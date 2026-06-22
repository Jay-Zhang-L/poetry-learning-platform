package com.shici.domain.dto.map;

import lombok.Data;
import java.util.List;

/**
 * 时间轴响应DTO
 */
@Data
public class TimelineResponse {
    private PoetInfoDto poet;
    private List<TimelineEventDto> events;
}
