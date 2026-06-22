package com.shici.config;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import okhttp3.*;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import java.io.IOException;

@Slf4j
@Data
@Component
@ConfigurationProperties(prefix = "ai.deepseek")
public class AIConfig {
    private String apiKey;
    private String modelUrl = "https://api.deepseek.com/v1/chat/completions";
    private String model = "deepseek-chat";
    private Integer maxTokens = 2048;
    private Double temperature = 0.7;

    private OkHttpClient httpClient;
    private ObjectMapper objectMapper;

    @PostConstruct
    public void init() {
        httpClient = new OkHttpClient.Builder()
                .connectTimeout(java.time.Duration.ofSeconds(30))
                .readTimeout(java.time.Duration.ofSeconds(60))
                .writeTimeout(java.time.Duration.ofSeconds(60))
                .build();
        objectMapper = new ObjectMapper();
        log.info("DeepSeek配置初始化完成，模型地址: {}", modelUrl);
    }

    public String callTextAI(String systemPrompt, String userPrompt) throws IOException {
        String requestBody = String.format(
                "{" +
                        "  \"model\": \"%s\"," +
                        "  \"messages\": [" +
                        "    {\"role\": \"system\", \"content\": \"%s\"}," +
                        "    {\"role\": \"user\", \"content\": \"%s\"}" +
                        "  ]," +
                        "  \"temperature\": %f," +
                        "  \"max_tokens\": %d" +
                        "}",
                model,
                escapeJson(systemPrompt),
                escapeJson(userPrompt),
                temperature,
                maxTokens
        );

        Request request = new Request.Builder()
                .url(modelUrl)
                .addHeader("Authorization", "Bearer " + apiKey)
                .addHeader("Content-Type", "application/json")
                .post(RequestBody.create(requestBody, MediaType.parse("application/json")))
                .build();

        try (Response response = httpClient.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                log.error("AI调用失败，状态码: {}", response.code());
                throw new IOException("AI调用失败: " + response.code());
            }
            String responseBody = response.body().string();
            log.debug("AI响应: {}", responseBody);

            JsonNode root = objectMapper.readTree(responseBody);
            return root.path("choices").get(0).path("message").path("content").asText();
        }
    }

    public String callTextAI(String userPrompt) throws IOException {
        String systemPrompt = "你是一位专业的诗词专家，擅长分析诗词的韵律、韵脚、平仄，并提供润色建议。请用中文回复。";
        return callTextAI(systemPrompt, userPrompt);
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}