package com.shici.domain.map;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 诗人关系表
 */
@Data
public class PoetRelationship {
    private Long id;
    private Long poet1Id;
    private Long poet2Id;
    private String relationshipType;  // 师徒/好友/同僚/亲戚/仰慕/唱和
    private String description;
    private Integer strength;
    private LocalDateTime createdAt;
}
