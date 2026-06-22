package com.shici.domain.map;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 诗人信息表
 */
@Data
public class Poet {
    private Long id;
    private String name;
    private String dynasty;
    private Integer birthYear;
    private Integer deathYear;
    private String birthplace;
    private String description;
    private String imageUrl;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
