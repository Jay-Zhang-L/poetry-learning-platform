<template>
  <div class="chatPage">
    <!-- 竹纹背景 -->
    <div class="bgBamboo"></div>

    <!-- 水墨晕染渐变层 -->
    <div class="bgInk"></div>

    <div class="contentWrapper">
      <!-- 页面头部 -->
      <header class="chatHeader">
        <button class="navBtn backBtn" type="button" @click="goBack">
          <span class="btnIcon">←</span>
          <span class="btnText">返回</span>
        </button>

        <div class="chatTitle">
          <div class="titleMain">{{ targetUser.nickname || targetUser.username || '用户' }}</div>
          <div class="titleSub">{{ onlineStatus }}</div>
        </div>

        <button class="navBtn moreBtn" type="button" @click="showMore = !showMore">
          <span class="btnIcon">⋮</span>
        </button>
      </header>

      <!-- 更多操作菜单 -->
      <div v-if="showMore" class="moreMenu">
        <button class="menuItem" @click="clearHistory">清空聊天记录</button>
        <button class="menuItem danger" @click="blockUser">屏蔽用户</button>
      </div>

      <!-- 加载状态 -->
      <div v-if="loading" class="loadingContainer">
        <div class="loadingSpinner"></div>
        <div class="loadingText">正在加载聊天记录...</div>
      </div>

      <!-- 聊天内容区域 -->
      <div v-else class="chatContainer">
        <!-- 消息列表 -->
        <div class="messageList" ref="messageListRef">
          <div v-if="messages.length === 0" class="emptyState">
            <div class="emptyIcon">💬</div>
            <div class="emptyText">开始聊天吧！</div>
            <div class="emptySub">向对方打个招呼吧</div>
          </div>

          <div v-else>
            <div
              v-for="msg in messages"
              :key="msg.id"
              class="messageItem"
              :class="{ 'isSelf': msg.isSelf }"
            >
              <div class="messageTime" v-if="showTime(msg, $index)">
                {{ formatTime(msg.createdAt) }}
              </div>

              <!-- 对方消息：头像 + 气泡 -->
              <div v-if="!msg.isSelf" class="messageContent">
                <div class="avatar">
                  <img v-if="targetUser.avatarUrl" :src="fullUrl(targetUser.avatarUrl)" alt="" />
                  <div v-else class="avatarPlaceholder">{{ (targetUser.nickname || targetUser.username || 'U').slice(0, 1) }}</div>
                </div>

                <div class="bubble">
                  <div class="bubbleText">{{ msg.content }}</div>
                  <div class="bubbleStatus">
                    <span class="bubbleTime">{{ formatShortTime(msg.createdAt) }}</span>
                  </div>
                </div>
              </div>

              <!-- 自己消息：气泡 + 头像 -->
              <div v-else class="messageContent">
                <div class="bubble isSelf">
                  <div class="bubbleText">{{ msg.content }}</div>
                  <div class="bubbleStatus">
                    <span>{{ msg.isRead ? '已读' : '已发送' }}</span>
                    <span class="bubbleTime">{{ formatShortTime(msg.createdAt) }}</span>
                  </div>
                </div>

                <div class="avatar">
                  <img v-if="currentUser.avatarUrl" :src="fullUrl(currentUser.avatarUrl)" alt="" />
                  <div v-else class="avatarPlaceholder">{{ (currentUser.nickname || currentUser.username || 'I').slice(0, 1) }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 输入区域 -->
        <div class="inputArea">
          <div class="inputWrapper">
            <button class="inputBtn" @click="showEmoji = !showEmoji" title="表情">
              <span class="btnIcon">😊</span>
            </button>

            <textarea
              v-model="messageInput"
              class="messageInput"
              placeholder="输入消息..."
              rows="1"
              @keydown.enter.prevent="sendMessage"
              ref="inputRef"
            ></textarea>

            <button
              class="sendBtn"
              :disabled="!messageInput.trim() || sending"
              @click="sendMessage"
            >
              <span v-if="!sending">发送</span>
              <span v-else>...</span>
            </button>
          </div>

          <!-- 表情面板 -->
          <div v-if="showEmoji" class="emojiPanel">
            <div class="emojiGrid">
              <button
                v-for="emoji in commonEmojis"
                :key="emoji"
                class="emojiBtn"
                @click="insertEmoji(emoji)"
              >
                {{ emoji }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 底部安全区域 -->
    <div class="safeBottom"></div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick, onUnmounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { authGet, authPost, authPut, authDelete } from '@/utils/api';

const route = useRoute();
const router = useRouter();
const API_BASE = 'http://localhost:8080';

const targetUserId = computed(() => route.params.id);
const loading = ref(true);
const sending = ref(false);
const showMore = ref(false);
const showEmoji = ref(false);

const messageInput = ref('');
const messages = ref([]);
const messageListRef = ref(null);
const inputRef = ref(null);

const currentUser = reactive({
  id: null,
  username: '',
  nickname: '',
  avatarUrl: ''
});

const targetUser = reactive({
  id: null,
  username: '',
  nickname: '',
  avatarUrl: ''
});

// 常用表情
const commonEmojis = [
  '😀', '😂', '🥰', '😍', '🤔', '😢', '😡', '👍',
  '👎', '❤️', '🎉', '🔥', '✨', '🌟', '💯', '🙏'
];

const onlineStatus = computed(() => {
  return '在线'; // 可以后续扩展真实的在线状态
});

function fullUrl(path) {
  if (!path) return '';
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  return API_BASE + path;
}

function goBack() {
  router.back();
}

function formatTime(v) {
  if (!v) return '';
  const d = new Date(v);
  const pad = (n) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function formatShortTime(v) {
  if (!v) return '';
  const d = new Date(v);
  const pad = (n) => String(n).padStart(2, '0');
  return `${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function showTime(msg, index) {
  if (!index) return true;
  const prevMsg = messages.value[index - 1];
  if (!prevMsg) return true;

  const timeDiff = new Date(msg.createdAt) - new Date(prevMsg.createdAt);
  return timeDiff > 5 * 60 * 1000; // 5分钟
}

async function loadMessages() {
  loading.value = true;
  try {
    const res = await authGet(`${API_BASE}/api/messages/${targetUserId.value}`);
    if (res.code === 0) {
      messages.value = res.data || [];
      await scrollToBottom();
    }
  } catch (e) {
    console.error('加载消息失败:', e);
  } finally {
    loading.value = false;
  }
}

async function loadCurrentUser() {
  try {
    const userStr = localStorage.getItem('user');
    if (userStr) {
      const user = JSON.parse(userStr);
      Object.assign(currentUser, user);
    }
  } catch (e) {
    console.error('获取当前用户信息失败:', e);
  }
}

async function loadTargetUser() {
  try {
    const res = await authGet(`${API_BASE}/api/user/profile/${targetUserId.value}`);
    if (res.code === 0) {
      Object.assign(targetUser, res.data.user);
    }
  } catch (e) {
    console.error('获取目标用户信息失败:', e);
  }
}

async function sendMessage() {
  const content = messageInput.value.trim();
  if (!content) return;

  sending.value = true;
  try {
    const res = await authPost(`${API_BASE}/api/messages/${targetUserId.value}`, {
      content: content
    });

    if (res.code === 0) {
      // 添加消息到列表
      const newMessage = {
        id: res.data.id,
        senderId: currentUser.id,
        receiverId: targetUserId.value,
        content: content,
        messageType: 'text',
        isRead: false,
        createdAt: new Date().toISOString(),
        isSelf: true
      };
      messages.value.push(newMessage);

      // 清空输入框
      messageInput.value = '';
      showEmoji.value = false;

      // 滚动到底部
      await scrollToBottom();

      // 标记为已读
      await markAsRead();
    } else {
      alert(res.msg || '发送失败');
    }
  } catch (e) {
    console.error('发送消息失败:', e);
    alert('发送失败，请重试');
  } finally {
    sending.value = false;
  }
}

async function markAsRead() {
  try {
    await authPut(`${API_BASE}/api/messages/${targetUserId.value}/read`);
  } catch (e) {
    console.error('标记已读失败:', e);
  }
}

function insertEmoji(emoji) {
  messageInput.value += emoji;
  if (inputRef.value) {
    inputRef.value.focus();
  }
}

async function scrollToBottom() {
  // 等待Vue的DOM更新
  await nextTick();

  // 使用requestAnimationFrame确保浏览器的渲染完成
  // 双重RAF确保所有布局计算完成
  requestAnimationFrame(() => {
    requestAnimationFrame(() => {
      if (messageListRef.value) {
        messageListRef.value.scrollTop = messageListRef.value.scrollHeight;
      }
    });
  });
}

function clearHistory() {
  if (confirm('确定要清空聊天记录吗？')) {
    // TODO: 实现清空聊天记录功能
    alert('功能开发中');
  }
  showMore.value = false;
}

function blockUser() {
  if (confirm('确定要屏蔽此用户吗？')) {
    // TODO: 实现屏蔽用户功能
    alert('功能开发中');
  }
  showMore.value = false;
}

onMounted(async () => {
  await loadCurrentUser();
  await loadTargetUser();
  await loadMessages();

  // 额外保障：确保在所有内容加载完成后滚动到底部
  await scrollToBottom();
});

onUnmounted(() => {
  // 组件卸载时标记消息为已读
  markAsRead();
});
</script>

<style scoped>
/* =========================
   全局容器和背景
   ========================= */
.chatPage {
  height: calc(100vh - 64px - 32px);
  position: relative;
  background: var(--bg0);
  color: var(--text);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  width: 100%;
  margin: 0;
  padding: 0;
  left: 0;
  right: 0;
}

.bgBamboo {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: url("@/assets/chuangzuo/竹.png");
  background-size: 25%;
  background-repeat: repeat;
  opacity: 0.08;
  pointer-events: none;
  z-index: -3;
}

.bgInk {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
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
}

/* =========================
   页面头部
   ========================= */
.chatHeader {
  position: relative;
  z-index: 40;
  padding: 16px 20px;
  flex-shrink: 0;
  background: linear-gradient(180deg, rgba(253, 251, 247, 0.98), rgba(253, 251, 247, 0.95), rgba(253, 251, 247, 0));
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(212, 175, 55, 0.1);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.navBtn {
  height: 40px;
  padding: 0 16px;
  border-radius: 12px;
  border: 1px solid rgba(212, 175, 55, 0.3);
  background: linear-gradient(135deg, rgba(253, 249, 242, 0.9), rgba(246, 240, 230, 0.8));
  cursor: pointer;
  font-weight: 900;
  color: #4a3b36;
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
  font-size: 18px;
}

.btnText {
  font-size: 14px;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

.chatTitle {
  flex: 1;
  text-align: center;
}

.titleMain {
  font-size: 18px;
  font-weight: 900;
  color: #3a2e2b;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  letter-spacing: 2px;
}

.titleSub {
  font-size: 12px;
  color: #9d8b7a;
  font-weight: 700;
  margin-top: 4px;
}

/* =========================
   更多操作菜单
   ========================= */
.moreMenu {
  position: absolute;
  top: 60px;
  right: 20px;
  background: rgba(253, 249, 242, 0.98);
  border: 1px solid rgba(212, 175, 55, 0.2);
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(212, 175, 55, 0.15);
  backdrop-filter: blur(12px);
  z-index: 101;
  min-width: 160px;
}

.menuItem {
  width: 100%;
  padding: 12px 16px;
  border: none;
  background: transparent;
  text-align: left;
  cursor: pointer;
  font-size: 14px;
  color: #4a3b36;
  font-weight: 700;
  transition: all 0.2s ease;
  border-radius: 8px;
}

.menuItem:hover {
  background: rgba(212, 175, 55, 0.1);
}

.menuItem.danger {
  color: #e74c3c;
}

.menuItem.danger:hover {
  background: rgba(231, 76, 60, 0.1);
}

.menuItem:first-child {
  border-radius: 12px 12px 0 0;
}

.menuItem:last-child {
  border-radius: 0 0 12px 12px;
}

/* =========================
   加载状态
   ========================= */
.loadingContainer {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 20px;
}

.loadingSpinner {
  width: 48px;
  height: 48px;
  border: 4px solid rgba(212, 175, 55, 0.2);
  border-top-color: #d4af37;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loadingText {
  font-size: 16px;
  color: #9d8b7a;
  font-weight: 700;
}

/* =========================
   聊天容器
   ========================= */
.chatContainer {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  min-height: 0;
}

/* =========================
   消息列表
   ========================= */
.messageList {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  padding: 20px;
  min-height: 0;
}

.emptyState {
  text-align: center;
  padding: 60px 20px;
}

.emptyIcon {
  font-size: 64px;
  margin-bottom: 20px;
}

.emptyText {
  font-size: 18px;
  color: #4a3b36;
  font-weight: 900;
  margin-bottom: 8px;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

.emptySub {
  font-size: 14px;
  color: #9d8b7a;
  font-weight: 700;
}

/* =========================
   消息项
   ========================= */
.messageItem {
  margin-bottom: 16px;
}

.messageTime {
  text-align: center;
  font-size: 12px;
  color: #9d8b7a;
  font-weight: 700;
  margin-bottom: 12px;
  padding: 0 16px;
}

.messageContent {
  display: flex;
  gap: 12px;
  align-items: flex-start;
}

.messageItem.isSelf .messageContent {
  justify-content: flex-end;
}

/* 头像 */
.avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
  flex-shrink: 0;
  border: 2px solid rgba(212, 175, 55, 0.3);
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
  background: rgba(212, 175, 55, 0.1);
  font-weight: 900;
  font-size: 16px;
  color: #4a3b36;
}

/* 消息气泡 */
.bubble {
  max-width: 70%;
  padding: 12px 16px;
  border-radius: 16px;
  position: relative;
}

.bubble:not(.isSelf) {
  background: rgba(255, 255, 255, 0.95);
  border: 1px solid rgba(212, 175, 55, 0.2);
  border-top-left-radius: 4px;
}

.bubble.isSelf {
  background: linear-gradient(135deg, #e6c288, #d4af37);
  border-top-right-radius: 4px;
}

.bubbleText {
  font-size: 15px;
  line-height: 1.6;
  word-wrap: break-word;
}

.bubble:not(.isSelf) .bubbleText {
  color: #4a3b36;
}

.bubble.isSelf .bubbleText {
  color: #3a2e2b;
}

.bubbleStatus {
  font-size: 11px;
  margin-top: 4px;
  opacity: 0.7;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 8px;
}

.bubble:not(.isSelf) .bubbleStatus {
  color: #9d8b7a;
}

.bubble.isSelf .bubbleStatus {
  color: rgba(58, 46, 43, 0.7);
}

/* =========================
   输入区域
   ========================= */
.inputArea {
  position: relative;
  background: rgba(253, 249, 242, 0.95);
  border-top: 1px solid rgba(212, 175, 55, 0.1);
  padding: 12px 20px;
  flex-shrink: 0;
}

.inputWrapper {
  display: flex;
  align-items: flex-end;
  gap: 12px;
}

.inputBtn {
  height: 40px;
  width: 40px;
  border-radius: 12px;
  border: 1px solid rgba(212, 175, 55, 0.2);
  background: rgba(255, 255, 255, 0.8);
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.inputBtn:hover {
  background: rgba(212, 175, 55, 0.1);
  border-color: rgba(212, 175, 55, 0.4);
}

.btnIcon {
  font-size: 20px;
}

.messageInput {
  flex: 1;
  min-height: 40px;
  max-height: 120px;
  border: 1px solid rgba(212, 175, 55, 0.2);
  background: rgba(255, 255, 255, 0.95);
  border-radius: 12px;
  padding: 10px 14px;
  font-size: 15px;
  color: #4a3b36;
  outline: none;
  resize: none;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  line-height: 1.5;
}

.messageInput:focus {
  border-color: rgba(212, 175, 55, 0.4);
  box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
}

.sendBtn {
  height: 40px;
  padding: 0 24px;
  border-radius: 12px;
  border: none;
  background: linear-gradient(135deg, #e6c288, #d4af37);
  color: #fff;
  font-weight: 900;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 14px;
}

.sendBtn:hover:not(:disabled) {
  background: linear-gradient(135deg, #d4af37, #c9a227);
  transform: translateY(-1px);
}

.sendBtn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* 表情面板 */
.emojiPanel {
  position: absolute;
  bottom: 60px;
  left: 20px;
  background: rgba(253, 249, 242, 0.98);
  border: 1px solid rgba(212, 175, 55, 0.2);
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(212, 175, 55, 0.15);
  backdrop-filter: blur(12px);
  padding: 12px;
  z-index: 102;
}

.emojiGrid {
  display: grid;
  grid-template-columns: repeat(8, 1fr);
  gap: 8px;
  max-width: 320px;
}

.emojiBtn {
  width: 32px;
  height: 32px;
  border: none;
  background: transparent;
  cursor: pointer;
  font-size: 20px;
  transition: all 0.2s ease;
  border-radius: 6px;
}

.emojiBtn:hover {
  background: rgba(212, 175, 55, 0.15);
  transform: scale(1.1);
}

/* =========================
   底部安全区域
   ========================= */
.safeBottom {
  height: 0;
}

/* =========================
   响应式设计
   ========================= */
@media (max-width: 768px) {
  .chatHeader {
    padding: 12px 16px;
  }

  .titleMain {
    font-size: 16px;
  }

  .bubble {
    max-width: 80%;
  }

  .emojiGrid {
    grid-template-columns: repeat(6, 1fr);
  }

  .emojiPanel {
    left: 16px;
    right: 16px;
    max-width: none;
  }
}
</style>