package com.shici.mapper;

import com.shici.domain.Conversation;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface ConversationMapper {

    @Insert("INSERT INTO conversation (user_id, target_id, last_message_id, unread_count) " +
            "VALUES (#{userId}, #{targetId}, #{lastMessageId}, #{unreadCount}) " +
            "ON DUPLICATE KEY UPDATE " +
            "last_message_id = VALUES(last_message_id), " +
            "unread_count = unread_count + 1, " +
            "updated_at = CURRENT_TIMESTAMP")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int upsert(Conversation conversation);

    @Select("SELECT * FROM conversation WHERE user_id = #{userId} " +
            "ORDER BY updated_at DESC " +
            "LIMIT #{offset}, #{size}")
    List<Conversation> getConversationsByUserId(@Param("userId") Long userId,
                                                 @Param("offset") int offset,
                                                 @Param("size") int size);

    @Update("UPDATE conversation SET unread_count = 0 " +
            "WHERE user_id = #{userId} AND target_id = #{targetId}")
    int clearUnreadCount(@Param("userId") Long userId, @Param("targetId") Long targetId);

    @Select("SELECT * FROM conversation WHERE user_id = #{userId} AND target_id = #{targetId}")
    Conversation getConversation(@Param("userId") Long userId, @Param("targetId") Long targetId);

    @Delete("DELETE FROM conversation WHERE user_id = #{userId} AND target_id = #{targetId}")
    int deleteConversation(@Param("userId") Long userId, @Param("targetId") Long targetId);

    @Select("SELECT COUNT(*) FROM conversation WHERE user_id = #{userId}")
    int countConversations(@Param("userId") Long userId);

    /**
     * 清空用户所有会话的未读计数
     */
    @Update("UPDATE conversation SET unread_count = 0 WHERE user_id = #{userId}")
    int clearAllUnreadCount(@Param("userId") Long userId);
}