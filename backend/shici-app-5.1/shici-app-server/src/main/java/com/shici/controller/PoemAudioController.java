package com.shici.controller;

import com.shici.mapper.PoemMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;

@RestController
@RequestMapping("/api/poem")
public class PoemAudioController {

    @Value("${app.file-root}")
    private String fileRoot;

    private final PoemMapper poemMapper;

    public PoemAudioController(PoemMapper poemMapper) {
        this.poemMapper = poemMapper;
    }

    @PostMapping("/{id}/audio")
    public ResponseEntity<?> uploadAudio(@PathVariable("id") Long id,
                                         @RequestParam("file") MultipartFile file) throws Exception {

        if (file == null || file.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("msg", "文件为空"));
        }

        String original = file.getOriginalFilename();
        String ext = "";
        if (StringUtils.hasText(original) && original.contains(".")) {
            ext = original.substring(original.lastIndexOf(".")).toLowerCase();
        }

        // 只允许常见音频
        if (!ext.equals(".mp3") && !ext.equals(".wav") && !ext.equals(".m4a")) {
            return ResponseEntity.badRequest().body(Map.of("msg", "只支持 mp3/wav/m4a"));
        }

        // 存储路径：{fileRoot}/audio/poem/{id}{ext}
        Path dir = Path.of(fileRoot, "audio", "poem");
        Files.createDirectories(dir);

        String filename = id + ext;
        Path target = dir.resolve(filename);

        // 覆盖写入
        file.transferTo(target.toFile());

        // 写回数据库的 url（前端/浏览器访问用）
        String audioUrl = "/files/audio/poem/" + filename;

        // 时长先不算（后面你要我可以加“自动解析时长”）
        Integer duration = null;

        poemMapper.updateAudio(id, audioUrl, duration, ext.substring(1));

        return ResponseEntity.ok(Map.of(
                "msg", "上传成功",
                "audioUrl", audioUrl
        ));
    }
}
