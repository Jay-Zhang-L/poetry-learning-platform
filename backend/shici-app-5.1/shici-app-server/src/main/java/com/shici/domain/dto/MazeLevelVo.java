package com.shici.domain.dto;

import lombok.Data;
import java.util.List;

@Data
public class MazeLevelVo {
    private Long id;
    private Integer seasonNo;
    private Integer levelNo;
    private String title;
    private String poemTitle;
    private String poemAuthor;
    private Integer sizeN;
    private List<List<String>> grid;
    private List<String> lines;
    private String difficulty;
}