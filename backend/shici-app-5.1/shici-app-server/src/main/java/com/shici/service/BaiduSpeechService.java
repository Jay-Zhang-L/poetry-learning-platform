package com.shici.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shici.config.BaiduSpeechConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import okhttp3.*;
import org.springframework.stereotype.Service;
import ws.schild.jave.Encoder;
import ws.schild.jave.MultimediaObject;
import ws.schild.jave.encode.AudioAttributes;
import ws.schild.jave.encode.EncodingAttributes;

import java.io.File;
import java.io.IOException;
import java.util.Base64;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.concurrent.TimeUnit;

/**
 * 百度语音识别服务
 * 使用百度语音识别API
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class BaiduSpeechService {

    private final BaiduSpeechConfig baiduSpeechConfig;
    private final ObjectMapper objectMapper;

    // 缓存 Access Token
    private String cachedToken;
    private long tokenExpireTime;

    private final OkHttpClient httpClient = new OkHttpClient.Builder()
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(60, TimeUnit.SECONDS)
            .writeTimeout(60, TimeUnit.SECONDS)
            .build();

    /**
     * 获取百度 API 访问 Token
     */
    private String getAccessToken() throws IOException {
        if (cachedToken != null && System.currentTimeMillis() < tokenExpireTime) {
            return cachedToken;
        }

        String url = baiduSpeechConfig.getTokenUrl()
                + "?grant_type=client_credentials"
                + "&client_id=" + baiduSpeechConfig.getApiKey()
                + "&client_secret=" + baiduSpeechConfig.getSecretKey();

        Request request = new Request.Builder()
                .url(url)
                .post(RequestBody.create("", MediaType.parse("application/json")))
                .build();

        try (Response response = httpClient.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("获取百度Token失败: " + response.code());
            }

            ResponseBody body = response.body();
            if (body == null) {
                throw new IOException("获取百度Token失败: 响应体为空");
            }

            String responseBody = body.string();
            JsonNode jsonNode = objectMapper.readTree(responseBody);

            if (jsonNode.has("error")) {
                String err = jsonNode.has("error_description")
                        ? jsonNode.get("error_description").asText()
                        : jsonNode.get("error").asText();
                throw new IOException("获取百度Token失败: " + err);
            }

            cachedToken = jsonNode.get("access_token").asText();
            int expiresIn = jsonNode.get("expires_in").asInt();
            tokenExpireTime = System.currentTimeMillis() + (expiresIn - 300) * 1000L;

            log.info("百度语音识别Token获取成功，有效期{}秒", expiresIn);
            return cachedToken;
        }
    }

    /**
     * 识别 WAV 音频
     */
    public String recognizeWav(byte[] audioData) throws IOException {
        log.info("接收音频数据，大小={}bytes，开始处理", audioData.length);

        boolean isWav = isWavFormat(audioData);
        int originalSampleRate = isWav ? getWavSampleRate(audioData) : 0;
        log.info("原始音频: 是否WAV={}, 原始采样率={}Hz", isWav, originalSampleRate);

        byte[] wavData;
        int finalSampleRate;

        if (isWav) {
            if (originalSampleRate == 16000 || originalSampleRate == 8000) {
                log.info("原始音频采样率符合要求，直接使用");
                wavData = audioData;
                finalSampleRate = originalSampleRate;
            } else {
                log.info("WAV格式但采样率={}Hz不符合要求，重采样到16000Hz", originalSampleRate);
                wavData = resampleTo16kHz(audioData, originalSampleRate);
                finalSampleRate = 16000;
            }
        } else {
            log.info("非WAV格式，尝试转换为16kHz WAV");
            try {
                wavData = convertToWav(audioData);
                int convertedRate = getWavSampleRate(wavData);
                log.info("JAVE转换后采样率={}Hz", convertedRate);

                if (convertedRate != 16000 && convertedRate != 8000) {
                    log.warn("转换后采样率={}Hz仍不正确，继续重采样到16000Hz", convertedRate);
                    wavData = resampleTo16kHz(wavData, convertedRate);
                    finalSampleRate = 16000;
                } else {
                    finalSampleRate = convertedRate;
                }
            } catch (Exception e) {
                log.error("JAVE转换失败: {}", e.getMessage(), e);
                throw new IOException("无法转换音频格式: " + e.getMessage(), e);
            }
        }

        int verifiedRate = getWavSampleRate(wavData);
        log.info("最终WAV: 头部采样率={}Hz, 大小={}bytes", verifiedRate, wavData.length);

        if (verifiedRate == 16000 || verifiedRate == 8000) {
            finalSampleRate = verifiedRate;
        }

        log.info("调用百度语音识别API，采样率参数={}Hz", finalSampleRate);
        return recognize(wavData, "wav", finalSampleRate);
    }

    /**
     * 识别 PCM 音频
     */
    public String recognizePcm(byte[] audioData) throws IOException {
        return recognize(audioData, "pcm", 16000);
    }

    /**
     * 通用识别方法
     */
    public String recognize(byte[] audioData, String format, int sampleRate) throws IOException {
        String token = getAccessToken();
        log.info("将以格式={}, 采样率={}Hz 进行百度语音识别", format, sampleRate);

        String audioBase64 = Base64.getEncoder().encodeToString(audioData);

        int devPid = baiduSpeechConfig.getDevPid() > 0 ? baiduSpeechConfig.getDevPid() : 1537;

        String requestJson = String.format(
                "{\"format\":\"%s\",\"rate\":%d,\"channel\":1,\"cuid\":\"shici-app\",\"token\":\"%s\",\"dev_pid\":%d,\"speech\":\"%s\",\"len\":%d}",
                format, sampleRate, token, devPid, audioBase64, audioData.length
        );

        String url = baiduSpeechConfig.getAsrUrl();
        log.info("百度语音识别请求URL={}", url);
        log.info("百度语音识别请求参数: format={}, rate={}, channel=1, cuid=shici-app, dev_pid={}, len={}",
                format, sampleRate, devPid, audioData.length);

        Request request = new Request.Builder()
                .url(url)
                .post(RequestBody.create(requestJson, MediaType.parse("application/json; charset=utf-8")))
                .build();

        try (Response response = httpClient.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                log.error("语音识别HTTP请求失败: status={}", response.code());
                throw new IOException("语音识别请求失败: HTTP " + response.code());
            }

            ResponseBody body = response.body();
            if (body == null) {
                throw new IOException("语音识别失败: 响应体为空");
            }

            String responseBody = body.string();
            log.info("百度语音识别响应: {}", responseBody);

            JsonNode jsonNode = objectMapper.readTree(responseBody);
            int errNo = jsonNode.has("err_no") ? jsonNode.get("err_no").asInt() : -1;

            if (errNo != 0) {
                String errMsg = jsonNode.has("err_msg") ? jsonNode.get("err_msg").asText() : "未知错误";
                log.error("语音识别API错误: err_no={}, err_msg={}, 音频大小={}bytes", errNo, errMsg, audioData.length);
                throw new IOException("语音识别失败: " + errMsg + " (err_no=" + errNo + ")");
            }

            JsonNode resultArray = jsonNode.get("result");
            if (resultArray != null && resultArray.isArray() && resultArray.size() > 0) {
                StringBuilder sb = new StringBuilder();
                for (JsonNode node : resultArray) {
                    sb.append(node.asText());
                }
                String result = sb.toString();
                log.info("语音识别成功: {}", result);
                return result;
            }

            log.warn("语音识别返回空结果, 音频大小={}bytes", audioData.length);
            return "";
        }
    }

    /**
     * 转换音频为百度所需 WAV
     * 输出目标：16kHz、单声道、PCM 16-bit WAV
     */
    public byte[] convertToWav(byte[] audioData) throws IOException {
        String inputFormat = isWavFormat(audioData) ? "WAV" : "WebM";
        log.info("开始转换{}格式音频为16kHz WAV，输入大小={}bytes", inputFormat, audioData.length);

        Path tempDir = Paths.get(System.getProperty("java.io.tmpdir"), "shici-audio");
        Files.createDirectories(tempDir);

        String inputExt = isWavFormat(audioData) ? "wav" : "webm";
        Path inputFile = tempDir.resolve("input_" + System.currentTimeMillis() + "." + inputExt);
        Path outputFile = tempDir.resolve("output_" + System.currentTimeMillis() + ".wav");

        try {
            Files.write(inputFile, audioData);

            File source = inputFile.toFile();
            File target = outputFile.toFile();

            AudioAttributes audio = new AudioAttributes();
            audio.setCodec("pcm_s16le");
            audio.setSamplingRate(16000);
            audio.setChannels(1);

            EncodingAttributes attrs = new EncodingAttributes();
            attrs.setOutputFormat("wav");
            attrs.setAudioAttributes(audio);

            Encoder encoder = new Encoder();
            encoder.encode(new MultimediaObject(source), target, attrs);

            byte[] wavData = Files.readAllBytes(outputFile);

            if (!isWavFormat(wavData)) {
                throw new IOException("转换失败：输出不是有效的WAV格式");
            }

            int actualSampleRate = getWavSampleRate(wavData);
            log.info("音频转换成功，输出大小={}bytes，实际采样率={}Hz", wavData.length, actualSampleRate);

            if (actualSampleRate != 16000) {
                log.warn("JAVE转换后的采样率不是16000Hz，尝试强制修正");
                return forceConvertTo16kHz(inputFile, outputFile);
            }

            return wavData;
        } catch (Exception e) {
            log.error("音频转换失败: {}", e.getMessage(), e);
            throw new IOException("音频格式转换失败: " + e.getMessage(), e);
        } finally {
            try {
                Files.deleteIfExists(inputFile);
            } catch (Exception ignored) {
            }
            try {
                Files.deleteIfExists(outputFile);
            } catch (Exception ignored) {
            }
        }
    }

    /**
     * 检测是否 WAV
     */
    private boolean isWavFormat(byte[] data) {
        if (data.length < 12) {
            return false;
        }
        String header = new String(data, 0, 4);
        String wave = new String(data, 8, 4);
        return "RIFF".equals(header) && "WAVE".equals(wave);
    }

    /**
     * 强制转换为16kHz
     */
    private byte[] forceConvertTo16kHz(Path inputFile, Path outputFile) throws IOException {
        try {
            File source = inputFile.toFile();
            File target = outputFile.toFile();

            AudioAttributes audio = new AudioAttributes();
            audio.setCodec("pcm_s16le");
            audio.setSamplingRate(16000);
            audio.setChannels(1);
            audio.setBitRate(256000);

            EncodingAttributes attrs = new EncodingAttributes();
            attrs.setOutputFormat("wav");
            attrs.setAudioAttributes(audio);

            Encoder encoder = new Encoder();
            encoder.encode(new MultimediaObject(source), target, attrs);

            byte[] wavData = Files.readAllBytes(outputFile);
            int actualRate = getWavSampleRate(wavData);
            log.info("强制转换完成，采样率={}Hz，大小={}bytes", actualRate, wavData.length);

            return wavData;
        } catch (Exception e) {
            log.error("强制音频转换失败: {}", e.getMessage(), e);
            throw new IOException("音频格式转换失败: " + e.getMessage(), e);
        }
    }

    /**
     * Java 原生重采样到16kHz
     */
    private byte[] resampleTo16kHz(byte[] wavData, int sourceSampleRate) throws IOException {
        log.info("使用Java原生方式重采样: {}Hz -> 16000Hz", sourceSampleRate);

        try {
            if (wavData.length < 44) {
                throw new IOException("WAV文件太小: " + wavData.length + " bytes");
            }

            int channels = (wavData[22] & 0xFF) | ((wavData[23] & 0xFF) << 8);
            int bitsPerSample = (wavData[34] & 0xFF) | ((wavData[35] & 0xFF) << 8);

            if (channels <= 0 || channels > 2) {
                log.warn("声道数异常: {}, 默认使用1", channels);
                channels = 1;
            }
            if (bitsPerSample != 8 && bitsPerSample != 16) {
                log.warn("位深度异常: {}, 默认使用16", bitsPerSample);
                bitsPerSample = 16;
            }

            log.info("原始WAV参数: 声道数={}, 位深度={}, 源采样率={}Hz", channels, bitsPerSample, sourceSampleRate);

            int dataOffset = findDataChunk(wavData);
            if (dataOffset < 0) {
                throw new IOException("无效的WAV格式：找不到data块");
            }

            int audioDataSize = wavData.length - dataOffset;
            if (audioDataSize <= 0) {
                throw new IOException("WAV音频数据为空");
            }

            int bytesPerSample = bitsPerSample / 8;
            int frameSize = bytesPerSample * channels;
            int totalFrames = audioDataSize / frameSize;
            double ratio = (double) sourceSampleRate / 16000.0;
            int newTotalFrames = (int) (totalFrames / ratio);

            byte[] newAudioData = new byte[newTotalFrames * frameSize];

            for (int i = 0; i < newTotalFrames; i++) {
                double srcFrameIdx = i * ratio;
                int srcFrame0 = (int) srcFrameIdx;
                int srcFrame1 = Math.min(srcFrame0 + 1, totalFrames - 1);
                double frac = srcFrameIdx - srcFrame0;

                for (int c = 0; c < channels; c++) {
                    int srcOffset0 = dataOffset + srcFrame0 * frameSize + c * bytesPerSample;
                    int srcOffset1 = dataOffset + srcFrame1 * frameSize + c * bytesPerSample;
                    int dstOffset = i * frameSize + c * bytesPerSample;

                    if (bitsPerSample == 16) {
                        short sample0 = readLittleEndian16(wavData, srcOffset0);
                        short sample1 = readLittleEndian16(wavData, srcOffset1);
                        short interpolated = (short) (sample0 + (sample1 - sample0) * frac);
                        writeLittleEndian16(newAudioData, dstOffset, interpolated);
                    } else {
                        int sample0 = wavData[srcOffset0] & 0xFF;
                        int sample1 = wavData[srcOffset1] & 0xFF;
                        int interpolated = (int) (sample0 + (sample1 - sample0) * frac);
                        newAudioData[dstOffset] = (byte) interpolated;
                    }
                }
            }

            int newByteRate = 16000 * channels * bytesPerSample;
            int newBlockAlign = channels * bytesPerSample;
            int newFileSize = 36 + newAudioData.length;

            byte[] newWavData = new byte[44 + newAudioData.length];

            System.arraycopy("RIFF".getBytes(), 0, newWavData, 0, 4);
            writeLittleEndian32(newWavData, 4, newFileSize);
            System.arraycopy("WAVE".getBytes(), 0, newWavData, 8, 4);

            System.arraycopy("fmt ".getBytes(), 0, newWavData, 12, 4);
            writeLittleEndian32(newWavData, 16, 16);
            writeLittleEndian16(newWavData, 20, (short) 1);
            writeLittleEndian16(newWavData, 22, (short) channels);
            writeLittleEndian32(newWavData, 24, 16000);
            writeLittleEndian32(newWavData, 28, newByteRate);
            writeLittleEndian16(newWavData, 32, (short) newBlockAlign);
            writeLittleEndian16(newWavData, 34, (short) bitsPerSample);

            System.arraycopy("data".getBytes(), 0, newWavData, 36, 4);
            writeLittleEndian32(newWavData, 40, newAudioData.length);
            System.arraycopy(newAudioData, 0, newWavData, 44, newAudioData.length);

            int verifyRate = getWavSampleRate(newWavData);
            log.info("Java原生重采样完成，新文件大小={}bytes, 验证采样率={}Hz", newWavData.length, verifyRate);

            return newWavData;
        } catch (Exception e) {
            log.error("Java原生重采样失败: {}", e.getMessage(), e);
            throw new IOException("音频重采样失败: " + e.getMessage(), e);
        }
    }

    /**
     * 查找 data chunk
     */
    private int findDataChunk(byte[] wavData) {
        int offset = 12;
        while (offset < wavData.length - 8) {
            String chunkId = new String(wavData, offset, 4);
            int chunkSize = (wavData[offset + 4] & 0xFF)
                    | ((wavData[offset + 5] & 0xFF) << 8)
                    | ((wavData[offset + 6] & 0xFF) << 16)
                    | ((wavData[offset + 7] & 0xFF) << 24);

            if ("data".equals(chunkId)) {
                return offset + 8;
            }
            offset += 8 + chunkSize;
        }
        return -1;
    }

    /**
     * 读取16位小端序
     */
    private short readLittleEndian16(byte[] data, int offset) {
        if (offset + 1 >= data.length) {
            return 0;
        }
        return (short) ((data[offset] & 0xFF) | ((data[offset + 1] & 0xFF) << 8));
    }

    /**
     * 写入32位小端序
     */
    private void writeLittleEndian32(byte[] data, int offset, int value) {
        data[offset] = (byte) (value & 0xFF);
        data[offset + 1] = (byte) ((value >> 8) & 0xFF);
        data[offset + 2] = (byte) ((value >> 16) & 0xFF);
        data[offset + 3] = (byte) ((value >> 24) & 0xFF);
    }

    /**
     * 写入16位小端序
     */
    private void writeLittleEndian16(byte[] data, int offset, short value) {
        data[offset] = (byte) (value & 0xFF);
        data[offset + 1] = (byte) ((value >> 8) & 0xFF);
    }

    /**
     * 从 WAV 文件头读取采样率
     */
    public int getWavSampleRate(byte[] wavData) {
        if (wavData.length < 28) {
            return 16000;
        }
        return (wavData[24] & 0xFF)
                | ((wavData[25] & 0xFF) << 8)
                | ((wavData[26] & 0xFF) << 16)
                | ((wavData[27] & 0xFF) << 24);
    }
}