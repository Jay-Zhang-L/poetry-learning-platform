package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.dto.ChatMessageRequestDTO;  // 修改导入
import com.shici.service.AiTeacherService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/ai/teacher")
@RequiredArgsConstructor
public class AiTeacherController {

  private final AiTeacherService aiTeacherService;

  @PostMapping("/chat")
  public R<?> chat(@Valid @RequestBody ChatMessageRequestDTO msg) {  // 修改参数类型
    return R.ok(aiTeacherService.reply(msg));
  }
}