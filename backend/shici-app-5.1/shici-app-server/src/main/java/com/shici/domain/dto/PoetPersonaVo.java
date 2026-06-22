package com.shici.domain.dto;

import lombok.Data;

/**
 * 诗人形象VO
 */
@Data
public class PoetPersonaVo {
    private Long poetId;
    private String name;
    private String dynasty;
    private String avatarUrl;
    private String personaTitle;
    private String personaDesc;
    private String representativeWorks;
    private String tags;
}
