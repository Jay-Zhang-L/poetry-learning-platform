package com.shici.domain.map;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 地区诗词统计表
 */
@Data
public class LocationPoemStat {
    private Long id;
    private Long locationId;
    private String dynasty;
    private Integer poemCount;
    private Integer poetCount;
    private BigDecimal heatValue;
    private Integer statYear;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
