<template>
  <div class="notificationsPage">
    <div class="container">
      <!-- 顶部栏 -->
      <header class="topbar">
        <button class="backBtn" @click="goBack">
          <svg viewBox="0 0 24 24" aria-hidden="true">
            <path d="M15 18l-6-6 6-6" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          <span>返回</span>
        </button>
        <div class="title">互动消息</div>
        <button class="markBtn" @click="markAllRead" v-if="unreadCount > 0">
          全部已读
        </button>
        <div v-else style="width: 80px;"></div>
      </header>

      <!-- 筛选标签 -->
      <section class="filterTabs">
        <button 
          v-for="filter in filters" 
          :key="filter.key"
          class="filterTab"
          :class="{ active: activeFilter === filter.key }"
          @click="switchFilter(filter.key)"
        >
          {{ filter.label }}
          <span v-if="filter.count > 0" class="badge">{{ filter.count }}</span>
        </button>
      </section>

      <!-- 通知列表 -->
      <section v-if="loading && notifications.length === 0" class="skeletonList">
        <div v-for="i in 6" :key="i" class="skCard">
          <div class="skRow">
            <div class="skAvatar"></div>
            <div class="skLine w70"></div>
          </div>
          <div class="skLine w85"></div>
        </div>
      </section>

      <section v-else-if="notifications.length > 0" class="notifList">
        <article 
          v-for="notif in notifications" 
          :key="notif.id"
          class="notifCard"
          :class="{ unread: !notif.read }"
          @click="handleNotifClick(notif)"
        >
          <div class="notifIcon" :class="notif.type">
            <span v-if="notif.type === 'like'">❤️</span>
            <span v-else-if="notif.type === 'comment'">💬</span>
            <span v-else-if="notif.type === 'mention'">@</span>
            <span v-else-if="notif.type === 'message'">📩</span>
            <span v-else-if="notif.type === 'follow'">➕</span>
            <span v-else-if="notif.type === 'favorite'">⭐</span>
          </div>

          <div class="notifContent">
            <div class="notifHeader">
              <img :src="notif.user.avatar" class="avatar" />
              <div class="userInfo">
                <span class="userName">{{ notif.user.name }}</span>
                <span class="notifAction">{{ getActionText(notif.type) }}</span>
              </div>
              <span class="notifTime">{{ formatTime(notif.createdAt) }}</span>
            </div>
            <div class="notifBody">
              <div v-if="notif.content" class="notifText">{{ notif.content }}</div>
              <div v-if="notif.work" class="workPreview">
                <div class="workTitle">{{ notif.work.title }}</div>
                <div class="workExcerpt">{{ notif.work.excerpt }}</div>
              </div>
            </div>
          </div>
          <div v-if="!notif.read" class="unreadDot"></div>
        </article>
      </section>

      <section v-else class="empty">
        <div class="emptyIcon">🔔</div>
        <div class="emptyTitle">暂无消息</div>
        <div class="emptyDesc">当有人点赞、评论或@你时，会在这里显示</div>
      </section>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';
import { useProfileStore } from '@/stores/profile';
import { checkLoginStatus } from '@/utils/auth';

const router = useRouter();
const profileStore = useProfileStore();

// 获取token
const token = computed(() => localStorage.getItem("token") || "");

const filters = [
  { key: 'all', label: '全部', count: 0 },
  { key: 'like', label: '点赞', count: 0 },
  { key: 'comment', label: '评论', count: 0 },
  { key: 'mention', label: '@我', count: 0 },
  { key: 'message', label: '私信', count: 0 },
  { key: 'follow', label: '关注', count: 0 },
  { key: 'favorite', label: '收藏', count: 0 },
];

const activeFilter = ref('all');
const loading = ref(false);
const notifications = ref([]);

const unreadCount = computed(() => {
  return notifications.value.filter(n => !n.read).length;
});

function getActionText(type) {
  const actions = {
    like: '赞了你的作品',
    comment: '评论了你的作品',
    mention: '在作品中@了你',
    message: '给您发来了一条私信',
    follow: '关注了你',
    favorite: '收藏了你的作品',
  };
  return actions[type] || '';
}

function formatTime(v) {
  if (!v) return '刚刚';
  const d = new Date(v);
  const now = new Date();
  const diff = now - d;
  
  const minute = 60 * 1000;
  const hour = 60 * minute;
  const day = 24 * hour;
  
  if (diff < minute) return '刚刚';
  if (diff < hour) return `${Math.floor(diff / minute)}分钟前`;
  if (diff < day) return `${Math.floor(diff / hour)}小时前`;
  if (diff < 7 * day) return `${Math.floor(diff / day)}天前`;
  
  const pad = (n) => (n < 10 ? '0' + n : '' + n);
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
}

async function fetchNotifications() {
  loading.value = true;
  try {
    // 获取通知列表
    const res = await fetch(`/api/notifications?type=${activeFilter.value}`, {
      headers: {
        'Authorization': `Bearer ${token.value}`,
        'Content-Type': 'application/json'
      }
    });
    const data = await res.json();
    
    if (data.code === 200) {
      const list = data.data?.list || [];
      notifications.value = list.map(n => ({
        id: n.id,
        type: n.type,
        read: n.isRead,
        user: {
          id: n.fromUserId, // 添加发送者ID用于跳转
          name: n.fromUserName,
          avatar: n.fromUserAvatar || 'https://via.placeholder.com/40'
        },
        content: n.content,
        work: n.workTitle ? {
          id: n.targetId,
          title: n.workTitle,
          excerpt: n.workExcerpt
        } : null,
        createdAt: new Date(n.createdAt)
      }));
    }
    
    // 获取各类型未读数
    const countRes = await fetch('/api/notifications/unread-count-by-type', {
      headers: {
        'Authorization': `Bearer ${token.value}`,
        'Content-Type': 'application/json'
      }
    });
    const countData = await countRes.json();
    
    if (countData.code === 200) {
      const counts = countData.data;
      filters[0].count = counts.all || 0;
      filters[1].count = counts.like || 0;
      filters[2].count = counts.comment || 0;
      filters[3].count = counts.mention || 0;
      filters[4].count = counts.message || 0;
      filters[5].count = counts.follow || 0;
      filters[6].count = counts.favorite || 0;
    }
  } catch (e) {
    console.error('获取通知失败：', e);
  } finally {
    loading.value = false;
  }
}

async function switchFilter(key) {
  activeFilter.value = key;
  await fetchNotifications();
}

async function handleNotifClick(notif) {
  // 已读通知直接跳转
  if (notif.read) {
    navigateToTarget(notif);
    return;
  }

  // 未读通知：先标记已读，设置 100ms 超时
  try {
    const markReadPromise = fetch(`/api/notifications/${notif.id}/read`, {
      method: 'PUT',
      headers: {
        'Authorization': `Bearer ${token.value}`,
        'Content-Type': 'application/json'
      }
    }).then(res => res.json());

    // 等待 API 响应，最多等 100ms
    const timeoutPromise = new Promise(resolve => setTimeout(resolve, 100));

    const data = await Promise.race([markReadPromise, timeoutPromise]);

    // 如果 API 在 100ms 内返回，更新状态
    if (data && data.code === 200) {
      notif.read = true;
      filters.forEach(f => {
        if (f.key === 'all' || f.key === notif.type) {
          f.count = Math.max(0, f.count - 1);
        }
      });
    }
  } catch (e) {
    console.error('标记已读失败：', e);
  }

  // 无论如何都跳转
  navigateToTarget(notif);
}

function navigateToTarget(notif) {
  if (notif.type === 'message') {
    // 私信通知跳转到聊天页面
    router.push(`/chat/${notif.user.id}`);
  } else if (notif.type === 'follow') {
    // 关注通知跳转到用户主页
    router.push(`/author/${notif.user.id}`);
  } else if (notif.work) {
    // 其他通知跳转到相关作品
    router.push(`/chuangzuo/${notif.work.id}`);
  }
}

function markAllRead() {
  fetch('/api/notifications/read-all', {
    method: 'PUT',
    headers: {
      'Authorization': `Bearer ${token.value}`,
      'Content-Type': 'application/json'
    }
  }).then(res => res.json()).then(data => {
    if (data.code === 200) {
      notifications.value.forEach(n => n.read = true);
      filters.forEach(f => f.count = 0);
    }
  }).catch(e => console.error('标记全部已读失败：', e));
}

function goBack() {
  router.back();
}

onMounted(() => {
  // 页面加载时检查登录状态
  if (!checkLoginStatus(router)) {
    return;
  }
  
  // 加载profile store
  profileStore.load();
  
  fetchNotifications();
});
</script>


<style scoped>
.notificationsPage {
  min-height: 100vh;
  position: relative;
  background:
    radial-gradient(1200px 800px at 20% 10%, rgba(180, 200, 220, 0.08), transparent 60%),
    radial-gradient(900px 600px at 80% 20%, rgba(230, 220, 190, 0.12), transparent 55%),
    linear-gradient(135deg, #fdfbf7, #f5f3ef);
  padding: 0 0 40px
}

.notificationsPage::before {
  content: "";
  position: fixed;
  inset: 0;
  background: url("@/assets/chuangzuo/竹.png");
  background-size: 25%;
  opacity: 0.06;
  pointer-events: none;
  z-index: -3
}

.container {
  max-width: none;
  width: 100%;
  margin: 0;
  padding: 0 48px;
  position: relative;
  z-index: 1
}

@media (min-width: 1600px) {
  .container { padding: 0 64px }
}

@media (min-width: 1200px) and (max-width: 1599px) {
  .container { padding: 0 56px }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .container { padding: 0 32px }
}

@media (max-width: 767px) {
  .container { padding: 0 16px }
}

/* 顶部栏 */
.topbar {
  position: sticky;
  top: 0;
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24px 0 16px;
  background: linear-gradient(180deg, rgba(253,251,247,0.98), rgba(253,251,247,0.95), rgba(253,251,247,0));
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(212,175,55,0.1);
  margin-bottom: 24px
}

@media (min-width: 1600px) {
  .topbar { padding: 28px 0 20px }
}

@media (max-width: 767px) {
  .topbar { padding: 16px 0 }
}

.backBtn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  border-radius: 12px;
  border: 1px solid rgba(212,175,55,0.3);
  background: linear-gradient(135deg, rgba(253,249,242,0.9), rgba(246,240,230,0.8));
  cursor: pointer;
  font-weight: 900;
  color: #4a3b36;
  transition: all 0.3s ease;
  font-size: 14px
}

.backBtn:hover {
  background: linear-gradient(135deg, rgba(242,233,210,0.9), rgba(230,194,136,0.8));
  border-color: rgba(212,175,55,0.5);
  transform: translateY(-1px)
}

.backBtn svg {
  width: 18px;
  height: 18px
}

.title {
  font-size: 24px;
  font-weight: 900;
  letter-spacing: 2px;
  color: #3a2e2b;
  font-family: "思源宋体", "STSong", "SimSun", serif
}

@media (max-width: 768px) {
  .title { font-size: 20px }
}

.markBtn {
  padding: 10px 20px;
  border-radius: 12px;
  border: 1px solid rgba(212,175,55,0.3);
  background: linear-gradient(135deg, rgba(253,249,242,0.9), rgba(246,240,230,0.8));
  font-size: 14px;
  font-weight: 900;
  cursor: pointer;
  color: #4a3b36;
  transition: all 0.3s ease
}

.markBtn:hover {
  background: linear-gradient(135deg, rgba(242,233,210,0.9), rgba(230,194,136,0.8));
  border-color: rgba(212,175,55,0.5);
  transform: translateY(-1px)
}

/* 筛选标签 */
.filterTabs {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
  overflow-x: auto;
  scrollbar-width: none;
  -ms-overflow-style: none
}

.filterTabs::-webkit-scrollbar {
  display: none
}

.filterTab {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 12px 24px;
  border-radius: 999px;
  border: 1px solid rgba(212,175,55,0.3);
  background: linear-gradient(135deg, rgba(253,249,242,0.9), rgba(246,240,230,0.8));
  font-size: 14px;
  font-weight: 900;
  cursor: pointer;
  color: #4a3b36;
  transition: all 0.3s ease;
  white-space: nowrap
}

.filterTab:hover {
  background: linear-gradient(135deg, rgba(242,233,210,0.9), rgba(230,194,136,0.8));
  border-color: rgba(212,175,55,0.5);
  transform: translateY(-1px)
}

.filterTab.active {
  background: linear-gradient(135deg, #e6c288, #d4af37);
  color: #fff;
  border-color: rgba(212,175,55,0.4)
}

.badge {
  min-width: 20px;
  height: 20px;
  padding: 0 6px;
  border-radius: 999px;
  background: linear-gradient(135deg, #e6c288, #d4af37);
  color: #fff;
  font-size: 11px;
  font-weight: 900;
  display: grid;
  place-items: center;
  border: 1px solid rgba(255,255,255,0.3)
}

/* 通知列表 */
.notifList {
  display: grid;
  gap: 16px;
  padding: 16px 0
}

.notifCard {
  position: relative;
  display: flex;
  gap: 16px;
  padding: 20px;
  background: rgba(255,255,255,0.85);
  border-radius: 16px;
  border: 1px solid rgba(212,175,55,0.15);
  box-shadow: 0 4px 16px rgba(212,175,55,0.08);
  cursor: pointer;
  transition: all 0.3s ease;
  overflow: hidden
}

.notifCard::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: linear-gradient(180deg, #d4af37, #b8860b);
  opacity: 0.8
}

.notifCard:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(212,175,55,0.12);
  border-color: rgba(212,175,55,0.3)
}

.notifCard.unread {
  background: rgba(255,255,255,0.95);
  border-color: rgba(212,175,55,0.25)
}

.notifIcon {
  width: 48px;
  height: 48px;
  border-radius: 999px;
  display: grid;
  place-items: center;
  font-size: 24px;
  flex-shrink: 0;
  border: 2px solid rgba(212,175,55,0.2);
  background: linear-gradient(135deg, rgba(212,175,55,0.1), rgba(184,134,11,0.05))
}

.notifIcon.like {
  background: linear-gradient(135deg, rgba(255,71,87,0.15), rgba(232,65,24,0.1));
  border-color: rgba(201,74,74,0.3)
}

.notifIcon.comment {
  background: linear-gradient(135deg, rgba(74,123,184,0.15), rgba(45,90,143,0.1));
  border-color: rgba(45,90,143,0.3)
}

.notifIcon.mention {
  background: linear-gradient(135deg, rgba(212,165,116,0.15), rgba(139,115,85,0.1));
  border-color: rgba(184,134,11,0.3)
}

.notifIcon.message {
  background: linear-gradient(135deg, rgba(66,165,245,0.15), rgba(25,118,210,0.1));
  border-color: rgba(25,118,210,0.3)
}

.notifIcon.follow {
  background: linear-gradient(135deg, rgba(212,175,55,0.15), rgba(184,134,11,0.1));
  border-color: rgba(212,175,55,0.3)
}

.notifIcon.favorite {
  background: linear-gradient(135deg, rgba(255,215,0,0.15), rgba(255,193,7,0.1));
  border-color: rgba(255,193,7,0.3)
}

.notifContent {
  flex: 1;
  min-width: 0;
}

.notifHeader {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
}

.avatar {
  width: 40px;
  height: 40px;
  border-radius: 999px;
  object-fit: cover;
  border: 2px solid rgba(212,175,55,0.2)
}

.userInfo {
  flex: 1;
  min-width: 0;
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap
}

.userName {
  font-weight: 900;
  color: #3a2e2b;
  font-size: 15px
}

.notifAction {
  font-size: 13px;
  color: #9d8b7a;
  font-weight: 700
}

.notifTime {
  font-size: 12px;
  color: #9d8b7a;
  font-weight: 700;
  flex-shrink: 0
}

.notifBody {
  display: grid;
  gap: 8px
}

.notifText {
  font-size: 14px;
  color: #4a3b36;
  line-height: 1.6;
  font-weight: 700
}

.workPreview {
  padding: 12px;
  background: linear-gradient(135deg, rgba(212,175,55,0.08), rgba(184,134,11,0.05));
  border-radius: 12px;
  border: 1px solid rgba(212,175,55,0.15)
}

.workTitle {
  font-size: 15px;
  font-weight: 900;
  color: #3a2e2b;
  margin-bottom: 6px;
  font-family: "思源宋体", "STSong", "SimSun", serif
}

.workExcerpt {
  font-size: 13px;
  color: #9d8b7a;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden
}

.unreadDot {
  position: absolute;
  top: 16px;
  right: 16px;
  width: 8px;
  height: 8px;
  border-radius: 999px;
  background: linear-gradient(135deg, #d4af37, #b8860b);
  box-shadow: 0 2px 6px rgba(212,175,55,0.4)
}

/* 空态 */
.empty {
  text-align: center;
  padding: 80px 20px;
  background: rgba(255,255,255,0.6);
  border-radius: 20px;
  border: 2px dashed rgba(212,175,55,0.2);
  margin: 40px 0
}

.emptyIcon {
  font-size: 72px;
  margin-bottom: 20px
}

.emptyTitle {
  font-size: 22px;
  font-weight: 900;
  color: #3a2e2b;
  margin-bottom: 12px;
  font-family: "思源宋体", "STSong", "SimSun", serif
}

.emptyDesc {
  font-size: 15px;
  color: #9d8b7a;
  font-weight: 700
}

/* 骨架屏 */
.skeletonList {
  display: grid;
  gap: 12px;
}

.skCard {
  background: rgba(255,255,255,.8);
  border-radius: 18px;
  padding: 16px;
  border: 1px solid rgba(0,0,0,.08);
}

.skRow {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
}

.skAvatar {
  width: 32px;
  height: 32px;
  border-radius: 999px;
  background: linear-gradient(90deg, rgba(0,0,0,0.06), rgba(0,0,0,0.02), rgba(0,0,0,0.06));
  background-size: 200% 100%;
  animation: shimmer 1.2s infinite;
}

.skLine {
  height: 12px;
  border-radius: 999px;
  background: linear-gradient(90deg, rgba(0,0,0,0.06), rgba(0,0,0,0.02), rgba(0,0,0,0.06));
  background-size: 200% 100%;
  animation: shimmer 1.2s infinite;
  margin-bottom: 8px;
}

.skLine.w70 { width: 70%; }
.skLine.w85 { width: 85%; }

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
</style>
