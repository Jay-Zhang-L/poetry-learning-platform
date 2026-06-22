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
            <h2 class="introTitle">{{ currentPoet?.name || '清代名家' }}</h2>
            <p class="introDynasty">{{ currentPoet?.dynasty || '清代' }} · {{ currentPoet?.title || '文学家' }}</p>
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
import bg from '@/assets/chaodai/beijing1.jpg'

// 诗人图片
import liuyongImg from '@/assets/chaodai/liuyong.jpg'
import yuanmeiImg from '@/assets/chaodai/yuanmei.jpg'
import guyanwuImg from '@/assets/chaodai/guyanwu.jpg'
import caoxueqinImg from '@/assets/chaodai/caoxueqing.jpg'
import zhangwentaoImg from '@/assets/chaodai/zhangwentao.jpg'

// 诗集图片
import caoSangzi from '@/assets/shiji/shiji1.jpg'
import liangShiGong from '@/assets/shiji/shiji2.jpg'
import wangWenZhi from '@/assets/shiji/shiji3.jpg'
import yuanMeiSuoJian from '@/assets/shiji/shiji4.jpg'
import liangShiCe from '@/assets/shiji/shiji5.jpg'

const router = useRouter()
const title = '清'

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
    name: '刘墉',
    dynasty: '清代',
    title: '书法家 · 政治家 · 大学士',
    intro: '刘墉（1719-1805），字崇如，号石庵，山东诸城人。清代乾嘉年间重臣，官至体仁阁大学士，加太子太保。其书法用墨厚重，体丰骨劲，浑厚敦实，与翁方纲、梁同书、王文治并称“清代四大书法家”。尤擅小楷，笔法精妙，结构严谨。为官清廉，刚正不阿，深得百姓爱戴，民间有“刘罗锅”之美誉。',
    extra: '刘墉一生勤于政事，亦精研书法艺术，其《石庵诗集》《清爱堂帖》传世，对后世书法影响深远。乾隆皇帝曾赞其“人书俱老，德艺双馨”。',
    quote: '写字当如做人，一笔一划，皆见风骨。',
    avatar: liuyongImg
  },
  {
    id: 2,
    name: '袁枚',
    dynasty: '清代',
    title: '诗人 · 散文家 · 文学评论家',
    intro: '袁枚（1716-1798），字子才，号简斋，晚年自号随园主人，浙江钱塘人。清代乾嘉时期代表诗人、散文家、文学评论家，与赵翼、蒋士铨并称“乾隆三大家”。倡导“性灵说”，主张诗文创作应直抒胸臆，表现个人真情实感，反对模拟古人和格调束缚。',
    extra: '袁枚辞官后隐居南京小仓山随园，广收诗弟子，女弟子尤众，开一代风气之先。著有《小仓山房诗文集》《随园诗话》《子不语》《随园食单》等。',
    quote: '凡人之情，其目悦，其体适，则其心自怡。诗者，由情生者也。',
    avatar: yuanmeiImg
  },
  {
    id: 3,
    name: '顾炎武',
    dynasty: '明末清初',
    title: '思想家 · 经学家 · 史地学家',
    intro: '顾炎武（1613-1682），本名绛，字宁人，号亭林，江苏昆山人。明末清初杰出的思想家、经学家、史地学家，与黄宗羲、王夫之并称“明末清初三大儒”。提出“天下兴亡，匹夫有责”的著名论断，主张“经世致用”的实学思想，开清代朴学之风。',
    extra: '顾炎武一生著书立说，学术渊博，于经学、史学、音韵学、地理学皆有精深研究。代表作《日知录》《天下郡国利病书》《音学五书》。',
    quote: '天下兴亡，匹夫有责。君子为学，以明道也，以救世也。',
    avatar: guyanwuImg
  },
  {
    id: 4,
    name: '曹雪芹',
    dynasty: '清代',
    title: '小说家 · 诗人 · 画家',
    intro: '曹雪芹（约1715-约1763），名霑，字梦阮，号雪芹，又号芹溪、芹圃，满洲正白旗人。清代伟大的文学家，古典小说巅峰之作《红楼梦》的作者。其诗风哀婉深沉，借“石头”之言抒家国兴亡之叹。',
    extra: '曹雪芹出身清代内务府正白旗包衣世家，早年亲历繁华，后家道中落，在贫病交加中创作《红楼梦》。',
    quote: '满纸荒唐言，一把辛酸泪。都云作者痴，谁解其中味？',
    avatar: caoxueqinImg
  },
  {
    id: 5,
    name: '张问陶',
    dynasty: '清代',
    title: '诗人 · 书画家 · 性灵派大家',
    intro: '张问陶（1764-1814），字仲冶，号船山，四川遂宁人。清代乾嘉时期著名诗人、书画家，与袁枚、赵翼并称“性灵派三大家”。其诗风空灵疏秀，兼擅书画。',
    extra: '著有《船山诗草》二十卷。袁枚赞其“沉郁空灵，为清代蜀中诗人之冠”。',
    quote: '天籁自鸣天趣足，好诗不过近人情。',
    avatar: zhangwentaoImg
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
    title: '《采桑子》',
    author: '陶元藻',
    type: '词集 · 清雅婉约',
    description: '陶元藻（1716-1801），字龙溪，号篁村，浙江会稽人。清代著名诗人、学者。《采桑子》为其代表词作，以采桑为引，描绘江南田园风光与闺中情思，语言清丽婉转，意境悠远。',
    extra: '此词牌下多首作品被收录于《全清词》，展现了清代中叶词坛的婉约风貌。陶元藻一生著述颇丰，有《泊鸥山房集》《全浙诗话》等传世。',
    quote: '采桑径里逢春色，笑语盈盈暗香去。',
    cover: caoSangzi
  },
  {
    id: 2,
    title: '《十宫词》',
    author: '梁诗正',
    type: '行书 · 宫廷诗帖',
    description: '梁诗正（1697-1763），字养仲，号芗林，浙江钱塘人。清代名臣，书法家，乾隆朝大学士。其行书《十宫词》以历代宫廷为题材，笔法遒劲秀逸，结构严谨，被誉为“清代行书典范”。',
    extra: '此帖现藏于故宫博物院，为国家一级文物。',
    quote: '行云流水间，尽显庙堂气象。',
    cover: liangShiGong
  },
  {
    id: 3,
    title: '《题画》',
    author: '王文治',
    type: '诗卷 · 题画绝句',
    description: '王文治（1730-1802），字禹卿，号梦楼，江苏丹徒人。清代著名书法家、诗人，与刘墉、翁方纲、梁同书并称“清代四大书法家”。',
    extra: '王文治书法学董其昌、米芾，秀逸天成，有“淡墨探花”之誉。',
    quote: '画到神情飘没处，更无真象有真魂。',
    cover: wangWenZhi
  },
  {
    id: 4,
    title: '《所见》',
    author: '袁枚',
    type: '五言绝句 · 性灵小品',
    description: '袁枚《所见》是其性灵诗风的代表作：“牧童骑黄牛，歌声振林樾。意欲捕鸣蝉，忽然闭口立。”全诗捕捉乡村童趣瞬间，语言浅白自然，却生动传神。',
    extra: '此诗被选入小学语文教材，是清代性灵派诗歌最脍炙人口的作品之一。',
    quote: '牧童骑黄牛，歌声振林樾。意欲捕鸣蝉，忽然闭口立。',
    cover: yuanMeiSuoJian
  },
  {
    id: 5,
    title: '《集古诗册页》',
    author: '梁诗正',
    type: '书法集帖 · 楷行草三体',
    description: '梁诗正《集古诗册页》汇集晋唐以来名家诗句，以楷、行、草三体书写，展现其深厚的书法功底和对古典诗词的深刻理解。',
    extra: '此册页共十二开，是清代馆阁体与文人书法结合的典范之作。',
    quote: '集古人之大成，开一家之风貌。',
    cover: liangShiCe
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

.heroDesc {
  font-size: 48px;
  opacity: 0.92;
  line-height: 1.7;
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

/* 诗人区域 - 图片紧贴竖线 */
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

/* 诗集区域 - 图片紧贴竖线 */
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

  .heroDesc {
    font-size: 14px;
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