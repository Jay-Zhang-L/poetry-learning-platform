package com.shici.service;

import com.shici.domain.LearnUnit;
import com.shici.domain.UserProgress;
import com.shici.mapper.LearnUnitMapper;
import com.shici.mapper.ProgressMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class LearnService {
  private final LearnUnitMapper learnUnitMapper;
  private final ProgressMapper progressMapper;

  public List<Map<String, Object>> grades(Long userId) {
    // 先给前端一个“年级→学习单元列表入口”，后续可扩展成更复杂的学习路线
    List<Map<String, Object>> list = new ArrayList<>();
    for (int g = 1; g <= 6; g++) {
      Map<String, Object> m = new HashMap<>();
      m.put("grade", g);
      m.put("name", g + "年级");
      m.put("desc", "分级学习：必背 → 理解 → 赏析 → 默写/题型");
      list.add(m);
    }
    return list;
  }

  public List<Map<String, Object>> units(Long userId, Integer grade) {
    List<LearnUnit> units = learnUnitMapper.listByGrade(grade);
    List<Map<String, Object>> res = new ArrayList<>();
    for (LearnUnit u : units) {
      UserProgress p = progressMapper.get(userId, u.getId());
      Map<String, Object> m = new HashMap<>();
      m.put("unit", u);
      m.put("progress", p == null ? 0 : p.getProgress());
      m.put("streakDays", p == null ? 0 : p.getStreakDays());
      res.add(m);
    }
    return res;
  }

  public void updateProgress(Long userId, Long unitId, Integer progress, Integer streakDays) {
    UserProgress p = new UserProgress();
    p.setUserId(userId);
    p.setUnitId(unitId);
    p.setProgress(progress == null ? 0 : progress);
    p.setStreakDays(streakDays == null ? 0 : streakDays);
    progressMapper.upsert(p);
  }
}
