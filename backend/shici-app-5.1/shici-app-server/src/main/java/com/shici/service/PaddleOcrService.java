package com.shici.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.awt.image.ColorConvertOp;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

@Service
public class PaddleOcrService {

    @Value("${paddleocr.url:http://127.0.0.1:8868/ocr}")
    private String paddleOcrUrl;

    private static final int MAX_WIDTH = 2048;
    private static final int MAX_HEIGHT = 2048;
    private static final float JPEG_QUALITY = 0.95f;

    public String recognize(MultipartFile image) throws Exception {
        if (image == null || image.isEmpty()) {
            return "";
        }

        byte[] imageBytes = preprocessImage(image);
        String base64 = Base64.getEncoder().encodeToString(imageBytes);
        String json = "{\"imageBase64\":\"" + base64 + "\"}";

        HttpURLConnection conn = null;
        try {
            conn = (HttpURLConnection) new URL(paddleOcrUrl).openConnection();
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(30000);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(json.getBytes(StandardCharsets.UTF_8));
            }

            int code = conn.getResponseCode();
            InputStream responseStream = (code >= 200 && code < 300)
                    ? conn.getInputStream()
                    : conn.getErrorStream();

            String body = responseStream == null
                    ? ""
                    : new String(responseStream.readAllBytes(), StandardCharsets.UTF_8);

            if (code < 200 || code >= 300) {
                throw new RuntimeException("PaddleOCR 请求失败，HTTP " + code + "，响应：" + body);
            }

            return extractText(body);
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    private String extractText(String body) {
        if (body == null || body.isBlank()) {
            return "";
        }

        int idx = body.indexOf("\"text\":");
        if (idx < 0) {
            return "";
        }

        String value = body.substring(idx + 7).trim();

        if (value.startsWith("\"")) {
            value = value.substring(1);
        }

        int endQuote = value.indexOf("\",");
        if (endQuote >= 0) {
            value = value.substring(0, endQuote);
        } else {
            if (value.endsWith("}")) {
                value = value.substring(0, value.length() - 1);
            }
            if (value.endsWith("\"")) {
                value = value.substring(0, value.length() - 1);
            }
        }

        return value.replace("\\n", "\n")
                .replace("\\\"", "\"")
                .trim();
    }

    /**
     * OCR 专用图片预处理：灰度化 + 对比度增强 + 合适分辨率
     */
    private byte[] preprocessImage(MultipartFile file) throws Exception {
        BufferedImage original = ImageIO.read(file.getInputStream());
        if (original == null) {
            return file.getBytes();
        }

        int width = original.getWidth();
        int height = original.getHeight();

        // 小图放大，大图缩小到合适尺寸
        double scale = Math.min(
                1.0,
                Math.min((double) MAX_WIDTH / width, (double) MAX_HEIGHT / height)
        );

        // 如果图片太小（文字区域可能太小），放大到至少 800px 宽
        if (width < 800 && height < 800) {
            double minScale = 800.0 / Math.min(width, height);
            scale = Math.max(scale, minScale);
        }

        int targetWidth = Math.max(1, (int) Math.round(width * scale));
        int targetHeight = Math.max(1, (int) Math.round(height * scale));

        // 先缩放到目标尺寸
        BufferedImage resized = new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = resized.createGraphics();
        try {
            g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
            g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_OFF);
            g2d.drawImage(original, 0, 0, targetWidth, targetHeight, null);
        } finally {
            g2d.dispose();
        }

        // 转为灰度图（大幅提升 OCR 准确率）
        BufferedImage gray = new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_BYTE_GRAY);
        ColorConvertOp op = new ColorConvertOp(null);
        op.filter(resized, gray);

        // 对比度增强
        BufferedImage enhanced = enhanceContrast(gray);

        // 输出为 PNG（无损，避免 JPEG 伪影影响小字识别）
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(enhanced, "png", baos);
        return baos.toByteArray();
    }

    /**
     * 对比度增强：让文字更突出
     */
    private BufferedImage enhanceContrast(BufferedImage source) {
        int width = source.getWidth();
        int height = source.getHeight();

        // 计算直方图
        int[] histogram = new int[256];
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int gray = source.getRaster().getSample(x, y, 0);
                histogram[gray]++;
            }
        }

        // 找最小/最大灰度（忽略边缘 1% 像素）
        int ignore = (width * height) / 100;
        int sum = 0;
        int minGray = 0;
        for (int i = 0; i < 256; i++) {
            sum += histogram[i];
            if (sum > ignore) {
                minGray = i;
                break;
            }
        }
        sum = 0;
        int maxGray = 255;
        for (int i = 255; i >= 0; i--) {
            sum += histogram[i];
            if (sum > ignore) {
                maxGray = i;
                break;
            }
        }

        // 线性拉伸到 0-255
        int range = maxGray - minGray;
        if (range < 10) {
            return source; // 对比度已经足够
        }

        BufferedImage result = new BufferedImage(width, height, BufferedImage.TYPE_BYTE_GRAY);
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int gray = source.getRaster().getSample(x, y, 0);
                int stretched = ((gray - minGray) * 255) / range;
                stretched = Math.max(0, Math.min(255, stretched));
                result.getRaster().setSample(x, y, 0, stretched);
            }
        }
        return result;
    }
}