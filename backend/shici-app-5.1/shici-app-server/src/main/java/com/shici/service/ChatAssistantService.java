package com.shici.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shici.config.ZhipuAIConfig;
import com.shici.domain.dto.AssistantChatMessage;
import com.shici.domain.dto.AssistantChatRequest;
import com.shici.domain.dto.AssistantChatResponse;
import lombok.extern.slf4j.Slf4j;
import okhttp3.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
public class ChatAssistantService {

    private final ZhipuAIConfig zhipuAIConfig;
    private final ObjectMapper objectMapper;
    private final OkHttpClient httpClient;

    private static final String SYSTEM_PROMPT = "你是诗词小精灵，一个专注于中国古诗词和传统文化的智能助手。" +
            "你的职责是回答用户关于古诗词、传统文化的问题，包括诗词赏析、作者介绍、历史背景等。" +
            "请用简洁友好的语气回答，每次回复不超过200字。适当使用表情符号增加亲和力。";

    @Autowired
    public ChatAssistantService(ZhipuAIConfig zhipuAIConfig, ObjectMapper objectMapper) {
        this.zhipuAIConfig = zhipuAIConfig;
        this.objectMapper = objectMapper;
        this.httpClient = new OkHttpClient.Builder()
                .connectTimeout(30, TimeUnit.SECONDS)
                .readTimeout(60, TimeUnit.SECONDS)
                .writeTimeout(30, TimeUnit.SECONDS)
                .build();
    }

    public AssistantChatResponse chat(AssistantChatRequest request) {
        try {
            String url = zhipuAIConfig.getBaseUrl() + "/chat/completions";

            // 构建消息列表
            List<Map<String, String>> messages = new ArrayList<>();

            // 添加系统提示
            Map<String, String> systemMsg = new HashMap<>();
            systemMsg.put("role", "system");
            systemMsg.put("content", SYSTEM_PROMPT);
            messages.add(systemMsg);

            // 添加历史消息
            if (request.getHistory() != null && !request.getHistory().isEmpty()) {
                for (AssistantChatMessage msg : request.getHistory()) {
                    Map<String, String> historyMsg = new HashMap<>();
                    historyMsg.put("role", msg.getRole());
                    historyMsg.put("content", msg.getContent());
                    messages.add(historyMsg);
                }
            }

            // 添加当前用户消息
            Map<String, String> userMsg = new HashMap<>();
            userMsg.put("role", "user");
            userMsg.put("content", request.getMessage());
            messages.add(userMsg);

            // 构建请求体
            Map<String, Object> requestBodyMap = new HashMap<>();
            requestBodyMap.put("model", zhipuAIConfig.getModel());
            requestBodyMap.put("messages", messages);
            requestBodyMap.put("stream", false);

            String requestBody = objectMapper.writeValueAsString(requestBodyMap);

            Request httpRequest = new Request.Builder()
                    .url(url)
                    .addHeader("Authorization", "Bearer " + zhipuAIConfig.getApiKey())
                    .addHeader("Content-Type", "application/json")
                    .post(RequestBody.create(requestBody, MediaType.parse("application/json")))
                    .build();

            try (Response response = httpClient.newCall(httpRequest).execute()) {
                if (!response.isSuccessful()) {
                    String errorBody = response.body() != null ? response.body().string() : "Unknown error";
                    log.error("智谱AI调用失败: {} - {}", response.code(), errorBody);
                    return AssistantChatResponse.builder()
                            .success(false)
                            .errorMsg("AI服务调用失败，请稍后重试")
                            .build();
                }

                String responseBody = response.body().string();
                JsonNode jsonNode = objectMapper.readTree(responseBody);

                String reply = jsonNode.path("choices")
                        .path(0)
                        .path("message")
                        .path("content")
                        .asText();

                return AssistantChatResponse.builder()
                        .reply(reply)
                        .success(true)
                        .build();
            }

        } catch (Exception e) {
            log.error("智能助手服务调用异常", e);
            return AssistantChatResponse.builder()
                    .success(false)
                    .errorMsg("服务暂时不可用，请稍后重试")
                    .build();
        }
    }
}
