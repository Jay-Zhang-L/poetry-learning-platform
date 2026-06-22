package com.shici.service;

import com.shici.domain.dto.poetmoment.*;
import com.shici.mapper.PoetMomentGameMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PoetMomentGameService {

    private final PoetMomentGameMapper poetMomentGameMapper;

    public PoetMomentGameRandomMomentVo randomMoment() {
        PoetMomentGameMomentRow row = poetMomentGameMapper.selectRandomMomentWithOptions();
        if (row == null) {
            return null;
        }
        List<PoetMomentGameOptionRow> optRows = poetMomentGameMapper.selectOptionsByMomentId(row.getMomentId());
        List<PoetMomentGameOptionVo> options = optRows.stream().map(r -> {
            PoetMomentGameOptionVo v = new PoetMomentGameOptionVo();
            v.setOptionId(r.getOptionId());
            v.setPoetId(r.getPoetId());
            v.setPoetName(r.getPoetName());
            return v;
        }).collect(Collectors.toList());

        PoetMomentGameRandomMomentVo vo = new PoetMomentGameRandomMomentVo();
        vo.setMomentId(row.getMomentId());
        vo.setContent(row.getContent());
        vo.setImageUrl(row.getImageUrl());
        vo.setOptions(options);
        return vo;
    }

    public PoetMomentGameSubmitResultVo submitAnswer(PoetMomentGameSubmitReq req) {
        if (req == null || !StringUtils.hasText(req.getUserId())
                || req.getMomentId() == null || req.getSelectedPoetId() == null) {
            throw new IllegalArgumentException("参数不完整");
        }
        Integer correctId = poetMomentGameMapper.selectCorrectPoetIdByMomentId(req.getMomentId());
        if (correctId == null) {
            throw new IllegalArgumentException("动态不存在或未配置正确答案");
        }
        int ok = poetMomentGameMapper.countOptionByMomentAndPoet(req.getMomentId(), req.getSelectedPoetId());
        if (ok == 0) {
            throw new IllegalArgumentException("所选诗人不在该题的选项中");
        }

        boolean isCorrect = correctId.equals(req.getSelectedPoetId());
        poetMomentGameMapper.insertGameRecord(
                req.getUserId(),
                req.getMomentId(),
                req.getSelectedPoetId(),
                isCorrect
        );

        PoetMomentGamePoetRow poetRow = poetMomentGameMapper.selectPoetById(correctId);
        PoetMomentGamePoetVo poetVo = toPoetVo(poetRow);
        PoetMomentGamePoetRow correctNamed = poetRow;
        String correctName = correctNamed != null ? correctNamed.getName() : "";

        PoetMomentGameSubmitResultVo vo = new PoetMomentGameSubmitResultVo();
        vo.setIsCorrect(isCorrect);
        vo.setCorrectPoetId(correctId);
        vo.setCorrectPoetName(correctName);
        vo.setPoetInfo(poetVo);
        return vo;
    }

    public PoetMomentGameUserRecordsVo userRecords(String userId) {
        if (!StringUtils.hasText(userId)) {
            throw new IllegalArgumentException("user_id 不能为空");
        }
        int total = poetMomentGameMapper.countAttemptsByUser(userId);
        int correct = poetMomentGameMapper.countCorrectByUser(userId);
        int accuracy = total == 0 ? 0 : (int) Math.round(correct * 100.0 / total);

        List<PoetMomentGameRecordRow> rows = poetMomentGameMapper.selectRecordsByUserId(userId);
        List<PoetMomentGameRecordItemVo> records = rows.stream().map(r -> {
            PoetMomentGameRecordItemVo v = new PoetMomentGameRecordItemVo();
            v.setRecordId(r.getRecordId());
            v.setMomentId(r.getMomentId());
            v.setContent(r.getContent());
            v.setSelectedPoetId(r.getSelectedPoetId());
            v.setSelectedPoetName(r.getSelectedPoetName());
            v.setCorrectPoetId(r.getCorrectPoetId());
            v.setCorrectPoetName(r.getCorrectPoetName());
            v.setIsCorrect(Boolean.TRUE.equals(r.getCorrect()));
            v.setCreatedAt(r.getCreatedAt());
            return v;
        }).collect(Collectors.toList());

        PoetMomentGameUserRecordsVo vo = new PoetMomentGameUserRecordsVo();
        vo.setTotalAttempts(total);
        vo.setCorrectCount(correct);
        vo.setAccuracy(accuracy);
        vo.setRecords(records);
        return vo;
    }

    public PoetMomentGamePoetDetailVo poetDetail(Integer poetId) {
        if (poetId == null) {
            throw new IllegalArgumentException("poet_id 不能为空");
        }
        PoetMomentGamePoetRow poetRow = poetMomentGameMapper.selectPoetById(poetId);
        if (poetRow == null) {
            return null;
        }
        List<PoetMomentGameMomentRow> mRows = poetMomentGameMapper.selectMomentsByPoetId(poetId);
        List<PoetMomentGameMomentItemVo> moments = mRows.stream().map(m -> {
            PoetMomentGameMomentItemVo v = new PoetMomentGameMomentItemVo();
            v.setMomentId(m.getMomentId());
            v.setContent(m.getContent());
            v.setImageUrl(m.getImageUrl());
            v.setLikesCount(m.getLikesCount() != null ? m.getLikesCount() : 0);
            v.setCreatedAt(m.getCreatedAt());
            return v;
        }).collect(Collectors.toList());

        PoetMomentGamePoetDetailVo vo = new PoetMomentGamePoetDetailVo();
        vo.setPoetId(poetRow.getPoetId());
        vo.setName(poetRow.getName());
        vo.setDynasty(poetRow.getDynasty());
        vo.setBirthYear(poetRow.getBirthYear());
        vo.setDeathYear(poetRow.getDeathYear());
        vo.setDescription(poetRow.getDescription());
        vo.setImageUrl(poetRow.getImageUrl());
        vo.setMoments(moments);
        return vo;
    }

    private static PoetMomentGamePoetVo toPoetVo(PoetMomentGamePoetRow row) {
        if (row == null) {
            return null;
        }
        PoetMomentGamePoetVo v = new PoetMomentGamePoetVo();
        v.setPoetId(row.getPoetId());
        v.setName(row.getName());
        v.setDynasty(row.getDynasty());
        v.setBirthYear(row.getBirthYear());
        v.setDeathYear(row.getDeathYear());
        v.setDescription(row.getDescription());
        v.setImageUrl(row.getImageUrl());
        return v;
    }
}