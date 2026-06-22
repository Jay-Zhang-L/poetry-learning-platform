package com.shici.domain;

import lombok.Data;
import java.util.Date;

@Data
public class ForumPost {
    private Long id;
    private Long seasonId;
    private Long userId;
    private String title;
    private String content;
    private String imagesJson;
    private Integer likeCount;
    private Integer commentCount;
    private Date createdAt;
}
