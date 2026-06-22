package com.shici.mapper;

import com.shici.domain.FhGameAnswer;
import com.shici.domain.FhGameSession;
import com.shici.domain.dto.FhRankVo;
import com.shici.domain.dto.FhSentenceVo;
import com.shici.domain.dto.FhTopicVo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface GamePlayMapper {

    /**
     * 查询飞花令主题列表
     */
    List<FhTopicVo> selectFhTopics();

    /**
     * 按主题ID查询
     */
    FhTopicVo selectFhTopicById(@Param("topicId") Long topicId);

    /**
     * 按关键字查询主题
     */
    FhTopicVo selectFhTopicByKeyword(@Param("keyword") String keyword);

    /**
     * 随机查询一个主题
     */
    FhTopicVo selectRandomFhTopic();

    /**
     * 新建游戏会话
     */
    int insertFhSession(FhGameSession session);

    /**
     * 按会话ID查询会话
     */
    FhGameSession selectFhSessionById(@Param("sessionId") Long sessionId);

    /**
     * 更新当前会话主题
     */
    int updateFhSessionTopic(@Param("sessionId") Long sessionId,
                             @Param("topicId") Long topicId,
                             @Param("keyword") String keyword);

    /**
     * 更新会话统计数据
     */
    int updateFhSessionStats(@Param("sessionId") Long sessionId,
                             @Param("score") Integer score,
                             @Param("correctCount") Integer correctCount,
                             @Param("wrongCount") Integer wrongCount,
                             @Param("skipCount") Integer skipCount);

    /**
     * 查询某关键字示例诗句
     */
    List<FhSentenceVo> selectExamplesByKeyword(@Param("keyword") String keyword);

    /**
     * 随机查询某关键字的一条示例诗句
     */
    FhSentenceVo selectRandomExampleByKeyword(@Param("keyword") String keyword);

    /**
     * 按关键字 + 标准化后的句子精确匹配
     */
    FhSentenceVo selectMatchedSentence(@Param("keyword") String keyword,
                                       @Param("sentenceClean") String sentenceClean);

    /**
     * 插入答题记录
     */
    int insertFhAnswer(FhGameAnswer answer);

    /**
     * 统计本局中某句是否已经答对过
     */
    Integer countCorrectSentenceInSession(@Param("sessionId") Long sessionId,
                                          @Param("sentenceId") Long sentenceId);

    /**
     * 查询飞花令排行榜
     */
    List<FhRankVo> selectFhRankList();

    /**
     * 搜索飞花令诗句
     */
    List<FhSentenceVo> searchFhSentences(@Param("q") String q);
}