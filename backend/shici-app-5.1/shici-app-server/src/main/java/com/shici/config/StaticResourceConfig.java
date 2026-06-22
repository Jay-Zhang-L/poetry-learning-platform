package com.shici.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Paths;

@Configuration
public class StaticResourceConfig implements WebMvcConfigurer {

    @Value("${app.file-root}")
    private String fileRoot;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 映射 /uploads/** 路径（已废弃，保留兼容性）
        String uploadDir = Paths.get(fileRoot, "uploads").toAbsolutePath().toString().replace("\\", "/");
        System.out.println("配置静态资源映射: /uploads/** -> file:" + uploadDir + "/");
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadDir + "/");

        // 映射 /files/** 路径（用于图片上传）
        String filesDir = Paths.get(fileRoot).toAbsolutePath().toString().replace("\\", "/");
        System.out.println("配置静态资源映射: /files/** -> file:" + filesDir + "/");
        registry.addResourceHandler("/files/**")
                .addResourceLocations("file:" + filesDir + "/")
                .setCachePeriod(3600);  // 缓存1小时
        
        // 映射 /game/** 路径（用于诗人朋友圈游戏图片）
        String gameDir = "D:/shici_app_4.2/shici-app-starter/public/game/";
        System.out.println("配置静态资源映射: /game/** -> file:" + gameDir);
        registry.addResourceHandler("/game/**")
                .addResourceLocations("file:" + gameDir)
                .setCachePeriod(3600);  // 缓存1小时
    }
}