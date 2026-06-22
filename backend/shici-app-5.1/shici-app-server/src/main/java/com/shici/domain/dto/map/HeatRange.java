package com.shici.domain.dto.map;

import lombok.Data;
import java.math.BigDecimal;

/**
 * 热度范围DTO
 */
@Data
public class HeatRange {
    private BigDecimal min;
    private BigDecimal max;
}
