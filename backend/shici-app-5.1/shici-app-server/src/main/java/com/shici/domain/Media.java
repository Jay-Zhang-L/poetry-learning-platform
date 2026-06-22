package com.shici.domain;

import lombok.Data;

@Data
public class Media {
  private Long id;
  private Long poemId;
  private String type; // audio|video
  private String title;
  private String url;
  private Integer durationSec;
  private String extra; // json
}
