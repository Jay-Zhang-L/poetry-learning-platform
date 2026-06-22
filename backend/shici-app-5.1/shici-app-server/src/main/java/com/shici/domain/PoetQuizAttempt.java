package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 诗人形象测评记录表
 */
@Data
public class PoetQuizAttempt {
    private Long id;
    private Long quizId;
    private Long userId;
    private Integer totalQuestions;
    private Integer answeredCount;
    private String status;
    private Long resultPoetId;
    private Integer resultScore;
    private String resultScoresSnapshot;
    private LocalDateTime startedAt;
    private LocalDateTime finishedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
