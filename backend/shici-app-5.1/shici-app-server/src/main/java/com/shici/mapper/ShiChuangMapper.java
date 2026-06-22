package com.shici.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface ShiChuangMapper {

    List<Map<String, Object>> searchByTitle(@Param("keyword") String keyword, @Param("limit") Integer limit);

    List<Map<String, Object>> searchByAuthor(@Param("keyword") String keyword, @Param("limit") Integer limit);

    List<Map<String, Object>> searchByQuote(@Param("keyword") String keyword, @Param("limit") Integer limit);

    List<Map<String, Object>> searchByContent(@Param("keyword") String keyword, @Param("limit") Integer limit);

    List<Map<String, Object>> searchByAuthorAndTitle(@Param("author") String author,
                                                     @Param("title") String title,
                                                     @Param("limit") Integer limit);

    List<Map<String, Object>> recommendBySingleTag(@Param("tag") String tag, @Param("limit") Integer limit);

    List<Map<String, Object>> recommendBySummary(@Param("summary") String summary, @Param("limit") Integer limit);

    List<Map<String, Object>> recommendHot(@Param("limit") Integer limit);

    Map<String, Object> getDetail(@Param("id") Long id);
}
