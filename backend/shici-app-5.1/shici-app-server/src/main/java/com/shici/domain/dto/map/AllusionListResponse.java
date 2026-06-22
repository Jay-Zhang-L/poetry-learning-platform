package com.shici.domain.dto.map;

import lombok.Data;
import java.util.List;

/**
 * 典故列表响应DTO
 */
@Data
public class AllusionListResponse {
    private String location;
    private List<AllusionDetailDto> allusions;
}
