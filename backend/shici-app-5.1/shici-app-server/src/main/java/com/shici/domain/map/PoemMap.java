package com.shici.domain.map;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 诗词信息表（诗词地图模块专用）
 */
@Data
public class PoemMap {
    private Long id;
    private String title;
    private Long poetId;
    private String content;
    private String dynasty;
    private Integer createYear;
    private String description;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
