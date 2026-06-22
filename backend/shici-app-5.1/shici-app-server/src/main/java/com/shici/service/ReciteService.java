package com.shici.service;

import com.shici.domain.dto.*;
import com.shici.mapper.ReciteMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class ReciteService {

  private final ReciteMapper reciteMapper;

  @Autowired
  public ReciteService(ReciteMapper reciteMapper) {
    this.reciteMapper = reciteMapper;
  }

  // ================= 诗单 =================

  public List<RecitePlaylistDto> getPlaylists(String type) {
    if (type == null || type.isBlank()) {
      return Collections.emptyList();
    }
    return reciteMapper.selectPlaylistsByType(type);
  }

  public List<ReciteListenItemDto> getPlaylistItems(Long playlistId) {
    if (playlistId == null) {
      return Collections.emptyList();
    }
    return reciteMapper.selectPlaylistItems(playlistId);
  }

  public List<ReciteVideoDto> getPlaylistVideos(Long playlistId) {
    if (playlistId == null) {
      return Collections.emptyList();
    }
    return reciteMapper.selectPlaylistVideos(playlistId);
  }

  // ================= 收藏 =================

  public List<RecitePlaylistDto> getMyFavorites(Long userId) {
    if (userId == null) {
      return Collections.emptyList();
    }
    return reciteMapper.selectMyFavoritePlaylists(userId);
  }

  public List<ReciteListenItemDto> getMyFavoriteAudios(Long userId) {
    if (userId == null) {
      return Collections.emptyList();
    }
    return reciteMapper.selectMyFavoriteAudioItems(userId);
  }

  public List<ReciteVideoDto> getMyFavoriteVideos(Long userId) {
    if (userId == null) {
      return Collections.emptyList();
    }
    return reciteMapper.selectMyFavoriteVideos(userId);
  }

  // ================= 最近播放 =================

  public List<RecitePlaylistDto> getMyRecentPlaylists(Long userId) {
    if (userId == null) {
      return Collections.emptyList();
    }
    return reciteMapper.selectMyRecentPlaylists(userId);
  }

  public List<ReciteListenItemDto> getMyRecentAudios(Long userId) {
    if (userId == null) {
      return Collections.emptyList();
    }
    return reciteMapper.selectMyRecentAudioItems(userId);
  }

  public List<ReciteVideoDto> getMyRecentVideos(Long userId) {
    if (userId == null) {
      return Collections.emptyList();
    }
    return reciteMapper.selectMyRecentVideos(userId);
  }

  // ================= 推荐（大家都在听） =================

  public ReciteListenRespDto getListenData() {
    ReciteListenRespDto resp = new ReciteListenRespDto();
    resp.setHotList(reciteMapper.selectHotList());
    resp.setPickList(reciteMapper.selectPickList());
    return resp;
  }

  public List<ReciteVideoDto> getVideos(String type) {
    return reciteMapper.selectVideosByType(type);
  }
  public Map<String, Object> searchAll(String keyword) {
    Map<String, Object> map = new HashMap<>();

    if (keyword == null || keyword.isBlank()) {
      map.put("audios", Collections.emptyList());
      map.put("videos", Collections.emptyList());
      return map;
    }

    map.put("audios", reciteMapper.searchAudioItems(keyword.trim()));
    map.put("videos", reciteMapper.searchVideos(keyword.trim()));
    return map;
  }

  // ================= 播放记录（重点改这里） =================

  public void addPlay(Long userId, RecitePlayReq req) {
    if (req == null) {
      return;
    }

    // 👉 核心修改：未登录也记录
    if (userId == null) {
      userId = 1L;
    }

    reciteMapper.insertPlayRecord(
            userId,
            req.getPoemId(),
            req.getPlaylistId(),
            req.getMediaId(),
            req.getPlayType()
    );

    reciteMapper.insertRecentPlay(
            userId,
            req.getPlaylistId(),
            req.getPoemId(),
            req.getMediaId(),
            req.getPlayType()
    );
  }

  public void addVideoPlay(Long userId, ReciteVideoPlayReq req) {
    if (req == null) {
      return;
    }

    if (userId == null) {
      userId = 1L;
    }

    reciteMapper.insertVideoPlayRecord(
            userId,
            req.getVideoId(),
            req.getPlaylistId(),
            req.getPlaySeconds() != null ? req.getPlaySeconds() : 0,
            req.getPlayType()
    );

    reciteMapper.insertRecentVideoPlay(
            userId,
            req.getVideoId(),
            req.getPlaylistId(),
            req.getPlayType()
    );
  }

  // ================= 收藏操作 =================

  public void addFavorite(Long userId, Long targetId, String favoriteType) {
    if (userId == null || targetId == null || favoriteType == null || favoriteType.isBlank()) {
      return;
    }

    if (!isValidFavoriteType(favoriteType)) {
      throw new RuntimeException("收藏类型错误");
    }

    Integer count = reciteMapper.countFavorite(userId, targetId, favoriteType);
    if (count != null && count > 0) {
      return;
    }

    reciteMapper.insertFavorite(userId, targetId, favoriteType);
  }

  public void removeFavorite(Long userId, Long targetId, String favoriteType) {
    if (userId == null || targetId == null || favoriteType == null || favoriteType.isBlank()) {
      return;
    }

    if (!isValidFavoriteType(favoriteType)) {
      throw new RuntimeException("收藏类型错误");
    }

    reciteMapper.deleteFavorite(userId, targetId, favoriteType);
  }

  public boolean isFavorited(Long userId, Long targetId, String favoriteType) {
    if (userId == null || targetId == null || favoriteType == null || favoriteType.isBlank()) {
      return false;
    }

    if (!isValidFavoriteType(favoriteType)) {
      return false;
    }

    Integer count = reciteMapper.countFavorite(userId, targetId, favoriteType);
    return count != null && count > 0;
  }

  private boolean isValidFavoriteType(String favoriteType) {
    return "playlist".equals(favoriteType)
            || "audio".equals(favoriteType)
            || "video".equals(favoriteType);
  }

  // ================= 朗诵诗词 =================

  public PageResp<RecitePoemSelectionDto> getPoemsForRecitation(
          Integer difficultyLevel, String emotionType, String keyword,
          int page, int size) {

    if (page < 1) page = 1;
    if (size < 1) size = 10;
    if (size > 50) size = 50;

    int offset = (page - 1) * size;

    long total = reciteMapper.countPoemsForRecitation(difficultyLevel, emotionType, keyword);
    List<RecitePoemSelectionDto> items = reciteMapper.selectPoemsForRecitation(
            difficultyLevel, emotionType, keyword, offset, size);

    return PageResp.of(total, page, size, items);
  }

  public RecitePoemSelectionDto getPoemForRecitationById(Long id) {
    if (id == null) {
      return null;
    }
    return reciteMapper.selectPoemForRecitationById(id);
  }
}