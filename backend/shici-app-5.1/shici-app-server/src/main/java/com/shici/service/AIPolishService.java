package com.shici.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class AIPolishService {

    // 改用 AIServiceClient
    private final AIServiceClient aiServiceClient;
    private final ObjectMapper objectMapper;

    /**
     * 诗词润色（包含错别字、韵脚、韵律检查）
     */
    public Map<String, Object> polish(String content) {
        try {
            String prompt = buildPolishPrompt(content);
            log.debug("润色提示词: {}", prompt);

            // 使用 AIServiceClient 的 callTextAI 方法
            String aiResponse = aiServiceClient.callTextAI(prompt);
            log.debug("AI润色响应: {}", aiResponse);

            // 尝试解析AI返回的JSON
            return parsePolishResponse(aiResponse);

        } catch (Exception e) {
            log.error("AI润色失败", e);
            // 返回默认结构
            return getDefaultPolishResult();
        }
    }

    /**
     * 单独检查韵脚接口
     * @param content 诗词内容
     * @return 韵脚检查结果
     */
    public Map<String, Object> checkRhyme(String content) {
        try {
            String prompt = buildRhymeCheckPrompt(content);
            log.debug("韵脚检查提示词: {}", prompt);

            String aiResponse = aiServiceClient.callTextAI(prompt);
            log.debug("AI韵脚检查响应: {}", aiResponse);

            return parseRhymeCheckResponse(aiResponse);

        } catch (Exception e) {
            log.error("韵脚检查失败", e);
            return getDefaultRhymeCheckResult();
        }
    }

    /**
     * 构建润色提示词
     */
    private String buildPolishPrompt(String content) {
        return String.format(
                "你是一位专业的诗词润色专家。请对以下诗词进行润色优化：\n\n" +
                        "【原诗词】\n%s\n\n" +
                        "【润色要求】\n" +
                        "1. 检查并修正错别字\n" +
                        "2. 检查韵脚是否押韵，如不押韵请调整\n" +
                        "3. 检查平仄是否协调，如不协调请优化\n" +
                        "4. 保持原诗的主题和意境\n" +
                        "5. 优化用词，使语言更加优美典雅\n" +
                        "6. 保持古典诗词的格律规范\n\n" +
                        "【返回格式】\n" +
                        "请返回JSON格式，包含以下字段：\n" +
                        "{\n" +
                        "  \"original\": \"原诗词内容\",\n" +
                        "  \"polished\": \"润色后的诗词\",\n" +
                        "  \"explanation\": \"润色说明（简要说明修正了哪些错别字、韵脚调整等）\",\n" +
                        "  \"corrections\": \"修正说明（列出修正的错别字和韵脚问题）\"\n" +
                        "}\n\n" +
                        "请直接返回JSON，不要添加其他内容：",
                content
        );
    }

    /**
     * 构建韵脚检查提示词
     */
    private String buildRhymeCheckPrompt(String content) {
        return String.format(
                "你是一位专业的诗词格律专家。请对以下诗词进行韵脚检查：\n\n" +
                        "【诗词内容】\n%s\n\n" +
                        "【检查要求】\n" +
                        "1. 找出每句的最后一个字（押韵字）\n" +
                        "2. 判断这些字是否属于同一韵部\n" +
                        "3. 如果不押韵，给出建议的修改方案\n" +
                        "4. 说明当前使用的韵部\n\n" +
                        "【返回格式】\n" +
                        "请返回JSON格式，包含以下字段：\n" +
                        "{\n" +
                        "  \"content\": \"原诗词内容\",\n" +
                        "  \"rhymingWords\": [\"每句的押韵字列表\"],\n" +
                        "  \"isRhyming\": true/false,\n" +
                        "  \"rhymeCategory\": \"韵部名称（如：平水韵·一东）\",\n" +
                        "  \"explanation\": \"韵脚分析说明\",\n" +
                        "  \"suggestions\": \"如果不押韵，给出修改建议\"\n" +
                        "}\n\n" +
                        "请直接返回JSON，不要添加其他内容：",
                content
        );
    }

    /**
     * 解析润色响应
     */
    private Map<String, Object> parsePolishResponse(String response) {
        try {
            // 尝试提取JSON
            String jsonStr = extractJson(response);
            JsonNode jsonNode = objectMapper.readTree(jsonStr);

            Map<String, Object> result = new HashMap<>();
            result.put("original", jsonNode.has("original") ? jsonNode.get("original").asText() : "");
            result.put("polished", jsonNode.has("polished") ? jsonNode.get("polished").asText() : "");
            result.put("explanation", jsonNode.has("explanation") ? jsonNode.get("explanation").asText() : "");
            result.put("corrections", jsonNode.has("corrections") ? jsonNode.get("corrections").asText() : "");

            return result;

        } catch (Exception e) {
            log.error("解析润色响应失败", e);
            // 如果解析失败，直接返回原内容
            Map<String, Object> result = new HashMap<>();
            result.put("original", "");
            result.put("polished", response);
            result.put("explanation", "AI润色完成");
            result.put("corrections", "");
            return result;
        }
    }

    /**
     * 解析韵脚检查响应
     */
    private Map<String, Object> parseRhymeCheckResponse(String response) {
        try {
            String jsonStr = extractJson(response);
            JsonNode jsonNode = objectMapper.readTree(jsonStr);

            Map<String, Object> result = new HashMap<>();
            result.put("content", jsonNode.has("content") ? jsonNode.get("content").asText() : "");

            // 处理 rhymingWords 数组
            if (jsonNode.has("rhymingWords") && jsonNode.get("rhymingWords").isArray()) {
                java.util.List<String> words = new ArrayList<>();
                for (JsonNode word : jsonNode.get("rhymingWords")) {
                    words.add(word.asText());
                }
                result.put("rhymingWords", words);
            } else {
                result.put("rhymingWords", new ArrayList<>());
            }

            result.put("isRhyming", jsonNode.has("isRhyming") && jsonNode.get("isRhyming").asBoolean());
            result.put("rhymeCategory", jsonNode.has("rhymeCategory") ? jsonNode.get("rhymeCategory").asText() : "");
            result.put("explanation", jsonNode.has("explanation") ? jsonNode.get("explanation").asText() : "");
            result.put("suggestions", jsonNode.has("suggestions") ? jsonNode.get("suggestions").asText() : "");

            return result;

        } catch (Exception e) {
            log.error("解析韵脚检查响应失败", e);
            return getDefaultRhymeCheckResult();
        }
    }

    /**
     * 从响应中提取JSON
     */
    private String extractJson(String response) {
        if (response == null || response.isEmpty()) {
            return "{}";
        }
        // 尝试找到JSON的开始和结束
        int start = response.indexOf('{');
        int end = response.lastIndexOf('}');
        if (start >= 0 && end > start) {
            return response.substring(start, end + 1);
        }
        return response;
    }

    /**
     * 获取默认润色结果
     */
    private Map<String, Object> getDefaultPolishResult() {
        Map<String, Object> result = new HashMap<>();
        result.put("original", "");
        result.put("polished", "润色失败，请稍后重试");
        result.put("explanation", "AI服务暂时不可用");
        result.put("corrections", "");
        return result;
    }

    /**
     * 获取默认韵脚检查结果
     */
    private Map<String, Object> getDefaultRhymeCheckResult() {
        Map<String, Object> result = new HashMap<>();
        result.put("content", "");
        result.put("rhymingWords", new ArrayList<>());
        result.put("isRhyming", false);
        result.put("rhymeCategory", "");
        result.put("explanation", "韵脚检查失败，请稍后重试");
        result.put("suggestions", "");
        return result;
    }
}