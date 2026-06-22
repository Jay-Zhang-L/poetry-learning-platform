<template>
  <div class="conversationsPage">
    <!-- 竹纹背景 -->
    <div class="bgBamboo"></div>

    <!-- 水墨晕染渐变层 -->
    <div class="bgInk"></div>

    <div class="contentWrapper">
      <!-- 顶部栏 -->
      <header class="chatHeader">
        <button class="navBtn backBtn" type="button" @click="goBack">
          <span class="btnIcon">←</span>
          <span class="btnText">返回</span>
        </button>

        <div class="chatTitle">
          <div class="titleMain">我的会话</div>
          <div class="titleSub">{{ totalConversations > 0 ? `${totalConversations}个会话` : '暂无会话' }}</div>
        </div>

        <button class="navBtn searchBtn" type="button" @click="showSearch = !showSearch">
          <svg class="searchIconSvg" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <circle cx="11" cy="11" r="6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            <path d="M20 20L15.5 15.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
          </svg>
        </button>

        <button
          class="navBtn markAllBtn"
          type="button"
          @click="markAllAsRead"
          v-if="hasUnreadMessages"
        >
          <span class="btnIcon">✓</span>
          <span class="btnText">全部已读</span>
        </button>
      </header>

      <!-- 搜索栏 -->
      <div v-if="showSearch" class="searchBar">
        <input
          v-model="searchQuery"
          type="text"
          class="searchInput"
          placeholder="搜索用户名或昵称..."
          @input="handleSearch"
        />
        <button v-if="searchQuery" class="clearBtn" @click="clearSearch">✕</button>
      </div>

      <!-- 加载状态 -->
      <div v-if="loading && conversations.length === 0" class="loadingContainer">
        <div class="loadingSpinner"></div>
        <div class="loadingText">正在加载会话列表...</div>
      </div>

      <!-- 会话列表 -->
      <div v-else class="conversationsContainer">
        <!-- 空状态 -->
        <div v-if="conversations.length === 0" class="emptyState">
          <div class="emptyIcon">💬</div>
          <div class="emptyText">还没有任何会话</div>
          <div class="emptySub">关注用户后，点击他们的头像发起私信吧</div>
        </div>

        <!-- 会话列表 -->
        <div v-else class="conversationsList">
          <div
            v-for="conv in filteredConversations"
            :key="conv.id"
            class="conversationItem"
            @click="openChat(conv)"
          >
            <!-- 头像 -->
            <div class="avatar">
              <img v-if="conv.targetAvatarUrl" :src="conv.targetAvatarUrl" alt="" />
              <div v-else class="avatarPlaceholder">
                {{ (conv.targetNickname || 'U').slice(0, 1) }}
              </div>
              <!-- 在线状态指示器 -->
              <div v-if="conv.isOnline" class="onlineIndicator"></div>
            </div>

            <!-- 内容 -->
            <div class="content">
              <div class="topRow">
                <div class="nickname">{{ conv.targetNickname || '未知用户' }}</div>
                <div class="meta">
                  <span v-if="conv.unreadCount > 0" class="unreadBadge">{{ conv.unreadCount > 99 ? '99+' : conv.unreadCount }}</span>
                  <span class="time">{{ formatTime(conv.lastMessageTime) }}</span>
                </div>
              </div>
              <div class="messagePreview">
                {{ conv.lastMessageContent || '暂无消息' }}
              </div>
            </div>

            <!-- 更多操作按钮 -->
            <button
              class="moreBtn"
              @click.stop="showMenu(conv)"
              v-if="!showSearch"
            >
              <span>⋮</span>
            </button>
          </div>

          <!-- 加载更多 -->
          <div v-if="hasMore && !loading" class="loadMore">
            <button class="loadMoreBtn" @click="loadMore">
              {{ loadingMore ? '加载中...' : '加载更多' }}
            </button>
          </div>

          <!-- 没有更多 -->
          <div v-if="!hasMore && conversations.length > 0" class="noMore">
            没有更多了
          </div>
        </div>
      </div>

      <!-- 操作菜单 -->
      <div v-if="selectedConversation" class="actionMenu" @click="closeMenu">
        <div class="menuContent" @click.stop>
          <div class="menuHeader">
            <div class="menuTitle">操作</div>
            <button class="closeBtn" @click="closeMenu">✕</button>
          </div>
          <button class="menuItem" @click="markAsRead">
            <span class="menuIcon">✓</span>
            标记已读
          </button>
          <button class="menuItem danger" @click="deleteConversation">
            <span class="menuIcon">🗑️</span>
            删除会话
          </button>
        </div>
      </div>
    </div>

    <!-- 底部安全区域 -->
    <div class="safeBottom"></div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();

const token = computed(() => localStorage.getItem('token') || '');
const isLogin = computed(() => !!token.value);

const loading = ref(false);
const loadingMore = ref(false);
const showSearch = ref(false);
const searchQuery = ref('');
const conversations = ref([]);
const selectedConversation = ref(null);

const page = ref(1);
const size = 20;
const hasMore = ref(false);
const totalConversations = ref(0);

// 过滤后的会话列表
const filteredConversations = computed(() => {
  if (!searchQuery.value.trim()) {
    return conversations.value;
  }
  const query = searchQuery.value.toLowerCase();
  return conversations.value.filter(conv => {
    const nickname = (conv.targetNickname || '').toLowerCase();
    return nickname.includes(query);
  });
});

// 计算是否有未读消息
const hasUnreadMessages = computed(() => {
  return conversations.value.some(conv => conv.unreadCount > 0);
});

// 格式化时间
function formatTime(timeStr) {
  if (!timeStr) return '';

  const date = new Date(timeStr);
  const now = new Date();
  const diff = now - date;

  const minute = 60 * 1000;
  const hour = 60 * minute;
  const day = 24 * hour;

  if (diff < minute) return '刚刚';
  if (diff < hour) return `${Math.floor(diff / minute)}分钟前`;
  if (diff < day) return `${Math.floor(diff / hour)}小时前`;
  if (diff < 7 * day) return `${Math.floor(diff / day)}天前`;

  const pad = (n) => String(n).padStart(2, '0');
  return `${date.getMonth() + 1}/${date.getDate()}`;
}

// 获取会话列表
async function fetchConversations(isRefresh = false) {
  if (!isLogin.value) {
    router.replace('/login');
    return;
  }

  if (isRefresh) {
    page.value = 1;
  }

  loading.value = true;
  try {
    const resp = await fetch(`/api/messages/conversations?page=${page.value}&size=${size}`, {
      headers: {
        'Authorization': `Bearer ${token.value}`,
        'Content-Type': 'application/json'
      }
    });

    const data = await resp.json();

    if (data.code === 0 || data.code === 200) {
      const list = data.data || [];

      if (isRefresh) {
        conversations.value = list;
      } else {
        conversations.value = [...conversations.value, ...list];
      }

      // 判断是否还有更多
      hasMore.value = list.length === size;

      // 获取总会话数
      totalConversations.value = conversations.value.length;
    } else {
      throw new Error(data.message || '加载失败');
    }
  } catch (e) {
    console.error('获取会话列表失败：', e);
    alert(e.message || '加载失败，请稍后重试');
  } finally {
    loading.value = false;
  }
}

// 加载更多
async function loadMore() {
  if (loadingMore.value || !hasMore.value) return;

  loadingMore.value = true;
  page.value += 1;

  try {
    const resp = await fetch(`/api/messages/conversations?page=${page.value}&size=${size}`, {
      headers: {
        'Authorization': `Bearer ${token.value}`,
        'Content-Type': 'application/json'
      }
    });

    const data = await resp.json();

    if (data.code === 0 || data.code === 200) {
      const list = data.data || [];
      conversations.value = [...conversations.value, ...list];
      hasMore.value = list.length === size;
    } else {
      throw new Error(data.message || '加载失败');
    }
  } catch (e) {
    console.error('加载更多失败：', e);
    page.value -= 1;
    alert(e.message || '加载失败，请稍后重试');
  } finally {
    loadingMore.value = false;
  }
}

// 打开聊天
function openChat(conv) {
  // 标记已读
  if (conv.unreadCount > 0) {
    markAsReadAPI(conv.targetId);
  }

  // 跳转到聊天页面
  router.push(`/chat/${conv.targetId}`);
}

// 标记已读API
async function markAsReadAPI(targetId) {
  try {
    await fetch(`/api/messages/${targetId}/read`, {
      method: 'PUT',
      headers: {
        'Authorization': `Bearer ${token.value}`,
        'Content-Type': 'application/json'
      }
    });

    // 更新本地状态
    conversations.value.forEach(conv => {
      if (conv.targetId === targetId) {
        conv.unreadCount = 0;
      }
    });
  } catch (e) {
    console.error('标记已读失败：', e);
  }
}

// 搜索处理
function handleSearch() {
  // 搜索逻辑由 computed 自动处理
}

// 清除搜索
function clearSearch() {
  searchQuery.value = '';
}

// 显示操作菜单
function showMenu(conv) {
  selectedConversation.value = conv;
}

// 关闭菜单
function closeMenu() {
  selectedConversation.value = null;
}

// 标记已读
async function markAsRead() {
  if (!selectedConversation.value) return;

  await markAsReadAPI(selectedConversation.value.targetId);
  closeMenu();
}

// 删除会话
async function deleteConversation() {
  if (!selectedConversation.value) return;

  const conv = selectedConversation.value;
  const nickname = conv.targetNickname || '该用户';

  if (!confirm(`确认删除与${nickname}的会话？此操作不可恢复。`)) {
    closeMenu();
    return;
  }

  try {
    const resp = await fetch(`/api/messages/conversations/${conv.targetId}`, {
      method: 'DELETE',
      headers: {
        'Authorization': `Bearer ${token.value}`,
        'Content-Type': 'application/json'
      }
    });

    const data = await resp.json();

    if (data.code === 0 || data.code === 200) {
      // 从列表中移除
      conversations.value = conversations.value.filter(c => c.id !== conv.id);
      totalConversations.value = conversations.value.length;

      closeMenu();
      alert('会话已删除');
    } else {
      throw new Error(data.message || '删除失败');
    }
  } catch (e) {
    console.error('删除会话失败：', e);
    alert(e.message || '删除失败，请稍后重试');
  }
}

// 返回
function goBack() {
  router.back();
}

// 标记全部已读
async function markAllAsRead() {
  if (!hasUnreadMessages.value) return;

  try {
    const resp = await fetch('/api/messages/read-all', {
      method: 'PUT',
      headers: {
        'Authorization': `Bearer ${token.value}`,
        'Content-Type': 'application/json'
      }
    });

    const data = await resp.json();

    if (data.code === 0 || data.code === 200) {
      // 更新本地状态：清空所有未读计数
      conversations.value.forEach(conv => {
        conv.unreadCount = 0;
      });

      // 显示成功提示
      alert('全部消息已标记为已读');
    } else {
      throw new Error(data.message || '操作失败');
    }
  } catch (e) {
    console.error('标记全部已读失败：', e);
    alert(e.message || '操作失败，请稍后重试');
  }
}

onMounted(() => {
  fetchConversations();
});

// 下拉刷新
let startY = 0;
let isRefreshing = false;

function handleTouchStart(e) {
  startY = e.touches[0].clientY;
}

function handleTouchMove(e) {
  if (isRefreshing) return;

  const currentY = e.touches[0].clientY;
  const diff = currentY - startY;

  // 如果下拉超过100px，触发刷新
  if (diff > 100 && window.scrollY === 0) {
    isRefreshing = true;
    fetchConversations(true).finally(() => {
      isRefreshing = false;
    });
  }
}

onMounted(() => {
  window.addEventListener('touchstart', handleTouchStart);
  window.addEventListener('touchmove', handleTouchMove);
});

onUnmounted(() => {
  window.removeEventListener('touchstart', handleTouchStart);
  window.removeEventListener('touchmove', handleTouchMove);
});
</script>

<style scoped>
.conversationsPage {
  min-height: 100vh;
  position: relative;
  display: flex;
  flex-direction: column;
  background: var(--bg0);
  color: var(--text);
}

/* 竹纹背景 */
.conversationsPage::before {
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
.conversationsPage::after {
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

.contentWrapper {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  padding: 0 20px 32px;
}

/* 顶部栏 */
.chatHeader {
  display: grid;
  grid-template-columns: 80px 1fr 60px;
  gap: 16px;
  align-items: center;
  padding: 16px 20px;
  background: linear-gradient(180deg, rgba(253,251,247,0.98), rgba(253,251,247,0.95), rgba(253,251,247,0));
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(212,175,55,0.1);
  position: sticky;
  top: 0;
  z-index: 100;
}

.navBtn {
  height: 42px;
  border-radius: 12px;
  border: 1px solid rgba(212, 175, 55, 0.3);
  background: linear-gradient(135deg, rgba(253, 249, 242, 0.9), rgba(246, 240, 230, 0.8));
  cursor: pointer;
  font-weight: 900;
  color: #4a3b36;
  padding: 0 20px;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.navBtn:hover {
  background: linear-gradient(135deg, rgba(242, 233, 210, 0.9), rgba(230, 194, 136, 0.8));
  border-color: rgba(212, 175, 55, 0.5);
  transform: translateY(-1px);
}

.btnIcon {
  font-size: 16px;
}

.btnText {
  font-size: 14px;
  margin-left: 4px;
}

/* 搜索按钮 */
.searchBtn {
  padding: 0 16px;
}

.searchIconSvg {
  width: 20px;
  height: 20px;
  color: #d4af37;
  opacity: 0.85;
  transition: all 0.3s ease;
}

.navBtn:hover .searchIconSvg {
  opacity: 1;
  transform: scale(1.1);
}

/* 全部已读按钮 */
.markAllBtn {
  background: linear-gradient(135deg, rgba(212, 175, 55, 0.15), rgba(184, 134, 11, 0.1));
  border-color: rgba(212, 175, 55, 0.4);
  margin-left: 8px;
}

.markAllBtn:hover {
  background: linear-gradient(135deg, rgba(212, 175, 55, 0.25), rgba(184, 134, 11, 0.2));
  border-color: rgba(212, 175, 55, 0.6);
  transform: translateY(-1px);
}

.markAllBtn .btnIcon {
  color: #d4af37;
  font-size: 16px;
  font-weight: bold;
}

.chatTitle {
  text-align: center;
}

.titleMain {
  font-weight: 900;
  letter-spacing: 1px;
  color: #3a2e2b;
  font-size: 20px;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

.titleSub {
  font-size: 12px;
  color: #9d8b7a;
  margin-top: 2px;
}

/* 搜索栏 */
.searchBar {
  position: relative;
  margin: 16px 0;
  background: rgba(255,255,255,0.85);
  border: 1px solid rgba(212,175,55,0.15);
  border-radius: 16px;
  padding: 4px 20px;
  box-shadow: 0 2px 8px rgba(212,175,55,0.08);
}

.searchInput {
  width: 100%;
  border: none;
  background: transparent;
  font-size: 14px;
  padding: 8px 0;
  outline: none;
  color: #3a2e2b;
}

.searchInput::placeholder {
  color: #9d8b7a;
}

.clearBtn {
  position: absolute;
  right: 16px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  font-size: 18px;
  cursor: pointer;
  color: #9d8b7a;
  padding: 4px 8px;
}

.clearBtn:hover {
  color: #d4af37;
}

/* 加载容器 */
.loadingContainer {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
}

.loadingSpinner {
  width: 40px;
  height: 40px;
  border: 3px solid rgba(212,175,55,0.3);
  border-top-color: #d4af37;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loadingText {
  margin-top: 16px;
  color: #9d8b7a;
  font-size: 14px;
}

/* 会话容器 */
.conversationsContainer {
  flex: 1;
  overflow-y: auto;
  background: rgba(255,255,255,0.85);
  border: 1px solid rgba(212,175,55,0.15);
  border-radius: 18px;
  padding: 20px;
  min-height: 400px;
}

/* 空状态 */
.emptyState {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  text-align: center;
}

.emptyIcon {
  font-size: 64px;
  margin-bottom: 16px;
}

.emptyText {
  font-size: 18px;
  color: #3a2e2b;
  font-weight: 700;
  margin-bottom: 8px;
}

.emptySub {
  font-size: 14px;
  color: #9d8b7a;
}

/* 会话列表 */
.conversationsList {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

/* 会话项 */
.conversationItem {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px;
  background: rgba(255,255,255,0.95);
  border: 1px solid rgba(212,175,55,0.15);
  border-radius: 16px;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
}

.conversationItem:hover {
  background: rgba(255,255,255,1);
  border-color: rgba(212,175,55,0.3);
  box-shadow: 0 4px 12px rgba(212,175,55,0.12);
  transform: translateY(-2px);
}

/* 头像 */
.avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  overflow: hidden;
  border: 2px solid rgba(212,175,55,0.3);
  flex-shrink: 0;
  position: relative;
  background: linear-gradient(135deg, rgba(212,175,55,0.15), rgba(184,134,11,0.1));
}

.avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatarPlaceholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 900;
  font-size: 20px;
  color: #d4af37;
}

/* 在线指示器 */
.onlineIndicator {
  position: absolute;
  bottom: 2px;
  right: 2px;
  width: 12px;
  height: 12px;
  background: #52c41a;
  border: 2px solid #fff;
  border-radius: 50%;
}

/* 内容 */
.content {
  flex: 1;
  min-width: 0;
}

.topRow {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 6px;
}

.nickname {
  font-weight: 900;
  font-size: 16px;
  color: #3a2e2b;
}

.meta {
  display: flex;
  align-items: center;
  gap: 8px;
}

/* 未读徽章 */
.unreadBadge {
  background: linear-gradient(135deg, #d4af37, #b8860b);
  color: white;
  font-size: 12px;
  font-weight: 900;
  padding: 2px 8px;
  border-radius: 12px;
  min-width: 20px;
  text-align: center;
}

.time {
  font-size: 12px;
  color: #9d8b7a;
}

/* 消息预览 */
.messagePreview {
  font-size: 14px;
  color: #9d8b7a;
  line-height: 1.5;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* 更多按钮 */
.moreBtn {
  padding: 8px;
  background: none;
  border: none;
  font-size: 16px;
  cursor: pointer;
  color: #9d8b7a;
  transition: all 0.3s ease;
}

.moreBtn:hover {
  color: #d4af37;
}

/* 加载更多 */
.loadMore, .noMore {
  padding: 16px;
  text-align: center;
  font-size: 14px;
  color: #9d8b7a;
}

.loadMoreBtn {
  background: none;
  border: 1px solid rgba(212,175,55,0.3);
  border-radius: 12px;
  padding: 8px 24px;
  cursor: pointer;
  transition: all 0.3s ease;
  color: #4a3b36;
  font-weight: 700;
}

.loadMoreBtn:hover {
  background: rgba(212,175,55,0.1);
  border-color: rgba(212,175,55,0.5);
}

/* 操作菜单 */
.actionMenu {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: flex-end;
  justify-content: center;
  z-index: 1000;
  padding: 16px;
}

.menuContent {
  background: white;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.15);
  overflow: hidden;
  min-width: 200px;
}

.menuHeader {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  border-bottom: 1px solid rgba(212,175,55,0.1);
}

.menuTitle {
  font-weight: 900;
  font-size: 16px;
  color: #3a2e2b;
}

.closeBtn {
  background: none;
  border: none;
  font-size: 18px;
  cursor: pointer;
  color: #9d8b7a;
  padding: 4px 8px;
}

.menuItem {
  width: 100%;
  padding: 14px 16px;
  background: none;
  border: none;
  text-align: left;
  font-size: 14px;
  color: #4a3b36;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 12px;
  transition: background 0.2s ease;
}

.menuItem:hover {
  background: rgba(212,175,55,0.1);
}

.menuItem.danger {
  color: #c94a4a;
}

.menuIcon {
  font-size: 16px;
}

/* 安全底部 */
.safeBottom {
  height: 32px;
}

/* 响应式 */
@media (min-width: 768px) {
  .contentWrapper {
    padding: 0 20px 32px;
  }
}

@media (min-width: 1200px) {
  .contentWrapper {
    padding: 0 32px 32px;
  }
}

@media (max-width: 767px) {
  .chatHeader {
    padding: 12px 16px;
    grid-template-columns: 60px 1fr 50px;
  }

  .contentWrapper {
    padding: 0 16px 32px;
  }

  .titleMain {
    font-size: 18px;
  }

  .conversationItem {
    padding: 12px;
  }

  .avatar {
    width: 45px;
    height: 45px;
  }

  .nickname {
    font-size: 15px;
  }

  .messagePreview {
    font-size: 13px;
  }
}
</style>