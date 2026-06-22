package com.shici.controller;

import com.shici.common.R;
import com.shici.service.ChatMessageService;
import com.shici.domain.vo.ChatMessageVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 聊天室控制器
 *
 * @author shici
 * @date 2026-03-30
 */
@RestController
@RequestMapping("/api/chat")
@CrossOrigin(originPatterns = {"http://localhost:5173", "http://localhost:5174", "http://localhost:5175"}, maxAge = 3600)
public class ChatController {

    @Autowired
    private ChatMessageService chatMessageService;

    /**
     * 发送消息
     */
    @PostMapping("/send")
    public R<ChatMessageVO> sendMessage(@RequestBody Map<String, Object> params) {
        try {
            // 获取参数
            Long userId = Long.valueOf(params.get("userId").toString());
            String nickname = params.get("nickname").toString();
            String avatar = params.get("avatar") != null ? params.get("avatar").toString() : "";
            String content = params.get("content").toString();

            // 参数校验
            if (userId == null || userId <= 0) {
                return R.fail("用户ID无效");
            }
            if (nickname == null || nickname.trim().isEmpty()) {
                return R.fail("昵称不能为空");
            }
            if (content == null || content.trim().isEmpty()) {
                return R.fail("消息内容不能为空");
            }
            if (content.length() > 500) {
                return R.fail("消息内容不能超过500个字符");
            }

            // 发送消息
            ChatMessageVO message = chatMessageService.sendMessage(userId, nickname, avatar, content);
            return R.ok(message);

        } catch (NumberFormatException e) {
            return R.fail("用户ID格式错误");
        } catch (Exception e) {
            e.printStackTrace();
            return R.fail("发送消息失败：" + e.getMessage());
        }
    }

    /**
     * 获取最新消息（默认50条）
     */
    @GetMapping("/latest")
    public R<List<ChatMessageVO>> getLatestMessages() {
        try {
            List<ChatMessageVO> messages = chatMessageService.getLatestMessages();
            return R.ok(messages);
        } catch (Exception e) {
            e.printStackTrace();
            return R.fail("获取最新消息失败：" + e.getMessage());
        }
    }

    /**
     * 获取历史消息（分页）
     */
    @GetMapping("/history")
    public R<Map<String, Object>> getHistoryMessages(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "20") Integer size) {
        try {
            // 参数校验
            if (page < 1) {
                page = 1;
            }
            if (size < 1 || size > 100) {
                size = 20;
            }

            // 获取历史消息
            List<ChatMessageVO> messages = chatMessageService.getHistoryMessages(page, size);

            // 封装返回数据
            Map<String, Object> result = new HashMap<>();
            result.put("messages", messages);
            result.put("page", page);
            result.put("size", size);
            result.put("total", messages.size());

            return R.ok(result);

        } catch (Exception e) {
            e.printStackTrace();
            return R.fail("获取历史消息失败：" + e.getMessage());
        }
    }

    /**
     * 健康检查接口
     */
    @GetMapping("/health")
    public R<String> health() {
        return R.ok("Chat service is running");
    }

    /**
     * 获取消息总数
     */
    @GetMapping("/count")
    public R<Map<String, Long>> getMessageCount() {
        try {
            long count = chatMessageService.getTotalCount();
            Map<String, Long> result = new HashMap<>();
            result.put("count", count);
            return R.ok(result);
        } catch (Exception e) {
            e.printStackTrace();
            return R.fail("获取消息总数失败：" + e.getMessage());
        }
    }
}