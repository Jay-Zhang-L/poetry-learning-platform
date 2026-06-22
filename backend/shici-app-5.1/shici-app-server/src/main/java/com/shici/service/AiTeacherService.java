package com.shici.service;

import com.shici.domain.dto.ChatMessageRequestDTO;  // 修改导入
import com.shici.domain.dto.ChatReply;
import org.springframework.stereotype.Service;

@Service
public class AiTeacherService {

  public ChatReply reply(ChatMessageRequestDTO msg) {  // 修改参数类型
    // 这里先做"可用占位"，后续你接入大模型接口即可（例如你自己的 /llm/chat）
    String mode = (msg.getMode() == null || msg.getMode().isBlank()) ? "qa" : msg.getMode();
    String text = msg.getMessage();

    String prefix = switch (mode) {
      case "explain" -> "我来讲解：";
      case "fix" -> "我来纠错并给建议：";
      default -> "我来回答：";
    };

    String reply = prefix + text + "\n\n（提示：当前为后端占位回复，你接入大模型后这里会返回真实内容。）";
    String hint = "你可以在后端 AiTeacherService 中替换为真实大模型调用。";
    return new ChatReply(reply, hint);
  }
}