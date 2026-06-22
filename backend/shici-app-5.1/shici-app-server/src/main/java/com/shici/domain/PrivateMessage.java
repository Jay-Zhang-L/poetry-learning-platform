package com.shici.domain;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class PrivateMessage {
    private Long id;
    private Long senderId;
    private Long receiverId;
    private String content;
    private String messageType; // text, image, emoji等
    private Boolean isRead;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 扩展字段（不对应数据库字段）
    private String senderNickname;
    private String senderAvatarUrl;
    private String receiverNickname;
    private String receiverAvatarUrl;
}