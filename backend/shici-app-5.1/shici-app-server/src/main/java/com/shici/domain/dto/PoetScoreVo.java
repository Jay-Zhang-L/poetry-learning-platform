package com.shici.domain.dto;

import lombok.Data;

/**
 * 诗人得分VO
 */
@Data
public class PoetScoreVo {
    private Long poetId;
    private Integer score;
    private String name;
    private String dynasty;
    private String avatarUrl;
    private String poetName;
}
