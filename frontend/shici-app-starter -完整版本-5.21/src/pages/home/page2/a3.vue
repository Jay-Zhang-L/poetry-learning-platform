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
            <h2 class="introTitle">{{ currentPoet?.name || '唐代名家' }}</h2>
            <p class="introDynasty">{{ currentPoet?.dynasty || '唐代' }} · {{ currentPoet?.title || '文学家' }}</p>
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
import bg from '@/assets/chaodai/beijing3.jpg'

// 诗人图片（按顺序：贺知章、贾岛、陆羽、裴度、孙思邈）
import hezhizhangImg from '@/assets/chaodai/tang_hezhizhang.jpg'
import jiadaoImg from '@/assets/chaodai/tang_jiadao.jpg'
import luyuImg from '@/assets/chaodai/tang_luyu.jpg'
import peiduImg from '@/assets/chaodai/tang_peidu.jpg'
import sunsimiaoImg from '@/assets/chaodai/tang_sunsimiao.jpg'

// 诗集图片（使用唐代相关图片）
import tang1 from '@/assets/shiji/tang1.jpg'
import tang2 from '@/assets/shiji/tang2.jpg'
import tang3 from '@/assets/shiji/tang3.jpg'
import tang4 from '@/assets/shiji/tang4.jpg'
import tang5 from '@/assets/shiji/tang5.jpg'

const router = useRouter()
const title = '唐'

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
    name: '贺知章',
    dynasty: '唐代',
    title: '诗人 · 书法家 · 高官',
    intro: '贺知章（约659-744），字季真，晚年自号四明狂客，越州永兴人。唐代著名诗人、书法家。少时以诗文知名，武则天证圣元年中状元，官至太子宾客、秘书监。',
    extra: '贺知章旷达不羁，好酒善谑，与李白、张旭等为“饮中八仙”。其诗风清新通俗，《咏柳》《回乡偶书》等为传世名篇。',
    quote: '少小离家老大回，乡音无改鬓毛衰。',
    avatar: hezhizhangImg
  },
  {
    id: 2,
    name: '贾岛',
    dynasty: '唐代',
    title: '诗人 · 苦吟派代表',
    intro: '贾岛（779-843），字浪仙，范阳人。唐代著名诗人，早年出家为僧，后还俗应举。以苦吟著称，与孟郊并称“郊寒岛瘦”。',
    extra: '贾岛作诗讲究炼字，有“推敲”典故传世。代表作有《寻隐者不遇》《题李凝幽居》等。',
    quote: '两句三年得，一吟双泪流。',
    avatar: jiadaoImg
  },
  {
    id: 3,
    name: '陆羽',
    dynasty: '唐代',
    title: '茶学家 · 隐士',
    intro: '陆羽（733-804），字鸿渐，号竟陵子，复州竟陵人。唐代著名茶学家，被誉为“茶圣”。一生嗜茶，精于茶道，撰《茶经》三卷，为世界第一部茶叶专著。',
    extra: '陆羽隐居苕溪，著书立说，对茶文化发展影响深远。',
    quote: '茶者，南方之嘉木也。',
    avatar: luyuImg
  },
  {
    id: 4,
    name: '裴度',
    dynasty: '唐代',
    title: '政治家 · 诗人 · 名相',
    intro: '裴度（765-839），字中立，河东闻喜人。唐代著名政治家、诗人，历仕德宗、顺宗、宪宗、穆宗、敬宗、文宗六朝，官至中书令，封晋国公。',
    extra: '裴度力主削藩，平定淮西之乱，为“元和中兴”重臣。晚年居洛阳，与白居易、刘禹锡等唱和。',
    quote: '浮云不共此山齐，山霭苍苍望转迷。',
    avatar: peiduImg
  },
  {
    id: 5,
    name: '孙思邈',
    dynasty: '唐代',
    title: '医药学家 · 道士',
    intro: '孙思邈（541-682），京兆华原人。唐代著名医药学家、道士，被尊为“药王”。一生隐居修道，精研医理，著《千金要方》《千金翼方》，为中国医学发展作出巨大贡献。',
    extra: '孙思邈提出“大医精诚”的医德思想，至今为医者准则。',
    quote: '上医医国，中医医人，下医医病。',
    avatar: sunsimiaoImg
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
    title: '《赠无了禅师》',
    author: '佚名',
    type: '行书 · 禅诗残卷',
    description: '此卷为唐代禅诗手稿，“灵一作匡虚赠无了禅师神松不异藏宝石俱开向此师清堂义我双髻山瀑布濯云间尘世自发”。书法流畅自然，禅意盎然。',
    extra: '此残卷现藏于私人手中，为唐代书法珍品。',
    quote: '神松不异藏宝石，俱开向此师清堂。',
    cover: tang1
  },
  {
    id: 2,
    title: '《郎士元诗》',
    author: '郎士元',
    type: '楷书 · 五言诗稿',
    description: '郎士元，唐代诗人，“大历十才子”之一。此卷楷书工整端丽，内容为其五言诗作，“结庐就欢蜜，朗竹通经行。夕阳照分明，吾师任其下，禅生证无生。”',
    extra: '郎士元诗风清丽闲雅，深为时人所重。',
    quote: '结庐就欢蜜，朗竹通经行。',
    cover: tang2
  },
  {
    id: 3,
    title: '《温飞卿诗集》',
    author: '温庭筠',
    type: '刻本 · 诗集卷第一',
    description: '温庭筠（约812-866），字飞卿，唐代著名诗人、词人。此为其诗集卷第一，内含《鸡鸣埭歌》等名篇，为后世刊刻本。',
    extra: '温庭筠诗辞藻华丽，为花间词派鼻祖。',
    quote: '鸡鸣埭歌一曲，千古风流至今传。',
    cover: tang3
  },
  {
    id: 4,
    title: '《孟浩然诗》',
    author: '孟浩然',
    type: '行草 · 山水诗卷',
    description: '孟浩然（689-740），唐代著名山水诗人。此卷为其诗作手稿，“西山竞林，孟浩然诗”等字清晰可辨，书法飘逸洒脱。',
    extra: '孟浩然诗风清淡自然，与王维并称“王孟”。',
    quote: '西山竞林壑，归卧故山秋。',
    cover: tang4
  },
  {
    id: 5,
    title: '《茶经》',
    author: '陆羽',
    type: '楷书 · 茶道典籍',
    description: '陆羽《茶经》是世界第一部茶叶专著，全书三卷十章，系统论述茶叶起源、采制、煮饮及茶器等内容，奠定中国茶文化基础。',
    extra: '《茶经》对后世茶文化影响深远，陆羽因此被尊为“茶圣”。',
    quote: '茶之为用，味至寒，为饮最宜精行俭德之人。',
    cover: tang5
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
  bottom: calc(34px + 30vh);
  z-index: 3;
  color: #fff;
}

.heroTitle {
  font-size: 80px;
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
    font-size: 48px;
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