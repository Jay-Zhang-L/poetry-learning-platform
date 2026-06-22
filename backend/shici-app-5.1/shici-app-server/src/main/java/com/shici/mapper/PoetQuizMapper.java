package com.shici.mapper;

import com.shici.domain.PoetQuizAnswer;
import com.shici.domain.PoetQuizAttempt;
import com.shici.domain.PoetQuizOption;
import com.shici.domain.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 诗人形象测评 Mapper
 */
@Mapper
public interface PoetQuizMapper {

    /**
     * 查询问卷列表
     */
    List<PoetQuizListVo> selectQuizList();

    /**
     * 查询问卷详情
     */
    PoetQuizDetailVo selectQuizDetail(@Param("quizId") Long quizId);

    /**
     * 查询问卷题目列表
     */
    List<PoetQuizQuestionVo> selectQuestionsByQuizId(@Param("quizId") Long quizId);

    /**
     * 查询题目选项列表
     */
    List<PoetQuizOptionVo> selectOptionsByQuestionId(@Param("questionId") Long questionId);

    /**
     * 查询问卷题目数量
     */
    Integer countQuestionsByQuizId(@Param("quizId") Long quizId);

    /**
     * 插入测评记录
     */
    int insertAttempt(PoetQuizAttempt attempt);

    /**
     * 查询测评记录
     */
    PoetQuizAttempt selectAttemptById(@Param("attemptId") Long attemptId);

    /**
     * 更新测评记录答题数
     */
    int updateAttemptAnsweredCount(@Param("attemptId") Long attemptId, @Param("answeredCount") Integer answeredCount);

    /**
     * 更新测评记录完成状态
     */
    int updateAttemptFinished(@Param("attemptId") Long attemptId,
                              @Param("resultPoetId") Long resultPoetId,
                              @Param("resultScore") Integer resultScore,
                              @Param("resultScoresSnapshot") String resultScoresSnapshot);

    /**
     * 插入或更新答题记录
     */
    int insertOrUpdateAnswer(PoetQuizAnswer answer);

    /**
     * 查询选项详情（含poetId和score）
     */
    PoetQuizOption selectOptionById(@Param("optionId") Long optionId);

    /**
     * 查询某次测评的所有答案按诗人聚合分数
     */
    List<PoetScoreVo> selectScoresByAttemptId(@Param("attemptId") Long attemptId);

    /**
     * 查询诗人形象详情
     */
    PoetPersonaVo selectPoetPersonaById(@Param("poetId") Long poetId);

    /**
     * 查询所有诗人形象（用于排行榜）
     */
    List<PoetPersonaVo> selectAllPoetPersonas();

    /**
     * 统计用户对某题是否已答
     */
    Integer countAnswerByAttemptAndQuestion(@Param("attemptId") Long attemptId,
                                            @Param("questionId") Long questionId);
    Long countMyAttempts(@Param("userId") Long userId, @Param("status") String status);

    List<PoetQuizAttemptHistoryVo> selectMyAttempts(@Param("userId") Long userId,
                                                    @Param("status") String status,
                                                    @Param("offset") int offset,
                                                    @Param("limit") int limit);

    int deleteAnswersByAttemptId(@Param("attemptId") Long attemptId);

    int deleteAttemptByIdAndUserId(@Param("attemptId") Long attemptId, @Param("userId") Long userId);
}