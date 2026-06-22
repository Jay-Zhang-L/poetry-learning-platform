package com.shici.domain.map;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 地区信息表
 */
@Data
public class Location {
    private Long id;
    private String name;
    private String province;
    private BigDecimal longitude;
    private BigDecimal latitude;
    private String description;
    private String historicalName;
    private String dynasty;
    private Integer importanceScore;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
