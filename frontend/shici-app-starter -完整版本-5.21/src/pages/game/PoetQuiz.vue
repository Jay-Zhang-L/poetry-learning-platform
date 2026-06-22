<template>
  <div class="quizPage" :style="{ backgroundImage: `url(${bgUrl})` }">
    <div class="bgOverlay"></div>

    <header class="topBar">
      <button class="backBtn" @click="exitToGame">返回大厅</button>

      <div class="topCenter">
        <div class="topTitle">诗人气质测评</div>
        <div class="topSub" v-if="phase === 'inProgress'">
          第 {{ currentIndex + 1 }} / {{ totalQuestions }} 题
        </div>
        <div class="topSub" v-else-if="phase === 'finished'">灵魂波长分析</div>
        <div class="topSub" v-else>探寻跨越千年的文学基因</div>
      </div>

      <div class="topRight">
        <button class="ghostTopBtn" @click="openHistoryDrawer">测评档案</button>
      </div>
    </header>

    <main class="mainStage">
      <transition name="fadeUp" mode="out-in">
        <!-- 统一的外部容器，确保尺寸固定，防止跳转 -->
        <div class="contentContainer" :key="phase">

          <!-- 1. 初始介绍页 (按钮移到底部) -->
          <section v-if="phase === 'intro'" class="introWrap">
            <div class="paperCard stableCard introCard">
              <div class="introContent">
                <div class="introTop">
                  <div class="introPreTitle">寻觅千年的灵魂回响</div>
                  <div class="introTitle">{{ quizTitle || "测一测：你最像哪位诗人？" }}</div>
                  <div class="introDesc">
                    {{ quizDesc || "这是一场基于性格底色与审美直觉的深度测评。我们将通过 12 组灵魂抉择，分析你的六维性格占比，最终在漫漫历史长河中，为你匹配那份跨越千年的文学共鸣。" }}
                  </div>
                  <div class="chipRow">
                    <span class="chip"># 气质画像</span>
                    <span class="chip"># 性格占比分析</span>
                    <span class="chip"># 文学基因匹配</span>
                  </div>
                </div>
                <div class="introBottom">
                  <div class="ruleBox">
                    <div class="ruleTitle">测评指南</div>
                    <div class="ruleRow">
                      <div class="ruleItem">● 遵循第一直觉进行选择</div>
                      <div class="ruleItem">● 选项点击后将自动进入下一题</div>
                      <div class="ruleItem">● 测评结果将永久保存于个人档案</div>
                    </div>
                  </div>
                  <div class="startAction">
                    <button class="primaryBtn startBtn" :disabled="starting || loading" @click="start">
                      {{ starting ? "开启灵魂之旅…" : "开始测评" }}
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </section>

          <!-- 2. 答题进行中 (拉宽且稳定) -->
          <section v-else-if="phase === 'inProgress'" class="quizWrap">
            <div class="paperCard stableCard quizCard">
              <div class="quizGrid">
                <div class="qLeft">
                  <div class="qProgress">
                    <div class="qProgressBar">
                      <div class="qProgressIn" :style="{ width: `${progressPct}%` }"></div>
                    </div>
                    <div class="qProgressText">
                      <b>{{ currentIndex + 1 }}</b> / {{ totalQuestions }}
                    </div>
                  </div>

                  <transition name="swapUp" mode="out-in">
                    <div class="qTextBox" :key="currentQuestion?.questionId">
                      <div class="qNo">QUESTION {{ currentIndex + 1 }}</div>
                      <div class="qText">{{ currentQuestion?.questionText || "" }}</div>
                      <div class="qHint">倾听内心的声音，选择契合的答案</div>
                    </div>
                  </transition>

                  <div class="qControls">
                    <button class="ctrlBtn ghost" :disabled="submitting || currentIndex === 0" @click="prev">
                      返回上一题
                    </button>
                  </div>
                </div>

                <div class="qRight">
                  <transition name="swapUp" mode="out-in">
                    <div class="optGrid" :key="currentQuestion?.questionId">
                      <button
                          v-for="(opt, idx) in currentOptions"
                          :key="opt.optionId"
                          class="optCard"
                          :class="{ selected: draftSelectedOptionId === opt.optionId }"
                          @click="selectOption(opt.optionId)"
                          :disabled="submitting"
                          :style="{ animationDelay: `${idx * 60}ms` }"
                      >
                        <div class="optBadge">{{ optionLetter(idx) }}</div>
                        <div class="optText">{{ opt.optionText }}</div>
                        <div class="optTick">✓</div>
                        <div class="optGlow"></div>
                      </button>
                    </div>
                  </transition>
                  <div class="needPick" v-if="!draftSelectedOptionId">请选择一个选项</div>
                </div>
              </div>
            </div>
          </section>

          <!-- 3. 测评结果页 (左右分栏布局) -->
          <section v-else class="resultWrap">
            <div class="paperCard stableCard resultCard">
              <!-- 形象分析 (左侧) -->
              <div class="resultMain">
                <div class="shine"></div>
                <div class="posterHead">
                  <div class="posterSub">您的性格底色最接近</div>
                </div>
                <div class="posterNameRow">
                  <div class="posterName">{{ resultPoet?.name || "未知" }}</div>
                  <div class="posterDynasty">{{ resultPoet?.dynasty || "" }}</div>
                </div>
                <div class="persona">{{ resultPoet?.personaTitle || "气质画像" }}</div>
                <div class="posterDesc">
                  {{ resultPoet?.personaDesc || "你拥有独特的灵魂波长，在文字的律动中闪烁着温润而坚定的光芒..." }}
                </div>
                <div class="tagRow" v-if="resultPoet?.tags">
                  <span v-for="(t, i) in splitTags(resultPoet.tags)" :key="i" class="tag">#{{ t }}</span>
                </div>
                <div class="works" v-if="resultPoet?.representativeWorks">
                  <div class="worksTitle">灵魂代表作</div>
                  <div class="worksText">{{ resultPoet.representativeWorks }}</div>
                </div>
                <div class="resultActions">
                  <button class="actBtn primary" @click="restart">再测一次</button>
                  <button class="actBtn ghost" @click="exitToGame">返回大厅</button>
                </div>
              </div>

              <!-- 图表分析 (右侧) -->
              <div class="resultAnalysis">
                <div class="radarTop">
                  <div class="radarTitle">性格维度占比</div>
                  <div class="radarTip">基于 {{ totalQuestions }} 组维度数据的核心特征提取</div>
                </div>
                <div class="radarBox">
                  <VChart class="radarChart" :option="radarOption" autoresize />
                </div>
                <div class="miniList">
                  <div
                      v-for="(it, idx) in scoreBoardView.slice(0, radarTopN)"
                      :key="String(it.poetId) + '_' + idx"
                      class="miniRow"
                  >
                    <div class="miniRank">{{ idx + 1 }}</div>
                    <div class="miniName">{{ poetTraitName(it.poetId) }}</div>
                    <div class="miniScore">{{ it.score }}</div>
                  </div>
                </div>
              </div>
            </div>
          </section>
        </div>
      </transition>
    </main>

    <!-- 档案管理侧边栏 (完整还原原始逻辑) -->
    <transition name="drawer">
      <div v-if="showHistory" class="drawerMask" @click.self="showHistory = false">
        <div class="drawerPanel">
          <div class="drawerHead">
            <div class="drawerTitle">测评档案</div>
            <button class="drawerClose" @click="showHistory = false">✕</button>
          </div>

          <div class="drawerTabs">
            <button class="tabBtn" :class="{ active: historyStatus === 'finished' }" @click="switchHistoryStatus('finished')">已完成</button>
            <button class="tabBtn" :class="{ active: historyStatus === 'in_progress' }" @click="switchHistoryStatus('in_progress')">进行中</button>
          </div>

          <div class="drawerBody">
            <div v-if="historyError" class="drawerError">{{ historyError }}</div>

            <div v-if="historyLoading" class="drawerState">正在读取时光印记…</div>
            <div v-else-if="!historyItems.length" class="drawerState">暂无记录</div>

            <div v-else class="drawerList">
              <div v-for="it in historyItems" :key="it.attemptId" class="drawerItem" @click="openHistory(it)">
                <div class="dLeft">
                  <div class="dName">{{ it.resultPoetName || (it.status === 'finished' ? '未知诗人' : '未完成') }}</div>
                  <div class="dTime">{{ formatTime(it.finishedAt || it.startedAt) }}</div>
                </div>

                <div class="dMid" :class="it.status">
                  {{ it.status === 'finished' ? '已生成' : '进行中' }}
                </div>

                <button class="dDel" :disabled="historyDeletingId === it.attemptId" @click.stop="deleteHistory(it)">
                  {{ historyDeletingId === it.attemptId ? "删除中" : "删除" }}
                </button>
              </div>
            </div>

            <div class="pager" v-if="historyTotal > historySize">
              <button class="pagerBtn" :disabled="historyPage <= 1 || historyLoading" @click="prevHistoryPage">上一页</button>
              <div class="pagerText">第 {{ historyPage }} 页</div>
              <button class="pagerBtn" :disabled="historyPage * historySize >= historyTotal || historyLoading" @click="nextHistoryPage">下一页</button>
            </div>
          </div>

          <div class="drawerFoot">
            <button class="footBtn" :disabled="historyLoading" @click="reloadHistory">
              {{ historyLoading ? "刷新中…" : "刷新" }}
            </button>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import bgUrl from "@/assets/game/quiz.jpg";
import { use } from "echarts/core";
import { RadarChart } from "echarts/charts";
import { TooltipComponent } from "echarts/components";
import { CanvasRenderer } from "echarts/renderers";
import VChart from "vue-echarts";
import { computed, reactive, ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import {
  answerPoetQuiz,
  deletePoetQuizAttempt,
  getMyPoetQuizAttempts,
  getPoetProfile,
  getPoetQuizAttempt,
  getPoetQuizDetail,
  getPoetQuizList,
  startPoetQuiz,
  submitPoetQuiz,
} from "@/utils/poetQuizApi";

use([RadarChart, TooltipComponent, CanvasRenderer]);

const router = useRouter();
const loading = ref(true);
const starting = ref(false);
const submitting = ref(false);
const phase = ref("intro");

const quizId = ref(null);
const quizTitle = ref("");
const quizDesc = ref("");
const questions = ref([]);
const totalQuestions = computed(() => questions.value.length || 0);

const attemptId = ref(null);
const currentIndex = ref(0);
const draftSelectedOptionId = ref(null);

const resultPoet = ref(null);
const scoreBoard = ref([]);
const poetCache = reactive({});

// 性格特质映射 (用于雷达图顶点)
const TRAIT_MAP = {
  9001: "浪漫自由", 9002: "现实关怀", 9003: "豁达智慧",
  9004: "细腻感知", 9005: "空灵静观", 9006: "平易共情",
  9007: "热血担当", 9008: "淡泊田园", 9009: "市井风月",
  9010: "边塞豪气", 9011: "深情自省", 9012: "理想执着"
};

// 档案状态逻辑
const showHistory = ref(false);
const historyLoading = ref(false);
const historyError = ref("");
const historyItems = ref([]);
const historyTotal = ref(0);
const historyPage = ref(1);
const historySize = ref(20);
const historyStatus = ref("finished");
const historyDeletingId = ref(null);

const currentQuestion = computed(() => questions.value[currentIndex.value] || null);
const currentOptions = computed(() => currentQuestion.value?.options || []);
const isLastQuestion = computed(() => currentIndex.value >= totalQuestions.value - 1);

const progressPct = computed(() => {
  if (!totalQuestions.value) return 0;
  return Math.min(100, Math.max(0, ((currentIndex.value + 1) / totalQuestions.value) * 100));
});

const scoreBoardView = computed(() => {
  const list = Array.isArray(scoreBoard.value) ? scoreBoard.value : [];
  return [...list].sort((a, b) => (b.score ?? 0) - (a.score ?? 0));
});

function optionLetter(i) { return ["A", "B", "C", "D"][i] || ""; }

// 自动跳转逻辑：点击选项后延迟自动下一题
async function selectOption(optionId) {
  if (submitting.value) return;
  draftSelectedOptionId.value = optionId;

  setTimeout(async () => {
    try {
      if (isLastQuestion.value) await submit();
      else await next();
    } catch (e) { console.error("Auto next failed", e); }
  }, 350);
}

async function start() {
  starting.value = true;
  try {
    const res = await startPoetQuiz({ quizId: quizId.value || 9100 });
    attemptId.value = res?.data?.attemptId ?? null;
    currentIndex.value = 0;
    draftSelectedOptionId.value = null;
    phase.value = "inProgress";
  } catch (e) { alert(e?.message || "启动测评失败"); }
  finally { starting.value = false; }
}

async function prev() {
  if (currentIndex.value <= 0) return;
  currentIndex.value -= 1;
  draftSelectedOptionId.value = null;
}

async function next() {
  await commitCurrentAnswer();
  if (currentIndex.value < totalQuestions.value - 1) {
    currentIndex.value += 1;
    draftSelectedOptionId.value = null;
  }
}

async function submit() {
  await commitCurrentAnswer();
  await doSubmit();
}

async function commitCurrentAnswer() {
  if (!attemptId.value || !currentQuestion.value?.questionId || !draftSelectedOptionId.value) return;
  submitting.value = true;
  try {
    await answerPoetQuiz({
      attemptId: attemptId.value,
      questionId: currentQuestion.value.questionId,
      optionId: draftSelectedOptionId.value,
    });
  } catch (e) {
    alert(e?.message || "数据提交失败");
    throw e;
  } finally { submitting.value = false; }
}

async function doSubmit() {
  if (!attemptId.value) return;
  submitting.value = true;
  try {
    const res = await submitPoetQuiz({ attemptId: attemptId.value });
    const data = res?.data || {};
    resultPoet.value = data.resultPoet || null;
    scoreBoard.value = Array.isArray(data.scoreBoard) ? data.scoreBoard : [];
    await preloadPoetNames(scoreBoard.value.slice(0, 6).map((x) => x.poetId));
    phase.value = "finished";
    loadHistory();
  } catch (e) { alert(e?.message || "结果分析失败"); }
  finally { submitting.value = false; }
}

function poetTraitName(id) { return TRAIT_MAP[id] || poetCache[id] || `维度#${id}`; }

async function preloadPoetNames(poetIds) {
  const uniq = Array.from(new Set((poetIds || []).filter(Boolean)));
  const need = uniq.filter((id) => !poetCache[id]);
  if (!need.length) return;
  await Promise.all(need.map(async (id) => {
    try {
      const res = await getPoetProfile(id);
      if (res?.data?.name) poetCache[id] = res.data.name;
    } catch (e) {}
  }));
}

// 雷达图配置：性格占比由积分 Score 决定
const radarTopN = 6;
const radarOption = computed(() => {
  const top = scoreBoardView.value.slice(0, radarTopN);
  const maxScoreRaw = top[0]?.score ?? 0;
  const axisMax = Math.max(10, Number(maxScoreRaw) * 1.1 || 10);

  const indicator = top.length
      ? top.map((it) => ({ name: poetTraitName(it.poetId), max: axisMax }))
      : Array(6).fill(0).map((_, i) => ({ name: `特质${i+1}`, max: 10 }));

  const values = top.length ? top.map((it) => Number(it.score) || 0) : [0, 0, 0, 0, 0, 0];

  return {
    tooltip: { show: true, trigger: 'item' },
    radar: {
      shape: "polygon",
      radius: "70%",
      splitNumber: 5,
      axisName: { color: "#5a4b3f", fontWeight: "bold", fontSize: 13 },
      splitArea: { areaStyle: { color: ["rgba(255,255,255,0.6)", "rgba(249,243,232,0.4)"] } },
      splitLine: { lineStyle: { color: "rgba(143,75,43,0.12)" } },
      indicator,
    },
    series: [{
      type: "radar",
      data: [{
        value: values,
        name: "性格维度占比",
        areaStyle: { color: "rgba(143, 75, 43, 0.28)" },
        lineStyle: { color: "#8f4b2b", width: 3 },
        itemStyle: { color: "#8f4b2b" },
        symbol: 'circle',
        symbolSize: 8
      }]
    }]
  };
});

// 档案管理核心逻辑
function openHistoryDrawer() { showHistory.value = true; if (!historyItems.value.length) loadHistory(); }
function switchHistoryStatus(s) { if (historyStatus.value === s) return; historyStatus.value = s; historyPage.value = 1; loadHistory(); }
async function reloadHistory() { historyPage.value = 1; await loadHistory(); }
async function prevHistoryPage() { if (historyPage.value <= 1) return; historyPage.value -= 1; await loadHistory(); }
async function nextHistoryPage() { if (historyPage.value * historySize.value >= historyTotal.value) return; historyPage.value += 1; await loadHistory(); }

async function loadHistory() {
  historyLoading.value = true;
  historyError.value = "";
  try {
    const res = await getMyPoetQuizAttempts({ page: historyPage.value, size: historySize.value, status: historyStatus.value });
    const data = res?.data || {};
    historyTotal.value = data.total ?? 0;
    historyItems.value = Array.isArray(data.items) ? data.items : [];
  } catch (e) {
    historyError.value = e?.message || "记录加载失败";
    historyItems.value = [];
  } finally { historyLoading.value = false; }
}

async function openHistory(it) {
  showHistory.value = false;
  loading.value = true;
  try {
    const res = await getPoetQuizAttempt(it.attemptId);
    const data = res?.data || {};
    attemptId.value = data.attemptId ?? it.attemptId;
    const isDone = data.status === "finished" || it.status === "finished";

    if (isDone) {
      resultPoet.value = data.resultPoet || (it.resultPoetName ? { name: it.resultPoetName, dynasty: it.resultPoetDynasty, personaTitle: it.resultPoetPersonaTitle } : null);
      scoreBoard.value = Array.isArray(data.scoreBoard) ? data.scoreBoard : [];
      await preloadPoetNames(scoreBoard.value.slice(0, 6).map((x) => x.poetId));
      phase.value = "finished";
    } else {
      phase.value = "inProgress";
      currentIndex.value = Math.min(Math.max(0, data.answeredCount ?? 0), totalQuestions.value - 1);
      draftSelectedOptionId.value = null;
    }
  } catch (e) { alert("读取失败: " + e.message); }
  finally { loading.value = false; }
}

async function deleteHistory(it) {
  if (!window.confirm("确定删除测评档案吗？")) return;
  historyDeletingId.value = it.attemptId;
  try {
    await deletePoetQuizAttempt(it.attemptId);
    historyItems.value = historyItems.value.filter((x) => x.attemptId !== it.attemptId);
    historyTotal.value = Math.max(0, historyTotal.value - 1);
  } catch (e) { alert("删除失败"); }
  finally { historyDeletingId.value = null; }
}

function restart() { phase.value = "intro"; attemptId.value = null; currentIndex.value = 0; draftSelectedOptionId.value = null; resultPoet.value = null; scoreBoard.value = []; }
function exitToGame() { router.push("/game"); }
function splitTags(s) { return s ? String(s).split(/[，,]/).map(x => x.trim()).filter(Boolean) : []; }
function formatTime(s) { return s ? String(s).replace("T", " ").slice(0, 16) : ""; }

async function boot() {
  loading.value = true;
  try {
    const listRes = await getPoetQuizList();
    const first = listRes?.data?.[0];
    quizId.value = first?.quizId ?? 9100;
    const detailRes = await getPoetQuizDetail(quizId.value);
    const d = detailRes?.data || {};
    quizTitle.value = d.title || first?.title || "诗人气质测评";
    quizDesc.value = d.description || first?.description || "";
    questions.value = Array.isArray(d.questions) ? d.questions : [];
    loadHistory();
  } catch (e) { console.error(e); }
  finally { loading.value = false; }
}

onMounted(boot);
</script>

<style scoped>
.quizPage {
  min-height: 100vh;
  width: 100%;
  background-size: cover;
  background-position: center;
  position: relative;
  padding: 40px;
  display: flex;
  flex-direction: column;
  overflow-x: hidden;
}

.bgOverlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(248, 241, 226, 0.2) 0%, rgba(248, 241, 226, 0.5) 100%);
  pointer-events: none;
}

.topBar {
  position: relative;
  z-index: 5;
  display: grid;
  grid-template-columns: 200px 1fr 200px;
  align-items: center;
  max-width: 1250px;
  margin: 0 auto 50px;
  width: 100%;
}

.backBtn, .ghostTopBtn {
  padding: 0 0 8px 0;
  border: none;
  background: transparent;
  cursor: pointer;
  font-weight: 900;
  color: #5a4b3f;
  font-size: 18px;
  position: relative;
  transition: color 0.25s;
}
.backBtn::after, .ghostTopBtn::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 2px;
  background: #8f4b2b;
  transition: transform 0.25s;
}
.backBtn:hover, .ghostTopBtn:hover {
  color: #8f4b2b;
}
.backBtn:hover::after, .ghostTopBtn:hover::after {
  transform: scaleX(1.2);
}

.topTitle { font-size: 32px; font-family: serif; font-weight: 900; letter-spacing: 5px; text-align: center; color: #2b241d; }
.topSub { font-size: 16px; text-align: center; opacity: 0.7; color: #2b241d; margin-top: 8px; }

.mainStage {
  position: relative;
  z-index: 2;
  width: 100%;
  max-width: 1250px;
  margin: 0 auto;
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}

.contentContainer {
  width: 100%;
  min-height: 720px;
  display: flex;
  align-items: center;
}

.paperCard {
  border-radius: 0;
  background: rgba(255, 255, 255, 0.88);
  backdrop-filter: blur(30px);
  box-shadow: 0 25px 90px rgba(46, 32, 18, 0.15);
  border: 1px solid rgba(255, 255, 255, 0.8);
  overflow: hidden;
  width: 100%;
}

.stableCard { min-height: 720px; }

/* 1. 介绍页：纵向布局优化 */
.introCard { padding: 60px 80px; position: relative; }
.seal { position: absolute; right: 60px; top: 60px; width: 70px; height: 70px; background: #8f4b2b; color: #fff; border-radius: 14px; display: grid; place-items: center; font-size: 32px; font-family: serif; box-shadow: 0 10px 25px rgba(143,75,43,0.3); }

.introContent { display: flex; flex-direction: column; gap: 50px; height: 100%; }
.introTop { flex: 1; text-align: center; }
.introBottom { display: flex; flex-direction: column; align-items: center; gap: 40px; padding-top: 40px; border-top: 1px dashed rgba(143, 75, 43, 0.15); }

.introPreTitle { font-size: 18px; color: #8f4b2b; font-weight: 900; letter-spacing: 6px; margin-bottom: 20px; text-transform: uppercase; }
.introTitle { font-size: 64px; font-family: serif; line-height: 1.3; color: #2b241d; font-weight: 900; margin-bottom: 30px; }
.introDesc { font-size: 24px; line-height: 1.8; color: #5a4b3f; opacity: 0.95; margin-bottom: 40px; max-width: 900px; margin-left: auto; margin-right: auto; }
.chipRow { display: flex; gap: 18px; justify-content: center; }
.chip { padding: 10px 24px; background: rgba(143,75,43,0.08); color: #8f4b2b; border-radius: 24px; font-size: 15px; font-weight: bold; }

.startAction { width: 100%; display: flex; justify-content: center; }
.startBtn { width: 380px; height: 84px; font-size: 24px; }
.primaryBtn {
  background: linear-gradient(135deg, #8f4b2b, #723a22);
  color: #fff;
  border: none;
  border-radius: 24px;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 15px 40px rgba(143,75,43,0.35);
}
.primaryBtn:hover { transform: translateY(-4px); box-shadow: 0 20px 50px rgba(143,75,43,0.45); }

.ruleBox { width: 100%; text-align: center; }
.ruleTitle { font-weight: bold; margin-bottom: 15px; color: #8f4b2b; font-size: 18px; }
.ruleRow { display: flex; gap: 50px; justify-content: center; }
.ruleItem { font-size: 16px; color: #5a4b3f; opacity: 0.8; }

/* 2. 答题页 */
.quizCard { padding: 70px 90px; }
.quizGrid { display: grid; grid-template-columns: 1fr 1fr; gap: 100px; height: 100%; }
.qProgress { display: flex; align-items: center; gap: 30px; margin-bottom: 60px; }
.qProgressBar { height: 16px; background: rgba(0,0,0,0.08); border-radius: 8px; flex: 1; overflow: hidden; }
.qProgressIn { height: 100%; background: linear-gradient(90deg, #8f4b2b, #b56d45); transition: width 0.6s cubic-bezier(0.34, 1.56, 0.64, 1); }
.qProgressText { font-weight: 900; color: #5a4b3f; font-size: 20px; }
.qProgressText b { color: #8f4b2b; font-size: 32px; margin-right: 8px; }

.qTextBox { min-height: 350px; display: flex; flex-direction: column; justify-content: center; }
.qNo { color: #8f4b2b; font-weight: 900; font-size: 22px; margin-bottom: 25px; letter-spacing: 4px; }
.qText { font-size: 46px; font-family: serif; line-height: 1.5; color: #2b241d; font-weight: 900; }
.qHint { font-size: 18px; margin-top: 30px; color: #8c7e71; font-weight: bold; opacity: 0.8; }

.optGrid { display: flex; flex-direction: column; gap: 24px; min-height: 480px; }
.optCard {
  display: flex;
  align-items: center;
  padding: 28px 36px;
  background: rgba(255,255,255,0.7);
  border: 1px solid rgba(80, 60, 45, 0.15);
  border-radius: 28px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  text-align: left;
  animation: popIn 420ms ease both;
}
@keyframes popIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

.optCard:hover { background: #fff; border-color: #8f4b2b; transform: translateX(15px); }
.optCard.selected { background: #2b241d; color: #fff; border-color: #2b241d; box-shadow: 0 15px 40px rgba(0,0,0,0.25); }
.optBadge { width: 50px; height: 50px; background: rgba(0,0,0,0.06); border-radius: 50%; display: grid; place-items: center; margin-right: 28px; font-weight: 900; font-size: 22px; }
.optCard.selected .optBadge { background: rgba(255,255,255,0.22); color: #fff; }
.optText { font-size: 22px; flex: 1; font-weight: 900; }
.optTick { opacity: 0; margin-left: 20px; font-size: 24px; }
.optCard.selected .optTick { opacity: 1; }

.qControls { margin-top: 70px; }
.ctrlBtn { padding: 18px 40px; border-radius: 35px; border: 1px solid rgba(80, 60, 45, 0.3); background: rgba(255,255,255,0.7); color: #5a4b3f; font-weight: 900; cursor: pointer; transition: all 0.25s; font-size: 18px; }
.ctrlBtn:hover:not(:disabled) { background: #fff; border-color: #8f4b2b; color: #8f4b2b; }

/* 3. 结果页：分栏对齐优化 */
.resultWrap { width: 100%; display: flex; justify-content: center; }
.resultCard { display: grid; grid-template-columns: 1fr 1fr; border-radius: 0; background: rgba(255, 255, 255, 0.9); align-items: stretch; position: relative; width: 100%; min-height: 720px; overflow: hidden; }
.resultMain { padding: 60px 70px; border-right: 1px dashed rgba(143, 75, 43, 0.15); display: flex; flex-direction: column; position: relative; overflow: hidden; justify-content: flex-start; }
.resultAnalysis { padding: 60px 70px; background: rgba(255, 255, 255, 0.4); display: flex; flex-direction: column; justify-content: flex-start; }

.resultMain > *:first-child, .resultAnalysis > *:first-child { margin-top: 0; }

.shine {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, rgba(255,255,255,0) 0%, rgba(255,255,255,0.4) 50%, rgba(255,255,255,0) 100%);
  transform: translateX(-100%);
  animation: shine 3s infinite;
  pointer-events: none;
}
@keyframes shine {
  0% { transform: translateX(-100%); }
  20%, 100% { transform: translateX(100%); }
}

.posterHead { display: flex; align-items: center; gap: 20px; margin-bottom: 35px; }
.stamp { width: 64px; height: 64px; border: 3.5px solid #8f4b2b; color: #8f4b2b; display: grid; place-items: center; font-weight: 900; font-family: serif; transform: rotate(-10deg); font-size: 30px; background: #fff; border-radius: 20px; }
.posterSub { font-weight: 900; color: #8c7e71; letter-spacing: 5px; font-size: 22px; }

.posterNameRow { display: flex; align-items: baseline; gap: 28px; margin: 30px 0; }
.posterName { font-size: 100px; font-family: serif; line-height: 1; color: #2b241d; font-weight: 900; }
.posterDynasty { font-size: 36px; color: #8f4b2b; font-weight: 900; letter-spacing: 6px; }

.persona { padding: 16px 36px; background: #2b241d; color: #fff; border-radius: 40px; display: inline-block; margin-bottom: 40px; font-size: 24px; font-weight: bold; letter-spacing: 4px; }
.posterDesc { font-size: 21px; line-height: 2.2; color: #4a3f35; padding: 35px; border-radius: 32px; background: rgba(255,255,255,0.7); border: 1px solid rgba(0,0,0,0.08); font-weight: 500; }

.tagRow { display: flex; flex-wrap: wrap; gap: 16px; margin: 35px 0; }
.tag { padding: 10px 24px; background: rgba(143,75,43,0.15); color: #8f4b2b; border-radius: 30px; font-size: 17px; font-weight: 900; }

.works { padding: 35px; background: rgba(255,255,255,0.7); border-radius: 30px; border: 1px solid rgba(0,0,0,0.08); margin-bottom: 50px; }
.worksTitle { font-weight: 900; margin-bottom: 15px; color: #5a4b3f; font-size: 20px; }
.worksText { font-size: 20px; color: #4a3f35; line-height: 2; font-weight: 800; }

.radarTop { margin-bottom: 50px; }
.radarTitle { font-weight: 900; font-size: 32px; color: #2b241d; }
.radarTip { font-size: 18px; color: #8c7e71; margin-top: 10px; }

.radarBox { flex: 1; min-height: 450px; margin: 35px 0; background: rgba(255,255,255,0.5); border-radius: 40px; border: 1px solid rgba(0,0,0,0.06); padding: 30px; display: flex; align-items: center; justify-content: center; }
.radarChart { width: 100%; height: 100%; }

.miniList { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
.miniRow { display: flex; align-items: center; padding: 18px 24px; background: #fff; border-radius: 24px; border: 1px solid rgba(0,0,0,0.06); }
.miniRank { width: 36px; height: 36px; background: #8f4b2b; color: #fff; border-radius: 50%; display: grid; place-items: center; margin-right: 18px; font-size: 16px; font-weight: bold; }
.miniName { flex: 1; font-weight: 900; color: #5a4b3f; font-size: 18px; }
.miniScore { font-weight: 900; color: #8f4b2b; font-size: 20px; }

.resultActions { display: flex; gap: 30px; margin-top: auto; }
.actBtn { flex: 1; height: 76px; border-radius: 38px; font-weight: 900; cursor: pointer; transition: all 0.3s; font-size: 22px; }
.actBtn.primary { background: #2b241d; color: #fff; border: none; }
.actBtn.ghost { background: transparent; border: 3px solid #2b241d; color: #2b241d; }
.actBtn:hover { transform: translateY(-4px); box-shadow: 0 15px 35px rgba(0,0,0,0.18); }

/* 档案管理侧边栏 (还原原始样式深度) */
.drawerMask { position: fixed; inset: 0; z-index: 100; background: rgba(43,36,29,0.6); backdrop-filter: blur(12px); display: flex; justify-content: flex-end; }
.drawerPanel { width: 680px; height: 100%; background: #fdfaf5; box-shadow: -15px 0 60px rgba(0,0,0,0.25); display: flex; flex-direction: column; }
.drawerHead { padding: 45px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1.5px solid rgba(0,0,0,0.08); }
.drawerTitle { font-size: 28px; font-family: serif; font-weight: 900; color: #2b241d; }
.drawerClose { background: none; border: none; font-size: 30px; cursor: pointer; color: #8c7e71; }
.drawerTabs { display: flex; padding: 15px 45px; gap: 25px; }
.tabBtn { padding: 15px 30px; border: none; background: none; font-weight: 900; color: #8c7e71; cursor: pointer; border-bottom: 4px solid transparent; font-size: 18px; }
.tabBtn.active { color: #8f4b2b; border-bottom-color: #8f4b2b; }
.drawerBody { flex: 1; overflow-y: auto; padding: 45px; }
.drawerItem { background: #fff; border-radius: 30px; padding: 30px; margin-bottom: 25px; border: 1px solid rgba(0,0,0,0.08); cursor: pointer; display: flex; align-items: center; transition: all 0.25s; }
.drawerItem:hover { border-color: #8f4b2b; transform: scale(1.02); }
.dLeft { flex: 1; }
.dName { font-size: 22px; font-weight: 900; color: #2b241d; margin-bottom: 8px; }
.dTime { font-size: 15px; color: #8c7e71; }
.dMid { padding: 8px 20px; border-radius: 18px; font-size: 14px; font-weight: 900; margin: 0 25px; }
.dMid.finished { background: #e8f5e9; color: #2e7d32; }
.dMid.in_progress { background: #fff3e0; color: #ef6c00; }
.dDel { padding: 10px 20px; border-radius: 15px; border: 1px solid #ffcdd2; background: #fff; color: #c62828; cursor: pointer; font-weight: 900; }

.pager { display: flex; align-items: center; justify-content: center; gap: 30px; margin-top: 40px; }
.pagerBtn { padding: 12px 25px; border-radius: 18px; border: 1px solid #ddd; background: #fff; cursor: pointer; font-weight: 900; }

.drawerFoot { padding: 30px 45px; border-top: 1px solid rgba(0,0,0,0.08); }
.footBtn { width: 100%; height: 60px; border-radius: 30px; background: #fff; border: 1.5px solid #2b241d; font-weight: 900; font-size: 18px; cursor: pointer; }

/* 动画系统 */
.fadeUp-enter-active, .fadeUp-leave-active { transition: all 0.6s cubic-bezier(0.4, 0, 0.2, 1); }
.fadeUp-enter-from { opacity: 0; transform: translateY(50px); }
.fadeUp-leave-to { opacity: 0; transform: translateY(-50px); }

.swapUp-enter-active, .swapUp-leave-active { transition: all 0.45s ease; }
.swapUp-enter-from { opacity: 0; transform: translateY(25px); }
.swapUp-leave-to { opacity: 0; transform: translateY(-25px); }

.drawer-enter-active, .drawer-leave-active { transition: all 0.5s cubic-bezier(0.34, 1.56, 0.64, 1); }
.drawer-enter-from, .drawer-leave-to { transform: translateX(100%); }

@media (max-width: 1000px) {
  .introGrid, .quizGrid, .resultCard { grid-template-columns: 1fr; }
  .resultMain { border-right: none; border-bottom: 1px dashed rgba(143, 75, 43, 0.15); }
  .contentContainer, .stableCard { min-height: auto; }
}
</style>