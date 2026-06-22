
<!-- src/pages/Home.vue -->
<template>
  <div class="homePage">
    <div class="fullPager" :class="{ 'page-shifting': pageShifting, 'shift-down': shiftDirection === 'down', 'shift-up': shiftDirection === 'up' }" ref="pagerRef" @wheel.prevent="onWheel" @touchstart.passive="onTouchStart"
      @touchmove.passive="onTouchMove" @touchend="onTouchEnd">
      <div class="pages" :style="pagesStyle">
        <!-- 第一屏 -->
        <section class="page stage">
          <CardCarousel v-if="route.path === '/home'" :cards="carouselCards"></CardCarousel>
        </section>

        <!-- 第二屏 -->
        <section class="page hallWrap">
          <div class="hallBluePanel" :style="hallBluePanelStyle" aria-hidden="true">
          </div>
          <div class="hallBlueGlow" aria-hidden="true"></div>
          <div class="hallCurveMask" aria-hidden="true"></div>

          <div class="hallViewport">
            <div class="hallContent">
              <div class="hallCopyZone">
                <transition name="hall-copy-switch" mode="out-in">
                  <div class="hallCopy" :key="hallYears[activeIndex]">
                    <div class="hallYearText">{{ hallSceneMeta[activeIndex].title }}</div>
                    <div class="hallCopyTitle">{{ hallSceneMeta[activeIndex].period }}</div>
                    <div class="hallCopyLine"></div>
                    <div class="hallCopyCn">
                      <div class="hallInfoBlock">
                        <span class="hallInfoLabel">代表诗人</span>
                        <span class="hallInfoValue">{{ hallSceneMeta[activeIndex].poets }}</span>
                      </div>
                      <div class="hallInfoBlock works">
                        <span class="hallInfoLabel">代表作</span>
                        <span class="hallInfoValue">{{ hallSceneMeta[activeIndex].works }}</span>
                      </div>
                    </div>
                  </div>
                </transition>
              </div>

              <div class="hallDialStage">
                <div class="hallDialShell" aria-hidden="true">
                  <div class="hallDialOuter" :style="hallOuterBgStyle"></div>
                  <div class="hallDialInner"></div>

                  <div class="hallDialRotor" :style="hallDialRotateStyle">
                    <img class="hallDialFrame" :src="hallFrame" alt="" />
                    <div class="hallDialTicks">
                      <span v-for="tick in hallTicks" :key="'tick-' + tick" class="hallDialTick"
                        :style="hallTickStyle(tick)"></span>
                    </div>
                  </div>

                  <div class="hallDialYears">
                    <span v-for="(year, i) in hallYears" :key="year" class="hallDialYear"
                      :class="{ on: i === activeIndex }" :style="hallYearStyle(i)" @click="setActive(i, true)">
                      {{ year }}
                    </span>
                  </div>

                  <div class="hallDialFocusLine"></div>
                  <div class="hallDialHubYear">{{ hallYears[activeIndex] }}</div>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- 第三屏 -->
        <section class="page menuSixWrap" :class="{
          enter: menuEnter,
          zooming: menuZooming
        }">
          <div class="menuHeroBg current"
            :style="{ backgroundImage: `url(${menuSix[menuActive]?.img || menuSix[0].img})` }" aria-hidden="true"></div>
          <div class="menuHeroMask" aria-hidden="true"></div>
          <div class="menuHeroGlow" aria-hidden="true"></div>

          <div class="menuHeroTop">
            <div class="menuHeroTabs">
              <button v-for="(m, i) in menuSix" :key="m.key + '-tab'" class="menuHeroTab"
               :class="{
  on: i === menuActive,
  locked: menuZooming && !menuReturning,
  hidden: menuZooming && zoomTarget && zoomTarget.key !== m.key
}"
              </button>
            </div>
          </div>

          <div class="menuHeroMain">
            <div v-if="currentMenuDetail" class="menuHeroInfo">
              <div class="menuHeroMini">诗词分类</div>
              <div class="menuHeroBig">{{ currentMenuDetail.title }}</div>
              <div class="menuHeroDesc">{{ currentMenuDetail.desc }}</div>
              <div class="menuHeroQuote">“{{ currentMenuDetail.quote }}”</div>
              <div class="menuHeroChips">
                <span v-for="sub in currentMenuDetail.subs" :key="sub" class="menuHeroChip">
                  {{ sub }}
                </span>
              </div>
              <button class="menuHeroBtn" type="button" @click="goPage(3)">
                进入诗词长廊
              </button>
            </div>

            <div class="menuHeroRailWrap">
              <button class="menuHeroArrow left" type="button" :disabled="menuZooming" @click="changeMenu(-1)">
                ‹
              </button>
              <div class="closeWrap">
                <button class="closeBtn" type="button" v-if="showCloseBtn" @click="goBack">✕</button>
              </div>

              <div class="menuHeroRail">
                <button v-for="(m, i) in menuSix" :key="m.key" class="menuHeroStrip" :class="{
                  on: i === menuActive,
                  locked: menuZooming && !menuReturning,
                  returning: menuReturning && zoomTarget && zoomTarget.key === m.key,
                  hidden: menuZooming && zoomTarget && zoomTarget.key !== m.key
                }" type="button" :ref="(el) => setMenuStripRef(el, i)" @click="handleMenuClick(i, m)">
                  <div class="menuHeroStripImg" :style="{ backgroundImage: `url(${m.img})` }"></div>
                  <div class="menuHeroStripShade"></div>
                  <div class="menuHeroStripText" v-show="!(menuZooming && zoomTarget && zoomTarget.key === m.key)">{{
                    m.big }}</div>
                </button>
              </div>

              
<div class="contentWrap" v-if="contentWrapVisible && currentMenuContent">
                <div class="sectionTitle" :class="{ 'fade-in': contentFadeIn }">
                  <p
                    v-for="(paragraph, idx) in currentMenuContent.paragraphs"
                    :key="currentMenuContent.key + '-p-' + idx"
                    class="sectionParagraph"
                  >
                    {{ paragraph }}
                  </p>
                </div>

                <div class="picWrap" :class="{ 'fade-in': contentFadeIn }">
                  <div class="themePicCard">
                    <img :src="currentMenuContent.image" :alt="currentMenuContent.title">
                    <div class="themePicOverlay"></div>
                    <div class="themePicCaption">
                      <div class="themePicLabel">{{ currentMenuContent.title }}</div>
                      <div class="themePicQuote">“{{ currentMenuContent.quote }}”</div>
                    </div>
                  </div>
                </div>
              </div>
              <button class="menuHeroArrow right" type="button" :disabled="menuZooming" @click="changeMenu(1)">
                ›
              </button>
            </div>
          </div>

          <div class="menuHeroBottom">
            <div class="menuHeroDots">
              <button v-for="(m, i) in menuSix" :key="m.key + '-dot'" class="menuHeroDot"
                :class="{ on: i === menuActive }" type="button" @click="handleMenuClick(i, m)"></button>
            </div>
          </div>
        </section>

        <!-- 第四屏 -->
        <section class="page spiralSection" ref="spiralRef">
          <div class="spiralBg" :style="{ backgroundImage: blackGoldUrl }" aria-hidden="true"></div>
          <div class="spiralBgMask" aria-hidden="true"></div>

          <div class="spiralInkFog" aria-hidden="true"></div>
          <div class="spiralLight" aria-hidden="true"></div>

          <div class="spiralTopBar">
            <div class="spiralTopLeft">
              <div class="spiralTitle">诗词长廊</div>
              <div class="spiralSub">拖拽旋转 · 滚轮推进 · 点击卡片看详情</div>
            </div>
            <div class="spiralTopRight">
              <div class="spiralTipPill">拖拽旋转</div>
              <div class="spiralTipPill">滚轮推进</div>
              <div class="spiralTipPill">点击详情</div>
            </div>
          </div>

          <PoetrySpiralInteractive class="spiralFull" :items="spiralItems" :pitch="20" :radius="700" :tilt="3"
            :cardW="195" :cardH="360" :perspective="1800" @go="onSpiralGo" />
        </section>

        <!-- 第五屏 -->
        <section class="page lastHub">
          <div class="hubBg" aria-hidden="true"></div>
          <div class="hubLight" aria-hidden="true"></div>

          <div class="hubWrap" ref="hubWrapRef">
            <!-- 诗词小知识 -->
            <div class="hubBlock">
              <div class="hubTitleRow">
                <i class="hubBar" aria-hidden="true"></i>
                <h2 class="hubTitle">诗词小知识</h2>
                <span class="hubSubtitle">每日更新</span>
              </div>

              <div class="dailyKnowledge">
                <div class="knowledgeCard featured">
                  <div class="knowledgeDate">{{ todayDate }}</div>
                  <div class="knowledgeTitle">{{ dailyKnowledge.title }}</div>
                  <div class="knowledgeContent">{{ dailyKnowledge.content }}</div>
                  <div class="knowledgeTag">{{ dailyKnowledge.tag }}</div>
                </div>
              </div>

              <div class="hubGrid knowledge">
                <button v-for="item in knowledgeList" :key="item.key" class="hubCard" type="button"
                  @click="openKnowledgeModal(item.pageKey)">
                  <div class="hubThumb" :style="{ backgroundImage: `url(${normalizeKnowledgeUrl(item.cover)})` }">
                    <div class="thumbOverlay"></div>

                  </div>
                  <div class="hubCardTitle">{{ item.title }}</div>
                  <div class="hubCardDesc">{{ item.desc }}</div>
                </button>
              </div>
            </div>

            <!-- 视频推荐 -->
            <div class="hubBlock">
              <div class="hubTitleRow">
                <i class="hubBar" aria-hidden="true"></i>
                <h2 class="hubTitle">视频推荐</h2>
                <span class="hubSubtitle">名家朗诵 · 诗词解析</span>
              </div>

              <div class="hubGrid video">
                <button v-for="item in videoList" :key="item.id || item.key" class="hubCard videoCard" type="button"
                  @click="playVideo(item)">
                  <div class="hubThumb video" :style="bgImg(getCoverUrl(item.coverUrl || item.cover))">
                    <div class="thumbOverlay"></div>
                    <div class="playIcon">▶</div>
                    <div class="videoDuration">{{ item.duration || '00:00' }}</div>
                  </div>
                  <div class="hubCardTitle">{{ item.title }}</div>
                  <div class="videoMeta">
                    <span class="videoAuthor">{{ item.author || '未知' }}</span>
                    <span class="videoViews">{{ formatViews(item.views) }}观看</span>
                  </div>
                </button>
              </div>
            </div>
          </div> <!-- 这里必须有关闭 hubWrap 的 </div> -->
        </section> <!-- 这里必须有关闭 lastHub 的 </section> -->
      </div> <!-- 关闭 pages -->

      <!-- 侧边导航点 -->
      <div class="sideDots" aria-hidden="true">
        <button class="sd" :class="{ on: pageIndex === 0 }" @click="goPage(0)"></button>
        <button class="sd" :class="{ on: pageIndex === 1 }" @click="goPage(1)"></button>
        <button class="sd" :class="{ on: pageIndex === 2 }" @click="goPage(2)"></button>
        <button class="sd" :class="{ on: pageIndex === 3 }" @click="goPage(3)"></button>
        <button class="sd" :class="{ on: pageIndex === 4 }" @click="goPage(4)"></button>
      </div>

      <!-- 诗词详情弹窗 -->
      <transition name="fade">
        <div v-if="detailVisible" class="poetryDetailMask" @click="closeDetail">
          <div class="poetryDetailPanel" @click.stop>
            <button class="detailCloseBtn" @click="closeDetail">关闭</button>

            <div v-if="currentPoetry" class="detailBody">
              <div class="detailTag">{{ currentPoetry.tag }}</div>
              <div class="detailTitle">{{ currentPoetry.title }}</div>
              <div class="detailMeta">
                {{ currentPoetry.author }} · {{ currentPoetry.dynasty }}
              </div>

              <div class="detailBlock">
                <div class="detailLabel">主题</div>
                <div class="detailText">{{ currentPoetry.theme }}</div>
              </div>

              <div class="detailBlock">
                <div class="detailLabel">原句</div>
                <div class="detailText detailLine">{{ currentPoetry.line }}</div>
              </div>

              <div class="detailBlock">
                <div class="detailLabel">释义</div>
                <div class="detailText">{{ currentPoetry.meaning }}</div>
              </div>

              <div class="detailBlock">
                <div class="detailLabel">赏析</div>
                <div class="detailText">{{ currentPoetry.appreciation }}</div>
              </div>

              <div class="detailBlock">
                <div class="detailLabel">难度</div>
                <div class="detailText">{{ currentPoetry.level }}</div>
              </div>

              <div class="detailBlock">
                <div class="detailLabel">关键词</div>
                <div class="detailKeywordRow">
                  <span v-for="key in currentPoetry.keywords || []" :key="key" class="detailKeyword">
                    {{ key }}
                  </span>
                </div>
              </div>

              <div class="detailBlock">
                <div class="detailLabel">编号</div>
                <div class="detailText">{{ currentPoetry.serialNo }}</div>
              </div>
            </div>
          </div>
        </div>
      </transition>

      <!-- 知识详情弹窗 -->
      <transition name="modal-fade">
        <div v-if="showKnowledgeModal" class="knowledge-modal-mask" @click="closeKnowledgeModal">
          <div class="knowledge-modal-container" @click.stop>
            <div class="knowledge-modal">
              <div class="modal-header" :style="{ backgroundImage: 'url(' + currentKnowledge.imageBg + ')' }">
                <button class="modal-close-btn" @click="closeKnowledgeModal">✕</button>
                <h2>{{ currentKnowledge.title }}</h2>
                <span class="modal-category">{{ currentKnowledge.category }}</span>
              </div>

              <div class="modal-body">
                <div class="modal-inner">
                  <section class="modal-section intro-section">
                    <div class="section-head">
                      <span class="section-icon">📖</span>
                      <h3>内容介绍</h3>
                    </div>
                    <p class="intro-text">{{ currentKnowledge.fullDescription }}</p>
                  </section>

                  <section v-if="currentKnowledge.images && currentKnowledge.images.length"
                    class="modal-section gallery-section">
                    <div class="modal-illustration-area">
                      <div v-for="(img, idx) in currentKnowledge.images" :key="idx" class="modal-image-wrapper">
                        <img :src="img.imageUrl" :alt="img.imageDesc" class="modal-image-real" />
                        <div class="modal-image-caption">{{ img.imageDesc }}</div>
                      </div>
                    </div>
                  </section>

                  <section class="modal-section analysis-section">
                    <div class="section-head">
                      <span class="section-icon">📝</span>
                      <h3>详细赏析</h3>
                    </div>
                    <div class="modal-text-shell">
                      <div class="modal-text-content" v-html="currentKnowledge.detailText"></div>
                    </div>
                  </section>
                </div>
              </div>

              <div class="modal-footer">
                <button class="modal-close-footer" @click="closeKnowledgeModal">关闭</button>
              </div>
            </div>
          </div>
        </div>
      </transition>
    </div> <!-- 关闭 fullPager -->
  </div> <!-- 关闭 homePage -->
</template>

<script setup>
import { getKnowledgeList, getKnowledgeDetail } from '@/utils/api'
import {
  ref,
  computed,
  onMounted,
  onUnmounted,
  reactive,
  watch,
  inject
} from "vue";

import { useRouter, useRoute } from "vue-router";
import { defineAsyncComponent } from 'vue';
const TheSongPainted = defineAsyncComponent(() => import('../components/TheSongPainted.vue'));
const CardCarousel = defineAsyncComponent(() => import('../components/CardCarousel.vue'));
import PoetrySpiralInteractive from "./home/components/PoetrySpiralInteractive.vue";

// 引入 CardCarousel 所需的图片
import portalBg1 from '../assets/images/navigation/portal_01.png';
import portalBg2 from '../assets/images/navigation/portal_02.png';
import portalBg3 from '../assets/images/navigation/portal_03.png';
import portalBg4 from '../assets/images/navigation/portal_04.png';
import portalBg5 from '../assets/images/navigation/portal_05.png';
import portalBg6 from '../assets/images/navigation/portal_06.png';
import poetry100 from "../mock/poetry100";

import s1 from "../assets/home/scroll/1.jpg";
import s2 from "../assets/home/scroll/2.jpg";
import s3 from "../assets/home/scroll/3.jpg";
import s4 from "../assets/home/scroll/4.jpg";
import s5 from "../assets/home/scroll/5.jpg";
import s6 from "../assets/home/scroll/6.jpg";
import hallBg1 from "../assets/home2/左1.jpg";
import hallBg2 from "../assets/home2/左2.jpg";
import hallBg3 from "../assets/home2/左3.jpg";
import hallBg4 from "../assets/home2/左4.jpg";
import hallBg5 from "../assets/home2/左5.jpg";
import hallBg6 from "../assets/home2/左6.jpg";
import hallFrame from "../assets/home2/框框.png";
// 在导入区域添加（大约在第 150 行附近）
import dialBgImg from '@/assets/home2/bg.jpg'  // 替换为实际图片名

import bgBlackGold from "../assets/han/bg_black_gold.jpg";
import { getVideoList, addVideoView } from "../utils/api";

const hallOuterBgStyle = computed(() => ({
  backgroundImage: `url(${dialBgImg})`,
  backgroundSize: 'cover',
  backgroundPosition: 'center',
  backgroundRepeat: 'no-repeat',
  backgroundColor: 'transparent',
  boxShadow: '0 22px 60px rgba(40, 47, 120, .14)'
}))
const music = inject('musicControl')
const isMusicPlaying = ref(false)

const toggleMusic = async () => {
  if (!music) return
  const state = await music.toggle()
  isMusicPlaying.value = state
}

const router = useRouter();
const route = useRoute();

// CardCarousel 组件所需的数据
const carouselCards = ref([
  {
    image: portalBg1,
    name: '诗',
    location: '凝千年文脉',
    description: '以平仄立韵，以字句寄情，藏山河风月，写人间悲欢，是东方文学最初的浪漫与风骨。'
  },
  {
    image: portalBg2,
    name: '歌',
    location: '以声入文',
    description: '以声入文，以韵和鸣。随心而咏，随口而唱，融市井烟火与天地情志，婉转悠扬，流转岁月人间。'
  },
  {
    image: portalBg3,
    name: '赋',
    location: '铺陈辞藻',
    description: '铺陈辞藻，铺展山河。辞采华美，气象恢弘，状物叙事极尽铺排，纳天地万象于笔墨，尽显古典文辞之富丽雍容。'
  },
  {
    image: portalBg4,
    name: '词',
    location: '倚声填韵',
    description: '依曲定调，长短成句，藏闺意离愁、家国情怀，字句温柔缱绻，尽是中式含蓄之美。'
  },
  {
    image: portalBg5,
    name: '曲',
    location: '俗雅相融',
    description: '俗雅相融，洒脱随性。格律自由，直白真切，写俗世百态、江湖风月，烟火气与诗意共生，灵动而旷达。'
  }
]);

function go(p) {
  router.push(p);
}

const pagerRef = ref(null);
const spiralRef = ref(null);

const initialReturnMenuKey = typeof window !== 'undefined' ? sessionStorage.getItem('homeReturnMenuKey') : null;
const initialReturnHallIndex = typeof window !== 'undefined' ? sessionStorage.getItem('homeReturnHallIndex') : null;
const pageIndex = ref(initialReturnHallIndex !== null ? 1 : (initialReturnMenuKey ? 2 : 0));
const pageCount = 5;

// 监听路由变化，当show=portal时跳转到第一屏
watch(() => route.query.show, (newShow) => {
  if (newShow === 'portal') {
    pageIndex.value = 0;
  }
}, { immediate: true });

const pagesStyle = computed(() => {
  const y = -pageIndex.value * 100;
  return { transform: `translate3d(0, ${y}vh, 0)` };
});

function clamp(n, a, b) {
  return Math.max(a, Math.min(b, n));
}

let pageLock = false;
let wheelAcc = 0;
let wheelTimer = null;
let pageShiftTimer = null;
const pageShifting = ref(false);
const shiftDirection = ref("down");

const menuEnter = ref(false);

function triggerMenuEnter() {
  menuEnter.value = false;
  requestAnimationFrame(() => {
    requestAnimationFrame(() => {
      menuEnter.value = true;
      setTimeout(() => {
        menuEnter.value = false;
      }, 760);
    });
  });
}

function goPage(i) {
  const prev = pageIndex.value;
  const next = clamp(i, 0, pageCount - 1);
  if (next === prev) return;

  shiftDirection.value = next > prev ? "down" : "up";
  pageShifting.value = true;
  if (pageShiftTimer) clearTimeout(pageShiftTimer);
  pageShiftTimer = setTimeout(() => {
    pageShifting.value = false;
  }, 760);

  pageIndex.value = next;
  if (next === 2) triggerMenuEnter();
}

function nextPage() {
  goPage(pageIndex.value + 1);
}

function prevPage() {
  goPage(pageIndex.value - 1);
}

const hubWrapRef = ref(null);

function bgImg(url) {
  return { backgroundImage: `url(${url})` };
}

const todayDate = computed(() => {
  const now = new Date();
  const month = now.getMonth() + 1;
  const day = now.getDate();
  return `${month}月${day}日`;
});

const dailyKnowledge = computed(() => {
  const knowledges = [
    {
      title: "诗词中的“月”意象",
      content:
        "月亮在中国古典诗词中是最常见的意象之一，常用来表达思乡、离别、孤独等情感。如李白的“举头望明月，低头思故乡”，苏轼的“但愿人长久，千里共婵娟”，都是千古传诵的名句。",
      tag: "意象解析",
    },
    {
      title: "什么是飞花令？",
      content:
        "飞花令源自古人的诗词游戏，得名于“春城无处不飞花”。行令时，参与者需要说出包含指定字的诗句，是一种兼具文学性、趣味性和竞技性的传统雅戏。",
      tag: "诗词游戏",
    },
    {
      title: "唐诗的格律之美",
      content:
        "唐诗讲究平仄、对仗、押韵，形成了独特的音韵美。五言绝句、七言律诗等体裁，都有较严格的格律要求，体现了中国古典诗歌在形式上的高度成熟。",
      tag: "格律知识",
    },
  ];
  const dayOfYear = Math.floor(
    (new Date() - new Date(new Date().getFullYear(), 0, 0)) / 86400000
  );
  return knowledges[dayOfYear % knowledges.length];
});

// 弹窗相关数据
const showKnowledgeModal = ref(false)
const currentKnowledge = ref({
  title: '',
  category: '',
  fullDescription: '',
  detailText: '',
  imageBg: '',
  images: []
})

// 打开知识弹窗
const openKnowledgeModal = async (pageKey) => {
  try {
    const res = await getKnowledgeDetail(pageKey)
    if (res.code === 200 && res.data) {
      currentKnowledge.value = {
        title: res.data.title || '',
        category: res.data.category || '',
        fullDescription: res.data.fullDescription || '',
        detailText: res.data.detailText || '',
        imageBg: normalizeKnowledgeUrl(res.data.coverUrl || res.data.imageBg),
        images: Array.isArray(res.data.images)
          ? res.data.images.map(img => ({
            ...img,
            imageUrl: normalizeKnowledgeUrl(img.imageUrl)
          }))
          : []
      }
      showKnowledgeModal.value = true
    } else {
      console.error('获取知识卡片详情失败:', res.message)
    }
  } catch (error) {
    console.error('获取知识卡片详情失败:', error)
  }
}

// 关闭弹窗
const closeKnowledgeModal = () => {
  showKnowledgeModal.value = false
}

// 按 ESC 键关闭弹窗
const handleEscKey = (e) => {
  if (e.key === 'Escape' && showKnowledgeModal.value) {
    closeKnowledgeModal()
  }
}

// 知识卡片列表数据（从后端加载）
const knowledgeList = ref([])

// 加载知识卡片列表
const loadKnowledgeList = async () => {
  try {
    const res = await getKnowledgeList()
    if (res.code === 200) {
      knowledgeList.value = res.data.map(item => ({
        key: item.pageKey,
        title: item.title,
        desc: item.fullDescription ? item.fullDescription.substring(0, 50) + '...' : '',
        cover: item.coverUrl,
        pageKey: item.pageKey
      }))
      console.log('转换后第一个卡片:', knowledgeList.value[0])
    }
  } catch (error) {
    console.error('加载失败:', error)
  }
}

const videoList = ref([]);

function formatViews(views) {
  const num = Number(views || 0);
  if (Number.isNaN(num)) return "0";
  if (num >= 10000) return (num / 10000).toFixed(1) + "万";
  return String(num);
}

function getCoverUrl(coverPath) {
  if (!coverPath) return s1;
  return coverPath;
}

const normalizeKnowledgeUrl = (url) => {
  const value = String(url || '').trim()
  if (!value) return ''
  if (value.startsWith('http://') || value.startsWith('https://')) return value
  if (value.startsWith('/')) return `http://localhost:8080${value}`
  return `http://localhost:8080/${value}`
}
const fetchVideos = async () => {
  try {
    const data = await getVideoList();
    videoList.value = Array.isArray(data) ? data : [];
  } catch (error) {
    console.error("获取视频失败:", error);
    videoList.value = [];
  }
};

async function playVideo(video) {
  const videoUrl = video.videoUrl;
  if (!videoUrl) {
    console.error("视频地址为空");
    return;
  }

  const modal = document.createElement("div");
  modal.id = "videoPlayerModal";
  modal.innerHTML = `
    <div style="position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.95);z-index:10000;display:flex;align-items:center;justify-content:center;animation:fadeIn 0.3s ease;">
      <div style="position:relative;width:90%;max-width:1000px;">
        <video src="${videoUrl}" controls autoplay style="width:100%;max-height:80vh;background:#000;border-radius:8px;"></video>
        <button id="closeVideoBtn" style="position:absolute;top:-40px;right:0;background:none;border:none;color:white;font-size:30px;cursor:pointer;opacity:0.8;transition:opacity 0.2s;">×</button>
        <div style="color:white;margin-top:12px;padding:12px;">
          <h3 style="margin:0 0 8px 0;font-size:18px;">${video.title || "视频"}</h3>
          <p style="margin:0;opacity:0.8;">朗诵：${video.author || "未知"} · ${formatViews(video.views)}观看</p>
        </div>
      </div>
    </div>
    <style>
      @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
      }
    
@media (max-width: 1100px) {
  .menuHeroMain {
    grid-template-columns: 1fr;
    gap: 24px;
    padding: 28px 24px 88px;
  }

  .menuHeroInfo {
    max-width: none;
    text-align: center;
  }

  .menuHeroChips {
    justify-content: center;
  }

  .menuHeroRailWrap {
    gap: 14px;
  }

  .menuHeroArrow {
    width: 42px;
    height: 42px;
  }
}

@media (max-width: 768px) {
  .menuHeroTop {
    padding: 18px 16px 0;
  }

  .menuHeroTabs {
    gap: 10px 14px;
  }

  .menuHeroTab {
    font-size: 13px;
    letter-spacing: .08em;
  }

  .menuHeroMain {
    min-height: calc(100vh - 92px);
    padding: 18px 12px 74px;
  }

  .menuHeroBig {
    font-size: 72px;
  }

  .menuHeroDesc {
    font-size: 14px;
  }

  .menuHeroQuote {
    font-size: 20px;
  }

  .menuHeroRail {
    gap: 8px;
    min-height: 290px;
  }

  .menuHeroStrip {
    width: 20px;
    border-radius: 14px;
    height: 300px;
  }

  .menuHeroStrip.on {
    width: 110px;
  }

  .menuHeroStripText {
    bottom: 16px;
    font-size: 28px;
  }

  .menuHeroArrow {
    display: none;
  }
}


.sectionParagraph {
  margin: 0 0 18px;
  max-width: min(820px, 58vw);
}

.sectionParagraph:last-child {
  margin-bottom: 0;
}

.picWrap {
  position: absolute;
  right: 8%;
  top: 54%;
  transform: translateY(-50%) translateY(20px);
  width: min(280px, 18vw);
  transition: opacity 0.4s ease-out, transform 0.4s ease-out;
}

.picWrap.fade-in {
  transform: translateY(-50%) translateY(0);
}

.themePicCard {
  position: relative;
  width: 100%;
  height: min(44vh, 420px);
  border-radius: 18px;
  overflow: hidden;
  box-shadow: 0 22px 58px rgba(0, 0, 0, .34);
  border: 1px solid rgba(255, 255, 255, .16);
  background: rgba(255, 255, 255, .06);
}

.themePicCard img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transform: scale(1.04);
}

.themePicOverlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, .04) 0%, rgba(0, 0, 0, .18) 34%, rgba(0, 0, 0, .62) 100%);
}

.themePicCaption {
  position: absolute;
  left: 18px;
  right: 18px;
  bottom: 18px;
  z-index: 2;
  color: #fff;
}

.themePicLabel {
  font-size: 22px;
  font-weight: 700;
  letter-spacing: .08em;
  margin-bottom: 10px;
}

.themePicQuote {
  font-size: 14px;
  line-height: 1.8;
  color: rgba(255, 245, 220, .92);
}

@media (max-width: 1200px) {
  .sectionParagraph {
    max-width: min(700px, 62vw);
  }

  .picWrap {
    right: 5%;
    width: min(240px, 22vw);
  }
}

@media (max-width: 900px) {
  .contentWrap {
    padding-top: 24vh;
    width: calc(100% - 32px);
  }

  .sectionParagraph {
    max-width: 100%;
  }

  .picWrap {
    position: static;
    width: 100%;
    margin-top: 24px;
    transform: translateY(20px);
  }

  .picWrap.fade-in {
    transform: translateY(0);
  }

  .themePicCard {
    height: 260px;
  }
}



/* 第三屏最终覆盖：文字数量、宋代美学标题、右下配图位置 */
.menuHeroMain {
  grid-template-columns: minmax(420px, 540px) 1fr;
}

.menuHeroInfo {
  max-width: 540px;
}

.menuHeroBig {
  font-size: clamp(58px, 6.8vw, 96px);
  line-height: 1.08;
  letter-spacing: .02em;
  text-shadow: 0 14px 34px rgba(0, 0, 0, .24);
  font-family: "STSong", "Songti SC", "Noto Serif SC", serif;
  word-break: keep-all;
}

.sectionTitle {
  font-family: "STSong", "Songti SC", "Noto Serif SC", serif;
  font-weight: 400;
  line-height: 2.1;
  color: rgba(255, 248, 236, .94);
  letter-spacing: .02em;
}

.sectionParagraph {
  margin: 0 0 18px;
  max-width: min(820px, 58vw);
  text-shadow: 0 4px 18px rgba(0, 0, 0, .18);
}

.sectionParagraph:last-child {
  margin-bottom: 0;
}

.picWrap {
  position: absolute;
  right: 8%;
  top: 54%;
  transform: translateY(-50%) translateY(20px);
  width: min(280px, 18vw);
  margin-right: 0;
  margin-bottom: 0;
}

.picWrap.fade-in {
  transform: translateY(-50%) translateY(0);
}

.themePicCard {
  position: relative;
  width: 100%;
  height: min(44vh, 420px);
  border-radius: 18px;
  overflow: hidden;
  box-shadow: 0 22px 58px rgba(0, 0, 0, .34);
  border: 1px solid rgba(255, 255, 255, .16);
  background: rgba(255, 255, 255, .06);
}

.themePicCard img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transform: scale(1.04);
}

.themePicOverlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, .04) 0%, rgba(0, 0, 0, .18) 34%, rgba(0, 0, 0, .62) 100%);
}

.themePicCaption {
  position: absolute;
  left: 18px;
  right: 18px;
  bottom: 18px;
  z-index: 2;
  color: #fff;
}

.themePicLabel {
  font-size: 22px;
  font-weight: 700;
  letter-spacing: .08em;
  margin-bottom: 10px;
}

.themePicQuote {
  font-size: 14px;
  line-height: 1.8;
  color: rgba(255, 245, 220, .92);
}

@media (max-width: 1200px) {
  .sectionParagraph {
    max-width: min(700px, 62vw);
  }

  .picWrap {
    right: 5%;
    width: min(240px, 22vw);
  }
}

@media (max-width: 1100px) {
  .contentWrap {
    padding-top: 24vh;
    width: min(92vw, 980px);
  }

  .menuHeroMain {
    grid-template-columns: 1fr;
  }

  .menuHeroInfo {
    max-width: none;
  }

  .menuHeroBig {
    font-size: clamp(46px, 10vw, 82px);
  }

  .picWrap {
    position: static;
    width: 100%;
    margin-top: 24px;
    transform: translateY(20px);
  }

  .picWrap.fade-in {
    transform: translateY(0);
  }
}

@media (max-width: 900px) {
  .contentWrap {
    padding-top: 24vh;
    width: calc(100% - 32px);
  }

  .sectionParagraph {
    max-width: 100%;
  }

  .themePicCard {
    height: 260px;
  }
}

</style>
  `;

  document.body.appendChild(modal);

  const closeBtn = document.getElementById("closeVideoBtn");
  if (closeBtn) {
    closeBtn.onclick = () => {
      const node = document.getElementById("videoPlayerModal");
      if (node) node.remove();
    };
  }

  modal.addEventListener("click", (e) => {
    if (e.target === modal.firstElementChild) {
      modal.remove();
    }
  });

  if (video.id) {
    try {
      await addVideoView(video.id);
      const index = videoList.value.findIndex((v) => v.id === video.id);
      if (index !== -1) {
        videoList.value[index].views = Number(videoList.value[index].views || 0) + 1;
      }
    } catch (error) {
      console.error("记录观看次数失败:", error);
    }
  }
}

function tryScrollHubByWheel(dy) {
  const el = hubWrapRef.value;
  if (!el) return false;

  const canScroll = el.scrollHeight > el.clientHeight + 2;
  if (!canScroll) return false;

  const atTop = el.scrollTop <= 0;
  const atBottom = el.scrollTop + el.clientHeight >= el.scrollHeight - 1;

  if (dy < 0 && atTop) return false;
  if (dy > 0 && atBottom) return false;

  el.scrollTop += dy;
  return true;
}

function onWheel(e) {
  const dy = e.deltaY || 0;

  // ✅ 第二屏单独处理，不走 wheelAcc 累加逻辑
  if (pageIndex.value === 1) {
    const dir = dy > 0 ? 1 : -1;
    const moved = tryMoveHallByWheel(dir);
    if (!moved) {
      if (!pageLock) {
        pageLock = true;
        if (dir > 0) nextPage();
        else prevPage();
        setTimeout(() => (pageLock = false), 450);
      }
    }
    return;
  }

  if (pageIndex.value === 4) {
    const scrolled = tryScrollHubByWheel(dy);
    if (scrolled) return;

    if (pageLock) return;
    pageLock = true;

    const dir = dy > 0 ? 1 : -1;
    if (dir < 0) prevPage();
    setTimeout(() => (pageLock = false), 450);
    return;
  }

  wheelAcc += dy;

  if (wheelTimer) clearTimeout(wheelTimer);
  wheelTimer = setTimeout(() => {
    wheelAcc = 0;
  }, 120);

  if (pageLock) return;
  const threshold = 80;
  if (Math.abs(wheelAcc) < threshold) return;

  pageLock = true;
  const dir = wheelAcc > 0 ? 1 : -1;
  wheelAcc = 0;

  if (pageIndex.value === 1) {
    const moved = tryMoveHallByWheel(dir);
    if (!moved) {
      if (dir > 0) nextPage();
      else prevPage();
    }
  } else {
    if (dir > 0) nextPage();
    else prevPage();
  }

  setTimeout(() => (pageLock = false), 450);
}

let tStartY = 0;
let tDelta = 0;

function onTouchStart(e) {
  const t = e.touches?.[0];
  if (!t) return;
  tStartY = t.clientY;
  tDelta = 0;
}

function onTouchMove(e) {
  const t = e.touches?.[0];
  if (!t) return;
  tDelta = t.clientY - tStartY;
}

function onTouchEnd() {
  if (pageLock) return;

  if (pageIndex.value === 4 && hubWrapRef.value) {
    const el = hubWrapRef.value;
    const canScroll = el.scrollHeight > el.clientHeight + 2;

    if (canScroll) {
      const atTop = el.scrollTop <= 0;
      const atBottom = el.scrollTop + el.clientHeight >= el.scrollHeight - 1;

      if (tDelta < 0 && !atBottom) return;
      if (tDelta > 0 && !atTop) return;
    }
  }

  const threshold = 60;
  if (Math.abs(tDelta) < threshold) return;

  pageLock = true;
  const dir = tDelta < 0 ? 1 : -1;

  if (pageIndex.value === 1) {
    const moved = tryMoveHallByWheel(dir);
    if (!moved) {
      if (dir > 0) nextPage();
      else prevPage();
    }
  } else {
    if (dir > 0) nextPage();
    else prevPage();
  }

  setTimeout(() => (pageLock = false), 450);
}

function onKeydown(e) {
  if (pageLock) return;
  if (e.key === "ArrowDown" || e.key === "PageDown") {
    e.preventDefault();
    onWheel({ deltaY: 120 });
  } else if (e.key === "ArrowUp" || e.key === "PageUp") {
    e.preventDefault();
    onWheel({ deltaY: -120 });
  }
}

const blackGoldUrl = computed(() => `url(${bgBlackGold})`);

const scenes = [
  { img: s1, main: "若似月轮终皎洁", sub: "不辞冰雪为卿热" },
  { img: s2, main: "南风知我意", sub: "吹梦到西洲" },
  { img: s3, main: "须知少时凌云志", sub: "曾许天下第一流" },
  { img: s4, main: "江畔何人初见月", sub: "江月何年初照人" },
  { img: s5, main: "你挑灯回看", sub: "我把萧瑟写成歌" },
  { img: s6, main: "寒风初歇", sub: "微雨乍停" },
];

const navs = computed(() => {
  const labels = ["景", "情", "史", "理", "物", "韵"];
  return labels.map((label, i) => ({
    key: label + "-" + i,
    label,
    thumb: scenes[i]?.img || scenes[0].img,
  }));
});

const hallBackgrounds = [hallBg1, hallBg2, hallBg3, hallBg4, hallBg5, hallBg6];

const hallYears = ["先秦", "魏晋", "唐代", "宋代", "元代", "清代"];
const hallTicks = Array.from({ length: 6 }, (_, i) => i);
const hallSceneMeta = [
  {
    title: "先秦",
    period: "远古—前221年",
    poets: "屈原、宋玉、荀况",
    works: "《离骚》《九歌·湘夫人》《天问》《九章·橘颂》《九辩》《成相》"
  },
  {
    title: "魏晋南北朝",
    period: "220—589年",
    poets: "曹操、陶渊明、曹植",
    works: "《短歌行》《观沧海》《饮酒·其五》《归园田居》《洛神赋》《白马篇》"
  },
  {
    title: "唐代",
    period: "618—907年",
    poets: "李白、杜甫、白居易",
    works: "《静夜思》《蜀道难》《春望》《登高》《长恨歌》《赋得古原草送别》"
  },
  {
    title: "宋代",
    period: "960—1279年",
    poets: "苏轼、李清照、辛弃疾",
    works: "《水调歌头·明月几时有》《念奴娇·赤壁怀古》《声声慢·寻寻觅觅》《一剪梅·红藕香残玉簟秋》《破阵子·为陈同甫赋壮词以寄之》《永遇乐·京口北固亭怀古》"
  },
  {
    title: "元代",
    period: "1271—1368年",
    poets: "马致远、关汉卿、白朴",
    works: "《天净沙·秋思》《夜行船·秋思》《窦娥冤》《四块玉·别情》《墙头马上》《沉醉东风·渔夫》"
  },
  {
    title: "清代",
    period: "1636—1912年",
    poets: "纳兰性德、龚自珍、袁枚",
    works: "《木兰花令·拟古决绝词》《长相思·山一程》《己亥杂诗·浩荡离愁白日斜》《己亥杂诗·落红不是无情物》《所见》《苔》"
  }
];

const activeIndex = ref(0);

function setActive(i, navigate = false) {
  const total = scenes.length;
  activeIndex.value = (i + total) % total;
  if (navigate) {
    handleHallArrowClick();
  }
}

function handleHallArrowClick() {
  const currentYear = hallYears[activeIndex.value];
  switch (currentYear) {
    case '先秦':
      go('/home/page2/a1');
      break;
    case '魏晋':
      go('/home/page2/a2');
      break;
    case '唐代':
      go('/home/page2/a3');
      break;
    case '宋代':
      go('/home/page2/a4');
      break;
    case '元代':
      go('/home/page2/a5');
      break;
    case '清代':
      go('/home/page2/a6');
      break;
  }
}

const hallDialRotateStyle = computed(() => ({
  transform: `rotate(${activeIndex.value * -60}deg)`
}));

const hallBluePanelStyle = computed(() => ({
  backgroundImage: `url(${hallBackgrounds[activeIndex.value]})`
}));

function hallTickStyle(index) {
  const deg = 150 + index * 60;
  const longTick = true; // 每个朝代位置都是长刻度
  const radius = longTick ? 42.1 : 43.1;

  return {
    left: `${50 + Math.cos((deg * Math.PI) / 180) * radius}%`,
    top: `${50 + Math.sin((deg * Math.PI) / 180) * radius}%`,
    height: '40px',
    opacity: '.42',
    transform: `translate(-50%, -50%) rotate(${deg + 90}deg)`
  };
}

function hallYearStyle(index) {
  const total = 6;
  // 计算循环相对距离
  let relative = index - activeIndex.value;
  // 处理循环：如果超过2格，取反向（考虑圆形布局）
  if (relative > 2) relative -= total;
  if (relative < -2) relative += total;

  // 360度均匀分布，每个朝代占 60 度
  const step = 60;
  const deg = 180 + relative * step;
  const radius = 39.2;

  const x = 50 + Math.cos((deg * Math.PI) / 180) * radius;
  const y = 50 + Math.sin((deg * Math.PI) / 180) * radius;

  const isActive = index === activeIndex.value;
  const scale = isActive ? 1.2 : 0.85;
  // 动一下只画一个朝代：只有当前选中的朝代高亮，其他淡化
  const opacity = isActive ? 1 : 0.08;

  return {
    left: `${x}%`,
    top: `${y}%`,
    opacity,
    transform: `translate(-50%, -50%) scale(${scale})`,
    transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
    zIndex: isActive ? 10 : 1,
    fontWeight: isActive ? 700 : 400,
  };
}

function navPosStyle(i) {
  const n = navs.value.length || 1;
  const t = n === 1 ? 0.5 : i / (n - 1);

  const startDeg = 72;
  const endDeg = -48;
  const deg = startDeg + (endDeg - startDeg) * t;
  const rad = (deg * Math.PI) / 180;

  const rx = 228;
  const ry = 268;
  const cx = 168;
  const cy = 380;

  const x = cx + Math.cos(rad) * rx;
  const y = cy - Math.sin(rad) * ry;
  const sc = i === activeIndex.value ? 1.08 : 1;

  return {
    left: `${x}px`,
    top: `${y}px`,
    transform: `translate(-50%, -50%) scale(${sc})`,
  };
}

function cardStyle(i) {
  const a = activeIndex.value;
  const off = i - a;
  const abs = Math.abs(off);

  const hidden = abs >= 4;
  const dx = off * 210;
  const sc = 1 - abs * 0.1;
  const blur = abs * 1;
  const op = hidden ? 0 : 1 - abs * 0.18;
  const rotate = off * -7;
  const z = 100 - abs * 10;

  return {
    "--dx": dx + "px",
    "--sc": sc.toFixed(3),
    "--blur": blur + "px",
    "--op": op.toFixed(3),
    "--rot": rotate + "deg",
    zIndex: z,
    pointerEvents: hidden ? "none" : "auto",
  };
}

let hallWheelLock = false;

function onHallWheel(e) {
  const dir = e.deltaY > 0 ? 1 : -1;
  tryMoveHallByWheel(dir);
}

function tryMoveHallByWheel(dir) {
  if (hallWheelLock) return true;
  hallWheelLock = true;

  const atStart = activeIndex.value === 0;
  const atEnd = activeIndex.value === scenes.length - 1;

  if (dir < 0 && atStart) {
    hallWheelLock = false;
    return false;
  }
  if (dir > 0 && atEnd) {
    hallWheelLock = false;
    return false;
  }

  setActive(activeIndex.value + dir);
  setTimeout(() => (hallWheelLock = false), 600);
  return true;
}

const cardStageRef = ref(null);
let dragging = false;
let dragStartX = 0;
let dragDx = 0;

function onCardDragStart(e) {
  dragging = true;
  dragStartX = e.clientX;
  dragDx = 0;
  e.currentTarget.setPointerCapture?.(e.pointerId);
}

function onCardDragMove(e) {
  if (!dragging) return;
  dragDx = e.clientX - dragStartX;
}

function onCardDragEnd() {
  if (!dragging) return;
  dragging = false;

  const threshold = 60;
  if (dragDx > threshold) {
    setActive(activeIndex.value - 1);
  } else if (dragDx < -threshold) {
    setActive(activeIndex.value + 1);
  }
  dragDx = 0;
}
const menuSix = computed(() => [
  { key: "a1", title: "建安风骨", big: "建安", seal: "骨", img: s1, path: "/home/items/jianan" },
  { key: "a2", title: "浪漫派", big: "浪漫", seal: "逸", img: s2, path: "/home/items/langman" },
  { key: "a3", title: "山水田园诗派", big: "田园", seal: "境", img: s3, path: "/home/items/shanshui" },
  { key: "a4", title: "边塞诗派", big: "边塞", seal: "雄", img: s4, path: "/home/items/biansai" },
  { key: "a5", title: "新乐府诗派", big: "乐府", seal: "新", img: s5, path: "/home/items/yuefu" },
  { key: "a6", title: "豪放派", big: "豪放", seal: "阔", img: s6, path: "/home/items/haofang" },
]);
const menuDetailMap = {
  a1: {
    title: "建安风骨",
    desc: "建安诗歌以慷慨悲凉、刚健有力著称，在动荡时代中写出人格力量与家国情怀。",
    quote: "对酒当歌，人生几何。",
    subs: ["慷慨", "苍凉", "风骨", "壮志"],
  },
  a2: {
    title: "浪漫派",
    desc: "浪漫派诗歌想象奇绝、情感奔涌，常借明月、大鹏、银河等意象写精神飞扬。",
    quote: "俱怀逸兴壮思飞，欲上青天览明月。",
    subs: ["想象", "夸张", "自由", "飘逸"],
  },
  a3: {
    title: "山水田园诗派",
    desc: "山水田园诗派重在描绘自然与田居之美，于清淡宁静中寄托隐逸情怀。",
    quote: "采菊东篱下，悠然见南山。",
    subs: ["山水", "田园", "隐逸", "宁静"],
  },
  a4: {
    title: "边塞诗派",
    desc: "边塞诗派多写大漠烽烟、征战行旅，格调雄浑高亢，富有壮阔气势。",
    quote: "大漠孤烟直，长河落日圆。",
    subs: ["边关", "征战", "壮阔", "豪情"],
  },
  a5: {
    title: "新乐府诗派",
    desc: "新乐府诗派强调关注现实、针砭时事，以通俗晓畅的语言反映民生疾苦。",
    quote: "可怜身上衣正单，心忧炭贱愿天寒。",
    subs: ["现实", "民生", "讽谕", "通俗"],
  },
  a6: {
    title: "豪放派",
    desc: "豪放派词作气象开阔、情感奔放，常将家国抱负与人生胸襟写得昂扬激越。",
    quote: "大江东去，浪淘尽，千古风流人物。",
    subs: ["旷达", "激昂", "胸襟", "家国"],
  },
};

const menuContentMap = {
  a1: {
    key: "a1",
    title: "建安风骨",
    image: s1,
    quote: "对酒当歌，人生几何。",
    paragraphs: [
      "建安风骨形成于汉末建安时期，在时代巨变与社会动荡之中，诗歌呈现出一种格外鲜明的精神力量。它不以纤弱婉转取胜，而强调情感的直陈、气势的挺立和人格的坚守。诗人往往把个人命运与乱世现实连在一起，因此作品既有对生命短促的感慨，也有对建功立业的强烈追求，整体气质慷慨悲凉而不失昂扬刚健。",
      "这一主题下的作品常见战争、宴饮、登临、怀抱等内容，语言凝练有力，句式开阔，读来有一种沉雄顿挫之感。曹操、曹丕、曹植等人的创作，使诗歌从单纯抒情进一步走向更强烈的现实关照与精神表达，也让“风骨”成为中国文学中极具分量的审美标准。",
      "在页面呈现上，建安风骨更适合保留厚重、沉静而有力量的气息。文字不宜过于轻飘，而应让节奏更稳、语意更实，使读者感受到乱世中的担当、壮志与苍凉并存的精神面貌。右下角配图也应呼应这种气质，突出古朴、肃穆、带有历史压力感的画面。"
    ]
  },
  a2: {
    key: "a2",
    title: "浪漫派",
    image: s2,
    quote: "俱怀逸兴壮思飞，欲上青天览明月。",
    paragraphs: [
      "浪漫派诗歌最鲜明的特征，在于想象的飞跃与情感的奔涌。它不满足于照实描摹眼前世界，而倾向于借助夸张、变形、神话式联想和瑰丽意象，把现实经验提升到更自由、更广阔的精神空间之中。山川可以与日月相接，孤独可以化作银河万里，壮志也常被写得如大鹏高举、直上青云，因而整体风格充满逸兴与奇气。",
      "这种主题下的内容更强调自我精神的舒展与超越现实的力量，画面往往高远、空灵、明亮，具有强烈的视觉张力。李白是其中最具代表性的诗人，他使诗歌摆脱拘束，呈现出一种天马行空而又真情激荡的气质。浪漫派之所以动人，不仅因为它写得瑰丽，更因为它让理想、自由与个体生命的热情拥有了极大的伸展空间。",
      "在页面氛围上，这一类主题适合呈现更轻盈、更流动的视觉感受。文案可以更有起伏，画面也可以更具月色、云海、长风与仙境般的层次，让整个版面既有古典气韵，又有超越现实的想象光泽。"
    ]
  },
  a3: {
    key: "a3",
    title: "山水田园诗派",
    image: s3,
    quote: "采菊东篱下，悠然见南山。",
    paragraphs: [
      "山水田园诗派以自然景物和田居生活为核心，追求的是一种清淡、澄明、宁静的审美境界。它并不依靠强烈的情绪冲击，而是通过山川草木、村舍炊烟、溪流鸟鸣这些细微景象，把诗人的内心世界慢慢铺展开来。人在自然之中获得安顿，情感也因此变得从容而悠远，这种诗风特别强调人与自然的和谐共生。",
      "陶渊明、王维、孟浩然等人的作品，常借景写心，在看似平常的自然描写中寄托隐逸理想和人生体悟。它的动人之处，正在于不张扬、不喧闹，却能在清浅景色中留出极深的回味。山水田园并不是单纯的风景书写，而是一种让心灵沉静下来的生活理想，也是中国古典诗歌中极具东方气质的审美传统。",
      "这一主题在页面上更适合用留白、舒缓和层次分明的方式来表达。文字应当更平和，图像也更适合山水、竹林、庭院、田舍这一类有静气的内容，使人一眼就能感受到远离尘嚣后的松弛与澄净。"
    ]
  },
  a4: {
    key: "a4",
    title: "边塞诗派",
    image: s4,
    quote: "大漠孤烟直，长河落日圆。",
    paragraphs: [
      "边塞诗派把目光投向塞外山川、军旅生活与征战场景，在壮阔空间中写出强烈的历史感与家国情怀。诗中常出现大漠、长城、烽火、羌笛、孤城、寒月等意象，画面辽远雄浑，声音苍凉激越，既有报国立功的昂扬气概，也有久戍边关的孤独与悲壮，因此整体风格兼具豪迈与沉痛。",
      "这一主题下的内容不能只写战争本身，更要写人在边地环境中的情绪震荡：有将士出征时的壮怀，有对故乡亲人的思念，也有面对辽阔天地时生出的悲凉之感。高适、岑参、王昌龄等诗人的作品，使边塞不只是地理空间，更成为英雄气、离别感与时代风云交织的文学场域。",
      "因此页面表达上，边塞诗派更适合强调空间的开阔感与色调的苍劲感。文案可以带有更强的节奏和力度，右下图像也应体现关山大漠、落日长河、孤城烽火这一类雄浑景象，使整体视觉更具边地风声与历史回响。"
    ]
  },
  a5: {
    key: "a5",
    title: "新乐府诗派",
    image: s5,
    quote: "可怜身上衣正单，心忧炭贱愿天寒。",
    paragraphs: [
      "新乐府诗派强调诗歌对于现实社会的关注，主张文章合为时而著、歌诗合为事而作。它不刻意追求艰深，而更重视内容的针对性与表达的明晰度，通过通俗而有力量的语言，直接揭示人民疾苦、社会不公和制度弊病。因此这一诗派最突出的特征，就是强烈的现实关怀与鲜明的批判意识。",
      "白居易、元稹等人的作品，使诗歌更贴近百姓生活，也让文学具备了更鲜明的人文温度。新乐府真正重要的地方，在于它让诗歌从书斋和个人情绪中走出来，重新走向社会现场，去关照普通人的生存处境。它写寒冷、饥饿、劳作、离散，也写不平背后的制度问题，因此具有明显的责任感与公共性。",
      "这一主题在页面上不宜过于空灵，而应更强调真实、质朴与现实感。文案应该更扎实，图像也更适合民生、劳作、街市、风雪行旅等内容，让读者直观感受到这一诗派所承担的人间温度与社会重量。"
    ]
  },
  a6: {
    key: "a6",
    title: "豪放派",
    image: s6,
    quote: "大江东去，浪淘尽，千古风流人物。",
    paragraphs: [
      "豪放派在词体发展中开拓出更为开阔雄健的艺术空间，它突破了柔婉纤细的传统局限，把历史、山河、人生、抱负与失意一并纳入词的表达范围。其风格常见气象宏大、情绪奔放、笔力纵横，既能写登临怀古、家国理想，也能写个体生命中的不平、旷达与激越，因此整体格局更大，情感张力也更强。",
      "苏轼、辛弃疾等人的创作，使词从儿女情长扩展到山河历史与人格襟怀，形成昂扬、阔大、沉郁而有力量的审美品格。豪放并不只是声音高昂，它更是一种能够承载复杂人生经验的气度：既有胸中万里山河，也有理想受挫后的深沉回望，因此更显厚重。",
      "这一主题在页面上应当体现一种向外扩展的力量感。文字不宜过碎，而应更有整体气势；图像也更适合江河、长天、群山、古城这一类具有开张感的视觉内容，让豪放派的恢弘胸襟在版面中真正立起来。"
    ]
  }
};

const currentMenuContent = computed(() => {
  if (!expandedMenuKey.value) return null;
  return menuContentMap[expandedMenuKey.value] || null;
});


const menuActive = ref(0);
const expandedMenuKey = ref("a1");
const menuZooming = ref(false);
const zoomTarget = ref(null);
const menuReturning = ref(false);
const menuStripRefs = ref([]);
const menuFlyVisible = ref(false);
const menuFlyBodyVisible = ref(false);
const contentWrapVisible = ref(false);
const contentFadeIn = ref(false);
const menuFlyStyle = ref({});
let menuJumpTimer = null;
const showCloseBtn = ref(false);
const detailKey = 'home'

// 新增：保存原始卡片位置信息
const originalCardPosition = ref(null);
const activeCardIndex = ref(null);

function clearMenuJumpTimer() {
  if (menuJumpTimer) {
    clearTimeout(menuJumpTimer);
    menuJumpTimer = null;
  }
}

function setMenuStripRef(el, i) {
  if (el) menuStripRefs.value[i] = el;
}

const currentMenuDetail = computed(() => {
  if (!expandedMenuKey.value) return null;
  return menuDetailMap[expandedMenuKey.value] || null;
});

const currentMenuVisual = computed(() => {
  return menuSix.value[menuActive.value]?.img || menuSix.value[0]?.img || "";
});

const currentMenuNarrative = computed(() => {
  const detail = currentMenuDetail.value;
  if (!detail) {
    return {
      lead: "",
      body: "",
      tail: "",
      end: "",
    };
  }

  const subs = (detail.subs || []).join("、");
  return {
    lead: `${detail.title}并不只是一个单独的题材标签，它更像一扇进入古典诗歌内部结构的门。诗人常常借由${subs}这些意象，把瞬间的感受延展成完整的审美空间，让读者在画面、声息与情绪之间慢慢进入诗境。`,
    body: `当这种表达被展开时，文字不再只是说明，而会形成一种缓慢上升的阅读节奏。我们看到的不是孤立的句子，而是一层层被铺开的气息、颜色与心绪，它们随着阅读不断向上流动，最后在视线中留下清晰的主题轮廓。`,
    tail: `因此第三屏在视觉上更适合使用“固定框景 + 流动文字”的方式来呈现。框本身像一个稳定的观看界面，而文字在其中穿行，既保留了秩序感，也能让内容拥有更强的沉浸和叙事节奏。`,
    end: `无论是“${detail.title}”所对应的意境、情感还是思想，这种展开方式都会让每一个分类拥有相似的观看逻辑，但又因为文案和图像不同，保留各自独立的气质与层次。`,
  };
});

function openMenuDetail(i, m) {
  menuActive.value = i;
  expandedMenuKey.value = m.key;
}

function handleMenuClick(i, m) {
  if (menuZooming.value) return;

  contentWrapVisible.value = false;
  contentFadeIn.value = false;
  menuReturning.value = false;
  openMenuDetail(i, m);
  zoomTarget.value = m;
  menuZooming.value = true;
  showCloseBtn.value = true;

  // 新增：保存原始卡片位置信息
  activeCardIndex.value = i;
  const sourceEl = menuStripRefs.value[i];
  const rect = sourceEl?.getBoundingClientRect?.();

  if (rect) {
    originalCardPosition.value = {
      index: i,
      top: rect.top,
      left: rect.left,
      width: rect.width,
      height: rect.height
    };
  }

  menuFlyVisible.value = true;
  menuFlyBodyVisible.value = false;

  if (rect) {
    menuFlyStyle.value = {
      top: `${rect.top}px`,
      left: `${rect.left}px`,
      width: `${rect.width}px`,
      height: `${rect.height}px`,
      borderRadius: "28px",
      backgroundImage: `url(${m.img})`
    };

    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        menuFlyBodyVisible.value = true;
        menuFlyStyle.value = {
          top: "0px",
          left: "0px",
          width: `${window.innerWidth}px`,
          height: "38vh",
          borderRadius: "0px",
          backgroundImage: `url(${m.img})`
        };
      });
    });
  } else {
    menuFlyBodyVisible.value = true;
    menuFlyStyle.value = {
      top: "0px",
      left: "0px",
      width: `${window.innerWidth}px`,
      height: "38vh",
      borderRadius: "0px",
      backgroundImage: `url(${m.img})`
    };
  }

  clearMenuJumpTimer();
  menuJumpTimer = setTimeout(() => {
    contentWrapVisible.value = true;
    setTimeout(() => {
      contentFadeIn.value = true;
    }, 50);
  }, 2000);
}

function changeMenu(step) {
  if (menuZooming.value) return;
  const total = menuSix.value.length;
  const next = (menuActive.value + step + total) % total;
  openMenuDetail(next, menuSix.value[next]);
}
function goBack() {
  if (!zoomTarget.value) return;

  clearMenuJumpTimer();
  stopMenuAuto();
  showCloseBtn.value = false;
  contentFadeIn.value = false;
  contentWrapVisible.value = false;
  menuReturning.value = true;

  // 获取卡片的当前位置（考虑可能的滚动）
  let targetRect = null;
  if (activeCardIndex.value !== null) {
    const targetEl = menuStripRefs.value[activeCardIndex.value];
    targetRect = targetEl?.getBoundingClientRect();
  }

  // 如果没有获取到当前位置，使用保存的原始位置
  if (!targetRect && originalCardPosition.value) {
    targetRect = originalCardPosition.value;
  }

  if (!targetRect) {
    menuZooming.value = false;
    menuReturning.value = false;
    zoomTarget.value = null;
    return;
  }

  // 确保飞入层可见并设置当前展开状态
  menuFlyVisible.value = true;
  menuFlyStyle.value = {
    top: "0px",
    left: "0px",
    width: `${window.innerWidth}px`,
    height: "38vh",
    borderRadius: "0px",
    backgroundImage: `url(${zoomTarget.value.img})`
  };

  // 强制浏览器重排，确保展开状态已设置
  void menuFlyStyle.value;

  // 立即开始收缩动画
  requestAnimationFrame(() => {
    requestAnimationFrame(() => {
      menuFlyStyle.value = {
        top: `${targetRect.top}px`,
        left: `${targetRect.left}px`,
        width: `${targetRect.width}px`,
        height: `${targetRect.height}px`,
        borderRadius: "28px",
        backgroundImage: `url(${zoomTarget.value.img})`
      };
    });
  });

  // 1500ms后清理状态
  setTimeout(() => {
    menuFlyVisible.value = false;
    menuZooming.value = false;
    menuReturning.value = false;
    zoomTarget.value = null;
    activeCardIndex.value = null;
    originalCardPosition.value = null;
  }, 1500);
}

let menuAutoTimer = null;

function startMenuAuto() {
  stopMenuAuto();
  menuAutoTimer = setInterval(() => {
    changeMenu(1);
  }, 2600);
}

function stopMenuAuto() {
  if (menuAutoTimer) {
    clearInterval(menuAutoTimer);
    menuAutoTimer = null;
  }
}

watch(pageIndex, (val) => {
  if (val === 2) {
    startMenuAuto();
    triggerMenuEnter();
    return;
  }
  stopMenuAuto();
});

const kw = ref("");

const tips = [
  "海内存知己，天涯若比邻。",
  "春眠不觉晓，处处闻啼鸟。",
  "明月松间照，清泉石上流。",
  "行到水穷处，坐看云起时。",
  "会当凌绝顶，一览众山小。",
];
const tip = ref(tips[0]);

function randomTip() {
  tip.value = tips[Math.floor(Math.random() * tips.length)];
}

const spiralItems = ref(poetry100);
const detailVisible = ref(false);
const currentPoetry = ref(null);

function onSpiralGo(payload) {
  if (!payload?.item) return;
  if (payload.type === "detail") {
    currentPoetry.value = payload.item;
    detailVisible.value = true;
  }
}

function closeDetail() {
  detailVisible.value = false;
}

const petals = reactive([]);
let pid = 0;

function spawnPetal() {
  const left = Math.random() * 100;
  const delay = Math.random() * 2;
  const dur = 6 + Math.random() * 3;
  const size = 10 + Math.random() * 8;
  const rot = Math.random() * 360;
  petals.push({
    id: ++pid,
    style: {
      left: left + "%",
      animationDelay: delay + "s",
      animationDuration: dur + "s",
      width: size + "px",
      height: size * 0.72 + "px",
      transform: `rotate(${rot}deg)`,
    },
  });
  if (petals.length > 40) petals.splice(0, petals.length - 40);
}

const worldRef = ref(null);

function onMove(e) {
  const el = worldRef.value;
  if (!el) return;
  const rect = el.getBoundingClientRect();
  const dx = (e.clientX - (rect.left + rect.width / 2)) / rect.width;
  const dy = (e.clientY - (rect.top + rect.height / 2)) / rect.height;
  el.style.setProperty("--mx", (dx * 18).toFixed(2) + "px");
  el.style.setProperty("--my", (dy * 12).toFixed(2) + "px");
}

let petalTimer = null;

const checkScrollToKnowledge = () => {
  const shouldScroll = localStorage.getItem('scrollToKnowledge')
  if (shouldScroll === 'true') {
    localStorage.removeItem('scrollToKnowledge')

    setTimeout(() => {
      pageIndex.value = 4

      setTimeout(() => {
        const dailyKnowledgeEl = document.querySelector('.dailyKnowledge')
        if (dailyKnowledgeEl) {
          dailyKnowledgeEl.scrollIntoView({ behavior: 'smooth', block: 'start' })
        } else {
          const hubGrid = document.querySelector('.hubGrid')
          if (hubGrid) {
            hubGrid.scrollIntoView({ behavior: 'smooth', block: 'start' })
          }
        }
      }, 200)
    }, 100)
  }
}

function playMenuReturnAnimation(targetKey) {
  const targetIndex = menuSix.value.findIndex((item) => item.key === targetKey);
  if (targetIndex === -1) return

  // 保存当前索引
  activeCardIndex.value = targetIndex;

  pageIndex.value = 2;
  stopMenuAuto();
  openMenuDetail(targetIndex, menuSix.value[targetIndex]);
  zoomTarget.value = menuSix.value[targetIndex];
  menuZooming.value = true;
  menuReturning.value = true;
  menuFlyVisible.value = true;
  menuFlyBodyVisible.value = true;

  menuFlyStyle.value = {
    top: "0px",
    left: "0px",
    width: `${window.innerWidth}px`,
    height: "38vh",
    borderRadius: "0px",
    backgroundImage: `url(${menuSix.value[targetIndex].img})`
  };

  // 强制浏览器重排，确保展开状态已设置
  void menuFlyStyle.value;

  // 立即隐藏内容区域，无延迟
  menuFlyBodyVisible.value = false;

  // 直接获取目标位置并开始收缩（与展开动画一致，使用双层 requestAnimationFrame）
  requestAnimationFrame(() => {
    requestAnimationFrame(() => {
      const targetEl = menuStripRefs.value[targetIndex];
      const rect = targetEl?.getBoundingClientRect?.();

      if (rect) {
        // 更新原始位置信息
        originalCardPosition.value = {
          index: targetIndex,
          top: rect.top,
          left: rect.left,
          width: rect.width,
          height: rect.height
        };

        // 开始收缩动画
        menuFlyStyle.value = {
          top: `${rect.top}px`,
          left: `${rect.left}px`,
          width: `${rect.width}px`,
          height: `${rect.height}px`,
          borderRadius: "28px",
          backgroundImage: `url(${menuSix.value[targetIndex].img})`
        };
      }
    });
  });

  // 1500ms后清理状态
  setTimeout(() => {
    menuFlyVisible.value = false;
    menuZooming.value = false;
    menuReturning.value = false;
    zoomTarget.value = null;
    activeCardIndex.value = null;
    originalCardPosition.value = null;
  }, 1500);
}

// 页面挂载
onMounted(() => {
  randomTip()
  for (let i = 0; i < 15; i++) spawnPetal()
  petalTimer = setInterval(spawnPetal, 500)

  fetchVideos()
  loadKnowledgeList()
  checkScrollToKnowledge()

  window.addEventListener("mousemove", onMove, { passive: true })
  window.addEventListener("keydown", onKeydown, { passive: false })
  window.addEventListener('keydown', handleEscKey)

  if (pageIndex.value === 2) {
    triggerMenuEnter()
    startMenuAuto()
  }

  if (music) {
    isMusicPlaying.value = music.getState()
  }

  const returnHallIndex = sessionStorage.getItem('homeReturnHallIndex')
  if (returnHallIndex !== null) {
    const parsedHallIndex = Number(returnHallIndex)
    if (!Number.isNaN(parsedHallIndex)) {
      activeIndex.value = clamp(parsedHallIndex, 0, scenes.length - 1)
      pageIndex.value = 1
    }
    sessionStorage.removeItem('homeReturnHallIndex')
    sessionStorage.removeItem('homeReturnMenuKey')
  } else {
    const returnKey = sessionStorage.getItem('homeReturnMenuKey')
    if (returnKey) {
      sessionStorage.removeItem('homeReturnMenuKey')
      requestAnimationFrame(() => {
        playMenuReturnAnimation(returnKey)
      })
    }
  }
})

// 页面卸载
onUnmounted(() => {
  petalTimer && clearInterval(petalTimer);
  if (pageShiftTimer) clearTimeout(pageShiftTimer);
  window.removeEventListener("mousemove", onMove);
  window.removeEventListener("keydown", onKeydown);
  window.removeEventListener('keydown', handleEscKey)
  stopMenuAuto()
  clearMenuJumpTimer();
  menuFlyVisible.value = false;
  menuFlyBodyVisible.value = false;
  menuReturning.value = false;
  // 清理新增的状态变量
  activeCardIndex.value = null;
  originalCardPosition.value = null;
})

function ripple(e) {
  const wrap = e.currentTarget;
  const r = document.createElement("span");
  r.className = "rip";
  const rect = wrap.getBoundingClientRect();
  const x = e.clientX - rect.left;
  const y = e.clientY - rect.top;
  r.style.left = x + "px";
  r.style.top = y + "px";
  wrap.appendChild(r);
  setTimeout(() => r.remove(), 700);
}
</script>

<style scoped>
.contentWrap {
  padding-top: 28vh;
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  max-width: 1440px;
  width: 100%;
}

.sectionTitle {
  font-family: "STSong", "Songti SC", "Noto Serif SC", serif;
  text-align: justify;
  font-weight: 400;
  font-size: 16px;
  line-height: 2.1;
  color: rgba(255, 248, 236, .94);
  letter-spacing: .02em;
  opacity: 0;
  transform: translateY(20px);
  transition: opacity 0.4s ease-out, transform 0.4s ease-out;
}

.sectionTitle.fade-in {
  opacity: 1;
  transform: translateY(0);
}

.closeWrap {
  position: absolute;
  top: 20px;
  right: 20px;
  z-index: 1000;
}

.closeBtn {
  width: 42px;
  height: 42px;
  border-radius: 50%;
  border: none;
  background: rgba(0, 0, 0, 0.35);
  color: #fff;
  font-size: 20px;
  line-height: 1;
  cursor: pointer;
  backdrop-filter: blur(6px);
  transition: transform 0.25s ease, background 0.25s ease;
}

.homePage {
  width: 100%;
  height: 100vh;
  overflow: hidden;
  position: relative;
}

.fullPager {
  width: 100%;
  height: 100vh;
  overflow: hidden;
}

.pages {
  width: 100%;
  height: 500vh;
  transition: transform 0.72s cubic-bezier(.22, .78, .24, 1);
  will-change: transform;
}

.stage,
.hallWrap {
  transition: transform 0.72s cubic-bezier(.22, .78, .24, 1), filter 0.72s cubic-bezier(.22, .78, .24, 1), opacity 0.72s cubic-bezier(.22, .78, .24, 1);
}

.fullPager.page-shifting.shift-down .stage {
  transform: scale(0.985);
  filter: brightness(0.9) saturate(0.94);
}

.fullPager.page-shifting.shift-down .hallWrap {
  transform: scale(1.02);
  filter: brightness(0.97);
}

.fullPager.page-shifting.shift-up .stage {
  transform: scale(1.01);
  filter: brightness(0.96);
}

.fullPager.page-shifting.shift-up .hallWrap {
  transform: scale(0.99);
  filter: brightness(0.93) saturate(0.95);
}

.page {
  width: 100%;
  height: 100vh;
  position: relative;
  overflow: hidden;
  transform: translateZ(0);
  backface-visibility: hidden;
}

.sideDots {
  position: fixed;
  right: 14px;
  top: 50%;
  transform: translateY(-50%);
  display: grid;
  gap: 10px;
  z-index: 2000;
}

.sd {
  width: 8px;
  height: 26px;
  border-radius: 999px;
  border: 1px solid rgba(255, 255, 255, .22);
  background: rgba(255, 255, 255, .10);
  backdrop-filter: blur(10px);
  cursor: pointer;
}

.sd.on {
  background: rgba(255, 255, 255, .55);
  border-color: rgba(255, 255, 255, .50);
}

.stage {
  background: transparent;
}

.bg {
  position: absolute;
  inset: 0;
  background-image: url("../assets/han/bg_mountain.jpg");
  background-size: contain;
  background-position: center;
  background-repeat: no-repeat;
  transform: translateZ(0);
}

.bambooLeft {
  position: absolute;
  left: -150px;
  bottom: -20px;
  height: 78%;
  width: auto;
  z-index: 5;
  pointer-events: none;
  opacity: 0.95;
  filter: drop-shadow(0 10px 20px rgba(0, 0, 0, .1));
  transform: translateZ(0);
}

.plumRight {
  position: absolute;
  right: -40px;
  top: 10px;
  width: 360px;
  height: 360px;
  background-image: url("../assets/han/55.png");
  background-repeat: no-repeat;
  background-position: center;
  background-size: contain;
  transform: scaleX(-1) translateZ(0);
  z-index: 8;
  pointer-events: none;
  opacity: 0.98;
  filter: drop-shadow(0 8px 16px rgba(0, 0, 0, .12));
}

.fog {
  position: absolute;
  inset: -30%;
  background:
    radial-gradient(circle at 20% 20%, rgba(255, 255, 255, .45), transparent 45%),
    radial-gradient(circle at 70% 35%, rgba(255, 255, 255, .30), transparent 48%);
  animation: drift 12s ease-in-out infinite alternate;
  pointer-events: none;
  z-index: 2;
  will-change: transform;
}

@keyframes drift {
  from {
    transform: translate3d(-1%, -0.5%, 0);
  }

  to {
    transform: translate3d(1%, 0.5%, 0);
  }
}

.light {
  position: absolute;
  inset: -40%;
  background: radial-gradient(circle at 60% 40%, rgba(255, 255, 255, .45), transparent 55%);
  animation: sweep 8s ease-in-out infinite;
  pointer-events: none;
  z-index: 1;
  mix-blend-mode: screen;
  opacity: 0.45;
  will-change: transform;
}

@keyframes sweep {
  0% {
    transform: translateX(-4%) translateY(1%);
    opacity: 0.30;
  }

  50% {
    transform: translateX(4%) translateY(-1%);
    opacity: 0.50;
  }

  100% {
    transform: translateX(-4%) translateY(1%);
    opacity: 0.30;
  }
}

.top {
  position: absolute;
  top: 16px;
  left: 50%;
  transform: translateX(-50%);
  width: min(980px, 92vw);
  display: flex;
  gap: 10px;
  align-items: center;
  z-index: 30;
}

.search {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 14px;
  border-radius: 999px;
  background: rgba(255, 255, 255, .72);
  border: 1px solid rgba(0, 0, 0, .10);
  backdrop-filter: blur(10px);
}

.search input {
  border: none;
  outline: none;
  background: transparent;
  width: 100%;
  font-weight: 800;
}

.ico {
  opacity: 0.78;
  font-weight: 1000;
  width: 22px;
  text-align: center;
}

.miniBtn {
  height: 44px;
  padding: 0 16px;
  border-radius: 999px;
  border: 1px solid rgba(0, 0, 0, .12);
  background: rgba(255, 255, 255, .70);
  cursor: pointer;
  font-weight: 1000;
}

.miniBtn:hover {
  background: rgba(255, 255, 255, .92);
}

.float {
  position: absolute;
  top: 140px;
  display: flex;
  flex-direction: column;
  gap: 16px;
  z-index: 60;
}

.float.left {
  left: 18px;
}

.float.right {
  right: 18px;
}

.ringBtn {
  width: 76px;
  height: 76px;
  border: none;
  outline: none;
  background: transparent;
  cursor: pointer;
  position: relative;
  display: grid;
  place-items: center;
  background-image: url("../assets/han/ring.png");
  background-repeat: no-repeat;
  background-position: center;
  background-size: contain;
  filter: drop-shadow(0 10px 22px rgba(0, 0, 0, .12));
  transition: transform .12s ease, filter .12s ease;
}

.ringBtn:hover {
  transform: translateY(-2px);
  filter: drop-shadow(0 14px 26px rgba(0, 0, 0, .16));
}

.ringText {
  width: 54px;
  text-align: center;
  font-weight: 1000;
  font-size: 14px;
  letter-spacing: .10em;
  color: rgba(20, 20, 20, .86);
  line-height: 1;
  user-select: none;
}

.world {
  position: absolute;
  inset: 0;
  z-index: 10;
  --mx: 0px;
  --my: 0px;
}

.figure {
  position: absolute;
  bottom: 0;
  width: 800px;
  height: 1580px;
  background-repeat: no-repeat;
  background-position: center bottom;
  background-size: contain;
  box-shadow: 0 16px 40px rgba(0, 0, 0, .12);
  mask-image: radial-gradient(ellipse at 50% 55%, #000 62%, transparent 78%);
  -webkit-mask-image: radial-gradient(ellipse at 50% 55%, #000 62%, transparent 78%);
  transform-origin: 50% 92%;
  animation: floatY 3.5s ease-in-out infinite;
  will-change: transform;
}

.leftFig {
  left: 8%;
  background-image: url("../assets/han/左.png");
  animation-delay: .15s;
  transform: translate3d(calc(var(--mx) * .50), calc(var(--my) * .40), 0);
}

.rightFig {
  right: 3%;
  background-image: url("../assets/han/右1.png");
  animation-name: floatY2;
  animation-delay: .55s;
  transform: translate3d(calc(var(--mx) * -0.45), calc(var(--my) * .35), 0);
}

@keyframes floatY {

  0%,
  100% {
    transform: translate3d(calc(var(--mx) * .50), calc(var(--my) * .40), 0) translateY(0);
  }

  50% {
    transform: translate3d(calc(var(--mx) * .50), calc(var(--my) * .40), 0) translateY(-10px);
  }
}

@keyframes floatY2 {

  0%,
  100% {
    transform: translate3d(calc(var(--mx) * -0.45), calc(var(--my) * .35), 0) translateY(0);
  }

  50% {
    transform: translate3d(calc(var(--mx) * -0.45), calc(var(--my) * .35), 0) translateY(-12px);
  }
}

.petal {
  position: absolute;
  top: -20px;
  background: rgba(255, 170, 190, .75);
  border-radius: 999px 999px 999px 0;
  filter: blur(.2px);
  z-index: 50;
  animation-name: fall;
  animation-timing-function: linear;
  animation-iteration-count: infinite;
}

@keyframes fall {
  from {
    transform: translateY(-20px) translateX(0) rotate(0deg);
    opacity: .95;
  }

  to {
    transform: translateY(1200px) translateX(80px) rotate(260deg);
    opacity: .15;
  }
}

.rippleWrap {
  position: absolute;
  inset: 0;
  z-index: 15;
}

.rip {
  position: absolute;
  width: 10px;
  height: 10px;
  border-radius: 999px;
  border: 2px solid rgba(0, 0, 0, .18);
  transform: translate(-50%, -50%);
  animation: rip .7s ease-out both;
}

@keyframes rip {
  from {
    opacity: .6;
    transform: translate(-50%, -50%) scale(1);
  }

  to {
    opacity: 0;
    transform: translate(-50%, -50%) scale(18);
  }
}

.quote {
  position: absolute;
  left: 50%;
  bottom: 16px;
  transform: translateX(-50%);
  width: min(620px, 90vw);
  padding: 12px 14px;
  border-radius: 14px;
  background: rgba(255, 255, 255, .78);
  border: 1px solid rgba(0, 0, 0, .10);
  backdrop-filter: blur(10px);
  z-index: 70;
}

.qTitle {
  font-weight: 1000;
  font-size: 12px;
  opacity: .75;
}

.qLine {
  margin-top: 6px;
  font-weight: 1000;
}

/* 第二屏 */
.hallWrap {
  position: relative;
  overflow: hidden;
  background: #f6f6f6;
}

.hallBluePanel {
  position: absolute;
  inset: 0 30% 0 0;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  transition: background-image .5s ease;
}

.hallBluePanel::after {
  content: "";
  position: absolute;
  inset: 0;
  background: linear-gradient(90deg, rgba(0, 0, 0, .18) 0%, rgba(0, 0, 0, .06) 70%, rgba(0, 0, 0, 0) 100%);
}

.hallBlueGlow {
  display: none;
}

.hallCurveMask {
  display: none;
}

.hallViewport {
  position: relative;
  z-index: 2;
  width: 100%;
  height: 100%;
}

.hallArrow {
  position: absolute;
  left: 31.5%;
  width: 64px;
  height: 64px;
  transform: translateX(-50%);
  border: 1px solid rgba(255, 255, 255, .22);
  background: rgba(255, 255, 255, .08);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  cursor: pointer;
  display: grid;
  place-items: center;
  z-index: 6;
  border-radius: 999px;
  box-shadow: 0 14px 34px rgba(25, 35, 108, .18);
  transition: transform .22s ease, background .22s ease, border-color .22s ease, box-shadow .22s ease;
}

.hallArrow.top {
  top: 58px;
}

.hallArrow.bottom {
  bottom: 26px;
}

.hallArrowMark {
  display: block;
  color: rgba(255, 255, 255, .96);
  font-size: 26px;
  font-weight: 800;
  line-height: 1;
  letter-spacing: .04em;
  transition: transform .22s ease, opacity .22s ease;
}

.hallArrow:hover {
  transform: translateX(-50%) translateY(-2px);
  background: rgba(255, 255, 255, .13);
  border-color: rgba(255, 255, 255, .34);
  box-shadow: 0 18px 40px rgba(25, 35, 108, .24);
}

.hallArrow:hover .hallArrowMark {
  opacity: .9;
  transform: scale(1.06);
}

.hallContent {
  position: absolute;
  inset: 0;
  display: grid;
  grid-template-columns: 44% 56%;
  align-items: center;
}

.hallCopyZone {
  position: relative;
  padding-left: clamp(88px, 8vw, 160px);
  padding-right: 26px;
  z-index: 4;
}

.hallCopy {
  width: min(620px, 36vw);
  color: rgba(255, 255, 255, .98);
  text-shadow: 0 2px 12px rgba(0, 0, 0, .18);
}

.hallYearText {
  font-size: clamp(58px, 4.5vw, 88px);
  line-height: 1;
  font-weight: 700;
  letter-spacing: .04em;
  font-family: "STKaiti", "KaiTi", "Kaiti SC", serif;
}

.hallCopyTitle {
  margin-top: 14px;
  font-size: clamp(24px, 1.8vw, 34px);
  line-height: 1.3;
  font-weight: 600;
  letter-spacing: .04em;
  font-family: "STSong", "SimSun", "Songti SC", serif;
}

.hallCopyLine {
  width: min(540px, 30vw);
  height: 2px;
  margin: 22px 0 26px;
  background: rgba(255, 255, 255, .42);
}

.hallCopyCn {
  color: rgba(255, 255, 255, .84);
  font-size: clamp(16px, 1.08vw, 21px);
  line-height: 1.95;
  max-width: 560px;
  font-family: "STSong", "SimSun", "Songti SC", serif;
}

.hallInfoBlock {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.hallInfoBlock.works {
  margin-top: 20px;
}

.hallInfoLabel {
  font-size: 15px;
  letter-spacing: .18em;
  color: rgba(255, 255, 255, .62);
  font-family: "STKaiti", "KaiTi", "Kaiti SC", serif;
}

.hallInfoValue {
  color: rgba(255, 255, 255, .92);
}

.hallDialStage {
  position: relative;
  height: 100%;
}

.hallDialShell {
  position: absolute;
  right: -20vw;
  top: 50%;
  transform: translateY(-50%);
  width: 74vw;
  height: 74vw;
  min-width: 920px;
  min-height: 920px;
  border-radius: 50%;
}

.hallDialOuter,
.hallDialFrame,
.hallDialInner,
.hallDialRotor,
.hallDialTicks,
.hallDialYears {
  position: absolute;
  inset: 0;
  border-radius: 50%;
}

/* style 中 */
.hallDialOuter {
  position: absolute;
  inset: 0;
  border-radius: 50%;
  background: #fff;
  z-index: 0;
}

.hallDialFrame {
  width: 100%;
  height: 100%;
  object-fit: contain;
  pointer-events: none;
  z-index: 1;
  transform: scale(1.3); 
}

.hallDialInner {
  inset: 2.8%;
  background: transparent !important;
  box-shadow: none;
  z-index: -1;
}

.hallDialRotor {
  transition: transform .7s cubic-bezier(.22, .74, .2, 1);
  z-index: 2;
}

.hallDialTicks {
  inset: 0;
}

.hallDialTick {
  position: absolute;
  width: 2px;
  background: rgba(96, 101, 148, .38);
  transform-origin: center center;
}

.hallDialYears {
  inset: 0;
  z-index: 3;
}

.hallDialYear {
  position: absolute;
  color: rgba(0, 0, 0, .82);
  font-size: 42px !important;  /* 强制固定大小 */
  font-weight: 900 !important;  /* 最粗 */
  letter-spacing: .04em;
  white-space: nowrap;
  font-family: "STKaiti", "KaiTi", "Kaiti SC", serif;
  transition:
    left .72s cubic-bezier(.22, .74, .2, 1),
    top .72s cubic-bezier(.22, .74, .2, 1),
    opacity .28s ease,
    transform .72s cubic-bezier(.22, .74, .2, 1),
    color .28s ease;
    z-index: 25;
}

.hallDialYear.on {
  color: #000;
  font-weight: 700;
}

.hallDialFocusLine {
  position: absolute;
  left: 15.2%;
  top: 50%;
  width: 74px;
  height: 4px;
  border-radius: 999px;
  background: rgba(0, 0, 0, .82);
  transform: translateY(-50%);
  box-shadow: 0 0 0 10px rgba(0, 0, 0, .05);
  z-index: 4;
}

.hallDialHubYear {
  position: absolute;
  left: 47%;
  top: 52%;
  transform: translate(-50%, -50%);
  color: #000;
  font-size: clamp(72px, 6vw, 110px);
  font-weight: 700;
  letter-spacing: .08em;
  font-family: "STKaiti", "KaiTi", "Kaiti SC", serif;
  z-index: 5;
}


@media (max-width: 1280px) {
  .hallBluePanel {
    inset: 0 40% 0 0;
  }

  .hallArrow {
    left: 31%;
  }

  .hallContent {
    grid-template-columns: 44% 56%;
  }

  .hallCopyZone {
    padding-left: 8vw;
  }

  .hallCopy {
    width: min(560px, 38vw);
  }

  .hallDialShell {
    right: -18vw;
    width: 70vw;
    height: 70vw;
    min-width: 840px;
    min-height: 840px;
  }
}

@media (max-width: 900px) {
  .hallWrap {
    background: #f6f6f6;
  }

  .hallBluePanel {
    inset: 0;
  }

  .hallArrow {
    left: 50%;
  }

  .hallContent {
    grid-template-columns: 1fr;
  }

  .hallCopyZone {
    padding: 120px 30px 0;
  }

  .hallCopy {
    width: auto;
  }

  .hallDialStage {
    position: absolute;
    inset: 0;
  }
}

.hall-copy-switch-enter-active,
.hall-copy-switch-leave-active {
  transition: all .38s cubic-bezier(.22, .74, .2, 1);
}

.hall-copy-switch-enter-from {
  opacity: 0;
  transform: translateY(26px);
}



.sectionTitle {
  text-align: justify;
  line-height: 2;
  color: #fff;
  opacity: 0;
  transform: translateY(20px);
  transition: opacity 0.8s ease-out, transform 0.8s ease-out;
}

.sectionTitle.fade-in {
  opacity: 1;
  transform: translateY(0);
}

.picWrap {
  width: clamp(220px, 18vw, 320px);
  align-self: flex-end;
  justify-self: end;
  margin-right: clamp(12px, 4vw, 56px);
  margin-bottom: 4vh;
  opacity: 0;
  transform: translateY(20px);
  transition: opacity 0.8s ease-out, transform 0.8s ease-out;
  transition-delay: 0.2s;
}

.picWrap.fade-in {
  opacity: 1;
  transform: translateY(0);
}

.hall-copy-switch-leave-to {
  opacity: 0;
  transform: translateY(-26px);
}

@media (max-width: 1280px) {
  .hallCurveMask {
    right: 28%;
    width: 100vw;
    height: 100vw;
  }

  .hallArrow {
    left: 29%;
  }

  .contentWrap {
    padding-top: 28vh;
    position: absolute;
    left: 50%;
    transform: translateX(-50%);
    max-width: 1440px;
    width: 100%;
  }

  .sectionTitle {
    text-align: justify;
    line-height: 2;
    color: #fff;
    opacity: 0;
    transform: translateY(20px);
    transition: opacity 0.8s ease-out, transform 0.8s ease-out;
  }

  .sectionTitle.fade-in {
    opacity: 1;
    transform: translateY(0);
  }

  .hallContent {
    grid-template-columns: minmax(360px, 1fr) minmax(460px, 52vw);
  }

  .hallCopyZone {
    padding-left: 12vw;
  }

  .hallCopy {
    width: min(620px, 42vw);
  }

  .hallDialShell {
    right: -26vw;
    width: 76vw;
    height: 76vw;
    min-width: 860px;
    min-height: 860px;
  }
}

@media (max-width: 980px) {
  .hallWrap {
    background: #f6f6f6;
  }

  .hallBluePanel {
    inset: 0;
  }

  .hallCurveMask {
    right: -8%;
    width: 120vw;
    height: 120vw;
    opacity: .94;
  }

  .hallContent {
    grid-template-columns: 1fr;
  }

  .hallCopyZone {
    padding: 0 10vw;
    align-self: end;
    margin-bottom: 18vh;
  }

  .hallCopy {
    width: min(720px, 80vw);
  }

  .hallDialShell {
    right: -50vw;
    top: 56%;
    width: 118vw;
    height: 118vw;
    min-width: 720px;
    min-height: 720px;
  }

  .hallArrow {
    left: 50%;
  }

  .hallDialHubYear {
    font-size: clamp(62px, 8vw, 110px);
  }
}

@media (max-width: 640px) {
  .hallArrow.top {
    top: 30px;
  }

  .hallArrow.bottom {
    bottom: 18px;
  }

  .hallArrow {
    width: 52px;
    height: 52px;
  }

  .hallArrowMark {
    font-size: 20px;
  }

  .hallCopyZone {
    padding: 0 8vw;
    margin-bottom: 16vh;
  }

  .hallYearText {
    font-size: 34px;
  }

  .hallCopyTitle {
    font-size: 20px;
  }

  .hallCopyCn {
    font-size: 15px;
  }

  .hallDialShell {
    right: -68vw;
    width: 148vw;
    height: 148vw;
    min-width: 560px;
    min-height: 560px;
  }
}

/* 第三屏 */
.menuSixWrap {
  position: relative;
  background: #030303;
  overflow: hidden;
}

.menuSixBg {
  position: absolute;
  inset: 0;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  transform: scale(1.08) translateZ(0);
  opacity: .12;
  filter: saturate(.9) brightness(.42);
}

.menuSixMask {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(900px 520px at 50% 50%, rgba(255, 255, 255, .04), transparent 60%),
    linear-gradient(180deg, rgba(0, 0, 0, .78), rgba(0, 0, 0, .88));
  pointer-events: none;
}

.menuSixOrbit {
  position: absolute;
  top: 55%;
  width: 220px;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, .18), transparent);
  opacity: .65;
}

.menuSixOrbit::before,
.menuSixOrbit::after {
  content: "";
  position: absolute;
  top: 50%;
  width: 7px;
  height: 7px;
  border-radius: 999px;
  background: rgba(255, 255, 255, .75);
  box-shadow: 0 0 0 5px rgba(255, 255, 255, .05);
  transform: translateY(-50%);
}

.menuSixOrbit.left {
  left: -36px;
}

.menuSixOrbit.left::before {
  left: 34px;
}

.menuSixOrbit.left::after {
  right: 26px;
}

.menuSixOrbit.right {
  right: -36px;
}

.menuSixOrbit.right::before {
  left: 26px;
}

.menuSixOrbit.right::after {
  right: 34px;
}

.videoBoardShell {
  position: relative;
  z-index: 4;
  width: min(1260px, 94vw);
  margin: 34px auto 0;
  padding-top: 18px;
}

.videoBoardBadge {
  width: fit-content;
  margin: 0 auto;
  padding: 12px 26px;
  border-radius: 999px;
  border: 1px solid rgba(255, 255, 255, .30);
  background: rgba(255, 255, 255, .12);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, .18), 0 10px 28px rgba(0, 0, 0, .30);
  color: rgba(255, 255, 255, .92);
  font-weight: 800;
  font-size: 28px;
  letter-spacing: .06em;
  backdrop-filter: blur(8px);
}

.videoBoardDots {
  margin-top: 18px;
  display: flex;
  justify-content: center;
  gap: 8px;
}

.videoBoardDot {
  width: 8px;
  height: 8px;
  border-radius: 999px;
  border: 1px solid rgba(255, 255, 255, .55);
  background: transparent;
}

.videoBoardDot.on {
  background: rgba(255, 255, 255, .88);
}

.videoBoardFrame {
  position: relative;
  margin-top: 34px;
  min-height: 560px;
  border-radius: 18px;
  border: 1px solid rgba(255, 255, 255, .18);
  background: rgba(255, 255, 255, .02);
  overflow: hidden;
  box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .03), 0 28px 80px rgba(0, 0, 0, .46);
}

.videoBoardScenery,
.videoBoardShade,
.videoBoardGlow {
  position: absolute;
  inset: 0;
}

.videoBoardScenery {
  background-size: cover;
  background-position: center;
  transition: background-image .45s ease, transform .7s ease;
  transform: scale(1.06);
  opacity: .92;
}

.videoBoardShade {
  background:
    linear-gradient(90deg, rgba(0, 0, 0, .42), rgba(0, 0, 0, .08) 40%, rgba(0, 0, 0, .46)),
    linear-gradient(180deg, rgba(0, 0, 0, .18), rgba(0, 0, 0, .48));
}

.videoBoardGlow {
  background:
    radial-gradient(420px 320px at 50% 50%, rgba(255, 255, 255, .08), transparent 72%),
    radial-gradient(280px 220px at 52% 72%, rgba(255, 210, 120, .10), transparent 74%);
  pointer-events: none;
}

.videoBoardTopNav {
  position: absolute;
  top: 26px;
  left: 30px;
  right: 30px;
  z-index: 3;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  color: rgba(255, 255, 255, .66);
  font-size: 11px;
}

.videoBoardBrand,
.videoBoardTopItem {
  position: relative;
  z-index: 2;
  white-space: nowrap;
}

.videoBoardBrand {
  font-weight: 700;
  letter-spacing: .06em;
}

.videoBoardBrand.muted {
  opacity: .65;
}

.videoBoardTopItem {
  flex: 1;
  text-align: center;
  letter-spacing: .18em;
}

.videoBoardTopItem.on {
  color: rgba(255, 255, 255, .94);
}

.videoBoardCenter {
  position: absolute;
  left: 50%;
  top: 52%;
  transform: translate(-50%, -50%);
  display: flex;
  gap: 10px;
  z-index: 4;
}

.videoStrip {
  position: relative;
  width: 18px;
  height: 196px;
  border: 0;
  border-radius: 12px;
  overflow: hidden;
  background: rgba(255, 255, 255, .08);
  cursor: pointer;
  padding: 0;
  transition: width .42s cubic-bezier(.22, .8, .24, 1), transform .32s ease, box-shadow .32s ease, opacity .28s ease;
  box-shadow: 0 12px 28px rgba(0, 0, 0, .35);
}

.menuSixWrap.enter .videoStrip {
  animation: videoStripIn .62s cubic-bezier(.22, .84, .24, 1) both;
}

.menuSixWrap.enter .videoStrip:nth-child(1) {
  animation-delay: .02s;
}

.menuSixWrap.enter .videoStrip:nth-child(2) {
  animation-delay: .08s;
}

.menuSixWrap.enter .videoStrip:nth-child(3) {
  animation-delay: .14s;
}

.menuSixWrap.enter .videoStrip:nth-child(4) {
  animation-delay: .20s;
}

.menuSixWrap.enter .videoStrip:nth-child(5) {
  animation-delay: .26s;
}

.menuSixWrap.enter .videoStrip:nth-child(6) {
  animation-delay: .32s;
}

@keyframes videoStripIn {
  from {
    opacity: 0;
    transform: translateY(34px) scale(.92);
    filter: blur(4px);
  }

  to {
    opacity: 1;
    transform: translateY(0) scale(1);
    filter: blur(0);
  }
}

.videoStrip:hover {
  transform: translateY(-6px);
}

.videoStrip.on {
  width: 138px;
  transform: translateY(-10px);
  box-shadow: 0 20px 54px rgba(0, 0, 0, .42), 0 0 0 1px rgba(255, 255, 255, .10);
}

.videoStripImg,
.videoStripShade {
  position: absolute;
  inset: 0;
}

.videoStripImg {
  background-size: cover;
  background-position: center;
  transform: scale(1.12);
}

.videoStripShade {
  background: linear-gradient(180deg, rgba(0, 0, 0, .12), rgba(0, 0, 0, .44));
}

.videoStripLabel {
  position: absolute;
  inset: auto 0 16px 0;
  text-align: center;
  color: rgba(255, 255, 255, .94);
  font-size: 28px;
  font-weight: 700;
  text-shadow: 0 6px 16px rgba(0, 0, 0, .45);
  letter-spacing: .08em;
}

.videoFocusCard {
  position: absolute;
  left: 26%;
  top: 18%;
  width: min(400px, 34vw);
  min-height: 390px;
  padding: 28px 28px 26px;
  border-radius: 28px;
  background: rgba(255, 255, 255, .16);
  border: 1px solid rgba(255, 255, 255, .16);
  backdrop-filter: blur(10px);
  box-shadow: 0 24px 64px rgba(0, 0, 0, .30);
  z-index: 3;
}

.videoFocusYear {
  font-size: 12px;
  color: rgba(255, 255, 255, .62);
  letter-spacing: .18em;
}

.videoFocusTitle {
  margin-top: 92px;
  font-size: 42px;
  line-height: 1.05;
  color: rgba(255, 255, 255, .96);
  font-weight: 700;
}

.videoFocusDesc {
  margin-top: 14px;
  font-size: 14px;
  line-height: 1.9;
  color: rgba(255, 255, 255, .74);
}

.videoFocusQuote {
  margin-top: 18px;
  font-size: 16px;
  line-height: 1.8;
  color: rgba(255, 244, 220, .94);
  font-family: "STKaiti", "KaiTi", "FangSong", serif;
}

.videoFocusChips {
  margin-top: 18px;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.videoFocusChip {
  padding: 7px 14px;
  border-radius: 999px;
  border: 1px solid rgba(255, 255, 255, .12);
  background: rgba(255, 255, 255, .08);
  color: rgba(255, 255, 255, .86);
  font-size: 12px;
}

.videoFocusBtn {
  margin-top: 22px;
  height: 42px;
  padding: 0 22px;
  border: 0;
  border-radius: 999px;
  background: rgba(255, 255, 255, .92);
  color: #101010;
  font-size: 14px;
  font-weight: 800;
  cursor: pointer;
  transition: transform .2s ease, box-shadow .2s ease;
  box-shadow: 0 10px 28px rgba(0, 0, 0, .22);
}

.videoFocusBtn:hover {
  transform: translateY(-2px);
}

.videoBoardArrow {
  position: absolute;
  top: 74%;
  width: 36px;
  height: 36px;
  border-radius: 999px;
  border: 1px solid rgba(255, 255, 255, .14);
  background: rgba(0, 0, 0, .30);
  color: rgba(255, 255, 255, .78);
  font-size: 24px;
  line-height: 1;
  display: grid;
  place-items: center;
  cursor: pointer;
  z-index: 5;
}

.videoBoardArrow.left {
  left: calc(50% - 96px);
}

.videoBoardArrow.right {
  right: calc(50% - 96px);
}

.videoBoardMeta {
  position: absolute;
  top: 52%;
  transform: translateY(-50%);
  z-index: 3;
  color: rgba(255, 255, 255, .52);
  display: flex;
  flex-direction: column;
  gap: 8px;
  font-size: 12px;
}

.videoBoardMeta.left {
  left: -84px;
  align-items: flex-end;
}

.videoBoardMeta.right {
  right: -84px;
  align-items: flex-start;
}

.videoBoardMetaMain {
  font-size: 14px;
  letter-spacing: .16em;
  color: rgba(255, 255, 255, .82);
}

.videoBoardMetaSub {
  max-width: 96px;
  line-height: 1.8;
}

.videoBoardFooter {
  display: grid;
  grid-template-columns: 1fr auto 1fr;
  align-items: center;
  gap: 18px;
  margin-top: 30px;
  padding: 16px 4px 0;
  border-top: 1px solid rgba(255, 255, 255, .12);
  color: rgba(255, 255, 255, .82);
}

.videoBoardFootLeft,
.videoBoardFootRight {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 14px;
  font-weight: 700;
}

.videoBoardFootRight {
  justify-content: flex-end;
}

.videoBoardDate {
  font-size: 42px;
  line-height: 1;
}

.videoBoardDivider {
  width: 1px;
  height: 24px;
  background: rgba(255, 255, 255, .18);
}

.videoBoardFootCenter {
  font-size: 13px;
  color: rgba(255, 255, 255, .56);
  text-align: center;
}

.menuSixHint {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  bottom: 16px;
  display: flex;
  gap: 10px;
  justify-content: center;
  align-items: center;
  flex-wrap: wrap;
  z-index: 10;
}

/* 第三屏新版 */
.menuSixWrap {
  position: relative;
  overflow: hidden;
  background: #000;
}

.menuHeroBg,
.menuHeroMask,
.menuHeroGlow {
  position: absolute;
  inset: 0;
}

.menuHeroBg {
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  transform: scale(1.08);
  transition: background-image .55s ease, transform .7s ease;
  filter: saturate(1.02) brightness(.74);
}

.menuHeroMask {
  background:
    linear-gradient(90deg, rgba(0, 0, 0, .56) 0%, rgba(0, 0, 0, .26) 34%, rgba(0, 0, 0, .22) 64%, rgba(0, 0, 0, .48) 100%),
    linear-gradient(180deg, rgba(0, 0, 0, .26) 0%, rgba(0, 0, 0, .10) 26%, rgba(0, 0, 0, .38) 100%);
}

.menuHeroGlow {
  background:
    radial-gradient(560px 320px at 25% 55%, rgba(255, 255, 255, .12), transparent 70%),
    radial-gradient(680px 340px at 72% 48%, rgba(255, 220, 160, .12), transparent 72%);
  pointer-events: none;
}

.menuHeroTop,
.menuHeroMain,
.menuHeroBottom {
  position: relative;
  z-index: 2;
}

.menuHeroTop {
  padding: 28px 44px 0;
}

.menuHeroTabs {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 18px;
  flex-wrap: wrap;
}

.menuHeroTab {
  border: 0;
  background: transparent;
  color: rgba(255, 255, 255, .58);
  font-size: 15px;
  letter-spacing: .16em;
  cursor: pointer;
  padding: 6px 4px;
  transition: color .25s ease, transform .25s ease;
}

.menuHeroTab.on {
  color: rgba(255, 255, 255, .96);
  transform: scale(1.05);
}

.menuHeroMain {
  min-height: calc(100vh - 120px);
  padding: 34px 56px 84px;
  display: grid;
  grid-template-columns: minmax(420px, 540px) 1fr;
  align-items: center;
  gap: 40px;
}

.menuHeroInfo {
  max-width: 540px;
}

.menuHeroMini {
  color: rgba(255, 255, 255, .64);
  font-size: 13px;
  letter-spacing: .22em;
}

.menuHeroBig {
  margin-top: 18px;
  font-size: clamp(58px, 6.8vw, 96px);
  line-height: 1.08;
  color: #fff;
  font-weight: 800;
  text-shadow: 0 14px 34px rgba(0, 0, 0, .24);
  letter-spacing: .02em;
  font-family: "STSong", "Songti SC", "Noto Serif SC", serif;
  word-break: keep-all;
}

.menuHeroDesc {
  margin-top: 20px;
  font-size: 16px;
  line-height: 1.9;
  color: rgba(255, 255, 255, .82);
}

.menuHeroQuote {
  margin-top: 18px;
  font-size: 24px;
  line-height: 1.8;
  color: rgba(255, 245, 220, .98);
  font-family: "STKaiti", "KaiTi", "FangSong", serif;
}

.menuHeroChips {
  margin-top: 22px;
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.menuHeroChip {
  padding: 8px 16px;
  border-radius: 999px;
  border: 1px solid rgba(255, 255, 255, .18);
  background: rgba(255, 255, 255, .08);
  color: rgba(255, 255, 255, .88);
  font-size: 13px;
}

.menuHeroBtn {
  margin-top: 26px;
  height: 48px;
  padding: 0 28px;
  border-radius: 999px;
  border: 0;
  background: rgba(255, 255, 255, .96);
  color: #141414;
  font-size: 15px;
  font-weight: 800;
  cursor: pointer;
  box-shadow: 0 14px 36px rgba(0, 0, 0, .24);
}

.menuHeroRailWrap {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 28px;
  width: 100%;
}

.menuHeroRail {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  min-height: 420px;
}

.menuHeroStrip {
  position: relative;
  width: 30px;
  height: clamp(320px, 56vh, 520px);
  border: 0;
  padding: 0;
  border-radius: 20px;
  overflow: hidden;
  background: rgba(255, 255, 255, .12);
  cursor: pointer;
  box-shadow: 0 22px 58px rgba(0, 0, 0, .34);
  transition: width .46s cubic-bezier(.22, .8, .24, 1), transform .32s ease, filter .32s ease, box-shadow .32s ease;
}

.menuHeroStrip:hover {
  transform: translateY(-6px);
}

.menuHeroStrip.on {
  width: clamp(180px, 18vw, 250px);
  transform: translateY(-10px) scale(1.02);
  box-shadow: 0 26px 70px rgba(0, 0, 0, .42), 0 0 0 1px rgba(255, 255, 255, .12);
}

.menuSixWrap.enter .menuHeroStrip {
  animation: menuHeroStripIn .68s cubic-bezier(.22, .84, .24, 1) both;
}

.menuSixWrap.enter .menuHeroStrip:nth-child(1) {
  animation-delay: .03s;
}

.menuSixWrap.enter .menuHeroStrip:nth-child(2) {
  animation-delay: .08s;
}

.menuSixWrap.enter .menuHeroStrip:nth-child(3) {
  animation-delay: .13s;
}

.menuSixWrap.enter .menuHeroStrip:nth-child(4) {
  animation-delay: .18s;
}

.menuSixWrap.enter .menuHeroStrip:nth-child(5) {
  animation-delay: .23s;
}

.menuSixWrap.enter .menuHeroStrip:nth-child(6) {
  animation-delay: .28s;
}

@keyframes menuHeroStripIn {
  from {
    opacity: 0;
    transform: translateY(44px) scale(.9);
    filter: blur(8px);
  }

  to {
    opacity: 1;
    transform: translateY(0) scale(1);
    filter: blur(0);
  }
}

.menuHeroStripImg,
.menuHeroStripShade {
  position: absolute;
  inset: 0;
}

.menuHeroStripImg {
  background-size: cover;
  background-position: center;
  transform: scale(1.1);
}

.menuHeroStripShade {
  background: linear-gradient(180deg, rgba(0, 0, 0, .08), rgba(0, 0, 0, .36));
}

.menuHeroStripText {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 24px;
  text-align: center;
  color: rgba(255, 255, 255, .95);
  font-size: 38px;
  font-weight: 800;
  letter-spacing: .08em;
  text-shadow: 0 8px 22px rgba(0, 0, 0, .38);
}

.menuHeroArrow {
  width: 48px;
  height: 48px;
  border-radius: 999px;
  border: 1px solid rgba(255, 255, 255, .18);
  background: rgba(0, 0, 0, .26);
  color: rgba(255, 255, 255, .96);
  font-size: 28px;
  cursor: pointer;
  display: grid;
  place-items: center;
  backdrop-filter: blur(6px);
}

.menuHeroBottom {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 28px;
  display: flex;
  justify-content: center;
}

.menuHeroDots {
  display: flex;
  align-items: center;
  gap: 10px;
}

.menuHeroDot {
  width: 28px;
  height: 6px;
  border-radius: 999px;
  border: 0;
  background: rgba(255, 255, 255, .24);
  cursor: pointer;
  transition: background .24s ease, transform .24s ease;
}

.menuHeroDot.on {
  background: rgba(255, 255, 255, .95);
  transform: scaleX(1.25);
}


.menuHeroStrip.locked,
.menuHeroTab.locked {
  pointer-events: none;
}

.menuHeroStrip.locked {
  width: 40vw;
  height: 60vh;
  margin: 0 auto;
  position: fixed;
  top: 20%;
  left: 50%;
  transform: translateY(-20%) translateX(-50%);
  transition: width 1s ease, top 1s ease, transform 1s ease;
  animation: expandFull 0.8s forwards 0.8s;
}

.menuHeroStrip.returning {
  /* 移除固定动画，改用JavaScript控制 */
  width: 100vw;
  height: 30vh;
  position: fixed;
  top: 0;
  left: 50%;
  transform: translateX(-50%);
  border-radius: 0 0 20px 20px;
  box-shadow: 0 26px 70px rgba(0, 0, 0, .42), 0 0 0 1px rgba(255, 255, 255, .12);
  /* 移除了固定的 shrinkBack 动画 */
}

@keyframes expandFull {
  to {
    width: 100vw;
    height: 30vh;
    border-radius: 0 0 20px 20px;
    top: 0;
    transform: translateX(-50%);
  }
}

/* 移除了固定的 shrinkBack 动画，改用JavaScript动态控制 */

.menuHeroStrip.hidden {
  opacity: 0 !important;
  visibility: hidden;
  transform: scaleY(.82) scaleX(.94) translateY(16px);
  /* transition: all 2s cubic-bezier(.22, .7, .14, 1); */
}

.menuSixWrap.zooming .menuHeroTop,
.menuSixWrap.zooming .menuHeroInfo,
.menuSixWrap.zooming .menuHeroBottom,
.menuSixWrap.zooming .menuHeroArrow {
  opacity: 0;
  transform: translateY(26px);
  pointer-events: none;
  transition: all .34s ease;
}

.menuPageTransition {
  position: fixed;
  inset: 0;
  z-index: 90;
  pointer-events: none;
  overflow: hidden;
}

.menuFlyHero {
  position: fixed;
  background-position: center;
  background-size: cover;
  background-repeat: no-repeat;
  box-shadow: 0 18px 40px rgba(0, 0, 0, .18);
  transition:
    top 1.5s cubic-bezier(.4, .0, .2, 1),
    left 1.5s cubic-bezier(.4, .0, .2, 1),
    width 1.5s cubic-bezier(.4, .0, .2, 1),
    height 1.5s cubic-bezier(.4, .0, .2, 1),
    border-radius 1.5s cubic-bezier(.4, .0, .2, 1),
    box-shadow 1.5s cubic-bezier(.4, .0, .2, 1);
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}

.menuFlyHeroMask {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, .12) 0%, rgba(0, 0, 0, .18) 45%, rgba(0, 0, 0, .38) 100%);
}

.menuFlyContent {
  position: relative;
  z-index: 2;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
  max-width: 500px;
  padding: 40px;
}

.menuFlyImage {
  width: 300px;
  height: 200px;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, .2);
  margin-bottom: 30px;
}

.menuFlyTextContainer {
  text-align: center;
}

.menuFlyHeroText {
  color: rgba(255, 255, 255, .95);
  font-size: 36px;
  font-weight: 700;
  letter-spacing: .04em;
  line-height: 1;
  text-shadow: 0 10px 24px rgba(0, 0, 0, .22);
  margin-bottom: 10px;
}

.menuFlyHeroSub {
  color: rgba(255, 255, 255, .88);
  font-size: 16px;
  letter-spacing: .04em;
  text-shadow: 0 8px 20px rgba(0, 0, 0, .18);
}

.menuFlyBody {
  position: fixed;
  left: 0;
  right: 0;
  top: calc(38vh - 28px);
  bottom: 0;
  background: #f7f4ee;
  border-top-left-radius: 30px;
  border-top-right-radius: 30px;
  box-shadow: 0 -10px 40px rgba(26, 19, 13, .08);
  transform: translateY(100%);
  transition: transform .3s cubic-bezier(.2, .76, .14, 1);
}

.menuFlyBody.on {
  transform: translateY(0);
}

@media (max-width: 900px) {
  .menuFlyContent {
    padding: 20px;
  }

  .menuFlyImage {
    width: 250px;
    height: 160px;
    margin-bottom: 20px;
  }

  .menuFlyHeroText {
    font-size: 28px;
  }

  .menuFlyHeroSub {
    font-size: 14px;
  }

  .menuFlyBody {
    top: calc(34vh - 24px);
  }
}


/* 第四屏 */
.spiralSection {
  position: relative;
  background: transparent;
}

.spiralBg {
  position: absolute;
  inset: 0;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  transform: translateZ(0);
  opacity: .98;
}

.spiralBgMask {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(900px 600px at 30% 35%, rgba(0, 0, 0, .12), transparent 62%),
    linear-gradient(180deg, rgba(0, 0, 0, .08), rgba(0, 0, 0, .24));
  pointer-events: none;
}

.spiralInkFog {
  position: absolute;
  inset: -20%;
  background:
    radial-gradient(circle at 22% 28%, rgba(255, 255, 255, .05), transparent 42%),
    radial-gradient(circle at 78% 38%, rgba(255, 255, 255, .03), transparent 48%);
  pointer-events: none;
  z-index: 1;
  animation: drift2 13s ease-in-out infinite alternate;
  opacity: .22;
  will-change: transform;
}

@keyframes drift2 {
  from {
    transform: translate3d(-1%, -0.5%, 0);
  }

  to {
    transform: translate3d(1%, 0.5%, 0);
  }
}

.spiralLight {
  position: absolute;
  inset: -30%;
  background:
    radial-gradient(700px 420px at 50% 55%, rgba(255, 255, 255, .05), transparent 62%);
  opacity: .18;
  pointer-events: none;
  z-index: 2;
  animation: sweep2 9s ease-in-out infinite;
  will-change: transform;
}

@keyframes sweep2 {
  0% {
    transform: translateX(-3%) translateY(1%);
    opacity: .28;
  }

  50% {
    transform: translateX(3%) translateY(-1%);
    opacity: .45;
  }

  100% {
    transform: translateX(-3%) translateY(1%);
    opacity: .28;
  }
}

.spiralTopBar {
  position: absolute;
  top: 14px;
  left: 50%;
  transform: translateX(-50%);
  width: min(1200px, 94vw);
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 14px;
  z-index: 10;
  pointer-events: none;
}

.spiralTopLeft {
  padding: 10px 12px;
  border-radius: 14px;
  background: rgba(255, 255, 255, .10);
  border: 1px solid rgba(255, 255, 255, .10);
  backdrop-filter: blur(10px);
}

.spiralTitle {
  font-weight: 700;
  font-size: 24px;
  letter-spacing: .18em;
  color: rgba(255, 245, 220, .96);
  font-family: "STKaiti", "KaiTi", "FangSong", "Noto Serif SC", serif;
}

.spiralSub {
  margin-top: 8px;
  font-weight: 600;
  font-size: 13px;
  letter-spacing: .08em;
  opacity: .88;
  color: rgba(255, 240, 220, .82);
  font-family: "STKaiti", "KaiTi", "FangSong", serif;
}

.spiralTopRight {
  display: flex;
  gap: 8px;
}

.spiralTipPill {
  padding: 8px 14px;
  border-radius: 999px;
  background: rgba(255, 248, 236, .10);
  border: 1px solid rgba(255, 235, 210, .14);
  backdrop-filter: blur(10px);
  font-weight: 700;
  font-size: 12px;
  color: rgba(255, 240, 220, .88);
  font-family: "STKaiti", "KaiTi", "FangSong", serif;
}

.spiralFull {
  position: relative;
  z-index: 5;
  height: 100%;
}

/* 第五屏 */
.lastHub {
  position: relative;
  background: linear-gradient(135deg, #fdfbf7 0%, #f5f3ef 100%);
}

.hubBg {
  position: absolute;
  inset: 0;
  background-image:
    radial-gradient(circle at 15% 20%, rgba(255, 220, 180, .15), transparent 45%),
    radial-gradient(circle at 85% 80%, rgba(200, 180, 255, .12), transparent 50%);
  pointer-events: none;
}

.hubLight {
  position: absolute;
  inset: -20%;
  background: radial-gradient(circle at 50% 50%, rgba(255, 240, 220, .25), transparent 60%);
  animation: lightPulse 8s ease-in-out infinite;
  pointer-events: none;
  opacity: 0.6;
}

@keyframes lightPulse {

  0%,
  100% {
    transform: scale(1);
    opacity: 0.4;
  }

  50% {
    transform: scale(1.05);
    opacity: 0.6;
  }
}

.hubWrap {
  height: 100%;
  overflow: auto;
  padding: 32px 40px 50px;
  position: relative;
  z-index: 1;
}

.hubWrap::-webkit-scrollbar {
  width: 8px;
}

.hubWrap::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, .03);
  border-radius: 4px;
}

.hubWrap::-webkit-scrollbar-thumb {
  background: rgba(0, 0, 0, .15);
  border-radius: 4px;
}

.hubWrap::-webkit-scrollbar-thumb:hover {
  background: rgba(0, 0, 0, .25);
}

.hubBlock {
  margin: 0 0 48px;
  animation: fadeInUp 0.6s ease both;
}

.hubBlock:nth-child(1) {
  animation-delay: 0.1s;
}

.hubBlock:nth-child(2) {
  animation-delay: 0.2s;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.hubTitleRow {
  display: flex;
  align-items: center;
  gap: 12px;
  margin: 0 0 20px;
}

.hubTitle {
  font-size: 28px;
  font-weight: 1000;
  letter-spacing: 0.5px;
  margin: 0;
  background: linear-gradient(135deg, #2d5a8f 0%, #4a7bb8 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.hubSubtitle {
  font-size: 13px;
  font-weight: 900;
  color: rgba(0, 0, 0, .45);
  margin-left: auto;
  padding: 4px 12px;
  background: rgba(255, 220, 180, .25);
  border-radius: 999px;
}

.hubBar {
  width: 4px;
  height: 24px;
  background: linear-gradient(180deg, #d4a574 0%, #b8895f 100%);
  border-radius: 3px;
  box-shadow: 0 2px 8px rgba(212, 165, 116, .3);
}

.dailyKnowledge {
  margin-bottom: 24px;
}

.knowledgeCard {
  padding: 24px 28px;
  background: linear-gradient(135deg, rgba(255, 250, 240, .95) 0%, rgba(255, 245, 235, .95) 100%);
  border-radius: 20px;
  border: 1px solid rgba(212, 165, 116, .25);
  box-shadow: 0 12px 40px rgba(0, 0, 0, .08);
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
}

.knowledgeCard::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, #d4a574 0%, #b8895f 50%, #d4a574 100%);
}

.knowledgeCard:hover {
  transform: translateY(-4px);
  box-shadow: 0 16px 50px rgba(0, 0, 0, .12);
}

.knowledgeDate {
  font-size: 13px;
  font-weight: 900;
  color: #d4a574;
  margin-bottom: 12px;
}

.knowledgeTitle {
  font-size: 22px;
  font-weight: 1000;
  color: #2d5a8f;
  margin-bottom: 14px;
  letter-spacing: 0.5px;
}

.knowledgeContent {
  font-size: 15px;
  font-weight: 800;
  line-height: 1.8;
  color: rgba(0, 0, 0, .75);
  margin-bottom: 16px;
}

.knowledgeTag {
  display: inline-block;
  padding: 6px 14px;
  background: rgba(212, 165, 116, .18);
  border-radius: 999px;
  font-size: 12px;
  font-weight: 900;
  color: #b8895f;
}

.hubGrid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 24px;
}

.hubCard {
  text-align: left;
  border: 0;
  padding: 0;
  background: transparent;
  cursor: pointer;
  transition: transform 0.3s ease;
}

.hubCard:hover {
  transform: translateY(-6px);
}

.hubThumb {
  width: 100%;
  height: 200px;
  border-radius: 16px;
  background-size: cover;
  background-position: center;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
  margin-bottom: 14px;
}

.thumbOverlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, .35) 100%);
  opacity: 0.6;
  transition: opacity 0.3s ease;
}

.hubCard:hover .hubThumb {
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.18);
}

.hubCard:hover .thumbOverlay {
  opacity: 0.8;
}

.hubThumb.video {
  height: 180px;
}

.playIcon {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 56px;
  height: 56px;
  background: rgba(255, 255, 255, .92);
  border-radius: 999px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  color: #2d5a8f;
  padding-left: 4px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, .25);
  transition: all 0.3s ease;
  z-index: 2;
}

.hubCard:hover .playIcon {
  transform: translate(-50%, -50%) scale(1.1);
  background: rgba(255, 255, 255, 1);
}

.videoDuration {
  position: absolute;
  bottom: 10px;
  right: 10px;
  padding: 4px 10px;
  background: rgba(0, 0, 0, .75);
  border-radius: 6px;
  font-size: 12px;
  font-weight: 900;
  color: rgba(255, 255, 255, .95);
  z-index: 2;
}

.hubCardTitle {
  font-size: 16px;
  font-weight: 1000;
  color: #2d2d2d;
  margin: 0 0 8px 0;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.hubCardDesc {
  font-size: 13px;
  font-weight: 800;
  color: rgba(0, 0, 0, .55);
  line-height: 1.5;
}

.videoMeta {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 13px;
  font-weight: 800;
}

.videoAuthor {
  color: rgba(0, 0, 0, .65);
}

.videoViews {
  color: rgba(0, 0, 0, .45);
}

.videoViews::before {
  content: '·';
  margin-right: 12px;
  color: rgba(0, 0, 0, .25);
}

/* 详情侧栏 */
.poetryDetailMask {
  position: fixed;
  inset: 0;
  z-index: 9999;
  background: rgba(10, 10, 10, 0.42);
}

.poetryDetailPanel {
  position: fixed;
  top: 0;
  right: 0;
  width: 460px;
  max-width: 92vw;
  height: 100vh;
  background: linear-gradient(180deg, rgba(249, 243, 229, 0.99), rgba(245, 237, 220, 0.99));
  box-shadow: -12px 0 40px rgba(0, 0, 0, 0.2);
  padding: 24px 20px 30px;
  overflow-y: auto;
  border-left: 1px solid rgba(120, 90, 50, 0.12);
}

.detailCloseBtn {
  height: 38px;
  padding: 0 16px;
  border: none;
  border-radius: 999px;
  background: rgba(95, 72, 52, 0.92);
  color: #fff;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
}

.detailBody {
  margin-top: 20px;
}

.detailTag {
  display: inline-block;
  padding: 5px 12px;
  border-radius: 999px;
  background: rgba(140, 103, 72, 0.12);
  color: #7b5a3e;
  font-size: 12px;
  font-weight: 700;
  margin-bottom: 14px;
}

.detailTitle {
  font-size: 30px;
  line-height: 1.25;
  color: #2f241b;
  font-weight: 800;
  margin-bottom: 10px;
  font-family: "STKaiti", "KaiTi", "FangSong", serif;
}

.detailMeta {
  font-size: 15px;
  color: #7b6756;
  margin-bottom: 22px;
  font-weight: 600;
}

.detailBlock {
  margin-bottom: 22px;
}

.detailLabel {
  font-size: 15px;
  font-weight: 800;
  color: #7a563a;
  margin-bottom: 10px;
}

.detailText {
  font-size: 15px;
  line-height: 1.9;
  color: #33281f;
}

.detailLine {
  font-size: 20px;
  font-family: "STKaiti", "KaiTi", "FangSong", serif;
  font-weight: 700;
}

.detailKeywordRow {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.detailKeyword {
  padding: 6px 12px;
  border-radius: 999px;
  background: rgba(122, 90, 58, 0.12);
  color: #6c4d31;
  font-size: 13px;
  font-weight: 700;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.24s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* 响应式 */
@media (max-width: 1200px) {
  .videoBoardShell {
    width: min(1180px, 95vw);
  }

  .videoFocusCard {
    left: 18%;
    width: min(380px, 38vw);
  }
}

@media (max-width: 1100px) {
  .hubGrid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 900px) {
  .hallBody {
    grid-template-columns: 1fr;
  }

  .hallLeft {
    display: none;
  }

  .cardStage {
    width: 92vw;
    margin: 0 auto;
    height: 520px;
  }

  .hallRight {
    padding-right: 0;
  }

  .hallH1 {
    font-size: 30px;
    letter-spacing: .12em;
  }

  .hallH2 {
    font-size: 12px;
    letter-spacing: .18em;
  }

  .stageCard {
    left: 14%;
    width: 300px;
    height: 460px;
  }

  .videoBoardFrame {
    min-height: 520px;
  }

  .videoBoardCenter {
    top: auto;
    bottom: 62px;
    transform: translateX(-50%);
  }

  .videoFocusCard {
    left: 32px;
    top: 88px;
    width: calc(100% - 64px);
    min-height: 260px;
    padding: 22px;
  }

  .videoFocusTitle {
    margin-top: 44px;
    font-size: 30px;
  }

  .videoBoardArrow.left {
    left: calc(50% - 110px);
  }

  .videoBoardArrow.right {
    right: calc(50% - 110px);
  }

  .videoBoardMeta {
    display: none;
  }
}

@media (max-width: 820px) {
  .hubWrap {
    padding: 24px 20px 40px;
  }

  .hubTitle {
    font-size: 24px;
  }

  .hubCardTitle {
    font-size: 15px;
  }

  .hubThumb {
    height: 160px;
  }

  .hubThumb.video {
    height: 140px;
  }

  .knowledgeTitle {
    font-size: 20px;
  }

  .knowledgeContent {
    font-size: 14px;
  }

  .hubGrid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 700px) {
  .videoBoardBadge {
    font-size: 22px;
    padding: 10px 20px;
  }

  .videoBoardFrame {
    min-height: 480px;
  }

  .videoStrip {
    width: 14px;
    height: 156px;
  }

  .videoStrip.on {
    width: 78px;
  }

  .videoStripLabel {
    font-size: 22px;
  }

  .videoBoardCenter {
    gap: 7px;
    bottom: 54px;
  }

  .videoBoardTopNav {
    gap: 10px;
    font-size: 10px;
  }

  .videoBoardTopItem:nth-child(4),
  .videoBoardTopItem:nth-child(5),
  .videoBoardTopItem:nth-child(6) {
    display: none;
  }

  .videoFocusCard {
    width: calc(100% - 32px);
    left: 16px;
    top: 76px;
    padding: 18px;
    border-radius: 22px;
  }

  .videoFocusTitle {
    font-size: 24px;
    margin-top: 22px;
  }

  .videoFocusDesc,
  .videoFocusQuote {
    font-size: 13px;
  }

  .videoBoardArrow {
    top: auto;
    bottom: 18px;
  }

  .videoBoardArrow.left {
    left: calc(50% - 92px);
  }

  .videoBoardArrow.right {
    right: calc(50% - 92px);
  }

  .videoBoardFooter {
    grid-template-columns: 1fr;
    text-align: center;
  }

  .videoBoardFootLeft,
  .videoBoardFootRight {
    justify-content: center;
  }

  .videoBoardDate {
    font-size: 28px;
  }
}

@media (max-width: 600px) {
  .hubGrid {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .poetryDetailPanel {
    width: 100vw;
    max-width: 100vw;
  }
}

/* ========== 知识弹窗 ========== */
.modal-fade-enter-active,
.modal-fade-leave-active {
  transition: opacity 0.28s ease;
}

.modal-fade-enter-from,
.modal-fade-leave-to {
  opacity: 0;
}

.knowledge-modal-mask {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.52);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 10000;
}

.knowledge-modal-container {
  width: min(1500px, 92vw);
  height: min(88vh, 900px);
  animation: modalSlideIn 0.32s ease;
}

@keyframes modalSlideIn {
  from {
    transform: translateY(-16px) scale(0.985);
    opacity: 0;
  }

  to {
    transform: translateY(0) scale(1);
    opacity: 1;
  }
}

.knowledge-modal {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  border-radius: 24px;
  background: #f8f3ea;
  box-shadow: 0 24px 80px rgba(0, 0, 0, 0.18);
}

.modal-header {
  position: relative;
  min-height: 150px;
  padding: 28px 32px 22px;
  text-align: center;
  color: #fff;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  flex-shrink: 0;
}

.modal-header::before {
  content: '';
  position: absolute;
  inset: 0;
  background: rgba(46, 39, 31, 0.42);
  z-index: 1;
}

.modal-header h2,
.modal-category,
.modal-close-btn {
  position: relative;
  z-index: 2;
}

.modal-header h2 {
  margin: 0 0 10px;
  font-size: 1.55rem;
  font-weight: 700;
  letter-spacing: 1px;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.22);
}

.modal-category {
  display: inline-block;
  padding: 5px 14px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.24);
  font-size: 0.76rem;
  color: #fff;
}

.modal-close-btn {
  position: absolute;
  top: 16px;
  right: 18px;
  width: 38px;
  height: 38px;
  border-radius: 999px;
  border: 1px solid rgba(255, 255, 255, 0.34);
  background: rgba(255, 255, 255, 0.14);
  color: #fff;
  font-size: 20px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.modal-close-btn:hover {
  background: rgba(255, 255, 255, 0.24);
  transform: scale(1.04);
}

.modal-body {
  flex: 1;
  overflow-y: auto;
  padding: 0;
}

.modal-body::-webkit-scrollbar {
  width: 8px;
}

.modal-body::-webkit-scrollbar-track {
  background: #efe7db;
}

.modal-body::-webkit-scrollbar-thumb {
  background: #ccb18c;
  border-radius: 999px;
}

.modal-inner {
  width: min(1360px, 90%);
  margin: 0 auto;
  padding: 22px 0 26px;
}

.modal-section {
  margin-bottom: 22px;
}

.section-head {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
}

.section-icon {
  font-size: 1.1rem;
  line-height: 1;
}

.modal-section h3 {
  margin: 0;
  font-size: 1.18rem;
  font-weight: 800;
  color: #342517;
  letter-spacing: 0.3px;
}

.intro-section {
  padding-bottom: 10px;
  border-bottom: 1px solid rgba(160, 132, 97, 0.18);
}

.intro-text {
  margin: 0;
  color: #2d241b;
  font-size: 0.94rem;
  line-height: 1.9;
  text-align: justify;
}

.gallery-section {
  margin-top: 6px;
}

.modal-illustration-area {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px;
}

.modal-image-wrapper {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.modal-image-real {
  width: 100%;
  height: 220px;
  display: block;
  border-radius: 14px;
  object-fit: cover;
  background: #efe8dd;
  box-shadow: 0 8px 22px rgba(0, 0, 0, 0.08);
  transition: transform 0.24s ease, box-shadow 0.24s ease;
}

.modal-image-real:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 26px rgba(0, 0, 0, 0.12);
}

.modal-image-caption {
  font-size: 0.8rem;
  line-height: 1.5;
  color: #9a7c53;
  text-align: center;
}

.analysis-section {
  margin-top: 8px;
}

.modal-text-shell {
  border: 1px solid rgba(172, 145, 110, 0.22);
  border-radius: 18px;
  background: rgba(255, 251, 245, 0.68);
  padding: 18px 22px;
}

.modal-text-content {
  color: #2c241a;
  font-size: 0.93rem;
  line-height: 1.9;
}

.modal-text-content h1,
.modal-text-content h2,
.modal-text-content h3,
.modal-text-content h4 {
  color: #2f2418;
  margin: 0 0 16px;
  font-weight: 800;
}

.modal-text-content h2 {
  font-size: 1.22rem;
}

.modal-text-content h3 {
  font-size: 1.04rem;
  margin-top: 20px;
}

.modal-text-content p {
  margin: 0 0 14px;
}

.modal-text-content ul,
.modal-text-content ol {
  margin: 0 0 14px 20px;
  padding: 0;
}

.modal-text-content li {
  margin-bottom: 6px;
}

.modal-text-content blockquote {
  margin: 14px 0;
  padding: 12px 16px;
  background: #f6eee1;
  border-left: 4px solid #c5a477;
  border-radius: 10px;
  color: #5d4932;
}

.modal-footer {
  flex-shrink: 0;
  padding: 14px 0 18px;
  border-top: 1px solid rgba(172, 145, 110, 0.18);
  background: #f8f3ea;
  display: flex;
  justify-content: center;
}

.modal-close-footer {
  min-width: 132px;
  height: 44px;
  padding: 0 24px;
  border: none;
  border-radius: 999px;
  background: linear-gradient(135deg, #9b7742 0%, #7e5b2f 100%);
  color: #fff;
  font-size: 0.92rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.22s ease;
  box-shadow: 0 10px 24px rgba(126, 91, 47, 0.22);
}

.modal-close-footer:hover {
  transform: translateY(-2px);
  box-shadow: 0 14px 26px rgba(126, 91, 47, 0.28);
}

@media (max-width: 1200px) {
  .knowledge-modal-container {
    width: 94vw;
    height: 90vh;
  }

  .modal-inner {
    width: 92%;
  }

  .modal-illustration-area {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .modal-image-real {
    height: 200px;
  }
}

@media (max-width: 768px) {
  .knowledge-modal-container {
    width: 100vw;
    height: 100vh;
  }

  .knowledge-modal {
    border-radius: 0;
  }

  .modal-header {
    min-height: 128px;
    padding: 22px 18px 18px;
  }

  .modal-header h2 {
    font-size: 1.3rem;
    margin-bottom: 8px;
  }

  .modal-category {
    font-size: 0.7rem;
    padding: 4px 12px;
  }

  .modal-close-btn {
    top: 12px;
    right: 12px;
    width: 34px;
    height: 34px;
    font-size: 18px;
  }

  .modal-inner {
    width: 100%;
    padding: 18px 16px 22px;
  }

  .section-icon {
    font-size: 1rem;
  }

  .modal-section h3 {
    font-size: 1.04rem;
  }

  .intro-text,
  .modal-text-content {
    font-size: 0.88rem;
    line-height: 1.8;
  }

  .modal-illustration-area {
    grid-template-columns: 1fr;
    gap: 14px;
  }

  .modal-image-real {
    height: 190px;
    border-radius: 12px;
  }

  .modal-text-shell {
    padding: 16px 14px;
    border-radius: 16px;
  }

  .modal-footer {
    padding: 12px 0 16px;
  }

  .modal-close-footer {
    height: 42px;
    min-width: 124px;
    font-size: 0.88rem;
  }
}

@media (max-width: 480px) {
  .modal-header {
    min-height: 112px;
    padding: 18px 14px 14px;
  }

  .modal-header h2 {
    font-size: 1.08rem;
  }

  .modal-category {
    font-size: 0.64rem;
    padding: 3px 10px;
  }

  .modal-close-btn {
    width: 30px;
    height: 30px;
    font-size: 15px;
  }

  .modal-inner {
    padding: 16px 12px 18px;
  }

  .modal-section h3 {
    font-size: 0.96rem;
  }

  .intro-text,
  .modal-text-content {
    font-size: 0.84rem;
    line-height: 1.72;
  }

  .modal-image-real {
    height: 170px;
  }

  .modal-text-shell {
    padding: 14px 12px;
  }

  .modal-close-footer {
    min-width: 116px;
    height: 40px;
    font-size: 0.84rem;
  }
}

/* ========== 知识弹窗字号强制覆盖，放在 style 最底部 ========== */
.knowledge-modal .modal-header h2 {
  font-size: 1.55rem !important;
  line-height: 1.2 !important;
  font-weight: 700 !important;
  margin: 0 0 10px !important;
}

.knowledge-modal .modal-category {
  font-size: 0.76rem !important;
  padding: 5px 14px !important;
}

.knowledge-modal .section-head {
  gap: 10px !important;
  margin-bottom: 12px !important;
}

.knowledge-modal .section-icon {
  font-size: 1.1rem !important;
  line-height: 1 !important;
}

.knowledge-modal .modal-section h3 {
  font-size: 1.18rem !important;
  line-height: 1.35 !important;
  font-weight: 800 !important;
  margin: 0 !important;
}

.knowledge-modal .intro-text {
  font-size: 0.94rem !important;
  line-height: 1.9 !important;
  margin: 0 !important;
}

.knowledge-modal .modal-image-real {
  height: 220px !important;
  border-radius: 14px !important;
}

.knowledge-modal .modal-image-caption {
  font-size: 0.8rem !important;
  line-height: 1.5 !important;
}

.knowledge-modal .modal-text-shell {
  padding: 18px 22px !important;
  border-radius: 18px !important;
}

.knowledge-modal .modal-text-content {
  font-size: 0.93rem !important;
  line-height: 1.9 !important;
}

.knowledge-modal :deep(.modal-text-content h1),
.knowledge-modal :deep(.modal-text-content h2),
.knowledge-modal :deep(.modal-text-content h3),
.knowledge-modal :deep(.modal-text-content h4) {
  font-weight: 800 !important;
  line-height: 1.4 !important;
  margin: 0 0 16px !important;
  color: #2f2418 !important;
}

.knowledge-modal :deep(.modal-text-content h1) {
  font-size: 1.3rem !important;
}

.knowledge-modal :deep(.modal-text-content h2) {
  font-size: 1.22rem !important;
}

.knowledge-modal :deep(.modal-text-content h3) {
  font-size: 1.04rem !important;
  margin-top: 20px !important;
}

.knowledge-modal :deep(.modal-text-content p),
.knowledge-modal :deep(.modal-text-content li),
.knowledge-modal :deep(.modal-text-content div),
.knowledge-modal :deep(.modal-text-content span) {
  font-size: 0.93rem !important;
  line-height: 1.9 !important;
}

.knowledge-modal :deep(.modal-text-content p) {
  margin: 0 0 14px !important;
}

.knowledge-modal :deep(.modal-text-content ul),
.knowledge-modal :deep(.modal-text-content ol) {
  margin: 0 0 14px 20px !important;
  padding: 0 !important;
}

.knowledge-modal :deep(.modal-text-content blockquote) {
  margin: 14px 0 !important;
  padding: 12px 16px !important;
  font-size: 0.9rem !important;
  line-height: 1.8 !important;
}

@media (max-width: 768px) {
  .knowledge-modal .modal-header h2 {
    font-size: 1.3rem !important;
  }

  .knowledge-modal .modal-category {
    font-size: 0.7rem !important;
    padding: 4px 12px !important;
  }

  .knowledge-modal .modal-section h3 {
    font-size: 1.04rem !important;
  }

  .knowledge-modal .intro-text,
  .knowledge-modal .modal-text-content,
  .knowledge-modal :deep(.modal-text-content p),
  .knowledge-modal :deep(.modal-text-content li),
  .knowledge-modal :deep(.modal-text-content div),
  .knowledge-modal :deep(.modal-text-content span) {
    font-size: 0.88rem !important;
    line-height: 1.8 !important;
  }

  .knowledge-modal .modal-image-real {
    height: 190px !important;
  }
}

@media (max-width: 480px) {
  .knowledge-modal .modal-header h2 {
    font-size: 1.08rem !important;
  }

  .knowledge-modal .modal-section h3 {
    font-size: 0.96rem !important;
  }

  .knowledge-modal .intro-text,
  .knowledge-modal .modal-text-content,
  .knowledge-modal :deep(.modal-text-content p),
  .knowledge-modal :deep(.modal-text-content li),
  .knowledge-modal :deep(.modal-text-content div),
  .knowledge-modal :deep(.modal-text-content span) {
    font-size: 0.84rem !important;
    line-height: 1.72 !important;
  }

  .knowledge-modal .modal-image-real {
    height: 170px !important;
  }
}

.sectionParagraph {
  margin: 0 0 18px;
  max-width: min(820px, 58vw);
}

.sectionParagraph:last-child {
  margin-bottom: 0;
}

.picWrap {
  position: absolute;
  right: 8%;
  top: 54%;
  transform: translateY(-50%) translateY(20px);
  width: min(280px, 18vw);
  transition: opacity 0.4s ease-out, transform 0.4s ease-out;
}

.picWrap.fade-in {
  transform: translateY(-50%) translateY(0);
}

.themePicCard {
  position: relative;
  width: 100%;
  height: min(44vh, 420px);
  border-radius: 18px;
  overflow: hidden;
  box-shadow: 0 22px 58px rgba(0, 0, 0, .34);
  border: 1px solid rgba(255, 255, 255, .16);
  background: rgba(255, 255, 255, .06);
}

.themePicCard img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transform: scale(1.04);
}

.themePicOverlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, .04) 0%, rgba(0, 0, 0, .18) 34%, rgba(0, 0, 0, .62) 100%);
}

.themePicCaption {
  position: absolute;
  left: 18px;
  right: 18px;
  bottom: 18px;
  z-index: 2;
  color: #fff;
}

.themePicLabel {
  font-size: 22px;
  font-weight: 700;
  letter-spacing: .08em;
  margin-bottom: 10px;
}

.themePicQuote {
  font-size: 14px;
  line-height: 1.8;
  color: rgba(255, 245, 220, .92);
}

@media (max-width: 1200px) {
  .sectionParagraph {
    max-width: min(700px, 62vw);
  }

  .picWrap {
    right: 5%;
    width: min(240px, 22vw);
  }
}

@media (max-width: 900px) {
  .contentWrap {
    padding-top: 24vh;
    width: calc(100% - 32px);
  }

  .sectionParagraph {
    max-width: 100%;
  }

  .picWrap {
    position: static;
    width: 100%;
    margin-top: 24px;
    transform: translateY(20px);
  }

  .picWrap.fade-in {
    transform: translateY(0);
  }

  .themePicCard {
    height: 260px;
  }
}



/* 第三屏最终覆盖：文字数量、宋代美学标题、右下配图位置 */
.menuHeroMain {
  grid-template-columns: minmax(420px, 540px) 1fr;
}

.menuHeroInfo {
  max-width: 540px;
}

.menuHeroBig {
  font-size: clamp(58px, 6.8vw, 96px);
  line-height: 1.08;
  letter-spacing: .02em;
  text-shadow: 0 14px 34px rgba(0, 0, 0, .24);
  font-family: "STSong", "Songti SC", "Noto Serif SC", serif;
  word-break: keep-all;
}

.sectionTitle {
  font-family: "STSong", "Songti SC", "Noto Serif SC", serif;
  font-weight: 400;
  line-height: 2.1;
  color: rgba(255, 248, 236, .94);
  letter-spacing: .02em;
}

.sectionParagraph {
  margin: 0 0 18px;
  max-width: min(820px, 58vw);
  text-shadow: 0 4px 18px rgba(0, 0, 0, .18);
}

.sectionParagraph:last-child {
  margin-bottom: 0;
}

.picWrap {
  position: absolute;
  right: 8%;
  top: 54%;
  transform: translateY(-50%) translateY(20px);
  width: min(280px, 18vw);
  margin-right: 0;
  margin-bottom: 0;
}

.picWrap.fade-in {
  transform: translateY(-50%) translateY(0);
}

.themePicCard {
  position: relative;
  width: 100%;
  height: min(44vh, 420px);
  border-radius: 18px;
  overflow: hidden;
  box-shadow: 0 22px 58px rgba(0, 0, 0, .34);
  border: 1px solid rgba(255, 255, 255, .16);
  background: rgba(255, 255, 255, .06);
}

.themePicCard img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transform: scale(1.04);
}

.themePicOverlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, .04) 0%, rgba(0, 0, 0, .18) 34%, rgba(0, 0, 0, .62) 100%);
}

.themePicCaption {
  position: absolute;
  left: 18px;
  right: 18px;
  bottom: 18px;
  z-index: 2;
  color: #fff;
}

.themePicLabel {
  font-size: 22px;
  font-weight: 700;
  letter-spacing: .08em;
  margin-bottom: 10px;
}

.themePicQuote {
  font-size: 14px;
  line-height: 1.8;
  color: rgba(255, 245, 220, .92);
}

@media (max-width: 1200px) {
  .sectionParagraph {
    max-width: min(700px, 62vw);
  }

  .picWrap {
    right: 5%;
    width: min(240px, 22vw);
  }
}

@media (max-width: 1100px) {
  .contentWrap {
    padding-top: 24vh;
    width: min(92vw, 980px);
  }

  .menuHeroMain {
    grid-template-columns: 1fr;
  }

  .menuHeroInfo {
    max-width: none;
  }

  .menuHeroBig {
    font-size: clamp(46px, 10vw, 82px);
  }

  .picWrap {
    position: static;
    width: 100%;
    margin-top: 24px;
    transform: translateY(20px);
  }

  .picWrap.fade-in {
    transform: translateY(0);
  }
}

@media (max-width: 900px) {
  .contentWrap {
    padding-top: 24vh;
    width: calc(100% - 32px);
  }

  .sectionParagraph {
    max-width: 100%;
  }

  .themePicCard {
    height: 260px;
  }
}

</style>
