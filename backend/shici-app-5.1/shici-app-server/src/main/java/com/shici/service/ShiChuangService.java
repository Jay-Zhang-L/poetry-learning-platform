package com.shici.service;

import java.util.List;
import java.util.Map;

public interface ShiChuangService {

    List<Map<String, Object>> searchByRecognizedText(String recognizedText, Integer limit);

    List<Map<String, Object>> recommendByAiTags(List<String> tags, String summary, Integer limit);

    Map<String, Object> getDetail(Long id);

    String buildReason(Map<String, Object> poem, List<String> tags, String summary);
}
