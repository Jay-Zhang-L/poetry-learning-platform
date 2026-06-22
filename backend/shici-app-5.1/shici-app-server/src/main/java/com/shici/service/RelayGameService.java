package com.shici.service;

import com.shici.domain.RelayAnswerRecord;
import com.shici.domain.RelayGameSession;
import com.shici.domain.SysUser;
import com.shici.domain.dto.FhRankVo;
import com.shici.domain.dto.RelayQuestionVo;
import com.shici.domain.dto.RelaySessionVo;
import com.shici.domain.dto.RelayStartReq;
import com.shici.domain.dto.RelaySubmitReq;
import com.shici.mapper.RelayGameMapper;
import com.shici.mapper.SysUserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class RelayGameService {

    @Autowired
    private RelayGameMapper relayGameMapper;

    @Autowired
    private SysUserMapper sysUserMapper;

    /**
     * 每题固定加分
     */
    private static final int SCORE_PER_QUESTION = 10;

    public RelaySessionVo startGame(Long userId, RelayStartReq req) {
        RelayQuestionVo question;

        if (req != null && req.getDifficulty() != null) {
            question = relayGameMapper.selectRandomQuestionByDifficulty(req.getDifficulty());
            if (question == null) {
                question = relayGameMapper.selectRandomQuestion();
            }
        } else {
            question = relayGameMapper.selectRandomQuestion();
        }

        if (question == null) {
            throw new RuntimeException("当前没有可用接龙题目");
        }

        RelayGameSession session = new RelayGameSession();
        session.setUserId(userId);
        session.setCurrentQuestionId(question.getId());
        session.setCurrentPoem(question.getPoemSentence());
        session.setExpectedWord(resolveExpectedWord(question));
        session.setCurrentStreak(0);
        session.setTotalCorrect(0);
        session.setDragonLightCount(0);
        session.setTotalTargetCount(12);
        session.setStatus("ONGOING");

        relayGameMapper.insertSession(session);

        SysUser user = sysUserMapper.findById(userId);

        RelaySessionVo vo = new RelaySessionVo();
        vo.setSessionId(session.getId());
        vo.setQuestionId(question.getId());
        vo.setPoemSentence(question.getPoemSentence());
        vo.setExpectedWord(resolveExpectedWord(question));
        vo.setAuthor(safe(question.getAuthor()));
        vo.setDynasty(safe(question.getDynasty()));

        vo.setCurrentStreak(0);
        vo.setTotalCorrect(0);
        vo.setDragonLightCount(0);
        vo.setTotalTargetCount(12);

        vo.setRelayScore(user == null || user.getRelayScore() == null ? 0 : user.getRelayScore());
        vo.setTotalScore(user == null || user.getGameTotalScore() == null ? 0 : user.getGameTotalScore());
        vo.setScorePerQuestion(SCORE_PER_QUESTION);

        vo.setTips(List.of(
                "请输入完整下句",
                "答对一次龙鳞+1",
                "累计分数写入总榜"
        ));
        return vo;
    }

    public RelaySessionVo getSession(Long userId, Long sessionId) {
        RelayGameSession session = checkSession(userId, sessionId);
        RelayQuestionVo question = relayGameMapper.selectQuestionById(session.getCurrentQuestionId());
        SysUser user = sysUserMapper.findById(userId);

        RelaySessionVo vo = new RelaySessionVo();
        vo.setSessionId(session.getId());
        vo.setQuestionId(session.getCurrentQuestionId());
        vo.setPoemSentence(session.getCurrentPoem());
        vo.setExpectedWord(StringUtils.hasText(session.getExpectedWord())
                ? session.getExpectedWord()
                : resolveExpectedWord(question));

        vo.setAuthor(question == null ? "" : safe(question.getAuthor()));
        vo.setDynasty(question == null ? "" : safe(question.getDynasty()));

        vo.setCurrentStreak(defaultZero(session.getCurrentStreak()));
        vo.setTotalCorrect(defaultZero(session.getTotalCorrect()));
        vo.setDragonLightCount(defaultZero(session.getDragonLightCount()));
        vo.setTotalTargetCount(defaultZero(session.getTotalTargetCount()) == 0 ? 12 : session.getTotalTargetCount());

        vo.setRelayScore(user == null || user.getRelayScore() == null ? 0 : user.getRelayScore());
        vo.setTotalScore(user == null || user.getGameTotalScore() == null ? 0 : user.getGameTotalScore());
        vo.setScorePerQuestion(SCORE_PER_QUESTION);

        vo.setTips(List.of(
                question == null ? "" : "作者：" + safe(question.getAuthor()),
                question == null ? "" : "朝代：" + safe(question.getDynasty())
        ));
        return vo;
    }

    public Map<String, Object> submitAnswer(Long userId, RelaySubmitReq req) {
        if (req == null || req.getSessionId() == null) {
            throw new RuntimeException("会话参数不能为空");
        }

        RelayGameSession session = checkSession(userId, req.getSessionId());

        if (!StringUtils.hasText(req.getAnswer())) {
            throw new RuntimeException("请输入答案");
        }

        // 先保存“当前题”信息，避免切题后历史记录错乱
        Long currentQuestionId = session.getCurrentQuestionId();
        String currentPoem = session.getCurrentPoem();
        String currentExpectedWord = session.getExpectedWord();

        RelayQuestionVo currentQuestion = relayGameMapper.selectQuestionById(currentQuestionId);
        if (!StringUtils.hasText(currentExpectedWord)) {
            currentExpectedWord = resolveExpectedWord(currentQuestion);
        }

        String userAnswer = normalize(req.getAnswer());
        String correctAnswer = normalize(relayGameMapper.selectAnswerSentenceById(currentQuestionId));

        boolean correct = userAnswer.equals(correctAnswer);
        int award = 0;
        String message;

        if (correct) {
            award = SCORE_PER_QUESTION;

            session.setCurrentStreak(defaultZero(session.getCurrentStreak()) + 1);
            session.setTotalCorrect(defaultZero(session.getTotalCorrect()) + 1);
            session.setDragonLightCount(defaultZero(session.getDragonLightCount()) + 1);

            RelayQuestionVo next = relayGameMapper.selectRandomQuestion();
            if (next == null) {
                session.setStatus("FINISHED");
            } else {
                session.setCurrentQuestionId(next.getId());
                session.setCurrentPoem(next.getPoemSentence());
                session.setExpectedWord(resolveExpectedWord(next));
            }

            relayGameMapper.updateSession(session);
            sysUserMapper.incrRelayScore(userId, award);

            message = "回答正确，龙鳞点亮 +" + 1;
        } else {
            session.setCurrentStreak(0);
            relayGameMapper.updateSession(session);
            message = "回答错误，请再试一次";
        }

        // 历史记录必须记“本次作答的题”，不能记切换后的下一题
        RelayAnswerRecord record = new RelayAnswerRecord();
        record.setSessionId(session.getId());
        record.setUserId(userId);
        record.setQuestionId(currentQuestionId);
        record.setPoemSentence(currentPoem);
        record.setExpectedWord(currentExpectedWord);
        record.setUserAnswer(req.getAnswer());
        record.setCorrectAnswer(correctAnswer);
        record.setIsCorrect(correct ? 1 : 0);
        record.setScoreDelta(award);
        relayGameMapper.insertAnswerRecord(record);

        SysUser user = sysUserMapper.findById(userId);
        RelayQuestionVo latestQuestion = relayGameMapper.selectQuestionById(session.getCurrentQuestionId());

        Map<String, Object> map = new HashMap<>();
        map.put("correct", correct);
        map.put("scoreAward", award);
        map.put("message", message);

        map.put("sessionId", session.getId());
        map.put("questionId", session.getCurrentQuestionId());

        map.put("currentStreak", defaultZero(session.getCurrentStreak()));
        map.put("totalCorrect", defaultZero(session.getTotalCorrect()));
        map.put("dragonLightCount", defaultZero(session.getDragonLightCount()));
        map.put("totalTargetCount", defaultZero(session.getTotalTargetCount()) == 0 ? 12 : session.getTotalTargetCount());

        map.put("relayScore", user == null || user.getRelayScore() == null ? 0 : user.getRelayScore());
        map.put("totalScore", user == null || user.getGameTotalScore() == null ? 0 : user.getGameTotalScore());
        map.put("scorePerQuestion", SCORE_PER_QUESTION);

        map.put("nextPoemSentence", session.getCurrentPoem());
        map.put("nextExpectedWord", StringUtils.hasText(session.getExpectedWord())
                ? session.getExpectedWord()
                : resolveExpectedWord(latestQuestion));

        map.put("author", latestQuestion == null ? "" : safe(latestQuestion.getAuthor()));
        map.put("dynasty", latestQuestion == null ? "" : safe(latestQuestion.getDynasty()));

        return map;
    }

    public List<String> getRecentHistory(Long userId, Long sessionId) {
        checkSession(userId, sessionId);
        return relayGameMapper.selectRecentAnswers(sessionId);
    }

    public List<FhRankVo> getRelayRankList() {
        return sysUserMapper.selectRelayRankListFromUser();
    }

    public List<FhRankVo> getGameTotalRankList() {
        return sysUserMapper.selectGameTotalRankList();
    }

    private RelayGameSession checkSession(Long userId, Long sessionId) {
        RelayGameSession session = relayGameMapper.selectSessionById(sessionId);
        if (session == null) {
            throw new RuntimeException("接龙会话不存在");
        }
        if (!session.getUserId().equals(userId)) {
            throw new RuntimeException("无权操作该会话");
        }
        if (!"ONGOING".equals(session.getStatus())) {
            throw new RuntimeException("当前会话已结束");
        }
        return session;
    }

    private String normalize(String text) {
        return text == null ? "" :
                text.replace("，", "")
                        .replace("。", "")
                        .replace("！", "")
                        .replace("？", "")
                        .replace("、", "")
                        .replace("；", "")
                        .replace("：", "")
                        .replace(",", "")
                        .replace(".", "")
                        .replace("!", "")
                        .replace("?", "")
                        .replace(" ", "")
                        .replace("\n", "")
                        .trim();
    }

    /**
     * 后端优先使用表中的 expected_word；
     * 如果没填，就自动取上句最后一个汉字给前端显示。
     */
    private String resolveExpectedWord(RelayQuestionVo question) {
        if (question == null) {
            return "";
        }
        if (StringUtils.hasText(question.getExpectedWord())) {
            return question.getExpectedWord().trim();
        }
        return getLastChineseChar(question.getPoemSentence());
    }

    private String getLastChineseChar(String text) {
        if (!StringUtils.hasText(text)) {
            return "";
        }
        String cleaned = text.replaceAll("[，。！？；：、“”‘’（）()《》〈〉【】\\[\\]\\s]", "").trim();
        for (int i = cleaned.length() - 1; i >= 0; i--) {
            char c = cleaned.charAt(i);
            if (String.valueOf(c).matches("[\\u4e00-\\u9fa5]")) {
                return String.valueOf(c);
            }
        }
        return "";
    }

    private Integer defaultZero(Integer value) {
        return value == null ? 0 : value;
    }

    private String safe(String v) {
        return v == null ? "" : v;
    }
}