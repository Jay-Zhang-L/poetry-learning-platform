package com.shici.controller;

import com.shici.common.R;
import com.shici.service.SeasonService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/season")
public class SeasonController {

    private final SeasonService seasonService;

    public SeasonController(SeasonService seasonService) {
        this.seasonService = seasonService;
    }

    @GetMapping("/current")
    public R<?> current() {
        return R.ok(seasonService.current());
    }

    @GetMapping("/{id}")
    public R<?> get(@PathVariable("id") Long id) {
        return R.ok(seasonService.get(id));
    }

    @GetMapping("/{id}/rank")
    public R<?> rank(@PathVariable("id") Long id,
                     @RequestParam(value = "top", required = false) Integer top) {
        return R.ok(seasonService.rank(id, top));
    }
}
