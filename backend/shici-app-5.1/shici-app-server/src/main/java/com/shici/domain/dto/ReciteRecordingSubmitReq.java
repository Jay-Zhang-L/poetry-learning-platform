package com.shici.domain.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 提交录音请求
 */
@Data
public class ReciteRecordingSubmitReq {
    @NotNull(message = "诗词ID不能为空")
    private Long poemId;
    
    private String poemTitle;
    private String poemContent;
    private Integer audioDuration;
}
