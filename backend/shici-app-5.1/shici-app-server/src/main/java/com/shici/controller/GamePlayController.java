package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.dto.*;
import com.shici.service.GamePlayService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/gameplay")
public class GamePlayController {

    @Autowired
    private GamePlayService gamePlayService;

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

    @GetMapping("/feihua/topics")
    public R<List<FhTopicVo>> getFhTopics() {
        return R.ok(gamePlayService.getFhTopics());
    }

    @PostMapping("/feihua/start")
    public R<FhSessionVo> startFhGame(@RequestBody(required = false) FhStartReq req,
                                      HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        if (req == null) {
            req = new FhStartReq();
        }
        return R.ok(gamePlayService.startFhGame(userId, req));
    }

    @GetMapping("/feihua/session/{sessionId}")
    public R<FhSessionVo> getFhSession(@PathVariable Long sessionId,
                                       HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        return R.ok(gamePlayService.getFhSession(userId, sessionId));
    }

    @PostMapping("/feihua/submit")
    public R<Map<String, Object>> submitFhAnswer(@RequestBody FhSubmitReq req,
                                                 HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        return R.ok(gamePlayService.submitFhAnswer(userId, req));
    }

    @PostMapping("/feihua/skip/{sessionId}")
    public R<Map<String, Object>> skipFh(@PathVariable Long sessionId,
                                         HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        return R.ok(gamePlayService.skipFhTopic(userId, sessionId));
    }

    @PostMapping("/feihua/hint/{sessionId}")
    public R<Map<String, Object>> hintFh(@PathVariable Long sessionId,
                                         HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        return R.ok(gamePlayService.getFhHint(userId, sessionId));
    }

    @GetMapping("/feihua/rank")
    public R<List<FhRankVo>> getFhRank() {
        return R.ok(gamePlayService.getFhRankList());
    }

    @GetMapping("/feihua/search")
    public R<List<FhSentenceVo>> searchFh(@RequestParam String q) {
        return R.ok(gamePlayService.searchFhSentences(q));
    }
}