package com.shici.domain;

import lombok.Data;

@Data
public class LearnUnit {
  private Long id;
  private Integer grade; // 1..12
  private String name;
  private String description;
  private Integer estimatedMin;
  private String mode; // listen|recite|dictation
  private Integer difficultyStar;
  private Integer sortNo;
}
