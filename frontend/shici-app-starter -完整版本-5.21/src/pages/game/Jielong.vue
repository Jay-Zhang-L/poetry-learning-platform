<template>
  <div class="relayPage" :style="{ 
    backgroundImage: `url(${bgImage})`, 
    backgroundSize: 'cover', 
    backgroundPosition: 'center', 
    backgroundRepeat: 'no-repeat',
    backgroundAttachment: 'fixed'
  }">
    <div class="pageShell">
      <button class="backBtnOnly" @click="goBack">
        <span class="backArrow">←</span>
        <span>诗词学习</span>
      </button>

      <section class="mainStage">
        <div class="stageBg">
          <div class="bgGlow glow1"></div>
          <div class="bgGlow glow2"></div>
          <div class="bgGlow glow3"></div>
          <div class="bgDragon"></div>
          <div class="floorHalo"></div>
        </div>

        <!-- 顶部两栏布局：PNG图片 + 右侧正方形容器 -->
        <div class="topTwoColumns">
          <!-- 左侧：PNG图片区域 -->
          <div class="leftDragonArea">
            <div class="dragonScaleContainer">
              <div class="scaleCard">
                <div class="customImageArea">
                  <img 
                    :src="dragonScaleImage" 
                    alt="龙鳞图案"
                    class="dragonScaleImg"
                    v-if="dragonScaleImage"
                  />
                  <div class="imagePlaceholder" v-else>
                    <span>请导入PNG图片</span>
                  </div>
                  
                  <!-- SVG 龙鳞亮起特效 - 16个独立鳞片 + 圆形光点 -->
                  <svg class="scaleSvgOverlay" viewBox="0 0 200 200" v-if="dragonScaleImage">
                    <defs>
                      <!-- 鳞片亮起渐变 -->
                      <radialGradient id="scaleGlow" cx="50%" cy="50%" r="50%">
                        <stop offset="0%" stop-color="rgba(255,215,0,0.9)"/>
                        <stop offset="40%" stop-color="rgba(255,180,0,0.6)"/>
                        <stop offset="70%" stop-color="rgba(255,140,0,0.3)"/>
                        <stop offset="100%" stop-color="rgba(255,100,0,0)"/>
                      </radialGradient>
                      <!-- 圆形光点渐变 -->
                      <radialGradient id="dotGlow">
                        <stop offset="0%" stop-color="rgba(255,255,220,1)"/>
                        <stop offset="30%" stop-color="rgba(255,215,0,0.9)"/>
                        <stop offset="60%" stop-color="rgba(255,180,0,0.5)"/>
                        <stop offset="100%" stop-color="rgba(255,140,0,0)"/>
                      </radialGradient>
                      <filter id="glowFilter">
                        <feGaussianBlur stdDeviation="2" result="blur"/>
                        <feMerge>
                          <feMergeNode in="blur"/>
                          <feMergeNode in="SourceGraphic"/>
                        </feMerge>
                      </filter>
                    </defs>
                    
                    <!-- 16个鳞片（填充式点亮） -->
                    <path 
                      v-for="i in 16" 
                      :key="'scale_' + i"
                      :d="getScalePath(i)"
                      fill="url(#scaleGlow)"
                      :class="{ active: i - 1 < state.dragonLightCount }"
                      class="scalePath"
                    />
                    
                    <!-- 16个圆形光点（在每片鳞片的外圈中心位置） -->
                    <circle 
                      v-for="i in 16" 
                      :key="'dot_' + i"
                      :cx="getDotPosition(i).x"
                      :cy="getDotPosition(i).y"
                      r="9"
                      fill="url(#dotGlow)"
                      :class="{ active: i - 1 < state.dragonLightCount }"
                      class="scaleDot"
                      filter="url(#glowFilter)"
                    />
                  </svg>
                </div>
                <!-- 龙鳞进度显示（数字+文字）放在图片内 -->
                <div class="scaleProgressCenter">
                  <div class="scaleProgressNum">{{ state.dragonLightCount }}/{{ state.totalTargetCount }}</div>
                  <div class="scaleProgressLabel">龙鳞点亮</div>
                </div>
              </div>
            </div>
          </div>

          <!-- 右侧：接近正方形的容器 -->
          <div class="rightSquareArea">
            <div class="squareGameContainer">
              <!-- 上句标签和倒计时 -->
              <div class="cardTop">
                <div class="badgeGroup">
                  <span class="fromTag">从上句</span>
                  <span class="timerTag">限时 {{ state.leftSeconds }}s</span>
                </div>
                <div class="statusBadge">
                  +{{ state.scorePerQuestion }}分/句
                </div>
              </div>

              <!-- 诗句 + 作者信息 -->
              <div class="questionMain">
                <div class="questionSentence">
                  {{ state.poemSentence || "点击下方开始接龙" }}
                </div>
                <div class="questionMeta">
                  {{ state.dynasty || "唐" }} · {{ state.author || "柳宗元" }}
                </div>
              </div>

              <!-- 输入框区域 -->
              <div class="answerCard">
                <div class="inputWrap">
                  <span class="pen">笔</span>
                  <input
                    v-model.trim="state.answer"
                    class="answerInput"
                    placeholder="请输入下一句诗..."
                    @keyup.enter="submitAnswer"
                  />
                </div>

                <!-- 规则提示 -->
                <div class="tipLine">
                  <span class="tipWord">首字应为“{{ state.expectedWord || "请先开始" }}”</span>
                  <span class="tipSub">今日提示 {{ state.hintUsed }}/{{ state.hintLimit }}</span>
                </div>

                <div class="helperRow">
                  <div class="helperChip">已答对 {{ state.totalCorrect }} 句</div>
                  <div class="helperChip">连对 {{ state.currentStreak }} 句</div>
                </div>
              </div>

              <!-- 确认按钮 -->
              <button class="confirmBtn" @click="submitAnswer" :disabled="loading">
                确认接龙 · 点亮龙鳞
              </button>

              <!-- 开始按钮 -->
              <div class="bottomCenterBtns">
                <button class="startBtn" @click="startGame" :disabled="loading">
                  {{ state.sessionId ? "继续接龙" : "开始接龙" }}
                </button>
              </div>
              <!-- 本局状态容器 -->
              <div class="stateContainer">
                <div class="leftInfoCard">
                  <div class="leftInfoTitle">本局状态</div>
                  <div class="leftInfoGrid">
                    <div class="infoMini">
                      <span>本局答对</span>
                      <b>{{ state.totalCorrect }}</b>
                    </div>
                    <div class="infoMini">
                      <span>连续接对</span>
                      <b>{{ state.currentStreak }}</b>
                    </div>
                    <div class="infoMini">
                      <span>接龙积分</span>
                      <b>{{ state.relayScore }}</b>
                    </div>
                    <div class="infoMini">
                      <span>游戏总分</span>
                      <b>{{ state.totalScore }}</b>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 下方区域：三个按钮 + 龙鳞进度条 -->
        <div class="bottomActionArea">
          <div class="actionPanel">
            <button class="actionBtn mint" @click="getHint">提示一句</button>
            <button class="actionBtn gold" @click="changeQuestion">换一题</button>
            <button class="actionBtn pink" @click="openHistory">历史记录</button>
          </div>

          <div class="progressPanel">
            <div class="progressHead">
              <span>龙鳞进度 {{ state.dragonLightCount }}/{{ state.totalTargetCount }}</span>
              <span>每句 {{ state.scorePerQuestion }} 分</span>
            </div>
            <div class="progressBar">
              <div class="progressInner" :style="{ width: progressPercent + '%' }"></div>
            </div>
          </div>
        </div>

        <section class="rankSection">
          <div class="rankTitle">排行榜</div>
          <div class="rankList">
            <div class="rankRow rankHead">
              <span>名次</span>
              <span>昵称</span>
              <span>积分</span>
            </div>
            <div class="rankBody">
              <div class="rankRow" v-for="(item, idx) in rankList" :key="item.id || item.userId || idx">
                <span>{{ idx + 1 }}</span>
                <span>{{ item.nickname || item.username || "新用户" }}</span>
                <span>{{ item.score ?? item.relayScore ?? item.totalScore ?? 0 }}</span>
              </div>
              <div class="rankEmpty" v-if="!rankList.length">暂无排行榜数据</div>
            </div>
          </div>
        </section>
      </section>
    </div>

    <transition name="fade">
      <div class="toast" v-if="toastText">{{ toastText }}</div>
    </transition>

    <div class="mask" v-if="showHistory" @click.self="showHistory = false">
      <div class="historyDialog">
        <div class="dialogTitle">历史记录</div>
        <div class="historyList">
          <div class="historyItem" v-for="(item, idx) in historyList" :key="idx">
            {{ item }}
          </div>
          <div class="emptyText" v-if="!historyList.length">暂无记录</div>
        </div>
        <button class="dialogClose" @click="showHistory = false">关闭</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, reactive, ref } from "vue";
import { useRouter } from "vue-router";
import {
  startRelayGame,
  submitRelayAnswer,
  getRelayHistory,
  getRelayRank
} from "@/utils/api";
import bgImage from '@/assets/game/jielong.jpg';
import dragonScalePng from '@/assets/game/dragon.png';

const router = useRouter();
const loading = ref(false);
const rankList = ref([]);
const historyList = ref([]);
const toastText = ref("");
const showHistory = ref(false);
const showIntro = ref(true);
const lastSubmitCorrect = ref(false);

const dragonScaleImage = ref(dragonScalePng);

let toastTimer = null;

const state = reactive({
  sessionId: null,
  questionId: null,
  poemSentence: "",
  expectedWord: "",
  answer: "",
  dynasty: "唐",
  author: "柳宗元",
  currentStreak: 0,
  totalCorrect: 0,
  dragonLightCount: 0,
  totalTargetCount: 16,  // 改为16
  relayScore: 0,
  totalScore: 0,
  scorePerQuestion: 10,
  leftSeconds: 30,
  timer: null,
  hintUsed: 0,
  hintLimit: 3
});

const progressPercent = computed(() => {
  if (!state.totalTargetCount) return 0;
  return Math.min(100, (state.dragonLightCount / state.totalTargetCount) * 100);
});

// 计算单个鳞片路径（最外圈，16等份，第一个鳞片中心在12点位置）
function getScalePath(index) {
  // 每个鳞片占22.5°（360°/16 = 22.5°）
  // 第一个鳞片中心在-90°（12点位置）
  // 第1个：-101.25° 到 -78.75°（中心-90°）
  // 第2个：-78.75° 到 -56.25°（中心-67.5°）
  // 以此类推
  const angleStart = (index - 1) * 22.5 - 90 - 11.25;  // 起始角度：中心角 - 11.25°
  const angleEnd = (index - 1) * 22.5 - 90 + 11.25;    // 结束角度：中心角 + 11.25°
  
  const startRad = angleStart * Math.PI / 180;
  const endRad = angleEnd * Math.PI / 180;
  
  const centerX = 100;
  const centerY = 100;
  const innerR = 55;   // 内圈半径
  const outerR = 95;   // 外圈半径
  
  // 计算四个点
  const innerStartX = centerX + innerR * Math.cos(startRad);
  const innerStartY = centerY + innerR * Math.sin(startRad);
  const outerStartX = centerX + outerR * Math.cos(startRad);
  const outerStartY = centerY + outerR * Math.sin(startRad);
  const outerEndX = centerX + outerR * Math.cos(endRad);
  const outerEndY = centerY + outerR * Math.sin(endRad);
  const innerEndX = centerX + innerR * Math.cos(endRad);
  const innerEndY = centerY + innerR * Math.sin(endRad);
  
  // 绘制鳞片路径
  return `M ${innerStartX} ${innerStartY} L ${outerStartX} ${outerStartY} A ${outerR} ${outerR} 0 0 1 ${outerEndX} ${outerEndY} L ${innerEndX} ${innerEndY} A ${innerR} ${innerR} 0 0 0 ${innerStartX} ${innerStartY} Z`;
}

// 计算圆形光点位置（在每个鳞片的外圈中心位置）
function getDotPosition(index) {
  // 每个鳞片的中心角度：第1个-90°，第2个-67.5°，第3个-45°，第4个-22.5°...
  const centerAngle = (index - 1) * 22.5 - 90;
  // 半径距离（外圈中间位置）
  const radius = 88;
  const centerX = 100;
  const centerY = 100;
  
  // 角度转弧度
  const rad = centerAngle * Math.PI / 180;
  
  const x = centerX + radius * Math.cos(rad);
  const y = centerY + radius * Math.sin(rad);
  
  return { x, y };
}

function getLastChineseChar(text) {
  if (!text) return "";
  const cleaned = String(text)
    .replace(/[，。！？；：、“”‘’（）()《》〈〉【】\[\]\s]/g, "")
    .trim();
  const match = cleaned.match(/[\u4e00-\u9fa5](?=[^\u4e00-\u9fa5]*$)/);
  return match ? match[0] : "";
}

function normalizeSentence(data = {}) {
  return (
    data.nextPoemSentence ||
    data.nextSentence ||
    data.nextLine ||
    data.nextQuestion ||
    data.currentSentence ||
    data.currentLine ||
    data.poemSentence ||
    data.questionSentence ||
    data.sentence ||
    ""
  );
}

function normalizeQuestionId(data = {}) {
  return data.nextQuestionId ?? data.questionId ?? data.id ?? null;
}

function resolveExpectedWord(data = {}, sentence = "") {
  return (
    data.expectedWord ||
    data.nextExpectedWord ||
    data.firstWord ||
    data.nextFirstWord ||
    getLastChineseChar(sentence || state.poemSentence || "")
  );
}

function showToast(text) {
  toastText.value = text || "";
  if (toastTimer) {
    clearTimeout(toastTimer);
    toastTimer = null;
  }
  if (!toastText.value) return;
  toastTimer = setTimeout(() => {
    toastText.value = "";
  }, 2200);
}

function goBack() {
  router.back();
}

function startTimer() {
  stopTimer();
  state.leftSeconds = 30;
  state.timer = setInterval(() => {
    state.leftSeconds -= 1;
    if (state.leftSeconds <= 0) {
      stopTimer();
      state.leftSeconds = 0;
      showToast("本题已超时，可换一题继续");
    }
  }, 1000);
}

function stopTimer() {
  if (state.timer) {
    clearInterval(state.timer);
    state.timer = null;
  }
}

function applyGameData(data = {}) {
  const prevSentence = state.poemSentence;
  const nextSentence = normalizeSentence(data);
  const nextQuestionId = normalizeQuestionId(data);

  state.sessionId = data.sessionId ?? state.sessionId ?? null;
  state.questionId = nextQuestionId ?? state.questionId ?? null;

  if (nextSentence) {
    state.poemSentence = nextSentence;
  }

  state.expectedWord = resolveExpectedWord(data, state.poemSentence);

  state.currentStreak = data.currentStreak ?? state.currentStreak ?? 0;
  state.totalCorrect = data.totalCorrect ?? state.totalCorrect ?? 0;
  state.dragonLightCount = data.dragonLightCount ?? state.dragonLightCount ?? 0;
  state.totalTargetCount = 16;  // 固定为16

  state.relayScore = data.relayScore ?? state.relayScore ?? 0;
  state.totalScore = data.totalScore ?? state.totalScore ?? 0;
  state.scorePerQuestion = data.scorePerQuestion ?? state.scorePerQuestion ?? 10;

  state.dynasty = data.dynasty || data.nextDynasty || state.dynasty || "唐";
  state.author = data.author || data.nextAuthor || state.author || "柳宗元";

  state.answer = "";

  return {
    prevSentence,
    nextSentence: state.poemSentence,
    changed: !!state.poemSentence && state.poemSentence !== prevSentence
  };
}

async function loadRank() {
  try {
    const res = await getRelayRank();
    const list = Array.isArray(res?.data) ? res.data : Array.isArray(res) ? res : [];
    rankList.value = list;
  } catch (e) {
    console.error("加载排行榜失败：", e);
    rankList.value = [];
  }
}

async function loadHistory() {
  if (!state.sessionId) {
    historyList.value = [];
    return;
  }
  try {
    const res = await getRelayHistory(state.sessionId);
    const list = Array.isArray(res?.data) ? res.data : Array.isArray(res) ? res : [];
    historyList.value = list;
  } catch (e) {
    console.error("加载历史失败：", e);
    historyList.value = [];
  }
}

async function openHistory() {
  await loadHistory();
  showHistory.value = true;
}

async function startGame() {
  loading.value = true;
  try {
    const res = await startRelayGame({});
    const data = res?.data && typeof res.data === "object" && !Array.isArray(res.data) ? res.data : res || {};
    applyGameData(data);
    lastSubmitCorrect.value = false;
    await Promise.all([loadRank(), loadHistory()]);
    startTimer();
    showToast("已开始新一局");
  } catch (e) {
    console.error("开始失败：", e);
    showToast(e?.message || "开始失败");
  } finally {
    loading.value = false;
  }
}

async function changeQuestion() {
  loading.value = true;
  try {
    const res = await startRelayGame({
      sessionId: state.sessionId || undefined,
      change: true
    });
    const data = res?.data && typeof res.data === "object" && !Array.isArray(res.data) ? res.data : res || {};
    applyGameData(data);
    lastSubmitCorrect.value = false;
    await Promise.all([loadRank(), loadHistory()]);
    startTimer();
    showToast("已切换到下一题");
  } catch (e) {
    console.error("换题失败：", e);
    showToast(e?.message || "换题失败");
  } finally {
    loading.value = false;
  }
}

async function submitAnswer() {
  if (!state.sessionId) {
    showToast("请先开始接龙");
    return;
  }
  if (!state.answer) {
    showToast("请输入下一句");
    return;
  }
  if (state.leftSeconds <= 0) {
    showToast("本题已超时，请换一题");
    return;
  }

  loading.value = true;
  try {
    const beforeSentence = state.poemSentence;
    const res = await submitRelayAnswer({
      sessionId: state.sessionId,
      questionId: state.questionId,
      answer: state.answer
    });
    const data = res?.data && typeof res.data === "object" && !Array.isArray(res.data) ? res.data : res || {};
    lastSubmitCorrect.value = !!data.correct;
    const result = applyGameData(data);

    if (data.correct && (!result.changed || result.nextSentence === beforeSentence)) {
      await changeQuestion();
      showToast(data.message || "回答正确，已自动切换下一题");
      return;
    }

    await Promise.all([loadRank(), loadHistory()]);
    startTimer();
    showToast(data.message || "提交成功");
  } catch (e) {
    console.error("提交失败：", e);
    showToast(e?.message || "提交失败");
  } finally {
    loading.value = false;
  }
}

function getHint() {
  if (!state.sessionId) {
    showToast("请先开始接龙");
    return;
  }
  if (state.hintUsed >= state.hintLimit) {
    showToast("今日提示次数已用完");
    return;
  }
  state.hintUsed += 1;
  showToast(`提示：首字应为“${state.expectedWord || "请先开始"}”`);
}

onMounted(async () => {
  await loadRank();
});

onBeforeUnmount(() => {
  stopTimer();
  if (toastTimer) {
    clearTimeout(toastTimer);
    toastTimer = null;
  }
});
</script>

<style scoped>
.relayPage {
  min-height: 100vh;
  width: 100%;
  overflow-x: hidden;
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
}

.pageShell {
  width: 100%;
  min-height: 100vh;
  background: transparent;
}

.backArrow {
  font-size: 22px;
  line-height: 1;
}

.backBtnOnly {
  position: fixed;
  top: 80px;
  left: 20px;
  z-index: 100;
  height: 48px;
  padding: 0 22px;
  border: none;
  border-radius: 999px;
  background: #9f2f25;
  color: #fff;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-size: 18px;
  font-weight: 900;
  cursor: pointer;
  backdrop-filter: blur(4px);
}

.mainStage {
  position: relative;
  margin: 0;
  border-radius: 0;
  overflow: visible;
  min-height: 100vh;
  background: transparent;
  border: none;
  box-shadow: none;
  padding: 0;
}

.stageBg {
  position: absolute;
  inset: 0;
  background: transparent;
}

.bgGlow {
  position: absolute;
  border-radius: 50%;
  filter: blur(12px);
}

.glow1 {
  left: 70px;
  top: 120px;
  width: 180px;
  height: 120px;
  background: radial-gradient(circle, rgba(255,255,255,.72), transparent 70%);
}

.glow2 {
  left: 120px;
  top: 260px;
  width: 140px;
  height: 90px;
  background: radial-gradient(circle, rgba(255,255,255,.4), transparent 72%);
}

.glow3 {
  right: 90px;
  top: 110px;
  width: 140px;
  height: 96px;
  background: radial-gradient(circle, rgba(255,221,235,.28), transparent 72%);
}

.bgDragon {
  position: absolute;
  left: 44px;
  top: 160px;
  width: 320px;
  height: 240px;
  opacity: .12;
  background: radial-gradient(circle at 48% 56%, transparent 0 34%, rgba(96,96,96,.46) 34.4% 35.6%, transparent 36%), radial-gradient(circle at 58% 26%, rgba(96,96,96,.42) 0 7%, transparent 8%), radial-gradient(circle at 37% 30%, rgba(96,96,96,.36) 0 5%, transparent 6%), radial-gradient(circle at 24% 54%, rgba(96,96,96,.3) 0 4%, transparent 5%), radial-gradient(circle at 70% 66%, rgba(96,96,96,.3) 0 4%, transparent 5%), linear-gradient(140deg, transparent 0 42%, rgba(96,96,96,.28) 43% 45%, transparent 46%);
}

.floorHalo {
  position: absolute;
  left: 50%;
  bottom: 32px;
  width: 560px;
  height: 110px;
  transform: translateX(-50%);
  border-radius: 50%;
  background: radial-gradient(ellipse at center, rgba(126, 225, 222, .24) 0%, rgba(126, 225, 222, .1) 35%, transparent 68%);
}

/* 顶部两栏布局 */
.topTwoColumns {
  display: flex;
  flex-direction: row;
  align-items: flex-end;
  justify-content: center;
  gap: 50px;
  padding: 0 0 20px 0;
  flex-wrap: wrap;
  position: relative;
  z-index: 2;
}

/* 左侧PNG图片区域 */
.leftDragonArea {
  flex: 1;
  min-width: 300px;
  max-width: 450px;
  display: flex;
  justify-content: center;
  position: relative;
  top: -50px;
  left: 245px;
}

.dragonScaleContainer {
  width: 100%;
}

/* 右侧正方形区域 */
.rightSquareArea {
  flex: 0 0 auto;
  width: 450px;
  display: flex;
  justify-content: center;
  align-items: flex-end;
  position: relative;
  top: 0;
  left: 265px;
}

.scaleCard {
  position: relative;
  padding: 20px;
  border-radius: 30px;
  background: transparent;
  border: none;
  width: 100%;
  text-align: center;
}

.customImageArea {
  position: relative;
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

/* SVG 叠加层 */
.scaleSvgOverlay {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 10;
}

/* 鳞片路径样式 */
.scalePath {
  opacity: 0;
  transition: opacity 0.3s ease, filter 0.3s ease;
}

.scalePath.active {
  opacity: 1;
  animation: scaleGlowPulse 0.5s ease-out;
}

/* 圆形光点样式 */
.scaleDot {
  opacity: 0;
  transition: all 0.3s ease;
  transform-origin: center;
}

.scaleDot.active {
  opacity: 1;
  animation: dotPulse 0.5s ease-out;
}

@keyframes scaleGlowPulse {
  0% { 
    opacity: 0; 
    filter: brightness(0.5);
  }
  50% { 
    opacity: 1; 
    filter: brightness(1.5) drop-shadow(0 0 5px gold);
  }
  100% { 
    opacity: 1; 
    filter: brightness(1) drop-shadow(0 0 2px rgba(255,215,0,0.5));
  }
}

@keyframes dotPulse {
  0% { 
    opacity: 0; 
    transform: scale(0.3);
    filter: brightness(0.5) drop-shadow(0 0 0px gold);
  }
  50% { 
    opacity: 1; 
    transform: scale(1.4);
    filter: brightness(1.5) drop-shadow(0 0 12px gold);
  }
  100% { 
    opacity: 1; 
    transform: scale(1);
    filter: brightness(1) drop-shadow(0 0 4px rgba(255,215,0,0.6));
  }
}

.dragonScaleImg {
  max-width: 100%;
  height: auto;
  border-radius: 20px;
  object-fit: contain;
  transform: scale(1.2);
  transform-origin: center center;
}

.imagePlaceholder {
  width: 200px;
  height: 200px;
  border-radius: 50%;
  background: rgba(255,255,255,0.3);
  backdrop-filter: blur(10px);
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px dashed rgba(255,255,255,0.6);
  color: rgba(255,255,255,0.8);
  font-size: 14px;
  text-align: center;
  padding: 20px;
}

.scaleProgressCenter {
  text-align: center;
  margin-top: 10px;
  top: -35px;
  position: relative;
}

.scaleProgressNum {
  font-size: 72px;
  line-height: 1;
  font-weight: 500;
  color: #d8ab49;
  font-family: Georgia, "Times New Roman", serif;
  text-shadow: 0 2px 0 rgba(255,255,255,.9);
}

.scaleProgressLabel {
  margin-top: 4px;
  font-size: 28px;
  font-weight: 900;
  color: #d8ab49;
  text-shadow: 0 1px 2px rgba(0,0,0,0.2);
}

/* 游戏操作容器 */
.squareGameContainer {
  width: 100%;
  height: 520px;
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(20px) saturate(180%);
  -webkit-backdrop-filter: blur(20px) saturate(180%);
  border-radius: 32px;
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 20px 48px rgba(0, 0, 0, 0.15);
  padding: 16px 20px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  gap: 12px;
  overflow-y: visible;
  flex-shrink: 0;
  flex-grow: 0;
  top: -130px;
  position: relative;
}

/* 卡片顶部标签 */
.cardTop {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
  flex-shrink: 0;
}

.badgeGroup {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.fromTag,
.timerTag,
.statusBadge {
  height: 32px;
  padding: 0 12px;
  font-size: 13px;
  border-radius: 999px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-weight: 900;
}

.fromTag {
  background: #f9f4e3 ;
  border: 2px solid #ffe9a7;
  color: #f6cd56;
}

.timerTag {
  background: #f6e8e7;
  border: 2px solid #9f2f25;
  color: #b05651;
}

.statusBadge {
  background: linear-gradient(180deg, #ffe9a7, #f6cd56);
  color: #8d6819;
  box-shadow: 0 8px 18px rgba(246, 205, 86, .18);
}

/* 诗句区域 */
.questionMain {
  padding: 8px 12px;
  flex: 1;
}

.questionSentence {
  margin-top: 8px;
  font-size: 20px;
  line-height: 1.3;
  font-weight: 900;
  color: #171717;
  letter-spacing: 1px;
  word-break: break-word;
}

.questionMeta {
  margin-top: 4px;
  text-align: right;
  color: #7d7d7d;
  font-size: 12px;
  font-weight: 700;
}

/* 作答区域 */
.answerCard {
  padding: 10px 12px;
  border-radius: 24px;
  background: linear-gradient(180deg, rgba(255, 249, 251, .82), rgba(255,255,255,.66));
  border: 1px solid #f6cd56;
  flex-shrink: 0;
}

.inputWrap {
  display: flex;
  align-items: center;
  min-height: 40px;
  padding: 0 12px;
  gap: 8px;
  border-radius: 18px;
  border: 2px solid #f7c42b;
  background: rgba(255,255,255,.94);
  box-shadow: inset 0 2px 8px rgba(0,0,0,.03);
}

.pen {
  width: 32px;
  height: 32px;
  border-radius: 10px;
  display: grid;
  place-items: center;
  font-size: 14px;
  font-weight: 900;
  color: #fdc41c;
  background: #f8f1dd;
}

.answerInput {
  flex: 1;
  border: none;
  outline: none;
  background: transparent;
  color: #333;
  font-size: 14px;
}

.tipLine {
  margin-top: 8px;
  display: flex;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
  color: #727272;
  font-size: 11px;
  font-weight: 700;
}

.tipWord::before {
  content: "● ";
  color: #9f2f25;
}

.tipSub {
  color: #9f2f25;
}

.helperRow {
  margin-top: 10px;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.helperChip {
  min-height: 30px;
  padding: 0 12px;
  border-radius: 999px;
  display: inline-flex;
  align-items: center;
  background: #fbf7ec;
  border: 1px solid #f6cd56;
  color: #fac527;
  font-size: 12px;
  font-weight: 800;
}

/* 按钮区域 */
.confirmBtn {
  width: 100%;
  height: 48px;
  border: none;
  border-radius: 999px;
  background: #fbd669;
  color: #fff;
  font-size: 17px;
  font-weight: 900;
  box-shadow: 0 8px 16px #f8dc86;
  cursor: pointer;
  transition: transform 0.2s ease;
  flex-shrink: 0;
}

.confirmBtn:hover {
  transform: scale(1.02);
}

.confirmBtn:disabled {
  opacity: .6;
  cursor: not-allowed;
}

.bottomCenterBtns {
  display: flex;
  justify-content: center;
  flex-shrink: 0;
}

.startBtn {
  width: 100%;
  height: 48px;
  border: none;
  border-radius: 999px;
  background: #c13b2f;
  color: #f9cb6a;
  font-size: 18px;
  font-weight: 900;
  cursor: pointer;
  box-shadow: 0 8px 16px #fff;
  transition: transform 0.2s ease;
}

.startBtn:hover {
  transform: scale(1.02);
}

/* 本局状态容器 */
.stateContainer {
  width: 100%;
  margin: 0.2px 0 0 0;
  position: relative;
  z-index: 2;
  box-sizing: border-box;
  flex: 0 0 auto;
}

.leftInfoCard {
  padding: 0.1px 0.2px;
  border-radius: 20px;
  background: rgba(255, 255, 255, 0.85);
  border: 1px solid rgba(255,255,255,.62);
  backdrop-filter: blur(10px);
  box-shadow: 0 10px 24px rgba(156, 193, 191, .14);
  width: 100%;
  box-sizing: border-box;
}

.leftInfoTitle {
  font-size: 12px;
  font-weight: 900;
  color: #ffd85b;
  margin-bottom: 8px;
  text-align: center;
}

.leftInfoGrid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
}

.infoMini {
  border-radius: 14px;
  padding: 0.1px 0.2px;
  background: rgba(255,255,255,.72);
  border: 1px solid rgba(239, 234, 217, .96);
  text-align: center;
}

.infoMini span {
  display: block;
  font-size: 11px;
  color: #7a7a7a;
  font-weight: 700;
}

.infoMini b {
  display: block;
  margin-top: 1px;
  color: #ffd85b;
  font-size: 18px;
  font-weight: 900;
}

.bottomActionArea {
  max-width: 100%;
  width: 100%;
  margin: -140px 0 0 0;
  padding: 20px 0;
  position: relative;
  z-index: 2;
}

/* 三个按钮 */
.actionPanel {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  width: 70%;
  margin: 0 auto 24px auto;
  justify-content: center;
}

.actionBtn {
  height: 52px;
  border: none;
  border-radius: 18px;
  font-size: 18px;
  font-weight: 900;
  cursor: pointer;
  box-shadow: 0 10px 20px rgba(0,0,0,.07);
  transition: transform 0.2s ease;
  background: #fff;
  color: #d8ab49;
}

.actionBtn:hover {
  transform: translateY(-2px);
  background: #b83a2e;
  color: #e8c06a;
}

.actionBtn.gold {
  background: linear-gradient(180deg, #ffe7a0, #f4c944);
  color: #8e661d;
}

/* 龙鳞进度条 */
.progressPanel {
  padding: 20px;
  border-radius: 28px;
  background: rgba(255,255,255,.75);
  border: 1px solid rgba(225, 243, 242, .96);
  backdrop-filter: blur(10px);
  width: 100%;
  box-sizing: border-box;
}

.progressHead {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
  font-size: 17px;
  font-weight: 900;
  color: #8e661d;
  flex-wrap: wrap;
}

.progressBar {
  margin-top: 14px;
  height: 22px;
  border-radius: 999px;
  background: rgba(255, 226, 137, .6);
  overflow: hidden;
  box-shadow: inset 0 2px 6px rgba(0,0,0,.06);
}

.progressInner {
  height: 100%;
  border-radius: 999px;
  background: linear-gradient(90deg, #9f2f25, #ffd85b);
  transition: width 0.3s ease;
}

/* 排行榜区域 */
.rankSection {
  max-width: 100%;
  width: 100%; 
  margin: 20px 0 40px 0;
  padding: 20px;
  background: linear-gradient(180deg, rgba(255,255,255,.76), rgba(255,255,255,.6));
  border: 1px solid rgba(230, 201, 96, .6);
  box-shadow: 0 10px 28px rgba(219, 191, 96, .08);
  position: relative;
  z-index: 2;
  box-sizing: border-box;
}

.rankTitle {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 110px;
  height: 40px;
  border-radius: 18px 18px 0 0;
  background: rgba(255,250,240,.95);
  border: 1px solid rgba(230, 201, 96, .72);
  border-bottom: none;
  color: #333;
  font-size: 18px;
  font-weight: 900;
  margin-top: -38px;
}

.rankList {
  margin-top: 10px;
  border-radius: 18px;
  overflow: hidden;
  border: 1px solid rgba(242, 236, 212, .96);
}

.rankRow {
  display: grid;
  grid-template-columns: 60px 1fr 80px;
  align-items: center;
  min-height: 44px;
  padding: 0 12px;
  background: rgba(255,255,255,.8);
  border-bottom: 1px solid rgba(243, 239, 223, .96);
  font-size: 14px;
  font-weight: 700;
}

.rankHead {
  background: rgba(251, 246, 232, .96);
  font-weight: 900;
}

.rankBody {
  max-height: 200px;
  overflow-y: auto;
}

.rankEmpty {
  padding: 18px;
  text-align: center;
  color: #8a8a8a;
  font-size: 14px;
  font-weight: 700;
}

.toast {
  position: fixed;
  left: 50%;
  bottom: 40px;
  transform: translateX(-50%);
  min-width: 220px;
  max-width: 70vw;
  padding: 12px 22px;
  border-radius: 999px;
  background: rgba(30,30,30,.78);
  color: #fff;
  font-size: 15px;
  z-index: 99;
}

.mask {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,.25);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
}

.historyDialog {
  width: 560px;
  max-width: calc(100vw - 40px);
  background: #fff;
  border-radius: 22px;
  padding: 24px;
}

.dialogTitle {
  font-size: 24px;
  font-weight: 800;
  margin-bottom: 16px;
}

.historyList {
  max-height: 420px;
  overflow: auto;
  border: 1px solid #eee;
  border-radius: 12px;
}

.historyItem {
  padding: 14px 16px;
  border-bottom: 1px solid #f2f2f2;
  font-size: 16px;
  color: #444;
}

.emptyText {
  padding: 24px;
  text-align: center;
  color: #888;
}

.dialogClose {
  margin-top: 18px;
  width: 100%;
  height: 46px;
  border: none;
  border-radius: 12px;
  background: #43c6c6;
  color: #fff;
  font-size: 18px;
  font-weight: 700;
  cursor: pointer;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity .25s ease, transform .25s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translate(-50%, 12px);
}

/* 响应式布局 */
@media (max-width: 900px) {
  .topTwoColumns {
    flex-direction: column;
    align-items: center;
    padding: 20px 20px 20px;
  }
  
  .leftDragonArea {
    max-width: 350px;
    left: 0;
  }
  
  .rightSquareArea {
    flex: 1;
    min-width: auto;
    max-width: none;
    display: flex;
    justify-content: center;
    align-items: center;
    left: 0;
    transform: scale(0.6);
    transform-origin: center center;
  }
  
  .squareGameContainer {
    min-height: auto;
  }
  
  .bottomActionArea {
    padding: 20px;
  }
  
  .actionBtn {
    font-size: 16px;
    height: 46px;
  }
  
  .progressHead {
    font-size: 15px;
  }
  
  .progressBar {
    height: 18px;
  }
  
  .stateContainer {
    padding: 0 20px;
    box-sizing: border-box;
  }
}

@media (max-width: 768px) {
  .backBtnOnly {
    top: 12px;
    left: 12px;
    height: 40px;
    padding: 0 16px;
    font-size: 15px;
  }
  
  .backArrow {
    font-size: 18px;
  }
  
  .topTwoColumns {
    padding: 20px 12px 12px;
  }
  
  .questionSentence {
    font-size: 20px;
  }
  
  .actionPanel {
    gap: 10px;
  }
  
  .actionBtn {
    font-size: 13px;
    height: 42px;
  }
  
  .squareGameContainer {
    padding: 16px;
  }
  
  .fromTag,
  .timerTag,
  .statusBadge {
    height: 32px;
    padding: 0 12px;
    font-size: 12px;
  }
  
  .confirmBtn,
  .startBtn {
    height: 46px;
    font-size: 16px;
  }
  
  .scaleProgressNum {
    font-size: 52px;
  }
  
  .scaleProgressLabel {
    font-size: 22px;
  }
  
  .stateContainer {
    padding: 0 12px;
  }
}
</style>