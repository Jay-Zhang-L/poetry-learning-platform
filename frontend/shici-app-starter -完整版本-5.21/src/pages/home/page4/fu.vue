<template>
  <div class="fu-page-container">
    <!-- 国风导航栏 -->
    <PoetryNavigation />

    <!-- 多个长卷式内容分屏 -->
    <main class="fu-main-content" ref="mainContent">
      <!-- 卷一：赋的起源 -->
      <section class="scroll-section origin-section" id="section-origin">
        <div
          class="section-bg origin-bg"
          :style="{ backgroundImage: `url(${sectionBgs[0]})` }"
        ></div>

        <div class="origin-stage">
          <!-- 左侧文字 -->
          <div class="origin-text-panel">
            <div class="origin-title-wrap">
              <h2 class="section-title origin-title">赋的起源</h2>
            </div>

            <div class="section-desc origin-desc origin-line origin-line-1">
              赋是中国古代一种独特的文学体裁，介于诗歌与散文之间。起源于战国，兴盛于汉魏，盛行于六朝。赋讲究铺陈排比、辞藻华丽，善用比喻和夸张，既有诗歌的韵律美，又有散文的叙述功能。
            </div>

            <div class="origin-quote origin-line origin-line-2">
              “赋者，古诗之流也，铺采摛文，体物写志”
            </div>
          </div>

          <!-- 太阳 -->
          <img class="origin-sun" :src="fuSun" alt="sun" />

          <!-- 山 -->
          <div class="origin-mountain-wrap">
            <img class="origin-mountain" :src="fuMountain" alt="mountain" />
          </div>
        </div>
      </section>

      <!-- 卷一 / 卷二 过渡 -->
      <section class="transition-scene-section" id="origin-hanfu-transition">
        <div class="transition-scene-inner">
          <!-- 左侧底云 -->
          <img class="transition-cloud-left" :src="fuCloud" alt="cloud" />

          <!-- 宫殿 -->
          <img
            class="transition-house"
            :src="fuHouse"
            alt="house"
            :style="{ transform: `translateY(${houseFloatY}px)` }"
          />

          <!-- 右上云 -->
          <img
            class="transition-cloud-right"
            :src="fuCloud2"
            alt="cloud2"
            :style="{ transform: `translateY(${cloud2FloatY}px)` }"
          />

          <!-- 左下树 -->
          <img
            class="transition-tree"
            :src="fuTree"
            alt="tree"
            :style="{ transform: `translateY(${treeFloatY}px)` }"
          />
        </div>
      </section>

      <!-- 卷二：汉赋 -->
      <section class="scroll-section" id="section-hanfu">
        <div
          class="section-bg"
          :style="{ backgroundImage: `url(${sectionBgs[1]})` }"
        ></div>

        <img class="hanfu-house2" :src="fuHouse2" alt="house2" />

        <div class="section-content reverse">
          <div class="visual-content"></div>

          <div class="text-content reveal-block hanfu-reveal">
            <h2 class="section-title reveal-item">汉赋</h2>

            <div class="section-desc">
              <p class="reveal-item">
                汉代是赋的黄金时代，汉赋以其宏大的气魄和华丽的辞藻著称。司马相如、扬雄等是汉赋的代表作家。
              </p>
              <p class="reveal-item">
                《子虚赋》、《上林赋》等作品展现了汉赋的典型特色：铺张扬厉、辞藻华丽、气势恢宏。
              </p>
            </div>
          </div>
        </div>
      </section>

      <!-- 卷二 / 卷三 过渡 -->
<section class="hanfu-shuqing-middle" id="hanfu-shuqing-middle">
  <img class="hanfu-shuqing-middle-img" :src="fuMiddle" alt="middle" />

  <div class="cloud3-wrapper">
    <img class="hanfu-shuqing-cloud3" :src="fuCloud3" alt="cloud3" />
  </div>

  <img
    class="hanfu-shuqing-car"
    :src="fuCar"
    alt="car"
    :style="{ left: carPosition + 'vw' }"
  />
</section>

      <!-- 卷三：抒情小赋 -->
      <section class="scroll-section" id="section-shuqing">
        <div
          class="section-bg"
          :style="{ backgroundImage: `url(${fuBg3})` }"
        ></div>

        <div class="section-content">
          <div class="text-content reveal-block shuqing-reveal">
            <h2 class="section-title reveal-item">抒情小赋</h2>

            <div class="section-desc">
              <p class="reveal-item">
                魏晋南北朝时期，赋体发生了重要变化，由大赋转向抒情小赋。篇幅短小，情感真挚，意境深远。
              </p>
              <p class="reveal-item">
                陶渊明《归去来兮辞》、曹植《洛神赋》等都是抒情小赋的经典之作，对后世文学影响深远。
              </p>
            </div>

            <div class="poetry-excerpt">
              <div class="poem-title reveal-item">《洛神赋》（节选）</div>

              <div class="poem-content">
                <span class="poem-line reveal-item">翩若惊鸿，婉若游龙。</span>
                <span class="poem-line reveal-item">荣曜秋菊，华茂春松。</span>
                <span class="poem-line reveal-item">
                  仿佛兮若轻云之蔽月，飘摇兮若流风之回雪。
                </span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- 说赋 -->
      <section class="video-section" id="section-video" :style="{ backgroundImage: `url(${videoGalleryBgImg})`, backgroundSize: 'cover', backgroundPosition: 'center' }">
        <div class="section-header">
          <div class="calligraphy-title">
            <span class="calligraphy-char">说</span>
            <span class="calligraphy-char">赋</span>
          </div>
        </div>

        <div class="video-gallery">
          <div
            v-for="(video, index) in videos"
            :key="video.id"
            class="video-card"
            @click="playVideo(index)"
          >
            <div class="video-thumbnail">
              <img v-if="video.thumbnail" :src="video.thumbnail" :alt="video.title">
              <div v-else class="video-thumbnail-placeholder">
                <span class="video-placeholder-icon">🎬</span>
              </div>
              <div class="play-overlay">
                <div class="play-btn">
                  <span class="play-icon">▶</span>
                </div>
              </div>
              <div class="video-duration">{{ video.duration }}</div>
            </div>
          </div>
        </div>
      </section>

      <!-- 赏赋 -->
      <section class="gallery-section" id="section-gallery" :style="{ backgroundImage: `url(${videoGalleryBgImg})`, backgroundSize: 'cover', backgroundPosition: 'center' }">
        <div class="section-header">
          <div class="calligraphy-title">
            <span class="calligraphy-char">赏</span>
            <span class="calligraphy-char">赋</span>
          </div>
        </div>

        <div class="gallery-container">
          <div class="ancient-book-layout">
            <!-- 大型书法作品区域 - 占2行2列 -->
            <div class="calligraphy-area large" @click="viewPainting(0)">
              <div class="calligraphy-content">
                <div class="calligraphy-placeholder" :style="{ backgroundImage: `url(${paintings[0].image})` }">
                </div>
              </div>
            </div>

            <!-- 中型作品 - 占1行2列 -->
            <div class="calligraphy-area medium-wide" @click="viewPainting(1)">
              <div class="calligraphy-content">
                <div class="calligraphy-placeholder" :style="{ backgroundImage: `url(${paintings[1].image})` }">
                </div>
              </div>
            </div>

            <!-- 小型作品 - 占1行1列 -->
            <div class="calligraphy-area small" @click="viewPainting(2)">
              <div class="calligraphy-content">
                <div class="calligraphy-placeholder" :style="{ backgroundImage: `url(${paintings[2].image})` }">
                </div>
              </div>
            </div>

            <!-- 小型作品 - 占1行1列 -->
            <div class="calligraphy-area small" @click="viewPainting(3)">
              <div class="calligraphy-content">
                <div class="calligraphy-placeholder" :style="{ backgroundImage: `url(${paintings[3].image})` }">
                </div>
              </div>
            </div>

            <!-- 中型作品 - 占2行1列 -->
            <div class="calligraphy-area medium-tall" @click="viewPainting(4)">
              <div class="calligraphy-content">
                <div class="calligraphy-placeholder" :style="{ backgroundImage: `url(${paintings[4].image})` }">
                </div>
              </div>
            </div>

             <!-- 中型作品 - 占2行1列 -->
            <div class="calligraphy-area medium-tall" @click="viewPainting(5)">
              <div class="calligraphy-content">
                <div class="calligraphy-placeholder" :style="{ backgroundImage: `url(${paintings[5].image})` }">
                </div>
              </div>
            </div>

            <!-- 大型作品 - 占2行2列 -->
            <div class="calligraphy-area large" @click="viewPainting(6)">
              <div class="calligraphy-content">
                <div class="calligraphy-placeholder" :style="{ backgroundImage: `url(${paintings[6].image})` }">
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- 页脚 -->
      <footer class="fu-footer">
        <div class="footer-content">
          <div class="footer-text">
            <p>赋是中华文学宝库中的璀璨明珠</p>
            <p>铺张扬厉，辞藻华丽，展现中国文学的雄浑气魄</p>
          </div>

          <div class="footer-actions">
            <button class="footer-btn" @click="scrollToTop">
              <span>↑ 返回顶部</span>
            </button>
            <button class="footer-btn" @click="exploreMore">
              <span>探索更多 →</span>
            </button>
          </div>
        </div>
      </footer>
    </main>

    <!-- 视频播放弹窗 -->
    <div v-if="showVideoModal" class="video-modal" @click="closeVideoModal">
      <div class="modal-content" @click.stop>
        <button class="close-btn" @click="closeVideoModal">✕</button>

        <div class="video-player">
          <video :src="currentVideo.url" controls autoplay></video>
        </div>

        <div class="video-detail">
          <h3>{{ currentVideo.title }}</h3>
          <p>{{ currentVideo.speaker }}</p>
          <p>{{ currentVideo.description }}</p>
        </div>
      </div>
    </div>

    <!-- 图片查看弹窗 -->
    <div
      v-if="showPaintingModal"
      class="painting-modal"
      @click="closePaintingModal"
    >
      <div class="modal-content" @click.stop>
        <button class="close-btn" @click="closePaintingModal">✕</button>

        <div class="painting-viewer">
          <img
            v-if="currentPainting.image"
            :src="currentPainting.image"
            :alt="currentPainting.title"
          />

          <div v-else class="painting-modal-placeholder">
            <span class="modal-placeholder-icon">🎨</span>
            <p>{{ currentPainting.title }}</p>
          </div>

          <div class="painting-detail">
            <h3>{{ currentPainting.title }}</h3>
            <p>作者：{{ currentPainting.artist }}</p>
            <p>关联赋作：{{ currentPainting.relatedFu }}</p>
            <p>{{ currentPainting.description }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import PoetryNavigation from '@/components/PoetryNavigation.vue'
import fuSun from '@/assets/home1/fu/sun.png'
import fuMountain from '@/assets/home1/fu/mountain.png'
import fuCloud from '@/assets/home1/fu/cloud.png'
import fuCloud2 from '@/assets/home1/fu/cloud2.png'
import fuHouse from '@/assets/home1/fu/house.png'
import fuTree from '@/assets/home1/fu/tree.png'
import fuHouse2 from '@/assets/home1/fu/house2.png'
import fuBg3 from '@/assets/home1/fu/4.jpg'
import fuMiddle from '@/assets/home1/fu/middle.jpg'
import fuCloud3 from '@/assets/home1/fu/cloud3.png'
import fuCar from '@/assets/home1/fu/car.png'

const videoGalleryBgImg = new URL('@/assets/home1/shi/chouti/bg.jpg', import.meta.url).href

const router = useRouter()
const mainContent = ref(null)

const houseFloatY = ref(0)
const cloud2FloatY = ref(0)
const treeFloatY = ref(0)
const carPosition = ref(32)

const sectionBgs = ref(['', '', ''])

const videos = ref([
  {
    id: 1,
    title: '汉赋的艺术成就——铺张扬厉的文学之美',
    speaker: '傅璇琮教授',
    description: '深入解读汉赋的艺术特色、发展历程与文化价值',
    category: '古典文学',
    views: '12.8万',
    tags: ['汉赋', '司马相如', '古典文学'],
    thumbnail: '',
    duration: '18:45',
    url: ''
  }
])

const paintings = ref([
  {
    id: 1,
    title: '上林苑图',
    artist: '仇英',
    era: '明代',
    dynasty: '明代',
    relatedFu: '《上林赋》',
    image: new URL('@/assets/home1/fu/shang/class-PC01-56.jpg', import.meta.url).href,
    description: '再现司马相如笔下的皇家园林，展现汉赋宏大场景'
  },
  {
    id: 2,
    title: '洛神图',
    artist: '顾恺之',
    era: '东晋',
    dynasty: '晋代',
    relatedFu: '《洛神赋》',
    image: new URL('@/assets/home1/fu/shang/class-PC02-89.jpg', import.meta.url).href,
    description: '洛神形象的艺术再现，展现赋中绝美意境'
  },
  {
    id: 3,
    title: '归去来图',
    artist: '文征明',
    era: '明代',
    dynasty: '明代',
    relatedFu: '《归去来兮辞》',
    image: new URL('@/assets/home1/fu/shang/class-PC03-100.jpg', import.meta.url).href,
    description: '陶渊明归隐田园的生活场景'
  },
  {
    id: 4,
    title: '子虚图',
    artist: '唐寅',
    era: '明代',
    dynasty: '明代',
    relatedFu: '《子虚赋》',
    image: new URL('@/assets/home1/fu/shang/class-PC04-99.jpg', import.meta.url).href,
    description: '子虚与乌有先生对话的场景描绘'
  },
  {
    id: 5,
    title: '阿房宫图',
    artist: '袁江',
    era: '清代',
    dynasty: '清代',
    relatedFu: '《阿房宫赋》',
    image: new URL('@/assets/home1/fu/shang/class-PC05-51.jpg', import.meta.url).href,
    description: '再现杜牧笔下阿房宫的壮丽景象'
  },
  {
    id: 6,
    title: '赤壁图',
    artist: '吴镇',
    era: '元代',
    dynasty: '元代',
    relatedFu: '《赤壁赋》',
    image: new URL('@/assets/home1/fu/shang/class-PC06-109.jpg', import.meta.url).href,
    description: '苏轼赤壁赋中的山水意境'
  },
  {
    id: 7,
    title: '长门图',
    artist: '沈周',
    era: '明代',
    dynasty: '明代',
    relatedFu: '《长门赋》',
    image: new URL('@/assets/home1/fu/shang/class-PC01-56.jpg', import.meta.url).href,
    description: '陈皇后失宠幽居的凄凉场景'
  }
])

const showVideoModal = ref(false)
const showPaintingModal = ref(false)
const currentVideo = ref({})
const currentPainting = ref({})

let ticking = false
let textObserver = null

function clamp(value, min, max) {
  return Math.min(max, Math.max(min, value))
}

function easeOutCubic(x) {
  return 1 - Math.pow(1 - x, 3)
}

function getSectionProgress(el, startRatio = 0.95, endRatio = 0.1) {
  if (!el) return 0

  const rect = el.getBoundingClientRect()
  const viewH = window.innerHeight || document.documentElement.clientHeight
  const start = viewH * startRatio
  const end = viewH * endRatio
  const total = start - end

  if (total <= 0) return 0

  return clamp((start - rect.top) / total, 0, 1)
}

function updateSceneFloat() {
  const transitionSection = document.getElementById('origin-hanfu-transition')
  const progress = easeOutCubic(getSectionProgress(transitionSection, 0.98, 0.18))

  houseFloatY.value = -70 * progress
  cloud2FloatY.value = -42 * progress
  treeFloatY.value = -30 * progress
}

function updateCarMove() {
  const middleSection = document.getElementById('hanfu-shuqing-middle')
  if (!middleSection) return
  
  const rect = middleSection.getBoundingClientRect()
  const viewH = window.innerHeight || document.documentElement.clientHeight
  
  // 计算滚动进度
  // 当元素顶部到达视口底部时开始移动，顶部到达视口顶部时完成移动
  const startWhenTop = viewH  // 元素顶部到达视口底部
  const endWhenTop = 0        // 元素顶部到达视口顶部
  const total = startWhenTop - endWhenTop
  let progress = (startWhenTop - rect.top) / total
  progress = Math.min(1, Math.max(0, progress))
  
  // 使用缓动
  const easeProgress = 1 - Math.pow(1 - progress, 1.5)
  
  const startLeft = 32
  const endLeft = 86
  carPosition.value = startLeft + (endLeft - startLeft) * easeProgress
}

function handleScroll() {
  if (ticking) return

  ticking = true
  requestAnimationFrame(() => {
    updateSceneFloat()
    updateCarMove()
    ticking = false
  })
}

function setupTextReveal() {
  if (textObserver) {
    textObserver.disconnect()
    textObserver = null
  }

  const blocks = document.querySelectorAll('.reveal-block')

  textObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        const items = entry.target.querySelectorAll('.reveal-item')

        if (entry.isIntersecting) {
          items.forEach((item, index) => {
            setTimeout(() => {
              item.classList.add('is-visible')
            }, index * 180)
          })
        }
      })
    },
    {
      threshold: 0.25
    }
  )

  blocks.forEach((block) => textObserver.observe(block))
}

function scrollToTop() {
  window.scrollTo({ top: 0, behavior: 'smooth' })

  if (mainContent.value) {
    mainContent.value.scrollTo({ top: 0, behavior: 'smooth' })
  }

  document.documentElement.scrollTo({ top: 0, behavior: 'smooth' })
}

function exploreMore() {
  router.push('/library')
}

function playVideo(index) {
  currentVideo.value = videos.value[index]
  showVideoModal.value = true
}

function closeVideoModal() {
  showVideoModal.value = false
  currentVideo.value = {}
}

function viewPainting(index) {
  currentPainting.value = paintings.value[index]
  showPaintingModal.value = true
}

function closePaintingModal() {
  showPaintingModal.value = false
  currentPainting.value = {}
}

onMounted(async () => {
  await nextTick()
  setupTextReveal()
  handleScroll()
  window.addEventListener('scroll', handleScroll, { passive: true })
  window.addEventListener('resize', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
  window.removeEventListener('resize', handleScroll)

  if (textObserver) {
    textObserver.disconnect()
    textObserver = null
  }
})
</script>

<style scoped>
/* 基础样式 */
.fu-page-container {
  width: 100%;
  min-height: 100vh;
  background: #F5F1E8;
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
  color: var(--text);
}

/* 主内容区 */
.fu-main-content {
  padding-top: 10px;
}

/* 通用分屏 */
.scroll-section {
  min-height: 100vh;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 !important;
  overflow: visible;
}

.section-bg {
  position: absolute;
  inset: 0;
  background-size: 100% 100%;
  background-position: center;
  background-repeat: no-repeat;
  z-index: 0;
}

/* =========================
   卷一：赋的起源
========================= */
.origin-section {
  min-height: 145vh;
  padding: 0 !important;
  margin: 0 !important;
  width: 100%;
  overflow: hidden;
  background: #f2efe6;
}

.origin-bg {
  opacity: 0.04;
}

.origin-stage {
  position: relative;
  z-index: 1;
  width: 100%;
  min-height: 145vh;
  overflow: hidden;
}

.origin-text-panel {
  position: absolute;
  top: 6vh;
  left: 7vw;
  width: min(38vw, 620px);
  z-index: 6;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.origin-title-wrap {
  position: relative;
  margin-bottom: 1.8rem;
  opacity: 0;
  transform: translateY(40px);
  animation: originTitleFadeIn 1.2s cubic-bezier(0.22, 1, 0.36, 1) forwards;
  animation-delay: 1.1s;
}

.origin-title {
  margin: 0;
  font-size: clamp(4rem, 6vw, 6.6rem);
  font-weight: 700;
  line-height: 1.04;
  letter-spacing: 0.01em;
  color: #5d6257;
  text-shadow: 0 8px 20px rgba(109, 98, 87, 0.08);
}

.origin-desc {
  font-size: 1.18rem;
  line-height: 2.1;
  color: #6d6257;
  margin-bottom: 2.6rem;
}

.origin-quote {
  display: inline-block;
  font-size: 2.1rem;
  line-height: 1.9;
  color: #111;
  font-style: italic;
  font-family: 'STKaiti', 'KaiTi', 'Noto Serif SC', serif;
  text-shadow:
    0 8px 20px rgba(0, 0, 0, 0.06),
    0 2px 6px rgba(0, 0, 0, 0.05);
  transform: translateY(-6px);
}

.origin-line {
  opacity: 0;
  transform: translateY(26px);
  animation: originLineFadeIn 0.9s ease forwards;
}

.origin-line-1 {
  animation-delay: 1.8s;
}

.origin-line-2 {
  animation-delay: 2.6s;
}

.origin-sun {
  position: absolute;
  left: 70vw;
  bottom: 60vh;
  width: 720px;
  z-index: 5;
  opacity: 0;
  transform: translate(-50%, 120px) scale(0.9);
  animation: originSunRiseRight 3.8s ease-out forwards;
  pointer-events: none;
  filter:
    drop-shadow(0 0 25px rgba(255, 210, 120, 0.4))
    brightness(1.2);
}

.origin-mountain-wrap {
  position: absolute;
  left: 50%;
  bottom: 15vh;
  width: 120vw;
  transform: translateX(-50%);
  z-index: 3;
  overflow: hidden;
  pointer-events: none;
}

.origin-mountain {
  display: block;
  width: 120vw;
  max-width: none;
  height: auto;
}

@keyframes originSunRiseRight {
  0% {
    opacity: 0;
    transform: translate(-50%, 180px) scale(0.9);
  }
  30% {
    opacity: 0.6;
  }
  100% {
    opacity: 1;
    transform: translate(-50%, -40px) scale(1);
  }
}

@keyframes originTitleFadeIn {
  0% {
    opacity: 0;
    transform: translateY(40px);
  }
  100% {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes originLineFadeIn {
  0% {
    opacity: 0;
    transform: translateY(26px);
  }
  100% {
    opacity: 1;
    transform: translateY(0);
  }
}

/* =========================
   卷一 / 卷二 过渡
========================= */
.transition-scene-section {
  position: relative;
  height: 44vh;
  margin-top: -8vh;
  margin-bottom: -4vh;
  background: transparent;
  overflow: visible;
  z-index: 1;
}

.transition-scene-inner {
  position: relative;
  width: 100%;
  height: 100%;
  pointer-events: none;
}

.transition-cloud-left {
  position: absolute;
  left: 50%;
  transform: translateX(-50%) scaleY(0.5);
  bottom: -30vh;
  width: 105vw;
  max-width: none;
  z-index: 2;
}

.transition-house {
  position: absolute;
  left: 14vw;
  bottom: 5vh;
  width: min(56vw, 860px);
  z-index: 4;
  display: block;
  transition: transform 0.08s linear;
  will-change: transform;
}

.transition-cloud-right {
  position: absolute;
  right: 0;
  top: -20vh;
  width: 105vw;
  z-index: 7;
  display: block;
  transition: transform 0.08s linear;
  will-change: transform;
}

.transition-tree {
  position: absolute;
  left: 0;
  bottom: -5vh;
  width: min(40vw, 600px);
  z-index: 6;
  display: block;
  transition: transform 0.08s linear;
  will-change: transform;
}

/* =========================
   卷二：汉赋
========================= */
#section-hanfu {
  position: relative;
  min-height: 90vh;
  padding: 0 !important;
  margin: 0 !important;
  z-index: 10;
  overflow: visible;
}

.hanfu-house2 {
  position: absolute;
  left: 0;
  top: -8vh;
  width: 60vw;
  transform: none;
  z-index: 12;
}

.section-content {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  max-width: 1400px;
  margin: 0 auto;
  align-items: center;
}

.section-content.reverse {
  direction: rtl;
}

.section-content.reverse > * {
  direction: ltr;
}

#section-hanfu .text-content {
  position: absolute;
  right: -40vw;
  top: 10vh;
  width: 32vw;
  z-index: 6;
}

/* =========================
   卷二 / 卷三 过渡
========================= */
.hanfu-shuqing-middle {
  position: relative;
  width: 100%;
  height: 50vh;
  margin: -5vh 0 -8vh 0;
  padding: 0;
  overflow: visible;
  z-index: 50;
  pointer-events: none;
}

.hanfu-shuqing-middle-img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center 30%;
  opacity: 0;
}

.cloud3-wrapper {
  position: absolute;
  left: 0;
  top: -28vh;
  width: 100%;
  height: calc(100% + 30vh);
  overflow: visible;
  pointer-events: none;
  z-index: 15;
  isolation: isolate;
}

.hanfu-shuqing-cloud3 {
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  min-width: auto;
  max-width: none;
  z-index: 30;
  opacity: 0.95;
  pointer-events: none;
  transform-style: preserve-3d;
  object-fit: cover;
  -webkit-mask-image: linear-gradient(
    to bottom,
    rgba(0,0,0,0.2) 0%,
    rgba(0,0,0,0.6) 8%,
    rgba(0,0,0,1) 15%,
    rgba(0,0,0,1) 55%,
    rgba(0,0,0,1) 75%,
    rgba(0,0,0,0.98) 88%,
    rgba(0,0,0,0) 100%
  );
  mask-image: linear-gradient(
    to bottom,
    rgba(0,0,0,0.2) 0%,
    rgba(0,0,0,0.6) 8%,
    rgba(0,0,0,1) 15%,
    rgba(0,0,0,1) 55%,
    rgba(0,0,0,1) 75%,
    rgba(0,0,0,0.98) 88%,
    rgba(0,0,0,0) 100%
  );
}

.hanfu-shuqing-car {
  position: absolute;
  top: 8vh;
  left: 32vw;
  width: min(28vw, 520px);
  min-width: 280px;
  z-index: 101;
  pointer-events: none;
  filter: drop-shadow(0 8px 18px rgba(0, 0, 0, 0.15));
  transition: left 0.08s linear;
  will-change: left;
}

/* =========================
   卷三：抒情小赋
========================= */
#section-shuqing {
  position: relative;
  padding: 0 !important;
  margin: 0 !important;
  width: 100%;
  height: auto;
  aspect-ratio: 1 / 1;
  overflow: hidden;
}

#section-shuqing .section-content {
  position: relative;
  z-index: 1;
  background-size: 120% 100%;
  padding: 0 0 4rem;
  margin-top: -40rem;
}

/* =========================
   通用文字
========================= */
.section-number {
  font-size: 0.9rem;
  font-weight: 600;
  color: #8a7f72;
  letter-spacing: 0.2em;
  margin-bottom: 1rem;
}

.section-title {
  font-size: 3rem;
  font-weight: 700;
  margin: 0 0 2rem 0;
  color: #6d6257;
}

.section-desc {
  font-size: 1.1rem;
  line-height: 1.8;
  color: var(--muted);
  margin-bottom: 2rem;
}

.section-desc p {
  margin-bottom: 1rem;
}

.highlight-box {
  padding: 1.5rem;
  background: var(--bg1);
  border-left: 4px solid;
  border-image: linear-gradient(135deg, #667eea 0%, #764ba2 100%) 1;
  border-radius: 0 12px 12px 0;
}

.poetry-excerpt {
  padding: 0;
  background: none;
  border-radius: 0;
  margin-top: 2rem;
}

.poem-title {
  font-size: 2.1rem;
  line-height: 1.9;
  color: #111;
  font-style: italic;
  font-family: 'STKaiti', 'KaiTi', 'Noto Serif SC', serif;
  text-shadow:
    0 8px 20px rgba(0, 0, 0, 0.06),
    0 2px 6px rgba(0, 0, 0, 0.05);
  margin-bottom: 1rem;
  font-weight: normal;
}

.poem-content {
  font-size: 1.8rem;
  line-height: 1.4;
  color: #111;
  font-style: italic;
  font-family: 'STKaiti', 'KaiTi', 'Noto Serif SC', serif;
  text-shadow:
    0 8px 20px rgba(0, 0, 0, 0.06),
    0 2px 6px rgba(0, 0, 0, 0.05);
}

.poem-line {
  display: block;
  margin-bottom: 0.18em;
}

.poem-line:last-child {
  margin-bottom: 0;
}

.visual-content {
  display: flex;
  justify-content: center;
  align-items: center;
}

/* =========================
   滚动浮现
========================= */
.reveal-item {
  opacity: 0;
  transform: translateY(28px);
  filter: blur(6px);
  transition:
    opacity 0.7s ease,
    transform 0.7s ease,
    filter 0.7s ease;
}

.reveal-item.is-visible {
  opacity: 1;
  transform: translateY(0);
  filter: blur(0);
}

/* =========================
   视频区
========================= */
.video-section {
  padding: 2rem 2rem 4rem; /* 减少上padding，消除上方空白 */
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  position: relative;
}

/* 为视频section添加半透明遮罩层 */
.video-section::before {
  content: '';
  position: absolute;
  top: 0; /* 从顶部开始，消除上方空白 */
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(248, 245, 230, 0.85); /* 半透明宣纸白色遮罩 */
  pointer-events: none;
  z-index: 1;
}

/* 确保视频section的内容在遮罩层之上 */
.video-section > * {
  position: relative;
  z-index: 2;
}

.section-header {
  text-align: center;
  margin-bottom: 2rem;
  padding: 2rem 0;
}

.calligraphy-title {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1rem;
}

.calligraphy-char {
  font-family: 'Noto Serif SC', 'STSong', 'SimSun', serif;
  font-size: 4rem;
  font-weight: 700;
  color: #333;
  letter-spacing: 0.5rem;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
}

.video-gallery {
  display: flex;
  justify-content: center;
  align-items: center;
  max-width: 1000px;
  margin: 0 auto;
  padding: 1rem;
}

.video-card {
  background: rgba(248, 245, 230, 0.95); /* 宣纸白 */
  border-radius: 12px; /* 减小圆角 */
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(44, 44, 44, 0.1); /* 淡化阴影 */
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid rgba(90, 74, 63, 0.3); /* 淡化边框 */
  width: 100%;
}

.video-card:hover {
  transform: translateY(-8px) scale(1.01);
  box-shadow: 0 8px 24px rgba(44, 44, 44, 0.25); /* 加深墨色阴影 */
  border-color: #C83C3C; /* 朱砂色边框高亮 */
}

.video-thumbnail {
  position: relative;
  aspect-ratio: 16 / 9;
  overflow: hidden;
  background: linear-gradient(135deg, #8B7355 0%, #D4AF37 100%);
}

.video-thumbnail-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #8B7355 0%, #8B4513 100%);
}

.video-placeholder-icon {
  font-size: 4rem;
  color: white;
}

.video-thumbnail img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s ease;
}

.video-card:hover .video-thumbnail img {
  transform: scale(1.15);
}

.play-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom, rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.6));
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.video-card:hover .play-overlay {
  opacity: 1;
}

.play-btn {
  width: 100px;
  height: 100px;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 12px 35px rgba(0, 0, 0, 0.3);
  transition: all 0.3s ease;
}

.play-icon {
  font-size: 2.5rem;
  color: #8B7355;
  margin-left: 6px;
}

.video-card:hover .play-btn {
  transform: scale(1.15);
  background: white;
}

.video-duration {
  position: absolute;
  bottom: 1.2rem;
  right: 1.2rem;
  background: rgba(0, 0, 0, 0.8);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-size: 0.9rem;
  font-weight: 600;
  backdrop-filter: blur(10px);
}

/* =========================
   图片区
========================= */
.gallery-section {
  padding: 2rem 2rem 4rem; /* 保持一致的padding */
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  position: relative;
}

/* 为赏赋section添加半透明遮罩层 */
.gallery-section::before {
  content: '';
  position: absolute;
  top: 0; /* 从顶部开始，消除上方空白 */
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(248, 245, 230, 0.85); /* 半透明宣纸白色遮罩 */
  pointer-events: none;
  z-index: 1;
}

/* 确保赏赋section的内容在遮罩层之上 */
.gallery-section > * {
  position: relative;
  z-index: 2;
}

.gallery-container {
  max-width: 1200px;
  margin: 0 auto;
}

.ancient-book-layout {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-auto-rows: minmax(150px, auto);
  gap: 8px;
  padding: 8px;
  background: #EDE5D8;
  border: 2px solid #D4C4B0;
}

.calligraphy-area {
  position: relative;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); /* 与赏诗部分保持一致的过渡效果 */
  border: 1px solid #D4C4B0;
  background: #F5F1E8;
  border-radius: 12px; /* 添加圆角效果 */
}

.calligraphy-area:hover {
  transform: scale(1.08) translateY(-8px); /* 增大放大比例，向上浮起 */
  box-shadow: 0 12px 24px rgba(139, 115, 85, 0.4); /* 增强阴影效果 */
  z-index: 10;
}

.calligraphy-area.large {
  grid-column: span 2;
  grid-row: span 2;
}

.calligraphy-area.medium-wide {
  grid-column: span 2;
  grid-row: span 1;
}

.calligraphy-area.medium-tall {
  grid-column: span 1;
  grid-row: span 2;
}

.calligraphy-area.small {
  grid-column: span 1;
  grid-row: span 1;
}

.calligraphy-content {
  width: 100%;
  height: 100%;
  min-height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.calligraphy-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #F5F1E8 0%, #EDE5D8 100%);
  background-size: cover;
  background-position: center;
  position: relative;
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); /* 添加过渡效果 */
  border-radius: 12px; /* 添加圆角效果，与外层容器保持一致 */
}

.calligraphy-area:hover .calligraphy-placeholder {
  transform: scale(1.05); /* 背景图片内部也放大，增强层次感 */
}

.calligraphy-placeholder::before {
  content: '';
  position: absolute;
  top: 40px;
  left: 0;
  right: 0;
  bottom: 0;
  background-image:
    repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(139, 115, 85, 0.03) 2px),
    repeating-linear-gradient(90deg, transparent, transparent 2px, rgba(139, 115, 85, 0.03) 2px);
  pointer-events: none;
}

/* =========================
   页脚
========================= */
.fu-footer {
  padding: 3rem 2rem;
  background: var(--text);
  color: white;
  text-align: center;
}

.footer-content {
  max-width: 1400px;
  margin: 0 auto;
}

.footer-text {
  margin-bottom: 2rem;
}

.footer-text p {
  font-size: 1.2rem;
  margin: 0.5rem 0;
  opacity: 0.8;
}

.footer-actions {
  display: flex;
  justify-content: center;
  gap: 1rem;
}

.footer-btn {
  padding: 0.75rem 1.5rem;
  background: rgba(255, 255, 255, 0.1);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.footer-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

/* =========================
   弹窗
========================= */
.video-modal,
.painting-modal {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.modal-content {
  background: white;
  border-radius: 16px;
  max-width: 900px;
  width: 90%;
  max-height: 90vh;
  overflow: auto;
  position: relative;
}

.close-btn {
  position: absolute;
  top: 1rem;
  right: 1rem;
  width: 40px;
  height: 40px;
  background: rgba(0, 0, 0, 0.1);
  border: none;
  border-radius: 50%;
  cursor: pointer;
  font-size: 1.2rem;
  z-index: 10;
}

.video-player {
  width: 100%;
  aspect-ratio: 16 / 9;
  background: black;
}

.video-player video {
  width: 100%;
  height: 100%;
}

.video-detail,
.painting-detail {
  padding: 2rem;
}

.video-detail h3,
.painting-detail h3 {
  font-size: 1.5rem;
  margin: 0 0 1rem 0;
}

.video-detail p,
.painting-detail p {
  color: var(--muted);
  line-height: 1.6;
}

.painting-viewer img {
  width: 100%;
  height: auto;
  display: block;
}

.painting-modal-placeholder {
  width: 100%;
  padding: 4rem;
  text-align: center;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  border-radius: 8px;
}

.modal-placeholder-icon {
  font-size: 6rem;
  display: block;
  margin-bottom: 1rem;
}

.painting-modal-placeholder p {
  font-size: 1.5rem;
  color: #333;
  font-weight: 600;
  margin: 0;
}

/* =========================
   响应式
========================= */
@media (max-width: 1024px) {
  .origin-text-panel {
    right: 4vw;
    top: 8vh;
    width: min(46vw, 560px);
  }

  .origin-title-wrap {
    left: 6vw;
    bottom: 18vh;
  }

  .origin-sun {
    left: 34%;
    bottom: 15vh;
  }

  .origin-desc {
    font-size: 1.04rem;
  }

  #section-hanfu .text-content {
    right: -16vw;
    width: 42vw;
  }

  .hanfu-shuqing-car {
    width: 34vw;
    min-width: 220px;
  }
}

@media (max-width: 768px) {
  .scroll-section {
    padding: 2rem 1rem;
  }

  .section-content {
    grid-template-columns: 1fr;
    gap: 2rem;
  }

  .section-content.reverse {
    direction: ltr;
  }

  .section-title {
    font-size: 2rem;
  }

  .calligraphy-char {
    font-size: 2.5rem;
  }

  .origin-stage {
    min-height: calc(100vh - 56px);
  }

  .origin-text-panel {
    position: absolute;
    top: 7vh;
    left: 1rem;
    right: 1rem;
    width: auto;
  }

  .origin-desc {
    font-size: 0.98rem;
    line-height: 1.9;
    margin-bottom: 1.2rem;
  }

  .origin-title-wrap {
    left: 1rem;
    bottom: 14vh;
  }

  .origin-title {
    font-size: clamp(2.6rem, 12vw, 4.4rem);
  }

  .origin-sun {
    left: 34%;
    width: clamp(58px, 13vw, 88px);
    bottom: 11vh;
  }

  .origin-mountain {
    width: 135%;
    max-width: none;
    margin-left: -17.5%;
  }

  #section-hanfu .text-content {
    position: relative;
    right: auto;
    top: auto;
    width: auto;
    padding: 0 1rem;
  }

  #section-shuqing .section-content {
    margin-top: -10rem;
    padding: 0 1rem 3rem;
  }

  .transition-house {
    left: 8vw;
    width: 74vw;
  }

  .transition-cloud-right {
    top: -8vh;
    width: 118vw;
  }

  .transition-tree {
    width: 48vw;
  }

  .hanfu-shuqing-car {
    top: 12vh;
    width: 48vw;
    min-width: 180px;
  }

  .ancient-book-layout {
    grid-template-columns: repeat(2, 1fr);
    gap: 6px;
    padding: 6px;
  }

  .calligraphy-area.large {
    grid-column: span 2;
    grid-row: span 2;
  }

  .calligraphy-area.medium-wide {
    grid-column: span 2;
    grid-row: span 1;
  }

  .calligraphy-area.medium-tall {
    grid-column: span 1;
    grid-row: span 2;
  }
}

@media (min-width: 769px) and (max-width: 1024px) {
  .calligraphy-char {
    font-size: 3rem;
  }

  .ancient-book-layout {
    grid-template-columns: repeat(3, 1fr);
    gap: 7px;
    padding: 7px;
  }

  .calligraphy-area.large {
    grid-column: span 2;
    grid-row: span 2;
  }

  .calligraphy-area.medium-wide {
    grid-column: span 2;
    grid-row: span 1;
  }

  .calligraphy-area.medium-tall {
    grid-column: span 1;
    grid-row: span 2;
  }
}

@media (min-width: 1025px) {
  .calligraphy-char {
    font-size: 4rem;
  }

  .ancient-book-layout {
    grid-template-columns: repeat(4, 1fr);
    gap: 8px;
    padding: 8px;
  }

  .calligraphy-area.large {
    grid-column: span 2;
    grid-row: span 2;
  }

  .calligraphy-area.medium-wide {
    grid-column: span 2;
    grid-row: span 1;
  }

  .calligraphy-area.medium-tall {
    grid-column: span 1;
    grid-row: span 2;
  }
}
</style>
