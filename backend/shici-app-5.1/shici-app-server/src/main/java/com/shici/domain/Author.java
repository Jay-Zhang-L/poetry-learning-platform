package com.shici.domain;

import lombok.Data;

@Data
public class Author {

    private Long id;
    private String name;
    private String dynasty;
    private String avatarUrl;
    private String intro;
}
