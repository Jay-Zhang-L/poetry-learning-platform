package com.shici.service.impl;

import com.shici.mapper.CreationMapper;
import com.shici.service.StatsService;
import com.shici.domain.DashboardVO;
import com.shici.domain.TimelineVO;
import com.shici.domain.WordCloudVO;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * 统计分析服务实现
 */
@Service
public class StatsServiceImpl implements StatsService {

    private final CreationMapper creationMapper;

    public StatsServiceImpl(CreationMapper creationMapper) {
        this.creationMapper = creationMapper;
    }

    @Override
    public List<TimelineVO> getUserTimeline(Long userId, String mode) {
        List<Map<String, Object>> works = creationMapper.findTimelineByUserId(userId);

        List<TimelineVO> timeline = new ArrayList<>();

        for (int i = 0; i < works.size(); i++) {
            Map<String, Object> work = works.get(i);
            TimelineVO node = new TimelineVO();

            node.setId(((Number) work.get("id")).longValue());
            node.setTitle((String) work.get("title"));

            // 根据模式设置日期标签
            Object createdAtObj = work.get("created_at");
            String createdAt = createdAtObj != null ? createdAtObj.toString() : "";
            node.setDate(createdAt.length() >= 10 ? createdAt.substring(0, 10) : "");

            // 简单的日期格式化
            if (createdAt != null && createdAt.length() >= 7) {
                String dateLabel = createdAt.substring(0, 7); // YYYY-MM
                if ("month".equals(mode)) {
                    node.setDateLabel(dateLabel + "月");
                } else if ("quarter".equals(mode)) {
                    int month = Integer.parseInt(createdAt.substring(5, 7));
                    String quarter = "Q" + ((month - 1) / 3 + 1);
                    node.setDateLabel(createdAt.substring(0, 4) + " " + quarter);
                } else {
                    node.setDateLabel(createdAt.substring(0, 4) + "年");
                }
            } else {
                node.setDateLabel("未知时间");
            }

            node.setLikes(((Number) work.getOrDefault("like_count", 0)).intValue());
            node.setComments(((Number) work.getOrDefault("comment_count", 0)).intValue());

            // 设置里程碑
            node.setIsMilestone(i == 0); // 第一篇是里程碑
            if (i == 0) {
                node.setBadgeText("首篇");
            } else if (node.getLikes() >= 100) {
                node.setIsMilestone(true);
                node.setBadgeText("100赞");
            }

            timeline.add(node);
        }

        return timeline;
    }

    @Override
    public DashboardVO getUserDashboard(Long userId) {
        DashboardVO dashboard = new DashboardVO();

        // 基础统计数据
        int totalWorks = creationMapper.countByUserId(userId);
        int totalWords = creationMapper.sumWordsByUserId(userId);
        int totalLikes = creationMapper.sumLikesByUserId(userId);
        int totalComments = creationMapper.sumCommentsByUserId(userId);

        dashboard.setTotalWorks(totalWorks);
        dashboard.setTotalWords(totalWords);
        dashboard.setAvgLikes(totalWorks > 0 ? (double) totalLikes / totalWorks : 0.0);
        dashboard.setAvgComments(totalWorks > 0 ? (double) totalComments / totalWorks : 0.0);
        dashboard.setAvgFav(0); // 暂无收藏统计

        // 趋势数据
        List<Map<String, Object>> monthlyStats = creationMapper.findMonthlyStats(userId);
        List<String> months = new ArrayList<>();
        List<Integer> trendData = new ArrayList<>();

        // 简单处理：只返回有数据的月份
        for (Map<String, Object> stat : monthlyStats) {
            String month = (String) stat.get("month");
            String monthLabel = month.substring(5) + "月"; // MM月格式
            months.add(monthLabel);
            trendData.add(((Number) stat.get("count")).intValue());
        }

        dashboard.setTrendMonths(months);
        dashboard.setTrendData(trendData);

        // 类型分布
        List<Map<String, Object>> typeStats = creationMapper.findTypeStats(userId);
        List<Map<String, Object>> typeDistribution = new ArrayList<>();

        // 类型名称映射
        Map<String, String> typeNames = new HashMap<>();
        typeNames.put("wujue", "五言绝句");
        typeNames.put("qijue", "七言绝句");
        typeNames.put("wulv", "五言律诗");
        typeNames.put("qilv", "七言律诗");
        typeNames.put("ge", "古体诗");
        typeNames.put("ci", "词");
        typeNames.put("other", "其他");

        for (Map<String, Object> stat : typeStats) {
            String type = (String) stat.get("type");
            Integer count = ((Number) stat.get("count")).intValue();

            Map<String, Object> typeData = new HashMap<>();
            typeData.put("name", typeNames.getOrDefault(type, type));
            typeData.put("value", count);
            typeDistribution.add(typeData);
        }

        dashboard.setTypeDistribution(typeDistribution);
        dashboard.setInteractionData(null); // 暂无互动数据

        return dashboard;
    }

    @Override
    public List<WordCloudVO> getWordCloudData(Long userId) {
        List<Map<String, Object>> works = creationMapper.findTimelineByUserId(userId);

        // 简单的关键词提取（基于作品内容）
        Map<String, Integer> wordCount = new HashMap<>();

        // 常见诗词关键词
        String[] commonWords = {"春", "夏", "秋", "冬", "月", "日", "星", "云", "风", "雨",
                               "山", "水", "花", "鸟", "树", "草", "天", "地", "人", "情",
                               "相思", "离别", "故乡", "友情", "爱情", "思乡", "山水", "田园",
                               "明月", "清风", "白日", "黄河", "长江", "桃花", "梅花", "菊花"};

        for (Map<String, Object> work : works) {
            String content = (String) work.get("content");
            if (content != null) {
                for (String word : commonWords) {
                    if (content.contains(word)) {
                        wordCount.put(word, wordCount.getOrDefault(word, 0) + 1);
                    }
                }
            }
        }

        // 转换为WordCloudVO列表并按词频排序
        List<WordCloudVO> wordCloud = new ArrayList<>();
        int maxCount = wordCount.values().stream().max(Integer::compare).orElse(1);

        for (Map.Entry<String, Integer> entry : wordCount.entrySet()) {
            WordCloudVO word = new WordCloudVO();
            word.setText(entry.getKey());
            word.setCount(entry.getValue());
            word.setWeight((double) entry.getValue() / maxCount);
            wordCloud.add(word);
        }

        // 按词频降序排序
        wordCloud.sort((a, b) -> b.getCount().compareTo(a.getCount()));

        // 返回前20个关键词
        return wordCloud.stream().limit(20).toList();
    }
}