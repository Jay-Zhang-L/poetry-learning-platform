// 文件路径：src/main/java/com/shici/service/VideoService.java
package com.shici.service;

import com.shici.domain.Video;
import com.shici.mapper.VideoMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class VideoService {

    @Autowired
    private VideoMapper videoMapper;

    // 获取推荐视频
    public List<Video> getRecommendVideos() {
        return videoMapper.findRecommendVideos();
    }

    // 获取所有视频
    public List<Video> getAllVideos() {
        return videoMapper.findAll();
    }

    // 根据ID获取视频
    public Video getVideoById(Integer id) {
        return videoMapper.findById(id);
    }

    // 根据分类获取视频
    public List<Video> getVideosByCategory(String category) {
        return videoMapper.findByCategory(category);
    }

    // 增加观看次数
    public void addViewCount(Integer id) {
        videoMapper.incrementViews(id);
    }

    // 添加视频（管理员）
    public Video addVideo(Video video) {
        videoMapper.insert(video);
        return video;
    }

    // 更新视频（管理员）
    public Video updateVideo(Video video) {
        videoMapper.update(video);
        return video;
    }

    // 删除视频（管理员）
    public void deleteVideo(Integer id) {
        videoMapper.delete(id);
    }
}