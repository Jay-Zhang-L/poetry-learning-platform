package com.shici.mapper;

import com.shici.domain.GameEntry;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface GameMapper {

  /**
   * 每周推荐
   * weeklyNo 允许为 null：null 表示不过滤周次
   */
  List<GameEntry> listWeekly(@Param("weeklyNo") Integer weeklyNo);
}
