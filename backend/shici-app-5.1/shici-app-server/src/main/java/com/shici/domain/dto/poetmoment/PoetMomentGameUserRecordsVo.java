package com.shici.domain.dto.poetmoment;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Data;

import java.util.List;

@Data
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class PoetMomentGameUserRecordsVo {
    private Integer totalAttempts;
    private Integer correctCount;
    private Integer accuracy;
    private List<PoetMomentGameRecordItemVo> records;
}