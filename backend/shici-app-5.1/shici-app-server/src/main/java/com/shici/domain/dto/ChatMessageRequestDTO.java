package com.shici.domain.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ChatMessageRequestDTO {
  @NotBlank
  private String message;
  private String mode; // explain|qa|fix
  private Long poemId;
}
