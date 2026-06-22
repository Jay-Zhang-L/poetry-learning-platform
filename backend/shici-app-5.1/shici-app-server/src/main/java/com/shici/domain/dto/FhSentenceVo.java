package com.shici.domain.dto;

import lombok.Data;

@Data
public class FhSentenceVo {
    private Long id;
    private String keyword;
    private String sentence;
    private String poemTitle;
    private String author;
    private String dynasty;
}