<template>
  <div class="xiandaishi-page-container">
    <!-- 国风导航栏 -->
    <PoetryNavigation />

    <!-- 2. 多个长卷式内容分屏 -->
    <main class="xiandaishi-main-content" ref="mainContent">
       <!-- 现代诗3D卡片轮播 -->
      <section class="carousel-section" id="section-carousel">
        <CardCarousel :cards="poetryCards" />
      </section>

      <!-- 卷轴内容区域 -->
      <div class="scroll-sections-container">
        <!-- 卷一：现代诗的起源 -->
        <section class="scroll-section" id="section-origin">
          <div class="section-content">
          <div class="text-content">
            <div class="section-number">卷一</div>
            <h2 class="section-title">现代诗的起源</h2>
            <div class="section-desc">
              <p>中国现代诗起源于20世纪初的"五四"新文化运动，是对传统格律诗的革命性突破。胡适、鲁迅等人倡导白话文运动，开启了新诗纪元。</p>
              <p>现代诗打破了古诗严格的格律限制，采用白话文写作，形式自由，语言生动，更能反映现代人的生活与情感。</p>
            </div>
            <div class="highlight-box">
              <span class="highlight-text">"诗体大解放，是用白话文写诗，做新诗"</span>
            </div>
          </div>
          <div class="visual-content">
            <div class="new-culture">
              <div class="culture-placeholder">
                <span class="culture-icon">📚</span>
                <p>新文学运动</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- 卷二：新月派与象征派 -->
      <section class="scroll-section" id="section-schools">
        <div class="section-content reverse">
          <div class="visual-content">
            <div class="school-display">
              <div class="school-item">
                <div class="school-icon">🌙</div>
                <h3>新月派</h3>
                <p>格律新诗</p>
                <div class="school-desc">徐志摩、闻一多，追求音乐美</div>
              </div>
              <div class="school-item">
                <div class="school-icon">🎭</div>
                <h3>象征派</h3>
                <p>意象隐喻</p>
                <div class="school-desc">李金发、戴望舒，注重象征暗示</div>
              </div>
            </div>
          </div>
          <div class="text-content">
            <div class="section-number">卷二</div>
            <h2 class="section-title">新月派与象征派</h2>
            <div class="section-desc">
              <p>20世纪20-30年代，新月派代表人物徐志摩、闻一多等人提倡新诗格律化，追求诗歌的音乐美和建筑美。</p>
              <p>象征派诗人如李金发、戴望舒则受法国象征主义影响，注重意象的营造和情感暗示，开创了现代诗的新风格。</p>
            </div>
            <div class="poetry-excerpt">
              <div class="poem-title">《再别康桥》（节选）</div>
              <div class="poem-content">
                <p>轻轻的我走了，正如我轻轻的来；</p>
                <p>我轻轻的招手，作别西天的云彩。</p>
                <p>那河畔的金柳，是夕阳中的新娘；</p>
                <p>波光里的艳影，在我的心头荡漾。</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- 卷三：九叶派与当代诗歌 -->
      <section class="scroll-section" id="section-contemporary">
        <div class="section-content">
          <div class="text-content">
            <div class="section-number">卷三</div>
            <h2 class="section-title">九叶派与当代诗歌</h2>
            <div class="section-desc">
              <p>20世纪40年代，九叶派诗人如穆旦、郑敏等人融合现代主义与中国传统，探索诗歌的新表现手法。</p>
              <p>当代诗歌在80年代迎来"朦胧诗"热潮，北岛、顾城、海子等诗人以其独特的艺术风格影响了一代又一代读者。</p>
            </div>
            <div class="poetry-excerpt">
              <div class="poem-title">《面朝大海，春暖花开》（节选）</div>
              <div class="poem-content">
                <p>从明天起，做一个幸福的人</p>
                <p>喂马、劈柴，周游世界</p>
                <p>从明天起，关心粮食和蔬菜</p>
                <p>我有一所房子，面朝大海，春暖花开</p>
              </div>
            </div>
          </div>
          <div class="visual-content">
            <div class="modern-showcase">
              <div class="modern-card">
                <div class="modern-char">新</div>
                <p>创新表达</p>
              </div>
              <div class="modern-card">
                <div class="modern-char">真</div>
                <p>真挚情感</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- 3. 专家视频区 -->
      <section class="video-section" id="section-video" :style="{ backgroundImage: `url(${videoGalleryBgImg})`, backgroundSize: 'cover', backgroundPosition: 'center' }">
        <div class="section-header">
          <div class="calligraphy-title">
            <span class="calligraphy-char">说</span>
            <span class="calligraphy-char">诗</span>
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

      <!-- 4. 赏诗图片区 -->
      <section class="gallery-section" id="section-gallery" :style="{ backgroundImage: `url(${videoGalleryBgImg})`, backgroundSize: 'cover', backgroundPosition: 'center' }">
        <div class="section-header">
          <div class="calligraphy-title">
            <span class="calligraphy-char">赏</span>
            <span class="calligraphy-char">诗</span>
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
      <footer class="xiandaishi-footer">
        <div class="footer-content">
          <div class="footer-text">
            <p>现代诗是中国文学的崭新篇章</p>
            <p>自由创新，真挚表达，展现现代人的精神世界</p>
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
    </div><!-- 结束卷轴容器 -->
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
            <p>关联诗作：{{ currentPainting.relatedPoem }}</p>
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
import CardCarousel from '@/components/CardCarousel.vue'

const videoGalleryBgImg = new URL('@/assets/home1/shi/chouti/bg.jpg', import.meta.url).href

const router = useRouter()
const currentSection = ref(0)
const mainContent = ref(null)

// 现代诗卡片数据
const poetryCards = ref([
  {
    name: '康桥',
    location: '徐志摩',
    description: '轻轻的我走了，正如我轻轻的来；我轻轻的招手，作别西天的云彩。',
    image: new URL('@/assets/home1/xian/zhangailing.jpg', import.meta.url).href
  },
  {
    name: '雨巷',
    location: '戴望舒',
    description: '撑着油纸伞，独自彷徨在悠长、悠长又寂寥的雨巷。',
    image: new URL('@/assets/home1/xian/wenyiduo.jpg', import.meta.url).href
  },
  {
    name: '面朝大海',
    location: '海子',
    description: '从明天起，做一个幸福的人；喂马、劈柴，周游世界。',
    image: new URL('@/assets/home1/xian/haizi.jpg', import.meta.url).href
  }
])

// 视频数据配置
const videos = ref([
  {
    id: 1,
    title: '中国现代诗的发展历程——从新文化运动到当代',
    speaker: '洪子诚教授',
    description: '深入解析中国现代诗的发展历程、主要流派与代表诗人',
    category: '现代文学',
    views: '21.5万',
    tags: ['现代诗', '新诗', '文学史'],
    thumbnail: '',
    duration: '22:30',
    url: ''
  }
])

// 画作数据配置
const paintings = ref([
  {
    id: 1,
    title: '康桥图',
    artist: '徐悲鸿',
    era: '现代',
    dynasty: '民国',
    relatedPoem: '《再别康桥》',
    image: new URL('@/assets/home1/xian/shang/faith-PC01-81.jpg', import.meta.url).href,
    description: '剑桥大学康河风光，徐志摩诗歌中的经典场景'
  },
  {
    id: 2,
    title: '雨巷图',
    artist: '吴冠中',
    era: '现代',
    dynasty: '当代',
    relatedPoem: '《雨巷》',
    image: new URL('@/assets/home1/xian/shang/faith-PC02-90.jpg', import.meta.url).href,
    description: '江南雨巷的诗意表达，戴望舒笔下的朦胧意境'
  },
  {
    id: 3,
    title: '大海图',
    artist: '林风眠',
    era: '现代',
    dynasty: '当代',
    relatedPoem: '《面朝大海，春暖花开》',
    image: new URL('@/assets/home1/xian/shang/faith-PC03-59.jpg', import.meta.url).href,
    description: '海的辽阔与春的温暖，海子诗歌的理想境界'
  },
  {
    id: 4,
    title: '回答图',
    artist: '赵无极',
    era: '现代',
    dynasty: '当代',
    relatedPoem: '《回答》',
    image: new URL('@/assets/home1/xian/shang/faith-PC04-75.jpg', import.meta.url).href,
    description: '北岛诗歌中的抽象意境与精神力量'
  },
  {
    id: 5,
    title: '远和近图',
    artist: '朱德群',
    era: '现代',
    dynasty: '当代',
    relatedPoem: '《远和近》',
    image: new URL('@/assets/home1/xian/shang/faith-PC05-58.jpg', import.meta.url).href,
    description: '顾城诗歌中的哲学思考与视觉美感'
  },
  {
    id: 6,
    title: '一代人图',
    artist: '徐冰',
    era: '现代',
    dynasty: '当代',
    relatedPoem: '《一代人》',
    image: new URL('@/assets/home1/xian/shang/faith-PC06-61.jpg', import.meta.url).href,
    description: '黑夜与眼睛的意象，顾城诗歌的深刻内涵'
  },
  {
    id: 7,
    title: '断章图',
    artist: '蔡国强',
    era: '现代',
    dynasty: '当代',
    relatedPoem: '《断章》',
    image: new URL('@/assets/home1/xian/shang/faith-PC01-81.jpg', import.meta.url).href,
    description: '卞之琳诗歌中的相对论哲学与艺术表达'
  }
])

// 视频和弹窗状态
const showVideoModal = ref(false)
const showPaintingModal = ref(false)
const currentVideo = ref({})
const currentPainting = ref({})

// 章节配置
const sections = ref([
  { id: 'section-origin', title: '现代诗的起源' },
  { id: 'section-schools', title: '新月派与象征派' },
  { id: 'section-contemporary', title: '九叶派与当代诗歌' },
  { id: 'section-video', title: '名师讲堂' },
  { id: 'section-gallery', title: '诗画意境' }
])

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
/* 基础样式 */
.xiandaishi-page-container {
  width: 100%;
  min-height: 100vh;
  background: #F5F1E8;
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
  color: var(--text);
}

/* 主内容区 */
.xiandaishi-main-content {
  padding-top: 10px;
}

/* 轮播区域独立容器 */
.carousel-section {
  position: relative;
  width: 100%;
  height: 100vh;
  background: transparent;
  overflow: hidden;
  isolation: isolate;
}

/* 卷轴区域容器 */
.scroll-sections-container {
  background-color: #F5F1E8;
  background-image: url('@/assets/home1/xian/bg.png');
  background-size: contain;
  background-position: center top;
  background-repeat: no-repeat;
  background-attachment: fixed;
  position: relative;
  z-index: 1;
  box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.1);
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
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
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

.highlight-text {
  font-size: 1.2rem;
  font-style: italic;
  color: var(--text);
}

.poetry-excerpt {
  padding: 2rem;
  background: var(--bg1);
  border-radius: 12px;
  margin-top: 2rem;
}

.poem-title {
  font-size: 1.3rem;
  font-weight: 600;
  margin-bottom: 1rem;
  color: var(--text);
}

.poem-content {
  font-size: 1.1rem;
  line-height: 1.8;
  color: var(--muted);
}

.poem-content p {
  margin-bottom: 0.5rem;
  text-indent: 2em;
}

.visual-content {
  display: flex;
  justify-content: center;
  align-items: center;
}

.new-culture,
.school-display,
.modern-showcase {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.culture-placeholder,
.school-item,
.modern-card {
  background: white;
  padding: 2rem;
  text-align: center;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
  min-width: 200px;
}

.culture-icon,
.school-icon {
  font-size: 3rem;
  display: block;
  margin-bottom: 1rem;
}

.modern-char {
  font-family: 'Noto Serif SC', 'STSong', 'SimSun', serif;
  font-size: 3rem;
  font-weight: 700;
  color: #8B7355;
  margin-bottom: 0.5rem;
}

.school-item h3,
.modern-card h3 {
  font-size: 1.8rem;
  margin: 0.5rem 0;
  color: #333;
}

.school-item p,
.modern-card p {
  color: #666;
  font-size: 1rem;
  margin: 0;
}

.school-desc {
  margin-top: 0.5rem;
  font-size: 0.9rem;
  color: #999;
}

/* 3. 专家视频区 */
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

/* 4. 赏诗图片区 */
.gallery-section {
  padding: 2rem 2rem 4rem; /* 保持一致的padding */
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  position: relative;
}

/* 为赏诗section添加半透明遮罩层 */
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

/* 确保赏诗section的内容在遮罩层之上 */
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

/* 页脚 */
.xiandaishi-footer {
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