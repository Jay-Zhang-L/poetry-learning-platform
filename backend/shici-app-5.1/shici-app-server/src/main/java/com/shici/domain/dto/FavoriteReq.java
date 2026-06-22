package com.shici.domain.dto;

import lombok.Data;

@Data
public class FavoriteReq {
    private Long targetId;
    private String favoriteType; // playlist / audio
}