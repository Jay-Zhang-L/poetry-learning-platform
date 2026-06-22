package com.shici.mapper;

import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface CreationTagMapper {
    
    @Select("SELECT id FROM creation_tag WHERE name = #{name}")
    Long findIdByName(@Param("name") String name);
    
    @Insert("INSERT INTO creation_tag(name, use_count) VALUES(#{name}, 1)")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(@Param("name") String name);
    
    @Update("UPDATE creation_tag SET use_count = use_count + 1 WHERE id = #{tagId}")
    int incrementUseCount(@Param("tagId") Long tagId);
    
    @Insert("INSERT INTO creation_work_tag(work_id, tag_id) VALUES(#{workId}, #{tagId})")
    int linkWorkTag(@Param("workId") Long workId, @Param("tagId") Long tagId);
    
    @Select("SELECT t.name FROM creation_tag t INNER JOIN creation_work_tag wt ON t.id = wt.tag_id WHERE wt.work_id = #{workId}")
    List<String> findTagsByWorkId(@Param("workId") Long workId);
    
    @Delete("DELETE FROM creation_work_tag WHERE work_id = #{workId}")
    int deleteWorkTags(@Param("workId") Long workId);
}
