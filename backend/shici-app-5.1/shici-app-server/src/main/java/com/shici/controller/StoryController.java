package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.entity.Story;
import com.shici.domain.entity.StoryCategory;
import com.shici.domain.vo.StoryDetailVO;
import com.shici.service.StoryRecommendService;
import com.shici.service.StoryService;
import com.shici.service.TokenService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/story")
@RequiredArgsConstructor
public class StoryController {

    private final StoryService storyService;
    private final StoryRecommendService storyRecommendService;
    private final TokenService tokenService;

    @GetMapping("/categories")
    public R<List<StoryCategory>> getCategories() {
        return R.ok(storyService.getCategories());
    }

    @GetMapping("/list")
    public R<List<Story>> getStoryList(
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String keyword
    ) {
        return R.ok(storyService.getStoryList(categoryId, keyword));
    }

    /**
     * 获取典故详情
     * 同时自动记录用户浏览行为到 story_user_action 表
     */
    @GetMapping("/{id}")
    public R<StoryDetailVO> getStoryDetail(
            @PathVariable Long id,
            @RequestHeader(value = "Authorization", required = false) String token) {

        StoryDetailVO detail = storyService.getStoryDetail(id);

        // 自动记录浏览行为（异步，不影响接口响应速度）
        Long userId = extractUserIdFromToken(token);
        if (userId != null) {
            try {
                storyRecommendService.recordUserAction(userId, id, "view");
            } catch (Exception e) {
                // 行为记录失败不影响主流程
            }
        }

        return R.ok(detail);
    }

    private Long extractUserIdFromToken(String token) {
        if (token == null || !token.startsWith("Bearer ")) {
            return null;
        }
        try {
            String actualToken = token.substring(7).trim();
            return tokenService.getUserId(actualToken);
        } catch (Exception e) {
            return null;
        }
    }
}
