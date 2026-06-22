package com.shici.domain.dto;

import lombok.Data;

@Data
public class MazeRankVo {
    private Long userId;
    private String username;
    private String nickname;
    private String avatarUrl;
    private Integer totalScore;
    private Integer totalLines;
    private Integer solvedPoems;
    private String latestSolveTime;
}