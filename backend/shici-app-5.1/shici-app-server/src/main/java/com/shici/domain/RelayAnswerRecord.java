package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RelayAnswerRecord {
    private Long id;
    private Long sessionId;
    private Long userId;
    private Long questionId;
    private String poemSentence;
    private String expectedWord;
    private String userAnswer;
    private String correctAnswer;
    private Integer isCorrect;
    private Integer scoreDelta;
    private LocalDateTime createTime;
}