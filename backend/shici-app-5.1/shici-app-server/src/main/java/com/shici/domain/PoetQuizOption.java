package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 诗人形象测评问卷选项表
 */
@Data
public class PoetQuizOption {
    private Long id;
    private Long questionId;
    private Integer optionNo;
    private String optionText;
    private Integer status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
