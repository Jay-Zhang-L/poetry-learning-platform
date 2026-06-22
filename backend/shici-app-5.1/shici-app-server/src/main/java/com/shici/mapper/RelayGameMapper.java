package com.shici.mapper;

import com.shici.domain.RelayAnswerRecord;
import com.shici.domain.RelayGameSession;
import com.shici.domain.dto.RelayQuestionVo;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface RelayGameMapper {

    @Select("""
        SELECT id,
               title,
               poem_sentence AS poemSentence,
               answer_sentence AS answerSentence,
               expected_word AS expectedWord,
               author,
               dynasty,
               difficulty
        FROM relay_question_bank
        WHERE status = '0'
        ORDER BY RAND()
        LIMIT 1
    """)
    RelayQuestionVo selectRandomQuestion();

    @Select("""
        SELECT id,
               title,
               poem_sentence AS poemSentence,
               answer_sentence AS answerSentence,
               expected_word AS expectedWord,
               author,
               dynasty,
               difficulty
        FROM relay_question_bank
        WHERE status = '0'
          AND difficulty = #{difficulty}
        ORDER BY RAND()
        LIMIT 1
    """)
    RelayQuestionVo selectRandomQuestionByDifficulty(@Param("difficulty") Integer difficulty);

    @Select("""
        SELECT id,
               title,
               poem_sentence AS poemSentence,
               answer_sentence AS answerSentence,
               expected_word AS expectedWord,
               author,
               dynasty,
               difficulty
        FROM relay_question_bank
        WHERE id = #{id}
        LIMIT 1
    """)
    RelayQuestionVo selectQuestionById(@Param("id") Long id);

    @Select("""
        SELECT answer_sentence
        FROM relay_question_bank
        WHERE id = #{id}
        LIMIT 1
    """)
    String selectAnswerSentenceById(@Param("id") Long id);

    @Insert("""
        INSERT INTO relay_game_session(
            user_id, current_question_id, current_poem, expected_word,
            current_streak, total_correct, dragon_light_count, total_target_count,
            status, create_time, update_time
        )
        VALUES(
            #{userId}, #{currentQuestionId}, #{currentPoem}, #{expectedWord},
            #{currentStreak}, #{totalCorrect}, #{dragonLightCount}, #{totalTargetCount},
            #{status}, NOW(), NOW()
        )
    """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insertSession(RelayGameSession session);

    @Select("""
        SELECT id,
               user_id AS userId,
               current_question_id AS currentQuestionId,
               current_poem AS currentPoem,
               expected_word AS expectedWord,
               current_streak AS currentStreak,
               total_correct AS totalCorrect,
               dragon_light_count AS dragonLightCount,
               total_target_count AS totalTargetCount,
               status,
               create_time AS createTime,
               update_time AS updateTime
        FROM relay_game_session
        WHERE id = #{sessionId}
        LIMIT 1
    """)
    RelayGameSession selectSessionById(@Param("sessionId") Long sessionId);

    @Update("""
        UPDATE relay_game_session
        SET current_question_id = #{currentQuestionId},
            current_poem = #{currentPoem},
            expected_word = #{expectedWord},
            current_streak = #{currentStreak},
            total_correct = #{totalCorrect},
            dragon_light_count = #{dragonLightCount},
            total_target_count = #{totalTargetCount},
            status = #{status},
            update_time = NOW()
        WHERE id = #{id}
    """)
    int updateSession(RelayGameSession session);

    @Insert("""
        INSERT INTO relay_answer_record(
            session_id, user_id, question_id, poem_sentence, expected_word,
            user_answer, correct_answer, is_correct, score_delta, create_time
        )
        VALUES(
            #{sessionId}, #{userId}, #{questionId}, #{poemSentence}, #{expectedWord},
            #{userAnswer}, #{correctAnswer}, #{isCorrect}, #{scoreDelta}, NOW()
        )
    """)
    int insertAnswerRecord(RelayAnswerRecord record);

    @Select("""
        SELECT user_answer
        FROM relay_answer_record
        WHERE session_id = #{sessionId}
        ORDER BY id DESC
        LIMIT 10
    """)
    List<String> selectRecentAnswers(@Param("sessionId") Long sessionId);
}