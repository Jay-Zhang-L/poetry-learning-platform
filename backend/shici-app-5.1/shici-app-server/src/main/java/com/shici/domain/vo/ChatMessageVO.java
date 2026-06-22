package com.shici.domain.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ChatMessageVO {
    private Long id;
    private Long userId;
    private String nickname;
    private String avatar;
    private String content;
    private Integer type;
    private LocalDateTime createTime;
    private String timeAgo; // 时间描述（刚刚、几分钟前等）
}