package com.shici.controller;

import com.shici.common.R;
import com.shici.service.LearnService;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/learn")
@RequiredArgsConstructor
public class LearnController {
  private final LearnService learnService;

  // 演示：暂时把 userId 固定为 1，后续接入登录后从 token 取
  private long userId() { return 1L; }

  @GetMapping("/grades")
  public R<?> grades() {
    return R.ok(learnService.grades(userId()));
  }

  @GetMapping("/units")
  public R<?> units(@RequestParam @Min(1) @Max(12) Integer grade) {
    return R.ok(learnService.units(userId(), grade));
  }

  @PostMapping("/progress")
  public R<?> progress(@RequestBody ProgressReq req) {
    learnService.updateProgress(userId(), req.getUnitId(), req.getProgress(), req.getStreakDays());
    return R.ok(true);
  }

  @Data
  public static class ProgressReq {
    private Long unitId;
    private Integer progress;
    private Integer streakDays;
  }
}
