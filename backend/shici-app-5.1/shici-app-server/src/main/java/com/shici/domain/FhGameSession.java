package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class FhGameSession {
    private Long id;
    private Long userId;
    private Long currentTopicId;
    private String currentKeyword;
    private Integer score;
    private Integer correctCount;
    private Integer wrongCount;
    private Integer skipCount;
    private Integer status;
    private LocalDateTime startedAt;
    private LocalDateTime endedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}