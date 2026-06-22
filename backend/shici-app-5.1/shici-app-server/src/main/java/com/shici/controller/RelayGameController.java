package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.dto.FhRankVo;
import com.shici.domain.dto.RelaySessionVo;
import com.shici.domain.dto.RelayStartReq;
import com.shici.domain.dto.RelaySubmitReq;
import com.shici.service.RelayGameService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/gameplay/relay")
public class RelayGameController {

    @Autowired
    private RelayGameService relayGameService;

    private Long getCurrentUserId(HttpServletRequest request) {
        Object userId = request.getAttribute("userId");
        if (userId == null) {
            return null;
        }
        if (userId instanceof Long) {
            return (Long) userId;
        }
        return Long.valueOf(String.valueOf(userId));
    }

    @PostMapping("/start")
    public R<RelaySessionVo> start(@RequestBody(required = false) RelayStartReq req,
                                   HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        return R.ok(relayGameService.startGame(userId, req));
    }

    @GetMapping("/session/{sessionId}")
    public R<RelaySessionVo> getSession(@PathVariable Long sessionId,
                                        HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        return R.ok(relayGameService.getSession(userId, sessionId));
    }

    @PostMapping("/submit")
    public R<Map<String, Object>> submit(@RequestBody RelaySubmitReq req,
                                         HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        return R.ok(relayGameService.submitAnswer(userId, req));
    }

    @GetMapping("/history/{sessionId}")
    public R<List<String>> history(@PathVariable Long sessionId,
                                   HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        return R.ok(relayGameService.getRecentHistory(userId, sessionId));
    }

    @GetMapping("/rank")
    public R<List<FhRankVo>> rank() {
        return R.ok(relayGameService.getRelayRankList());
    }

    @GetMapping("/rank/total")
    public R<List<FhRankVo>> totalRank() {
        return R.ok(relayGameService.getGameTotalRankList());
    }
}