package com.shici.domain.dto;

import lombok.Data;

@Data
public class RelaySubmitReq {
    private Long sessionId;
    private String answer;
}