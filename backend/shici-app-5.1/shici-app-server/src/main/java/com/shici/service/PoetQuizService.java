package com.shici.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shici.domain.PoetQuizAnswer;
import com.shici.domain.PoetQuizAttempt;
import com.shici.domain.PoetQuizOption;
import com.shici.domain.dto.*;
import com.shici.mapper.PoetQuizMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 诗人形象测评服务
 */
@Service
public class PoetQuizService {

    @Autowired
    private PoetQuizMapper poetQuizMapper;

    @Autowired
    private ObjectMapper objectMapper;

    /**
     * 获取问卷列表
     */
    public List<PoetQuizListVo> getQuizList() {
        return poetQuizMapper.selectQuizList();
    }

    /**
     * 获取问卷详情（含题目和选项）
     */
    public PoetQuizDetailVo getQuizDetail(Long quizId) {
        PoetQuizDetailVo detail = poetQuizMapper.selectQuizDetail(quizId);
        if (detail == null) {
            throw new RuntimeException("问卷不存在");
        }

        List<PoetQuizQuestionVo> questions = poetQuizMapper.selectQuestionsByQuizId(quizId);

        for (PoetQuizQuestionVo question : questions) {
            List<PoetQuizOptionVo> options = poetQuizMapper.selectOptionsByQuestionId(question.getQuestionId());
            question.setOptions(options);
        }

        detail.setQuestions(questions);
        return detail;
    }

    /**
     * 开始一次测评
     */
    @Transactional
    public PoetQuizAttemptVo startQuiz(Long userId, PoetQuizStartReq req) {
        if (req == null || req.getQuizId() == null) {
            throw new RuntimeException("问卷ID不能为空");
        }

        Integer questionCount = poetQuizMapper.countQuestionsByQuizId(req.getQuizId());
        if (questionCount == null || questionCount == 0) {
            throw new RuntimeException("该问卷暂无题目");
        }

        PoetQuizAttempt attempt = new PoetQuizAttempt();
        attempt.setQuizId(req.getQuizId());
        attempt.setUserId(userId);
        attempt.setTotalQuestions(questionCount);
        attempt.setAnsweredCount(0);
        attempt.setStatus("in_progress");

        poetQuizMapper.insertAttempt(attempt);

        PoetQuizAttemptVo vo = new PoetQuizAttemptVo();
        vo.setAttemptId(attempt.getId());
        vo.setQuizId(req.getQuizId());
        vo.setTotalQuestions(questionCount);
        vo.setAnsweredCount(0);
        vo.setStartedAt(attempt.getStartedAt());
        return vo;
    }

    /**
     * 提交某一题答案
     */
    @Transactional
    public PoetQuizAnswerResultVo submitAnswer(Long userId, PoetQuizAnswerReq req) {
        if (req == null || req.getAttemptId() == null || req.getQuestionId() == null || req.getOptionId() == null) {
            throw new RuntimeException("参数不完整");
        }

        PoetQuizAttempt attempt = checkAttempt(userId, req.getAttemptId());

        PoetQuizOption option = poetQuizMapper.selectOptionById(req.getOptionId());
        if (option == null) {
            throw new RuntimeException("选项不存在");
        }

        Integer answered = poetQuizMapper.countAnswerByAttemptAndQuestion(req.getAttemptId(), req.getQuestionId());
        boolean isNewAnswer = answered == null || answered == 0;

        PoetQuizAnswer answer = new PoetQuizAnswer();
        answer.setAttemptId(req.getAttemptId());
        answer.setQuestionId(req.getQuestionId());
        answer.setOptionId(req.getOptionId());
        poetQuizMapper.insertOrUpdateAnswer(answer);

        if (isNewAnswer) {
            int newAnsweredCount = attempt.getAnsweredCount() + 1;
            poetQuizMapper.updateAttemptAnsweredCount(req.getAttemptId(), newAnsweredCount);
            attempt.setAnsweredCount(newAnsweredCount);
        }

        PoetQuizAnswerResultVo vo = new PoetQuizAnswerResultVo();
        vo.setAttemptId(req.getAttemptId());
        vo.setAnsweredCount(attempt.getAnsweredCount());
        vo.setTotalQuestions(attempt.getTotalQuestions());
        vo.setIsFinished(attempt.getAnsweredCount().equals(attempt.getTotalQuestions()));
        return vo;
    }

    /**
     * 提交问卷并计算结果
     */
    @Transactional
    public PoetQuizResultVo submitQuiz(Long userId, PoetQuizSubmitReq req) {
        if (req == null || req.getAttemptId() == null) {
            throw new RuntimeException("测评ID不能为空");
        }

        PoetQuizAttempt attempt = checkAttempt(userId, req.getAttemptId());

        if (!attempt.getAnsweredCount().equals(attempt.getTotalQuestions())) {
            throw new RuntimeException("还有题目未完成，请完成所有题目后再提交");
        }

        List<PoetScoreVo> scoreBoard = poetQuizMapper.selectScoresByAttemptId(req.getAttemptId());
        if (scoreBoard == null || scoreBoard.isEmpty()) {
            throw new RuntimeException("未找到答题记录");
        }

        Long resultPoetId = scoreBoard.get(0).getPoetId();
        Integer resultScore = scoreBoard.get(0).getScore();

        String scoresSnapshot;
        try {
            scoresSnapshot = objectMapper.writeValueAsString(scoreBoard);
        } catch (JsonProcessingException e) {
            scoresSnapshot = "[]";
        }

        poetQuizMapper.updateAttemptFinished(req.getAttemptId(), resultPoetId, resultScore, scoresSnapshot);

        PoetQuizAttempt refreshed = poetQuizMapper.selectAttemptById(req.getAttemptId());

        PoetQuizResultVo result = new PoetQuizResultVo();
        result.setAttemptId(req.getAttemptId());
        result.setQuizId(attempt.getQuizId());
        result.setResultPoet(poetQuizMapper.selectPoetPersonaById(resultPoetId));
        result.setScoreBoard(scoreBoard);
        result.setFinishedAt(refreshed == null ? null : refreshed.getFinishedAt());
        return result;
    }

    /**
     * 查询某次测评结果
     */
    public PoetQuizResultVo getAttemptResult(Long userId, Long attemptId) {
        PoetQuizAttempt attempt = checkAttempt(userId, attemptId);

        if (!"finished".equals(attempt.getStatus())) {
            throw new RuntimeException("测评尚未完成");
        }

        List<PoetScoreVo> scoreBoard = poetQuizMapper.selectScoresByAttemptId(attemptId);

        PoetQuizResultVo result = new PoetQuizResultVo();
        result.setAttemptId(attemptId);
        result.setQuizId(attempt.getQuizId());
        result.setResultPoet(poetQuizMapper.selectPoetPersonaById(attempt.getResultPoetId()));
        result.setScoreBoard(scoreBoard);
        result.setFinishedAt(attempt.getFinishedAt());
        return result;
    }

    public PageResp<PoetQuizAttemptHistoryVo> getMyAttempts(Long userId, int page, int size, String status) {
        int p = Math.max(page, 1);
        int s = Math.max(size, 1);
        int offset = (p - 1) * s;

        String st = (status == null || status.isBlank()) ? "finished" : status;

        long total = poetQuizMapper.countMyAttempts(userId, st);
        List<PoetQuizAttemptHistoryVo> items = poetQuizMapper.selectMyAttempts(userId, st, offset, s);

        return PageResp.of(total, p, s, items);
    }

    @Transactional
    public void deleteAttempt(Long userId, Long attemptId) {
        if (attemptId == null) {
            throw new RuntimeException("测评ID不能为空");
        }

        checkAttempt(userId, attemptId);

        poetQuizMapper.deleteAnswersByAttemptId(attemptId);
        int deleted = poetQuizMapper.deleteAttemptByIdAndUserId(attemptId, userId);
        if (deleted <= 0) {
            throw new RuntimeException("删除失败");
        }
    }

    /**
     * 查询诗人形象详情
     */
    public PoetPersonaVo getPoetPersona(Long poetId) {
        PoetPersonaVo vo = poetQuizMapper.selectPoetPersonaById(poetId);
        if (vo == null) {
            throw new RuntimeException("诗人形象不存在");
        }
        return vo;
    }

    /**
     * 检查测评记录
     */
    private PoetQuizAttempt checkAttempt(Long userId, Long attemptId) {
        PoetQuizAttempt attempt = poetQuizMapper.selectAttemptById(attemptId);
        if (attempt == null) {
            throw new RuntimeException("测评记录不存在");
        }
        if (!attempt.getUserId().equals(userId)) {
            throw new RuntimeException("无权访问该测评记录");
        }
        return attempt;
    }
}