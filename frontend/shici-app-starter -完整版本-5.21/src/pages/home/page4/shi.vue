<template>
  <div class="shi-page-container">
    <!-- 国风导航栏 -->
    <PoetryNavigation />

    <!-- 抽屉式主容器 -->
    <main class="shi-drawer-main" @mouseenter="stopAutoPlay" @mouseleave="startAutoPlay">
      <!-- 左侧抽屉导航区 (30%) -->
      <aside class="drawer-nav-section" :style="{ backgroundImage: `url(${drawerBgImg})`, backgroundSize: 'cover', backgroundPosition: 'center' }">
        <div class="drawer-buttons">
          <div
            v-for="(section, index) in drawerSections"
            :key="index"
            class="drawer-item"
            :class="{ active: currentSection === index }"
            @click="switchSection(index)"
          >
            <button class="drawer-btn" :style="{ backgroundImage: `url(${drawerBtnBgImg})`, backgroundSize: 'cover', backgroundPosition: 'center' }">
              <span class="drawer-title">{{ section.title }}</span>
              <span class="drawer-number">{{ index + 1 }}</span>
            </button>
          </div>
        </div>
      </aside>

      <!-- 右侧内容展示区 (70%) -->
      <section class="content-display-section" :style="{ backgroundImage: `url(${currentBgImage})`, backgroundSize: 'cover', backgroundPosition: 'center' }">
        <!-- 进度条 -->
        <div class="progress-indicator">
          <div class="progress-bar">
            <div
              class="progress-thumb"
              :style="{ transform: `translateY(${progressPosition}%)` }"
            ></div>
          </div>
        </div>

        <!-- 内容卡片容器 -->
        <div class="content-cards-container">
          <div
            v-for="(_, index) in 3"
            :key="index"
            class="content-card"
            :class="{ active: currentSection === index }"
          >
            <!-- 卷一：诗经的起源 -->
            <div v-if="index === 0" class="section-content">
              <div class="text-content">
                <div class="section-number">卷一</div>
                <h2 class="section-title">诗经的起源</h2>
                <div class="section-desc">
                  <p>《诗经》是中国古代诗歌的开端，最早的一部诗歌总集，收集了西周初期至春秋中叶（前11世纪至前6世纪）的诗歌。</p>
                  <p>诗经分为风、雅、颂三类，共计305篇，反映了周代社会的方方面面，是中国古典文学的源头。</p>
                </div>
                <div class="highlight-box">
                  <span class="highlight-text">"诗者，志之所之也，在心为志，发言为诗"</span>
                </div>
              </div>
              <div class="visual-content">
                <div class="ancient-book">
                  <div class="book-carousel">
                    <!-- 上按钮 -->
                    <button class="carousel-btn up-btn" @click="prevBook">
                      <img :src="bookButtonUp" alt="上一本" class="carousel-btn-img" />
                    </button>

                    <!-- 书籍图片展示 -->
                    <div class="book-display">
                      <div class="book-image-container">
                        <transition :name="slideDirection" mode="out-in">
                          <img
                            :src="bookImages[currentBookIndex]"
                            :alt="'古籍善本 ' + (currentBookIndex + 1)"
                            class="book-image"
                            :key="currentBookIndex"
                          />
                        </transition>
                      </div>
                      <!-- 书籍信息 -->
                      <div class="book-info">
                        <p class="book-title">古籍善本</p>
                        <p class="book-number">{{ currentBookIndex + 1 }} / {{ bookImages.length }}</p>
                      </div>
                    </div>

                    <!-- 下按钮 -->
                    <button class="carousel-btn down-btn" @click="nextBook">
                      <img :src="bookButtonDown" alt="下一本" class="carousel-btn-img" />
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- 卷二：风雅颂 -->
            <div v-if="index === 1" class="section-content reverse">
              <div class="visual-content">
<div class="category-display">
  <div class="category-item">
    <img :src="fengImg" alt="风" class="category-img" />
    <p>民间歌谣</p>
    <div class="category-desc">十五国风，反映各地民俗</div>
  </div>
  <div class="category-item">
    <img :src="yaImg" alt="雅" class="category-img" />
    <p>宫廷乐歌</p>
    <div class="category-desc">大雅小雅，贵族生活写照</div>
  </div>
  <div class="category-item">
    <img :src="songImg" alt="颂" class="category-img" />
    <p>宗庙祭祀</p>
    <div class="category-desc">周鲁商颂，祭祀祖先赞歌</div>
  </div>
</div>
              </div>
              <div class="text-content">
                <div class="section-number">卷二</div>
                <h2 class="section-title">风雅颂</h2>
                <div class="section-desc">
                  <p>《诗经》按内容性质分为风、雅、颂三类。"风"是各地民歌，"雅"是朝廷正乐，"颂"是宗庙祭祀之乐。</p>
                  <p>这种分类体现了周代社会的等级制度和文化分层，也展现了古代诗歌的多样功能。</p>
                </div>
                <div class="poetry-excerpt">
                  <div class="poem-title">《关雎》</div>
                  <div class="poem-content">
                    <p>关关雎鸠，在河之洲。</p>
                    <p>窈窕淑女，君子好逑。</p>
                    <p>参差荇菜，左右流之。</p>
                    <p>窈窕淑女，寤寐求之。</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- 卷三：艺术特色 -->
            <div v-if="index === 2" class="section-content">
              <div class="text-content">
                <div class="section-number">卷三</div>
                <h2 class="section-title">艺术特色</h2>
                <div class="section-desc">
                  <p>《诗经》的艺术手法主要有赋、比、兴三种。赋是直陈其事，比是比喻，兴是托物起兴。</p>
                  <p>这些手法对后世中国诗歌产生了深远影响，成为中国古典诗歌的基本表现技巧。</p>
                </div>
                <div class="poetry-excerpt">
                  <div class="poem-title">《蒹葭》</div>
                  <div class="poem-content">
                    <p>蒹葭苍苍，白露为霜。</p>
                    <p>所谓伊人，在水一方。</p>
                    <p>溯洄从之，道阻且长。</p>
                    <p>溯游从之，宛在水中央。</p>
                  </div>
                </div>
              </div>
              <div class="visual-content">
                <div class="technique-display">
  <div class="technique-item">
    <img :src="fuImg" alt="赋" class="technique-img" />
    <p>直陈其事</p>
  </div>
  <div class="technique-item">
    <img :src="biImg" alt="比" class="technique-img" />
    <p>比喻象征</p>
  </div>
  <div class="technique-item">
    <img :src="xingImg" alt="兴" class="technique-img" />
    <p>托物起兴</p>
  </div>
</div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <!-- 其他内容统一容器 -->
    <div class="shi-other-content-wrapper" :style="{ '--bg-top-image': `url(${otherContentBgTopImg})`, '--bg-top2-image': `url(${otherContentBgTop2Img})` }">

    <!-- 最底层背景层 - bgtop2.png -->
    <div class="bg-top2-layer"></div>

    <!-- 2.5 诗词名言过渡区与诗言志装饰性section合并 -->
    <section class="poetry-quotes-intro-section" id="section-quotes">

      <!-- 诗词名言过渡区 - 文字跳动效果 -->
      <div class="quotes-container">
        <div class="quotes-background">
          <div class="ink-decoration ink-1"></div>
          <div class="ink-decoration ink-2"></div>
        </div>

        <div class="quotes-content">
          <div
            v-for="(quote, index) in poetryQuotes"
            :key="index"
            class="quote-item"
            :class="{ 'quote-active': activeQuote === index }"
          >
            <div class="quote-text">
              <span
                v-for="(char, charIndex) in quote.text"
                :key="charIndex"
                class="quote-char"
                :style="getCharStyle(index, charIndex)"
              >
                {{ char }}
              </span>
            </div>
            <div class="quote-source">—— {{ quote.source }}</div>
          </div>
        </div>

        <div class="quotes-indicator">
          <div
            v-for="(_, index) in poetryQuotes.length"
            :key="index"
            class="indicator-dot"
            :class="{ 'dot-active': activeQuote === index }"
          ></div>
        </div>
      </div>

      <!-- 诗言志装饰性内容 -->
      <div class="intro-content">
        <!-- 装饰图片 -->
        <img :src="poetryIntroImg" alt="诗言志" class="intro-decoration-img" />

        <!-- 文字描述 -->
        <div class="intro-description">
          <p class="intro-text">
            诗者，志之所之也。它源起于先民的情感抒发，成熟于《诗经》的风雅颂，鼎盛于唐宋的近体诗。以凝练的文字、铿锵的韵律，写尽山河岁月、人间悲欢，是中国古代最具代表性的文体，也是中国人刻在骨子里的浪漫。
          </p>
        </div>
      </div>

    </section>

    <!-- 说诗和赏诗共用容器 -->
    <div class="shi-gallery-video-wrapper">

    <!-- 3. 专家视频区 -->
    <section class="video-section" id="section-video">
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
    <section class="gallery-section" id="section-gallery">
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

    </div><!-- 结束 shi-gallery-video-wrapper -->

    </div><!-- 结束 shi-other-content-wrapper -->

    <!-- 页脚 -->
    <footer class="shi-footer">
      <div class="footer-content">
        <div class="footer-text">
          <p>诗经是中国诗歌的源头</p>
          <p>风雅颂，构成了中国诗歌的古典传统</p>
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
            <p>关联诗篇：{{ currentPainting.relatedPoetry }}</p>
            <p>{{ currentPainting.description }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import PoetryNavigation from '@/components/PoetryNavigation.vue'
// 赋比兴图片导入
const fuImg = new URL('@/assets/home1/shi/chouti/赋.png', import.meta.url).href
const biImg = new URL('@/assets/home1/shi/chouti/比.png', import.meta.url).href
const xingImg = new URL('@/assets/home1/shi/chouti/兴.png', import.meta.url).href
const router = useRouter()
// 风雅颂图片导入（新增）
const fengImg = new URL('@/assets/home1/shi/chouti/风.png', import.meta.url).href
const yaImg = new URL('@/assets/home1/shi/chouti/雅.png', import.meta.url).href
const songImg = new URL('@/assets/home1/shi/chouti/颂.png', import.meta.url).href
// 图片资源导入
const poetryIntroImg = new URL('@/assets/home1/shi/group04_img01.png', import.meta.url).href
const juanOneBgImg = new URL('@/assets/home1/shi/chouti/bg/topBg.jpg', import.meta.url).href
const juanTwoBgImg = new URL('@/assets/home1/shi/chouti/bg/topBg02.jpg', import.meta.url).href
const juanThreeBgImg = new URL('@/assets/home1/shi/chouti/bg/shinvBox2Bg.jpg', import.meta.url).href
const drawerBgImg = new URL('@/assets/home1/shi/chouti/leftTopTree.png', import.meta.url).href
const drawerBtnBgImg = new URL('@/assets/home1/shi/chouti/huajuan2.png', import.meta.url).href
const otherContentBgTopImg = new URL('@/assets/home1/shi/chouti/bgtop.png', import.meta.url).href
const otherContentBgTop2Img = new URL('@/assets/home1/shi/chouti/bgtop2.png', import.meta.url).href

// 视频资源导入
const shiVideoUrl = new URL('@/assets/home1/shi/vedio/shi.mp4', import.meta.url).href
const shiVideoThumbnail = new URL('@/assets/home1/shi/vedio/shifengmian.jpg', import.meta.url).href

// 古籍善本轮播图片资源
const bookButtonUp = new URL('@/assets/home1/shi/chouti/button-s.png', import.meta.url).href
const bookButtonDown = new URL('@/assets/home1/shi/chouti/button-x.png', import.meta.url).href

// 古籍善本书籍图片数组
const bookImages = ref([
  new URL('@/assets/home1/shi/chouti/shuji/shijin.png', import.meta.url).href,
  new URL('@/assets/home1/shi/chouti/shuji/shishuhua2.png', import.meta.url).href,
  new URL('@/assets/home1/shi/chouti/shuji/shishuhua1.png', import.meta.url).href,
  new URL('@/assets/home1/shi/chouti/shuji/ma.png', import.meta.url).href,
  new URL('@/assets/home1/shi/chouti/shuji/zhang.png', import.meta.url).href,
  new URL('@/assets/home1/shi/chouti/shuji/shicibacui.png', import.meta.url).href
])

// 轮播状态
const currentBookIndex = ref(0)
const bookCarouselInterval = ref(null)
const slideDirection = ref('') // 记录滑动方向：'up' 或 'down'

// 下一本书（向下滑动）
const nextBook = () => {
  slideDirection.value = 'down'
  currentBookIndex.value = (currentBookIndex.value + 1) % bookImages.value.length
}

// 上一本书（向上滑动）
const prevBook = () => {
  slideDirection.value = 'up'
  currentBookIndex.value = (currentBookIndex.value - 1 + bookImages.value.length) % bookImages.value.length
}

// 启动自动轮播（已禁用）
// const startBookCarousel = () => {
//   bookCarouselInterval.value = setInterval(() => {
//     nextBook()
//   }, 3000) // 每3秒切换一次
// }

// 停止自动轮播
const stopBookCarousel = () => {
  if (bookCarouselInterval.value) {
    clearInterval(bookCarouselInterval.value)
    bookCarouselInterval.value = null
  }
}

// 组件挂载时不启动自动轮播
// onMounted(() => {
//   startBookCarousel()
// })

onUnmounted(() => {
  stopBookCarousel()
})

// 抽屉导航数据
const drawerSections = ref([
  { title: '诗经的起源', subtitle: 'The Origins of Shijing' },
  { title: '风雅颂', subtitle: 'Wind, Elegance, and Hymns' },
  { title: '艺术特色', subtitle: 'Artistic Features' }
])

// 抽屉交互状态
const currentSection = ref(0)
const progressPosition = ref(0)

// 根据当前章节返回对应的背景图
const currentBgImage = computed(() => {
  switch (currentSection.value) {
    case 0:
      return juanOneBgImg
    case 1:
      return juanTwoBgImg
    case 2:
      return juanThreeBgImg
    default:
      return 'none'
  }
})
const isTransitioning = ref(false)
const autoPlayInterval = ref(null)

// 诗词名言数据
const poetryQuotes = ref([
  { text: '诗者，志之所之也', source: '《毛诗序》' },
  { text: '关关雎鸠，在河之洲', source: '《诗经·周南·关雎》' },
  { text: '蒹葭苍苍，白露为霜', source: '《诗经·秦风·蒹葭》' },
  { text: '桃之夭夭，灼灼其华', source: '《诗经·周南·桃夭》' },
  { text: '青青子衿，悠悠我心', source: '《诗经·郑风·子衿》' }
])

const activeQuote = ref(0)
const quoteInterval = ref(null)
const charAnimations = ref({})

// 切换名言
function switchQuote(index) {
  activeQuote.value = index
  resetCharAnimations(index)
}

// 重置文字动画
function resetCharAnimations(quoteIndex) {
  const quote = poetryQuotes.value[quoteIndex]
  const chars = quote.text.split('')

  chars.forEach((_, charIndex) => {
    setTimeout(() => {
      charAnimations.value[`${quoteIndex}-${charIndex}`] = true
    }, charIndex * 150) // 每个文字间隔150ms
  })
}

// 获取文字样式
function getCharStyle(quoteIndex, charIndex) {
  const isAnimated = charAnimations.value[`${quoteIndex}-${charIndex}`]
  return {
    opacity: isAnimated ? 1 : 0,
    filter: isAnimated ? 'blur(0px)' : 'blur(10px)',
    transform: isAnimated ? 'translateY(0)' : 'translateY(30px)'
  }
}

// 自动轮换名言
function startQuoteRotation() {
  quoteInterval.value = setInterval(() => {
    const nextQuote = (activeQuote.value + 1) % poetryQuotes.value.length
    switchQuote(nextQuote)
  }, 6000) // 每6秒切换一次
}

function stopQuoteRotation() {
  if (quoteInterval.value) {
    clearInterval(quoteInterval.value)
    quoteInterval.value = null
  }
}

// 视频数据配置
const videos = ref([
  {
    id: 1,
    title: '《诗经》导读——中国诗歌的源头',
    speaker: '程郁缀教授',
    description: '深入解读《诗经》的历史背景、文学价值与文化意义',
    category: '经典导读',
    views: '18.5万',
    tags: ['诗经', '古典文学', '诗歌鉴赏'],
    thumbnail: shiVideoThumbnail, // 使用导入的视频封面
    duration: '15:45',
    url: shiVideoUrl // 使用导入的视频URL
  }
])

// 画作数据配置
const paintings = ref([
  {
    id: 1,
    title: '诗经图卷',
    artist: '顾恺之',
    era: '东晋',
    dynasty: '晋代',
    relatedPoetry: '《关雎》',
    image: new URL('@/assets/home1/shi/shang/childhood-PC01-31.jpg', import.meta.url).href,
    description: '描绘关雎诗意境，展现先民质朴情感'
  },
  {
    id: 2,
    title: '蒹葭图',
    artist: '仇英',
    era: '明代',
    dynasty: '明代',
    relatedPoetry: '《蒹葭》',
    image: new URL('@/assets/home1/shi/shang/childhood-PC02-11.jpg', import.meta.url).href,
    description: '秋水蒹葭，伊人在水一方的诗意表达'
  },
  {
    id: 3,
    title: '桃夭图',
    artist: '唐寅',
    era: '明代',
    dynasty: '明代',
    relatedPoetry: '《桃夭》',
    image: new URL('@/assets/home1/shi/shang/childhood-PC03-30.jpg', import.meta.url).href,
    description: '桃花灼灼，宜室宜家的美好祝愿'
  },
  {
    id: 4,
    title: '鹿鸣图',
    artist: '沈周',
    era: '明代',
    dynasty: '明代',
    relatedPoetry: '《鹿鸣》',
    image: new URL('@/assets/home1/shi/shang/childhood-PC04-32.jpg', import.meta.url).href,
    description: '呦呦鹿鸣，食野之苹的宴饮场景'
  },
  {
    id: 5,
    title: '采薇图',
    artist: '文征明',
    era: '明代',
    dynasty: '明代',
    relatedPoetry: '《采薇》',
    image: new URL('@/assets/home1/shi/shang/childhood-PC05-94.jpg', import.meta.url).href,
    description: '昔我往矣，杨柳依依的离愁别绪'
  },
  {
    id: 6,
    title: '七月流火图',
    artist: '董其昌',
    era: '明代',
    dynasty: '明代',
    relatedPoetry: '《七月》',
    image: new URL('@/assets/home1/shi/shang/childhood-PC06-105.jpg', import.meta.url).href,
    description: '农历七月时节，农家生活场景'
  },
  {
    id: 7,
    title: '文王图',
    artist: '陈洪绶',
    era: '明代',
    dynasty: '明代',
    relatedPoetry: '《文王》',
    image: new URL('@/assets/home1/shi/shang/1.jpg', import.meta.url).href,
    description: '周文王画像，展现圣君风范'
  }
])

// 视频和弹窗状态
const showVideoModal = ref(false)
const showPaintingModal = ref(false)
const currentVideo = ref({})
const currentPainting = ref({})

// 切换章节
function switchSection(index) {
  if (isTransitioning.value || index === currentSection.value) return

  isTransitioning.value = true
  currentSection.value = index

  // 计算进度条位置
  progressPosition.value = index * (100 / (drawerSections.value.length - 1))

  // 动画结束后重置状态
  setTimeout(() => {
    isTransitioning.value = false
  }, 500)

  // 重启自动播放
  restartAutoPlay()
}

// 自动播放功能
function startAutoPlay() {
  stopAutoPlay()
  autoPlayInterval.value = setInterval(() => {
    const nextSection = (currentSection.value + 1) % drawerSections.value.length
    switchSection(nextSection)
  }, 3000)
}

function stopAutoPlay() {
  if (autoPlayInterval.value) {
    clearInterval(autoPlayInterval.value)
    autoPlayInterval.value = null
  }
}

function restartAutoPlay() {
  stopAutoPlay()
  startAutoPlay()
}

function scrollToTop() {
  window.scrollTo({ top: 0, behavior: 'smooth' })
  document.documentElement.scrollTo({ top: 0, behavior: 'smooth' })
}

function exploreMore() {
  router.push('/library')
}

// 视频功能
function playVideo(index) {
  currentVideo.value = videos.value[index]
  showVideoModal.value = true
  stopAutoPlay()
}

function closeVideoModal() {
  showVideoModal.value = false
  currentVideo.value = {}
  startAutoPlay()
}

// 画作功能
function viewPainting(index) {
  currentPainting.value = paintings.value[index]
  showPaintingModal.value = true
  stopAutoPlay()
}

function closePaintingModal() {
  showPaintingModal.value = false
  currentPainting.value = {}
  startAutoPlay()
}

onMounted(() => {
  startAutoPlay()
  startQuoteRotation()
  // 初始化第一个名言动画
  resetCharAnimations(0)
})

onUnmounted(() => {
  stopAutoPlay()
  stopQuoteRotation()
})
</script>

<style scoped>
/* 风雅颂图片样式 */
.category-img {
  width: 180px;           /* 调整图片宽度 */
  height: auto;
  max-width: 100%;
  margin-bottom: 1rem;
  display: block;
  transition: transform 0.3s ease, filter 0.3s ease;
}

.category-item:hover .category-img {
  transform: scale(1.05);
  filter: drop-shadow(0 4px 8px rgba(200, 60, 60, 0.3));
}

/* 隐藏原来的 emoji 图标和 h3 标题（如果不想显示） */
.category-icon {
  display: none;    /* 隐藏 emoji */
}

.category-item h3 {
  display: none;    /* 隐藏“风”、“雅”、“颂”文字 */
}
/* 诗言志装饰性section */
.shi-intro-section {
  width: 100%;
  min-height: 40vh; /* 减少最小高度，从60vh改为40vh */
  background: transparent; /* 使用透明背景，融入大容器 */
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem 2rem; /* 减少padding，从3rem改为2rem */
  position: relative;
  overflow: hidden;
  margin: 0; /* 移除外边距 */
  border: none; /* 移除边框 */
}

.intro-content {
  display: flex;
  align-items: center;
  gap: 3rem;
  max-width: 1200px;
  width: 100%;
  position: relative;
  z-index: 2;
}

.intro-decoration-img {
  width: 45%;
  max-width: 500px;
  height: auto;
  object-fit: contain;
  filter: drop-shadow(0 10px 30px rgba(44, 44, 44, 0.15));
}

.intro-text {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  font-size: 1.55rem;
  line-height: 2;
  color: #3d3d3d;
  text-align: justify;
  letter-spacing: 0.08em;
  font-weight: 400;
  margin: 0;
}

/* 合并后的诗词名言与诗言志统一section */
.poetry-quotes-intro-section {
  width: 100%;
  position: relative;
  background: transparent;
  padding: 2rem 2rem calc(4rem + 34px); /* 删掉2px，从36px改为34px */
  margin: 0;
  overflow: hidden;
}

.poetry-quotes-intro-section .quotes-container {
  margin-bottom: 3rem;
  margin-top: 150px; /* 向下移动150px */
}

.poetry-quotes-intro-section .intro-content {
  max-width: 1200px;
  margin: 150px auto 0; /* 向下移动150px */
}

/* 响应式适配 */
@media (max-width: 1024px) {
  .shi-intro-section {
    min-height: 50vh;
    padding: 2rem 1.5rem;
  }

  .intro-content {
    flex-direction: column;
    gap: 2rem;
  }

  .intro-decoration-img {
    width: 70%;
    max-width: 400px;
  }

  .intro-description {
    padding: 2rem;
  }

  .intro-text {
    font-size: 1rem;
    line-height: 1.8;
  }

  .poetry-quotes-intro-section {
    padding: 3rem 1.5rem;
  }
}

@media (max-width: 768px) {
  .shi-intro-section {
    min-height: 40vh;
    padding: 1.5rem 1rem;
  }

  .intro-decoration-img {
    width: 80%;
    max-width: 300px;
  }

  .intro-description {
    padding: 1.5rem;
  }

  .intro-text {
    font-size: 0.9rem;
    line-height: 1.6;
  }

  /* 古籍善本轮播组件移动端样式 */
  .book-image-container {
    max-width: 250px;
    height: 350px;
  }

  .book-title {
    font-size: 1rem;
  }

  .carousel-btn-img {
    width: 35px;
    height: 35px;
  }

  .poetry-quotes-intro-section {
    padding: 2rem 1rem;
  }

  .poetry-quotes-intro-section .quotes-container {
    margin-bottom: 2rem;
  }
}

/* 古风基础样式 - 宣纸色系统 */
.shi-page-container {
  width: 100%;
  min-height: 100vh;
  background: linear-gradient(135deg, #F8F5E6 0%, #E8DCC8 100%); /* 宣纸米白到浅赭石渐变 */
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
  color: #2C2C2C; /* 墨色文字 */
  position: relative;
  z-index: 1;
}

/* 其他内容统一容器 - 消除间隔和分界线 */
.shi-other-content-wrapper {
  width: 100vw; /* 使用100vw确保宽度铺满整个视口 */
  max-width: 100vw; /* 确保不超过视口宽度 */
  margin-left: calc(50% - 50vw); /* 通过负边距让容器完全贴边 */
  margin-right: calc(50% - 50vw); /* 通过负边距让容器完全贴边 */
  position: relative;
  min-height: 80vh; /* 减少最小高度，从100vh改为80vh */
  background:
    linear-gradient(135deg, #F8F5E6 0%, #E8DCC8 100%), /* 渐变背景 */
    url(@/assets/home1/shi/chouti/bg.jpg); /* 添加底层纹理背景 */
  background-size: cover, cover;
  background-position: center, center;
  background-attachment: fixed, fixed; /* 固定背景，创建视差效果 */
  overflow: visible; /* 改为visible，让背景图不被容器裁切 */
}

/* 最底层背景层 - bgtop2.png */
.shi-other-content-wrapper .bg-top2-layer {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 120vh; /* 恢复到120vh，显示原图 */
  background-size: auto; /* 原图大小 */
  background-position: center top;
  background-repeat: no-repeat;
  z-index: 2; /* 中间层级，在bgtop.png下层 */
  pointer-events: none;
  background-image: var(--bg-top2-image);
  opacity: 1;
}

/* 顶部背景层 - bgtop.png */
.shi-other-content-wrapper::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 120vh; /* 恢复到120vh，显示原图 */
  background-size: auto; /* 原图大小 */
  background-position: center top;
  background-repeat: no-repeat;
  z-index: 3; /* 最高层级，确保在最上层显示 */
  pointer-events: none;
  background-image: var(--bg-top-image);
  opacity: 1; /* 确保完全不透明 */
}

/* 为背景图添加半透明遮罩层，确保文字可读 */
.shi-other-content-wrapper > * {
  position: relative;
  z-index: 10; /* 提高层级，确保在所有背景层之上 */
}

/* 宣纸纹理效果已移除 */

/* 古风抽屉式主容器 */
.shi-drawer-main {
  display: grid;
  grid-template-columns: 30fr 70fr; /* 恢复原来的30:70比例 */
  height: 100vh;
  overflow: hidden;
  margin-bottom: 0; /* 移除底部边距，让与大容器无缝连接 */
  position: relative;
  z-index: 1;
}

/* 古风左侧抽屉导航区 - 木质纹理 */
.drawer-nav-section {
  background: linear-gradient(135deg, #E8DCC8 0%, #D4C4B0 100%); /* 浅赭石木质色 */
  padding: 2rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
  position: relative;
  border-right: 1px solid rgba(139, 115, 85, 0.2); /* 淡化边框 */
  box-shadow: inset 0 0 20px rgba(139, 115, 85, 0.1); /* 内阴影增加深度 */
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
}

/* 为背景图添加半透明遮罩层 */
.drawer-nav-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background:
    linear-gradient(135deg, rgba(232, 220, 200, 0.85) 0%, rgba(212, 196, 176, 0.85) 100%),
    repeating-linear-gradient(0deg, transparent, transparent 1px, rgba(139, 115, 85, 0.03) 1px, rgba(139, 115, 85, 0.03) 2px),
    repeating-linear-gradient(90deg, transparent, transparent 1px, rgba(139, 115, 85, 0.02) 1px, rgba(139, 115, 85, 0.02) 2px);
  pointer-events: none;
  z-index: 1;
}

.drawer-buttons {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  position: relative;
  z-index: 10;
  padding: 1.5rem 2rem; /* 增加内边距，给按钮更多显示空间 */
}

.drawer-item {
  position: relative;
  transform: translateX(-70%);
  transition: transform 0.5s ease-in-out;
}

.drawer-item.active {
  transform: translateX(0);
}

.drawer-btn {
  width: 100%;
  padding: 0; /* 移除内边距，让按钮完全按照背景图尺寸 */
  background: #F8F5E6; /* 宣纸白色 */
  background-size: 100% 100%; /* 等比缩放背景图以完全填充按钮 */
  background-position: center;
  background-repeat: no-repeat;
  border: 1px solid rgba(90, 74, 63, 0.3); /* 淡化边框 */
  border-radius: 4px; /* 减小圆角，更符合古风 */
  color: #2C2C2C; /* 墨色文字 */
  font-size: 1.2rem;
  font-weight: 600;
  transition: all 0.3s ease;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  text-align: left;
  box-shadow: 0 1px 4px rgba(44, 44, 44, 0.08); /* 淡化阴影 */
  min-height: 100px; /* 设置合适的最小高度 */
  aspect-ratio: 29/10; /* 设置为29:10的宽高比 */
  display: flex;
  align-items: center;
  justify-content: space-between;
}

/* 为背景图添加半透明遮罩层 */
.drawer-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(248, 245, 230, 0); /* 完全透明，去掉白色遮罩 */
  z-index: 1;
  pointer-events: none;
}

/* 确保文字在遮罩层之上 */
.drawer-btn .drawer-title {
  position: relative;
  z-index: 2;
  padding: 1rem 1.5rem; /* 为文字添加内边距 */
  flex: 1;
}

.drawer-btn .drawer-number {
  position: relative;
  z-index: 2;
  padding: 1rem 1.5rem; /* 为数字添加内边距 */
  font-family: '猫啃网风雅宋', 'SimSun', '宋体', serif; /* 应用风雅宋字体 */
  font-weight: normal;
  font-size: 2.5rem; /* 增大字体尺寸，突出字体效果 */
  line-height: 1;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3); /* 添加阴影增强立体感 */
}

/* 激活状态 - 书简展开效果 */
.drawer-item.active .drawer-btn {
  border-color: #D4AF37; /* 金色边框，象征书简展开 */
  box-shadow: 0 4px 15px rgba(212, 175, 55, 0.4); /* 金色光晕 */
  transform: scale(1.02); /* 微微放大，模拟展开效果 */
}

.drawer-item.active .drawer-btn::before {
  background: rgba(139, 115, 85, 0); /* 完全透明，去掉激活状态的遮罩 */
  border: 2px solid rgba(212, 175, 55, 0.3); /* 保留金色边框 */
}

.drawer-item.active .drawer-btn {
  color: #2C2C2C; /* 保持墨色文字，更符合书简风格 */
}

.drawer-item.active .drawer-btn .drawer-title {
  color: #8B4513; /* 深棕色标题，更符合古风书简 */
  font-weight: 700;
  text-shadow: 0 1px 2px rgba(248, 245, 230, 0.5); /* 淡阴影增强可读性 */
}

.drawer-item.active .drawer-btn .drawer-number {
  color: #D4AF37; /* 金色数字，突出显示 */
  text-shadow: 0 2px 4px rgba(212, 175, 55, 0.3);
}

.drawer-btn:hover {
  transform: scale(1.02);
  box-shadow: 0 6px 20px rgba(44, 44, 44, 0.2); /* 加深墨色阴影 */
}

/* 添加水墨晕染hover效果 */
.drawer-btn::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  background: radial-gradient(circle, rgba(44, 44, 44, 0.1) 0%, transparent 70%);
  transform: translate(-50%, -50%);
  transition: all 0.5s ease;
  pointer-events: none;
}

.drawer-btn:hover::before {
  width: 200%;
  height: 200%;
}

.drawer-title {
  position: relative;
  z-index: 2;
}

.drawer-number {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 4rem;
  font-weight: 700;
  color: rgba(255, 255, 255, 0.2);
  text-shadow: 2px -1px 8px rgba(250, 80, 193, 0.3);
  pointer-events: none;
}

/* 古风右侧内容展示区 - 宣纸质感 */
.content-display-section {
  position: relative;
  background: rgba(248, 245, 230, 0.85); /* 半透明宣纸白 */
  backdrop-filter: blur(11px);
  padding: 2rem;
  overflow: hidden;
  box-shadow: inset 0 0 30px rgba(44, 44, 44, 0.05); /* 内阴影增加深度 */
  transition: background-image 0.5s ease-in-out;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
}

/* 为卷一背景图添加遮罩层 */
.content-display-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 255, 255, 0.75);
  pointer-events: none;
  z-index: 1;
  opacity: 0;
  transition: opacity 0.5s ease-in-out;
}

/* 当有背景图时显示遮罩 */
.content-display-section[style*="backgroundImage"]::before {
  opacity: 1;
}

/* 古风进度指示器 - 竹简样式 */
.progress-indicator {
  position: absolute;
  left: 2rem;
  top: 10%;
  height: 80%;
  width: 4px; /* 加粗一点，像竹简 */
  background: rgba(44, 44, 44, 0.1); /* 淡墨色 */
  z-index: 20; /* 提高层级确保在遮罩层之上 */
  border-radius: 2px;
}

.progress-bar {
  position: relative;
  height: 100%;
  width: 100%;
}

.progress-thumb {
  position: absolute;
  width: 8px; /* 加宽 */
  height: 25%;
  left: -2px;
  top: 0;
  background: linear-gradient(135deg, #C83C3C 0%, #8B1A1A 100%); /* 朱砂色渐变 */
  border-radius: 4px;
  transition: transform 0.5s ease-in-out;
  box-shadow: 0 2px 8px rgba(200, 60, 60, 0.4); /* 朱砂色光晕 */
  border: 1px solid #F8F5E6; /* 宣纸白边框 */
}

/* 内容卡片容器 */
.content-cards-container {
  height: 100%;
  overflow: hidden;
  position: relative;
  margin-left: 2rem;
  z-index: 10; /* 确保内容在遮罩层之上 */
}

.content-card {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  opacity: 0;
  transform: translateY(20px);
  transition: all 0.5s ease-in-out;
  pointer-events: none;
  display: flex;
  align-items: center;
  justify-content: center;
}

.content-card.active {
  opacity: 1;
  transform: translateY(0);
  pointer-events: all;
}

/* 保留原有的内容样式 */
.section-content {
  position: relative;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  max-width: 1400px;
  margin: 0 auto;
  align-items: center;
  padding: 2rem;
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

/* 古风标题系统 - 书法字体效果 */
.section-number {
  font-size: 0.9rem;
  font-weight: 600;
  color: #C83C3C; /* 朱砂色 */
  letter-spacing: 0.2em;
  margin-bottom: 1rem;
  font-family: 'STKaiti', 'KaiTi', '楷体', serif; /* 楷体 */
}

.section-title {
  font-size: 3rem;
  font-weight: 700;
  margin: 0 0 2rem 0;
  color: #2C2C2C; /* 墨色 */
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif; /* 书法字体 */
  text-shadow: 2px 2px 4px rgba(44, 44, 44, 0.1); /* 淡墨色阴影 */
}

/* 古风正文 - 宋体系统 */
.section-desc {
  font-size: 1.1rem;
  line-height: 1.8;
  color: #2C2C2C; /* 墨色 */
  margin-bottom: 2rem;
  font-family: 'STSong', 'SimSun', '宋体', serif; /* 宋体 */
}

.section-desc p {
  margin-bottom: 1rem;
}


.highlight-text {
  font-size: 1.8rem;
  font-style: italic;
  color: #2C2C2C; /* 墨色 */
  font-family: 'STKaiti', 'KaiTi', '楷体', serif; /* 楷体 */
}


.poem-title {
  font-size: 1.8rem;
  font-weight: 600;
  margin-bottom: 1rem;
  color: #2C2C2C; /* 墨色 */
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif; /* 书法字体 */
  text-align: center;
  border-bottom: 1px solid rgba(44, 44, 44, 0.1);
  padding-bottom: 0.5rem;
}

.poem-content {
  font-size: 1.8rem;
  line-height: 2;
  color: #2C2C2C; /* 墨色 */
  font-family: 'STSong', 'SimSun', '宋体', serif; /* 宋体 */
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

.ancient-book,
.category-display,
.technique-display {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

/* 古籍善本轮播组件 */
.book-carousel {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  position: relative;
  width: 100%;
  max-width: 400px;
}

.book-display {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  width: 100%;
}

.book-image-container {
  width: 100%;
  max-width: 300px;
  height: 400px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  position: relative;
  z-index: 1;
}

.book-image {
  width: 100%;
  height: 100%;
  object-fit: contain;
  transition: transform 0.3s ease;
}

.book-image:hover {
  transform: scale(1.05);
}

/* 向下滑动过渡效果（点击下一个按钮） */
.down-enter-active {
  animation: slideDownIn 0.5s ease-out;
}

.down-leave-active {
  animation: slideDownOut 0.5s ease-out;
}

@keyframes slideDownIn {
  from {
    opacity: 0;
    transform: translateY(-50px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes slideDownOut {
  from {
    opacity: 1;
    transform: translateY(0);
  }
  to {
    opacity: 0;
    transform: translateY(50px);
  }
}

/* 向上滑动过渡效果（点击上一个按钮） */
.up-enter-active {
  animation: slideUpIn 0.5s ease-out;
}

.up-leave-active {
  animation: slideUpOut 0.5s ease-out;
}

@keyframes slideUpIn {
  from {
    opacity: 0;
    transform: translateY(50px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes slideUpOut {
  from {
    opacity: 1;
    transform: translateY(0);
  }
  to {
    opacity: 0;
    transform: translateY(-50px);
  }
}

.book-info {
  text-align: center;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.book-title {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  font-size: 1.2rem;
  font-weight: 600;
  color: #2C2C2C;
  margin: 0;
}

.book-number {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  font-size: 0.9rem;
  color: #666;
  margin: 0;
}

.carousel-btn {
  background: none;
  border: none;
  cursor: pointer;
  padding: 0.5rem;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.carousel-btn-img {
  width: 40px;
  height: 40px;
  object-fit: contain;
  transition: transform 0.3s ease;
}

.carousel-btn:hover .carousel-btn-img {
  transform: scale(1.2);
}

.carousel-btn:active .carousel-btn-img {
  transform: scale(0.95);
}

/* 古风卡片样式 - 线装书效果 */
.book-placeholder,
.category-item,
.technique-item {
  text-align: center;
  position: relative;
  background: transparent;  /* 改为透明 */
  padding: 1rem;            /* 减少内边距 */
  border: none;             /* 移除边框 */
  box-shadow: none;         /* 移除阴影 */
  border-radius: 0;         /* 移除圆角 */
}

/* 移除伪元素（做旧纹理） */
.technique-item::before {
  display: none;
}

/* 添加做旧纹理 */
.book-placeholder::before,
.category-item::before,


.book-icon,
.category-icon {
  font-size: 3rem;
  display: block;
  margin-bottom: 1rem;
}


/* 赋比兴图片样式 */
.technique-img {
  width: 180px;
  height: auto;
  max-width: 100%;
  margin-bottom: 0.5rem;
  display: block;
  transition: transform 0.3s ease, filter 0.3s ease;
}

.technique-item:hover .technique-img {
  transform: scale(1.05);
  filter: drop-shadow(0 4px 8px rgba(200, 60, 60, 0.3));
}

/* 如果还想保留原来的文字样式作为后备，可以保留 .technique-char */
.technique-char {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  font-size: 3rem;
  font-weight: 700;
  color: #C83C3C;
  margin-bottom: 0.5rem;
  text-shadow: 2px 2px 4px rgba(200, 60, 60, 0.2);
}

.category-item h3,
.technique-item h3 {
  font-size: 1.8rem;
  margin: 0.5rem 0;
  color: #2C2C2C; /* 墨色 */
  font-family: 'STKaiti', 'KaiTi', '楷体', serif; /* 楷体 */
}

.category-item p,
.technique-item p {
  color: #5A4A3F; /* 深棕色 */
  font-size: 1rem;
  margin: 0;
  font-family: 'STSong', 'SimSun', '宋体', serif; /* 宋体 */
}

.category-desc {
  margin-top: 0.5rem;
  font-size: 0.9rem;
  color: #8B7355; /* 浅棕色 */
  font-family: 'STSong', 'SimSun', '宋体', serif; /* 宋体 */
}

/* 专家视频区 */
/* 古风视频区 */
.video-section {
  padding: 3rem 2rem;
  background: transparent;
  margin: 0;
  border: none;
  position: relative;
  z-index: 1;
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
  font-family: 'Noto Serif SC', 'STSong', 'SimSun', serif; /* 和ge.vue一样的字体 */
  font-size: 4rem;
  font-weight: 700;
  color: #333; /* 和ge.vue一样的颜色 */
  letter-spacing: 0.5rem;
  text-shadow: 3px 3px 6px rgba(44, 44, 44, 0.2); /* 墨色阴影 */
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

/* 诗词名言过渡区 - 文字跳动效果 */
.poetry-quotes-section {
  padding: 4rem 2rem;
  background: transparent; /* 使用透明背景，融入统一容器 */
  position: relative;
  overflow: hidden;
  margin: 0; /* 移除外边距 */
  border: none; /* 移除边框 */
}

.quotes-container {
  max-width: 1200px;
  margin: 0 auto;
  position: relative;
  min-height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.quotes-background {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
}

.ink-decoration {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.06;
}

.ink-1 {
  width: 500px;
  height: 500px;
  background: radial-gradient(circle, rgba(200, 60, 60, 0.1) 0%, transparent 70%);
  top: -250px;
  left: -100px;
  animation: inkFloat1 15s ease-in-out infinite;
}

.ink-2 {
  width: 400px;
  height: 400px;
  background: radial-gradient(circle, rgba(212, 175, 55, 0.08) 0%, transparent 70%);
  bottom: -200px;
  right: -100px;
  animation: inkFloat2 12s ease-in-out infinite;
}

@keyframes inkFloat1 {
  0%, 100% { transform: translate(0, 0) scale(1); }
  50% { transform: translate(50px, 30px) scale(1.2); }
}

@keyframes inkFloat2 {
  0%, 100% { transform: translate(0, 0) scale(1); }
  50% { transform: translate(-30px, -20px) scale(1.1); }
}

.quotes-content {
  position: relative;
  z-index: 1;
  width: 100%;
  text-align: center;
}

.quote-item {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 100%;
  opacity: 0;
  transition: opacity 0.8s ease;
  pointer-events: none;
}

.quote-item.quote-active {
  opacity: 1;
  pointer-events: all;
}

.quote-text {
  font-family: 'STXingkai', '华文行楷', 'KaiTi', '楷体', serif;
  font-size: 3.5rem;
  color: #2C2C2C; /* 墨色 */
  margin-bottom: 2rem;
  text-shadow: 1px 1px 3px rgba(44, 44, 44, 0.1); /* 淡墨色阴影 */
  letter-spacing: 0.3rem;
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.quote-char {
  display: inline-block;
  transition: all 0.6s cubic-bezier(0.4, 0, 0.2, 1);
  transform-origin: bottom center;
}

.quote-char:hover {
  transform: scale(1.1);
  color: #C83C3C; /* 朱砂色hover效果 */
  text-shadow: 0 0 20px rgba(200, 60, 60, 0.4);
}

.quote-source {
  font-family: 'STSong', 'SimSun', '宋体', serif;
  font-size: 1.3rem;
  color: #5A4A3F; /* 深棕色 */
  letter-spacing: 0.2rem;
  opacity: 0;
  transform: translateY(20px);
  transition: all 0.6s ease 0.5s; /* 延迟显示 */
}

.quote-active .quote-source {
  opacity: 1;
  transform: translateY(0);
}

.quotes-indicator {
  position: absolute;
  bottom: 1rem;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 1.5rem;
  z-index: 2;
  align-items: center;
}

.indicator-dot {
  width: 40px;
  height: 4px;
  background: rgba(139, 115, 85, 0.3); /* 淡棕色 */
  cursor: pointer;
  transition: all 0.4s ease;
  border-radius: 2px;
  position: relative;
  z-index: 1;
}

.indicator-dot::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 0;
  height: 0;
  background: rgba(139, 115, 85, 0.6);
  border-radius: 50%;
  transition: all 0.4s ease;
}

.indicator-dot:hover {
  background: rgba(139, 115, 85, 0.5);
  transform: scale(1.05);
}

.indicator-dot:hover::after {
  width: 8px;
  height: 8px;
}

.indicator-dot.dot-active {
  background: linear-gradient(90deg, #C83C3C 0%, #8B1A1A 100%); /* 朱砂色渐变 */
  box-shadow: 0 2px 8px rgba(200, 60, 60, 0.3);
  transform: scale(1.1);
}

.indicator-dot.dot-active::after {
  width: 12px;
  height: 12px;
  background: #F8F5E6; /* 宣纸白 */
  border: 2px solid #C83C3C; /* 朱砂色边框 */
}

/* 说诗和赏诗共用容器 */
.shi-gallery-video-wrapper {
  position: relative;
  width: 100%;
}

/* 为共用容器添加背景图 */
.shi-gallery-video-wrapper::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: var(--bg-top2-image);
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  opacity: 0.3;
  z-index: 0;
  pointer-events: none;
}

/* 赏诗图片区 */
/* 古风赏诗区 */
.gallery-section {
  padding: 3rem 2rem 4rem;
  background: transparent;
  margin: 0;
  border: none;
  position: relative;
  z-index: 1;
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
  background: rgba(232, 220, 200, 0.6); /* 浅赭石色 */
  border: 1px solid rgba(90, 74, 63, 0.2); /* 淡化边框 */
  box-shadow: 0 2px 8px rgba(44, 44, 44, 0.08); /* 淡化阴影 */
}

.calligraphy-area {
  position: relative;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); /* 与悬停状态保持一致的过渡效果 */
  border: 1px solid rgba(90, 74, 63, 0.3); /* 淡化边框 */
  background: rgba(248, 245, 230, 0.8); /* 宣纸白 */
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
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image:
    repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(139, 115, 85, 0.03) 2px),
    repeating-linear-gradient(90deg, transparent, transparent 2px, rgba(139, 115, 85, 0.03) 2px);
  pointer-events: none;
}

/* 古风页脚 */
.shi-footer {
  padding: 3rem 2rem;
  background: linear-gradient(135deg, #2C2C2C 0%, #1a1a1a 100%); /* 墨色渐变 */
  color: #F8F5E6; /* 宣纸白文字 */
  text-align: center;
  border-top: none; /* 移除顶部边框，让过渡更自然 */
  margin: 0; /* 移除外边距 */
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
  background: transparent;
  color: #F8F5E6; /* 宣纸白 */
  border: 1px solid rgba(200, 60, 60, 0.6); /* 淡化朱砂色边框 */
  border-radius: 4px; /* 减小圆角 */
  cursor: pointer;
  transition: all 0.3s ease;
  font-family: 'STKaiti', 'KaiTi', '楷体', serif; /* 楷体 */
}

.footer-btn:hover {
  background: #C83C3C; /* 朱砂色填充 */
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(200, 60, 60, 0.4); /* 朱砂色光晕 */
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
  z-index: 1;
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
  .shi-drawer-main {
    grid-template-columns: 1fr;
    grid-template-rows: auto 1fr;
    height: auto;
    min-height: 100vh;
  }

  .drawer-nav-section {
    height: auto;
    flex-direction: row;
    overflow-x: auto;
    padding: 1rem;
    gap: 0.5rem;
  }

  .drawer-buttons {
    padding: 0.5rem 1rem; /* 移动端内边距，减小上下间距 */
    flex-direction: row;
    width: 100%;
    min-width: max-content;
  }

  .drawer-buttons {
    flex-direction: row;
    width: 100%;
    min-width: max-content;
  }

  .drawer-item {
    transform: translateY(-100%);
    min-width: 150px;
  }

  .drawer-item.active {
    transform: translateY(0);
  }

  .drawer-btn {
    padding: 0; /* 移动端也移除内边距 */
    font-size: 1rem;
    white-space: nowrap;
    min-height: 80px; /* 移动端最小高度 */
    aspect-ratio: 29/10; /* 保持相同的29:10比例 */
  }

  .drawer-btn .drawer-title {
    padding: 0.8rem 1rem; /* 移动端文字内边距 */
  }

  .drawer-btn .drawer-number {
    padding: 0.8rem 1rem; /* 移动端数字内边距 */
  }

  .drawer-number {
    font-size: 2rem;
    right: 5px;
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

  /* 诗词名言区移动端样式 */
  .poetry-quotes-section {
    padding: 3rem 1rem;
    min-height: 250px;
  }

  .quotes-container {
    min-height: 250px;
  }

  .quote-text {
    font-size: 2rem;
    letter-spacing: 0.2rem;
    gap: 0.3rem;
  }

  .quote-source {
    font-size: 1rem;
    letter-spacing: 0.1rem;
  }

  .ink-decoration {
    display: none;
  }

  .ancient-book-layout {
    grid-template-columns: repeat(2, 1fr);
    gap: 6px;
    padding: 6px;
  }

  .calligraphy-area {
    border-radius: 8px; /* 移动端使用稍小的圆角 */
  }

  .calligraphy-placeholder {
    border-radius: 8px; /* 移动端使用稍小的圆角 */
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
/* 调整“说诗”标题中的“诗”字（第二个字）向右移动 */
.video-section .calligraphy-char:last-child {
  position: relative;
  right: -30px;   /* 向右移动30像素，正值向右，负值向左 */
}

/* 调整“赏诗”标题中的“诗”字（第二个字）向右移动 */
.gallery-section .calligraphy-char:last-child {
  position: relative;
  right: -30px;   /* 向右移动30像素 */
}
</style>