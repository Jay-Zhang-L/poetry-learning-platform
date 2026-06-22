package com.shici.domain;

import java.util.List;
import java.util.Map;

/**
 * 数据看板VO
 */
public class DashboardVO {
    private Integer totalWorks;
    private Integer totalWords;
    private Double avgLikes;
    private Double avgComments;
    private Integer avgFav;
    private List<String> trendMonths;
    private List<Integer> trendData;
    private List<Map<String, Object>> typeDistribution;
    private List<Map<String, Object>> interactionData;

    // Getters and Setters
    public Integer getTotalWorks() {
        return totalWorks;
    }

    public void setTotalWorks(Integer totalWorks) {
        this.totalWorks = totalWorks;
    }

    public Integer getTotalWords() {
        return totalWords;
    }

    public void setTotalWords(Integer totalWords) {
        this.totalWords = totalWords;
    }

    public Double getAvgLikes() {
        return avgLikes;
    }

    public void setAvgLikes(Double avgLikes) {
        this.avgLikes = avgLikes;
    }

    public Double getAvgComments() {
        return avgComments;
    }

    public void setAvgComments(Double avgComments) {
        this.avgComments = avgComments;
    }

    public Integer getAvgFav() {
        return avgFav;
    }

    public void setAvgFav(Integer avgFav) {
        this.avgFav = avgFav;
    }

    public List<String> getTrendMonths() {
        return trendMonths;
    }

    public void setTrendMonths(List<String> trendMonths) {
        this.trendMonths = trendMonths;
    }

    public List<Integer> getTrendData() {
        return trendData;
    }

    public void setTrendData(List<Integer> trendData) {
        this.trendData = trendData;
    }

    public List<Map<String, Object>> getTypeDistribution() {
        return typeDistribution;
    }

    public void setTypeDistribution(List<Map<String, Object>> typeDistribution) {
        this.typeDistribution = typeDistribution;
    }

    public List<Map<String, Object>> getInteractionData() {
        return interactionData;
    }

    public void setInteractionData(List<Map<String, Object>> interactionData) {
        this.interactionData = interactionData;
    }
}