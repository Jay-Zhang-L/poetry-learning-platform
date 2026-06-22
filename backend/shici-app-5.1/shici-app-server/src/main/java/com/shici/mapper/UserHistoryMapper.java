package com.shici.mapper;

import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface UserHistoryMapper {

    @Insert("""
        INSERT INTO user_history(user_id, target_type, target_id, title, cover_url, viewed_at)
        VALUES(#{userId}, #{type}, #{targetId}, #{title}, #{coverUrl}, NOW())
    """)
    int add(@Param("userId") Long userId,
            @Param("type") String type,
            @Param("targetId") Long targetId,
            @Param("title") String title,
            @Param("coverUrl") String coverUrl);

    @Select("""
        SELECT id, target_type AS targetType, target_id AS targetId, title, cover_url AS coverUrl, viewed_at AS createdAt
        FROM user_history
        WHERE user_id = #{userId}
        ORDER BY viewed_at DESC
        LIMIT #{limit} OFFSET #{offset}
    """)
    List<Map<String,Object>> list(@Param("userId") Long userId, @Param("offset") int offset, @Param("limit") int limit);

    @Delete("DELETE FROM user_history WHERE id=#{id}")
    int deleteById(@Param("id") Long id);

    @Delete("DELETE FROM user_history WHERE user_id=#{userId}")
    int clear(@Param("userId") Long userId);
}