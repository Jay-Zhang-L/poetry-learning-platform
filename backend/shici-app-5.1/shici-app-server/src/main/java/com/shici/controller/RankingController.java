package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.RankingItem;
import com.shici.service.RankingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/ranking")
public class RankingController {

    @Autowired
    private RankingService rankingService;

    @GetMapping("/48h")
    public R<List<RankingItem>> getRanking48h() {
        List<RankingItem> list = rankingService.getRanking48h();
        return R.ok(list);
    }

    @GetMapping("/10d")
    public R<List<RankingItem>> getRanking10d() {
        List<RankingItem> list = rankingService.getRanking10d();
        return R.ok(list);
    }

    @GetMapping("/hot15d")
    public R<List<RankingItem>> getHot15d() {
        List<RankingItem> list = rankingService.getHot15d();
        return R.ok(list);
    }

    @GetMapping("/editor")
    public R<List<RankingItem>> getEditorPick() {
        List<RankingItem> list = rankingService.getEditorPick();
        return R.ok(list);
    }
}