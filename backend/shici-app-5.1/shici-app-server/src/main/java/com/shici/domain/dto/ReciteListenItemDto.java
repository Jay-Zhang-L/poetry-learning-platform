package com.shici.domain.dto;

import lombok.Data;

@Data
public class ReciteListenItemDto {
    private Long id;
    private Long playlistId;
    private Long poemId;
    private String title;
    private String subtitle;
    private String cover;
    private String audioUrl;
    private Boolean up;
}