package com.shici.domain.dto;

import lombok.Data;

/**
 * 朗诵诗词选择DTO
 * 用于朗诵录音页面的诗词选择列表
 */
@Data
public class RecitePoemSelectionDto {

    /**
     * 主键ID
     */
    private Long id;

    /**
     * 关联的诗词ID
     */
    private Long poemId;

    /**
     * 诗词标题
     */
    private String title;

    /**
     * 诗人姓名
     */
    private String poetName;

    /**
     * 朝代
     */
    private String dynasty;

    /**
     * 诗词内容（原文）
     */
    private String content;

    /**
     * 难度等级：1-入门 2-初级 3-中级 4-高级 5-挑战
     */
    private Integer difficultyLevel;

    /**
     * 推荐朗诵时长（秒）
     */
    private Integer recommendedDuration;

    /**
     * 情感类型：思乡、爱国、山水、送别等
     */
    private String emotionType;

    /**
     * 是否推荐：1-推荐 0-普通
     */
    private Boolean isFeatured;
}
