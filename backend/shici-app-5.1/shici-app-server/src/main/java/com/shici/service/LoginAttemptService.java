package com.shici.service;

import org.springframework.stereotype.Service;

import java.util.concurrent.ConcurrentHashMap;

/**
 * 登录失败计数与短时锁定（单机内存）。连续密码错误 {@link #MAX_FAILURES} 次后锁定 {@link #LOCK_MS} 毫秒。
 */
@Service
public class LoginAttemptService {

    static final int MAX_FAILURES = 8;
    private static final long LOCK_MS = 10 * 60 * 1000L;

    private static final class State {
        int failures;
        long lockedUntil;
    }

    private final ConcurrentHashMap<String, State> attempts = new ConcurrentHashMap<>();

    private static String key(String username) {
        if (username == null || username.isBlank()) {
            return null;
        }
        return username.trim().toLowerCase();
    }

    /**
     * 若已超过失败次数阈值且仍在锁定期内则抛异常。
     */
    public void assertNotLocked(String username) {
        String k = key(username);
        if (k == null) {
            return;
        }
        State s = attempts.get(k);
        if (s == null) {
            return;
        }
        long now = System.currentTimeMillis();
        if (s.lockedUntil > now) {
            long remain = s.lockedUntil - now;
            int minutes = Math.max(1, (int) Math.ceil(remain / 60000.0));
            throw new RuntimeException(
                    "密码错误已达" + MAX_FAILURES + "次，账号已锁定约" + minutes + "分钟，请稍后再试");
        }
        // 锁过期后清除
        if (s.lockedUntil > 0 && s.lockedUntil <= now) {
            attempts.remove(k);
        }
    }

    /**
     * 在已确认用户名存在且密码不匹配时调用。若本轮触发锁定则抛出带说明的异常（与 assertNotLocked 文案一致）。
     */
    public void recordPasswordFailure(String username) {
        String k = key(username);
        if (k == null) {
            return;
        }
        attempts.compute(k, (key, old) -> {
            State s = old != null ? old : new State();
            long now = System.currentTimeMillis();
            if (s.lockedUntil > now) {
                return s;
            }
            s.failures++;
            if (s.failures >= MAX_FAILURES) {
                s.lockedUntil = now + LOCK_MS;
            }
            return s;
        });
    }

    /** 上次错误密码之后的连续失败次数（未锁定或未过期计数窗口内）。 */
    public int failureCount(String username) {
        String k = key(username);
        if (k == null) {
            return 0;
        }
        State s = attempts.get(k);
        if (s == null) {
            return 0;
        }
        long now = System.currentTimeMillis();
        if (s.lockedUntil > now) {
            return MAX_FAILURES;
        }
        if (s.lockedUntil > 0 && s.lockedUntil <= now) {
            return 0;
        }
        return s.failures;
    }

    public void clearSuccess(String username) {
        String k = key(username);
        if (k != null) {
            attempts.remove(k);
        }
    }
}
