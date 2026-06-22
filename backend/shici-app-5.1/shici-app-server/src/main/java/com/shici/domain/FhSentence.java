package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class FhSentence {
    private Long id;
    private String keyword;
    private String sentence;
    private String sentenceClean;
    private String poemTitle;
    private String author;
    private String dynasty;
    private String sourceText;
    private Integer difficulty;
    private Integer isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}