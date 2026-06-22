package com.shici.domain.dto.map;

import lombok.Data;
import java.math.BigDecimal;
import java.util.List;

/**
 * 地点详情响应DTO
 */
@Data
public class LocationDetailResponse {
    private Long id;
    private String name;
    private String historicalName;
    private String description;
    private BigDecimal longitude;
    private BigDecimal latitude;
    private List<RepresentativePoetDto> representativePoets;
    private List<AllusionDto> allusions;
    private PoemStatsDto poemStats;
}
