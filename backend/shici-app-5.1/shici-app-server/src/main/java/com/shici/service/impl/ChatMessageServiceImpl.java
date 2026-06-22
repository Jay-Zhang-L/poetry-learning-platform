package com.shici.service.impl;

import com.shici.domain.ChatMessage;
import com.shici.domain.SysUser;
import com.shici.mapper.ChatMessageMapper;
import com.shici.service.ChatMessageService;
import com.shici.service.UserService;
import com.shici.domain.vo.ChatMessageVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.time.Duration;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ChatMessageServiceImpl implements ChatMessageService {

    @Autowired
    private ChatMessageMapper chatMessageMapper;

    @Autowired
    private UserService userService;

    @Override
    public ChatMessageVO sendMessage(Long userId, String nickname, String avatar, String content) {
        ChatMessage message = new ChatMessage();
        message.setUserId(userId);
        message.setNickname(nickname);

        // 从数据库获取用户头像（确保每次都获取最新的）
        String userAvatar = "";
        try {
            SysUser user = userService.me(userId);
            if (user != null && user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) {
                userAvatar = user.getAvatarUrl();
                System.out.println("获取到用户头像: " + userAvatar);
            }
        } catch (Exception e) {
            System.out.println("获取用户头像失败: " + e.getMessage());
        }
        message.setAvatar(userAvatar);

        message.setContent(content);
        message.setType(1);
        message.setStatus(1);
        message.setCreateTime(LocalDateTime.now());

        chatMessageMapper.insert(message);

        return convertToVO(message);
    }

    @Override
    public long getTotalCount() {
        return chatMessageMapper.getTotalCount();
    }

    @Override
    public List<ChatMessageVO> getLatestMessages() {
        List<ChatMessage> messages = chatMessageMapper.getLatestMessages();
        return messages.stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());
    }

    @Override
    public List<ChatMessageVO> getHistoryMessages(Integer page, Integer size) {
        int offset = (page - 1) * size;
        List<ChatMessage> messages = chatMessageMapper.getHistoryMessages(offset, size);
        return messages.stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());
    }

    private ChatMessageVO convertToVO(ChatMessage message) {
        ChatMessageVO vo = new ChatMessageVO();
        BeanUtils.copyProperties(message, vo);
        vo.setTimeAgo(getTimeAgo(message.getCreateTime()));
        return vo;
    }

    private String getTimeAgo(LocalDateTime time) {
        if (time == null) {
            return "";
        }

        LocalDateTime now = LocalDateTime.now();
        Duration duration = Duration.between(time, now);

        long seconds = duration.getSeconds();
        long minutes = seconds / 60;
        long hours = minutes / 60;
        long days = hours / 24;

        if (seconds < 60) {
            return "刚刚";
        } else if (minutes < 60) {
            return minutes + "分钟前";
        } else if (hours < 24) {
            return hours + "小时前";
        } else if (days < 30) {
            return days + "天前";
        } else {
            return time.getMonthValue() + "月" + time.getDayOfMonth() + "日";
        }
    }
}