package com.shici.domain;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 聊天消息实体类
 *
 * @author shici
 * @date 2026-03-30
 */
@Data
public class ChatMessage {

    /**
     * 消息ID
     */
    private Long id;

    /**
     * 用户ID
     */
    private Long userId;

    /**
     * 用户昵称
     */
    private String nickname;

    /**
     * 头像URL
     */
    private String avatar;

    /**
     * 消息内容
     */
    private String content;

    /**
     * 消息类型：1-普通消息，2-系统消息
     */
    private Integer type;

    /**
     * 状态：1-正常，0-删除
     */
    private Integer status;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;
}