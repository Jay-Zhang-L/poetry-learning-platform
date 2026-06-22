package com.shici.domain.dto;

import lombok.Data;

@Data
public class GameRankItemDto {
    private Long userId;
    private String username;
    private String nickname;
    private String avatarUrl;
    private Integer totalScore;
    private Integer poemMatchScore;
    private Integer correctCount;
    private Integer passCount;
}