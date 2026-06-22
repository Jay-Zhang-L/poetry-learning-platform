package com.shici.domain;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class SysUser {
    private String avatarUrl;
    private String coverUrl;
    private String bio;
    private Integer relayScore;
    private Integer relayCorrectCount;
    private Integer gameTotalScore;
    private Integer likeCount;
    private Integer followingCount;
    private Integer followerCount;
    private Long id;

    private String username;

    private String nickname;

    private String role;      // student / teacher

    private Integer grade;

    private LocalDateTime createdAt;

    private String password;  // 明文密码（A方案）
}