package com.shici.mapper;

import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface UserFavoriteMapper {

    @Insert("""
        INSERT INTO user_favorite(user_id, target_type, target_id, created_at)
        VALUES(#{userId}, #{type}, #{targetId}, NOW())
    """)
    int fav(@Param("userId") Long userId, @Param("type") String type, @Param("targetId") Long targetId);

    @Delete("""
        DELETE FROM user_favorite
        WHERE user_id=#{userId} AND target_type=#{type} AND target_id=#{targetId}
    """)
    int unfav(@Param("userId") Long userId, @Param("type") String type, @Param("targetId") Long targetId);

    @Select("""
        SELECT
            uf.target_type AS targetType,
            uf.target_id AS targetId,
            uf.created_at AS createdAt,
            cw.title AS title,
            cw.content AS content,
            cw.user_id AS authorId,
            u.nickname AS authorName,
            u.avatar_url AS authorAvatar,
            cw.images AS coverImage
        FROM user_favorite uf
        LEFT JOIN creation_work cw ON uf.target_id = cw.id AND uf.target_type = 'creation_work'
        LEFT JOIN sys_user u ON cw.user_id = u.id
        WHERE uf.user_id = #{userId}
        ORDER BY uf.created_at DESC
        LIMIT #{limit} OFFSET #{offset}
    """)
    List<Map<String,Object>> listFav(@Param("userId") Long userId, @Param("offset") int offset, @Param("limit") int limit);

    @Select("""
        SELECT
            uf.target_type AS targetType,
            uf.target_id AS targetId,
            uf.created_at AS createdAt,
            cw.title AS title,
            cw.content AS content,
            cw.user_id AS authorId,
            u.nickname AS authorName,
            u.avatar_url AS authorAvatar,
            cw.images AS coverImage
        FROM user_favorite uf
        LEFT JOIN creation_work cw ON uf.target_id = cw.id AND uf.target_type = 'creation_work'
        LEFT JOIN sys_user u ON cw.user_id = u.id
        WHERE uf.user_id = #{userId} AND uf.target_type = 'creation_work'
        ORDER BY uf.created_at DESC
        LIMIT #{limit} OFFSET #{offset}
    """)
    List<Map<String,Object>> listFavByCreation(@Param("userId") Long userId, @Param("offset") int offset, @Param("limit") int limit);

    @Select("""
        SELECT
            uf.target_type AS targetType,
            uf.target_id AS targetId,
            uf.created_at AS createdAt
        FROM user_favorite uf
        WHERE uf.user_id = #{userId} AND uf.target_type = 'recite_work'
        ORDER BY uf.created_at DESC
        LIMIT #{limit} OFFSET #{offset}
    """)
    List<Map<String,Object>> listFavByRecite(@Param("userId") Long userId, @Param("offset") int offset, @Param("limit") int limit);

    @Select("""
        SELECT
            uf.target_type AS targetType,
            uf.target_id AS targetId,
            uf.created_at AS createdAt
        FROM user_favorite uf
        WHERE uf.user_id = #{userId} AND uf.target_type = 'library_work'
        ORDER BY uf.created_at DESC
        LIMIT #{limit} OFFSET #{offset}
    """)
    List<Map<String,Object>> listFavByLibrary(@Param("userId") Long userId, @Param("offset") int offset, @Param("limit") int limit);
}