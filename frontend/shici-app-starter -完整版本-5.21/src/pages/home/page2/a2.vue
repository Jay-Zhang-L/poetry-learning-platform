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
            <h2 class="introTitle">{{ currentPoet?.name || '魏晋名家' }}</h2>
            <p class="introDynasty">{{ currentPoet?.dynasty || '魏晋' }} · {{ currentPoet?.title || '文学家' }}</p>
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
import bg from '@/assets/chaodai/beijing2.jpg'

// 诗人图片（按顺序：葛洪、陶渊明、王羲之、温峤、谢安）
import gehongImg from '@/assets/chaodai/weijin_gehong.jpg'
import taoyuanmingImg from '@/assets/chaodai/weijin_taoyuanming.jpg'
import wangxizhiImg from '@/assets/chaodai/weijin_wangxizhi.jpg'
import wenqiaoImg from '@/assets/chaodai/weijin_wengqiao.jpg'
import xieanImg from '@/assets/chaodai/weijin_xiean.jpg'

// 诗集图片（使用魏晋相关图片）
import weijin1 from '@/assets/shiji/weijin1.jpg'
import weijin2 from '@/assets/shiji/weijin2.jpg'
import weijin3 from '@/assets/shiji/weijin3.jpg'

const router = useRouter()
const title = '魏晋'

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
    name: '葛洪',
    dynasty: '东晋',
    title: '道教学者 · 医药学家 · 炼丹家',
    intro: '葛洪（283-363），字稚川，号抱朴子，丹阳句容人。东晋著名道教学者、医药学家、炼丹家。少时家贫，躬耕樵薪，夜以继日读书。',
    extra: '葛洪著有《抱朴子》内外篇、《肘后备急方》等，对后世道教和医学发展影响深远。',
    quote: '我命在我不在天，还丹成金亿万年。',
    avatar: gehongImg
  },
  {
    id: 2,
    name: '陶渊明',
    dynasty: '东晋',
    title: '诗人 · 辞赋家 · 隐士',
    intro: '陶渊明（约365-427），字元亮，号五柳先生，浔阳柴桑人。东晋末至南朝宋初诗人、辞赋家，被誉为“隐逸诗人之宗”。',
    extra: '陶渊明开创田园诗派，代表作有《饮酒》《归园田居》《桃花源记》《五柳先生传》等。',
    quote: '采菊东篱下，悠然见南山。',
    avatar: taoyuanmingImg
  },
  {
    id: 3,
    name: '王羲之',
    dynasty: '东晋',
    title: '书法家 · 右军将军',
    intro: '王羲之（303-361），字逸少，琅琊临沂人。东晋著名书法家，有“书圣”之称。历任秘书郎、宁远将军、江州刺史，后为右军将军。',
    extra: '王羲之擅长楷、行、草诸体，代表作《兰亭序》被誉为“天下第一行书”。',
    quote: '后之视今，亦犹今之视昔。',
    avatar: wangxizhiImg
  },
  {
    id: 4,
    name: '温峤',
    dynasty: '东晋',
    title: '政治家 · 军事家',
    intro: '温峤（288-329），字太真，太原祁县人。东晋著名政治家、军事家。初为刘琨参军，后渡江辅佐晋元帝，官至骠骑大将军、开府仪同三司，封始安郡公。',
    extra: '温峤平定王敦、苏峻之乱，力保东晋江山，与王导、庾亮并称“中兴三贤”。',
    quote: '臣虽不武，敢竭忠节。',
    avatar: wenqiaoImg
  },
  {
    id: 5,
    name: '谢安',
    dynasty: '东晋',
    title: '政治家 · 名士',
    intro: '谢安（320-385），字安石，陈郡阳夏人。东晋著名政治家、名士，少时以清谈知名，隐居东山，年逾四十方出仕。',
    extra: '谢安指挥淝水之战大胜前秦，以功拜太保。其家族为东晋顶级门阀“陈郡谢氏”。',
    quote: '小儿辈遂已破贼。',
    avatar: xieanImg
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
    title: '《曹植雅诗》',
    author: '曹植',
    type: '行书 · 诗卷',
    description: '此卷为曹植诗作手稿，“高唐多悲风，朝日照北溟。”曹植（192-232），字子建，曹操之子，三国曹魏著名诗人，被誉为“建安之杰”。',
    extra: '曹植诗风“骨气奇高，词采华茂”，代表作有《洛神赋》《七步诗》《白马篇》等。',
    quote: '高唐多悲风，朝日照北溟。',
    cover: weijin1
  },
  {
    id: 2,
    title: '《颜平原鹿脯帖》',
    author: '颜真卿',
    type: '楷书 · 法帖',
    description: '颜真卿（709-785），字清臣，唐代名臣、书法家。此帖为颜真卿楷书珍品，笔法雄强厚重，有“颜体”之誉。',
    extra: '此帖原藏常州旧家，后为王长安所得，为希世之宝。',
    quote: '颜平原鹿脯帖真迹在常州一旧家，今为王长安。',
    cover: weijin2
  },
  {
    id: 3,
    title: '《白象赋》',
    author: '佚名',
    type: '行楷 · 赋文残卷',
    description: '此卷为魏晋赋文残篇，内容描绘白象祥瑞之兆，“炎海之滨，和气丛然，山川毓秀，播祥降精，祥纷瑞霁，煌煌荧荧而奇兽于是生焉。”',
    extra: '此赋文辞华美，展现了魏晋时期骈赋的艺术特色。',
    quote: '炎海之滨，和气丛然，山川毓秀。',
    cover: weijin3
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