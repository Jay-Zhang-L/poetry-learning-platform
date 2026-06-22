package com.shici.domain.dto.map;

import lombok.Data;
import java.util.List;

/**
 * 典故详情DTO（包含相关诗词）
 */
@Data
public class AllusionDetailDto {
    private Long id;
    private String title;
    private String content;
    private String dynasty;
    private List<RelatedPoemDto> relatedPoems;
}
