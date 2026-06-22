package com.shici.service.impl;

import com.shici.domain.Feedback;
import com.shici.mapper.FeedbackMapper;
import com.shici.service.FeedbackService;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class FeedbackServiceImpl implements FeedbackService {

    private final FeedbackMapper feedbackMapper;

    public FeedbackServiceImpl(FeedbackMapper feedbackMapper) {
        this.feedbackMapper = feedbackMapper;
    }

    @Override
    public Feedback submit(Feedback feedback) {
        if (feedback.getContent() == null || feedback.getContent().trim().isEmpty()) {
            throw new RuntimeException("反馈内容不能为空");
        }
        feedbackMapper.insert(feedback);
        return feedback;
    }

    @Override
    public List<Map<String, Object>> listMyFeedback(Long userId, int page, int size) {
        int offset = Math.max(0, (page - 1) * size);
        List<Map<String, Object>> list = feedbackMapper.listByUserId(userId, offset, size);

        // 添加分页信息
        int total = feedbackMapper.countByUserId(userId);
        for (Map<String, Object> item : list) {
            item.put("total", total);
        }

        return list;
    }
}