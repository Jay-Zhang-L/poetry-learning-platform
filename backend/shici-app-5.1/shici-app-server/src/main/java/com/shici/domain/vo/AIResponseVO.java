package com.shici.domain.vo;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Builder
public class AIResponseVO {
    private String content;        // AI回复内容
    private String mode;           // 当前模式
    private LocalDateTime time;    // 回复时间
    private Boolean success;       // 是否成功
    private String errorMsg;       // 错误信息
}