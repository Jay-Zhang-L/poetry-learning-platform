package com.shici.domain.dto;

import lombok.Data;

import java.util.List;

@Data
public class GamePoemMatchLevelDto {
    private Long levelId;
    private String title;
    private String description;
    private Integer timeLimitSec;
    private Integer slotLimit;
    private Integer poemCount;
    private List<GamePoemMatchFragmentDto> fragments;
}