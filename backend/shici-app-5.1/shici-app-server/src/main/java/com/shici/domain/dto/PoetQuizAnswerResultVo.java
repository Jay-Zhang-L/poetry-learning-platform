package com.shici.domain.dto;

import lombok.Data;

/**
 * 提交答案结果VO
 */
@Data
public class PoetQuizAnswerResultVo {
    private Long attemptId;
    private Integer answeredCount;
    private Integer totalQuestions;
    private Boolean isFinished;
}
