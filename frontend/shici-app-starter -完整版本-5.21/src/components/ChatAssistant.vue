<!-- src/components/ChatAssistant.vue -->
<template>
  <!-- 悬浮按钮 -->
  <div
      class="assistant-trigger"
      :class="{ hidden: isOpen }"
      :style="triggerStyle"
      @mousedown="startDragTrigger"
      @click="handleTriggerClick"
  >
    <span class="assistant-icon floating-brush">🖌️</span>
    <span class="assistant-label">文襄</span>
  </div>

  <!-- 聊天窗口 -->
  <Transition name="slide-up">
    <div v-if="isOpen" class="assistant-panel" :style="panelStyle">
      <!-- 头部（可拖拽） -->
      <div 
        class="panel-header" 
        @mousedown="startDragPanel"
        :class="{ dragging: isDraggingPanel }"
      >
        <div class="header-title">
          <span class="avatar">🖋️</span>
          <span>文襄</span>
        </div>
        <div class="header-actions">
          <span class="drag-hint" v-if="!isDraggingPanel">⋮⋮ 拖拽移动</span>
          <button class="close-btn" @click="closeChat">×</button>
        </div>
      </div>

      <!-- 消息区域 -->
      <div class="messages-container" ref="messagesRef">
        <div class="welcome-section">
          <div class="welcome-icon">🖌️</div>
          <h3>文襄</h3>
          <p>遇见诗词，遇见美</p>
        </div>
        <div
            v-for="(msg, index) in messages"
            :key="index"
            class="message"
            :class="msg.role"
        >
          <div v-if="msg.role === 'assistant'" class="avatar-mini">🖋️</div>
          <div class="message-content">
            {{ msg.content }}
            <div class="message-time">{{ msg.time || '刚刚' }}</div>
          </div>
          <div v-if="msg.role === 'user'" class="avatar-mini user">我</div>
        </div>
        <div v-if="loading" class="message assistant">
          <div class="message-content loading">
            <span class="dot"></span>
            <span class="dot"></span>
            <span class="dot"></span>
          </div>
        </div>
      </div>

      <!-- 输入区域 -->
      <div class="input-area">
        <input
            v-model="inputText"
            @keyup.enter="sendMessage"
            placeholder="问我关于诗词的问题..."
            :disabled="loading"
        />
        <button @click="sendMessage" :disabled="loading || !inputText.trim()">
          发送
        </button>
      </div>
    </div>
  </Transition>
</template>

<script setup>
import { ref, nextTick, computed, onMounted, onUnmounted } from 'vue'
import axios from 'axios'

const isOpen = ref(false)
const inputText = ref('')
const loading = ref(false)
const messages = ref([
  { 
    role: 'assistant', 
    content: '你好！我是文襄，很高兴为你服务。你可以问我关于诗词解析、诗人背景、填词技巧等方面的问题。🖋️',
    time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
  }
])
const messagesRef = ref(null)

// 拖拽相关状态
const triggerX = ref(window.innerWidth - 84) // 初始位置：右下角
const triggerY = ref(window.innerHeight - 84)
const panelX = ref(window.innerWidth - 384)
const panelY = ref(window.innerHeight - 524)

const isDraggingTrigger = ref(false)
const isDraggingPanel = ref(false)
const dragStartX = ref(0)
const dragStartY = ref(0)
const dragStartOffsetX = ref(0)
const dragStartOffsetY = ref(0)

// 是否发生了拖拽（用于区分点击和拖拽）
const hasDragged = ref(false)

// 触发按钮样式
const triggerStyle = computed(() => ({
  right: 'auto',
  bottom: 'auto',
  left: `${triggerX.value}px`,
  top: `${triggerY.value}px`
}))

// 面板样式
const panelStyle = computed(() => ({
  right: 'auto',
  bottom: 'auto',
  left: `${panelX.value}px`,
  top: `${panelY.value}px`
}))

// 开始拖拽触发按钮
const startDragTrigger = (e) => {
  e.preventDefault()
  isDraggingTrigger.value = true
  hasDragged.value = false
  dragStartX.value = e.clientX
  dragStartY.value = e.clientY
  dragStartOffsetX.value = triggerX.value
  dragStartOffsetY.value = triggerY.value
  
  document.addEventListener('mousemove', onDragTrigger)
  document.addEventListener('mouseup', stopDragTrigger)
}

// 拖拽触发按钮中
const onDragTrigger = (e) => {
  if (!isDraggingTrigger.value) return
  
  const deltaX = e.clientX - dragStartX.value
  const deltaY = e.clientY - dragStartY.value
  
  // 如果移动超过5px，认为是拖拽
  if (Math.abs(deltaX) > 5 || Math.abs(deltaY) > 5) {
    hasDragged.value = true
  }
  
  // 计算新位置，限制在窗口范围内
  const newX = Math.max(0, Math.min(window.innerWidth - 60, dragStartOffsetX.value + deltaX))
  const newY = Math.max(0, Math.min(window.innerHeight - 60, dragStartOffsetY.value + deltaY))
  
  triggerX.value = newX
  triggerY.value = newY
}

// 停止拖拽触发按钮
const stopDragTrigger = () => {
  isDraggingTrigger.value = false
  document.removeEventListener('mousemove', onDragTrigger)
  document.removeEventListener('mouseup', stopDragTrigger)
}

// 处理触发按钮点击
const handleTriggerClick = () => {
  // 如果发生了拖拽，不触发点击
  if (hasDragged.value) return
  openChat()
}

// 开始拖拽面板
const startDragPanel = (e) => {
  // 只在头部区域拖拽，避免影响关闭按钮
  if (e.target.closest('.close-btn') || e.target.closest('.drag-hint')) return
  
  e.preventDefault()
  isDraggingPanel.value = true
  dragStartX.value = e.clientX
  dragStartY.value = e.clientY
  dragStartOffsetX.value = panelX.value
  dragStartOffsetY.value = panelY.value
  
  document.addEventListener('mousemove', onDragPanel)
  document.addEventListener('mouseup', stopDragPanel)
}

// 拖拽面板中
const onDragPanel = (e) => {
  if (!isDraggingPanel.value) return
  
  const deltaX = e.clientX - dragStartX.value
  const deltaY = e.clientY - dragStartY.value
  
  // 计算新位置，限制在窗口范围内
  const newX = Math.max(0, Math.min(window.innerWidth - 360, dragStartOffsetX.value + deltaX))
  const newY = Math.max(0, Math.min(window.innerHeight - 100, dragStartOffsetY.value + deltaY))
  
  panelX.value = newX
  panelY.value = newY
}

// 停止拖拽面板
const stopDragPanel = () => {
  isDraggingPanel.value = false
  document.removeEventListener('mousemove', onDragPanel)
  document.removeEventListener('mouseup', stopDragPanel)
}

// 打开聊天窗口
const openChat = () => {
  isOpen.value = true
  // 面板初始位置跟随按钮
  panelX.value = Math.min(triggerX.value, window.innerWidth - 380)
  panelY.value = Math.max(0, triggerY.value - 520)
}

// 关闭聊天窗口
const closeChat = () => {
  isOpen.value = false
}

// 发送消息
const sendMessage = async () => {
  const text = inputText.value.trim()
  if (!text || loading.value) return

  const now = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })

  // 添加用户消息
  messages.value.push({ 
    role: 'user', 
    content: text,
    time: now
  })
  inputText.value = ''
  loading.value = true

  // 滚动到底部
  await nextTick()
  scrollToBottom()

  try {
    // 构建历史记录（最近5轮）
    const history = messages.value.slice(-10).map(m => ({
      role: m.role === 'assistant' ? 'assistant' : 'user',
      content: m.content
    }))

    const res = await axios.post('/api/assistant/chat', {
      message: text,
      history: history
    })

    const assistantTime = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })

    if (res.data.data?.success) {
      messages.value.push({
        role: 'assistant',
        content: res.data.data.reply,
        time: assistantTime
      })
    } else {
      messages.value.push({
        role: 'assistant',
        content: '抱歉，出了点问题，请稍后再试~',
        time: assistantTime
      })
    }
  } catch (error) {
    console.error('发送失败:', error)
    const errorTime = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    messages.value.push({
      role: 'assistant',
      content: '网络连接失败，请检查网络后重试~',
      time: errorTime
    })
  } finally {
    loading.value = false
    await nextTick()
    scrollToBottom()
  }
}

// 滚动到底部
const scrollToBottom = () => {
  if (messagesRef.value) {
    messagesRef.value.scrollTop = messagesRef.value.scrollHeight
  }
}

// 窗口大小变化时调整位置
const handleResize = () => {
  triggerX.value = Math.min(triggerX.value, window.innerWidth - 60)
  triggerY.value = Math.min(triggerY.value, window.innerHeight - 60)
  panelX.value = Math.min(panelX.value, window.innerWidth - 360)
  panelY.value = Math.min(panelY.value, window.innerHeight - 100)
}

onMounted(() => {
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  document.removeEventListener('mousemove', onDragTrigger)
  document.removeEventListener('mouseup', stopDragTrigger)
  document.removeEventListener('mousemove', onDragPanel)
  document.removeEventListener('mouseup', stopDragPanel)
})
</script>

<style scoped>
/* 触发按钮 */
.assistant-trigger {
  position: fixed;
  width: 64px;
  height: 64px;
  background-color: #f2e8d5; /* 深一点的宣纸色 */
  background-image: radial-gradient(#e2d5bd 1px, transparent 1px);
  background-size: 12px 12px;
  border: 1.5px solid #8b7d6b; /* 灰褐色边框 */
  border-radius: 50%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: grab;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  z-index: 1000;
  user-select: none;
}

.assistant-trigger:active {
  cursor: grabbing;
  transform: scale(0.95);
}

.assistant-trigger:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
  border-color: #6b5e4f;
}

.assistant-trigger.hidden {
  display: none;
}

.assistant-icon {
  font-size: 28px;
  filter: grayscale(1) contrast(1.2);
  transform: rotate(-15deg);
}

.floating-brush {
  animation: floatBrush 3s ease-in-out infinite;
}

@keyframes floatBrush {
  0% { transform: translateY(0) rotate(-15deg); }
  50% { transform: translateY(-6px) rotate(-10deg); }
  100% { transform: translateY(0) rotate(-15deg); }
}

.assistant-label {
  font-size: 10px;
  color: #5c4f3f;
  font-weight: 600;
  margin-top: 1px;
  letter-spacing: 0.5px;
}

/* 聊天面板 */
.assistant-panel {
  position: fixed;
  width: 400px;   
  height: 600px;
  background: #fdfaf5;
  border-radius: 24px;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
  display: flex;
  flex-direction: column;
  z-index: 1001;
  overflow: hidden;
  border: 1px solid #e2d5bd;
}

/* 头部 */
.panel-header {
  background: #f2e8d5;
  color: #4a3b36;
  padding: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: grab;
  user-select: none;
  border-bottom: 1px solid #e2d5bd;
}

.panel-header:active,
.panel-header.dragging {
  cursor: grabbing;
}

.header-title {
  display: flex;
  align-items: center;
  gap: 12px;
  font-weight: 700;
  font-size: 18px;
  color: #4a3b36;
}

.avatar {
  font-size: 24px;
  filter: grayscale(1);
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.drag-hint {
  font-size: 12px;
  color: #8b7d6b;
  opacity: 0.8;
}

.close-btn {
  background: #dcd0bc;
  border: none;
  color: #4a3b36;
  font-size: 20px;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}

.close-btn:hover {
  background: #cebfab;
}

/* 消息区域 */
.messages-container {
  flex: 1;
  overflow-y: auto;
  padding: 30px 20px;
  background: #fdfaf5;
  background-image: 
    linear-gradient(rgba(243, 233, 217, 0.3) 1px, transparent 1px),
    linear-gradient(90deg, rgba(243, 233, 217, 0.3) 1px, transparent 1px);
  background-size: 30px 30px;
}

.welcome-section {
  text-align: center;
  padding: 40px 0;
  color: #8b7d6b;
}

.welcome-icon {
  font-size: 48px;
  margin-bottom: 15px;
  filter: grayscale(1);
}

.welcome-section h3 {
  font-size: 22px;
  margin: 0;
  color: #4a3b36;
}

.welcome-section p {
  font-size: 14px;
  margin: 8px 0 0;
  opacity: 0.8;
}

.message {
  margin-bottom: 24px;
  display: flex;
  align-items: flex-start;
  gap: 12px;
}

.message.user {
  justify-content: flex-end;
}

.avatar-mini {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  flex-shrink: 0;
  background: #f2e8d5;
  border: 1px solid #e2d5bd;
}

.avatar-mini.user {
  background: #ece3d4;
  color: #4a3b36;
  font-size: 14px;
  font-weight: bold;
}

.message-content {
  max-width: 75%;
  padding: 15px 20px;
  border-radius: 20px;
  font-size: 16px;
  line-height: 1.6;
  white-space: pre-wrap;
  position: relative;
  background: white;
  color: #4a3b36;
  border: 1px solid #e2d5bd;
  box-shadow: 0 2px 10px rgba(0,0,0,0.03);
}

.message-time {
  font-size: 12px;
  margin-top: 8px;
  color: #8b7d6b;
  opacity: 0.6;
  text-align: right;
}

.message.user .message-content {
  background: #ece3d4;
  border-color: #dcd0bc;
}

/* 加载动画 */
.loading {
  display: flex;
  gap: 8px;
  padding: 10px 15px;
}

.dot {
  width: 8px;
  height: 8px;
  background: #8b7d6b;
  border-radius: 50%;
  animation: bounce 1.4s infinite ease-in-out both;
}

/* 输入区域 */
.input-area {
  padding: 20px;
  background: #f2e8d5;
  border-top: 1px solid #e2d5bd;
  display: flex;
  gap: 15px;
  align-items: center;
}

.input-area input {
  flex: 1;
  padding: 12px 24px;
  border: 1px solid white;
  border-radius: 30px;
  outline: none;
  font-size: 16px;
  background: white;
  color: #4a3b36;
}

.input-area button {
  padding: 0 24px;
  height: 44px;
  background: #b8ac9a;
  color: white;
  border: none;
  border-radius: 22px;
  cursor: pointer;
  font-weight: 600;
  font-size: 16px;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.input-area button:hover:not(:disabled) {
  background: #a99d8a;
}

.input-area button:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

/* 动画 */
.slide-up-enter-active,
.slide-up-leave-active {
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.slide-up-enter-from,
.slide-up-leave-to {
  opacity: 0;
  transform: translateY(30px) scale(0.95);
}

/* 移动端适配 */
@media (max-width: 480px) {
  .assistant-panel {
    width: calc(100vw - 32px);
    height: calc(100vh - 100px);
    max-height: 500px;
  }
  
  .drag-hint {
    display: none;
  }
}
</style>
