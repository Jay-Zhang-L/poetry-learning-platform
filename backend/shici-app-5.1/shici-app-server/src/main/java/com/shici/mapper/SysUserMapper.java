package com.shici.mapper;

import com.shici.domain.SysUser;
import com.shici.domain.dto.FhRankVo;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface SysUserMapper {

    @Select("""
        SELECT id,
               username,
               nickname,
               role,
               grade,
               created_at AS createdAt,
               password,
               avatar_url AS avatarUrl,
               cover_url  AS coverUrl,
               bio,
               like_count          AS likeCount,
               following_count     AS followingCount,
               follower_count      AS followerCount,
               ff_score            AS ffScore,
               ff_correct_count    AS ffCorrectCount,
               relay_score         AS relayScore,
               relay_correct_count AS relayCorrectCount,
               game_total_score    AS gameTotalScore
        FROM sys_user
        WHERE username = #{username}
        LIMIT 1
    """)
    SysUser findByUsername(@Param("username") String username);

    @Select("""
        SELECT id,
               username,
               nickname,
               role,
               grade,
               created_at AS createdAt,
               avatar_url AS avatarUrl,
               cover_url  AS coverUrl,
               bio,
               like_count          AS likeCount,
               following_count     AS followingCount,
               follower_count      AS followerCount,
               ff_score            AS ffScore,
               ff_correct_count    AS ffCorrectCount,
               relay_score         AS relayScore,
               relay_correct_count AS relayCorrectCount,
               game_total_score    AS gameTotalScore
        FROM sys_user
        WHERE id = #{id}
        LIMIT 1
    """)
    SysUser findById(@Param("id") Long id);

    @Insert("""
        INSERT INTO sys_user(username, nickname, role, grade, created_at, password,
                             avatar_url, cover_url, bio, like_count, following_count, follower_count,
                             ff_score, ff_correct_count, relay_score, relay_correct_count, game_total_score)
        VALUES(#{username}, #{nickname}, #{role}, #{grade}, NOW(), #{password},
               #{avatarUrl}, #{coverUrl}, #{bio}, 0, 0, 0,
               0, 0, 0, 0, 0)
    """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(SysUser user);

    @Update("""
        UPDATE sys_user
        SET nickname = #{nickname},
            grade    = #{grade},
            bio      = #{bio},
            avatar_url = #{avatarUrl},
            cover_url  = #{coverUrl}
        WHERE id = #{id}
    """)
    int updateProfile(SysUser user);

    @Update("""
        UPDATE sys_user
        SET ff_score = #{ffScore},
            ff_correct_count = #{ffCorrectCount},
            relay_score = #{relayScore},
            relay_correct_count = #{relayCorrectCount},
            game_total_score = #{gameTotalScore},
            game_updated_at = NOW()
        WHERE id = #{id}
    """)
    int updateGameScore(SysUser user);

    @Update("""
        UPDATE sys_user
        SET ff_score = IFNULL(ff_score, 0) + #{award},
            ff_correct_count = IFNULL(ff_correct_count, 0) + 1,
            game_total_score = IFNULL(game_total_score, 0) + #{award},
            game_updated_at = NOW()
        WHERE id = #{userId}
    """)
    int incrFhScore(@Param("userId") Long userId, @Param("award") int award);

    @Update("""
        UPDATE sys_user
        SET relay_score = IFNULL(relay_score, 0) + #{award},
            relay_correct_count = IFNULL(relay_correct_count, 0) + 1,
            game_total_score = IFNULL(game_total_score, 0) + #{award},
            game_updated_at = NOW()
        WHERE id = #{userId}
    """)
    int incrRelayScore(@Param("userId") Long userId, @Param("award") int award);

    @Update("""
        UPDATE sys_user
        SET following_count = following_count + 1
        WHERE id = #{userId}
    """)
    int incrFollowing(@Param("userId") Long userId);

    @Update("""
        UPDATE sys_user
        SET follower_count = follower_count + 1
        WHERE id = #{userId}
    """)
    int incrFollower(@Param("userId") Long userId);

    @Update("""
        UPDATE sys_user
        SET following_count = CASE
            WHEN following_count > 0 THEN following_count - 1
            ELSE 0
        END
        WHERE id = #{userId}
    """)
    int decrFollowing(@Param("userId") Long userId);

    @Update("""
        UPDATE sys_user
        SET follower_count = CASE
            WHEN follower_count > 0 THEN follower_count - 1
            ELSE 0
        END
        WHERE id = #{userId}
    """)
    int decrFollower(@Param("userId") Long userId);

    @Select("""
        SELECT id,
               username,
               nickname,
               role,
               grade,
               avatar_url AS avatarUrl,
               bio
        FROM sys_user
        WHERE nickname LIKE CONCAT('%', #{keyword}, '%')
           OR username LIKE CONCAT('%', #{keyword}, '%')
        LIMIT #{limit}
    """)
    List<SysUser> searchByKeyword(@Param("keyword") String keyword, @Param("limit") int limit);

    /**
     * 飞花令页面排行榜
     * 页面内只统计飞花令答对次数：答对一题 +1
     * 同时兼容 score / totalScore 两种前端字段读取方式
     */
    @Select("""
        SELECT id AS userId,
               username,
               nickname,
               avatar_url AS avatarUrl,
               IFNULL(ff_correct_count, 0) AS score,
               IFNULL(ff_correct_count, 0) AS totalScore,
               IFNULL(ff_correct_count, 0) AS correctCount
        FROM sys_user
        ORDER BY IFNULL(ff_correct_count, 0) DESC, id ASC
        LIMIT 50
    """)
    List<FhRankVo> selectFhRankListFromUser();

    /**
     * 接龙页面排行榜
     * 页面内只统计接龙答对次数：答对一题 +1
     * 同时兼容 score / totalScore 两种前端字段读取方式
     */
    @Select("""
        SELECT id AS userId,
               username,
               nickname,
               avatar_url AS avatarUrl,
               IFNULL(relay_correct_count, 0) AS score,
               IFNULL(relay_correct_count, 0) AS totalScore,
               IFNULL(relay_correct_count, 0) AS correctCount
        FROM sys_user
        ORDER BY IFNULL(relay_correct_count, 0) DESC, id ASC
        LIMIT 50
    """)
    List<FhRankVo> selectRelayRankListFromUser();

    /**
     * 首页总排行榜
     * 统计：
     * 飞花令答对数 + 接龙答对数 + 消消乐配对成功次数
     */
    @Select("""
    SELECT id AS userId,
           username,
           nickname,
           avatar_url AS avatarUrl,

           -- ✅ 总积分（核心）
           (IFNULL(ff_correct_count, 0)
            + IFNULL(relay_correct_count, 0)
            + IFNULL(poem_match_correct_count, 0)) AS score,

           (IFNULL(ff_correct_count, 0)
            + IFNULL(relay_correct_count, 0)
            + IFNULL(poem_match_correct_count, 0)) AS totalScore,

           -- ✅ 总正确次数（右侧“正确”列）
           (IFNULL(ff_correct_count, 0)
            + IFNULL(relay_correct_count, 0)
            + IFNULL(poem_match_correct_count, 0)) AS correctCount

    FROM sys_user

    ORDER BY (IFNULL(ff_correct_count, 0)
              + IFNULL(relay_correct_count, 0)
              + IFNULL(poem_match_correct_count, 0)) DESC,
             id ASC

    LIMIT 50
""")
    List<FhRankVo> selectGameTotalRankList();
}