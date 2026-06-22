package com.shici.mapper;

import com.shici.domain.ForumComment;
import com.shici.domain.ForumPost;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface ForumMapper {

    @Select("""
      SELECT * FROM forum_post
      WHERE season_id=#{seasonId}
      ORDER BY id DESC
      LIMIT #{offset}, #{size}
    """)
    List<ForumPost> listPosts(@Param("seasonId") Long seasonId,
                              @Param("offset") Integer offset,
                              @Param("size") Integer size);

    @Select("SELECT * FROM forum_post WHERE id=#{id}")
    ForumPost getPost(@Param("id") Long id);

    @Insert("""
      INSERT INTO forum_post(season_id,user_id,title,content,images_json,like_count,comment_count)
      VALUES(#{seasonId},#{userId},#{title},#{content},#{imagesJson},0,0)
    """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insertPost(ForumPost p);

    @Select("SELECT * FROM forum_comment WHERE post_id=#{postId} ORDER BY id ASC")
    List<ForumComment> listComments(@Param("postId") Long postId);

    @Insert("""
      INSERT INTO forum_comment(post_id,user_id,parent_id,content,images_json)
      VALUES(#{postId},#{userId},#{parentId},#{content},#{imagesJson})
    """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insertComment(ForumComment c);

    @Update("UPDATE forum_post SET comment_count = comment_count + 1 WHERE id=#{postId}")
    int incCommentCount(@Param("postId") Long postId);
}
