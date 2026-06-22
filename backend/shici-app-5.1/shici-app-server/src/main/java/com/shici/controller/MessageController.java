package com.shici.controller;

import com.shici.service.MessageService;
import com.shici.service.TokenService;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/messages")
public class MessageController {

    private final MessageService messageService;
    private final TokenService tokenService;

    public MessageController(MessageService messageService, TokenService tokenService) {
        this.messageService = messageService;
        this.tokenService = tokenService;
    }

    private Long getUserId(String auth) {
        if (auth == null || !auth.startsWith("Bearer ")) {
            throw new RuntimeException("未登录");
        }
        String token = auth.substring("Bearer ".length()).trim();
        Long userId = tokenService.getUserId(token);
        if (userId == null) {
            throw new RuntimeException("登录已失效");
        }
        return userId;
    }

    private Map<String, Object> success(Object data) {
        Map<String, Object> res = new HashMap<>();
        res.put("code", 0);
        res.put("msg", "ok");
        res.put("data", data);
        return res;
    }

    private Map<String, Object> error(String msg) {
        Map<String, Object> res = new HashMap<>();
        res.put("code", 1);
        res.put("msg", msg);
        res.put("data", null);
        return res;
    }

    /**
     * 获取与指定用户的聊天记录
     */
    @GetMapping("/{targetUserId}")
    public Map<String, Object> getMessages(
            @RequestHeader(value = "Authorization", required = false) String auth,
            @PathVariable Long targetUserId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "50") int size) {
        try {
            Long userId = getUserId(auth);
            var messages = messageService.getMessagesBetweenUsers(userId, targetUserId, page, size);
            return success(messages);
        } catch (Exception e) {
            return error(e.getMessage());
        }
    }

    /**
     * 发送消息
     */
    @PostMapping("/{targetUserId}")
    public Map<String, Object> sendMessage(
            @RequestHeader(value = "Authorization", required = false) String auth,
            @PathVariable Long targetUserId,
            @RequestBody Map<String, String> body) {
        try {
            Long userId = getUserId(auth);
            String content = body.get("content");
            if (content == null || content.trim().isEmpty()) {
                return error("消息内容不能为空");
            }
            if (content.length() > 500) {
                return error("消息内容不能超过500字");
            }

            var message = messageService.sendMessage(userId, targetUserId, content.trim());
            return success(message);
        } catch (Exception e) {
            return error(e.getMessage());
        }
    }

    /**
     * 标记消息为已读
     */
    @PutMapping("/{targetUserId}/read")
    public Map<String, Object> markAsRead(
            @RequestHeader(value = "Authorization", required = false) String auth,
            @PathVariable Long targetUserId) {
        try {
            Long userId = getUserId(auth);
            messageService.markAsRead(userId, targetUserId);
            return success(null);
        } catch (Exception e) {
            return error(e.getMessage());
        }
    }

    /**
     * 获取会话列表
     */
    @GetMapping("/conversations")
    public Map<String, Object> getConversations(
            @RequestHeader(value = "Authorization", required = false) String auth,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int size) {
        try {
            Long userId = getUserId(auth);
            var conversations = messageService.getConversations(userId, page, size);
            return success(conversations);
        } catch (Exception e) {
            return error(e.getMessage());
        }
    }

    /**
     * 获取未读消息数
     */
    @GetMapping("/unread-count")
    public Map<String, Object> getUnreadCount(
            @RequestHeader(value = "Authorization", required = false) String auth) {
        try {
            Long userId = getUserId(auth);
            int count = messageService.getUnreadCount(userId);
            Map<String, Object> data = new HashMap<>();
            data.put("count", count);
            return success(data);
        } catch (Exception e) {
            return error(e.getMessage());
        }
    }

    /**
     * 删除会话
     */
    @DeleteMapping("/conversations/{targetUserId}")
    public Map<String, Object> deleteConversation(
            @RequestHeader(value = "Authorization", required = false) String auth,
            @PathVariable Long targetUserId) {
        try {
            Long userId = getUserId(auth);
            messageService.deleteConversation(userId, targetUserId);
            return success(null);
        } catch (Exception e) {
            return error(e.getMessage());
        }
    }

    /**
     * 标记所有消息为已读
     */
    @PutMapping("/read-all")
    public Map<String, Object> markAllAsRead(
            @RequestHeader(value = "Authorization", required = false) String auth) {
        try {
            Long userId = getUserId(auth);
            messageService.markAllAsRead(userId);
            return success(null);
        } catch (Exception e) {
            return error(e.getMessage());
        }
    }
}