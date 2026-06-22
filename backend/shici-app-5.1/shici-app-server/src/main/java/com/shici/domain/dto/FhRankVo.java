package com.shici.domain.dto;

import lombok.Data;

@Data
public class FhRankVo {

    private Long userId;
    private String username;
    private String nickname;
    private String avatarUrl;

    /**
     * 通用排行榜分数字段
     */
    private Integer score;

    /**
     * 兼容旧前端页面使用的字段
     */
    private Integer totalScore;

    /**
     * 答对次数
     */
    private Integer correctCount;
}