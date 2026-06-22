package com.shici.controller;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

@RestController
@RequestMapping("/images")
@CrossOrigin(origins = "http://localhost:5173")
public class ImageController {

    private static final String IMAGE_PATH = "D:/shici-files/shouye/images/";

    @GetMapping("/{filename:.+}")
    public ResponseEntity<Resource> getImage(@PathVariable String filename) {
        try {
            Path filePath = Paths.get(IMAGE_PATH).resolve(filename).normalize();
            File file = filePath.toFile();

            if (!file.exists()) {
                System.out.println("图片不存在: " + filePath);
                return ResponseEntity.notFound().build();
            }

            Resource resource = new FileSystemResource(file);

            String lower = filename.toLowerCase();
            String contentType = "image/jpeg";
            if (lower.endsWith(".png")) {
                contentType = "image/png";
            } else if (lower.endsWith(".gif")) {
                contentType = "image/gif";
            } else if (lower.endsWith(".webp")) {
                contentType = "image/webp";
            } else if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) {
                contentType = "image/jpeg";
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .body(resource);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.notFound().build();
        }
    }
}