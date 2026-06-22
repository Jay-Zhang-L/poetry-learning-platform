package com.shici.domain;

import lombok.Data;

@Data
public class Poem {
    private Long id;

    private String title;
    private String author;
    private String dynasty;
    private String genre;
    private String theme;

    private Double difficulty;
    private Integer hot;
    private Integer len;

    private String quote;
    private String content;
    private String translation;
    private String analysis;
    private String tagsStr;
    private String coverUrl;
    private String audioUrl;
    private Integer audioDuration;
    private String audioType;

    // ========== 新增分类字段 ==========
    private String season;           // 季节
    private String emotion;          // 情感
    private String scenery;          // 景物
    private String festival;         // 节日
    private String historicalPeriod; // 历史时期
    private String poeticForm;       // 诗体
    private String rhetoricalDevice; // 修辞手法
    private String famousLineType;   // 名句类型
}