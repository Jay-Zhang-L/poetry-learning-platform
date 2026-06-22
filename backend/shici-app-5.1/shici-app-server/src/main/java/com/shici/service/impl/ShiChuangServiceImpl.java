package com.shici.service.impl;

import com.shici.mapper.ShiChuangMapper;
import com.shici.service.ShiChuangService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ShiChuangServiceImpl implements ShiChuangService {

    private static final Pattern SPLIT_LINE = Pattern.compile("[\\r\\n]+");
    private static final Pattern SPLIT_TOKEN = Pattern.compile("[\\s，。；、】【、,.!?？！:：\"“”'‘’()（）]+");

    private static final int DEFAULT_LIMIT = 8;
    private static final int MAX_LINES = 6;
    private static final int MAX_TOKENS = 6;

    private final ShiChuangMapper shiChuangMapper;

    @Override
    public List<Map<String, Object>> searchByRecognizedText(String recognizedText, Integer limit) {
        int finalLimit = (limit == null || limit <= 0) ? DEFAULT_LIMIT : limit;
        String text = normalize(recognizedText);
        if (text.isEmpty()) {
            return List.of();
        }

        Map<Long, ScoreHolder> scoreMap = new HashMap<>();

        // 1) 整段匹配：优先查最有价值的字段，避免大范围重扫
        if (text.length() >= 2 && text.length() <= 30) {
            mergeWithScore(scoreMap, shiChuangMapper.searchByQuote(text, finalLimit), 160);
            if (text.length() <= 20) {
                mergeWithScore(scoreMap, shiChuangMapper.searchByContent(text, finalLimit), 100);
            }
            if (text.length() <= 12) {
                mergeWithScore(scoreMap, shiChuangMapper.searchByTitle(text, finalLimit), 90);
                mergeWithScore(scoreMap, shiChuangMapper.searchByAuthor(text, finalLimit), 80);
            }
            if (scoreMap.size() >= finalLimit) {
                return topResults(scoreMap, finalLimit);
            }
        }

        // 2) 按行匹配：只取前两行，减少查询次数
        List<String> lines = Arrays.stream(SPLIT_LINE.split(text))
                .map(this::normalize)
                .filter(s -> !s.isBlank())
                .filter(s -> s.length() >= 4)
                .distinct()
                .limit(MAX_LINES)
                .collect(Collectors.toList());

        for (String line : lines) {
            mergeWithScore(scoreMap, shiChuangMapper.searchByQuote(line, finalLimit), scoreByLength(line, 130));

            // 只有较短的行才查 content，避免全文模糊匹配过重
            if (line.length() <= 18) {
                mergeWithScore(scoreMap, shiChuangMapper.searchByContent(line, finalLimit), scoreByLength(line, 80));
            }

            if (line.length() <= 12) {
                mergeWithScore(scoreMap, shiChuangMapper.searchByTitle(line, finalLimit), scoreByLength(line, 70));
            }
        }

        if (scoreMap.size() >= finalLimit) {
            return topResults(scoreMap, finalLimit);
        }

        // 3) 分词匹配：限制 token 数量，不再对 content 做循环检索
        List<String> tokens = Arrays.stream(SPLIT_TOKEN.split(text))
                .map(this::normalize)
                .filter(s -> !s.isBlank())
                .filter(s -> s.length() >= 2 && s.length() <= 8)
                .distinct()
                .limit(MAX_TOKENS)
                .collect(Collectors.toList());

        for (String token : tokens) {
            mergeWithScore(scoreMap, shiChuangMapper.searchByTitle(token, finalLimit), scoreByLength(token, 50));
            mergeWithScore(scoreMap, shiChuangMapper.searchByAuthor(token, finalLimit), scoreByLength(token, 60));
            mergeWithScore(scoreMap, shiChuangMapper.searchByQuote(token, finalLimit), scoreByLength(token, 30));
        }

        return topResults(scoreMap, finalLimit);
    }

    @Override
    public List<Map<String, Object>> recommendByAiTags(List<String> tags, String summary, Integer limit) {
        LinkedHashMap<Long, Map<String, Object>> merged = new LinkedHashMap<>();
        int finalLimit = (limit == null || limit <= 0) ? DEFAULT_LIMIT : limit;

        if (tags != null) {
            for (String tag : tags) {
                if (tag == null || tag.isBlank()) continue;
                putAll(merged, shiChuangMapper.recommendBySingleTag(tag.trim(), finalLimit));
                if (merged.size() >= finalLimit) break;
            }
        }

        if (merged.size() < finalLimit && summary != null && !summary.isBlank()) {
            putAll(merged, shiChuangMapper.recommendBySummary(summary.trim(), finalLimit));
        }

        if (merged.size() < finalLimit) {
            putAll(merged, shiChuangMapper.recommendHot(finalLimit));
        }

        return merged.values().stream().limit(finalLimit).collect(Collectors.toList());
    }

    @Override
    public Map<String, Object> getDetail(Long id) {
        return shiChuangMapper.getDetail(id);
    }

    @Override
    public String buildReason(Map<String, Object> poem, List<String> tags, String summary) {
        List<String> parts = new ArrayList<>();
        if (tags != null && !tags.isEmpty()) {
            parts.add("识别到的画面意象为" + String.join("、", tags));
        }
        Object scenery = poem.get("scenery");
        Object season = poem.get("season");
        Object theme = poem.get("theme");

        if (scenery != null && !String.valueOf(scenery).isBlank()) {
            parts.add("作品景象偏向" + scenery);
        }
        if (season != null && !String.valueOf(season).isBlank()) {
            parts.add("季节气息偏向" + season);
        }
        if (theme != null && !String.valueOf(theme).isBlank()) {
            parts.add("主题更接近" + theme);
        }
        if (summary != null && !summary.isBlank()) {
            parts.add("整体画面可概括为“" + summary + "”");
        }
        return parts.isEmpty() ? "推荐与当前画面较为贴合。" : String.join("，", parts) + "。";
    }

    private List<Map<String, Object>> topResults(Map<Long, ScoreHolder> scoreMap, int limit) {
        if (scoreMap.isEmpty()) {
            return List.of();
        }
        return scoreMap.values().stream()
                .sorted((a, b) -> {
                    int scoreCompare = Integer.compare(b.score, a.score);
                    if (scoreCompare != 0) return scoreCompare;

                    int hotA = toInt(a.data.get("hot"));
                    int hotB = toInt(b.data.get("hot"));
                    return Integer.compare(hotB, hotA);
                })
                .limit(limit)
                .map(holder -> holder.data)
                .collect(Collectors.toList());
    }

    private void mergeWithScore(Map<Long, ScoreHolder> scoreMap, List<Map<String, Object>> list, int score) {
        if (list == null) return;
        for (Map<String, Object> item : list) {
            if (item == null || item.get("id") == null) continue;
            Long id = Long.valueOf(String.valueOf(item.get("id")));
            ScoreHolder holder = scoreMap.computeIfAbsent(id, k -> new ScoreHolder(item));
            holder.score += score;
        }
    }

    private void putAll(LinkedHashMap<Long, Map<String, Object>> merged, List<Map<String, Object>> list) {
        if (list == null) return;
        for (Map<String, Object> item : list) {
            if (item == null || item.get("id") == null) continue;
            Long id = Long.valueOf(String.valueOf(item.get("id")));
            merged.putIfAbsent(id, item);
        }
    }

    private int scoreByLength(String text, int base) {
        int len = text == null ? 0 : text.length();
        if (len >= 10) return base + 35;
        if (len >= 7) return base + 20;
        if (len >= 4) return base + 10;
        return base;
    }

    private int toInt(Object value) {
        if (value == null) return 0;
        try {
            return Integer.parseInt(String.valueOf(value));
        } catch (Exception e) {
            return 0;
        }
    }

    private String normalize(String text) {
        if (text == null) return "";
        return text.replace('\u3000', ' ')
                .replaceAll("\\s+", " ")
                .trim();
    }

    private static class ScoreHolder {
        private final Map<String, Object> data;
        private int score = 0;

        private ScoreHolder(Map<String, Object> data) {
            this.data = data;
        }
    }
}
