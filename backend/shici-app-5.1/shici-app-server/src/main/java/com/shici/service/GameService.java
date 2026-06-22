package com.shici.service;

import com.shici.domain.GameEntry;
import com.shici.mapper.GameMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.temporal.WeekFields;
import java.util.List;
import java.util.Locale;

@Service
@RequiredArgsConstructor
public class GameService {
  private final GameMapper gameMapper;

  public List<GameEntry> weekly() {
    int week = LocalDate.now().get(WeekFields.of(Locale.CHINA).weekOfWeekBasedYear());
    // 演示：优先按当前周取，没有的话就取全部
    List<GameEntry> items = gameMapper.listWeekly(week);
    if (items == null || items.isEmpty()) {
      return gameMapper.listWeekly(null);
    }
    return items;
  }
}
