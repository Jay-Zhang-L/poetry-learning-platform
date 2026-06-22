package com.shici.service;

public interface DictionaryService {

    Object getHomeData();

    Object search(String keyword);

    Object getDetail(Long id);
}