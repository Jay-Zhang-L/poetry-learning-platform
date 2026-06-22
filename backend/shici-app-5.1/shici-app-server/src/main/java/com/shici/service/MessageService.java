package com.shici.service;

import com.shici.domain.Conversation;
import com.shici.domain.PrivateMessage;
import com.shici.domain.Notification;
import com.shici.mapper.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
public class MessageService {

    private final PrivateMessageMapper privateMessageMapper;
    private final ConversationMapper conversationMapper;
    private final SysUserMapper sysUserMapper;
    private final UserFollowMapper userFollowMapper;
    private final NotificationMapper notificationMapper;

    public MessageService(PrivateMessageMapper privateMessageMapper,
                          ConversationMapper conversationMapper,
                          SysUserMapper sysUserMapper,
                          UserFollowMapper userFollowMapper,
                          NotificationMapper notificationMapper) {
        this.privateMessageMapper = privateMessageMapper;
        this.conversationMapper = conversationMapper;
        this.sysUserMapper = sysUserMapper;
        this.userFollowMapper = userFollowMapper;
        this.notificationMapper = notificationMapper;
    }

    /**
     * 发送私信
     */
    @Transactional
    public PrivateMessage sendMessage(Long senderId, Long receiverId, String content) {
        // 验证用户存在
        if (Objects.equals(senderId, receiverId)) {
            throw new RuntimeException("不能给自己发送消息");
        }

        // 检查是否互相关注
        int isFollowing = userFollowMapper.isFollowed(senderId, receiverId);
        int isFollowed = userFollowMapper.isFollowed(receiverId, senderId);

        if (isFollowing == 0 || isFollowed == 0) {
            throw new RuntimeException("只能向互关的好友发送私信");
        }

        // 创建消息
        PrivateMessage message = new PrivateMessage();
        message.setSenderId(senderId);
        message.setReceiverId(receiverId);
        message.setContent(content);
        message.setMessageType("text");
        message.setIsRead(false);

        privateMessageMapper.insert(message);

        // 更新会话
        Conversation conversation = new Conversation();
        conversation.setUserId(receiverId); // 接收者的会话
        conversation.setTargetId(senderId);
        conversation.setLastMessageId(message.getId());
        conversation.setUnreadCount(1);
        conversationMapper.upsert(conversation);

        // 同时也为发送者更新会话
        Conversation senderConversation = new Conversation();
        senderConversation.setUserId(senderId);
        senderConversation.setTargetId(receiverId);
        senderConversation.setLastMessageId(message.getId());
        senderConversation.setUnreadCount(0);
        conversationMapper.upsert(senderConversation);

        // 创建私信通知
        try {
            var sender = sysUserMapper.findById(senderId);
            if (sender != null) {
                String senderName = sender.getNickname() != null ? sender.getNickname() : sender.getUsername();
                String notificationContent = senderName + "给您发来了一条私信";

                Notification notification = new Notification();
                notification.setUserId(receiverId);
                notification.setFromUserId(senderId);
                notification.setType("message");
                notification.setTargetType("private_message");
                notification.setTargetId(message.getId());
                notification.setContent(notificationContent);
                notification.setIsRead(false);

                notificationMapper.insert(notification);
            }
        } catch (Exception e) {
            // 通知创建失败不影响消息发送
            System.err.println("创建私信通知失败: " + e.getMessage());
        }

        return message;
    }

    /**
     * 获取与指定用户的聊天记录
     */
    public List<Map<String, Object>> getMessagesBetweenUsers(Long userId1, Long userId2, int page, int size) {
        int offset = Math.max(0, (page - 1) * size);
        List<PrivateMessage> messages = privateMessageMapper.getMessagesBetweenUsers(userId1, userId2, offset, size);

        List<Map<String, Object>> result = new ArrayList<>();
        for (PrivateMessage msg : messages) {
            Map<String, Object> msgMap = new HashMap<>();
            msgMap.put("id", msg.getId());
            msgMap.put("senderId", msg.getSenderId());
            msgMap.put("receiverId", msg.getReceiverId());
            msgMap.put("content", msg.getContent());
            msgMap.put("messageType", msg.getMessageType());
            msgMap.put("isRead", msg.getIsRead());
            msgMap.put("createdAt", msg.getCreatedAt());
            msgMap.put("isSelf", Objects.equals(msg.getSenderId(), userId1));
            result.add(msgMap);
        }

        // 反转列表，让最新消息在最后
        Collections.reverse(result);
        return result;
    }

    /**
     * 标记消息为已读
     */
    public void markAsRead(Long userId, Long senderId) {
        privateMessageMapper.markAsRead(userId, senderId);
        conversationMapper.clearUnreadCount(userId, senderId);
    }

    /**
     * 获取未读消息数
     */
    public int getUnreadCount(Long userId) {
        return privateMessageMapper.getUnreadCount(userId);
    }

    /**
     * 获取会话列表
     */
    public List<Map<String, Object>> getConversations(Long userId, int page, int size) {
        int offset = Math.max(0, (page - 1) * size);
        List<Conversation> conversations = conversationMapper.getConversationsByUserId(userId, offset, size);

        List<Map<String, Object>> result = new ArrayList<>();
        for (Conversation conv : conversations) {
            Map<String, Object> convMap = new HashMap<>();
            convMap.put("id", conv.getId());
            convMap.put("targetId", conv.getTargetId());
            convMap.put("unreadCount", conv.getUnreadCount() != null ? conv.getUnreadCount() : 0);
            convMap.put("updatedAt", conv.getUpdatedAt());

            // 获取目标用户信息
            try {
                var targetUser = sysUserMapper.findById(conv.getTargetId());
                if (targetUser != null) {
                    convMap.put("targetNickname", targetUser.getNickname() != null ? targetUser.getNickname() : targetUser.getUsername());
                    convMap.put("targetAvatarUrl", targetUser.getAvatarUrl());
                }
            } catch (Exception e) {
                // 用户可能已删除
                convMap.put("targetNickname", "未知用户");
                convMap.put("targetAvatarUrl", null);
            }

            // 获取最后一条消息内容
            if (conv.getLastMessageId() != null) {
                try {
                    PrivateMessage lastMsg = privateMessageMapper.findById(conv.getLastMessageId());
                    if (lastMsg != null) {
                        convMap.put("lastMessageContent", lastMsg.getContent());
                        convMap.put("lastMessageTime", lastMsg.getCreatedAt());
                    }
                } catch (Exception e) {
                    // 消息可能已删除
                }
            }

            result.add(convMap);
        }

        return result;
    }

    /**
     * 删除会话
     */
    @Transactional
    public void deleteConversation(Long userId, Long targetId) {
        conversationMapper.deleteConversation(userId, targetId);
    }

    /**
     * 标记所有消息为已读
     */
    @Transactional
    public void markAllAsRead(Long userId) {
        // 1. 更新该用户所有未读的私信为已读状态
        privateMessageMapper.markAllAsRead(userId);

        // 2. 清空该用户所有会话的未读计数
        conversationMapper.clearAllUnreadCount(userId);
    }
}