package com.shici.mapper;

import com.shici.domain.Notification;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface NotificationMapper {
    
    @Select("<script>" +
            "SELECT n.*, " +
            "u.nickname as fromUserName, u.avatar_url as fromUserAvatar, " +
            "w.title as workTitle, LEFT(w.content, 100) as workExcerpt " +
            "FROM notification n " +
            "LEFT JOIN sys_user u ON n.from_user_id = u.id " +
            "LEFT JOIN creation_work w ON n.target_type = 'work' AND n.target_id = w.id " +
            "WHERE n.user_id = #{userId} " +
            "<if test='type != null and type != \"all\"'>AND n.type = #{type}</if> " +
            "<if test='isRead != null'>AND n.is_read = #{isRead}</if> " +
            "ORDER BY n.created_at DESC " +
            "LIMIT #{offset}, #{limit}" +
            "</script>")
    List<Notification> findList(@Param("userId") Long userId, 
                                 @Param("type") String type,
                                 @Param("isRead") Boolean isRead,
                                 @Param("offset") int offset, 
                                 @Param("limit") int limit);
    
    @Select("SELECT COUNT(*) FROM notification WHERE user_id = #{userId} AND is_read = 0")
    int countUnread(Long userId);
    
    @Select("<script>" +
            "SELECT COUNT(*) FROM notification " +
            "WHERE user_id = #{userId} AND is_read = 0 " +
            "<if test='type != null and type != \"all\"'>AND type = #{type}</if>" +
            "</script>")
    int countUnreadByType(@Param("userId") Long userId, @Param("type") String type);
    
    @Insert("INSERT INTO notification (user_id, from_user_id, type, target_type, target_id, content) " +
            "VALUES (#{userId}, #{fromUserId}, #{type}, #{targetType}, #{targetId}, #{content})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Notification notification);
    
    @Update("UPDATE notification SET is_read = 1 WHERE id = #{id}")
    int markAsRead(Long id);
    
    @Update("UPDATE notification SET is_read = 1 WHERE user_id = #{userId}")
    int markAllAsRead(Long userId);
    
    @Delete("DELETE FROM notification WHERE id = #{id}")
    int deleteById(Long id);
}
