<template>
  <div class="ai" @mousemove="onMouseMove" @mouseleave="resetMouse">
    <!-- 顶部栏 -->
    <div class="topBar">
      <div class="brand">
        <div class="t1">AI教师</div>
        <div class="t2">立体形象 · 语音对话 · 讲解 / 答疑 / 纠错（演示版）</div>
      </div>

      <div class="modes">
        <button class="mode" :class="{ on: mode==='explain' }" @click="setMode('explain')">讲解</button>
        <button class="mode" :class="{ on: mode==='qa' }" @click="setMode('qa')">答疑</button>
        <button class="mode" :class="{ on: mode==='fix' }" @click="setMode('fix')">纠错</button>
      </div>

      <div class="ops">
        <button class="ghost" @click="mockIntro">示例</button>
        <button class="ghost" @click="clearChat">清空</button>
        <button class="primary" @click="drawerOpen = !drawerOpen">{{ drawerOpen ? '收起工具' : '展开工具' }}</button>
      </div>
    </div>

    <div class="main">
      <!-- 左：3D AI 老师 -->
      <aside class="left">
        <div
          class="teacherCard"
          :style="teacherCardStyle"
          @mouseenter="hoverTeacher=true"
          @mouseleave="hoverTeacher=false"
        >
          <!-- 细腻环面/光晕层 -->
          <div class="torusWrap" aria-hidden="true">
            <div class="torus t1"></div>
            <div class="torus t2"></div>
            <div class="torus t3"></div>
            <div class="spark s1"></div>
            <div class="spark s2"></div>
            <div class="spark s3"></div>
          </div>

          <div class="teacherHead">
            <div class="tag">墨墨老师</div>
            <div class="state">
              <span class="dot" :class="{ talk: isTalking || isListening }"></span>
              <span class="txt">{{ isListening ? '听你说话…' : (isTalking ? '正在回应…' : '在线') }}</span>
            </div>
          </div>

          <div class="stage">
            <!-- 立体舞台光 -->
            <div class="light" aria-hidden="true"></div>
            <div class="mist" aria-hidden="true"></div>
            <div class="grain" aria-hidden="true"></div>

            <!-- 老师立绘（伪3D：视差+点头/摆手） -->
            <div class="avatar3d" :class="avatarMotionClass" :style="avatarStyle">
              <img class="teacherImg" :src="teacherImg" alt="teacher" draggable="false" />

              <!-- 眼睛跟随：两个“瞳孔”浮层（位置大概在脸部区域） -->
              <div class="eyes" aria-hidden="true">
                <span class="eye eL"><i class="pupil" :style="pupilStyle"></i></span>
                <span class="eye eR"><i class="pupil" :style="pupilStyle"></i></span>
              </div>

              <!-- 说话波纹 -->
              <div class="speak" v-if="isTalking" aria-hidden="true">
                <span class="ring r1"></span>
                <span class="ring r2"></span>
                <span class="ring r3"></span>
              </div>

              <!-- 听你说话时的麦克风波纹 -->
              <div class="listen" v-if="isListening" aria-hidden="true">
                <span class="micRing m1"></span>
                <span class="micRing m2"></span>
              </div>
            </div>
          </div>

          <!-- 老师引导气泡 -->
          <div class="coach">
            <div class="coachTitle">老师引导</div>

            <button class="coachBubble" @click="fillInput(suggestions[mode][0])">
              <span class="q">“</span>{{ suggestions[mode][0] }}<span class="q">”</span>
            </button>
            <button class="coachBubble" @click="fillInput(suggestions[mode][1])">
              <span class="q">“</span>{{ suggestions[mode][1] }}<span class="q">”</span>
            </button>
            <button class="coachBubble subtle" @click="fillInput(suggestions[mode][2])">
              <span class="q">“</span>{{ suggestions[mode][2] }}<span class="q">”</span>
            </button>
          </div>

          <!-- 语音控制（你要的“通话”效果核心） -->
          <div class="voiceBox">
            <div class="vbTitle">语音对话</div>

            <div class="vbRow">
              <button class="vBtn" :class="{ on: voiceAutoSpeak }" @click="voiceAutoSpeak = !voiceAutoSpeak">
                {{ voiceAutoSpeak ? '已开启朗读' : '开启朗读' }}
              </button>

              <button class="vBtn ghost2" :disabled="!speechSupported" @click="toggleListen">
                {{ isListening ? '停止听写' : '按住说话(点一下)' }}
              </button>
            </div>

            <div class="vbTip" v-if="!speechSupported">
              你的浏览器不支持语音识别（SpeechRecognition）。你仍可使用“朗读”功能。
            </div>
            <div class="vbTip" v-else>
              提示：首次使用会弹出麦克风权限；在 localhost 上一般可用。
            </div>
          </div>
        </div>
      </aside>

      <!-- 中：大屏对话 -->
      <main class="center">
        <div class="chatCard">
          <div class="chatTop">
            <div class="chipRow">
              <button class="chip" @click="fillInput('请用三步法讲解《静夜思》，并标出考点。')">三步法讲解</button>
              <button class="chip" @click="fillInput('逐句解释“海内存知己，天涯若比邻”，给意象与情感。')">逐句赏析</button>
              <button class="chip" @click="fillInput('出5道理解题（含答案解析）。')">出题训练</button>
              <button class="chip" @click="fillInput('我背诵总卡壳，请给停顿与重音建议。')">朗诵建议</button>
              <button class="chip ghost2" @click="fillInput('把这首诗改写成现代白话文，保留意境。')">白话改写</button>
            </div>

            <div class="hint">
              <span class="hTag">{{ modeName }}</span>
              <span class="hText">Enter 发送，Shift+Enter 换行</span>
            </div>
          </div>

          <div class="chatBody" ref="chatBodyRef">
            <div v-if="messages.length===0" class="zero">
              <div class="zTitle">开始对话</div>
              <div class="zSub">左侧是“立体老师形象”，中间是沉浸聊天区，右侧抽屉是工具。</div>

              <div class="zGrid">
                <button class="zCard" @click="fillInput('请讲解《春晓》：背景、逐句注释、意象、考点、速记。')">
                  <div class="zH">讲解模板</div>
                  <div class="zS">背景→注释→赏析→考点→速记</div>
                </button>
                <button class="zCard" @click="fillInput('我想练朗诵《静夜思》，请给停顿、重音、情感线。')">
                  <div class="zH">朗诵训练</div>
                  <div class="zS">停顿/重音/情感线/易错点</div>
                </button>
                <button class="zCard" @click="fillInput('请出一套《望岳》练习：选择+简答，含解析。')">
                  <div class="zH">题目生成</div>
                  <div class="zS">题目+答案+解析</div>
                </button>
              </div>
            </div>

            <div v-for="m in messages" :key="m.id" class="msg" :class="m.role">
              <div class="av">{{ m.role==='assistant' ? '墨' : '我' }}</div>
              <div class="bub">
                <div class="meta">
                  <span class="who">{{ m.role==='assistant' ? '墨墨老师' : '你' }}</span>
                  <span class="time">{{ m.time }}</span>
                </div>
                <div class="ct" v-html="m.html"></div>

                <div class="actRow" v-if="m.role==='assistant'">
                  <button class="mini" @click="speakText(stripHtml(m.html))" :disabled="!ttsSupported">朗读</button>
                  <button class="mini ghost2" @click="fillInput('把上面的回答压缩成3条要点。')">变要点</button>
                  <button class="mini ghost2" @click="fillInput('基于上面内容，出3道题并给答案解析。')">出题</button>
                </div>
              </div>
            </div>
          </div>

          <div class="composer">
            <textarea
              v-model="input"
              class="input"
              rows="2"
              placeholder="输入你的问题（可点左侧语音听写），例如：这句诗表达了什么情感？"
              @keydown.enter.exact.prevent="send()"
              @keydown.enter.shift.exact.stop
            ></textarea>

            <button class="send" :disabled="!input.trim() || isTalking" @click="send">
              {{ isTalking ? '生成中…' : '发送' }}
            </button>
          </div>
        </div>
      </main>

      <!-- 右：抽屉工具面板（滑出） -->
      <aside class="drawer" :class="{ open: drawerOpen }">
        <div class="drawerInner">
          <div class="pTitle">
            工具抽屉
            <button class="close" @click="drawerOpen=false">×</button>
          </div>

          <div class="box">
            <div class="bTitle">结构模板</div>
            <div class="tpl">
              <div class="pill2">① 主旨</div>
              <div class="pill2">② 注释</div>
              <div class="pill2">③ 意象</div>
              <div class="pill2">④ 情感线</div>
              <div class="pill2">⑤ 手法考点</div>
              <div class="pill2">⑥ 1分钟速记</div>
            </div>
          </div>

          <div class="box">
            <div class="bTitle">快捷填充</div>
            <div class="qs">
              <button class="qBtn" @click="fillInput('请按“背景/注释/赏析/考点/速记”输出：')">按结构输出</button>
              <button class="qBtn" @click="fillInput('请给3种记忆口令，帮助背诵：')">背诵口令</button>
              <button class="qBtn" @click="fillInput('把这首诗拆成可朗诵的停顿节奏（用 / 标注）：')">停顿节奏</button>
              <button class="qBtn" @click="fillInput('给我5个同主题拓展诗句，并简述关联：')">同主题拓展</button>
            </div>
          </div>

          <div class="box">
            <div class="bTitle">高级外观（你想要更妙）</div>
            <div class="desc">
              <div class="row"><span class="k">环面</span><span class="v">已用多层 torus + blur + conic 实现</span></div>
              <div class="row"><span class="k">3D</span><span class="v">鼠标视差 + 阴影 + 细噪点</span></div>
              <div class="row"><span class="k">动作</span><span class="v">点头/摆手/说话波纹已联动</span></div>
            </div>
          </div>

          <div class="box">
            <div class="bTitle">语音说明</div>
            <div class="desc">
              <div class="row"><span class="k">听写</span><span class="v">SpeechRecognition（部分浏览器支持）</span></div>
              <div class="row"><span class="k">朗读</span><span class="v">speechSynthesis（大多可用）</span></div>
              <div class="row"><span class="k">真实通话</span><span class="v">后续接后端/大模型音频流即可升级</span></div>
            </div>
          </div>
        </div>
      </aside>

      <!-- 抽屉遮罩 -->
      <div class="drawerMask" v-if="drawerOpen" @click="drawerOpen=false"></div>
    </div>
  </div>
</template>

<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, ref } from 'vue'
import teacherPng from '../assets/bg/map.jpg'

/** ===== 基础状态 ===== */
const teacherImg = teacherPng
const mode = ref('explain') // explain | qa | fix
const input = ref('')
const isTalking = ref(false)
const drawerOpen = ref(true)
const hoverTeacher = ref(false)

/** ===== 眼睛跟随（鼠标坐标 → pupil 偏移） ===== */
const mx = ref(0) // -1..1
const my = ref(0) // -1..1
function onMouseMove(e){
  const w = window.innerWidth
  const h = window.innerHeight
  mx.value = ((e.clientX / w) - 0.5) * 2
  my.value = ((e.clientY / h) - 0.5) * 2
}
function resetMouse(){
  mx.value = 0
  my.value = 0
}
const pupilStyle = computed(() => {
  // 瞳孔偏移幅度：越小越真实
  const px = Math.max(-1, Math.min(1, mx.value)) * 6
  const py = Math.max(-1, Math.min(1, my.value)) * 4
  return { transform: `translate(${px}px, ${py}px)` }
})

/** ===== 立体卡片视差（老师卡整体 3D） ===== */
const teacherCardStyle = computed(() => {
  const rx = (-my.value) * 6
  const ry = (mx.value) * 10
  const s = hoverTeacher.value ? 1.01 : 1
  return {
    transform: `perspective(1000px) rotateX(${rx}deg) rotateY(${ry}deg) scale(${s})`,
  }
})

/** ===== 立绘层视差（更明显） ===== */
const avatarStyle = computed(() => {
  const tx = mx.value * 10
  const ty = my.value * 8
  return { transform: `translate(${tx}px, ${ty}px)` }
})

/** ===== 点头/摆手 动作触发 ===== */
const motion = ref('idle') // idle | nod | wave | talk
const avatarMotionClass = computed(() => ({
  nod: motion.value === 'nod',
  wave: motion.value === 'wave',
  talk: isTalking.value,
}))

function triggerNod(){
  motion.value = 'nod'
  setTimeout(() => (motion.value = 'idle'), 820)
}
function triggerWave(){
  motion.value = 'wave'
  setTimeout(() => (motion.value = 'idle'), 980)
}

/** ===== 模式与引导 ===== */
const modeName = computed(() => (mode.value === 'explain' ? '讲解模式' : mode.value === 'qa' ? '答疑模式' : '纠错模式'))
const suggestions = {
  explain: [
    '请用“三步法”讲解《静夜思》，并标出考点。',
    '逐句解释“海内存知己，天涯若比邻”，给意象与情感。',
    '用表格对比“山水诗”和“边塞诗”的特点，并举例。'
  ],
  qa: [
    '这句诗的主旨是什么？为什么用这个意象？',
    '“借景抒情”和“托物言志”怎么区分？举例说明。',
    '把这句诗换一种说法，但保留原意与意境。'
  ],
  fix: [
    '我背诵《春晓》总把最后一句说错，给我记忆口令。',
    '指出我朗诵最容易卡壳的字词，并给停顿建议。',
    '给我一个1分钟背诵路线：先抓主旨，再记关键字。'
  ]
}

function setMode(m){
  mode.value = m
  triggerWave()
}
function fillInput(t){
  input.value = t
  triggerNod()
}

/** ===== 聊天消息（演示） ===== */
const messages = ref([])
const chatBodyRef = ref(null)
function nowTime(){
  const d = new Date()
  const hh = String(d.getHours()).padStart(2,'0')
  const mm = String(d.getMinutes()).padStart(2,'0')
  return `${hh}:${mm}`
}
function escapeHtml(s){
  return s
    .replaceAll('&','&amp;')
    .replaceAll('<','&lt;')
    .replaceAll('>','&gt;')
    .replaceAll('"','&quot;')
    .replaceAll("'","&#039;")
}
function mdLikeToHtml(s){
  let t = escapeHtml(s)
  t = t.replaceAll(/\*\*(.+?)\*\*/g, '<b>$1</b>')
  t = t.replaceAll(/`(.+?)`/g, '<code>$1</code>')
  t = t.replaceAll('\n','<br/>')
  return t
}
function stripHtml(html){
  return html.replaceAll(/<br\s*\/?>/g, '\n').replaceAll(/<[^>]+>/g, '')
}
async function scrollToBottom(){
  await nextTick()
  const el = chatBodyRef.value
  if (!el) return
  el.scrollTop = el.scrollHeight
}
function clearChat(){ messages.value = [] }
function mockIntro(){
  messages.value = [{
    id: crypto.randomUUID(),
    role: 'assistant',
    time: nowTime(),
    html: mdLikeToHtml('你好，我是**墨墨老师**。\n你可以发：整首诗 / 一句名句 / 你的疑问。\n我会按：背景→注释→赏析→考点→速记 输出。')
  }]
  triggerWave()
}

async function send(){
  const text = input.value.trim()
  if (!text || isTalking.value) return

  messages.value.push({ id: crypto.randomUUID(), role: 'user', time: nowTime(), html: mdLikeToHtml(text) })
  input.value = ''
  await scrollToBottom()

  // 你发消息：老师点头
  triggerNod()

  isTalking.value = true

  setTimeout(async () => {
    const reply = mockReply(text, mode.value)
    const msg = { id: crypto.randomUUID(), role: 'assistant', time: nowTime(), html: mdLikeToHtml(reply) }
    messages.value.push(msg)

    // AI 回答：老师摆手 + 说话完成后可朗读
    triggerWave()

    isTalking.value = false
    await scrollToBottom()

    if (voiceAutoSpeak.value && ttsSupported.value) {
      speakText(stripHtml(msg.html))
    }
  }, 850)
}

function mockReply(q, m){
  if (m === 'fix') {
    return `**纠错建议（演示）**
1）易错点：把关键词做“钉子字”（例如：月/乡）  
2）停顿：\`举头 / 望明月\`，\`低头 / 思故乡\`  
3）口令：**月在上，乡在心**（抬头看月，收回想乡）

把你的背诵版本贴出来，我可以逐字纠正。`
  }
  if (m === 'qa') {
    return `**结论（演示）**：这是典型“借景抒情”，用画面承载情绪。

**拆解**
- 意象：月光/霜 → 清冷、静、孤  
- 情感：思念/惆怅 → 不直说，用画面引出  
- 手法：比喻、对照（举头/低头）

你再给我一句名句，我用同样方法拆解。`
  }
  return `**一句话主旨（演示）**：借月色写乡愁，用极简画面承载浓情。

**逐句注释**
- \`床前明月光\`：月光照入室内  
- \`疑是地上霜\`：比喻月色清冷  
- \`举头望明月\`：动作上扬  
- \`低头思故乡\`：情绪回收

**考点**：比喻、对照、借景抒情  
**1分钟速记**：月光像霜 → 抬头看月 → 低头想家`
}

/** ===== 语音：朗读（TTS） ===== */
const ttsSupported = ref(false)
const voiceAutoSpeak = ref(true)

function speakText(text){
  try{
    if (!('speechSynthesis' in window)) return
    window.speechSynthesis.cancel()
    const u = new SpeechSynthesisUtterance(text)
    u.rate = 1
    u.pitch = 1
    u.volume = 1
    // 中文更自然：尝试选一个中文 voice（有则用）
    const voices = window.speechSynthesis.getVoices?.() || []
    const zh = voices.find(v => /zh|Chinese|中文/i.test(v.lang + ' ' + v.name))
    if (zh) u.voice = zh
    window.speechSynthesis.speak(u)
  }catch(e){}
}

/** ===== 语音：听写（SpeechRecognition） ===== */
const speechSupported = ref(false)
const isListening = ref(false)
let rec = null

function setupRecognition(){
  const SR = window.SpeechRecognition || window.webkitSpeechRecognition
  if (!SR) return
  rec = new SR()
  rec.lang = 'zh-CN'
  rec.interimResults = true
  rec.continuous = true

  rec.onresult = (ev) => {
    let finalText = ''
    let interim = ''
    for (let i = ev.resultIndex; i < ev.results.length; i++){
      const r = ev.results[i]
      const t = r[0]?.transcript || ''
      if (r.isFinal) finalText += t
      else interim += t
    }
    // 边说边写到输入框（更像“通话”）
    input.value = (input.value ? input.value.replace(/（听写中….*$/,'') : '')
      + (finalText || interim ? (finalText || interim) : '')
  }

  rec.onend = () => {
    // 如果用户没主动停，就保持“通话感”（可按需改成不自动重启）
    if (isListening.value) {
      try{ rec.start() }catch(e){}
    }
  }
}

function toggleListen(){
  if (!speechSupported.value) return
  if (!rec) return
  if (isListening.value) {
    isListening.value = false
    try{ rec.stop() }catch(e){}
  } else {
    isListening.value = true
    triggerNod()
    try{ rec.start() }catch(e){}
  }
}

/** ===== 生命周期 ===== */
onMounted(() => {
  ttsSupported.value = ('speechSynthesis' in window)

  const SR = window.SpeechRecognition || window.webkitSpeechRecognition
  speechSupported.value = !!SR
  if (speechSupported.value) setupRecognition()

  // 语音 voice 列表可能需要一次触发才加载，这里轻触一下
  if (ttsSupported.value) {
    try{ window.speechSynthesis.getVoices() }catch(e){}
  }
})

onBeforeUnmount(() => {
  try{ window.speechSynthesis?.cancel?.() }catch(e){}
  try{ rec?.stop?.() }catch(e){}
})
</script>

<style scoped>
.ai{
  width: 100%;
  max-width: 1520px;
  margin: 0 auto;
  padding: 18px 18px 28px;
}

/* 顶部控制台 */
.topBar{
  display:grid;
  grid-template-columns: 1fr auto auto;
  gap: 12px;
  align-items: end;
  padding: 14px 16px;
  border-radius: 20px;
  background: rgba(255,255,255,.62);
  border: 1px solid rgba(0,0,0,.06);
  backdrop-filter: blur(14px);
  box-shadow: 0 18px 52px rgba(0,0,0,.06);
}
.brand .t1{ font-weight: 1000; font-size: 20px; letter-spacing: .6px; }
.brand .t2{ margin-top: 4px; opacity:.68; font-weight: 800; font-size: 12px; }

.modes{ display:flex; gap: 10px; }
.mode{
  height: 38px;
  padding: 0 14px;
  border-radius: 14px;
  border: 1px solid rgba(0,0,0,.10);
  background: rgba(255,255,255,.70);
  cursor:pointer;
  font-weight: 1000;
}
.mode.on{
  background: rgba(50,70,60,.14);
  border-color: rgba(50,70,60,.24);
}

.ops{ display:flex; gap: 10px; justify-content: end; }
.ghost,.primary{
  height: 38px;
  padding: 0 14px;
  border-radius: 14px;
  border: 1px solid rgba(0,0,0,.10);
  cursor:pointer;
  font-weight: 1000;
  background: rgba(255,255,255,.70);
}
.primary{ background: rgba(50,70,60,.14); border-color: rgba(50,70,60,.24); }

.main{
  margin-top: 14px;
  display:grid;
  grid-template-columns: 380px 1fr;
  gap: 14px;
  align-items:start;
  position: relative;
}

/* ===== 左侧：3D 老师卡 ===== */
.left{ position: relative; }
.teacherCard{
  position: sticky;
  top: 14px;
  border-radius: 22px;
  padding: 14px;
  background: rgba(255,255,255,.58);
  border: 1px solid rgba(0,0,0,.06);
  backdrop-filter: blur(14px);
  box-shadow: 0 18px 52px rgba(0,0,0,.06);
  transform-style: preserve-3d;
  transition: transform .12s ease;
  overflow:hidden;
}

/* 环面/火花：更微妙高级 */
.torusWrap{ position:absolute; inset:-30%; pointer-events:none; opacity:.9; }
.torus{
  position:absolute;
  left: 50%; top: 52%;
  width: 520px; height: 520px;
  border-radius: 999px;
  transform: translate(-50%,-50%);
  filter: blur(10px);
  opacity:.55;
  background:
    conic-gradient(from 180deg,
      rgba(70,120,100,.0),
      rgba(70,120,100,.22),
      rgba(210,160,120,.18),
      rgba(70,120,100,.20),
      rgba(70,120,100,.0)
    );
  mask: radial-gradient(circle at center, transparent 56%, #000 58%, #000 64%, transparent 66%);
  animation: torusSpin 14s linear infinite;
}
.torus.t2{
  width: 420px; height: 420px;
  top: 58%;
  opacity:.35;
  filter: blur(14px);
  animation-duration: 18s;
  animation-direction: reverse;
}
.torus.t3{
  width: 620px; height: 620px;
  top: 44%;
  opacity:.26;
  filter: blur(18px);
  animation-duration: 22s;
}
.spark{
  position:absolute;
  width: 8px; height: 8px;
  border-radius: 999px;
  background: rgba(255,255,255,.85);
  box-shadow: 0 0 22px rgba(255,255,255,.65);
  opacity:.35;
  animation: spark 2.8s ease-in-out infinite;
}
.s1{ left: 40%; top: 40%; }
.s2{ left: 60%; top: 62%; animation-delay: .6s; }
.s3{ left: 52%; top: 30%; animation-delay: 1.2s; }

.teacherHead{
  display:flex;
  justify-content: space-between;
  align-items:center;
  gap: 10px;
  margin-bottom: 10px;
  position: relative;
  z-index: 2;
}
.tag{
  padding: 6px 10px;
  border-radius: 999px;
  background: rgba(0,0,0,.06);
  border: 1px solid rgba(0,0,0,.06);
  font-weight: 1000;
}
.state{ display:flex; gap: 8px; align-items:center; }
.dot{
  width: 10px; height: 10px;
  border-radius: 999px;
  background: rgba(60,160,120,.65);
  box-shadow: 0 0 0 6px rgba(60,160,120,.12);
}
.dot.talk{ animation: pulse 1.1s ease-in-out infinite; }
.txt{ opacity:.7; font-weight: 900; font-size: 12px; }

.stage{
  position: relative;
  height: 340px;
  border-radius: 18px;
  border: 1px solid rgba(0,0,0,.06);
  overflow:hidden;
  background:
    radial-gradient(900px 300px at 45% 10%, rgba(220,240,230,.95), transparent 58%),
    radial-gradient(700px 280px at 70% 85%, rgba(240,232,220,.90), transparent 55%),
    linear-gradient(180deg, rgba(255,255,255,.84), rgba(255,255,255,.52));
  transform: translateZ(18px);
  z-index: 2;
}

.light{
  position:absolute; inset:-20%;
  background: radial-gradient(circle at 40% 20%, rgba(255,255,255,.75), transparent 55%);
  filter: blur(8px);
  opacity: .9;
  pointer-events:none;
}
.mist{
  position:absolute; inset:-20%;
  background:
    radial-gradient(circle at 25% 70%, rgba(255,255,255,.60), transparent 55%),
    radial-gradient(circle at 75% 35%, rgba(255,255,255,.55), transparent 55%);
  filter: blur(10px);
  opacity:.9;
  animation: drift 10s ease-in-out infinite;
  pointer-events:none;
}
.grain{
  position:absolute; inset:0;
  background-image: radial-gradient(rgba(0,0,0,.08) 1px, transparent 1px);
  background-size: 22px 22px;
  opacity:.08;
  mix-blend-mode: multiply;
  pointer-events:none;
}

/* 立绘容器：做伪3D */
.avatar3d{
  position:absolute;
  left: 50%;
  bottom: -10px;
  transform: translateX(-50%);
  width: 100%;
  height: 115%;
  display:flex;
  align-items:flex-end;
  justify-content:center;
  pointer-events:none;
  transform-style: preserve-3d;
}
.teacherImg{
  height: 120%;
  object-fit: contain;
  filter: drop-shadow(0 18px 42px rgba(0,0,0,.20));
  animation: float 3.8s ease-in-out infinite;
  user-select:none;
}

/* 点头（整体轻微俯仰） */
.avatar3d.nod .teacherImg{
  animation: none;
  transform-origin: 50% 75%;
  animation: nod 0.82s ease-in-out;
}

/* 摆手（轻微摇摆） */
.avatar3d.wave .teacherImg{
  animation: none;
  transform-origin: 50% 80%;
  animation: wave 0.98s ease-in-out;
}

/* 说话时更灵动一点 */
.avatar3d.talk .teacherImg{
  filter: drop-shadow(0 18px 44px rgba(0,0,0,.22)) saturate(1.06);
}

/* 眼睛：位置是经验值（针对你的 teacher.png 大概脸部位置），你可微调 top/left */
.eyes{
  position:absolute;
  top: 86px;
  left: 50%;
  transform: translateX(-50%);
  width: 150px;
  display:flex;
  justify-content: space-between;
  gap: 26px;
  opacity: .55;
  mix-blend-mode: multiply;
}
.eye{
  width: 22px; height: 14px;
  border-radius: 999px;
  background: rgba(0,0,0,.10);
  border: 1px solid rgba(0,0,0,.12);
  position: relative;
  overflow:hidden;
}
.pupil{
  position:absolute;
  left: 50%; top: 50%;
  width: 6px; height: 6px;
  border-radius: 999px;
  background: rgba(0,0,0,.55);
  transform: translate(-50%,-50%);
  transition: transform .06s linear;
}

/* 说话波纹 */
.speak{
  position:absolute;
  left: 50%;
  bottom: 110px;
  transform: translateX(-50%);
  pointer-events:none;
}
.ring{
  position:absolute;
  left: 50%;
  top: 0;
  transform: translateX(-50%);
  width: 22px; height: 22px;
  border-radius: 999px;
  border: 2px solid rgba(70,120,100,.25);
  opacity: 0;
}
.r1{ animation: ring 1.2s ease-out infinite; }
.r2{ animation: ring 1.2s ease-out infinite .3s; }
.r3{ animation: ring 1.2s ease-out infinite .6s; }

/* 听写时波纹 */
.listen{
  position:absolute;
  left: 50%;
  bottom: 128px;
  transform: translateX(-50%);
}
.micRing{
  position:absolute;
  left: 50%;
  top: 0;
  transform: translateX(-50%);
  width: 14px; height: 14px;
  border-radius: 999px;
  border: 2px solid rgba(210,160,120,.30);
  opacity: 0;
}
.m1{ animation: ring 1.0s ease-out infinite; }
.m2{ animation: ring 1.0s ease-out infinite .25s; }

/* 引导区 */
.coach{ margin-top: 12px; position: relative; z-index: 2; }
.coachTitle{ font-weight: 1000; margin-bottom: 8px; }
.coachBubble{
  width: 100%;
  text-align:left;
  padding: 12px;
  border-radius: 16px;
  border: 1px solid rgba(0,0,0,.06);
  background: rgba(255,255,255,.72);
  cursor:pointer;
  font-weight: 900;
  line-height: 1.55;
  transition: .16s;
  margin-bottom: 10px;
}
.coachBubble:hover{ transform: translateY(-1px); box-shadow: 0 16px 40px rgba(0,0,0,.08); }
.coachBubble.subtle{ opacity:.92; }
.q{ opacity:.55; font-weight: 1000; }

/* 语音区 */
.voiceBox{
  margin-top: 10px;
  border-top: 1px dashed rgba(0,0,0,.10);
  padding-top: 10px;
  position: relative;
  z-index: 2;
}
.vbTitle{ font-weight: 1000; margin-bottom: 10px; }
.vbRow{ display:flex; gap: 10px; }
.vBtn{
  flex:1;
  height: 38px;
  border-radius: 14px;
  border: 1px solid rgba(0,0,0,.10);
  background: rgba(255,255,255,.74);
  cursor:pointer;
  font-weight: 1000;
}
.vBtn.on{
  background: rgba(50,70,60,.14);
  border-color: rgba(50,70,60,.24);
}
.vBtn:disabled{ opacity:.55; cursor:not-allowed; }
.vbTip{ margin-top: 8px; opacity:.75; font-weight: 800; font-size: 12px; }
.ghost2{ opacity:.9; }

/* ===== 中间聊天 ===== */
.chatCard{
  border-radius: 22px;
  overflow:hidden;
  background: rgba(255,255,255,.58);
  border: 1px solid rgba(0,0,0,.06);
  backdrop-filter: blur(14px);
  box-shadow: 0 18px 52px rgba(0,0,0,.06);
}
.chatTop{
  padding: 12px;
  border-bottom: 1px solid rgba(0,0,0,.06);
  background: rgba(255,255,255,.66);
}
.chipRow{ display:flex; flex-wrap: wrap; gap: 8px; }
.chip{
  height: 34px;
  padding: 0 12px;
  border-radius: 999px;
  border: 1px solid rgba(0,0,0,.10);
  background: rgba(255,255,255,.75);
  cursor:pointer;
  font-weight: 1000;
  transition: .16s;
}
.chip:hover{ transform: translateY(-1px); box-shadow: 0 14px 34px rgba(0,0,0,.08); }
.hint{
  margin-top: 10px;
  display:flex;
  justify-content: space-between;
  gap: 10px;
  align-items:center;
  opacity:.8;
}
.hTag{
  padding: 4px 10px;
  border-radius: 999px;
  border: 1px solid rgba(50,70,60,.14);
  background: rgba(50,70,60,.10);
  font-weight: 1000;
  font-size: 12px;
}
.hText{ font-weight: 900; font-size: 12px; opacity:.75; }

.chatBody{
  height: calc(100vh - 240px);
  min-height: 600px;
  max-height: 860px;
  overflow:auto;
  padding: 14px 14px 10px;
}

/* 空态 */
.zero{
  margin-top: 14px;
  border-radius: 18px;
  padding: 16px;
  background: rgba(255,255,255,.60);
  border: 1px dashed rgba(0,0,0,.10);
}
.zTitle{ font-weight: 1000; font-size: 16px; }
.zSub{ margin-top: 4px; opacity:.68; font-weight: 800; font-size: 12px; }
.zGrid{
  margin-top: 12px;
  display:grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
}
.zCard{
  text-align:left;
  padding: 12px;
  border-radius: 16px;
  border: 1px solid rgba(0,0,0,.06);
  background: rgba(255,255,255,.72);
  cursor:pointer;
  transition: .16s;
}
.zCard:hover{ transform: translateY(-1px); box-shadow: 0 14px 34px rgba(0,0,0,.08); }
.zH{ font-weight: 1000; }
.zS{ margin-top: 4px; opacity:.68; font-weight: 800; font-size: 12px; }

/* 消息 */
.msg{ display:flex; gap: 10px; margin-bottom: 12px; align-items:flex-start; }
.av{
  width: 34px; height: 34px;
  border-radius: 12px;
  display:flex; align-items:center; justify-content:center;
  font-weight: 1000;
  border: 1px solid rgba(0,0,0,.10);
  background: rgba(255,255,255,.72);
}
.msg.assistant .av{
  background: rgba(50,70,60,.12);
  border-color: rgba(50,70,60,.16);
}
.bub{
  flex: 1;
  padding: 12px;
  border-radius: 16px;
  border: 1px solid rgba(0,0,0,.06);
  background: rgba(255,255,255,.72);
}
.meta{ display:flex; gap: 10px; align-items:center; margin-bottom: 6px; }
.who{ font-weight: 1000; }
.time{ opacity:.55; font-weight: 800; font-size: 12px; }
.ct{ line-height: 1.75; font-weight: 800; color: rgba(20,30,26,.92); }
.ct code{
  padding: 2px 6px;
  border-radius: 8px;
  background: rgba(0,0,0,.06);
  border: 1px solid rgba(0,0,0,.06);
  font-weight: 900;
}
.actRow{ margin-top: 10px; display:flex; gap: 8px; flex-wrap: wrap; }
.mini{
  height: 30px;
  padding: 0 10px;
  border-radius: 999px;
  border: 1px solid rgba(0,0,0,.10);
  background: rgba(255,255,255,.76);
  cursor:pointer;
  font-weight: 1000;
  font-size: 12px;
}
.mini:disabled{ opacity:.55; cursor:not-allowed; }

/* 输入区 */
.composer{
  display:flex;
  gap: 10px;
  align-items:flex-end;
  padding: 12px;
  border-top: 1px solid rgba(0,0,0,.06);
  background: rgba(255,255,255,.66);
}
.input{
  flex: 1;
  width: 100%;
  resize:none;
  border-radius: 16px;
  border: 1px solid rgba(0,0,0,.10);
  background: rgba(255,255,255,.80);
  padding: 10px 12px;
  outline:none;
  font-weight: 900;
  line-height: 1.6;
}
.send{
  width: 98px;
  height: 44px;
  border-radius: 16px;
  border: 1px solid rgba(50,70,60,.20);
  background: rgba(50,70,60,.14);
  cursor:pointer;
  font-weight: 1000;
}
.send:disabled{ opacity:.55; cursor:not-allowed; }

/* ===== 右侧抽屉 ===== */
.drawer{
  position: fixed;
  top: 0; right: 0;
  height: 100vh;
  width: 380px;
  transform: translateX(100%);
  transition: transform .22s ease;
  z-index: 999;
}
.drawer.open{ transform: translateX(0); }

.drawerInner{
  height: 100%;
  padding: 14px;
  background: rgba(255,255,255,.78);
  border-left: 1px solid rgba(0,0,0,.08);
  backdrop-filter: blur(16px);
  box-shadow: -18px 0 52px rgba(0,0,0,.10);
  overflow:auto;
}
.drawerMask{
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,.18);
  z-index: 998;
}
.pTitle{
  display:flex;
  align-items:center;
  justify-content: space-between;
  font-weight: 1000;
  margin-bottom: 12px;
}
.close{
  width: 34px; height: 34px;
  border-radius: 12px;
  border: 1px solid rgba(0,0,0,.10);
  background: rgba(255,255,255,.70);
  cursor:pointer;
  font-size: 18px;
  line-height: 32px;
}

.box{
  border-radius: 18px;
  padding: 12px;
  background: rgba(255,255,255,.68);
  border: 1px solid rgba(0,0,0,.06);
  margin-bottom: 12px;
}
.bTitle{ font-weight: 1000; margin-bottom: 10px; }
.tpl{ display:flex; flex-wrap: wrap; gap: 8px; }
.pill2{
  padding: 8px 10px;
  border-radius: 999px;
  background: rgba(0,0,0,.05);
  border: 1px solid rgba(0,0,0,.06);
  font-weight: 900;
  font-size: 12px;
}
.qs{ display:flex; flex-direction: column; gap: 10px; }
.qBtn{
  text-align:left;
  padding: 12px;
  border-radius: 16px;
  border: 1px solid rgba(0,0,0,.06);
  background: rgba(255,255,255,.72);
  cursor:pointer;
  font-weight: 900;
  transition: .16s;
}
.qBtn:hover{ transform: translateY(-1px); box-shadow: 0 14px 34px rgba(0,0,0,.08); }
.desc .row{ display:flex; gap: 10px; margin-bottom: 10px; line-height: 1.6; }
.desc .k{ width: 52px; font-weight: 1000; opacity:.78; }
.desc .v{ flex:1; opacity:.86; font-weight: 800; font-size: 12px; }

/* ===== 动画 ===== */
@keyframes float{
  0%,100%{ transform: translateY(0); }
  50%{ transform: translateY(-8px); }
}
@keyframes drift{
  0%,100%{ transform: translate(0,0); }
  50%{ transform: translate(-16px, 10px); }
}
@keyframes pulse{
  0%,100%{ box-shadow: 0 0 0 6px rgba(60,160,120,.12); opacity: 1; }
  50%{ box-shadow: 0 0 0 10px rgba(60,160,120,.08); opacity: .85; }
}
@keyframes ring{
  0%{ transform: translateX(-50%) scale(.6); opacity: 0; }
  20%{ opacity: .7; }
  100%{ transform: translateX(-50%) scale(2.6); opacity: 0; }
}
@keyframes nod{
  0%{ transform: rotateX(0deg) translateY(0); }
  30%{ transform: rotateX(10deg) translateY(2px); }
  60%{ transform: rotateX(-6deg) translateY(-1px); }
  100%{ transform: rotateX(0deg) translateY(0); }
}
@keyframes wave{
  0%{ transform: rotateZ(0deg) translateY(0); }
  25%{ transform: rotateZ(2.2deg) translateY(1px); }
  50%{ transform: rotateZ(-2.6deg) translateY(-1px); }
  75%{ transform: rotateZ(1.6deg) translateY(1px); }
  100%{ transform: rotateZ(0deg) translateY(0); }
}
@keyframes torusSpin{
  from{ transform: translate(-50%,-50%) rotate(0deg); }
  to{ transform: translate(-50%,-50%) rotate(360deg); }
}
@keyframes spark{
  0%,100%{ transform: translateY(0); opacity:.25; }
  50%{ transform: translateY(-10px); opacity:.45; }
}

/* 响应式 */
@media (max-width: 1280px){
  .main{ grid-template-columns: 360px 1fr; }
  .zGrid{ grid-template-columns: 1fr; }
}
@media (max-width: 980px){
  .main{ grid-template-columns: 1fr; }
  .teacherCard{ position: relative; top: 0; }
  .chatBody{ min-height: 520px; }
  .drawer{ width: min(92vw, 380px); }
}
</style>
