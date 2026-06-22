package com.shici.mapper;

import com.shici.domain.Knowledge;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface KnowledgeMapper {

    /**
     * 获取所有启用的知识卡片
     * @return 知识卡片列表
     */
    List<Knowledge> findAllEnabled();

    /**
     * 根据pageKey获取知识卡片
     * @param pageKey 卡片标识
     * @return 知识卡片
     */
    Knowledge findByPageKey(@Param("pageKey") String pageKey);

    /**
     * 根据ID获取知识卡片
     * @param id 主键ID
     * @return 知识卡片
     */
    Knowledge findById(@Param("id") Integer id);
}