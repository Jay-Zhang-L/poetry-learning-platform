package com.shici.domain.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Story {
    private Long id;
    private Long categoryId;
    private String title;
    private String dynasty;
    private String keywords;
    private String summary;
    private String content;
    private String source;
    private String coverImage;
    private Integer heat;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
