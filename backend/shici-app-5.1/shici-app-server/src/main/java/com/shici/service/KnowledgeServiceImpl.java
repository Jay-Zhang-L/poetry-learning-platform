package com.shici.service;

import com.shici.domain.Knowledge;
import com.shici.domain.KnowledgeImage;
import com.shici.mapper.KnowledgeMapper;
import com.shici.mapper.KnowledgeImageMapper;
import com.shici.domain.vo.KnowledgeImageVO;
import com.shici.domain.vo.KnowledgeVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class KnowledgeServiceImpl implements KnowledgeService {

    @Autowired
    private KnowledgeMapper knowledgeMapper;

    @Autowired
    private KnowledgeImageMapper knowledgeImageMapper;

    @Override
    public List<KnowledgeVO> getKnowledgeList() {
        List<Knowledge> knowledgeList = knowledgeMapper.findAllEnabled();
        List<KnowledgeVO> voList = new ArrayList<>();

        for (Knowledge knowledge : knowledgeList) {
            KnowledgeVO vo = new KnowledgeVO();
            vo.setId(knowledge.getId());
            vo.setPageKey(knowledge.getPageKey());
            vo.setTitle(knowledge.getTitle());
            vo.setCategory(knowledge.getCategory());
            vo.setFullDescription(knowledge.getFullDescription());
            vo.setDetailText(knowledge.getDetailText());
            vo.setImageBg(knowledge.getImageBg());
            vo.setCoverUrl(knowledge.getCoverUrl());
            voList.add(vo);
        }

        return voList;
    }

    @Override
    public KnowledgeVO getKnowledgeDetail(String pageKey) {
        Knowledge knowledge = knowledgeMapper.findByPageKey(pageKey);
        if (knowledge == null) {
            return null;
        }

        KnowledgeVO vo = new KnowledgeVO();
        vo.setId(knowledge.getId());
        vo.setPageKey(knowledge.getPageKey());
        vo.setTitle(knowledge.getTitle());
        vo.setCategory(knowledge.getCategory());
        vo.setFullDescription(knowledge.getFullDescription());
        vo.setDetailText(knowledge.getDetailText());
        vo.setImageBg(knowledge.getImageBg());
        vo.setCoverUrl(knowledge.getCoverUrl());

        List<KnowledgeImage> images = knowledgeImageMapper.findByKnowledgeId(knowledge.getId());
        List<KnowledgeImageVO> imageVOs = images.stream().map(img -> {
            KnowledgeImageVO imgVO = new KnowledgeImageVO();
            imgVO.setId(img.getId());
            imgVO.setImageUrl(img.getImageUrl());
            imgVO.setImageDesc(img.getImageDesc());
            imgVO.setSortOrder(img.getSortOrder());
            return imgVO;
        }).collect(Collectors.toList());

        vo.setImages(imageVOs);

        return vo;
    }
}