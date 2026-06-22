package com.shici.service.impl;

import com.shici.domain.entity.Story;
import com.shici.domain.entity.StoryCategory;
import com.shici.domain.vo.StoryDetailVO;
import com.shici.domain.vo.StoryPoemVO;
import com.shici.mapper.StoryMapper;
import com.shici.service.StoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class StoryServiceImpl implements StoryService {

    private final StoryMapper storyMapper;

    @Override
    public List<StoryCategory> getCategories() {
        return storyMapper.selectCategories();
    }

    @Override
    public List<Story> getStoryList(Long categoryId, String keyword) {
        return storyMapper.selectStoryList(categoryId, keyword);
    }

    @Override
    public StoryDetailVO getStoryDetail(Long id) {
        storyMapper.increaseHeat(id);

        Story story = storyMapper.selectStoryById(id);
        List<StoryPoemVO> poems = storyMapper.selectPoemsByStoryId(id);

        StoryDetailVO vo = new StoryDetailVO();
        vo.setStory(story);
        vo.setPoems(poems);

        return vo;
    }
}
