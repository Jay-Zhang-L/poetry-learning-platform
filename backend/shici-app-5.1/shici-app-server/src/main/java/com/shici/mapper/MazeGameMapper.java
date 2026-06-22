package com.shici.mapper;

import com.shici.domain.dto.MazeRankVo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface MazeGameMapper {

    Map<String, Object> selectLevelBySeasonAndLevel(@Param("seasonNo") Integer seasonNo,
                                                    @Param("levelNo") Integer levelNo);

    List<Map<String, Object>> selectLevelList(@Param("seasonNo") Integer seasonNo);

    Integer countUserSolvedLine(@Param("userId") Long userId,
                                @Param("levelId") Long levelId,
                                @Param("lineIndex") Integer lineIndex);

    int insertSolvedLine(@Param("userId") Long userId,
                         @Param("seasonNo") Integer seasonNo,
                         @Param("levelId") Long levelId,
                         @Param("levelNo") Integer levelNo,
                         @Param("poemTitle") String poemTitle,
                         @Param("poemAuthor") String poemAuthor,
                         @Param("lineIndex") Integer lineIndex,
                         @Param("lineText") String lineText);

    List<Integer> selectSolvedLineIndexes(@Param("userId") Long userId,
                                          @Param("levelId") Long levelId);

    List<MazeRankVo> selectGlobalRank(@Param("seasonNo") Integer seasonNo);

    Integer countUserScoreBySeason(@Param("userId") Long userId,
                                   @Param("seasonNo") Integer seasonNo);
}