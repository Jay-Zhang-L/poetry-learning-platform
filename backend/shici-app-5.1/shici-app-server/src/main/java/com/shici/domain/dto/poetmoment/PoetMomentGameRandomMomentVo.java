package com.shici.domain.dto.poetmoment;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Data;

import java.util.List;

@Data
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class PoetMomentGameRandomMomentVo {
    private Integer momentId;
    private String content;
    private String imageUrl;
    private List<PoetMomentGameOptionVo> options;
}