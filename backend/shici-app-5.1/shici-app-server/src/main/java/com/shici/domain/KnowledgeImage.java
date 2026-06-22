package com.shici.domain;

import lombok.Data;
import java.util.Date;

@Data
public class KnowledgeImage {
    /**
     * 主键ID
     */
    private Integer id;

    /**
     * 知识卡片ID
     */
    private Integer knowledgeId;

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

    /**
     * 创建时间
     */
    private Date createdAt;
}