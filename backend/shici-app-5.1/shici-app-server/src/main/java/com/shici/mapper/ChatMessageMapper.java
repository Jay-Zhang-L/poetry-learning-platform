package com.shici.mapper;

import com.shici.domain.ChatMessage;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface ChatMessageMapper {

    @Insert("INSERT INTO chat_message(user_id, nickname, avatar, content, type, status, create_time) " +
            "VALUES(#{userId}, #{nickname}, #{avatar}, #{content}, #{type}, #{status}, #{createTime})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(ChatMessage message);

    @Select("SELECT * FROM chat_message WHERE status = 1 ORDER BY create_time DESC LIMIT 50")
    List<ChatMessage> getLatestMessages();

    @Select("SELECT * FROM chat_message WHERE status = 1 ORDER BY create_time DESC LIMIT #{size} OFFSET #{offset}")
    List<ChatMessage> getHistoryMessages(@Param("offset") int offset, @Param("size") int size);
    @Select("SELECT COUNT(*) FROM chat_message WHERE status = 1")  // ← 添加这个方法
    long getTotalCount();
}