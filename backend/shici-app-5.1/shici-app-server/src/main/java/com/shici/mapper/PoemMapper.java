package com.shici.mapper;

import com.shici.domain.dto.PoemCardDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface PoemMapper {

    List<PoemCardDto> page(@Param("q") String q,
                           @Param("dynasty") String dynasty,
                           @Param("genre") String genre,
                           @Param("theme") String theme,
                           @Param("season") String season,
                           @Param("emotion") String emotion,
                           @Param("scenery") String scenery,
                           @Param("festival") String festival,
                           @Param("historicalPeriod") String historicalPeriod,
                           @Param("poeticForm") String poeticForm,
                           @Param("rhetoricalDevice") String rhetoricalDevice,
                           @Param("famousLineType") String famousLineType,
                           @Param("orderBy") String orderBy,
                           @Param("offset") int offset,
                           @Param("size") int size);

    long count(@Param("q") String q,
               @Param("dynasty") String dynasty,
               @Param("genre") String genre,
               @Param("theme") String theme,
               @Param("season") String season,
               @Param("emotion") String emotion,
               @Param("scenery") String scenery,
               @Param("festival") String festival,
               @Param("historicalPeriod") String historicalPeriod,
               @Param("poeticForm") String poeticForm,
               @Param("rhetoricalDevice") String rhetoricalDevice,
               @Param("famousLineType") String famousLineType);

    PoemCardDto findById(@Param("id") Long id);

    int updateAudio(@Param("id") Long id,
                    @Param("audioUrl") String audioUrl,
                    @Param("audioDuration") Integer audioDuration,
                    @Param("audioType") String audioType);

    int updateCover(@Param("id") Long id,
                    @Param("coverUrl") String coverUrl);

    // ==================== 收藏功能 ====================

    int insertFav(@Param("userId") Long userId, @Param("poemId") Long poemId);

    int deleteFav(@Param("userId") Long userId, @Param("poemId") Long poemId);

    int existsFav(@Param("userId") Long userId, @Param("poemId") Long poemId);

    List<PoemCardDto> getUserFavList(@Param("userId") Long userId,
                                     @Param("offset") int offset,
                                     @Param("size") int size);

    long countUserFav(@Param("userId") Long userId);

    List<Long> getUserFavIds(@Param("userId") Long userId, @Param("poemIds") List<Long> poemIds);

    // ==================== 作者列表 ====================
    List<Map<String, Object>> getAuthors(@Param("dynasty") String dynasty,
                                         @Param("genre") String genre,
                                         @Param("theme") String theme,
                                         @Param("season") String season,
                                         @Param("emotion") String emotion,
                                         @Param("scenery") String scenery,
                                         @Param("festival") String festival,
                                         @Param("historicalPeriod") String historicalPeriod,
                                         @Param("poeticForm") String poeticForm,
                                         @Param("rhetoricalDevice") String rhetoricalDevice);
}