package com.shici.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.Arrays;

@Configuration
public class CorsConfig implements WebMvcConfigurer {

  @Value("${app.cors.allowed-origins:}")
  private String allowedOrigins;

  @Override
  public void addCorsMappings(CorsRegistry registry) {

    String[] origins;

    if (allowedOrigins == null || allowedOrigins.trim().isEmpty()) {
      // 默认本地开发端口（你项目用过多个端口）
      origins = new String[]{
              "http://localhost:5173",
              "http://127.0.0.1:5173",
              "http://localhost:5174",
              "http://127.0.0.1:5174",
              "http://localhost:5175",
              "http://127.0.0.1:5175"
      };
    } else {
      origins = Arrays.stream(allowedOrigins.split(","))
              .map(String::trim)
              .filter(s -> !s.isEmpty())
              .toArray(String[]::new);
    }

    registry.addMapping("/**")
            // ⚠️ 用 patterns（更灵活）
            .allowedOriginPatterns(origins)
            .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
            .allowedHeaders("*")
            .allowCredentials(true)
            .maxAge(3600);
  }
}