package com.shici.domain.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class PoetQuizAttemptHistoryVo {
    private Long attemptId;
    private Long quizId;
    private String quizTitle;
    private String status;
    private Integer totalQuestions;
    private Integer answeredCount;
    private Long resultPoetId;
    private Integer resultScore;
    private String resultPoetName;
    private String resultPoetDynasty;
    private String resultPoetAvatarUrl;
    private String resultPoetPersonaTitle;
    private LocalDateTime startedAt;
    private LocalDateTime finishedAt;
}