package com.shici.domain.dto.poetmoment;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class PoetMomentGameRecordItemVo {
    private Integer recordId;
    private Integer momentId;
    private String content;
    private Integer selectedPoetId;
    private String selectedPoetName;
    private Integer correctPoetId;
    private String correctPoetName;
    private Boolean isCorrect;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;
}