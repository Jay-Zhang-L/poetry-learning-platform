package com.shici.domain;

import lombok.Data;
import java.util.Date;

@Data
public class ForumComment {
    private Long id;
    private Long postId;
    private Long userId;
    private Long parentId;
    private String content;
    private String imagesJson;
    private Date createdAt;
}
