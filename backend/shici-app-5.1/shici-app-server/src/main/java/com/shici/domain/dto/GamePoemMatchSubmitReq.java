package com.shici.domain.dto;

import lombok.Data;

@Data
public class GamePoemMatchSubmitReq {
    private Long recordId;
    private Long userId;
    private Long levelId;
    private Integer score;
    private Integer matchedCount;
    private Boolean passed;
    private Integer usedSeconds;
}