<template>
  <div
    class="floatingPoetryContainer"
    ref="containerRef"
    @click="handleContainerClick"
  >
    <button
      class="pauseBtn"
      @click="togglePause"
      :title="isPaused ? '继续飘动 (空格)' : '暂停飘动 (空格)'"
      :class="{ paused: isPaused }"
    >
      {{ isPaused ? '▶' : '⏸' }}
    </button>

    <div v-if="showPerformanceStats && isDevMode" class="performanceStats">
      <span class="perfItem">FPS: {{ currentFPS }}</span>
      <span class="perfItem">卡片: {{ visiblePoems.length }}</span>
    </div>

    <div
      v-for="poem in visiblePoems"
      :key="poem.id"
      class="poemCard"
      :class="[
        `layer-${poem.layer}`,
        `speed-${poem.speedLevel}`,
        { paused: isPaused || poem.isHovered }
      ]"
      :style="getCardStyle(poem)"
      @mouseenter="handleMouseEnter(poem)"
      @mouseleave="handleMouseLeave(poem)"
      @click.stop="openPoem(poem)"
    >
      <div class="cardHeader">
        <div class="authorInfo">
          <span class="authorName">{{ poem.author?.name || poem.authorName }}</span>
          <span class="time">{{ poem.timeText }}</span>
        </div>
      </div>

      <div class="cardContent">
        <div class="poemTitle" v-if="poem.title">{{ poem.title }}</div>
        <div class="poemText">{{ getDisplayContent(poem) }}</div>
      </div>

      <div class="cardFooter">
        <span class="stats">
          <span class="stat">👍 {{ poem.likeCount || poem.likes || 0 }}</span>
          <span class="stat">💬 {{ poem.commentCount || poem.comments || 0 }}</span>
        </span>
      </div>
    </div>

    <div v-if="loading" class="loadingState">
      <div class="spinner"></div>
      <div class="loadingText">加载中...</div>
    </div>

    <div v-if="!loading && floatingPoems.length === 0" class="emptyState">
      <div class="emptyText">暂无飘动诗词</div>
      <div class="emptyHint">快来发布你的第一首作品吧～</div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch, nextTick, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const props = defineProps({
  poems: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['filterChange', 'tabChange', 'search', 'clearSearch'])

const router = useRouter()
const route = useRoute()
const isPaused = ref(false)
const loading = ref(false)
const floatingPoems = ref([])
const containerRef = ref(null)

const showPerformanceStats = ref(false)
const isDevMode = import.meta.env.DEV
const currentFPS = ref(60)
const frameCount = ref(0)
const lastFPSUpdate = ref(Date.now())
let fpsMonitorInterval = null

const errorCount = ref(0)
const maxErrors = 5
const hasCriticalError = ref(false)

const isMobile = ref(false)
const hoveredPoemId = ref(null)

const CONFIG = {
  MAX_CARDS: 60,
  LAYERS: 6,
  MIN_DURATION: 18,
  MAX_DURATION: 42,
  BASE_DELAY_STEP: 0.65
}

const SPEED_LEVELS = {
  FAST: { duration: 18, label: 'fast', name: '快速' },
  MEDIUM_FAST: { duration: 22, label: 'mediumFast', name: '中快' },
  MEDIUM: { duration: 28, label: 'medium', name: '中速' },
  MEDIUM_SLOW: { duration: 34, label: 'mediumSlow', name: '中慢' },
  SLOW: { duration: 40, label: 'slow', name: '慢速' },
  VERY_SLOW: { duration: 46, label: 'verySlow', name: '极慢' }
}

const LAYER_CONFIG = {
  1: { top: '24px',  zIndex: 12, opacity: 0.98, scale: 1,    speed: SPEED_LEVELS.FAST },
  2: { top: '118px', zIndex: 10, opacity: 0.94, scale: 0.97, speed: SPEED_LEVELS.MEDIUM_FAST },
  3: { top: '212px', zIndex: 8,  opacity: 0.91, scale: 0.94, speed: SPEED_LEVELS.MEDIUM },
  4: { top: '306px', zIndex: 6,  opacity: 0.88, scale: 0.91, speed: SPEED_LEVELS.MEDIUM_SLOW },
  5: { top: '400px', zIndex: 4,  opacity: 0.84, scale: 0.88, speed: SPEED_LEVELS.SLOW },
  6: { top: '494px', zIndex: 2,  opacity: 0.80, scale: 0.85, speed: SPEED_LEVELS.VERY_SLOW }
}

const chineseColors = [
  { name: '桃夭', bg: 'rgba(245, 222, 210, 0.92)', border: 'rgba(200, 160, 140, 0.25)', shadow: 'rgba(200, 160, 140, 0.15)' },
  { name: '竹青', bg: 'rgba(220, 240, 225, 0.92)', border: 'rgba(160, 200, 175, 0.25)', shadow: 'rgba(160, 200, 175, 0.15)' },
  { name: '天青', bg: 'rgba(225, 235, 245, 0.92)', border: 'rgba(170, 190, 210, 0.25)', shadow: 'rgba(170, 190, 210, 0.15)' },
  { name: '月白', bg: 'rgba(240, 240, 250, 0.92)', border: 'rgba(190, 190, 220, 0.25)', shadow: 'rgba(190, 190, 220, 0.15)' },
  { name: '藤黄', bg: 'rgba(250, 235, 215, 0.92)', border: 'rgba(210, 190, 150, 0.25)', shadow: 'rgba(210, 190, 150, 0.15)' }
]

const paperBackgrounds = [
  new URL('@/assets/chuangzuo/1.jpg', import.meta.url).href,
  new URL('@/assets/chuangzuo/2.jpg', import.meta.url).href,
  new URL('@/assets/chuangzuo/3.jpg', import.meta.url).href,
  new URL('@/assets/chuangzuo/4.jpg', import.meta.url).href,
  new URL('@/assets/chuangzuo/5.jpg', import.meta.url).href,
  new URL('@/assets/chuangzuo/6.jpg', import.meta.url).href
]

function getRandomColorScheme(index = 0) {
  return chineseColors[index % chineseColors.length]
}

function getDisplayContent(poem) {
  const content = poem.excerpt || poem.content || poem.summary || ''
  return content.length > 42 ? content.substring(0, 42) + '...' : content
}

function formatTime(dateStr) {
  if (!dateStr) return '刚刚'
  const date = new Date(dateStr)
  const now = new Date()
  const diff = now - date

  const minutes = Math.floor(diff / 60000)
  const hours = Math.floor(diff / 3600000)
  const days = Math.floor(diff / 86400000)

  if (minutes < 1) return '刚刚'
  if (minutes < 60) return `${minutes}分钟前`
  if (hours < 24) return `${hours}小时前`
  if (days < 7) return `${days}天前`

  return `${date.getMonth() + 1}-${date.getDate()}`
}

function checkMobile() {
  return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ||
    window.innerWidth <= 768
}

function getDurationByLayer(layer, index) {
  const base = LAYER_CONFIG[layer]?.speed?.duration || 30
  const offset = index % 5
  return Math.min(CONFIG.MAX_DURATION, Math.max(CONFIG.MIN_DURATION, base + offset))
}

function buildPoemsList() {
  if (!props.poems || props.poems.length === 0) return []

  const source = props.poems.filter(Boolean)
  if (source.length === 0) return []

  let result = [...source]

  if (result.length < CONFIG.MAX_CARDS) {
    const repeated = []
    let round = 0
    while (result.length + repeated.length < CONFIG.MAX_CARDS) {
      for (let i = 0; i < source.length; i++) {
        const poem = source[i]
        repeated.push({
          ...poem,
          id: `${poem.id || i}-clone-${round}-${i}`
        })
        if (result.length + repeated.length >= CONFIG.MAX_CARDS) break
      }
      round++
      if (round > 20) break
    }
    result = result.concat(repeated)
  }

  return result.slice(0, CONFIG.MAX_CARDS)
}

const visiblePoems = computed(() => floatingPoems.value)

async function initFloatingPoems() {
  if (!props.poems || props.poems.length === 0) {
    floatingPoems.value = []
    return
  }

  loading.value = true

  try {
    const poemsToProcess = buildPoemsList()

    floatingPoems.value = poemsToProcess.map((poem, index) => {
      const safeIndex = index + 1
      return processPoem(poem, safeIndex)
    })
  } catch (error) {
    console.error('初始化飘动诗词失败:', error)
    errorCount.value++
    if (errorCount.value >= maxErrors) {
      enableFallbackMode()
    }
  } finally {
    loading.value = false
  }
}

function getCardStyle(poem) {
  const layerConfig = LAYER_CONFIG[poem.layer]
  const colors = poem.colorScheme || chineseColors[0]
  const bgIndex = Math.abs(hashCode(String(poem.id || poem.title || 0))) % paperBackgrounds.length
  const bgImage = `url(${paperBackgrounds[bgIndex]})`

  return {
    '--animation-duration': `${poem.duration}s`,
    '--animation-delay': `${poem.delay}s`,
    '--card-scale': layerConfig.scale,
    opacity: layerConfig.opacity,
    top: layerConfig.top,
    zIndex: layerConfig.zIndex,
    backgroundImage: bgImage,
    borderColor: colors.border
  }
}

function hashCode(str) {
  let hash = 0
  for (let i = 0; i < str.length; i++) {
    hash = ((hash << 5) - hash) + str.charCodeAt(i)
    hash |= 0
  }
  return hash
}

function handleMouseEnter(poem) {
  if (!isMobile.value) {
    poem.isHovered = true
  }
}

function handleMouseLeave(poem) {
  poem.isHovered = false
}

function openPoem(poem) {
  const realId = String(poem.id).split('-clone-')[0]
  if (!realId) {
    console.warn('诗词缺少id，无法跳转', poem)
    return
  }

  if (isMobile.value) {
    if (hoveredPoemId.value === poem.id) {
      router.push(`/chuangzuo/${realId}`)
    } else {
      hoveredPoemId.value = poem.id
      poem.isHovered = true
      setTimeout(() => {
        if (hoveredPoemId.value === poem.id) {
          poem.isHovered = false
          hoveredPoemId.value = null
        }
      }, 3000)
    }
  } else {
    router.push(`/chuangzuo/${realId}`)
  }
}

function handleContainerClick() {
  if (isMobile.value && hoveredPoemId.value) {
    const pausedPoem = floatingPoems.value.find(p => p.id === hoveredPoemId.value)
    if (pausedPoem) {
      pausedPoem.isHovered = false
    }
    hoveredPoemId.value = null
  }
}

function togglePause() {
  isPaused.value = !isPaused.value
}

function handleKeyPress(event) {
  if (event.code === 'Space' && document.activeElement?.tagName !== 'INPUT') {
    event.preventDefault()
    togglePause()
  }
}

function throttledHandleResize() {
  isMobile.value = checkMobile()
}

function startFPSMonitor() {
  if (!isDevMode) return

  fpsMonitorInterval = setInterval(() => {
    const now = Date.now()
    const delta = now - lastFPSUpdate.value
    if (delta >= 1000) {
      currentFPS.value = Math.round((frameCount.value * 1000) / delta)
      frameCount.value = 0
      lastFPSUpdate.value = now
    }
  }, 1000)

  function countFrames() {
    frameCount.value++
    requestAnimationFrame(countFrames)
  }

  requestAnimationFrame(countFrames)
}

function stopFPSMonitor() {
  if (fpsMonitorInterval) {
    clearInterval(fpsMonitorInterval)
    fpsMonitorInterval = null
  }
}

function enableFallbackMode() {
  floatingPoems.value = floatingPoems.value.slice(0, 12)
  isPaused.value = true
  showWarning('性能受限，已自动优化')
}

function processPoem(poem, index) {
  const layer = ((index - 1) % CONFIG.LAYERS) + 1
  const duration = getDurationByLayer(layer, index)

  return {
    ...poem,
    layer,
    speedLevel: LAYER_CONFIG[layer].speed.label,
    duration,
    delay: (index - 1) * CONFIG.BASE_DELAY_STEP * -1,
    isHovered: false,
    timeText: formatTime(poem.createdAt),
    colorScheme: getRandomColorScheme(index)
  }
}

function showWarning(message) {
  console.warn(message)
}

watch(() => props.poems, async () => {
  await nextTick()
  if (containerRef.value) {
    await initFloatingPoems()
  }
}, { deep: true })

watch(() => route.path, async (newPath) => {
  if (newPath === '/chuangzuo') {
    await nextTick()
    if (containerRef.value) {
      await initFloatingPoems()
    }
  }
})

onMounted(async () => {
  await nextTick()
  isMobile.value = checkMobile()

  try {
    if (containerRef.value) {
      await initFloatingPoems()
    }

    window.addEventListener('resize', throttledHandleResize)
    window.addEventListener('keydown', handleKeyPress)

    if (isDevMode) {
      startFPSMonitor()
    }
  } catch (error) {
    console.error('初始化失败:', error)
    enableFallbackMode()
  }
})

onUnmounted(() => {
  floatingPoems.value = []
  window.removeEventListener('resize', throttledHandleResize)
  window.removeEventListener('keydown', handleKeyPress)
  stopFPSMonitor()
})
</script>

<style scoped>
.floatingPoetryContainer {
  position: relative;
  width: 100%;
  min-height: 620px;
  height: 620px;
  overflow: hidden;
  background: transparent;
  border-radius: 0;
  border: none;
  backdrop-filter: none;
  box-shadow: none;
}

.floatingPoetryContainer::before {
  content: "";
  position: absolute;
  inset: 0;
  background-image:
    url("@/assets/game/bg_page_1.jpg");
  background-size: 30%, 20%;
  background-repeat: repeat;
  opacity: 0.14;
  animation: bambooShake 8s ease-in-out infinite;
  z-index: 0;
  pointer-events: none;
}

@keyframes bambooShake {
  0%, 100% { transform: translate(0, 0) rotate(0deg); }
  25% { transform: translate(2px, 1px) rotate(0.3deg); }
  50% { transform: translate(-1px, 2px) rotate(-0.2deg); }
  75% { transform: translate(1px, -1px) rotate(0.2deg); }
}

.performanceStats {
  position: absolute;
  top: 12px;
  left: 12px;
  z-index: 101;
  display: flex;
  gap: 8px;
  padding: 6px 10px;
  background: rgba(0, 0, 0, 0.7);
  border-radius: 8px;
  font-size: 11px;
  font-family: monospace;
  color: #0f0;
}

.perfItem {
  white-space: nowrap;
}

.pauseBtn {
  position: absolute;
  top: 12px;
  right: 12px;
  z-index: 101;
  width: 36px;
  height: 36px;
  border-radius: 999px;
  border: 1px solid rgba(0, 0, 0, 0.08);
  background: rgba(255, 255, 255, 0.88);
  font-size: 16px;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.pauseBtn:hover {
  background: rgba(255, 255, 255, 1);
  transform: scale(1.05);
}

.pauseBtn.paused {
  background: rgba(74, 123, 184, 0.2);
  border-color: rgba(74, 123, 184, 0.4);
}

.poemCard {
  position: absolute;
  left: 0;
  width: 240px;
  z-index: 1;
  background: #fdf9f2;
  background-size: cover;
  background-position: center;
  border-radius: 10px 12px 8px 12px;
  border: 1px solid rgba(212, 175, 55, 0.22);
  box-shadow:
    0 0 12px rgba(255, 220, 120, 0.10),
    0 6px 24px rgba(0, 0, 0, 0.10),
    0 2px 8px rgba(0, 0, 0, 0.06);
  padding: 12px;
  cursor: pointer;
  transition: box-shadow 0.3s ease, background 0.3s ease, border-color 0.3s ease;
  will-change: transform;
  backdrop-filter: blur(8px);
  animation: floatLeft linear infinite;
  animation-duration: var(--animation-duration, 30s);
  animation-delay: var(--animation-delay, 0s);
  animation-play-state: running;
  overflow: hidden;
  transform-origin: center center;
}

.poemCard::before {
  content: '';
  position: absolute;
  inset: 0;
  background:
    radial-gradient(ellipse at 20% 30%, rgba(212, 175, 55, 0.08) 0%, transparent 50%),
    radial-gradient(ellipse at 80% 70%, rgba(180, 160, 120, 0.06) 0%, transparent 50%),
    radial-gradient(ellipse at 50% 50%, rgba(160, 140, 100, 0.04) 0%, transparent 60%);
  background-size: 150% 150%;
  opacity: 0.05;
  pointer-events: none;
  z-index: 0;
  border-radius: inherit;
}

.poemCard::after {
  content: '';
  position: absolute;
  inset: -2px;
  border-radius: 12px 14px 10px 14px;
  background: conic-gradient(
    from 0deg,
    transparent 0deg,
    rgba(212, 175, 55, 0.3) 90deg,
    transparent 180deg,
    rgba(255, 220, 120, 0.2) 270deg,
    transparent 360deg
  );
  animation: rotateBorder 4s linear infinite;
  filter: blur(6px);
  z-index: -1;
  opacity: 0;
  transition: opacity 0.3s ease;
}

@keyframes rotateBorder {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.poemCard:hover::after {
  opacity: 1;
}

@keyframes floatLeft {
  0% {
    transform: translateX(110vw) scale(var(--card-scale, 1));
  }
  100% {
    transform: translateX(-320px) scale(var(--card-scale, 1));
  }
}

.poemCard.paused {
  animation-play-state: paused !important;
}

.poemCard:hover {
  animation-play-state: paused !important;
  box-shadow:
    0 8px 24px rgba(212, 175, 55, 0.18),
    0 12px 40px rgba(0, 0, 0, 0.16),
    0 4px 16px rgba(0, 0, 0, 0.10);
  z-index: 100 !important;
  background: #fffcf7;
  border-color: rgba(212, 175, 55, 0.42);
}

.poemCard:active {
  transform: scale(0.98) !important;
}

.poemCard.layer-1 {}
.poemCard.layer-2 {}
.poemCard.layer-3 {}
.poemCard.layer-4 {}
.poemCard.layer-5 {}
.poemCard.layer-6 {}

.poemCard.speed-fast { --animation-duration: 18s; }
.poemCard.speed-mediumFast { --animation-duration: 22s; }
.poemCard.speed-medium { --animation-duration: 28s; }
.poemCard.speed-mediumSlow { --animation-duration: 34s; }
.poemCard.speed-slow { --animation-duration: 40s; }
.poemCard.speed-verySlow { --animation-duration: 46s; }

.loadingState {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.45);
  z-index: 50;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 3px solid rgba(74, 123, 184, 0.2);
  border-top-color: rgba(74, 123, 184, 0.8);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loadingText {
  margin-top: 12px;
  font-size: 14px;
  color: rgba(0, 0, 0, 0.6);
  font-weight: 700;
}

.emptyState {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.3);
}

.emptyText {
  font-size: 18px;
  font-weight: 900;
  color: rgba(0, 0, 0, 0.4);
  margin-bottom: 8px;
}

.emptyHint {
  font-size: 14px;
  color: rgba(0, 0, 0, 0.3);
  font-weight: 600;
}

.cardHeader {
  margin-bottom: 8px;
  position: relative;
  z-index: 1;
}

.authorInfo {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}

.authorName {
  font-size: 13px;
  font-weight: 900;
  color: #3a2e2b;
  font-family: "Noto Serif SC", "Source Han Serif SC", "STSong", "SimSun", serif;
}

.time {
  font-size: 11px;
  color: #4a3b36;
  font-weight: 600;
  opacity: 0.6;
}

.cardContent {
  margin-bottom: 10px;
  position: relative;
  z-index: 1;
}

.poemTitle {
  font-size: 15px;
  font-weight: 1000;
  color: #3a2e2b;
  margin-bottom: 6px;
  line-height: 1.6;
  letter-spacing: 0.05em;
  font-family: "Noto Serif SC", "Source Han Serif SC", "STSong", "SimSun", serif;
}

.poemText {
  font-size: 13px;
  line-height: 1.7;
  color: #4a3b36;
  font-weight: 500;
  letter-spacing: 0.02em;
  font-family: "Noto Serif SC", "Source Han Serif SC", "STSong", "SimSun", serif;
  text-align: justify;
}

.cardFooter {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-top: 8px;
  border-top: 1px solid rgba(212, 175, 55, 0.2);
  position: relative;
  z-index: 1;
}

.stats {
  display: flex;
  gap: 12px;
}

.stat {
  font-size: 12px;
  font-weight: 700;
  color: #4a3b36;
  opacity: 0.7;
  cursor: pointer;
  transition: all 0.2s;
}

.stat:hover {
  color: #d4af37;
  opacity: 1;
}

@media (max-width: 768px) {
  .floatingPoetryContainer {
    height: 540px;
    min-height: 540px;
  }

  .poemCard {
    width: 200px;
    padding: 10px;
  }

  .pauseBtn {
    width: 34px;
    height: 34px;
  }

  @keyframes floatLeft {
    0% {
      transform: translateX(120vw) scale(var(--card-scale, 1));
    }
    100% {
      transform: translateX(-260px) scale(var(--card-scale, 1));
    }
  }
}
</style>