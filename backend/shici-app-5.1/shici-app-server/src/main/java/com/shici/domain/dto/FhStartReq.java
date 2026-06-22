package com.shici.domain.dto;

import lombok.Data;

@Data
public class FhStartReq {

    /**
     * 主题ID
     */
    private Long topicId;

    /**
     * 主题关键字（花 / 山 / 风 等）
     */
    private String keyword;

}