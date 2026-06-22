package com.shici.domain;

import lombok.Data;
import java.util.Date;

@Data
public class SeasonPlayerStat {
    private Long id;
    private Long seasonId;
    private Long userId;
    private Integer score;
    private Integer correctCount;
    private Integer wrongCount;
    private Date updatedAt;
}
