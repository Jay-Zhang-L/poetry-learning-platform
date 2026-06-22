package com.shici.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class PageResp<T> {

    private long total;
    private int page;
    private int size;
    private List<T> items;

    public static <T> PageResp<T> of(long total, int page, int size, List<T> items) {
        return new PageResp<>(total, page, size, items);
    }
}
