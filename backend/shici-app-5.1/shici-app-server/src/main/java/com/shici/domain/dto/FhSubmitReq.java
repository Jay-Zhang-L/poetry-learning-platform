package com.shici.domain.dto;

import lombok.Data;

@Data
public class FhSubmitReq {
    private Long sessionId;
    private String sentence;
    private String keyword;
}