package com.shici.mapper;

import org.apache.ibatis.annotations.*;

@Mapper
public interface TokenMapper {

    @Insert("""
    INSERT INTO sys_token(token, user_id, created_at, expire_at)
    VALUES(#{token}, #{userId}, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY))
  """)
    int insert(@Param("token") String token, @Param("userId") Long userId);

    @Select("""
    SELECT user_id
    FROM sys_token
    WHERE token = #{token}
      AND (expire_at IS NULL OR expire_at > NOW())
    LIMIT 1
  """)
    Long findUserIdByToken(@Param("token") String token);

    @Delete("DELETE FROM sys_token WHERE token = #{token}")
    int delete(@Param("token") String token);
}