package com.shici.mapper;

import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface RankMapper {

    @Select("""
      SELECT s.user_id, s.score, s.correct_count, s.wrong_count
      FROM season_player_stat s
      WHERE s.season_id = #{seasonId}
      ORDER BY s.score DESC, s.correct_count DESC
      LIMIT #{top}
    """)
    List<Map<String,Object>> topRank(@Param("seasonId") Long seasonId, @Param("top") Integer top);

    /** 今日排行榜：根据今天的game_record统计 */
    @Select("""
      SELECT user_id, 
             SUM(score_add) as score,
             SUM(CASE WHEN is_correct=1 THEN 1 ELSE 0 END) as correct_count,
             SUM(CASE WHEN is_correct=0 THEN 1 ELSE 0 END) as wrong_count
      FROM game_record
      WHERE season_id = #{seasonId}
        AND DATE(created_at) = CURDATE()
      GROUP BY user_id
      ORDER BY score DESC, correct_count DESC
      LIMIT #{top}
    """)
    List<Map<String,Object>> todayRank(@Param("seasonId") Long seasonId, @Param("top") Integer top);

    /** 本周排行榜：根据本周的game_record统计 */
    @Select("""
      SELECT user_id, 
             SUM(score_add) as score,
             SUM(CASE WHEN is_correct=1 THEN 1 ELSE 0 END) as correct_count,
             SUM(CASE WHEN is_correct=0 THEN 1 ELSE 0 END) as wrong_count
      FROM game_record
      WHERE season_id = #{seasonId}
        AND YEARWEEK(created_at, 1) = YEARWEEK(CURDATE(), 1)
      GROUP BY user_id
      ORDER BY score DESC, correct_count DESC
      LIMIT #{top}
    """)
    List<Map<String,Object>> weekRank(@Param("seasonId") Long seasonId, @Param("top") Integer top);

    /** 本月排行榜：根据本月的game_record统计 */
    @Select("""
      SELECT user_id, 
             SUM(score_add) as score,
             SUM(CASE WHEN is_correct=1 THEN 1 ELSE 0 END) as correct_count,
             SUM(CASE WHEN is_correct=0 THEN 1 ELSE 0 END) as wrong_count
      FROM game_record
      WHERE season_id = #{seasonId}
        AND YEAR(created_at) = YEAR(CURDATE())
        AND MONTH(created_at) = MONTH(CURDATE())
      GROUP BY user_id
      ORDER BY score DESC, correct_count DESC
      LIMIT #{top}
    """)
    List<Map<String,Object>> monthRank(@Param("seasonId") Long seasonId, @Param("top") Integer top);

    @Select("SELECT COUNT(1) FROM season_player_stat WHERE season_id=#{seasonId} AND user_id=#{userId}")
    int exists(@Param("seasonId") Long seasonId, @Param("userId") Long userId);

    /** 关键：补齐这个方法，Service 才不会报红 */
    @Insert("""
      INSERT INTO season_player_stat(season_id,user_id,score,correct_count,wrong_count)
      VALUES(#{seasonId},#{userId},0,0,0)
    """)
    int insertEmpty(@Param("seasonId") Long seasonId, @Param("userId") Long userId);

    @Update("""
      UPDATE season_player_stat
      SET score = score + #{scoreAdd},
          correct_count = correct_count + #{correctAdd},
          wrong_count = wrong_count + #{wrongAdd}
      WHERE season_id=#{seasonId} AND user_id=#{userId}
    """)
    int updateStat(@Param("seasonId") Long seasonId, @Param("userId") Long userId,
                   @Param("scoreAdd") Integer scoreAdd,
                   @Param("correctAdd") Integer correctAdd,
                   @Param("wrongAdd") Integer wrongAdd);
}
