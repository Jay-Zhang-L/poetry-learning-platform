package com.shici.controller;

import com.shici.service.StatsService;
import com.shici.service.TokenService;
import com.shici.domain.DashboardVO;
import com.shici.domain.TimelineVO;
import com.shici.domain.WordCloudVO;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/stats")
public class StatsController {

    private final StatsService statsService;
    private final TokenService tokenService;

    public StatsController(StatsService statsService, TokenService tokenService) {
        this.statsService = statsService;
        this.tokenService = tokenService;
    }

    /**
     * 从Authorization header中获取用户ID
     */
    private Long getUserIdFromAuth(String auth) {
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
     * 获取创作时光轴数据
     */
    @GetMapping("/timeline")
    public Map<String, Object> getTimeline(
            @RequestParam(defaultValue = "month") String mode,
            @RequestHeader(value = "Authorization", required = false) String auth) {
        Map<String, Object> res = new java.util.HashMap<>();
        try {
            Long userId = getUserIdFromAuth(auth);
            List<TimelineVO> timeline = statsService.getUserTimeline(userId, mode);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", timeline);
            return res;
        } catch (Exception e) {
            e.printStackTrace();
            res.put("code", 1);
            res.put("msg", e.getMessage());  // 返回具体错误信息
            res.put("data", null);
            return res;
        }
    }

    /**
     * 获取创作数据看板
     */
    @GetMapping("/dashboard")
    public Map<String, Object> getDashboard(@RequestHeader(value = "Authorization", required = false) String auth) {
        Map<String, Object> res = new java.util.HashMap<>();
        try {
            Long userId = getUserIdFromAuth(auth);
            DashboardVO dashboard = statsService.getUserDashboard(userId);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", dashboard);
            return res;
        } catch (Exception e) {
            e.printStackTrace();
            res.put("code", 1);
            res.put("msg", e.getMessage());  // 返回具体错误信息
            res.put("data", null);
            return res;
        }
    }

    /**
     * 获取主题词云数据
     */
    @GetMapping("/wordcloud")
    public Map<String, Object> getWordCloud(@RequestHeader(value = "Authorization", required = false) String auth) {
        Map<String, Object> res = new java.util.HashMap<>();
        try {
            Long userId = getUserIdFromAuth(auth);
            List<WordCloudVO> wordCloud = statsService.getWordCloudData(userId);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", wordCloud);
            return res;
        } catch (Exception e) {
            e.printStackTrace();
            res.put("code", 1);
            res.put("msg", e.getMessage());  // 返回具体错误信息
            res.put("data", null);
            return res;
        }
    }
}