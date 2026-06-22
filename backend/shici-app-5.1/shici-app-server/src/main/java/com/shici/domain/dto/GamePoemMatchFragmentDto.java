package com.shici.domain.dto;

import lombok.Data;

@Data
public class GamePoemMatchFragmentDto {
    private Long fragmentId;
    private Long groupId;
    private String poemTitle;
    private String author;
    private String dynasty;
    private String poemText;
    private String fragmentText;
    private Integer fragmentOrder;
}