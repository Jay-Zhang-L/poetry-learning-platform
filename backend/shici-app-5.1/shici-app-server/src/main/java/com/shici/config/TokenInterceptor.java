package com.shici.config;

import com.shici.domain.SysUser;
import com.shici.mapper.SysUserMapper;
import com.shici.service.TokenService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class TokenInterceptor implements HandlerInterceptor {

    @Autowired
    private TokenService tokenService;

    @Autowired
    private SysUserMapper sysUserMapper;

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) {

        // 从请求头中获取 Authorization
        String auth = request.getHeader("Authorization");
        String token = extractToken(auth);

        if (token != null && !token.isEmpty()) {
            try {
                // 通过 token 获取用户 ID
                Long userId = tokenService.getUserId(token);

                if (userId != null) {
                    // 查询用户信息
                    SysUser user = sysUserMapper.findById(userId);

                    if (user != null) {
                        // 存入 Session
                        HttpSession session = request.getSession();
                        session.setAttribute("user", user);

                        // 存入 Request，方便 controller/service 直接取
                        request.setAttribute("user", user);
                        request.setAttribute("userId", user.getId());
                    }
                }
            } catch (Exception e) {
                // token 无效时不拦截请求，直接放行
                // 可以按需打开日志
                // e.printStackTrace();
            }
        }

        return true;
    }

    private String extractToken(String auth) {
        if (auth == null || auth.trim().isEmpty()) {
            return null;
        }

        String s = auth.trim();
        if (s.startsWith("Bearer ")) {
            return s.substring("Bearer ".length()).trim();
        }

        return null;
    }
}