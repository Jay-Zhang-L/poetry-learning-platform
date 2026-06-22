package com.shici.mapper;

import com.shici.domain.Media;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MediaMapper {
  List<Media> listByPoemId(@Param("poemId") Long poemId, @Param("type") String type);
}
