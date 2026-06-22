package com.shici.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.charset.StandardCharsets;
import java.util.List;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private TokenInterceptor tokenInterceptor;

    @Value("${app.file-root}")
    private String fileRoot;

    @Value("${app.cors.allowed-origins}")
    private String allowedOrigins;

    // AI图片上传目录配置
    @Value("${ai.image.upload-dir:./uploads/}")
    private String imageUploadDir;

    // 新增：文件上传路径（用于作品图片）
    @Value("${file.upload.path:D:/shici-files/uploads}")
    private String fileUploadPath;

    @Override
    public void extendMessageConverters(List<HttpMessageConverter<?>> converters) {
        for (HttpMessageConverter<?> converter : converters) {
            if (converter instanceof MappingJackson2HttpMessageConverter jsonConverter) {
                jsonConverter.setDefaultCharset(StandardCharsets.UTF_8);
            }
        }
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 原有的 /files/** 映射
        registry.addResourceHandler("/files/**")
                .addResourceLocations("file:" + normalizePath(fileRoot) + "/");

        // 映射 /knowledge/** 到知识库目录
        registry.addResourceHandler("/knowledge/**")
                .addResourceLocations("file:" + normalizePath(fileRoot) + "/knowledge/");

        // 映射 /cover/** 到封面目录
        registry.addResourceHandler("/cover/**")
                .addResourceLocations("file:" + normalizePath(fileRoot) + "/cover/");

        // 映射 /avatar/** 到头像目录
        registry.addResourceHandler("/avatar/**")
                .addResourceLocations("file:" + normalizePath(fileRoot) + "/avatar/");

        // 映射 /shouye/** 到首页目录
        registry.addResourceHandler("/shouye/**")
                .addResourceLocations("file:" + normalizePath(fileRoot) + "/shouye/");

        // ========== 作品图片上传目录映射 ==========
        // 映射 /uploads/** 到作品图片上传目录
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + normalizePath(fileUploadPath) + "/")
                .setCachePeriod(3600);  // 缓存1小时

        // AI图片上传目录映射
        registry.addResourceHandler("/ai-images/**")
                .addResourceLocations("file:" + normalizePath(imageUploadDir))
                .setCachePeriod(3600);

        // 诗词图片目录
        registry.addResourceHandler("/poem-images/**")
                .addResourceLocations("file:" + normalizePath(fileUploadPath) + "/images/");
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(tokenInterceptor)
                .addPathPatterns("/api/**")
                .excludePathPatterns("/api/auth/**");
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        String[] origins = allowedOrigins.split(",");
        registry.addMapping("/**")
                .allowedOriginPatterns(origins)
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }

    private String normalizePath(String path) {
        if (path == null) return "";
        return path.replace("\\", "/");
    }
}