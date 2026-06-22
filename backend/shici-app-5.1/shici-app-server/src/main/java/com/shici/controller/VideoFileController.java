package com.shici.controller;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

@RestController
@RequestMapping("/videos")
@CrossOrigin(origins = "http://localhost:5173")
public class VideoFileController {

    private static final String VIDEO_PATH = "D:/shici-files/shouye/videos/";

    @GetMapping("/{filename:.+}")
    public ResponseEntity<Resource> getVideo(@PathVariable String filename) {
        try {
            Path filePath = Paths.get(VIDEO_PATH).resolve(filename).normalize();
            File file = filePath.toFile();

            if (!file.exists()) {
                System.out.println("视频不存在: " + filePath);
                return ResponseEntity.notFound().build();
            }

            Resource resource = new FileSystemResource(file);

            String lower = filename.toLowerCase();
            String contentType = "video/mp4";
            if (lower.endsWith(".webm")) {
                contentType = "video/webm";
            } else if (lower.endsWith(".ogg")) {
                contentType = "video/ogg";
            } else if (lower.endsWith(".mp4")) {
                contentType = "video/mp4";
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + file.getName() + "\"")
                    .body(resource);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.notFound().build();
        }
    }
}