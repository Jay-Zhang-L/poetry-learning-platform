<template>
  <div class="authPage" :style="authBgStyle">
    <div class="cardWrap">
      <img class="cardBg" :src="loginCardBg" alt="登录卷轴背景" />

      <div class="cardContent">
        <div class="brand">
          <div class="logo">诗韵华章</div>
          <div class="sub">登录后进入学习与创作</div>
        </div>

        <div class="seg">
          <button
            class="segBtn"
            :class="{ on: role === 'student' }"
            @click="role = 'student'"
          >
            学生
          </button>
          <button
            class="segBtn"
            :class="{ on: role === 'teacher' }"
            @click="role = 'teacher'"
          >
            教师
          </button>
        </div>

        <div class="form">
          <div class="field">
            <label class="lbl">账号</label>
            <input
              v-model.trim="form.username"
              class="iptLine"
              placeholder="请输入账号"
              autocomplete="username"
            />
          </div>

          <div class="field">
            <label class="lbl">密码</label>
            <input
              v-model.trim="form.password"
              class="iptLine"
              placeholder="请输入密码"
              type="password"
              autocomplete="current-password"
              @keyup.enter="onLogin"
            />
          </div>

          <button class="primary" :disabled="loading" @click="onLogin">
            {{ loading ? "登录中..." : "登录" }}
          </button>

          <div class="row">
            <span class="tip">
              还没有账号？
              <a class="link" @click="goRegister">去注册</a>
            </span>
            <span class="tip">
              <a class="link" @click="goHome">返回首页</a>
            </span>
          </div>
        </div>

        <div class="hint">
          当前登录身份：<b>{{ roleLabel }}</b>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { useProfileStore } from "../../stores/profile";
import { showError, showSuccess } from "@/utils/toast";
import loginBg from "@/assets/bg/login-bg.jpg";
import loginCardBg from "@/assets/bg/login-card.png";

const router = useRouter();
const profile = useProfileStore();

const role = ref("student");
const roleLabel = computed(() =>
  role.value === "teacher" ? "教师" : "学生"
);

const form = reactive({
  username: "",
  password: "",
});

const loading = ref(false);

const authBgStyle = computed(() => ({
  backgroundImage: `url(${loginBg})`,
}));

function goRegister() {
  router.push("/register");
}

function goHome() {
  router.push("/home");
}

async function safeReadJson(resp) {
  const text = await resp.text();
  try {
    return text ? JSON.parse(text) : null;
  } catch (e) {
    return { code: 1, msg: text || "服务器返回非JSON内容", data: null };
  }
}

async function onLogin() {
  if (!form.username || !form.password) {
    showError("请先填写账号和密码");
    return;
  }

  loading.value = true;
  try {
    const resp = await fetch("/api/auth/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        username: form.username,
        password: form.password,
        role: role.value,
      }),
    });

    const json = await safeReadJson(resp);

    if (!resp.ok) {
      showError((json && json.msg) || `登录失败（HTTP ${resp.status}）`);
      return;
    }

    if (!json || json.code !== 0) {
      showError((json && json.msg) || "登录失败（业务失败）");
      return;
    }

    const token = json.data && json.data.token;
    const user = json.data && json.data.user;

    if (!token || !user) {
      showError("登录失败：返回数据不完整");
      return;
    }

    localStorage.setItem("token", token);
    localStorage.setItem("user", JSON.stringify(user));
    localStorage.setItem("role", user.role || role.value);

    profile.setUser(user);

    showSuccess("登录成功！");

    setTimeout(() => {
      router.replace("/home");
    }, 1000);
  } catch (e) {
    console.error(e);
    showError(e.message || "登录失败（网络异常）");
  } finally {
    loading.value = false;
  }
}
</script>

<style scoped>
.authPage {
  position: fixed;
  inset: 0;
  width: 100vw;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  box-sizing: border-box;
  overflow: hidden;
  background-position: center center;
  background-repeat: no-repeat;
  background-size: cover;
}

.cardWrap {
  position: relative;
  width: min(760px, 92vw);
  display: flex;
  align-items: center;
  justify-content: center;
  background: transparent;
}

.cardBg {
  display: block;
  width: 100%;
  height: auto;
  max-height: 90vh;
  object-fit: contain;
  pointer-events: none;
  user-select: none;
  -webkit-user-drag: none;
}

.cardContent {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 62%;
  transform: translate(-50%, -44%);
  color: #1f1a14;
  background: transparent;
}

.brand {
  margin-bottom: 18px;
}

.brand .logo {
  font-size: 34px;
  line-height: 1.1;
  font-weight: 700;
  letter-spacing: 2px;
  color: #1c1712;
}

.brand .sub {
  margin-top: 8px;
  font-size: 16px;
  color: #3a3027;
}

.seg {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 18px;
  margin-bottom: 26px;
}

.segBtn {
  height: 48px;
  border: 1px solid rgba(83, 63, 39, 0.35);
  border-radius: 999px;
  background: rgba(255, 248, 231, 0.28);
  color: #2f2418;
  font-size: 18px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s ease;
}

.segBtn:hover {
  background: rgba(245, 233, 205, 0.48);
}

.segBtn.on {
  background: rgba(219, 195, 143, 0.36);
  border-color: rgba(83, 63, 39, 0.52);
  color: #1f1710;
}

.form {
  margin-top: 4px;
}

.field {
  margin-bottom: 22px;
}

.lbl {
  display: block;
  margin-bottom: 10px;
  font-size: 16px;
  color: #4a3a2a;
  font-weight: 600;
}

.iptLine {
  width: 100%;
  height: 46px;
  padding: 0 2px;
  box-sizing: border-box;
  border: none;
  border-bottom: 2px solid rgba(89, 67, 43, 0.42);
  background: transparent;
  color: #1d1712;
  font-size: 21px;
  outline: none;
}

.iptLine::placeholder {
  color: rgba(83, 63, 39, 0.42);
}

.iptLine:focus {
  border-bottom-color: rgba(72, 47, 23, 0.9);
}

.primary {
  width: 100%;
  height: 50px;
  margin-top: 12px;
  border: 1px solid rgba(95, 71, 44, 0.45);
  border-radius: 999px;
  background: rgba(255, 248, 235, 0.55);
  color: #1d1610;
  font-size: 28px;
  font-weight: 700;
  letter-spacing: 2px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.primary:hover {
  background: rgba(244, 231, 205, 0.76);
}

.primary:active {
  transform: translateY(1px);
}

.primary:disabled {
  opacity: 0.65;
  cursor: not-allowed;
}

.row {
  margin-top: 18px;
  display: flex;
  justify-content: space-between;
  gap: 12px;
}

.tip {
  font-size: 15px;
  color: #4c3e30;
}

.link {
  color: #2d2116;
  text-decoration: none;
  border-bottom: 1px solid rgba(45, 33, 22, 0.45);
  cursor: pointer;
}

.hint {
  margin-top: 18px;
  font-size: 14px;
  color: #4b3d30;
}

@media (max-width: 900px) {
  .cardWrap {
    width: min(720px, 96vw);
  }

  .cardContent {
    width: 64%;
    transform: translate(-50%, -43%);
  }

  .brand .logo {
    font-size: 28px;
  }

  .brand .sub {
    font-size: 14px;
  }

  .segBtn {
    height: 44px;
    font-size: 17px;
  }

  .iptLine {
    font-size: 18px;
  }

  .primary {
    font-size: 24px;
  }
}

@media (max-width: 640px) {
  .authPage {
    padding: 12px;
  }

  .cardWrap {
    width: 98vw;
  }

  .cardBg {
    max-height: 94vh;
  }

  .cardContent {
    width: 66%;
    transform: translate(-50%, -42%);
  }

  .brand {
    margin-bottom: 14px;
  }

  .brand .logo {
    font-size: 22px;
    letter-spacing: 1px;
  }

  .brand .sub {
    margin-top: 4px;
    font-size: 12px;
  }

  .seg {
    gap: 10px;
    margin-bottom: 18px;
  }

  .segBtn {
    height: 38px;
    font-size: 15px;
  }

  .field {
    margin-bottom: 16px;
  }

  .lbl {
    margin-bottom: 6px;
    font-size: 13px;
  }

  .iptLine {
    height: 38px;
    font-size: 16px;
    border-bottom-width: 1.5px;
  }

  .primary {
    height: 42px;
    margin-top: 8px;
    font-size: 20px;
  }

  .row {
    margin-top: 14px;
    flex-direction: row;
    gap: 8px;
  }

  .tip {
    font-size: 12px;
  }

  .hint {
    margin-top: 12px;
    font-size: 12px;
  }
}
</style>