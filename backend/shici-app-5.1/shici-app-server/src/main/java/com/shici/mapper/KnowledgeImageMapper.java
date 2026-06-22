package com.shici.mapper;

import com.shici.domain.KnowledgeImage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface KnowledgeImageMapper {

    /**
     * 根据知识卡片ID获取图片列表
     * @param knowledgeId 知识卡片ID
     * @return 图片列表
     */
    List<KnowledgeImage> findByKnowledgeId(@Param("knowledgeId") Integer knowledgeId);
}