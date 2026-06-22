package com.shici.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shici.config.AIConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class AIServiceClient {

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;
    private final AIConfig aiConfig;

    // ==================== DeepSeek相关方法 ====================

    /**
     * DeepSeek 简单对话
     */
    public String deepSeekSimpleChat(String prompt) {
        List<Map<String, String>> messages = new ArrayList<>();
        Map<String, String> userMessage = new HashMap<>();
        userMessage.put("role", "user");
        userMessage.put("content", prompt);
        messages.add(userMessage);
        return callDeepSeek(messages);
    }

    /**
     * DeepSeek 带系统提示词的对话
     */
    public String deepSeekChatWithSystem(String systemPrompt, String userPrompt) {
        List<Map<String, String>> messages = new ArrayList<>();
        Map<String, String> systemMessage = new HashMap<>();
        systemMessage.put("role", "system");
        systemMessage.put("content", systemPrompt);
        messages.add(systemMessage);
        Map<String, String> userMessage = new HashMap<>();
        userMessage.put("role", "user");
        userMessage.put("content", userPrompt);
        messages.add(userMessage);
        return callDeepSeek(messages);
    }

    /**
     * 调用 DeepSeek API
     */
    public String callDeepSeek(List<Map<String, String>> messages) {
        try {
            String url = aiConfig.getModelUrl();

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("messages", messages);
            requestBody.put("model", aiConfig.getModel() != null ? aiConfig.getModel() : "deepseek-chat");
            requestBody.put("temperature", aiConfig.getTemperature() != null ? aiConfig.getTemperature() : 0.7);
            requestBody.put("max_tokens", aiConfig.getMaxTokens() != null ? aiConfig.getMaxTokens() : 2048);
            requestBody.put("stream", false);

            log.info("调用DeepSeek API，URL: {}, Model: {}", url, aiConfig.getModel());

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "Bearer " + aiConfig.getApiKey());

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

            long startTime = System.currentTimeMillis();
            ResponseEntity<String> response = restTemplate.exchange(
                    url,
                    HttpMethod.POST,
                    entity,
                    String.class
            );
            long endTime = System.currentTimeMillis();
            log.info("DeepSeek API调用耗时: {} ms", endTime - startTime);

            JsonNode jsonNode = objectMapper.readTree(response.getBody());

            if (jsonNode.has("error")) {
                String errorMsg = jsonNode.get("error").get("message").asText();
                log.error("DeepSeek API返回错误: {}", errorMsg);
                throw new RuntimeException("DeepSeek API错误: " + errorMsg);
            }

            String result = jsonNode.get("choices").get(0).get("message").get("content").asText();
            log.info("DeepSeek响应成功，内容长度: {}", result.length());
            return result;

        } catch (HttpClientErrorException e) {
            log.error("DeepSeek HTTP错误 - 状态码: {}, 响应体: {}", e.getStatusCode(), e.getResponseBodyAsString());
            throw new RuntimeException("DeepSeek调用失败: HTTP " + e.getStatusCode() + " - " + e.getResponseBodyAsString(), e);
        } catch (Exception e) {
            log.error("DeepSeek调用失败", e);
            throw new RuntimeException("DeepSeek调用失败: " + e.getMessage(), e);
        }
    }

    // ==================== 通用方法（默认使用 DeepSeek） ====================

    /**
     * 简单对话（默认使用 DeepSeek）
     */
    public String simpleChat(String prompt) {
        return deepSeekSimpleChat(prompt);
    }

    /**
     * 文本AI调用（默认使用 DeepSeek）
     */
    public String callTextAI(String prompt) {
        return deepSeekSimpleChat(prompt);
    }

    /**
     * 带系统提示词的对话（默认使用 DeepSeek）
     */
    public String chatWithSystem(String systemPrompt, String userPrompt) {
        return deepSeekChatWithSystem(systemPrompt, userPrompt);
    }
}