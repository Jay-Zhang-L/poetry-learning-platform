package com.shici.mapper;

import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface UserLikeMapper {

    @Insert("""
        INSERT INTO user_like(user_id, target_type, target_id, created_at)
        VALUES(#{userId}, #{type}, #{targetId}, NOW())
    """)
    int like(@Param("userId") Long userId, @Param("type") String type, @Param("targetId") Long targetId);

    @Delete("""
        DELETE FROM user_like
        WHERE user_id=#{userId} AND target_type=#{type} AND target_id=#{targetId}
    """)
    int unlike(@Param("userId") Long userId, @Param("type") String type, @Param("targetId") Long targetId);

    @Select("SELECT COUNT(*) FROM user_like WHERE target_type='work' AND target_id IN (SELECT id FROM creation_work WHERE user_id=#{userId})")
    Integer countLikesOnMyWorks(@Param("userId") Long userId);

    @Select("""
        SELECT
            ul.id AS id,
            ul.created_at AS createdAt,
            ul.target_type AS targetType,
            ul.target_id AS targetId,
            cw.title AS title,
            cw.content AS content,
            cw.user_id AS authorId,
            u.nickname AS authorName,
            u.avatar_url AS authorAvatar
        FROM user_like ul
        INNER JOIN creation_work cw ON ul.target_id = cw.id
        LEFT JOIN sys_user u ON cw.user_id = u.id
        WHERE ul.user_id = #{userId} AND ul.target_type = 'work'
        ORDER BY ul.created_at DESC
        LIMIT #{limit} OFFSET #{offset}
    """)
    List<Map<String,Object>> listMyLikes(@Param("userId") Long userId, @Param("offset") int offset, @Param("limit") int limit);

    /**
     * 查询用户作品的获赞记录（别人点赞了我的作品）
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
        WHERE cw.user_id = #{userId} AND ul.target_type = 'work'
        ORDER BY ul.created_at DESC
        LIMIT #{limit} OFFSET #{offset}
    """)
    List<Map<String,Object>> findReceivedLikes(@Param("userId") Long userId, @Param("offset") int offset, @Param("limit") int limit);

    /**
     * 统计用户作品的获赞总数
     */
    @Select("""
        SELECT COUNT(*)
        FROM user_like ul
        INNER JOIN creation_work cw ON ul.target_id = cw.id
        WHERE cw.user_id = #{userId} AND ul.target_type = 'work'
    """)
    int countReceivedLikes(@Param("userId") Long userId);

}