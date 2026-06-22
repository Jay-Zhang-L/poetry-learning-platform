package com.shici.controller;

import com.shici.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/upload")
public class UploadController {

    @Autowired
    private FileService fileService;

    @Value("${app.file-root}")
    private String fileRoot;

    @PostMapping("/avatar")
    public Map<String, Object> uploadAvatar(@RequestParam("file") MultipartFile file) {
        return saveImage(file, "avatar");
    }

    @PostMapping("/cover")
    public Map<String, Object> uploadCover(@RequestParam("file") MultipartFile file) {
        return saveImage(file, "cover");
    }

    @PostMapping("/image")
    public Map<String, Object> uploadImage(@RequestParam("file") MultipartFile file) {
        return saveImage(file, "creation");
    }

    @PostMapping("/audio")
    public Map<String, Object> uploadAudio(@RequestParam("file") MultipartFile file) {
        Map<String, Object> resp = new HashMap<>();
        try {
            if (file == null || file.isEmpty()) {
                resp.put("code", 500);
                resp.put("msg", "音频文件不能为空");
                resp.put("data", null);
                return resp;
            }
            String url = fileService.saveAudio(file);
            Map<String, Object> data = new HashMap<>();
            data.put("url", url);
            data.put("size", file.getSize());
            data.put("name", file.getOriginalFilename());
            resp.put("code", 200);
            resp.put("msg", "音频上传成功");
            resp.put("data", data);
            return resp;
        } catch (Exception e) {
            resp.put("code", 500);
            resp.put("msg", e.getMessage());
            resp.put("data", null);
            return resp;
        }
    }

    @PostMapping("/video")
    public Map<String, Object> uploadVideo(@RequestParam("file") MultipartFile file) {
        Map<String, Object> resp = new HashMap<>();
        try {
            if (file == null || file.isEmpty()) {
                resp.put("code", 500);
                resp.put("msg", "视频文件不能为空");
                resp.put("data", null);
                return resp;
            }
            String url = fileService.saveVideo(file);
            Map<String, Object> data = new HashMap<>();
            data.put("url", url);
            data.put("size", file.getSize());
            data.put("name", file.getOriginalFilename());
            resp.put("code", 200);
            resp.put("msg", "视频上传成功");
            resp.put("data", data);
            return resp;
        } catch (Exception e) {
            resp.put("code", 500);
            resp.put("msg", e.getMessage());
            resp.put("data", null);
            return resp;
        }
    }

    private Map<String, Object> saveImage(MultipartFile file, String folder) {
        Map<String, Object> resp = new HashMap<>();

        try {
            System.out.println("=== 图片上传开始 ===");
            System.out.println("文件名: " + (file != null ? file.getOriginalFilename() : "null"));
            System.out.println("文件大小: " + (file != null ? file.getSize() : 0) + " bytes");
            System.out.println("目标文件夹: " + folder);
            System.out.println("文件根目录: " + fileRoot);

            if (file == null || file.isEmpty()) {
                resp.put("code", 500);
                resp.put("msg", "上传文件不能为空");
                resp.put("data", null);
                return resp;
            }

            String ext = StringUtils.getFilenameExtension(file.getOriginalFilename());
            if (!StringUtils.hasText(ext)) {
                ext = "jpg";
            }

            File dir = new File(fileRoot, folder);
            System.out.println("完整上传路径: " + dir.getAbsolutePath());

            if (!dir.exists() && !dir.mkdirs()) {
                String errorMsg = "创建上传目录失败: " + dir.getAbsolutePath();
                System.err.println(errorMsg);
                throw new RuntimeException(errorMsg);
            }

            System.out.println("目录是否存在: " + dir.exists());
            System.out.println("目录是否可写: " + dir.canWrite());

            String fileName = UUID.randomUUID().toString().replace("-", "") + "." + ext;
            File dest = new File(dir, fileName);
            System.out.println("保存文件到: " + dest.getAbsolutePath());

            file.transferTo(dest);

            String url = "/files/" + folder + "/" + fileName;
            System.out.println("文件URL: " + url);
            System.out.println("=== 图片上传成功 ===");

            Map<String, Object> data = new HashMap<>();
            data.put("url", url);

            resp.put("code", 200);
            resp.put("msg", "上传成功");
            resp.put("data", data);
            return resp;
        } catch (Exception e) {
            System.err.println("=== 图片上传失败 ===");
            System.err.println("错误信息: " + e.getMessage());
            e.printStackTrace();

            resp.put("code", 500);
            resp.put("msg", e.getMessage());
            resp.put("data", null);
            return resp;
        }
    }
}