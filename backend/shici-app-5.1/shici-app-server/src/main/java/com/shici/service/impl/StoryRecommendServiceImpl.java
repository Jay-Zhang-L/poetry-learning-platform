package com.shici.service.impl;

import com.shici.domain.dto.recommendation.RecommendResponseVo;
import com.shici.domain.dto.recommendation.StoryRecommendVo;
import com.shici.mapper.StoryRecommendMapper;
import com.shici.service.StoryRecommendService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 典故推荐服务实现 - 混合推荐引擎
 * 
 * 推荐策略：
 * 1. 基于内容推荐（40%）：同分类、同朝代、关键词相似
 * 2. Item-CF协同过滤（40%）：喜欢该典故的用户还喜欢什么
 * 3. 热门推荐（20%）：热度兜底
 * 
 * 冷启动处理：
 * - story_user_action表无数据时，自动降级为内容推荐+热门推荐
 * - 随着用户行为积累，协同过滤权重逐步提升
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class StoryRecommendServiceImpl implements StoryRecommendService {

    private final StoryRecommendMapper storyRecommendMapper;

    @Value("${app.file-root:}")
    private String fileRoot;

    @Override
    public RecommendResponseVo getRecommendations(Long userId, Long currentStoryId, String dynasty, int size) {
        long startTime = System.currentTimeMillis();

        int finalSize = Math.min(Math.max(size, 1), 20);

        StoryRecommendVo currentStory = null;
        if (currentStoryId != null) {
            currentStory = storyRecommendMapper.selectStoryById(currentStoryId);
        }

        Set<Long> excludeIds = new HashSet<>();
        if (userId != null) {
            List<Long> interactedIds = storyRecommendMapper.selectUserInteractedStoryIds(userId);
            if (interactedIds != null) {
                excludeIds.addAll(interactedIds);
            }
        }
        if (currentStoryId != null) {
            excludeIds.add(currentStoryId);
        }

        // ========== 1. 基于内容推荐（不依赖行为数据，始终可用） ==========
        List<StoryRecommendVo> contentBasedRecs = getContentBasedRecommendations(
                currentStory, dynasty, new ArrayList<>(excludeIds), finalSize);

        // ========== 2. Item-CF协同过滤推荐（依赖行为数据，可能为空） ==========
        List<StoryRecommendVo> cfRecs = Collections.emptyList();
        if (currentStoryId != null && userId != null) {
            try {
                cfRecs = getItemCFRecommendations(currentStoryId, userId, new ArrayList<>(excludeIds), finalSize);
            } catch (Exception e) {
                log.warn("协同过滤推荐异常，降级跳过: {}", e.getMessage());
                cfRecs = Collections.emptyList();
            }
        }

        // ========== 3. 热门推荐（兜底，始终可用） ==========
        List<StoryRecommendVo> hotRecs = Collections.emptyList();
        try {
            hotRecs = storyRecommendMapper.selectHotStories(finalSize, new ArrayList<>(excludeIds));
            if (hotRecs == null) {
                hotRecs = Collections.emptyList();
            }
        } catch (Exception e) {
            log.warn("热门推荐查询异常: {}", e.getMessage());
        }

        // ========== 4. 混合融合与重排序 ==========
        List<StoryRecommendVo> finalRecommendations = mergeAndRerank(
                contentBasedRecs, cfRecs, hotRecs, currentStory, userId, finalSize);

        // 转换图片路径
        finalRecommendations.forEach(this::convertCoverImageUrl);

        String recommendId = "rec_" + Instant.now().toEpochMilli() + "_" + 
                             (currentStoryId != null ? currentStoryId : "0");
        
        String triggerType = determineTriggerType(contentBasedRecs, cfRecs, hotRecs);

        RecommendResponseVo response = RecommendResponseVo.builder()
                .recommendId(recommendId)
                .triggerType(triggerType)
                .stories(finalRecommendations)
                .meta(RecommendResponseVo.RecommendMetaVo.builder()
                        .algorithmVersion("v1.0")
                        .latencyMs((int) (System.currentTimeMillis() - startTime))
                        .cacheHit(false)
                        .build())
                .build();

        log.info("推荐完成: userId={}, currentStoryId={}, resultSize={}, triggerType={}, latency={}ms",
                userId, currentStoryId, finalRecommendations.size(), triggerType,
                System.currentTimeMillis() - startTime);

        return response;
    }

    /**
     * 基于内容的推荐（不依赖用户行为数据，始终可用）
     */
    private List<StoryRecommendVo> getContentBasedRecommendations(
            StoryRecommendVo currentStory, String dynasty, List<Long> excludeIds, int limit) {
        
        List<StoryRecommendVo> results = new ArrayList<>();

        if (currentStory != null) {
            if (currentStory.getCategoryId() != null) {
                List<StoryRecommendVo> categoryRecs = storyRecommendMapper.selectStoriesByCategory(
                        currentStory.getCategoryId(), currentStory.getId(), limit / 2 + 1);
                if (categoryRecs != null) {
                    categoryRecs.forEach(rec -> {
                        rec.setScore(0.9);
                        rec.setReason("与当前典故属于同一分类");
                        rec.setTags(Arrays.asList("同类", currentStory.getDynasty()));
                    });
                    results.addAll(categoryRecs);
                }
            }

            if (currentStory.getDynasty() != null) {
                List<StoryRecommendVo> dynastyRecs = storyRecommendMapper.selectStoriesByDynasty(
                        currentStory.getDynasty(), currentStory.getId(), limit / 2 + 1);
                if (dynastyRecs != null) {
                    dynastyRecs.forEach(rec -> {
                        rec.setScore(0.8);
                        rec.setReason("与当前典故同属" + rec.getDynasty() + "时期");
                        rec.setTags(Arrays.asList("同朝代"));
                    });
                    results.addAll(dynastyRecs);
                }
            }

            if (currentStory.getKeywords() != null && !currentStory.getKeywords().isEmpty()) {
                String[] keywordArr = currentStory.getKeywords().split("[,，、]");
                if (keywordArr.length > 0) {
                    String firstKeyword = keywordArr[0].trim();
                    if (!firstKeyword.isEmpty()) {
                        List<StoryRecommendVo> keywordRecs = storyRecommendMapper.selectSimilarByKeywords(
                                firstKeyword, currentStory.getId(), limit / 2);
                        if (keywordRecs != null) {
                            keywordRecs.forEach(rec -> {
                                rec.setScore(0.75);
                                rec.setReason("关键词相似");
                                rec.setTags(Arrays.asList("相关主题"));
                            });
                            results.addAll(keywordRecs);
                        }
                    }
                }
            }
        } else if (dynasty != null) {
            List<StoryRecommendVo> dynastyRecs = storyRecommendMapper.selectStoriesByDynasty(
                    dynasty, null, limit);
            if (dynastyRecs != null) {
                dynastyRecs.forEach(rec -> {
                    rec.setScore(0.7);
                    rec.setReason(dynasty + "时期热门典故");
                    rec.setTags(Arrays.asList(dynasty));
                });
                results.addAll(dynastyRecs);
            }
        }

        return results.stream()
                .filter(rec -> rec != null && !excludeIds.contains(rec.getId()))
                .limit(limit)
                .collect(Collectors.toList());
    }

    /**
     * Item-CF协同过滤推荐（依赖story_user_action表数据）
     * 当表无数据时返回空列表，不影响整体推荐
     */
    private List<StoryRecommendVo> getItemCFRecommendations(
            Long currentStoryId, Long userId, List<Long> excludeIds, int limit) {
        
        List<Map<String, Object>> coOccurrenceList = storyRecommendMapper.selectCoOccurrenceStories(
                currentStoryId, userId, limit * 2);

        if (coOccurrenceList == null || coOccurrenceList.isEmpty()) {
            log.debug("协同过滤无共现数据，跳过Item-CF推荐");
            return Collections.emptyList();
        }

        return coOccurrenceList.stream()
                .map(map -> {
                    try {
                        Long storyId = ((Number) map.get("storyId")).longValue();
                        Double weight = ((Number) map.get("weight")).doubleValue();
                        
                        StoryRecommendVo story = storyRecommendMapper.selectStoryById(storyId);
                        if (story == null || excludeIds.contains(storyId)) {
                            return null;
                        }

                        double normalizedScore = Math.min(weight / 10.0, 1.0);
                        story.setScore(normalizedScore);
                        story.setReason("同样喜欢此典故的用户还喜欢");
                        story.setTags(Arrays.asList("猜你喜欢"));

                        return story;
                    } catch (Exception e) {
                        log.warn("协同过滤结果解析异常: {}", e.getMessage());
                        return null;
                    }
                })
                .filter(Objects::nonNull)
                .sorted((a, b) -> Double.compare(b.getScore(), a.getScore()))
                .limit(limit)
                .collect(Collectors.toList());
    }

    /**
     * 混合融合与重排序
     * 根据各路推荐结果是否为空，动态调整权重
     */
    private List<StoryRecommendVo> mergeAndRerank(
            List<StoryRecommendVo> contentBasedRecs,
            List<StoryRecommendVo> cfRecs,
            List<StoryRecommendVo> hotRecs,
            StoryRecommendVo currentStory,
            Long userId,
            int finalSize) {

        Map<Long, StoryRecommendVo> mergedMap = new LinkedHashMap<>();

        boolean hasCfData = !cfRecs.isEmpty();
        boolean hasContentData = !contentBasedRecs.isEmpty();

        double contentWeight, cfWeight, hotWeight;

        if (!hasCfData) {
            // 无协同过滤数据（冷启动）：内容推荐和热门推荐分担
            contentWeight = 0.55;
            cfWeight = 0.0;
            hotWeight = 0.45;
        } else if (userId == null) {
            contentWeight = 0.45;
            cfWeight = 0.0;
            hotWeight = 0.55;
        } else if (currentStory != null) {
            contentWeight = 0.40;
            cfWeight = 0.40;
            hotWeight = 0.20;
        } else {
            contentWeight = 0.30;
            cfWeight = 0.30;
            hotWeight = 0.40;
        }

        for (StoryRecommendVo rec : contentBasedRecs) {
            if (!mergedMap.containsKey(rec.getId())) {
                double finalScore = rec.getScore() * contentWeight;
                
                if (currentStory != null && currentStory.getDynasty() != null &&
                    currentStory.getDynasty().equals(rec.getDynasty())) {
                    finalScore *= 1.15;
                }
                
                rec.setScore(finalScore);
                mergedMap.put(rec.getId(), rec);
            }
        }

        for (StoryRecommendVo rec : cfRecs) {
            if (mergedMap.containsKey(rec.getId())) {
                StoryRecommendVo existing = mergedMap.get(rec.getId());
                existing.setScore(existing.getScore() + rec.getScore() * cfWeight);
            } else {
                double finalScore = rec.getScore() * cfWeight;
                rec.setScore(finalScore);
                mergedMap.put(rec.getId(), rec);
            }
        }

        for (StoryRecommendVo rec : hotRecs) {
            if (!mergedMap.containsKey(rec.getId())) {
                double baseScore = 0.5;
                if (rec.getHeat() != null && rec.getHeat() > 0) {
                    baseScore = Math.min(0.5 + rec.getHeat() / 1000.0, 0.95);
                }
                rec.setScore(baseScore * hotWeight);
                rec.setReason("热门典故");
                rec.setTags(Arrays.asList("热门"));
                mergedMap.put(rec.getId(), rec);
            }
        }

        return mergedMap.values().stream()
                .sorted((a, b) -> Double.compare(b.getScore(), a.getScore()))
                .limit(finalSize)
                .collect(Collectors.toList());
    }

    /**
     * 将数据库中的图片路径转换为浏览器可访问的URL
     */
    private void convertCoverImageUrl(StoryRecommendVo story) {
        if (story == null) return;

        String originalPath = story.getCoverImage();
        
        if (!StringUtils.hasText(originalPath)) {
            story.setCoverImage("");
            return;
        }

        String normalizedPath = originalPath.replace("\\", "/");

        if (normalizedPath.startsWith("/files/") || normalizedPath.startsWith("/uploads/") || 
            normalizedPath.startsWith("/knowledge/") || normalizedPath.startsWith("/cover/") ||
            normalizedPath.startsWith("/avatar/") || normalizedPath.startsWith("/game/") ||
            normalizedPath.startsWith("http://") || normalizedPath.startsWith("https://")) {
            story.setCoverImage(normalizedPath);
            return;
        }

        if (StringUtils.hasText(fileRoot)) {
            String normalizedFileRoot = fileRoot.replace("\\", "/");
            if (normalizedPath.toLowerCase().startsWith(normalizedFileRoot.toLowerCase())) {
                String relativePath = normalizedPath.substring(normalizedFileRoot.length());
                if (!relativePath.startsWith("/")) {
                    relativePath = "/" + relativePath;
                }
                story.setCoverImage("/files" + relativePath);
                return;
            }
        }

        if (!normalizedPath.startsWith("/")) {
            story.setCoverImage("/files/" + normalizedPath);
            return;
        }

        story.setCoverImage(normalizedPath);
    }

    private String determineTriggerType(List<StoryRecommendVo> contentBasedRecs,
                                         List<StoryRecommendVo> cfRecs,
                                         List<StoryRecommendVo> hotRecs) {
        if (!contentBasedRecs.isEmpty()) return "content_based";
        if (!cfRecs.isEmpty()) return "collaborative_filtering";
        return "popular";
    }

    @Override
    public RecommendResponseVo getHotRecommendations(int size) {
        long startTime = System.currentTimeMillis();
        int finalSize = Math.min(Math.max(size, 1), 20);

        List<StoryRecommendVo> hotStories = storyRecommendMapper.selectHotStories(finalSize, null);
        if (hotStories == null) {
            hotStories = Collections.emptyList();
        }

        hotStories.forEach(this::convertCoverImageUrl);
        
        hotStories.forEach(rec -> {
            rec.setScore(1.0);
            rec.setReason("热门推荐");
            rec.setTags(Arrays.asList("热门"));
        });

        return RecommendResponseVo.builder()
                .recommendId("hot_" + Instant.now().toEpochMilli())
                .triggerType("popular")
                .stories(hotStories)
                .meta(RecommendResponseVo.RecommendMetaVo.builder()
                        .algorithmVersion("v1.0")
                        .latencyMs((int) (System.currentTimeMillis() - startTime))
                        .cacheHit(false)
                        .build())
                .build();
    }

    /**
     * 记录用户行为 - 真正写入数据库
     * 前端调用 POST /api/recommendation/action 时触发
     * 数据写入 story_user_action 表，供协同过滤算法使用
     */
    @Override
    public void recordUserAction(Long userId, Long storyId, String actionType) {
        if (userId == null || storyId == null || actionType == null) {
            log.warn("记录用户行为失败：参数不完整 userId={}, storyId={}, actionType={}", 
                     userId, storyId, actionType);
            return;
        }

        try {
            storyRecommendMapper.insertUserAction(userId, storyId, actionType);
            log.info("用户行为记录成功: userId={}, storyId={}, actionType={}", 
                     userId, storyId, actionType);
        } catch (Exception e) {
            log.error("记录用户行为异常: userId={}, storyId={}, actionType={}, error={}", 
                      userId, storyId, actionType, e.getMessage());
        }
    }
}
