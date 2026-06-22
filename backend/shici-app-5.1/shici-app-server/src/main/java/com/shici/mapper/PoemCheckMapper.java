package com.shici.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface PoemCheckMapper {

    @Select("""
      SELECT COUNT(1)
      FROM poem
      WHERE REPLACE(REPLACE(REPLACE(REPLACE(content,'，',''),'。',''),'？',''),'！','') LIKE CONCAT('%', #{pureAnswer}, '%')
    """)
    int existsLine(@Param("pureAnswer") String pureAnswer);
}
