package com.shici.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.shici.common.R;
import com.shici.domain.CreationWork;
import com.shici.domain.SysUser;
import com.shici.service.CreationService;
import com.shici.service.FileService;
import com.shici.service.TokenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/creations")
public class CreationController {

    @Autowired
    private CreationService creationService;

    @Autowired
    private TokenService tokenService;

    @Autowired
    private FileService fileService;

    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * 从 Session 获取当前用户 ID（已增加空判断）
     */
    private Long getCurrentUserId(HttpSession session) {
        if (session == null) {
            return null;
        }
        SysUser user = (SysUser) session.getAttribute("user");
        return user != null ? user.getId() : null;
    }

    /**
     * 从 Token 获取当前用户 ID
     */
    private Long getUserIdFromToken(String auth) {
        if (auth == null || !auth.startsWith("Bearer ")) return null;
        String token = auth.substring("Bearer ".length()).trim();
        return tokenService.getUserId(token);
    }

    /**
     * 获取创作列表（推荐流）
     */
    @GetMapping
    public R<Map<String, Object>> getList(@RequestParam(defaultValue = "recommend") String tab,
                                          @RequestParam(defaultValue = "all") String type,
                                          @RequestParam(defaultValue = "time") String sortBy,
                                          @RequestParam(defaultValue = "1") int page,
                                          @RequestParam(defaultValue = "10") int pageSize,
                                          HttpSession session) {
        Long userId = getCurrentUserId(session);
        Map<String, Object> result = creationService.getList(tab, userId, type, sortBy, page, pageSize);
        return R.ok(result);
    }

    /**
     * 获取某个作者的公开作品列表
     */
    @GetMapping("/user/{userId}")
    public R<Map<String, Object>> getUserWorks(@PathVariable Long userId,
                                               @RequestParam(defaultValue = "all") String type,
                                               @RequestParam(defaultValue = "time") String sortBy,
                                               @RequestParam(defaultValue = "1") int page,
                                               @RequestParam(defaultValue = "10") int pageSize,
                                               HttpSession session) {
        Long currentUserId = getCurrentUserId(session);
        Map<String, Object> result = creationService.getUserWorks(userId, currentUserId, type, sortBy, page, pageSize);
        return R.ok(result);
    }

    /**
     * 获取我的作品列表（已修复 session 空指针问题）
     */
    @GetMapping("/my")
    public R<Map<String, Object>> getMyWorks(@RequestParam(defaultValue = "all") String type,
                                             @RequestParam(defaultValue = "time") String sortBy,
                                             @RequestParam(defaultValue = "1") int page,
                                             @RequestParam(defaultValue = "10") int pageSize,
                                             @RequestHeader(value = "Authorization", required = false) String auth,
                                             HttpSession session) {
        Long userId = getUserIdFromToken(auth);
        if (userId == null) {
            userId = getCurrentUserId(session);
        }
        if (userId == null) {
            return R.fail("请先登录");
        }

        Map<String, Object> result = creationService.getMyWorks(userId, type, sortBy, page, pageSize);
        return R.ok(result);
    }

    /**
     * 获取我的作品统计（已修复 session 空指针问题）
     */
    @GetMapping("/my/stats")
    public R<Map<String, Object>> getMyStats(@RequestHeader(value = "Authorization", required = false) String auth,
                                             HttpSession session) {
        Long userId = getUserIdFromToken(auth);
        if (userId == null) {
            userId = getCurrentUserId(session);
        }
        if (userId == null) {
            return R.fail("请先登录");
        }

        Map<String, Object> stats = creationService.getMyStats(userId);
        return R.ok(stats);
    }

    /**
     * 获取我的作品获赞记录详情
     */
    @GetMapping("/my/likes")
    public Map<String, Object> getMyLikes(@RequestHeader(value = "Authorization", required = false) String auth,
                                          @RequestParam(defaultValue = "1") int page,
                                          @RequestParam(defaultValue = "20") int size,
                                          HttpSession session) {
        Map<String, Object> res = new HashMap<>();
        Long userId = getUserIdFromToken(auth);
        if (userId == null) {
            userId = getCurrentUserId(session);
        }
        if (userId == null) {
            res.put("code", 1);
            res.put("message", "请先登录");
            res.put("data", null);
            return res;
        }

        Map<String, Object> result = creationService.getMyLikes(userId, page, size);
        res.put("code", 200);
        res.put("message", "success");
        res.put("data", result);
        return res;
    }

    /**
     * 获取作品详情
     */
    @GetMapping("/{id}")
    public R<CreationWork> getDetail(@PathVariable Long id, HttpSession session) {
        Long userId = getCurrentUserId(session);
        CreationWork work = creationService.getById(id, userId);
        if (work == null) {
            return R.fail("作品不存在");
        }
        return R.ok(work);
    }

    /**
     * 发布作品（支持文件上传，使用 Jackson）
     */
    @PostMapping
    public R<CreationWork> create(
            @RequestParam(value = "title", required = false) String title,
            @RequestParam("content") String content,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam("type") String type,
            @RequestParam(value = "privacy", defaultValue = "public") String privacy,
            @RequestParam(value = "tags", required = false) List<String> tags,
            @RequestParam(value = "images", required = false) List<MultipartFile> images,
            @RequestParam(value = "audio", required = false) MultipartFile audio,
            @RequestParam(value = "video", required = false) MultipartFile video,
            HttpSession session) {

        Long userId = getCurrentUserId(session);
        if (userId == null) {
            return R.fail("请先登录");
        }

        if (content == null || content.trim().isEmpty()) {
            return R.fail("作品内容不能为空");
        }

        // 保存图片文件，返回 URL 列表
        List<String> imageUrls = new ArrayList<>();
        if (images != null && !images.isEmpty()) {
            for (MultipartFile image : images) {
                if (image != null && !image.isEmpty()) {
                    try {
                        String url = fileService.saveImage(image, userId);
                        imageUrls.add(url);
                    } catch (Exception e) {
                        System.err.println("保存图片失败: " + e.getMessage());
                    }
                }
            }
        }

        // 构建作品对象
        CreationWork work = new CreationWork();
        work.setUserId(userId);
        work.setTitle(title);
        work.setContent(content);
        work.setDescription(description);
        work.setType(type);
        work.setPrivacy(privacy);
        work.setTags(tags);

        // 将图片 URL 列表转为 JSON 字符串存储（使用 Jackson）
        if (!imageUrls.isEmpty()) {
            try {
                work.setImages(objectMapper.writeValueAsString(imageUrls));
            } catch (Exception e) {
                System.err.println("JSON转换失败: " + e.getMessage());
                work.setImages(null);
            }
        }

        // 保存音频文件
        if (audio != null && !audio.isEmpty()) {
            try {
                String audioUrl = fileService.saveAudio(audio);
                work.setAudioUrl(audioUrl);
            } catch (Exception e) {
                System.err.println("保存音频失败: " + e.getMessage());
            }
        }

        // 保存视频文件
        if (video != null && !video.isEmpty()) {
            try {
                String videoUrl = fileService.saveVideo(video);
                work.setVideoUrl(videoUrl);
            } catch (Exception e) {
                System.err.println("保存视频失败: " + e.getMessage());
            }
        }

        CreationWork created = creationService.create(work);
        return R.ok(created);
    }

    /**
     * 更新作品
     */
    @PutMapping("/{id}")
    public R<Void> update(@PathVariable Long id,
                          @RequestBody CreationWork work,
                          HttpSession session) {
        Long userId = getCurrentUserId(session);
        if (userId == null) {
            return R.fail("请先登录");
        }

        work.setId(id);
        boolean success = creationService.update(work, userId);
        if (!success) {
            return R.fail("更新失败，作品不存在或无权限");
        }
        return R.ok();
    }

    /**
     * 删除作品
     */
    @DeleteMapping("/{id}")
    public R<Void> delete(@PathVariable Long id, HttpSession session) {
        Long userId = getCurrentUserId(session);
        if (userId == null) {
            return R.fail("请先登录");
        }

        boolean success = creationService.delete(id, userId);
        if (!success) {
            return R.fail("删除失败，作品不存在或无权限");
        }
        return R.ok();
    }

    /**
     * 点赞/取消点赞
     */
    @PostMapping("/{id}/like")
    public R<Void> toggleLike(@PathVariable Long id,
                              @RequestBody Map<String, Boolean> body,
                              HttpSession session) {
        Long userId = getCurrentUserId(session);
        if (userId == null) {
            return R.fail("请先登录");
        }

        boolean like = body.getOrDefault("like", true);
        boolean success = creationService.toggleLike(id, userId, like);
        if (!success) {
            return R.fail("操作失败");
        }
        return R.ok();
    }

    /**
     * 收藏/取消收藏
     */
    @PostMapping("/{id}/save")
    public R<Void> toggleSave(@PathVariable Long id,
                              @RequestBody Map<String, Boolean> body,
                              HttpSession session) {
        Long userId = getCurrentUserId(session);
        if (userId == null) {
            return R.fail("请先登录");
        }

        boolean save = body.getOrDefault("save", true);
        boolean success = creationService.toggleSave(id, userId, save);
        if (!success) {
            return R.fail("操作失败");
        }
        return R.ok();
    }
}