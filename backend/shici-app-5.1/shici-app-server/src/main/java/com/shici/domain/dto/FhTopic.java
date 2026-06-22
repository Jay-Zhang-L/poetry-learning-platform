package com.shici.domain.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class FhTopic {
    private Long id;
    private String keyword;
    private String title;
    private String coverUrl;
    private String description;
    private Integer sortNum;
    private Integer status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}