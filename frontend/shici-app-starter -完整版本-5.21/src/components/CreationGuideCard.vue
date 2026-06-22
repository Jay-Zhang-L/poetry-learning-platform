<template>
  <div
    class="guideCard"
    :style="cardStyle"
    @mouseenter="hoverCard = true"
    @mouseleave="hoverCard = false"
  >
    <!-- 细腻环面/光晕层 -->
    <div class="torusWrap" aria-hidden="true">
      <div class="torus t1"></div>
      <div class="torus t2"></div>
      <div class="torus t3"></div>
      <div class="spark s1"></div>
      <div class="spark s2"></div>
      <div class="spark s3"></div>
    </div>

    <!-- 卡片头部 -->
    <div class="cardHeader">
      <div class="tag">创作小提示</div>
    </div>

    <!-- 分类筛选Tab -->
    <div class="categoryTabs">
      <button
        v-for="cat in categories"
        :key="cat.key"
        class="categoryTab"
        :class="{ active: activeCategory === cat.key }"
        @click="switchCategory(cat.key)"
      >
        {{ cat.label }}
      </button>
    </div>

    <!-- 舞台区域 -->
    <div class="stage">
      <!-- 立体舞台光 -->
      <div class="light" aria-hidden="true"></div>
      <div class="mist" aria-hidden="true"></div>
      <div class="grain" aria-hidden="true"></div>

      <!-- 导师立绘 -->
      <div class="avatar3d" :style="avatarStyle">
        <img
          class="teacherImg"
          :src="currentTeacherImg"
          :style="{ filter: currentImageFilter, opacity: imageOpacity }"
          alt="创作导师"
          draggable="false"
        />
      </div>
    </div>

    <!-- 对话框区域 -->
    <div class="guideSection">
      <div class="guideTitle">创作引导</div>

      <button class="guideBubble" @click="fillGuide(currentSuggestions[0])">
        <span class="q">「</span>{{ currentSuggestions[0] }}<span class="q">」</span>
      </button>

      <button class="guideBubble" @click="fillGuide(currentSuggestions[1])">
        <span class="q">「</span>{{ currentSuggestions[1] }}<span class="q">」</span>
      </button>
    </div>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue';
import teacherPng from '../assets/teacher/teacher.png';

const emit = defineEmits(['selectGuide']);

const hoverCard = ref(false);

// 鼠标坐标（用于3D视差）
const mx = ref(0); // -1..1
const my = ref(0); // -1..1

// 分类配置
const categories = [
  { key: 'poem', label: '诗' },
  { key: 'ci', label: '词' },
  { key: 'fu', label: '赋' }
];

// 当前选中的分类
const activeCategory = ref('poem');

// 图片透明度（用于过渡动画）
const imageOpacity = ref(1);

// 各分类内容配置
const categoryContent = {
  poem: {
    image: teacherPng,
    filter: 'none',
    suggestions: [
      '如何开始创作诗词？从观察身边的事物开始',
      '试试以"春"为主题，写一首五言绝句'
    ]
  },
  ci: {
    image: teacherPng, // 临时使用同一图片，之后替换
    filter: 'hue-rotate(45deg) saturate(1.2)',
    suggestions: [
      '词有固定词牌，先选择一个词牌，如《浣溪沙》《菩萨蛮》',
      '按词牌格律填词，注意平仄和押韵，表达细腻情感'
    ]
  },
  fu: {
    image: teacherPng, // 临时使用同一图片，之后替换
    filter: 'sepia(0.3) hue-rotate(90deg)',
    suggestions: [
      '赋讲究铺陈排比，可以从景物描写入手，层层递进',
      '以赋体形式描述一处风景，注意辞藻华丽，句式整齐'
    ]
  }
};

// 当前内容
const currentContent = computed(() => {
  return categoryContent[activeCategory.value];
});

// 当前图片
const currentTeacherImg = computed(() => {
  return currentContent.value.image;
});

// 当前图片滤镜（用于区分不同类型）
const currentImageFilter = computed(() => {
  return currentContent.value.filter;
});

// 当前引导建议
const currentSuggestions = computed(() => {
  return currentContent.value.suggestions;
});

// 卡片3D视差样式
const cardStyle = computed(() => {
  const rx = (-my.value) * 6;
  const ry = (mx.value) * 10;
  const s = hoverCard.value ? 1.01 : 1;
  return {
    transform: `perspective(1000px) rotateX(${rx}deg) rotateY(${ry}deg) scale(${s})`,
  };
});

// 立绘层视差
const avatarStyle = computed(() => {
  const tx = mx.value * 10;
  const ty = my.value * 8;
  return { transform: `translate(${tx}px, ${ty}px)` };
});

// 瞳孔跟随
const pupilStyle = computed(() => {
  const px = Math.max(-1, Math.min(1, mx.value)) * 6;
  const py = Math.max(-1, Math.min(1, my.value)) * 4;
  return { transform: `translate(${px}px, ${py}px)` };
});

// 切换分类
function switchCategory(categoryKey) {
  if (activeCategory.value === categoryKey) return;

  // 淡出当前图片
  imageOpacity.value = 0;

  // 延迟后切换并淡入
  setTimeout(() => {
    activeCategory.value = categoryKey;
    imageOpacity.value = 1;
  }, 150);
}

// 选择引导
function fillGuide(text) {
  emit('selectGuide', text);
}

// 暴露鼠标移动方法给父组件
function updateMousePosition(x, y) {
  mx.value = x;
  my.value = y;
}

defineExpose({
  updateMousePosition
});
</script>

<style scoped>
/* ===== 立体卡片容器 ===== */
.guideCard {
  position: sticky;
  top: 20px;
  border-radius: 22px;
  padding: 14px;
  background: rgba(255, 255, 255, 0.58);
  border: 1px solid rgba(0, 0, 0, 0.06);
  backdrop-filter: blur(14px);
  box-shadow: 0 18px 52px rgba(0, 0, 0, 0.06);
  transform-style: preserve-3d;
  transition: transform 0.12s ease;
  overflow: hidden;
}

/* ===== 环面/光晕（完全复制墨墨老师效果） ===== */
.torusWrap {
  position: absolute;
  inset: -30%;
  pointer-events: none;
  opacity: 0.9;
}

.torus {
  position: absolute;
  left: 50%;
  top: 52%;
  width: 520px;
  height: 520px;
  border-radius: 999px;
  transform: translate(-50%, -50%);
  filter: blur(10px);
  opacity: 0.55;
  background: conic-gradient(
    from 180deg,
    rgba(70, 120, 100, 0),
    rgba(70, 120, 100, 0.22),
    rgba(210, 160, 120, 0.18),
    rgba(70, 120, 100, 0.20),
    rgba(70, 120, 100, 0)
  );
  mask: radial-gradient(circle at center, transparent 56%, #000 58%, #000 64%, transparent 66%);
  animation: torusSpin 14s linear infinite;
}

.torus.t2 {
  width: 420px;
  height: 420px;
  top: 58%;
  opacity: 0.35;
  filter: blur(14px);
  animation-duration: 18s;
  animation-direction: reverse;
}

.torus.t3 {
  width: 620px;
  height: 620px;
  top: 44%;
  opacity: 0.26;
  filter: blur(18px);
  animation-duration: 22s;
}

.spark {
  position: absolute;
  width: 8px;
  height: 8px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.85);
  box-shadow: 0 0 22px rgba(255, 255, 255, 0.65);
  opacity: 0.35;
  animation: spark 2.8s ease-in-out infinite;
}

.s1 { left: 40%; top: 40%; }
.s2 { left: 60%; top: 62%; animation-delay: 0.6s; }
.s3 { left: 52%; top: 30%; animation-delay: 1.2s; }

/* ===== 卡片头部 ===== */
.cardHeader {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
  position: relative;
  z-index: 2;
}

.tag {
  padding: 6px 10px;
  border-radius: 999px;
  background: rgba(0, 0, 0, 0.06);
  border: 1px solid rgba(0, 0, 0, 0.06);
  font-weight: 1000;
}

/* ===== 分类筛选Tab ===== */
.categoryTabs {
  display: flex;
  gap: 8px;
  margin-top: 8px;
  margin-bottom: 10px;
  position: relative;
  z-index: 2;
}

.categoryTab {
  flex: 1;
  padding: 8px 12px;
  border-radius: 12px;
  border: 1px solid rgba(0, 0, 0, 0.08);
  background: rgba(255, 255, 255, 0.6);
  cursor: pointer;
  font-weight: 900;
  font-size: 14px;
  transition: all 0.2s ease;
  color: var(--text);
}

.categoryTab:hover {
  background: rgba(255, 255, 255, 0.8);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
}

.categoryTab.active {
  background: rgba(60, 80, 70, 0.15);
  border-color: rgba(60, 80, 70, 0.25);
  box-shadow: 0 4px 12px rgba(60, 80, 70, 0.1);
}

.state {
  display: flex;
  gap: 8px;
  align-items: center;
}

.dot {
  width: 10px;
  height: 10px;
  border-radius: 999px;
  background: rgba(60, 160, 120, 0.65);
  box-shadow: 0 0 0 6px rgba(60, 160, 120, 0.12);
}

.dot.online {
  animation: pulse 1.1s ease-in-out infinite;
}

.txt {
  opacity: 0.7;
  font-weight: 900;
  font-size: 12px;
}

/* ===== 舞台区域 ===== */
.stage {
  position: relative;
  height: 240px;
  border-radius: 18px;
  border: 1px solid rgba(0, 0, 0, 0.06);
  overflow: hidden;
  background:
    radial-gradient(900px 300px at 45% 10%, rgba(220, 240, 230, 0.95), transparent 58%),
    radial-gradient(700px 280px at 70% 85%, rgba(240, 232, 220, 0.90), transparent 55%),
    linear-gradient(180deg, rgba(255, 255, 255, 0.84), rgba(255, 255, 255, 0.52));
  transform: translateZ(18px);
  z-index: 2;
}

.light {
  position: absolute;
  inset: -20%;
  background: radial-gradient(circle at 40% 20%, rgba(255, 255, 255, 0.75), transparent 55%);
  filter: blur(8px);
  opacity: 0.9;
  pointer-events: none;
}

.mist {
  position: absolute;
  inset: -20%;
  background:
    radial-gradient(circle at 25% 70%, rgba(255, 255, 255, 0.60), transparent 55%),
    radial-gradient(circle at 75% 35%, rgba(255, 255, 255, 0.55), transparent 55%);
  filter: blur(10px);
  opacity: 0.9;
  animation: drift 10s ease-in-out infinite;
  pointer-events: none;
}

.grain {
  position: absolute;
  inset: 0;
  background-image: radial-gradient(rgba(0, 0, 0, 0.08) 1px, transparent 1px);
  background-size: 22px 22px;
  opacity: 0.08;
  mix-blend-mode: multiply;
  pointer-events: none;
}

/* ===== 立绘容器 ===== */
.avatar3d {
  position: absolute;
  left: 50%;
  bottom: -10px;
  transform: translateX(-50%);
  width: 100%;
  height: 115%;
  display: flex;
  align-items: flex-end;
  justify-content: center;
  pointer-events: none;
  transform-style: preserve-3d;
}

.teacherImg {
  height: 120%;
  object-fit: contain;
  filter: drop-shadow(0 18px 42px rgba(0, 0, 0, 0.20));
  animation: float 3.8s ease-in-out infinite;
  user-select: none;
  transition: opacity 0.3s ease, filter 0.3s ease;
}

/* ===== 眼睛跟随 ===== */
.eyes {
  position: absolute;
  top: 86px;
  left: 50%;
  transform: translateX(-50%);
  width: 150px;
  display: flex;
  justify-content: space-between;
  gap: 26px;
  opacity: 0.55;
  mix-blend-mode: multiply;
}

.eye {
  width: 22px;
  height: 14px;
  border-radius: 999px;
  background: rgba(0, 0, 0, 0.10);
  border: 1px solid rgba(0, 0, 0, 0.12);
  position: relative;
  overflow: hidden;
}

.pupil {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 6px;
  height: 6px;
  border-radius: 999px;
  background: rgba(0, 0, 0, 0.55);
  transform: translate(-50%, -50%);
  transition: transform 0.06s linear;
}

/* ===== 引导区域 ===== */
.guideSection {
  margin-top: 12px;
  position: relative;
  z-index: 2;
}

.guideTitle {
  font-weight: 1000;
  margin-bottom: 8px;
}

.guideBubble {
  width: 100%;
  text-align: left;
  padding: 12px;
  border-radius: 16px;
  border: 1px solid rgba(0, 0, 0, 0.06);
  background: rgba(255, 255, 255, 0.72);
  cursor: pointer;
  font-weight: 900;
  line-height: 1.55;
  transition: all 0.16s ease;
  margin-bottom: 10px;
  animation: slideIn 0.3s ease;
}

.guideBubble:hover {
  transform: translateY(-1px);
  box-shadow: 0 16px 40px rgba(0, 0, 0, 0.08);
}

.q {
  opacity: 0.55;
  font-weight: 1000;
}

/* ===== 动画 ===== */
@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-8px); }
}

@keyframes drift {
  0%, 100% { transform: translate(0, 0); }
  50% { transform: translate(-16px, 10px); }
}

@keyframes pulse {
  0%, 100% { box-shadow: 0 0 0 6px rgba(60, 160, 120, 0.12); opacity: 1; }
  50% { box-shadow: 0 0 0 10px rgba(60, 160, 120, 0.08); opacity: 0.85; }
}

@keyframes torusSpin {
  from { transform: translate(-50%, -50%) rotate(0deg); }
  to { transform: translate(-50%, -50%) rotate(360deg); }
}

@keyframes spark {
  0%, 100% { transform: translateY(0); opacity: 0.25; }
  50% { transform: translateY(-10px); opacity: 0.45; }
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateX(-10px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}
</style>
