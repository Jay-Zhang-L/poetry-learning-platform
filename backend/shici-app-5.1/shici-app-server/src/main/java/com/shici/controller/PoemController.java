package com.shici.controller;

import com.shici.common.Result;
import com.shici.domain.dto.PageResp;
import com.shici.domain.dto.PoemCardDto;
import com.shici.service.PoemService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/poems")
@RequiredArgsConstructor
@Tag(name = "诗词管理", description = "诗词查询、收藏等接口")
public class PoemController {

    private final PoemService poemService;

    @GetMapping("/page")
    @Operation(summary = "分页查询诗词")
    public Result page(
            @RequestParam(required = false) String kw,
            @RequestParam(required = false) String dynasty,
            @RequestParam(required = false) String genre,
            @RequestParam(required = false) String theme,
            @RequestParam(required = false) String season,
            @RequestParam(required = false) String emotion,
            @RequestParam(required = false) String scenery,
            @RequestParam(required = false) String festival,
            @RequestParam(required = false) String historicalPeriod,
            @RequestParam(required = false) String poeticForm,
            @RequestParam(required = false) String rhetoricalDevice,
            @RequestParam(required = false) String famousLineType,
            @RequestParam(required = false) String sortKey,
            @RequestParam(required = false) Integer page,
            @RequestParam(required = false) Integer size,
            @RequestParam(required = false) Integer pageNum) {

        int finalPage = page != null ? page : (pageNum != null ? pageNum : 1);
        int finalSize = size != null ? size : 10;

        PageResp<PoemCardDto> result = poemService.page(
                kw, dynasty, genre, theme,
                season, emotion, scenery, festival, historicalPeriod,
                poeticForm, rhetoricalDevice, famousLineType,
                sortKey, finalPage, finalSize);

        return Result.success(result);
    }

    @GetMapping("/{id}")
    @Operation(summary = "获取诗词详情")
    public Result detail(@PathVariable Long id) {
        PoemCardDto poem = poemService.detail(id);
        if (poem == null) {
            return Result.error("诗词不存在");
        }
        return Result.success(poem);
    }

    // 收藏相关接口
    @PostMapping("/{id}/fav")
    @Operation(summary = "收藏诗词")
    public Result addFavorite(@PathVariable Long id) {
        try {
            poemService.addFavorite(id);
            return Result.success("收藏成功");
        } catch (Exception e) {
            log.error("收藏失败", e);
            return Result.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}/fav")
    @Operation(summary = "取消收藏")
    public Result removeFavorite(@PathVariable Long id) {
        poemService.removeFavorite(id);
        return Result.success("取消收藏成功");
    }

    @GetMapping("/{id}/fav/status")
    @Operation(summary = "检查收藏状态")
    public Result checkFavoriteStatus(@PathVariable Long id) {
        boolean isFav = poemService.isFavorited(id);
        return Result.success(isFav);
    }

    @GetMapping("/favorites")
    @Operation(summary = "获取我的收藏列表")
    public Result getFavorites(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "12") Integer pageSize) {
        PageResp<PoemCardDto> result = poemService.getUserFavorites(pageNum, pageSize);
        return Result.success(result);
    }
    @GetMapping("/authors")
    @Operation(summary = "获取作者列表（支持分类筛选）")
    public Result getAuthors(
            @RequestParam(required = false) String dynasty,
            @RequestParam(required = false) String genre,
            @RequestParam(required = false) String theme,
            @RequestParam(required = false) String season,
            @RequestParam(required = false) String emotion,
            @RequestParam(required = false) String scenery,
            @RequestParam(required = false) String festival,
            @RequestParam(required = false) String historicalPeriod,
            @RequestParam(required = false) String poeticForm,
            @RequestParam(required = false) String rhetoricalDevice) {
        List<Map<String, Object>> authors = poemService.getAuthors(
                dynasty, genre, theme, season, emotion, scenery,
                festival, historicalPeriod, poeticForm, rhetoricalDevice);
        return Result.success(authors);
    }

}