package com.shici.mapper;

import com.shici.domain.UserProgress;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ProgressMapper {
  UserProgress get(@Param("userId") Long userId, @Param("unitId") Long unitId);
  int upsert(UserProgress progress);
}
