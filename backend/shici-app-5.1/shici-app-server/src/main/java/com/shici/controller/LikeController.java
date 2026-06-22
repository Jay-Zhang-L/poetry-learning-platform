package com.shici.controller;

import com.shici.service.LikeService;
import com.shici.service.TokenService;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/likes")
public class LikeController {

    private final LikeService likeService;
    private final TokenService tokenService;

    public LikeController(LikeService likeService, TokenService tokenService) {
        this.likeService = likeService;
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
     * 获取我获得的点赞记录
     */
    @GetMapping("/received")
    public Map<String, Object> getReceivedLikes(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestHeader(value = "Authorization", required = false) String auth) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = getUserId(auth);

            List<Map<String, Object>> likes = likeService.getReceivedLikes(userId, page, size);
            int total = likeService.countReceivedLikes(userId);

            Map<String, Object> result = new HashMap<>();
            result.put("list", likes);
            result.put("total", total);

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

    /**
     * 获取我点赞的记录
     */
    @GetMapping("/given")
    public Map<String, Object> getGivenLikes(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestHeader(value = "Authorization", required = false) String auth) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = getUserId(auth);

            List<Map<String, Object>> likes = likeService.getGivenLikes(userId, page, size);
            int total = likeService.countGivenLikes(userId);

            Map<String, Object> result = new HashMap<>();
            result.put("list", likes);
            result.put("total", total);

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
