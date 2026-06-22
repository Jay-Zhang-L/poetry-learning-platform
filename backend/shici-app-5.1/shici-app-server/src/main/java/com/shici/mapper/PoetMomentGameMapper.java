package com.shici.mapper;

import com.shici.domain.dto.poetmoment.PoetMomentGameMomentRow;
import com.shici.domain.dto.poetmoment.PoetMomentGameOptionRow;
import com.shici.domain.dto.poetmoment.PoetMomentGamePoetRow;
import com.shici.domain.dto.poetmoment.PoetMomentGameRecordRow;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface PoetMomentGameMapper {

    PoetMomentGameMomentRow selectRandomMomentWithOptions();

    List<PoetMomentGameOptionRow> selectOptionsByMomentId(@Param("momentId") Integer momentId);

    Integer selectCorrectPoetIdByMomentId(@Param("momentId") Integer momentId);

    int countOptionByMomentAndPoet(@Param("momentId") Integer momentId,
                                   @Param("poetId") Integer poetId);

    PoetMomentGamePoetRow selectPoetById(@Param("poetId") Integer poetId);

    int insertGameRecord(@Param("userId") String userId,
                         @Param("momentId") Integer momentId,
                         @Param("selectedPoetId") Integer selectedPoetId,
                         @Param("isCorrect") boolean isCorrect);

    int countAttemptsByUser(@Param("userId") String userId);

    int countCorrectByUser(@Param("userId") String userId);

    List<PoetMomentGameRecordRow> selectRecordsByUserId(@Param("userId") String userId);

    List<PoetMomentGameMomentRow> selectMomentsByPoetId(@Param("poetId") Integer poetId);
}