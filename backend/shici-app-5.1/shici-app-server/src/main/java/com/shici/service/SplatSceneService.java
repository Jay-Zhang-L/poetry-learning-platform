package com.shici.service;

import com.shici.domain.SplatScene;
import java.util.List;

public interface SplatSceneService {
    SplatScene getById(Long id);
    List<SplatScene> search(String kw);
}