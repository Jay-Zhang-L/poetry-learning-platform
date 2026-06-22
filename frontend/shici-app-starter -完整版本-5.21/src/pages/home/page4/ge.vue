<template>
  <div class="ge-page-container">
    <!-- 国风导航栏 -->
    <PoetryNavigation />

    <!-- 2. 多个长卷式内容分屏 -->
    <main class="ge-main-content" ref="mainContent">

      <!-- 1.5 装饰性section -->
      <section class="ge-intro-section">
        <!-- 主视觉区域 -->
        <div class="main-visual-area">
          <!-- 红色圆形 + 文字 -->
          <div class="red-circle-main">
            <img :src="redCircleImg" alt="诗经印记" class="red-circle-img-main" />
            <div class="circle-text-content">
              <div class="poetry-text-line-1">
                <span
                  v-for="(char, index) in poetryChars1"
                  :key="'line1-' + index"
                  class="poetry-char"
                  :style="{ animationDelay: `${getRandomDelay()}s` }"
                >
                  {{ char }}
                </span>
              </div>
              <div class="poetry-text-line-2">
                <span
                  v-for="(char, index) in poetryChars2"
                  :key="'line2-' + index"
                  class="poetry-char"
                  :style="{ animationDelay: `${getRandomDelay()}s` }"
                >
                  {{ char }}
                </span>
              </div>
            </div>
          </div>

          <!-- 祥云托圆 -->
          <div class="cloud-support-container">
            <img :src="yellowCloudImg" alt="祥云" class="cloud-support-img" />
          </div>

          <!-- 右侧人物 -->
          <div class="right-figure-container">
            <img :src="leftFigureImg" alt="古诗人物" class="right-figure-img" />
          </div>
        </div>

        <!-- 底部通栏说明文字区域 -->
        <div class="bottom-description-area">
          <div class="description-content-text">
            <div
              v-for="(line, lineIndex) in descriptionLines"
              :key="'line-' + lineIndex"
              class="description-line"
            >
              <span
                v-for="(char, index) in getLineChars(line)"
                :key="'line-' + lineIndex + '-char-' + index"
                class="desc-text-char"
              >
                {{ char }}
              </span>
            </div>
          </div>
        </div>
      </section>

      <!-- 卷一、卷二、卷三的大容器 -->
      <div class="chapters-container">
        <!-- 卷一：歌的起源 -->
        <section class="scroll-section" id="section-origin" style="margin-top: -600px;">
          <div class="section-content">
            <div class="text-content">
              <div class="section-number">卷一</div>
              <h2 class="section-title">歌的起源</h2>
              <div class="section-desc">
                <p>歌，即古诗，是中国古代诗歌的重要形式。它起源于原始社会的劳动歌谣，发展于先秦时期，兴盛于汉唐。</p>
                <p>古代歌曲与音乐密不可分，诗乐合一，既是文学作品，也是音乐作品，体现了古人的艺术审美。</p>
              </div>
              <div class="highlight-box">
                <span class="highlight-text">"歌者，心声也；乐者，心语也"</span>
              </div>
            </div>
            <div class="visual-content">
              <div class="ancient-performance">
                <div class="performance-placeholder">
                  <img :src="shijingDoujiangtuGif" alt="古乐表演" class="performance-gif" />
                </div>
              </div>
            </div>
          </div>

          <!-- 动图下方的栏杆装饰 -->
          <div class="langan-decoration">
            <img :src="shijingLanganImg" alt="诗经栏杆" class="langan-img" />
          </div>
        </section>
          <!-- 左上角村庄装饰图片 -->
          <div class="cunzhuang-decoration">
            <img :src="shijingCunzhuangImg" alt="诗经村庄" class="cunzhuang-img" />
          </div>

        <!-- 卷二：乐府民歌 -->
        <section class="scroll-section" id="section-yuefu">
          <div class="section-content reverse">
            <div class="text-content">
              <div class="section-number">卷二</div>
              <h2 class="section-title">乐府民歌</h2>
              <div class="section-desc">
                <p>乐府是汉代设立的音乐机构，负责搜集民间歌谣和制定乐谱。乐府诗真实反映了当时社会的方方面面。</p>
                <p>《孔雀东南飞》、《木兰诗》等乐府名篇，至今仍是中国文学史上的经典之作。</p>
              </div>
              <div class="poetry-excerpt">
                <div class="poem-title">《孔雀东南飞》</div>
                <div class="poem-content">
                  <p>孔雀东南飞，五里一徘徊。</p>
                  <p>十三能织素，十四学裁衣。</p>
                  <p>十五弹箜篌，十六诵诗书。</p>
                  <p>十七为君妇，心中常苦悲。</p>
                </div>
              </div>
            </div>
          </div>

          <!-- 卷二左侧栏杆装饰 -->
          <div class="langan-left-decoration">
            <img :src="shijingLangan2Img" alt="诗经栏杆" class="langan-left-img" />
          </div>

          <!-- part3_top图片装饰 -->
          <div class="part3-top-decoration">
            <img :src="part3TopImg" alt="part3顶部装饰" class="part3-top-img" />
          </div>
        </section>

        <!-- 卷三：琴歌与吟诵 -->
        <section class="scroll-section" id="section-qinge">
          <div class="section-content">
            <div class="text-content">
              <div class="section-number">卷三</div>
              <h2 class="section-title">琴歌与吟诵</h2>
              <div class="section-desc">
                <p>琴歌是古代诗词与音乐结合的最高形式，以古琴伴奏，吟诵诗词。文人雅士常以琴歌抒发情怀。</p>
                <p>吟诵是古典诗词的传统读法，讲究声调韵律，体现诗词的音乐美和节奏美。</p>
              </div>
              <div class="poetry-excerpt">
                <div class="poem-title">《阳关三叠》</div>
                <div class="poem-content">
                  <p>渭城朝雨浥轻尘，客舍青青柳色新。</p>
                  <p>劝君更尽一杯酒，西出阳关无故人。</p>
                </div>
              </div>
            </div>
            <div class="visual-content">
              <div class="instrument-showcase">
                <div class="instrument-card">
                  <div class="instrument-char">琴</div>
                  <p>古琴伴奏</p>
                </div>
                <div class="instrument-card">
                  <div class="instrument-char">吟</div>
                  <p>诗词吟诵</p>
                </div>
              </div>
            </div>
          </div>

          <!-- 卷三右下角书籍装饰 -->
          <div class="shu-decoration">
            <img :src="shijingShuImg" alt="诗经书籍" class="shu-img" />
          </div>
        </section>
      </div>

      <!-- 3. 专家视频区 -->
      <section class="video-section" id="section-video" :style="{ backgroundImage: `url(${videoGalleryBgImg})`, backgroundSize: 'cover', backgroundPosition: 'center' }">
        <div class="section-header">
          <div class="calligraphy-title">
            <span class="calligraphy-char">说</span>
            <span class="calligraphy-char">歌</span>
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

      <!-- 4. 赏歌图片区 -->
      <section class="gallery-section" id="section-gallery" :style="{ backgroundImage: `url(${videoGalleryBgImg})`, backgroundSize: 'cover', backgroundPosition: 'center' }">
        <div class="section-header">
          <div class="calligraphy-title">
            <span class="calligraphy-char">赏</span>
            <span class="calligraphy-char">歌</span>
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
      <footer class="ge-footer">
        <div class="footer-content">
          <div class="footer-text">
            <p>歌是诗词与音乐的完美结合</p>
            <p>从劳动号子到艺术雅乐，展现中国音乐文学的魅力</p>
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
            <p>关联歌谣：{{ currentPainting.relatedSong }}</p>
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

const router = useRouter()
const currentSection = ref(0)
const mainContent = ref(null)

// 装饰性section图片资源导入
const redCircleImg = new URL('@/assets/home1/ge/juan/shijing_hongquan.png', import.meta.url).href
const yellowCloudImg = new URL('@/assets/home1/ge/juan/shijing_yun.png', import.meta.url).href
const leftFigureImg = new URL('@/assets/home1/ge/juan/genv.png', import.meta.url).href
const part3BgImg = new URL('@/assets/home1/ge/tuceng2.jpg', import.meta.url).href
const part4BgImg = new URL('@/assets/home1/ge/part4Bg.jpg', import.meta.url).href
const videoGalleryBgImg = new URL('@/assets/home1/shi/chouti/bg.jpg', import.meta.url).href

// 视频资源导入
const geVideoUrl = new URL('@/assets/home1/ge/vedio/ge.mp4', import.meta.url).href
const geVideoThumbnail = new URL('@/assets/home1/ge/vedio/ge-fm.jpg', import.meta.url).href
const shijingCunzhuangImg = new URL('@/assets/home1/ge/zuoyoutiantu/shijing_cunzhuang.png', import.meta.url).href
const shijingDoujiangtuGif = new URL('@/assets/home1/ge/zuoyoutiantu/shijing_doujiangtu.gif', import.meta.url).href
const shijingLanganImg = new URL('@/assets/home1/ge/shijing_langan.png', import.meta.url).href

// 装饰性section描述文字
const descriptionText = ref('从《诗经》的先民吟唱，到《木兰诗》的巾帼传奇，再到《琵琶行》的千古共情，歌以其「感于哀乐，缘事而发」的特质，记录着时代的风貌与人心的温度，是中国文学史上永不落幕的声音。')

// 将文字拆分为字符数组
const descriptionChars = ref([])

// 将描述文字按换行符分为两行
const descriptionLines = ref([])

const shijingShuImg = new URL('@/assets/home1/ge/zuoyoutiantu/shijing_shu.png', import.meta.url).href
// 圆形内文字逐字显示
const poetryText1 = ref('【诗言志  歌永言')
const shijingLangan2Img = new URL('@/assets/home1/ge/zuoyoutiantu/liuLiTangTree.png', import.meta.url).href
const poetryText2 = ref('声依永  律和声】')
const part3TopImg = new URL('@/assets/home1/ge/part3_top.png', import.meta.url).href
const poetryChars1 = ref([])
const poetryChars2 = ref([])

// 随机延迟函数
function getRandomDelay() {
  return Math.random() * 1.5
}

// 获取每行的字符数组
function getLineChars(line) {
  return line.split('')
}

// 背景图片配置
const sectionBgs = ref([
  '',
  '',
  ''
])

// 视频数据配置
const videos = ref([
  {
    id: 1,
    title: '乐府诗的艺术魅力——民间歌谣的文学价值',
    speaker: '赵逵夫教授',
    description: '深入解析乐府诗的艺术特色与文化内涵，感受民间文学的魅力',
    category: '诗词赏析',
    views: '14.5万',
    tags: ['乐府', '民歌', '古典音乐'],
    thumbnail: geVideoThumbnail,
    duration: '16:30',
    url: geVideoUrl
  }
])

// 画作数据配置
const paintings = ref([
  {
    id: 1,
    title: '乐府图',
    artist: '顾恺之',
    era: '东晋',
    dynasty: '晋代',
    relatedSong: '《孔雀东南飞》',
    image: new URL('@/assets/home1/ge/shang/market-PC01-36.jpg', import.meta.url).href,
    description: '描绘乐府诗中的经典场景，展现古代爱情悲剧'
  },
  {
    id: 2,
    title: '琴歌图',
    artist: '仇英',
    era: '明代',
    dynasty: '明代',
    relatedSong: '《阳关三叠》',
    image: new URL('@/assets/home1/ge/shang/market-PC02-1.jpg', import.meta.url).href,
    description: '古琴伴奏，诗词吟诵的文人雅集场景'
  },
  {
    id: 3,
    title: '木兰从军图',
    artist: '唐寅',
    era: '明代',
    dynasty: '明代',
    relatedSong: '《木兰诗》',
    image: new URL('@/assets/home1/ge/shang/market-PC03-84.jpg', import.meta.url).href,
    description: '巾帼英雄木兰替父从军的英勇形象'
  },
  {
    id: 4,
    title: '陌上桑图',
    artist: '沈周',
    era: '明代',
    dynasty: '明代',
    relatedSong: '《陌上桑》',
    image: new URL('@/assets/home1/ge/shang/market-PC04-14.jpg', import.meta.url).href,
    description: '罗敷采桑的场景，展现古代女性形象'
  },
  {
    id: 5,
    title: '十五从军征图',
    artist: '文征明',
    era: '明代',
    dynasty: '明代',
    relatedSong: '《十五从军征》',
    image: new URL('@/assets/home1/ge/shang/market-PC06-95.jpg', import.meta.url).href,
    description: '老兵回乡的凄凉景象，反映战争对人民的伤害'
  },
  {
    id: 6,
    title: '有所思图',
    artist: '董其昌',
    era: '明代',
    dynasty: '明代',
    relatedSong: '《有所思》',
    image: new URL('@/assets/home1/ge/shang/1.jpg', import.meta.url).href,
    description: '女子思念情人的细腻情感表达'
  },
  {
    id: 7,
    title: '上邪图',
    artist: '陈洪绶',
    era: '明代',
    dynasty: '明代',
    relatedSong: '《上邪》',
    image: new URL('@/assets/home1/ge/shang/2.jpg', import.meta.url).href,
    description: '热烈爱情誓言的艺术表达'
  }
])

// 视频和弹窗状态
const showVideoModal = ref(false)
const showPaintingModal = ref(false)
const currentVideo = ref({})
const currentPainting = ref({})

// 章节配置
const sections = ref([
  { id: 'section-origin', title: '歌的起源' },
  { id: 'section-yuefu', title: '乐府民歌' },
  { id: 'section-qinge', title: '琴歌与吟诵' },
  { id: 'section-video', title: '名师讲堂' },
  { id: 'section-gallery', title: '歌画意境' }
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
  // 将描述文字拆分为字符
  descriptionChars.value = descriptionText.value.split('')

  // 将描述文字按换行符分为两行
  descriptionLines.value = descriptionText.value.split('<br>')

  // 将圆形内文字拆分为字符
  poetryChars1.value = poetryText1.value.split('')
  poetryChars2.value = poetryText2.value.split('')
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
/* 基础样式 */
.ge-page-container {
  width: 100%;
  min-height: 100vh;
  background: #F5F1E8;
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
  color: var(--text);
}

/* 主内容区 */
.ge-main-content {
  padding-top: 0; /* 移除padding，消除导航栏与装饰性section之间的空白间隙 */
}

/* 1.5 装饰性section - 重构版本 */
.ge-intro-section {
  position: relative;
  width: 100%;
  min-height: 100vh;
  background: #1a1a1a; /* 恢复原来的背景色 */
  overflow: hidden;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  align-items: center;
  padding: 0;
  margin-bottom: 0;
}

/* 主视觉区域 */
.main-visual-area {
  position: relative;
  flex: 1;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* 红色圆形主元素 - 重构 */
.red-circle-main {
  position: absolute;
  left: 22%;
  top: 50%;
  transform: translateY(-50%);
  width: 29.4vw;
  height: 29.4vw;
  max-width: 31.5vw;
  max-height: 31.5vw;
  z-index: 1;
}

.red-circle-img-main {
  width: 100%;
  height: 100%;
  object-fit: contain;
  background: transparent;
}

/* 圆形内文字内容 - 重构 */
.circle-text-content {
  position: absolute;
  top: 42%;
  left: 50%;
  transform: translate(-50%, -50%);
  text-align: center;
  color: #F5E7C3;
  font-family: 'STSong', 'SimSun', '宋体', serif;
  width: 100%;
  padding: 0 2rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.poetry-text-line-1 {
  font-size: 1.8vw;
  font-weight: 600;
  letter-spacing: 0.2em;
  line-height: 1.5;
}

.poetry-text-line-2 {
  font-size: 1.8vw;
  letter-spacing: 0.2em;
  line-height: 1.5;
}

.poetry-char {
  display: inline-block;
  opacity: 0;
  animation: randomCharFadeIn 0.8s ease-out forwards;
}

.poetry-text-divider {
  display: inline-block;
  width: 1em;
}

.poetry-char {
  display: inline-block;
  opacity: 0;
  animation: randomCharFadeIn 0.8s ease-out forwards;
  position: relative;
  font-weight: 700;
  text-shadow:
    0 0 8px rgba(245, 231, 195, 0.6),
    0 1px 2px rgba(0, 0, 0, 0.9),
    1px 1px 0 rgba(0, 0, 0, 0.3),
    -1px -1px 0 rgba(255, 255, 255, 0.1);
  padding: 0 0.1em;
}

.poetry-text-divider {
  display: inline-block;
  width: 1em;
}

/* 祥云托圆 - 重构 */
.cloud-support-container {
  position: absolute;
  left: 19%;
  top: 60%;
  transform: translateY(-50%);
  width: 33.6vw;
  z-index: 2;
  opacity: 0.9;
  pointer-events: none;
}

.cloud-support-img {
  width: 100%;
  height: auto;
  object-fit: contain;
  opacity: 0.9;
}

/* 右侧人物 - 重构 */
.right-figure-container {
  position: absolute;
  left: calc(20% + 29.4vw - 2vw);
  top: 52%;
  transform: translateY(-50%);
  width: 26vw;
  height: auto;
  z-index: 3;
  animation: figureFloatAnimation 4s ease-in-out infinite;
}

.right-figure-img {
  width: 100%;
  height: auto;
  object-fit: contain;
  filter: drop-shadow(0 10px 40px rgba(0, 0, 0, 0.8)) sepia(0.3) contrast(1.1);
  mask-image: linear-gradient(to right, transparent 0%, rgba(0,0,0,1) 10%);
  -webkit-mask-image: linear-gradient(to right, transparent 0%, rgba(0,0,0,1) 10%);
}

/* 动画效果 */
@keyframes figureFloatAnimation {
  0%, 100% {
    transform: translateY(-50%) translateX(0);
  }
  50% {
    transform: translateY(-55%) translateX(0);
  }
}

@keyframes randomCharFadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes figureFadeInMain {
  from {
    opacity: 0;
    transform: translateY(-50%) translateX(30px);
  }
  to {
    opacity: 1;
    transform: translateY(-50%) translateX(0);
  }
}

/* 底部通栏说明文字区域 - 重构 */
.bottom-description-area {
  position: relative;
  width: 100%;
  padding: 3rem 5% 5%;
  z-index: 3;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 20vh;
}

.description-content-text {
  font-size: 1rem;
  line-height: 1.8;
  color: #D4AF37;
  font-family: 'PingFang SC', 'Microsoft YaHei', 'SimHei', '黑体', sans-serif;
  text-align: center;
  letter-spacing: 0.8px;
  max-width: 90vw;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 1rem;
}

.description-line {
  display: block;
  width: 100%;
}

.desc-text-char {
  display: inline-block;
  opacity: 1;
  transition: color 0.3s ease;
}

.desc-text-char:hover {
  color: #F5E7C3;
  text-shadow: 0 0 10px rgba(245, 231, 195, 0.5);
}

.desc-text-char:hover {
  color: #F5E7C3;
  text-shadow: 0 0 15px rgba(245, 231, 195, 0.5);
}

@keyframes descCharFadeIn {
  from {
    opacity: 0;
    transform: translateY(5px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 卷一、卷二、卷三的大容器 */
.chapters-container {
  position: relative;
  width: 100%;
  min-height: calc(300vh + 200px); /* 三个section高度 + 600px空白 + 300px偏移 */
  background-image: url('@/assets/home1/ge/tuceng2.jpg'); /* 使用路径字符串 */
  background-size: 100% auto; /* 宽度100%，高度自动，完整显示图片 */
  background-position: top center; /* 从图片最上方开始 */
  background-repeat: repeat-y; /* 垂直方向重复，确保覆盖整个区域 */
  padding-top: 600px; /* 在顶部添加600px空白区域，对应卷二和卷三的下移 */
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
/* 卷一特定样式 */
/* 卷一卷二卷三文字古风优化 */
#section-origin .section-number,
#section-yuefu .section-number,
#section-qinge .section-number {
  color: #8B7355;
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  font-weight: 600;
  letter-spacing: 0.3em;
}

#section-origin .section-title,
#section-yuefu .section-title,
#section-qinge .section-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #4A4A4A; /* 灰黑色 */
  text-shadow: 2px 2px 4px rgba(44, 44, 44, 0.1);
  letter-spacing: 0.1em;
}

#section-origin .section-desc,
#section-yuefu .section-desc,
#section-qinge .section-desc {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #000000;
  line-height: 2;
  letter-spacing: 0.1em;
}

#section-origin .highlight-text,
#section-yuefu .highlight-text,
#section-qinge .highlight-text {
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  color: #8B4513;
}

#section-origin .poem-title,
#section-yuefu .poem-title,
#section-qinge .poem-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #8B7355;
}

#section-origin .poem-content,
#section-yuefu .poem-content,
#section-qinge .poem-content {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #4A4A4A; /* 灰黑色 */
  line-height: 2;
}
/* 卷一卷二卷三文字古风优化 */
#section-origin .section-number,
#section-yuefu .section-number,
#section-qinge .section-number {
  color: #8B7355;
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  font-weight: 600;
  letter-spacing: 0.3em;
}

#section-origin .section-title,
#section-yuefu .section-title,
#section-qinge .section-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #4A4A4A; /* 灰黑色 */
  text-shadow: 2px 2px 4px rgba(44, 44, 44, 0.1);
  letter-spacing: 0.1em;
}

#section-origin .section-desc,
#section-yuefu .section-desc,
#section-qinge .section-desc {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #000000;
  line-height: 2;
  letter-spacing: 0.1em;
}

#section-origin .highlight-text,
#section-yuefu .highlight-text,
#section-qinge .highlight-text {
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  color: #8B4513;
}

#section-origin .poem-title,
#section-yuefu .poem-title,
#section-qinge .poem-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #8B7355;
}

#section-origin .poem-content,
#section-yuefu .poem-content,
#section-qinge .poem-content {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #4A4A4A; /* 灰黑色 */
  line-height: 2;
}
/* 卷一卷二卷三文字古风优化 */
#section-origin .section-number,
#section-yuefu .section-number,
#section-qinge .section-number {
  color: #8B7355;
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  font-weight: 600;
  letter-spacing: 0.3em;
}

#section-origin .section-title,
#section-yuefu .section-title,
#section-qinge .section-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #4A4A4A; /* 灰黑色 */
  text-shadow: 2px 2px 4px rgba(44, 44, 44, 0.1);
  letter-spacing: 0.1em;
}

#section-origin .section-desc,
#section-yuefu .section-desc,
#section-qinge .section-desc {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #000000;
  line-height: 2;
  letter-spacing: 0.1em;
}

#section-origin .highlight-text,
#section-yuefu .highlight-text,
#section-qinge .highlight-text {
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  color: #8B4513;
}

#section-origin .poem-title,
#section-yuefu .poem-title,
#section-qinge .poem-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #8B7355;
}

#section-origin .poem-content,
#section-yuefu .poem-content,
#section-qinge .poem-content {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #4A4A4A; /* 灰黑色 */
  line-height: 2;
}

/* 卷一卷二卷三文字古风优化 */
#section-origin .section-number,
#section-yuefu .section-number,
#section-qinge .section-number {
  color: #8B7355;
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  font-weight: 600;
  letter-spacing: 0.3em;
}

#section-origin .section-title,
#section-yuefu .section-title,
#section-qinge .section-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #4A4A4A; /* 灰黑色 */
  text-shadow: 2px 2px 4px rgba(44, 44, 44, 0.1);
  letter-spacing: 0.1em;
}

#section-origin .section-desc,
#section-yuefu .section-desc,
#section-qinge .section-desc {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #000000;
  line-height: 2;
  letter-spacing: 0.1em;
}

#section-origin .highlight-text,
#section-yuefu .highlight-text,
#section-qinge .highlight-text {
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  color: #8B4513;
}

#section-origin .poem-title,
#section-yuefu .poem-title,
#section-qinge .poem-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #8B7355;
}

#section-origin .poem-content,
#section-yuefu .poem-content,
#section-qinge .poem-content {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #4A4A4A; /* 灰黑色 */
  line-height: 2;
}
#section-origin .visual-content,
/* 卷一卷二卷三文字古风优化 */
#section-origin .section-number,
#section-yuefu .section-number,
#section-qinge .section-number {
  color: #8B7355;
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  font-weight: 600;
  letter-spacing: 0.3em;
}

#section-origin .section-title,
#section-yuefu .section-title,
#section-qinge .section-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #4A4A4A; /* 灰黑色 */
  text-shadow: 2px 2px 4px rgba(44, 44, 44, 0.1);
  letter-spacing: 0.1em;
}

#section-origin .section-desc,
#section-yuefu .section-desc,
#section-qinge .section-desc {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #000000;
  line-height: 2;
  letter-spacing: 0.1em;
}

#section-origin .highlight-text,
#section-yuefu .highlight-text,
#section-qinge .highlight-text {
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  color: #8B4513;
}

#section-origin .poem-title,
#section-yuefu .poem-title,
#section-qinge .poem-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #8B7355;
}

#section-origin .poem-content,
#section-yuefu .poem-content,
#section-qinge .poem-content {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #4A4A4A; /* 灰黑色 */
  line-height: 2;
}
#section-origin .performance-placeholder {
  margin-top: 20px;
  padding: 0;
}

/* 卷一文字盒子样式 */
#section-origin .text-content {
  padding: 2rem;
  border-radius: 12px;
  margin-left: 350px; /* 向右移动50px (300+50) */
  margin-top: 70px !important; /* 向下调整70px，确保成功移动 */
  width: 600px;
}

/* 卷二文字盒子样式 */
#section-yuefu .text-content {
  padding: 2rem;
  border-radius: 12px;
  margin-left: -30px; /* 向右移动20px (-50+20) */
  width: 600px;
  background: transparent;
  backdrop-filter: none;
  box-shadow: none;
}

/* 卷三文字盒子样式 */
#section-qinge .text-content {
  padding: 2rem;
  border-radius: 12px;
  margin-left: 130px; /* 向右移动50px (80+50) */
  width: 600px;
  background: transparent;
  backdrop-filter: none;
  box-shadow: none;
}

/* 卷三整个section-content向右移动20px */
#section-qinge .section-content {
  margin-left: 20px !important; /* 向右移动20px */
  transform: translateX(20px); /* 双重保险，使用transform */
}
/* 卷一卷二卷三文字古风优化 */
#section-origin .section-number,
#section-yuefu .section-number,
#section-qinge .section-number {
  color: #8B7355;
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  font-weight: 600;
  letter-spacing: 0.3em;
}

#section-origin .section-title,
#section-yuefu .section-title,
#section-qinge .section-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #4A4A4A; /* 灰黑色 */
  text-shadow: 2px 2px 4px rgba(44, 44, 44, 0.1);
  letter-spacing: 0.1em;
}

#section-origin .section-desc,
#section-yuefu .section-desc,
#section-qinge .section-desc {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #000000;
  line-height: 2;
  letter-spacing: 0.1em;
}

#section-origin .highlight-text,
#section-yuefu .highlight-text,
#section-qinge .highlight-text {
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  color: #8B4513;
}

#section-origin .poem-title,
#section-yuefu .poem-title,
#section-qinge .poem-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #8B7355;
}

#section-origin .poem-content,
#section-yuefu .poem-content,
#section-qinge .poem-content {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #4A4A4A; /* 灰黑色 */
  line-height: 2;
}
/* 卷一卷二卷三文字古风优化 */
#section-origin .section-number,
#section-yuefu .section-number,
#section-qinge .section-number {
  color: #8B7355;
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  font-weight: 600;
  letter-spacing: 0.3em;
}

#section-origin .section-title,
#section-yuefu .section-title,
#section-qinge .section-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #4A4A4A; /* 灰黑色 */
  text-shadow: 2px 2px 4px rgba(44, 44, 44, 0.1);
  letter-spacing: 0.1em;
}

#section-origin .section-desc,
#section-yuefu .section-desc,
#section-qinge .section-desc {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #000000;
  line-height: 2;
  letter-spacing: 0.1em;
}

#section-origin .highlight-text,
#section-yuefu .highlight-text,
#section-qinge .highlight-text {
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  color: #8B4513;
}

#section-origin .poem-title,
#section-yuefu .poem-title,
#section-qinge .poem-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #8B7355;
}

#section-origin .poem-content,
#section-yuefu .poem-content,
#section-qinge .poem-content {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #4A4A4A; /* 灰黑色 */
  line-height: 2;
}
/* 卷一卷二卷三文字古风优化 */
#section-origin .section-number,
#section-yuefu .section-number,
#section-qinge .section-number {
  color: #8B7355;
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  font-weight: 600;
  letter-spacing: 0.3em;
}

#section-origin .section-title,
#section-yuefu .section-title,
#section-qinge .section-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #4A4A4A; /* 灰黑色 */
  text-shadow: 2px 2px 4px rgba(44, 44, 44, 0.1);
  letter-spacing: 0.1em;
}

#section-origin .section-desc,
#section-yuefu .section-desc,
#section-qinge .section-desc {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #000000;
  line-height: 2;
  letter-spacing: 0.1em;
}

#section-origin .highlight-text,
#section-yuefu .highlight-text,
#section-qinge .highlight-text {
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  color: #8B4513;
}

#section-origin .poem-title,
#section-yuefu .poem-title,
#section-qinge .poem-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #8B7355;
}

#section-origin .poem-content,
#section-yuefu .poem-content,
#section-qinge .poem-content {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #4A4A4A; /* 灰黑色 */
  line-height: 2;
}
/* 卷一卷二卷三文字古风优化 */
#section-origin .section-number,
#section-yuefu .section-number,
#section-qinge .section-number {
  color: #8B7355;
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  font-weight: 600;
  letter-spacing: 0.3em;
}

#section-origin .section-title,
#section-yuefu .section-title,
#section-qinge .section-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #4A4A4A; /* 灰黑色 */
  text-shadow: 2px 2px 4px rgba(44, 44, 44, 0.1);
  letter-spacing: 0.1em;
}

#section-origin .section-desc,
#section-yuefu .section-desc,
#section-qinge .section-desc {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #000000;
  line-height: 2;
  letter-spacing: 0.1em;
}

#section-origin .highlight-text,
#section-yuefu .highlight-text,
#section-qinge .highlight-text {
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  color: #8B4513;
}

#section-origin .poem-title,
#section-yuefu .poem-title,
#section-qinge .poem-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #8B7355;
}

#section-origin .poem-content,
#section-yuefu .poem-content,
#section-qinge .poem-content {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #4A4A4A; /* 灰黑色 */
  line-height: 2;
}
/* 卷一卷二卷三文字古风优化 */
#section-origin .section-number,
#section-yuefu .section-number,
#section-qinge .section-number {
  color: #8B7355;
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  font-weight: 600;
  letter-spacing: 0.3em;
}

#section-origin .section-title,
#section-yuefu .section-title,
#section-qinge .section-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #4A4A4A; /* 灰黑色 */
  text-shadow: 2px 2px 4px rgba(44, 44, 44, 0.1);
  letter-spacing: 0.1em;
}

#section-origin .section-desc,
#section-yuefu .section-desc,
#section-qinge .section-desc {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #000000;
  line-height: 2;
  letter-spacing: 0.1em;
}

#section-origin .highlight-text,
#section-yuefu .highlight-text,
#section-qinge .highlight-text {
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  color: #8B4513;
}

#section-origin .poem-title,
#section-yuefu .poem-title,
#section-qinge .poem-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #8B7355;
}

#section-origin .poem-content,
#section-yuefu .poem-content,
#section-qinge .poem-content {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #0c0c0c; /* 灰黑色 */
  line-height: 2;
}
/* 卷一卷二卷三文字古风优化 */
#section-origin .section-number,
#section-yuefu .section-number,
#section-qinge .section-number {
  color: #8B7355;
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  font-weight: 600;
  letter-spacing: 0.3em;
}

#section-origin .section-title,
#section-yuefu .section-title,
#section-qinge .section-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #4A4A4A; /* 灰黑色 */
  text-shadow: 2px 2px 4px rgba(44, 44, 44, 0.1);
  letter-spacing: 0.1em;
}

#section-origin .section-desc,
#section-yuefu .section-desc,
#section-qinge .section-desc {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #000000;
  line-height: 2;
  letter-spacing: 0.1em;
}

#section-origin .highlight-text,
#section-yuefu .highlight-text,
#section-qinge .highlight-text {
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  color: #8B4513;
}

#section-origin .poem-title,
#section-yuefu .poem-title,
#section-qinge .poem-title {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  color: #8B7355;
}

#section-origin .poem-content,
#section-yuefu .poem-content,
#section-qinge .poem-content {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  color: #4A4A4A; /* 灰黑色 */
  line-height: 2;
}

#section-origin .performance-placeholder { margin-top: 20px;
  padding: 0;
}
/* 左上角村庄装饰图片 */
.cunzhuang-decoration {
  position: absolute;
  top: calc(100vh - 600px - 200px - 200px + 10px + 5px); /* 向下移动5px */
  left: 0;
  width: 27vw;
  z-index: 10;
  pointer-events: none;
}

.cunzhuang-img {
  width: 100%;
  height: auto;
  object-fit: contain;
  display: block;
}

/* 动图下方栏杆装饰 */
.langan-decoration {
  position: absolute;
  bottom: -100px;
  left: 0;
  width: 100vw;
  z-index: 5;
  pointer-events: none;
}
/* 卷二左侧栏杆装饰 */
.langan-left-decoration {
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 36vw;
  z-index: 5;
  pointer-events: none;
}

/* part3_top图片装饰 */
.part3-top-decoration {
  position: absolute;
  left: calc(36vw - 120px); /* 向左移动120px */
  bottom: calc(0px - 20px); /* 向下移动20px */
  transform: translateY(-50%);
  width: auto;
  height: 30vh;
  z-index: 5;
  pointer-events: none;
}

.part3-top-img {
/* 卷三右下角书籍装饰 */
.shu-decoration {
  position: absolute;
  bottom: 0;
  right: -80px; /* 配合section-content向右移动20px (-60-20) */
  width: 10vw;
  z-index: 5;
  pointer-events: none;
}

.shu-img {
  width: 100%;
  height: auto;
  object-fit: contain;
  display: block;
}
  width: auto;
  height: 100%;
  object-fit: contain;
  display: block;
}
.langan-left-img {
  width: 100%;
  height: auto;
  object-fit: contain;
  display: block;
}

.langan-img {
  width: 100%;
  height: auto;
  object-fit: contain;
  display: block;
}


.section-bg {
  position: absolute;
  top: 40px;
  left: 0;
  right: 0;
  bottom: 0;
  background-size: cover;
  background-position: center;
  opacity: 0.15;
  z-index: 0;
}

.section-content {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  max-width: 1800px;
  margin: 0 auto;
  align-items: center;
}

.section-content.reverse {
  direction: rtl;
}

.section-content.reverse > * {
  direction: ltr;
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
  background: linear-gradient(135deg, #8B7355 0%, #8B4513 100%);
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
  background: rgba(255, 255, 255, 0.5); /* 改为半透明背景 */
  backdrop-filter: blur(5px); /* 添加毛玻璃效果 */
  border-left: 4px solid;
  border-image: linear-gradient(135deg, #8B7355 0%, #8B4513 100%) 1;
  border-radius: 0 12px 12px 0;
}

.highlight-text {
  font-size: 1.2rem;
  font-style: italic;
  color: var(--text);
}

.poetry-excerpt {
  padding: 2rem;
  background: rgba(255, 255, 255, 0.6); /* 改为半透明背景 */
  backdrop-filter: blur(10px); /* 添加毛玻璃效果 */
  border-radius: 12px;
  margin-top: 2rem;
  border: 1px solid rgba(255, 255, 255, 0.3); /* 添加边框 */
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

.ancient-performance,
.yuefu-display,
.instrument-showcase {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.performance-placeholder {
  /* 移除白色背景和毛玻璃效果 */
  padding: 0;
  text-align: center;
  border-radius: 0;
  box-shadow: none;
  border: none;
  min-width: auto;
}

.yuefu-item,
.instrument-card {
  background: rgba(255, 255, 255, 0.7); /* 改为半透明白色背景 */
  backdrop-filter: blur(10px); /* 添加毛玻璃效果 */
  padding: 2rem;
  text-align: center;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
  border: 1px solid rgba(255, 255, 255, 0.3); /* 添加边框增强层次感 */
  min-width: 200px;
}

.performance-gif {
  width: 100%;
  height: auto;
  max-height: 600px;
  object-fit: contain;
  display: block;
}

.performance-icon,
.yuefu-icon {
  font-size: 3rem;
  display: block;
  margin-bottom: 1rem;
}

.instrument-char {
  font-family: 'Noto Serif SC', 'STSong', 'SimSun', serif;
  font-size: 3rem;
  font-weight: 700;
  color: #8B7355;
  margin-bottom: 0.5rem;
}

.yuefu-item h3,
.instrument-card h3 {
  font-size: 1.8rem;
  margin: 0.5rem 0;
  color: #333;
}

.yuefu-item p,
.instrument-card p {
  color: #666;
  font-size: 1rem;
  margin: 0;
}

.yuefu-desc {
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

/* 4. 赏歌图片区 */
.gallery-section {
  padding: 2rem 2rem 4rem; /* 保持一致的padding */
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  position: relative;
}

/* 为赏歌section添加半透明遮罩层 */
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

/* 确保赏歌section的内容在遮罩层之上 */
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
.ge-footer {
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
  top: 40px;
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
  /* 装饰性section移动端适配 - 重构版本 */
  .ge-intro-section {
    min-height: 80vh;
  }

  .red-circle-main {
    left: 50%;
    transform: translate(-50%, -50%);
    width: 39vw;
    height: 39vw;
    max-width: 39vw;
    max-height: 39vw;
  }

  .poetry-text-line-1 {
    font-size: 2.3vw;
  }

  .poetry-text-line-2 {
    font-size: 2vw;
  }

  .cloud-support-container {
    left: 50%;
    transform: translate(-50%, -50%);
    width: 42vw;
  }

  .right-figure-container {
    left: 50%;
    transform: translate(-50%, -50%);
    width: 35vw;
    top: 42%;
    bottom: auto;
  }

  .right-figure-img {
    mask-image: none;
    -webkit-mask-image: none;
  }

  .bottom-description-area {
    padding: 2rem 5% 4%;
  }

  .description-content-text {
    font-size: 0.85rem;
    line-height: 1.6;
    letter-spacing: 0.5px;
  }

  .desc-text-char {
    animation-duration: 0.4s;
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

  /* 移动端圆角效果 */
  .calligraphy-area {
    border-radius: 8px; /* 移动端使用稍小的圆角 */
  }

  .calligraphy-placeholder {
    border-radius: 8px; /* 移动端使用稍小的圆角 */
  }
}

@media (min-width: 769px) and (max-width: 1024px) {
  /* 装饰性section平板端适配 - 重构版本 */
  .red-circle-main {
    left: 17%;
    width: 26.25vw;
    height: 26.25vw;
    max-width: 29.4vw;
    max-height: 29.4vw;
  }

  .poetry-text-line-1 {
    font-size: 1.8vw;
  }

  .poetry-text-line-2 {
    font-size: 1.6vw;
  }

  .cloud-support-container {
    left: 14%;
    width: 30.45vw;
  }

  .right-figure-container {
    left: calc(17% + 26.25vw - 1.5vw);
    width: 24vw;
  }

  .bottom-description-area {
    padding: 2.5rem 5% 4%;
  }

  .description-content-text {
    font-size: 0.95rem;
    line-height: 1.7;
  }

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

/* 针对ge.vue页面的黑色导航栏样式 */
.ge-page-container :deep(.poetry-navigation) {
  background: #0a0a0a !important;
  border-top: 1px solid #333333 !important;
  border-bottom: 1px solid #333333 !important;
  box-shadow: 0 1px 3px rgba(255, 255, 255, 0.1) !important;
}

.ge-page-container :deep(.nav-item) {
  color: #ffffff !important;
}

.ge-page-container :deep(.nav-item:hover) {
  color: #d4af37 !important;
  background: rgba(212, 175, 55, 0.1) !important;
}

.ge-page-container :deep(.nav-item.active) {
  color: #d4af37 !important;
}

.ge-page-container :deep(.nav-item.active .nav-text) {
  background: linear-gradient(135deg, #d4af37 0%, #f4d03f 100%) !important;
  -webkit-background-clip: text !important;
  -webkit-text-fill-color: transparent !important;
  background-clip: text !important;
}

.ge-page-container :deep(.nav-divider) {
  background: #666666 !important;
  border-left: 1px dashed #999999 !important;
}
</style>
