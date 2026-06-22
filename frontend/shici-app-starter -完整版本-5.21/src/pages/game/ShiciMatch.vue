<template>
  <div class="matchPage">

    <div class="mainLayout">
      <div class="leftStage">
        <div
          ref="boardRef"
          class="boardWrap"
          :class="{ dragging: isDragging }"
          @pointerdown="onBoardPointerDown"
          @wheel.prevent="onBoardWheel"
        >
<div class="boardHeader">
  <div class="boardHeaderMain">
    <div class="boardInfo">
      <div class="boardTitle">诗词趣消消</div>
      <div class="boardSub">✨ 拖动画面旋转 ｜ 点击卡片收集碎片</div>
    </div>

    <div class="boardHeaderRight">
      <div class="boardActions">
        <button class="headerBtn" @click="goBack">返回</button>
        <button class="headerBtn ghost" @click="restartGame">重开</button>
      </div>

      <div class="boardStats">
        <div class="statPill">
          <span class="statLabel">🎯 当前旋转</span>
          <span class="statValue">{{ Math.round(normalizedBoardRotation) }}°</span>
        </div>
        <div class="statPill">
          <span class="statLabel">📦 剩余卡片</span>
          <span class="statValue">{{ remainingCount }}</span>
        </div>
      </div>
    </div>
  </div>
</div>

          <div class="board">
            <div class="boardAura"></div>
            <div class="boardGlow"></div>
            <div class="boardTexture"></div>

            <div class="ring ringOuter"></div>
            <div class="ring ringOuter2"></div>
            <div class="ring ringMid"></div>
            <div class="ring ringInner"></div>

            <div class="centerSeal">
              <div class="sealInner">
                <div class="sealText">诗盘</div>
                <div class="sealTip">🔍 拖动旋转</div>
              </div>
            </div>

            <div
              v-for="card in visibleCards"
              :key="card.id"
              class="poemCard"
              :class="{
                covered: card.covered,
                removed: card.removed,
                clickable: !card.covered && gameStatus === 'playing'
              }"
              :style="getCardStyle(card)"
              @click.stop="handleCardClick(card)"
            >
              <div class="cardFace">
                <span class="cardText">{{ card.text }}</span>
              </div>
            </div>

            <div class="rotateHint">🖱️ 鼠标拖动 / 滚轮旋转</div>
          </div>
        </div>

        <div class="bottomPanels">
          <div class="slotPanel">
            <div class="panelHead">
              <div class="panelTitle">📦 收集槽</div>
              <div class="slotTip">⚠️ 满 {{ slotLimit }} 格则失败</div>
            </div>

            <div
              class="slotBar"
              :style="{ gridTemplateColumns: `repeat(${slotLimit}, 1fr)` }"
            >
              <div v-for="i in slotLimit" :key="i" class="slotCell">
                <div v-if="slotCards[i - 1]" class="slotCard">
                  {{ slotCards[i - 1].text }}
                </div>
              </div>
            </div>
          </div>

          <div class="rulePanel">
            <div class="panelHead">
              <div class="panelTitle">📜 玩法说明</div>
            </div>
            <div class="ruleLine">🎭 同一首诗的 <strong>3 个片段</strong> 进入槽位后自动消除，每成功配对 1 首加 1 分。</div>
            <div class="ruleLine">🏆 全部完成额外奖励 <strong>+5 分</strong>；槽位满或时间结束则挑战失败。</div>
            <div class="ruleLine">🔍 优先点击未被遮挡的最外层卡片，边旋转边找同组碎片更容易通关。</div>
          </div>
        </div>
      </div>

      <aside class="rightPanel">
        <div class="sideCard scoreCard">
          <div class="gameMiniHead">
            <div class="miniTitle">诗词趣消消</div>
            <div class="miniLevel">{{ level.title || "第一关·诗林寻踪" }}</div>
          </div>

          <div class="progressMeta">
            <div class="progressItem">
              <div class="scoreLabel">⏳ 倒计时</div>
              <div class="scoreValue timerValue">{{ formatTime(remainSeconds) }}</div>
            </div>
            <div class="progressItem">
              <div class="scoreLabel">🎖️ 得分</div>
              <div class="scoreValue">{{ displayScore }}</div>
            </div>
            <div class="progressItem">
              <div class="scoreLabel">📖 进度</div>
              <div class="scoreValue">{{ matchedCount }}/{{ level.poemCount || 20 }}</div>
            </div>
            <div class="progressItem">
              <div class="scoreLabel">🃏 剩余卡片</div>
              <div class="scoreValue">{{ remainingCount }}</div>
            </div>
          </div>
        </div>

        <div class="sideCard rankCard">
          <div class="sideHead">
            <div class="sideTitle">🏅 排行榜</div>
            <div class="rankBadge">✨ 实时数据</div>
          </div>

          <div class="rankList">
            <div
              v-for="item in rankList"
              :key="item.rank"
              class="rankRow"
              :class="{ me: item.me }"
            >
              <div class="rankNo">{{ item.rank }}</div>
              <div class="rankUser">
                <div class="rankName">{{ item.name }}</div>
                <div class="rankMeta">{{ item.desc }}</div>
              </div>
              <div class="rankScore">{{ item.score }}</div>
            </div>

            <div v-if="!rankList.length" class="rankEmpty">
              🌟 暂无排行榜数据
            </div>
          </div>
        </div>
      </aside>
    </div>

    <!-- 胜利弹窗 -->
    <div v-if="gameStatus === 'win'" class="mask">
      <div class="dialog winDialog">
        <div class="dialogIcon">🏆</div>
        <h3>🎉 通关成功</h3>
        <p>配对得分：{{ score }}</p>
        <p>通关奖励：+{{ winBonus }}</p>
        <p class="finalScore">最终得分：{{ finalScore }}</p>
        <p>⏱️ 用时：{{ formatTime(usedSeconds) }}</p>
        <div class="dialogBtns">
          <button class="primaryBtn" @click="restartGame">再来一局</button>
          <button @click="goBack">返回</button>
        </div>
      </div>
    </div>

    <!-- 失败弹窗 -->
    <div v-if="gameStatus === 'fail'" class="mask">
      <div class="dialog failDialog">
        <div class="dialogIcon">😭</div>
        <h3>挑战失败</h3>
        <p>当前得分：{{ score }}</p>
        <p>已配对：{{ matchedCount }} 首</p>
        <p>原因：{{ failReason }}</p>
        <div class="dialogBtns">
          <button class="primaryBtn" @click="restartGame">重新开始</button>
          <button @click="goBack">返回</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, reactive, ref } from "vue";
import { useRouter } from "vue-router";
import bgImage from '@/assets/game/shicimatch.jpg';
import {
  getPoemMatchLevel,
  startPoemMatchGame,
  addPoemMatchScore,
  submitPoemMatchResult,
  getPoemMatchRank
} from "@/utils/api";

const backgroundImage = bgImage;
const router = useRouter();
const boardRef = ref(null);

const SHICI_MATCH_RETURN_KEY = "shici_match_return_state";

function parseReturnState() {
  try {
    const raw = sessionStorage.getItem(SHICI_MATCH_RETURN_KEY);
    if (!raw) return null;
    return JSON.parse(raw);
  } catch (error) {
    console.error("读取趣消消返回状态失败", error);
    return null;
  }
}

function clearReturnState() {
  sessionStorage.removeItem(SHICI_MATCH_RETURN_KEY);
}

function goBack() {
  const saved = parseReturnState();

  if (saved?.path) {
    clearReturnState();
    router.push({
      path: saved.path,
      query: {
        restoreGame: "1",
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

const level = reactive({
  levelId: 1,
  title: "",
  description: "",
  timeLimitSec: 480,
  slotLimit: 6,
  poemCount: 20
});

const cards = ref([]);
const slotCards = ref([]);
const rankData = ref([]);
const recordId = ref(null);

const remainSeconds = ref(480);
const score = ref(0);
const matchedCount = ref(0);
const finalScore = ref(0);
const usedSeconds = ref(0);
const gameStatus = ref("playing");
const failReason = ref("");
const winBonus = ref(0);
const winSubmitted = ref(false);

let timer = null;

const boardRotation = ref(0);
const isDragging = ref(false);
const dragMoved = ref(false);
const dragStartAngle = ref(0);
const dragStartRotation = ref(0);

const slotLimit = computed(() => level.slotLimit || 6);
const visibleCards = computed(() => cards.value.filter(item => !item.removed));
const remainingCount = computed(() => cards.value.filter(item => !item.removed).length);

const displayScore = computed(() => {
  if (gameStatus.value === "win") return finalScore.value;
  return score.value;
});

const normalizedBoardRotation = computed(() => {
  let v = boardRotation.value % 360;
  if (v < 0) v += 360;
  return v;
});

function getCurrentUser() {
  try {
    return JSON.parse(localStorage.getItem("user") || "{}");
  } catch (e) {
    return {};
  }
}

function getCurrentUserId() {
  const user = getCurrentUser();
  return user?.id || user?.userId || user?.uid || user?.user_id || null;
}

const rankList = computed(() => {
  const myId = getCurrentUserId();
  return (rankData.value || []).map((item, index) => ({
    rank: index + 1,
    name: item.nickname || item.username || `诗友${index + 1}`,
    desc: `配对 ${item.correctCount || 0} 首 · 通关 ${item.passCount || 0} 次`,
    score: item.poemMatchScore || 0,
    me: !!myId && Number(item.userId) === Number(myId)
  }));
});

function shuffle(arr) {
  const list = [...arr];
  for (let i = list.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [list[i], list[j]] = [list[j], list[i]];
  }
  return list;
}

function degToRad(deg) {
  return (deg * Math.PI) / 180;
}

function getAngleFromPointer(event) {
  const el = boardRef.value;
  if (!el) return 0;
  const rect = el.getBoundingClientRect();
  const cx = rect.left + rect.width / 2;
  const cy = rect.top + rect.height / 2;
  return (Math.atan2(event.clientY - cy, event.clientX - cx) * 180) / Math.PI;
}

function generateLayout(list) {
  const layerConfig = [
    { layer: 1, count: 22, radius: 330, start: -90, step: 15 },
    { layer: 2, count: 18, radius: 245, start: -80, step: 20 },
    { layer: 3, count: 12, radius: 162, start: -60, step: 30 },
    { layer: 4, count: 8, radius: 88, start: -45, step: 45 }
  ];

  let startIndex = 0;
  const result = [];

  layerConfig.forEach(cfg => {
    for (let i = 0; i < cfg.count && startIndex < list.length; i++, startIndex++) {
      const jitter = (Math.random() - 0.5) * 8;
      const angle = cfg.start + i * cfg.step + jitter;
      result.push({
        ...list[startIndex],
        layer: cfg.layer,
        baseAngle: angle,
        radius: cfg.radius + (Math.random() - 0.5) * 8,
        removed: false,
        covered: false
      });
    }
  });

  while (startIndex < list.length) {
    result.push({
      ...list[startIndex],
      layer: 4,
      baseAngle: -90 + (startIndex % 8) * 45,
      radius: 88,
      removed: false,
      covered: false
    });
    startIndex++;
  }

  return result;
}

function updateCovered() {
  const activeCards = cards.value.filter(c => !c.removed);

  activeCards.forEach(card => {
    card.covered = activeCards.some(other => {
      if (other.id === card.id) return false;
      if (other.layer <= card.layer) return false;

      const angleA = card.baseAngle + boardRotation.value;
      const angleB = other.baseAngle + boardRotation.value;

      const ax = Math.cos(degToRad(angleA)) * card.radius;
      const ay = Math.sin(degToRad(angleA)) * card.radius;
      const bx = Math.cos(degToRad(angleB)) * other.radius;
      const by = Math.sin(degToRad(angleB)) * other.radius;

      return Math.abs(ax - bx) < 76 && Math.abs(ay - by) < 48;
    });
  });
}

function getCardStyle(card) {
  const angle = card.baseAngle + boardRotation.value;
  const rad = degToRad(angle);
  const x = Math.cos(rad) * card.radius;
  const y = Math.sin(rad) * card.radius;
  const tilt = Math.sin(rad) * 4;
  const zIndex = 1000 + card.layer * 100 + Math.round(220 - y);

  return {
    left: "50%",
    top: "50%",
    zIndex,
    transform: `
      translate(calc(-50% + ${x}px), calc(-50% + ${y}px))
      rotate(${tilt}deg)
      scale(${card.covered ? 0.98 : 1})
    `
  };
}

function onBoardPointerDown(event) {
  if (gameStatus.value !== "playing") return;
  isDragging.value = true;
  dragMoved.value = false;
  dragStartAngle.value = getAngleFromPointer(event);
  dragStartRotation.value = boardRotation.value;

  window.addEventListener("pointermove", onBoardPointerMove);
  window.addEventListener("pointerup", onBoardPointerUp);
}

function onBoardPointerMove(event) {
  if (!isDragging.value) return;
  const currentAngle = getAngleFromPointer(event);
  const delta = currentAngle - dragStartAngle.value;
  if (Math.abs(delta) > 1) dragMoved.value = true;
  boardRotation.value = dragStartRotation.value + delta;
  updateCovered();
}

function onBoardPointerUp() {
  isDragging.value = false;
  setTimeout(() => {
    dragMoved.value = false;
  }, 0);

  window.removeEventListener("pointermove", onBoardPointerMove);
  window.removeEventListener("pointerup", onBoardPointerUp);
}

function onBoardWheel(event) {
  if (gameStatus.value !== "playing") return;
  boardRotation.value += event.deltaY * 0.12;
  updateCovered();
}

async function handleCardClick(card) {
  if (dragMoved.value) return;
  if (gameStatus.value !== "playing") return;
  if (card.covered) return;
  if (slotCards.value.length >= slotLimit.value) return;

  card.removed = true;
  slotCards.value.push({
    id: card.id,
    groupId: card.groupId,
    text: card.text
  });

  await checkMatch();
  updateCovered();
  await checkGameStatus();
}

async function checkMatch() {
  const groupMap = {};

  slotCards.value.forEach(item => {
    if (!groupMap[item.groupId]) groupMap[item.groupId] = [];
    groupMap[item.groupId].push(item);
  });

  for (const groupId of Object.keys(groupMap)) {
    if (groupMap[groupId].length === 3) {
      const ids = new Set(groupMap[groupId].map(item => item.id));
      slotCards.value = slotCards.value.filter(item => !ids.has(item.id));

      matchedCount.value += 1;
      score.value += 1;

      try {
        const currentUserId = getCurrentUserId();
        if (!currentUserId || !recordId.value) return;

        await addPoemMatchScore({
          recordId: recordId.value,
          userId: currentUserId,
          levelId: level.levelId,
          usedSeconds: Math.max(0, level.timeLimitSec - remainSeconds.value)
        });

        await loadRank();
      } catch (e) {
        console.error("增量记分失败", e);
      }
    }
  }
}

async function checkGameStatus() {
  const allRemoved = cards.value.every(item => item.removed);

  if (allRemoved) {
    await handleWin();
    return;
  }

  if (slotCards.value.length >= slotLimit.value) {
    failReason.value = "槽位已满";
    await handleFail();
  }
}

async function handleWin() {
  if (winSubmitted.value) return;

  winSubmitted.value = true;
  gameStatus.value = "win";
  clearTimer();
  usedSeconds.value = level.timeLimitSec - remainSeconds.value;

  try {
    const res = await submitPoemMatchResult({
      recordId: recordId.value,
      userId: getCurrentUserId(),
      levelId: level.levelId,
      passed: true,
      usedSeconds: usedSeconds.value
    });

    const root = res?.data || res || {};
    const data = root?.data || root || {};
    winBonus.value = data.bonus || 5;
    finalScore.value = score.value + winBonus.value;

    await loadRank();
  } catch (e) {
    console.error("通关结算失败", e);
    winBonus.value = 5;
    finalScore.value = score.value + 5;
  }
}

async function handleFail() {
  gameStatus.value = "fail";
  clearTimer();
  usedSeconds.value = level.timeLimitSec - remainSeconds.value;

  try {
    await submitPoemMatchResult({
      recordId: recordId.value,
      userId: getCurrentUserId(),
      levelId: level.levelId,
      passed: false,
      usedSeconds: usedSeconds.value
    });
    await loadRank();
  } catch (e) {
    console.error("失败结算失败", e);
  }
}

function startTimer() {
  clearTimer();
  timer = setInterval(async () => {
    if (gameStatus.value !== "playing") return;

    if (remainSeconds.value > 0) {
      remainSeconds.value -= 1;
    } else {
      failReason.value = "时间到";
      await handleFail();
    }
  }, 1000);
}

function clearTimer() {
  if (timer) {
    clearInterval(timer);
    timer = null;
  }
}

function formatTime(sec) {
  const safe = Math.max(0, Number(sec || 0));
  const m = String(Math.floor(safe / 60)).padStart(2, "0");
  const s = String(safe % 60).padStart(2, "0");
  return `${m}:${s}`;
}

async function startRecord() {
  const userId = getCurrentUserId();
  if (!userId) {
    recordId.value = null;
    return;
  }

  try {
    const res = await startPoemMatchGame({
      userId,
      levelId: level.levelId
    });

    const root = res?.data || res || {};
    const data = root?.data || root || {};
    recordId.value = data.recordId || null;
  } catch (e) {
    console.error("开局创建记录失败", e);
    recordId.value = null;
  }
}

async function loadLevel() {
  const res = await getPoemMatchLevel(1);
  const root = res?.data || res || {};
  const data = root?.data || root || {};

  level.levelId = data.levelId || 1;
  level.title = data.title || "诗词趣消消第一关";
  level.description = data.description || "";
  level.timeLimitSec = data.timeLimitSec || 480;
  level.slotLimit = data.slotLimit || 6;
  level.poemCount = data.poemCount || 20;

  const fragmentCards = (data.fragments || []).map(item => ({
    id: item.fragmentId,
    groupId: item.groupId,
    text: item.fragmentText,
    poemTitle: item.poemTitle,
    author: item.author,
    dynasty: item.dynasty,
    poemText: item.poemText
  }));

  cards.value = generateLayout(shuffle(fragmentCards));
  boardRotation.value = 0;
  updateCovered();

  remainSeconds.value = level.timeLimitSec;
  slotCards.value = [];
  score.value = 0;
  matchedCount.value = 0;
  finalScore.value = 0;
  usedSeconds.value = 0;
  failReason.value = "";
  gameStatus.value = "playing";
  winBonus.value = 0;
  winSubmitted.value = false;
  recordId.value = null;

  startTimer();
  await startRecord();
}

async function loadRank() {
  try {
    const res = await getPoemMatchRank();
    const root = res?.data || res || {};
    rankData.value = root?.data || root || [];
  } catch (e) {
    console.error("加载排行榜失败", e);
    rankData.value = [];
  }
}

async function restartGame() {
  await loadLevel();
  await loadRank();
}


onMounted(async () => {
  await loadLevel();
  await loadRank();
});

onBeforeUnmount(() => {
  clearTimer();
  window.removeEventListener("pointermove", onBoardPointerMove);
  window.removeEventListener("pointerup", onBoardPointerUp);
});
</script>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.matchPage {
  min-height: 100vh;
  padding: 0;
  margin: 0;
  background: url('@/assets/game/shicimatch.jpg') no-repeat center center fixed;
  background-size: cover;
  position: relative;
}

.floatActions {
  position: fixed;
  top: 16px;
  left: 16px;
  right: 16px;
  z-index: 20;
  pointer-events: none;
}

.floatBtn {
  position: absolute;
  pointer-events: auto;
  border: none;
  cursor: pointer;
  padding: 10px 24px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(8px);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  font-size: 14px;
  font-weight: 800;
  color: #9f2f25;
  transition: all 0.2s ease;
  border: 1px solid rgba(60, 100, 80, 0.2);
}

.backBtn {
  left: 0;
}

.restartBtn {
  right: 0;
}

.floatBtn:hover {
  transform: translateY(-2px);
  background: white;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
  color: #9f2f25;
}

.mainLayout {
  display: flex;
  gap: 0;
  align-items: stretch;
  margin: 0;
  padding: 0;
  position: relative;
  z-index: 2;
}

.leftStage {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
}

.boardWrap {
  width: 100%;
  margin: 0;
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(4px);
  border: 1px solid rgba(80, 120, 100, 0.2);
  box-shadow: 0 20px 35px rgba(0, 0, 0, 0.08);
  user-select: none;
  overflow: hidden;
  transition: box-shadow 0.3s;
}

.boardWrap.dragging {
  cursor: grabbing;
  box-shadow: 0 25px 45px rgba(0, 0, 0, 0.12);
}

.boardHeader {
  padding: 14px 18px 6px;
  background: linear-gradient(135deg, rgba(255,255,255,0.4), rgba(230,245,240,0.3));
}

.boardHeaderMain {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
}

.boardInfo {
  min-width: 0;
}

.boardTitle {
  font-size: 24px;
  font-weight: 900;
  color: #9f2f25;
  text-shadow: 0 1px 0 rgba(255,255,255,0.6);
  letter-spacing: 2px;
}

.boardSub {
  margin-top: 4px;
  color: #9f2f25;
  font-size: 12px;
  font-weight: 500;
}

.boardStats {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  justify-content: flex-end;
}

.statPill {
  min-width: 100px;
  padding: 8px 12px;
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(4px);
  border: 1px solid rgba(80, 120, 100, 0.2);
  text-align: center;
}

.statLabel {
  display: block;
  font-size: 11px;
  color: #9f2f25;
  letter-spacing: 1px;
}

.statValue {
  display: block;
  margin-top: 4px;
  font-size: 16px;
  font-weight: 800;
  color: #9f2f25;
}

.board {
  position: relative;
  width: 100%;
  height: 760px;
  overflow: hidden;
  cursor: grab;
   background: transparent;
}

.boardAura {
  position: absolute;
  inset: 0;
  background: radial-gradient(circle at center, rgba(255,245,210,0.3) 0%, rgba(200,220,210,0.1) 70%);
  pointer-events: none;
}

.boardGlow {
  position: absolute;
  inset: 50%;
  width: 780px;
  height: 780px;
  transform: translate(-50%, -50%);
  background: radial-gradient(circle, rgba(255,230,170,0.15) 0%, rgba(210,190,130,0.05) 50%, transparent 80%);
  filter: blur(15px);
  pointer-events: none;
}

.boardTexture {
  position: absolute;
  inset: 0;
  pointer-events: none;
  opacity: 0.08;
  background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="%236b8e7e" stroke-width="0.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/></svg>');
  background-repeat: repeat;
  background-size: 28px;
  mask-image: radial-gradient(circle at center, black 30%, transparent 88%);
}

.ring {
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
}

.ringOuter {
  width: 710px;
  height: 710px;
  border: 2px dashed #ffe7a0;
}

.ringOuter2 {
  width: 610px;
  height: 610px;
  border: 1px solid #ffe7a0;
}

.ringMid {
  width: 470px;
  height: 470px;
  border: 2px dotted #ffe7a0;
}

.ringInner {
  width: 310px;
  height: 310px;
  border: 1px solid #ffe7a0;
}

.centerSeal {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 164px;
  height: 164px;
  transform: translate(-50%, -50%);
  padding: 8px;
  background: rgba(255, 255, 255, 0.9);
  border: 2px solid #c4a86a;
}

.sealInner {
  width: 100%;
  height: 100%;
  background: linear-gradient(145deg, #fffef5, #f5f0e0);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.sealText {
  font-size: 34px;
  font-weight: 900;
  color: #8b6946;
  letter-spacing: 4px;
}

.sealTip {
  margin-top: 8px;
  font-size: 12px;
  color: #a0845c;
}

.rotateHint {
  position: absolute;
  right: 18px;
  bottom: 18px;
  padding: 8px 16px;
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(8px);
  color: #9f2f25;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 1px;
  border: 1px solid #ffe7a0;
}

/* 诗盘卡片样式 - 保留圆角 */
.poemCard {
  position: absolute;
  width: 138px;
  height: 78px;
  transition: transform 0.18s ease, opacity 0.18s ease, filter 0.18s ease;
  cursor: pointer;
}

.poemCard .cardFace {
  position: relative;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(180deg, #fffefb, #f6efe4);
  color: #151515;
  font-size: 23px;
  font-weight: 600;
  letter-spacing: 1px;
  box-shadow:
    0 14px 26px rgba(33, 31, 24, 0.14),
    0 2px 0 #f3e8d9,
    0 5px 0 #e6d9c7;
  border: 1px solid rgba(70, 50, 20, 0.07);
  transition: transform 0.18s ease, box-shadow 0.18s ease;
  border-radius: 18px;
}

.poemCard .cardFace::before {
  content: "";
  position: absolute;
  inset: 0;
  background:
    linear-gradient(135deg, rgba(255,255,255,0.40), transparent 28%, transparent 72%, rgba(255,255,255,0.18));
  pointer-events: none;
  border-radius: 18px;
}

.poemCard.clickable:hover .cardFace {
  transform: translateY(-3px) scale(1.02);
  box-shadow:
    0 20px 34px rgba(0, 0, 0, 0.16),
    0 2px 0 #f0e6d8,
    0 5px 0 #e4d8c6;
}

.cardText {
  display: inline-block;
  transform: translateY(-1px);
}

.poemCard.covered {
  opacity: 0.30;
  filter: grayscale(0.18) blur(0.4px);
  cursor: not-allowed;
}

.bottomPanels {
  display: grid;
  grid-template-columns: 1.2fr 0.8fr;
  gap: 0;
  flex-shrink: 0;
}

.slotPanel,
.rulePanel {
  padding: 16px 20px;
  background: rgba(255, 255, 255, 0.75);
  backdrop-filter: blur(8px);
  border: 1px solid #ffe7a0;
}

.slotPanel {
  border-right: none;
}

.panelHead,
.sideHead {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 16px;
  border-bottom: 1px dashed #ffe7a0;
  padding-bottom: 8px;
}

.panelTitle,
.sideTitle {
  font-size: 20px;
  font-weight: 800;
  color: #9f2f25;
  letter-spacing: 2px;
}

.slotTip,
.rankBadge {
  font-size: 12px;
  color: #8b6946;
  padding: 4px 12px;
  background: rgba(255, 255, 255, 0.8);
  border: 1px solid rgba(139, 105, 70, 0.3);
}

.slotBar {
  display: grid;
  gap: 0;
}

.slotCell {
  height: 82px;
  border: 1px solid #e2bf56;
  background: #fdfaf4;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}
.slotCard {
  width: 100%;
  height: 100%;
  background: #fffef8;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow:
    0 8px 16px rgba(0, 0, 0, 0.10),
    0 2px 0 #f0e6d8;
  font-size: 22px;
  color: #111;
}

.ruleLine {
  color: #9f2f25;
  font-size: 15px;
  line-height: 1.85;
}

.ruleLine + .ruleLine {
  margin-top: 8px;
}

.rightPanel {
  width: 320px;
  display: flex;
  flex-direction: column;
  gap: 0;
  flex-shrink: 0;
}

.sideCard {
  padding: 16px;
  background: rgba(255,255,255,0.78);
  border: 1px solid rgba(80, 110, 110, 0.12);
  box-shadow: 0 10px 28px rgba(45, 78, 78, 0.08);
  backdrop-filter: blur(12px);
}

.scoreCard {
  flex-shrink: 0;
  border-bottom: none;
}

.rankCard {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-height: 0;
}

.rankList {
  flex: 1;
  overflow-y: auto;
  max-height: calc(100% - 50px);
  padding-right: 4px;
}

.gameMiniHead {
  margin-bottom: 14px;
}

.miniTitle {
  font-size: 24px;
  font-weight: 800;
  color: #203535;
  line-height: 1.2;
}

.miniLevel {
  margin-top: 6px;
  font-size: 13px;
  color: #6a7f7f;
}

.progressMeta,
.scoreGrid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0;
}

.progressItem,
.scoreItem {
  padding: 12px;
  background: #faf0ce;
  border: 1px solid #f5c536;
}

.progressItem {
  border-right: none;
  border-bottom: none;
}

.progressItem:nth-child(even) {
  border-right: 1px solid #faf0ce;
}

.progressItem:nth-child(3),
.progressItem:nth-child(4) {
  border-bottom: 1px solid #faf0ce;
}

.scoreLabel {
  font-size: 12px;
  color: #080909;
}

.scoreValue {
  margin-top: 8px;
  font-size: 18px;
  font-weight: 800;
  color: #070b0b;
}

.rankList {
  display: flex;
  flex-direction: column;
  gap: 0;
}

.rankRow {
  display: grid;
  grid-template-columns: 40px 1fr auto;
  gap: 12px;
  align-items: center;
  padding: 12px;
  background: rgba(247,250,249,0.84);
  border: 1px solid #faf0ce;
  transition: transform 0.18s ease, box-shadow 0.18s ease;
}

.rankRow + .rankRow {
  border-top: none;
}

.rankRow:hover {
  transform: translateY(-1px);
  box-shadow: 0 10px 18px rgba(28, 52, 52, 0.06);
}

.rankRow.me {
  background: linear-gradient(180deg, #faf0ce);
  border-color: #faf0ce;
}

.rankNo {
  width: 40px;
  height: 40px;
  background: linear-gradient(180deg, #fefefe, #faf0ce);
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 800;
  color: #050707;
}

.rankName {
  font-size: 15px;
  font-weight: 800;
  color: #000909;
}

.rankMeta {
  margin-top: 4px;
  font-size: 12px;
  color: #040505;
}

.rankScore {
  font-size: 20px;
  font-weight: 800;
  color: #090e0e;
}

.rankEmpty {
  padding: 18px 12px;
  text-align: center;
  color: #6f8484;
  background: #faf0ce;
  border: 1px solid #faf0ce;
}

.mask {
  position: fixed;
  inset: 0;
  background: #faf0ce;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
}

.dialog {
  width: 420px;
  max-width: calc(100vw - 32px);
  padding: 26px 24px;
  background: rgba(255,255,255,0.95);
  text-align: center;
  box-shadow: 0 24px 50px rgba(0,0,0,0.16);
}

.dialog h3 {
  margin: 0 0 14px;
  font-size: 28px;
  color: #213737;
}

.dialog p {
  margin: 10px 0;
  font-size: 17px;
  color: #060707;
}

.dialogBtns {
  display: flex;
  justify-content: center;
  gap: 12px;
  margin-top: 18px;
}

.dialogBtns button {
  border: none;
  cursor: pointer;
  padding: 10px 18px;
  background: linear-gradient(180deg, #ffffff, #faf0ce);
  box-shadow: 0 6px 18px rgba(0, 0, 0, 0.08);
  font-size: 15px;
  font-weight: 700;
  color: #000b0b;
  transition: transform 0.18s ease, box-shadow 0.18s ease;
}

@media (max-width: 1480px) {
  .board {
    height: 720px;
  }

  .boardGlow {
    width: 720px;
    height: 720px;
  }

  .ringOuter {
    width: 660px;
    height: 660px;
  }

  .ringOuter2 {
    width: 560px;
    height: 560px;
  }

  .ringMid {
    width: 430px;
    height: 430px;
  }
}

@media (max-width: 1280px) {
  .mainLayout {
    flex-direction: column;
  }

  .rightPanel {
    width: 100%;
    flex-direction: row;
    gap: 0;
  }

  .rankCard {
    flex: 1;
  }

  .scoreCard {
    flex: 1;
    border-bottom: 1px solid rgba(80, 110, 110, 0.12);
    border-right: none;
  }

  .board {
    height: 680px;
  }

  .bottomPanels {
    grid-template-columns: 1fr;
  }

  .slotPanel {
    border-right: 1px solid rgba(80, 120, 100, 0.2);
  }

  .floatActions {
    top: 84px;
  }
}

@media (max-width: 768px) {
  .matchPage {
    padding: 0;
  }

  .floatActions {
    top: 76px;
    left: 16px;
    right: 16px;
  }

  .boardHeaderMain {
    flex-direction: column;
    align-items: stretch;
  }

  .boardStats {
    justify-content: flex-start;
  }

  .board {
    height: 600px;
  }

  .slotBar {
    grid-template-columns: repeat(3, 1fr) !important;
  }

  .poemCard {
    width: 118px;
    height: 68px;
  }

  .poemCard .cardFace {
    font-size: 20px;
  }

  .mainLayout {
    gap: 0;
  }

  .progressMeta {
    grid-template-columns: 1fr 1fr;
  }

  .rightPanel {
    flex-direction: column;
  }

  .scoreCard {
    border-right: 1px solid rgba(80, 110, 110, 0.12);
    border-bottom: none;
  }
}
.backBtn {
  position: fixed;
  top: 20px;
  left: 20px;
  z-index: 999;
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
</style>