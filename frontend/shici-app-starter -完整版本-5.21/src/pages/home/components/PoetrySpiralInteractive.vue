<!-- src/pages/home/components/PoetrySpiralInteractive.vue -->
<template>
  <div class="spiralRoot">
    <svg style="position: absolute; width: 0; height: 0;">
      <defs>
        <filter id="mosaic" x="-20%" y="-20%" width="140%" height="140%">
          <feTurbulence type="fractalNoise" baseFrequency="0.8" numOctaves="4" result="noise" />
          <feDisplacementMap in="SourceGraphic" in2="noise" scale="8" xChannelSelector="R" yChannelSelector="G" />
        </filter>
        <filter id="mosaic-heavy" x="-20%" y="-20%" width="140%" height="140%">
          <feTurbulence type="fractalNoise" baseFrequency="0.5" numOctaves="4" result="noise" />
          <feDisplacementMap in="SourceGraphic" in2="noise" scale="15" xChannelSelector="R" yChannelSelector="G" />
        </filter>
      </defs>
    </svg>

    <div ref="wrapRef" class="wrap" @wheel="onWheel">
      <div class="ribbon" aria-hidden="true">
        <span class="rail rail1"></span>
        <span class="rail rail2"></span>
        <span class="railGlow"></span>
      </div>

      <div class="stage3d" :style="stageStyle">
        <div
          v-for="(it, i) in items"
          :key="it.id ?? i"
          class="card3d"
          :class="{ active: i === activeIdx }"
          :style="cardStyle(i)"
          @click.stop="onCardClick(i)"
        >
          <div class="paperGlow" aria-hidden="true"></div>

          <div class="paperCard" :style="paperBgStyle">
            <div class="paperLight" aria-hidden="true"></div>

            <div class="cardSeal" v-if="it.tag">{{ it.tag }}</div>

            <div class="verseWrap">
              <div class="authorCol">
                <span class="authorText">
                  {{ it.author || "佚名" }}<span v-if="it.dynasty">·{{ it.dynasty }}</span>
                </span>
              </div>

              <div class="verseCols">
                <div v-for="(seg, idx) in getLineColumns(it)" :key="idx" class="verseCol">
                  {{ seg }}
                </div>
              </div>
            </div>

            <div class="cardBottomTip">点击查看详情</div>
          </div>
        </div>
      </div>

      <div ref="blankRef" class="blank" :style="blankStyle">
        <div class="blankOverlay"></div>

        <div class="blankInner">
          <div class="blankTextPanel">
            <div class="blankEyebrow">诗词长廊</div>

            <h1 :class="['title-text', 'blankTitle', { 'title-clear': titleClear }]">
              景中藏诗，诗里绘景
            </h1>

            <div class="blankMeta">
              <span>地境载情</span>
              <span>·</span>
              <span>流转诗意</span>
              <span>·</span>
              <span>点击右侧诗笺继续展开</span>
            </div>

            <div class="blankParagraphs">
              <p class="textBlock" :class="{ visible: textBlockVisible1 }">
                {{ typedText1 }}<span v-if="isTyping1" class="cursor">|</span>
              </p>
              <p class="textBlock" :class="{ visible: textBlockVisible2 }">
                {{ typedText2 }}<span v-if="isTyping2" class="cursor">|</span>
              </p>
              <p class="textBlock" :class="{ visible: textBlockVisible3 }">
                {{ typedText3 }}<span v-if="isTyping3" class="cursor">|</span>
              </p>
              <p class="textBlock" :class="{ visible: textBlockVisible4 }">
                {{ typedText4 }}<span v-if="isTyping4" class="cursor">|</span>
              </p>
            </div>
          </div>

          <div class="blankVisualPanel">
            <button
              type="button"
              class="frameAction"
              :class="{
                'frame-image-visible': imageVisible && firstFrameVisible && !secondFrameVisible && !thirdFrameVisible && !fourthFrameVisible,
                'frame-image-fly': secondFrameVisible || fourthFrameVisible
              }"
              @click="liftFrame"
            >
              <img :src="paperFrame" alt="诗笺" class="frameImageReal" />
              <div class="poetryOverlay">
                <div class="poetryColumn">
                  <span>明</span>
                  <span>月</span>
                  <span>几</span>
                  <span>时</span>
                  <span>有</span>
                  <span>,</span>
                  <span>把</span>
                  <span>酒</span>
                  <span>问</span>
                  <span>青</span>
                  <span>天</span>
                </div>
               <div class="poetryColumn">
                  <span>不</span>
                  <span>知</span>
                  <span>天</span>
                  <span>上</span>
                  <span>宫</span>
                  <span>阙</span>
                  <span>,</span>
                  <span>今</span>
                  <span>夕</span>
                  <span>是</span>
                  <span>何</span>
                 </div>
                 <div class="poetryColumn">
                  <span>年</span>
                  <span>?</span>
                   <span>我</span>
                  <span>欲</span>
                  <span>乘</span>
                  <span>风</span>
                  <span>归</span>
                  <span>去</span>
                 <span>,</span>
                  <span>又</span>
                  <span>恐</span>
                  
                </div>
                   <div class="poetryColumn">
                    <span>琼</span>
                  <span>楼</span>
                  <span>玉</span>
                  <span>宇</span>
                   <span>,</span>
                  <span>高</span>
                  <span>处</span>
                   <span>不</span>
                  <span>胜</span>
                  <span>寒</span>
                 
                </div>
              </div>
              <div class="poetryAuthor">
                <span>作</span>
                <span>者</span>
                <span>苏</span>
                <span>轼</span>
              </div>
            </button>
            
            <button
              type="button"
              class="frameAction frameActionSecond"
              :class="{
                'frame-image-visible': secondFrameVisible,
                'frame-image-entered': secondFrameEntered,
                'frame-image-fly': thirdFrameVisible
              }"
              @click="liftFrame"
            >
              <img :src="paperFrame" alt="诗笺" class="frameImageReal" />
              <div class="poetryOverlay">
                <div class="poetryColumn">
                  <span>春</span>
                  <span>江</span>
                  <span>潮</span>
                  <span>水</span>
                  <span>连</span>
                  <span>海</span>
                  <span>平</span>
                  <span>,</span>
                  <span>海</span>
                  <span>上</span>
                  <span>明</span>
                 
                </div>
                <div class="poetryColumn">
                 <span>月</span>
                  <span>共</span>
                  <span>潮</span>
                  <span>生</span>
                   <span>,</span>
                  <span>滟</span>
                  <span>滟</span>
                  <span>随</span>
                  <span>波</span>
                  <span>千</span>
                  <span>万</span>
                 
                </div>
                 <div class="poetryColumn">
                <span>里</span>
                  <span>,</span>
                  <span>何</span>
                  <span>处</span>
                  <span>春</span>
                  <span>江</span>
                  <span>无</span>
                  <span>月</span>
                  <span>明</span>
                </div>
              </div>
              <div class="poetryAuthor">
                <span>作</span>
                <span>者</span>
                <span>张</span>
                <span>若</span>
                <span>虚</span>
              </div>
            </button>
            
            <button
              type="button"
              class="frameAction frameActionThird"
              :class="{
                'frame-image-visible': thirdFrameVisible,
                'frame-image-entered': thirdFrameEntered,
                'frame-image-fly': fourthFrameVisible
              }"
              @click="liftFrame"
            >
              <img :src="paperFrame" alt="诗笺" class="frameImageReal" />
              <div class="poetryOverlay">
                <div class="poetryColumn">
                  <span>岱</span>
                  <span>宗</span>
                  <span>夫</span>
                  <span>如</span>
                  <span>何</span>
                  <span>?</span>
                  <span>齐</span>
                  <span>鲁</span>
                  <span>青</span>
                  <span>未</span>
                  <span>了</span>
                  <span>,</span>
                </div>
                <div class="poetryColumn">
                  <span>造</span>
                  <span>化</span>
                  <span>钟</span>
                  <span>神</span>
                  <span>秀</span>
                  <span>,</span>
                  <span>阴</span>
                  <span>阳</span>
                  <span>割</span>
                  <span>昏</span>
                  <span>晓</span>
                </div>
                <div class="poetryColumn">
                  <span>荡</span>
                  <span>胸</span>
                  <span>生</span>
                  <span>层</span>
                  <span>云</span>
                  <span>,</span>
                  <span>决</span>
                  <span>眦</span>
                  <span>入</span>
                  <span>归</span>
                  <span>鸟</span>
                </div>
              </div>
              <div class="poetryAuthor">
                <span>作</span>
                <span>者</span>
                <span>杜</span>
                <span>甫</span>
              </div>
            </button>
            
            <button
              type="button"
              class="frameAction frameActionFourth"
              :class="{
                'frame-image-visible': fourthFrameVisible,
                'frame-image-entered': fourthFrameEntered,
                'frame-image-fly': !fourthFrameVisible && firstFrameVisible
              }"
              @click="liftFrame"
            >
              <img :src="paperFrame" alt="诗笺" class="frameImageReal" />
              <div class="poetryOverlay">
                <div class="poetryColumn">
                  <span>海</span>
                  <span>上</span>
                  <span>生</span>
                  <span>明</span>
                  <span>月</span>
                  <span>,</span>
                  <span>天</span>
                  <span>崖</span>
                  <span>共</span>
                  <span>此</span>
                  <span>时</span>
                </div>
                 <div class="poetryColumn">
                  <span>情</span>
                  <span>人</span>
                  <span>怨</span>
                  <span>遥</span>
                  <span>夜</span>
                  <span>,</span>
                  <span>竟</span>
                  <span>夕</span>
                  <span>起</span>
                  <span>相</span>
                  <span>思</span>
                </div>
                <div class="poetryColumn">
                  <span>灭</span>
                  <span>烛</span>
                  <span>怜</span>
                  <span>光</span>
                  <span>满</span>
                  <span>,</span>
                  <span>披</span>
                  <span>衣</span>
                  <span>觉</span>
                  <span>露</span>
                  <span>滋</span>
                </div>
                <div class="poetryColumn">
                  <span>不</span>
                  <span>堪</span>
                  <span>盈</span>
                  <span>手</span>
                  <span>赠</span>
                  <span>,</span>
                  <span>还</span>
                  <span>寝</span>
                  <span>梦</span>
                  <span>佳</span>
                  <span>期</span>
                </div>
                
                 
              </div>
              <div class="poetryAuthor">
                <span>作</span>
                <span>者</span>
                <span>张</span>
                <span>九</span>
                <span>龄</span>
              </div>
            </button>
          </div>
        </div>
      </div>

      <div class="hint">滚轮旋转推进 · 点击卡片看详情</div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref } from "vue";
import paperFrame from "../../../assets/han/paper_frame.jpg";
import home4Bg from "../../../assets/home4/背景.jpg";

const text1 = `“景”不仅是自然的映照，更是诗人情感的载体。山川草木、云霞烟雨，在诗人的笔下被赋予灵性与温度。王维以“空山新雨后，天气晚来秋”勾勒出澄澈宁静的山水画卷；杜甫借“星垂平野阔，月涌大江流”抒写苍茫壮阔的家国情怀。`;
const text2 = `景因情而生辉，情因景而深远。诗歌中的“景”，既是外在世界的缩影，也是内心宇宙的投射。它穿越时空，让千年后的读者仍能感受到那一缕晨光、一声鸟鸣、一片落叶所承载的诗意与哲思。`;
const text3 = `从王维的空山新雨，到孟浩然的春晓微明；从柳永的寒蝉凄切，到苏轼的江天一色，古典诗词总能把可见之景写成可感之境。读者看到的并非单纯的山水草木，而是一种被情绪浸润后的世界。`;
const text4 = `在快节奏的今天，重读这些写景之诗，恰如清泉洗心。景让诗有了形，诗让景有了魂。点击右侧诗笺，让画面继续上行展开，进入更完整的诗意观看节奏。`;

const typedText1 = ref("");
const typedText2 = ref("");
const typedText3 = ref("");
const typedText4 = ref("");
const isTyping1 = ref(false);
const isTyping2 = ref(false);
const isTyping3 = ref(false);
const isTyping4 = ref(false);

const typewriterStarted = ref(false);
const imageVisible = ref(false);
const frameLifted = ref(false);
const titleClear = ref(false);
const firstFrameVisible = ref(true);
const secondFrameVisible = ref(false);
const secondFrameEntered = ref(false);
const thirdFrameVisible = ref(false);
const thirdFrameEntered = ref(false);
const fourthFrameVisible = ref(false);
const fourthFrameEntered = ref(false);

const textBlockVisible1 = ref(false);
const textBlockVisible2 = ref(false);
const textBlockVisible3 = ref(false);
const textBlockVisible4 = ref(false);

let typewriterTimers = [];

function typeWriter(text, targetRef, isTypingRef, visibleRef, delay = 0, speed = 18) {
  let index = 0;
  const timeoutId = setTimeout(() => {
    visibleRef.value = true;
    isTypingRef.value = true;

    function type() {
      if (index < text.length) {
        targetRef.value += text.charAt(index);
        index += 1;
        const timer = setTimeout(type, speed);
        typewriterTimers.push(timer);
      } else {
        isTypingRef.value = false;
      }
    }

    type();
  }, delay);

  typewriterTimers.push(timeoutId);
}

function clearTypewriterTimers() {
  typewriterTimers.forEach((timer) => clearTimeout(timer));
  typewriterTimers = [];
}

function liftFrame() {
  if (!secondFrameEntered.value) {
    secondFrameVisible.value = true;
    firstFrameVisible.value = false;
    setTimeout(() => {
      secondFrameEntered.value = true;
    }, 50);
  } else if (!thirdFrameEntered.value) {
    thirdFrameVisible.value = true;
    setTimeout(() => {
      thirdFrameEntered.value = true;
    }, 50);
  } else if (!fourthFrameEntered.value) {
    fourthFrameVisible.value = true;
    setTimeout(() => {
      fourthFrameEntered.value = true;
    }, 50);
  } else {
    fourthFrameEntered.value = false;
    fourthFrameVisible.value = false;
    thirdFrameEntered.value = false;
    thirdFrameVisible.value = false;
    secondFrameEntered.value = false;
    secondFrameVisible.value = false;
    
    setTimeout(() => {
      firstFrameVisible.value = true;
    }, 100);
  }
}

const props = defineProps({
  items: { type: Array, default: () => [] },
  radius: { type: Number, default: 640 },
  pitch: { type: Number, default: 150 },
  cardW: { type: Number, default: 220 },
  cardH: { type: Number, default: 150 },
  tilt: { type: Number, default: 7 },
  perspective: { type: Number, default: 1500 },
});

const emit = defineEmits(["go", "blankFullyVisible"]);

const wrapRef = ref(null);
const blankRef = ref(null);

const rot = ref(0);
const lift = ref(0);

let vRot = 0;
let vLift = 0;
let anim = 0;

const blankFullyVisible = ref(false);

function clamp(n, a, b) {
  return Math.max(a, Math.min(b, n));
}

const count = computed(() => props.items.length || 1);

const stepDeg = computed(() => {
  const raw = 360 / Math.min(16, count.value);
  return clamp(raw, 15, 35);
});

const stageStyle = computed(() => ({
  perspective: `${props.perspective}px`,
  perspectiveOrigin: "50% 54%",
  "--tilt": `${props.tilt}deg`,
}));

function cardStyle(i) {
  const deg = i * stepDeg.value + rot.value;
  const center = (count.value - 1) / 2;
  const pitchFactor = center > 0 ? 1.1 - (i / Math.max(count.value - 1, 1)) * 0.3 : 1;
  const y = (i - center) * (props.pitch * pitchFactor) - lift.value;

  const radiusFactor = 0.69 - (i / Math.max(count.value - 1, 1)) * 0.31;
  const adjustedRadius = props.radius * radiusFactor;

  const n = Math.abs((((deg % 360) + 540) % 360) - 180);
  const front = 1 - clamp(n / 180, 0, 1);
  const positionFactor = 1 - (i / Math.max(count.value - 1, 1)) * 0.45;
  const scale = (0.85 + front * 0.15) * positionFactor;
  const hidden = front < 0.08;

  return {
    width: `${props.cardW}px`,
    height: `${props.cardH}px`,
    transform: `translate(-50%, -50%) rotateY(${deg}deg) translateZ(${adjustedRadius}px) translateY(${y}px) scale(${scale})`,
    opacity: hidden ? 0 : 0.25 + front * 0.75,
    filter: hidden ? "none" : `blur(${(1 - front) * 0.3}px)`,
    zIndex: Math.round(front * 1000),
    pointerEvents: hidden ? "none" : "auto",
  };
}

const paperBgStyle = computed(() => ({
  backgroundImage: `url(${paperFrame})`,
}));

const blankStyle = computed(() => ({
  width: "100%",
  height: "100vh",
  backgroundImage: `url(${home4Bg})`,
  backgroundSize: "cover",
  backgroundPosition: "center",
  backgroundRepeat: "no-repeat",
  position: "absolute",
  bottom: "-100vh",
  left: "50%",
  transform: `translate(-50%, ${-lift.value}px)`,
  transition: "transform 0.1s ease",
  zIndex: 8000,
}));

function stopInertia() {
  cancelAnimationFrame(anim);
  anim = 0;
  vRot = 0;
  vLift = 0;
}

function onWheel(e) {
  const dy = e.deltaY || 0;
  const vh = window.innerHeight;
  const maxLift = vh * 1.0;

  if (dy > 0) {
    if (lift.value < maxLift) {
      e.preventDefault();
      e.stopPropagation();

      lift.value = Math.min(lift.value + dy * 0.5, maxLift);
      rot.value += dy * 0.08;
      vRot = dy * 0.008;
      vLift = dy * 0.015;

      if (lift.value >= maxLift && !blankFullyVisible.value) {
        blankFullyVisible.value = true;
        emit("blankFullyVisible", true);
      }
    } else if (!blankFullyVisible.value) {
      blankFullyVisible.value = true;
      emit("blankFullyVisible", true);
    }
  } else if (lift.value > 0) {
    e.preventDefault();
    e.stopPropagation();

    lift.value = Math.max(lift.value + dy * 0.5, 0);
    rot.value += dy * 0.08;
    vRot = dy * 0.008;
    vLift = dy * 0.015;
  }

  stopInertia();
}

const activeIdx = computed(() => {
  if (!props.items.length) return 0;

  let best = 0;
  let bestScore = -Infinity;

  for (let i = 0; i < props.items.length; i += 1) {
    const deg = i * stepDeg.value + rot.value;
    const n = Math.abs((((deg % 360) + 540) % 360) - 180);
    const front = 1 - clamp(n / 180, 0, 1);

    if (front > bestScore) {
      bestScore = front;
      best = i;
    }
  }

  return best;
});

function emitDetail(item) {
  emit("go", { type: "detail", item });
}

function onCardClick(i) {
  const item = props.items[i];
  if (!item) return;
  emitDetail(item);
}

function getLineColumns(item) {
  const raw = item?.line || item?.title || "";
  const text = String(raw).trim();

  if (!text) return ["暂无内容", ""];

  const firstSplit = text.split(/[，,]/).filter(Boolean);
  if (firstSplit.length >= 2) return [firstSplit[0], firstSplit[1]];

  const secondSplit = text.split(/[。！？；]/).filter(Boolean);
  if (secondSplit.length >= 2) return [secondSplit[0], secondSplit[1]];

  const mid = Math.ceil(text.length / 2);
  return [text.slice(0, mid), text.slice(mid)];
}

onMounted(() => {
  const el = wrapRef.value;
  if (!el) return;

  el.addEventListener("dragstart", (ev) => ev.preventDefault());

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting && !typewriterStarted.value) {
          typewriterStarted.value = true;
          imageVisible.value = true;

          const displacementMap = document.querySelector("#mosaic-heavy feDisplacementMap");
          if (displacementMap) {
            const duration = 1800;
            const startTime = performance.now();

            function animate(currentTime) {
              const elapsed = currentTime - startTime;
              const progress = Math.min(elapsed / duration, 1);
              const scale = 15 * (1 - progress);
              displacementMap.setAttribute("scale", scale.toString());

              if (progress < 1) {
                requestAnimationFrame(animate);
              } else {
                titleClear.value = true;
              }
            }

            requestAnimationFrame(animate);
          } else {
            titleClear.value = true;
          }

          typeWriter(text1, typedText1, isTyping1, textBlockVisible1, 220, 15);
          typeWriter(text2, typedText2, isTyping2, textBlockVisible2, 880, 15);
          typeWriter(text3, typedText3, isTyping3, textBlockVisible3, 1540, 15);
          typeWriter(text4, typedText4, isTyping4, textBlockVisible4, 2200, 15);

          observer.disconnect();
        }
      });
    },
    { threshold: 0.1 }
  );

  if (blankRef.value) {
    observer.observe(blankRef.value);
  }
});

onUnmounted(() => {
  stopInertia();
  clearTypewriterTimers();
});
</script>

<style scoped>
p {
  font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", "PingFang SC", "Microsoft YaHei", Arial, sans-serif;
  font-size: 17px;
}

.spiralRoot {
  width: 100%;
  height: 100%;
}

.wrap {
  --spiral-axis-y: 54%;
  width: 100%;
  height: 100%;
  position: relative;
  overflow: visible;
  background: transparent;
  border: none;
  box-shadow: none;
  border-radius: 0;
  touch-action: none;
  perspective-origin: 50% 50%;
}

.ribbon {
  position: absolute;
  inset: 0;
  pointer-events: none;
  z-index: 1;
}

.rail {
  position: absolute;
  left: 50%;
  top: var(--spiral-axis-y);
  width: min(980px, 86vw);
  height: 2px;
  transform: translate(-50%, -50%);
  opacity: 0.45;
  background: linear-gradient(90deg, transparent, rgba(255, 210, 140, 0.4), transparent);
}

.rail1 {
  transform: translate(-50%, -50%) translateY(26px);
}

.rail2 {
  transform: translate(-50%, -50%) translateY(-26px);
  opacity: 0.35;
}

.railGlow {
  position: absolute;
  left: 50%;
  top: var(--spiral-axis-y);
  width: min(1100px, 92vw);
  height: 240px;
  transform: translate(-50%, -50%);
  background: radial-gradient(closest-side, rgba(255, 210, 140, 0.08), transparent 70%);
  filter: blur(8px);
  opacity: 0.35;
}

.stage3d {
  position: absolute;
  inset: 0;
  transform-style: preserve-3d;
  transform: translateZ(0) rotateX(var(--tilt));
  transform-origin: 50% 50%;
  z-index: 2;
}

.stage3d::before {
  content: "";
  position: absolute;
  left: 50%;
  top: var(--spiral-axis-y);
  transform: translate(-50%, -50%);
  width: calc(100% + 40px);
  height: 4px;
  background: linear-gradient(90deg, transparent, rgba(100, 70, 40, 0.2), transparent);
  border-radius: 2px;
  z-index: -1;
}

.stage3d::after {
  content: "";
  position: absolute;
  left: 50%;
  top: var(--spiral-axis-y);
  transform: translate(-50%, -50%);
  width: 4px;
  height: 80px;
  background: linear-gradient(180deg, transparent, rgba(100, 70, 40, 0.15), transparent);
  border-radius: 2px;
  z-index: -1;
}

.card3d {
  position: absolute;
  left: 50%;
  top: var(--spiral-axis-y);
  transform-style: preserve-3d;
  transform-origin: 50% 50%;
  cursor: pointer;
  user-select: none;
}

.paperGlow {
  position: absolute;
  inset: -8px;
  background:
    radial-gradient(260px 120px at 30% 20%, rgba(255, 255, 255, 0.18), rgba(255, 255, 255, 0)),
    radial-gradient(320px 180px at 72% 82%, rgba(0, 0, 0, 0.06), transparent 60%);
  filter: blur(6px);
  opacity: 0.35;
  pointer-events: none;
}

.paperCard {
  position: absolute;
  inset: 0;
  overflow: hidden;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  box-shadow:
    0 16px 36px rgba(0, 0, 0, 0.12),
    0 6px 12px rgba(0, 0, 0, 0.06);
  transition: transform 0.22s ease, box-shadow 0.22s ease, opacity 0.22s ease;
  border: 1px solid rgba(100, 70, 40, 0.15);
  border-radius: 2px;
}

.paperCard::before,
.paperCard::after {
  content: "";
  position: absolute;
  top: 0;
  bottom: 0;
  width: 16px;
  z-index: -1;
}

.paperCard::before {
  left: -16px;
  border-right: 1px solid rgba(100, 70, 40, 0.1);
  background: linear-gradient(90deg, rgba(100, 70, 40, 0.2), rgba(100, 70, 40, 0.1) 50%, rgba(100, 70, 40, 0.05));
}

.paperCard::after {
  right: -16px;
  border-left: 1px solid rgba(100, 70, 40, 0.1);
  background: linear-gradient(90deg, rgba(100, 70, 40, 0.05), rgba(100, 70, 40, 0.1) 50%, rgba(100, 70, 40, 0.2));
}

.card3d.active .paperCard,
.card3d:hover .paperCard {
  box-shadow:
    0 22px 48px rgba(0, 0, 0, 0.14),
    0 8px 16px rgba(0, 0, 0, 0.08);
}

.paperLight {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(420px 180px at 40% 30%, rgba(255, 255, 255, 0.14), transparent 60%),
    radial-gradient(260px 160px at 70% 70%, rgba(255, 210, 140, 0.08), transparent 62%);
  pointer-events: none;
  opacity: 0.45;
}

.cardSeal {
  position: absolute;
  top: 14px;
  right: 14px;
  min-width: 42px;
  height: 42px;
  padding: 0 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(138, 33, 33, 0.12);
  border: 1px solid rgba(138, 33, 33, 0.2);
  color: rgba(138, 33, 33, 0.88);
  font-size: 12px;
  font-weight: 700;
  font-family: "STKaiti", "KaiTi", serif;
  z-index: 3;
}

.verseWrap {
  position: absolute;
  inset: 30px 18px 42px 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 16px;
  pointer-events: none;
}

.authorCol {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 82%;
  writing-mode: vertical-rl;
  text-orientation: upright;
}

.authorText {
  font-family: "STKaiti", "KaiTi", "FangSong", serif;
  font-size: 14px;
  font-weight: 700;
  color: rgba(35, 35, 35, 0.72);
  letter-spacing: 0.08em;
  line-height: 1.5;
}

.verseCols {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 18px;
  height: 92%;
}

.verseCol {
  writing-mode: vertical-rl;
  text-orientation: upright;
  font-family: "STKaiti", "KaiTi", "FangSong", "Noto Serif SC", serif;
  font-weight: 700;
  font-size: 24px;
  line-height: 1.28;
  letter-spacing: 0.08em;
  color: rgba(20, 20, 20, 0.92);
  text-shadow: 0 6px 16px rgba(0, 0, 0, 0.06);
  max-height: 92%;
  overflow: hidden;
}

.cardBottomTip {
  position: absolute;
  left: 50%;
  bottom: 12px;
  transform: translateX(-50%);
  padding: 4px 12px;
  background: rgba(255, 248, 236, 0.72);
  border: 1px solid rgba(100, 70, 40, 0.08);
  font-size: 12px;
  font-weight: 700;
  color: #7b5a3d;
  font-family: "STKaiti", "KaiTi", serif;
}

.blank {
  overflow: hidden;
  filter: saturate(1.04) contrast(1.04) brightness(1.02);
}

.blankOverlay {
  position: absolute;
  inset: 0;
  background:
    linear-gradient(90deg, rgba(241, 236, 226, 0.78) 0%, rgba(241, 236, 226, 0.68) 42%, rgba(241, 236, 226, 0.32) 68%, rgba(241, 236, 226, 0.14) 100%),
    radial-gradient(circle at 78% 50%, rgba(255, 255, 255, 0.05), transparent 32%);
  pointer-events: none;
}

.blankInner {
  position: relative;
  z-index: 1;
  width: min(1480px, 94vw);
  height: 100%;
  margin: 0 auto;
  display: grid;
  grid-template-columns: minmax(0, 1.2fr) minmax(280px, 420px);
  gap: 56px;
  align-items: center;
}

.blankTextPanel {
  padding-left: 24px;
  padding-top: 28px;
  max-width: 980px;
}

.blankEyebrow {
  color: rgba(214, 191, 145, 0.92);
  font-size: 18px;
  letter-spacing: 0.22em;
  margin-bottom: 14px;
}

.blankTitle {
  margin: 0;
  font-size: clamp(62px, 5.2vw, 88px);
  line-height: 1.04;
  color: #191713;
  font-weight: 900;
}

.blankMeta {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
  margin-top: 20px;
  color: rgba(194, 165, 113, 0.96);
  font-size: 15px;
  letter-spacing: 0.12em;
  font-weight: 700;
}

.blankParagraphs {
  margin-top: 42px;
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.textBlock {
  width: min(960px, 100%);
  margin: 0;
  text-align: justify;
  line-height: 1.92;
  color: rgba(34, 31, 27, 0.94);
  opacity: 0;
  transform: translateY(16px);
  transition: opacity 0.32s ease, transform 0.32s ease;
  text-shadow: 0 1px 0 rgba(255,255,255,0.22);
}

.textBlock.visible {
  opacity: 1;
  transform: translateY(0);
}

.blankVisualPanel {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
}

.frameAction {
  position: absolute;
  top: 50%;
  left: 50%;
  border: 0;
  padding: 0;
  background: transparent;
  cursor: pointer;
  width: min(320px, 23vw);
  opacity: 0;
  transform: translate(-50%, -50%);
  transition:
    opacity 0.45s ease,
    transform 0.45s ease,
    filter 0.25s ease;
  filter: drop-shadow(0 18px 34px rgba(80, 52, 28, 0.16));
}

.frameAction:hover {
  filter: drop-shadow(0 26px 40px rgba(80, 52, 28, 0.24));
}

.frame-image-visible {
  opacity: 1;
  transform: translate(-50%, -50%);
}
.frame-image-fly {
  opacity: 0 !important;
  transform: translate(-50%, -200%) !important;
  transition: transform 0.5s cubic-bezier(0.18, 0.84, 0.2, 1), opacity 0.3s ease !important;
}.frameActionSecond,
.frameActionThird,
.frameActionFourth {
  position: absolute;
  top: 50%;
  left: 50%;
  opacity: 0;
  transform: translate(-50%, 200%);
}

.frame-image-entered {
  opacity: 1;
  transform: translate(-50%, -50%);
  transition: transform 0.5s cubic-bezier(0.18, 0.84, 0.2, 1), opacity 0.3s ease;
}

.frameImageReal {
  width: 100%;
  display: block;
}

.poetryOverlay {
  position: absolute;
  top: 4%;
  left: 30%;
  right: 10%;
  bottom: 28%;
  display: flex;
  flex-direction: row-reverse;
  justify-content: space-between;
  align-items: flex-start;
  pointer-events: none;
}

.poetryColumn {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.poetryColumn span {
  font-family: "STKaiti", "KaiTi", "FangSong", "Noto Serif SC", serif;
  font-size: clamp(14px, 3.8vw, 22px);
  font-weight: 700;
  color: rgba(34, 31, 27, 0.92);
  letter-spacing: 0.3em;
  text-shadow: 0 2px 8px rgba(255, 255, 255, 0.5);
}

.poetryAuthor {
  position: absolute;
  left: 20%;
  bottom: 5%;
  display: flex;
  flex-direction: column;
  gap: 6px;
  pointer-events: none;
}

.poetryAuthor span {
  font-family: "STKaiti", "KaiTi", "FangSong", "Noto Serif SC", serif;
  font-size: clamp(11px, 2.6vw, 15px);
  font-weight: 700;
  color: rgba(80, 60, 40, 0.88);
  letter-spacing: 0.08em;
  text-shadow: 0 2px 6px rgba(255, 255, 255, 0.5);
}

.title-text {
  filter: url(#mosaic-heavy);
  transition: filter 2s ease-out;
}

.title-clear {
  filter: none;
}

.hint {
  position: absolute;
  left: 18px;
  bottom: 16px;
  font-weight: 900;
  font-size: 12px;
  opacity: 0.7;
  padding: 8px 12px;
  background: rgba(255, 255, 255, 0.22);
  border: 1px solid rgba(0, 0, 0, 0.06);
  backdrop-filter: blur(10px);
  pointer-events: none;
}

.cursor {
  display: inline-block;
  animation: blink 0.8s infinite;
  font-weight: 100;
  color: #333;
}

@keyframes blink {
  0%, 50% { opacity: 1; }
  51%, 100% { opacity: 0; }
}

@media (max-width: 1100px) {
  .blankInner {
    grid-template-columns: 1fr 300px;
    gap: 28px;
  }

  .blankTitle {
    font-size: 56px;
  }
}

@media (max-width: 900px) {
  .rail {
    width: min(860px, 92vw);
  }

  .authorText {
    font-size: 12px;
  }

  .verseCol {
    font-size: 20px;
  }

  .verseWrap {
    gap: 10px;
  }

  .blankInner {
    grid-template-columns: 1fr;
    gap: 20px;
    width: min(94vw, 760px);
    align-content: center;
    padding: 54px 0 42px;
  }

  .blankTextPanel {
    padding: 0;
  }

  .blankTitle {
    font-size: 44px;
  }

  .blankParagraphs {
    gap: 15px;
    margin-top: 28px;
  }

  .textBlock {
    font-size: 15px;
    line-height: 1.86;
  }

  .frameAction {
    width: min(280px, 58vw);
  }
}
</style>
