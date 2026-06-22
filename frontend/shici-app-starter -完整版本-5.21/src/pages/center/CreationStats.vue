<template>
  <div class="page">
    <header class="head">
      <button class="back" type="button" @click="back">返回</button>
      <div class="title">笔底春秋录</div>
      <button class="right" type="button" :disabled="loading" @click="reload">
        {{ loading ? "加载中..." : "刷新" }}
      </button>
    </header>

    <!-- 标签导航 -->
    <div class="tabs">
      <button
        v-for="tab in tabs"
        :key="tab.key"
        class="tabBtn"
        :class="{ active: activeTab === tab.key }"
        @click="switchTab(tab.key)"
      >
        <span class="tabIcon">{{ tab.icon }}</span>
        <span class="tabText">{{ tab.label }}</span>
      </button>
    </div>

    <!-- 内容区域 -->
    <section class="panel">
      <!-- 创作时光轴 -->
      <div v-if="activeTab === 'timeline'" class="tabContent">
        <div class="timelineControls">
          <!-- 视图切换按钮 -->
          <div class="viewToggle">
            <button
              class="viewBtn"
              :class="{ active: timelineView === '3d-canvas' }"
              @click="timelineView = '3d-canvas'"
            >
              🎨 Three.js 3D
            </button>
            <button
              class="viewBtn"
              :class="{ active: timelineView === '3d' }"
              @click="timelineView = '3d'"
            >
              📜 CSS 3D
            </button>
            <button
              class="viewBtn"
              :class="{ active: timelineView === '2d' }"
              @click="timelineView = '2d'"
            >
              📋 2D视图
            </button>
          </div>

          <select v-model="timelineMode" class="modeSelect" @change="loadTimeline">
            <option value="month">按月</option>
            <option value="quarter">按季度</option>
            <option value="year">按年</option>
          </select>
        </div>

        <div v-if="!loading && timelineData.length === 0" class="empty">
          <div class="empty-state">
            <div class="empty-illustration">
              <svg viewBox="0 0 200 200" class="empty-svg">
                <!-- 古风卷轴 -->
                <rect x="60" y="40" width="20" height="120" fill="rgba(139, 119, 101, 0.3)" rx="2"/>
                <rect x="120" y="40" width="20" height="120" fill="rgba(139, 119, 101, 0.3)" rx="2"/>
                <!-- 纸张 -->
                <rect x="80" y="50" width="40" height="100" fill="rgba(248, 245, 240, 0.8)" stroke="rgba(212, 175, 55, 0.3)" stroke-width="1"/>
                <!-- 墨滴 -->
                <circle cx="100" cy="100" r="15" fill="rgba(26, 18, 11, 0.2)">
                  <animate attributeName="r" values="15;18;15" dur="2s" repeatCount="indefinite"/>
                  <animate attributeName="opacity" values="0.2;0.3;0.2" dur="2s" repeatCount="indefinite"/>
                </circle>
                <!-- 山水简笔 -->
                <path d="M 70 160 Q 85 140, 100 150 T 130 160" fill="none" stroke="rgba(26, 18, 11, 0.2)" stroke-width="2"/>
              </svg>
            </div>
            <div class="empty-text">
              <p class="empty-title">暂无创作记录</p>
              <p class="empty-subtitle">快去创作第一首诗词吧！</p>
            </div>
          </div>
        </div>

        <!-- Three.js 3D视图 -->
        <div v-else-if="timelineView === '3d-canvas'" class="timeline3DWrapper">
          <Timeline3DAdvanced :timelineData="timelineData" />
        </div>

        <!-- CSS 3D视图 -->
        <div v-else-if="timelineView === '3d'" class="timeline3DWrapper">
          <Timeline3D :timelineData="timelineData" />
        </div>

        <!-- 2D视图（原有版本） -->
        <div v-else class="timelineContainer">
          <div class="timelineHorizontal">
            <div
              v-for="node in timelineData"
              :key="node.id"
              class="timelineNode"
              @click="goToWork(node.id)"
            >
              <div class="nodeDate">{{ node.dateLabel }}</div>
              <div class="nodeMarker">
                <span v-if="node.isMilestone" class="badge">{{ node.badgeText }}</span>
              </div>
              <div class="nodeContent">
                <div class="workTitle">{{ node.title }}</div>
                <div class="workStats">
                  <span>👍 {{ node.likes }}</span>
                  <span class="dot">·</span>
                  <span>💬 {{ node.comments }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 数据看板 -->
      <div v-else-if="activeTab === 'dashboard'" class="tabContent">
        <div v-if="!loading && !dashboardData" class="empty">
          暂无统计数据
        </div>

        <div v-else class="dashboardGrid">
          <div class="kpiCards">
            <div class="kpiCard">
              <div class="kpiValue">{{ dashboardData?.totalWorks || 0 }}</div>
              <div class="kpiLabel">创作总数</div>
            </div>
            <div class="kpiCard">
              <div class="kpiValue">{{ formatNumber(dashboardData?.totalWords || 0) }}</div>
              <div class="kpiLabel">累计字数</div>
            </div>
            <div class="kpiCard">
              <div class="kpiValue">{{ dashboardData?.avgLikes || 0 }}</div>
              <div class="kpiLabel">平均获赞</div>
            </div>
          </div>

          <div class="chartsContainer">
            <div id="trendChart" class="chart"></div>
            <div id="typeChart" class="chart"></div>
            <div id="interactionChart" class="chart"></div>
          </div>
        </div>
      </div>

      <!-- 主题词云 -->
      <div v-else-if="activeTab === 'wordcloud'" class="tabContent">
        <div v-if="!loading && wordCloudData.length === 0" class="empty">
          暂无关键词数据
        </div>

        <div v-else class="wordcloudContainer">
          <div id="wordCloud" class="wordcloudCanvas"></div>
          <div class="wordcloudLegend">
            <span
              v-for="word in topWords"
              :key="word.text"
              class="wordTag"
              @click="filterByWord(word.text)"
            >
              {{ word.text }} ({{ word.count }})
            </span>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { computed, onMounted, ref, nextTick } from "vue";
import { useRouter } from "vue-router";
import * as echarts from "echarts";
import WordCloud from "wordcloud";
import { showError } from "@/utils/toast";
import Timeline3D from "@/components/Timeline3D.vue";
import Timeline3DAdvanced from "@/components/Timeline3DAdvanced.vue";

const router = useRouter();
const token = computed(() => localStorage.getItem("token") || "");

function apiFetch(url, opts = {}) {
  const headers = Object.assign({}, opts.headers || {});
  if (token.value) headers.Authorization = "Bearer " + token.value;
  return fetch(url, { ...opts, headers });
}

const tabs = [
  { key: "timeline", label: "创作时光轴", icon: "📅" },
  { key: "dashboard", label: "数据看板", icon: "📊" },
  { key: "wordcloud", label: "主题词云", icon: "☁️" }
];

const activeTab = ref("timeline");
const loading = ref(false);
const timelineMode = ref("month");
const timelineView = ref("3d-canvas"); // 默认使用Three.js 3D视图
const timelineData = ref([]);
const dashboardData = ref(null);
const wordCloudData = ref([]);

// 计算词云前6个高频词
const topWords = computed(() => {
  return wordCloudData.value.slice(0, 6);
});

function back() {
  router.back();
}

function switchTab(key) {
  activeTab.value = key;
  loadTabData();
}

async function loadTabData() {
  switch (activeTab.value) {
    case "timeline":
      await loadTimeline();
      break;
    case "dashboard":
      await loadDashboard();
      break;
    case "wordcloud":
      await loadWordCloud();
      break;
  }
}

async function loadTimeline() {
  loading.value = true;
  try {
    const resp = await apiFetch(`/api/stats/timeline?mode=${timelineMode.value}`);
    const json = await resp.json().catch(() => null);

    if (!resp.ok || !json || json.code !== 0) {
      // 检查是否是token失效问题
      if (json && (json.msg === "未登录" || json.msg === "登录已失效")) {
        showError("登录已失效，请重新登录");
        setTimeout(() => {
          localStorage.removeItem("token");
          localStorage.removeItem("user");
          localStorage.removeItem("role");
          router.replace("/login");
        }, 1500);
        return;
      }
      throw new Error(json?.msg || "加载失败");
    }

    timelineData.value = (json.data && json.data.items) || json.data || [];
  } catch (e) {
    console.error("加载时光轴失败", e);
    showError(e.message || "加载失败");
    timelineData.value = [];
  } finally {
    loading.value = false;
  }
}

async function loadDashboard() {
  loading.value = true;
  try {
    const resp = await apiFetch("/api/stats/dashboard");
    const json = await resp.json().catch(() => null);

    if (!resp.ok || !json || json.code !== 0) {
      // 检查是否是token失效问题
      if (json && (json.msg === "未登录" || json.msg === "登录已失效")) {
        showError("登录已失效，请重新登录");
        setTimeout(() => {
          localStorage.removeItem("token");
          localStorage.removeItem("user");
          localStorage.removeItem("role");
          router.replace("/login");
        }, 1500);
        return;
      }
      throw new Error(json?.msg || "加载失败");
    }

    dashboardData.value = json.data;
    await nextTick();
    initCharts();
  } catch (e) {
    console.error("加载看板失败", e);
    showError(e.message || "加载失败");
    dashboardData.value = null;
  } finally {
    loading.value = false;
  }
}

async function loadWordCloud() {
  loading.value = true;
  try {
    const resp = await apiFetch("/api/stats/wordcloud");
    const json = await resp.json().catch(() => null);

    if (!resp.ok || !json || json.code !== 0) {
      // 检查是否是token失效问题
      if (json && (json.msg === "未登录" || json.msg === "登录已失效")) {
        showError("登录已失效，请重新登录");
        setTimeout(() => {
          localStorage.removeItem("token");
          localStorage.removeItem("user");
          localStorage.removeItem("role");
          router.replace("/login");
        }, 1500);
        return;
      }
      throw new Error(json?.msg || "加载失败");
    }

    wordCloudData.value = (json.data && json.data.items) || json.data || [];
    await nextTick();
    initWordCloud();
  } catch (e) {
    console.error("加载词云失败", e);
    showError(e.message || "加载失败");
    wordCloudData.value = [];
  } finally {
    loading.value = false;
  }
}

function initCharts() {
  if (!dashboardData.value) return;

  // 趋势图
  const trendChart = echarts.init(document.getElementById("trendChart"));
  trendChart.setOption({
    title: { text: "作品数量趋势", left: "center", textStyle: { fontSize: 16, fontWeight: "bold" } },
    tooltip: { trigger: "axis" },
    xAxis: { type: "category", data: dashboardData.value.trendMonths || [] },
    yAxis: { type: "value" },
    series: [{
      data: dashboardData.value.trendData || [],
      type: "line",
      smooth: true,
      lineStyle: { color: "#d4af37", width: 2 },
      itemStyle: { color: "#d4af37" }
    }]
  });

  // 类型分布图
  const typeChart = echarts.init(document.getElementById("typeChart"));
  typeChart.setOption({
    title: { text: "诗词类型分布", left: "center", textStyle: { fontSize: 16, fontWeight: "bold" } },
    tooltip: { trigger: "item" },
    series: [{
      type: "pie",
      radius: "70%",
      data: dashboardData.value.typeDistribution || [],
      emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: "rgba(0, 0, 0, 0.5)" } }
    }]
  });

  // 互动率图
  const interactionChart = echarts.init(document.getElementById("interactionChart"));
  interactionChart.setOption({
    title: { text: "平均互动率", left: "center", textStyle: { fontSize: 16, fontWeight: "bold" } },
    tooltip: { trigger: "axis" },
    xAxis: { type: "category", data: ["点赞", "评论", "收藏"] },
    yAxis: { type: "value" },
    series: [{
      data: [
        dashboardData.value.avgLikes || 0,
        dashboardData.value.avgComments || 0,
        dashboardData.value.avgFav || 0
      ],
      type: "bar",
      itemStyle: { color: "#d4af37" }
    }]
  });
}

function initWordCloud() {
  if (wordCloudData.value.length === 0) return;

  const words = wordCloudData.value.map(w => [w.text, w.weight * 100]);

  // 创建古风配色方案 - 鎏金、朱砂、墨色系列
  const colors = [
    "#d4af37", "#b8860b", "#daa520", "#cd853f", "#d2691e",
    "#8b4513", "#a0522d", "#cd853f", "#deb887", "#f4a460",
    "#c94a4a", "#b8860b", "#d4af37", "#e6c288"
  ];

  WordCloud(document.getElementById("wordCloud"), {
    list: words,
    gridSize: 12,
    weightFactor: 5,
    fontFamily: '"思源宋体", "STSong", "SimSun", "KaiTi", "楷体", "STKaiti", serif',
    color: (word, weight, fontSize, distance, theta) => {
      return colors[Math.floor(Math.random() * colors.length)];
    },
    backgroundColor: "transparent",
    rotateRatio: 0.2,
    rotationSteps: 2,
    minRotation: -0.1,
    maxRotation: 0.1,
    shuffle: true,
    shrinkToFit: true,
    minFontSize: 16,
    maxFontSize: 60
  });
}

function formatNumber(num) {
  if (num >= 10000) return (num / 10000).toFixed(1) + "万";
  if (num >= 1000) return (num / 1000).toFixed(1) + "千";
  return num.toString();
}

function goToWork(id) {
  router.push(`/chuangzuo/${id}`);
}

function filterByWord(word) {
  alert(`筛选包含"${word}"的作品功能开发中...`);
}

async function reload() {
  await loadTabData();
}

onMounted(() => {
  if (!token.value) return router.replace("/login");
  loadTabData();
});
</script>

<style scoped>
.page {
  min-height: 100vh;
  background: radial-gradient(1200px 800px at 20% 10%, rgba(180, 200, 220, 0.08), transparent 60%),
              radial-gradient(900px 600px at 80% 20%, rgba(230, 220, 190, 0.12), transparent 55%),
              linear-gradient(135deg, #fdfbf7, #f5f3ef);
  position: relative
}

.page::before {
  content: "";
  position: fixed;
  inset: 0;
  background: url("@/assets/chuangzuo/竹.png");
  background-size: 25%;
  opacity: 0.06;
  pointer-events: none;
  z-index: -3
}

.head {
  max-width: none;
  width: 100%;
  padding: 24px 48px 16px;
  margin: 0;
  display: grid;
  grid-template-columns: 80px 1fr 100px;
  gap: 16px;
  align-items: center;
  position: sticky;
  top: 0;
  z-index: 40;
  background: linear-gradient(180deg, rgba(253,251,247,0.98), rgba(253,251,247,0.95), rgba(253,251,247,0));
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(212,175,55,0.1)
}

@media (min-width: 1600px) {
  .head { padding: 24px 64px 16px }
}

@media (min-width: 1200px) and (max-width: 1599px) {
  .head { padding: 24px 56px 16px }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .head { padding: 20px 32px 12px }
}

@media (max-width: 767px) {
  .head { padding: 16px; grid-template-columns: 60px 1fr 80px }
}

.back, .right {
  height: 40px;
  border-radius: 12px;
  border: 1px solid rgba(212,175,55,0.3);
  background: linear-gradient(135deg, rgba(253,249,242,0.9), rgba(246,240,230,0.8));
  cursor: pointer;
  font-weight: 900;
  color: #4a3b36;
  padding: 0 20px;
  transition: all 0.3s ease
}

.back:hover, .right:hover {
  background: linear-gradient(135deg, rgba(242,233,210,0.9), rgba(230,194,136,0.8));
  border-color: rgba(212,175,55,0.5);
  transform: translateY(-1px)
}

.right:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  background: rgba(200,200,200,0.2)
}

.title {
  text-align: center;
  font-weight: 900;
  letter-spacing: 2px;
  color: #3a2e2b;
  font-size: 24px;
  font-family: "思源宋体", "STSong", "SimSun", serif
}

.tabs {
  display: flex;
  justify-content: center;
  gap: 16px;
  padding: 20px 48px;
  position: sticky;
  top: 72px;
  z-index: 99;
  background: linear-gradient(180deg, rgba(253,251,247,0.95), transparent)
}

.tabBtn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 24px;
  border-radius: 999px;
  border: 2px solid rgba(212,175,55,0.3);
  background: rgba(255,255,255,0.8);
  cursor: pointer;
  font-weight: 900;
  color: #4a3b36;
  transition: all 0.3s ease;
  font-size: 15px
}

.tabBtn:hover {
  background: linear-gradient(135deg, rgba(242,233,210,0.9), rgba(230,194,136,0.8));
  border-color: rgba(212,175,55,0.5);
  transform: translateY(-2px)
}

.tabBtn.active {
  background: linear-gradient(135deg, #e6c288, #d4af37);
  border-color: #d4af37;
  color: #fff
}

.panel {
  max-width: none;
  width: 100%;
  padding: 0 48px;
  margin: 0 auto 20px
}

.panel > div {
  background: rgba(255,255,255,0.85);
  border: 1px solid rgba(212,175,55,0.15);
  border-radius: 18px;
  padding: 32px;
  box-shadow: 0 4px 16px rgba(212,175,55,0.08)
}

@media (min-width: 1600px) {
  .panel { padding: 0 64px }
}

@media (min-width: 1200px) and (max-width: 1599px) {
  .panel { padding: 0 56px }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .panel { padding: 0 32px }
}

@media (max-width: 767px) {
  .panel { padding: 0 16px }
}

.tabContent {
  min-height: 400px
}

.timelineControls {
  margin-bottom: 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  flex-wrap: wrap;
}

.viewToggle {
  display: flex;
  gap: 8px;
  background: rgba(255, 255, 255, 0.8);
  padding: 4px;
  border-radius: 12px;
  border: 1px solid rgba(212, 175, 55, 0.3);
  flex-wrap: wrap;
}

.viewBtn {
  padding: 8px 16px;
  border-radius: 8px;
  border: none;
  background: transparent;
  cursor: pointer;
  font-weight: 700;
  color: #4a3b36;
  font-size: 14px;
  transition: all 0.3s ease;
}

.viewBtn:hover {
  background: rgba(212, 175, 55, 0.1);
}

.viewBtn.active {
  background: linear-gradient(135deg, #e6c288, #d4af37);
  color: #fff;
  transform: scale(1.05);
}

.modeSelect {
  padding: 8px 16px;
  border-radius: 8px;
  border: 1px solid rgba(212,175,55,0.3);
  background: rgba(255,255,255,0.9);
  font-weight: 700;
  color: #4a3b36;
  cursor: pointer
}

.timeline3DWrapper {
  padding: 20px 0;
}

.timelineContainer {
  overflow-x: auto;
  padding: 20px 0
}

.timelineHorizontal {
  display: flex;
  gap: 24px;
  padding: 20px 0;
  min-width: max-content
}

.timelineNode {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  min-width: 180px;
  cursor: pointer;
  transition: all 0.3s ease
}

.timelineNode:hover {
  transform: translateY(-4px)
}

.nodeDate {
  font-size: 14px;
  color: #9d8b7a;
  font-weight: 700
}

.nodeMarker {
  width: 60px;
  height: 60px;
  border-radius: 999px;
  background: linear-gradient(135deg, rgba(212,175,55,0.2), rgba(184,134,11,0.1));
  border: 3px solid #d4af37;
  display: grid;
  place-items: center;
  position: relative;
  font-size: 24px
}

.badge {
  position: absolute;
  top: -8px;
  right: -8px;
  background: linear-gradient(135deg, #ff6b6b, #ff4757);
  color: white;
  font-size: 11px;
  padding: 2px 6px;
  border-radius: 999px;
  font-weight: 900;
  border: 2px solid #fff
}

.nodeContent {
  text-align: center
}

.workTitle {
  font-weight: 900;
  color: #3a2e2b;
  font-size: 15px;
  margin-bottom: 8px
}

.workStats {
  font-size: 13px;
  color: #9d8b7a;
  display: flex;
  gap: 6px;
  align-items: center;
  justify-content: center
}

.dot {
  color: rgba(212,175,55,0.3)
}

.dashboardGrid {
  display: grid;
  gap: 32px
}

.kpiCards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px
}

@media (max-width: 768px) {
  .kpiCards { grid-template-columns: 1fr }
}

.kpiCard {
  background: linear-gradient(135deg, rgba(212,175,55,0.1), rgba(184,134,11,0.05));
  border: 2px solid rgba(212,175,55,0.2);
  border-radius: 16px;
  padding: 24px;
  text-align: center;
  transition: all 0.3s ease
}

.kpiCard:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(212,175,55,0.15)
}

.kpiValue {
  font-size: 36px;
  font-weight: 900;
  color: #d4af37;
  margin-bottom: 8px;
  font-family: "Arial", sans-serif
}

.kpiLabel {
  font-size: 14px;
  color: #9d8b7a;
  font-weight: 700
}

.chartsContainer {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 24px
}

@media (max-width: 1024px) {
  .chartsContainer { grid-template-columns: 1fr }
}

.chart {
  background: rgba(255,255,255,0.6);
  border: 1px solid rgba(212,175,55,0.15);
  border-radius: 12px;
  padding: 16px;
  height: 350px
}

.wordcloudContainer {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 24px
}

.wordcloudCanvas {
  width: 100%;
  height: 450px;
  background: linear-gradient(135deg, rgba(255,255,255,0.8), rgba(253,249,242,0.9));
  border: 2px solid rgba(212,175,55,0.2);
  border-radius: 16px;
  position: relative;
  overflow: hidden
}

.wordcloudCanvas::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url("@/assets/chuangzuo/竹.png");
  background-size: 30%;
  opacity: 0.03;
  pointer-events: none
}

.wordcloudLegend {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  justify-content: center;
  max-width: 800px
}

.wordTag {
  padding: 10px 18px;
  border-radius: 999px;
  background: linear-gradient(135deg, rgba(212,175,55,0.15), rgba(184,134,11,0.1));
  border: 1px solid rgba(212,175,55,0.3);
  cursor: pointer;
  font-weight: 900;
  color: #4a3b36;
  transition: all 0.3s ease;
  font-size: 14px;
  font-family: "思源宋体", "STSong", "SimSun", "KaiTi", "楷体", serif
}

.wordTag:hover {
  background: linear-gradient(135deg, rgba(242,233,210,0.9), rgba(230,194,136,0.8));
  border-color: rgba(212,175,55,0.5);
  transform: scale(1.05)
}

.empty {
  padding: 60px 20px;
  text-align: center;
  background: rgba(255,255,255,0.6);
  border: 1px dashed rgba(212,175,55,0.2);
  border-radius: 20px;
  margin: 20px 0;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 24px;
}

.empty-illustration {
  width: 200px;
  height: 200px;
  opacity: 0.8;
}

.empty-svg {
  width: 100%;
  height: 100%;
  filter: drop-shadow(0 4px 12px rgba(212, 175, 55, 0.2));
}

.empty-text {
  text-align: center;
}

.empty-title {
  font-size: 20px;
  font-weight: 900;
  color: #3a2e2b;
  margin-bottom: 8px;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  letter-spacing: 1px;
}

.empty-subtitle {
  font-size: 14px;
  color: #9d8b7a;
  font-weight: 700;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

@media (max-width: 768px) {
  .title { font-size: 20px }
  .back, .right { height: 36px; padding: 0 16px }
  .tabs { padding: 16px 24px; flex-wrap: wrap }
  .tabBtn { padding: 10px 16px; font-size: 14px }
}
</style>