package com.shici.mapper;

import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface UserFollowMapper {

    @Insert("""
        INSERT INTO user_follow(user_id, follow_user_id, created_at)
        VALUES(#{userId}, #{followUserId}, NOW())
    """)
    int follow(@Param("userId") Long userId, @Param("followUserId") Long followUserId);

    @Delete("""
        DELETE FROM user_follow
        WHERE user_id = #{userId} AND follow_user_id = #{followUserId}
    """)
    int unfollow(@Param("userId") Long userId, @Param("followUserId") Long followUserId);

    @Select("""
        SELECT COUNT(*)
        FROM user_follow
        WHERE user_id = #{userId} AND follow_user_id = #{followUserId}
    """)
    int isFollowed(@Param("userId") Long userId, @Param("followUserId") Long followUserId);

    @Select("""
        SELECT COUNT(*)
        FROM user_follow
        WHERE user_id = #{userId}
    """)
    int countFollowing(@Param("userId") Long userId);

    @Select("""
        SELECT COUNT(*)
        FROM user_follow
        WHERE follow_user_id = #{userId}
    """)
    int countFollowers(@Param("userId") Long userId);

    @Select("""
        SELECT
            u.id,
            u.username,
            u.nickname,
            u.avatar_url AS avatarUrl,
            u.bio,
            (SELECT COUNT(*) FROM user_follow WHERE follow_user_id = f.follow_user_id) AS followersCount,
            (SELECT COUNT(*) FROM creation_work WHERE user_id = f.follow_user_id) AS worksCount
        FROM user_follow f
        JOIN sys_user u ON u.id = f.follow_user_id
        WHERE f.user_id = #{userId}
        ORDER BY f.created_at DESC
        LIMIT #{limit} OFFSET #{offset}
    """)
    List<Map<String,Object>> listFollowing(@Param("userId") Long userId,
                                           @Param("offset") int offset,
                                           @Param("limit") int limit);

    @Select("""
        SELECT
            u.id,
            u.username,
            u.nickname,
            u.avatar_url AS avatarUrl,
            u.bio,
            (SELECT COUNT(*) FROM user_follow WHERE follow_user_id = u.id) AS followersCount,
            (SELECT COUNT(*) FROM creation_work WHERE user_id = u.id) AS worksCount
        FROM user_follow f
        JOIN sys_user u ON u.id = f.user_id
        WHERE f.follow_user_id = #{userId}
        ORDER BY f.created_at DESC
        LIMIT #{limit} OFFSET #{offset}
    """)
    List<Map<String,Object>> listFollowers(@Param("userId") Long userId,
                                           @Param("offset") int offset,
                                           @Param("limit") int limit);

    /**
     * 获取关注用户的作品ID列表
     */
    @Select("""
        SELECT DISTINCT w.id
        FROM user_follow f
        INNER JOIN creation_work w ON w.user_id = f.follow_user_id
        WHERE f.user_id = #{userId}
        AND w.privacy = 'public'
        ORDER BY w.created_at DESC
        LIMIT #{limit} OFFSET #{offset}
    """)
    List<Long> findFollowedUserWorkIds(@Param("userId") Long userId,
                                       @Param("offset") int offset,
                                       @Param("limit") int limit);

    /**
     * 统计关注用户的作品数量
     */
    @Select("""
        SELECT COUNT(DISTINCT w.id)
        FROM user_follow f
        INNER JOIN creation_work w ON w.user_id = f.follow_user_id
        WHERE f.user_id = #{userId}
        AND w.privacy = 'public'
    """)
    int countFollowedUserWorks(@Param("userId") Long userId);

    /**
     * 统计互相关注的数量
     * 查询同时在我关注列表和关注我列表的用户数量
     */
    @Select("""
        SELECT COUNT(*)
        FROM user_follow f1
        JOIN user_follow f2 ON f1.user_id = f2.follow_user_id AND f1.follow_user_id = f2.user_id
        WHERE f1.user_id = #{userId}
    """)
    int countMutualFollow(@Param("userId") Long userId);

    /**
     * 查询互相关注的用户列表
     * 查询同时在我关注列表和关注我列表的用户
     */
    @Select("""
        SELECT
            u.id AS id,
            u.username AS username,
            u.nickname AS nickname,
            u.avatar_url AS avatarUrl,
            u.bio AS bio,
            (SELECT COUNT(*) FROM creation_work WHERE user_id = u.id) AS worksCount,
            (SELECT COUNT(*) FROM user_follow WHERE follow_user_id = u.id) AS followersCount
        FROM user_follow f1
        JOIN user_follow f2 ON f1.user_id = f2.follow_user_id AND f1.follow_user_id = f2.user_id
        JOIN sys_user u ON u.id = f2.user_id
        WHERE f1.user_id = #{userId}
        ORDER BY u.nickname ASC
        LIMIT #{limit} OFFSET #{offset}
    """)
    List<Map<String, Object>> listMutualFollows(@Param("userId") Long userId,
                                               @Param("offset") int offset,
                                               @Param("limit") int limit);
}