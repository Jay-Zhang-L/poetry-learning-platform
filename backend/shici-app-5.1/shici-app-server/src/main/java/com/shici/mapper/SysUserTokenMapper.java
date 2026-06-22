package com.shici.mapper;

import org.apache.ibatis.annotations.*;

@Mapper
public interface SysUserTokenMapper {

    @Insert("""
        INSERT INTO sys_user_token(user_id, token, created_at)
        VALUES(#{userId}, #{token}, NOW())
    """)
    int insert(@Param("userId") Long userId, @Param("token") String token);

    @Select("""
        SELECT user_id
        FROM sys_user_token
        WHERE token = #{token}
        LIMIT 1
    """)
    Long findUserIdByToken(@Param("token") String token);

    @Delete("""
        DELETE FROM sys_user_token
        WHERE token = #{token}
    """)
    int deleteByToken(@Param("token") String token);
}