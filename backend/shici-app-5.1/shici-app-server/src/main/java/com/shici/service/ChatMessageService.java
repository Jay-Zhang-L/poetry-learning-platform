package com.shici.service;

import com.shici.domain.ChatMessage;
import com.shici.domain.vo.ChatMessageVO;
import java.util.List;

public interface ChatMessageService {

    /**
     * 发送消息
     */
    ChatMessageVO sendMessage(Long userId, String nickname, String avatar, String content);

    /**
     * 获取最新消息
     */
    List<ChatMessageVO> getLatestMessages();

    /**
     * 获取历史消息（分页）
     */
    List<ChatMessageVO> getHistoryMessages(Integer page, Integer size);

    long getTotalCount();  // ← 添加这个方法
}