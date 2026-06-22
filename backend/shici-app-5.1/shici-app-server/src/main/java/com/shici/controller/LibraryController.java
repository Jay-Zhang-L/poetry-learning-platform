package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.dto.PageResp;
import com.shici.domain.dto.PoemCardDto;
import com.shici.domain.dto.TopicDto;
import com.shici.service.LibraryService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/library")
@CrossOrigin // 联调阶段先放开，后面可按域名收紧
public class LibraryController {

    private final LibraryService libraryService;

    public LibraryController(LibraryService libraryService) {
        this.libraryService = libraryService;
    }

    // 专题推荐
    @GetMapping("/topics")
    public R<List<TopicDto>> topics() {
        return R.ok(libraryService.listTopics());
    }

    /**
     * 列表 + 筛选 + 搜索 + 排序 + 分页（支持扩展分类）
     *
     * 兼容前端参数（你现在的 library.vue）：
     * - pageNum / pageSize
     * - kw
     * - sortKey
     *
     * 也兼容旧参数：
     * - page / size
     * - q
     * - sort
     */
    @GetMapping("/poems")
    public R<PageResp<PoemCardDto>> poems(
            // 搜索关键字：兼容 q / kw
            @RequestParam(value = "q", required = false) String q,
            @RequestParam(value = "kw", required = false) String kw,

            // 基础筛选
            @RequestParam(value = "dynasty", required = false) String dynasty,
            @RequestParam(value = "genre", required = false) String genre,
            @RequestParam(value = "theme", required = false) String theme,

            // 扩展分类筛选
            @RequestParam(value = "season", required = false) String season,
            @RequestParam(value = "emotion", required = false) String emotion,
            @RequestParam(value = "scenery", required = false) String scenery,
            @RequestParam(value = "festival", required = false) String festival,
            @RequestParam(value = "historicalPeriod", required = false) String historicalPeriod,
            @RequestParam(value = "poeticForm", required = false) String poeticForm,
            @RequestParam(value = "rhetoricalDevice", required = false) String rhetoricalDevice,
            @RequestParam(value = "famousLineType", required = false) String famousLineType,

            // 排序：兼容 sort / sortKey
            @RequestParam(value = "sort", defaultValue = "hot") String sort,
            @RequestParam(value = "sortKey", required = false) String sortKey,

            // 分页：兼容 page/size 以及 pageNum/pageSize
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            @RequestParam(value = "pageNum", required = false) Integer pageNum,
            @RequestParam(value = "pageSize", required = false) Integer pageSize
    ) {
        // 优先用 pageNum/pageSize（你的前端正在发这个）
        int p = (pageNum != null && pageNum > 0) ? pageNum : Math.max(page, 1);
        int s = (pageSize != null && pageSize > 0) ? pageSize : Math.max(size, 1);

        // 排序字段：优先用 sortKey
        String order = (sortKey != null && !sortKey.isBlank()) ? sortKey : sort;

        // 搜索关键字：优先用 kw
        String keyword = (kw != null && !kw.isBlank()) ? kw : q;

        // 处理默认值
        String dyn = (dynasty == null || dynasty.isBlank()) ? "全部" : dynasty;
        String gen = (genre == null || genre.isBlank()) ? "全部" : genre;
        String thm = (theme == null || theme.isBlank()) ? "全部" : theme;
        String ssn = (season == null || season.isBlank()) ? "全部" : season;
        String emo = (emotion == null || emotion.isBlank()) ? "全部" : emotion;
        String sce = (scenery == null || scenery.isBlank()) ? "全部" : scenery;
        String fes = (festival == null || festival.isBlank()) ? "全部" : festival;
        String his = (historicalPeriod == null || historicalPeriod.isBlank()) ? "全部" : historicalPeriod;
        String poe = (poeticForm == null || poeticForm.isBlank()) ? "全部" : poeticForm;
        String rhe = (rhetoricalDevice == null || rhetoricalDevice.isBlank()) ? "全部" : rhetoricalDevice;
        String fam = (famousLineType == null || famousLineType.isBlank()) ? "全部" : famousLineType;

        return R.ok(libraryService.pagePoems(keyword, dyn, gen, thm,
                ssn, emo, sce, fes, his, poe, rhe, fam, order, p, s));
    }
}