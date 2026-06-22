package com.shici.service.impl;

import com.shici.service.LikeService;
import com.shici.mapper.LikeMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class LikeServiceImpl implements LikeService {

    private final LikeMapper likeMapper;

    public LikeServiceImpl(LikeMapper likeMapper) {
        this.likeMapper = likeMapper;
    }

    @Override
    public List<Map<String, Object>> getReceivedLikes(Long userId, int page, int size) {
        int offset = Math.max(0, (page - 1) * size);
        return likeMapper.findReceivedLikes(userId, offset, size);
    }

    @Override
    public int countReceivedLikes(Long userId) {
        return likeMapper.countReceivedLikes(userId);
    }

    @Override
    public List<Map<String, Object>> getGivenLikes(Long userId, int page, int size) {
        int offset = Math.max(0, (page - 1) * size);
        return likeMapper.findGivenLikes(userId, offset, size);
    }

    @Override
    public int countGivenLikes(Long userId) {
        return likeMapper.countGivenLikes(userId);
    }
}
