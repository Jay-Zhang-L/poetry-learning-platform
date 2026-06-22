package com.shici.mapper;

import com.shici.domain.CreationWork;
import com.shici.domain.RankingItem;
import org.apache.ibatis.annotations.*;
import java.util.List;
import java.util.Map;

@Mapper
public interface CreationMapper {

    // ========== 您原有的方法 ==========

    @Select("SELECT w.*, u.nickname as authorName, u.avatar_url as authorAvatar " +
            "FROM creation_work w " +
            "LEFT JOIN sys_user u ON w.user_id = u.id " +
            "WHERE w.id = #{id}")
    CreationWork findById(Long id);

    @Select("<script>" +
            "SELECT w.*, u.nickname as authorName, u.avatar_url as authorAvatar " +
            "FROM creation_work w " +
            "LEFT JOIN sys_user u ON w.user_id = u.id " +
            "WHERE w.id IN " +
            "<foreach item='id' collection='list' open='(' separator=',' close=')'>" +
            "#{id}" +
            "</foreach>" +
            " ORDER BY w.created_at DESC" +
            "</script>")
    List<CreationWork> findByIds(List<Long> ids);

    @Select("<script>" +
            "SELECT w.*, u.nickname as authorName, u.avatar_url as authorAvatar " +
            "FROM creation_work w " +
            "LEFT JOIN sys_user u ON w.user_id = u.id " +
            "WHERE 1=1 " +
            "<if test='userId != null'>AND w.user_id = #{userId}</if> " +
            "<if test='type != null and type != \"all\"'>AND w.type = #{type}</if> " +
            "<if test='privacy != null'>AND w.privacy = #{privacy}</if> " +
            "ORDER BY " +
            "<choose>" +
            "<when test='sortBy == \"likes\"'>w.like_count DESC</when>" +
            "<when test='sortBy == \"comments\"'>w.comment_count DESC</when>" +
            "<when test='sortBy == \"views\"'>w.view_count DESC</when>" +
            "<otherwise>w.created_at DESC</otherwise>" +
            "</choose> " +
            "LIMIT #{offset}, #{limit}" +
            "</script>")
    List<CreationWork> findList(Map<String, Object> params);

    @Select("SELECT COUNT(*) FROM creation_work WHERE user_id = #{userId}")
    int countByUserId(Long userId);

    @Select("SELECT COALESCE(SUM(like_count), 0) FROM creation_work WHERE user_id = #{userId}")
    int sumLikesByUserId(Long userId);

    @Select("SELECT COALESCE(SUM(comment_count), 0) FROM creation_work WHERE user_id = #{userId}")
    int sumCommentsByUserId(Long userId);

    @Select("SELECT COALESCE(SUM(view_count), 0) FROM creation_work WHERE user_id = #{userId}")
    int sumViewsByUserId(Long userId);

    @Insert("INSERT INTO creation_work (user_id, type, title, content, description, images, audio_url, video_url, privacy) " +
            "VALUES (#{userId}, #{type}, #{title}, #{content}, #{description}, #{images}, #{audioUrl}, #{videoUrl}, #{privacy})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(CreationWork work);

    @Update("UPDATE creation_work SET " +
            "title = #{title}, content = #{content}, description = #{description}, " +
            "images = #{images}, audio_url = #{audioUrl}, video_url = #{videoUrl}, privacy = #{privacy}, updated_at = NOW() " +
            "WHERE id = #{id}")
    int update(CreationWork work);

    @Delete("DELETE FROM creation_work WHERE id = #{id}")
    int deleteById(Long id);

    @Update("UPDATE creation_work SET like_count = like_count + #{delta} WHERE id = #{id}")
    int updateLikeCount(@Param("id") Long id, @Param("delta") int delta);

    @Update("UPDATE creation_work SET comment_count = comment_count + #{delta} WHERE id = #{id}")
    int updateCommentCount(@Param("id") Long id, @Param("delta") int delta);

    @Update("UPDATE creation_work SET save_count = save_count + #{delta} WHERE id = #{id}")
    int updateSaveCount(@Param("id") Long id, @Param("delta") int delta);

    @Update("UPDATE creation_work SET view_count = view_count + 1 WHERE id = #{id}")
    int incrementViewCount(Long id);

    @Select("SELECT EXISTS(SELECT 1 FROM user_like WHERE user_id = #{userId} " +
            "AND target_type = 'work' AND target_id = #{workId})")
    boolean isLikedByUser(@Param("userId") Long userId, @Param("workId") Long workId);

    @Select("SELECT EXISTS(SELECT 1 FROM user_favorite WHERE user_id = #{userId} " +
            "AND target_type = 'creation_work' AND target_id = #{workId})")
    boolean isSavedByUser(@Param("userId") Long userId, @Param("workId") Long workId);

    @Insert("INSERT INTO user_like (user_id, target_type, target_id) " +
            "VALUES (#{userId}, 'work', #{workId})")
    int addLike(@Param("userId") Long userId, @Param("workId") Long workId);

    @Delete("DELETE FROM user_like WHERE user_id = #{userId} " +
            "AND target_type = 'work' AND target_id = #{workId}")
    int removeLike(@Param("userId") Long userId, @Param("workId") Long workId);

    @Insert("INSERT INTO user_favorite (user_id, target_type, target_id) " +
            "VALUES (#{userId}, 'creation_work', #{workId})")
    int addSave(@Param("userId") Long userId, @Param("workId") Long workId);

    @Delete("DELETE FROM user_favorite WHERE user_id = #{userId} " +
            "AND target_type = 'creation_work' AND target_id = #{workId}")
    int removeSave(@Param("userId") Long userId, @Param("workId") Long workId);

    @Select("SELECT COALESCE(SUM(CHAR_LENGTH(content)), 0) FROM creation_work WHERE user_id = #{userId}")
    int sumWordsByUserId(Long userId);

    @Select("SELECT * FROM creation_work WHERE user_id = #{userId} ORDER BY created_at ASC LIMIT 1")
    Map<String, Object> findFirstWorkByUserId(Long userId);

    @Select("SELECT * FROM creation_work WHERE user_id = #{userId} ORDER BY created_at DESC LIMIT 1")
    Map<String, Object> findLastWorkByUserId(Long userId);

    @Select("SELECT DATE_FORMAT(created_at, '%Y-%m') as month, COUNT(*) as count " +
            "FROM creation_work WHERE user_id = #{userId} " +
            "GROUP BY DATE_FORMAT(created_at, '%Y-%m') " +
            "ORDER BY month ASC " +
            "LIMIT 12")
    List<Map<String, Object>> findMonthlyStats(Long userId);

    @Select("SELECT type, COUNT(*) as count FROM creation_work " +
            "WHERE user_id = #{userId} GROUP BY type ORDER BY count DESC")
    List<Map<String, Object>> findTypeStats(Long userId);

    @Select("SELECT id, title, type, content, created_at, like_count, comment_count " +
            "FROM creation_work WHERE user_id = #{userId} " +
            "ORDER BY created_at ASC")
    List<Map<String, Object>> findTimelineByUserId(Long userId);

    // ========== 新增：侧边栏排行查询方法 ==========

    /**
     * 48小时阅读排行
     */
    @Select("SELECT id, title, view_count as viewCount, CONCAT('/chuangzuo/', id) as url " +
            "FROM creation_work " +
            "WHERE created_at >= DATE_SUB(NOW(), INTERVAL 48 HOUR) " +
            "AND privacy = 'public' " +
            "ORDER BY view_count DESC " +
            "LIMIT 6")
    List<RankingItem> selectRanking48h();

    /**
     * 10天推荐排行（按点赞数）
     */
    @Select("SELECT id, title, like_count as viewCount, CONCAT('/chuangzuo/', id) as url " +
            "FROM creation_work " +
            "WHERE created_at >= DATE_SUB(NOW(), INTERVAL 10 DAY) " +
            "AND privacy = 'public' " +
            "ORDER BY like_count DESC " +
            "LIMIT 6")
    List<RankingItem> selectRanking10d();

    /**
     * 15天热门创作（按互动量：点赞 + 评论*2）
     */
    @Select("SELECT id, title, (like_count + comment_count * 2) as viewCount, CONCAT('/chuangzuo/', id) as url " +
            "FROM creation_work " +
            "WHERE created_at >= DATE_SUB(NOW(), INTERVAL 15 DAY) " +
            "AND privacy = 'public' " +
            "ORDER BY (like_count + comment_count * 2) DESC " +
            "LIMIT 6")
    List<RankingItem> selectHot15d();

    /**
     * 编辑推荐（按综合热度排序）
     */
    @Select("SELECT id, title, (like_count + comment_count * 2 + view_count / 10) as score, CONCAT('/chuangzuo/', id) as url " +
            "FROM creation_work " +
            "WHERE privacy = 'public' " +
            "ORDER BY score DESC " +
            "LIMIT 6")
    List<RankingItem> selectEditorPick();
}