package com.shici.service;

import com.shici.domain.dto.MazeLevelVo;
import com.shici.domain.dto.MazeRankVo;
import com.shici.domain.dto.MazeSubmitLineReq;
import com.shici.domain.dto.MazeUserProgressVo;

import java.util.List;
import java.util.Map;

public interface MazeGameService {

    List<Map<String, Object>> getLevelList(Integer seasonNo);

    MazeLevelVo getLevel(Integer seasonNo, Integer levelNo);

    Map<String, Object> submitLine(Integer seasonNo, Integer levelNo, Long userId, MazeSubmitLineReq req);

    MazeUserProgressVo getUserProgress(Integer seasonNo, Integer levelNo, Long userId);

    List<MazeRankVo> getGlobalRank(Integer seasonNo);
}