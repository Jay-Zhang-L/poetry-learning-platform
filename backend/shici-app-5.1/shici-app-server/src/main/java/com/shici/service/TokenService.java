package com.shici.service;

import com.shici.mapper.SysUserTokenMapper;
import org.springframework.stereotype.Service;

@Service
public class TokenService {

    private final SysUserTokenMapper tokenMapper;

    public TokenService(SysUserTokenMapper tokenMapper) {
        this.tokenMapper = tokenMapper;
    }

    public void bind(String token, Long userId) {
        tokenMapper.insert(userId, token);
    }

    public Long getUserId(String token) {
        return tokenMapper.findUserIdByToken(token);
    }

    public void logout(String token) {
        tokenMapper.deleteByToken(token);
    }
}