package com.shici.service;

import com.shici.domain.dto.GamePoemMatchFragmentDto;
import com.shici.domain.dto.GamePoemMatchLevelDto;
import com.shici.domain.dto.GamePoemMatchResultDto;
import com.shici.domain.dto.GamePoemMatchSubmitReq;
import com.shici.domain.dto.GameRankItemDto;
import com.shici.domain.entity.GamePoemMatchRecord;
import com.shici.mapper.GamePoemMatchMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class GamePoemMatchService {

    private final GamePoemMatchMapper gamePoemMatchMapper;

    public GamePoemMatchLevelDto getLevel(Long levelId) {
        Map<String, Object> levelMap = gamePoemMatchMapper.selectLevelById(levelId);
        if (levelMap == null || levelMap.isEmpty()) {
            return null;
        }

        List<GamePoemMatchFragmentDto> fragments =
                gamePoemMatchMapper.selectFragmentsByLevelId(levelId);

        GamePoemMatchLevelDto dto = new GamePoemMatchLevelDto();
        dto.setLevelId(levelMap.get("levelId") == null ? null : ((Number) levelMap.get("levelId")).longValue());
        dto.setTitle((String) levelMap.get("title"));
        dto.setDescription((String) levelMap.get("description"));
        dto.setTimeLimitSec(levelMap.get("timeLimitSec") == null ? 480 : ((Number) levelMap.get("timeLimitSec")).intValue());
        dto.setSlotLimit(levelMap.get("slotLimit") == null ? 6 : ((Number) levelMap.get("slotLimit")).intValue());
        dto.setPoemCount(levelMap.get("poemCount") == null ? 20 : ((Number) levelMap.get("poemCount")).intValue());
        dto.setFragments(fragments);
        return dto;
    }

    @Transactional(rollbackFor = Exception.class)
    public Long startGame(GamePoemMatchSubmitReq req) {
        if (req == null || req.getUserId() == null || req.getLevelId() == null) {
            throw new RuntimeException("开局失败：userId或levelId不能为空");
        }

        GamePoemMatchRecord record = new GamePoemMatchRecord();
        record.setUserId(req.getUserId());
        record.setLevelId(req.getLevelId());
        record.setScore(0);
        record.setMatchedCount(0);
        record.setPassed(0);
        record.setUsedSeconds(0);

        int affected = gamePoemMatchMapper.insertRecord(record);
        if (affected <= 0 || record.getId() == null) {
            throw new RuntimeException("开局失败：创建对局记录失败");
        }

        return record.getId();
    }

    @Transactional(rollbackFor = Exception.class)
    public void addScore(GamePoemMatchSubmitReq req) {
        if (req == null || req.getUserId() == null || req.getRecordId() == null) {
            throw new RuntimeException("实时加分失败：userId或recordId不能为空");
        }

        int usedSeconds = req.getUsedSeconds() == null ? 0 : req.getUsedSeconds();

        int affect1 = gamePoemMatchMapper.increaseRecordScore(req.getRecordId(), usedSeconds);
        if (affect1 <= 0) {
            throw new RuntimeException("实时加分失败：record不存在，recordId=" + req.getRecordId());
        }

        int affect2 = gamePoemMatchMapper.updateUserPoemMatchScore(
                req.getUserId(),
                1,
                1,
                0
        );
        if (affect2 <= 0) {
            throw new RuntimeException("实时加分失败：sys_user不存在，userId=" + req.getUserId());
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public GamePoemMatchResultDto submit(GamePoemMatchSubmitReq req) {
        if (req == null || req.getUserId() == null || req.getLevelId() == null || req.getRecordId() == null) {
            return new GamePoemMatchResultDto(0, 0, false, 0, "提交失败：userId、levelId、recordId不能为空");
        }

        boolean passed = req.getPassed() != null && req.getPassed();
        int usedSeconds = req.getUsedSeconds() == null ? 0 : req.getUsedSeconds();
        int passValue = passed ? 1 : 0;
        int bonusScore = passed ? 5 : 0;

        int affect1 = gamePoemMatchMapper.finishRecord(req.getRecordId(), passValue, usedSeconds);
        if (affect1 <= 0) {
            throw new RuntimeException("结算失败：record不存在，recordId=" + req.getRecordId());
        }

        if (passed) {
            int affect2 = gamePoemMatchMapper.updateUserPoemMatchScore(
                    req.getUserId(),
                    bonusScore,
                    0,
                    1
            );
            if (affect2 <= 0) {
                throw new RuntimeException("结算失败：sys_user不存在，userId=" + req.getUserId());
            }
        }

        return new GamePoemMatchResultDto(
                bonusScore,
                0,
                passed,
                bonusScore,
                passed ? "通关成功，额外奖励5分，已计入排行榜" : "本局成绩已保存"
        );
    }

    public List<GameRankItemDto> getGameTotalRank() {
        return gamePoemMatchMapper.selectGameTotalRank();
    }
}