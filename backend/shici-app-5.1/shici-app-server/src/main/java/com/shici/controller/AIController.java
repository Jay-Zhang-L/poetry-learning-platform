package com.shici.controller;

import com.shici.domain.dto.AIRequestDTO;
import com.shici.domain.vo.AIResponseVO;
import com.shici.service.AIPolishService;
import com.shici.service.AIService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/ai")
@CrossOrigin(origins = {"http://localhost:5173", "http://127.0.0.1:5173"})
public class AIController {

    @Autowired
    private AIService aiService;

    @Autowired
    private AIPolishService aiPolishService;  // 新增注入

    /**
     * AI对话接口
     */
    @PostMapping("/chat")
    public ResponseEntity<AIResponseVO> chat(@Valid @RequestBody AIRequestDTO request) {
        log.info("收到AI请求，mode: {}, message: {}", request.getMode(), request.getMessage());

        AIResponseVO response = aiService.chat(request);

        if (response.getSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    /**
     * 获取所有可用模式
     */
    @GetMapping("/modes")
    public ResponseEntity<List<String>> getModes() {
        return ResponseEntity.ok(aiService.getModes());
    }

    /**
     * 健康检查接口
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        Map<String, String> status = new HashMap<>();
        status.put("status", "ok");
        status.put("service", "AI Service");
        status.put("time", String.valueOf(System.currentTimeMillis()));
        return ResponseEntity.ok(status);
    }

    // ==================== 新增：AI润色接口 ====================

    /**
     * AI润色接口
     * POST /api/ai/polish
     */
    @PostMapping("/polish")
    public ResponseEntity<Map<String, Object>> polish(@RequestBody Map<String, String> params) {
        String content = params.get("content");
        log.info("收到AI润色请求，内容长度: {}", content != null ? content.length() : 0);

        if (content == null || content.trim().isEmpty()) {
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("code", 400);
            errorResult.put("message", "内容不能为空");
            return ResponseEntity.badRequest().body(errorResult);
        }

        try {
            Map<String, Object> result = aiPolishService.polish(content);

            // 转换格式以匹配前端期望
            Map<String, Object> response = new HashMap<>();
            response.put("code", 200);
            response.put("message", "success");
            response.put("data", formatPolishResultForFrontend(result));

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("AI润色失败", e);
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("code", 500);
            errorResult.put("message", "AI润色失败: " + e.getMessage());
            return ResponseEntity.status(500).body(errorResult);
        }
    }

    /**
     * 格式化润色结果，匹配前端期望的数据结构
     */
    private Map<String, Object> formatPolishResultForFrontend(Map<String, Object> polishResult) {
        Map<String, Object> formatted = new HashMap<>();

        // 错别字检查结果
        List<Map<String, String>> spellingErrors = new java.util.ArrayList<>();
        String corrections = (String) polishResult.getOrDefault("corrections", "");
        if (corrections != null && !corrections.isEmpty()) {
            // 解析修正说明，生成错别字列表
            Map<String, String> error = new HashMap<>();
            error.put("original", "待修正");
            error.put("suggested", polishResult.getOrDefault("polished", "").toString());
            error.put("reason", corrections);
            spellingErrors.add(error);
        }
        formatted.put("spellingErrors", spellingErrors);

        // 韵脚信息（简化版）
        Map<String, Object> rhymeInfo = new HashMap<>();
        rhymeInfo.put("status", "已检查");
        rhymeInfo.put("currentRhyme", "根据AI分析");
        rhymeInfo.put("suggestion", polishResult.getOrDefault("explanation", ""));
        formatted.put("rhymeInfo", rhymeInfo);

        // 韵律信息
        Map<String, Object> rhythmInfo = new HashMap<>();
        rhythmInfo.put("detail", polishResult.getOrDefault("explanation", ""));
        rhythmInfo.put("suggestion", "");
        formatted.put("rhythmInfo", rhythmInfo);

        // 整体建议
        formatted.put("generalAdvice", polishResult.getOrDefault("explanation", ""));

        // 润色后的内容
        formatted.put("polishedContent", polishResult.getOrDefault("polished", ""));

        return formatted;
    }

    /**
     * 单独检查韵脚接口
     * POST /api/ai/check-rhyme
     */
    @PostMapping("/check-rhyme")
    public ResponseEntity<Map<String, Object>> checkRhyme(@RequestBody Map<String, String> params) {
        String content = params.get("content");
        log.info("收到韵脚检查请求");

        if (content == null || content.trim().isEmpty()) {
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("code", 400);
            errorResult.put("message", "内容不能为空");
            return ResponseEntity.badRequest().body(errorResult);
        }

        try {
            Map<String, Object> result = aiPolishService.checkRhyme(content);

            Map<String, Object> response = new HashMap<>();
            response.put("code", 200);
            response.put("message", "success");
            response.put("data", result);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("韵脚检查失败", e);
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("code", 500);
            errorResult.put("message", "韵脚检查失败: " + e.getMessage());
            return ResponseEntity.status(500).body(errorResult);
        }
    }
}