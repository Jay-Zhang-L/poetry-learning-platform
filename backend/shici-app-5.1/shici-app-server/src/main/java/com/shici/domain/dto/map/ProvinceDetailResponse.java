package com.shici.domain.dto.map;

import lombok.Data;

/**
 * 省份详情响应DTO
 */
@Data
public class ProvinceDetailResponse {
    private Long id;
    private String name;
    private String historicalName;
    private String description;
    private Integer poemCount;
    private Integer poetCount;
}
