package com.shici.domain.dto.map;

import lombok.Data;
import java.util.Map;

/**
 * 诗词统计DTO
 */
@Data
public class PoemStatsDto {
    private Integer total;
    private Map<String, Integer> byDynasty;
}
