package com.shici.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * 百度语音识别配置
 * 官网：https://console.bce.baidu.com/ai/#/ai/speech/app/list
 * 免费额度：5万次/月
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "baidu.speech")
public class BaiduSpeechConfig {
    /**
     * 百度语音识别API Key
     */
    private String apiKey;
    
    /**
     * 百度语音识别Secret Key
     */
    private String secretKey;
    
    /**
     * 语音识别API地址
     */
    private String tokenUrl = "https://aip.baidubce.com/oauth/2.0/token";
    
    /**
     * 语音识别API地址
     */
    private String asrUrl = "https://vop.baidu.com/server_api";
    
    /**
     * 语言模型ID（1537=中文普通话）
     */
    private Integer devPid = 1537;
}
