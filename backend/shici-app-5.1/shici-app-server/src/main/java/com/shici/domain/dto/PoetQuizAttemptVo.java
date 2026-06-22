package com.shici.domain.dto;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 测评记录VO
 */
@Data
public class PoetQuizAttemptVo {
    private Long attemptId;
    private Long quizId;
    private Integer totalQuestions;
    private Integer answeredCount;
    private LocalDateTime startedAt;
}
