package com.shici.domain.dto;

import lombok.Data;

@Data
public class RecitePlayReq {
    private Long poemId;
    private Long playlistId;
    private Long mediaId;
    private String playType;
}