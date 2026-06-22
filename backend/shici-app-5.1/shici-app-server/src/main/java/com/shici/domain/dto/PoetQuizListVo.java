package com.shici.domain.dto;

import lombok.Data;

/**
 * 问卷列表VO
 */
@Data
public class PoetQuizListVo {
    private Long quizId;
    private String code;
    private String title;
    private String description;
    private String coverUrl;
    private Integer questionCount;
}
