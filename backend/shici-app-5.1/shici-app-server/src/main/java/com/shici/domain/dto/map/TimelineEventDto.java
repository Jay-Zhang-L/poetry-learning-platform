package com.shici.domain.dto.map;

import lombok.Data;

/**
 * 时间轴事件DTO
 */
@Data
public class TimelineEventDto {
    private Long id;
    private Integer year;
    private String type;
    private String name;
    private String description;
    private String location;
    private Integer importance;
}
