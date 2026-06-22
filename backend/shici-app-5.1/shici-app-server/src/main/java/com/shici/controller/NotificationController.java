package com.shici.controller;

import com.shici.common.R;
import com.shici.service.NotificationService;
import com.shici.service.TokenService;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    private final NotificationService notificationService;
    private final TokenService tokenService;

    public NotificationController(NotificationService notificationService, TokenService tokenService) {
        this.notificationService = notificationService;
        this.tokenService = tokenService;
    }

    private Long uid(String auth) {
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
    
    /**
     * 获取通知列表
     */
    @GetMapping
    public R<Map<String, Object>> getList(@RequestParam(defaultValue = "all") String type,
                     @RequestParam(defaultValue = "1") int page,
                     @RequestParam(defaultValue = "20") int pageSize,
                     @RequestHeader(value = "Authorization", required = false) String auth) {
        try {
            Long userId = uid(auth);
            Map<String, Object> result = notificationService.getList(userId, type, page, pageSize);
            return R.ok(result);
        } catch (Exception e) {
            return R.fail(e.getMessage());
        }
    }
    
    /**
     * 获取未读数量
     */
    @GetMapping("/unread-count")
    public R<Integer> getUnreadCount(@RequestHeader(value = "Authorization", required = false) String auth) {
        try {
            Long userId = uid(auth);
            int count = notificationService.getUnreadCount(userId);
            return R.ok(count);
        } catch (Exception e) {
            return R.ok(0);
        }
    }
    
    /**
     * 获取各类型未读数量
     */
    @GetMapping("/unread-count-by-type")
    public R<Map<String, Integer>> getUnreadCountByType(@RequestHeader(value = "Authorization", required = false) String auth) {
        try {
            Long userId = uid(auth);
            Map<String, Integer> counts = notificationService.getUnreadCountByType(userId);
            return R.ok(counts);
        } catch (Exception e) {
            return R.fail(e.getMessage());
        }
    }
    
    /**
     * 标记为已读
     */
    @PutMapping("/{id}/read")
    public R<Void> markAsRead(@PathVariable Long id,
                             @RequestHeader(value = "Authorization", required = false) String auth) {
        try {
            Long userId = uid(auth);
            boolean success = notificationService.markAsRead(id);
            if (!success) {
                return R.fail("操作失败");
            }
            return R.ok();
        } catch (Exception e) {
            return R.fail(e.getMessage());
        }
    }
    
    /**
     * 全部标记为已读
     */
    @PutMapping("/read-all")
    public R<Void> markAllAsRead(@RequestHeader(value = "Authorization", required = false) String auth) {
        try {
            Long userId = uid(auth);
            boolean success = notificationService.markAllAsRead(userId);
            if (!success) {
                return R.fail("操作失败");
            }
            return R.ok();
        } catch (Exception e) {
            return R.fail(e.getMessage());
        }
    }
}
