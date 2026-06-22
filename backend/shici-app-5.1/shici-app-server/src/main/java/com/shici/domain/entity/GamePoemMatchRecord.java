package com.shici.domain.entity;

import lombok.Data;

@Data
public class GamePoemMatchRecord {
    private Long id;
    private Long userId;
    private Long levelId;
    private Integer score;
    private Integer matchedCount;
    private Integer passed;
    private Integer usedSeconds;
}