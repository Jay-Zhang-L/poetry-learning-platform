package com.shici.domain.dto;

import lombok.Data;
import jakarta.validation.constraints.NotBlank;

@Data
public class AIRequestDTO {

    @NotBlank(message = "消息内容不能为空")
    private String message;

    private String mode = "三步法讲解"; // 默认模式

    private String poemTitle; // 诗词标题（可选）

    private String poemContent; // 诗词内容（可选）
}