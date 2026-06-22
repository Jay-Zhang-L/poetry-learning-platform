package com.shici.domain.dto.poetmoment;

import lombok.Data;

@Data
public class PoetMomentGamePoetRow {
    private Integer poetId;
    private String name;
    private String dynasty;
    private Integer birthYear;
    private Integer deathYear;
    private String description;
    private String imageUrl;
}