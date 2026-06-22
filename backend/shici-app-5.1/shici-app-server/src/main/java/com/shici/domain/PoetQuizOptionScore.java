package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 选项分数表（选项与诗人的分数映射）
 */
@Data
public class PoetQuizOptionScore {
    private Long id;
    private Long optionId;
    private Long poetId;
    private Integer score;
    private LocalDateTime createdAt;
}
