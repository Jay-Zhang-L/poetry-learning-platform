package com.shici.domain.dto;

import lombok.Data;

@Data
public class FhTopicVo {
    private Long id;
    private String keyword;
    private String title;
    private String description;
    private String coverUrl;
}