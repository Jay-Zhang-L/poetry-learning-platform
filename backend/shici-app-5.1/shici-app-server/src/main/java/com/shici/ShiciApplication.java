package com.shici;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.shici.mapper") // ⭐ 关键：让 MyBatis 扫描 mapper 接口
public class ShiciApplication {
    public static void main(String[] args) {
        SpringApplication.run(ShiciApplication.class, args);
    }
}
