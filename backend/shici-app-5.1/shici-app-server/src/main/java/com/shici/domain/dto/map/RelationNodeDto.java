package com.shici.domain.dto.map;

import lombok.Data;

/**
 * 关系网节点DTO
 */
@Data
public class RelationNodeDto {
    private Long id;
    private String name;
    private Integer group;
    private String dynasty;
    private String imageUrl;
}
