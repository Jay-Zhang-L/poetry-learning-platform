<template>
  <div class="creationPage">
    <!-- 顶部大飘带 -->
    <section class="topRibbon">
      <div class="ribbonBg"></div>
      <div class="ribbonFog" aria-hidden="true"></div>

<div class="ribbonInner">

  <!-- 居中标题 -->
  <div class="ribbonLeft">
    <div class="title">诗词创作</div>
    <div class="sub">挥毫泼墨 · 书写灵感 · 传承文化</div>
  </div>

  <!-- ✅ 按钮单独拿出来 -->
  <div class="buttonRow buttonRowCorner">
    <button class="btn ghost" @click="goMyWorks">我的创作</button>
    <button class="btn primary" @click="goPublish">立即创作</button>
  </div>

  <!-- 右上角 -->
  <div class="ribbonRight">
  <button class="btn ghost" @click="refresh">刷新</button>

  <button class="btn ghost notifyBtn" @click="goNotifications">
    <span class="notifyText">消息</span>
    <span v-if="unreadCount > 0" class="notifyBadge">
      {{ unreadCount > 99 ? '99+' : unreadCount }}
    </span>
  </button>

  <div class="hotBadge" title="实时在线创作者">
    <span class="dot"></span>
    <span class="hotText">正在创作：</span>
    <span class="hotNum">{{ liveCreators.toLocaleString() }}</span>
    <span class="hotUnit">人</span>
  </div>
</div>
</div>

      <!-- 诗句展示（固定显示） -->
      <div class="poemMarquee" aria-hidden="true">
        <div class="poemContent">
          <span class="poemTitle">为你写诗</span>
          <span class="poemSeparator">·</span>
          <span class="poemText">诗词与书法相融，可以让人忘却烦扰，寻一个安住内心的地方，将灵感写给日常。 这里是你创作的专属舞台，每一首诗都值得被看见。</span>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { isLoggedIn } from '@/utils/auth';
import { showWarning } from '@/utils/toast';

const router = useRouter();
const emit = defineEmits(['refresh', 'showCreateModal']);

// 模拟数据（实际应从后端获取）
const liveCreators = ref(89);
const unreadCount = ref(8); // 未读消息数量

// 获取未读通知数
async function fetchUnreadCount() {
  if (!isLoggedIn()) return;

  try {
    const token = localStorage.getItem('token');
    if (!token) return;

    // 获取通用通知未读数
    const res = await fetch('/api/notifications/unread-count', {
      headers: { Authorization: `Bearer ${token}` }
    });
    const data = await res.json();

    let notificationCount = 0;
    if (data.code === 200) {
      notificationCount = data.data || 0;
    }

    // 获取私信未读数
    let messageCount = 0;
    try {
      const msgRes = await fetch('/api/messages/unread-count', {
        headers: { Authorization: `Bearer ${token}` }
      });
      const msgData = await msgRes.json();
      if (msgData.code === 200) {
        messageCount = msgData.data || 0;
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

function refresh() {
  // 触发父组件刷新数据
  emit('refresh');
  showWarning('刷新成功');
}

function goNotifications() {
  if (!isLoggedIn()) {
    showWarning('请先登录后查看消息通知');
    setTimeout(() => {
      router.push('/login');
    }, 2000);
    return;
  }
  router.push("/chuangzuo/notifications");
}

function goMyWorks() {
  router.push('/chuangzuo/my');
}

function goPublish() {
  // 检查登录状态
  if (!isLoggedIn()) {
    showWarning('暂未登录，请登录后进行');
    setTimeout(() => {
      router.push('/login');
    }, 2000);
    return;
  }
  // 触发父组件显示创作类型选择弹窗
  emit('showCreateModal');
}

onMounted(() => {
  fetchUnreadCount();
});
</script>

<style scoped>
.creationPage {
  width: 100%;
}

/* ============== 顶部大飘带 ============== */
.topRibbon {
  position: relative;
  margin: 0;        /* ✅ 去掉上下外边距 */
  width: 100%;      /* ✅ 撑满 */
  border-radius: 0; /* ✅ 去掉圆角 */
  overflow: hidden;
  box-shadow: none;
  border: none;
  background: rgba(255, 255, 255, 0.34);
}

.ribbonBg {
  position: absolute;
  inset: 0;
  background-image: url("@/assets/chuangzuo/dapiaodai.jpg");
  background-size: cover;
  background-position: center;
  opacity: 0.8;
  filter: saturate(0.96) contrast(0.98);
}

/* 雾气动画层 - 增强版，更明显 */
.ribbonFog {
  position: absolute;
  inset: -30px -60px;
  background:
    /* 增强雾气效果 */
    radial-gradient(circle at 30% 30%, rgba(255, 255, 255, 0.7), transparent 50%),
    radial-gradient(circle at 70% 60%, rgba(255, 255, 255, 0.5), transparent 55%);
  opacity: 0.6; /* 增加不透明度 */
  animation: fogMove 12s linear infinite; /* 加快动画速度 */
}

@keyframes fogMove {
  0% { transform: translate3d(-3%, 0, 0) scale(1.03); }
  50% { transform: translate3d(3%, -2%, 0) scale(1.06); }
  100% { transform: translate3d(-3%, 0, 0) scale(1.03); }
}

.ribbonInner {
  position: relative;
  z-index: 2;
  padding: 20px 22px 72px;
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  min-height: 150px;
  background: transparent;
  backdrop-filter: none;
}

.ribbonLeft {
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  z-index: 3;
}

.title {
  font-size: 32px;
  font-weight: 1000;
  letter-spacing: 1px;
  margin-top: 6px;
}

.sub {
  opacity: 0.78;
  margin-top: 6px;
  font-weight: 700;
}

.buttonRow {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.btn.primary {
  background: linear-gradient(135deg, #E6C078 0%, #D2AA5A 100%);
  border-color: rgba(210, 170, 90, 0.4);
  color: rgba(40, 30, 20, 0.95);
  box-shadow:
    0 4px 16px rgba(210, 170, 90, 0.25),
    0 2px 8px rgba(210, 170, 90, 0.15);
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.btn.primary:hover {
  background: linear-gradient(135deg, #E8C882 0%, #DAB25E 100%);
  border-color: rgba(210, 170, 90, 0.5);
  box-shadow:
    0 6px 20px rgba(210, 170, 90, 0.35),
    0 2px 8px rgba(210, 170, 90, 0.2),
    0 0 0 3px rgba(210, 170, 90, 0.1); /* 外发光效果 */
  transform: translateY(-2px);
}

.ribbonRight {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
  justify-content: flex-end;
  margin-left: auto;
  z-index: 4;
}

/* 通用按钮 - 优化微交互 */
.btn {
  height: 36px;
  padding: 0 16px;
  border-radius: 999px;
  border: 1px solid rgba(0, 0, 0, 0.1);
  background: rgba(255, 255, 255, 0.75);
  font-weight: 1000;
  cursor: pointer;
  transition: all 0.18s cubic-bezier(0.4, 0, 0.2, 1);
}

.btn:hover {
  background: rgba(255, 255, 255, 0.9);
  transform: translateY(-1px);
  /* 小级别阴影 */
  box-shadow:
    0 4px 12px rgba(0, 0, 0, 0.1),
    0 2px 6px rgba(0, 0, 0, 0.06);
}

.btn:active {
  transform: translateY(0);
}

.btn.ghost {
  background: rgba(255, 255, 255, 0.45);
  border-color: rgba(0, 0, 0, 0.06);
}

/* 消息通知按钮 */
.notifyBtn {
  position: relative;
  padding: 0 14px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.notifyIcon {
  font-size: 16px;
}

.notifyText {
  font-weight: 900;
}

.notifyBadge {
  position: absolute;
  top: -6px;
  right: -6px;
  min-width: 18px;
  height: 18px;
  padding: 0 5px;
  border-radius: 999px;
  background: #ff4757;
  color: white;
  font-size: 11px;
  font-weight: 900;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px solid rgba(255, 255, 255, 0.9);
  box-shadow: 0 2px 6px rgba(255, 71, 87, 0.3);
}

.hotBadge {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 6px 10px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.5);
  border: 1px solid rgba(0, 0, 0, 0.08);
}

.hotBadge .dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #4ade80;
  box-shadow: 0 0 8px #4ade80;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

.hotText {
  font-weight: 700;
  opacity: 0.8;
  font-size: 12px;
}

.hotNum {
  font-weight: 1000;
  font-size: 14px;
}

.hotUnit {
  font-weight: 700;
  opacity: 0.7;
  font-size: 11px;
}

/* 诗句展示（固定显示） */
.poemMarquee {
  position: relative;
  z-index: 2;
  padding: 12px 22px;
  border-top: 1px solid rgba(0, 0, 0, 0.06);
  background: transparent;
}

.poemContent {
  display: flex;
  align-items: center;
  gap: 8px;
  opacity: 0.65;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.poemTitle {
  font-size: 15px;
  font-weight: 900;
  letter-spacing: 0.8px;
  color: rgba(40, 60, 55, 0.85);
  flex-shrink: 0;
}

.poemSeparator {
  font-size: 15px;
  font-weight: 900;
  color: rgba(40, 60, 55, 0.6);
  flex-shrink: 0;
}

.poemText {
  font-size: 13px;
  line-height: 1.8;
  color: rgba(0, 0, 0, 0.7);
  font-weight: 500;
  letter-spacing: 0.3px;
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.title {
  font-size: 42px;
  font-weight: 1000;
  letter-spacing: 3px;
}

.sub {
  margin-top: 10px;
  font-size: 18px;
  opacity: 0.7;
  letter-spacing: 1px;
}
.buttonRowCorner {
  position: absolute;
  right: 22px;
  bottom: 16px;
  display: flex;
  gap: 10px;
  flex-wrap: nowrap;
  z-index: 4;
}
</style>
