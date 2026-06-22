package com.shici.domain.dto.map;

import lombok.Data;
import java.math.BigDecimal;
import java.util.List;

/**
 * 地点热度信息DTO（用于热力图）
 */
@Data
public class LocationHeatDto {
    private Long id;
    private String name;
    private BigDecimal longitude;
    private BigDecimal latitude;
    private BigDecimal heatValue;
    private Integer poemCount;
    private Integer poetCount;
    private List<String> famousPoets;
}
