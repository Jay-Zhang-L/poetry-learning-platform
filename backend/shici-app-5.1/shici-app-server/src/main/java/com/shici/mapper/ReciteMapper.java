package com.shici.mapper;

import com.shici.domain.dto.ReciteListenItemDto;
import com.shici.domain.dto.RecitePoemSelectionDto;
import com.shici.domain.dto.RecitePlaylistDto;
import com.shici.domain.dto.ReciteVideoDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ReciteMapper {

    // ========== 诗单相关 ==========
    List<RecitePlaylistDto> selectPlaylistsByType(@Param("type") String type);
    List<ReciteListenItemDto> selectPlaylistItems(@Param("playlistId") Long playlistId);
    List<ReciteVideoDto> selectPlaylistVideos(@Param("playlistId") Long playlistId);
    List<ReciteListenItemDto> searchAudioItems(@Param("keyword") String keyword);
    List<ReciteVideoDto> searchVideos(@Param("keyword") String keyword);

    // ========== 收藏相关 ==========
    List<RecitePlaylistDto> selectMyFavoritePlaylists(@Param("userId") Long userId);
    List<ReciteListenItemDto> selectMyFavoriteAudioItems(@Param("userId") Long userId);
    List<ReciteVideoDto> selectMyFavoriteVideos(@Param("userId") Long userId);

    // ========== 最近播放相关 ==========
    List<RecitePlaylistDto> selectMyRecentPlaylists(@Param("userId") Long userId);
    List<ReciteListenItemDto> selectMyRecentAudioItems(@Param("userId") Long userId);
    List<ReciteVideoDto> selectMyRecentVideos(@Param("userId") Long userId);

    // ========== 大家都在听 ==========
    List<ReciteListenItemDto> selectHotList();
    List<ReciteListenItemDto> selectPickList();

    // ========== 朗诵诗词选择 ==========
    /**
     * 获取可朗诵的诗词列表（支持筛选）
     * @param difficultyLevel 难度等级（可选）
     * @param emotionType 情感类型（可选）
     * @param keyword 搜索关键词（可选）
     * @param offset 分页偏移量
     * @param size 每页数量
     * @return 诗词列表
     */
    List<RecitePoemSelectionDto> selectPoemsForRecitation(
            @Param("difficultyLevel") Integer difficultyLevel,
            @Param("emotionType") String emotionType,
            @Param("keyword") String keyword,
            @Param("offset") int offset,
            @Param("size") int size);

    /**
     * 统计可朗诵诗词总数（支持筛选）
     */
    long countPoemsForRecitation(
            @Param("difficultyLevel") Integer difficultyLevel,
            @Param("emotionType") String emotionType,
            @Param("keyword") String keyword);

    /**
     * 根据ID获取诗词详情
     */
    RecitePoemSelectionDto selectPoemForRecitationById(@Param("id") Long id);

    // ========== 视频推荐（所有视频）==========
    List<ReciteVideoDto> selectVideosByType(@Param("type") String type);

    // ========== 音频播放记录 ==========
    int insertPlayRecord(@Param("userId") Long userId,
                         @Param("poemId") Long poemId,
                         @Param("playlistId") Long playlistId,
                         @Param("mediaId") Long mediaId,
                         @Param("playType") String playType);

    int insertRecentPlay(@Param("userId") Long userId,
                         @Param("playlistId") Long playlistId,
                         @Param("poemId") Long poemId,
                         @Param("mediaId") Long mediaId,
                         @Param("playType") String playType);

    // ========== 视频播放记录 ==========
    int insertVideoPlayRecord(@Param("userId") Long userId,
                              @Param("videoId") Long videoId,
                              @Param("playlistId") Long playlistId,
                              @Param("playSeconds") Integer playSeconds,
                              @Param("playType") String playType);

    int insertRecentVideoPlay(@Param("userId") Long userId,
                              @Param("videoId") Long videoId,
                              @Param("playlistId") Long playlistId,
                              @Param("playType") String playType);

    // ========== 收藏操作 ==========
    int insertFavorite(@Param("userId") Long userId,
                       @Param("targetId") Long targetId,
                       @Param("favoriteType") String favoriteType);

    int deleteFavorite(@Param("userId") Long userId,
                       @Param("targetId") Long targetId,
                       @Param("favoriteType") String favoriteType);

    Integer countFavorite(@Param("userId") Long userId,
                          @Param("targetId") Long targetId,
                          @Param("favoriteType") String favoriteType);
}