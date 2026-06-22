package com.shici.domain.dto;

import lombok.Data;

@Data
public class ProfileDto {
    private Long id;
    private String username;
    private String nickname;
    private String role;
    private Integer grade;
    private String avatarUrl;
    private String coverUrl;
    private String bio;
    private Integer likeCount;
    private Integer followingCount;
    private Integer followerCount;
}