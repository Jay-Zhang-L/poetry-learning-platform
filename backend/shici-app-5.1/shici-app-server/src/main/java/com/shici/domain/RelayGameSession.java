package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RelayGameSession {
    private Long id;
    private Long userId;
    private Long currentQuestionId;
    private String currentPoem;
    private String expectedWord;
    private Integer currentStreak;
    private Integer totalCorrect;
    private Integer dragonLightCount;
    private Integer totalTargetCount;
    private String status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}