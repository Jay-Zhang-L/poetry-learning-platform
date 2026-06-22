package com.shici.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.InputStream;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class QwenVisionService {

    private static final int SAMPLE_STEP = 6;

    private final PaddleOcrService paddleOcrService;

    public Map<String, Object> analyzeScene(MultipartFile image) {
        try {
            String ocrText = safeRecognizeText(image);
            BufferedImage img = safeReadImage(image);

            ScoreBucket bucket = new ScoreBucket();

            if (!ocrText.isBlank()) {
                applyOcrRules(ocrText, bucket);
            }

            if (img != null) {
                ImageStats stats = analyzeImageStats(img);
                applyImageRules(stats, bucket);
            }

            bucket.ensureDefault();
            return buildResult(bucket, ocrText);

        } catch (Exception e) {
            e.printStackTrace();
            return defaultResult();
        }
    }

    private String safeRecognizeText(MultipartFile image) {
        try {
            String text = paddleOcrService.recognize(image);
            return normalizeText(text);
        } catch (Exception e) {
            return "";
        }
    }

    private BufferedImage safeReadImage(MultipartFile image) {
        try (InputStream is = image.getInputStream()) {
            return ImageIO.read(is);
        } catch (Exception e) {
            return null;
        }
    }

    private String normalizeText(String text) {
        if (text == null) return "";
        return text.replaceAll("\\s+", "")
                .replace("，", "")
                .replace("。", "")
                .replace("：", "")
                .replace("；", "")
                .replace("、", "")
                .replace(",", "")
                .replace(".", "")
                .trim();
    }

    private void applyOcrRules(String text, ScoreBucket bucket) {
        // 主题
        hit(text, bucket::addTheme, 28, "山水", "山", "水", "江", "河", "湖", "溪", "泉", "峰", "岭");
        hit(text, bucket::addTheme, 30, "思乡", "乡", "故乡", "归乡", "还乡", "家书", "乡愁");
        hit(text, bucket::addTheme, 28, "边塞", "边塞", "玉门关", "黄沙", "胡", "塞", "烽火", "战");
        hit(text, bucket::addTheme, 26, "田园", "田园", "农家", "柴门", "村居", "篱落", "桑麻");
        hit(text, bucket::addTheme, 24, "友情", "送别", "故人", "友人", "君", "相送");
        hit(text, bucket::addTheme, 22, "励志", "壮志", "凌云", "报国", "立功", "志");
        hit(text, bucket::addTheme, 20, "节令", "节", "岁暮", "新岁", "佳节");

        // 季节
        hit(text, bucket::addSeason, 30, "春", "春", "春风", "春雨", "芳草", "新绿", "桃花", "柳");
        hit(text, bucket::addSeason, 28, "夏", "夏", "荷", "蝉", "炎", "暑", "盛夏");
        hit(text, bucket::addSeason, 30, "秋", "秋", "秋风", "秋月", "落叶", "寒蝉", "重阳");
        hit(text, bucket::addSeason, 32, "冬", "冬", "雪", "寒", "霜", "冰", "岁寒");

        // 情感
        hit(text, bucket::addEmotion, 30, "思念", "相思", "思君", "思归", "怀人", "念", "忆");
        hit(text, bucket::addEmotion, 28, "闲适", "闲", "静", "幽", "归隐", "自适", "清闲");
        hit(text, bucket::addEmotion, 28, "豪迈", "壮", "豪", "雄", "报国", "凌云", "丈夫");
        hit(text, bucket::addEmotion, 30, "惜别", "离别", "送别", "别君", "长亭", "折柳");
        hit(text, bucket::addEmotion, 28, "愁思", "愁", "悲", "怨", "泪", "伤", "恨");
        hit(text, bucket::addEmotion, 26, "孤寂", "孤", "独", "寂", "冷", "空", "清寒");
        hit(text, bucket::addEmotion, 24, "欢快", "喜", "乐", "笑", "新晴", "春游");
        hit(text, bucket::addEmotion, 24, "坚韧", "坚", "韧", "不屈", "凌寒", "傲霜");
        hit(text, bucket::addEmotion, 22, "喜庆", "喜庆", "良辰", "团圆", "华灯");
        hit(text, bucket::addEmotion, 22, "哲理", "人生", "世事", "兴亡", "道", "理");
        hit(text, bucket::addEmotion, 20, "感恩", "恩", "谢", "报答", "不忘");

        // 景物
        hit(text, bucket::addScene, 30, "月夜", "月", "明月", "月下", "夜", "子夜", "月明");
        hit(text, bucket::addScene, 28, "花鸟", "花", "鸟", "燕", "莺", "蝶", "鹤");
        hit(text, bucket::addScene, 30, "山水", "山", "江", "河", "湖", "溪", "舟", "渔");
        hit(text, bucket::addScene, 26, "江海", "海", "潮", "涛", "沧海", "长江");
        hit(text, bucket::addScene, 24, "草木", "柳", "竹", "松", "梅", "菊", "荷", "兰");
        hit(text, bucket::addScene, 28, "雪", "雪", "冰", "霜", "寒江");
        hit(text, bucket::addScene, 24, "雨夜", "雨", "夜雨", "潇潇", "听雨");
        hit(text, bucket::addScene, 24, "花", "花", "梅花", "桃花", "菊花", "荷花");
        hit(text, bucket::addScene, 22, "湖", "湖", "西湖", "洞庭");
        hit(text, bucket::addScene, 22, "江", "江", "江水", "江边", "寒江");
        hit(text, bucket::addScene, 22, "城", "城", "城楼", "长安", "洛阳", "宫阙");

        // 节日
        hit(text, bucket::addFestival, 32, "春节", "春节", "新春", "元日", "爆竹", "岁首");
        hit(text, bucket::addFestival, 32, "元宵", "元宵", "花灯", "上元", "灯市");
        hit(text, bucket::addFestival, 30, "中秋", "中秋", "团圆", "月圆");
        hit(text, bucket::addFestival, 30, "重阳", "重阳", "登高", "茱萸");
        hit(text, bucket::addFestival, 28, "端午", "端午", "龙舟", "粽");

        // 历史时期
        hit(text, bucket::addPeriod, 18, "初唐", "初唐");
        hit(text, bucket::addPeriod, 20, "盛唐", "盛唐");
        hit(text, bucket::addPeriod, 18, "中唐", "中唐");
        hit(text, bucket::addPeriod, 18, "晚唐", "晚唐");
        hit(text, bucket::addPeriod, 18, "北宋", "北宋");
        hit(text, bucket::addPeriod, 18, "南宋", "南宋");

        // 体裁
        hit(text, bucket::addForm, 20, "诗", "诗");
        hit(text, bucket::addForm, 20, "词", "词");
        hit(text, bucket::addForm, 18, "曲", "曲");
        hit(text, bucket::addForm, 18, "文言", "赋", "序", "记", "文");

        // 诗体
        hit(text, bucket::addPoemType, 22, "五绝", "五绝");
        hit(text, bucket::addPoemType, 22, "七绝", "七绝");
        hit(text, bucket::addPoemType, 22, "五律", "五律");
        hit(text, bucket::addPoemType, 22, "七律", "七律");
        hit(text, bucket::addPoemType, 18, "乐府", "乐府");
        hit(text, bucket::addPoemType, 18, "古风", "古风");

        // 修辞手法
        hit(text, bucket::addRhetoric, 18, "比喻", "如", "似", "若");
        hit(text, bucket::addRhetoric, 18, "拟人", "啼", "语", "愁", "笑");
        hit(text, bucket::addRhetoric, 16, "夸张", "万里", "千丈", "九天");
        hit(text, bucket::addRhetoric, 18, "对偶", "对", "并", "两句相承");
        hit(text, bucket::addRhetoric, 18, "排比", "一连串并列");
        hit(text, bucket::addRhetoric, 16, "设问", "何", "谁", "安得", "何处");

        // 名句类型
        hit(text, bucket::addFamousType, 28, "写景", "山", "水", "月", "花", "雪", "风");
        hit(text, bucket::addFamousType, 26, "抒情", "思", "愁", "怨", "喜", "悲");
        hit(text, bucket::addFamousType, 24, "哲理", "人生", "世事", "道", "理");
        hit(text, bucket::addFamousType, 22, "送别", "送", "别", "长亭", "故人");
        hit(text, bucket::addFamousType, 22, "咏物", "梅", "兰", "竹", "菊", "松", "柳");

        // 朝代倾向
        hit(text, bucket::addDynasty, 18, "唐", "唐");
        hit(text, bucket::addDynasty, 18, "宋", "宋");
        hit(text, bucket::addDynasty, 14, "元", "元");
        hit(text, bucket::addDynasty, 12, "明", "明");
        hit(text, bucket::addDynasty, 12, "清", "清");

        // 核心意象
        hit(text, bucket::addTag, 34, "相思", "相思", "红豆");
        hit(text, bucket::addTag, 30, "月夜", "月", "夜");
        hit(text, bucket::addTag, 30, "白雪", "雪", "霜", "冰");
        hit(text, bucket::addTag, 28, "寒江", "寒江", "江雪");
        hit(text, bucket::addTag, 26, "孤舟", "孤舟", "渔舟", "小舟");
        hit(text, bucket::addTag, 26, "柳色", "柳", "折柳");
        hit(text, bucket::addTag, 26, "梅花", "梅", "梅花");
        hit(text, bucket::addTag, 24, "远山", "远山", "青山", "峰");
        hit(text, bucket::addTag, 24, "田园", "田园", "村居", "桑麻");
        hit(text, bucket::addTag, 24, "灯火", "灯", "灯火", "上元");
    }

    private void hit(String text, BiAdder adder, int baseScore, String label, String... words) {
        int hitCount = 0;
        for (String word : words) {
            if (text.contains(word)) {
                hitCount++;
            }
        }
        if (hitCount > 0) {
            adder.add(label, baseScore + (hitCount - 1) * 6);
        }
    }

    private ImageStats analyzeImageStats(BufferedImage img) {
        int width = img.getWidth();
        int height = img.getHeight();

        long totalR = 0, totalG = 0, totalB = 0, totalBrightness = 0;
        int count = 0;

        int whiteCount = 0;
        int blackCount = 0;
        int redCount = 0;
        int greenCount = 0;
        int blueCount = 0;
        int grayCount = 0;
        int skinLikeCount = 0;
        int warmCount = 0;
        int coldCount = 0;

        for (int x = 0; x < width; x += SAMPLE_STEP) {
            for (int y = 0; y < height; y += SAMPLE_STEP) {
                int rgb = img.getRGB(x, y);

                int r = (rgb >> 16) & 0xff;
                int g = (rgb >> 8) & 0xff;
                int b = rgb & 0xff;
                int brightness = (r + g + b) / 3;

                totalR += r;
                totalG += g;
                totalB += b;
                totalBrightness += brightness;
                count++;

                if (r > 215 && g > 215 && b > 215) whiteCount++;
                if (brightness < 45) blackCount++;
                if (r > 150 && g < 110 && b < 110) redCount++;
                if (g > 120 && g > r + 10 && g > b + 10) greenCount++;
                if (b > 120 && b > r + 10 && b > g + 5) blueCount++;
                if (Math.abs(r - g) < 18 && Math.abs(g - b) < 18 && brightness > 120) grayCount++;
                if (r > 150 && g > 110 && b > 90 && r > g && g > b) skinLikeCount++;
                if (r > g + 12 && r > b + 20) warmCount++;
                if (b > r + 12 || (b > 110 && g > 100)) coldCount++;
            }
        }

        ImageStats s = new ImageStats();
        s.avgR = safeDiv(totalR, count);
        s.avgG = safeDiv(totalG, count);
        s.avgB = safeDiv(totalB, count);
        s.avgBrightness = safeDiv(totalBrightness, count);
        s.count = count;
        s.whiteRatio = ratio(whiteCount, count);
        s.blackRatio = ratio(blackCount, count);
        s.redRatio = ratio(redCount, count);
        s.greenRatio = ratio(greenCount, count);
        s.blueRatio = ratio(blueCount, count);
        s.grayRatio = ratio(grayCount, count);
        s.skinRatio = ratio(skinLikeCount, count);
        s.warmRatio = ratio(warmCount, count);
        s.coldRatio = ratio(coldCount, count);
        return s;
    }

    private void applyImageRules(ImageStats s, ScoreBucket bucket) {
        // 相思 / 红豆 / 人物
        if (s.redRatio > 0.025 && s.skinRatio > 0.012) {
            bucket.addTag("相思", 24);
            bucket.addTag("红豆", 22);
            bucket.addEmotion("思念", 20);
            bucket.addEmotion("愁思", 8);
            bucket.addScene("花", 8);
            bucket.addFamousType("抒情", 16);
            bucket.addRhetoric("比喻", 6);
            bucket.addDynasty("唐", 4);
        }

        // 夜景
        if (s.avgBrightness < 78 || (s.blackRatio > 0.28 && s.coldRatio > 0.22)) {
            bucket.addTag("月夜", 20);
            bucket.addTag("灯火", 16);
            bucket.addTheme("思乡", 10);
            bucket.addEmotion("思念", 10);
            bucket.addEmotion("孤寂", 12);
            bucket.addScene("月夜", 20);
            bucket.addScene("城", 8);
            bucket.addFamousType("写景", 10);
            bucket.addFamousType("抒情", 10);
            bucket.addDynasty("唐", 4);
            bucket.addDynasty("宋", 4);
        }

        // 雪景 / 寒江
        if ((s.whiteRatio > 0.16 && s.coldRatio > 0.20)
                || (s.avgBrightness > 145 && s.blueRatio > 0.10 && s.grayRatio > 0.20)) {
            bucket.addTag("冬日", 22);
            bucket.addTag("白雪", 22);
            bucket.addTag("寒江", 18);
            bucket.addTag("孤舟", 16);
            bucket.addTheme("山水", 10);
            bucket.addSeason("冬", 28);
            bucket.addEmotion("孤寂", 12);
            bucket.addScene("雪", 24);
            bucket.addScene("江", 14);
            bucket.addScene("山水", 12);
            bucket.addFamousType("写景", 12);
            bucket.addFamousType("哲理", 4);
            bucket.addDynasty("唐", 6);
            bucket.addDynasty("宋", 4);
        }

        // 春景 / 草木 / 花鸟
        if (s.greenRatio > 0.18 && s.avgBrightness > 120) {
            bucket.addTag("春日", 22);
            bucket.addTag("花木", 16);
            bucket.addTag("柳色", 14);
            bucket.addTheme("田园", 10);
            bucket.addSeason("春", 28);
            bucket.addEmotion("欢快", 10);
            bucket.addEmotion("闲适", 10);
            bucket.addScene("草木", 20);
            bucket.addScene("花鸟", 16);
            bucket.addScene("花", 10);
            bucket.addFamousType("写景", 12);
            bucket.addFamousType("咏物", 8);
            bucket.addDynasty("唐", 4);
            bucket.addDynasty("宋", 4);
        }

        // 山水 / 江海
        if ((s.blueRatio > 0.14 && s.grayRatio > 0.15)
                || (s.coldRatio > 0.28 && s.avgBrightness > 95)) {
            bucket.addTag("山水", 20);
            bucket.addTag("江河", 16);
            bucket.addTag("远山", 14);
            bucket.addTheme("山水", 24);
            bucket.addEmotion("闲适", 10);
            bucket.addEmotion("豪迈", 6);
            bucket.addScene("山水", 22);
            bucket.addScene("江海", 12);
            bucket.addScene("江", 12);
            bucket.addScene("湖", 10);
            bucket.addFamousType("写景", 14);
            bucket.addDynasty("唐", 4);
            bucket.addDynasty("宋", 6);
        }

        // 田园 / 村居
        if (s.warmRatio > 0.18 && s.greenRatio > 0.08) {
            bucket.addTag("田园", 18);
            bucket.addTag("村居", 16);
            bucket.addTag("归隐", 14);
            bucket.addTheme("田园", 22);
            bucket.addEmotion("闲适", 16);
            bucket.addEmotion("欢快", 6);
            bucket.addScene("草木", 12);
            bucket.addScene("城", 4);
            bucket.addFamousType("写景", 10);
            bucket.addFamousType("抒情", 6);
            bucket.addDynasty("宋", 6);
            bucket.addDynasty("元", 4);
        }

        // 水墨 / 留白 / 空灵
        if (s.grayRatio > 0.32 && s.avgBrightness > 140) {
            bucket.addTag("空灵", 16);
            bucket.addTag("水墨", 16);
            bucket.addTag("清寂", 14);
            bucket.addEmotion("闲适", 8);
            bucket.addEmotion("孤寂", 8);
            bucket.addTheme("山水", 8);
            bucket.addScene("湖", 8);
            bucket.addFamousType("哲理", 6);
            bucket.addRhetoric("比喻", 4);
            bucket.addDynasty("宋", 4);
            bucket.addDynasty("元", 4);
        }

        // 偏暖、偏节庆
        if (s.redRatio > 0.05 && s.warmRatio > 0.20 && s.avgBrightness > 120) {
            bucket.addFestival("元宵", 10);
            bucket.addFestival("春节", 8);
            bucket.addEmotion("喜庆", 12);
            bucket.addFamousType("抒情", 4);
            bucket.addDynasty("宋", 4);
        }
    }

    private Map<String, Object> buildResult(ScoreBucket bucket, String ocrText) {
        List<String> tags = topKeys(bucket.tags, 8);
        List<String> themes = topKeys(bucket.themes, 5);
        List<String> seasons = topKeys(bucket.seasons, 4);
        List<String> emotions = topKeys(bucket.emotions, 5);
        List<String> scenes = topKeys(bucket.scenes, 6);
        List<String> festivals = topKeys(bucket.festivals, 4);
        List<String> periods = topKeys(bucket.periods, 4);
        List<String> forms = topKeys(bucket.forms, 3);
        List<String> poemTypes = topKeys(bucket.poemTypes, 4);
        List<String> rhetorics = topKeys(bucket.rhetorics, 5);
        List<String> famousTypes = topKeys(bucket.famousTypes, 5);
        List<String> dynasties = topKeys(bucket.dynasties, 4);

        String summary = buildSummary(tags, themes, seasons, emotions, scenes, festivals, dynasties, ocrText);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("tags", tags);
        result.put("themes", themes);
        result.put("seasons", seasons);
        result.put("emotions", emotions);
        result.put("scenes", scenes);
        result.put("festivals", festivals);
        result.put("periods", periods);
        result.put("forms", forms);
        result.put("poemTypes", poemTypes);
        result.put("rhetorics", rhetorics);
        result.put("famousTypes", famousTypes);
        result.put("dynasties", dynasties);
        result.put("summary", summary);
        result.put("ocrText", ocrText);
        return result;
    }

    private String buildSummary(List<String> tags,
                                List<String> themes,
                                List<String> seasons,
                                List<String> emotions,
                                List<String> scenes,
                                List<String> festivals,
                                List<String> dynasties,
                                String ocrText) {
        StringBuilder sb = new StringBuilder("画面意象");

        if (!tags.isEmpty()) {
            sb.append("偏向").append(String.join("、", tags));
        } else {
            sb.append("较为自然含蓄");
        }

        if (!themes.isEmpty()) {
            sb.append("，主题更接近").append(String.join("、", themes));
        }

        if (!scenes.isEmpty()) {
            sb.append("，景物倾向").append(String.join("、", scenes));
        }

        if (!seasons.isEmpty()) {
            sb.append("，季节气息偏向").append(String.join("、", seasons));
        }

        if (!emotions.isEmpty()) {
            sb.append("，情感基调接近").append(String.join("、", emotions));
        }

        if (!festivals.isEmpty()) {
            sb.append("，并带有").append(String.join("、", festivals)).append("相关节令联想");
        }

        if (!dynasties.isEmpty()) {
            sb.append("，朝代风格可优先参考").append(String.join("、", dynasties));
        }

        if (ocrText != null && !ocrText.isBlank()) {
            sb.append("。图中文字识别为“").append(limitText(ocrText, 24)).append("”");
        }

        return sb.toString();
    }

    private String limitText(String text, int maxLen) {
        if (text == null) return "";
        return text.length() <= maxLen ? text : text.substring(0, maxLen) + "...";
    }

    private List<String> topKeys(Map<String, Integer> map, int n) {
        return map.entrySet().stream()
                .sorted((a, b) -> Integer.compare(b.getValue(), a.getValue()))
                .limit(n)
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());
    }

    private int safeDiv(long a, int b) {
        if (b <= 0) return 0;
        return (int) (a / b);
    }

    private double ratio(int n, int total) {
        if (total <= 0) return 0D;
        return (double) n / total;
    }

    private Map<String, Object> defaultResult() {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("tags", List.of("自然", "清景"));
        result.put("themes", List.of("山水"));
        result.put("seasons", List.of());
        result.put("emotions", List.of("闲适"));
        result.put("scenes", List.of("山水"));
        result.put("festivals", List.of());
        result.put("periods", List.of());
        result.put("forms", List.of("诗"));
        result.put("poemTypes", List.of());
        result.put("rhetorics", List.of("比喻"));
        result.put("famousTypes", List.of("写景"));
        result.put("dynasties", List.of("唐", "宋"));
        result.put("summary", "画面整体偏自然清景，可优先从山水、田园、写景类诗词中匹配");
        result.put("ocrText", "");
        return result;
    }

    private interface BiAdder {
        void add(String key, int score);
    }

    private static class ImageStats {
        int avgR;
        int avgG;
        int avgB;
        int avgBrightness;
        int count;

        double whiteRatio;
        double blackRatio;
        double redRatio;
        double greenRatio;
        double blueRatio;
        double grayRatio;
        double skinRatio;
        double warmRatio;
        double coldRatio;
    }

    private static class ScoreBucket {
        Map<String, Integer> tags = new LinkedHashMap<>();
        Map<String, Integer> themes = new LinkedHashMap<>();
        Map<String, Integer> seasons = new LinkedHashMap<>();
        Map<String, Integer> emotions = new LinkedHashMap<>();
        Map<String, Integer> scenes = new LinkedHashMap<>();
        Map<String, Integer> festivals = new LinkedHashMap<>();
        Map<String, Integer> periods = new LinkedHashMap<>();
        Map<String, Integer> forms = new LinkedHashMap<>();
        Map<String, Integer> poemTypes = new LinkedHashMap<>();
        Map<String, Integer> rhetorics = new LinkedHashMap<>();
        Map<String, Integer> famousTypes = new LinkedHashMap<>();
        Map<String, Integer> dynasties = new LinkedHashMap<>();

        void addTag(String key, int score) { add(tags, key, score); }
        void addTheme(String key, int score) { add(themes, key, score); }
        void addSeason(String key, int score) { add(seasons, key, score); }
        void addEmotion(String key, int score) { add(emotions, key, score); }
        void addScene(String key, int score) { add(scenes, key, score); }
        void addFestival(String key, int score) { add(festivals, key, score); }
        void addPeriod(String key, int score) { add(periods, key, score); }
        void addForm(String key, int score) { add(forms, key, score); }
        void addPoemType(String key, int score) { add(poemTypes, key, score); }
        void addRhetoric(String key, int score) { add(rhetorics, key, score); }
        void addFamousType(String key, int score) { add(famousTypes, key, score); }
        void addDynasty(String key, int score) { add(dynasties, key, score); }

        private void add(Map<String, Integer> map, String key, int score) {
            map.put(key, map.getOrDefault(key, 0) + score);
        }

        void ensureDefault() {
            if (tags.isEmpty()) addTag("自然", 10);
            if (themes.isEmpty()) addTheme("山水", 8);
            if (emotions.isEmpty()) addEmotion("闲适", 8);
            if (scenes.isEmpty()) addScene("山水", 8);
            if (forms.isEmpty()) addForm("诗", 6);
            if (famousTypes.isEmpty()) addFamousType("写景", 8);
            if (dynasties.isEmpty()) {
                addDynasty("唐", 6);
                addDynasty("宋", 6);
            }
        }
    }
}