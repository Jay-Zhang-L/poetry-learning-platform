package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.ForumComment;
import com.shici.domain.ForumPost;
import com.shici.service.ForumService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/forum")
public class ForumController {

    private final ForumService forumService;

    public ForumController(ForumService forumService) {
        this.forumService = forumService;
    }

    @GetMapping("/posts")
    public R<?> posts(@RequestParam("seasonId") Long seasonId,
                      @RequestParam(value = "page", required = false) Integer page,
                      @RequestParam(value = "size", required = false) Integer size) {
        return R.ok(forumService.listPosts(seasonId, page, size));
    }

    @PostMapping("/post")
    public R<?> create(@RequestBody ForumPost p) {
        return R.ok(forumService.createPost(p));
    }

    @GetMapping("/post/{id}")
    public R<?> post(@PathVariable("id") Long id) {
        return R.ok(forumService.getPost(id));
    }

    @GetMapping("/post/{id}/comments")
    public R<?> comments(@PathVariable("id") Long postId) {
        return R.ok(forumService.listComments(postId));
    }

    @PostMapping("/post/{id}/comment")
    public R<?> comment(@PathVariable("id") Long postId, @RequestBody ForumComment c) {
        c.setPostId(postId);
        return R.ok(forumService.addComment(c));
    }
}
