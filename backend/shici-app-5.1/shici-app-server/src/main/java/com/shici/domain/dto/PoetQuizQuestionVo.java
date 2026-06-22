package com.shici.domain.dto;

import lombok.Data;

import java.util.List;

/**
 * 问卷题目VO
 */
@Data
public class PoetQuizQuestionVo {
    private Long questionId;
    private Integer questionNo;
    private String questionText;
    private List<PoetQuizOptionVo> options;
}
