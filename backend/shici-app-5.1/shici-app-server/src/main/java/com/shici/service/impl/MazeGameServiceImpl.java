package com.shici.service.impl;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shici.domain.dto.MazeRankVo;
import com.shici.domain.dto.MazeSubmitLineReq;
import com.shici.domain.dto.MazeUserProgressVo;
import com.shici.mapper.MazeGameMapper;
import com.shici.service.MazeGameService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.shici.domain.dto.MazeLevelVo;


import java.util.*;

@Service
@RequiredArgsConstructor
public class MazeGameServiceImpl implements MazeGameService {

    private final MazeGameMapper mazeGameMapper;
    private final ObjectMapper objectMapper;

    @Override
    public List<Map<String, Object>> getLevelList(Integer seasonNo) {
        return mazeGameMapper.selectLevelList(seasonNo);
    }

    @Override
    public MazeLevelVo getLevel(Integer seasonNo, Integer levelNo) {
        Map<String, Object> row = mazeGameMapper.selectLevelBySeasonAndLevel(seasonNo, levelNo);
        if (row == null) {
            return null;
        }

        MazeLevelVo vo = new MazeLevelVo();
        vo.setId(((Number) row.get("id")).longValue());
        vo.setSeasonNo((Integer) row.get("seasonNo"));
        vo.setLevelNo((Integer) row.get("levelNo"));
        vo.setTitle((String) row.get("title"));
        vo.setPoemTitle((String) row.get("poemTitle"));
        vo.setPoemAuthor((String) row.get("poemAuthor"));
        vo.setSizeN((Integer) row.get("sizeN"));
        vo.setDifficulty((String) row.get("difficulty"));

        try {
            vo.setGrid(objectMapper.readValue(
                    String.valueOf(row.get("gridJson")),
                    new TypeReference<List<List<String>>>() {}
            ));
            vo.setLines(objectMapper.readValue(
                    String.valueOf(row.get("linesJson")),
                    new TypeReference<List<String>>() {}
            ));
        } catch (Exception e) {
            throw new RuntimeException("迷宫关卡JSON解析失败", e);
        }

        return vo;
    }

    @Override
    public Map<String, Object> submitLine(Integer seasonNo, Integer levelNo, Long userId, MazeSubmitLineReq req) {
        Map<String, Object> level = mazeGameMapper.selectLevelBySeasonAndLevel(seasonNo, levelNo);
        if (level == null) {
            throw new RuntimeException("关卡不存在");
        }

        Long levelId = ((Number) level.get("id")).longValue();
        String poemTitle = String.valueOf(level.get("poemTitle"));
        String poemAuthor = String.valueOf(level.get("poemAuthor"));

        List<String> lines;
        List<List<Map<String, Integer>>> paths;
        try {
            lines = objectMapper.readValue(
                    String.valueOf(level.get("linesJson")),
                    new TypeReference<List<String>>() {}
            );
            paths = objectMapper.readValue(
                    String.valueOf(level.get("pathsJson")),
                    new TypeReference<List<List<Map<String, Integer>>>>() {}
            );
        } catch (Exception e) {
            throw new RuntimeException("关卡数据解析失败", e);
        }

        Integer lineIndex = req.getLineIndex();
        if (lineIndex == null || lineIndex < 0 || lineIndex >= lines.size()) {
            throw new RuntimeException("诗句下标错误");
        }

        List<Map<String, Integer>> rightPath = paths.get(lineIndex);
        List<MazeSubmitLineReq.PointDto> selectedPath = req.getSelectedPath();
        boolean correct = comparePath(rightPath, selectedPath);

        Map<String, Object> result = new HashMap<>();
        result.put("correct", correct);
        result.put("lineIndex", lineIndex);
        result.put("lineText", lines.get(lineIndex));

        if (!correct) {
            result.put("addedScore", 0);
            result.put("alreadySolved", false);
            return result;
        }

        Integer exists = mazeGameMapper.countUserSolvedLine(userId, levelId, lineIndex);
        boolean alreadySolved = exists != null && exists > 0;

        if (!alreadySolved) {
            mazeGameMapper.insertSolvedLine(
                    userId,
                    seasonNo,
                    levelId,
                    levelNo,
                    poemTitle,
                    poemAuthor,
                    lineIndex,
                    lines.get(lineIndex)
            );
        }

        result.put("alreadySolved", alreadySolved);
        result.put("addedScore", alreadySolved ? 0 : 1);

        List<Integer> solvedIndexes = mazeGameMapper.selectSolvedLineIndexes(userId, levelId);
        result.put("solvedLineIndexes", solvedIndexes);
        result.put("solvedCount", solvedIndexes.size());
        result.put("totalLines", lines.size());

        Integer totalScore = mazeGameMapper.countUserScoreBySeason(userId, seasonNo);
        result.put("currentTotalScore", totalScore == null ? 0 : totalScore);

        return result;
    }

    @Override
    public MazeUserProgressVo getUserProgress(Integer seasonNo, Integer levelNo, Long userId) {
        Map<String, Object> level = mazeGameMapper.selectLevelBySeasonAndLevel(seasonNo, levelNo);
        if (level == null) {
            return null;
        }

        Long levelId = ((Number) level.get("id")).longValue();

        List<String> lines;
        try {
            lines = objectMapper.readValue(
                    String.valueOf(level.get("linesJson")),
                    new TypeReference<List<String>>() {}
            );
        } catch (Exception e) {
            throw new RuntimeException("关卡数据解析失败", e);
        }

        List<Integer> solvedIndexes = mazeGameMapper.selectSolvedLineIndexes(userId, levelId);
        Integer score = mazeGameMapper.countUserScoreBySeason(userId, seasonNo);

        MazeUserProgressVo vo = new MazeUserProgressVo();
        vo.setUserId(userId);
        vo.setSeasonNo(seasonNo);
        vo.setLevelNo(levelNo);
        vo.setSolvedCount(solvedIndexes.size());
        vo.setTotalLines(lines.size());
        vo.setCurrentScore(score == null ? 0 : score);
        vo.setSolvedLineIndexes(solvedIndexes);
        return vo;
    }

    @Override
    public List<MazeRankVo> getGlobalRank(Integer seasonNo) {
        return mazeGameMapper.selectGlobalRank(seasonNo);
    }

    private boolean comparePath(List<Map<String, Integer>> rightPath,
                                List<MazeSubmitLineReq.PointDto> selectedPath) {
        if (rightPath == null || selectedPath == null) {
            return false;
        }
        if (rightPath.size() != selectedPath.size()) {
            return false;
        }
        for (int i = 0; i < rightPath.size(); i++) {
            Map<String, Integer> rp = rightPath.get(i);
            MazeSubmitLineReq.PointDto sp = selectedPath.get(i);
            if (!Objects.equals(rp.get("row"), sp.getRow())) {
                return false;
            }
            if (!Objects.equals(rp.get("col"), sp.getCol())) {
                return false;
            }
        }
        return true;
    }
}