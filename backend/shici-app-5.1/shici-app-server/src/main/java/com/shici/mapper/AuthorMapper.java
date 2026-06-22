package com.shici.mapper;

import com.shici.domain.Author;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface AuthorMapper {

    @Select("""
        SELECT id, name, dynasty, avatar_url AS avatarUrl, intro
        FROM author
        WHERE name = #{name}
    """)
    Author findByName(String name);
}
