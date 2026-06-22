package com.shici.mapper;

import com.shici.domain.DictionaryEntry;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DictionaryMapper {

    List<DictionaryEntry> selectHomeRecommend();

    List<DictionaryEntry> searchEntries(@Param("keyword") String keyword,
                                        @Param("limit") Integer limit);

    DictionaryEntry selectById(@Param("id") Long id);
}