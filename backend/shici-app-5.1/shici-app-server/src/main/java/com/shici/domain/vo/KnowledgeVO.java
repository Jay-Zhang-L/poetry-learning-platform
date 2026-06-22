package com.shici.domain.vo;

import lombok.Data;
import java.util.List;

@Data
public class KnowledgeVO {
    /**
     * 主键ID
     */
    private Integer id;

    /**
     * 卡片标识
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
     * 详细赏析文字
     */
    private String detailText;

    /**
     * 头部渐变色
     */
    private String imageBg;

    /**
     * 图片列表
     */
    private List<KnowledgeImageVO> images;
    private String coverUrl;
}