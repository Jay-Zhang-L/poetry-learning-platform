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
            <h2 class="introTitle">{{ currentPoet?.name || '宋代名家' }}</h2>
            <p class="introDynasty">{{ currentPoet?.dynasty || '宋代' }} · {{ currentPoet?.title || '文学家' }}</p>
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
import bg from '@/assets/chaodai/beijing4.jpg'

// 诗人图片（按顺序：韩琦、苏轼、苏辙、张栻、周敦颐）
import hanqiImg from '@/assets/chaodai/song_hanqi.jpg'
import sushiImg from '@/assets/chaodai/song_sushi.jpg'
import suzheImg from '@/assets/chaodai/song_suzhe.jpg'
import zhangshiImg from '@/assets/chaodai/song_zhangshi.jpg'
import zhouguoyiImg from '@/assets/chaodai/song_zhouguoyi.jpg'

// 诗集图片（使用宋代相关图片）
import song1 from '@/assets/shiji/song1.jpg'
import song2 from '@/assets/shiji/song2.jpg'
import song3 from '@/assets/shiji/song3.jpg'
import song4 from '@/assets/shiji/song4.jpg'
import song5 from '@/assets/shiji/song5.jpg'

const router = useRouter()
const title = '宋'

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
    name: '韩琦',
    dynasty: '北宋',
    title: '政治家 · 词人 · 宰相',
    intro: '韩琦（1008-1075），字稚圭，号赣叟，相州安阳人。北宋著名政治家、词人，与范仲淹并称“韩范”。历仕仁宗、英宗、神宗三朝，官至同中书门下平章事、右仆射，封魏国公。',
    extra: '韩琦为相十载，辅佐三朝，勤政爱民。其词风沉雄劲健，有《安阳集》传世。',
    quote: '满目山河空念远，落花风雨更伤春。',
    avatar: hanqiImg
  },
  {
    id: 2,
    name: '苏轼',
    dynasty: '北宋',
    title: '文学家 · 书画家 · 美食家',
    intro: '苏轼（1037-1101），字子瞻，号东坡居士，眉州眉山人。北宋文坛领袖，诗词文书画俱佳，与父苏洵、弟苏辙合称“三苏”。其诗题材广阔，清新豪健，词开豪放一派。',
    extra: '苏轼一生宦海沉浮，却始终豁达乐观。代表作有《念奴娇·赤壁怀古》《水调歌头》《赤壁赋》等。',
    quote: '竹杖芒鞋轻胜马，谁怕？一蓑烟雨任平生。',
    avatar: sushiImg
  },
  {
    id: 3,
    name: '苏辙',
    dynasty: '北宋',
    title: '文学家 · 政治家',
    intro: '苏辙（1039-1112），字子由，号颍滨遗老，眉州眉山人。北宋文学家、政治家，苏轼之弟。其文汪洋澹泊，深醇温粹，与兄苏轼齐名。',
    extra: '苏辙历官至门下侍郎，政见稳健。著有《栾城集》《春秋集解》等。',
    quote: '天下之患，最不可为者，名为治平无事，而其实有不测之忧。',
    avatar: suzheImg
  },
  {
    id: 4,
    name: '张栻',
    dynasty: '南宋',
    title: '理学家 · 教育家',
    intro: '张栻（1133-1180），字敬夫，号南轩，汉州绵竹人。南宋著名理学家、教育家，与朱熹、吕祖谦并称“东南三贤”。湖湘学派代表人物。',
    extra: '张栻主持岳麓书院多年，倡导“传道济民”之学。著有《南轩集》。',
    quote: '松声夜半如倾瀑，惊起山窗梦不成。',
    avatar: zhangshiImg
  },
  {
    id: 5,
    name: '周敦颐',
    dynasty: '北宋',
    title: '理学家 · 哲学家',
    intro: '周敦颐（1017-1073），字茂叔，号濂溪先生，道州营道人。北宋著名理学家，宋明理学开山鼻祖。其《太极图说》《通书》奠定了理学理论基础。',
    extra: '周敦颐一生清廉自守，爱莲成癖，《爱莲说》为其传世名篇。',
    quote: '出淤泥而不染，濯清涟而不妖。',
    avatar: zhouguoyiImg
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
    title: '《夏日》',
    author: '佚名',
    type: '行书 · 夏景诗帖',
    description: '此卷为宋代行书诗帖，内容描绘夏日清和景象：“清和节后绿枝稠，寂寞黄梅雨乍收。畏日正长凝碧汉，薰风微度到丹楼。”书法流畅自然，富有文人气息。',
    extra: '此帖现藏于私人手中，为宋代书法精品。',
    quote: '清和节后绿枝稠，寂寞黄梅雨乍收。',
    cover: song1
  },
  {
    id: 2,
    title: '《食荔枝》',
    author: '苏轼',
    type: '行书 · 岭南诗稿',
    description: '苏轼贬谪岭南时所作，“罗浮山下四时春，卢橘杨梅次第新。日啖荔枝三百颗，不辞长作岭南人。”诗中尽显东坡豁达乐观的人生态度。',
    extra: '此诗为苏轼晚年代表作之一，广为传诵。',
    quote: '日啖荔枝三百颗，不辞长作岭南人。',
    cover: song2
  },
  {
    id: 3,
    title: '《松声》',
    author: '张栻',
    type: '楷书 · 诗稿残卷',
    description: '张栻诗作，“松声夜半如倾瀑，惊起山窗梦不成。”此卷以楷书抄录，笔法端庄凝重，体现了理学家的严谨风范。',
    extra: '此残卷为张栻手迹，弥足珍贵。',
    quote: '松声夜半如倾瀑，惊起山窗梦不成。',
    cover: song3
  },
  {
    id: 4,
    title: '《清流》',
    author: '佚名',
    type: '草书 · 山水诗卷',
    description: '此卷草书奔放洒脱，内容描绘清流荷塘之景：“草铺横野六七里，笛弄晚风三四声。归来饱饭黄昏后，不脱蓑衣卧月明。”',
    extra: '此卷书法一气呵成，颇具宋代尚意书风。',
    quote: '草铺横野六七里，笛弄晚风三四声。',
    cover: song4
  },
  {
    id: 5,
    title: '《秋日》',
    author: '朱熹',
    type: '行楷 · 理学诗稿',
    description: '朱熹诗作，“半亩方塘一鉴开，天光云影共徘徊。问渠那得清如许？为有源头活水来。”以景喻理，深入浅出。',
    extra: '此诗体现了宋代“格物致知”的理学思想。',
    quote: '问渠那得清如许？为有源头活水来。',
    cover: song5
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