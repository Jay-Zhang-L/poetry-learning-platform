package com.shici.domain.dto.ff;

import lombok.Data;

@Data
public class SubmitAnswerReq {
    private Long sessionId;
    private String sentence;
}