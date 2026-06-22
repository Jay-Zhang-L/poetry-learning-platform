package com.shici.service;

import com.shici.domain.SysUser;
import com.shici.mapper.SysUserMapper;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final SysUserMapper sysUserMapper;
    private final LoginAttemptService loginAttemptService;

    public AuthService(SysUserMapper sysUserMapper, LoginAttemptService loginAttemptService) {
        this.sysUserMapper = sysUserMapper;
        this.loginAttemptService = loginAttemptService;
    }

    // 注册
    public SysUser register(String username,
                            String password,
                            String nickname,
                            String role,
                            Integer grade) {

        if (username == null || username.isBlank()) {
            throw new RuntimeException("账号不能为空");
        }

        if (password == null || password.length() < 6) {
            throw new RuntimeException("密码至少6位");
        }

        SysUser exist = sysUserMapper.findByUsername(username);
        if (exist != null) {
            throw new RuntimeException("账号已存在");
        }

        SysUser user = new SysUser();
        user.setUsername(username);
        user.setPassword(password);  // 明文（临时）
        user.setNickname(nickname == null ? "新用户" : nickname);
        user.setRole(role == null ? "student" : role);
        user.setGrade(grade);

        sysUserMapper.insert(user);

        user.setPassword(null);  // 不返回密码
        return user;
    }

    // 登录
    public SysUser login(String username,
                         String password,
                         String role) {

        loginAttemptService.assertNotLocked(username);

        SysUser user = sysUserMapper.findByUsername(username);

        if (user == null) {
            throw new RuntimeException("账号不存在");
        }

        if (role != null && !role.equals(user.getRole())) {
            throw new RuntimeException("身份不匹配");
        }

        if (!password.equals(user.getPassword())) {
            loginAttemptService.recordPasswordFailure(username);
            loginAttemptService.assertNotLocked(username);
            int left =
                    LoginAttemptService.MAX_FAILURES - loginAttemptService.failureCount(username);
            throw new RuntimeException("密码错误，还可尝试 " + left + " 次");
        }

        loginAttemptService.clearSuccess(username);
        user.setPassword(null);
        return user;
    }
}
