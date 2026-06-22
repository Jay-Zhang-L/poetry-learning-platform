package com.shici.controller;

import com.shici.service.KnowledgeService;
import com.shici.domain.vo.KnowledgeVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/knowledge")

public class KnowledgeController {

    @Autowired
    private KnowledgeService knowledgeService;

    /**
     * 获取所有知识卡片列表
     * GET /api/knowledge/list
     * @return 知识卡片列表
     */
    @GetMapping("/list")
    public Map<String, Object> getList() {
        Map<String, Object> result = new HashMap<>();
        try {
            List<KnowledgeVO> list = knowledgeService.getKnowledgeList();
            result.put("code", 200);
            result.put("data", list);
            result.put("message", "success");
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 获取知识卡片详情
     * GET /api/knowledge/detail/{pageKey}
     * @param pageKey 卡片标识
     * @return 知识卡片详情
     */
    @GetMapping("/detail/{pageKey}")
    public Map<String, Object> getDetail(@PathVariable String pageKey) {
        Map<String, Object> result = new HashMap<>();
        try {
            KnowledgeVO detail = knowledgeService.getKnowledgeDetail(pageKey);
            if (detail == null) {
                result.put("code", 404);
                result.put("message", "知识卡片不存在");
            } else {
                result.put("code", 200);
                result.put("data", detail);
                result.put("message", "success");
            }
        } catch (Exception e) {
            result.put("code", 500);
            result.put("message", e.getMessage());
        }
        return result;
    }
}