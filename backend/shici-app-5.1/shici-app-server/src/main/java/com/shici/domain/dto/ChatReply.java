package com.shici.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ChatReply {
  private String reply;
  private String hint;
}
