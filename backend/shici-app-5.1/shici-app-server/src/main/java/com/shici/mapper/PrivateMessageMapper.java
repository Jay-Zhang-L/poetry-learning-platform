package com.shici.mapper;

import com.shici.domain.PrivateMessage;
import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface PrivateMessageMapper {

    @Insert("INSERT INTO private_message (sender_id, receiver_id, content, message_type, is_read) " +
            "VALUES (#{senderId}, #{receiverId}, #{content}, #{messageType}, #{isRead})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(PrivateMessage message);

    @Select("SELECT * FROM private_message " +
            "WHERE ((sender_id = #{userId1} AND receiver_id = #{userId2}) " +
            "OR (sender_id = #{userId2} AND receiver_id = #{userId1})) " +
            "ORDER BY created_at DESC " +
            "LIMIT #{offset}, #{size}")
    List<PrivateMessage> getMessagesBetweenUsers(@Param("userId1") Long userId1,
                                                  @Param("userId2") Long userId2,
                                                  @Param("offset") int offset,
                                                  @Param("size") int size);

    @Select("SELECT * FROM private_message WHERE receiver_id = #{userId} AND is_read = FALSE")
    List<PrivateMessage> getUnreadMessages(@Param("userId") Long userId);

    @Update("UPDATE private_message SET is_read = TRUE " +
            "WHERE receiver_id = #{userId} AND sender_id = #{senderId}")
    int markAsRead(@Param("userId") Long userId, @Param("senderId") Long senderId);

    @Select("SELECT COUNT(*) FROM private_message WHERE receiver_id = #{userId} AND is_read = FALSE")
    int getUnreadCount(@Param("userId") Long userId);

    @Delete("DELETE FROM private_message WHERE id = #{id}")
    int deleteById(@Param("id") Long id);

    @Select("SELECT * FROM private_message WHERE id = #{id}")
    PrivateMessage findById(@Param("id") Long id);

    // 获取最近的会话列表
    @Select("SELECT DISTINCT " +
            "CASE WHEN sender_id = #{userId} THEN receiver_id ELSE sender_id END as target_id, " +
            "MAX(created_at) as last_message_time " +
            "FROM private_message " +
            "WHERE sender_id = #{userId} OR receiver_id = #{userId} " +
            "GROUP BY target_id " +
            "ORDER BY last_message_time DESC " +
            "LIMIT #{offset}, #{size}")
    List<Map<String, Object>> getRecentConversations(@Param("userId") Long userId,
                                                      @Param("offset") int offset,
                                                      @Param("size") int size);

    /**
     * 将用户所有接收的未读消息标记为已读
     */
    @Update("UPDATE private_message SET is_read = TRUE WHERE receiver_id = #{userId} AND is_read = FALSE")
    int markAllAsRead(@Param("userId") Long userId);
}