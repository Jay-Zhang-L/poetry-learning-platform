package com.shici.mapper;

import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface LikeMapper {

    /**
     * 查询用户获得的点赞记录（谁赞了我的作品）
     */
    @Select("""
        SELECT
            ul.id AS id,
            ul.user_id AS likerId,
            u.username AS likerUsername,
            u.nickname AS likerNickname,
            u.avatar_url AS likerAvatar,
            ul.target_id AS workId,
            cw.title AS workTitle,
            ul.created_at AS likedAt
        FROM user_like ul
        INNER JOIN sys_user u ON ul.user_id = u.id
        INNER JOIN creation_work cw ON ul.target_id = cw.id
        WHERE cw.author_id = #{userId} AND ul.target_type = 'work'
        ORDER BY ul.created_at DESC
        LIMIT #{limit} OFFSET #{offset}
    """)
    List<Map<String, Object>> findReceivedLikes(@Param("userId") Long userId,
                                                @Param("offset") int offset,
                                                @Param("limit") int limit);

    /**
     * 统计用户获得的点赞总数
     */
    @Select("""
        SELECT COUNT(*)
        FROM user_like ul
        INNER JOIN creation_work cw ON ul.target_id = cw.id
        WHERE cw.author_id = #{userId} AND ul.target_type = 'work'
    """)
    int countReceivedLikes(@Param("userId") Long userId);

    /**
     * 查询用户点赞的记录（我赞了谁的作品）
     */
    @Select("""
        SELECT
            ul.id AS id,
            ul.user_id AS likerId,
            u.username AS likerUsername,
            u.nickname AS likerNickname,
            u.avatar_url AS likerAvatar,
            ul.target_id AS workId,
            cw.title AS workTitle,
            cw.user_id AS authorId,
            au.nickname AS authorName,
            ul.created_at AS likedAt
        FROM user_like ul
        INNER JOIN sys_user u ON ul.user_id = u.id
        INNER JOIN creation_work cw ON ul.target_id = cw.id
        LEFT JOIN sys_user au ON cw.user_id = au.id
        WHERE ul.user_id = #{userId} AND ul.target_type = 'work'
        ORDER BY ul.created_at DESC
        LIMIT #{limit} OFFSET #{offset}
    """)
    List<Map<String, Object>> findGivenLikes(@Param("userId") Long userId,
                                             @Param("offset") int offset,
                                             @Param("limit") int limit);

    /**
     * 统计用户点赞的总数
     */
    @Select("SELECT COUNT(*) FROM user_like WHERE user_id = #{userId} AND target_type = 'work'")
    int countGivenLikes(@Param("userId") Long userId);
}
