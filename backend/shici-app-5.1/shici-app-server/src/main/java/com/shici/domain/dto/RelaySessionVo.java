package com.shici.domain.dto;

import lombok.Data;

import java.util.List;

@Data
public class RelaySessionVo {
    private Long sessionId;
    private Long questionId;

    // 当前题目
    private String poemSentence;
    private String expectedWord;
    private String author;
    private String dynasty;

    // 局内数据
    private Integer currentStreak;
    private Integer totalCorrect;
    private Integer dragonLightCount;
    private Integer totalTargetCount;

    // 分数
    private Integer relayScore;
    private Integer totalScore;

    // 每题加分，给前端进度条右侧显示
    private Integer scorePerQuestion;

    // 额外提示
    private List<String> tips;
}