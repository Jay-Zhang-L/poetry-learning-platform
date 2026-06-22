package com.shici.mapper;

import com.shici.domain.LearnUnit;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LearnUnitMapper {
  List<LearnUnit> listByGrade(@Param("grade") Integer grade);
}
