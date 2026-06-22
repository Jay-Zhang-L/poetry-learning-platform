// 文件路径：src/main/java/com/shici/controller/VideoController.java
package com.shici.controller;

import com.shici.domain.Video;
import com.shici.service.VideoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/video")
@CrossOrigin(origins = "http://localhost:5173") // 允许前端访问
public class VideoController {

    @Autowired
    private VideoService videoService;

    // 获取推荐视频列表
    @GetMapping("/recommend")
    public ResponseEntity<List<Video>> getRecommendVideos() {
        List<Video> videos = videoService.getRecommendVideos();
        return ResponseEntity.ok(videos);
    }

    // 获取所有视频
    @GetMapping("/list")
    public ResponseEntity<List<Video>> getAllVideos() {
        List<Video> videos = videoService.getAllVideos();
        return ResponseEntity.ok(videos);
    }

    // 根据ID获取视频详情
    @GetMapping("/{id}")
    public ResponseEntity<Video> getVideoById(@PathVariable Integer id) {
        Video video = videoService.getVideoById(id);
        if (video == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(video);
    }

    // 根据分类获取视频
    @GetMapping("/category/{category}")
    public ResponseEntity<List<Video>> getVideosByCategory(@PathVariable String category) {
        List<Video> videos = videoService.getVideosByCategory(category);
        return ResponseEntity.ok(videos);
    }

    // 增加观看次数
    @PostMapping("/{id}/view")
    public ResponseEntity<Map<String, Object>> incrementView(@PathVariable Integer id) {
        videoService.addViewCount(id);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "观看次数+1");
        return ResponseEntity.ok(result);
    }

    // 搜索视频（按标题）
    @GetMapping("/search")
    public ResponseEntity<List<Video>> searchVideos(@RequestParam String keyword) {
        // 这里需要你在Mapper中添加搜索方法
        // List<Video> videos = videoService.searchVideos(keyword);
        // return ResponseEntity.ok(videos);
        return ResponseEntity.ok(null);
    }
}