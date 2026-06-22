package com.shici.domain.dto;

import lombok.Data;
import java.util.List;

@Data
public class MazeSubmitLineReq {
    private Integer seasonNo;
    private Integer levelNo;
    private Integer lineIndex;
    private List<PointDto> selectedPath;

    @Data
    public static class PointDto {
        private Integer row;
        private Integer col;
    }
}