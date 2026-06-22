<!-- src/pages/Center.vue -->
<template>
  <div class="centerPage">
    <section class="hero">
      <div class="cover" :style="coverStyle"></div>
      <div class="coverShade"></div>

      <div class="heroTop">
        <button type="button" class="iconBtn" @click="needLoginThen('/chuangzuo/notifications')" title="消息">
          消息
          <span v-if="unreadCount > 0" class="msgBadge">{{ unreadCount > 99 ? '99+' : unreadCount }}</span>
        </button>
      </div>

      <div class="heroMain">
        <div class="avatarWrap" @click="needLoginThen('/center/profile')">
          <img v-if="user.avatarUrl" class="avatar" :src="user.avatarUrl" alt="" />
          <div v-else class="avatar placeholder">
            <span class="avatarText">{{ avatarText }}</span>
          </div>
        </div>

        <div class="meta">
          <div class="nameRow">
            <div class="name">
              {{ isLogin ? (user.nickname || user.username || "用户") : "我" }}
            </div>
            <span class="chip nameTag" v-if="isLogin">{{ roleLabel }}</span>
          </div>

          <div class="subRow">
            <span class="chip" v-if="isLogin && user.grade != null">年级 {{ user.grade }}</span>
            <span class="chip muted" v-if="!isLogin">登录后同步数据</span>
          </div>

          <div class="bio">
            {{ isLogin ? (userBio || "这个人很懒，还没有简介") : "登录后可查看获赞、关注、粉丝等信息" }}
          </div>
          

          <!--账号数据-->
          <div class="statsLine">
            <button type="button" class="statItem" @click="needLoginThen('/center/following')">
              <span class="num">{{ stats.followingCount }}</span>
              <span class="lbl">关注</span>
            </button>
            <span class="sep"></span>
            <button type="button" class="statItem" @click="needLoginThen('/center/followers')">
              <span class="num">{{ stats.followerCount }}</span>
              <span class="lbl">粉丝</span>
            </button>
            <span class="sep"></span>
            <button type="button" class="statItem" @click="needLoginThen('/center/liked-me')">
              <span class="num">{{ stats.likeCount }}</span>
              <span class="lbl">获赞</span>
            </button>
            <span class="sep"></span>
            <button type="button" class="statItem" @click="needLoginThen('/center/mutual-following')">
              <span class="num">{{ stats.mutualFollowCount }}</span>
              <span class="lbl">互关</span>
            </button>
          </div>

          <div class="ops">
            <button v-if="!isLogin" type="button" class="btn primary" @click="go('/login')">去登录</button>
            <template v-else>
              <button type="button" class="btn" @click="go('/center/profile')">编辑资料</button>
              <button type="button" class="btn primary" @click="go('/center/creation-stats')">笔底春秋录</button>
            </template>
          </div>
        </div>
      </div>
    </section>

    <section class="panel quickPanel">
      <div class="quickGrid">
        <button type="button" class="qItem" @click="needLoginThen('/center/conversations')">
          <div class="qIco" aria-hidden="true">
            <img src="@/assets/chuangzuo/梅花竹叶前缀.png" alt="会话" />
          </div>
          <div class="qTxt">我的会话</div>
        </button>

        <button type="button" class="qItem" @click="needLoginThen('/chuangzuo/my')">
          <div class="qIco" aria-hidden="true">
            <img src="@/assets/chuangzuo/毛笔+诗卷.png" alt="作品" />
          </div>
          <div class="qTxt">我的作品</div>
        </button>

        <button type="button" class="qItem" @click="needLoginThen('/center/fav')">
          <div class="qIco" aria-hidden="true">
            <img src="@/assets/chuangzuo/星印.png" alt="收藏" />
          </div>
          <div class="qTxt">我的收藏</div>
        </button>

        <button type="button" class="qItem" @click="needLoginThen('/center/likes')">
          <div class="qIco" aria-hidden="true">
            <img src="@/assets/chuangzuo/梅花.png" alt="点赞" />
          </div>
          <div class="qTxt">我的点赞</div>
        </button>
      </div>
    </section>

    <section class="panel listPanel">

      <div class="cell" @click="needLoginThen('/center/history')">
        <span class="cellIco" aria-hidden="true">
          <img src="@/assets/chuangzuo/梅花竹叶前缀.png" alt="" />
        </span>
        <span class="cellText">浏览历史</span>
        <span class="cellSub">查看最近浏览的内容</span>
        <span class="chev" aria-hidden="true">
          <img src="@/assets/chuangzuo/回纹箭头.png" alt="" />
        </span>
      </div>

      <div class="cell" @click="needLoginThen('/center/feedback')">
        <span class="cellIco" aria-hidden="true">
          <img src="@/assets/chuangzuo/梅花竹叶前缀.png" alt="" />
        </span>
        <span class="cellText">意见反馈</span>
        <span class="cellSub"></span>
        <span class="chev" aria-hidden="true">
          <img src="@/assets/chuangzuo/回纹箭头.png" alt="" />
        </span>
      </div>

      <div class="cell" @click="needLoginThen('/center/settings')">
        <span class="cellIco" aria-hidden="true">
          <img src="@/assets/chuangzuo/梅花竹叶前缀.png" alt="" />
        </span>
        <span class="cellText">更多设置</span>
        <span class="cellSub"></span>
        <span class="chev" aria-hidden="true">
          <img src="@/assets/chuangzuo/回纹箭头.png" alt="" />
        </span>
      </div>
    </section>

    <section class="panel" v-if="isLogin">
      <button type="button" class="logout" @click="onLogout">退出登录</button>
    </section>

    <div class="safeBottom"></div>
  </div>
</template>

<script setup>
import { computed, reactive, onMounted, ref } from "vue";
import { useRouter } from "vue-router";
import bambooBg from '@/assets/chuangzuo/竹.png';
import { useFollowRelationsStore } from '@/stores/followRelations';
import { showWarning } from "@/utils/toast";

const router = useRouter();
const followRelationsStore = useFollowRelationsStore();

const user = reactive({
  id: null,
  username: "",
  nickname: "",
  role: "",
  grade: null,
  avatarUrl: "",
  bio: "",
  coverUrl: "",
});

const stats = reactive({
  likeCount: 0,
  followingCount: 0,
  followerCount: 0,
  mutualFollowCount: 0,
});

const unreadCount = ref(0);

const token = computed(() => localStorage.getItem("token") || "");
const isLogin = computed(() => !!token.value);

const roleLabel = computed(() => ((user.role || "student").toLowerCase() === "teacher" ? "教师" : "学生"));

const avatarText = computed(() => {
  const n = user.nickname || user.username || "我";
  return n.slice(0, 1);
});

const userBio = computed(() => user.bio || "");

const coverStyle = computed(() => {
  if (user.coverUrl) return `background-image:url(${user.coverUrl});`;
  return `
    background-image:
      radial-gradient(900px 450px at 10% 30%, rgba(255,255,255,.22), transparent 60%),
      radial-gradient(700px 420px at 80% 10%, rgba(255,255,255,.18), transparent 60%),
      linear-gradient(120deg, rgba(20,22,30,.96), rgba(18,20,28,.86), rgba(20,22,30,.96));
  `;
});

function go(path) {
  router.push(path);
}

function needLoginThen(path) {
  if (!isLogin.value) {
    showWarning("暂未登录，请登录后进行");
    setTimeout(() => {
      router.push("/login");
    }, 1500);
    return;
  }
  router.push(path);
}

function onLogout() {
  localStorage.removeItem("token");
  localStorage.removeItem("user");
  localStorage.removeItem("role");
  router.replace("/home");
}

// 简单的提示函数
function showToast(message) {
  // 创建临时提示元素
  const toast = document.createElement('div');
  toast.textContent = message;
  toast.style.cssText = `
    position: fixed;
    top: 80px;
    left: 50%;
    transform: translateX(-50%);
    background: rgba(0, 0, 0, 0.8);
    color: white;
    padding: 12px 24px;
    border-radius: 8px;
    z-index: 9999;
    animation: fadeInOut 2s ease-in-out;
    font-size: 14px;
  `;

  // 添加动画样式
  if (!document.querySelector('#toast-animation')) {
    const style = document.createElement('style');
    style.id = 'toast-animation';
    style.textContent = `
      @keyframes fadeInOut {
        0%, 100% { opacity: 0; }
        20%, 80% { opacity: 1; }
      }
    `;
    document.head.appendChild(style);
  }

  document.body.appendChild(toast);

  setTimeout(() => {
    toast.remove();
  }, 2000);
}

async function loadMe() {
  if (!isLogin.value) return;

  const resp = await fetch("/api/user/me", {
    headers: { Authorization: "Bearer " + token.value },
  });

  const json = await resp.json().catch(() => null);

  if (!resp.ok || !json || json.code !== 0) {
    localStorage.removeItem("token");
    localStorage.removeItem("user");
    localStorage.removeItem("role");
    router.replace("/login");
    return;
  }

  Object.assign(user, json.data);
  localStorage.setItem("user", JSON.stringify(json.data));
  localStorage.setItem("role", json.data.role || "student");
}

async function loadStats() {
  if (!isLogin.value) return;

  const resp = await fetch("/api/user/stats", {
    headers: { Authorization: "Bearer " + token.value },
  });

  const json = await resp.json().catch(() => null);
  if (!resp.ok || !json || json.code !== 0 || !json.data) return;

  stats.likeCount = Number(json.data.likeCount || 0);
  stats.followingCount = Number(json.data.followingCount || 0);
  stats.followerCount = Number(json.data.followerCount || 0);
  stats.mutualFollowCount = Number(json.data.mutualFollowCount || 0);
}

async function loadUnreadCount() {
  if (!isLogin.value) return;

  try {
    // 获取通用通知未读数
    const resp = await fetch('/api/notifications/unread-count', {
      headers: { Authorization: "Bearer " + token.value }
    });
    const json = await resp.json();
    let notificationCount = 0;
    if (json.code === 200) {
      notificationCount = json.data || 0;
    }

    // 获取私信未读数
    let messageCount = 0;
    try {
      const msgResp = await fetch('/api/messages/unread-count', {
        headers: { Authorization: "Bearer " + token.value }
      });
      const msgJson = await msgResp.json();
      if (msgJson.code === 200) {
        messageCount = msgJson.data || 0;
      }
    } catch (e) {
      console.error('获取私信未读数失败:', e);
    }

    // 合并未读数
    unreadCount.value = notificationCount + messageCount;
  } catch (err) {
    console.error('获取未读消息数失败:', err);
  }
}

async function loadFollowRelations() {
  if (!isLogin.value) return;

  try {
    // 并行加载关注和粉丝列表数据
    const [followingRes, followersRes] = await Promise.all([
      fetch('/api/user/following?page=1&size=100', {
        headers: { Authorization: "Bearer " + token.value }
      }),
      fetch('/api/user/followers?page=1&size=100', {
        headers: { Authorization: "Bearer " + token.value }
      })
    ]);

    const followingData = await followingRes.json();
    const followersData = await followersRes.json();

    // 初始化全局状态
    followRelationsStore.initFromAPI({
      following: followingData.data || [],
      followers: followersData.data || []
    });

  } catch (e) {
    console.error('加载关注关系失败：', e);
  }
}

onMounted(() => {
  try {
    const u = JSON.parse(localStorage.getItem("user") || "null");
    if (u) Object.assign(user, u);
  } catch {}

  loadMe();
  loadStats();
  loadUnreadCount();
  loadFollowRelations();
});
</script>

<style scoped>
.centerPage {
  min-height: 100vh;
  position: relative;
  background: var(--bg0);
  color: var(--text);
}

/* 水墨晕染 + 浅竹纹质感 */
.centerPage::before {
  content: "";
  position: fixed;
  inset: 0;
  background-image: url("@/assets/chuangzuo/竹.png");
  background-size: 25%;
  background-repeat: repeat;
  opacity: 0.08;
  pointer-events: none;
  z-index: -3;
}

/* 水墨晕染渐变层 */
.centerPage::after {
  content: "";
  position: fixed;
  inset: 0;
  background:
    radial-gradient(1200px 700px at 20% 10%, rgba(140, 170, 160, 0.12), transparent 60%),
    radial-gradient(900px 500px at 80% 20%, rgba(180, 200, 220, 0.08), transparent 55%),
    radial-gradient(1000px 600px at 50% 90%, rgba(230, 220, 190, 0.15), transparent 55%);
  pointer-events: none;
  z-index: -2;
}

.hero {
  position: relative;
  height: 360px;
  overflow: visible;
  margin: 0;
  width: 100%;
  z-index: 2
}

@media (max-width: 768px) {
  .hero { height: 320px }
}

@media (max-width: 480px) {
  .hero { height: 280px }
}

/* 用户信息区 */
.heroMain {
  position: relative;
  z-index: 2;
  display: grid;
  grid-template-columns: auto 1fr;
  gap: 16px;
  padding: 24px 48px;
  align-items: center;
  pointer-events: auto;
  justify-content: start;
  width: 100%;
  margin: 0
}

@media (min-width: 1600px) {
  .heroMain { padding: 24px 64px }
}

@media (min-width: 1200px) and (max-width: 1599px) {
  .heroMain { padding: 24px 56px }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .heroMain { padding: 20px 32px }
}

@media (max-width: 767px) {
  .heroMain {
    padding: 20px;
    grid-template-columns: 1fr;
    gap: 20px;
    text-align: center
  }
}

/* 关键：封面层不吃点击，否则你上面的按钮/编辑/统计都点不了 */
.cover,
.coverShade {
  pointer-events: none;
}

.cover {
  position: absolute;
  inset: 0;
  background-size: cover;
  background-position: center;
  transform: scale(1.02);
  filter: saturate(0.95) brightness(0.95);
}

.coverShade {
  position: absolute;
  inset: 0;
  background: transparent;
}

.heroTop {
  position: relative;
  z-index: 2;
  padding: 16px 48px 0;
  display: flex;
  justify-content: flex-end;
  gap: 8px
}

@media (min-width: 1600px) {
  .heroTop { padding: 16px 64px 0 }
}

@media (min-width: 1200px) and (max-width: 1599px) {
  .heroTop { padding: 16px 56px 0 }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .heroTop { padding: 14px 32px 0 }
}

@media (max-width: 767px) {
  .heroTop { padding: 12px 16px 0 }
}

.iconBtn {
  position: relative;
  height: 36px;
  padding: 0 14px;
  border-radius: 999px;
  border: 1px solid rgba(247, 215, 108, 0.3);
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(8px);
  color: rgba(255, 255, 255, 0.95);
  cursor: pointer;
  font-weight: 800;
  font-size: 13px;
  display: flex;
  align-items: center;
  transition: all 0.3s ease;
}

.iconBtn:hover {
  background: rgba(255, 255, 255, 0.3);
  border-color: rgba(244, 205, 79, 0.5);
  transform: translateY(-1px);
}

.msgBadge {
  position: absolute;
  top: -4px;
  right: -4px;
  min-width: 18px;
  height: 18px;
  padding: 0 5px;
  border-radius: 999px;
  background: linear-gradient(135deg, #ff6b6b, #ff4757);
  color: white;
  font-size: 11px;
  font-weight: 900;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px solid rgba(255, 255, 255, 0.9);
  box-shadow: 0 2px 8px rgba(255, 71, 87, 0.4);
}

.avatarWrap {
  width: 100px;
  height: 100px;
  border-radius: 999px;
  overflow: hidden;
  cursor: pointer;
  border: 2px solid rgba(212, 175, 55, 0.4);
  box-shadow: 0 4px 12px rgba(212, 175, 55, 0.2);
  background: rgba(255, 255, 255, 0.9);
  position: relative;
  margin-top: -30px;
  z-index: 3;
  transition: all 0.3s ease;
}

@media (min-width: 768px) and (max-width: 1199px) {
  .avatarWrap {
    width: 110px;
    height: 110px
  }
}

@media (min-width: 1200px) {
  .avatarWrap {
    width: 120px;
    height: 120px;
    border-width: 3px
  }
}

@media (min-width: 1600px) {
  .avatarWrap {
    width: 130px;
    height: 130px
  }
}

@media (max-width: 767px) {
  .avatarWrap {
    width: 90px;
    height: 90px;
    margin-top: -20px
  }
}

.avatarWrap:hover {
  transform: scale(1.05);
  box-shadow: 0 6px 16px rgba(212, 175, 55, 0.3)
}

/* 印章效果 */
.avatarWrap::after {
  content: "诗";
  position: absolute;
  bottom: 2px;
  right: 2px;
  width: 24px;
  height: 24px;
  border-radius: 4px;
  background: rgba(212, 175, 55, 0.2);
  color: #3a2e2b;
  font-size: 12px;
  font-weight: 900;
  display: grid;
  place-items: center;
  border: 1px solid rgba(212, 175, 55, 0.3);
}

/* 印章效果 */
.avatarWrap::after {
  content: "诗";
  position: absolute;
  bottom: 2px;
  right: 2px;
  width: 24px;
  height: 24px;
  border-radius: 4px;
  background: rgba(212, 175, 55, 0.2);
  color: #3a2e2b;
  font-size: 12px;
  font-weight: 900;
  display: grid;
  place-items: center;
  border: 1px solid rgba(212, 175, 55, 0.3);
}

.avatar {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar.placeholder {
  display: grid;
  place-items: center;
  background: rgba(212, 175, 55, 0.1);
}

.avatarText {
  font-weight: 900;
  font-size: 28px;
  color: #4a3b36;
}

@media (min-width: 1200px) {
  .avatarText {
    font-size: 32px
  }
}

@media (min-width: 1600px) {
  .avatarText {
    font-size: 36px
  }
}

.meta { min-width: 0; color: #3a2e2b; margin-top: -20px; }
.nameRow { display: flex; align-items: center; gap: 12px; margin-bottom: 8px; }
.name {
  font-size: 20px;
  font-weight: 900;
  letter-spacing: 1px;
  color: #3a2e2b;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

@media (min-width: 1200px) {
  .name {
    font-size: 24px;
    letter-spacing: 2px
  }
}

@media (min-width: 1600px) {
  .name {
    font-size: 28px
  }
}
.nameTag {
  flex-shrink: 0;
  font-size: 12px;
  padding: 4px 10px;
  border-radius: 12px;
  background: linear-gradient(135deg, #f2e9d2, #e6c288);
  color: #3a2e2b;
  border: 1px solid rgba(212, 175, 55, 0.2);
  font-weight: 700;
}
.editBtn {
  border: 1px solid rgba(212, 175, 55, 0.3);
  background: rgba(255, 255, 255, 0.6);
  color: #4a3b36;
  border-radius: 999px;
  padding: 6px 12px;
  cursor: pointer;
  font-weight: 800;
  font-size: 12px;
  transition: all 0.3s ease;
}

.editBtn:hover {
  background: linear-gradient(135deg, rgba(242, 233, 210, 0.8), rgba(230, 194, 136, 0.6));
  border-color: rgba(212, 175, 55, 0.5);
}

.subRow { margin-top: 8px; display: flex; gap: 8px; flex-wrap: wrap; }
.chip {
  font-size: 12px;
  padding: 4px 10px;
  border-radius: 12px;
  background: linear-gradient(135deg, #f2e9d2, #e6c288);
  color: #3a2e2b;
  border: 1px solid rgba(212, 175, 55, 0.2);
  font-weight: 700;
}
.chip.muted {
  background: rgba(255,255,255,.10);
  border-color: rgba(255,255,255,.12);
  color: rgba(255,255,255,.80);
}

.bio {
  margin-top: 10px;
  font-size: 13px;
  color: #4a3b36;
  line-height: 1.6;
  max-width: 560px;
  opacity: 0.85;
}

@media (min-width: 1200px) {
  .bio {
    font-size: 14px;
    max-width: 680px
  }
}

@media (min-width: 1600px) {
  .bio {
    font-size: 15px;
    max-width: 800px
  }
}

.statsLine {
  margin-top: 16px;
  display: flex;
  align-items: center;
  gap: 24px;
  padding: 0;
  flex-wrap: wrap;
}

@media (max-width: 767px) {
  .statsLine {
    gap: 12px;
    justify-content: center
  }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .statsLine {
    gap: 16px
  }
}

@media (min-width: 1200px) {
  .statsLine {
    gap: 32px;
    margin-top: 20px
  }
}

@media (min-width: 1600px) {
  .statsLine {
    gap: 40px
  }
}

.statItem {
  border: 0;
  background: transparent;
  color: #4a3b36;
  cursor: pointer;
  display: inline-flex;
  align-items: baseline;
  gap: 6px;
  padding: 0;
  transition: all 0.3s ease;
}

.statItem:hover {
  transform: translateY(-2px);
}

.statItem .num {
  font-weight: 900;
  font-size: 22px;
  color: #d4af37;
}

@media (max-width: 767px) {
  .statItem .num {
    font-size: 18px
  }
}

@media (min-width: 1200px) {
  .statItem .num {
    font-size: 26px
  }
}

@media (min-width: 1600px) {
  .statItem .num {
    font-size: 30px
  }
}

.statItem .lbl {
  font-size: 13px;
  color: #9d8b7a;
  font-weight: 700;
}

@media (min-width: 1200px) {
  .statItem .lbl {
    font-size: 14px
  }
}

.sep {
  width: 1px;
  height: 20px;
  background: rgba(212, 175, 55, 0.3);
}

.ops { margin-top: 16px; display: flex; gap: 10px; flex-wrap: wrap; }

.btn {
  border-radius: 12px;
  padding: 9px 16px;
  border: 1px solid rgba(212, 175, 55, 0.3);
  background: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  font-weight: 900;
  color: #4a3b36;
  transition: all 0.3s ease;
}

@media (min-width: 1200px) {
  .btn {
    padding: 10px 20px;
    font-size: 14px
  }
}

.btn:hover {
  background: linear-gradient(135deg, rgba(242, 233, 210, 0.8), rgba(248, 222, 179, 0.6));
  border-color: rgba(212, 175, 55, 0.5);
  transform: translateY(-1px);
}

.btn.primary {
  background: linear-gradient(135deg, #efe8dc, #f0ece0);
  color: rgb(67, 8, 8);
  border-color: rgba(52, 43, 13, 0.4);
}

.btn.ghost {
  background: transparent;
  border-color: rgba(212, 175, 55, 0.2);
}

.panel {
  width: 100%;
  margin: 20px 0 0;
  border-radius: 16px;
  background: rgba(253, 249, 242, 0.9);
  border: 1px solid rgba(212, 175, 55, 0.2);
  box-shadow: 0 4px 16px rgba(212, 175, 55, 0.08);
  backdrop-filter: blur(12px);
  position: relative;
  z-index: 2;
}

@media (min-width: 1600px) {
  .panel {
    margin: 24px 0 0
  }
}

/* 鎏金虚线分隔不同模块 */
.panel + .panel::before {
  content: "";
  position: absolute;
  top: -10px;
  left: 20px;
  right: 20px;
  height: 1px;
  background: none;
  border-top: 1px dashed rgba(212, 175, 55, 0.2);
}

.quickPanel { padding: 20px; }

@media (min-width: 1600px) {
  .quickPanel { padding: 24px 64px }
}

@media (min-width: 1200px) and (max-width: 1599px) {
  .quickPanel { padding: 24px 56px }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .quickPanel { padding: 20px 32px }
}

@media (max-width: 767px) {
  .quickPanel { padding: 20px 16px }
}

.quickGrid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

@media (min-width: 1200px) {
  .quickGrid {
    grid-template-columns: repeat(4, 1fr);
    gap: 20px
  }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .quickGrid {
    grid-template-columns: repeat(4, 1fr)
  }
}

.qItem {
  border: 1px solid rgba(212, 175, 55, 0.2);
  background: rgba(255, 255, 255, 0.6);
  cursor: pointer;
  padding: 16px;
  border-radius: 16px;
  display: flex;
  align-items: center;
  gap: 12px;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden
}

.qItem::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: linear-gradient(180deg, #d4af37, #b8860b);
  opacity: 0;
  transition: opacity 0.3s ease
}

.qItem:hover::before {
  opacity: 1
}

.qItem:hover {
  background: rgba(253, 249, 242, 0.95);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(212, 175, 55, 0.15);
}

.qIco {
  width: 40px;
  height: 40px;
  border-radius: 12px;
  background: rgba(212, 175, 55, 0.1);
  border: 1px solid rgba(212, 175, 55, 0.2);
  display: grid;
  place-items: center;
  flex-shrink: 0;
  position: relative;
  overflow: hidden;
}

.qIco img {
  width: 24px;
  height: 24px;
  object-fit: contain;
}

.qTxt {
  font-size: 14px;
  color: #4a3b36;
  font-weight: 700;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  text-align: left;
}

.listPanel {
  overflow: hidden;
  padding: 0;
}

.cell {
  display: grid;
  grid-template-columns: 24px 1fr auto 24px;
  gap: 12px;
  align-items: center;
  padding: 16px 20px;
  cursor: pointer;
  transition: all 0.3s ease;
  border-bottom: 1px dashed rgba(212, 175, 55, 0.15);
  position: relative;
}

.cell:last-child {
  border-bottom: none;
}

.cell:hover {
  background: rgba(253, 249, 242, 0.8);
  transform: translateX(2px);
}

.cellIco {
  width: 20px;
  height: 20px;
  display: grid;
  place-items: center;
  position: relative;
}

.cellIco img {
  width: 16px;
  height: 16px;
  object-fit: contain;
  opacity: 0.6;
}

.cellText {
  font-size: 15px;
  color: #4a3b36;
  font-weight: 700;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

.cellSub {
  font-size: 13px;
  color: #9d8b7a;
}

.chev {
  width: 12px;
  height: 12px;
  display: grid;
  place-items: center;
}

.chev img {
  width: 12px;
  height: 12px;
  object-fit: contain;
  opacity: 0.5;
}

.logout {
  width: 100%;
  padding: 14px;
  border-radius: 24px;
  border: none;
  background: linear-gradient(135deg, #f2d7a8, #efdea7);
  color: #2e2626;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  font-size: 16px;
  font-weight: 900;
  cursor: pointer;
  box-shadow: 0 4px 12px rgba(212, 175, 55, 0.2);
  transition: all 0.3s ease;
}

.logout:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 16px rgba(212, 175, 55, 0.3);
}

.logout:active {
  transform: translateY(0);
  box-shadow: 0 2px 8px rgba(212, 175, 55, 0.2);
}

.safeBottom { height: 24px; }
</style>