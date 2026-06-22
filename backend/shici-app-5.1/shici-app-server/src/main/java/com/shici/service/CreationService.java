package com.shici.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shici.domain.CreationWork;
import com.shici.domain.Notification;
import com.shici.mapper.*;
import com.shici.mapper.UserLikeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CreationService {

    @Autowired
    private CreationMapper creationMapper;

    @Autowired
    private NotificationMapper notificationMapper;

    @Autowired
    private CreationTagMapper tagMapper;

    @Autowired
    private CreationMentionMapper mentionMapper;

    @Autowired
    private UserFollowMapper userFollowMapper;

    @Autowired
    private UserLikeMapper userLikeMapper;

    private final ObjectMapper objectMapper = new ObjectMapper();
    private static final String BASE_URL = "http://localhost:8080";

    /**
     * 解析图片JSON字符串并转换为完整URL数组
     */
    private List<String> parseImageUrls(String imagesJson) {
        if (imagesJson == null || imagesJson.trim().isEmpty()) {
            return new ArrayList<>();
        }

        try {
            List<String> paths = objectMapper.readValue(imagesJson, new TypeReference<List<String>>() {});
            List<String> fullUrls = new ArrayList<>();
            for (String path : paths) {
                if (path != null && !path.trim().isEmpty()) {
                    // 如果是完整URL，直接使用；否则拼接基础URL
                    if (path.startsWith("http://") || path.startsWith("https://")) {
                        fullUrls.add(path);
                    } else {
                        fullUrls.add(BASE_URL + path);
                    }
                }
            }
            return fullUrls;
        } catch (Exception e) {
            System.err.println("解析图片URL失败: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    /**
     * 处理作品列表，补充图片URL等信息
     */
    private void enrichWorks(List<CreationWork> works) {
        if (works == null || works.isEmpty()) {
            return;
        }

        for (CreationWork work : works) {
            // 处理图片URL
            List<String> imageUrls = parseImageUrls(work.getImages());
            work.setImageUrls(imageUrls);

            // 确保其他字段不为null
            if (work.getLikeCount() == null) work.setLikeCount(0);
            if (work.getCommentCount() == null) work.setCommentCount(0);
            if (work.getSaveCount() == null) work.setSaveCount(0);
            if (work.getViewCount() == null) work.setViewCount(0);
        }
    }

    public CreationWork getById(Long id, Long currentUserId) {
        CreationWork work = creationMapper.findById(id);
        if (work != null) {
            List<String> tags = tagMapper.findTagsByWorkId(id);
            work.setTags(tags);

            List<Long> mentionUserIds = mentionMapper.findUserIdsByWorkId(id);
            work.setMentionUserIds(mentionUserIds);

            if (currentUserId != null) {
                work.setViewerLiked(creationMapper.isLikedByUser(currentUserId, id));
                work.setViewerSaved(creationMapper.isSavedByUser(currentUserId, id));
                creationMapper.incrementViewCount(id);
            }

            // 处理图片URL
            List<String> imageUrls = parseImageUrls(work.getImages());
            work.setImageUrls(imageUrls);
        }
        return work;
    }

    public Map<String, Object> getList(String tab, Long currentUserId, String type,
                                       String sortBy, int page, int pageSize) {
        int offset = (page - 1) * pageSize;

        List<CreationWork> list;

        if ("follow".equals(tab) && currentUserId != null) {
            // 关注流：只显示关注用户的公开作品
            List<Long> workIds = userFollowMapper.findFollowedUserWorkIds(currentUserId, offset, pageSize);
            if (workIds.isEmpty()) {
                list = List.of();
            } else {
                list = creationMapper.findByIds(workIds);
            }
        } else {
            // 推荐流或类型筛选
            Map<String, Object> params = new HashMap<>();
            params.put("type", type);
            params.put("sortBy", sortBy);
            params.put("offset", offset);
            params.put("limit", pageSize);

            list = creationMapper.findList(params);
        }

        if (currentUserId != null) {
            for (CreationWork work : list) {
                work.setViewerLiked(creationMapper.isLikedByUser(currentUserId, work.getId()));
                work.setViewerSaved(creationMapper.isSavedByUser(currentUserId, work.getId()));
            }
        }

        // 处理图片URL和其他信息
        enrichWorks(list);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("hasMore", list.size() >= pageSize);
        return result;
    }


    /**
     * 获取某个作者的作品列表
     * 不是本人时，只返回公开作品
     */
    public Map<String, Object> getUserWorks(Long authorUserId, Long currentUserId,
                                            String type, String sortBy,
                                            int page, int pageSize) {
        int offset = (page - 1) * pageSize;

        Map<String, Object> params = new HashMap<>();
        params.put("userId", authorUserId);
        params.put("type", type);
        params.put("sortBy", sortBy);
        params.put("offset", offset);
        params.put("limit", pageSize);

        // 不是本人，只展示公开作品
        if (currentUserId == null || !currentUserId.equals(authorUserId)) {
            params.put("privacy", "public");
        }

        List<CreationWork> list = creationMapper.findList(params);

        if (currentUserId != null) {
            for (CreationWork work : list) {
                work.setViewerLiked(creationMapper.isLikedByUser(currentUserId, work.getId()));
                work.setViewerSaved(creationMapper.isSavedByUser(currentUserId, work.getId()));
            }
        }

        // 处理图片URL和其他信息
        enrichWorks(list);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("hasMore", list.size() >= pageSize);
        return result;
    }

    public Map<String, Object> getMyWorks(Long userId, String type, String sortBy,
                                          int page, int pageSize) {
        int offset = (page - 1) * pageSize;

        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("type", type);
        params.put("sortBy", sortBy);
        params.put("offset", offset);
        params.put("limit", pageSize);

        List<CreationWork> list = creationMapper.findList(params);

        // 处理图片URL和其他信息
        enrichWorks(list);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("hasMore", list.size() >= pageSize);
        return result;
    }

    public Map<String, Object> getMyStats(Long userId) {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalWorks", creationMapper.countByUserId(userId));
        stats.put("totalLikes", creationMapper.sumLikesByUserId(userId));
        stats.put("totalComments", creationMapper.sumCommentsByUserId(userId));
        stats.put("totalViews", creationMapper.sumViewsByUserId(userId));
        return stats;
    }

    public Map<String, Object> getMyLikes(Long userId, int page, int size) {
        int offset = Math.max(0, (page - 1) * size);
        List<Map<String, Object>> likes = userLikeMapper.findReceivedLikes(userId, offset, size);
        int total = userLikeMapper.countReceivedLikes(userId);

        Map<String, Object> result = new HashMap<>();
        result.put("list", likes);
        result.put("total", total);
        return result;
    }

    /**
     * 发布作品 - 已修复 type 字段问题
     */
    @Transactional
    public CreationWork create(CreationWork work) {
        // ========== 调试日志 ==========
        System.out.println("=== CreationService.create 开始 ===");
        System.out.println("userId: " + work.getUserId());
        System.out.println("type: " + work.getType());
        System.out.println("title: " + work.getTitle());
        System.out.println("content长度: " + (work.getContent() == null ? 0 : work.getContent().length()));
        System.out.println("privacy: " + work.getPrivacy());
        // ================================

        // 如果 type 为空，设置默认值
        if (work.getType() == null || work.getType().trim().isEmpty()) {
            work.setType("poem");
            System.out.println("type 为空，设置为默认值: poem");
        }

        // 设置创建时间和更新时间
        if (work.getCreatedAt() == null) {
            work.setCreatedAt(LocalDateTime.now());
        }
        if (work.getUpdatedAt() == null) {
            work.setUpdatedAt(LocalDateTime.now());
        }

        // 初始化计数字段
        if (work.getLikeCount() == null) work.setLikeCount(0);
        if (work.getCommentCount() == null) work.setCommentCount(0);
        if (work.getSaveCount() == null) work.setSaveCount(0);
        if (work.getViewCount() == null) work.setViewCount(0);

        // 插入数据库
        int result = creationMapper.insert(work);
        System.out.println("插入结果: " + result + ", 生成ID: " + work.getId());

        if (result == 0) {
            throw new RuntimeException("保存作品失败，数据库插入返回0");
        }

        // 处理标签（如果有）
        if (work.getTags() != null && !work.getTags().isEmpty()) {
            for (String tagName : work.getTags()) {
                Long tagId = tagMapper.findIdByName(tagName);
                if (tagId == null) {
                    tagMapper.insert(tagName);
                    tagId = tagMapper.findIdByName(tagName);
                } else {
                    tagMapper.incrementUseCount(tagId);
                }
                if (tagId != null) {
                    tagMapper.linkWorkTag(work.getId(), tagId);
                }
            }
        }

        // 处理 @提及（如果有）
        if (work.getMentionUserIds() != null && !work.getMentionUserIds().isEmpty()) {
            for (Long mentionUserId : work.getMentionUserIds()) {
                mentionMapper.insert(work.getId(), mentionUserId);

                if (!mentionUserId.equals(work.getUserId())) {
                    Notification notification = new Notification();
                    notification.setUserId(mentionUserId);
                    notification.setFromUserId(work.getUserId());
                    notification.setType("mention");
                    notification.setTargetType("work");
                    notification.setTargetId(work.getId());
                    notification.setContent(work.getContent().length() > 100
                            ? work.getContent().substring(0, 100) + "..."
                            : work.getContent());
                    notificationMapper.insert(notification);
                }
            }
        }

        System.out.println("=== CreationService.create 完成，作品ID: " + work.getId() + " ===");
        return work;
    }

    @Transactional
    public boolean update(CreationWork work, Long currentUserId) {
        CreationWork existing = creationMapper.findById(work.getId());
        if (existing == null || !existing.getUserId().equals(currentUserId)) {
            return false;
        }
        work.setUpdatedAt(LocalDateTime.now());
        return creationMapper.update(work) > 0;
    }

    @Transactional
    public boolean delete(Long id, Long currentUserId) {
        CreationWork existing = creationMapper.findById(id);
        if (existing == null || !existing.getUserId().equals(currentUserId)) {
            return false;
        }
        return creationMapper.deleteById(id) > 0;
    }

    @Transactional
    public boolean toggleLike(Long workId, Long userId, boolean like) {
        CreationWork work = creationMapper.findById(workId);
        if (work == null) return false;

        if (like) {
            creationMapper.addLike(userId, workId);
            creationMapper.updateLikeCount(workId, 1);

            if (!work.getUserId().equals(userId)) {
                Notification notification = new Notification();
                notification.setUserId(work.getUserId());
                notification.setFromUserId(userId);
                notification.setType("like");
                notification.setTargetType("work");
                notification.setTargetId(workId);
                notification.setContent(work.getContent().length() > 100
                        ? work.getContent().substring(0, 100) + "..."
                        : work.getContent());
                notificationMapper.insert(notification);
            }
        } else {
            creationMapper.removeLike(userId, workId);
            creationMapper.updateLikeCount(workId, -1);
        }

        return true;
    }

    @Transactional
    public boolean toggleSave(Long workId, Long userId, boolean save) {
        CreationWork work = creationMapper.findById(workId);
        if (work == null) return false;

        if (save) {
            creationMapper.addSave(userId, workId);
            creationMapper.updateSaveCount(workId, 1);

            // 创建收藏通知（不给自己发通知）
            if (!work.getUserId().equals(userId)) {
                Notification notification = new Notification();
                notification.setUserId(work.getUserId());
                notification.setFromUserId(userId);
                notification.setType("favorite");
                notification.setTargetType("work");
                notification.setTargetId(workId);
                notification.setContent(work.getContent().length() > 100
                        ? work.getContent().substring(0, 100) + "..."
                        : work.getContent());
                notificationMapper.insert(notification);
            }
        } else {
            creationMapper.removeSave(userId, workId);
            creationMapper.updateSaveCount(workId, -1);
        }
        return true;
    }
}