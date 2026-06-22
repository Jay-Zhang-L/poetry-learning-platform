package com.shici.controller;

import com.shici.domain.SysUser;
import com.shici.service.TokenService;
import com.shici.service.UserService;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/user")
public class UserController {

    private final TokenService tokenService;
    private final UserService userService;

    public UserController(TokenService tokenService, UserService userService) {
        this.tokenService = tokenService;
        this.userService = userService;
    }

    private Long uid(String auth) {
        if (auth == null || !auth.startsWith("Bearer ")) throw new RuntimeException("未登录");
        String token = auth.substring("Bearer ".length()).trim();
        Long userId = tokenService.getUserId(token);
        if (userId == null) throw new RuntimeException("登录已失效");
        return userId;
    }

    private Long uidNullable(String auth) {
        try {
            return uid(auth);
        } catch (Exception e) {
            return null;
        }
    }

    @GetMapping("/me")
    public Map<String, Object> me(@RequestHeader(value="Authorization", required=false) String auth) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = uid(auth);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", userService.me(userId));
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @PutMapping("/profile")
    public Map<String, Object> profile(@RequestHeader(value="Authorization", required=false) String auth,
                                       @RequestBody SysUser body) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = uid(auth);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", userService.updateProfile(userId, body));
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @GetMapping("/stats")
    public Map<String, Object> stats(@RequestHeader(value="Authorization", required=false) String auth) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = uid(auth);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", userService.stats(userId));
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @GetMapping("/history")
    public Map<String, Object> history(@RequestHeader(value="Authorization", required=false) String auth,
                                       @RequestParam(defaultValue="1") int page,
                                       @RequestParam(defaultValue="20") int size) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = uid(auth);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", userService.listHistory(userId, page, size));
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @DeleteMapping("/history/{id}")
    public Map<String, Object> deleteHistory(@RequestHeader(value="Authorization", required=false) String auth,
                                             @PathVariable Long id) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = uid(auth);
            userService.deleteHistory(id, userId);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", null);
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @DeleteMapping("/history/clear")
    public Map<String, Object> clearHistory(@RequestHeader(value="Authorization", required=false) String auth) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = uid(auth);
            userService.clearHistory(userId);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", null);
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @PostMapping("/history")
    public Map<String, Object> addHistory(@RequestHeader(value="Authorization", required=false) String auth,
                                           @RequestBody Map<String, Object> body) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = uid(auth);
            String type = (String) body.get("type");
            Long targetId = body.get("targetId") != null ? Long.valueOf(body.get("targetId").toString()) : null;
            String title = (String) body.get("title");
            String coverUrl = (String) body.get("coverUrl");

            userService.addHistory(userId, type, targetId, title, coverUrl);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", null);
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @GetMapping("/fav")
    public Map<String, Object> fav(@RequestHeader(value="Authorization", required=false) String auth,
                                   @RequestParam(defaultValue="creation") String tab,
                                   @RequestParam(defaultValue="1") int page,
                                   @RequestParam(defaultValue="20") int size) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = uid(auth);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", userService.listFav(userId, tab, page, size));
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @GetMapping("/following")
    public Map<String, Object> following(@RequestHeader(value="Authorization", required=false) String auth,
                                         @RequestParam(defaultValue="1") int page,
                                         @RequestParam(defaultValue="20") int size) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = uid(auth);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", userService.listFollowing(userId, page, size));
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @GetMapping("/followers")
    public Map<String, Object> followers(@RequestHeader(value="Authorization", required=false) String auth,
                                         @RequestParam(defaultValue="1") int page,
                                         @RequestParam(defaultValue="20") int size) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = uid(auth);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", userService.listFollowers(userId, page, size));
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @GetMapping("/mutual-follows")
    public Map<String, Object> mutualFollows(@RequestHeader(value="Authorization", required=false) String auth,
                                             @RequestParam(defaultValue="1") int page,
                                             @RequestParam(defaultValue="20") int size) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = uid(auth);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", userService.listMutualFollows(userId, page, size));
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @GetMapping("/likesReceived")
    public Map<String, Object> likesReceived(@RequestHeader(value="Authorization", required=false) String auth,
                                             @RequestParam(defaultValue="1") int page,
                                             @RequestParam(defaultValue="20") int size) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = uid(auth);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", userService.listMyLikes(userId, page, size));
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @GetMapping("/search")
    public Map<String, Object> search(@RequestParam String keyword,
                                      @RequestParam(defaultValue="10") int limit) {
        Map<String, Object> res = new HashMap<>();
        try {
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", userService.searchUsers(keyword, limit));
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @PostMapping("/follow/{targetUserId}")
    public Map<String, Object> follow(@RequestHeader(value="Authorization", required=false) String auth,
                                      @PathVariable Long targetUserId) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = uid(auth);
            userService.followUser(userId, targetUserId);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", null);
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @DeleteMapping("/follow/{targetUserId}")
    public Map<String, Object> unfollow(@RequestHeader(value="Authorization", required=false) String auth,
                                        @PathVariable Long targetUserId) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = uid(auth);
            userService.unfollowUser(userId, targetUserId);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", null);
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @GetMapping("/follow/status/{targetUserId}")
    public Map<String, Object> followStatus(@RequestHeader(value="Authorization", required=false) String auth,
                                            @PathVariable Long targetUserId) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long userId = uid(auth);
            Map<String, Object> data = new HashMap<>();
            data.put("followed", userService.isFollowed(userId, targetUserId));
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", data);
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }

    @GetMapping("/profile/{targetUserId}")
    public Map<String, Object> profileDetail(@RequestHeader(value="Authorization", required=false) String auth,
                                             @PathVariable Long targetUserId) {
        Map<String, Object> res = new HashMap<>();
        try {
            Long currentUserId = uidNullable(auth);
            res.put("code", 0);
            res.put("msg", "ok");
            res.put("data", userService.getUserProfile(currentUserId, targetUserId));
            return res;
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e.getMessage());
            res.put("data", null);
            return res;
        }
    }
}