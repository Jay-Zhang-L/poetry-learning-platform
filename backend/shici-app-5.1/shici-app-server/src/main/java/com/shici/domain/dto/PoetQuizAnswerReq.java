package com.shici.domain.dto;

import lombok.Data;

/**
 * 提交答案请求
 */
@Data
public class PoetQuizAnswerReq {
    private Long attemptId;
    private Long questionId;
    private Long optionId;
}
