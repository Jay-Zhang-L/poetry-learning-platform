package com.shici.service;

import com.shici.domain.RankingItem;
import com.shici.mapper.CreationMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RankingService {

    @Autowired
    private CreationMapper creationMapper;

    public List<RankingItem> getRanking48h() {
        try {
            return creationMapper.selectRanking48h();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    public List<RankingItem> getRanking10d() {
        try {
            return creationMapper.selectRanking10d();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    public List<RankingItem> getHot15d() {
        try {
            return creationMapper.selectHot15d();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    public List<RankingItem> getEditorPick() {
        try {
            return creationMapper.selectEditorPick();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }
}