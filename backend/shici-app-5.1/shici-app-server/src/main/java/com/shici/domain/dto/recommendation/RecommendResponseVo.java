package com.shici.domain.dto.recommendation;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * 推荐响应VO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecommendResponseVo {
    private String recommendId;
    private String triggerType;
    private List<StoryRecommendVo> stories;
    private RecommendMetaVo meta;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RecommendMetaVo {
        private String algorithmVersion;
        private Integer latencyMs;
        private Boolean cacheHit;
    }
}
