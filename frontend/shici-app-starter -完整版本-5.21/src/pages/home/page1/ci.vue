<template>
  <div class="ci-page-container">
    <!-- 国风导航栏 -->
    <PoetryNavigation />

    <!-- 2. 多个长卷式内容分屏 -->
    <main class="ci-main-content" ref="mainContent">
<div class="three-scroll-wrap">
  <div class="three-scroll-bg" :style="{ backgroundImage: `url(${threeScrollBg})` }"></div>

<!-- 卷一：词的起源 -->
<section
  class="scroll-section scroll-section--transparent section-origin-full"
  id="section-origin"
  :style="{ backgroundImage: `url(${gardImg})` }"
>
  <div class="origin-overlay"></div>

  <div class="section-content origin-content">
    <div class="text-content origin-text-content">
      <h2 class="section-title">词的起源</h2>
      <div class="section-desc">
        <p>词，又称"长短句"，起源于隋唐，兴盛于宋代。最初是配合音乐歌唱的歌词，后来发展成为一种独立的文学体裁。</p>
        <p>词牌名如《虞美人》、《水调歌头》、《念奴娇》等，不仅是曲调的名称，更蕴含着深厚的文化底蕴。</p>
      </div>
      <div class="ink-quote">
        “词是中国古代文学皇冠上光辉夺目的明珠”
      </div>
    </div>
  </div>
</section>

<!-- 卷二：婉约派 -->
<section class="scroll-section scroll-section--transparent" id="section-graceful">
  <div class="section-content graceful-layout">
    <div class="visual-content visual-content--left">
      <div class="poet-portrait poet-portrait--image">
        <img class="poet-real-image" :src="liqingzhaoImg" alt="李清照画像" />
      </div>
    </div>

    <div class="text-content text-content--graceful">
      <h2 class="section-title">婉约派</h2>
      <div class="section-desc">
        <p>婉约派词风细腻柔和，情感深沉，以李清照、柳永为代表。他们的词作多描写儿女情长、离愁别绪。</p>
        <p>李清照的《声声慢》堪称婉约词的巅峰之作，将内心的孤寂与哀愁表达得淋漓尽致。</p>
      </div>

      <div class="ink-poem">
        <div class="ink-poem-title">《声声慢·寻寻觅觅》</div>
        <div class="ink-poem-lines">
          <p>寻寻觅觅，冷冷清清，凄凄惨惨戚戚。</p>
          <p>乍暖还寒时候，最难将息。</p>
          <p>三杯两盏淡酒，怎敌他、晚来风急？</p>
        </div>
      </div>
    </div>
  </div>
</section>

  <!-- 卷三：豪放派 -->
  <section class="scroll-section scroll-section--transparent" id="section-bold">
    <div class="section-content">
      <div class="text-content">
        <h2 class="section-title">豪放派</h2>
        <div class="section-desc">
          <p>豪放派词风气势磅礴，意境开阔，以苏轼、辛弃疾为代表。他们的词作多抒发爱国情怀、人生感悟。</p>
          <p>苏轼的《念奴娇·赤壁怀古》将历史沧桑与个人感慨完美融合，展现了豪放词的独特魅力。</p>
        </div>
<div class="ink-poem">
  <div class="ink-poem-title">“《念奴娇·赤壁怀古》</div>
  <div class="ink-poem-lines">
    <p>大江东去，浪淘尽，千古风流人物。</p>
    <p>故垒西边，人道是，三国周郎赤壁。</p>
    <p>乱石穿空，惊涛拍岸，卷起千堆雪。”</p>
  </div>
</div>
      </div>
      <div class="visual-content">
        <div class="landscape-painting">
          <div class="painting-placeholder chibi-container">
          <img 
            class="chibi-image" 
            :src="chibiImg" 
            alt="赤壁怀古图"
          />
        </div>
        </div>
      </div>
    </div>
  </section>
</div>

      <!-- 3. 专家视频区 -->
      <section class="video-section" id="section-video">
        <div class="section-header">
          <div class="calligraphy-title">
            <span class="calligraphy-char">说</span>
            <span class="calligraphy-char">词</span>
          </div>
        </div>

        <div class="video-gallery">
          <div class="video-card" @click="playVideo(0)">
            <div class="video-thumbnail">
              <img v-if="videos[0].thumbnail" :src="videos[0].thumbnail" :alt="videos[0].title">
              <div v-else class="video-thumbnail-placeholder">
                <span class="video-placeholder-icon">🎬</span>
              </div>
              <div class="play-overlay">
                <div class="play-btn">
                  <span class="play-icon">▶</span>
                </div>
              </div>
              <div class="video-duration">{{ videos[0].duration }}</div>
            </div>
          </div>
        </div>
      </section>

      <!-- 4. 赏词图片区 -->
      <section class="gallery-section" id="section-gallery">
        <div class="section-header">
          <div class="calligraphy-title">
            <span class="calligraphy-char">赏</span>
            <span class="calligraphy-char">词</span>
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
      <footer class="ci-footer">
        <div class="footer-content">
          <div class="footer-text">
            <p>词是中华文化宝库中的璀璨明珠</p>
            <p>婉约与豪放，共同构成了宋词的丰富内涵</p>
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
            <p>关联词牌：{{ currentPainting.relatedCi }}</p>
            <p>{{ currentPainting.description }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>

import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import PoetryNavigation from '@/components/PoetryNavigation.vue'
import threeScrollBg from '@/assets/home1/ci/three-scroll-bg.jpg'
import liqingzhaoImg from '@/assets/home1/ci/liqingzhao.png'
import gardImg from '@/assets/home1/ci/gard.png'
import chibiImg from '@/assets/home1/ci/chibi.jpg'

const router = useRouter()
const currentSection = ref(0)
const mainContent = ref(null)



// 视频数据配置
const videos = ref([
  {
    id: 1,
    title: '李清照词作赏析——婉约派的巅峰艺术',
    speaker: '王立群教授',
    description: '深入解析李清照的代表作品，探讨婉约词的艺术特色与情感表达',
    category: '词人赏析',
    views: '12.5万',
    tags: ['李清照', '婉约派', '声声慢'],
    thumbnail: '',
    duration: '12:35',
    url: ''
  },
  {
    id: 2,
    title: '苏轼豪放词解读——大江东去的千古绝唱',
    speaker: '莫砺锋教授',
    description: '从文化背景角度解读苏轼豪放词的精神内涵与人格魅力',
    category: '名家讲座',
    views: '8.3万',
    tags: ['苏轼', '豪放派', '念奴娇'],
    thumbnail: '',
    duration: '15:20',
    url: ''
  },
  {
    id: 3,
    title: '宋词与音乐——还原词的歌唱本质',
    speaker: '田青教授',
    description: '探讨词与音乐的密切关系，还原词作为音乐文学的本来面貌',
    category: '文化解读',
    views: '6.7万',
    tags: ['词乐', '音乐', '传统文化'],
    thumbnail: '',
    duration: '18:45',
    url: ''
  },
  {
    id: 4,
    title: '词牌名的文化内涵与历史典故',
    speaker: '康震教授',
    description: '解析常见词牌名的来历及其背后的历史故事与文化意义',
    category: '知识科普',
    views: '15.2万',
    tags: ['词牌', '历史', '文化'],
    thumbnail: '',
    duration: '14:10',
    url: ''
  }
])

// 画作数据配置
const paintings = ref([
  {
    id: 1,
    title: '清秋图',
    artist: '张大千',
    era: '近代',
    dynasty: '民国',
    relatedCi: '《虞美人·春花秋月何时了》',
    image: 'https://picsum.photos/800/600?random=1',
    description: '清秋时节，落叶飘零，意境凄美，展现了词人凄凉的心境'
  },
  {
    id: 2,
    title: '赤壁夜游',
    artist: '吴冠中',
    era: '现代',
    dynasty: '当代',
    relatedCi: '《念奴娇·赤壁怀古》',
    image: 'https://picsum.photos/800/600?random=2',
    description: '再现苏轼赤壁怀古的壮阔场景，融合中西绘画技法'
  },
  {
    id: 3,
    title: '春江花月夜',
    artist: '傅抱石',
    era: '近代',
    dynasty: '民国',
    relatedCi: '《春江花月夜》',
    image: 'https://picsum.photos/400/300?random=3',
    description: '春江潮水连海平，海上明月共潮生的诗意表达'
  },
  {
    id: 4,
    title: '寒江独钓',
    artist: '李可染',
    era: '现代',
    dynasty: '当代',
    relatedCi: '《江城子·密州出猎》',
    image: 'https://picsum.photos/400/300?random=4',
    description: '孤舟蓑笠翁，独钓寒江雪的孤寂意境'
  },
  {
    id: 5,
    title: '踏歌图',
    artist: '关山月',
    era: '现代',
    dynasty: '当代',
    relatedCi: '《踏莎行·郴州旅舍》',
    image: 'https://picsum.photos/400/600?random=5',
    description: '民间歌舞场景，生动活泼，充满生活气息'
  },
  {
    id: 6,
    title: '听琴图',
    artist: '黄秋园',
    era: '近代',
    dynasty: '民国',
    relatedCi: '《水调歌头·明月几时有》',
    image: 'https://picsum.photos/400/600?random=6',
    description: '文人雅集，抚琴赏音，展现古代文人生活情趣'
  },
  {
    id: 7,
    title: '清明上河图',
    artist: '张择端',
    era: '北宋',
    dynasty: '宋代',
    relatedCi: '《青玉案·元夕》',
    image: 'https://picsum.photos/800/600?random=7',
    description: '描绘北宋京城汴京的繁荣景象，千古传世之作'
  }
])

// 视频和弹窗状态
const showVideoModal = ref(false)
const showPaintingModal = ref(false)
const currentVideo = ref({})
const currentPainting = ref({})

// 章节配置
const sections = ref([
  { id: 'section-origin', title: '词的起源' },
  { id: 'section-graceful', title: '婉约派' },
  { id: 'section-bold', title: '豪放派' },
  { id: 'section-video', title: '名师讲堂' },
  { id: 'section-gallery', title: '词画意境' }
])

function scrollToTop() {
  // 尝试滚动window
  window.scrollTo({ top: 0, behavior: 'smooth' })
  // 同时尝试滚动mainContent容器
  if (mainContent.value) {
    mainContent.value.scrollTo({ top: 0, behavior: 'smooth' })
  }
  // 最后尝试直接滚动到页面顶部
  document.documentElement.scrollTo({ top: 0, behavior: 'smooth' })
}

function exploreMore() {
  // 跳转到其他页面
  router.push('/library')
}

// 视频功能
function playVideo(index) {
  currentVideo.value = videos.value[index]
  showVideoModal.value = true
}

function closeVideoModal() {
  showVideoModal.value = false
  currentVideo.value = {}
}

// 画作功能
function viewPainting(index) {
  currentPainting.value = paintings.value[index]
  showPaintingModal.value = true
}

function closePaintingModal() {
  showPaintingModal.value = false
  currentPainting.value = {}
}

// 滚动监听
function handleScroll() {
  const scrollPosition = window.scrollY + window.innerHeight / 2
  sections.value.forEach((section, index) => {
    const element = document.getElementById(section.id)
    if (element) {
      const { offsetTop, offsetHeight } = element
      if (scrollPosition >= offsetTop && scrollPosition < offsetTop + offsetHeight) {
        currentSection.value = index
      }
    }
  })
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
/* 赤壁图片容器样式 */
.chibi-container {
  width: 100%;
  min-width: 200px;
  padding: 0 !important;
  overflow: hidden;
  background: transparent !important;
  box-shadow: none !important;
  display: flex;
  align-items: center;
  justify-content: center;
}

.chibi-image {
  width: 100%;
  height: auto;
  display: block;
  object-fit: contain;
}
/* 基础样式 */
.ci-page-container {
  width: 100%;
  min-height: 100vh;
  background: #F5F1E8; /* 宣纸色 */
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
  color: var(--text);
}

/* 主内容区 */
.ci-main-content {
  padding-top: 10px;
}

/* 2. 长卷式内容分屏 */
.scroll-section {
  min-height: 100vh;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 4rem 2rem;
}
.section-origin-full {
  position: relative;
  min-height: 100vh;
  padding: 0;
  background-size: cover;
  background-position: center center;
  background-repeat: no-repeat;
}

.origin-overlay {
  position: absolute;
  inset: 0;
  background: rgba(245, 241, 232, 0.12);
  z-index: 0;
}

.origin-content {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: none;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: flex-start;
  padding: 0 6vw;
}

.origin-text-content {
  max-width: 720px;
  padding: 0;
}

.three-scroll-wrap {
  position: relative;
  overflow: hidden;
}

.three-scroll-bg {
  position: absolute;
  inset: 0;
  background-size: cover;
  background-position: center top;
  background-repeat: no-repeat;
  opacity: 1;
  z-index: 0;
}

.three-scroll-wrap::after {
  content: '';
  position: absolute;
  inset: 0;
  background: rgba(245, 241, 232, 0.18);
  z-index: 0;
  pointer-events: none;
}

.scroll-section--transparent {
  background: transparent;
}

.scroll-section--transparent .section-content {
  position: relative;
  z-index: 1;
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

.text-content {
  padding: 2rem;
}

.section-number {
  font-size: 0.9rem;
  font-weight: 600;
  color: rgba(102, 126, 234, 0.8);
  letter-spacing: 0.2em;
  margin-bottom: 1rem;
}

.section-title {
  font-size: 3rem;
  font-weight: 700;
  margin: 0 0 2rem 0;
  color: var(--muted);
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

.ancient-instrument,
.poet-portrait,
.landscape-painting {
  position: relative;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

.instrument-placeholder,
.portrait-placeholder,
.painting-placeholder {
  background: white;
  padding: 3rem;
  text-align: center;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
  min-width: 200px;
}

.instrument-icon,
.portrait-icon,
.painting-icon {
  font-size: 4rem;
  display: block;
  margin-bottom: 1rem;
}

.instrument-placeholder p,
.painting-placeholder p {
  font-size: 1.2rem;
  color: #333;
  font-weight: 600;
  margin: 0;
}

.poet-portrait {
  text-align: center;
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

.portrait-placeholder {
  padding: 4rem 2rem;
  margin: 0;
  border-radius: 0;
  box-shadow: none;
}

.poet-info {
  padding: 1.5rem;
  background: var(--bg1);
}

.poet-info h3 {
  font-size: 1.5rem;
  margin: 0 0 0.5rem 0;
}

.poet-info p {
  color: var(--muted);
  margin: 0 0 1rem 0;
}

.poet-quote {
  font-style: italic;
  color: rgba(102, 126, 234, 0.8);
  line-height: 1.6;
}
#section-graceful .section-content {
  max-width: none;
  width: 100%;
  min-height: 980px;
  padding-left: 0;
  padding-right: 0;
}

#section-bold {
  min-height: 130vh;
  padding-top: 8rem;
  padding-bottom: 8rem;
}
#section-graceful .visual-content {
  justify-content: flex-start;
}

.graceful-layout {
  display: block;
  position: relative;
}

.visual-content--left {
  position: absolute;
  left: -200px;
  top: -350px;
  justify-content: flex-start;
  align-items: stretch;
  padding-left: 0;
}

.text-content--graceful {
  position: absolute;
  left: 920px;
  top: 450px;
  width: 460px;
  padding: 0;
}

.poet-portrait--image {
  width: 100%;
  max-width: none;
  border-radius: 0;
  overflow: visible;
  box-shadow: none;
  background: transparent;
  margin-top: 0;
}

.poet-real-image {
  width: 1150px;
  height: auto;
  display: block;
  object-fit: cover;
  border-radius: 0;
  box-shadow: none;
}
/* 3. 专家视频区 */
.video-section {
  padding: 4rem 2rem;
  background: linear-gradient(to bottom, #f8f9fa, #ffffff);
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
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 6px 24px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid #E8E8E8;
  width: 100%;
}

.video-card:hover {
  transform: translateY(-8px) scale(1.01);
  box-shadow: 0 12px 40px rgba(139, 115, 85, 0.2);
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
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
  color: #667eea;
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

.video-info {
  padding: 2rem;
  text-align: center;
}

.video-meta {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 0.75rem;
  gap: 1rem;
}

.video-speaker {
  color: #8B7355;
  font-size: 0.9rem;
  font-weight: 600;
}

.video-views {
  color: #999;
  font-size: 0.85rem;
}

.video-title {
  font-size: 1.5rem;
  font-weight: 700;
  margin: 0 0 1rem 0;
  line-height: 1.4;
  color: #333;
}

.video-description {
  color: #666;
  font-size: 1.1rem;
  line-height: 1.6;
  margin-bottom: 1.5rem;
}

.video-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.6rem;
  justify-content: center;
}

.tag {
  background: #F5F1E8;
  color: #8B7355;
  padding: 0.4rem 1rem;
  border-radius: 20px;
  font-size: 0.9rem;
  border: 1px solid #E8E8E8;
  transition: all 0.2s ease;
}

.tag:hover {
  background: #8B7355;
  color: white;
}

/* 4. 赏画图片区 */
.gallery-section {
  padding: 2rem 2rem 4rem;
  background: transparent;
}

.gallery-container {
  max-width: 1200px;
  margin: 0 auto;
}

/* 仿古籍多宫格布局 */
.ancient-book-layout {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-auto-rows: minmax(150px, auto);
  gap: 8px;
  padding: 8px;
  background: #EDE5D8; /* 深一点的宣纸色，形成书页感 */
  border: 2px solid #D4C4B0; /* 书页边框 */
}

.calligraphy-area {
  position: relative;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid #D4C4B0; /* 区域间缝隙 */
  background: #F5F1E8; /* 宣纸色 */
}

.calligraphy-area:hover {
  transform: scale(1.02);
  box-shadow: 0 4px 12px rgba(139, 115, 85, 0.2);
  z-index: 10;
}

/* 不同大小的区域 */
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
}

.calligraphy-placeholder::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image:
    repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(139, 115, 85, 0.03) 2px),
    repeating-linear-gradient(90deg, transparent, transparent 2px, rgba(139, 115, 85, 0.03) 2px);
  pointer-events: none;
}

.calligraphy-text {
  text-align: center;
  padding: 1rem;
  z-index: 1;
}

.calligraphy-text h3 {
  font-family: 'Noto Serif SC', 'STSong', 'SimSun', serif;
  font-size: 1.8rem;
  font-weight: 700;
  color: #8B7355;
  margin: 0 0 0.5rem 0;
  letter-spacing: 0.2rem;
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
}

.calligraphy-text p {
  font-family: 'Noto Serif SC', 'STSong', 'SimSun', serif;
  font-size: 0.9rem;
  color: #A89880;
  margin: 0;
  font-style: italic;
}

/* 大型区域字体更大 */
.calligraphy-area.large .calligraphy-text h3 {
  font-size: 2.5rem;
}

.calligraphy-area.large .calligraphy-text p {
  font-size: 1.2rem;
}

/* 中型区域字体适中 */
.calligraphy-area.medium-wide .calligraphy-text h3,
.calligraphy-area.medium-tall .calligraphy-text h3 {
  font-size: 2rem;
}

.calligraphy-area.medium-wide .calligraphy-text p,
.calligraphy-area.medium-tall .calligraphy-text p {
  font-size: 1rem;
}

/* 小型区域字体较小 */
.calligraphy-area.small .calligraphy-text h3 {
  font-size: 1.2rem;
}

.calligraphy-area.small .calligraphy-text p {
  font-size: 0.8rem;
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

/* 页脚 */
.ci-footer {
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

/* 弹窗样式 */
.video-modal,
.painting-modal {
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
.ink-quote {
  margin-top: 2rem;
  font-family: 'STKaiti', 'KaiTi', 'Kaiti SC', 'Songti SC', serif;
  font-size: 2rem;
  line-height: 1.7;
  color: #1f1a17;
  letter-spacing: 0.04em;
  font-weight: 400;
}

.ink-poem {
  margin-top: 2rem;
}

.ink-poem-title {
  font-family: 'STKaiti', 'KaiTi', 'Kaiti SC', 'Songti SC', serif;
  font-size: 2.2rem;
  line-height: 1.5;
  color: #1f1a17;
  letter-spacing: 0.03em;
  margin-bottom: 1.2rem;
  font-weight: 400;
}

.ink-poem-lines {
  font-family: 'STKaiti', 'KaiTi', 'Kaiti SC', 'Songti SC', serif;
  font-size: 1.9rem;
  line-height: 1.9;
  color: #5f625d;
  letter-spacing: 0.02em;
  font-weight: 400;
}

.ink-poem-lines p {
  margin: 0 0 0.8rem 0;
  text-indent: 1.2em;
}
/* 响应式设计 */
@media (max-width: 768px) {
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

  .header-content {
    padding: 1rem;
  }

  .page-title h1 {
    font-size: 1.2rem;
  }

  .nav-text {
    display: none;
  }

  .calligraphy-char {
    font-size: 2.5rem;
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