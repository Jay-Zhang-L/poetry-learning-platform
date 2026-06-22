package com.shici.controller;

import com.shici.common.R;
import com.shici.service.DictionaryService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/dictionary")
@RequiredArgsConstructor
public class DictionaryController {

    private final DictionaryService dictionaryService;

    @GetMapping("/home")
    public R home() {
        return R.ok(dictionaryService.getHomeData());
    }

    @GetMapping("/search")
    public R search(@RequestParam(defaultValue = "") String keyword) {
        return R.ok(dictionaryService.search(keyword));
    }

    @GetMapping("/{id}")
    public R detail(@PathVariable Long id) {
        Object data = dictionaryService.getDetail(id);
        if (data == null) {
            return R.fail("词条不存在");
        }
        return R.ok(data);
    }
}