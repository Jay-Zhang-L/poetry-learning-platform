package com.shici.domain.entity;

import lombok.Data;

@Data
public class StoryCategory {
    private Long id;
    private String name;
    private String icon;
    private Integer sortOrder;
}
