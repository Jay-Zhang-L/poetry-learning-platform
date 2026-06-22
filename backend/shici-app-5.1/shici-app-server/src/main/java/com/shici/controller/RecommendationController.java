package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.dto.recommendation.RecommendResponseVo;
import com.shici.service.StoryRecommendService;
import com.shici.service.TokenService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;

/**
 * 典故智能推荐控制器
 */
@Slf4j
@RestController
@RequestMapping("/api/recommendation")
@RequiredArgsConstructor
@CrossOrigin
public class RecommendationController {

    private final StoryRecommendService storyRecommendService;
    private final TokenService tokenService;

    /**
     * 获取典故智能推荐列表
     */
    @GetMapping("/stories")
    public R<RecommendResponseVo> getStoryRecommendations(
            @RequestParam(required = false) Long storyId,
            @RequestParam(required = false) String dynasty,
            @RequestParam(defaultValue = "10") int size,
            @RequestHeader(value = "Authorization", required = false) String token) {

        try {
            Long userId = extractUserIdFromToken(token);
            int finalSize = Math.min(Math.max(size, 1), 20);

            log.info("获取典故推荐: userId={}, storyId={}, dynasty={}, size={}", 
                     userId, storyId, dynasty, finalSize);

            RecommendResponseVo response = storyRecommendService.getRecommendations(
                    userId, storyId, dynasty, finalSize);

            return R.ok(response);

        } catch (Exception e) {
            log.error("获取典故推荐失败", e);
            return R.fail("获取推荐失败：" + e.getMessage());
        }
    }

    /**
     * 获取热门典故推荐
     */
    @GetMapping("/hot")
    public R<RecommendResponseVo> getHotStories(
            @RequestParam(defaultValue = "10") int size) {

        try {
            int finalSize = Math.min(Math.max(size, 1), 20);
            
            RecommendResponseVo response = storyRecommendService.getHotRecommendations(finalSize);
            
            return R.ok(response);

        } catch (Exception e) {
            log.error("获取热门推荐失败", e);
            return R.fail("获取热门推荐失败：" + e.getMessage());
        }
    }

    /**
     * 记录用户行为
     */
    @PostMapping("/action")
    public R<Void> recordUserAction(@RequestBody UserActionRequest body,
                                     @RequestHeader(value = "Authorization", required = false) String token) {

        try {
            if (body.getStoryId() == null) {
                return R.fail("故事ID不能为空");
            }
            if (body.getActionType() == null || body.getActionType().isEmpty()) {
                return R.fail("行为类型不能为空");
            }

            String actionType = body.getActionType().toLowerCase();
            if (!Arrays.asList("view", "like", "fav").contains(actionType)) {
                return R.fail("无效的行为类型，支持: view/like/fav");
            }

            Long userId = extractUserIdFromToken(token);
            if (userId == null) {
                return R.fail("请先登录后再记录行为");
            }

            storyRecommendService.recordUserAction(userId, body.getStoryId(), actionType);

            log.info("用户行为记录成功: userId={}, storyId={}, actionType={}", 
                     userId, body.getStoryId(), actionType);

            return R.ok();

        } catch (Exception e) {
            log.error("记录用户行为失败", e);
            return R.fail("记录失败：" + e.getMessage());
        }
    }

    /**
     * 从Token中提取用户ID
     * 使用项目现有的 TokenService 解析
     */
    private Long extractUserIdFromToken(String token) {
        if (token == null || !token.startsWith("Bearer ")) {
            return null;
        }

        try {
            String actualToken = token.substring(7).trim();
            return tokenService.getUserId(actualToken);
        } catch (Exception e) {
            log.warn("Token解析失败: {}", e.getMessage());
            return null;
        }
    }

    @lombok.Data
    public static class UserActionRequest {
        private Long storyId;
        private String actionType;
    }
}
