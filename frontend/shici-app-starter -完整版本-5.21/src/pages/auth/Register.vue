<template>
  <div class="authPage">
    <div class="card">
      <div class="brand">
        <div class="logo">注册账号</div>
        <div class="sub">注册后即可登录使用</div>
      </div>

      <div class="seg">
        <button class="segBtn" :class="{ on: role === 'student' }" @click="role = 'student'">
          学生
        </button>
        <button class="segBtn" :class="{ on: role === 'teacher' }" @click="role = 'teacher'">
          教师
        </button>
      </div>

      <div class="form">
        <label class="lbl">账号</label>
        <input v-model.trim="form.username" class="ipt" placeholder="建议英文/数字" />

        <label class="lbl">密码</label>
        <input v-model.trim="form.password" class="ipt" placeholder="至少 6 位" type="password" />

        <label class="lbl">确认密码</label>
        <input v-model.trim="form.password2" class="ipt" placeholder="再次输入密码" type="password" />

        <button class="primary" :disabled="loading" @click="onRegister">
          {{ loading ? "注册中..." : "注册" }}
        </button>

        <div class="row">
          <span class="tip">
            已有账号？
            <a class="link" @click="goLogin">去登录</a>
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { showError, showSuccess } from "@/utils/toast";

const router = useRouter();
const role = ref("student");
const loading = ref(false);

const form = reactive({
  username: "",
  password: "",
  password2: "",
});

function goLogin() {
  router.push({ path: "/login" });
}

async function onRegister() {
  if (!form.username || !form.password) {
    showError("请先填写账号和密码");
    return;
  }
  if (form.password.length < 6) {
    showError("密码至少 6 位");
    return;
  }
  if (form.password !== form.password2) {
    showError("两次密码不一致");
    return;
  }

  loading.value = true;
  try {
    const resp = await fetch("/api/auth/register", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        username: form.username,
        password: form.password,
        role: role.value,
      }),
    });

    const json = await resp.json().catch(() => null);
    if (!resp.ok) throw new Error((json && json.msg) || "注册失败");
    if (!json || json.code !== 0) throw new Error((json && json.msg) || "注册失败");

    showSuccess("注册成功，请登录");
    
    setTimeout(() => {
      router.replace({ path: "/login" });
    }, 1500);
  } catch (e) {
    console.error(e);
    showError(e.message || "注册失败，请稍后再试");
  } finally {
    loading.value = false;
  }
}
</script>

<style scoped>
.authPage {
  min-height: 100vh;
  display: grid;
  place-items: center;
  padding: 24px;
  background: radial-gradient(1200px 600px at 20% 10%, rgba(255,255,255,.18), transparent 60%),
              radial-gradient(900px 500px at 80% 30%, rgba(255,255,255,.10), transparent 60%),
              linear-gradient(180deg, rgba(10,10,10,.82), rgba(10,10,10,.92));
}
.card {
  width: min(420px, 92vw);
  border-radius: 18px;
  padding: 22px 20px 18px;
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255,255,255,.14);
  backdrop-filter: blur(10px);
}
.brand .logo {
  font-size: 22px;
  font-weight: 700;
  color: rgba(255,255,255,.92);
}
.brand .sub {
  margin-top: 6px;
  font-size: 13px;
  color: rgba(255,255,255,.62);
}
.seg {
  margin-top: 14px;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}
.segBtn {
  border-radius: 12px;
  padding: 10px 0;
  border: 1px solid rgba(255,255,255,.14);
  background: rgba(255,255,255,.06);
  color: rgba(255,255,255,.72);
  cursor: pointer;
}
.segBtn.on {
  background: rgba(255,255,255,.18);
  color: rgba(255,255,255,.92);
  border-color: rgba(255,255,255,.22);
}
.form { margin-top: 14px; }
.lbl {
  display: block;
  margin: 10px 0 6px;
  font-size: 13px;
  color: rgba(255,255,255,.70);
}
.ipt {
  width: 100%;
  padding: 11px 12px;
  border-radius: 12px;
  border: 1px solid rgba(255,255,255,.14);
  background: rgba(0,0,0,.22);
  color: rgba(255,255,255,.88);
  outline: none;
}
.primary {
  margin-top: 14px;
  width: 100%;
  padding: 11px 12px;
  border-radius: 12px;
  border: 0;
  cursor: pointer;
  background: rgba(255,255,255,.92);
  color: #111;
  font-weight: 700;
}
.primary:disabled { opacity: .65; cursor: not-allowed; }
.row {
  margin-top: 12px;
  display: flex;
  justify-content: space-between;
}
.tip { font-size: 13px; color: rgba(255,255,255,.62); }
.link { color: rgba(255,255,255,.92); text-decoration: underline; cursor: pointer; }
</style>