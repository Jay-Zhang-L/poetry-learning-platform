package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class DictionaryEntry {
    private Long id;

    private String word;
    private String pinyin;
    private String fullPinyin;
    private String alternativePinyin;

    private String explanation;
    private String detailedDefinition;
    private String wordType;
    private String usageType;
    private String emotionalColor;

    private String ancientMeaning;
    private String modernMeaning;
    private String semanticShift;

    private String sourceTitle;
    private String sourceText;
    private String sourceNote;

    private String mistakeProne;
    private String writingNote;
    private String characterNote;

    private String exampleClassical;
    private String examplePoetry;
    private String exampleModern;

    private String culturalBackground;
    private String geographyNote;
    private String literatureNote;

    private String poemExpand1Title;
    private String poemExpand1Author;
    private String poemExpand1Quote;
    private String poemExpand1Analysis;

    private String poemExpand2Title;
    private String poemExpand2Author;
    private String poemExpand2Quote;
    private String poemExpand2Analysis;

    private String poemExpand3Title;
    private String poemExpand3Author;
    private String poemExpand3Quote;
    private String poemExpand3Analysis;

    private String synonymText;
    private String antonymText;
    private String recommendText;

    private String coverUrl;
    private String themeTag;
    private Integer isRecommend;
    private Integer sortNo;
    private Integer status;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}