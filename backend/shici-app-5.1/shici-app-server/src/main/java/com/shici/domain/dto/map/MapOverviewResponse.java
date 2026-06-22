package com.shici.domain.dto.map;

import lombok.Data;
import java.util.List;

/**
 * 地图概览响应 DTO
 */
@Data
public class MapOverviewResponse {
    private List<LocationHeatDto> locations;
    private HeatRange heatRange;
    private List<RepresentativePoetDto> poets;
}
