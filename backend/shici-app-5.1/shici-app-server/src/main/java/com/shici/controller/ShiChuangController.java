package com.shici.controller;

import com.shici.common.R;
import com.shici.service.PaddleOcrService;
import com.shici.service.QwenVisionService;
import com.shici.service.ShiChuangService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/shichuang")
@RequiredArgsConstructor
public class ShiChuangController {

    private static final long MAX_SIZE = 10L * 1024 * 1024; // 10MB

    private final ShiChuangService shiChuangService;
    private final PaddleOcrService paddleOcrService;
    private final QwenVisionService qwenVisionService;

    @GetMapping("/ping")
    public R<?> ping() {
        return R.ok("pong");
    }

    @GetMapping("/search")
    public R<?> search(@RequestParam("keyword") String keyword,
                       @RequestParam(value = "limit", defaultValue = "8") Integer limit) {
        try {
            long start = System.currentTimeMillis();
            List<Map<String, Object>> poems = shiChuangService.searchByRecognizedText(keyword, limit);

            Map<String, Object> bestPoem = poems.isEmpty() ? null : poems.get(0);
            Map<String, Object> fullBestPoem = enrichPoemDetail(bestPoem);

            Map<String, Object> data = new HashMap<>();
            data.put("items", poems);
            data.put("itemsLite", poems.stream().map(this::simplifyPoem).toList());
            data.put("bestPoem", fullBestPoem);
            data.put("bestPoemLite", simplifyPoem(fullBestPoem));

            log.info("诗窗搜索完成，keywordLength={}, resultCount={}, cost={}ms",
                    keyword == null ? 0 : keyword.length(), poems.size(), System.currentTimeMillis() - start);
            return R.ok(data);
        } catch (Exception e) {
            log.error("诗窗搜索失败", e);
            return R.fail("搜索失败：" + e.getMessage());
        }
    }

    @PostMapping("/recognize-from-image")
    public R<?> recognizeFromImage(
            @RequestParam(value = "image", required = false) MultipartFile image,
            @RequestParam(value = "file", required = false) MultipartFile file) {
        long totalStart = System.currentTimeMillis();
        try {
            MultipartFile upload = pickUpload(image, file);
            if (upload == null || upload.isEmpty()) {
                return R.fail("图片不能为空");
            }
            if (upload.getSize() > MAX_SIZE) {
                return R.fail("图片不能超过10MB");
            }

            log.info("开始识诗，fileName={}, size={}bytes", upload.getOriginalFilename(), upload.getSize());

            long ocrStart = System.currentTimeMillis();
            String recognizedText = paddleOcrService.recognize(upload);
            long ocrCost = System.currentTimeMillis() - ocrStart;

            recognizedText = recognizedText == null ? "" : recognizedText.trim();
            log.info("OCR完成，textLength={}, cost={}ms, preview={}",
                    recognizedText.length(), ocrCost, preview(recognizedText));

            if (recognizedText.isEmpty()) {
                Map<String, Object> empty = new HashMap<>();
                empty.put("recognizedText", "");
                empty.put("bestPoem", null);
                empty.put("poems", List.of());
                empty.put("bestPoemLite", null);
                empty.put("poemsLite", List.of());
                log.info("OCR未识别到文本，totalCost={}ms", System.currentTimeMillis() - totalStart);
                return R.ok(empty);
            }

            long searchStart = System.currentTimeMillis();
            List<Map<String, Object>> poems = shiChuangService.searchByRecognizedText(recognizedText, 8);
            long searchCost = System.currentTimeMillis() - searchStart;

            Map<String, Object> bestPoem = poems.isEmpty() ? null : poems.get(0);

            long detailStart = System.currentTimeMillis();
            Map<String, Object> fullBestPoem = enrichPoemDetail(bestPoem);
            long detailCost = System.currentTimeMillis() - detailStart;

            Map<String, Object> data = new HashMap<>();
            data.put("recognizedText", recognizedText);

            // 网页端：最佳匹配补全详情，保留译文和赏析
            data.put("bestPoem", fullBestPoem);
            // 候选列表保持轻量，避免响应过大
            data.put("poems", poems);

            // 小程序端轻量数据
            data.put("bestPoemLite", simplifyPoem(fullBestPoem));
            data.put("poemsLite", poems.stream().map(this::simplifyPoem).toList());

            log.info("识诗完成，matchCount={}, searchCost={}ms, detailCost={}ms, totalCost={}ms",
                    poems.size(), searchCost, detailCost, System.currentTimeMillis() - totalStart);
            return R.ok(data);
        } catch (Exception e) {
            log.error("诗词识别失败，totalCost={}ms", System.currentTimeMillis() - totalStart, e);
            return R.fail("诗词识别失败：" + e.getMessage());
        }
    }

    @PostMapping("/recommend-by-image")
    public R<?> recommendByImage(
            @RequestParam(value = "image", required = false) MultipartFile image,
            @RequestParam(value = "file", required = false) MultipartFile file) {
        long totalStart = System.currentTimeMillis();
        try {
            MultipartFile upload = pickUpload(image, file);
            if (upload == null || upload.isEmpty()) {
                return R.fail("图片不能为空");
            }
            if (upload.getSize() > MAX_SIZE) {
                return R.fail("图片不能超过10MB");
            }

            log.info("开始风景配诗，fileName={}, size={}bytes", upload.getOriginalFilename(), upload.getSize());

            Map<String, Object> ai = qwenVisionService.analyzeScene(upload);

            @SuppressWarnings("unchecked")
            List<String> tags = (List<String>) ai.getOrDefault("tags", List.of());

            @SuppressWarnings("unchecked")
            List<String> themes = (List<String>) ai.getOrDefault("themes", List.of());

            @SuppressWarnings("unchecked")
            List<String> seasons = (List<String>) ai.getOrDefault("seasons", List.of());

            @SuppressWarnings("unchecked")
            List<String> emotions = (List<String>) ai.getOrDefault("emotions", List.of());

            @SuppressWarnings("unchecked")
            List<String> scenes = (List<String>) ai.getOrDefault("scenes", List.of());

            @SuppressWarnings("unchecked")
            List<String> festivals = (List<String>) ai.getOrDefault("festivals", List.of());

            @SuppressWarnings("unchecked")
            List<String> periods = (List<String>) ai.getOrDefault("periods", List.of());

            @SuppressWarnings("unchecked")
            List<String> forms = (List<String>) ai.getOrDefault("forms", List.of());

            @SuppressWarnings("unchecked")
            List<String> poemTypes = (List<String>) ai.getOrDefault("poemTypes", List.of());

            @SuppressWarnings("unchecked")
            List<String> rhetorics = (List<String>) ai.getOrDefault("rhetorics", List.of());

            @SuppressWarnings("unchecked")
            List<String> famousTypes = (List<String>) ai.getOrDefault("famousTypes", List.of());

            @SuppressWarnings("unchecked")
            List<String> dynasties = (List<String>) ai.getOrDefault("dynasties", List.of());

            String summary = (String) ai.getOrDefault("summary", "");
            String ocrText = (String) ai.getOrDefault("ocrText", "");

            List<Map<String, Object>> poems = shiChuangService.recommendByAiTags(tags, summary, 8);
            for (Map<String, Object> poem : poems) {
                poem.put("reason", shiChuangService.buildReason(poem, tags, summary));
            }

            Map<String, Object> data = new HashMap<>();
            data.put("tags", tags);
            data.put("themes", themes);
            data.put("seasons", seasons);
            data.put("emotions", emotions);
            data.put("scenes", scenes);
            data.put("festivals", festivals);
            data.put("periods", periods);
            data.put("forms", forms);
            data.put("poemTypes", poemTypes);
            data.put("rhetorics", rhetorics);
            data.put("famousTypes", famousTypes);
            data.put("dynasties", dynasties);
            data.put("summary", summary);
            data.put("ocrText", ocrText);

            data.put("poems", poems);
            data.put("poemsLite", poems.stream().map(this::simplifyPoemWithReason).toList());

            log.info("风景配诗完成，tagCount={}, resultCount={}, totalCost={}ms",
                    tags.size(), poems.size(), System.currentTimeMillis() - totalStart);
            return R.ok(data);
        } catch (Exception e) {
            log.error("风景配诗失败，totalCost={}ms", System.currentTimeMillis() - totalStart, e);
            return R.fail("风景配诗失败：" + e.getMessage());
        }
    }

    @GetMapping("/detail/{id}")
    public R<?> detail(@PathVariable Long id) {
        return R.ok(shiChuangService.getDetail(id));
    }

    private MultipartFile pickUpload(MultipartFile image, MultipartFile file) {
        return image != null ? image : file;
    }

    private Map<String, Object> simplifyPoem(Map<String, Object> poem) {
        if (poem == null) return null;

        Map<String, Object> result = new HashMap<>();
        result.put("id", poem.get("id"));
        result.put("title", poem.get("title"));
        result.put("author", poem.get("author"));
        result.put("dynasty", poem.get("dynasty"));
        result.put("content", poem.get("content"));
        result.put("quote", poem.get("quote"));
        return result;
    }

    private Map<String, Object> simplifyPoemWithReason(Map<String, Object> poem) {
        Map<String, Object> result = simplifyPoem(poem);
        if (result != null) {
            result.put("reason", poem.get("reason"));
        }
        return result;
    }

    private Map<String, Object> enrichPoemDetail(Map<String, Object> poem) {
        if (poem == null || poem.get("id") == null) {
            return poem;
        }
        try {
            Long id = Long.valueOf(String.valueOf(poem.get("id")));
            Map<String, Object> detail = shiChuangService.getDetail(id);
            if (detail == null || detail.isEmpty()) {
                return poem;
            }
            if (poem.get("reason") != null && detail.get("reason") == null) {
                detail.put("reason", poem.get("reason"));
            }
            return detail;
        } catch (Exception e) {
            log.warn("补全诗词详情失败，poemId={}", poem.get("id"), e);
            return poem;
        }
    }

    private String preview(String text) {
        if (text == null || text.isBlank()) return "";
        return text.length() <= 40 ? text : text.substring(0, 40) + "...";
    }
}
