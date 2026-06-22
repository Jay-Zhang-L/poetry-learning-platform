package com.shici.domain;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Conversation {
    private Long id;
    private Long userId;
    private Long targetId;
    private Long lastMessageId;
    private Integer unreadCount;
    private LocalDateTime updatedAt;

    // 扩展字段（不对应数据库字段）
    private String targetNickname;
    private String targetAvatarUrl;
    private String lastMessageContent;
    private LocalDateTime lastMessageTime;
    private Boolean isOnline;
}