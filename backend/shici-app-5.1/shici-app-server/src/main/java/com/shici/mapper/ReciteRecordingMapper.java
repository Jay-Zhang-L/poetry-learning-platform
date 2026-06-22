package com.shici.mapper;

import com.shici.domain.ReciteRecording;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 朗诵录音评价 Mapper
 */
@Mapper
public interface ReciteRecordingMapper {
    
    /**
     * 插入录音评价记录
     */
    int insert(ReciteRecording recording);
    
    /**
     * 根据ID查询录音评价
     */
    ReciteRecording selectById(@Param("id") Long id);
    
    /**
     * 查询用户的所有录音评价记录
     */
    List<ReciteRecording> selectByUserId(@Param("userId") Long userId);
    
    /**
     * 查询用户对某首诗的录音评价记录
     */
    List<ReciteRecording> selectByUserIdAndPoemId(@Param("userId") Long userId, @Param("poemId") Long poemId);
    
    /**
     * 删除录音评价记录
     */
    int deleteById(@Param("id") Long id, @Param("userId") Long userId);
}
