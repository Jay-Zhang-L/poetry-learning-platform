package com.shici.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shici.config.AIConfig;
import com.shici.domain.ReciteRecording;
import com.shici.domain.vo.ReciteRecordingVO;
import com.shici.mapper.ReciteRecordingMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * 朗诵录音评价服务
 * 功能：接收录音 -> 语音识别 -> AI评价 -> 存储结果
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ReciteRecordingService {

    private final BaiduSpeechService baiduSpeechService;
    private final ReciteRecordingMapper recordingMapper;
    private final AIConfig aiConfig;
    private final ObjectMapper objectMapper;
    
    @Value("${app.file-root}")
    private String fileRoot;
    
    private final OkHttpClient httpClient = new OkHttpClient.Builder()
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(120, TimeUnit.SECONDS)
            .writeTimeout(60, TimeUnit.SECONDS)
            .build();

    /**
     * 提交录音并获取AI评价
     * @param userId 用户ID
     * @param poemId 诗词ID
     * @param poemTitle 诗词标题
     * @param poemContent 诗词原文
     * @param audioFile 录音文件
     * @param audioDuration 录音时长（秒）
     * @return 录音评价结果
     */
    public ReciteRecordingVO submitRecording(Long userId, Long poemId, String poemTitle, 
            String poemContent, MultipartFile audioFile, Integer audioDuration) throws IOException {
        
        // 1. 先读取音频数据（必须在transferTo之前读取）
        byte[] audioData = audioFile.getBytes();
        
        // 2. 保存录音文件
        String audioUrl = saveAudioFile(audioFile, userId);
        
        // 3. 调用百度语音识别
        String transcribedText = "";
        try {
            transcribedText = baiduSpeechService.recognizeWav(audioData);
            log.info("语音识别结果: {}", transcribedText);
        } catch (Exception e) {
            log.error("语音识别失败", e);
            // 识别失败也继续处理，只是识别文本为空
        }
        
        // 4. 调用AI进行评价
        AIEvaluationResult aiResult = evaluateWithAI(poemTitle, poemContent, transcribedText);
        
        // 4. 保存到数据库
        ReciteRecording recording = new ReciteRecording();
        recording.setUserId(userId);
        recording.setPoemId(poemId);
        recording.setPoemTitle(poemTitle);
        recording.setPoemContent(poemContent);
        recording.setAudioUrl(audioUrl);
        recording.setAudioDuration(audioDuration != null ? audioDuration : 0);
        recording.setTranscribedText(transcribedText);
        recording.setClarityScore(aiResult.clarityScore);
        recording.setRhythmScore(aiResult.rhythmScore);
        recording.setEmotionScore(aiResult.emotionScore);
        recording.setOverallScore(aiResult.overallScore);
        recording.setAiEvaluation(aiResult.evaluation);
        recording.setAiSuggestion(aiResult.suggestion);
        
        recordingMapper.insert(recording);
        
        log.info("录音评价保存成功, recordingId={}", recording.getId());
        
        return toVO(recording);
    }

    /**
     * 保存录音文件到本地
     */
    private String saveAudioFile(MultipartFile audioFile, Long userId) throws IOException {
        // 创建录音保存目录
        String recordingDir = fileRoot + "/recordings";
        Path dirPath = Paths.get(recordingDir);
        if (!Files.exists(dirPath)) {
            Files.createDirectories(dirPath);
        }
        
        // 生成文件名: userId_timestamp.wav
        String fileName = userId + "_" + System.currentTimeMillis() + ".wav";
        String filePath = recordingDir + "/" + fileName;
        
        // 保存文件
        File targetFile = new File(filePath);
        audioFile.transferTo(targetFile);
        
        log.info("录音文件保存成功: {}", filePath);
        
        // 返回访问URL
        return "/files/recordings/" + fileName;
    }

    /**
     * 调用DeepSeek AI进行朗诵评价
     */
    private AIEvaluationResult evaluateWithAI(String poemTitle, String poemContent, String transcribedText) {
        try {
            String systemPrompt = buildSystemPrompt();
            String userMessage = buildUserMessage(poemTitle, poemContent, transcribedText);
            
            // 构建请求
            Map<String, Object> requestBody = new HashMap<>();
            
            List<Map<String, String>> messages = new ArrayList<>();
            
            Map<String, String> systemMsg = new HashMap<>();
            systemMsg.put("role", "system");
            systemMsg.put("content", systemPrompt);
            messages.add(systemMsg);
            
            Map<String, String> userMsg = new HashMap<>();
            userMsg.put("role", "user");
            userMsg.put("content", userMessage);
            messages.add(userMsg);
            
            requestBody.put("messages", messages);
            requestBody.put("model", "deepseek-chat");
            requestBody.put("temperature", 0.7);
            requestBody.put("stream", false);
            
            // 发送请求
            String url = aiConfig.getModelUrl();
            
            Request request = new Request.Builder()
                    .url(url)
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + aiConfig.getApiKey())
                    .post(RequestBody.create(objectMapper.writeValueAsString(requestBody), 
                            okhttp3.MediaType.parse("application/json")))
                    .build();
            
            try (Response response = httpClient.newCall(request).execute()) {
                if (!response.isSuccessful()) {
                    log.error("AI调用失败: {}", response.code());
                    return getDefaultResult();
                }
                
                String responseBody = response.body().string();
                JsonNode jsonNode = objectMapper.readTree(responseBody);
                String content = jsonNode.get("choices").get(0).get("message").get("content").asText();
                
                return parseAIResponse(content);
            }
            
        } catch (Exception e) {
            log.error("AI评价调用失败", e);
            return getDefaultResult();
        }
    }

    /**
     * 构建系统提示词
     */
    private String buildSystemPrompt() {
        return """
            你是一位专业的诗词朗诵教师墨墨老师。你的任务是评价学生的诗词朗诵录音。
            
            你会收到以下信息：
            1. 诗词标题
            2. 诗词原文
            3. 学生朗诵的语音识别文本（可能存在识别误差）
            
            请从以下维度进行评价：
            1. 清晰度（0-100分）：发音是否清晰，吐字是否准确
            2. 节奏感（0-100分）：停顿是否合理，节奏是否流畅
            3. 情感表达（0-100分）：情感是否到位，是否能体现诗词意境
            
            请严格按照以下JSON格式返回评价结果，不要包含其他内容：
            {
                "clarity_score": 评分数字,
                "rhythm_score": 评分数字,
                "emotion_score": 评分数字,
                "overall_score": 综合评分数字,
                "evaluation": "详细评价内容，包括优点和不足",
                "suggestion": "具体的改进建议"
            }
            
            注意事项：
            - 评分要客观公正，既不要过于苛刻，也不要一味夸奖
            - 评价要具体，指出朗诵的亮点和需要改进的地方
            - 建议要实用，给出具体的练习方法
            """;
    }

    /**
     * 构建用户消息
     */
    private String buildUserMessage(String poemTitle, String poemContent, String transcribedText) {
        StringBuilder sb = new StringBuilder();
        sb.append("诗词标题：").append(poemTitle != null ? poemTitle : "未知").append("\n\n");
        sb.append("诗词原文：\n").append(poemContent != null ? poemContent : "无").append("\n\n");
        sb.append("学生朗诵语音识别文本：\n").append(transcribedText != null && !transcribedText.isEmpty() ? transcribedText : "（语音识别失败，请根据诗词内容给出通用建议）").append("\n\n");
        sb.append("请对这次朗诵进行评价。");
        return sb.toString();
    }

    /**
     * 解析AI响应
     */
    private AIEvaluationResult parseAIResponse(String content) {
        try {
            // 尝试从响应中提取JSON
            int start = content.indexOf("{");
            int end = content.lastIndexOf("}");
            if (start >= 0 && end > start) {
                String jsonStr = content.substring(start, end + 1);
                JsonNode json = objectMapper.readTree(jsonStr);
                
                return new AIEvaluationResult(
                        json.has("clarity_score") ? json.get("clarity_score").asInt() : 70,
                        json.has("rhythm_score") ? json.get("rhythm_score").asInt() : 70,
                        json.has("emotion_score") ? json.get("emotion_score").asInt() : 70,
                        json.has("overall_score") ? json.get("overall_score").asInt() : 70,
                        json.has("evaluation") ? json.get("evaluation").asText() : "评价解析失败",
                        json.has("suggestion") ? json.get("suggestion").asText() : "建议解析失败"
                );
            }
        } catch (Exception e) {
            log.error("解析AI响应失败", e);
        }
        return getDefaultResult();
    }

    /**
     * 获取默认结果
     */
    private AIEvaluationResult getDefaultResult() {
        return new AIEvaluationResult(
                70, 70, 70, 70,
                "AI评价暂时不可用，请稍后再试。",
                "建议多加练习，注意发音清晰、节奏恰当、情感真挚。"
        );
    }

    /**
     * 获取用户的录音评价记录
     */
    public List<ReciteRecordingVO> getMyRecordings(Long userId) {
        List<ReciteRecording> recordings = recordingMapper.selectByUserId(userId);
        return recordings.stream().map(this::toVO).toList();
    }

    /**
     * 获取用户对某首诗的录音评价记录
     */
    public List<ReciteRecordingVO> getMyRecordingsByPoem(Long userId, Long poemId) {
        List<ReciteRecording> recordings = recordingMapper.selectByUserIdAndPoemId(userId, poemId);
        return recordings.stream().map(this::toVO).toList();
    }

    /**
     * 获取录音评价详情
     */
    public ReciteRecordingVO getRecordingDetail(Long id) {
        ReciteRecording recording = recordingMapper.selectById(id);
        if (recording == null) {
            return null;
        }
        return toVO(recording);
    }

    /**
     * 删除录音评价记录
     */
    public boolean deleteRecording(Long id, Long userId) {
        return recordingMapper.deleteById(id, userId) > 0;
    }

    /**
     * 转换为VO
     */
    private ReciteRecordingVO toVO(ReciteRecording recording) {
        return ReciteRecordingVO.builder()
                .id(recording.getId())
                .poemId(recording.getPoemId())
                .poemTitle(recording.getPoemTitle())
                .poemContent(recording.getPoemContent())
                .audioUrl(recording.getAudioUrl())
                .audioDuration(recording.getAudioDuration())
                .transcribedText(recording.getTranscribedText())
                .clarityScore(recording.getClarityScore())
                .rhythmScore(recording.getRhythmScore())
                .emotionScore(recording.getEmotionScore())
                .overallScore(recording.getOverallScore())
                .aiEvaluation(recording.getAiEvaluation())
                .aiSuggestion(recording.getAiSuggestion())
                .createdAt(recording.getCreatedAt())
                .build();
    }

    /**
     * AI评价结果内部类
     */
    private record AIEvaluationResult(
            int clarityScore,
            int rhythmScore,
            int emotionScore,
            int overallScore,
            String evaluation,
            String suggestion
    ) {}
}
