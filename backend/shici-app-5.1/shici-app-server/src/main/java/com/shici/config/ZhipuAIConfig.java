package com.shici.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Data
@Configuration
@ConfigurationProperties(prefix = "ai.zhipu")
public class ZhipuAIConfig {
    private String apiKey;
    private String model = "glm-4-flash";
    private String baseUrl = "https://open.bigmodel.cn/api/paas/v4";
}
