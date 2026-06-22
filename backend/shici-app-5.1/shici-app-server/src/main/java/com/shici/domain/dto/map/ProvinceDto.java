package com.shici.domain.dto.map;

import lombok.Data;

/**
 * 省份信息DTO（用于地图概览）
 */
@Data
public class ProvinceDto {
    private Long id;
    private String name;
    private String historicalName;
    private Integer poemCount;
    private Integer poetCount;
}
