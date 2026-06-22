package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.dto.poetmoment.*;
import com.shici.service.PoetMomentGameService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/game")
@RequiredArgsConstructor
@CrossOrigin
public class PoetMomentGameController {

    private final PoetMomentGameService poetMomentGameService;

    @GetMapping("/random-moment")
    public R<PoetMomentGameRandomMomentVo> randomMoment() {
        PoetMomentGameRandomMomentVo data = poetMomentGameService.randomMoment();
        if (data == null) {
            return R.fail("暂无题目");
        }
        return R.ok(data);
    }

    @PostMapping("/submit-answer")
    public R<PoetMomentGameSubmitResultVo> submitAnswer(@RequestBody PoetMomentGameSubmitReq req) {
        try {
            return R.ok(poetMomentGameService.submitAnswer(req));
        } catch (IllegalArgumentException e) {
            return R.fail(e.getMessage());
        }
    }

    @GetMapping("/user-records")
    public R<PoetMomentGameUserRecordsVo> userRecords(@RequestParam("user_id") String userId) {
        try {
            return R.ok(poetMomentGameService.userRecords(userId));
        } catch (IllegalArgumentException e) {
            return R.fail(e.getMessage());
        }
    }

    @GetMapping("/poet-detail")
    public R<PoetMomentGamePoetDetailVo> poetDetail(@RequestParam("poet_id") Integer poetId) {
        try {
            PoetMomentGamePoetDetailVo data = poetMomentGameService.poetDetail(poetId);
            if (data == null) {
                return R.fail("诗人不存在");
            }
            return R.ok(data);
        } catch (IllegalArgumentException e) {
            return R.fail(e.getMessage());
        }
    }
}