package com.shici.domain.dto.map;

import lombok.Data;

/**
 * 诗人基本信息DTO
 */
@Data
public class PoetInfoDto {
    private Long id;
    private String name;
    private String dynasty;
    private Integer birthYear;
    private Integer deathYear;
}
