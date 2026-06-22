<template>
  <div
      class="book-container"
      ref="containerRef"
      :style="{ backgroundImage: `url(${bgImage})` }"
  >
    <div class="book">
      <!-- 左侧底页 -->
      <div class="page page-left">
        <img
            v-for="(page, idx) in allPages"
            :key="'left-' + idx"
            :src="page.left"
            :class="{ active: idx === leftPageIndex }"
            decoding="async"
            loading="eager"
            draggable="false"
        />
        <div class="paper-texture"></div>
      </div>

      <!-- 右侧底页：下一页会在翻动开始前就准备好 -->
      <div class="page page-right">
        <img
            v-for="(page, idx) in allPages"
            :key="'right-' + idx"
            :src="page.right"
            :class="{ active: idx === rightUnderPageIndex }"
            decoding="async"
            loading="eager"
            draggable="false"
        />
        <div class="paper-texture"></div>
      </div>

      <!-- 下一页翻页层：右页向左翻 -->
      <div class="page-flip" :style="flipStyle">
        <div class="flip-front" :style="frontStyle">
          <img
              v-for="(page, idx) in allPages"
              :key="'front-' + idx"
              :src="page.right"
              :class="{ active: idx === flipFrontPageIndex }"
              decoding="async"
              loading="eager"
              draggable="false"
          />
          <div class="paper-texture"></div>
          <div class="page-fold" :style="foldStyle"></div>
        </div>

        <div class="flip-back" :style="backStyle">
          <img
              v-for="(page, idx) in allPages"
              :key="'back-' + idx"
              :src="page.left"
              :class="{ active: idx === flipBackPageIndex }"
              decoding="async"
              loading="eager"
              draggable="false"
          />
          <div class="paper-texture"></div>
        </div>

        <div class="flip-shadow" :style="shadowStyle"></div>
        <div class="flip-highlight" :style="highlightStyle"></div>
      </div>

      <!-- 上一页翻页层：左页向右翻 -->
      <div
          v-if="isPrevFlipping"
          class="prev-page-flip"
          :style="prevFlipStyle"
      >
        <div class="prev-flip-front" :style="prevFrontStyle">
          <img
              v-for="(page, idx) in allPages"
              :key="'prev-front-' + idx"
              :src="page.left"
              :class="{ active: idx === prevFlipFromPage }"
              decoding="async"
              loading="eager"
              draggable="false"
          />
          <div class="paper-texture"></div>
          <div class="prev-page-fold" :style="prevFoldStyle"></div>
        </div>

        <div class="prev-flip-back" :style="prevBackStyle">
          <img
              v-for="(page, idx) in allPages"
              :key="'prev-back-' + idx"
              :src="page.right"
              :class="{ active: idx === prevFlipTargetPage }"
              decoding="async"
              loading="eager"
              draggable="false"
          />
          <div class="paper-texture"></div>
        </div>

        <div class="prev-flip-shadow" :style="prevShadowStyle"></div>
        <div class="prev-flip-highlight" :style="prevHighlightStyle"></div>
      </div>

      <!-- 固定书脊：不参与翻页动画，始终压在最上层 -->
      <div class="book-spine-fixed">
        <div class="book-spine-core"></div>
      </div>

      <!-- 左侧图片点击区域：上一页 -->
      <div
          class="page-click-area page-click-left"
          title="上一页"
          @click="handleLeftPageClick"
      ></div>

      <!-- 右侧图片点击区域：下一页；同时保留右侧拖拽 -->
      <div
          class="page-click-area page-click-right"
          title="下一页"
          @click="handleRightPageClick"
          @mousedown="startDrag"
          @touchstart="startDrag"
      ></div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import Matter from 'matter-js'

import b1_1l from '../assets/book/1/1左.jpg'
import b1_1r from '../assets/book/1/1右.jpg'
import b1_2l from '../assets/book/1/2左.jpg'
import b1_2r from '../assets/book/1/2右.jpg'
import b1_3l from '../assets/book/1/3左.jpg'
import b1_3r from '../assets/book/1/3右.jpg'
import b1_4l from '../assets/book/1/4左.jpg'
import b1_4r from '../assets/book/1/4右.jpg'
import b1_5l from '../assets/book/1/5左.jpg'
import b1_5r from '../assets/book/1/5右.jpg'

import b2_1l from '../assets/book/2/1左.jpg'
import b2_1r from '../assets/book/2/1右.jpg'
import b2_2l from '../assets/book/2/2左.jpg'
import b2_2r from '../assets/book/2/2右.jpg'

import b3_1l from '../assets/book/3/1左.jpg'
import b3_1r from '../assets/book/3/1右.jpg'
import b3_2l from '../assets/book/3/2左.jpg'
import b3_2r from '../assets/book/3/2右.jpg'
import b3_3l from '../assets/book/3/3左.jpg'
import b3_3r from '../assets/book/3/3右.jpg'

import bgImage from '../assets/bg/physics-book.png'

const route = useRoute()
const containerRef = ref(null)

const currentPage = ref(0)
const angle = ref(0)
const angularVelocity = ref(0)
const progress = ref(0)

const isNextFlipping = ref(false)
const nextFlipFromPage = ref(0)
const nextFlipTargetPage = ref(0)

const isPrevFlipping = ref(false)
const prevProgress = ref(0)
const prevFlipFromPage = ref(0)
const prevFlipTargetPage = ref(0)

const friction = 0.65
const damping = 0.92
const flipThreshold = Math.PI * 0.3
const velocityThreshold = 0.06
const CLICK_MOVE_LIMIT = 8

/* 翻页速度：数值越大越慢 */
const FLIP_DURATION = 980
const BACK_DURATION = 420

const bookImagesMap = {
  '1': [
    { left: b1_1l, right: b1_1r },
    { left: b1_2l, right: b1_2r },
    { left: b1_3l, right: b1_3r },
    { left: b1_4l, right: b1_4r },
    { left: b1_5l, right: b1_5r }
  ],
  '2': [
    { left: b2_1l, right: b2_1r },
    { left: b2_2l, right: b2_2r }
  ],
  '3': [
    { left: b3_1l, right: b3_1r },
    { left: b3_2l, right: b3_2r },
    { left: b3_3l, right: b3_3r }
  ]
}

const currentBookId = computed(() => {
  const id = String(route.params.bookId || '1')
  return ['1', '2', '3'].includes(id) ? id : '1'
})

const allPages = computed(() => {
  const images = bookImagesMap[currentBookId.value]
  return images && images.length > 0 ? images : bookImagesMap['1']
})

const totalPages = computed(() => allPages.value.length)

const nextPageIndex = computed(() => {
  return (currentPage.value + 1) % totalPages.value
})

const prevPageIndex = computed(() => {
  return (currentPage.value - 1 + totalPages.value) % totalPages.value
})

const leftPageIndex = computed(() => {
  if (isPrevFlipping.value) return prevFlipTargetPage.value
  return currentPage.value
})

const rightUnderPageIndex = computed(() => {
  if (isNextFlipping.value) return nextFlipTargetPage.value
  if (isPrevFlipping.value) return prevFlipTargetPage.value
  return nextPageIndex.value
})

const flipFrontPageIndex = computed(() => {
  if (isNextFlipping.value) return nextFlipFromPage.value
  if (isPrevFlipping.value) return prevFlipTargetPage.value
  return currentPage.value
})

const flipBackPageIndex = computed(() => {
  if (isNextFlipping.value) return nextFlipTargetPage.value
  return nextPageIndex.value
})

let engine = null
let runner = null
let pageBody = null
let constraint = null

let isDragging = false
let isAnimating = false
let dragStartAngle = 0
let dragStartX = 0
let lastDragX = 0
let lastDragTime = 0
let dragVelocity = 0
let hasMovedDuringDrag = false
let suppressNextClick = false
let animationFrameId = 0

const imageCache = new Set()

const flipStyle = computed(() => {
  const p = progress.value
  const angleDeg = -p * 180

  return {
    transform: `translate3d(0,0,0) perspective(2000px) rotateY(${angleDeg}deg)`,
    transformOrigin: 'left center',
    transition: 'none',
    zIndex: p > 0.01 ? 35 : 12,
    pointerEvents: 'none'
  }
})

const frontStyle = computed(() => {
  const p = progress.value
  if (p <= 0) return {}

  const scaleX = 1 - p * 0.055

  return {
    transform: `translate3d(0,0,0) scaleX(${scaleX})`,
    boxShadow: `${-10 * p}px 0 ${22 * p}px rgba(0,0,0,${0.28 * p})`
  }
})

const backStyle = computed(() => {
  const p = progress.value
  if (p <= 0) return {}

  const scaleX = 1 - (1 - p) * 0.055

  return {
    transform: `translate3d(0,0,0) rotateY(180deg) scaleX(${scaleX})`,
    boxShadow: `${10 * (1 - p)}px 0 ${22 * (1 - p)}px rgba(0,0,0,${0.24 * (1 - p)})`
  }
})

const shadowStyle = computed(() => {
  const p = progress.value
  if (p <= 0) return { opacity: 0 }

  const opacity = Math.min(0.46, p * 0.62)

  return {
    opacity,
    background: `linear-gradient(to left,
      rgba(0,0,0,${opacity}) 0%,
      rgba(0,0,0,${opacity * 0.42}) 28%,
      transparent 70%)`
  }
})

const highlightStyle = computed(() => {
  const p = progress.value
  if (p <= 0 || p >= 1) return { opacity: 0 }

  const intensity = Math.sin(p * Math.PI)

  return {
    opacity: intensity * 0.18,
    background: `linear-gradient(to right,
      transparent 0%,
      rgba(255,255,255,${intensity * 0.32}) 50%,
      transparent 100%)`
  }
})

const foldStyle = computed(() => {
  const p = progress.value
  if (p <= 0) return { opacity: 0 }

  const foldPosition = 100 - p * 50
  const foldWidth = 10 + p * 16

  return {
    opacity: Math.min(1, p * 1.6),
    background: `linear-gradient(to right,
      transparent ${foldPosition - foldWidth}%,
      rgba(0,0,0,${0.14 * p}) ${foldPosition}%,
      rgba(255,255,255,${0.22 * p}) ${foldPosition + 2}%,
      transparent ${foldPosition + foldWidth}%)`
  }
})

const prevFlipStyle = computed(() => {
  const p = prevProgress.value
  const angleDeg = p * 180

  return {
    transform: `translate3d(0,0,0) perspective(2000px) rotateY(${angleDeg}deg)`,
    transformOrigin: 'right center',
    zIndex: 40,
    pointerEvents: 'none'
  }
})

const prevFrontStyle = computed(() => {
  const p = prevProgress.value
  const scaleX = 1 - p * 0.055

  return {
    transform: `translate3d(0,0,0) scaleX(${scaleX})`,
    boxShadow: `${10 * p}px 0 ${22 * p}px rgba(0,0,0,${0.26 * p})`
  }
})

const prevBackStyle = computed(() => {
  const p = prevProgress.value
  const scaleX = 1 - (1 - p) * 0.055

  return {
    transform: `translate3d(0,0,0) rotateY(180deg) scaleX(${scaleX})`,
    boxShadow: `${-10 * (1 - p)}px 0 ${22 * (1 - p)}px rgba(0,0,0,${0.24 * (1 - p)})`
  }
})

const prevShadowStyle = computed(() => {
  const p = prevProgress.value
  if (p <= 0) return { opacity: 0 }

  const opacity = Math.min(0.46, p * 0.62)

  return {
    opacity,
    background: `linear-gradient(to right,
      rgba(0,0,0,${opacity}) 0%,
      rgba(0,0,0,${opacity * 0.42}) 28%,
      transparent 70%)`
  }
})

const prevHighlightStyle = computed(() => {
  const p = prevProgress.value
  if (p <= 0 || p >= 1) return { opacity: 0 }

  const intensity = Math.sin(p * Math.PI)

  return {
    opacity: intensity * 0.18,
    background: `linear-gradient(to left,
      transparent 0%,
      rgba(255,255,255,${intensity * 0.3}) 50%,
      transparent 100%)`
  }
})

const prevFoldStyle = computed(() => {
  const p = prevProgress.value
  if (p <= 0) return { opacity: 0 }

  const foldPosition = p * 50
  const foldWidth = 10 + p * 16

  return {
    opacity: Math.min(1, p * 1.6),
    background: `linear-gradient(to left,
      transparent ${foldPosition - foldWidth}%,
      rgba(0,0,0,${0.14 * p}) ${foldPosition}%,
      rgba(255,255,255,${0.22 * p}) ${foldPosition + 2}%,
      transparent ${foldPosition + foldWidth}%)`
  }
})

function easeInOutCubic(t) {
  return t < 0.5
      ? 4 * t * t * t
      : 1 - Math.pow(-2 * t + 2, 3) / 2
}

function easeOutCubic(t) {
  return 1 - Math.pow(1 - t, 3)
}

function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value))
}

function preloadImage(src) {
  if (!src || imageCache.has(src)) return

  imageCache.add(src)

  const img = new Image()
  img.decoding = 'async'
  img.src = src

  if (img.decode) {
    img.decode().catch(() => {})
  }
}

function preloadPages(pages) {
  preloadImage(bgImage)

  pages.forEach((page) => {
    preloadImage(page.left)
    preloadImage(page.right)
  })
}

function preloadAround(index) {
  const pages = allPages.value
  const total = pages.length
  if (!total) return

  const indices = [
    index,
    (index + 1) % total,
    (index + 2) % total,
    (index - 1 + total) % total
  ]

  indices.forEach((i) => {
    preloadImage(pages[i].left)
    preloadImage(pages[i].right)
  })
}

function prepareNextFlip() {
  nextFlipFromPage.value = currentPage.value
  nextFlipTargetPage.value = nextPageIndex.value
  isNextFlipping.value = true
  preloadAround(nextFlipTargetPage.value)
}

function preparePrevFlip() {
  prevFlipFromPage.value = currentPage.value
  prevFlipTargetPage.value = prevPageIndex.value
  isPrevFlipping.value = true
  preloadAround(prevFlipTargetPage.value)
}

function initPhysics() {
  engine = Matter.Engine.create({
    gravity: { x: 0, y: 0 }
  })

  pageBody = Matter.Bodies.rectangle(0, 0, 100, 100, {
    isStatic: false,
    friction,
    frictionAir: 1 - damping,
    restitution: 0.06,
    density: 0.001,
    label: 'page'
  })

  constraint = Matter.Constraint.create({
    pointA: { x: 0, y: 0 },
    bodyB: pageBody,
    pointB: { x: -50, y: 0 },
    stiffness: 0.01,
    damping: 0.075,
    length: 0
  })

  Matter.Composite.add(engine.world, [pageBody, constraint])
  Matter.Events.on(engine, 'afterUpdate', onPhysicsUpdate)

  runner = Matter.Runner.create()
  Matter.Runner.run(runner, engine)
}

function onPhysicsUpdate() {
  if (!pageBody) return

  angle.value = pageBody.angle
  angularVelocity.value = pageBody.angularVelocity

  const nextProgress = clamp(-angle.value / Math.PI, 0, 1)
  progress.value = nextProgress

  if (nextProgress > 0.01) {
    if (!isNextFlipping.value) {
      prepareNextFlip()
    }
  } else if (!isDragging && !isAnimating) {
    isNextFlipping.value = false
  }

  if (!isDragging && !isAnimating && !isPrevFlipping.value) {
    const currentAngle = pageBody.angle
    const currentVelocity = pageBody.angularVelocity

    if (
        currentAngle < -flipThreshold ||
        (currentAngle < -Math.PI * 0.18 && currentVelocity < -velocityThreshold)
    ) {
      animateNextFromCurrent()
    } else if (Math.abs(currentAngle) > 0.05 && Math.abs(currentVelocity) < 0.01) {
      animateBackToRest()
    }
  }
}

function commitNextPage() {
  currentPage.value = nextFlipTargetPage.value
  resetPhysics()
  isNextFlipping.value = false
  isAnimating = false
  preloadAround(currentPage.value)
}

function commitPrevPage() {
  currentPage.value = prevFlipTargetPage.value
  resetPhysics()
  isPrevFlipping.value = false
  prevProgress.value = 0
  isAnimating = false
  preloadAround(currentPage.value)
}

function resetPhysics() {
  if (pageBody) {
    Matter.Body.setAngle(pageBody, 0)
    Matter.Body.setAngularVelocity(pageBody, 0)
    Matter.Body.setPosition(pageBody, { x: 0, y: 0 })
  }

  progress.value = 0
}

function getPointerPosition(e) {
  return e.touches ? e.touches[0] : e
}

function startDrag(e) {
  if (!pageBody || isAnimating || isPrevFlipping.value) return
  if (e.type === 'mousedown' && e.button !== 0) return

  prepareNextFlip()

  isDragging = true
  hasMovedDuringDrag = false

  const pos = getPointerPosition(e)

  dragStartX = pos.clientX
  dragStartAngle = pageBody.angle
  lastDragX = pos.clientX
  lastDragTime = performance.now()
  dragVelocity = 0

  document.addEventListener('mousemove', onDrag)
  document.addEventListener('mouseup', endDrag)
  document.addEventListener('touchmove', onDrag, { passive: false })
  document.addEventListener('touchend', endDrag)
}

function onDrag(e) {
  if (!isDragging || !pageBody) return

  e.preventDefault()

  const pos = getPointerPosition(e)
  const deltaX = pos.clientX - dragStartX
  const containerWidth = containerRef.value?.offsetWidth || 800

  if (Math.abs(deltaX) > CLICK_MOVE_LIMIT) {
    hasMovedDuringDrag = true
  }

  const now = performance.now()
  const dt = now - lastDragTime

  if (dt > 0) {
    const dx = pos.clientX - lastDragX
    dragVelocity = (dx / dt) * 1000
  }

  lastDragX = pos.clientX
  lastDragTime = now

  const angleDelta = -(deltaX / containerWidth) * Math.PI * 1.35
  const newAngle = clamp(dragStartAngle + angleDelta, -Math.PI * 1.05, 0.08)

  Matter.Body.setAngle(pageBody, newAngle)
  Matter.Body.setAngularVelocity(pageBody, 0)
}

function endDrag() {
  if (!isDragging) return

  isDragging = false

  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', endDrag)
  document.removeEventListener('touchmove', onDrag)
  document.removeEventListener('touchend', endDrag)

  if (hasMovedDuringDrag) {
    suppressNextClick = true
    window.setTimeout(() => {
      suppressNextClick = false
    }, 160)
  }

  if (!pageBody) return

  const currentAngle = pageBody.angle
  const containerWidth = containerRef.value?.offsetWidth || 800
  const angularVel = -(dragVelocity / containerWidth) * Math.PI * 2

  const shouldFlip =
      currentAngle < -flipThreshold * 0.55 ||
      angularVel < -velocityThreshold * 2.2

  if (shouldFlip) {
    animateNextFromCurrent()
  } else if (Math.abs(currentAngle) > 0.03) {
    animateBackToRest()
  } else {
    resetPhysics()
    isNextFlipping.value = false
  }
}

function cancelAnimation() {
  if (animationFrameId) {
    cancelAnimationFrame(animationFrameId)
    animationFrameId = 0
  }
}

function animateBackToRest() {
  if (!pageBody || isAnimating) return

  cancelAnimation()

  isAnimating = true

  const startAngle = pageBody.angle
  const startTime = performance.now()

  function animate(now) {
    const elapsed = now - startTime
    const p = clamp(elapsed / BACK_DURATION, 0, 1)
    const eased = easeOutCubic(p)

    const currentAngle = startAngle + (0 - startAngle) * eased

    Matter.Body.setAngle(pageBody, currentAngle)
    Matter.Body.setAngularVelocity(pageBody, 0)

    if (p < 1) {
      animationFrameId = requestAnimationFrame(animate)
    } else {
      animationFrameId = 0
      resetPhysics()
      isNextFlipping.value = false
      isAnimating = false
    }
  }

  animationFrameId = requestAnimationFrame(animate)
}

function animateNextFromCurrent() {
  if (!pageBody || isAnimating || isPrevFlipping.value) return

  cancelAnimation()
  prepareNextFlip()

  isAnimating = true

  const targetAngle = -Math.PI
  const startAngle = pageBody.angle
  const startTime = performance.now()

  function animate(now) {
    const elapsed = now - startTime
    const p = clamp(elapsed / FLIP_DURATION, 0, 1)
    const eased = easeInOutCubic(p)

    const currentAngle = startAngle + (targetAngle - startAngle) * eased

    Matter.Body.setAngle(pageBody, currentAngle)
    Matter.Body.setAngularVelocity(pageBody, 0)

    if (p < 1) {
      animationFrameId = requestAnimationFrame(animate)
    } else {
      animationFrameId = 0
      commitNextPage()
    }
  }

  animationFrameId = requestAnimationFrame(animate)
}

function nextPage() {
  if (!pageBody || isDragging || isAnimating || isPrevFlipping.value) return

  prepareNextFlip()
  animateNextFromCurrent()
}

function prevPage() {
  if (!pageBody || isDragging || isAnimating || isPrevFlipping.value) return

  cancelAnimation()
  preparePrevFlip()

  isAnimating = true
  prevProgress.value = 0

  const startTime = performance.now()

  function animate(now) {
    const elapsed = now - startTime
    const p = clamp(elapsed / FLIP_DURATION, 0, 1)
    const eased = easeInOutCubic(p)

    prevProgress.value = eased

    if (p < 1) {
      animationFrameId = requestAnimationFrame(animate)
    } else {
      animationFrameId = 0
      commitPrevPage()
    }
  }

  animationFrameId = requestAnimationFrame(animate)
}

function handleLeftPageClick() {
  if (isDragging || isAnimating || isPrevFlipping.value || suppressNextClick) return
  prevPage()
}

function handleRightPageClick() {
  if (isDragging || isAnimating || isPrevFlipping.value || suppressNextClick) return
  nextPage()
}

onMounted(() => {
  preloadPages(allPages.value)
  preloadAround(currentPage.value)
  initPhysics()
})

watch(currentBookId, () => {
  cancelAnimation()

  currentPage.value = 0
  isAnimating = false
  isNextFlipping.value = false
  isPrevFlipping.value = false
  prevProgress.value = 0

  preloadPages(allPages.value)
  preloadAround(0)
  resetPhysics()
})

watch(currentPage, (value) => {
  preloadAround(value)
})

onUnmounted(() => {
  cancelAnimation()

  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', endDrag)
  document.removeEventListener('touchmove', onDrag)
  document.removeEventListener('touchend', endDrag)

  if (runner) Matter.Runner.stop(runner)
  if (engine) Matter.Engine.clear(engine)
})
</script>

<style scoped>
.book-container {
  width: 100%;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  perspective: 2000px;
  overflow: hidden;
  user-select: none;
  -webkit-user-select: none;
}

.book {
  position: relative;
  width: 75%;
  max-width: 700px;
  height: 75vh;
  transform-style: preserve-3d;
  contain: layout paint style;
  transform: translate3d(0, 0, 0);
  isolation: isolate;
}

.page {
  position: absolute;
  width: 50%;
  height: 100%;
  backface-visibility: hidden;
  -webkit-backface-visibility: hidden;
  transform: translate3d(0, 0, 0);
  overflow: hidden;
}

.page-left {
  left: 0;
  z-index: 1;
}

.page-right {
  right: 0;
  z-index: 1;
}

.page-left img,
.page-right img,
.flip-front img,
.flip-back img,
.prev-flip-front img,
.prev-flip-back img {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  opacity: 0;
  visibility: hidden;
  transition: none;
  transform: translate3d(0, 0, 0);
  backface-visibility: hidden;
  -webkit-backface-visibility: hidden;
  image-rendering: auto;
  pointer-events: none;
}

.page-left img {
  border-radius: 4px 0 0 4px;
  box-shadow: inset 3px 0 18px rgba(0, 0, 0, 0.1);
}

.page-right img {
  border-radius: 0 4px 4px 0;
  box-shadow: inset -3px 0 18px rgba(0, 0, 0, 0.1);
}

.page-left img.active,
.page-right img.active,
.flip-front img.active,
.flip-back img.active,
.prev-flip-front img.active,
.prev-flip-back img.active {
  opacity: 1;
  visibility: visible;
}

.page-flip {
  position: absolute;
  right: 0;
  width: 50%;
  height: 100%;
  transform-style: preserve-3d;
  will-change: transform;
  transform: translate3d(0, 0, 0);
  pointer-events: none;
}

.prev-page-flip {
  position: absolute;
  left: 0;
  width: 50%;
  height: 100%;
  transform-style: preserve-3d;
  will-change: transform;
  transform: translate3d(0, 0, 0);
  pointer-events: none;
}

.flip-front,
.flip-back,
.prev-flip-front,
.prev-flip-back {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  backface-visibility: hidden;
  -webkit-backface-visibility: hidden;
  overflow: hidden;
  will-change: transform, box-shadow;
  transform: translate3d(0, 0, 0);
}

.flip-front {
  background: #f5f0e6;
  border-radius: 0 4px 4px 0;
}

.flip-back {
  background: #e8e0d4;
  transform: translate3d(0, 0, 0) rotateY(180deg);
  border-radius: 4px 0 0 4px;
}

.prev-flip-front {
  background: #f5f0e6;
  border-radius: 4px 0 0 4px;
}

.prev-flip-back {
  background: #e8e0d4;
  transform: translate3d(0, 0, 0) rotateY(180deg);
  border-radius: 0 4px 4px 0;
}

.page-fold,
.prev-page-fold {
  position: absolute;
  inset: 0;
  pointer-events: none;
  will-change: opacity, background;
}

.flip-shadow {
  position: absolute;
  top: 0;
  right: 0;
  width: 50%;
  height: 100%;
  pointer-events: none;
  will-change: opacity;
}

.prev-flip-shadow {
  position: absolute;
  top: 0;
  left: 0;
  width: 50%;
  height: 100%;
  pointer-events: none;
  will-change: opacity;
}

.flip-highlight,
.prev-flip-highlight {
  position: absolute;
  inset: 0;
  pointer-events: none;
  will-change: opacity;
}

.paper-texture {
  position: absolute;
  inset: 0;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.8' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.032'/%3E%3C/svg%3E");
  pointer-events: none;
}

/* 固定书脊：独立顶层，不再被翻页层影响 */
.book-spine-fixed {
  position: absolute;
  left: calc(50% - 6px);
  top: 0;
  width: 12px;
  height: 100%;
  z-index: 130;
  pointer-events: none;
  transform: translate3d(0, 0, 80px);
  backface-visibility: hidden;
  -webkit-backface-visibility: hidden;
  contain: paint;
}

.book-spine-core {
  position: absolute;
  inset: 0;
  border-radius: 4px;
  background:
      linear-gradient(
          90deg,
          rgba(50, 34, 22, 0.9) 0%,
          rgba(126, 99, 75, 0.96) 24%,
          rgba(80, 58, 42, 1) 50%,
          rgba(48, 34, 24, 0.96) 76%,
          rgba(28, 20, 14, 0.9) 100%
      );
  box-shadow:
      0 0 10px rgba(0, 0, 0, 0.34),
      inset 2px 0 4px rgba(255, 255, 255, 0.16),
      inset -2px 0 5px rgba(0, 0, 0, 0.35);
}

.book-spine-core::before {
  content: '';
  position: absolute;
  top: 0;
  left: 45%;
  width: 1px;
  height: 100%;
  background: rgba(255, 245, 220, 0.25);
}

.book-spine-core::after {
  content: '';
  position: absolute;
  top: 0;
  right: 18%;
  width: 1px;
  height: 100%;
  background: rgba(0, 0, 0, 0.25);
}

.page-click-area {
  position: absolute;
  top: 0;
  height: 100%;
  z-index: 140;
  background: transparent;
  -webkit-tap-highlight-color: transparent;
  user-select: none;
}

/* 点击区域避开书脊，防止点中间时误触发 */
.page-click-left {
  left: 0;
  width: calc(50% - 12px);
  cursor: w-resize;
}

.page-click-right {
  right: 0;
  width: calc(50% - 12px);
  cursor: e-resize;
}

.page-click-area:active {
  cursor: grabbing;
}

@media (max-width: 768px) {
  .book {
    width: 92%;
    height: 65vh;
  }

  .book-spine-fixed {
    left: calc(50% - 5px);
    width: 10px;
  }

  .page-click-left {
    width: calc(50% - 10px);
  }

  .page-click-right {
    width: calc(50% - 10px);
  }
}
</style>