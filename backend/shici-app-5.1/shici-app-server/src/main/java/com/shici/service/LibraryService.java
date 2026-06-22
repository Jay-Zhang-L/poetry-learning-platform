package com.shici.service;

import com.shici.domain.Author;
import com.shici.domain.dto.PageResp;
import com.shici.domain.dto.PoemCardDto;
import com.shici.domain.dto.TopicDto;
import com.shici.mapper.AuthorMapper;
import com.shici.mapper.PoemMapper;
import com.shici.mapper.TopicMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LibraryService {

    private final TopicMapper topicMapper;
    private final PoemMapper poemMapper;
    private final AuthorMapper authorMapper;

    // 只保留一个构造器，Spring 会用它来注入
    public LibraryService(TopicMapper topicMapper, PoemMapper poemMapper, AuthorMapper authorMapper) {
        this.topicMapper = topicMapper;
        this.poemMapper = poemMapper;
        this.authorMapper = authorMapper;
    }

    // 专题
    public List<TopicDto> listTopics() {
        return topicMapper.listTopics();
    }

    // 诗词列表分页（扩展分类版本）
    public PageResp<PoemCardDto> pagePoems(String q,
                                           String dynasty,
                                           String genre,
                                           String theme,
                                           String season,
                                           String emotion,
                                           String scenery,
                                           String festival,
                                           String historicalPeriod,
                                           String poeticForm,
                                           String rhetoricalDevice,
                                           String famousLineType,
                                           String sort,
                                           int page,
                                           int size) {

        if (page < 1) page = 1;
        if (size < 1) size = 10;
        if (size > 50) size = 50;

        String orderBy = (sort == null || sort.isBlank()) ? "hot" : sort;
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

        long total = poemMapper.count(q, dyn, gen, thm, ssn, emo, sce, fes, his, poe, rhe, fam);
        List<PoemCardDto> list = poemMapper.page(q, dyn, gen, thm, ssn, emo, sce, fes, his, poe, rhe, fam, orderBy, offset, size);

        // 补充作者信息：头像、简介（如果 author 表里有）
        for (PoemCardDto dto : list) {
            String name = dto.getAuthor();
            if (name == null || name.isBlank()) continue;

            Author a = authorMapper.findByName(name);
            if (a != null) {
                dto.setAuthorAvatar(a.getAvatarUrl());
                dto.setAuthorIntro(a.getIntro());
            }
        }

        return PageResp.of(total, page, size, list);
    }
}