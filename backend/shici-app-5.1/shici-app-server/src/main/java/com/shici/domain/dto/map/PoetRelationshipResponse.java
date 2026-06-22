package com.shici.domain.dto.map;

import lombok.Data;
import java.util.List;

/**
 * 诗人关系网响应DTO
 */
@Data
public class PoetRelationshipResponse {
    private List<RelationNodeDto> nodes;
    private List<RelationEdgeDto> edges;
}
