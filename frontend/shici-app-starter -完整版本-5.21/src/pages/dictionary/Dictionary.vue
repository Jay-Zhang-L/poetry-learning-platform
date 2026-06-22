<template>
  <div class="dictionaryPage">
    <section class="heroSection">
      <div class="heroBackdrop"></div>
      <div class="heroVeil"></div>
      <!-- 故宫风格装饰角 -->
      <div class="palace-corner top-left"></div>
      <div class="palace-corner top-right"></div>
      <div class="palace-corner bottom-left"></div>
      <div class="palace-corner bottom-right"></div>
      <!-- 光晕装饰 -->
      <div class="hero-glow"></div>
      <div class="heroInner pageShell">
        <div class="heroFrame">
          <div class="heroTopLine"></div>

          <div class="heroHead">
            <div class="heroLabel">古文词典</div>
            <h1 class="heroTitle">{{ homeData.bannerTitle || '词义有源，典故有迹' }}</h1>
            <p class="heroSubtitle">
              收录词义、古今演变、诗文出处与文化背景，在安静的页面里读清一个词。
            </p>
          </div>

          <div class="heroSearchPanel" :class="{ focused: searchFocused }">
            <div class="searchSymbol">检</div>
            <input
              v-model.trim="keyword"
              class="heroSearchInput"
              type="text"
              placeholder="请输入词语、拼音、出处"
              @keyup.enter="doSearch"
              @focus="searchFocused = true"
              @blur="searchFocused = false"
            />
            <button class="heroSearchBtn" @click="doSearch">查阅</button>
          </div>

          <div class="heroBottomMeta">
            <span class="metaLine"></span>
            <span class="metaText">今日推荐</span>
            <span class="metaLine"></span>
          </div>
        </div>
      </div>
    </section>

    <section class="listSection pageShell" v-if="!showSearchResult">
      <div class="sectionHeader">
        <div>
          <h2 class="sectionTitle">推荐词条</h2>
          <p class="sectionDesc">用更克制的版式承载词义与出处，不堆砌装饰，重点回到内容本身。</p>
        </div>
        <div class="sectionCount">共 {{ recommendList.length }} 条</div>
      </div>

      <div class="cardGrid">
        <article
          v-for="item in pagedRecommendList"
          :key="item.id"
          class="wordCard"
          @click="openDetail(item.id)"
        >
          <div class="cardHead">
            <div class="cardMark"></div>
            <h3 class="wordTitle">{{ item.word }}</h3>
          </div>

          <div class="wordPinyin" v-if="item.fullPinyin || item.pinyin">
            {{ item.fullPinyin || item.pinyin }}
          </div>

          <p class="wordDesc">{{ item.explanation }}</p>

          <div class="cardFoot">
            <span class="cardType">词条</span>
            <span class="cardArrow">查看</span>
          </div>
        </article>
      </div>

      <div class="paginationWrap" v-if="recommendList.length">
        <button
          class="pageBtn"
          :disabled="currentPage === 1"
          @click="goPage(currentPage - 1)"
        >
          上一页
        </button>

        <button
          v-for="page in visiblePages"
          :key="page"
          class="pageNoBtn"
          :class="{ active: currentPage === page }"
          @click="goPage(page)"
        >
          {{ page }}
        </button>

        <button
          class="pageBtn"
          :disabled="currentPage === totalPages"
          @click="goPage(currentPage + 1)"
        >
          下一页
        </button>
      </div>
    </section>

    <section class="searchSection pageShell" v-if="showSearchResult">
      <div class="sectionHeader searchHeader">
        <div>
          <h2 class="sectionTitle">搜索结果</h2>
          <p class="sectionDesc">共找到 {{ searchList.length }} 条相关词条</p>
        </div>
        <button class="backBtn" @click="resetHome">返回推荐</button>
      </div>

      <div v-if="searchList.length" class="searchList">
        <article
          v-for="item in searchList"
          :key="item.id"
          class="searchItem"
          @click="openDetail(item.id)"
        >
          <div class="searchMain">
            <div class="searchWordRow">
              <span class="searchWord">{{ item.word }}</span>
              <span class="searchPinyin">{{ item.fullPinyin || item.pinyin || '' }}</span>
            </div>
            <div class="searchDesc">{{ item.explanation }}</div>
          </div>
          <div class="searchAction">展开</div>
        </article>
      </div>

      <div v-else class="emptyBlock">
        <div class="emptyTitle">没有搜索到相关词条</div>
        <div class="emptyText">可以更换关键词，或返回推荐词条继续浏览。</div>
      </div>
    </section>

    <transition name="detail-fade">
      <div v-if="detailVisible" class="detailOverlay">
        <div class="detailPanel">
          <div class="detailTopBar">
            <button class="detailBackBtn" @click="closeDetail">返回</button>
            <div class="detailTopTitle">词条详解</div>
            <button class="detailCloseBtn" @click="closeDetail">×</button>
          </div>

          <div class="detailBody">
            <main class="detailMain">
              <section class="detailHeader">
                <div class="detailTag" v-if="detail.themeTag">{{ detail.themeTag }}</div>
                <h1 class="detailWord">{{ detail.word }}</h1>
                <div class="detailPinyin" v-if="detail.fullPinyin || detail.pinyin">
                  {{ detail.fullPinyin || detail.pinyin }}
                </div>
                <div class="detailAltPinyin" v-if="detail.alternativePinyin">
                  {{ detail.alternativePinyin }}
                </div>
                <p class="detailIntro" v-if="detail.explanation">{{ detail.explanation }}</p>
              </section>

              <section class="detailSection" v-if="detail.detailedDefinition">
                <h2 class="detailSectionTitle">完整释义</h2>
                <div class="detailText">{{ detail.detailedDefinition }}</div>
              </section>

              <section
                class="detailSection"
                v-if="detail.ancientMeaning || detail.modernMeaning || detail.semanticShift"
              >
                <h2 class="detailSectionTitle">古今义与演变</h2>

                <div class="subBlock" v-if="detail.ancientMeaning">
                  <div class="subTitle">古义</div>
                  <div class="detailText">{{ detail.ancientMeaning }}</div>
                </div>

                <div class="subBlock" v-if="detail.modernMeaning">
                  <div class="subTitle">今义</div>
                  <div class="detailText">{{ detail.modernMeaning }}</div>
                </div>

                <div class="subBlock" v-if="detail.semanticShift">
                  <div class="subTitle">语义演变</div>
                  <div class="detailText">{{ detail.semanticShift }}</div>
                </div>
              </section>

              <section
                class="detailSection"
                v-if="detail.sourceTitle || detail.sourceText || detail.sourceNote"
              >
                <h2 class="detailSectionTitle">出处溯源</h2>
                <div class="subBlock" v-if="detail.sourceTitle || detail.sourceText || detail.sourceNote">
                  <div class="subTitle">{{ detail.sourceTitle || '出处' }}</div>
                  <div class="quoteText" v-if="detail.sourceText">{{ detail.sourceText }}</div>
                  <div class="detailText" v-if="detail.sourceNote">{{ detail.sourceNote }}</div>
                </div>
              </section>

              <section
                class="detailSection"
                v-if="detail.exampleClassical || detail.examplePoetry || detail.exampleModern"
              >
                <h2 class="detailSectionTitle">用法例句</h2>

                <div class="subBlock" v-if="detail.exampleClassical">
                  <div class="subTitle">古文例句</div>
                  <div class="detailText">{{ detail.exampleClassical }}</div>
                </div>

                <div class="subBlock" v-if="detail.examplePoetry">
                  <div class="subTitle">诗词例句</div>
                  <div class="detailText">{{ detail.examplePoetry }}</div>
                </div>

                <div class="subBlock" v-if="detail.exampleModern">
                  <div class="subTitle">现代用法</div>
                  <div class="detailText">{{ detail.exampleModern }}</div>
                </div>
              </section>

              <section
                class="detailSection"
                v-if="detail.culturalBackground || detail.geographyNote || detail.literatureNote"
              >
                <h2 class="detailSectionTitle">文化背景</h2>

                <div class="subBlock" v-if="detail.culturalBackground">
                  <div class="subTitle">文化背景</div>
                  <div class="detailText">{{ detail.culturalBackground }}</div>
                </div>

                <div class="subBlock" v-if="detail.geographyNote">
                  <div class="subTitle">地理背景</div>
                  <div class="detailText">{{ detail.geographyNote }}</div>
                </div>

                <div class="subBlock" v-if="detail.literatureNote">
                  <div class="subTitle">文学意象</div>
                  <div class="detailText">{{ detail.literatureNote }}</div>
                </div>
              </section>

              <section
                class="detailSection"
                v-if="
                  detail.poemExpand1Title || detail.poemExpand1Quote || detail.poemExpand1Analysis ||
                  detail.poemExpand2Title || detail.poemExpand2Quote || detail.poemExpand2Analysis ||
                  detail.poemExpand3Title || detail.poemExpand3Quote || detail.poemExpand3Analysis
                "
              >
                <h2 class="detailSectionTitle">诗词拓展</h2>

                <div
                  class="subBlock"
                  v-if="detail.poemExpand1Title || detail.poemExpand1Quote || detail.poemExpand1Analysis"
                >
                  <div class="subTitle">{{ detail.poemExpand1Title || '拓展一' }}</div>
                  <div class="subMeta" v-if="detail.poemExpand1Author">{{ detail.poemExpand1Author }}</div>
                  <div class="quoteText" v-if="detail.poemExpand1Quote">{{ detail.poemExpand1Quote }}</div>
                  <div class="detailText" v-if="detail.poemExpand1Analysis">{{ detail.poemExpand1Analysis }}</div>
                </div>

                <div
                  class="subBlock"
                  v-if="detail.poemExpand2Title || detail.poemExpand2Quote || detail.poemExpand2Analysis"
                >
                  <div class="subTitle">{{ detail.poemExpand2Title || '拓展二' }}</div>
                  <div class="subMeta" v-if="detail.poemExpand2Author">{{ detail.poemExpand2Author }}</div>
                  <div class="quoteText" v-if="detail.poemExpand2Quote">{{ detail.poemExpand2Quote }}</div>
                  <div class="detailText" v-if="detail.poemExpand2Analysis">{{ detail.poemExpand2Analysis }}</div>
                </div>

                <div
                  class="subBlock"
                  v-if="detail.poemExpand3Title || detail.poemExpand3Quote || detail.poemExpand3Analysis"
                >
                  <div class="subTitle">{{ detail.poemExpand3Title || '拓展三' }}</div>
                  <div class="subMeta" v-if="detail.poemExpand3Author">{{ detail.poemExpand3Author }}</div>
                  <div class="quoteText" v-if="detail.poemExpand3Quote">{{ detail.poemExpand3Quote }}</div>
                  <div class="detailText" v-if="detail.poemExpand3Analysis">{{ detail.poemExpand3Analysis }}</div>
                </div>
              </section>
            </main>

            <aside class="detailAside">
              <div class="asideInner">
                <div class="asideCard" v-if="detail.wordType">
                  <div class="asideLabel">词性</div>
                  <div class="asideValue">{{ detail.wordType }}</div>
                </div>

                <div class="asideCard" v-if="detail.usageType">
                  <div class="asideLabel">用法</div>
                  <div class="asideValue">{{ detail.usageType }}</div>
                </div>

                <div class="asideCard" v-if="detail.emotionalColor">
                  <div class="asideLabel">色彩</div>
                  <div class="asideValue">{{ detail.emotionalColor }}</div>
                </div>

                <div class="asideCard" v-if="detail.mistakeProne">
                  <div class="asideLabel">易错提示</div>
                  <div class="asideValue">{{ detail.mistakeProne }}</div>
                </div>

                <div class="asideCard" v-if="detail.writingNote">
                  <div class="asideLabel">书写说明</div>
                  <div class="asideValue">{{ detail.writingNote }}</div>
                </div>

                <div class="asideCard" v-if="detail.characterNote">
                  <div class="asideLabel">汉字拆解</div>
                  <div class="asideValue">{{ detail.characterNote }}</div>
                </div>

                <div class="asideCard" v-if="detail.synonymText">
                  <div class="asideLabel">近义词</div>
                  <div class="asideValue">{{ detail.synonymText }}</div>
                </div>

                <div class="asideCard" v-if="detail.antonymText">
                  <div class="asideLabel">反义词</div>
                  <div class="asideValue">{{ detail.antonymText }}</div>
                </div>

                <div class="asideCard" v-if="detail.recommendText">
                  <div class="asideLabel">推荐词</div>
                  <div class="asideValue">{{ detail.recommendText }}</div>
                </div>
              </div>
            </aside>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch, onBeforeUnmount } from 'vue'
import { getDictionaryHome, searchDictionary, getDictionaryDetail } from '@/utils/api'

const keyword = ref('')
const homeData = ref({})
const recommendList = ref([])
const searchList = ref([])
const showSearchResult = ref(false)
const searchFocused = ref(false)

const detailVisible = ref(false)
const detail = ref({})

const pageSize = 8
const currentPage = ref(1)

const totalPages = computed(() => {
  return Math.max(1, Math.ceil((recommendList.value?.length || 0) / pageSize))
})

const pagedRecommendList = computed(() => {
  const start = (currentPage.value - 1) * pageSize
  const end = start + pageSize
  return (recommendList.value || []).slice(start, end)
})

const visiblePages = computed(() => {
  const total = totalPages.value

  if (total <= 5) {
    return Array.from({ length: total }, (_, i) => i + 1)
  }

  if (currentPage.value <= 3) {
    return [1, 2, 3, 4, 5]
  }

  if (currentPage.value >= total - 2) {
    return [total - 4, total - 3, total - 2, total - 1, total]
  }

  return [
    currentPage.value - 2,
    currentPage.value - 1,
    currentPage.value,
    currentPage.value + 1,
    currentPage.value + 2
  ]
})

watch(recommendList, () => {
  if (currentPage.value > totalPages.value) {
    currentPage.value = 1
  }
})

const goPage = (page) => {
  if (page < 1 || page > totalPages.value) return
  currentPage.value = page
}

const loadHome = async () => {
  try {
    const res = await getDictionaryHome()
    const data = res?.data || res || {}
    homeData.value = data
    recommendList.value = data.recommendList || []
    currentPage.value = 1
  } catch (e) {
    console.error('加载词典首页失败', e)
  }
}

const doSearch = async () => {
  try {
    const kw = keyword.value.trim()
    const res = await searchDictionary(kw)
    searchList.value = res?.data || res || []
    showSearchResult.value = true
  } catch (e) {
    console.error('搜索词典失败', e)
  }
}

const resetHome = () => {
  showSearchResult.value = false
  keyword.value = ''
  searchList.value = []
}

const openDetail = async (id) => {
  try {
    const res = await getDictionaryDetail(id)
    detail.value = res?.data || res || {}
    detailVisible.value = true
    document.body.style.overflow = 'hidden'
  } catch (e) {
    console.error('加载词条详情失败', e)
  }
}

const closeDetail = () => {
  detailVisible.value = false
  detail.value = {}
  document.body.style.overflow = ''
}

onMounted(() => {
  loadHome()
})

onBeforeUnmount(() => {
  document.body.style.overflow = ''
})
</script>

<style scoped>
:global(html),
:global(body) {
  margin: 0;
  padding: 0;
  width: 100%;
  overflow-x: hidden;
  background: #efe7d7;
}

:global(*) {
  box-sizing: border-box;
}

.dictionaryPage {
  min-height: 100vh;
  background: var(--paper-bg, #f8f4eb);
  color: #2f281f;
}

.dictionaryPage::before {
  content: "";
  position: fixed;
  inset: 0;
  z-index: -2;
  background:
    linear-gradient(rgba(248, 244, 235, 0.92), rgba(248, 244, 235, 0.96)),
    #f8f4eb center center / cover no-repeat;
  pointer-events: none;
}

.dictionaryPage::after {
  content: "";
  position: fixed;
  inset: 0;
  z-index: -1;
  background:
    radial-gradient(900px 420px at 20% 12%, rgba(155, 123, 71, 0.06), transparent 65%),
    radial-gradient(800px 380px at 80% 24%, rgba(138, 47, 43, 0.04), transparent 70%),
    radial-gradient(900px 480px at 50% 100%, rgba(120, 105, 90, 0.05), transparent 66%);
  pointer-events: none;
  animation: bgGlow 8s ease-in-out infinite;
}

@keyframes bgGlow {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.85; }
}

.pageShell {
  width: min(1440px, calc(100% - 64px));
  margin: 0 auto;
}

.heroSection {
  position: relative;
  min-height: 520px;
  border-bottom: 1px solid rgba(103, 80, 54, 0.2);
  overflow: hidden;
}

.heroBackdrop {
  position: absolute;
  inset: 0;
  background:
    linear-gradient(rgba(243, 237, 226, 0.02), rgba(243, 237, 226, 0.02)),
    url('@/assets/cidian/bg1.jpg') center center / cover no-repeat;
  filter: saturate(1) contrast(1.06) brightness(1.01);
  transform: none;
}
.heroVeil {
  position: absolute;
  inset: 0;
  background:
    linear-gradient(
      180deg,
      rgba(239, 231, 215, 0.04) 0%,
      rgba(239, 231, 215, 0.02) 30%,
      rgba(239, 231, 215, 0.18) 100%
    ),
    repeating-linear-gradient(
      90deg,
      rgba(137, 108, 76, 0.004) 0,
      rgba(137, 108, 76, 0.004) 1px,
      transparent 1px,
      transparent 36px
    );
}

/* 故宫风格装饰角 */
.palace-corner {
  position: absolute;
  width: 80px;
  height: 80px;
  pointer-events: none;
  z-index: 2;
  opacity: 0.4;
  transition: opacity 0.3s ease;
}
.palace-corner:hover { opacity: 0.7; }

.palace-corner::before,
.palace-corner::after {
  content: "";
  position: absolute;
  background: linear-gradient(135deg, rgba(138, 47, 43, 0.6), rgba(194, 160, 96, 0.4));
}

.palace-corner.top-left { top: 20px; left: 20px; }
.palace-corner.top-left::before { top: 0; left: 0; width: 60px; height: 2px; }
.palace-corner.top-left::after { top: 0; left: 0; width: 2px; height: 60px; }

.palace-corner.top-right { top: 20px; right: 20px; }
.palace-corner.top-right::before { top: 0; right: 0; width: 60px; height: 2px; }
.palace-corner.top-right::after { top: 0; right: 0; width: 2px; height: 60px; }

.palace-corner.bottom-left { bottom: 20px; left: 20px; }
.palace-corner.bottom-left::before { bottom: 0; left: 0; width: 60px; height: 2px; }
.palace-corner.bottom-left::after { bottom: 0; left: 0; width: 2px; height: 60px; }

.palace-corner.bottom-right { bottom: 20px; right: 20px; }
.palace-corner.bottom-right::before { bottom: 0; right: 0; width: 60px; height: 2px; }
.palace-corner.bottom-right::after { bottom: 0; right: 0; width: 2px; height: 60px; }

/* 光晕装饰 */
.hero-glow {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 600px;
  height: 400px;
  background: radial-gradient(ellipse, rgba(194, 160, 96, 0.08), transparent 70%);
  pointer-events: none;
  z-index: 0;
  animation: heroGlow 4s ease-in-out infinite;
}

@keyframes heroGlow {
  0%, 100% { opacity: 0.6; transform: translate(-50%, -50%) scale(1); }
  50% { opacity: 1; transform: translate(-50%, -50%) scale(1.1); }
}
.heroInner {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  min-height: 520px;
  padding: 64px 0 48px;
}

.heroFrame {
  width: min(980px, 100%);
  padding: 28px 0 0;
}

.heroTopLine {
  width: 84px;
  height: 1px;
  background: rgba(125, 93, 60, 0.7);
  margin-bottom: 28px;
}

.heroHead {
  max-width: 760px;
}

.heroLabel {
  display: inline-block;
  padding: 0 0 10px;
  font-size: 13px;
  letter-spacing: 0.28em;
  color: #8c5f43;
  text-transform: uppercase;
}

.heroTitle {
  margin: 0;
  font-size: 64px;
  line-height: 1.12;
  font-weight: 500;
  letter-spacing: 2px;
  color: #2d241b;
  transition: all 0.4s ease;
  animation: titleIn 0.8s ease both;
}

@keyframes titleIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.heroSection:hover .heroTitle {
  letter-spacing: 4px;
  text-shadow: 0 0 40px rgba(194, 160, 96, 0.2);
}

.heroSubtitle {
  max-width: 720px;
  margin: 22px 0 0;
  font-size: 17px;
  line-height: 2;
  color: #625340;
}

.heroSearchPanel {
  width: min(860px, 100%);
  margin-top: 42px;
  min-height: 78px;
  display: grid;
  grid-template-columns: 76px minmax(0, 1fr) 158px;
  border: 1px solid rgba(112, 89, 63, 0.28);
  background: rgba(248, 243, 234, 0.88);
  transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
}

.heroSearchPanel.focused {
  border-color: rgba(138, 47, 43, 0.4);
  box-shadow: 0 0 0 4px rgba(138, 47, 43, 0.08), 0 8px 24px rgba(72, 60, 46, 0.1);
  transform: translateY(-2px);
  background: rgba(255, 255, 255, 0.95);
}

.heroSearchPanel.focused .searchSymbol {
  color: #8a3830;
  background: rgba(138, 47, 43, 0.05);
}

.heroSearchPanel.focused .heroSearchBtn {
  background: linear-gradient(180deg, #8a3830, #5e2520);
}

.searchSymbol {
  display: flex;
  align-items: center;
  justify-content: center;
  border-right: 1px solid rgba(112, 89, 63, 0.22);
  color: #8a5d42;
  font-size: 24px;
  letter-spacing: 2px;
  transition: all 0.3s ease;
}

.heroSearchInput {
  width: 100%;
  min-width: 0;
  border: none;
  outline: none;
  background: transparent;
  padding: 0 26px;
  font-size: 17px;
  color: #312921;
  transition: all 0.3s ease;
}

.heroSearchInput::placeholder {
  color: #9a8a74;
}

.heroSearchBtn {
  border: none;
  border-left: 1px solid rgba(112, 89, 63, 0.22);
  background: linear-gradient(180deg, rgba(132, 87, 56, 0.92), rgba(94, 62, 40, 0.95));
  color: #f6efe6;
  font-size: 16px;
  letter-spacing: 0.18em;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.heroSearchBtn::before {
  content: "";
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  transform: translate(-50%, -50%);
  transition: all 0.5s ease;
}

.heroSearchBtn:hover::before {
  width: 300px;
  height: 300px;
}

.heroSearchBtn:hover {
  transform: scale(1.02);
  box-shadow: 0 4px 16px rgba(138, 56, 48, 0.3);
}

.heroSearchBtn:active {
  transform: scale(0.98);
}

.heroSearchBtn:hover {
  background: rgba(117, 75, 48, 0.96);
}

.heroBottomMeta {
  margin-top: 42px;
  display: flex;
  align-items: center;
  gap: 18px;
  color: #7c6447;
}

.metaLine {
  width: 52px;
  height: 1px;
  background: rgba(124, 100, 71, 0.55);
}

.metaText {
  font-size: 14px;
  letter-spacing: 0.18em;
}

.listSection,
.searchSection {
  padding: 48px 0 76px;
}

.sectionHeader {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
  padding-bottom: 18px;
  border-bottom: 1px solid rgba(110, 87, 61, 0.16);
}

.sectionTitle {
  margin: 0;
  font-size: 34px;
  font-weight: 500;
  color: #31271d;
  transition: all 0.3s ease;
  animation: titleSlideIn 0.6s ease both;
}

@keyframes titleSlideIn {
  from { opacity: 0; transform: translateX(-20px); }
  to { opacity: 1; transform: translateX(0); }
}

.sectionTitle:hover {
  color: #8a3830;
  letter-spacing: 2px;
}

.sectionDesc {
  margin: 10px 0 0;
  font-size: 15px;
  line-height: 1.9;
  color: #756450;
}

.sectionCount {
  flex-shrink: 0;
  font-size: 14px;
  color: #8a755c;
  letter-spacing: 0.08em;
}

.cardGrid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 24px;
  margin-top: 28px;
}

.cardGrid .wordCard:nth-child(1) { animation-delay: 0s; }
.cardGrid .wordCard:nth-child(2) { animation-delay: 0.08s; }
.cardGrid .wordCard:nth-child(3) { animation-delay: 0.16s; }
.cardGrid .wordCard:nth-child(4) { animation-delay: 0.24s; }
.cardGrid .wordCard:nth-child(5) { animation-delay: 0.32s; }
.cardGrid .wordCard:nth-child(6) { animation-delay: 0.4s; }
.cardGrid .wordCard:nth-child(7) { animation-delay: 0.48s; }
.cardGrid .wordCard:nth-child(8) { animation-delay: 0.56s; }

.wordCard {
  position: relative;
  min-height: 290px;
  padding: 24px 22px 18px;
  border: 1px solid rgba(110, 87, 61, 0.18);
  background: rgba(255, 255, 255, 0.5);
  cursor: pointer;
  transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
  animation: cardIn 0.5s ease both;
}

@keyframes cardIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.wordCard::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  width: 4px;
  height: 100%;
  background: linear-gradient(180deg, rgba(138, 47, 43, 0.7), rgba(194, 160, 96, 0.4));
  transform: scaleY(0);
  transform-origin: top center;
  transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.wordCard::after {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(circle at 50% 0%, rgba(194, 160, 96, 0.06), transparent 60%);
  opacity: 0;
  transition: opacity 0.4s ease;
  pointer-events: none;
}

.wordCard:hover::before {
  transform: scaleY(1);
}

.wordCard:hover::after {
  opacity: 1;
}

.wordCard:hover {
  transform: translateY(-6px);
  border-color: rgba(138, 47, 43, 0.35);
  background: rgba(255, 255, 255, 0.85);
  box-shadow:
    0 16px 40px rgba(72, 60, 46, 0.12),
    0 0 0 1px rgba(194, 160, 96, 0.2);
}

.cardHead {
  position: relative;
  padding-top: 14px;
}

.cardMark {
  position: absolute;
  left: 0;
  top: 0;
  width: 22px;
  height: 2px;
  background: #9d6246;
}

.wordTitle {
  margin: 0;
  font-size: 34px;
  font-weight: 500;
  color: #30261d;
  transition: all 0.3s ease;
}

.wordCard:hover .wordTitle {
  color: #8a3830;
  letter-spacing: 2px;
  text-shadow: 0 0 20px rgba(138, 47, 43, 0.15);
}

.wordPinyin {
  margin-top: 16px;
  font-size: 14px;
  line-height: 1.8;
  color: #7b6b57;
  transition: color 0.3s ease;
}

.wordCard:hover .wordPinyin {
  color: #5e2520;
}

.wordDesc {
  margin: 22px 0 0;
  font-size: 15px;
  line-height: 2;
  color: #43382c;
  display: -webkit-box;
  -webkit-line-clamp: 5;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.cardFoot {
  position: absolute;
  left: 22px;
  right: 22px;
  bottom: 18px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-top: 14px;
  border-top: 1px solid rgba(110, 87, 61, 0.14);
  transition: border-color 0.3s ease;
}

.wordCard:hover .cardFoot {
  border-top-color: rgba(138, 47, 43, 0.25);
}

.cardType,
.cardArrow {
  font-size: 13px;
  color: #8b7357;
  transition: all 0.3s ease;
}

.wordCard:hover .cardType {
  color: #8a3830;
}

.wordCard:hover .cardArrow {
  color: #8a3830;
  letter-spacing: 4px;
}

.paginationWrap {
  margin-top: 34px;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.pageBtn,
.pageNoBtn,
.backBtn,
.detailBackBtn,
.detailCloseBtn {
  border-radius: 0;
}

.pageBtn,
.pageNoBtn,
.backBtn {
  min-width: 46px;
  height: 40px;
  padding: 0 16px;
  border: 1px solid rgba(72, 60, 46, 0.15);
  background: rgba(255, 255, 255, 0.6);
  color: #3d3125;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.pageBtn::before,
.pageNoBtn::before,
.backBtn::before {
  content: "";
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  background: rgba(138, 47, 43, 0.15);
  border-radius: 50%;
  transform: translate(-50%, -50%);
  transition: all 0.4s ease;
}

.pageBtn:hover::before,
.pageNoBtn:hover::before,
.backBtn:hover::before {
  width: 200px;
  height: 200px;
}

.pageNoBtn.active,
.pageBtn:hover:not(:disabled),
.pageNoBtn:hover,
.backBtn:hover {
  border-color: rgba(138, 47, 43, 0.4);
  background: linear-gradient(180deg, #8a3830, #5e2520);
  color: #fff;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(138, 56, 48, 0.25);
}

.pageBtn:disabled {
  opacity: 0.42;
  cursor: not-allowed;
}

.searchHeader {
  align-items: center;
}

.searchList {
  margin-top: 24px;
  border-top: 1px solid rgba(110, 87, 61, 0.14);
}

.searchItem {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 88px;
  gap: 20px;
  align-items: center;
  padding: 24px 12px;
  border-bottom: 1px solid rgba(110, 87, 61, 0.14);
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  background: transparent;
}

.searchItem::before {
  content: "";
  position: absolute;
  left: 0;
  top: 0;
  width: 4px;
  height: 100%;
  background: linear-gradient(180deg, rgba(138, 47, 43, 0.7), rgba(194, 160, 96, 0.4));
  transform: scaleY(0);
  transform-origin: top center;
  transition: transform 0.3s ease;
}

.searchItem:hover::before {
  transform: scaleY(1);
}

.searchItem:hover {
  background: rgba(255, 255, 255, 0.5);
  padding-left: 16px;
  box-shadow: 0 4px 16px rgba(72, 60, 46, 0.08);
}

.searchWordRow {
  display: flex;
  flex-wrap: wrap;
  align-items: baseline;
  gap: 16px;
}

.searchWord {
  font-size: 30px;
  color: #31271d;
  transition: all 0.3s ease;
}

.searchItem:hover .searchWord {
  color: #8a3830;
  letter-spacing: 2px;
}

.searchPinyin {
  font-size: 14px;
  color: #7d6a57;
}

.searchDesc {
  margin-top: 10px;
  font-size: 15px;
  line-height: 1.95;
  color: #4a3e31;
}

.searchAction {
  justify-self: end;
  font-size: 14px;
  color: #8a5d42;
}

.emptyBlock {
  margin-top: 24px;
  padding: 86px 24px;
  border: 1px solid rgba(110, 87, 61, 0.14);
  text-align: center;
  background: rgba(255, 255, 255, 0.18);
}

.emptyTitle {
  font-size: 24px;
  color: #3a3025;
}

.emptyText {
  margin-top: 12px;
  font-size: 15px;
  color: #7d6e5c;
}

.detailOverlay {
  position: fixed;
  inset: 0;
  z-index: 200;
  background: rgba(38, 30, 23, 0.34);
}

.detailPanel {
  width: min(1560px, calc(100% - 32px));
  height: calc(100vh - 32px);
  margin: 16px auto;
  display: flex;
  flex-direction: column;
  border: 1px solid rgba(72, 60, 46, 0.15);
  background: rgba(255, 255, 255, 0.6);
  overflow: hidden;
  animation: panelIn 0.4s cubic-bezier(0.4, 0, 0.2, 1) both;
  box-shadow: 0 20px 60px rgba(72, 60, 46, 0.15);
}

@keyframes panelIn {
  from {
    opacity: 0;
    transform: scale(0.96) translateY(20px);
  }
  to {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

.detailTopBar {
  height: 72px;
  flex: 0 0 72px;
  display: grid;
  grid-template-columns: 120px 1fr 72px;
  align-items: center;
  padding: 0 18px;
  border-bottom: 1px solid rgba(111, 86, 58, 0.16);
  background: rgba(246, 239, 228, 0.96);
}

.detailTopTitle {
  text-align: center;
  font-size: 18px;
  color: #574635;
  letter-spacing: 0.18em;
}

.detailBackBtn,
.detailCloseBtn {
  border: 1px solid rgba(72, 60, 46, 0.15);
  background: rgba(255, 255, 255, 0.7);
  color: #574635;
  cursor: pointer;
  transition: all 0.3s ease;
}

.detailBackBtn:hover,
.detailCloseBtn:hover {
  background: #8a3830;
  border-color: #8a3830;
  color: #fff;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(138, 56, 48, 0.25);
}

.detailCloseBtn:hover {
  transform: translateY(-2px) rotate(90deg);
}

.detailBackBtn {
  width: 84px;
  height: 40px;
  font-size: 14px;
}

.detailCloseBtn {
  justify-self: end;
  width: 40px;
  height: 40px;
  font-size: 28px;
  line-height: 1;
}

.detailBody {
  flex: 1;
  min-height: 0;
  display: grid;
  grid-template-columns: minmax(0, 1fr) 320px;
}

.detailMain {
  min-width: 0;
  overflow-y: auto;
  padding: 34px 42px 42px;
}

.detailAside {
  border-left: 1px solid rgba(111, 86, 58, 0.14);
  background: rgba(255, 255, 255, 0.16);
  overflow-y: auto;
}

.asideInner {
  padding: 28px 24px 32px;
}

.detailHeader {
  position: relative;
  padding-bottom: 30px;
  border-bottom: 1px solid rgba(111, 86, 58, 0.16);
}

.detailTag {
  display: inline-block;
  padding: 6px 10px;
  border: 1px solid rgba(141, 93, 64, 0.2);
  font-size: 12px;
  letter-spacing: 0.12em;
  color: #8d5d40;
  background: rgba(157, 98, 70, 0.05);
}

.detailWord {
  margin: 20px 0 0;
  font-size: 72px;
  line-height: 1.04;
  font-weight: 500;
  color: #30261c;
  transition: all 0.4s ease;
  animation: wordIn 0.6s ease both;
}

@keyframes wordIn {
  from { opacity: 0; transform: translateX(-20px); }
  to { opacity: 1; transform: translateX(0); }
}

.detailWord:hover {
  color: #8a3830;
  letter-spacing: 4px;
  text-shadow: 0 0 30px rgba(138, 47, 43, 0.15);
}

.detailPinyin {
  margin-top: 16px;
  font-size: 22px;
  color: #7b694f;
}

.detailAltPinyin {
  margin-top: 8px;
  font-size: 14px;
  color: #9b886f;
}

.detailIntro {
  max-width: 960px;
  margin: 22px 0 0;
  font-size: 18px;
  line-height: 2;
  color: #45382c;
}

.detailSection {
  padding-top: 30px;
  animation: sectionIn 0.5s ease both;
}

@keyframes sectionIn {
  from { opacity: 0; transform: translateY(15px); }
  to { opacity: 1; transform: translateY(0); }
}

.detailSectionTitle {
  margin: 0 0 16px;
  padding-left: 14px;
  font-size: 28px;
  font-weight: 500;
  color: #33281e;
  border-left: 4px solid #8a3830;
  transition: all 0.3s ease;
}

.detailSectionTitle:hover {
  color: #8a3830;
  border-left-color: #c2a060;
  padding-left: 20px;
}

.subBlock {
  padding: 18px 0 16px;
  border-top: 1px solid rgba(111, 86, 58, 0.14);
}

.subBlock:first-of-type {
  border-top: none;
  padding-top: 0;
}

.subTitle {
  margin-bottom: 10px;
  font-size: 16px;
  font-weight: 600;
  color: #6d563f;
}

.subMeta {
  margin-bottom: 10px;
  font-size: 14px;
  color: #8e7a60;
}

.detailText {
  font-size: 16px;
  line-height: 2.05;
  color: #3f3429;
  white-space: pre-wrap;
}

.quoteText {
  margin-bottom: 12px;
  padding: 14px 16px;
  border-left: 2px solid rgba(141, 93, 64, 0.48);
  background: rgba(157, 98, 70, 0.06);
  color: #554434;
  line-height: 1.95;
  white-space: pre-wrap;
}

.asideCard {
  padding: 16px 0;
  border-bottom: 1px solid rgba(111, 86, 58, 0.14);
}

.asideLabel {
  margin-bottom: 8px;
  font-size: 13px;
  letter-spacing: 0.08em;
  color: #8e7458;
}

.asideValue {
  font-size: 15px;
  line-height: 1.95;
  color: #44372a;
  white-space: pre-wrap;
}

.detail-fade-enter-active,
.detail-fade-leave-active {
  transition: opacity 0.18s ease;
}

.detail-fade-enter-from,
.detail-fade-leave-to {
  opacity: 0;
}

@media (max-width: 1280px) {
  .cardGrid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .detailBody {
    grid-template-columns: 1fr;
  }

  .detailAside {
    border-left: none;
    border-top: 1px solid rgba(111, 86, 58, 0.14);
  }
}

@media (max-width: 768px) {
  .pageShell {
    width: calc(100% - 28px);
  }

  .heroSection,
  .heroInner {
    min-height: 460px;
  }

  .heroTitle {
    font-size: 40px;
    line-height: 1.2;
  }

  .heroSubtitle {
    font-size: 15px;
  }

  .heroSearchPanel {
    grid-template-columns: 56px minmax(0, 1fr);
  }

  .heroSearchBtn {
    grid-column: 1 / -1;
    min-height: 54px;
    border-left: none;
    border-top: 1px solid rgba(112, 89, 63, 0.22);
  }

  .sectionHeader {
    flex-direction: column;
    align-items: flex-start;
  }

  .sectionTitle {
    font-size: 28px;
  }

  .cardGrid {
    grid-template-columns: 1fr;
  }

  .searchItem {
    grid-template-columns: 1fr;
    padding: 18px 4px;
  }

  .searchAction {
    justify-self: start;
  }

  .detailPanel {
    width: calc(100% - 10px);
    height: calc(100vh - 10px);
    margin: 5px auto;
  }

  .detailTopBar {
    grid-template-columns: 84px 1fr 44px;
    padding: 0 10px;
  }

  .detailTopTitle {
    font-size: 15px;
    letter-spacing: 0.08em;
  }

  .detailMain {
    padding: 22px 16px 28px;
  }

  .asideInner {
    padding: 18px 16px 24px;
  }

  .detailWord {
    font-size: 46px;
  }

  .detailPinyin {
    font-size: 18px;
  }

  .detailSectionTitle {
    font-size: 24px;
  }
}
</style>
