package com.shici.mapper;

import com.shici.domain.entity.Story;
import com.shici.domain.entity.StoryCategory;
import com.shici.domain.vo.StoryPoemVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface StoryMapper {

    List<StoryCategory> selectCategories();

    List<Story> selectStoryList(
            @Param("categoryId") Long categoryId,
            @Param("keyword") String keyword
    );

    Story selectStoryById(@Param("id") Long id);

    List<StoryPoemVO> selectPoemsByStoryId(@Param("storyId") Long storyId);

    void increaseHeat(@Param("id") Long id);
}
