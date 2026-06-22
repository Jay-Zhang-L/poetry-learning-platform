<template>
  <div class="forum-chat">
    <!-- 临时调试信息 - 确认用户信息 -->
    <div class="debug-info" style="background: #f5f5f5; padding: 8px; margin: 8px; border-radius: 0; font-size: 12px; color: #333;">
      ✅ 当前用户: {{ currentUser.nickname }} (ID: {{ currentUser.id }})
    </div>
    
    <!-- 聊天头部 -->
    <div class="chat-header">
      <div class="header-left">
        <div class="logo">
          <span class="logo-icon">🍂</span>
          <h3>诗韵雅集</h3>
        </div>
        <div class="online-count">
          <span class="dot"></span>
          <span>在线 {{ onlineCount }} 人</span>
        </div>
      </div>
      <div class="header-right">
        <button class="icon-btn" @click="refreshMessages" :disabled="refreshing" title="刷新">
          <span class="icon" :class="{ spinning: refreshing }">⟳</span>
        </button>
        <button class="icon-btn" @click="scrollToTop" v-if="messages.length > 10" title="回顶部">
          <span class="icon">↑</span>
        </button>
      </div>
    </div>

    <!-- 消息列表 -->
    <div class="message-list" ref="messageList" @scroll="handleScroll">
      <div v-if="hasMore && !loading" class="load-more">
        <button class="load-more-btn" @click="loadMore" :disabled="loadingMore">
          <span v-if="!loadingMore">📜 点击加载更早的诗笺</span>
          <span v-else>📖 翻阅中...</span>
        </button>
      </div>
      
      <div 
        v-for="message in messages" 
        :key="message.id" 
        class="message-item"
        :class="{ 
          'system-message': message.type === 2,
          'my-message': message.userId === currentUser.id
        }"
      >
        <template v-if="message.type !== 2">
          <!-- 头像可点击 -->
          <div class="avatar" @click="goToUserProfile(message.userId)">
            <img 
              class="avatar-img" 
              :src="getAvatarUrl(message.avatar)" 
              :alt="message.nickname"
              @error="handleAvatarError"
            />
          </div>
          <div class="message-content">
            <div class="message-info">
              <!-- 昵称可点击 -->
              <span class="nickname" @click="goToUserProfile(message.userId)">{{ message.nickname }}</span>
              <span class="time">{{ formatTime(message.createTime) }}</span>
            </div>
            <div class="bubble">
              <span class="bubble-text">{{ message.content }}</span>
            </div>
          </div>
        </template>
        
        <template v-else>
          <div class="system-bubble">
            <span class="system-icon">🏮</span>
            <span class="system-text">{{ message.content }}</span>
          </div>
        </template>
      </div>
      
      <div v-if="loading && messages.length === 0" class="loading-tip">
        <div class="loading-spinner"></div>
        <p>加载诗笺中...</p>
      </div>
      
      <div v-if="!loading && messages.length === 0" class="empty-tip">
        <div class="empty-icon">📖</div>
        <p>暂无诗笺，来做第一个吟诗之人吧！</p>
      </div>
    </div>

    <!-- 输入区域 -->
    <div class="input-area">
      <div class="input-toolbar">
        <button class="tool-btn" @click="showEmoji = !showEmoji" :class="{ active: showEmoji }">
          <span>😊</span> 表情
        </button>
        <div class="char-count">{{ inputMessage.length }}/300</div>
      </div>
      
      <transition name="emoji-fade">
        <div v-show="showEmoji" class="emoji-panel">
          <div 
            v-for="emoji in emojis" 
            :key="emoji" 
            class="emoji-item"
            @click="addEmoji(emoji)"
          >
            {{ emoji }}
          </div>
        </div>
      </transition>
      
      <div class="input-wrapper">
        <textarea
          v-model="inputMessage"
          rows="2"
          placeholder="吟诗一首，或与诗友论道..."
          maxlength="300"
          @keydown.ctrl.enter="sendMessage"
          @keydown.enter.exact.prevent="handleEnter"
        ></textarea>
      </div>
      
      <div class="input-actions">
        <div class="tips">
          <span>⌨️ Ctrl + Enter 发送</span>
          <span>📝 分享诗意，以文会友</span>
        </div>
        <button class="send-btn" @click="sendMessage" :disabled="sending">
          <span v-if="!sending">✍️ 题诗发送</span>
          <span v-else>📮 寄送中...</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'

// 获取路由实例
const router = useRouter()

// 当前用户信息
const currentUser = ref({
  id: 0,
  nickname: '',
  avatar: ''
})

const messages = ref([])
const inputMessage = ref('')
const sending = ref(false)
const refreshing = ref(false)
const loading = ref(false)
const loadingMore = ref(false)
const onlineCount = ref(23)
const hasMore = ref(true)
const showEmoji = ref(false)
let currentPage = 1
let pollTimer = null
let pageSize = 20

const defaultAvatar = 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="45" fill="%23e8d5b5"/><circle cx="50" cy="40" r="12" fill="%23d4b88a"/><path d="M30 65 Q50 78 70 65" fill="%23c4a27a"/><circle cx="38" cy="38" r="2" fill="%23654321"/><circle cx="62" cy="38" r="2" fill="%23654321"/></svg>'

const emojis = ['😊', '😌', '🌸', '🍃', '🌙', '⭐', '📖', '✍️', '🍵', '🎋', '🏮', '🖌️', '📜', '🎵', '💭', '✨']

const API_BASE = '/api/chat'
const USER_API_BASE = '/api/user'

// 获取 token
const getToken = () => {
  const token = localStorage.getItem('token')
  return token ? `Bearer ${token}` : ''
}

// 获取完整头像URL
const getAvatarUrl = (avatar) => {
  if (!avatar) return defaultAvatar
  if (avatar.startsWith('http') || avatar.startsWith('data:')) return avatar
  return window.location.origin + avatar
}

// 跳转到用户个人主页
const goToUserProfile = (userId) => {
  if (!userId || userId === 0) {
    console.log('系统消息，无法跳转')
    return
  }
  
  console.log('跳转到用户主页:', userId)
  
  if (userId === currentUser.value.id) {
    router.push('/center')
  } else {
    router.push(`/author/${userId}`)
  }
}

// 获取当前登录用户信息
const fetchCurrentUser = async () => {
  try {
    const token = getToken()
    const headers = {
      'Content-Type': 'application/json'
    }
    if (token) {
      headers['Authorization'] = token
    }
    
    const res = await fetch(`${USER_API_BASE}/me`, {
      method: 'GET',
      headers: headers,
      credentials: 'include'
    })
    
    const data = await res.json()
    console.log('获取用户信息:', data)
    
    if (data.code === 0 && data.data) {
      let avatarUrl = data.data.avatarUrl || ''
      
      currentUser.value = {
        id: data.data.id,
        nickname: data.data.nickname || data.data.username || '诗友',
        avatar: avatarUrl
      }
    } else {
      const userStr = localStorage.getItem('user')
      if (userStr) {
        try {
          const userInfo = JSON.parse(userStr)
          currentUser.value = {
            id: userInfo.userId || userInfo.id || 2,
            nickname: userInfo.nickname || '小时',
            avatar: userInfo.avatarUrl || ''
          }
        } catch (e) {
          currentUser.value = { id: 2, nickname: '小时', avatar: '' }
        }
      } else {
        currentUser.value = { id: 2, nickname: '小时', avatar: '' }
      }
    }
    
    console.log('设置后的 currentUser:', currentUser.value)
  } catch (error) {
    console.error('获取当前用户失败:', error)
    currentUser.value = { id: 2, nickname: '小时', avatar: '' }
  }
}

// 获取最新消息
const fetchLatestMessages = async () => {
  try {
    const res = await fetch(`${API_BASE}/latest`, {
      credentials: 'include'
    })
    const data = await res.json()
    if (data.code === 200) {
      messages.value = data.data.reverse()
      scrollToBottom()
    }
  } catch (error) {
    console.error('获取消息失败', error)
  }
}

// 刷新消息
const refreshMessages = async () => {
  refreshing.value = true
  try {
    await fetchLatestMessages()
    ElMessage.success('刷新成功')
  } catch (error) {
    ElMessage.error('刷新失败')
  } finally {
    refreshing.value = false
  }
}

// 发送消息
const sendMessage = async () => {
  const content = inputMessage.value.trim()
  if (!content) {
    ElMessage.warning('请留下您的诗语')
    return
  }
  
  if (!currentUser.value.id || currentUser.value.id === 0) {
    ElMessage.warning('请先登录')
    return
  }
  
  sending.value = true
  try {
    const requestBody = {
      userId: currentUser.value.id,
      nickname: currentUser.value.nickname,
      avatar: currentUser.value.avatar,
      content: content
    }
    
    console.log('发送消息:', requestBody)
    
    const res = await fetch(`${API_BASE}/send`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      credentials: 'include',
      body: JSON.stringify(requestBody)
    })
    
    const data = await res.json()
    console.log('发送响应:', data)
    
    if (data.code === 200) {
      messages.value.push(data.data)
      inputMessage.value = ''
      showEmoji.value = false
      scrollToBottom()
      ElMessage.success('诗笺已寄出')
    } else {
      ElMessage.error(data.message || '寄送失败')
    }
  } catch (error) {
    console.error('发送失败', error)
    ElMessage.error('发送失败，请重试')
  } finally {
    sending.value = false
  }
}

// Enter 键处理
const handleEnter = (e) => {
  if (e.ctrlKey) {
    sendMessage()
  }
}

// 加载历史消息
const loadHistory = async (page = 1) => {
  loading.value = true
  try {
    const res = await fetch(`${API_BASE}/history?page=${page}&size=${pageSize}`, {
      credentials: 'include'
    })
    const data = await res.json()
    if (data.code === 200) {
      const newMessages = data.data.messages
      if (newMessages.length > 0) {
        messages.value = [...newMessages.reverse(), ...messages.value]
        currentPage = page
        hasMore.value = newMessages.length === pageSize
        return newMessages.length
      } else {
        hasMore.value = false
        return 0
      }
    }
    return 0
  } catch (error) {
    console.error('加载历史消息失败', error)
    return 0
  } finally {
    loading.value = false
  }
}

// 加载更多
const loadMore = async () => {
  if (loadingMore.value || !hasMore.value) return
  
  loadingMore.value = true
  try {
    const nextPage = currentPage + 1
    const loadedCount = await loadHistory(nextPage)
    
    if (loadedCount > 0) {
      ElMessage.success(`翻阅到 ${loadedCount} 篇旧诗笺`)
    } else {
      hasMore.value = false
      ElMessage.info('已至诗卷尽头')
    }
  } catch (error) {
    ElMessage.error('翻阅失败')
  } finally {
    loadingMore.value = false
  }
}

// 滚动到底部
const scrollToBottom = () => {
  nextTick(() => {
    const messageList = document.querySelector('.message-list')
    if (messageList) {
      messageList.scrollTop = messageList.scrollHeight
    }
  })
}

// 滚动到顶部
const scrollToTop = () => {
  const messageList = document.querySelector('.message-list')
  if (messageList) {
    messageList.scrollTop = 0
  }
}

// 处理滚动事件
const handleScroll = (e) => {
  const { scrollTop } = e.target
  if (scrollTop === 0 && hasMore.value && !loadingMore.value && !loading.value) {
    loadMore()
  }
}

// 添加表情
const addEmoji = (emoji) => {
  inputMessage.value += emoji
  showEmoji.value = false
}

// 头像加载失败处理
const handleAvatarError = (e) => {
  e.target.src = defaultAvatar
}

// 格式化时间
const formatTime = (time) => {
  if (!time) return ''
  const date = new Date(time)
  const now = new Date()
  const diff = now - date
  
  if (diff < 60000) return '方才'
  if (diff < 3600000) return `${Math.floor(diff / 60000)}刻前`
  if (diff < 86400000) return `${Math.floor(diff / 3600000)}时辰前`
  if (diff < 604800000) return `${Math.floor(diff / 86400000)}日前`
  
  const month = date.getMonth() + 1
  const day = date.getDate()
  const hour = date.getHours().toString().padStart(2, '0')
  const minute = date.getMinutes().toString().padStart(2, '0')
  return `${month}月${day}日 ${hour}:${minute}`
}

// 模拟在线人数
const updateOnlineCount = () => {
  setInterval(() => {
    onlineCount.value = Math.floor(Math.random() * 50) + 20
  }, 30000)
}

// 轮询获取新消息
const startPolling = () => {
  pollTimer = setInterval(() => {
    fetchLatestMessages()
  }, 5000)
}

// 停止轮询
const stopPolling = () => {
  if (pollTimer) {
    clearInterval(pollTimer)
  }
}

onMounted(async () => {
  console.log('ForumChat 组件加载')
  await fetchCurrentUser()
  console.log('用户信息加载完成:', currentUser.value)
  await loadHistory(1)
  startPolling()
  updateOnlineCount()
})

onUnmounted(() => {
  stopPolling()
})
</script>

<style scoped>
.forum-chat {
  height: 100%;
  width: 100%;
  display: flex;
  flex-direction: column;
  background: #fdf8f0;
  overflow: hidden;
  font-family: "思源宋体", "STSong", "楷体", "KaiTi", serif;
}

/* 聊天头部 - 深红色渐变 */
.chat-header {
  padding: 14px 18px;
  background: linear-gradient(135deg, #9f2f25, #c44a3f);
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 20px;
}

.logo {
  display: flex;
  align-items: center;
  gap: 8px;
}

.logo-icon {
  font-size: 24px;
  filter: drop-shadow(2px 2px 4px rgba(0,0,0,0.1));
}

.logo h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #fff;
  letter-spacing: 2px;
}

.online-count {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: #fff;
  background: rgba(255, 255, 255, 0.2);
  padding: 4px 12px;
  border-radius: 20px;
}

.dot {
  width: 8px;
  height: 8px;
  background: #67c23a;
  border-radius: 50%;
  animation: pulse 1.5s ease-in-out infinite;
}

.icon-btn {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: 1px solid rgba(255, 255, 255, 0.3);
  background: rgba(255, 255, 255, 0.15);
  cursor: pointer;
  transition: all 0.3s ease;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  margin-left: 8px;
}

.icon-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
}

.icon {
  font-size: 18px;
  color: #fff;
}

.spinning {
  animation: spin 0.6s linear infinite;
}

/* 消息列表 */
.message-list {
  flex: 1;
  overflow-y: auto;
  padding: 16px;
  scroll-behavior: smooth;
  background: #fdf8f0;
}

.message-list::-webkit-scrollbar {
  width: 6px;
}

.message-list::-webkit-scrollbar-track {
  background: rgba(159, 47, 37, 0.1);
  border-radius: 3px;
}

.message-list::-webkit-scrollbar-thumb {
  background: rgba(159, 47, 37, 0.4);
  border-radius: 3px;
}

.load-more {
  text-align: center;
  padding: 12px;
  margin-bottom: 16px;
}

.load-more-btn {
  padding: 8px 20px;
  background: rgba(159, 47, 37, 0.08);
  border: 1px solid rgba(159, 47, 37, 0.3);
  border-radius: 8px;
  color: #8b7355;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-family: inherit;
}

.load-more-btn:hover {
  background: rgba(159, 47, 37, 0.15);
  border-color: #9f2f25;
  color: #9f2f25;
  transform: translateY(-2px);
}

.message-item {
  margin-bottom: 20px;
  display: flex;
  gap: 12px;
  animation: fadeInUp 0.3s ease-out;
}

/* 头像可点击样式 */
.avatar {
  flex-shrink: 0;
  cursor: pointer;
  transition: transform 0.2s ease, opacity 0.2s ease;
}

.avatar:hover {
  transform: scale(1.05);
  opacity: 0.9;
}

.avatar-img {
  width: 44px;
  height: 44px;
  border-radius: 0;
  border: 2px solid #9f2f25;
  object-fit: cover;
  background: #f5efe5;
}

.message-content {
  flex: 1;
  max-width: calc(100% - 60px);
}

.message-info {
  margin-bottom: 6px;
  display: flex;
  align-items: baseline;
  gap: 12px;
  flex-wrap: wrap;
}

/* 昵称可点击样式 - 深红色 */
.nickname {
  font-weight: 700;
  color: #9f2f25;
  font-size: 14px;
  letter-spacing: 1px;
  cursor: pointer;
  transition: color 0.2s ease;
}

.nickname:hover {
  color: #c44a3f;
  text-decoration: underline;
}

/* 自己的消息中昵称样式 */
.message-item.my-message .nickname {
  color: #9f2f25;
}

.message-item.my-message .nickname:hover {
  color: #c44a3f;
}

.time {
  font-size: 11px;
  color: #b8a28c;
  font-family: monospace;
}

/* 消息气泡 - 白色背景 */
.bubble {
  display: inline-block;
  max-width: 100%;
  padding: 10px 16px;
  background: #fff;
  border-radius: 8px;
  border: 1px solid #f0e0d0;
  box-shadow: 0 1px 3px rgba(159, 47, 37, 0.1);
  word-wrap: break-word;
  line-height: 1.6;
  font-size: 14px;
}

.bubble-text {
  color: #4a3b32;
}

/* 自己的消息气泡 - 左侧深红色边框 */
.message-item.my-message .bubble {
  background: linear-gradient(135deg, #fff5eb, #ffe8dc);
  border-left: 3px solid #9f2f25;
}

.message-item.my-message {
  flex-direction: row-reverse;
}

.message-item.my-message .message-content {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
}

.message-item.my-message .message-info {
  justify-content: flex-end;
}

/* 系统消息 */
.system-message {
  justify-content: center;
}

.system-bubble {
  background: rgba(159, 47, 37, 0.06);
  color: #8b7355;
  padding: 8px 20px;
  border-radius: 20px;
  font-size: 12px;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  border: 1px solid rgba(159, 47, 37, 0.15);
}

.system-icon {
  font-size: 14px;
}

/* 加载和空状态 */
.loading-tip, .empty-tip {
  text-align: center;
  padding: 60px 20px;
  color: #b8a28c;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  margin: 0 auto 16px;
  border: 3px solid rgba(159, 47, 37, 0.2);
  border-top-color: #9f2f25;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

.empty-icon {
  font-size: 64px;
  margin-bottom: 16px;
  opacity: 0.5;
}

/* 输入区域 */
.input-area {
  padding: 12px 16px;
  background: #fff;
  border-top: 1px solid rgba(159, 47, 37, 0.12);
}

.input-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.tool-btn {
  padding: 6px 12px;
  background: rgba(159, 47, 37, 0.06);
  border: 1px solid rgba(159, 47, 37, 0.25);
  border-radius: 8px;
  color: #8b7355;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s ease;
  font-family: inherit;
}

.tool-btn:hover, .tool-btn.active {
  background: rgba(159, 47, 37, 0.12);
  border-color: #9f2f25;
  color: #9f2f25;
}

.char-count {
  font-size: 12px;
  color: #b8a28c;
}

/* 表情面板 */
.emoji-panel {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  padding: 12px;
  background: #fff;
  border-radius: 8px;
  margin-bottom: 12px;
  border: 1px solid rgba(159, 47, 37, 0.2);
}

.emoji-item {
  font-size: 24px;
  cursor: pointer;
  padding: 6px;
  transition: transform 0.2s ease;
}

.emoji-item:hover {
  transform: scale(1.2);
}

.emoji-fade-enter-active,
.emoji-fade-leave-active {
  transition: all 0.2s ease;
}

.emoji-fade-enter-from,
.emoji-fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

/* 输入框 */
.input-wrapper textarea {
  width: 100%;
  padding: 12px 16px;
  border: 1px solid rgba(159, 47, 37, 0.3);
  border-radius: 8px;
  background: #fff;
  font-size: 14px;
  line-height: 1.5;
  resize: none;
  font-family: inherit;
  transition: all 0.2s ease;
}

.input-wrapper textarea:focus {
  outline: none;
  border-color: #9f2f25;
  box-shadow: 0 0 8px rgba(159, 47, 37, 0.12);
}

.input-actions {
  margin-top: 12px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.tips {
  display: flex;
  gap: 20px;
  font-size: 11px;
  color: #b8a28c;
}

/* 发送按钮 - 深红色 */
.send-btn {
  padding: 8px 24px;
  background: linear-gradient(135deg, #9f2f25, #c44a3f);
  border: none;
  border-radius: 8px;
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  font-family: inherit;
  letter-spacing: 2px;
}

.send-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(159, 47, 37, 0.4);
}

.send-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* 动画 */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

/* 响应式 */
@media (max-width: 768px) {
  .chat-header {
    padding: 10px 14px;
  }
  
  .logo h3 {
    font-size: 15px;
  }
  
  .online-count {
    font-size: 11px;
    padding: 2px 8px;
  }
  
  .message-list {
    padding: 12px;
  }
  
  .message-item {
    gap: 8px;
  }
  
  .avatar-img {
    width: 36px;
    height: 36px;
  }
  
  .bubble {
    padding: 8px 12px;
    font-size: 13px;
  }
  
  .input-area {
    padding: 10px 12px;
  }
  
  .tips {
    display: none;
  }
  
  .send-btn {
    padding: 6px 18px;
    font-size: 13px;
  }
}
</style>