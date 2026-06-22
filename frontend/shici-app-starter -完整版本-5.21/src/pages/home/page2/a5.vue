<template>
  <div class="detailPage">
    <section class="hero" :style="{ backgroundImage: `url(${bg})`, backgroundSize: `${100 + scale * 10}%` }">
      <div class="heroMask"></div>

      <div class="closeWrap">
        <button class="closeBtn" type="button" @click="goBack">✕</button>
      </div>

      <div class="heroContent">
        <div class="heroTitle">{{ title }}</div>
      </div>

      <div
        class="scrollMask"
        :style="{ clipPath: `polygon(0 ${scale * 30 >= 100 ? 100 : scale * 30}%, 100% 0, 100% 100%, 0 100%)` }"
      ></div>
    </section>

    <section class="contentSection">
      <div class="contentWrap">
        <!-- 诗人区域 -->
        <div class="poetZone">
          <div class="poetStack">
            <div
              v-for="(poet, idx) in poets"
              :key="poet.id"
              class="poetCard"
              :class="{ expanded: expandedPoetId === poet.id }"
              @click="togglePoet(poet.id)"
              :style="getPoetStyle(idx, poet.id)"
            >
              <img :src="poet.avatar" :alt="poet.name" class="poetAvatar" />
            </div>
          </div>

          <div class="poetIntro">
            <h2 class="introTitle">{{ currentPoet?.name || '元代名家' }}</h2>
            <p class="introDynasty">{{ currentPoet?.dynasty || '元代' }} · {{ currentPoet?.title || '文学家' }}</p>
            <div class="introText">
              <p>{{ currentPoet?.intro }}</p>
              <p class="introExtra" v-if="currentPoet?.extra">{{ currentPoet.extra }}</p>
              <div class="introQuote" v-if="currentPoet?.quote">
                <span class="quoteMark">“</span>{{ currentPoet.quote }}<span class="quoteMark">”</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 诗集区域 -->
        <div class="anthologyZone">
          <div class="anthologyDesc">
            <h2 class="anthTitle">{{ currentAnthology.title }}</h2>
            <p class="anthMeta">{{ currentAnthology.author }} · {{ currentAnthology.type }}</p>
            <div class="anthText">
              <p>{{ currentAnthology.description }}</p>
              <p class="anthExtra" v-if="currentAnthology.extra">{{ currentAnthology.extra }}</p>
              <div class="anthQuote" v-if="currentAnthology.quote">
                <span class="quoteMark">「</span>{{ currentAnthology.quote }}<span class="quoteMark">」</span>
              </div>
            </div>
          </div>
          <div class="anthologyStack">
            <div
              v-for="(book, idx) in anthologies"
              :key="book.id"
              class="bookCard"
              :class="{ expandedBook: expandedBookId === book.id }"
              @click="toggleBook(book.id)"
              :style="getBookStyle(idx, book.id)"
            >
              <img :src="book.cover" :alt="book.title" class="bookCover" />
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { useRouter } from 'vue-router'
import bg from '@/assets/chaodai/beijing5.jpg'

// 诗人图片（按顺序：管道升、李致远、王庭筠、张可久、周权）
import guandaoshengImg from '@/assets/chaodai/yuan_guandaosheng.jpg'
import lizhiyuanImg from '@/assets/chaodai/yuan_lizhiyuan.jpg'
import wangtingyunImg from '@/assets/chaodai/yuan_wangtingyun.jpg'
import changkejiuImg from '@/assets/chaodai/yuan_zhangkejiu.jpg'
import zhouquanImg from '@/assets/chaodai/yuan_zhouquan.jpg'

// 诗集图片（按顺序：元1-5.jpg）
import yuan1 from '@/assets/shiji/yuan1.jpg'
import yuan2 from '@/assets/shiji/yuan2.jpg'
import yuan3 from '@/assets/shiji/yuan3.jpg'
import yuan4 from '@/assets/shiji/yuan4.jpg'
import yuan5 from '@/assets/shiji/yuan5.jpg'

const router = useRouter()
const title = '元'

function goBack() {
  const hallIndex = sessionStorage.getItem('homeReturnHallIndex')
  sessionStorage.removeItem('homeReturnMenuKey')
  if (hallIndex === null) {
    sessionStorage.setItem('homeReturnHallIndex', '0')
  }
  router.push('/home')
}

const scale = ref(1)
let detailPageEl = null
let handleScroll = null

onMounted(() => {
  detailPageEl = document.querySelector('.detailPage')
  if (detailPageEl) {
    handleScroll = () => {
      const scrollTop = detailPageEl.scrollTop
      scale.value = scrollTop / 100
    }
    detailPageEl.addEventListener('scroll', handleScroll)
  }
})

onBeforeUnmount(() => {
  if (detailPageEl && handleScroll) {
    detailPageEl.removeEventListener('scroll', handleScroll)
  }
})

// 诗人数据
const poets = ref([
  {
    id: 1,
    name: '管道升',
    dynasty: '元代',
    title: '女书法家 · 画家 · 词人',
    intro: '管道升（1262-1319），字仲姬，一字瑶姬，浙江吴兴人。元代著名女书法家、画家、词人，赵孟頫之妻。翰墨词章，不学而能，尤精于书画，其行楷与赵孟頫颇似，世称“管夫人”。',
    extra: '管道升与赵孟頫感情笃深，传世名作《我侬词》情深意切。其画作擅画墨竹梅兰，笔意清绝，著有《墨竹谱》传世。',
    quote: '尔侬我侬，忒煞情多。情多处，热似火。',
    avatar: guandaoshengImg
  },
  {
    id: 2,
    name: '李致远',
    dynasty: '元代',
    title: '散曲家 · 诗人',
    intro: '李致远，元代散曲家，生平事迹不详。其散曲作品以清丽婉约见长，多写景抒情之作，语言晓畅自然，意境深远。',
    extra: '《全元散曲》收录其小令多首，代表作有《小桃红》《落梅风》等，展现了元代散曲的多样风貌。',
    quote: '碧云天，黄花地，西风紧，北雁南飞。',
    avatar: lizhiyuanImg
  },
  {
    id: 3,
    name: '王庭筠',
    dynasty: '元代',
    title: '书画家 · 文学家',
    intro: '王庭筠（1151-1202），字子端，号黄华山主，辽东盖州人。元代著名书画家、文学家。其书法学米芾，善行草，画作以山水墨竹著称，笔法苍劲。',
    extra: '王庭筠文词渊雅，书法气韵生动，著有《黄华集》。与赵秉文、党怀英等交游，为金元之际文坛名家。',
    quote: '墨竹一竿，清风满纸。',
    avatar: wangtingyunImg
  },
  {
    id: 4,
    name: '张可久',
    dynasty: '元代',
    title: '散曲家 · 词人',
    intro: '张可久（约1270-1348），字小山，浙江宁波人。元代著名散曲家，与乔吉并称“曲中双璧”。其散曲作品数量为元代之冠，风格清丽典雅，工于写景咏物。',
    extra: '张可久一生未仕，以曲为业。著有《小山乐府》传世，代表作有《人月圆·山中书事》《卖花声·怀古》等。',
    quote: '兴亡千古繁华梦，诗眼倦天涯。',
    avatar: changkejiuImg
  },
  {
    id: 5,
    name: '周权',
    dynasty: '元代',
    title: '诗人 · 隐士',
    intro: '周权，字衡之，号此山，浙江松阳人。元代诗人。其诗风清雅淡远，多写山林隐逸之趣，与赵孟頫、袁桷等交游唱和。',
    extra: '周权一生不仕，隐居山林。著有《此山集》四卷，诗作被收入《元诗选》。欧阳玄称其诗“简淡和平，无雕琢之迹”。',
    quote: '青山一道同云雨，明月何曾是两乡。',
    avatar: zhouquanImg
  }
])

const expandedPoetId = ref(1)
const currentPoet = computed(() => poets.value.find(p => p.id === expandedPoetId.value))

function togglePoet(id) {
  expandedPoetId.value = id
}

function getPoetStyle(idx, id) {
  const isExpanded = expandedPoetId.value === id
  const total = poets.value.length
  const position = poets.value.findIndex(p => p.id === id)

  if (isExpanded) {
    return {
      zIndex: 20,
      transform: 'translateX(0) scale(1.1)',
      opacity: 1,
      filter: 'drop-shadow(0 15px 30px rgba(0,0,0,0.25))'
    }
  }

  const offsetX = -50 * (position + 1)
  const rotate = position % 2 === 0 ? 5 : -5
  return {
    zIndex: total - position,
    transform: `translateX(${offsetX}px) rotate(${rotate}deg)`,
    opacity: 0.85,
    filter: 'drop-shadow(0 5px 12px rgba(0,0,0,0.12))'
  }
}

// 诗集数据
const anthologies = ref([
  {
    id: 1,
    title: '《秋夜赋》',
    author: '管道升',
    type: '行书 · 秋思长卷',
    description: '管道升《秋夜赋》以行书书写，笔意婉转流丽，内容描绘秋夜寂寥与思乡之情，墨色浓淡相宜，尽显女性书法家的细腻与才情。',
    extra: '此卷现藏于北京故宫博物院，是管夫人传世书法珍品之一。',
    quote: '寂欲曙花时月共妍，摘青便濯幽并游佚地。',
    cover: yuan1
  },
  {
    id: 2,
    title: '《怀冷士诗》',
    author: '明本',
    type: '草书 · 禅意诗帖',
    description: '明本禅师（1263-1323），号中峰，元代高僧、书法家。其草书《怀冷士诗》笔势飞动，禅意盎然，内容抒发对隐逸高士的追怀之情。',
    extra: '明本与赵孟頫交谊深厚，其书法受赵孟頫影响，又自出机杼，别具禅趣。',
    quote: '西天目山幻住沙门明本误。',
    cover: yuan2
  },
  {
    id: 3,
    title: '《书史出门》',
    author: '佚名',
    type: '行楷 · 书论残卷',
    description: '此卷为元代书论残篇，内容论及学书之道与交友之诚，书法行楷相间，结体疏朗，反映了元代文人的书学思想。',
    extra: '残卷末有“清漏下教刻”等句，可见为文人日常书写之作，气息古雅。',
    quote: '曦余幼失恬良自天兄属志移为学守义思居莫问户滥。',
    cover: yuan3
  },
  {
    id: 4,
    title: '《小遗仙诗》',
    author: '方外生',
    type: '楷书 · 游仙诗卷',
    description: '此卷楷书工整端丽，内容为游仙诗二十首，想象瑰丽，辞采斐然。作者自署“此余方外生”，应为元代道士或隐者。',
    extra: '诗卷后有“余善迎和”等跋语，可见为道友唱和之作。',
    quote: '此余方外生余善迎和。小遗仙诗二十叶余加至长扬金也一堂如。',
    cover: yuan4
  },
  {
    id: 5,
    title: '《艺季禾秉》',
    author: '佚名',
    type: '草稿 · 农事杂录',
    description: '此残页为元代民间文书，内容杂记农时节气与耕作之事，书法潦草随性，却真实反映了元代百姓的生活面貌。',
    extra: '残页中有“不識一字每合作总东数方”等语，或为塾师教课杂写。',
    quote: '十月艺季禾秉农之植色乐。',
    cover: yuan5
  }
])

const expandedBookId = ref(1)
const currentAnthology = computed(() => anthologies.value.find(b => b.id === expandedBookId.value))

function toggleBook(id) {
  expandedBookId.value = id
}

function getBookStyle(idx, id) {
  const isExpanded = expandedBookId.value === id
  const total = anthologies.value.length
  const position = anthologies.value.findIndex(b => b.id === id)

  if (isExpanded) {
    return {
      zIndex: 20,
      transform: 'translateX(0) scale(1.1)',
      opacity: 1,
      filter: 'drop-shadow(0 15px 30px rgba(0,0,0,0.25))'
    }
  }

  const offsetX = 50 * (position + 1)
  const rotate = position % 2 === 0 ? 5 : -5
  return {
    zIndex: total - position,
    transform: `translateX(${offsetX}px) rotate(${rotate}deg)`,
    opacity: 0.85,
    filter: 'drop-shadow(0 5px 12px rgba(0,0,0,0.12))'
  }
}
</script>

<style scoped>
.scrollMask {
  position: absolute;
  bottom: -1px;
  left: 0;
  width: 100vw;
  height: 300px;
  background-color: #f7f4ee;
}

.detailPage {
  position: relative;
  width: 100%;
  height: 100vh;
  overflow-y: auto;
  background: #f7f4ee;
}

.hero {
  position: relative;
  width: 100%;
  height: 70vh;
  min-height: 260px;
  max-height: 1250px;
  background-size: cover;
  background-position: center 45%;
  overflow: hidden;
}

.heroMask {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, 0.18) 0%, rgba(0, 0, 0, 0.34) 100%);
}

.closeWrap {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 9999;
}

.closeBtn {
  width: 42px;
  height: 42px;
  border-radius: 50%;
  border: none;
  background: rgba(0, 0, 0, 0.35);
  color: #fff;
  font-size: 20px;
  cursor: pointer;
  backdrop-filter: blur(6px);
  transition: transform 0.25s ease, background 0.25s ease;
}

.closeBtn:hover {
  transform: scale(1.08);
  background: rgba(0, 0, 0, 0.55);
}

.heroContent {
  position: absolute;
  left: 48px;
  right: 48px;
  bottom: calc(34px + 25vh);
  z-index: 3;
  color: #fff;
}

.heroTitle {
  font-size: 52px;
  font-weight: 700;
  line-height: 1.1;
  margin-bottom: 12px;
}

.contentSection {
  position: relative;
  margin-top: 0;
  background: #f7f4ee;
  z-index: 2;
  min-height: 62vh;
}

.contentWrap {
  max-width: 1440px;
  margin: 0 auto;
  padding: 42px 32px 80px;
}

/* 诗人区域 */
.poetZone {
  display: flex;
  flex-wrap: wrap;
  gap: 60px;
  margin-bottom: 80px;
  background: transparent;
  padding: 20px 0;
  min-height: 580px;
}

.poetStack {
  flex: 1.2;
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 520px;
  margin-right: 0;
}

.poetCard {
  position: absolute;
  width: 280px;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.2, 0.9, 0.4, 1.2);
  background: transparent;
  right: 0px;
}

.poetAvatar {
  width: 100%;
  height: auto;
  aspect-ratio: 3 / 4;
  object-fit: cover;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
}

.poetIntro {
  flex: 1.5;
  background: transparent;
  padding: 20px 0 20px 40px;
  border-left: 2px solid #d4c5b0;
}

.introTitle {
  font-size: 52px;
  font-weight: 700;
  color: #2f241b;
  margin-bottom: 12px;
  letter-spacing: 2px;
}

.introDynasty {
  font-size: 16px;
  color: #a0815e;
  letter-spacing: 2px;
  margin-bottom: 28px;
  border-bottom: 1px solid #e0d3c2;
  display: inline-block;
  padding-bottom: 8px;
}

.introText {
  font-size: 16px;
  line-height: 1.9;
  color: #4e3f32;
  text-align: justify;
}

.introText p {
  margin-bottom: 16px;
}

.introExtra {
  font-size: 15px;
  color: #7a654f;
  font-style: italic;
  margin-top: 8px;
  padding-top: 8px;
  border-top: 1px dashed #e0d3c2;
}

.introQuote {
  margin-top: 24px;
  padding: 16px 20px;
  background: rgba(212, 197, 176, 0.2);
  font-size: 18px;
  font-weight: 500;
  color: #6b4c2c;
  text-align: center;
}

.quoteMark {
  font-size: 28px;
  font-family: serif;
  color: #b89a6e;
  margin: 0 4px;
}

/* 诗集区域 */
.anthologyZone {
  display: flex;
  flex-wrap: wrap;
  gap: 60px;
  background: transparent;
  padding: 20px 0;
  min-height: 580px;
}

.anthologyDesc {
  flex: 1.5;
  background: transparent;
  padding: 20px 40px 20px 0;
  border-right: 2px solid #d4c5b0;
  text-align: right;
}

.anthTitle {
  font-size: 44px;
  font-weight: 700;
  color: #2f241b;
  margin-bottom: 12px;
  letter-spacing: 2px;
}

.anthMeta {
  font-size: 15px;
  color: #a0815e;
  letter-spacing: 1px;
  margin-bottom: 28px;
  border-bottom: 1px solid #e0d3c2;
  display: inline-block;
  padding-bottom: 8px;
}

.anthText {
  font-size: 16px;
  line-height: 1.9;
  color: #4e3f32;
  text-align: justify;
}

.anthText p {
  margin-bottom: 16px;
}

.anthExtra {
  font-size: 15px;
  color: #7a654f;
  font-style: italic;
  margin-top: 8px;
  padding-top: 8px;
  border-top: 1px dashed #e0d3c2;
}

.anthQuote {
  margin-top: 24px;
  padding: 16px 20px;
  background: rgba(212, 197, 176, 0.2);
  font-size: 17px;
  font-weight: 500;
  color: #6b4c2c;
  text-align: center;
}

.anthologyStack {
  flex: 1.2;
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 520px;
  margin-left: 0;
}

.bookCard {
  position: absolute;
  width: 250px;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.2, 0.9, 0.4, 1.2);
  background: transparent;
  left: 0px;
}

.bookCover {
  width: 100%;
  height: auto;
  aspect-ratio: 3 / 4;
  object-fit: cover;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
}

/* 响应式 */
@media (max-width: 1200px) {
  .poetCard {
    width: 240px;
    right: 10px;
  }
  .bookCard {
    width: 210px;
    left: 10px;
  }
  .poetIntro {
    padding-left: 30px;
  }
  .anthologyDesc {
    padding-right: 30px;
  }
}

@media (max-width: 1000px) {
  .poetZone,
  .anthologyZone {
    flex-direction: column;
    gap: 40px;
  }

  .poetIntro {
    border-left: none;
    border-top: 2px solid #d4c5b0;
    padding: 30px 0 0 0;
  }

  .anthologyDesc {
    border-right: none;
    border-top: 2px solid #d4c5b0;
    padding: 30px 0 0 0;
    text-align: left;
  }

  .poetStack {
    margin-right: 0;
    overflow-x: auto;
    justify-content: flex-start;
    padding: 20px 0;
    gap: 24px;
    min-height: auto;
    position: relative;
  }

  .poetCard {
    position: relative;
    transform: none !important;
    width: 220px;
    margin: 0;
    right: 0;
  }

  .anthologyStack {
    margin-left: 0;
    overflow-x: auto;
    justify-content: flex-start;
    padding: 20px 0;
    gap: 24px;
    min-height: auto;
    position: relative;
  }

  .bookCard {
    position: relative;
    transform: none !important;
    width: 190px;
    margin: 0;
    left: 0;
  }

  .introTitle {
    font-size: 40px;
  }

  .anthTitle {
    font-size: 34px;
  }
}

@media (max-width: 640px) {
  .hero {
    height: 30vh;
    min-height: 220px;
  }

  .heroContent {
    left: 22px;
    right: 22px;
    bottom: 24px;
  }

  .heroTitle {
    font-size: 30px;
  }

  .contentWrap {
    padding: 30px 16px 60px;
  }

  .introTitle {
    font-size: 32px;
  }

  .anthTitle {
    font-size: 28px;
  }

  .poetCard {
    width: 170px;
  }

  .bookCard {
    width: 150px;
  }

  .introText,
  .anthText {
    font-size: 14px;
  }
}
</style>