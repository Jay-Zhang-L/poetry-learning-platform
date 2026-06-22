package com.shici.service;

import com.shici.domain.GameSeason;
import com.shici.mapper.RankMapper;
import com.shici.mapper.SeasonMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class SeasonService {
    private final SeasonMapper seasonMapper;
    private final RankMapper rankMapper;

    public SeasonService(SeasonMapper seasonMapper, RankMapper rankMapper) {
        this.seasonMapper = seasonMapper;
        this.rankMapper = rankMapper;
    }

    public GameSeason current() {
        return seasonMapper.selectCurrent();
    }

    public GameSeason get(Long id) {
        return seasonMapper.selectById(id);
    }

    public List<Map<String, Object>> rank(Long seasonId, Integer top) {
        return rankMapper.topRank(seasonId, top == null ? 20 : top);
    }
}
