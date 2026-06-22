package com.shici.domain.dto;

import lombok.Data;

@Data
public class RecitePlaylistDto {

    /**
     * 诗单ID
     */
    private Long id;

    /**
     * 诗单名称
     */
    private String name;

    /**
     * 封面图
     */
    private String cover;

    /**
     * 类型：album / taste
     */
    private String type;

    /**
     * 描述
     */
    private String description;
}