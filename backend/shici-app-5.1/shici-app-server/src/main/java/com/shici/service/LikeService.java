package com.shici.service;

import java.util.List;
import java.util.Map;

public interface LikeService {
    /**
     * 获取用户获得的点赞记录（谁赞了我的作品）
     */
    List<Map<String, Object>> getReceivedLikes(Long userId, int page, int size);

    /**
     * 统计用户获得的点赞总数
     */
    int countReceivedLikes(Long userId);

    /**
     * 获取用户点赞的记录（我赞了谁的作品）
     */
    List<Map<String, Object>> getGivenLikes(Long userId, int page, int size);

    /**
     * 统计用户点赞的总数
     */
    int countGivenLikes(Long userId);
}
