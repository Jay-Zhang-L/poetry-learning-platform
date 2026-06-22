package com.shici.domain;

import lombok.Data;
import java.util.Date;

@Data
public class Knowledge {
    /**
     * 主键ID
     */
    private Integer id;

    /**
     * 卡片标识（dufu, biansai等）
     */
    private String pageKey;

    /**
     * 标题
     */
    private String title;

    /**
     * 分类
     */
    private String category;

    /**
     * 完整介绍
     */
    private String fullDescription;

    /**
     * 详细赏析文字（支持HTML）
     */
    private String detailText;

    /**
     * 头部渐变色或背景图
     */
    private String imageBg;

    /**
     * 排序
     */
    private Integer sortOrder;

    /**
     * 状态：1启用 0禁用
     */
    private Integer status;

    /**
     * 创建时间
     */
    private Date createdAt;

    /**
     * 更新时间
     */
    private Date updatedAt;
    private String coverUrl;
}