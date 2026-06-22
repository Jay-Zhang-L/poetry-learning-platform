<template>
  <div class="shell" :class="{ 'is-paper': isPaper, 'ai-subnav-open': aiMenuOpen, 'overlay-nav': isOverlayNav }">
    <header class="topbar" :class="navThemeClass" v-show="!shouldHideNavbar">
      <div class="brand" @click="go('/home')">
        <div class="logo">诗</div>
        <div class="bt">
          <div class="bn">诗韵</div>
        </div>
      </div>

      <nav class="nav">
        <button type="button" :class="{ on: is('/home') }" @click="go('/home')">首页</button>
        <button type="button" :class="{ on: is('/learn') }" @click="go('/learn')">创作</button>
        <button type="button" :class="{ on: is('/recite') }" @click="go('/recite')">朗诵</button>

        <div
          class="dropdownNav"
          :class="{ open: libraryMenuOpen, on: isLibrarySection }"
          @mouseenter="libraryMenuOpen = true"
          @mouseleave="libraryMenuOpen = false"
        >
          <button
            type="button"
            class="dropdownTrigger"
            :class="{ on: isLibrarySection }"
            @click="toggleLibraryMenu"
          >
            藏书阁
          </button>
        </div>

        <button type="button" :class="{ on: is('/shichuang') }" @click="go('/shichuang')">诗窗</button>
        <button type="button" :class="{ on: is('/poetry-map') }" @click="go('/poetry-map')">地图</button>
        <button type="button" :class="{ on: is('/game') }" @click="go('/game')">游戏</button>
        <button
          type="button"
          class="aiTrigger"
          :class="{ on: is('/ai') }"
          @mouseenter="openAiMenu"
          @mouseleave="closeAiMenu"
          @click="go('/ai')"
        >
          会话
        </button>
      </nav>

      <!-- 下拉连接区域 - 连接顶部导航和页面内分类导航 -->
      <div
        v-show="showAiSubbar"
        class="ai-subnav-bridge"
        @mouseenter="openAiMenu"
        @mouseleave="closeAiMenu"
      ></div>

      <div class="right userEntry" @click="go('/center')">
        <div class="time">{{ now }}</div>
        <div class="userCard" :title="profile.isLoggedIn ? '进入个人中心' : '去登录'">
          <img v-if="avatarUrl" class="avatar" :src="avatarUrl" alt="头像" />
          <div v-else class="avatar placeholder">{{ avatarText }}</div>
          <div class="userName">{{ roleLabel }}</div>
        </div>
      </div>
    </header>
    <div
      v-show="!shouldHideNavbar && showLibrarySubbar"
      class="subbar"
      @mouseenter="libraryMenuOpen = true"
      @mouseleave="libraryMenuOpen = false"
    >
      <button type="button" :class="{ on: is('/library') }" @click="goLibrarySection('/library')">书库</button>
      <button type="button" :class="{ on: is('/dictionary') }" @click="goLibrarySection('/dictionary')">词典</button>
      <button type="button" :class="{ on: is('/story') }" @click="goLibrarySection('/story')">典故</button>
    </div>

    <main class="main" :class="{ full: isFullPage }">
      <RouterView />
    </main>
  </div>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useProfileStore } from "../stores/profile";

const router = useRouter();
const route = useRoute();
const profile = useProfileStore();

profile.load();

const roleLabel = computed(() => (profile.isLoggedIn ? profile.displayName : "我"));
const libraryMenuOpen = ref(false);
const aiMenuOpen = ref(false);
const avatarUrl = ref("");

const avatarText = computed(() => {
  const t = roleLabel.value || "我";
  return t.slice(0, 1).toUpperCase();
});

function resolveAvatarUrl(raw) {
  if (!raw) return "";
  if (/^https?:\/\//.test(raw)) return raw;
  if (raw.startsWith("/")) return raw;
  return `/${raw}`;
}

function go(p) {
  router.push(p);
  libraryMenuOpen.value = false;
  if (!p.startsWith("/ai")) aiMenuOpen.value = false;
}

function is(p) {
  return route.path === p || route.path.startsWith(p + "/");
}

const isLibrarySection = computed(() => {
  const p = route.path || "";
  return p.startsWith("/library") || p.startsWith("/dictionary") || p.startsWith("/story");
});
const showLibrarySubbar = computed(() => libraryMenuOpen.value);

const isAiSection = computed(() => {
  const p = route.path || "";
  return p.startsWith("/ai");
});
const showAiSubbar = computed(() => aiMenuOpen.value);

const navThemeClass = computed(() => {
  const p = route.path || "";
  if (p.startsWith("/home")) return "theme-home";
  if (p.startsWith("/library") || p.startsWith("/dictionary") || p.startsWith("/story")) return "theme-library";
  if (p.startsWith("/poetry-map")) return "theme-map";
  if (p.startsWith("/game")) return "theme-game";
  if (p.startsWith("/ai")) return "theme-ai";
  return "theme-default";
});

const isOverlayNav = computed(() => {
  const p = route.path || "";
  return (
    p.startsWith("/home") ||
    p.startsWith("/library") ||
    p.startsWith("/dictionary") ||
    p.startsWith("/story") ||
    p.startsWith("/ai")
  );
});

function toggleLibraryMenu() {
  if (!isLibrarySection.value) {
    go("/library");
    return;
  }
  libraryMenuOpen.value = !libraryMenuOpen.value;
}

function goLibrarySection(path) {
  go(path);
}

function openAiMenu() {
  if (!is("/ai")) return;
  aiMenuOpen.value = true;
  window.dispatchEvent(new CustomEvent("ai-subnav-show"));
}

function closeAiMenu() {
  if (!is("/ai")) return;
  aiMenuOpen.value = false;
  window.dispatchEvent(new CustomEvent("ai-subnav-hide"));
}

function openAiSubNav() {
  window.dispatchEvent(new CustomEvent("ai-subnav-show"));
}

function closeAiSubNav() {
  window.dispatchEvent(new CustomEvent("ai-subnav-hide"));
}

const isPaper = computed(() => {
  const p = route.path || "";
  return (
    p.startsWith("/library") ||
    p.startsWith("/game") ||
    p.startsWith("/season") ||
    p.startsWith("/forum") ||
    p.startsWith("/shichuang") ||
    p.startsWith("/splat") ||
    p.startsWith("/story") ||
    p.startsWith("/center") ||
    p.startsWith("/chuangzuo") ||
    p.startsWith("/author") ||
    p.startsWith("/chat") ||
    p.startsWith("/ai")
  );
});

const isFullPage = computed(() => {
  const p = route.path || "";
  return (
    p.startsWith("/library") ||
    p.startsWith("/dictionary") ||
    p.startsWith("/shichuang") ||
    p.startsWith("/splat") ||
    p.startsWith("/story") ||
    p.startsWith("/poetry-map") ||
    p.startsWith("/ai") ||
    p.startsWith("/recite") ||
    p.startsWith("/learn") ||
    p.startsWith("/game") ||
    p.startsWith("/center")
  );
});

const shouldHideNavbar = computed(() => {
  return route.meta?.fullscreen || false;
});

const now = ref("");
let t = null;

function tick() {
  const d = new Date();
  const pad = (n) => String(n).padStart(2, "0");
  now.value = `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}  ${pad(d.getHours())}:${pad(
    d.getMinutes()
  )}:${pad(d.getSeconds())}`;
}

onMounted(() => {
  try {
    const userStr = localStorage.getItem("user");
    if (userStr) {
      const user = JSON.parse(userStr);
      avatarUrl.value = resolveAvatarUrl(user.avatarUrl || user.avatar || "");
    }
  } catch {}
  tick();
  t = setInterval(tick, 1000);

  window.addEventListener("ai-subnav-enter", openAiMenu);
  window.addEventListener("ai-subnav-leave", closeAiMenu);
});

onUnmounted(() => {
  if (t) clearInterval(t);
  window.removeEventListener("ai-subnav-enter", openAiMenu);
  window.removeEventListener("ai-subnav-leave", closeAiMenu);
});
</script>

<style scoped>
.shell {
  min-height: 100vh;
  background: #f5f3ef;
  color: #222;
  width: 100%;
  margin: 0;
  padding: 0;
}

.shell.is-paper {
  background: transparent !important;
}

.topbar {
  --nav-bg: linear-gradient(90deg, rgba(20, 19, 21, 0.78), rgba(37, 31, 27, 0.72), rgba(10, 50, 66, 0.72));
  --nav-border: rgba(146, 118, 70, 0.34);
  --nav-ink: rgba(248, 245, 239, 0.96);
  --nav-muted: rgba(232, 222, 205, 0.8);
  --nav-accent: #d9b16f;
  --nav-topline: rgba(255, 255, 255, 0.2);
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 26px;
  padding: 0;
  background: var(--nav-bg);
  border-bottom: 1px solid var(--nav-border);
  box-shadow: 0 1px 0 rgba(255, 255, 255, 0.18) inset;
  backdrop-filter: blur(6px) saturate(108%);
  -webkit-backdrop-filter: blur(6px) saturate(108%);
  position: sticky;
  top: 0;
  z-index: 50;
  width: 100%;
  margin: 0;
  box-sizing: border-box;
}

.shell.overlay-nav .topbar {
  position: fixed;
  left: 0;
  right: 0;
}

.topbar::before {
  content: "";
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  height: 1px;
  background: var(--nav-topline);
}

.brand {
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
  user-select: none;
  flex-shrink: 0;
  padding-left: 24px;
}

.logo {
  width: 40px;
  height: 40px;
  background: #8f2a21;
  color: #fff;
  display: grid;
  place-items: center;
  font-size: 18px;
  font-weight: 700;
}

.bt {
  line-height: 1.1;
}

.bn {
  font-size: 16px;
  font-weight: 700;
  color: #f5f1e8;
  letter-spacing: 0.12em;
}

.bs {
  margin-top: 4px;
  font-size: 12px;
  color: #8f8a80;
}

.nav {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 24px;
  flex: 1;
  min-width: 0;
}

.nav button {
  height: 64px;
  padding: 0 2px;
  border: none;
  background: transparent;
  color: var(--nav-ink);
  font-size: 16px;
  font-weight: 500;
  letter-spacing: 0.08em;
  cursor: pointer;
  position: relative;
  white-space: nowrap;
  transition: color 0.18s ease;
}

.nav button:hover {
  color: var(--nav-accent);
}

.nav button.on {
  color: var(--nav-accent);
}

.nav button.on::after {
  content: "";
  position: absolute;
  left: 0;
  right: 0;
  bottom: 14px;
  height: 1px;
  background: var(--nav-accent);
}

.dropdownNav {
  position: relative;
  height: 64px;
}

.dropdownTrigger {
  height: 64px;
  padding: 0 2px;
  border: none;
  background: transparent;
  color: var(--nav-ink);
  font-size: 16px;
  font-weight: 500;
  letter-spacing: 0.08em;
  cursor: pointer;
  position: relative;
  white-space: nowrap;
  transition: color 0.18s ease;
}

.dropdownTrigger:hover,
.dropdownTrigger.on {
  color: var(--nav-accent);
}

.dropdownTrigger.on::after {
  content: "";
  position: absolute;
  left: 0;
  right: 0;
  bottom: 14px;
  height: 1px;
  background: var(--nav-accent);
}

.right {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-shrink: 0;
  padding-right: 24px;
}

.userEntry {
  cursor: pointer;
}

.userCard {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 4px;
  min-width: 70px;
}

.avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  object-fit: cover;
  border: 1px solid #d7c8b1;
  box-shadow: 0 2px 8px rgba(70, 42, 20, 0.08);
}

.avatar.placeholder {
  display: grid;
  place-items: center;
  background: #9f2f25;
  color: #fff;
  font-size: 14px;
  font-weight: 700;
}

.userName {
  font-size: 12px;
  color: #f2ede4;
  line-height: 1;
  max-width: 78px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.userEntry:hover .userName {
  color: var(--nav-accent);
}

.time {
  font-size: 12px;
  color: var(--nav-muted);
  white-space: nowrap;
}

.subbar {
  position: sticky;
  top: 64px;
  z-index: 49;
  height: 54px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 38px;
  background: rgba(190, 170, 138, 0.75);
  border-top: 1px solid rgba(242, 231, 210, 0.28);
  border-bottom: 1px solid rgba(127, 95, 47, 0.35);
}

/* 连接区域 - 连接顶部导航和页面内分类导航 */
.ai-subnav-bridge {
  position: fixed;
  top: 64px;
  left: 0;
  right: 0;
  height: 60px;
  z-index: 48;
  background: transparent;
  pointer-events: none;
}

.shell.overlay-nav .subbar {
  position: fixed;
  left: 0;
  right: 0;
}

.subbar button {
  border: none;
  background: transparent;
  color: #fffaf0;
  font-size: 16px;
  letter-spacing: 0.1em;
  cursor: pointer;
  position: relative;
  transition: color 0.2s ease;
}

.subbar button:hover,
.subbar button.on {
  color: #f9e0ac;
}

.subbar button.on::after {
  content: "";
  position: absolute;
  left: 0;
  right: 0;
  bottom: -10px;
  height: 1px;
  background: #f1d399;
}

.topbar.theme-home {
  --nav-bg: linear-gradient(90deg, rgba(19, 19, 20, 0.74), rgba(44, 39, 35, 0.68), rgba(14, 54, 71, 0.66));
  --nav-border: rgba(255, 255, 255, 0.14);
  --nav-ink: rgba(255, 255, 255, 0.94);
  --nav-muted: rgba(255, 255, 255, 0.72);
  --nav-accent: #d9b16f;
  --nav-topline: rgba(255, 255, 255, 0.12);
  backdrop-filter: blur(0px) saturate(106%);
  -webkit-backdrop-filter: blur(0px) saturate(106%);
}

.topbar.theme-library {
  --nav-bg: linear-gradient(90deg, rgba(18, 18, 19, 0.76), rgba(42, 37, 33, 0.7), rgba(12, 48, 63, 0.68));
  --nav-border: rgba(255, 255, 255, 0.14);
  --nav-ink: rgba(255, 255, 255, 0.94);
  --nav-muted: rgba(255, 255, 255, 0.72);
  --nav-accent: #d9b16f;
  --nav-topline: rgba(255, 255, 255, 0.12);
  backdrop-filter: blur(0px) saturate(106%);
  -webkit-backdrop-filter: blur(0px) saturate(106%);
}

.topbar.theme-map {
  --nav-bg: #f6f2e8;
  --nav-border: rgba(146, 118, 70, 0.34);
  --nav-ink: #2d241a;
  --nav-muted: #796a56;
  --nav-accent: #9f2f25;
}

.topbar.theme-game {
  --nav-bg: #f6f2e8;
  --nav-border: rgba(146, 118, 70, 0.34);
  --nav-ink: #2d241a;
  --nav-muted: #796a56;
  --nav-accent: #9f2f25;
}

.topbar.theme-ai {
  --nav-bg: linear-gradient(90deg, rgba(36, 28, 21, 0.8), rgba(66, 49, 37, 0.74), rgba(38, 35, 25, 0.72));
  --nav-border: rgba(200, 164, 104, 0.3);
  --nav-ink: rgba(248, 245, 239, 0.96);
  --nav-muted: rgba(234, 223, 204, 0.82);
  --nav-accent: #d8b06d;
}

.topbar.theme-default {
  --nav-bg: #f6f2e8;
  --nav-border: rgba(146, 118, 70, 0.34);
  --nav-ink: #2d241a;
  --nav-muted: #796a56;
  --nav-accent: #9f2f25;
}

.main {
  width: 100%;
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.shell.is-paper .main {
  padding: 0 !important;
}

.main.full {
  padding: 0 !important;
  width: 100% !important;
  max-width: none !important;
  margin: 0 !important;
}

.main :deep(.container),
.main :deep(.content),
.main :deep(.wrapper),
.main :deep(.page),
.main :deep(.page-shell),
.main :deep(.layout-main),
.main :deep(.el-main),
.main :deep(.main-wrap) {
  width: 100% !important;
  max-width: none !important;
  margin: 0 !important;
}

.main.full :deep(.container),
.main.full :deep(.content),
.main.full :deep(.wrapper),
.main.full :deep(.page),
.main.full :deep(.page-shell),
.main.full :deep(.layout-main),
.main.full :deep(.el-main),
.main.full :deep(.main-wrap) {
  width: 100% !important;
  max-width: none !important;
  margin: 0 !important;
  padding-left: 0 !important;
  padding-right: 0 !important;
}

@media (max-width: 1200px) {
  .brand {
    padding-left: 16px;
  }

  .right {
    padding-right: 16px;
  }

  .nav button,
  .dropdownTrigger {
    font-size: 14px;
  }

  .time {
    display: none;
  }

  .subbar {
    gap: 20px;
  }

  .subbar button {
    font-size: 14px;
  }
}

@media (max-width: 980px) {
  .topbar {
    height: auto;
    align-items: flex-start;
    flex-wrap: wrap;
    padding: 10px 0;
    gap: 10px;
  }

  .brand {
    padding-left: 12px;
  }

  .nav {
    order: 3;
    width: 100%;
    justify-content: flex-start;
    flex-wrap: wrap;
    padding: 0 12px;
    box-sizing: border-box;
  }

  .nav button,
  .dropdownTrigger {
    height: 42px;
    font-size: 15px;
  }

  .dropdownNav {
    height: 42px;
  }

  .nav button.on::after,
  .dropdownTrigger.on::after {
    left: 0;
    right: 0;
    bottom: 4px;
  }

  .right {
    margin-left: auto;
    padding-right: 12px;
  }

  .subbar {
    top: 102px;
    height: 44px;
    gap: 12px;
    justify-content: flex-start;
    padding: 0 12px;
    overflow-x: auto;
  }

  .subbar button {
    font-size: 13px;
    white-space: nowrap;
  }
}
</style>
