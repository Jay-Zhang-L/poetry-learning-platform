package com.shici.service;

import com.shici.domain.CreationWork;
import com.shici.domain.Notification;
import com.shici.domain.dto.CommentDto;
import com.shici.mapper.CreationCommentMapper;
import com.shici.mapper.CreationMapper;
import com.shici.mapper.NotificationMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CommentService {
    
    @Autowired
    private CreationCommentMapper commentMapper;
    
    @Autowired
    private CreationMapper creationMapper;
    
    @Autowired
    private NotificationMapper notificationMapper;
    
    public Map<String, Object> getComments(Long workId, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        List<CommentDto> list = commentMapper.findByWorkId(workId, offset, pageSize);
        int total = commentMapper.countByWorkId(workId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("total", total);
        result.put("hasMore", offset + list.size() < total);
        return result;
    }
    
    @Transactional
    public CommentDto create(Long workId, Long userId, String content, Long parentId) {
        try {
            // 插入评论
            int rows = commentMapper.insert(workId, userId, content, parentId);
            if (rows == 0) {
                throw new RuntimeException("插入评论失败");
            }
            
            // 更新作品评论数
            creationMapper.updateCommentCount(workId, 1);
            
            // 创建通知
            CreationWork work = creationMapper.findById(workId);
            if (work != null && !work.getUserId().equals(userId)) {
                Notification notification = new Notification();
                notification.setUserId(work.getUserId());
                notification.setFromUserId(userId);
                notification.setType("comment");
                notification.setTargetType("work");
                notification.setTargetId(workId);
                notification.setContent(content.length() > 100 ? content.substring(0, 100) + "..." : content);
                notification.setIsRead(false);
                notificationMapper.insert(notification);
            }
            
            // 返回新创建的评论（查询该用户在该作品下最新的评论）
            List<CommentDto> comments = commentMapper.findByWorkId(workId, 0, 20);
            // 找到当前用户的最新评论
            for (CommentDto comment : comments) {
                if (comment.getUserId().equals(userId) && comment.getContent().equals(content)) {
                    return comment;
                }
            }
            
            // 如果没找到，返回null（不应该发生）
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("创建评论失败：" + e.getMessage(), e);
        }
    }
    
    @Transactional
    public boolean delete(Long commentId, Long userId) {
        return commentMapper.deleteByIdAndUserId(commentId, userId) > 0;
    }
}
