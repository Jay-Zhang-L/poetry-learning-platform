package com.shici.domain.dto.map;

import lombok.Data;
import java.math.BigDecimal;
import java.util.List;

/**
 * 路线点DTO
 */
@Data
public class RoutePointDto {
    private Integer order;
    private Long locationId;
    private String locationName;
    private Integer year;
    private String event;
    private List<RoutePoemDto> poems;
    private BigDecimal longitude;
    private BigDecimal latitude;
}
