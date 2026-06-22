package com.shici.service;

import com.shici.domain.Notification;
import com.shici.mapper.NotificationMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class NotificationService {
    
    @Autowired
    private NotificationMapper notificationMapper;
    
    public Map<String, Object> getList(Long userId, String type, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        List<Notification> list = notificationMapper.findList(userId, type, null, offset, pageSize);
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("hasMore", list.size() >= pageSize);
        return result;
    }
    
    public int getUnreadCount(Long userId) {
        return notificationMapper.countUnread(userId);
    }
    
    public Map<String, Integer> getUnreadCountByType(Long userId) {
        Map<String, Integer> counts = new HashMap<>();
        counts.put("all", notificationMapper.countUnread(userId));
        counts.put("like", notificationMapper.countUnreadByType(userId, "like"));
        counts.put("comment", notificationMapper.countUnreadByType(userId, "comment"));
        counts.put("mention", notificationMapper.countUnreadByType(userId, "mention"));
        counts.put("message", notificationMapper.countUnreadByType(userId, "message"));
        counts.put("follow", notificationMapper.countUnreadByType(userId, "follow"));
        counts.put("favorite", notificationMapper.countUnreadByType(userId, "favorite"));
        return counts;
    }
    
    @Transactional
    public boolean markAsRead(Long id) {
        return notificationMapper.markAsRead(id) > 0;
    }
    
    @Transactional
    public boolean markAllAsRead(Long userId) {
        return notificationMapper.markAllAsRead(userId) > 0;
    }
    
    @Transactional
    public boolean create(Notification notification) {
        return notificationMapper.insert(notification) > 0;
    }
}
