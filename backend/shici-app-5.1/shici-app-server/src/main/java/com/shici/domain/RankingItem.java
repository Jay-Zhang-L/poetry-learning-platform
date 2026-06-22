package com.shici.domain;

public class RankingItem {
    private Long id;
    private String title;
    private String url;
    private Integer viewCount;

    public RankingItem() {}

    public RankingItem(String title, String url) {
        this.title = title;
        this.url = url;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }

    public Integer getViewCount() { return viewCount; }
    public void setViewCount(Integer viewCount) { this.viewCount = viewCount; }
}