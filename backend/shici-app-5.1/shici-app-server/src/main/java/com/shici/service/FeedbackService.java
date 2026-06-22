package com.shici.service;

import com.shici.domain.Feedback;

import java.util.List;
import java.util.Map;

public interface FeedbackService {
    Feedback submit(Feedback feedback);
    List<Map<String, Object>> listMyFeedback(Long userId, int page, int size);
}