package com.shici.controller;

import com.shici.domain.SysUser;
import com.shici.service.AuthService;
import com.shici.service.TokenService;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;
    private final TokenService tokenService;

    public AuthController(AuthService authService, TokenService tokenService) {
        this.authService = authService;
        this.tokenService = tokenService;
    }

    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody Map<String, Object> body) {
        Map<String, Object> res = new HashMap<>();
        try {
            SysUser user = authService.login(
                    (String) body.get("username"),
                    (String) body.get("password"),
                    (String) body.get("role")
            );

            String token = UUID.randomUUID().toString().replace("-", "");
            tokenService.bind(token, user.getId());

            user.setPassword(null);

            Map<String, Object> data = new HashMap<>();
            data.put("token", token);
            data.put("user", user);

            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", data);
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage() == null ? "登录失败" : e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @PostMapping("/register")
    public Map<String, Object> register(@RequestBody Map<String, Object> body) {
        Map<String, Object> res = new HashMap<>();
        try {
            Integer grade = null;
            Object g = body.get("grade");
            if (g instanceof Number) grade = ((Number) g).intValue();
            else if (g instanceof String && !((String) g).isBlank()) grade = Integer.parseInt((String) g);

            SysUser user = authService.register(
                    (String) body.get("username"),
                    (String) body.get("password"),
                    (String) body.get("nickname"),
                    (String) body.get("role"),
                    grade
            );

            user.setPassword(null);

            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", user);
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage() == null ? "注册失败" : e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @PostMapping("/logout")
    public Map<String, Object> logout(@RequestHeader(value="Authorization", required=false) String auth) {
        Map<String, Object> res = new HashMap<>();
        try {
            String token = extractToken(auth);
            if (token != null) tokenService.logout(token);
            res.put("code", 0); res.put("msg", "ok"); res.put("data", null);
            return res;
        } catch (Exception e) {
            res.put("code", 1); res.put("msg", e.getMessage()); res.put("data", null);
            return res;
        }
    }

    private String extractToken(String auth) {
        if (auth == null) return null;
        String s = auth.trim();
        if (!s.startsWith("Bearer ")) return null;
        return s.substring("Bearer ".length()).trim();
    }
}