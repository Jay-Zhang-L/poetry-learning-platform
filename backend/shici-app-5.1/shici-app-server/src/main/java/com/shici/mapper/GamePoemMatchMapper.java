package com.shici.mapper;

import com.shici.domain.dto.GamePoemMatchFragmentDto;
import com.shici.domain.dto.GameRankItemDto;
import com.shici.domain.entity.GamePoemMatchRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface GamePoemMatchMapper {

    Map<String, Object> selectLevelById(@Param("levelId") Long levelId);

    List<GamePoemMatchFragmentDto> selectFragmentsByLevelId(@Param("levelId") Long levelId);

    int insertRecord(GamePoemMatchRecord record);

    int increaseRecordScore(@Param("recordId") Long recordId,
                            @Param("usedSeconds") Integer usedSeconds);

    int finishRecord(@Param("recordId") Long recordId,
                     @Param("passed") Integer passed,
                     @Param("usedSeconds") Integer usedSeconds);

    int updateUserPoemMatchScore(@Param("userId") Long userId,
                                 @Param("score") Integer score,
                                 @Param("matchedCount") Integer matchedCount,
                                 @Param("passed") Integer passed);

    List<GameRankItemDto> selectGameTotalRank();
}