package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.dto.*;
import com.shici.service.PoetQuizService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 诗人形象测评控制器
 */
@RestController
@RequestMapping("/api/gameplay/poet-quiz")
public class PoetQuizController {

    @Autowired
    private PoetQuizService poetQuizService;

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

    /**
     * 获取问卷列表
     */
    @GetMapping("/quizzes")
    public R<List<PoetQuizListVo>> getQuizList() {
        return R.ok(poetQuizService.getQuizList());
    }

    /**
     * 获取问卷详情（含题目和选项）
     */
    @GetMapping("/quiz/{quizId}")
    public R<PoetQuizDetailVo> getQuizDetail(@PathVariable Long quizId) {
        return R.ok(poetQuizService.getQuizDetail(quizId));
    }

    /**
     * 开始一次测评
     */
    @PostMapping("/start")
    public R<PoetQuizAttemptVo> startQuiz(@RequestBody PoetQuizStartReq req,
                                          HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        return R.ok(poetQuizService.startQuiz(userId, req));
    }

    /**
     * 提交某一题答案
     */
    @PostMapping("/answer")
    public R<PoetQuizAnswerResultVo> submitAnswer(@RequestBody PoetQuizAnswerReq req,
                                                  HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        return R.ok(poetQuizService.submitAnswer(userId, req));
    }

    /**
     * 提交问卷并计算结果
     */
    @PostMapping("/submit")
    public R<PoetQuizResultVo> submitQuiz(@RequestBody PoetQuizSubmitReq req,
                                          HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        return R.ok(poetQuizService.submitQuiz(userId, req));
    }

    /**
     * 查询某次测评结果
     */
    @GetMapping("/attempt/{attemptId}")
    public R<PoetQuizResultVo> getAttemptResult(@PathVariable Long attemptId,
                                                HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        return R.ok(poetQuizService.getAttemptResult(userId, attemptId));
    }

    @DeleteMapping("/attempt/{attemptId}")
    public R<Void> deleteAttempt(@PathVariable Long attemptId, HttpServletRequest request) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        poetQuizService.deleteAttempt(userId, attemptId);
        return R.ok();
    }

    @GetMapping("/attempts/my")
    public R<PageResp<PoetQuizAttemptHistoryVo>> getMyAttempts(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "20") int size,
            @RequestParam(value = "status", required = false) String status,
            HttpServletRequest request
    ) {
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            return R.fail("请先登录");
        }
        return R.ok(poetQuizService.getMyAttempts(userId, page, size, status));
    }
    /**
     * 查询诗人形象详情
     */
    @GetMapping("/poets/{poetId}")
    public R<PoetPersonaVo> getPoetPersona(@PathVariable Long poetId) {
        return R.ok(poetQuizService.getPoetPersona(poetId));
    }
}