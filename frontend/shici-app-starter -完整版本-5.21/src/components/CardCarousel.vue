<template>
  <div class="carousel-container">
    <!-- 背景图容器 - 全部空 src，由 JS 填充 -->
    <div class="carousel-background">
      <div class="bg-image current--image">
        <img src="" alt="" />
      </div>
      <div class="bg-image next--image">
        <img src="" alt="" />
      </div>
      <div class="bg-image previous--image">
        <img src="" alt="" />
      </div>
    </div>

    <div class="app">
      <div class="cardList">
        <button
          class="cardList__btn btn btn--left"
          @click="swapCards('left')"
          :disabled="isAnimating"
        >
          <div class="icon">
            <svg><use xlink:href="#arrow-left"></use></svg>
          </div>
        </button>

        <div class="cards__wrapper" ref="cardsWrapper">
          <div class="card current--card" @click="handleCardClick('current')">
            <div class="card__image">
              <img src="" alt="" />
            </div>
            <div class="card__decoration">
              <img src="" alt="" />
            </div>
          </div>

          <div class="card next--card" @click="handleCardClick('next')">
            <div class="card__image">
              <img src="" alt="" />
            </div>
            <div class="card__decoration">
              <img src="" alt="" />
            </div>
          </div>

          <div class="card previous--card" @click="handleCardClick('previous')">
            <div class="card__image">
              <img src="" alt="" />
            </div>
            <div class="card__decoration">
              <img src="" alt="" />
            </div>
          </div>
        </div>

        <button
          class="cardList__btn btn btn--right"
          @click="swapCards('right')"
          :disabled="isAnimating"
        >
          <div class="icon">
            <svg><use xlink:href="#arrow-right"></use></svg>
          </div>
        </button>
      </div>

      <div class="infoList">
        <div class="info__wrapper" ref="infoWrapper">
          <div class="info current--info">
            <div class="text heroBadge">中文母语者的精神社交网络</div>
            <h1 class="text name"></h1>
            <h4 class="text location"></h4>
            <p class="text description"></p>
            <div class="heroQuote">
              <p>举头望明月，低头思故乡</p>
              <span>李白《静夜思》</span>
            </div>
            <div class="heroActions">
              <button class="heroBtn" type="button" @click.stop="goExperience">立即体验</button>
              <button class="heroBtn ghost" type="button" @click.stop="goLibrary">进入藏书阁</button>
            </div>
            <div class="heroMeta">
              <span>收录诗词 {{ formatCount(poemCount) }}+</span>
              <span>词典条目 {{ formatCount(dictCount) }}+</span>
              <span>典故索引 {{ formatCount(storyCount) }}+</span>
            </div>
          </div>

          <div class="info next--info">
            <div class="text heroBadge">中文母语者的精神社交网络</div>
            <h1 class="text name"></h1>
            <h4 class="text location"></h4>
            <p class="text description"></p>
            <div class="heroQuote">
              <p>举头望明月，低头思故乡</p>
              <span>李白《静夜思》</span>
            </div>
            <div class="heroActions">
              <button class="heroBtn" type="button" @click.stop="goExperience">立即体验</button>
              <button class="heroBtn ghost" type="button" @click.stop="goLibrary">进入藏书阁</button>
            </div>
            <div class="heroMeta">
              <span>收录诗词 {{ formatCount(poemCount) }}+</span>
              <span>词典条目 {{ formatCount(dictCount) }}+</span>
              <span>典故索引 {{ formatCount(storyCount) }}+</span>
            </div>
          </div>

          <div class="info previous--info">
            <div class="text heroBadge">中文母语者的精神社交网络</div>
            <h1 class="text name"></h1>
            <h4 class="text location"></h4>
            <p class="text description"></p>
            <div class="heroQuote">
              <p>举头望明月，低头思故乡</p>
              <span>李白《静夜思》</span>
            </div>
            <div class="heroActions">
              <button class="heroBtn" type="button" @click.stop="goExperience">立即体验</button>
              <button class="heroBtn ghost" type="button" @click.stop="goLibrary">进入藏书阁</button>
            </div>
            <div class="heroMeta">
              <span>收录诗词 {{ formatCount(poemCount) }}+</span>
              <span>词典条目 {{ formatCount(dictCount) }}+</span>
              <span>典故索引 {{ formatCount(storyCount) }}+</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <aside class="dailySeal" :class="{ paused: sealPaused, switching: sealSwitching }" aria-label="今日诗签" @mouseenter="sealPaused = true" @mouseleave="sealPaused = false" @click="nextSeal">
      <div class="sealHead">今日诗签</div>
      <div class="sealBody">{{ todaySeal.text }}</div>
      <div class="sealFoot">{{ todaySeal.author }}</div>
    </aside>

    <!-- 底部渐变过渡层 -->
    <!-- <div class="carousel-gradient-overlay" aria-hidden="true"></div> -->

    <!-- 过渡装饰层 -->
    <!-- <div class="carousel-transition-layer" aria-hidden="true">
      <div class="transition-cloud cloud-1"></div>
      <div class="transition-cloud cloud-2"></div>
      <div class="transition-cloud cloud-3"></div>
    </div> -->

    <svg class="icons" style="display: none;">
      <symbol id="arrow-left" xmlns='http://www.w3.org/2000/svg' viewBox='0 0 512 512'>
        <polyline points='328 112 184 256 328 400'
               style='fill:none;stroke:#fff;stroke-linecap:round;stroke-linejoin:round;stroke-width:48px' />
      </symbol>
      <symbol id="arrow-right" xmlns='http://www.w3.org/2000/svg' viewBox='0 0 512 512'>
        <polyline points='184 112 328 256 184 400'
               style='fill:none;stroke:#fff;stroke-linecap:round;stroke-linejoin:round;stroke-width:48px' />
      </symbol>
    </svg>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { gsap } from 'gsap'
import { useRouter } from 'vue-router'

const router = useRouter()
const poemCount = ref(0)
const dictCount = ref(0)
const storyCount = ref(0)
const counterPlayed = ref(false)
const sealIndex = ref(0)
const sealPaused = ref(false)
const sealSwitching = ref(false)

const sealPool = [
  { text: '春风得意马蹄疾，一日看尽长安花。', author: '孟郊《登科后》' },
  { text: '海上生明月，天涯共此时。', author: '张九龄《望月怀远》' },
  { text: '云想衣裳花想容，春风拂槛露华浓。', author: '李白《清平调》' },
  { text: '落霞与孤鹜齐飞，秋水共长天一色。', author: '王勃《滕王阁序》' },
  { text: '长风破浪会有时，直挂云帆济沧海。', author: '李白《行路难》' }
]

const todaySeal = computed(() => {
  const day = new Date().getDate()
  const base = day % sealPool.length
  return sealPool[(base + sealIndex.value) % sealPool.length]
})

const nextSeal = () => {
  if (sealSwitching.value) return
  sealSwitching.value = true
  setTimeout(() => {
    sealIndex.value = (sealIndex.value + 1) % sealPool.length
    sealSwitching.value = false
  }, 180)
}

// ============ 数据存储（普通变量，非响应式） ============
// 这样 Vue 不会追踪它们的变化，不会自动重新渲染模板
let cardsData = []
let decorationData = []

// 索引（普通变量）
let idxCurrent = 0
let idxNext = 1
let idxPrev = 0  // 在 init 中根据长度计算

// 动画锁
const isAnimating = ref(false)

// 自动轮播相关
let autoPlayTimer = null
const isPaused = ref(false) // 改为ref以确保响应式
const AUTO_PLAY_INTERVAL = 4000 // 4秒自动切换，给用户更多观看时间

// ============ Props 接收 ============
const props = defineProps({
  cards: {
    type: Array,
    required: true,
    default: () => [],
    validator: (value) => value.length >= 3
  }
})

// ============ DOM 缓存 ============
let domRefs = null

const getDomRefs = () => {
  if (domRefs) return domRefs

  const cardsWrapper = document.querySelector('.cards__wrapper')
  const bgContainer = document.querySelector('.carousel-background')
  const infoWrapper = document.querySelector('.info__wrapper')

  domRefs = {
    // 卡片
    cards: {
      current: cardsWrapper.querySelector('.current--card'),
      next: cardsWrapper.querySelector('.next--card'),
      prev: cardsWrapper.querySelector('.previous--card'),
    },
    // 卡片图片
    cardImgs: {
      current: cardsWrapper.querySelector('.current--card .card__image img'),
      next: cardsWrapper.querySelector('.next--card .card__image img'),
      prev: cardsWrapper.querySelector('.previous--card .card__image img'),
    },
    // 装饰图片
    decoImgs: {
      current: cardsWrapper.querySelector('.current--card .card__decoration img'),
      next: cardsWrapper.querySelector('.next--card .card__decoration img'),
      prev: cardsWrapper.querySelector('.previous--card .card__decoration img'),
    },
    // 装饰容器
    decoContainers: {
      current: cardsWrapper.querySelector('.current--card .card__decoration'),
      next: cardsWrapper.querySelector('.next--card .card__decoration'),
      prev: cardsWrapper.querySelector('.previous--card .card__decoration'),
    },
    // 背景
    bgs: {
      current: bgContainer.querySelector('.current--image'),
      next: bgContainer.querySelector('.next--image'),
      prev: bgContainer.querySelector('.previous--image'),
    },
    bgImgs: {
      current: bgContainer.querySelector('.current--image img'),
      next: bgContainer.querySelector('.next--image img'),
      prev: bgContainer.querySelector('.previous--image img'),
    },
    // 文字
    infos: {
      current: infoWrapper.querySelector('.current--info'),
      next: infoWrapper.querySelector('.next--info'),
      prev: infoWrapper.querySelector('.previous--info'),
    },
    texts: {
      current: {
        name: infoWrapper.querySelector('.current--info .name'),
        location: infoWrapper.querySelector('.current--info .location'),
        desc: infoWrapper.querySelector('.current--info .description'),
      },
      next: {
        name: infoWrapper.querySelector('.next--info .name'),
        location: infoWrapper.querySelector('.next--info .location'),
        desc: infoWrapper.querySelector('.next--info .description'),
      },
      prev: {
        name: infoWrapper.querySelector('.previous--info .name'),
        location: infoWrapper.querySelector('.previous--info .location'),
        desc: infoWrapper.querySelector('.previous--info .description'),
      },
    },
    // 按钮
    btns: {
      prev: document.querySelector('.btn--left'),
      next: document.querySelector('.btn--right'),
    }
  }
  return domRefs
}

// ============ 核心：更新所有 DOM 内容（完全手动控制） ============
const updateContent = () => {
  const d = getDomRefs()
  const curr = cardsData[idxCurrent]
  const next = cardsData[idxNext]
  const prev = cardsData[idxPrev]

  // 卡片图片
  d.cardImgs.current.src = curr.image
  d.cardImgs.next.src = next.image
  d.cardImgs.prev.src = prev.image

  // 装饰图片
  d.decoImgs.current.src = decorationData[idxCurrent] || ''
  d.decoImgs.next.src = decorationData[idxNext] || ''
  d.decoImgs.prev.src = decorationData[idxPrev] || ''

  // 为装饰容器添加主题类名
  const themeClassMap = {
    '诗': 'theme-shi',
    '歌': 'theme-ge',
    '赋': 'theme-fu',
    '词': 'theme-ci',
    '曲': 'theme-qu'
  }

  // 清除旧的主题类名
  Object.values(themeClassMap).forEach(themeClass => {
    d.decoContainers.current.classList.remove(themeClass)
    d.decoContainers.next.classList.remove(themeClass)
    d.decoContainers.prev.classList.remove(themeClass)
  })

  // 添加新的主题类名
  if (themeClassMap[curr.name]) {
    d.decoContainers.current.classList.add(themeClassMap[curr.name])
  }
  if (themeClassMap[next.name]) {
    d.decoContainers.next.classList.add(themeClassMap[next.name])
  }
  if (themeClassMap[prev.name]) {
    d.decoContainers.prev.classList.add(themeClassMap[prev.name])
  }

  // 背景图片
  d.bgImgs.current.src = curr.image
  d.bgImgs.next.src = next.image
  d.bgImgs.prev.src = prev.image

  // 文字内容
  d.texts.current.name.textContent = curr.name
  d.texts.current.location.textContent = curr.location
  d.texts.current.desc.textContent = curr.description

  d.texts.next.name.textContent = next.name
  d.texts.next.location.textContent = next.location
  d.texts.next.desc.textContent = next.description

  d.texts.prev.name.textContent = prev.name
  d.texts.prev.location.textContent = prev.location
  d.texts.prev.desc.textContent = prev.description
}

// ============ 切换卡片 ============
const swapCards = async (direction) => {
  if (isAnimating.value) return
  isAnimating.value = true

  const d = getDomRefs()

  // ---- 阶段 1：计算新索引 ----
  let newCurrent, newNext, newPrev

  if (direction === 'right') {
    newPrev = idxCurrent
    newCurrent = idxNext
    newNext = (idxNext + 1) % cardsData.length
  } else {
    newNext = idxCurrent
    newCurrent = idxPrev
    newPrev = (idxPrev - 1 + cardsData.length) % cardsData.length
  }

  // ---- 阶段 2：按钮禁用 ----
  gsap.to([d.btns.prev, d.btns.next], {
    duration: 0.2,
    opacity: 0.5,
    pointerEvents: 'none',
  })

  // ---- 阶段 3：文字淡出（旧内容）----
  await gsap.to(d.infos.current.querySelectorAll('.text'), {
    duration: 0.4,
    stagger: 0.1,
    translateY: '-120px',
    opacity: 0,
  })

  // ---- 阶段 4：先切换 CSS 类名（DOM元素位置关系）----
  // 移除旧类名
  d.cards.current.classList.remove('current--card')
  d.cards.prev.classList.remove('previous--card')
  d.cards.next.classList.remove('next--card')

  d.bgs.current.classList.remove('current--image')
  d.bgs.prev.classList.remove('previous--image')
  d.bgs.next.classList.remove('next--image')

  d.infos.current.classList.remove('current--info')
  d.infos.prev.classList.remove('previous--info')
  d.infos.next.classList.remove('next--info')

  // 设置 z-index
  d.cards.current.style.zIndex = '50'
  d.bgs.current.style.zIndex = '-2'

  // 添加新类名
  if (direction === 'right') {
    d.cards.prev.style.zIndex = '20'
    d.cards.next.style.zIndex = '30'
    d.bgs.next.style.zIndex = '-1'

    d.cards.current.classList.add('previous--card')
    d.cards.prev.classList.add('next--card')
    d.cards.next.classList.add('current--card')

    d.bgs.current.classList.add('previous--image')
    d.bgs.prev.classList.add('next--image')
    d.bgs.next.classList.add('current--image')

    d.infos.current.classList.add('previous--info')
    d.infos.prev.classList.add('next--info')
    d.infos.next.classList.add('current--info')
  } else {
    d.cards.prev.style.zIndex = '30'
    d.cards.next.style.zIndex = '20'
    d.bgs.prev.style.zIndex = '-1'

    d.cards.current.classList.add('next--card')
    d.cards.prev.classList.add('current--card')
    d.cards.next.classList.add('previous--card')

    d.bgs.current.classList.add('next--image')
    d.bgs.prev.classList.add('current--image')
    d.bgs.next.classList.add('previous--image')

    d.infos.current.classList.add('next--info')
    d.infos.next.classList.add('previous--info')
    d.infos.prev.classList.add('current--info')
  }

  // ---- 阶段 5：更新索引 ----
  idxCurrent = newCurrent
  idxNext = newNext
  idxPrev = newPrev

  // ---- 阶段 6：更新 DOM 内容（索引已更新，类名已切换）----
  updateContent()

  // ---- 阶段 7：清空 DOM 缓存，重新获取（因为类名变了）----
  domRefs = null
  const newD = getDomRefs()

  // ---- 阶段 8：文字淡入（新内容，从下方滑入）----
  await gsap.fromTo(
    newD.infos.current.querySelectorAll('.text'),
    { opacity: 0, translateY: '40px' },
    { duration: 0.4, stagger: 0.1, translateY: '0px', opacity: 1 }
  )

  // ---- 阶段 9：按钮恢复 ----
  gsap.to([newD.btns.prev, newD.btns.next], {
    duration: 0.2,
    opacity: 1,
    pointerEvents: 'all',
  })

  // ---- 阶段 10：重新绑定鼠标事件 ----
  bindCardEvents()

  // ---- 阶段 11：解锁 ----
  setTimeout(() => {
    isAnimating.value = false
  }, 100)
}

// ============ 卡片点击跳转 ============
const handleCardClick = (position) => {
  if (isAnimating.value) return

  // 根据点击的卡片位置确定对应的卡片索引
  let cardIndex
  if (position === 'current') {
    cardIndex = idxCurrent
  } else if (position === 'next') {
    cardIndex = idxNext
  } else if (position === 'previous') {
    cardIndex = idxPrev
  }

  // 根据卡片索引获取对应的名称，确定跳转路径
  const card = cardsData[cardIndex]
  if (!card) return

  // 定义名称到路由的映射
  const routeMap = {
    '诗': '/home/page4/shi',
    '歌': '/home/page4/ge',
    '赋': '/home/page4/fu',
    '词': '/home/page4/ci',
    '曲': '/home/page4/qu'
  }

  const targetRoute = routeMap[card.name]
  if (targetRoute) {
    router.push(targetRoute)
  }
}

const goExperience = () => {
  router.push('/learn')
}

const goLibrary = () => {
  router.push('/library')
}

const formatCount = (num) => {
  return Number(num || 0).toLocaleString('en-US')
}

const playCounters = () => {
  if (counterPlayed.value) return
  counterPlayed.value = true

  const counterTargets = [
    { key: 'poem', to: 12800 },
    { key: 'dict', to: 9600 },
    { key: 'story', to: 3200 }
  ]

  counterTargets.forEach((item, index) => {
    const tweenObj = { value: 0 }
    gsap.to(tweenObj, {
      value: item.to,
      duration: 1.6,
      delay: 0.3 + index * 0.12,
      ease: 'power2.out',
      onUpdate: () => {
        const v = Math.round(tweenObj.value)
        if (item.key === 'poem') poemCount.value = v
        if (item.key === 'dict') dictCount.value = v
        if (item.key === 'story') storyCount.value = v
      }
    })
  })
}

// ============ 自动轮播功能 ============
const startAutoPlay = () => {
  stopAutoPlay() // 清除可能存在的旧定时器
  autoPlayTimer = setInterval(() => {
    if (!isPaused.value && !isAnimating.value) {
      swapCards('right') // 自动向右切换
    }
  }, AUTO_PLAY_INTERVAL)
}

const stopAutoPlay = () => {
  if (autoPlayTimer) {
    clearInterval(autoPlayTimer)
    autoPlayTimer = null
  }
}

const bindPauseEvents = () => {
  const cardList = document.querySelector('.cardList')
  if (!cardList) return

  // 鼠标进入卡片区域时暂停
  cardList.addEventListener('mouseenter', () => {
    isPaused.value = true
  })

  // 鼠标离开卡片区域时恢复
  cardList.addEventListener('mouseleave', () => {
    isPaused.value = false
  })
}

// ============ 鼠标跟随效果 ============
const onPointerMove = (e) => {
  const card = e.currentTarget
  const box = card.getBoundingClientRect()
  const centerX = box.left + box.width / 2
  const angle = Math.atan2(e.pageX - centerX, 0) * (35 / Math.PI)

  gsap.set(card, {
    '--current-card-rotation-offset': `${angle}deg`,
  })

  const currentInfo = document.querySelector('.current--info')
  if (currentInfo) {
    gsap.set(currentInfo, { rotateY: `${angle}deg` })
  }
}

const onPointerOut = (e) => {
  const card = e.currentTarget
  gsap.set(card, { '--current-card-rotation-offset': 0 })

  const currentInfo = document.querySelector('.current--info')
  if (currentInfo) {
    gsap.set(currentInfo, { rotateY: 0 })
  }
}

const bindCardEvents = () => {
  // 移除所有卡片的事件
  document.querySelectorAll('.card').forEach(card => {
    card.removeEventListener('pointermove', onPointerMove)
    card.removeEventListener('pointerout', onPointerOut)
  })

  // 只给当前卡片绑定
  const currentCard = document.querySelector('.current--card')
  if (currentCard) {
    currentCard.addEventListener('pointermove', onPointerMove)
    currentCard.addEventListener('pointerout', onPointerOut)
  }
}

// ============ 初始化 ============
onMounted(() => {
  // 复制数据到普通变量（切断 Vue 响应式追踪）
  cardsData = props.cards
  decorationData = [
    'src/assets/images/navigation/shi-libai.png',
    'src/assets/images/navigation/ge-quyuan.png',
    'src/assets/images/navigation/fu-caozhi.png',
    'src/assets/images/navigation/ci-liqingzhao.png',
    'src/assets/images/navigation/qu-mudanting.png'
  ]

  // 初始化索引
  idxCurrent = 0
  idxNext = 1
  idxPrev = cardsData.length - 1

  // 填充初始内容
  updateContent()

  // 绑定事件
  bindCardEvents()

  // 入场动画
  playEntranceAnimation()

  // 绑定鼠标悬停暂停事件
  bindPauseEvents()

  // 延迟启动自动轮播，确保DOM完全加载
  setTimeout(() => {
    startAutoPlay()
  }, 1000) // 延迟1秒启动

  // 首屏数字滚动动效（仅首次）
  playCounters()
})

// 组件销毁时清理定时器
onUnmounted(() => {
  stopAutoPlay()
})

const playEntranceAnimation = () => {
  const cardsContainer = document.querySelector('.cards__wrapper')
  const infoWrapper = document.querySelector('.info__wrapper')
  const btns = {
    prev: document.querySelector('.btn--left'),
    next: document.querySelector('.btn--right'),
  }

  if (!cardsContainer || !infoWrapper) return

  const tl = gsap.timeline()

  tl.to(cardsContainer.children, {
    delay: 0.15,
    duration: 0.5,
    stagger: {
      ease: 'power4.inOut',
      from: 'right',
      amount: 0.1,
    },
    '--card-translateY-offset': '0%',
  })
  .to(infoWrapper.querySelector('.current--info').querySelectorAll('.text'), {
    delay: 0.5,
    duration: 0.4,
    stagger: 0.1,
    opacity: 1,
    translateY: 0,
  })
  .to([btns.prev, btns.next], {
    duration: 0.4,
    opacity: 1,
    pointerEvents: 'all',
  }, '-=0.4')
}
</script>

<style>
@import url("https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@500;600;700&family=Noto+Serif+SC:wght@400;500;600;700;900&display=swap");

.carousel-container {
  width: 100%;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: transparent;
  overflow: hidden;
  position: relative;
}

:root {
   --card-width: 200px;
   --card-height: 300px;
   --card-transition-duration: 800ms;
   --card-transition-easing: ease;
}

* {
   box-sizing: border-box;
   margin: 0;
   padding: 0;
 }

 button {
   border: none;
   background: none;
   cursor: pointer;
 }

 button:focus {
   outline: none;
   border: none;
 }

 button:disabled {
   opacity: 0.3 !important;
   cursor: not-allowed;
   pointer-events: none;
 }

 .app {
   position: relative;
   width: 100%;
   height: 100vh;
   display: flex;
   justify-content: center;
   align-items: center;
   z-index: 10;
 }

 .carousel-background {
   position: absolute;
   top: 0;
   left: 0;
   width: 100%;
   height: 100%;
   overflow: hidden;
   z-index: 1;
   background: #000;
 }

 .carousel-background::before {
   content: '';
   position: absolute;
   top: 0;
   left: 0;
   right: 0;
   bottom: 0;
   background: rgba(0, 0, 0, 0.2);
   z-index: 2;
 }

 .bg-image {
   position: absolute;
   left: 50%;
   top: 50%;
   transform: translate(-50%, -50%) translateX(var(--image-translate-offset, 0));
   width: 100%;
   height: 100%;
   transition: transform 600ms ease, opacity 600ms ease;
   overflow: hidden;
   z-index: 1;
 }

 .bg-image img {
   width: 100%;
   height: 100%;
   object-fit: cover;
   display: block;
 }

 .bg-image.current--image {
   opacity: 1;
   --image-translate-offset: 0;
 }

 .bg-image.previous--image, .bg-image.next--image {
   opacity: 0;
 }

 .bg-image.previous--image {
   --image-translate-offset: -25%;
 }

 .bg-image.next--image {
   --image-translate-offset: 25%;
 }

 .cardList {
   position: absolute;
   width: calc(3 * var(--card-width));
   height: auto;
   z-index: 10;
 }

 .cardList__btn {
   --btn-size: 50px;
   width: var(--btn-size);
   height: var(--btn-size);
   position: absolute;
   top: 50%;
   transform: translateY(-50%);
   z-index: 50;
   background: none;
   border: none;
   cursor: pointer;
   transition: all 0.3s ease;
   padding: 0;
 }

 .cardList__btn.btn--left {
   left: 10%;
 }

 .cardList__btn.btn--right {
   right: 10%;
 }

 .cardList__btn:hover:not(:disabled) {
   transform: translateY(-50%) scale(1.15);
 }

 .cardList__btn:active:not(:disabled) {
   transform: translateY(-50%) scale(1.05);
 }

 .cardList__btn .icon {
   width: 100%;
   height: 100%;
   display: flex;
   align-items: center;
   justify-content: center;
 }

 .cardList__btn .icon svg {
   width: 100%;
   height: 100%;
   filter: drop-shadow(0 2px 8px rgba(0, 0, 0, 0.4));
   transition: filter 0.3s ease;
 }

 .cardList__btn:hover:not(:disabled) .icon svg {
   filter: drop-shadow(0 4px 12px rgba(0, 0, 0, 0.6));
 }

 .cardList .cards__wrapper {
   position: relative;
   width: 100%;
   height: 100%;
   perspective: 1000px;
 }

 .card {
   --card-translateY-offset: 100vh;
   position: absolute;
   left: 50%;
   top: 50%;
   transform: translate(-50%, -50%) translateX(var(--card-translateX-offset)) translateY(var(--card-translateY-offset)) rotateY(var(--card-rotation-offset)) scale(var(--card-scale-offset));
   display: inline-block;
   width: var(--card-width);
   height: var(--card-height);
   transition: transform var(--card-transition-duration) var(--card-transition-easing);
   user-select: none;
   cursor: pointer;
 }

 .card:active {
   transform: translate(-50%, -50%) translateX(var(--card-translateX-offset)) translateY(var(--card-translateY-offset)) rotateY(var(--card-rotation-offset)) scale(calc(var(--card-scale-offset) * 0.95));
 }

 .card::before {
   content: "";
   position: absolute;
   left: 0;
   top: 0;
   width: 100%;
   height: 100%;
   background: #000;
   z-index: 1;
   transition: opacity var(--card-transition-duration) var(--card-transition-easing);
   opacity: calc(1 - var(--opacity));
 }

 .card__image {
   position: relative;
   width: 100%;
   height: 100%;
 }

 .card__image img {
   position: absolute;
   left: 0;
   top: 0;
   width: 100%;
   height: 100%;
   object-fit: cover;
 }

 .card__decoration {
   position: absolute;
   top: calc(5% + 20px);
   left: 5%;
   width: 90%;
   height: 90%;
   z-index: 5;
   pointer-events: none;
   border-radius: 10px;
   overflow: hidden;
 }

 .card__decoration img {
   width: 100%;
   height: 100%;
   object-fit: cover; /* 改为cover让图片占据更多空间 */
   opacity: 0.9;
   border-radius: 8px;
 }

 /* 【曲】主题的装饰图片特殊样式 */
 .card__decoration.theme-qu img {
   object-fit: contain; /* 【曲】使用contain显示完整图片 */
   opacity: 1; /* 提高不透明度 */
   transform: scale(1.1); /* 放大10%以占据更多空间 */
 }

 .card.current--card {
   --current-card-rotation-offset: 0;
   --card-translateX-offset: 0;
   --card-rotation-offset: var(--current-card-rotation-offset);
   --card-scale-offset: 1.2;
   --opacity: 0.8;
 }

 .card.previous--card {
   --card-translateX-offset: calc(-1 * var(--card-width) * 1.1);
   --card-rotation-offset: 25deg;
 }

 .card.next--card {
   --card-translateX-offset: calc(var(--card-width) * 1.1);
   --card-rotation-offset: -25deg;
 }

 .card.previous--card, .card.next--card {
   --card-scale-offset: 0.9;
   --opacity: 0.4;
 }

 .infoList {
   position: absolute;
   left: 64px;
   width: min(58vw, 760px);
   height: var(--card-height);
   pointer-events: none;
   z-index: 20;
 }

 .dailySeal {
   position: absolute;
   right: 42px;
   top: 54%;
   transform: translateY(-50%);
   z-index: 25;
   width: 132px;
   padding: 4px 2px;
   color: #4a3b2d;
   opacity: 0;
   animation: sealFadeIn 0.9s ease 0.5s forwards, sealFloat 4.2s ease-in-out 1.4s infinite;
   transition: transform 0.25s ease, opacity 0.25s ease;
   cursor: pointer;
 }

 .dailySeal:hover {
   transform: translateY(calc(-50% - 3px));
   opacity: 1;
 }

 .dailySeal.paused {
   animation-play-state: paused;
 }

 .dailySeal.switching .sealBody,
 .dailySeal.switching .sealFoot {
   opacity: 0.25;
   transition: opacity 0.18s ease;
 }

 .dailySeal .sealHead {
   font-size: 12px;
   letter-spacing: 0.22em;
   color: #9a7a40;
   margin-bottom: 10px;
   padding-bottom: 6px;
  border-bottom: 1px solid rgba(184, 143, 58, 0.18);
 }

 .dailySeal .sealBody {
   writing-mode: vertical-rl;
   text-orientation: mixed;
   margin: 0 auto;
   height: auto;
   white-space: nowrap;
   font-size: 20px;
   line-height: 1.7;
   letter-spacing: 0.08em;
   color: #34271b;
 }

 .dailySeal .sealFoot {
   margin-top: 12px;
   font-size: 12px;
   letter-spacing: 0.08em;
   color: #7f6a4d;
   text-align: center;
 }

@keyframes sealFadeIn {
  from {
    opacity: 0;
    transform: translateY(calc(-50% + 10px));
  }
  to {
     opacity: 0.88;
     transform: translateY(-50%);
  }
}

@keyframes sealFloat {
  0% {
     transform: translateY(-50%);
  }
  50% {
     transform: translateY(calc(-50% - 5px));
  }
  100% {
     transform: translateY(-50%);
  }
}

 .infoList .info__wrapper {
   position: relative;
   width: 100%;
   height: 100%;
   display: flex;
   justify-content: flex-start;
   align-items: flex-end;
   perspective: 1000px;
   transform-style: preserve-3d;
 }

 .info {
   margin-bottom: calc(var(--card-height) / 8);
   margin-left: 0;
   transform: translateZ(2rem);
   transition: transform var(--card-transition-duration) var(--card-transition-easing);
 }

 .info .text {
   position: relative;
   font-family: "Noto Serif SC", "Source Han Serif SC", "Songti SC", serif;
   font-size: calc(var(--card-width) * var(--text-size-offset, 0.2));
   white-space: nowrap;
   color: #1f1610;
   width: fit-content;
 }

 .info .name {
   font-family: "Noto Serif SC", "Source Han Serif SC", serif;
   --text-size-offset: 0.3;
   color: #8e1e1f;
   font-weight: 700;
   letter-spacing: 0.08em;
   margin-top: 14px;
   margin-bottom: 8px;
 }

 .info .location {
   font-family: "Cormorant Garamond", "Times New Roman", serif;
   text-transform: uppercase;
   letter-spacing: 0.18em;
   --mg-left: 0;
   --text-size-offset: 0.18;
   font-weight: 600;
   margin-left: 0;
   margin-bottom: 1.1rem;
   padding-bottom: 0.6rem;
   color: #23170f;
 }

 .info .location::before, .info .location::after {
   content: "";
   position: absolute;
   background: #b88f3a;
   left: 0%;
   transform: none;
 }

 .info .location::before {
   top: -8px;
   width: 24px;
   height: 1px;
 }

 .info .location::after {
   bottom: 0;
   width: 82px;
   height: 1px;
 }

 .info .description {
   --text-size-offset: 0.065;
   font-weight: 500;
   max-width: 640px;
   white-space: normal;
   line-height: 1.76;
   color: #5b5046;
 }

 .info .heroBadge {
   --text-size-offset: 0.055;
   padding: 8px 18px;
   border: 1px solid rgba(184, 143, 58, 0.76);
   letter-spacing: 0.24em;
   color: #9e7d3f;
   margin-bottom: 12px;
 }

 .info .heroQuote {
   margin-top: 24px;
   border-left: 2px solid rgba(184, 143, 58, 0.82);
   padding-left: 16px;
   color: #6a5f53;
   max-width: 440px;
 }

 .info .heroQuote p {
   font-family: "Noto Serif SC", "Source Han Serif SC", serif;
   font-size: 24px;
   line-height: 1.5;
   margin-bottom: 8px;
   letter-spacing: 0.06em;
 }

 .info .heroQuote span {
   font-size: 16px;
   letter-spacing: 0.08em;
   opacity: 0.85;
 }

 .info .heroActions {
   margin-top: 28px;
   display: flex;
   align-items: center;
   gap: 14px;
   pointer-events: auto;
 }

 .info .heroBtn {
   height: 44px;
   padding: 0 26px;
   border: 1px solid rgba(89, 72, 42, 0.36);
   background: rgba(255, 250, 240, 0.7);
   color: #2f2418;
   font-family: "Noto Serif SC", "Source Han Serif SC", serif;
   font-size: 18px;
   letter-spacing: 0.22em;
   transition: transform 0.2s ease, border-color 0.2s ease, color 0.2s ease, background 0.2s ease;
 }

 .info .heroBtn:hover {
   transform: translateY(-1px);
   border-color: #9f2f25;
   color: #9f2f25;
   background: rgba(255, 250, 240, 0.92);
 }

 .info .heroBtn.ghost {
   background: rgba(255, 250, 240, 0.3);
 }

 .info .heroMeta {
   margin-top: 16px;
   display: flex;
   gap: 14px;
   flex-wrap: wrap;
   color: #7c6f60;
   font-size: 13px;
   letter-spacing: 0.06em;
 }

 .info .heroMeta span {
   padding: 4px 10px;
   border: 1px solid rgba(184, 143, 58, 0.32);
   background: rgba(255, 248, 236, 0.45);
 }

 .info.current--info {
   opacity: 1;
   display: block;
 }

 .info.previous--info, .info.next--info {
   opacity: 0;
   display: none;
 }

 @media only screen and (min-width: 800px) {
   :root {
     --card-width: 250px;
     --card-height: 400px;
  }
  .card__decoration {
    top: calc(5% + 20px);
    left: 5%;
    width: 90%;
    height: 90%;
  }
 }

@media only screen and (max-width: 768px) {
   .dailySeal {
     right: 10px;
     top: auto;
     bottom: 80px;
     transform: none;
     width: 102px;
     padding: 2px 0;
   }

   .dailySeal .sealBody {
     font-size: 15px;
   }

   .infoList {
     left: 14px;
     width: calc(100vw - 28px);
   }

   .card__decoration {
     top: calc(5% + 20px);
     left: 5%;
     width: 90%;
     height: 90%;
   }

   .info {
     margin-left: 8px;
     margin-bottom: 20px;
   }

   .info .name {
     --text-size-offset: 0.26;
   }

   .info .location {
     --text-size-offset: 0.13;
     margin-bottom: 0.8rem;
   }

   .info .description {
     --text-size-offset: 0.075;
     max-width: 86vw;
   }

   .info .heroBadge {
     --text-size-offset: 0.052;
     letter-spacing: 0.14em;
   }

   .info .heroQuote p {
     font-size: 18px;
   }

   .info .heroQuote span {
     font-size: 13px;
   }

   .info .heroActions {
     gap: 10px;
     flex-wrap: wrap;
   }

   .info .heroBtn {
     height: 40px;
     font-size: 15px;
     padding: 0 18px;
     letter-spacing: 0.14em;
   }

   .info .heroMeta {
     gap: 8px;
     font-size: 12px;
   }
 }

@media (min-width: 1400px) {
  .card__decoration {
    top: calc(5% + 20px);
    left: 5%;
    width: 90%;
    height: 90%;
  }
}

/* ========== 底部渐变过渡层 ========== */
.carousel-gradient-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 50vh;
  background: linear-gradient(
    to bottom,
    rgba(245, 238, 224, 0) 0%,
    rgba(230, 225, 215, 0.2) 15%,
    rgba(210, 215, 220, 0.4) 35%,
    rgba(195, 205, 215, 0.65) 55%,
    rgba(180, 195, 210, 0.85) 75%,
    rgba(165, 185, 205, 0.95) 100%
  );
  pointer-events: none;
  z-index: 30;
}

/* ========== 过渡装饰层 - 山水云雾效果 ========== */
.carousel-transition-layer {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 25vh;
  pointer-events: none;
  z-index: 31;
  overflow: hidden;
}

.transition-cloud {
  position: absolute;
  bottom: 0;
  border-radius: 50% 50% 0 0;
  background: linear-gradient(
    to top,
    rgba(180, 195, 210, 0.6) 0%,
    rgba(200, 210, 220, 0.3) 50%,
    rgba(220, 225, 230, 0) 100%
  );
  filter: blur(12px);
  animation: cloudFloat 8s ease-in-out infinite;
}

.transition-cloud.cloud-1 {
  width: 40vw;
  height: 120px;
  left: -5%;
  animation-delay: 0s;
}

.transition-cloud.cloud-2 {
  width: 55vw;
  height: 150px;
  left: 25%;
  animation-delay: -3s;
}

.transition-cloud.cloud-3 {
  width: 35vw;
  height: 100px;
  right: -5%;
  animation-delay: -5s;
}

@keyframes cloudFloat {
  0%, 100% {
    transform: translateY(0) translateX(0);
    opacity: 0.8;
  }
  50% {
    transform: translateY(-12px) translateX(8px);
    opacity: 0.5;
  }
}

/* 移动端适配 */
@media only screen and (max-width: 768px) {
  .carousel-gradient-overlay {
    height: 35vh;
  }

  .carousel-transition-layer {
    height: 18vh;
  }

  .transition-cloud {
    filter: blur(8px);
  }

  .transition-cloud.cloud-1 {
    width: 55vw;
    height: 70px;
  }

  .transition-cloud.cloud-2 {
    width: 70vw;
    height: 85px;
  }

  .transition-cloud.cloud-3 {
    width: 50vw;
    height: 60px;
  }
}
</style>
