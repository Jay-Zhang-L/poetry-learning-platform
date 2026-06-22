package com.shici.service;

import com.shici.domain.dto.recommendation.RecommendResponseVo;

/**
 * 典故推荐服务接口
 */
public interface StoryRecommendService {

    /**
     * 获取典故推荐列表
     *
     * @param userId        用户ID（可为null表示未登录）
     * @param currentStoryId 当前浏览的典故ID
     * @param dynasty       朝代筛选
     * @param size          返回数量
     * @return 推荐结果
     */
    RecommendResponseVo getRecommendations(Long userId, Long currentStoryId, String dynasty, int size);

    /**
     * 获取热门典故推荐
     *
     * @param size 返回数量
     * @return 热门典故列表
     */
    RecommendResponseVo getHotRecommendations(int size);

    /**
     * 记录用户行为
     *
     * @param userId   用户ID
     * @param storyId  典故ID
     * @param actionType 行为类型：like/fav/view
     */
    void recordUserAction(Long userId, Long storyId, String actionType);
}
