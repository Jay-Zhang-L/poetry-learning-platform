<!-- src/pages/home/components/HeroScroll.vue -->
<template>
  <section ref="wrapRef" class="heroWrap">
    <div class="heroSticky">
      <div class="heroBg" :style="heroBgStyle" aria-hidden="true"></div>
      <div class="heroMask" aria-hidden="true"></div>

      <div class="heroText">
        <div class="heroMain">
          <span
            class="typeV main"
            :key="'m-' + activeIndex"
            :style="typeVStyle(activeScene.main, true)"
          >
            {{ activeScene.main }}
          </span>
        </div>

        <div class="heroSub">
          <span
            class="typeV sub"
            :key="'s-' + activeIndex"
            :style="typeVStyle(activeScene.sub, false)"
          >
            {{ activeScene.sub }}
          </span>
        </div>

        <div class="heroHint">向下滚动</div>
      </div>

      <div class="heroDots" aria-hidden="true">
        <span
          v-for="(s, i) in scenes"
          :key="i"
          class="heroDot"
          :class="{ on: i === activeIndex }"
        />
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref } from "vue";

const props = defineProps({
  scenes: {
    type: Array,
    default: () => [],
  },
  // 一幕高度（vh），默认 100vh
  sceneVh: {
    type: Number,
    default: 100,
  },
});

const wrapRef = ref(null);
const activeIndex = ref(0);
const sceneP = ref(0);

function clamp(n, a, b) {
  return Math.max(a, Math.min(b, n));
}

function calcHero() {
  const el = wrapRef.value;
  if (!el) return;

  const rect = el.getBoundingClientRect();
  const vh = window.innerHeight || 800;
  const totalH = el.offsetHeight;

  const scrollInto = clamp(-rect.top, 0, totalH - vh);
  const page = scrollInto / vh;

  const idx = clamp(Math.floor(page + 0.00001), 0, props.scenes.length - 1);
  const p = clamp(page - idx, 0, 1);

  activeIndex.value = idx;
  sceneP.value = p;
}

let rafId = 0;
function onWinScroll() {
  cancelAnimationFrame(rafId);
  rafId = requestAnimationFrame(calcHero);
}

const activeScene = computed(() => props.scenes[activeIndex.value] || props.scenes[0] || {});

const heroBgStyle = computed(() => {
  const p = sceneP.value;
  const scale = 1.1 - p * 0.1;
  const y = 14 - p * 28;
  const x = -10 + p * 20;
  return {
    backgroundImage: activeScene.value?.img ? `url(${activeScene.value.img})` : "none",
    transform: `translate3d(${x}px, ${y}px, 0) scale(${scale})`,
  };
});

function typeVStyle(text, isMain) {
  const len = Math.max(1, (text || "").length);
  const dur = isMain ? Math.min(2.4, 0.11 * len + 0.9) : Math.min(3.0, 0.12 * len + 1.0);
  return { "--n": len, "--dur": `${dur}s` };
}

onMounted(() => {
  calcHero();
  window.addEventListener("scroll", onWinScroll, { passive: true });
  window.addEventListener("resize", calcHero, { passive: true });
});

onUnmounted(() => {
  window.removeEventListener("scroll", onWinScroll);
  window.removeEventListener("resize", calcHero);
  cancelAnimationFrame(rafId);
});
</script>

<style scoped>
.heroWrap{
  height: calc(v-bind(sceneVh) * 1vh * v-bind("scenes.length || 1"));
  position: relative;
  background: #000;
}
.heroSticky{
  position: sticky;
  top: 0;
  height: 100vh;
  overflow: hidden;
}
.heroBg{
  position: absolute;
  inset: -10%;
  background-size: cover;
  background-position: center;
  will-change: transform;
  transition: transform .06s linear;
  filter: saturate(1.05) contrast(1.04);
}
.heroMask{
  position: absolute;
  inset: 0;
  background:
    radial-gradient(1200px 640px at 18% 72%, rgba(0,0,0,0.12), transparent 60%),
    radial-gradient(900px 520px at 70% 30%, rgba(0,0,0,0.14), transparent 55%),
    linear-gradient(to bottom, rgba(0,0,0,0.10), rgba(0,0,0,0.66));
  animation: maskBreath 6.8s ease-in-out infinite;
}
@keyframes maskBreath{
  0%,100%{ filter: brightness(1); }
  50%{ filter: brightness(1.08); }
}

.heroText{
  position: absolute;
  left: 7%;
  bottom: 12%;
  color: rgba(255,255,255,0.98);
  writing-mode: vertical-rl;
  letter-spacing: 0.16em;
  text-shadow: 0 14px 40px rgba(0,0,0,0.38);
}
.heroMain{ font-size: 42px; font-weight: 900; }
.heroSub{ margin-top: 14px; font-size: 22px; font-weight: 800; opacity: .94; }
.heroHint{
  margin-top: 16px;
  font-weight: 800;
  font-size: 12px;
  letter-spacing: .18em;
  opacity: .78;
  writing-mode: horizontal-tb;
}

.typeV{
  display: inline-block;
  position: relative;
  white-space: pre;
  will-change: clip-path, opacity, transform;
  animation: typeV var(--dur) steps(var(--n)) both;
}
.typeV.sub{
  animation-delay: .45s;
  opacity: .95;
}
@keyframes typeV{
  0%{
    clip-path: inset(100% 0 0 0);
    opacity: 0;
    transform: translateY(8px);
  }
  20%{ opacity: 1; }
  100%{
    clip-path: inset(0 0 0 0);
    opacity: 1;
    transform: translateY(0);
  }
}

.heroDots{
  position: absolute;
  right: 18px;
  top: 50%;
  transform: translateY(-50%);
  display: flex;
  flex-direction: column;
  gap: 10px;
  z-index: 3;
}
.heroDot{
  width: 7px;
  height: 7px;
  border-radius: 999px;
  background: rgba(255,255,255,0.28);
}
.heroDot.on{
  background: rgba(255,255,255,0.88);
  box-shadow: 0 0 0 6px rgba(255,255,255,0.12);
}

@media (max-width: 900px){
  .heroMain{ font-size: 30px; }
  .heroSub{ font-size: 18px; }
  .heroText{ left: 6%; bottom: 10%; }
}
</style>
