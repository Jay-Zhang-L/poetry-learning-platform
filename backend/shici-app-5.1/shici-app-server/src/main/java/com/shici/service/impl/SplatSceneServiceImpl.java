package com.shici.service.impl;

import com.shici.domain.SplatScene;
import com.shici.mapper.SplatSceneMapper;
import com.shici.service.SplatSceneService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SplatSceneServiceImpl implements SplatSceneService {

    private final SplatSceneMapper splatSceneMapper;

    public SplatSceneServiceImpl(SplatSceneMapper splatSceneMapper) {
        this.splatSceneMapper = splatSceneMapper;
    }

    @Override
    public SplatScene getById(Long id) {
        return splatSceneMapper.selectById(id);
    }

    @Override
    public List<SplatScene> search(String kw) {
        return splatSceneMapper.selectList(kw);
    }
}