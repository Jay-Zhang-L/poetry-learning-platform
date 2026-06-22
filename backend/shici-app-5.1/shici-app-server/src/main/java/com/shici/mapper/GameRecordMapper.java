package com.shici.mapper;

import com.shici.domain.GameRecord;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;

@Mapper
public interface GameRecordMapper {

    @Insert("""
      INSERT INTO game_record(season_id,user_id,mode,prompt,answer,is_correct,score_add,reason)
      VALUES(#{seasonId},#{userId},#{mode},#{prompt},#{answer},#{isCorrect},#{scoreAdd},#{reason})
    """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(GameRecord r);
}
