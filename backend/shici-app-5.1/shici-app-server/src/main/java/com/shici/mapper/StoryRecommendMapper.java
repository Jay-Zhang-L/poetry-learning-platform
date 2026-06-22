package com.shici.mapper;

import com.shici.domain.dto.recommendation.StoryRecommendVo;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 典故推荐Mapper
 */
public interface StoryRecommendMapper {

    /**
     * 获取所有启用的典故（用于内容推荐计算）
     */
    List<StoryRecommendVo> selectAllActiveStories();

    /**
     * 根据ID获取典故详情
     */
    StoryRecommendVo selectStoryById(@Param("id") Long id);

    /**
     * 获取热门典故（按热度排序）
     */
    List<StoryRecommendVo> selectHotStories(@Param("limit") int limit,
                                             @Param("excludeIds") List<Long> excludeIds);

    /**
     * 获取同分类的典故
     */
    List<StoryRecommendVo> selectStoriesByCategory(@Param("categoryId") Long categoryId,
                                                    @Param("excludeId") Long excludeId,
                                                    @Param("limit") int limit);

    /**
     * 获取同朝代的典故
     */
    List<StoryRecommendVo> selectStoriesByDynasty(@Param("dynasty") String dynasty,
                                                   @Param("excludeId") Long excludeId,
                                                   @Param("limit") int limit);

    /**
     * 根据关键词搜索相似典故
     */
    List<StoryRecommendVo> selectSimilarByKeywords(@Param("keywords") String keywords,
                                                    @Param("excludeId") Long excludeId,
                                                    @Param("limit") int limit);

    /**
     * 获取用户行为过的典故ID列表
     */
    List<Long> selectUserInteractedStoryIds(@Param("userId") Long userId);

    /**
     * 获取用户喜欢的典故（用于协同过滤）
     */
    List<Map<String, Object>> selectUserLikedStories(@Param("userId") Long userId,
                                                      @Param("limit") int limit);

    /**
     * 获取喜欢某典故的其他用户还喜欢哪些典故（Item-CF）
     */
    List<Map<String, Object>> selectCoOccurrenceStories(@Param("storyId") Long storyId,
                                                          @Param("userId") Long userId,
                                                          @Param("limit") int limit);

    /**
     * 统计典故的互动数量（用于热度计算）
     */
    Map<String, Object> selectStoryStats(@Param("storyId") Long storyId);

    /**
     * 插入用户行为记录
     */
    void insertUserAction(@Param("userId") Long userId,
                          @Param("storyId") Long storyId,
                          @Param("actionType") String actionType);
}
