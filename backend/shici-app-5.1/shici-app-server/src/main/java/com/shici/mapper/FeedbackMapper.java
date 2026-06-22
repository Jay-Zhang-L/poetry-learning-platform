package com.shici.mapper;

import com.shici.domain.Feedback;
import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface FeedbackMapper {

    @Insert("""
        INSERT INTO feedback(user_id, content, contact_info, status, created_at, updated_at)
        VALUES(#{userId}, #{content}, #{contactInfo}, 'pending', NOW(), NOW())
    """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Feedback feedback);

    @Select("""
        SELECT
            f.id AS id,
            f.user_id AS userId,
            f.content AS content,
            f.contact_info AS contactInfo,
            f.status AS status,
            f.reply AS reply,
            f.created_at AS createdAt,
            f.updated_at AS updatedAt,
            u.nickname AS userName,
            u.avatar_url AS userAvatar
        FROM feedback f
        LEFT JOIN sys_user u ON f.user_id = u.id
        WHERE f.user_id = #{userId}
        ORDER BY f.created_at DESC
        LIMIT #{limit} OFFSET #{offset}
    """)
    List<Map<String, Object>> listByUserId(@Param("userId") Long userId,
                                           @Param("offset") int offset,
                                           @Param("limit") int limit);

    @Select("SELECT COUNT(*) FROM feedback WHERE user_id = #{userId}")
    int countByUserId(@Param("userId") Long userId);
}