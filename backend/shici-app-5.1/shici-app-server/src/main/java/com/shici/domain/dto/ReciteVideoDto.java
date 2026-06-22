package com.shici.domain.dto;

import lombok.Data;

@Data
public class ReciteVideoDto {
    private Long id;
    private Long playlistId;   // 新增：所属专题/诗单ID
    private String type;       // 新增：视频分类，可选

    private String title;
    private String author;
    private String thumbnail;
    private String videoUrl;
    private String duration;
    private String quality;
    private Long views;
    private String tags;
    private String description;
    private String uploadTime;
}