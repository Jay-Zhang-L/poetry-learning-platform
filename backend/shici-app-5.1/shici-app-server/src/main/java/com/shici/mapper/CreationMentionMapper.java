package com.shici.mapper;

import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface CreationMentionMapper {
    
    @Insert("INSERT INTO creation_mention(work_id, user_id) VALUES(#{workId}, #{userId})")
    int insert(@Param("workId") Long workId, @Param("userId") Long userId);
    
    @Select("SELECT user_id FROM creation_mention WHERE work_id = #{workId}")
    List<Long> findUserIdsByWorkId(@Param("workId") Long workId);
    
    @Delete("DELETE FROM creation_mention WHERE work_id = #{workId}")
    int deleteByWorkId(@Param("workId") Long workId);
}
