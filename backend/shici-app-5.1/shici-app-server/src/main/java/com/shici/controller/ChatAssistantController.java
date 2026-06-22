package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.dto.AssistantChatRequest;
import com.shici.domain.dto.AssistantChatResponse;
import com.shici.service.ChatAssistantService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@Tag(name = "智能小助手", description = "智能小助手相关接口")
@RestController
@RequestMapping("/api/assistant")
public class ChatAssistantController {

    @Autowired
    private ChatAssistantService chatAssistantService;

    @Operation(summary = "发送消息", description = "与智能小助手进行对话")
    @PostMapping("/chat")
    public R<AssistantChatResponse> chat(@Valid @RequestBody AssistantChatRequest request) {
        AssistantChatResponse response = chatAssistantService.chat(request);
        return R.ok(response);
    }

    @Operation(summary = "健康检查", description = "检查智能助手服务是否可用")
    @GetMapping("/ping")
    public R<String> ping() {
        return R.ok("pong");
    }
}
