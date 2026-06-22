package com.shici.domain;

import lombok.Data;
import java.util.Date;

@Data
public class GameSeason {
    private Long id;
    private String title;
    private String theme;
    private Date startTime;
    private Date endTime;
    private Integer status;
    private Date createdAt;
}
