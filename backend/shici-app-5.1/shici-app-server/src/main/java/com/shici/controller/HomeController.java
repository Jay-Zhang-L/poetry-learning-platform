package com.shici.controller;

import com.shici.common.R;
import com.shici.service.GameService;
import com.shici.service.PoemService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/home")
@RequiredArgsConstructor
public class HomeController {
  private final PoemService poemService;
  private final GameService gameService;

  @GetMapping("/today")
  public R<?> today() {
    // 演示：取资料库第一条当今日推荐（你后面可做“每日一诗”表）
    Map<String, Object> res = new HashMap<>();
    res.put("todayPoem", poemService.detail(1L));
    res.put("dailyQuote", "明月松间照，清泉石上流。");
    res.put("games", gameService.weekly());
    res.put("tasks", new String[]{"听示范 30 秒", "跟读录音 获取评分", "做 1 道小题 巩固理解"});
    return R.ok(res);
  }
}
