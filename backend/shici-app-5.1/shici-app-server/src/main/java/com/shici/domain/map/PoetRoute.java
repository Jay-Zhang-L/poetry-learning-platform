package com.shici.domain.map;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 诗人路线表
 */
@Data
public class PoetRoute {
    private Long id;
    private Long poetId;
    private Long locationId;
    private Integer visitOrder;
    private Integer visitYear;
    private String stayDuration;
    private String eventDescription;
    private LocalDateTime createdAt;
}
