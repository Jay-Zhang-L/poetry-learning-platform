package com.shici.domain.dto;

import lombok.Data;

@Data
public class TopicDto {
    private Long id;
    private String code;
    private String name;
    private String subtitle;
    private String icon;
    private String coverUrl;
}
