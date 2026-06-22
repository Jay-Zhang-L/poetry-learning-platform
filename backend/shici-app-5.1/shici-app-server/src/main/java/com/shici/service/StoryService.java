package com.shici.service;

import com.shici.domain.entity.Story;
import com.shici.domain.entity.StoryCategory;
import com.shici.domain.vo.StoryDetailVO;

import java.util.List;

public interface StoryService {

    List<StoryCategory> getCategories();

    List<Story> getStoryList(Long categoryId, String keyword);

    StoryDetailVO getStoryDetail(Long id);
}
