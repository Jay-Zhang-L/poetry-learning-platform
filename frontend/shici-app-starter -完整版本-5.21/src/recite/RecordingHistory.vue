<template>
  <div class="historyPage">
    <!-- 背景底纹 -->
    <div class="bgTexture"></div>

    <!-- 页面内容 - 正常滚动 -->
    <div class="normalContent">
      <!-- 页面头部 -->
      <div class="pageHeader">
        <div class="headerLeft">
          <button class="backBtn" @click="router.back()">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M15 18l-6-6 6-6"/>
            </svg>
          </button>
          <div class="headerInfo">
            <div class="pageTitle">录音评价记录</div>
            <div class="pageSub">查看你的朗诵录音历史和AI评价</div>
          </div>
        </div>
        <div class="headerRight">
          <button class="btn primary" @click="router.push('/recite/recording')">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <circle cx="12" cy="12" r="10"/>
              <polygon points="12 6 12 12 16 14" fill="currentColor"/>
            </svg>
            <span>开始录音</span>
          </button>
        </div>
      </div>

      <!-- 筛选栏 -->
      <div class="filterBar" v-if="!poemIdFilter">
        <div class="filterTabs">
          <button
            class="filterTab"
            :class="{ active: sortType === 'time' }"
            @click="sortType = 'time'"
          >
            按时间排序
          </button>
          <button
            class="filterTab"
            :class="{ active: sortType === 'score' }"
            @click="sortType = 'score'"
          >
            按评分排序
          </button>
        </div>
      </div>

      <!-- 记录列表 -->
      <div class="recordList">
        <div v-if="loading" class="loadingBox">
          <div class="loadingSpinner"></div>
          <div class="loadingText">加载中...</div>
        </div>

        <div v-else-if="!recordList.length" class="emptyBox">
          <div class="emptyIcon">🎙️</div>
          <div class="emptyTitle">暂无录音记录</div>
          <div class="emptyDesc">开始录制你的朗诵，获取AI评价吧</div>
          <button class="btn primary" @click="router.push('/recite/recording')">
            开始录音
          </button>
        </div>

        <template v-else>
          <div
            class="recordCard"
            v-for="record in sortedList"
            :key="record.id"
            @click="showDetail(record)"
          >
            <div class="cardHeader">
              <div class="poemInfo">
                <div class="poemTitle">{{ record.poemTitle || "未知诗词" }}</div>
                <div class="recordTime">{{ formatDateTime(record.createdAt) }}</div>
              </div>
              <div class="scoreBadge" :class="getScoreClass(record.overallScore)">
                {{ record.overallScore }}分
              </div>
            </div>

            <div class="cardBody">
              <div class="scoreRow">
                <div class="scoreItem">
                  <span class="scoreLabel">清晰度</span>
                  <span class="scoreValue">{{ record.clarityScore }}</span>
                </div>
                <div class="scoreItem">
                  <span class="scoreLabel">节奏感</span>
                  <span class="scoreValue">{{ record.rhythmScore }}</span>
                </div>
                <div class="scoreItem">
                  <span class="scoreLabel">情感表达</span>
                  <span class="scoreValue">{{ record.emotionScore }}</span>
                </div>
              </div>

              <div class="durationInfo" v-if="record.audioDuration">
                ⏱ 录音时长：{{ formatDuration(record.audioDuration) }}
              </div>
            </div>

            <div class="cardActions">
              <button class="actionBtn" @click.stop="playAudio(record)">
                ▶ 播放录音
              </button>
              <button class="actionBtn danger" @click.stop="confirmDelete(record)">
                🗑 删除
              </button>
            </div>
          </div>
        </template>
      </div>
    </div>

    <!-- 详情弹窗 -->
    <div class="modalMask" v-if="selectedRecord" @click.self="selectedRecord = null">
      <div class="modalContent detailModal">
        <div class="modalHeader">
          <div class="modalTitle">评价详情</div>
          <button class="closeBtn" @click="selectedRecord = null">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
              <path d="M18 6L6 18M6 6l12 12"/>
            </svg>
          </button>
        </div>

        <div class="modalBody">
          <div class="detailHeader">
            <div class="detailPoem">{{ selectedRecord.poemTitle }}</div>
            <div class="detailTime">{{ formatDateTime(selectedRecord.createdAt) }}</div>
          </div>

          <div class="detailScores">
            <div class="overallScoreWrap">
              <div class="scoreRing" :style="getScoreStyle(selectedRecord.overallScore)">
                <span class="scoreNum">{{ selectedRecord.overallScore }}</span>
              </div>
              <div class="scoreLabel">综合评分</div>
            </div>

            <div class="detailScoreList">
              <div class="detailScoreItem">
                <span class="detailScoreName">清晰度</span>
                <div class="detailScoreBar">
                  <div class="detailScoreFill" :style="{ width: selectedRecord.clarityScore + '%' }"></div>
                </div>
                <span class="detailScoreVal">{{ selectedRecord.clarityScore }}</span>
              </div>
              <div class="detailScoreItem">
                <span class="detailScoreName">节奏感</span>
                <div class="detailScoreBar">
                  <div class="detailScoreFill" :style="{ width: selectedRecord.rhythmScore + '%' }"></div>
                </div>
                <span class="detailScoreVal">{{ selectedRecord.rhythmScore }}</span>
              </div>
              <div class="detailScoreItem">
                <span class="detailScoreName">情感表达</span>
                <div class="detailScoreBar">
                  <div class="detailScoreFill" :style="{ width: selectedRecord.emotionScore + '%' }"></div>
                </div>
                <span class="detailScoreVal">{{ selectedRecord.emotionScore }}</span>
              </div>
            </div>
          </div>

          <div class="detailSection" v-if="selectedRecord.transcribedText">
            <div class="detailSectionTitle">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <path d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z"/>
                <path d="M19 10v2a7 7 0 0 1-14 0v-2M12 19v4M8 23h8"/>
              </svg>
              语音识别结果
            </div>
            <div class="detailSectionContent transcribed">
              {{ selectedRecord.transcribedText }}
            </div>
          </div>

          <div class="detailSection" v-if="selectedRecord.aiEvaluation">
            <div class="detailSectionTitle">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
              </svg>
              AI 评价
            </div>
            <div class="detailSectionContent evaluation">
              {{ selectedRecord.aiEvaluation }}
            </div>
          </div>

          <div class="detailSection" v-if="selectedRecord.aiSuggestion">
            <div class="detailSectionTitle">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <circle cx="12" cy="12" r="10"/>
                <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3M12 17h.01"/>
              </svg>
              改进建议
            </div>
            <div class="detailSectionContent suggestion">
              {{ selectedRecord.aiSuggestion }}
            </div>
          </div>

          <div class="detailAudio" v-if="selectedRecord.audioUrl">
            <audio
              ref="detailAudioRef"
              :src="toMediaUrl(selectedRecord.audioUrl)"
              controls
              class="audioPlayer"
            ></audio>
          </div>
        </div>

        <div class="modalFooter">
          <button class="btn ghost" @click="selectedRecord = null">关闭</button>
          <button class="btn danger" @click="confirmDelete(selectedRecord)">删除记录</button>
        </div>
      </div>
    </div>

    <!-- 删除确认弹窗 -->
    <div class="modalMask" v-if="deleteTarget" @click.self="deleteTarget = null">
      <div class="modalContent confirmModal">
        <div class="confirmIcon">⚠️</div>
        <div class="confirmTitle">确认删除</div>
        <div class="confirmDesc">删除后将无法恢复，确定要删除这条录音记录吗？</div>
        <div class="confirmActions">
          <button class="btn ghost" @click="deleteTarget = null">取消</button>
          <button class="btn danger" @click="executeDelete" :disabled="deleting">
            {{ deleting ? "删除中..." : "确认删除" }}
          </button>
        </div>
      </div>
    </div>

    <!-- Toast 提示 -->
    <div class="toastWrap" v-if="toast.show">
      <div class="toast" :class="toast.type">
        <svg v-if="toast.type === 'success'" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
          <polyline points="22 4 12 14.01 9 11.01"/>
        </svg>
        <svg v-else-if="toast.type === 'error'" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <circle cx="12" cy="12" r="10"/>
          <line x1="15" y1="9" x2="9" y2="15"/>
          <line x1="9" y1="9" x2="15" y2="15"/>
        </svg>
        <span>{{ toast.message }}</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import { useRouter, useRoute } from "vue-router";
import {
  getReciteRecordingList,
  getReciteRecordingByPoem,
  deleteReciteRecording,
} from "@/utils/api";

const router = useRouter();
const route = useRoute();

const mediaBase = "http://localhost:8080";

const recordList = ref([]);
const loading = ref(false);
const sortType = ref("time");
const selectedRecord = ref(null);
const deleteTarget = ref(null);
const deleting = ref(false);
const detailAudioRef = ref(null);

const toast = ref({ show: false, message: "", type: "info" });

const showToast = (message, type = "info") => {
  toast.value = { show: true, message, type };
  setTimeout(() => {
    toast.value.show = false;
  }, 3000);
};

const poemIdFilter = computed(() => route.query.poemId);

const sortedList = computed(() => {
  const list = [...recordList.value];
  if (sortType.value === "score") {
    return list.sort((a, b) => (b.overallScore || 0) - (a.overallScore || 0));
  }
  return list.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
});

const formatDateTime = (dateStr) => {
  if (!dateStr) return "";
  const date = new Date(dateStr);
  return date.toLocaleString("zh-CN", {
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });
};

const formatDuration = (seconds) => {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return `${mins}分${secs}秒`;
};

const getScoreClass = (score) => {
  if (score >= 90) return "excellent";
  if (score >= 80) return "good";
  if (score >= 60) return "pass";
  return "fail";
};

const getScoreStyle = (score) => {
  const angle = (score / 100) * 360;
  let color = "#C85A5A";
  if (score < 60) color = "#A08070";
  else if (score < 80) color = "#D4A880";
  return {
    background: `conic-gradient(${color} ${angle}deg, #E8E0D8 ${angle}deg)`,
  };
};

const toMediaUrl = (url) => {
  if (!url) return "";
  if (/^https?:\/\//i.test(url)) return url;
  if (url.startsWith("/files/")) return `${mediaBase}${url}`;
  return url;
};

const loadRecords = async () => {
  loading.value = true;
  try {
    let res;
    if (poemIdFilter.value) {
      res = await getReciteRecordingByPoem(poemIdFilter.value);
    } else {
      res = await getReciteRecordingList();
    }
    recordList.value = res?.data || res || [];
  } catch (err) {
    console.error("加载录音记录失败：", err);
    showToast("加载失败，请稍后重试", "error");
    recordList.value = [];
  } finally {
    loading.value = false;
  }
};

const showDetail = (record) => {
  selectedRecord.value = record;
};

const playAudio = (record) => {
  if (record.audioUrl) {
    const audio = new Audio(toMediaUrl(record.audioUrl));
    audio.play().catch(err => {
      console.error("播放失败：", err);
      showToast("播放失败", "error");
    });
  } else {
    showToast("该记录没有录音文件", "warning");
  }
};

const confirmDelete = (record) => {
  deleteTarget.value = record;
};

const executeDelete = async () => {
  if (!deleteTarget.value) return;

  deleting.value = true;
  try {
    await deleteReciteRecording(deleteTarget.value.id);
    recordList.value = recordList.value.filter(r => r.id !== deleteTarget.value.id);
    if (selectedRecord.value?.id === deleteTarget.value.id) {
      selectedRecord.value = null;
    }
    deleteTarget.value = null;
    showToast("删除成功", "success");
  } catch (err) {
    console.error("删除失败：", err);
    showToast("删除失败，请稍后重试", "error");
  } finally {
    deleting.value = false;
  }
};

onMounted(loadRecords);
</script>

<style scoped>
/* 全局字体 */
@import url('https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@300;400;500;600;700;900&display=swap');

* {
  font-family: 'Noto Serif SC', '思源宋体', 'Source Han Serif', '宋体', serif;
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

/* 页面容器 - 正常滚动 */
.historyPage {
  min-height: 100vh;
  background: #F5F0EB;
}

/* 背景纹理 */
.bgTexture {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 800 600'%3E%3Cpath d='M100,100 Q150,80 200,120 Q250,160 300,100 Q350,50 400,110 Q450,170 500,90 Q550,30 600,100 Q650,150 700,80' fill='none' stroke='%23D4C4B4' stroke-width='0.5' opacity='0.15'/%3E%3Cpath d='M50,400 Q120,380 180,420 Q240,460 300,390 Q360,340 420,410 Q480,470 540,380 Q600,310 660,400 Q720,470 780,370' fill='none' stroke='%23D4C4B4' stroke-width='0.5' opacity='0.12'/%3E%3C/svg%3E");
  background-repeat: repeat;
  background-size: 400px 300px;
  opacity: 0.4;
  z-index: 0;
}

/* 正常内容区域 - 占满全屏，无空白 */
.normalContent {
  position: relative;
  z-index: 1;
  width: 100%;
}

/* 页面头部 */
.pageHeader {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  background: #FFFDF9;
  border-bottom: 1px solid #E8E0D8;
}

.headerLeft {
  display: flex;
  align-items: center;
  gap: 16px;
}

.backBtn {
  width: 40px;
  height: 40px;
  border: 1px solid #E8E0D8;
  background: rgba(255, 255, 255, 0.8);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #5A4A3A;
}

.backBtn:hover {
  background: rgba(200, 90, 90, 0.08);
  border-color: #C85A5A;
  color: #C85A5A;
}

.pageTitle {
  font-size: 22px;
  font-weight: 700;
  color: #3C2A1E;
}

.pageSub {
  font-size: 13px;
  color: #8A7A6A;
  margin-top: 4px;
}

/* 筛选栏 */
.filterBar {
  padding: 12px 24px;
  background: #FFFDF9;
  border-bottom: 1px solid #E8E0D8;
}

.filterTabs {
  display: flex;
  gap: 10px;
}

.filterTab {
  padding: 8px 20px;
  border: 1px solid #E8E0D8;
  background: rgba(255, 255, 255, 0.6);
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  color: #5A4A3A;
}

.filterTab.active {
  background: #C85A5A;
  color: white;
  border-color: #C85A5A;
}

/* 记录列表 */
.recordList {
  display: flex;
  flex-direction: column;
}

.recordCard {
  padding: 20px 24px;
  cursor: pointer;
  background: #FFFDF9;
  border-bottom: 1px solid #E8E0D8;
}

.recordCard:hover {
  background: rgba(200, 90, 90, 0.02);
}

.cardHeader {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 16px;
}

.poemTitle {
  font-size: 18px;
  font-weight: 700;
  color: #3C2A1E;
}

.recordTime {
  font-size: 12px;
  color: #A89888;
  margin-top: 4px;
}

.scoreBadge {
  padding: 4px 12px;
  font-size: 13px;
  font-weight: 600;
}

.scoreBadge.excellent {
  background: #C85A5A;
  color: white;
}

.scoreBadge.good {
  background: #D4A880;
  color: white;
}

.scoreBadge.pass {
  background: #B89888;
  color: white;
}

.scoreBadge.fail {
  background: #A08070;
  color: white;
}

.cardBody {
  margin-bottom: 16px;
}

.scoreRow {
  display: flex;
  gap: 32px;
}

.scoreItem {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
}

.scoreLabel {
  font-size: 11px;
  color: #A89888;
}

.scoreValue {
  font-size: 18px;
  font-weight: 700;
  color: #5A4A3A;
}

.durationInfo {
  margin-top: 12px;
  font-size: 12px;
  color: #B8A898;
}

.cardActions {
  display: flex;
  gap: 12px;
  padding-top: 16px;
  border-top: 1px solid #F0E8E0;
}

.actionBtn {
  padding: 6px 16px;
  border: 1px solid #E8E0D8;
  background: rgba(255, 255, 255, 0.8);
  font-size: 12px;
  cursor: pointer;
  color: #5A4A3A;
}

.actionBtn:hover {
  background: rgba(200, 90, 90, 0.08);
}

.actionBtn.danger {
  color: #C85A5A;
}

.actionBtn.danger:hover {
  background: rgba(200, 90, 90, 0.1);
}

.loadingBox,
.emptyBox {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  background: #FFFDF9;
  text-align: center;
}

.loadingSpinner {
  width: 40px;
  height: 40px;
  border: 2px solid #E8E0D8;
  border-top-color: #C85A5A;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loadingText {
  margin-top: 16px;
  color: #8A7A6A;
}

.emptyIcon {
  font-size: 48px;
  margin-bottom: 16px;
  opacity: 0.6;
}

.emptyTitle {
  font-size: 18px;
  font-weight: 600;
  color: #3C2A1E;
  margin-bottom: 8px;
}

.emptyDesc {
  font-size: 13px;
  color: #8A7A6A;
  margin-bottom: 24px;
}

/* 按钮 */
.btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 8px 20px;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  border: none;
}

.btn.primary {
  background: #C85A5A;
  color: white;
}

.btn.primary:hover {
  background: #B04848;
}

.btn.ghost {
  background: rgba(200, 90, 90, 0.06);
  color: #5A4A3A;
  border: 1px solid #E8E0D8;
}

.btn.ghost:hover {
  background: rgba(200, 90, 90, 0.1);
}

.btn.danger {
  background: #C85A5A;
  color: white;
}

.btn.danger:hover {
  background: #B04848;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* 弹窗 */
.modalMask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(60, 42, 30, 0.5);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modalContent {
  background: #FFFDF9;
  border-radius: 12px;
  max-height: 90vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
  border: 1px solid #E8E0D8;
}

.detailModal {
  width: 90%;
  max-width: 600px;
}

.confirmModal {
  width: 90%;
  max-width: 380px;
  padding: 32px;
  text-align: center;
}

.modalHeader {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  border-bottom: 1px solid #F0E8E0;
}

.modalTitle {
  font-size: 18px;
  font-weight: 700;
  color: #3C2A1E;
}

.closeBtn {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: none;
  background: rgba(200, 90, 90, 0.06);
  color: #8A7A6A;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.closeBtn:hover {
  background: rgba(200, 90, 90, 0.12);
  color: #C85A5A;
}

.modalBody {
  padding: 24px;
  overflow-y: auto;
}

.detailHeader {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  margin-bottom: 24px;
  flex-wrap: wrap;
  gap: 8px;
}

.detailPoem {
  font-size: 20px;
  font-weight: 700;
  color: #3C2A1E;
}

.detailTime {
  font-size: 12px;
  color: #A89888;
}

.detailScores {
  display: grid;
  grid-template-columns: 120px 1fr;
  gap: 24px;
  padding: 20px;
  background: rgba(200, 90, 90, 0.03);
  margin-bottom: 24px;
}

.overallScoreWrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.scoreRing {
  width: 88px;
  height: 88px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
}

.scoreRing::before {
  content: "";
  position: absolute;
  width: 70px;
  height: 70px;
  background: #FFFDF9;
  border-radius: 50%;
}

.scoreNum {
  position: relative;
  font-size: 26px;
  font-weight: 700;
  color: #3C2A1E;
}

.detailScoreList {
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 12px;
}

.detailScoreItem {
  display: grid;
  grid-template-columns: 60px 1fr 36px;
  align-items: center;
  gap: 12px;
}

.detailScoreName {
  font-size: 12px;
  color: #8A7A6A;
  font-weight: 500;
}

.detailScoreBar {
  height: 5px;
  background: #E8E0D8;
  border-radius: 3px;
  overflow: hidden;
}

.detailScoreFill {
  height: 100%;
  background: #C85A5A;
  border-radius: 3px;
}

.detailScoreVal {
  font-size: 13px;
  font-weight: 600;
  text-align: right;
  color: #5A4A3A;
}

.detailSection {
  margin-bottom: 20px;
}

.detailSectionTitle {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  font-weight: 600;
  color: #5A4A3A;
  margin-bottom: 10px;
  padding-left: 12px;
  border-left: 2px solid #C85A5A;
}

.detailSectionTitle svg {
  color: #C85A5A;
}

.detailSectionContent {
  padding: 14px 16px;
  font-size: 13px;
  line-height: 1.7;
}

.detailSectionContent.transcribed {
  background: rgba(200, 90, 90, 0.03);
  color: #5A4A3A;
  border: 1px solid #F0E8E0;
}

.detailSectionContent.evaluation {
  background: rgba(200, 90, 90, 0.04);
  color: #C85A5A;
  border: 1px solid #F0E8E0;
}

.detailSectionContent.suggestion {
  background: rgba(200, 90, 90, 0.02);
  color: #5A4A3A;
  border: 1px solid #F0E8E0;
}

.detailAudio {
  margin-top: 20px;
}

.audioPlayer {
  width: 100%;
}

.modalFooter {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 24px;
  border-top: 1px solid #F0E8E0;
}

.confirmIcon {
  font-size: 48px;
  margin-bottom: 16px;
}

.confirmTitle {
  font-size: 18px;
  font-weight: 700;
  color: #3C2A1E;
  margin-bottom: 8px;
}

.confirmDesc {
  font-size: 13px;
  color: #8A7A6A;
  margin-bottom: 24px;
}

.confirmActions {
  display: flex;
  justify-content: center;
  gap: 12px;
}

/* Toast */
.toastWrap {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 2000;
}

.toast {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 24px;
  font-size: 13px;
  font-weight: 500;
  color: white;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
}

.toast.info {
  background: #8A7A6A;
}

.toast.success {
  background: #C85A5A;
}

.toast.warning {
  background: #D4A880;
}

.toast.error {
  background: #B04848;
}

/* 响应式 */
@media (max-width: 768px) {
  .pageHeader {
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
    padding: 16px;
  }

  .headerRight {
    width: 100%;
  }

  .headerRight .btn {
    width: 100%;
    justify-content: center;
  }

  .scoreRow {
    flex-wrap: wrap;
    gap: 16px;
  }

  .recordCard {
    padding: 16px;
  }

  .filterBar {
    padding: 12px 16px;
  }
}
</style>