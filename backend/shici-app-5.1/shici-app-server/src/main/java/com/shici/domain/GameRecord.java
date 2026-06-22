package com.shici.domain;

import lombok.Data;
import java.util.Date;

@Data
public class GameRecord {
    private Long id;
    private Long seasonId;
    private Long userId;
    private String mode;      // FH / JL
    private String prompt;    // 关键词 或 上一句
    private String answer;
    private Integer isCorrect;
    private Integer scoreAdd;
    private String reason;
    private Date createdAt;
}
