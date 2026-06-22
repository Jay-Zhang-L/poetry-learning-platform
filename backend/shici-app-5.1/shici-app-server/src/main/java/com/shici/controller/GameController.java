package com.shici.controller;

import com.shici.common.R;
import com.shici.service.GameService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/games")
@RequiredArgsConstructor
public class GameController {
  private final GameService gameService;

  @GetMapping("/weekly")
  public R<?> weekly() {
    return R.ok(gameService.weekly());
  }
}
