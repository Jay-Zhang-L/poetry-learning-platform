<template>
  <div class="page">
    <header class="head">
      <button class="back" type="button" @click="back">返回</button>
      <div class="title">设置</div>
      <div></div>
    </header>

    <section class="panel">
      <div class="cell" @click="go('/center/profile')">
        <span class="t">个人资料</span>
        <span class="s">编辑头像、封面、昵称、简介</span>
        <span class="chev"></span>
      </div>

      <div class="cell" @click="toggle('privacyHistory')">
        <span class="t">隐私：历史记录仅自己可见</span>
        <span class="s">{{ settings.privacyHistory ? "已开启" : "未开启" }}</span>
        <span class="chev"></span>
      </div>

      <div class="cell" @click="toggle('privacyFav')">
        <span class="t">隐私：收藏仅自己可见</span>
        <span class="s">{{ settings.privacyFav ? "已开启" : "未开启" }}</span>
        <span class="chev"></span>
      </div>
    </section>

    <section class="panel">
      <button class="dangerBtn" type="button" @click="logout">退出登录</button>
    </section>

    <div class="space"></div>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive } from "vue";
import { useRouter } from "vue-router";

const router = useRouter();
const token = computed(() => localStorage.getItem("token") || "");

const settings = reactive({
  privacyHistory: false,
  privacyFav: false,
});

function back() { router.back(); }
function go(p) { router.push(p); }

function loadLocal() {
  try {
    const s = JSON.parse(localStorage.getItem("userSettings") || "null");
    if (s) Object.assign(settings, s);
  } catch {}
}

function saveLocal() {
  localStorage.setItem("userSettings", JSON.stringify(settings));
}

function toggle(k) {
  settings[k] = !settings[k];
  saveLocal();
}

function logout() {
  localStorage.removeItem("token");
  localStorage.removeItem("user");
  localStorage.removeItem("role");
  router.replace("/login");
}

onMounted(() => {
  if (!token.value) return router.replace("/login");
  loadLocal();
});
</script>

<style scoped>
.page { min-height:100vh; padding:14px; background: var(--bg0); }
.head{
  width:min(1080px, calc(100vw - 28px));
  margin:0 auto 12px;
  display:grid; grid-template-columns:70px 1fr 70px;
  gap:10px; align-items:center;
}
.back{
  height:36px;border-radius:12px;border:1px solid rgba(0,0,0,.10);
  background:rgba(255,255,255,.75);cursor:pointer;font-weight:900;
}
.title{ text-align:center;font-weight:1000;letter-spacing:1px;color:rgba(0,0,0,.78); }
.panel{
  width:min(1080px, calc(100vw - 28px));
  margin:0 auto 14px;
  border-radius:16px;background:rgba(255,255,255,.70);
  border:1px solid rgba(0,0,0,.08);
  box-shadow:0 18px 40px rgba(0,0,0,.08);
  overflow:hidden;
}
.cell{
  display:grid;
  grid-template-columns: 1fr auto 14px;
  gap: 10px;
  align-items:center;
  padding: 14px 14px;
  cursor:pointer;
}
.cell + .cell{ border-top: 1px solid rgba(0,0,0,.06); }
.cell:hover{ background: rgba(0,0,0,.02); }
.t{ font-weight:1000; color: rgba(0,0,0,.80); }
.s{ font-size:12px; color: rgba(0,0,0,.52); }
.chev{
  width:10px;height:10px;
  border-right:2px solid rgba(0,0,0,.35);
  border-bottom:2px solid rgba(0,0,0,.35);
  transform: rotate(-45deg);
}
.dangerBtn{
  width:100%;
  height:44px;
  border:0;
  background: rgba(255,60,60,.10);
  color: rgba(160,0,0,.92);
  cursor:pointer;
  font-weight:1000;
}
.space{ height:18px; }
</style>