package com.shici.domain.dto;

import lombok.Data;
import java.util.List;

@Data
public class MazeUserProgressVo {
    private Long userId;
    private Integer seasonNo;
    private Integer levelNo;
    private Integer solvedCount;
    private Integer totalLines;
    private Integer currentScore;
    private List<Integer> solvedLineIndexes;
}