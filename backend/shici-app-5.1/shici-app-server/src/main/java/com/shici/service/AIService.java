package com.shici.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shici.config.AIConfig;
import com.shici.domain.dto.AIRequestDTO;
import com.shici.domain.vo.AIResponseVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@Service
public class AIService {

    @Autowired
    private AIConfig aiConfig;

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private ObjectMapper objectMapper;

    /**
     * 根据模式获取系统提示词
     */
    private String getSystemPrompt(String mode) {
        Map<String, String> prompts = new HashMap<>();
        prompts.put("三步法讲解", "你是一位专业的诗词教师墨墨老师。请用三步法讲解古诗：1.背景介绍 2.注释解析 3.赏析感悟，最后标出考点。语气亲切专业。");
        prompts.put("逐句赏析", "你是一位专业的诗词教师墨墨老师。请逐句赏析古诗，解释每句的含义、意象和写作手法。");
        prompts.put("出题训练", "你是一位专业的诗词教师墨墨老师。请根据古诗生成3道题目（包含选择题和简答题），并给出答案和详细解析。");
        prompts.put("朗诵建议", "你是一位专业的诗词教师墨墨老师。请给出朗诵建议，包括：停顿位置、重音处理、情感线变化和常见易错点。");
        prompts.put("白话改写", "你是一位专业的诗词教师墨墨老师。请用现代白话文改写古诗，保持原有意境和美感。");

        return prompts.getOrDefault(mode, prompts.get("三步法讲解"));
    }

    /**
     * 调用DeepSeek API
     */
    public AIResponseVO chat(AIRequestDTO request) {
        try {
            String url = aiConfig.getModelUrl();

            // 构建系统提示词
            String systemPrompt = getSystemPrompt(request.getMode());
            String userMessage = request.getMessage();

            // 如果有诗词信息，添加到消息中
            if (request.getPoemTitle() != null && !request.getPoemTitle().isEmpty()) {
                userMessage = "关于《" + request.getPoemTitle() + "》：\n" + userMessage;
            }

            // 构建请求体
            Map<String, Object> requestBody = new HashMap<>();

            List<Map<String, String>> messages = new ArrayList<>();

            // system message
            Map<String, String> systemMsg = new HashMap<>();
            systemMsg.put("role", "system");
            systemMsg.put("content", systemPrompt);
            messages.add(systemMsg);

            // user message
            Map<String, String> userMsg = new HashMap<>();
            userMsg.put("role", "user");
            userMsg.put("content", userMessage);
            messages.add(userMsg);

            requestBody.put("messages", messages);
            requestBody.put("model", "deepseek-chat");
            requestBody.put("temperature", 0.8);
            requestBody.put("stream", false);

            // 发送请求
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "Bearer " + aiConfig.getApiKey());

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

            ResponseEntity<String> response = restTemplate.exchange(
                    url,
                    HttpMethod.POST,
                    entity,
                    String.class
            );

            // 解析响应
            JsonNode jsonNode = objectMapper.readTree(response.getBody());

            String result = jsonNode.get("choices").get(0).get("message").get("content").asText();

            return AIResponseVO.builder()
                    .content(result)
                    .mode(request.getMode())
                    .success(true)
                    .time(LocalDateTime.now())
                    .build();

        } catch (Exception e) {
            log.error("AI服务调用失败", e);
            return AIResponseVO.builder()
                    .success(false)
                    .errorMsg("服务调用失败：" + e.getMessage())
                    .time(LocalDateTime.now())
                    .build();
        }
    }

    /**
     * 获取所有可用模式
     */
    public List<String> getModes() {
        return Arrays.asList(
                "三步法讲解",
                "逐句赏析",
                "出题训练",
                "朗诵建议",
                "白话改写"
        );
    }
}