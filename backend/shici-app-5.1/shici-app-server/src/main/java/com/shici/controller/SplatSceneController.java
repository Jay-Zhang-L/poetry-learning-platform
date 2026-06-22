package com.shici.controller;

import com.shici.common.R;
import com.shici.domain.SplatScene;
import com.shici.service.SplatSceneService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/splat-scene")
public class SplatSceneController {

    private final SplatSceneService splatSceneService;

    public SplatSceneController(SplatSceneService splatSceneService) {
        this.splatSceneService = splatSceneService;
    }

    @GetMapping("/list")
    public R<List<SplatScene>> list(@RequestParam(value = "kw", required = false) String kw) {
        return R.ok(splatSceneService.search(kw));
    }

    @GetMapping("/detail")
    public R<SplatScene> detail(@RequestParam("id") Long id) {
        SplatScene data = splatSceneService.getById(id);
        if (data == null) {
            return R.fail("未找到诗境场景");
        }
        return R.ok(data);
    }
}