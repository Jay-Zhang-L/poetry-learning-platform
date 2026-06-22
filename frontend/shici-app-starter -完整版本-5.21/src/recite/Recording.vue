<template>
  <div class="recordingPage">
    <!-- 背景底纹 -->
    <div class="bgTexture"></div>

    <!-- 左侧山水背景 - 绝对定位 -->
    <div class="leftLandscape"></div>

    <!-- 左下角诗人 - 固定在山水图上 -->
    <div class="poetOnRock" @click="speakPoem">
      <img src="@/assets/luyin/shiren.png" alt="诗人" />
      <div class="speakHint" v-if="poem && !isRecording">
        {{ isSpeaking ? "点击暂停朗读" : "点击朗读诗词" }}
      </div>
      <div class="speakingWave" v-if="isSpeaking">
        <span></span><span></span><span></span>
      </div>
    </div>

    <!-- 右侧内容区域 -->
    <div class="rightContent">
      <div class="contentCard">
        <!-- 诗词区域 -->
        <div class="poemArea">
          <div class="poemCard" v-if="poem">
            <div class="poemHeader">
              <div class="poemInfo">
                <h1 class="poemTitle">{{ poem.title }}</h1>
                <p class="poemAuthor">{{ poem.author }}{{ poem.dynasty ? ` · ${poem.dynasty}` : '' }}</p>
              </div>
              <div class="poemActions">
                <button class="actionIcon" @click="router.push('/recite')" title="返回主页">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                    <polyline points="9 22 9 12 15 12 15 22"/>
                  </svg>
                </button>
                <button class="actionIcon" @click="showPoemSelector = true" :disabled="isRecording">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M1 4v6h6M23 20v-6h-6"/>
                    <path d="M20.49 9A9 9 0 0 0 5.64 5.64L1 10m22 4l-4.64 4.36A9 9 0 0 1 3.51 15"/>
                  </svg>
                </button>
              </div>
            </div>
            <div class="poemBody">
              <p v-for="(line, i) in poemLines" :key="i" class="poemLine">{{ line }}</p>
            </div>
          </div>
          
          <div class="poemPlaceholder" v-else @click="showPoemSelector = true">
            <div class="placeholderInner">
              <div class="placeholderIcon">
                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2">
                  <path d="M4 4h16v16H4z"/>
                  <path d="M8 2v4M16 2v4M8 20v2M16 20v2"/>
                  <path d="M8 8h8M8 12h6M8 16h4" stroke-linecap="round"/>
                </svg>
              </div>
              <p class="placeholderMain">请先选择一首诗词</p>
              <p class="placeholderSub">点击选择诗词</p>
            </div>
          </div>
        </div>

        <!-- 录音区域 -->
        <div class="recordArea">
          <!-- 计时器 -->
          <div class="timerArea">
            <div class="timerDisplay" :class="{ active: isRecording }">
              <span class="timerMinutes">{{ formatTime(recordingDuration).split(':')[0] }}</span>
              <span class="timerColon" :class="{ blink: isRecording }">:</span>
              <span class="timerSeconds">{{ formatTime(recordingDuration).split(':')[1] }}</span>
            </div>
            <div class="timerStatus" v-if="isRecording">录音中</div>
          </div>

          <!-- 波形图 -->
          <div class="waveformArea">
            <div class="waveformBox" :class="{ active: isRecording }">
              <canvas ref="waveformCanvas" class="waveformCanvas"></canvas>
              <div class="waveformPlaceholder" v-if="!isRecording && !audioBlob">
                <svg viewBox="0 0 600 40" preserveAspectRatio="none">
                  <path d="M0,20 Q50,16 100,22 Q150,26 200,18 Q250,12 300,23 Q350,28 400,17 Q450,10 500,24 Q550,30 600,20" 
                        fill="none" stroke="#C8B8A8" stroke-width="1.2" stroke-linecap="round" opacity="0.4"/>
                </svg>
              </div>
              <canvas ref="brushCanvas" class="brushCanvas" v-if="isRecording"></canvas>
            </div>
          </div>

          <!-- 录音按钮 -->
          <div class="recordButtonArea">
            <button
              class="recordMainBtn"
              :class="{ recording: isRecording, disabled: !poem }"
              @click="toggleRecording"
              :disabled="submitting || !poem"
            >
              <div class="recordBtnInner">
                <div class="recordIcon" v-if="!isRecording">
                  <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2">
                    <path d="M12 3C10.9 3 10 3.9 10 5v5c0 1.1 0.9 2 2 2s2-0.9 2-2V5c0-1.1-0.9-2-2-2z"/>
                    <path d="M17 11c0 2.8-2.2 5-5 5s-5-2.2-5-5M12 16v3M9 19h6"/>
                    <circle cx="12" cy="12" r="9" stroke="currentColor" fill="none"/>
                  </svg>
                </div>
                <div class="recordIcon stop" v-else>
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                    <rect x="6" y="6" width="12" height="12" rx="1"/>
                  </svg>
                </div>
              </div>
              <div class="recordRipple" v-if="isRecording"></div>
              <div class="recordRipple delay" v-if="isRecording"></div>
            </button>
            <p class="recordHint" :class="{ active: poem }">
              {{ isRecording ? "点击停止" : (poem ? "开始录音" : "请先选择诗词") }}
            </p>
          </div>

          <!-- 录音完成操作区 -->
          <transition name="slideUp">
            <div class="audioActionArea" v-if="audioBlob && !evaluationResult">
              <div class="audioPlayer">
                <button class="playBtn" @click="toggleAudioPlay">
                  <svg v-if="!isAudioPlaying" width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M8 5v14l11-7z"/>
                  </svg>
                  <svg v-else width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/>
                  </svg>
                </button>
                <div class="progressArea" @click="seekAudio">
                  <div class="progressBg">
                    <div class="progressFill" :style="{ width: audioProgress + '%' }"></div>
                  </div>
                </div>
                <div class="timeDisplay">
                  <span>{{ formatTime(audioCurrentTime) }}</span>
                  <span>/</span>
                  <span>{{ formatTime(audioDuration) }}</span>
                </div>
                <audio ref="audioPreviewRef" :src="audioPreviewUrl" @loadedmetadata="onAudioLoaded" @timeupdate="onAudioTimeUpdate" @ended="onAudioEnded" style="display:none;"></audio>
              </div>
              <div class="actionButtons">
                <button class="btnSecondary" @click="resetRecording" :disabled="submitting">
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                    <path d="M1 4v6h6M23 20v-6h-6"/>
                    <path d="M20.49 9A9 9 0 0 0 5.64 5.64L1 10m22 4l-4.64 4.36A9 9 0 0 1 3.51 15"/>
                  </svg>
                  <span>重新录制</span>
                </button>
                <button class="btnPrimary" @click="submitRecording" :disabled="submitting">
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                    <path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/>
                  </svg>
                  <span>{{ submitting ? "提交中" : "提交评价" }}</span>
                </button>
              </div>
            </div>
          </transition>

          <!-- 评价结果 -->
          <transition name="slideUp">
            <div class="evaluationArea" v-if="evaluationResult">
              <div class="evalHeader">
                <h3 class="evalTitle">AI 评价</h3>
                <span class="evalTime">{{ formatDateTime(evaluationResult.createdAt) }}</span>
              </div>

              <div class="scoreArea">
                <div class="overallScore">
                  <div class="scoreRing" :style="getScoreStyle(evaluationResult.overallScore)">
                    <span class="scoreNum">{{ evaluationResult.overallScore }}</span>
                  </div>
                  <span class="scoreLabel">综合评分</span>
                </div>
                <div class="detailScores">
                  <div class="scoreRow">
                    <span class="scoreName">清晰度</span>
                    <div class="scoreBar">
                      <div class="scoreFill clarity" :style="{ width: evaluationResult.clarityScore + '%' }"></div>
                    </div>
                    <span class="scoreValue">{{ evaluationResult.clarityScore }}</span>
                  </div>
                  <div class="scoreRow">
                    <span class="scoreName">节奏感</span>
                    <div class="scoreBar">
                      <div class="scoreFill rhythm" :style="{ width: evaluationResult.rhythmScore + '%' }"></div>
                    </div>
                    <span class="scoreValue">{{ evaluationResult.rhythmScore }}</span>
                  </div>
                  <div class="scoreRow">
                    <span class="scoreName">情感表达</span>
                    <div class="scoreBar">
                      <div class="scoreFill emotion" :style="{ width: evaluationResult.emotionScore + '%' }"></div>
                    </div>
                    <span class="scoreValue">{{ evaluationResult.emotionScore }}</span>
                  </div>
                </div>
              </div>

              <div class="evalBlock">
                <div class="evalLabel">语音识别</div>
                <p class="evalText">{{ evaluationResult.transcribedText || "无识别结果" }}</p>
              </div>

              <div class="evalBlock">
                <div class="evalLabel">AI 评价</div>
                <p class="evalText">{{ evaluationResult.aiEvaluation }}</p>
              </div>

              <div class="evalBlock">
                <div class="evalLabel">改进建议</div>
                <p class="evalText suggestion">{{ evaluationResult.aiSuggestion }}</p>
              </div>

              <div class="evalActions">
                <button class="btnSecondary" @click="resetAll">
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                    <path d="M1 4v6h6M23 20v-6h-6"/>
                    <path d="M20.49 9A9 9 0 0 0 5.64 5.64L1 10m22 4l-4.64 4.36A9 9 0 0 1 3.51 15"/>
                  </svg>
                  <span>重新录制</span>
                </button>
                <button class="btnPrimary" @click="router.push('/recite/recording/history')">
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                    <circle cx="12" cy="12" r="10"/>
                    <polyline points="12 6 12 12 16 14"/>
                  </svg>
                  <span>历史记录</span>
                </button>
              </div>
            </div>
          </transition>
        </div>
      </div>
    </div>

    <!-- 诗词选择器弹窗 -->
    <div class="modalMask" v-if="showPoemSelector" @click.self="showPoemSelector = false">
      <div class="modalContent">
        <div class="modalHeader">
          <h3 class="modalTitle">选择诗词</h3>
          <button class="closeBtn" @click="showPoemSelector = false">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
              <path d="M18 6L6 18M6 6l12 12"/>
            </svg>
          </button>
        </div>
        <div class="searchWrap">
          <div class="searchInputWrap">
            <svg class="searchIcon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
              <circle cx="11" cy="11" r="8"/>
              <path d="M21 21l-4.35-4.35"/>
            </svg>
            <input class="searchInput" v-model="poemSearchKeyword" placeholder="搜索诗词标题或作者" />
          </div>
        </div>
        <div class="filterSection">
          <div class="filterGroup">
            <div class="filterLabel">难度等级</div>
            <div class="filterChips">
              <button class="chip" :class="{ active: filterDifficulty === 0 }" @click="filterDifficulty = 0">全部</button>
              <button v-for="level in difficultyLevels" :key="level.value" class="chip" :class="{ active: filterDifficulty === level.value }" @click="filterDifficulty = level.value">{{ level.label }}</button>
            </div>
          </div>
          <div class="filterGroup">
            <div class="filterLabel">情感类型</div>
            <div class="filterChips">
              <button class="chip" :class="{ active: filterEmotion === '' }" @click="filterEmotion = ''">全部</button>
              <button v-for="emotion in emotionTypes" :key="emotion" class="chip" :class="{ active: filterEmotion === emotion }" @click="filterEmotion = emotion">{{ emotion }}</button>
            </div>
          </div>
        </div>
        <div class="poemList">
          <div v-if="poemLoading" class="emptyBox">
            <div class="loadingSpinner"></div>
            <span>加载中...</span>
          </div>
          <template v-else>
            <div class="poemItem" v-for="p in filteredPoems" :key="p.id" :class="{ selected: poem?.id === p.id }" @click="selectPoem(p)">
              <div class="poemItemMain">
                <div class="poemItemTitle">{{ p.title }}</div>
                <div class="poemItemMeta">{{ p.author }} · {{ p.dynasty || "" }}</div>
              </div>
              <div class="poemItemTags">
                <span v-if="p.difficultyLevel" class="tag difficulty" :class="'level' + p.difficultyLevel">{{ getDifficultyLabel(p.difficultyLevel) }}</span>
                <span v-if="p.emotionType" class="tag emotion">{{ p.emotionType }}</span>
              </div>
            </div>
          </template>
          <div class="emptyBox" v-if="!poemLoading && !filteredPoems.length">
            <span>暂无匹配结果</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Toast -->
    <transition name="fade">
      <div class="toastWrap" v-if="toast.show">
        <div class="toast" :class="toast.type">
          <svg v-if="toast.type === 'success'" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
            <polyline points="22 4 12 14.01 9 11.01"/>
          </svg>
          <svg v-else-if="toast.type === 'error'" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="10"/>
            <line x1="15" y1="9" x2="9" y2="15"/>
            <line x1="9" y1="9" x2="15" y2="15"/>
          </svg>
          <span>{{ toast.message }}</span>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref, watch } from "vue";
import { useRouter } from "vue-router";
import { submitReciteRecording, getRecitePoems } from "@/utils/api";

const router = useRouter();

// 诗词数据
const poem = ref(null);
const showPoemSelector = ref(false);
const poemSearchKeyword = ref("");
const poemList = ref([]);
const poemLoading = ref(false);

// 朗读相关
const isSpeaking = ref(false);
let speechSynthesis = null;
let speechUtterance = null;

// 筛选状态
const filterDifficulty = ref(0);
const filterEmotion = ref("");

const difficultyLevels = [
  { value: 1, label: "入门" },
  { value: 2, label: "初级" },
  { value: 3, label: "中级" },
  { value: 4, label: "高级" },
  { value: 5, label: "挑战" },
];

const emotionTypes = ["思乡", "爱国", "山水", "送别", "边塞", "春景", "秋景", "豪放"];

const getDifficultyLabel = (level) => {
  const item = difficultyLevels.find(l => l.value === level);
  return item ? item.label : "";
};

const speakPoem = (event) => {
  event.stopPropagation();
  if (!poem.value) {
    showToast("请先选择一首诗词", "warning");
    return;
  }
  
  if (isRecording.value) {
    showToast("录音中无法朗读，请先停止录音", "warning");
    return;
  }
  
  if (isSpeaking.value) {
    if (window.speechSynthesis) {
      window.speechSynthesis.cancel();
    }
    isSpeaking.value = false;
    speechUtterance = null;
    return;
  }
  
  const poemTitle = poem.value.title;
  const poemAuthor = `${poem.value.author}${poem.value.dynasty ? `，${poem.value.dynasty}` : ''}`;
  const poemContent = poem.value.content || poem.value.line || "";
  
  let cleanContent = poemContent
    .replace(/[，]/g, '， ')
    .replace(/[。]/g, '。 ')
    .replace(/[！]/g, '！ ')
    .replace(/[？]/g, '？ ')
    .replace(/[；]/g, '； ')
    .trim();
  
  const speakText = `${poemTitle}。 ${poemAuthor}。 ${cleanContent}`;
  
  if (!window.speechSynthesis) {
    showToast("您的浏览器不支持语音朗读功能", "error");
    return;
  }
  
  try {
    window.speechSynthesis.cancel();
    
    speechUtterance = new SpeechSynthesisUtterance(speakText);
    speechUtterance.lang = "zh-CN";
    speechUtterance.rate = 0.85;
    speechUtterance.pitch = 1.15;
    speechUtterance.volume = 1;
    
    const setVoice = () => {
      const voices = window.speechSynthesis.getVoices();
      const chineseVoice = voices.find(voice => 
        voice.lang === 'zh-CN' && 
        (voice.name.includes('Tingting') || 
         voice.name.includes('Yating') ||
         voice.name.includes('Xiaoxiao') ||
         voice.name.includes('Yunyang') ||
         voice.name.includes('自然'))
      ) || voices.find(voice => 
        voice.lang.includes('zh-CN') || 
        voice.lang.includes('zh')
      );
      
      if (chineseVoice && speechUtterance) {
        speechUtterance.voice = chineseVoice;
      }
    };
    
    if (window.speechSynthesis.getVoices().length > 0) {
      setVoice();
    } else {
      window.speechSynthesis.onvoiceschanged = setVoice;
    }
    
    speechUtterance.onstart = () => {
      isSpeaking.value = true;
    };
    
    speechUtterance.onend = () => {
      isSpeaking.value = false;
      speechUtterance = null;
    };
    
    speechUtterance.onerror = (err) => {
      console.error("朗读出错:", err);
      isSpeaking.value = false;
      speechUtterance = null;
      showToast("朗读失败，请重试", "error");
    };
    
    window.speechSynthesis.speak(speechUtterance);
    
  } catch (err) {
    console.error("朗读出错:", err);
    showToast("朗读失败，请重试", "error");
    isSpeaking.value = false;
  }
};

const stopSpeaking = () => {
  if (window.speechSynthesis) {
    window.speechSynthesis.cancel();
  }
  isSpeaking.value = false;
  speechUtterance = null;
};

// 录音状态
const isRecording = ref(false);
const recordingDuration = ref(0);
const audioBlob = ref(null);
const audioPreviewUrl = ref("");
const audioPreviewRef = ref(null);
const waveformCanvas = ref(null);
const brushCanvas = ref(null);

// 音频播放器状态
const isAudioPlaying = ref(false);
const audioCurrentTime = ref(0);
const audioDuration = ref(0);
const audioProgress = computed(() => {
  if (audioDuration.value === 0) return 0;
  return (audioCurrentTime.value / audioDuration.value) * 100;
});

// 录音相关变量
let recordingTimer = null;
let audioContext = null;
let analyser = null;
let dataArray = null;
let animationId = null;
let stream = null;
let scriptProcessor = null;
let recordedBuffers = [];
const TARGET_SAMPLE_RATE = 16000;

// 提交状态
const submitting = ref(false);
const evaluationResult = ref(null);

// Toast 提示
const toast = ref({ show: false, message: "", type: "info" });

const showToast = (message, type = "info") => {
  toast.value = { show: true, message, type };
  setTimeout(() => {
    toast.value.show = false;
  }, 3000);
};

// 计算属性
const poemLines = computed(() => {
  if (!poem.value?.line && !poem.value?.content) return [];
  const text = poem.value.line || poem.value.content || "";
  return text.split(/[，。！？、；]/g).filter(line => line.trim());
});

const filteredPoems = computed(() => {
  return poemList.value.slice(0, 50);
});

// 加载诗词列表
const loadPoems = async () => {
  poemLoading.value = true;
  try {
    const params = {
      keyword: poemSearchKeyword.value.trim() || undefined,
      page: 1,
      size: 50,
    };
    if (filterDifficulty.value > 0) params.difficultyLevel = filterDifficulty.value;
    if (filterEmotion.value) params.emotionType = filterEmotion.value;
    
    const res = await getRecitePoems(params);
    const data = res?.data || res || {};
    const list = data?.items || data?.rows || data?.list || data?.records || [];
    
    poemList.value = list.map(p => ({
      ...p,
      id: p.id || p.poemId,
      title: p.title,
      author: p.poetName || p.author,
      dynasty: p.dynasty,
      content: p.content,
      line: p.content
    }));
  } catch (e) {
    console.error("加载诗词列表失败:", e);
    poemList.value = [];
  } finally {
    poemLoading.value = false;
  }
};

let searchTimer = null;
watch(poemSearchKeyword, () => {
  if (searchTimer) clearTimeout(searchTimer);
  searchTimer = setTimeout(() => loadPoems(), 300);
});

watch([filterDifficulty, filterEmotion], () => loadPoems());

onMounted(() => loadPoems());

const formatTime = (seconds) => {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return `${mins.toString().padStart(2, "0")}:${secs.toString().padStart(2, "0")}`;
};

const formatDateTime = (dateStr) => {
  if (!dateStr) return "";
  const date = new Date(dateStr);
  return date.toLocaleString("zh-CN");
};

const getScoreStyle = (score) => {
  const angle = (score / 100) * 360;
  let color = "#C85A5A";
  if (score < 60) color = "#B8A898";
  else if (score < 80) color = "#D4A880";
  return {
    background: `conic-gradient(${color} ${angle}deg, #E8E0D8 ${angle}deg)`,
  };
};

const selectPoem = (p) => {
  stopSpeaking();
  poem.value = p;
  showPoemSelector.value = false;
  evaluationResult.value = null;
  resetRecording();
};

// 水墨笔触波形绘制
const drawBrushWaveform = () => {
  if (!analyser || !brushCanvas.value) return;

  const canvas = brushCanvas.value;
  const ctx = canvas.getContext("2d");
  
  const dpr = window.devicePixelRatio || 1;
  const rect = canvas.getBoundingClientRect();
  canvas.width = rect.width * dpr;
  canvas.height = rect.height * dpr;
  ctx.scale(dpr, dpr);
  
  const width = rect.width;
  const height = rect.height;

  const draw = () => {
    if (!isRecording.value) return;

    animationId = requestAnimationFrame(draw);
    analyser.getByteFrequencyData(dataArray);

    ctx.clearRect(0, 0, width, height);
    
    const step = Math.floor(dataArray.length / width);
    ctx.beginPath();
    ctx.moveTo(0, height / 2);
    
    for (let x = 0; x < width; x++) {
      const index = Math.floor(x * step);
      const value = dataArray[index] || 0;
      const y = height / 2 + (value - 128) / 255 * (height * 0.35);
      ctx.lineTo(x, y);
    }
    
    const gradient = ctx.createLinearGradient(0, 0, width, 0);
    gradient.addColorStop(0, "#C85A5A");
    gradient.addColorStop(0.5, "#D4A880");
    gradient.addColorStop(1, "#C85A5A");
    
    ctx.strokeStyle = gradient;
    ctx.lineWidth = 2.5;
    ctx.lineCap = "round";
    ctx.shadowBlur = 4;
    ctx.shadowColor = "rgba(200, 90, 90, 0.2)";
    ctx.stroke();
    
    ctx.beginPath();
    ctx.moveTo(0, height / 2 + 3);
    for (let x = 0; x < width; x++) {
      const index = Math.floor(x * step);
      const value = dataArray[index] || 0;
      const y = height / 2 + 3 + (value - 128) / 255 * (height * 0.2);
      ctx.lineTo(x, y);
    }
    ctx.strokeStyle = "rgba(200, 90, 90, 0.25)";
    ctx.lineWidth = 1.5;
    ctx.stroke();
    
    ctx.shadowBlur = 0;
  };

  draw();
};

// 录音相关
const startRecording = async () => {
  try {
    stream = await navigator.mediaDevices.getUserMedia({ audio: true });
    
    audioContext = new (window.AudioContext || window.webkitAudioContext)();
    const originalSampleRate = audioContext.sampleRate;
    
    analyser = audioContext.createAnalyser();
    const source = audioContext.createMediaStreamSource(stream);
    source.connect(analyser);
    analyser.fftSize = 512;
    dataArray = new Uint8Array(analyser.frequencyBinCount);

    const bufferSize = 4096;
    scriptProcessor = audioContext.createScriptProcessor(bufferSize, 1, 1);
    recordedBuffers = [];
    
    scriptProcessor.onaudioprocess = (event) => {
      const inputData = event.inputBuffer.getChannelData(0);
      const resampledData = resampleToTarget(inputData, originalSampleRate, TARGET_SAMPLE_RATE);
      recordedBuffers.push(new Float32Array(resampledData));
    };
    
    source.connect(scriptProcessor);
    scriptProcessor.connect(audioContext.destination);
    
    isRecording.value = true;
    recordingDuration.value = 0;

    recordingTimer = setInterval(() => {
      recordingDuration.value++;
      if (recordingDuration.value >= 60) {
        stopRecording();
        showToast("录音时长已达上限（60秒）", "warning");
      }
    }, 1000);

    drawBrushWaveform();

  } catch (err) {
    console.error("无法获取麦克风权限：", err);
    showToast("无法获取麦克风权限，请检查浏览器设置", "error");
  }
};

const resampleToTarget = (inputData, inputRate, outputRate) => {
  if (inputRate === outputRate) return inputData;
  const ratio = inputRate / outputRate;
  const outputLength = Math.floor(inputData.length / ratio);
  const output = new Float32Array(outputLength);
  for (let i = 0; i < outputLength; i++) {
    output[i] = inputData[Math.floor(i * ratio)];
  }
  return output;
};

const stopRecording = () => {
  if (scriptProcessor) {
    scriptProcessor.disconnect();
    scriptProcessor = null;
  }
  if (recordingTimer) clearInterval(recordingTimer);
  if (animationId) cancelAnimationFrame(animationId);
  if (stream) stream.getTracks().forEach(track => track.stop());
  if (audioContext) audioContext.close();
  
  isRecording.value = false;
  
  if (recordedBuffers.length > 0) {
    const wavBlob = createWavFromBuffers(recordedBuffers, TARGET_SAMPLE_RATE);
    audioBlob.value = wavBlob;
    audioPreviewUrl.value = URL.createObjectURL(wavBlob);
  }
};

const createWavFromBuffers = (buffers, sampleRate) => {
  let totalLength = buffers.reduce((sum, buf) => sum + buf.length, 0);
  const samples = new Float32Array(totalLength);
  let offset = 0;
  for (const buf of buffers) {
    samples.set(buf, offset);
    offset += buf.length;
  }
  return encodeWav(samples, sampleRate);
};

const toggleRecording = () => {
  if (!poem.value) {
    showToast("请先选择要朗诵的诗词", "warning");
    return;
  }
  if (isRecording.value) stopRecording();
  else startRecording();
};

const encodeWav = (samples, sampleRate) => {
  const buffer = new ArrayBuffer(44 + samples.length * 2);
  const view = new DataView(buffer);
  
  const writeString = (offset, str) => {
    for (let i = 0; i < str.length; i++) view.setUint8(offset + i, str.charCodeAt(i));
  };
  
  writeString(0, "RIFF");
  view.setUint32(4, 36 + samples.length * 2, true);
  writeString(8, "WAVE");
  writeString(12, "fmt ");
  view.setUint32(16, 16, true);
  view.setUint16(20, 1, true);
  view.setUint16(22, 1, true);
  view.setUint32(24, sampleRate, true);
  view.setUint32(28, sampleRate * 2, true);
  view.setUint16(32, 2, true);
  view.setUint16(34, 16, true);
  writeString(36, "data");
  view.setUint32(40, samples.length * 2, true);
  
  for (let i = 0; i < samples.length; i++) {
    const s = Math.max(-1, Math.min(1, samples[i]));
    view.setInt16(44 + i * 2, s < 0 ? s * 0x8000 : s * 0x7FFF, true);
  }
  
  return new Blob([buffer], { type: "audio/wav" });
};

const resetRecording = () => {
  if (audioPreviewRef.value) {
    audioPreviewRef.value.pause();
    audioPreviewRef.value.currentTime = 0;
  }
  isAudioPlaying.value = false;
  audioCurrentTime.value = 0;
  audioDuration.value = 0;
  if (audioPreviewUrl.value) URL.revokeObjectURL(audioPreviewUrl.value);
  audioBlob.value = null;
  audioPreviewUrl.value = "";
  recordingDuration.value = 0;
};

const submitRecording = async () => {
  if (!audioBlob.value || !poem.value) {
    showToast("请先完成录音", "warning");
    return;
  }
  submitting.value = true;
  try {
    const result = await submitReciteRecording({
      poemId: poem.value.id,
      poemTitle: poem.value.title,
      poemContent: poem.value.content,
      audio: audioBlob.value,
      audioDuration: recordingDuration.value,
    });
    evaluationResult.value = result?.data || result;
    showToast("评价完成！", "success");
  } catch (err) {
    showToast(err.message || "提交失败，请稍后重试", "error");
  } finally {
    submitting.value = false;
  }
};

const resetAll = () => {
  resetRecording();
  evaluationResult.value = null;
  isAudioPlaying.value = false;
  audioCurrentTime.value = 0;
  audioDuration.value = 0;
};

const toggleAudioPlay = () => {
  if (!audioPreviewRef.value) return;
  if (isAudioPlaying.value) audioPreviewRef.value.pause();
  else audioPreviewRef.value.play();
  isAudioPlaying.value = !isAudioPlaying.value;
};

const onAudioLoaded = () => {
  if (audioPreviewRef.value) audioDuration.value = Math.floor(audioPreviewRef.value.duration);
};

const onAudioTimeUpdate = () => {
  if (audioPreviewRef.value) audioCurrentTime.value = Math.floor(audioPreviewRef.value.currentTime);
};

const onAudioEnded = () => {
  isAudioPlaying.value = false;
  audioCurrentTime.value = 0;
};

const seekAudio = (event) => {
  if (!audioPreviewRef.value || audioDuration.value === 0) return;
  const rect = event.currentTarget.getBoundingClientRect();
  const percentage = (event.clientX - rect.left) / rect.width;
  audioPreviewRef.value.currentTime = percentage * audioDuration.value;
  audioCurrentTime.value = Math.floor(audioPreviewRef.value.currentTime);
};

onBeforeUnmount(() => {
  stopRecording();
  stopSpeaking();
  if (audioPreviewUrl.value) URL.revokeObjectURL(audioPreviewUrl.value);
});
</script>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

@import url('https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@300;400;500;600;700;900&display=swap');

/* 整个页面作为滚动容器 */
.recordingPage {
  min-height: 100vh;
  background: #F5F0EB;
  position: relative;
  font-family: 'Noto Serif SC', '思源宋体', serif;
  padding-top: 0;
}

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
  z-index: -1;
}

/* 左侧山水背景 - 固定不滚动 */
.leftLandscape {
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  width: 30%;
  background-image: url('@/assets/luyin/shangshui.png');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  pointer-events: none;
  z-index: 0;
  opacity: 0.85;
}

/* 诗人 - 固定在山水图上，不滚动 */
.poetOnRock {
  position: fixed;
  left: calc(30% * 0.6);
  bottom: 40px;
  z-index: 10;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  align-items: center;
  transition: all 0.3s;
  transform: translateX(-50%);
}

.poetOnRock img {
  width: 70px;
  height: auto;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.2));
  transition: all 0.3s;
}

.poetOnRock:hover img {
  transform: translateY(-3px);
  filter: drop-shadow(0 8px 16px rgba(200, 90, 90, 0.25));
}

.poetOnRock .speakHint {
  position: absolute;
  top: -30px;
  left: 50%;
  transform: translateX(-50%);
  background: #C85A5A;
  color: #fff;
  font-size: 10px;
  padding: 3px 10px;
  white-space: nowrap;
  opacity: 0;
  transition: opacity 0.3s;
  pointer-events: none;
  font-family: system-ui, sans-serif;
}

.poetOnRock:hover .speakHint {
  opacity: 0.9;
}

.poetOnRock .speakingWave {
  position: absolute;
  top: -20px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 3px;
}

.poetOnRock .speakingWave span {
  width: 3px;
  height: 10px;
  background: #C85A5A;
  animation: waveSmall 0.5s infinite;
}

.poetOnRock .speakingWave span:nth-child(1) { animation-delay: 0s; }
.poetOnRock .speakingWave span:nth-child(2) { animation-delay: 0.15s; }
.poetOnRock .speakingWave span:nth-child(3) { animation-delay: 0.3s; }

@keyframes waveSmall {
  0%, 100% { height: 6px; }
  50% { height: 14px; }
}

/* 右侧内容 - 可滚动 */
.rightContent {
  margin-left: 30%;
  width: 70%;
  padding: 20px 40px 80px 40px;
  position: relative;
  z-index: 2;
  min-height: 100vh;
}

.contentCard {
  background: rgba(255, 253, 249, 0.96);
  border-left: 1px solid #E8E0D8;
  padding: 28px 32px;
}

/* 诗词区域 */
.poemArea {
  border-bottom: 1px solid #E8E0D8;
  padding-bottom: 24px;
  margin-bottom: 24px;
}

.poemHeader {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20px;
  flex-wrap: wrap;
  gap: 12px;
}

.poemInfo {
  flex: 1;
}

.poemTitle {
  font-size: 28px;
  font-weight: 700;
  color: #3C2A1E;
  margin: 0 0 8px;
  letter-spacing: 2px;
}

.poemAuthor {
  font-size: 13px;
  color: #8A7A6A;
  margin: 0;
}

.poemActions {
  display: flex;
  gap: 10px;
}

.actionIcon {
  width: 36px;
  height: 36px;
  border: none;
  background: rgba(200, 90, 90, 0.08);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
  color: #5A4A3A;
}

.actionIcon:hover {
  background: #C85A5A;
  color: #fff;
}

.actionIcon:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.poemBody {
  text-align: center;
  padding: 16px 8px;
}

.poemLine {
  font-size: 16px;
  line-height: 2.2;
  color: #3C2A1E;
  font-weight: 500;
  letter-spacing: 2px;
  margin: 0;
}

/* 占位符 */
.poemPlaceholder {
  cursor: pointer;
  text-align: center;
  padding: 40px 20px;
  border: 1px solid #E8E0D8;
  background: rgba(255, 253, 249, 0.8);
  transition: all 0.2s;
}

.poemPlaceholder:hover {
  border-color: #C8B8A8;
  transform: translateY(-2px);
}

.placeholderIcon {
  margin-bottom: 16px;
  color: #C8B8A8;
}

.placeholderMain {
  font-size: 16px;
  color: #8A7A6A;
  margin: 0 0 8px;
}

.placeholderSub {
  font-size: 12px;
  color: #C85A5A;
  margin: 0;
}

/* 录音区域 */
.recordArea {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 28px;
}

.timerArea {
  text-align: center;
}

.timerDisplay {
  font-size: 72px;
  font-weight: 300;
  color: #3C2A1E;
  letter-spacing: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.timerDisplay.active {
  color: #C85A5A;
}

.timerColon {
  margin: 0 6px;
}

.timerColon.blink {
  animation: blink 1s infinite;
}

@keyframes blink {
  0%, 50% { opacity: 1; }
  51%, 100% { opacity: 0.3; }
}

.timerStatus {
  font-size: 11px;
  color: #C85A5A;
  margin-top: 6px;
  letter-spacing: 2px;
}

.waveformArea {
  width: 100%;
}

.waveformBox {
  position: relative;
  width: 100%;
  height: 90px;
  overflow: hidden;
  background: rgba(200, 90, 90, 0.02);
  border: 1px solid #E8E0D8;
}

.waveformBox.active {
  border-color: #C85A5A;
  box-shadow: 0 0 0 2px rgba(200, 90, 90, 0.08);
}

.waveformCanvas {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  opacity: 0;
}

.brushCanvas {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

.waveformPlaceholder {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 24px;
}

.waveformPlaceholder svg {
  width: 100%;
  height: 100%;
}

.recordButtonArea {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}

.recordMainBtn {
  position: relative;
  width: 100px;
  height: 100px;
  border: none;
  background: transparent;
  cursor: pointer;
  padding: 0;
  transition: all 0.2s;
}

.recordMainBtn:hover:not(.disabled) {
  transform: scale(1.04);
}

.recordMainBtn.disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.recordBtnInner {
  width: 100%;
  height: 100%;
  background: #C85A5A;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 20px rgba(200, 90, 90, 0.35);
  transition: all 0.2s;
}

.recordBtnInner:hover {
  background: #B04848;
}

.recordMainBtn.recording .recordBtnInner {
  background: #3C2A1E;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
}

.recordIcon {
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
}

.recordIcon.stop {
  color: #C85A5A;
}

.recordIcon.stop svg {
  fill: #C85A5A;
}

.recordHint {
  font-size: 13px;
  color: #8A7A6A;
  letter-spacing: 1px;
}

.recordHint.active {
  color: #C85A5A;
}

.recordRipple {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 100%;
  height: 100%;
  border: 1.5px solid rgba(200, 90, 90, 0.4);
  transform: translate(-50%, -50%);
  animation: rippleExpand 2s infinite;
}

.recordRipple.delay {
  animation-delay: 0.6s;
}

@keyframes rippleExpand {
  0% {
    transform: translate(-50%, -50%) scale(1);
    opacity: 0.5;
  }
  100% {
    transform: translate(-50%, -50%) scale(1.5);
    opacity: 0;
  }
}

/* 音频操作区 */
.audioActionArea {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.audioPlayer {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 10px 20px;
  background: rgba(200, 90, 90, 0.03);
  border: 1px solid #E8E0D8;
}

.playBtn {
  width: 40px;
  height: 40px;
  border: none;
  background: #C85A5A;
  color: #fff;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}

.playBtn:hover {
  background: #B04848;
}

.progressArea {
  flex: 1;
  cursor: pointer;
}

.progressBg {
  width: 100%;
  height: 3px;
  background: #E8E0D8;
  overflow: hidden;
}

.progressFill {
  height: 100%;
  background: #C85A5A;
  transition: width 0.1s linear;
}

.timeDisplay {
  font-size: 12px;
  color: #8A7A6A;
  white-space: nowrap;
  min-width: 75px;
  text-align: right;
}

.actionButtons {
  display: flex;
  gap: 12px;
}

.btnSecondary, .btnPrimary {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  padding: 10px 16px;
  border: none;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  font-family: system-ui, sans-serif;
}

.btnSecondary {
  background: rgba(200, 90, 90, 0.06);
  color: #5A4A3A;
  border: 1px solid #E8E0D8;
}

.btnSecondary:hover:not(:disabled) {
  background: rgba(200, 90, 90, 0.12);
  transform: translateY(-1px);
}

.btnPrimary {
  background: #C85A5A;
  color: #fff;
  box-shadow: 0 2px 10px rgba(200, 90, 90, 0.3);
}

.btnPrimary:hover:not(:disabled) {
  background: #B04848;
  transform: translateY(-1px);
}

.btnSecondary:disabled, .btnPrimary:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* 评价区域 */
.evaluationArea {
  width: 100%;
  margin-top: 8px;
  padding-top: 20px;
  border-top: 1px solid #E8E0D8;
}

.evalHeader {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  flex-wrap: wrap;
  gap: 8px;
}

.evalTitle {
  font-size: 18px;
  font-weight: 700;
  color: #3C2A1E;
  margin: 0;
}

.evalTime {
  font-size: 11px;
  color: #A89888;
}

.scoreArea {
  display: flex;
  gap: 28px;
  padding: 16px;
  background: rgba(200, 90, 90, 0.03);
  margin-bottom: 20px;
  flex-wrap: wrap;
}

.overallScore {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
}

.scoreRing {
  width: 85px;
  height: 85px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
}

.scoreRing::before {
  content: "";
  position: absolute;
  width: 68px;
  height: 68px;
  background: rgba(255, 253, 249, 0.96);
  border-radius: 50%;
}

.scoreNum {
  position: relative;
  font-size: 28px;
  font-weight: 700;
  color: #3C2A1E;
}

.scoreLabel {
  font-size: 11px;
  color: #8A7A6A;
}

.detailScores {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 10px;
  min-width: 160px;
}

.scoreRow {
  display: flex;
  align-items: center;
  gap: 12px;
}

.scoreName {
  font-size: 11px;
  color: #8A7A6A;
  width: 55px;
}

.scoreBar {
  flex: 1;
  height: 4px;
  background: #E8E0D8;
  overflow: hidden;
}

.scoreFill {
  height: 100%;
  transition: width 0.5s;
}

.scoreFill.clarity { background: #C85A5A; }
.scoreFill.rhythm { background: #D4A880; }
.scoreFill.emotion { background: #B89888; }

.scoreValue {
  font-size: 12px;
  font-weight: 600;
  color: #3C2A1E;
  width: 35px;
  text-align: right;
}

.evalBlock {
  margin-bottom: 18px;
}

.evalLabel {
  font-size: 12px;
  font-weight: 600;
  color: #5A4A3A;
  margin-bottom: 8px;
  padding-left: 10px;
  border-left: 2px solid #C85A5A;
}

.evalText {
  padding: 12px 16px;
  font-size: 13px;
  line-height: 1.6;
  margin: 0;
  background: rgba(200, 90, 90, 0.03);
  border: 1px solid #F0E8E0;
  color: #5A4A3A;
}

.evalText.suggestion {
  background: rgba(200, 90, 90, 0.01);
}

.evalActions {
  display: flex;
  gap: 12px;
  margin-top: 20px;
  padding-top: 16px;
  border-top: 1px dashed #E8E0D8;
}

/* 弹窗样式 */
.modalMask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(60, 42, 30, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  backdrop-filter: blur(4px);
}

.modalContent {
  background: #FFFDF9;
  width: 90%;
  max-width: 480px;
  max-height: 85vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
  border: 1px solid #E8E0D8;
}

.modalHeader {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid #F0E8E0;
}

.modalTitle {
  font-size: 16px;
  font-weight: 700;
  color: #3C2A1E;
  margin: 0;
}

.closeBtn {
  width: 32px;
  height: 32px;
  border: none;
  background: rgba(200, 90, 90, 0.06);
  color: #8A7A6A;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}

.closeBtn:hover {
  background: rgba(200, 90, 90, 0.12);
  color: #C85A5A;
}

.searchWrap {
  padding: 14px 16px;
  border-bottom: 1px solid #F0E8E0;
}

.searchInputWrap {
  position: relative;
  display: flex;
  align-items: center;
}

.searchIcon {
  position: absolute;
  left: 14px;
  color: #B8A898;
}

.searchInput {
  width: 100%;
  padding: 10px 14px 10px 40px;
  border: 1px solid #E8E0D8;
  background: #FFF;
  font-size: 13px;
  color: #3C2A1E;
  outline: none;
}

.searchInput:focus {
  border-color: #C85A5A;
  box-shadow: 0 0 0 2px rgba(200, 90, 90, 0.1);
}

.filterSection {
  padding: 12px 16px;
  border-bottom: 1px solid #F0E8E0;
}

.filterGroup {
  margin-bottom: 10px;
}

.filterGroup:last-child {
  margin-bottom: 0;
}

.filterLabel {
  font-size: 11px;
  font-weight: 600;
  color: #8A7A6A;
  margin-bottom: 6px;
}

.filterChips {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.chip {
  padding: 4px 12px;
  border: 1px solid #E8E0D8;
  background: #FFF;
  font-size: 11px;
  font-weight: 500;
  color: #8A7A6A;
  cursor: pointer;
  transition: all 0.2s;
}

.chip:hover {
  background: rgba(200, 90, 90, 0.06);
  color: #C85A5A;
}

.chip.active {
  background: #C85A5A;
  color: #FFF;
  border-color: #C85A5A;
}

.poemList {
  flex: 1;
  overflow-y: auto;
  padding: 8px;
}

.poemItem {
  padding: 10px 14px;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 10px;
  margin-bottom: 4px;
  border: 1px solid transparent;
}

.poemItem:hover {
  background: rgba(200, 90, 90, 0.04);
  border-color: #F0E8E0;
}

.poemItem.selected {
  background: rgba(200, 90, 90, 0.08);
  border-color: #E0D0C0;
}

.poemItemTitle {
  font-size: 14px;
  font-weight: 600;
  color: #3C2A1E;
}

.poemItemMeta {
  font-size: 11px;
  color: #8A7A6A;
  margin-top: 2px;
}

.poemItemTags {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
}

.poemItemTags .tag {
  padding: 2px 8px;
  font-size: 9px;
  font-weight: 500;
}

.poemItemTags .tag.difficulty.level1 { background: rgba(200, 90, 90, 0.08); color: #C85A5A; }
.poemItemTags .tag.difficulty.level2 { background: rgba(200, 90, 90, 0.12); color: #B04848; }
.poemItemTags .tag.difficulty.level3 { background: rgba(200, 90, 90, 0.16); color: #983838; }
.poemItemTags .tag.difficulty.level4 { background: rgba(200, 90, 90, 0.2); color: #802828; }
.poemItemTags .tag.difficulty.level5 { background: rgba(200, 90, 90, 0.24); color: #681818; }
.poemItemTags .tag.emotion { background: rgba(200, 90, 90, 0.06); color: #B89888; }

.emptyBox {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 10px;
  padding: 40px 16px;
  color: #B8A898;
}

.loadingSpinner {
  width: 28px;
  height: 28px;
  border: 2px solid #E8E0D8;
  border-top-color: #C85A5A;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
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
  gap: 8px;
  padding: 10px 20px;
  font-size: 13px;
  font-weight: 500;
  color: #fff;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

.toast.info { background: #8A7A6A; }
.toast.success { background: #C85A5A; }
.toast.warning { background: #D4A880; }
.toast.error { background: #B04848; }

/* 动画 */
.fade-enter-active, .fade-leave-active { transition: opacity 0.3s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

.slideUp-enter-active, .slideUp-leave-active { transition: all 0.3s; }
.slideUp-enter-from, .slideUp-leave-to { opacity: 0; transform: translateY(16px); }

/* 直角风格统一 */
.contentCard, .poemPlaceholder, .waveformBox,
.audioPlayer, .btnSecondary, .btnPrimary,
.actionIcon, .recordBtnInner, .playBtn,
.scoreRing, .scoreRing::before, .modalContent,
.chip, .searchInput, .toast {
  border-radius: 0px !important;
}

/* 响应式 */
@media (max-width: 900px) {
  .rightContent { padding: 16px 28px 60px 28px; }
  .poetOnRock { left: 18%; }
  .poetOnRock img { width: 60px; }
}

@media (max-width: 768px) {
  .leftLandscape { width: 100%; opacity: 0.35; }
  .rightContent { margin-left: 0; width: 100%; padding: 16px 20px 50px 20px; }
  .contentCard { padding: 20px; }
  
  .poemTitle { font-size: 22px; }
  .poemLine { font-size: 14px; }
  .timerDisplay { font-size: 52px; letter-spacing: 4px; }
  .waveformBox { height: 70px; }
  .recordMainBtn { width: 80px; height: 80px; }
  
  .scoreArea { flex-direction: column; align-items: center; }
  .overallScore { margin-bottom: 12px; }
  .evalActions, .actionButtons { flex-direction: column; }
  
  .poetOnRock { left: 50px; bottom: 20px; transform: none; }
  .poetOnRock img { width: 50px; }
}
</style>