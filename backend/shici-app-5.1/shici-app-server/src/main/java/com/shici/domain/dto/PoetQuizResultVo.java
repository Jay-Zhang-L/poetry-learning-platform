package com.shici.domain.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 测评结果VO
 */
@Data
public class PoetQuizResultVo {
    private Long attemptId;
    private Long quizId;
    private PoetPersonaVo resultPoet;
    private List<PoetScoreVo> scoreBoard;
    private LocalDateTime finishedAt;
}
