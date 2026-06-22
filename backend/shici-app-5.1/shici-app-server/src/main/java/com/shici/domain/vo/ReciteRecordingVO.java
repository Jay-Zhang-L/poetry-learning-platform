package com.shici.domain.vo;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 录音评价结果VO
 */
@Data
@Builder
public class ReciteRecordingVO {
    private Long id;
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
