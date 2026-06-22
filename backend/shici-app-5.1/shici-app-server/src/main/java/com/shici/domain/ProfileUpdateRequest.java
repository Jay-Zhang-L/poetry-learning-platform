package com.shici.domain;

import lombok.Data;

@Data
public class ProfileUpdateRequest {
    private String nickname;
    private Integer grade;
    private String bio;
    private String avatarUrl;
    private String coverUrl;
}