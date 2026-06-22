package com.shici.domain.dto.poetmoment;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class PoetMomentGameRecordRow {
    private Integer recordId;
    private Integer momentId;
    private String content;
    private Integer selectedPoetId;
    private String selectedPoetName;
    private Integer correctPoetId;
    private String correctPoetName;
    private Boolean correct;
    private LocalDateTime createdAt;
}