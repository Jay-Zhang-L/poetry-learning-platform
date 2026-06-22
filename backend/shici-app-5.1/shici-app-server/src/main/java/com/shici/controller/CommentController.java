package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.SysUser;
import com.shici.domain.dto.CommentDto;
import com.shici.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.Map;

@RestController
@RequestMapping("/api/comments")
public class CommentController {
    
    @Autowired
    private CommentService commentService;
    
    private Long getCurrentUserId(HttpSession session) {
        SysUser user = (SysUser) session.getAttribute("user");
        return user != null ? user.getId() : null;
    }
    
    /**
     * 获取作品评论列表
     */
    @GetMapping
    public R<Map<String, Object>> getComments(@RequestParam Long workId,
                                              @RequestParam(defaultValue = "1") int page,
                                              @RequestParam(defaultValue = "20") int pageSize) {
        Map<String, Object> result = commentService.getComments(workId, page, pageSize);
        return R.ok(result);
    }
    
    /**
     * 发表评论
     */
    @PostMapping
    public R<CommentDto> create(@RequestBody Map<String, Object> body, HttpSession session) {
        try {
            Long userId = getCurrentUserId(session);
            if (userId == null) {
                return R.fail("请先登录");
            }
            
            if (body.get("workId") == null) {
                return R.fail("作品ID不能为空");
            }
            if (body.get("content") == null) {
                return R.fail("评论内容不能为空");
            }
            
            Long workId = Long.valueOf(body.get("workId").toString());
            String content = body.get("content").toString();
            Long parentId = body.get("parentId") != null ? Long.valueOf(body.get("parentId").toString()) : null;
            
            if (content.trim().isEmpty()) {
                return R.fail("评论内容不能为空");
            }
            
            CommentDto comment = commentService.create(workId, userId, content, parentId);
            return R.ok(comment);
        } catch (Exception e) {
            e.printStackTrace();
            return R.fail("评论失败：" + e.getMessage());
        }
    }
    
    /**
     * 删除评论
     */
    @DeleteMapping("/{id}")
    public R<Void> delete(@PathVariable Long id, HttpSession session) {
        Long userId = getCurrentUserId(session);
        if (userId == null) {
            return R.fail("请先登录");
        }
        
        boolean success = commentService.delete(id, userId);
        if (!success) {
            return R.fail("删除失败，评论不存在或无权限");
        }
        return R.ok();
    }
}
