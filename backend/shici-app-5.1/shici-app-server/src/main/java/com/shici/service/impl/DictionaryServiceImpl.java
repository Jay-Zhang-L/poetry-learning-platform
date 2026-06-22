package com.shici.service.impl;

import com.shici.domain.DictionaryEntry;
import com.shici.mapper.DictionaryMapper;
import com.shici.service.DictionaryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class DictionaryServiceImpl implements DictionaryService {

    private final DictionaryMapper dictionaryMapper;

    @Override
    public Object getHomeData() {
        Map<String, Object> result = new HashMap<>();
        List<DictionaryEntry> recommendList = dictionaryMapper.selectHomeRecommend();

        result.put("recommendList", recommendList);
        result.put("bannerTitle", "古文词典");
        result.put("bannerSubTitle", "搜索古文词义，感受汉语之美");
        result.put("total", recommendList.size());

        return result;
    }

    @Override
    public Object search(String keyword) {
        return dictionaryMapper.searchEntries(keyword, 20);
    }

    @Override
    public Object getDetail(Long id) {
        return dictionaryMapper.selectById(id);
    }
}