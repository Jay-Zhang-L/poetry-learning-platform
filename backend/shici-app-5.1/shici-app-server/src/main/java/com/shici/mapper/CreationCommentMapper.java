package com.shici.mapper;

import com.shici.domain.dto.CommentDto;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface CreationCommentMapper {
    
    @Insert("""
        INSERT INTO creation_comment(work_id, user_id, content, parent_id)
        VALUES(#{workId}, #{userId}, #{content}, #{parentId})
    """)
    int insert(@Param("workId") Long workId, 
               @Param("userId") Long userId, 
               @Param("content") String content, 
               @Param("parentId") Long parentId);
    
    @Select("""
        SELECT c.id, c.work_id AS workId, c.user_id AS userId, c.content, 
               c.parent_id AS parentId, c.like_count AS likeCount, c.created_at AS createdAt,
               u.nickname AS userName, u.avatar_url AS userAvatar
        FROM creation_comment c
        LEFT JOIN sys_user u ON c.user_id = u.id
        WHERE c.work_id = #{workId}
        ORDER BY c.created_at DESC
        LIMIT #{limit} OFFSET #{offset}
    """)
    List<CommentDto> findByWorkId(@Param("workId") Long workId, 
                                   @Param("offset") int offset, 
                                   @Param("limit") int limit);
    
    @Select("SELECT COUNT(*) FROM creation_comment WHERE work_id = #{workId}")
    int countByWorkId(@Param("workId") Long workId);
    
    @Delete("DELETE FROM creation_comment WHERE id = #{id} AND user_id = #{userId}")
    int deleteByIdAndUserId(@Param("id") Long id, @Param("userId") Long userId);
    
    @Update("UPDATE creation_comment SET like_count = like_count + 1 WHERE id = #{id}")
    int incrementLikeCount(@Param("id") Long id);
    
    @Update("UPDATE creation_comment SET like_count = like_count - 1 WHERE id = #{id} AND like_count > 0")
    int decrementLikeCount(@Param("id") Long id);
}
