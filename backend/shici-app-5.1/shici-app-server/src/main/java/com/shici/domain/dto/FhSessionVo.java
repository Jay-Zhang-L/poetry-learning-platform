package com.shici.domain.dto;

import lombok.Data;

import java.util.List;

@Data
public class FhSessionVo {
    private Long sessionId;
    private Long topicId;
    private String keyword;
    private Integer score;
    private Integer correctCount;
    private Integer wrongCount;
    private Integer skipCount;
    private List<FhSentenceVo> examples;
}