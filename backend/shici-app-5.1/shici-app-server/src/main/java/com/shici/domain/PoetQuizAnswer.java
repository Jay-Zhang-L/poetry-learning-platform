package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 诗人形象测评答题记录表
 */
@Data
public class PoetQuizAnswer {
    private Long id;
    private Long attemptId;
    private Long questionId;
    private Long optionId;
    private LocalDateTime createdAt;
}
