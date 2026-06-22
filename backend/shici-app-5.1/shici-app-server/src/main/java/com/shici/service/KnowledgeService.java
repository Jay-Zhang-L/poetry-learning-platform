package com.shici.service;

import com.shici.domain.vo.KnowledgeVO;
import java.util.List;

public interface KnowledgeService {

    /**
     * 获取所有知识卡片列表（用于首页展示）
     * @return 知识卡片列表
     */
    List<KnowledgeVO> getKnowledgeList();

    /**
     * 根据pageKey获取知识卡片详情
     * @param pageKey 卡片标识
     * @return 知识卡片详情
     */
    KnowledgeVO getKnowledgeDetail(String pageKey);
}