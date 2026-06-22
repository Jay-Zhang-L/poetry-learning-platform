package com.shici.domain.map;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 典故信息表
 */
@Data
public class Allusion {
    private Long id;
    private String title;
    private String content;
    private Long locationId;
    private String dynasty;
    private String source;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
