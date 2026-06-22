package com.shici.domain;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class UserProgress {
  private Long id;
  private Long userId;
  private Long unitId;
  private Integer progress; // 0-100
  private Integer streakDays;
  private LocalDateTime updatedAt;
}
