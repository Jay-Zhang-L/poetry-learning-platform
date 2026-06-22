package com.shici.domain.dto;

import lombok.Data;

import java.util.List;

@Data
public class ReciteListenRespDto {
    private List<ReciteListenItemDto> hotList;
    private List<ReciteListenItemDto> pickList;
}