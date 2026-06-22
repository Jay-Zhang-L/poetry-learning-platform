package com.shici.domain.dto;

import lombok.Data;
import jakarta.validation.constraints.NotBlank;
import java.util.List;

@Data
public class AssistantChatRequest {

    @NotBlank(message = "消息内容不能为空")
    private String message;

    private List<AssistantChatMessage> history;
}
