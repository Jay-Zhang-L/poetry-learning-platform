package com.shici.domain.dto.recommendation;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * 典故推荐结果VO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StoryRecommendVo {
    private Long id;
    private Long categoryId;
    private String title;
    private String summary;
    private String dynasty;
    private String keywords;
    private String coverImage;
    private Integer heat;
    private Double score;
    private String reason;
    private List<String> tags;
}
