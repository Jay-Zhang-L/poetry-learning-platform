package com.shici.domain.dto.poetmoment;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Data;

@Data
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class PoetMomentGamePoetVo {
    private Integer poetId;
    private String name;
    private String dynasty;
    private Integer birthYear;
    private Integer deathYear;
    private String description;
    private String imageUrl;
}