package com.shici.domain.dto.poetmoment;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Data;

import java.util.List;

@Data
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class PoetMomentGamePoetDetailVo {
    private Integer poetId;
    private String name;
    private String dynasty;
    private Integer birthYear;
    private Integer deathYear;
    private String description;
    private String imageUrl;
    private List<PoetMomentGameMomentItemVo> moments;
}