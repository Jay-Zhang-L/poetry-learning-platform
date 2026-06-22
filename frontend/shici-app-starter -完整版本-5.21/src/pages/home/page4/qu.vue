<template>
  <div class="qu-page-container">
    <PoetryNavigation />

    <main class="qu-main-content" ref="mainContent">
      <!-- 卷一 -->
      <section class="scroll-section" id="section-origin">
        <div class="section-bg" :style="{ backgroundImage: `url(${originBgNew})` }"></div>
        <div class="calligraphy-word">曲</div>
        <img class="corner-img-zoom" :src="cornerImgUrl" alt="角标" />
        <div class="section-content empty-content">
          <div class="text-content"></div>
          <div class="visual-content"></div>
        </div>
      </section>

      <!-- 卷二（去掉白框） -->
      <section class="scroll-section" id="section-sanqu" style="background: linear-gradient(180deg, #000000, #ffffff);">
        <div class="section-content sanqu-layout">
          <div class="left-placeholder">
            <div class="sanqu-text-wrapper no-bg">
              <div class="sanqu-title">散曲</div>
              <div class="sanqu-intro">
                <p>散曲是元代新兴的诗歌形式，分为小令和套数。小令是单支曲子，短小精悍；套数由多支曲牌连缀而成，叙事抒情更为丰富。</p>
                <p>代表作家有关汉卿、马致远、白朴等。马致远的《天净沙·秋思》被誉为“秋思之祖”，关汉卿的《四块玉·闲适》则展现了文人的超脱情怀。</p>
                <p>散曲语言通俗活泼，比词更自由，大量运用口语、衬字，生活气息浓厚，是元代文学的瑰宝。</p>
              </div>
            </div>
            <div class="top-area" ref="sanquTopArea"></div>
            <div class="bottom-area" ref="sanquBottomArea"></div>
          </div>
          <div class="right-image">
            <img class="right-full-img" :src="img12Url" alt="人物" />
          </div>
        </div>
      </section>

      <!-- 卷三 -->
      <section class="scroll-section" id="section-ju" :style="{ background: `linear-gradient(180deg, #ffffff, ${fourthBgColor})` }">
        <div class="section-content ju-layout">
          <div class="text-content">
            <div class="section-number" style="display: none;">卷三</div>
            <h2 class="section-title">杂剧</h2>
            <div class="section-desc strong-text">
              <p>元杂剧是中国戏曲的第一个黄金时代，融合了唱、念、做、打等表演手段，结构通常为“四折一楔子”。</p>
              <p><strong>关汉卿、王实甫、白朴、马致远</strong>并称“元曲四大家”。关汉卿的《窦娥冤》是中国古典悲剧的典范，通过窦娥的冤案深刻揭露了社会的黑暗；王实甫的《西厢记》歌颂了青年男女的爱情自由，文辞优美；白朴的《梧桐雨》以唐明皇与杨贵妃的爱情悲剧折射历史兴亡；马致远的《汉宫秋》借王昭君的故事抒写家国之痛。</p>
              <p>此外，郑光祖的《倩女离魂》等作品也极具艺术价值。元杂剧题材广泛，从历史公案到爱情婚姻，从神仙道化到社会民生，极大地丰富了中国戏曲的宝库。</p>
            </div>
            <div class="poetry-excerpt">
              <div class="poem-title">《窦娥冤》第三折（节选）</div>
              <div class="poem-content">
                <p>【滚绣球】有日月朝暮悬，有鬼神掌着生死权。天地也！只合把清浊分辨，可怎生糊突了盗跖、颜渊？</p>
                <p>为善的受贫穷更命短，造恶的享富贵又寿延。天地也！做得个怕硬欺软，却原来也这般顺水推船。</p>
                <p>地也，你不分好歹何为地？天也，你错勘贤愚枉做天！哎，只落得两泪涟涟。</p>
              </div>
              <div class="poem-desc" style="margin-top: 1rem; font-size: 0.95rem; color: #555;">
                <p>这段唱词是窦娥被押赴刑场时对天地的控诉，情感激烈，语言泼辣，充分展现了关汉卿剧作“本色当行”的特点，也是元杂剧反抗精神的集中体现。</p>
              </div>
            </div>
          </div>
          <div class="right-placeholder" ref="juRightArea"></div>
        </div>
      </section>

      <!-- 第四卷：左侧图片下方添加白色切换按钮 -->
      <section class="scroll-section" id="section-fourth" :style="{ backgroundColor: fourthBgColor }" ref="fourthSection">
        <div class="section-content fourth-layout">
          <div class="left-fourth-container">
            <div class="left-fourth clickable" @click="rotateToNext" :class="{ rotating: isRotating }">
              <img class="fourth-img" :src="currentLeftImg" alt="左图" />
            </div>
            <!-- 白色按钮，点击切换下一张 -->
            <div class="switch-btn" @click="rotateToNext">换一换</div>
          </div>
          <div class="right-fourth clickable" @click="rotateToNext" :class="{ rotating: isRotating }">
            <div class="right-intro-card">
              <div class="intro-title">{{ currentIntroTitle }}</div>
              <div class="intro-section">{{ currentIntroTheme }}</div>
              <div class="intro-detail">{{ currentIntroDetail }}</div>
              <div class="intro-background">{{ currentIntroBackground }}</div>
            </div>
          </div>
        </div>
      </section>

      <!-- 视频区 -->
      <section class="video-section" id="section-video" :style="{ backgroundImage: `url(${videoGalleryBgImg})`, backgroundSize: 'cover', backgroundPosition: 'center' }">
        <div class="section-header">
          <div class="calligraphy-title">
            <span class="calligraphy-char">说</span>
            <span class="calligraphy-char">曲</span>
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

      <!-- 画廊区 -->
      <section class="gallery-section" id="section-gallery" :style="{ backgroundImage: `url(${videoGalleryBgImg})`, backgroundSize: 'cover', backgroundPosition: 'center' }">
        <div class="section-header">
          <div class="calligraphy-title">
            <span class="calligraphy-char">赏</span>
            <span class="calligraphy-char">曲</span>
          </div>
        </div>
        <div class="gallery-container">
          <div class="ancient-book-layout">
            <!-- 大型书法作品区域 - 占2行2列 -->
            <div class="calligraphy-area large" @click="viewPainting(0)">
              <div class="calligraphy-content">
                <div class="calligraphy-placeholder" :style="{ backgroundImage: `url(${paintings[0].image})` }"></div>
              </div>
            </div>
            <!-- 中型作品 - 占1行2列 -->
            <div class="calligraphy-area medium-wide" @click="viewPainting(1)">
              <div class="calligraphy-content">
                <div class="calligraphy-placeholder" :style="{ backgroundImage: `url(${paintings[1].image})` }"></div>
              </div>
            </div>
            <!-- 小型作品 - 占1行1列 -->
            <div class="calligraphy-area small" @click="viewPainting(2)">
              <div class="calligraphy-content">
                <div class="calligraphy-placeholder" :style="{ backgroundImage: `url(${paintings[2].image})` }"></div>
              </div>
            </div>
            <div class="calligraphy-area small" @click="viewPainting(3)">
              <div class="calligraphy-content">
                <div class="calligraphy-placeholder" :style="{ backgroundImage: `url(${paintings[3].image})` }"></div>
              </div>
            </div>
            <!-- 中型作品 - 占2行1列 -->
            <div class="calligraphy-area medium-tall" @click="viewPainting(4)">
              <div class="calligraphy-content">
                <div class="calligraphy-placeholder" :style="{ backgroundImage: `url(${paintings[4].image})` }"></div>
              </div>
            </div>
            <div class="calligraphy-area medium-tall" @click="viewPainting(5)">
              <div class="calligraphy-content">
                <div class="calligraphy-placeholder" :style="{ backgroundImage: `url(${paintings[5].image})` }"></div>
              </div>
            </div>
            <!-- 大型作品 - 占2行2列 -->
            <div class="calligraphy-area large" @click="viewPainting(6)">
              <div class="calligraphy-content">
                <div class="calligraphy-placeholder" :style="{ backgroundImage: `url(${paintings[6].image})` }"></div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- 页脚 -->
      <footer class="qu-footer">
        <div class="footer-content">
          <div class="footer-text">
            <p>曲是元代的文学瑰宝</p>
            <p>散曲清丽，杂剧生动，展现中国戏曲艺术的高峰</p>
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

    <!-- 跨卷绝对定位图片 -->
    <img class="cross-img" :src="img14Url" alt="14" ref="img14El" />
    <img class="cross-img" :src="img15Url" alt="15" ref="img15El" />
    <img class="cross-img" :src="img1Url" alt="1" ref="img1CrossEl" />

    <!-- 弹窗 -->
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

    <div v-if="showPaintingModal" class="painting-modal" @click="closePaintingModal">
      <div class="modal-content" @click.stop>
        <button class="close-btn" @click="closePaintingModal">✕</button>
        <div class="painting-viewer">
          <img v-if="currentPainting.image" :src="currentPainting.image" :alt="currentPainting.title">
          <div v-else class="painting-modal-placeholder">
            <span class="modal-placeholder-icon">🎨</span>
            <p>{{ currentPainting.title }}</p>
          </div>
          <div class="painting-detail">
            <h3>{{ currentPainting.title }}</h3>
            <p>作者：{{ currentPainting.artist }}</p>
            <p>关联曲作：{{ currentPainting.relatedQu }}</p>
            <p>{{ currentPainting.description }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import PoetryNavigation from '@/components/PoetryNavigation.vue'

// ==================== 图片路径 ====================
const originBgNew = new URL('@/assets/home1/qu/11.jpg', import.meta.url).href
const cornerImgUrl = new URL('@/assets/home1/qu/13.png', import.meta.url).href
const img12Url = new URL('@/assets/home1/qu/12.png', import.meta.url).href
const img14Url = new URL('@/assets/home1/qu/14.png', import.meta.url).href
const img15Url = new URL('@/assets/home1/qu/15.png', import.meta.url).href
const img1Url = new URL('@/assets/home1/qu/1.png', import.meta.url).href

const videoGalleryBgImg = new URL('@/assets/home1/shi/chouti/bg.jpg', import.meta.url).href

// 第四屏左侧图片数组（3.png白蛇传, 4.png牡丹亭, 5.png龙凤呈祥）
const leftImages = [
  new URL('@/assets/home1/qu/3.png', import.meta.url).href,
  new URL('@/assets/home1/qu/4.png', import.meta.url).href,
  new URL('@/assets/home1/qu/5.png', import.meta.url).href
]

// 右侧详细介绍卡片数据
const rightCards = [
  {
    title: '京剧《白蛇传·断桥》白素贞形象',
    theme: '主题：描绘了《白蛇传》中白素贞的经典形象，背景的落花、燕子与太湖石，烘托出断桥重逢时凄美的氛围。',
    detail: '细节：白素贞身着红白戏服，白纱飘带迎风飞舞，手持红梅的姿态哀怨动人，完美还原了戏曲中她在断桥等待许仙时的柔肠寸断；飘落的花瓣也暗示了故事的悲剧底色。',
    background: '戏曲背景：“断桥”是《白蛇传》中最经典的一折，白素贞的形象融合了温婉与坚韧，是戏曲舞台上最具代表性的青衣角色之一。'
  },
  {
    title: '昆曲/京剧《牡丹亭·惊梦》场景',
    theme: '主题：描绘了汤显祖《牡丹亭》中杜丽娘与柳梦梅的经典相遇场景，背景的垂柳、桃花、骏马暗示了故事发生在春日游园的情境。',
    detail: '细节：杜丽娘的戏服色彩雅致，绣有花鸟纹样，柳梦梅身着红色书生戏服，二人互动的姿态温柔含蓄，符合昆曲“以情动人”的意境；一旁的丑角（家僮）则增添了舞台的生动感。',
    background: '戏曲背景：《牡丹亭》是昆曲的巅峰之作，工笔画常以“游园惊梦”为题材，表现杜丽娘与柳梦梅跨越生死的爱情故事。'
  },
  {
    title: '京剧《龙凤呈祥》（或《大登殿》）大婚场景',
    theme: '主题：描绘了京剧经典剧目《龙凤呈祥》（刘备与孙尚香）或《大登殿》中，主角身着婚服的喜庆场面。画面中心的帝后/王侯形象，头戴凤冠、身着大红蟒袍，两侧侍从掌扇，还原了传统婚礼的庄重华贵。',
    detail: '细节：服饰采用工笔重彩技法，红底绣满龙纹、海水江崖纹样，凤冠上的珠翠点染细腻，背景的明黄色调烘托出皇家婚礼的喜庆氛围。',
    background: '戏曲背景：这类“红蟒婚服”是戏曲中帝后、贵族大婚的标志性服饰，象征着身份的尊贵与婚姻的圆满。'
  }
]

const fourthBgColor = '#E8DCC4'

const router = useRouter()
const mainContent = ref(null)
const fourthSection = ref(null)
const sanquTopArea = ref(null)
const sanquBottomArea = ref(null)
const juRightArea = ref(null)

const img14El = ref(null)
const img15El = ref(null)
const img1CrossEl = ref(null)

const leftOpacity = ref(1)
const isRotating = ref(false)
const currentIndex = ref(0)

const currentLeftImg = computed(() => leftImages[currentIndex.value])
const currentIntroTitle = computed(() => rightCards[currentIndex.value].title)
const currentIntroTheme = computed(() => rightCards[currentIndex.value].theme)
const currentIntroDetail = computed(() => rightCards[currentIndex.value].detail)
const currentIntroBackground = computed(() => rightCards[currentIndex.value].background)

function rotateToNext() {
  if (isRotating.value) return
  isRotating.value = true
  setTimeout(() => {
    currentIndex.value = (currentIndex.value + 1) % leftImages.length
    setTimeout(() => {
      isRotating.value = false
    }, 100)
  }, 300)
}

// 视频数据
const videos = ref([
  {
    id: 1,
    title: '元曲的艺术特色——散曲与杂剧的完美结合',
    speaker: '邓绍基教授',
    description: '深入解析元曲的艺术特色、发展历程与文化价值',
    category: '古典文学',
    views: '13.2万',
    tags: ['元曲', '散曲', '杂剧'],
    thumbnail: '',
    duration: '17:20',
    url: ''
  }
])

// 画作数据
const paintings = ref([
  { id: 1, title: '西厢记图', artist: '王实甫', era: '元代', dynasty: '元代', relatedQu: '《西厢记》', image: new URL('@/assets/home1/qu/shang/stage-PC01-9.jpg', import.meta.url).href, description: '张生与崔莺莺的爱情故事' },
  { id: 2, title: '秋思图', artist: '马致远', era: '元代', dynasty: '元代', relatedQu: '《天净沙·秋思》', image: new URL('@/assets/home1/qu/shang/stage-PC02-7.jpg', import.meta.url).href, description: '枯藤老树昏鸦的经典意境' },
  { id: 3, title: '窦娥冤图', artist: '关汉卿', era: '元代', dynasty: '元代', relatedQu: '《窦娥冤》', image: new URL('@/assets/home1/qu/shang/stage-PC03-16.jpg', import.meta.url).href, description: '窦娥六月飞雪的悲剧场景' },
  { id: 4, title: '梧桐雨图', artist: '白朴', era: '元代', dynasty: '元代', relatedQu: '《梧桐雨》', image: new URL('@/assets/home1/qu/shang/stage-PC04-20.jpg', import.meta.url).href, description: '唐明皇与杨贵妃的爱情悲剧' },
  { id: 5, title: '汉宫秋图', artist: '马致远', era: '元代', dynasty: '元代', relatedQu: '《汉宫秋》', image: new URL('@/assets/home1/qu/shang/stage-PC05-10.jpg', import.meta.url).href, description: '王昭君出塞的和亲故事' },
  { id: 6, title: '墙头马上图', artist: '白朴', era: '元代', dynasty: '元代', relatedQu: '《墙头马上》', image: new URL('@/assets/home1/qu/shang/stage-PC06-8.jpg', import.meta.url).href, description: '裴少俊与李千金的浪漫爱情' },
  { id: 7, title: '倩女离魂图', artist: '郑光祖', era: '元代', dynasty: '元代', relatedQu: '《倩女离魂》', image: new URL('@/assets/home1/qu/shang/stage-PC01-9.jpg', import.meta.url).href, description: '张倩女为爱情离魂的奇幻故事' }
])

const showVideoModal = ref(false)
const showPaintingModal = ref(false)
const currentVideo = ref({})
const currentPainting = ref({})

const sections = ref([
  { id: 'section-origin', title: '曲的起源' },
  { id: 'section-sanqu', title: '散曲' },
  { id: 'section-ju', title: '杂剧' },
  { id: 'section-fourth', title: '第四卷' },
  { id: 'section-video', title: '名师讲堂' },
  { id: 'section-gallery', title: '曲画意境' }
])

function scrollToTop() {
  window.scrollTo({ top: 0, behavior: 'smooth' })
  if (mainContent.value) mainContent.value.scrollTo({ top: 0, behavior: 'smooth' })
  document.documentElement.scrollTo({ top: 0, behavior: 'smooth' })
}
function exploreMore() { router.push('/library') }
function playVideo(index) { currentVideo.value = videos.value[index]; showVideoModal.value = true }
function closeVideoModal() { showVideoModal.value = false; currentVideo.value = {} }
function viewPainting(index) { currentPainting.value = paintings.value[index]; showPaintingModal.value = true }
function closePaintingModal() { showPaintingModal.value = false; currentPainting.value = {} }

// 更新跨卷图片位置
function updateCrossImages() {
  if (!sanquTopArea.value || !sanquBottomArea.value || !juRightArea.value) return

  const topRect = sanquTopArea.value.getBoundingClientRect()
  const bottomRect = sanquBottomArea.value.getBoundingClientRect()
  const juRect = juRightArea.value.getBoundingClientRect()
  const scrollY = window.scrollY

  const imgWidth = topRect.width * 0.2
  const imgHeight = 'auto'

  if (img14El.value) {
    img14El.value.style.position = 'absolute'
    img14El.value.style.left = topRect.left + 'px'
    img14El.value.style.top = (topRect.top + scrollY - 600) + 'px'
    img14El.value.style.width = imgWidth + 'px'
    img14El.value.style.height = imgHeight
    img14El.value.style.zIndex = '20'
  }

  if (img15El.value) {
    img15El.value.style.position = 'absolute'
    img15El.value.style.left = bottomRect.left + 'px'
    img15El.value.style.top = (bottomRect.top + scrollY) + 'px'
    img15El.value.style.width = imgWidth + 'px'
    img15El.value.style.height = imgHeight
    img15El.value.style.zIndex = '20'
  }

  if (img1CrossEl.value) {
    const extendDown = juRect.height * 0.3
    img1CrossEl.value.style.position = 'absolute'
    img1CrossEl.value.style.right = '0px'
    img1CrossEl.value.style.top = (juRect.top + scrollY + extendDown) + 'px'
    img1CrossEl.value.style.width = juRect.width + 'px'
    img1CrossEl.value.style.height = 'auto'
    img1CrossEl.value.style.zIndex = '20'
    img1CrossEl.value.style.objectFit = 'cover'
  }
}

// 第四屏滚动透明度（仅左侧图片容器）
function updateFourthOpacity() {
  if (!fourthSection.value) return
  const rect = fourthSection.value.getBoundingClientRect()
  const windowHeight = window.innerHeight
  let progress = 0
  if (rect.top < windowHeight && rect.bottom > 0) {
    const visibleHeight = Math.min(windowHeight, rect.bottom) - Math.max(0, rect.top)
    progress = visibleHeight / rect.height
  }
  leftOpacity.value = Math.max(0, Math.min(1, 1 - progress))
}

function handleScroll() {
  updateCrossImages()
  updateFourthOpacity()
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
  window.addEventListener('resize', handleScroll)
  handleScroll()
})
onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
  window.removeEventListener('resize', handleScroll)
})
</script>

<style scoped>
/* 基础样式 */
.qu-page-container {
  width: 100%;
  min-height: 100vh;
  background: #F5F1E8;
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
  position: relative;
}
.qu-main-content {
  padding-top: 10px;
}
.scroll-section {
  min-height: 100vh;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 4rem 2rem;
}
.section-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-size: cover;
  background-position: center;
  z-index: 0;
}
.calligraphy-word {
  position: absolute;
  top: 40px;
  right: 40px;
  font-family: '华文行书', 'STXingkai', 'KaiTi', cursive;
  font-size: 6rem;
  font-weight: bold;
  color: #F5A623;
  text-shadow: 2px 2px 8px rgba(0,0,0,0.2);
  z-index: 10;
  letter-spacing: 4px;
}
.corner-img-zoom {
  position: absolute;
  bottom: 20px;
  right: 20px;
  max-width: 150px;
  max-height: 150px;
  transform: scale(3);
  transform-origin: bottom right;
  z-index: 2;
  pointer-events: none;
}
.section-content {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0;
  max-width: 1400px;
  margin: 0 auto;
  align-items: stretch;
}
.section-content.empty-content .text-content,
.section-content.empty-content .visual-content {
  padding: 0;
  min-height: 0;
}
.sanqu-layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0;
  width: 100%;
  height: 100%;
}
.left-placeholder {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  height: 100%;
  position: relative;
}
/* 第二卷文字卡片：去掉白框（无背景、无模糊、无边框） */
.sanqu-text-wrapper.no-bg {
  padding: 2rem;
  background: transparent;
  border-radius: 0;
  backdrop-filter: none;
  margin-bottom: 1rem;
  margin-top: 400px;
}
.sanqu-title {
  font-size: 3rem;
  font-weight: bold;
  color: #F5A623;
  font-family: 'Noto Serif SC', serif;
  margin-bottom: 1.5rem;
  text-align: center;
}
.sanqu-intro p {
  font-size: 1.1rem;
  line-height: 1.8;
  color: #2C2418;
  margin-bottom: 1rem;
}
.top-area, .bottom-area {
  flex: 1;
}
.right-image {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: flex-end;
}
.right-full-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}
.ju-layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0;
}
.right-placeholder {
  width: 100%;
  height: 100%;
}
.text-content {
  padding: 2rem;
  background: transparent;
}
.section-number {
  font-size: 0.9rem;
  font-weight: 600;
  color: #F5A623;
  letter-spacing: 0.2em;
  margin-bottom: 1rem;
}
.section-title {
  font-size: 3rem;
  font-weight: 700;
  margin: 0 0 1rem 0;
  background: linear-gradient(135deg, #F5A623 0%, #F7C948 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.strong-text p {
  font-weight: 600;
  color: #1a1a1a;
  line-height: 1.7;
  margin-bottom: 1rem;
}
.poetry-excerpt {
  padding: 2rem;
  background: rgba(255, 255, 255, 0.85);
  border-radius: 16px;
  margin-top: 2rem;
  border-left: 6px solid #F5A623;
}
.poem-title {
  font-size: 1.4rem;
  font-weight: 700;
  margin-bottom: 1rem;
  color: #2C2418;
}
.poem-content {
  font-size: 1.05rem;
  line-height: 1.8;
  color: #2C2418;
}
.poem-content p {
  margin-bottom: 0.8rem;
  text-indent: 2em;
}
.poem-desc p {
  font-size: 0.95rem;
  color: #4a4a4a;
  line-height: 1.6;
}
/* 第四卷布局 */
.fourth-layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
  width: 100%;
  height: 100%;
  align-items: center;
}
.left-fourth-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
}
.left-fourth {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: opacity 0.3s ease;
  opacity: v-bind(leftOpacity);
}
.right-fourth {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 1;
}
.clickable {
  cursor: pointer;
}
.fourth-img {
  max-width: 80%;
  max-height: 80%;
  width: auto;
  height: auto;
  object-fit: contain;
  display: block;
}
/* 白色切换按钮，样式与右侧卡片类似 */
.switch-btn {
  margin-top: 1.5rem;
  background: rgba(255, 255, 245, 0.96);
  border-radius: 40px;
  padding: 0.6rem 1.5rem;
  font-size: 1rem;
  font-weight: 500;
  color: #8B5A2B;
  text-align: center;
  cursor: pointer;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transition: all 0.2s ease;
  backdrop-filter: blur(2px);
  border: 1px solid rgba(200, 180, 140, 0.5);
}
.switch-btn:hover {
  background: rgba(255, 255, 250, 1);
  transform: scale(1.02);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
}
.right-intro-card {
  background: rgba(255, 255, 245, 0.96);
  border-radius: 28px;
  padding: 1.8rem 2rem;
  box-shadow: 0 12px 28px rgba(0, 0, 0, 0.12);
  max-width: 90%;
  text-align: left;
  font-family: 'Noto Serif SC', serif;
  border-left: 6px solid #F5A623;
}
.intro-title {
  font-size: 1.5rem;
  font-weight: bold;
  color: #8B5A2B;
  margin-bottom: 1rem;
  text-align: center;
  border-bottom: 1px dashed #E0C8A0;
  padding-bottom: 0.5rem;
}
.intro-section, .intro-detail, .intro-background {
  font-size: 1rem;
  line-height: 1.6;
  color: #2C2418;
  margin-bottom: 0.8rem;
}
.intro-section {
  font-weight: 500;
  color: #A0522D;
}
.intro-detail {
  font-style: normal;
}
.intro-background {
  color: #5A4A3A;
  font-size: 0.95rem;
}
.rotating {
  animation: rotate3d 0.6s ease-in-out;
}
@keyframes rotate3d {
  0% { transform: rotateY(0deg); }
  50% { transform: rotateY(180deg); }
  100% { transform: rotateY(360deg); }
}
.cross-img {
  position: absolute;
  pointer-events: none;
  z-index: 20;
  transition: all 0.1s linear;
}
/* 其余样式（视频区、画廊区、页脚、弹窗等）与之前完全相同，此处为保持代码完整 */
.visual-content {
  display: flex;
  justify-content: center;
  align-items: center;
}
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
  aspect-ratio: 16/9;
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
.gallery-section {
  padding: 2rem 2rem 4rem; /* 保持一致的padding */
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  position: relative;
}

/* 为赏曲section添加半透明遮罩层 */
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

/* 确保赏曲section的内容在遮罩层之上 */
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
  background-image: repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(139, 115, 85, 0.03) 2px), repeating-linear-gradient(90deg, transparent, transparent 2px, rgba(139, 115, 85, 0.03) 2px);
  pointer-events: none;
}
.qu-footer {
  padding: 3rem 2rem;
  background: #2C2418;
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
.video-modal, .painting-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
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
  aspect-ratio: 16/9;
  background: black;
}
.video-player video {
  width: 100%;
  height: 100%;
}
.video-detail, .painting-detail {
  padding: 2rem;
}
.video-detail h3, .painting-detail h3 {
  font-size: 1.5rem;
  margin: 0 0 1rem 0;
}
.video-detail p, .painting-detail p {
  color: #6B5E4F;
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
@media (max-width: 768px) {
  .section-content {
    grid-template-columns: 1fr;
    gap: 0;
  }
  .section-title {
    font-size: 2rem;
  }
  .calligraphy-char {
    font-size: 2.5rem;
  }
  .ancient-book-layout {
    grid-template-columns: repeat(2, 1fr);
    gap: 6px;
    padding: 6px;
  }
  .corner-img-zoom {
    transform: scale(2);
    bottom: 10px;
    right: 10px;
  }
  .calligraphy-word {
    font-size: 3rem;
    top: 20px;
    right: 20px;
  }
  .sanqu-title {
    font-size: 2rem;
  }
  .fourth-layout {
    gap: 1rem;
  }
  .right-intro-card {
    padding: 1rem;
  }
  .intro-title {
    font-size: 1.2rem;
  }
  .intro-section, .intro-detail, .intro-background {
    font-size: 0.85rem;
  }
  .switch-btn {
    padding: 0.4rem 1rem;
    font-size: 0.8rem;
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
}
</style>