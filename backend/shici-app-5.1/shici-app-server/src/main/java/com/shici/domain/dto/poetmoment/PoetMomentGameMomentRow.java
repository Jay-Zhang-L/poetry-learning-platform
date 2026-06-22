package com.shici.domain.dto.poetmoment;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class PoetMomentGameMomentRow {
    private Integer momentId;
    private String content;
    private String imageUrl;
    private Integer likesCount;
    private LocalDateTime createdAt;
}