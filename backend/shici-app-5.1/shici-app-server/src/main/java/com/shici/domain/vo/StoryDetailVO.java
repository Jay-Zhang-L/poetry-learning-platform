package com.shici.domain.vo;

import com.shici.domain.entity.Story;
import lombok.Data;
import java.util.List;

@Data
public class StoryDetailVO {
    private Story story;
    private List<StoryPoemVO> poems;
}
