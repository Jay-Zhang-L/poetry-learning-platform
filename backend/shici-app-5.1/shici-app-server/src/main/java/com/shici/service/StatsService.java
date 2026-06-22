package com.shici.service;

import com.shici.domain.DashboardVO;
import com.shici.domain.TimelineVO;
import com.shici.domain.WordCloudVO;

import java.util.List;

/**
 * 统计分析服务接口
 */
public interface StatsService {

    /**
     * 获取用户创作时光轴
     * @param userId 用户ID
     * @param mode 时间模式：month/quarter/year
     * @return 时光轴节点列表
     */
    List<TimelineVO> getUserTimeline(Long userId, String mode);

    /**
     * 获取用户数据看板
     * @param userId 用户ID
     * @return 看板数据
     */
    DashboardVO getUserDashboard(Long userId);

    /**
     * 获取主题词云数据
     * @param userId 用户ID
     * @return 词云关键词列表
     */
    List<WordCloudVO> getWordCloudData(Long userId);
}