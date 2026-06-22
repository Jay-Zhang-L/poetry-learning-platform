package com.shici.mapper;

import com.shici.domain.GameSeason;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface SeasonMapper {

    @Select("SELECT * FROM game_season WHERE status=1 ORDER BY id DESC LIMIT 1")
    GameSeason selectCurrent();

    @Select("SELECT * FROM game_season WHERE id=#{id}")
    GameSeason selectById(Long id);
}
