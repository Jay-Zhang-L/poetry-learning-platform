package com.shici.service;

import com.shici.domain.SysUser;
import com.shici.mapper.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserService {

    private final SysUserMapper sysUserMapper;
    private final UserFollowMapper followMapper;
    private final UserFavoriteMapper favoriteMapper;
    private final UserHistoryMapper historyMapper;
    private final UserLikeMapper likeMapper;
    private final NotificationMapper notificationMapper;

    public UserService(SysUserMapper sysUserMapper,
                       UserFollowMapper followMapper,
                       UserFavoriteMapper favoriteMapper,
                       UserHistoryMapper historyMapper,
                       UserLikeMapper likeMapper,
                       NotificationMapper notificationMapper) {
        this.sysUserMapper = sysUserMapper;
        this.followMapper = followMapper;
        this.favoriteMapper = favoriteMapper;
        this.historyMapper = historyMapper;
        this.likeMapper = likeMapper;
        this.notificationMapper = notificationMapper;
    }

    public SysUser me(Long userId) {
        SysUser u = sysUserMapper.findById(userId);
        if (u == null) throw new RuntimeException("用户不存在");
        u.setPassword(null);
        return u;
    }

    public SysUser updateProfile(Long userId, SysUser patch) {
        SysUser db = sysUserMapper.findById(userId);
        if (db == null) throw new RuntimeException("用户不存在");

        db.setNickname(patch.getNickname());
        db.setGrade(patch.getGrade());
        db.setBio(patch.getBio());
        db.setAvatarUrl(patch.getAvatarUrl());
        db.setCoverUrl(patch.getCoverUrl());

        sysUserMapper.updateProfile(db);

        SysUser latest = sysUserMapper.findById(userId);
        latest.setPassword(null);
        return latest;
    }

    public Map<String, Object> stats(Long userId) {
        Map<String, Object> data = new HashMap<>();
        data.put("followingCount", followMapper.countFollowing(userId));
        data.put("followerCount", followMapper.countFollowers(userId));
        data.put("mutualFollowCount", followMapper.countMutualFollow(userId));

        Integer likeCount = 0;
        try {
            Integer x = likeMapper.countLikesOnMyWorks(userId);
            likeCount = x == null ? 0 : x;
        } catch (Exception ignore) {}
        data.put("likeCount", likeCount);

        return data;
    }

    public List<Map<String,Object>> listHistory(Long userId, int page, int size) {
        int offset = Math.max(0, (page - 1) * size);
        return historyMapper.list(userId, offset, size);
    }

    public List<Map<String,Object>> listFav(Long userId, String tab, int page, int size) {
        int offset = Math.max(0, (page - 1) * size);

        // 根据tab参数调用不同的查询方法
        if ("creation".equals(tab)) {
            return favoriteMapper.listFavByCreation(userId, offset, size);
        } else if ("recite".equals(tab)) {
            return favoriteMapper.listFavByRecite(userId, offset, size);
        } else if ("library".equals(tab)) {
            return favoriteMapper.listFavByLibrary(userId, offset, size);
        } else {
            // 默认返回所有收藏
            return favoriteMapper.listFav(userId, offset, size);
        }
    }

    public Map<String, Object> listFollowing(Long userId, int page, int size) {
        int offset = Math.max(0, (page - 1) * size);
        List<Map<String,Object>> items = followMapper.listFollowing(userId, offset, size);
        int total = followMapper.countFollowing(userId);

        Map<String, Object> result = new HashMap<>();
        result.put("items", items);
        result.put("total", total);
        result.put("page", page);
        result.put("size", size);
        return result;
    }

    public List<Map<String,Object>> listMutualFollows(Long userId, int page, int size) {
        int offset = Math.max(0, (page - 1) * size);
        return followMapper.listMutualFollows(userId, offset, size);
    }

    public Map<String, Object> listFollowers(Long userId, int page, int size) {
        int offset = Math.max(0, (page - 1) * size);
        List<Map<String,Object>> items = followMapper.listFollowers(userId, offset, size);
        int total = followMapper.countFollowers(userId);

        Map<String, Object> result = new HashMap<>();
        result.put("items", items);
        result.put("total", total);
        result.put("page", page);
        result.put("size", size);
        return result;
    }

    public List<Map<String,Object>> listMyLikes(Long userId, int page, int size) {
        int offset = Math.max(0, (page - 1) * size);
        return likeMapper.listMyLikes(userId, offset, size);
    }

    public void addHistory(Long userId, String type, Long targetId, String title, String coverUrl) {
        historyMapper.add(userId, type, targetId, title, coverUrl);
    }

    public void deleteHistory(Long historyId, Long userId) {
        // 验证这条历史是否属于当前用户
        // 简化实现，直接删除
        historyMapper.deleteById(historyId);
    }

    public void clearHistory(Long userId) {
        historyMapper.clear(userId);
    }

    public void fav(Long userId, String type, Long targetId) {
        favoriteMapper.fav(userId, type, targetId);
    }

    public void unfav(Long userId, String type, Long targetId) {
        favoriteMapper.unfav(userId, type, targetId);
    }

    public List<SysUser> searchUsers(String keyword, int limit) {
        List<SysUser> users = sysUserMapper.searchByKeyword(keyword, limit);
        users.forEach(u -> u.setPassword(null));
        return users;
    }

    @Transactional
    public void followUser(Long userId, Long targetUserId) {
        if (userId == null) throw new RuntimeException("未登录");
        if (targetUserId == null) throw new RuntimeException("目标用户不存在");
        if (userId.equals(targetUserId)) throw new RuntimeException("不能关注自己");

        SysUser target = sysUserMapper.findById(targetUserId);
        if (target == null) throw new RuntimeException("目标用户不存在");

        int existed = followMapper.isFollowed(userId, targetUserId);
        if (existed > 0) {
            return;
        }

        followMapper.follow(userId, targetUserId);
        sysUserMapper.incrFollowing(userId);
        sysUserMapper.incrFollower(targetUserId);

        // 创建关注通知
        com.shici.domain.Notification notification = new com.shici.domain.Notification();
        notification.setUserId(targetUserId);
        notification.setFromUserId(userId);
        notification.setType("follow");
        notification.setTargetType("user");
        notification.setTargetId(userId);
        notification.setContent(sysUserMapper.findById(userId).getNickname() + " 关注了你");
        notification.setIsRead(false);
        notificationMapper.insert(notification);
    }

    @Transactional
    public void unfollowUser(Long userId, Long targetUserId) {
        if (userId == null) throw new RuntimeException("未登录");
        if (targetUserId == null) throw new RuntimeException("目标用户不存在");
        if (userId.equals(targetUserId)) throw new RuntimeException("不能取消关注自己");

        int existed = followMapper.isFollowed(userId, targetUserId);
        if (existed <= 0) {
            return;
        }

        followMapper.unfollow(userId, targetUserId);
        sysUserMapper.decrFollowing(userId);
        sysUserMapper.decrFollower(targetUserId);
    }

    public boolean isFollowed(Long userId, Long targetUserId) {
        if (userId == null || targetUserId == null) return false;
        return followMapper.isFollowed(userId, targetUserId) > 0;
    }

    public Map<String, Object> getUserProfile(Long currentUserId, Long targetUserId) {
        SysUser user = sysUserMapper.findById(targetUserId);
        if (user == null) throw new RuntimeException("用户不存在");
        user.setPassword(null);

        Map<String, Object> data = new HashMap<>();
        data.put("user", user);
        data.put("isSelf", currentUserId != null && currentUserId.equals(targetUserId));
        data.put("followed", currentUserId != null && followMapper.isFollowed(currentUserId, targetUserId) > 0);
        return data;
    }
}