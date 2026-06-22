package com.shici.domain.dto.map;

import lombok.Data;

/**
 * 代表诗人DTO
 */
@Data
public class RepresentativePoetDto {
    private Long id;
    private String name;
    private String dynasty;
    private Integer relatedPoems;
    private String description;
}
