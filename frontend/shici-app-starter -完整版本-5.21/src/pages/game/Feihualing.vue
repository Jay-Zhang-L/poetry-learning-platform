<template>
  <div class="feihuaPage" :style="pageBgStyle">
    <section v-if="viewMode === 'catalog'" class="catalogPage">
      <div class="catalogMask"></div>

      <div class="catalogInner">
        <div class="catalogTopBar">
          <button class="backBtn" @click="goBack">返回</button>
          <div class="catalogTitleWrap">
            <div class="catalogMini">飞花雅令</div>
            <div class="catalogTitle">联诗流水</div>
            <div class="catalogSub">选择主题字，进入古风竞技场</div>
          </div>
        </div>

        <div class="catalogBoardHead">
          <div>
            <div class="catalogEyebrow">主题目录</div>
            <div class="catalogBoardTitle">请选择你的飞花题面</div>
          </div>
          <div class="catalogHint">点击任意主题开始挑战</div>
        </div>

        <div class="catalogGrid">
          <div
            v-for="(item, index) in displayTopicList"
            :key="item.keyword"
            class="scroll-item"
            :style="{ animationDelay: `${index * 0.08}s` }"
          >
            <button
              class="catalogTopicCard scroll-btn"
              :disabled="startingTopic === item.keyword"
              @click="enterTopic(item)"
            >
              <div class="scroll-inner">
                <div class="scroll-left"></div>
                <div class="scroll-middle">
                  <span class="catalogTopicWord">
                    {{ startingTopic === item.keyword ? "..." : item.keyword }}
                  </span>
                  <span class="catalogTopicMeta">飞花主题</span>
                </div>
                <div class="scroll-right"></div>
              </div>
            </button>
          </div>
        </div>
      </div>
    </section>

    <section v-else class="playPage">
      <div class="playShell">
        <div class="playFrame">
          <div class="topNavBar">
            <div class="navLeft">
              <div class="topicPillsWrapper">
                <div class="topicPillsContainer">
                  <div class="topicPillsTrack" :style="{ transform: `translateX(-${scrollOffset}px)` }">
                    <button
                      v-for="item in displayTopicList"
                      :key="item.keyword"
                      class="topicPill"
                      :class="{ active: currentTopic === item.keyword }"
                      @click="switchTopic(item)"
                    >
                      {{ item.keyword }}
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <div class="navRight">
              <button class="topActionBtn backPageBtn" @click="goBackPage">返回</button>
              <button class="arrowBtn" @click="prevTopic">‹</button>
              <button class="topActionBtn" @click="backToCatalog">目录</button>
              <button class="arrowBtn" @click="nextTopic">›</button>
            </div>
          </div>

          <div class="battleGrid">
            <main class="centerStage">
              <div class="centerBoard">
                <div class="centerInner">
                  <div class="boardTitle">本轮关键字</div>
                  <div class="boardKeyword">{{ currentTopic || "-" }}</div>
                  <div class="boardSubTitle">输入包含关键字的完整诗句即可得分</div>

                  <div class="fieldTitle">诗句示例</div>

                  <div class="poemListWrap">
                    <div
                      v-if="themePoems.length"
                      v-for="(line, idx) in themePoems"
                      :key="idx"
                      class="poemLineItem"
                    >
                      {{ line }}
                    </div>
                    <div v-else class="emptyText">暂无该主题示例诗句</div>
                  </div>

                  <div class="fieldTitle yourTitle">你的诗句</div>
                  <textarea
                    v-model="answerText"
                    class="mainAnswerArea"
                    placeholder="请输入包含当前主题字的完整诗句"
                  ></textarea>

                  <div class="mainActionRow">
                    <button class="mainActionBtn submitBtn" :disabled="submitting" @click="submitAnswer">
                      {{ submitting ? "提交中" : "提交答案" }}
                    </button>
                    <button class="mainActionBtn" @click="clearAnswer">清空</button>
                    <button class="mainActionBtn" :disabled="hintLoading" @click="getHint">
                      {{ hintLoading ? "提示中" : "提示" }}
                    </button>
                    <button class="mainActionBtn" :disabled="skipLoading" @click="skipCurrent">
                      {{ skipLoading ? "跳过中" : "跳过" }}
                    </button>
                    <button class="mainActionBtn outlineBtn" @click="restartGame">重开</button>
                  </div>

                  <div v-if="hintText" class="messageBox hintBox">
                    <span class="msgLabel">提示</span>
                    <span>{{ hintText }}</span>
                  </div>

                  <div
                    v-if="resultText"
                    class="messageBox"
                    :class="resultOk ? 'successBox' : 'errorBox'"
                  >
                    <span class="msgLabel">{{ resultOk ? "结果" : "提醒" }}</span>
                    <span>{{ resultText }}</span>
                  </div>
                </div>
              </div>
            </main>

            <aside class="rightStage">
              <div class="rankBoard" :style="{ backgroundImage: `url(${rankBoardBg})` }">
                <div class="rankBoardHead">芳榜积分表</div>

                <div class="rankHeader">
                  <span>名次</span>
                  <span>昵称</span>
                  <span>积分</span>
                </div>

                <div v-if="rankList.length" class="rankScroll">
                  <div
                    v-for="(item, index) in rankList"
                    :key="item.userId || index"
                    class="rankRow"
                    :class="{ top1: index === 0, top2: index === 1, top3: index === 2 }"
                  >
                    <span>{{ index + 1 }}</span>
                    <span>{{ item.nickname || item.username || "用户" }}</span>
                    <span>{{ item.totalScore ?? 0 }}</span>
                  </div>
                </div>

                <div v-else class="emptyRank">暂无排行榜数据</div>
              </div>
            </aside>
          </div>

          <div class="bottomControlBar">
            <div class="searchWrap">
              <div class="searchLabel">搜索:</div>
              <input
                v-model="searchKeyword"
                class="bottomSearchInput"
                placeholder="搜索诗句、关键词或意象"
                @keyup.enter="doSearch"
              />
              <button class="searchCircleBtn" @click="doSearch">搜</button>
            </div>
          </div>

          <div class="footerInfoRow">
            <div class="sessionMiniCard">
              <div class="miniCardTitle">本局状态</div>
              <div class="miniInfoRow"><span>主题字</span><b>{{ currentTopic || "-" }}</b></div>
              <div class="miniInfoRow"><span>会话编号</span><b>{{ sessionId || "-" }}</b></div>
              <div class="miniInfoRow"><span>提示状态</span><b>{{ hintText ? "已获取" : "未获取" }}</b></div>
            </div>

            <div class="tipsMiniCard">
              <div class="miniCardTitle">飞花小贴士</div>
              <div class="tipLine">优先想"名句"，准确率更高。</div>
              <div class="tipLine">围绕季节、山水、月夜等意象联想。</div>
              <div class="tipLine">不会时先点提示，再尝试作答。</div>
            </div>
          </div>

          <div v-if="searchResult.length" class="searchResultBoard">
            <div class="searchResultHead">
              <div class="searchResultTitle">搜索结果</div>
              <div class="searchResultCount">共 {{ searchResult.length }} 条</div>
            </div>
            <div class="searchResultList">
              <div v-for="(item, idx) in searchResult" :key="idx" class="searchResultItem">
                {{ formatSearchItem(item) }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { computed, onMounted, ref, watch, nextTick } from "vue";
import { useRouter, useRoute } from "vue-router";
import {
  getFeiHuaTopics,
  startFeiHuaGame,
  getFeiHuaSession,
  submitFeiHuaAnswer,
  skipFeiHua,
  hintFeiHua,
  getFeiHuaRank,
  searchFeiHua,
} from "@/utils/api";

import catalogBg from "@/assets/images/feihua-bg.jpg";
import gameBg from "@/assets/game/main-bg.jpg";
import rankBoardBg from "@/assets/game/rank-bg.jpg";

const FEIHUA_RETURN_KEY = "feihua_return_state";

const router = useRouter();
const route = useRoute();

const pageBgStyle = computed(() => {
  const bgImage = viewMode.value === "catalog" ? catalogBg : gameBg;
  return {
    backgroundImage: `url(${bgImage})`,
    backgroundSize: "cover",
    backgroundPosition: "center",
    backgroundRepeat: "no-repeat",
    backgroundAttachment: "fixed",
    minHeight: "100vh",
  };
});

const viewMode = ref("catalog");
const topicList = ref([]);
const rankList = ref([]);

const currentTopic = ref("");
const sessionId = ref(null);
const sessionData = ref(null);

const answerText = ref("");
const hintText = ref("");
const resultText = ref("");
const resultOk = ref(false);

const searchKeyword = ref("");
const searchResult = ref([]);

const startingTopic = ref("");
const submitting = ref(false);
const hintLoading = ref(false);
const skipLoading = ref(false);

const scrollOffset = ref(0);
const pillWidth = 80;
const visibleCount = 12;

const fallbackTopics = [
  { keyword: "花" },
  { keyword: "山" },
  { keyword: "风" },
  { keyword: "春" },
  { keyword: "梅" },
  { keyword: "天" },
  { keyword: "月" },
  { keyword: "秋" },
  { keyword: "水" },
  { keyword: "夜" },
  { keyword: "云" },
  { keyword: "竹" },
  { keyword: "雨" },
  { keyword: "夏" },
  { keyword: "松" },
  { keyword: "溪" },
  { keyword: "石" },
  { keyword: "冬" },
  { keyword: "林" },
  { keyword: "星" },
];

const fallbackPoems = {
  花: [
    "春色满园关不住，一枝红杏出墙来。",
    "人间四月芳菲尽，山寺桃花始盛开。",
    "感时花溅泪，恨别鸟惊心。",
  ],
  月: [
    "举头望明月，低头思故乡。",
    "明月松间照，清泉石上流。",
    "海上生明月，天涯共此时。",
  ],
  风: [
    "随风潜入夜，润物细无声。",
    "夜来风雨声，花落知多少。",
    "长风破浪会有时，直挂云帆济沧海。",
  ],
  春: [
    "春眠不觉晓，处处闻啼鸟。",
    "等闲识得东风面，万紫千红总是春。",
    "国破山河在，城春草木深。",
  ],
  山: [
    "会当凌绝顶，一览众山小。",
    "空山新雨后，天气晚来秋。",
    "千山鸟飞绝，万径人踪灭。",
  ],
  雨: [
    "好雨知时节，当春乃发生。",
    "夜来风雨声，花落知多少。",
    "沾衣欲湿杏花雨，吹面不寒杨柳风。",
  ],
  梅: [
    "墙角数枝梅，凌寒独自开。",
    "梅须逊雪三分白，雪却输梅一段香。",
    "零落成泥碾作尘，只有香如故。",
  ],
};

const displayTopicList = computed(() => {
  return topicList.value.length ? topicList.value : fallbackTopics;
});

const themePoems = computed(() => {
  return fallbackPoems[currentTopic.value] || [];
});

function scrollToCurrentTopic() {
  const index = displayTopicList.value.findIndex((t) => t.keyword === currentTopic.value);
  if (index === -1) return;

  const maxOffset = Math.max(0, (displayTopicList.value.length - visibleCount) * pillWidth);
  let targetOffset = index * pillWidth;

  targetOffset = Math.max(
    0,
    Math.min(maxOffset, targetOffset - (visibleCount / 2) * pillWidth + pillWidth / 2)
  );

  scrollOffset.value = Math.max(0, Math.min(maxOffset, targetOffset));
}

watch(currentTopic, () => {
  nextTick(() => {
    scrollToCurrentTopic();
  });
});

function parseReturnState() {
  try {
    const raw = sessionStorage.getItem(FEIHUA_RETURN_KEY);
    if (!raw) return null;
    return JSON.parse(raw);
  } catch (error) {
    console.error("读取飞花返回状态失败", error);
    return null;
  }
}

function clearReturnState() {
  sessionStorage.removeItem(FEIHUA_RETURN_KEY);
}

function goBack() {
  const saved = parseReturnState();
  console.log("读取到的 feihua_return_state =", saved);

  if (saved?.path) {
    clearReturnState();
    router.push({
      path: saved.path,
      query: {
        restoreFeihua: "1",
      },
    });
    return;
  }

  if (window.history.length > 1) {
    router.back();
    return;
  }

  router.push("/game");
}

function goBackPage() {
  goBack();
}

function backToCatalog() {
  viewMode.value = "catalog";
  answerText.value = "";
  hintText.value = "";
  resultText.value = "";
  searchResult.value = [];
}

async function loadTopics() {
  try {
    const res = await getFeiHuaTopics();
    const list = res?.data || [];
    topicList.value = Array.isArray(list) && list.length ? list : fallbackTopics;
  } catch (e) {
    console.error("加载主题失败", e);
    topicList.value = fallbackTopics;
  }
}

async function loadRank() {
  try {
    const res = await getFeiHuaRank();
    const list = res?.data || [];
    rankList.value = Array.isArray(list) ? list : [];
  } catch (e) {
    console.error("加载排行榜失败", e);
    rankList.value = [];
  }
}

async function loadSession(id) {
  if (!id) return;
  try {
    const res = await getFeiHuaSession(id);
    sessionData.value = res?.data || null;
  } catch (e) {
    console.error("加载会话失败", e);
  }
}

async function enterTopic(item) {
  const keyword = item?.keyword || item?.topic || item?.name;
  if (!keyword) return;

  startingTopic.value = keyword;
  resultText.value = "";
  hintText.value = "";
  answerText.value = "";
  searchResult.value = [];

  try {
    currentTopic.value = keyword;

    const res = await startFeiHuaGame({ keyword });
    const data = res?.data || {};

    sessionId.value = data.sessionId || data.id || null;
    sessionData.value = data || null;

    if (sessionId.value) {
      await loadSession(sessionId.value);
    }

    viewMode.value = "play";
  } catch (e) {
    console.error("进入主题失败", e);
    currentTopic.value = keyword;
    sessionId.value = null;
    sessionData.value = null;
    viewMode.value = "play";
  } finally {
    startingTopic.value = "";
  }
}

async function switchTopic(item) {
  await enterTopic(item);
}

async function prevTopic() {
  if (!displayTopicList.value.length) return;
  const idx = displayTopicList.value.findIndex((t) => t.keyword === currentTopic.value);
  const prev =
    idx >= 0
      ? displayTopicList.value[
          (idx - 1 + displayTopicList.value.length) % displayTopicList.value.length
        ]
      : displayTopicList.value[0];
  await switchTopic(prev);
}

async function nextTopic() {
  if (!displayTopicList.value.length) return;
  const idx = displayTopicList.value.findIndex((t) => t.keyword === currentTopic.value);
  const next =
    idx >= 0
      ? displayTopicList.value[(idx + 1) % displayTopicList.value.length]
      : displayTopicList.value[0];
  await switchTopic(next);
}

function clearAnswer() {
  answerText.value = "";
  resultText.value = "";
}

async function submitAnswer() {
  if (!answerText.value.trim()) {
    resultOk.value = false;
    resultText.value = "请先输入诗句";
    return;
  }

  submitting.value = true;
  try {
    const res = await submitFeiHuaAnswer({
      sessionId: sessionId.value,
      sentence: answerText.value.trim(),
      keyword: currentTopic.value,
    });

    const data = res?.data || {};
    const ok = !!data.correct;

    resultOk.value = ok;
    resultText.value = ok
      ? `回答正确，积分+1，当前累计 ${data.totalScore ?? data.score ?? 0} 分`
      : data.message || "回答不正确，请再试一次";

    await loadRank();
    if (sessionId.value) {
      await loadSession(sessionId.value);
    }
  } catch (e) {
    console.error("提交答案失败", e);
    resultOk.value = false;
    resultText.value = "提交失败，请稍后重试";
  } finally {
    submitting.value = false;
  }
}

async function skipCurrent() {
  if (!sessionId.value) {
    await nextTopic();
    return;
  }

  skipLoading.value = true;
  try {
    await skipFeiHua(sessionId.value);
    await nextTopic();
  } catch (e) {
    console.error("跳过失败", e);
  } finally {
    skipLoading.value = false;
  }
}

async function restartGame() {
  if (!currentTopic.value) return;
  await enterTopic({ keyword: currentTopic.value });
}

async function getHint() {
  if (!sessionId.value) {
    hintText.value = `可先从这些方向联想：${currentTopic.value}、意象、季节、景物`;
    return;
  }

  hintLoading.value = true;
  try {
    const res = await hintFeiHua(sessionId.value);
    const data = res?.data || {};
    hintText.value = data.hint || data.message || "请从常见名句中联想当前主题字";
  } catch (e) {
    console.error("获取提示失败", e);
    hintText.value = "提示获取失败，请稍后重试";
  } finally {
    hintLoading.value = false;
  }
}

async function doSearch() {
  const q = searchKeyword.value.trim();
  if (!q) {
    searchResult.value = [];
    return;
  }

  try {
    const res = await searchFeiHua(q);
    const list = res?.data || [];
    searchResult.value = Array.isArray(list) ? list : [];
  } catch (e) {
    console.error("搜索失败", e);
    searchResult.value = [];
  }
}

function formatSearchItem(item) {
  if (typeof item === "string") return item;
  return item?.poemLine || item?.sentence || item?.content || item?.title || JSON.stringify(item);
}

onMounted(async () => {
  await loadTopics();
  await loadRank();
});
</script>

<style scoped>
.backPageBtn {
  background: rgba(201, 79, 79, 0.92);
  color: #fff;
}

.backPageBtn:hover {
  background: rgba(175, 60, 60, 0.96);
}

.feihuaPage {
  color: #241c15;
  margin: 0;
  padding: 0;
  width: 100%;
}

.catalogPage {
  min-height: 100vh;
  position: relative;
  background: transparent;
  margin: 0;
  padding: 0;
  width: 100%;
}

.catalogMask {
  position: absolute;
  inset: 0;
  background: rgba(255, 248, 235, 0.3);
}

.catalogInner {
  position: relative;
  z-index: 2;
  min-height: 100vh;
  padding: 0;
  margin: 0;
  width: 100%;
  max-width: 100%;
}

.catalogTopBar {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-top: 0;
  padding-top: 0;
  padding-left: 20px;
  padding-right: 20px;
}

.backBtn {
  height: 42px;
  padding: 0 18px;
  border: 1px solid rgba(78, 112, 111, 0.22);
  background: rgba(255, 255, 255, 0.92);
  color: #2c2923;
  font-size: 15px;
  font-weight: 800;
  cursor: pointer;
  box-shadow: 0 8px 20px rgba(31, 92, 92, 0.06);
}

.catalogTitleWrap {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.catalogMini {
  color: #678885;
  font-size: 13px;
  font-weight: 800;
  letter-spacing: 2px;
}

.catalogTitle {
  font-size: 42px;
  font-weight: 900;
  line-height: 1.05;
  color: #171410;
}

.catalogSub {
  color: #72675c;
  font-size: 15px;
  font-weight: 600;
}

.catalogBoardHead {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  gap: 16px;
  margin-bottom: 20px;
  margin-top: 0;
}

.catalogEyebrow {
  color: #8a7a42;
  font-size: 14px;
  font-weight: 800;
  letter-spacing: 1px;
}

.catalogBoardTitle {
  margin-top: 6px;
  font-size: 30px;
  font-weight: 900;
  color: #1f1a14;
}

.catalogHint {
  color: #7b7166;
  font-weight: 700;
}

.catalogGrid {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 24px;
  overflow: hidden;
  padding: 0;
}

.scroll-item {
  opacity: 0;
  transform: translateX(100%);
  animation: scrollIn 0.5s ease forwards;
}

@keyframes scrollIn {
  0% {
    opacity: 0;
    transform: translateX(100%);
  }
  100% {
    opacity: 1;
    transform: translateX(0);
  }
}

.catalogTopicCard {
  position: relative;
  width: 100%;
  background: transparent;
  border: none;
  cursor: pointer;
  padding: 0;
  transition: transform 0.3s ease;
}

.catalogTopicCard:hover {
  transform: translateY(-5px);
}

.scroll-inner {
  position: relative;
  display: flex;
  align-items: center;
  min-height: 140px;
  background: linear-gradient(180deg, #f5e6c8 0%, #e8d4aa 100%);
  box-shadow:
    0 4px 12px rgba(0, 0, 0, 0.15),
    inset 0 1px 0 rgba(255, 255, 255, 0.5);
}

.scroll-left {
  width: 24px;
  height: 100%;
  background: linear-gradient(90deg, #c49a6c 0%, #d4b08c 50%, #c49a6c 100%);
  box-shadow:
    inset -2px 0 4px rgba(0, 0, 0, 0.1),
    2px 0 4px rgba(0, 0, 0, 0.05);
  position: relative;
}

.scroll-left::before {
  content: "";
  position: absolute;
  top: 8px;
  left: 4px;
  right: 4px;
  height: 2px;
  background: rgba(255, 255, 255, 0.4);
}

.scroll-left::after {
  content: "";
  position: absolute;
  bottom: 8px;
  left: 4px;
  right: 4px;
  height: 2px;
  background: rgba(0, 0, 0, 0.1);
}

.scroll-middle {
  flex: 1;
  padding: 20px 16px;
  background: linear-gradient(180deg, #fff8e8 0%, #fef0d8 100%);
  position: relative;
  min-width: 0;
}

.scroll-middle::before {
  content: "";
  position: absolute;
  inset: 0;
  background: repeating-linear-gradient(
    90deg,
    rgba(0, 0, 0, 0.02) 0px,
    rgba(0, 0, 0, 0.02) 1px,
    transparent 1px,
    transparent 4px
  );
  pointer-events: none;
}

.scroll-right {
  width: 24px;
  height: 100%;
  background: linear-gradient(90deg, #c49a6c 0%, #d4b08c 50%, #c49a6c 100%);
  box-shadow:
    inset 2px 0 4px rgba(0, 0, 0, 0.1),
    -2px 0 4px rgba(0, 0, 0, 0.05);
  position: relative;
}

.scroll-right::before {
  content: "";
  position: absolute;
  top: 8px;
  left: 4px;
  right: 4px;
  height: 2px;
  background: rgba(255, 255, 255, 0.4);
}

.scroll-right::after {
  content: "";
  position: absolute;
  bottom: 8px;
  left: 4px;
  right: 4px;
  height: 2px;
  background: rgba(0, 0, 0, 0.1);
}

.catalogTopicWord {
  display: block;
  text-align: center;
  font-size: 42px;
  line-height: 1.2;
  font-weight: 900;
  color: #8b4513;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.05);
  font-family: "楷体", "KaiTi", "STKaiti", serif;
}

.catalogTopicMeta {
  display: block;
  margin-top: 8px;
  text-align: center;
  color: #b8860b;
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 3px;
  font-family: "楷体", "KaiTi", "STKaiti", serif;
}

.catalogTopicCard:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.catalogTopicCard:disabled:hover {
  transform: none;
}

.playPage {
  min-height: 100vh;
  padding: 0;
}

.playShell {
  width: min(100%, 1600px);
  margin: 0 auto;
}

.playFrame {
  position: relative;
  padding: 0;
  background: transparent;
  overflow: hidden;
}

.topNavBar {
  position: relative;
  z-index: 2;
  min-height: 82px;
  padding: 0;
  background: rgba(255, 253, 245, 0.88);
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 18px;
  width: 100%;
  margin: 0;
}

.navLeft {
  display: flex;
  align-items: center;
  gap: 16px;
  min-width: 0;
  flex: 1;
}

.topicPillsWrapper {
  flex: 1;
  min-width: 0;
  overflow: hidden;
}

.topicPillsContainer {
  overflow-x: auto;
  scrollbar-width: none;
  -ms-overflow-style: none;
  position: relative;
}

.topicPillsContainer::-webkit-scrollbar {
  display: none;
}

.topicPillsTrack {
  display: flex;
  transition: transform 0.3s ease;
  white-space: nowrap;
}

.topicPill {
  flex-shrink: 0;
  width: 80px;
  height: 52px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: transparent;
  border: none;
  color: #5a4a3a;
  font-size: 22px;
  font-weight: 600;
  cursor: pointer;
  position: relative;
  transition: all 0.2s ease;
}

.topicPill:not(:last-child)::after {
  content: "";
  position: absolute;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 1px;
  height: 24px;
  background: rgba(90, 74, 58, 0.25);
}

.topicPill.active {
  color: #c94f4f;
  font-weight: 900;
  font-size: 26px;
}

.topicPill:hover:not(.active) {
  color: #8b6b4a;
}

.navRight {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-shrink: 0;
  padding-right: 16px;
}

.arrowBtn,
.topActionBtn {
  height: 50px;
  background: rgba(255, 255, 252, 0.9);
  color: #35302a;
  font-weight: 900;
  cursor: pointer;
  border: none;
}

.arrowBtn {
  width: 50px;
  font-size: 30px;
  line-height: 1;
}

.topActionBtn {
  padding: 0 18px;
  font-size: 15px;
}

.battleGrid {
  position: relative;
  z-index: 2;
  margin-top: 16px;
  display: flex;
  gap: 20px;
  align-items: stretch;
}

.centerStage {
  flex: 3;
  min-width: 0;
}

.rightStage {
  flex: 1;
  min-width: 0;
}

.centerBoard {
  position: relative;
  min-height: 610px;
  overflow: hidden;
}

.centerInner {
  position: relative;
  z-index: 2;
  padding: 20px 20px 18px;
}

.boardTitle {
  font-size: 20px;
  font-weight: 900;
  color: #1d1915;
}

.boardKeyword {
  margin-top: 4px;
  font-size: 42px;
  font-weight: 900;
  color: #1b1713;
}

.boardSubTitle {
  margin-top: 6px;
  color: #4b443c;
  font-size: 18px;
  font-weight: 700;
}

.fieldTitle {
  margin-top: 14px;
  margin-bottom: 8px;
  font-size: 18px;
  font-weight: 900;
  color: #1f1a16;
}

.poemListWrap {
  margin-top: 8px;
  margin-bottom: 8px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.poemLineItem {
  padding: 12px 16px;
  background: rgba(252, 252, 248, 0.92);
  color: #2d2822;
  line-height: 1.8;
  font-size: 16px;
  font-weight: 700;
  border-radius: 8px;
  border-left: 4px solid #c94f4f;
}

.yourTitle {
  margin-top: 12px;
}

.mainAnswerArea {
  width: 100%;
  box-sizing: border-box;
  background: rgba(252, 252, 248, 0.92);
  color: #2d2822;
  font-size: 18px;
  font-weight: 700;
  min-height: 140px;
  resize: vertical;
  padding: 14px 16px;
  outline: none;
  font-family: inherit;
  line-height: 1.8;
  border: 2px solid rgba(130, 134, 127, 0.35);
}

.mainAnswerArea:focus {
  box-shadow: 0 0 0 4px rgba(72, 192, 181, 0.08);
  border-color: rgba(72, 192, 181, 0.52);
}

.mainActionRow {
  margin-top: 16px;
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.mainActionBtn {
  min-width: 110px;
  height: 58px;
  padding: 0 22px;
  background: linear-gradient(180deg, rgba(255,255,255,0.95), rgba(241,238,232,0.95));
  color: #312b26;
  font-size: 18px;
  font-weight: 900;
  cursor: pointer;
  box-shadow:
    inset 0 1px 0 rgba(255,255,255,0.88),
    0 6px 12px rgba(0,0,0,0.05);
  border: 2px solid rgba(76, 72, 67, 0.26);
}

.mainActionBtn:disabled {
  opacity: 0.68;
  cursor: not-allowed;
}

.submitBtn {
  background: linear-gradient(180deg, #ffd36b, #f3b22b);
  color: #fff;
  border-color: rgba(180, 123, 21, 0.28);
}

.outlineBtn {
  background: rgba(255,255,255,0.9);
  border: 3px solid #2b2723;
}

.messageBox {
  margin-top: 14px;
  padding: 12px 14px;
  display: flex;
  gap: 10px;
  align-items: flex-start;
  font-size: 15px;
  font-weight: 700;
  line-height: 1.8;
}

.msgLabel {
  flex-shrink: 0;
  min-width: 40px;
  font-weight: 900;
}

.hintBox {
  background: rgba(255, 245, 208, 0.95);
  color: #8a6700;
}

.successBox {
  background: rgba(231, 249, 237, 0.96);
  color: #1f8d50;
}

.errorBox {
  background: rgba(255, 237, 237, 0.96);
  color: #c04040;
}

.rankBoard {
  min-height: 610px;
  padding: 16px 14px;
  position: relative;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  overflow: hidden;
}

.rankBoard::before {
  content: "";
  position: absolute;
  inset: 0;
  z-index: 0;
}

.rankBoard > * {
  position: relative;
  z-index: 1;
}

.rankBoardHead {
  text-align: center;
  font-size: 26px;
  font-weight: 900;
  color: #5a4a3a;
  margin-bottom: 12px;
  letter-spacing: 4px;
}

.rankHeader {
  display: grid;
  grid-template-columns: 50px minmax(0, 1fr) 56px;
  gap: 10px;
  align-items: center;
  min-height: 40px;
  padding: 0 8px;
  border-bottom: 2px solid rgba(255, 215, 150, 0.5);
  color: #5a4a3a;
  font-size: 16px;
  font-weight: 900;
}

.rankScroll {
  margin-top: 8px;
  max-height: 500px;
  overflow-y: auto;
  padding-right: 2px;
}

.rankRow {
  display: grid;
  grid-template-columns: 50px minmax(0, 1fr) 56px;
  gap: 10px;
  align-items: center;
  min-height: 50px;
  padding: 0 8px;
  border-bottom: 1px solid rgba(255, 215, 150, 0.25);
  color: #5a4a3a;
  font-size: 17px;
  font-weight: 800;
  backdrop-filter: blur(2px);
}

.rankRow span:nth-child(1),
.rankRow span:nth-child(3),
.rankHeader span:nth-child(1),
.rankHeader span:nth-child(3) {
  text-align: center;
}

.rankRow span:nth-child(2),
.rankHeader span:nth-child(2) {
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.top1 {
  background: rgba(255, 215, 0, 0.25);
  border-left: 3px solid #FFD700;
}

.top2 {
  background: rgba(192, 192, 192, 0.2);
  border-left: 3px solid #C0C0C0;
}

.top3 {
  background: rgba(205, 127, 50, 0.2);
  border-left: 3px solid #CD7F32;
}

.emptyRank {
  margin-top: 18px;
  text-align: center;
  color: #FFE8B0;
  font-weight: 700;
}

.bottomControlBar {
  position: relative;
  z-index: 2;
  margin-top: 16px;
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 16px;
  align-items: center;
}

.searchWrap {
  display: flex;
  align-items: center;
  gap: 10px;
  min-height: 80px;
  padding: 10px 14px;
  background: #fff;
  border: 2px solid #5a4a3a;
  border-radius: 48px;
  box-shadow: 0 4px 12px rgba(90, 74, 58, 0.15);
}

.searchLabel {
  font-size: 28px;
  font-weight: 900;
  color: #5a4a3a;
  flex-shrink: 0;
}

.bottomSearchInput {
  flex: 1;
  min-width: 0;
  height: 54px;
  padding: 0 16px;
  background: #fff;
  font-size: 18px;
  outline: none;
  color: #5a4a3a;
  border: 1px solid #5a4a3a;
  border-radius: 40px;
  font-weight: 500;
}

.searchCircleBtn {
  width: 56px;
  height: 56px;
  background: #9f2f25;
  color: #fff;
  font-size: 22px;
  font-weight: 900;
  cursor: pointer;
  border: none;
  border-radius: 50%;
}

.footerInfoRow {
  position: relative;
  z-index: 2;
  margin-top: 16px;
  display: grid;
  grid-template-columns: 320px minmax(0, 1fr);
  gap: 16px;
}

.sessionMiniCard {
  padding: 16px;
}

.tipsMiniCard {
  padding: 16px 18px;
}

.miniCardTitle {
  font-size: 20px;
  font-weight: 900;
  color: #241f18;
  margin-bottom: 10px;
}

.miniInfoRow {
  min-height: 40px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
  border-bottom: 1px solid rgba(0,0,0,0.08);
  color: #4b4338;
  font-weight: 700;
}

.tipLine {
  padding: 10px 12px;
  color: #3d352c;
  line-height: 1.8;
  font-weight: 700;
  margin-bottom: 10px;
}

.searchResultBoard {
  position: relative;
  z-index: 2;
  margin-top: 16px;
  padding: 16px 18px;
}

.searchResultHead {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.searchResultTitle {
  font-size: 22px;
  font-weight: 900;
  color: #231e18;
}

.searchResultCount {
  color: #7c7369;
  font-weight: 700;
}

.searchResultList {
  margin-top: 12px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.searchResultItem {
  padding: 12px 14px;
  background: rgba(255,255,255,0.8);
  color: #362f28;
  line-height: 1.85;
  font-weight: 700;
}

.emptyText {
  color: #85796e;
  text-align: center;
  font-weight: 700;
  margin-top: 8px;
}

@media (max-width: 1200px) {
  .battleGrid {
    flex-direction: column;
  }

  .centerStage,
  .rightStage {
    width: 100%;
  }

  .footerInfoRow {
    grid-template-columns: 1fr;
  }
}
</style>