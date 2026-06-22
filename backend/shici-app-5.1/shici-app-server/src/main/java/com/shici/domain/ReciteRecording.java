package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 朗诵录音评价实体
 */
@Data
public class ReciteRecording {
    private Long id;
    private Long userId;
    private Long poemId;
    private String poemTitle;
    private String poemContent;
    private String audioUrl;
    private Integer audioDuration;
    private String transcribedText;
    private Integer clarityScore;
    private Integer rhythmScore;
    private Integer emotionScore;
    private Integer overallScore;
    private String aiEvaluation;
    private String aiSuggestion;
    private LocalDateTime createdAt;
}
