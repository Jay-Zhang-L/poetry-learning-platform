package com.shici.domain.vo;

import lombok.Data;

@Data
public class StoryPoemVO {
    private Long id;
    private String title;
    private String author;
    private String dynasty;
    private String content;
    private String relationDesc;
}
