package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 诗人形象测评问卷题目表
 */
@Data
public class PoetQuizQuestion {
    private Long id;
    private Long quizId;
    private Integer questionNo;
    private String questionText;
    private Integer sortNum;
    private LocalDateTime createdAt;
}
