package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.SysUser;
import com.shici.domain.dto.FavoriteReq;
import com.shici.domain.dto.PageResp;
import com.shici.domain.dto.ReciteListenItemDto;
import com.shici.domain.dto.ReciteListenRespDto;
import com.shici.domain.dto.RecitePoemSelectionDto;
import com.shici.domain.dto.RecitePlayReq;
import com.shici.domain.dto.RecitePlaylistDto;
import com.shici.domain.dto.ReciteVideoDto;
import com.shici.domain.dto.ReciteVideoPlayReq;
import com.shici.domain.vo.ReciteRecordingVO;
import com.shici.service.ReciteRecordingService;
import com.shici.service.ReciteService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/recite")
public class ReciteController {

  @Autowired
  private ReciteService reciteService;

  @Autowired
  private ReciteRecordingService reciteRecordingService;

  private Long getCurrentUserId(HttpSession session) {
    if (session == null) {
      return null;
    }
    Object userObj = session.getAttribute("user");
    if (userObj instanceof SysUser user) {
      return user.getId();
    }
    return null;
  }

  /**
   * 获取诗单列表
   */
  @GetMapping("/playlists")
  public R<List<RecitePlaylistDto>> getPlaylists(@RequestParam String type) {
    return R.ok(reciteService.getPlaylists(type));
  }

  /**
   * 获取某个诗单下的音频条目列表
   */
  @GetMapping("/playlists/{playlistId}/items")
  public R<List<ReciteListenItemDto>> getPlaylistItems(@PathVariable Long playlistId) {
    return R.ok(reciteService.getPlaylistItems(playlistId));
  }

  /**
   * 获取某个诗单下的视频列表（专题鉴赏）
   */
  @GetMapping("/playlists/{playlistId}/videos")
  public R<List<ReciteVideoDto>> getPlaylistVideos(@PathVariable Long playlistId) {
    return R.ok(reciteService.getPlaylistVideos(playlistId));
  }
  @GetMapping("/search")
  public R<Map<String, Object>> search(@RequestParam String keyword) {
    return R.ok(reciteService.searchAll(keyword));
  }

  /**
   * 我的收藏 - 诗单
   */
  @GetMapping("/my/favorites")
  public R<List<RecitePlaylistDto>> getMyFavorites(HttpSession session) {
    Long userId = getCurrentUserId(session);
    return R.ok(reciteService.getMyFavorites(userId));
  }

  /**
   * 我的收藏 - 音频
   */
  @GetMapping("/my/favorite-audios")
  public R<List<ReciteListenItemDto>> getMyFavoriteAudios(HttpSession session) {
    Long userId = getCurrentUserId(session);
    return R.ok(reciteService.getMyFavoriteAudios(userId));
  }

  /**
   * 我的收藏 - 视频
   */
  @GetMapping("/my/favorite-videos")
  public R<List<ReciteVideoDto>> getMyFavoriteVideos(HttpSession session) {
    Long userId = getCurrentUserId(session);
    return R.ok(reciteService.getMyFavoriteVideos(userId));
  }

  /**
   * 最近播放 - 诗单
   */
  @GetMapping("/my/recent-playlists")
  public R<List<RecitePlaylistDto>> getMyRecentPlaylists(HttpSession session) {
    Long userId = getCurrentUserId(session);
    return R.ok(reciteService.getMyRecentPlaylists(userId));
  }

  /**
   * 最近播放 - 音频
   */
  @GetMapping("/my/recent-audios")
  public R<List<ReciteListenItemDto>> getMyRecentAudios(HttpSession session) {
    Long userId = getCurrentUserId(session);
    return R.ok(reciteService.getMyRecentAudios(userId));
  }

  /**
   * 最近播放 - 视频
   */
  @GetMapping("/my/recent-videos")
  public R<List<ReciteVideoDto>> getMyRecentVideos(HttpSession session) {
    Long userId = getCurrentUserId(session);
    return R.ok(reciteService.getMyRecentVideos(userId));
  }

  /**
   * 大家都在听：热门、精选
   */
  @GetMapping("/listen")
  public R<ReciteListenRespDto> getListenData() {
    return R.ok(reciteService.getListenData());
  }

  /**
   * 视频推荐（所有视频）
   */
  @GetMapping("/videos")
  public R<List<ReciteVideoDto>> getVideos(@RequestParam(required = false) String type) {
    return R.ok(reciteService.getVideos(type));
  }

  /**
   * 记录音频播放
   */
  @PostMapping("/play")
  public R<String> addPlay(@RequestBody RecitePlayReq req, HttpSession session) {
    Long userId = getCurrentUserId(session);
    reciteService.addPlay(userId, req);
    return R.ok("记录成功");
  }

  /**
   * 记录视频播放
   */
  @PostMapping("/video/play")
  public R<String> addVideoPlay(@RequestBody ReciteVideoPlayReq req, HttpSession session) {
    Long userId = getCurrentUserId(session);
    reciteService.addVideoPlay(userId, req);
    return R.ok("记录成功");
  }

  /**
   * 新增收藏
   */
  @PostMapping("/favorite")
  public R<String> addFavorite(@RequestBody FavoriteReq req, HttpSession session) {
    Long userId = getCurrentUserId(session);
    reciteService.addFavorite(userId, req.getTargetId(), req.getFavoriteType());
    return R.ok("收藏成功");
  }

  /**
   * 取消收藏
   */
  @DeleteMapping("/favorite")
  public R<String> removeFavorite(@RequestParam Long targetId,
                                  @RequestParam String favoriteType,
                                  HttpSession session) {
    Long userId = getCurrentUserId(session);
    reciteService.removeFavorite(userId, targetId, favoriteType);
    return R.ok("取消成功");
  }

  /**
   * 查询是否已收藏
   */
  @GetMapping("/favorite/status")
  public R<Boolean> getFavoriteStatus(@RequestParam Long targetId,
                                      @RequestParam String favoriteType,
                                      HttpSession session) {
    Long userId = getCurrentUserId(session);
    return R.ok(reciteService.isFavorited(userId, targetId, favoriteType));
  }

  // ========== 录音评价相关 API ==========

  /**
   * 获取可朗诵的诗词列表
   * 支持按难度、情感类型筛选，支持关键词搜索
   */
  @GetMapping("/poems")
  public R<PageResp<RecitePoemSelectionDto>> getPoemsForRecitation(
          @RequestParam(required = false) Integer difficultyLevel,
          @RequestParam(required = false) String emotionType,
          @RequestParam(required = false) String keyword,
          @RequestParam(defaultValue = "1") int page,
          @RequestParam(defaultValue = "10") int size) {
    return R.ok(reciteService.getPoemsForRecitation(difficultyLevel, emotionType, keyword, page, size));
  }

  /**
   * 获取诗词详情（用于朗诵）
   */
  @GetMapping("/poems/{id}")
  public R<RecitePoemSelectionDto> getPoemForRecitation(@PathVariable Long id) {
    RecitePoemSelectionDto poem = reciteService.getPoemForRecitationById(id);
    if (poem == null) {
      return R.fail("诗词不存在");
    }
    return R.ok(poem);
  }

  /**
   * 提交录音并获取AI评价
   * 用户录制朗诵音频后，系统会进行语音识别并给出AI评价
   * 不需要登录，游客也可以使用
   */
  @PostMapping("/recording/submit")
  public R<ReciteRecordingVO> submitRecording(
          @RequestParam("poemId") Long poemId,
          @RequestParam(value = "poemTitle", required = false) String poemTitle,
          @RequestParam(value = "poemContent", required = false) String poemContent,
          @RequestParam("audio") MultipartFile audioFile,
          @RequestParam(value = "audioDuration", required = false) Integer audioDuration,
          HttpSession session) {
    // 未登录时使用默认用户ID 1L，允许游客使用录音评价功能
    Long userId = getCurrentUserId(session);
    if (userId == null) {
      userId = 1L;
    }

    if (audioFile == null || audioFile.isEmpty()) {
      return R.fail("请上传录音文件");
    }

    try {
      ReciteRecordingVO result = reciteRecordingService.submitRecording(
              userId, poemId, poemTitle, poemContent, audioFile, audioDuration
      );
      return R.ok(result);
    } catch (IOException e) {
      return R.fail("录音处理失败：" + e.getMessage());
    }
  }

  /**
   * 获取当前用户的录音评价记录列表
   */
  @GetMapping("/recording/my")
  public R<List<ReciteRecordingVO>> getMyRecordings(HttpSession session) {
    Long userId = getCurrentUserId(session);
    if (userId == null) {
      return R.fail("请先登录");
    }
    return R.ok(reciteRecordingService.getMyRecordings(userId));
  }

  /**
   * 获取当前用户对某首诗的录音评价记录
   */
  @GetMapping("/recording/my/{poemId}")
  public R<List<ReciteRecordingVO>> getMyRecordingsByPoem(
          @PathVariable Long poemId,
          HttpSession session) {
    Long userId = getCurrentUserId(session);
    if (userId == null) {
      return R.fail("请先登录");
    }
    return R.ok(reciteRecordingService.getMyRecordingsByPoem(userId, poemId));
  }

  /**
   * 获取录音评价详情
   */
  @GetMapping("/recording/{id}")
  public R<ReciteRecordingVO> getRecordingDetail(@PathVariable Long id) {
    ReciteRecordingVO result = reciteRecordingService.getRecordingDetail(id);
    if (result == null) {
      return R.fail("记录不存在");
    }
    return R.ok(result);
  }

  /**
   * 删除录音评价记录
   */
  @DeleteMapping("/recording/{id}")
  public R<String> deleteRecording(@PathVariable Long id, HttpSession session) {
    Long userId = getCurrentUserId(session);
    if (userId == null) {
      return R.fail("请先登录");
    }

    boolean success = reciteRecordingService.deleteRecording(id, userId);
    if (success) {
      return R.ok("删除成功");
    } else {
      return R.fail("删除失败，记录不存在或无权删除");
    }
  }
}