package com.shici.domain;

import lombok.Data;

@Data
public class GameEntry {
  private Long id;
  private String code; // feihualing|guess|chain
  private String name;
  private String desc;
  private String coverUrl;
  private Integer weeklyNo;
  private Integer sortNo;
}
