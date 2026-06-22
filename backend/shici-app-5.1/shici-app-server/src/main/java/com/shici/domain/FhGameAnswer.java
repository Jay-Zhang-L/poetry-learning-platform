package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class FhGameAnswer {
    private Long id;
    private Long sessionId;
    private Long userId;
    private Long topicId;
    private String keyword;
    private String userSentence;
    private String userSentenceClean;
    private Long matchedSentenceId;
    private Integer isCorrect;
    private Integer scoreAward;
    private Integer hintUsed;
    private LocalDateTime createdAt;
}