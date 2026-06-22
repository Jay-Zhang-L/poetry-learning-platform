package com.shici.mapper;

import com.shici.domain.SplatScene;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SplatSceneMapper {

    SplatScene selectById(@Param("id") Long id);

    List<SplatScene> selectList(@Param("kw") String kw);
}