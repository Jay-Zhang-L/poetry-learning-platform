package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ReciteRecord {
  private Long id;
  private Long userId;
  private Long poemId;
  private String audioUrl;
  private Integer clarity;
  private Integer rhythm;
  private Integer overall;
  private String suggestion;
  private LocalDateTime createdAt;
}
