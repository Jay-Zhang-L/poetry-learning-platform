package com.shici.domain.map;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 诗词地点关联表
 */
@Data
public class PoemLocation {
    private Long id;
    private Long poemId;
    private Long locationId;
    private String referenceType;  // 创作地/描写地/提及地
    private String referenceDetail;
    private LocalDateTime createdAt;
}
