package com.shici.service;

import com.shici.domain.FhGameAnswer;
import com.shici.domain.FhGameSession;
import com.shici.domain.dto.*;
import com.shici.mapper.GamePlayMapper;
import com.shici.mapper.SysUserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class GamePlayService {

    @Autowired
    private GamePlayMapper gamePlayMapper;

    @Autowired
    private SysUserMapper sysUserMapper;

    public List<FhTopicVo> getFhTopics() {
        return gamePlayMapper.selectFhTopics();
    }

    public FhSessionVo startFhGame(Long userId, FhStartReq req) {
        FhTopicVo topic = null;

        if (req != null) {
            if (req.getTopicId() != null) {
                topic = gamePlayMapper.selectFhTopicById(req.getTopicId());
            } else if (StringUtils.hasText(req.getKeyword())) {
                topic = gamePlayMapper.selectFhTopicByKeyword(req.getKeyword().trim());
            }
        }

        if (topic == null) {
            topic = gamePlayMapper.selectRandomFhTopic();
        }

        if (topic == null) {
            throw new RuntimeException("当前没有可用主题");
        }

        FhGameSession session = new FhGameSession();
        session.setUserId(userId);
        session.setCurrentTopicId(topic.getId());
        session.setCurrentKeyword(topic.getKeyword());
        session.setScore(0);
        session.setCorrectCount(0);
        session.setWrongCount(0);
        session.setSkipCount(0);
        session.setStatus(1);

        gamePlayMapper.insertFhSession(session);

        FhSessionVo vo = new FhSessionVo();
        vo.setSessionId(session.getId());
        vo.setTopicId(topic.getId());
        vo.setKeyword(topic.getKeyword());
        vo.setScore(0);
        vo.setCorrectCount(0);
        vo.setWrongCount(0);
        vo.setSkipCount(0);
        vo.setExamples(gamePlayMapper.selectExamplesByKeyword(topic.getKeyword()));
        return vo;
    }

    public FhSessionVo getFhSession(Long userId, Long sessionId) {
        FhGameSession session = checkSession(userId, sessionId);

        FhSessionVo vo = new FhSessionVo();
        vo.setSessionId(session.getId());
        vo.setTopicId(session.getCurrentTopicId());
        vo.setKeyword(session.getCurrentKeyword());
        vo.setScore(session.getScore());
        vo.setCorrectCount(session.getCorrectCount());
        vo.setWrongCount(session.getWrongCount());
        vo.setSkipCount(session.getSkipCount());
        vo.setExamples(gamePlayMapper.selectExamplesByKeyword(session.getCurrentKeyword()));
        return vo;
    }

    public Map<String, Object> submitFhAnswer(Long userId, FhSubmitReq req) {
        if (req == null || req.getSessionId() == null) {
            throw new RuntimeException("会话参数不能为空");
        }

        FhGameSession session = checkSession(userId, req.getSessionId());

        if (!StringUtils.hasText(req.getSentence())) {
            throw new RuntimeException("请输入完整诗句");
        }

        String cleaned = normalize(req.getSentence());
        FhSentenceVo matched = gamePlayMapper.selectMatchedSentence(session.getCurrentKeyword(), cleaned);

        boolean correct = matched != null;
        int award = 0;
        String message;

        if (correct) {
            Integer count = gamePlayMapper.countCorrectSentenceInSession(session.getId(), matched.getId());
            if (count != null && count > 0) {
                correct = false;
                session.setWrongCount(session.getWrongCount() + 1);

                gamePlayMapper.updateFhSessionStats(
                        session.getId(),
                        session.getScore(),
                        session.getCorrectCount(),
                        session.getWrongCount(),
                        session.getSkipCount()
                );

                message = "这句你本局已经答过了，请换一句";
            } else {
                award = 1;
                session.setScore(session.getScore() + award);
                session.setCorrectCount(session.getCorrectCount() + 1);

                gamePlayMapper.updateFhSessionStats(
                        session.getId(),
                        session.getScore(),
                        session.getCorrectCount(),
                        session.getWrongCount(),
                        session.getSkipCount()
                );

                // 关键补充：把飞花令成绩同步写入 sys_user
                sysUserMapper.incrFhScore(userId, award);

                message = "回答正确，+1分";
            }
        } else {
            session.setWrongCount(session.getWrongCount() + 1);

            gamePlayMapper.updateFhSessionStats(
                    session.getId(),
                    session.getScore(),
                    session.getCorrectCount(),
                    session.getWrongCount(),
                    session.getSkipCount()
            );

            message = "回答错误，诗句不存在或不符合当前关键字";
        }

        FhGameAnswer answer = new FhGameAnswer();
        answer.setSessionId(session.getId());
        answer.setUserId(userId);
        answer.setTopicId(session.getCurrentTopicId());
        answer.setKeyword(session.getCurrentKeyword());
        answer.setUserSentence(req.getSentence());
        answer.setUserSentenceClean(cleaned);
        answer.setMatchedSentenceId(matched == null ? null : matched.getId());
        answer.setIsCorrect(correct ? 1 : 0);
        answer.setScoreAward(award);
        answer.setHintUsed(0);
        gamePlayMapper.insertFhAnswer(answer);

        Map<String, Object> map = new HashMap<>();
        map.put("correct", correct);
        map.put("scoreAward", award);
        map.put("message", message);
        map.put("score", session.getScore());
        map.put("totalScore", session.getScore());
        map.put("correctCount", session.getCorrectCount());
        map.put("wrongCount", session.getWrongCount());
        map.put("matched", matched);
        return map;
    }

    public Map<String, Object> skipFhTopic(Long userId, Long sessionId) {
        FhGameSession session = checkSession(userId, sessionId);
        FhTopicVo topic = gamePlayMapper.selectRandomFhTopic();

        if (topic == null) {
            throw new RuntimeException("暂无可切换主题");
        }

        session.setSkipCount(session.getSkipCount() + 1);

        gamePlayMapper.updateFhSessionStats(
                session.getId(),
                session.getScore(),
                session.getCorrectCount(),
                session.getWrongCount(),
                session.getSkipCount()
        );

        gamePlayMapper.updateFhSessionTopic(session.getId(), topic.getId(), topic.getKeyword());

        Map<String, Object> map = new HashMap<>();
        map.put("topicId", topic.getId());
        map.put("keyword", topic.getKeyword());
        map.put("examples", gamePlayMapper.selectExamplesByKeyword(topic.getKeyword()));
        map.put("score", session.getScore());
        map.put("skipCount", session.getSkipCount());
        return map;
    }

    public Map<String, Object> getFhHint(Long userId, Long sessionId) {
        FhGameSession session = checkSession(userId, sessionId);
        FhSentenceVo example = gamePlayMapper.selectRandomExampleByKeyword(session.getCurrentKeyword());

        Map<String, Object> map = new HashMap<>();
        if (example == null) {
            map.put("hint", "当前主题暂无提示");
            return map;
        }

        String sentence = example.getSentence();
        String hint = sentence.length() >= 2 ? sentence.substring(0, 2) + "..." : sentence;

        map.put("hint", hint);
        map.put("fullSentence", sentence);
        map.put("poemTitle", example.getPoemTitle());
        map.put("author", example.getAuthor());
        return map;
    }

    public List<FhRankVo> getFhRankList() {
        return gamePlayMapper.selectFhRankList();
    }

    public List<FhSentenceVo> searchFhSentences(String q) {
        if (!StringUtils.hasText(q)) {
            return List.of();
        }
        return gamePlayMapper.searchFhSentences(q.trim());
    }

    private FhGameSession checkSession(Long userId, Long sessionId) {
        FhGameSession session = gamePlayMapper.selectFhSessionById(sessionId);
        if (session == null) {
            throw new RuntimeException("游戏会话不存在");
        }
        if (!session.getUserId().equals(userId)) {
            throw new RuntimeException("无权操作该会话");
        }
        if (session.getStatus() == null || session.getStatus() != 1) {
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
}