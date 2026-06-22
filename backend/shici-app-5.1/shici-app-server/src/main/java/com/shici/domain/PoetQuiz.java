package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 诗人形象测评问卷主表
 */
@Data
public class PoetQuiz {
    private Long id;
    private String code;
    private String title;
    private String description;
    private String coverUrl;
    private Integer questionCount;
    private Integer status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
