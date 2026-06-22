package com.shici.controller;

import com.shici.domain.Feedback;
import com.shici.service.FeedbackService;
import com.shici.service.TokenService;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/feedback")
public class FeedbackController {

    private final FeedbackService feedbackService;
    private final TokenService tokenService;

    public FeedbackController(FeedbackService feedbackService, TokenService tokenService) {
        this.feedbackService = feedbackService;
        this.tokenService = tokenService;
    }

    private Long getUserId(String auth) {
        if (auth == null || !auth.startsWith("Bearer ")) {
            throw new RuntimeException("请先登录");
        }
        String token = auth.substring("Bearer ".length()).trim();
        Long userId = tokenService.getUserId(token);
        if (userId == null) {
            throw new RuntimeException("登录已失效");
        }
        return userId;
    }

    /**
     * 提交反馈
     */
    @PostMapping
    public Map<String, Object> submit(@RequestBody Map<String, String> body,
                              @RequestHeader(value = "Authorization", required = false) String auth) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = getUserId(auth);

            String content = body.get("content");
            if (content == null || content.trim().isEmpty()) {
                res.put("code", 1);
                res.put("msg", "反馈内容不能为空");
                res.put("data", null);
                return res;
            }

            Feedback feedback = new Feedback();
            feedback.setUserId(userId);
            feedback.setContent(content.trim());
            feedback.setContactInfo(body.get("contactInfo"));

            Feedback created = feedbackService.submit(feedback);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", created);
            return res;

        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    /**
     * 获取我的反馈列表
     */
    @GetMapping("/my")
    public Map<String, Object> listMy(@RequestParam(defaultValue = "1") int page,
                                         @RequestParam(defaultValue = "20") int size,
                                         @RequestHeader(value = "Authorization", required = false) String auth) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = getUserId(auth);

            List<Map<String, Object>> list = feedbackService.listMyFeedback(userId, page, size);

            Map<String, Object> result = new HashMap<>();
            result.put("list", list);

            // 如果列表不为空，从第一条记录获取 total
            if (!list.isEmpty()) {
                Object total = list.get(0).get("total");
                if (total != null) {
                    result.put("total", total);
                }
            }

            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", result);
            return res;

        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }
}