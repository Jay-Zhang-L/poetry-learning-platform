package com.shici.domain.dto.map;

import lombok.Data;

/**
 * 关系网边DTO
 */
@Data
public class RelationEdgeDto {
    private Long source;
    private Long target;
    private String type;
    private Integer strength;
    private String description;
}
