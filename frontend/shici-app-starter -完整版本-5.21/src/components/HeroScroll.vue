<template>
  <section ref="wrapRef" class="hero-scroll" @scroll.passive="onScroll">
    <div
      v-for="(item, i) in scenes"
      :key="i"
      class="scene"
      :class="{ active: i === activeIndex }"
    >
      <div class="bg" :style="bgStyle(i, item.img)" aria-hidden="true"></div>
      <div class="mask" aria-hidden="true"></div>

      <div class="text" :style="textStyle(i)">
        <div class="line main">
          <span class="type" :style="typeStyle(i, item.main)">{{ item.main }}</span>
        </div>
        <div class="line sub">
          <span class="type delay" :style="typeStyle(i, item.sub, true)">{{ item.sub }}</span>
        </div>
      </div>

      <div class="hint" v-if="i === 0">向下滚动进入下一幕</div>

      <div class="dots" aria-hidden="true">
        <span
          v-for="n in scenes.length"
          :key="n"
          class="dot"
          :class="{ on: n - 1 === activeIndex }"
        />
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'

import img1 from '@/assets/home/scroll/1.jpg'
import img2 from '@/assets/home/scroll/2.jpg'
import img3 from '@/assets/home/scroll/3.jpg'
import img4 from '@/assets/home/scroll/4.jpg'
import img5 from '@/assets/home/scroll/5.jpg'
import img6 from '@/assets/home/scroll/6.jpg'

const scenes = [
  { img: img1, main: '若似月轮终皎洁', sub: '不辞冰雪为卿热' },
  { img: img2, main: '南风知我意', sub: '吹梦到西洲' },
  { img: img3, main: '须知少时凌云志', sub: '曾许天下第一流' },
  { img: img4, main: '江畔何人初见月', sub: '江月何年初照人' },
  { img: img5, main: '你挑灯回看', sub: '我把萧瑟写成歌' },
  { img: img6, main: '寒风初歇', sub: '微雨乍停' },
]

const wrapRef = ref(null)
const activeIndex = ref(0)
const progressMap = ref(new Array(scenes.length).fill(0))

function clamp(n, a, b) {
  return Math.max(a, Math.min(b, n))
}

function calc() {
  const el = wrapRef.value
  if (!el) return
  const h = el.clientHeight
  const top = el.scrollTop

  activeIndex.value = clamp(Math.round(top / h), 0, scenes.length - 1)

  for (let i = 0; i < scenes.length; i++) {
    const start = i * h
    const p = (top - start) / h
    progressMap.value[i] = clamp(p, 0, 1)
  }
}

function onScroll() {
  requestAnimationFrame(calc)
}

onMounted(() => {
  calc()
  window.addEventListener('resize', calc, { passive: true })
})
onBeforeUnmount(() => {
  window.removeEventListener('resize', calc)
})

function bgStyle(i, img) {
  const p = progressMap.value[i] || 0
  const translate = -12 + p * 12
  const scale = 1.07 - p * 0.07
  return {
    backgroundImage: `url(${img})`,
    transform: `translateY(${translate}px) scale(${scale})`,
  }
}

function textStyle(i) {
  const p = progressMap.value[i] || 0
  const y = 22 - p * 22
  const op = 0.1 + p * 0.9
  return { transform: `translateY(${y}px)`, opacity: op }
}

function typeStyle(i, text, isSub = false) {
  const isActive = i === activeIndex.value
  const len = Math.max(1, (text || '').length)
  const dur = isSub ? Math.min(3.0, 0.12 * len + 0.9) : Math.min(2.4, 0.11 * len + 0.7)
  return {
    animationPlayState: isActive ? 'running' : 'paused',
    '--n': len,
    '--dur': `${dur}s`,
  }
}
</script>

<style scoped>
.hero-scroll {
  height: 100vh;
  overflow-y: auto;
  scroll-snap-type: y mandatory;
  scroll-behavior: smooth;
}

.scene {
  position: relative;
  height: 100vh;
  width: 100%;
  scroll-snap-align: start;
  overflow: hidden;
}

.bg {
  position: absolute;
  inset: -7%;
  background-size: cover;
  background-position: center;
  will-change: transform;
  transition: transform 0.05s linear;
}

.mask {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(1100px 560px at 18% 74%, rgba(0,0,0,0.10), transparent 60%),
    linear-gradient(to bottom, rgba(0,0,0,0.10), rgba(0,0,0,0.62));
}

.text {
  position: absolute;
  left: 8%;
  bottom: 14%;
  color: rgba(255,255,255,0.98);
  writing-mode: vertical-rl;
  letter-spacing: 0.16em;
  text-shadow: 0 14px 40px rgba(0,0,0,0.38);
  will-change: transform, opacity;
  transition: transform 0.12s ease, opacity 0.12s ease;
}

.line.main {
  font-size: 40px;
  font-weight: 900;
  margin-left: 18px;
}

.line.sub {
  margin-top: 12px;
  font-size: 22px;
  font-weight: 700;
  opacity: 0.94;
}

.type {
  display: inline-block;
  overflow: hidden;
  white-space: nowrap;
  width: 0;
  animation: typeIn var(--dur) steps(var(--n)) forwards;
}

.type.delay {
  animation-delay: 0.45s;
}

.scene.active .type {
  width: 0;
  animation-name: typeIn;
}

@keyframes typeIn {
  from { width: 0; }
  to { width: 100%; }
}

.hint {
  position: absolute;
  left: 50%;
  bottom: 26px;
  transform: translateX(-50%);
  color: rgba(255,255,255,0.86);
  font-weight: 800;
  font-size: 13px;
  letter-spacing: 0.12em;
  padding: 8px 14px;
  border-radius: 999px;
  background: rgba(0,0,0,0.22);
  border: 1px solid rgba(255,255,255,0.16);
  backdrop-filter: blur(10px);
}

.dots {
  position: absolute;
  right: 18px;
  top: 50%;
  transform: translateY(-50%);
  display: flex;
  flex-direction: column;
  gap: 10px;
  z-index: 2;
}

.dot {
  width: 7px;
  height: 7px;
  border-radius: 999px;
  background: rgba(255,255,255,0.28);
}
.dot.on {
  background: rgba(255,255,255,0.88);
  box-shadow: 0 0 0 6px rgba(255,255,255,0.12);
}

@media (max-width: 900px) {
  .text { left: 6%; bottom: 12%; }
  .line.main { font-size: 30px; }
  .line.sub { font-size: 18px; }
}
</style>
