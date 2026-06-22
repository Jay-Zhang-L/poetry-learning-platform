package com.shici.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class GamePoemMatchResultDto {
    private Integer score;
    private Integer matchedCount;
    private Boolean passed;
    private Integer bonus;
    private String message;
}