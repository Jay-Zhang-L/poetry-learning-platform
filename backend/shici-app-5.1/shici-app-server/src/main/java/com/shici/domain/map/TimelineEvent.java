package com.shici.domain.map;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 时间轴事件表
 */
@Data
public class TimelineEvent {
    private Long id;
    private Long poetId;
    private String eventType;  // 出生/入仕/贬谪/游历/创作/交游/去世
    private String eventName;
    private String eventDescription;
    private Integer eventYear;
    private Long locationId;
    private Long relatedPoemId;
    private Integer importance;
    private LocalDateTime createdAt;
}
