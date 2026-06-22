package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.dto.MazeSubmitLineReq;
import com.shici.service.MazeGameService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/game/maze")
@RequiredArgsConstructor
public class MazeGameController {

    private final MazeGameService mazeGameService;

    @GetMapping("/levels")
    public R getLevels(@RequestParam(defaultValue = "1") Integer seasonNo) {
        return R.ok(mazeGameService.getLevelList(seasonNo));
    }

    @GetMapping("/level")
    public R getLevel(@RequestParam(defaultValue = "1") Integer seasonNo,
                      @RequestParam Integer levelNo) {
        return R.ok(mazeGameService.getLevel(seasonNo, levelNo));
    }

    @GetMapping("/progress")
    public R getProgress(@RequestParam(defaultValue = "1") Integer seasonNo,
                         @RequestParam Integer levelNo,
                         HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        return R.ok(mazeGameService.getUserProgress(seasonNo, levelNo, userId));
    }

    @PostMapping("/submit-line")
    public R submitLine(@RequestBody MazeSubmitLineReq req,
                        HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        Integer seasonNo = req.getSeasonNo() == null ? 1 : req.getSeasonNo();
        Integer levelNo = req.getLevelNo();
        return R.ok(mazeGameService.submitLine(seasonNo, levelNo, userId, req));
    }

    @GetMapping("/rank")
    public R getRank(@RequestParam(defaultValue = "1") Integer seasonNo) {
        return R.ok(mazeGameService.getGlobalRank(seasonNo));
    }

    private Long getCurrentUserId(HttpServletRequest request) {
        Object userId = request.getAttribute("userId");
        if (userId == null) {
            Object sessionUserId = request.getSession().getAttribute("userId");
            if (sessionUserId == null) return null;
            if (sessionUserId instanceof Long) return (Long) sessionUserId;
            return Long.valueOf(String.valueOf(sessionUserId));
        }
        if (userId instanceof Long) {
            return (Long) userId;
        }
        return Long.valueOf(String.valueOf(userId));
    }
}