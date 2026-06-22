<template>
  <div class="agent-chat-full" :style="{ backgroundImage: `url(${currentPoet.image})` }">
    <!-- 半透明遮罩层 -->
    <div class="bg-overlay"></div>
    
    <!-- 顶部导航 -->
    <div class="chat-header">
      <div class="header-left">
        <span class="back-btn" @click="goBack">←</span>
        <div class="agent-info">
          <div class="agent-avatar" :style="{ backgroundImage: `url(${currentPoet.image})` }"></div>
          <div class="agent-details">
            <div class="agent-name">{{ currentPoet.name }}</div>
            <div class="agent-meta">
              <span class="agent-dynasty">{{ currentPoet.dynasty }}</span>
              <span class="agent-desc">{{ currentPoet.desc }}</span>
            </div>
            <!-- 智能体简介放在导航栏内部 -->
            <div class="agent-bio-inline">
              {{ getIntroduction(currentPoet.id) }}
            </div>
          </div>
        </div>
      </div>
      <div class="header-right">
        <span class="icon">⋯</span>
      </div>
    </div>

    <!-- 聊天消息区域 -->
    <div class="chat-messages" ref="messagesRef">
      <div v-for="(msg, index) in messages" :key="index" 
           class="message" 
           :class="msg.role">
        <div class="message-avatar" v-if="msg.role === 'assistant'" 
             :style="{ backgroundImage: `url(${currentPoet.image})` }">
        </div>
        <div class="message-avatar" v-else>
          👤
        </div>
        <div class="message-content">
          <div class="message-bubble">{{ msg.content }}</div>
          <div class="message-time">{{ msg.time }}</div>
        </div>
      </div>
      
      <!-- 加载状态 -->
      <div v-if="loading" class="message assistant">
        <div class="message-avatar" :style="{ backgroundImage: `url(${currentPoet.image})` }"></div>
        <div class="message-content">
          <div class="typing-indicator">
            <span></span>
            <span></span>
            <span></span>
          </div>
        </div>
      </div>
    </div>

    <!-- 快捷提问 -->
    <div class="quick-questions" v-if="showQuickQuestions">
      <div class="quick-title">问问{{ currentPoet.name }}</div>
      <div class="question-list">
        <div 
          v-for="(q, index) in quickQuestions" 
          :key="index"
          class="question-item"
          @click="inputMessage = q"
        >
          {{ q }}
        </div>
      </div>
    </div>

    <!-- 输入区域 -->
    <div class="input-area">
      <textarea
        v-model="inputMessage"
        placeholder="输入你的问题..."
        rows="1"
        @keydown.enter.exact.prevent="sendMessage"
      ></textarea>
      <button class="send-btn" @click="sendMessage" :disabled="!inputMessage.trim() || loading">
        发送
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { aiChat } from '@/utils/api'

const route = useRoute()
const router = useRouter()

// 从路由参数获取诗人信息
const currentPoet = ref({
  id: route.query.id || 'libai',
  name: route.query.name || '李白',
  dynasty: route.query.dynasty || '唐',
  desc: route.query.desc || '诗仙',
  image: route.query.image || ''
})

const messages = ref([])
const inputMessage = ref('')
const loading = ref(false)
const showQuickQuestions = ref(true)
const messagesRef = ref(null)

// 快捷问题
const quickQuestions = computed(() => {
  const questions = {
    libai: ['《静夜思》的创作背景', '你最喜欢的自己的诗', '为什么被称为诗仙'],
    dufu: ['《春望》表达了什么', '你和李白的关系', '为什么叫诗史'],
    bai_juyi: ['《长恨歌》写了多久', '新乐府运动是什么', '为什么诗通俗易懂'],
    wangwei: ['诗中有画是什么意思', '《山居秋暝》赏析', '佛教对诗的影响'],
    sushi: ['《水调歌头》背景', '被贬经历的影响', '除了诗词还有什么成就'],
    liqingzhao: ['《如梦令》赏析', '婉约派特点', '你的爱情观'],
    xinqiji: ['豪放派特点', '《青玉案》解析', '武将词人的经历'],
    lin_daiyu: ['你的诗词风格', '葬花吟的寓意', '对宝玉的感情'],
  }
  return questions[currentPoet.value.id] || [
    '介绍一下你自己',
    '你的代表作是什么',
    '有什么想对现代人说的'
  ]
})

// 诗人简介
const getIntroduction = (id) => {
  const intros = {
    libai: '李白（701年－762年），字太白，号青莲居士，唐代伟大的浪漫主义诗人，被后人誉为“诗仙”。其诗飘逸奔放，意境奇妙，对后世影响深远。',
    dufu: '杜甫（712年－770年），字子美，唐代伟大的现实主义诗人，被后人誉为“诗圣”。其诗沉郁顿挫，反映社会现实，被称为“诗史”。',
    bai_juyi: '白居易（772年－846年），字乐天，号香山居士，唐代著名诗人。主张“文章合为时而著，歌诗合为事而作”，诗风通俗易懂。',
    wangwei: '王维（701年－761年），字摩诘，号摩诘居士，唐代著名诗人、画家。精通诗、书、画、音乐，被誉为“诗佛”。',
    sushi: '苏轼（1037年－1101年），字子瞻，号东坡居士，宋代文学家、书画家。诗词文书画俱佳，是宋代文学最高成就的代表。',
    liqingzhao: '李清照（1084年－1155年），号易安居士，宋代女词人，婉约派代表。词风婉约含蓄，情感真挚，被誉为“千古第一才女”。',
    xinqiji: '辛弃疾（1140年－1207年），字幼安，号稼轩，宋代豪放派词人。既是词人又是将领，词风豪放悲壮。',
    lin_daiyu: '林黛玉，中国古典名著《红楼梦》中的人物，金陵十二钗之首。才情卓绝，多愁善感，诗词造诣极高。',
  }
  return intros[id] || `我是${currentPoet.value.name}，很高兴与你对话。`
}

// 返回上一页
const goBack = () => {
  router.back()
}

// 发送消息
const sendMessage = async () => {
  if (!inputMessage.value.trim() || loading.value) return

  const userMessage = inputMessage.value
  messages.value.push({
    role: 'user',
    content: userMessage,
    time: new Date().toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
  })

  inputMessage.value = ''
  loading.value = true
  showQuickQuestions.value = false
  scrollToBottom()

  try {
    const prompt = `你现在是${currentPoet.value.name}（${currentPoet.value.dynasty}代${currentPoet.value.desc}），请以${currentPoet.value.name}的身份和口吻回答用户的问题。用第一人称，保持古人的语气和风格，但要让现代人听得懂。问题：${userMessage}`
    
    const result = await aiChat(prompt, '三步法讲解')
    
    if (result.success) {
      messages.value.push({
        role: 'assistant',
        content: result.content,
        time: new Date().toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
      })
    } else {
      messages.value.push({
        role: 'assistant',
        content: '抱歉，我现在无法回答，请稍后再试。',
        time: new Date().toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
      })
    }
  } catch (error) {
    console.error('发送失败:', error)
    messages.value.push({
      role: 'assistant',
      content: '网络错误，请稍后重试',
      time: new Date().toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
    })
  } finally {
    loading.value = false
    scrollToBottom()
  }
}

const scrollToBottom = async () => {
  await nextTick()
  if (messagesRef.value) {
    messagesRef.value.scrollTop = messagesRef.value.scrollHeight
  }
}

onMounted(() => {
  console.log('路由参数:', route.query)  // 查看所有传递的参数
  console.log('图片路径:', route.query.image)  // 查看图片路径
  
  currentPoet.value = {
    id: route.query.id || 'libai',
    name: route.query.name || '李白',
    dynasty: route.query.dynasty || '唐',
    desc: route.query.desc || '诗仙',
    image: route.query.image || ''  // 确保这里能接收到
  }
  
  console.log('当前诗人:', currentPoet.value)
  
  messages.value.push({
    role: 'assistant',
    content: `你好，我是${currentPoet.value.name}。有什么想问我的吗？`,
    time: new Date().toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
  })
})
</script>

<style scoped>
.agent-chat-full {
  min-height: 100vh;
  width: 100%;
  background-size: cover;
  background-position: center;
  background-attachment: fixed;
  position: relative;
  display: flex;
  flex-direction: column;
}

/* 半透明遮罩层 */
.bg-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
  z-index: 0;
}

/* 所有内容都在遮罩层上面 */
.chat-header,
.chat-messages,
.quick-questions,
.input-area {
  position: relative;
  z-index: 1;
}

/* 聊天头部 */
.chat-header {
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  padding: 16px 32px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid rgba(0,0,0,0.05);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 20px;
}

.back-btn {
  font-size: 28px;
  color: #333;
  cursor: pointer;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  background: rgba(255,255,255,0.5);
  transition: all 0.2s;
}

.back-btn:hover {
  background: rgba(255,255,255,0.8);
}

.agent-info {
  display: flex;
  align-items: center;
  gap: 16px;
}

.agent-avatar {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  border: 3px solid white;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.agent-details {
  display: flex;
  flex-direction: column;
}

.agent-name {
  font-size: 24px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.agent-meta {
  display: flex;
  gap: 12px;
  font-size: 14px;
  color: #666;
}

.agent-dynasty {
  background: rgba(0,0,0,0.05);
  padding: 4px 12px;
  border-radius: 20px;
}

.agent-desc {
  color: #666;
}

/* 智能体简介放在导航栏内部 */
.agent-bio-inline {
  font-size: 13px;
  color: #666;
  margin-top: 4px;
  max-width: 600px;
  line-height: 1.5;
  opacity: 0.9;
}

.header-right .icon {
  font-size: 24px;
  color: #666;
  cursor: pointer;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  background: rgba(255,255,255,0.5);
  transition: all 0.2s;
}

.header-right .icon:hover {
  background: rgba(255,255,255,0.8);
}

/* 聊天消息区域 */
.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 32px;
  display: flex;
  flex-direction: column;
  gap: 20px;
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
}

/* 消息样式 */
.message {
  display: flex;
  gap: 16px;
}

.message.user {
  flex-direction: row-reverse;
}

.message-avatar {
  width: 48px;
  height: 48px;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  border-radius: 50%;
  flex-shrink: 0;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.message.user .message-avatar {
  background: #007AFF;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  color: white;
}

.message-content {
  max-width: 60%;
}

.message-bubble {
  padding: 16px 20px;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  border-bottom-left-radius: 4px;
  font-size: 15px;
  line-height: 1.6;
  color: #333;
  box-shadow: 0 4px 16px rgba(0,0,0,0.05);
}

.message.user .message-bubble {
  background: #007AFF;
  color: white;
  border-bottom-right-radius: 4px;
  border-bottom-left-radius: 20px;
}

.message-time {
  font-size: 12px;
  color: #999;
  margin-top: 6px;
  text-align: right;
}

/* 快捷提问区域 */
.quick-questions {
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  padding: 20px 32px;
  border-top: 1px solid rgba(0,0,0,0.05);
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
}

.quick-title {
  font-size: 16px;
  font-weight: 500;
  color: #666;
  margin-bottom: 16px;
}

.question-list {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.question-item {
  padding: 10px 20px;
  background: rgba(255,255,255,0.9);
  border: 1px solid rgba(0,0,0,0.1);
  border-radius: 30px;
  font-size: 14px;
  color: #333;
  cursor: pointer;
  transition: all 0.2s;
}

.question-item:hover {
  background: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

/* 输入区域 */
.input-area {
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  padding: 20px 32px;
  border-top: 1px solid rgba(0,0,0,0.05);
  display: flex;
  gap: 16px;
  align-items: flex-end;
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
}

textarea {
  flex: 1;
  border: 1px solid rgba(0,0,0,0.1);
  border-radius: 30px;
  padding: 14px 24px;
  font-size: 15px;
  resize: none;
  outline: none;
  max-height: 120px;
  font-family: inherit;
  background: rgba(255,255,255,0.9);
  transition: all 0.2s;
}

textarea:focus {
  border-color: #007AFF;
  box-shadow: 0 0 0 3px rgba(0,122,255,0.1);
}

.send-btn {
  width: 100px;
  height: 52px;
  background: #007AFF;
  color: white;
  border: none;
  border-radius: 30px;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.send-btn:hover:not(:disabled) {
  background: #0056b3;
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0,122,255,0.3);
}

.send-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
}

/* 打字动画 */
.typing-indicator {
  display: flex;
  gap: 4px;
  padding: 12px 16px;
  background: white;
  border-radius: 18px;
  border-bottom-left-radius: 4px;
  align-items: center;
}

.typing-indicator span {
  width: 8px;
  height: 8px;
  background: #007AFF;
  border-radius: 50%;
  animation: typing 1.4s infinite;
}

.typing-indicator span:nth-child(2) {
  animation-delay: 0.2s;
}

.typing-indicator span:nth-child(3) {
  animation-delay: 0.4s;
}

@keyframes typing {
  0%, 60%, 100% {
    transform: translateY(0);
    opacity: 0.6;
  }
  30% {
    transform: translateY(-6px);
    opacity: 1;
  }
}
</style>