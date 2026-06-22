package com.shici.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Set;
import java.util.UUID;

@Service
public class FileService {

    @Value("${file.upload.path}")
    private String uploadPath;

    /**
     * 保存图片
     * @param file 上传的图片文件
     * @param userId 用户ID
     * @return 图片访问URL
     */
    public String saveImage(MultipartFile file, Long userId) {
        try {
            String datePath = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
            Path uploadDir = Paths.get(uploadPath, "images", datePath);

            if (!Files.exists(uploadDir)) {
                Files.createDirectories(uploadDir);
            }

            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String filename = UUID.randomUUID().toString() + extension;

            Path filePath = uploadDir.resolve(filename);
            file.transferTo(filePath.toFile());

            return "/uploads/images/" + datePath + "/" + filename;
        } catch (IOException e) {
            throw new RuntimeException("保存图片失败: " + e.getMessage(), e);
        }
    }

    private static final Set<String> ALLOWED_AUDIO_EXTENSIONS = Set.of("mp3", "wav", "m4a", "aac", "ogg", "flac");
    private static final long MAX_AUDIO_SIZE = 10 * 1024 * 1024;

    private static final Set<String> ALLOWED_VIDEO_EXTENSIONS = Set.of("mp4", "avi", "mov", "wmv", "mkv", "webm");
    private static final long MAX_VIDEO_SIZE = 50 * 1024 * 1024;

    public String saveAudio(MultipartFile file) {
        validateFile(file, ALLOWED_AUDIO_EXTENSIONS, MAX_AUDIO_SIZE, "音频");
        return saveMedia(file, "audio");
    }

    public String saveVideo(MultipartFile file) {
        validateFile(file, ALLOWED_VIDEO_EXTENSIONS, MAX_VIDEO_SIZE, "视频");
        return saveMedia(file, "video");
    }

    private void validateFile(MultipartFile file, Set<String> allowedExtensions, long maxSize, String mediaType) {
        if (file == null || file.isEmpty()) {
            throw new RuntimeException(mediaType + "文件不能为空");
        }
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || !originalFilename.contains(".")) {
            throw new RuntimeException(mediaType + "文件格式不正确，无法识别扩展名");
        }
        String ext = originalFilename.substring(originalFilename.lastIndexOf(".") + 1).toLowerCase();
        if (!allowedExtensions.contains(ext)) {
            throw new RuntimeException("不支持的" + mediaType + "格式: ." + ext + "，允许的格式: " + allowedExtensions);
        }
        if (file.getSize() > maxSize) {
            throw new RuntimeException(mediaType + "文件过大，最大允许 " + (maxSize / 1024 / 1024) + "MB");
        }
    }

    private String saveMedia(MultipartFile file, String subDir) {
        try {
            Path uploadDir = Paths.get(uploadPath, subDir);

            if (!Files.exists(uploadDir)) {
                Files.createDirectories(uploadDir);
            }

            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String filename = UUID.randomUUID().toString() + extension;

            Path filePath = uploadDir.resolve(filename);
            file.transferTo(filePath.toFile());

            return "/uploads/" + subDir + "/" + filename;
        } catch (IOException e) {
            throw new RuntimeException("保存" + (subDir.equals("audio") ? "音频" : "视频") + "文件失败: " + e.getMessage(), e);
        }
    }

    /**
     * 删除图片
     * @param imageUrl 图片URL
     * @return 是否删除成功
     */
    public boolean deleteImage(String imageUrl) {
        try {
            if (imageUrl == null || imageUrl.isEmpty()) {
                return false;
            }
            // 从 URL 提取文件路径
            String relativePath = imageUrl.replace("/uploads/", "");
            Path filePath = Paths.get(uploadPath, relativePath);
            return Files.deleteIfExists(filePath);
        } catch (IOException e) {
            System.err.println("删除图片失败: " + e.getMessage());
            return false;
        }
    }
}