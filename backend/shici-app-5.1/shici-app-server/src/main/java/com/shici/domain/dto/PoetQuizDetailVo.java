package com.shici.domain.dto;

import lombok.Data;

import java.util.List;

/**
 * 问卷详情VO
 */
@Data
public class PoetQuizDetailVo {
    private Long quizId;
    private String title;
    private String description;
    private String coverUrl;
    private List<PoetQuizQuestionVo> questions;
}
