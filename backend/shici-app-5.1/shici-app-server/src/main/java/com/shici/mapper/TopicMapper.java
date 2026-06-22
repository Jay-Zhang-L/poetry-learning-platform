package com.shici.mapper;

import com.shici.domain.dto.TopicDto;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface TopicMapper {
    List<TopicDto> listTopics();
}
