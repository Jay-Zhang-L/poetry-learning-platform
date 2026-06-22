package com.shici.service;

import com.shici.domain.dto.PageResp;
import com.shici.domain.dto.PoemCardDto;
import com.shici.mapper.PoemMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.*;
import java.util.stream.Collectors;
import java.util.List;
import java.util.Map;

@Service
public class PoemService {

    private final PoemMapper poemMapper;

    public PoemService(PoemMapper poemMapper) {
        this.poemMapper = poemMapper;
    }

    // 获取当前用户ID（暂时写死，后续从token获取）
    private Long getCurrentUserId() {
        // TODO: 从session/token获取当前登录用户ID
        return 1L;  // 测试用
    }

    public PageResp<PoemCardDto> page(String kw, String dynasty, String genre, String theme,
                                      String season, String emotion, String scenery,
                                      String festival, String historicalPeriod,
                                      String poeticForm, String rhetoricalDevice,
                                      String famousLineType,
                                      String sortKey, int page, int size) {
        if (page < 1) page = 1;
        if (size < 1) size = 10;
        if (size > 50) size = 50;

        String orderBy = (sortKey == null || sortKey.isBlank()) ? "hot" : sortKey;
        int offset = (page - 1) * size;

        // 处理"全部"参数，转换为null
        String dyn = (dynasty == null || "全部".equals(dynasty)) ? null : dynasty;
        String gen = (genre == null || "全部".equals(genre)) ? null : genre;
        String thm = (theme == null || "全部".equals(theme)) ? null : theme;
        String ssn = (season == null || "全部".equals(season)) ? null : season;
        String emo = (emotion == null || "全部".equals(emotion)) ? null : emotion;
        String sce = (scenery == null || "全部".equals(scenery)) ? null : scenery;
        String fes = (festival == null || "全部".equals(festival)) ? null : festival;
        String his = (historicalPeriod == null || "全部".equals(historicalPeriod)) ? null : historicalPeriod;
        String poe = (poeticForm == null || "全部".equals(poeticForm)) ? null : poeticForm;
        String rhe = (rhetoricalDevice == null || "全部".equals(rhetoricalDevice)) ? null : rhetoricalDevice;
        String fam = (famousLineType == null || "全部".equals(famousLineType)) ? null : famousLineType;

        long total = poemMapper.count(kw, dyn, gen, thm, ssn, emo, sce, fes, his, poe, rhe, fam);
        List<PoemCardDto> items = poemMapper.page(kw, dyn, gen, thm, ssn, emo, sce, fes, his, poe, rhe, fam, orderBy, offset, size);

        // 批量查询收藏状态
        Long userId = getCurrentUserId();
        if (items != null && !items.isEmpty() && userId != null && userId > 0) {
            List<Long> poemIds = items.stream().map(PoemCardDto::getId).collect(Collectors.toList());
            List<Long> favIds = poemMapper.getUserFavIds(userId, poemIds);
            Set<Long> favSet = new HashSet<>(favIds);
            for (PoemCardDto it : items) {
                it.setFav(favSet.contains(it.getId()));
                normalize(it);
            }
        } else if (items != null) {
            for (PoemCardDto it : items) {
                it.setFav(false);
                normalize(it);
            }
        }

        return PageResp.of(total, page, size, items);
    }

    public PoemCardDto detail(Long id) {
        PoemCardDto it = poemMapper.findById(id);
        if (it == null) return null;

        Long userId = getCurrentUserId();
        if (userId != null && userId > 0) {
            it.setFav(poemMapper.existsFav(userId, id) > 0);
        } else {
            it.setFav(false);
        }

        normalize(it);
        return it;
    }

    // ==================== 收藏功能 ====================

    @Transactional
    public void addFavorite(Long poemId) {
        Long userId = getCurrentUserId();
        if (userId == null || userId <= 0) {
            throw new RuntimeException("请先登录");
        }
        PoemCardDto poem = poemMapper.findById(poemId);
        if (poem == null) {
            throw new RuntimeException("诗词不存在");
        }
        if (poemMapper.existsFav(userId, poemId) == 0) {
            poemMapper.insertFav(userId, poemId);
        }
    }

    @Transactional
    public void removeFavorite(Long poemId) {
        Long userId = getCurrentUserId();
        if (userId != null && userId > 0) {
            poemMapper.deleteFav(userId, poemId);
        }
    }

    public boolean isFavorited(Long poemId) {
        Long userId = getCurrentUserId();
        return userId != null && userId > 0 && poemMapper.existsFav(userId, poemId) > 0;
    }

    public PageResp<PoemCardDto> getUserFavorites(int pageNum, int pageSize) {
        if (pageNum < 1) pageNum = 1;
        if (pageSize < 1) pageSize = 12;
        if (pageSize > 50) pageSize = 50;

        Long userId = getCurrentUserId();
        if (userId == null || userId <= 0) {
            return PageResp.of(0, pageNum, pageSize, Collections.emptyList());
        }

        int offset = (pageNum - 1) * pageSize;
        long total = poemMapper.countUserFav(userId);
        List<PoemCardDto> items = poemMapper.getUserFavList(userId, offset, pageSize);

        if (items != null) {
            for (PoemCardDto it : items) {
                it.setFav(true);
                normalize(it);
            }
        }

        return PageResp.of(total, pageNum, pageSize, items);
    }

    private void normalize(PoemCardDto it) {
        it.setFav(Boolean.TRUE.equals(it.getFav()));
        it.setTagsStr(normalizeTagsStr(it.getTagsStr()));

        if (!StringUtils.hasText(it.getTranslation())) {
            it.setTranslation("");
        }
        if (!StringUtils.hasText(it.getAnalysis())) {
            it.setAnalysis("");
        }
        if (!StringUtils.hasText(it.getContent())) {
            it.setContent("");
        }
        if (!StringUtils.hasText(it.getCoverUrl())) {
            it.setCoverUrl("");
        }
        if (!StringUtils.hasText(it.getAudioUrl())) {
            it.setAudioUrl("");
        }
    }

    private String normalizeTagsStr(String tagsStr) {
        if (!StringUtils.hasText(tagsStr)) return null;
        String s = tagsStr.replace('，', ',').trim();
        s = s.replaceAll("\\s*,\\s*", ",");
        s = s.replaceAll(",{2,}", ",");
        if (s.startsWith(",")) s = s.substring(1);
        if (s.endsWith(",")) s = s.substring(0, s.length() - 1);
        return s.isEmpty() ? null : s;
    }
    public List<Map<String, Object>> getAuthors(String dynasty, String genre, String theme,
                                                String season, String emotion, String scenery,
                                                String festival, String historicalPeriod,
                                                String poeticForm, String rhetoricalDevice) {
        String dyn = (dynasty == null || "全部".equals(dynasty)) ? null : dynasty;
        String gen = (genre == null || "全部".equals(genre)) ? null : genre;
        String thm = (theme == null || "全部".equals(theme)) ? null : theme;
        String ssn = (season == null || "全部".equals(season)) ? null : season;
        String emo = (emotion == null || "全部".equals(emotion)) ? null : emotion;
        String sce = (scenery == null || "全部".equals(scenery)) ? null : scenery;
        String fes = (festival == null || "全部".equals(festival)) ? null : festival;
        String his = (historicalPeriod == null || "全部".equals(historicalPeriod)) ? null : historicalPeriod;
        String poe = (poeticForm == null || "全部".equals(poeticForm)) ? null : poeticForm;
        String rhe = (rhetoricalDevice == null || "全部".equals(rhetoricalDevice)) ? null : rhetoricalDevice;

        return poemMapper.getAuthors(dyn, gen, thm, ssn, emo, sce, fes, his, poe, rhe);
    }
}