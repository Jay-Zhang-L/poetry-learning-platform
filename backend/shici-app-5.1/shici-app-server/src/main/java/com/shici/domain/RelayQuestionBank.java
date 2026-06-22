package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RelayQuestionBank {
    private Long id;
    private String title;
    private String poemSentence;
    private String answerSentence;
    private String expectedWord;
    private String author;
    private String dynasty;
    private Integer difficulty;
    private String status;
    private Integer sortNum;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}