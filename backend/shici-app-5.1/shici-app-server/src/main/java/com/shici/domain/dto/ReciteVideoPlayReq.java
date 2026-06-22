// ReciteVideoPlayReq.java
package com.shici.domain.dto;

import lombok.Data;

@Data
public class ReciteVideoPlayReq {
    /**
     * 视频ID
     */
    private Long videoId;

    /**
     * 诗单ID（可选，用于关联）
     */
    private Long playlistId;

    /**
     * 播放时长（秒）
     */
    private Integer playSeconds;

    /**
     * 播放类型：master/student/tutorial/video
     */
    private String playType;
}