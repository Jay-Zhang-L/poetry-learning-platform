package com.shici.domain.dto;

import lombok.Data;

@Data
public class RelayQuestionVo {
    private Long id;
    private String title;
    private String poemSentence;
    private String answerSentence;
    private String expectedWord;
    private String author;
    private String dynasty;
    private Integer difficulty;
}