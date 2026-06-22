package com.shici.domain.dto.poetmoment;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Data;

@Data
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class PoetMomentGameSubmitResultVo {
    private Boolean isCorrect;
    private Integer correctPoetId;
    private String correctPoetName;
    private PoetMomentGamePoetVo poetInfo;
}