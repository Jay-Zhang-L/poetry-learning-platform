package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.dto.GamePoemMatchLevelDto;
import com.shici.domain.dto.GamePoemMatchResultDto;
import com.shici.domain.dto.GamePoemMatchSubmitReq;
import com.shici.domain.dto.GameRankItemDto;
import com.shici.service.GamePoemMatchService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/game/poem-match")
@RequiredArgsConstructor
@CrossOrigin
public class GamePoemMatchController {

    private final GamePoemMatchService gamePoemMatchService;

    @GetMapping("/level/{levelId}")
    public R<GamePoemMatchLevelDto> getLevel(@PathVariable Long levelId) {
        GamePoemMatchLevelDto dto = gamePoemMatchService.getLevel(levelId);
        if (dto == null) {
            return R.fail("关卡不存在");
        }
        return R.ok(dto);
    }

    @PostMapping("/start")
    public R<Map<String, Object>> start(@RequestBody GamePoemMatchSubmitReq req) {
        Long recordId = gamePoemMatchService.startGame(req);
        Map<String, Object> data = new HashMap<>();
        data.put("recordId", recordId);
        return R.ok(data);
    }

    @PostMapping("/add-score")
    public R<String> addScore(@RequestBody GamePoemMatchSubmitReq req) {
        gamePoemMatchService.addScore(req);
        return R.ok("ok");
    }

    @PostMapping("/submit")
    public R<GamePoemMatchResultDto> submit(@RequestBody GamePoemMatchSubmitReq req) {
        return R.ok(gamePoemMatchService.submit(req));
    }

    @GetMapping("/rank")
    public R<List<GameRankItemDto>> getRank() {
        return R.ok(gamePoemMatchService.getGameTotalRank());
    }
}