package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 诗人形象表
 */
@Data
public class PoetPersona {
    private Long id;
    private String name;
    private String dynasty;
    private String avatarUrl;
    private String personaTitle;
    private String personaDesc;
    private String representativeWorks;
    private String tags;
    private Integer status;
    private Integer sortNo;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
