package com.shici.domain.vo;

import lombok.Data;

@Data
public class KnowledgeImageVO {
    /**
     * 主键ID
     */
    private Integer id;

    /**
     * 图片URL
     */
    private String imageUrl;

    /**
     * 图片描述
     */
    private String imageDesc;

    /**
     * 排序
     */
    private Integer sortOrder;
}