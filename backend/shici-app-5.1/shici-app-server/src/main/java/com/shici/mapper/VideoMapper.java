// 文件路径：src/main/java/com/shici/mapper/VideoMapper.java
package com.shici.mapper;

import com.shici.domain.Video;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface VideoMapper {

    // 查询所有显示的视频，按排序字段和创建时间倒序
    @Select("SELECT * FROM video WHERE status = 1 ORDER BY sort_order DESC, created_time DESC")
    List<Video> findAll();

    // 查询推荐视频（取前10条）
    @Select("SELECT * FROM video WHERE status = 1 ORDER BY sort_order DESC, views DESC, created_time DESC LIMIT 10")
    List<Video> findRecommendVideos();

    // 根据ID查询视频
    @Select("SELECT * FROM video WHERE id = #{id}")
    Video findById(Integer id);

    // 根据分类查询视频
    @Select("SELECT * FROM video WHERE status = 1 AND category = #{category} ORDER BY sort_order DESC")
    List<Video> findByCategory(String category);

    // 增加观看次数
    @Update("UPDATE video SET views = views + 1 WHERE id = #{id}")
    int incrementViews(Integer id);

    // 插入视频（管理员用）
    @Insert("INSERT INTO video(title, category, author, duration, cover_url, video_url, description, sort_order, status) " +
            "VALUES(#{title}, #{category}, #{author}, #{duration}, #{coverUrl}, #{videoUrl}, #{description}, #{sortOrder}, #{status})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Video video);

    // 更新视频（管理员用）
    @Update("UPDATE video SET title=#{title}, category=#{category}, author=#{author}, " +
            "duration=#{duration}, cover_url=#{coverUrl}, video_url=#{videoUrl}, " +
            "description=#{description}, sort_order=#{sortOrder}, status=#{status} " +
            "WHERE id=#{id}")
    int update(Video video);

    // 删除视频（管理员用）
    @Delete("DELETE FROM video WHERE id = #{id}")
    int delete(Integer id);
}