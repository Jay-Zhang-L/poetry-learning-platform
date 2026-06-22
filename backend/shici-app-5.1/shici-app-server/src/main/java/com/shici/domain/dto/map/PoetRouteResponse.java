package com.shici.domain.dto.map;

import lombok.Data;
import java.util.List;

/**
 * 诗人路线响应DTO
 */
@Data
public class PoetRouteResponse {
    private PoetInfoDto poet;
    private List<RoutePointDto> route;
}
