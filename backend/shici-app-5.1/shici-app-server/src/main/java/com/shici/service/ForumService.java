package com.shici.service;

import com.shici.domain.ForumComment;
import com.shici.domain.ForumPost;
import com.shici.mapper.ForumMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ForumService {

    private final ForumMapper forumMapper;

    public ForumService(ForumMapper forumMapper) {
        this.forumMapper = forumMapper;
    }

    public List<ForumPost> listPosts(Long seasonId, Integer page, Integer size) {
        int p = page == null || page < 1 ? 1 : page;
        int s = size == null || size < 1 ? 10 : size;
        int offset = (p - 1) * s;
        return forumMapper.listPosts(seasonId, offset, s);
    }

    public ForumPost getPost(Long id) {
        return forumMapper.getPost(id);
    }

    public ForumPost createPost(ForumPost p) {
        forumMapper.insertPost(p);
        return p;
    }

    public List<ForumComment> listComments(Long postId) {
        return forumMapper.listComments(postId);
    }

    public ForumComment addComment(ForumComment c) {
        forumMapper.insertComment(c);
        forumMapper.incCommentCount(c.getPostId());
        return c;
    }
}
