<template>
  <div class="timeline3d-container">
    <!-- 宣纸纹理背景层 -->
    <div class="paper-texture-bg"></div>

    <!-- 水墨晕染装饰层 -->
    <div class="ink-decoration">
      <div class="ink-splash ink-splash-1"></div>
      <div class="ink-splash ink-splash-2"></div>
      <div class="ink-splash ink-splash-3"></div>
    </div>

    <!-- 3D场景容器 -->
    <div class="timeline3d-scene" ref="sceneRef">
      <!-- FPS监控（开发模式） -->
      <div v-if="showFPS" class="fps-monitor">
        <span class="fps-value">{{ currentFPS }}</span>
        <span class="fps-label">FPS</span>
      </div>

      <!-- 加载动画 -->
      <transition name="loading-fade">
        <div v-if="showLoading" class="loading-animation">
          <div class="scroll-container">
            <div class="scroll-left"></div>
            <div class="scroll-center">
              <div class="scroll-text">展开中...</div>
            </div>
            <div class="scroll-right"></div>
          </div>
        </div>
      </transition>

      <!-- 弧形时光轴轨道 -->
      <div class="timeline3d-track">
        <!-- 骨架屏（加载中显示） -->
        <div v-if="props.timelineData.length === 0" class="skeleton-loading">
          <div v-for="i in 5" :key="i" class="skeleton-node">
            <div class="skeleton-marker"></div>
            <div class="skeleton-content">
              <div class="skeleton-title"></div>
              <div class="skeleton-stats"></div>
            </div>
          </div>
        </div>

        <!-- SVG弧线 -->
        <svg class="track-line" viewBox="0 0 1000 300" preserveAspectRatio="none">
          <defs>
            <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" style="stop-color:#d4af37;stop-opacity:0.3" />
              <stop offset="50%" style="stop-color:#d4af37;stop-opacity:0.8" />
              <stop offset="100%" style="stop-color:#d4af37;stop-opacity:0.3" />
            </linearGradient>

            <!-- 鎏金流光渐变 -->
            <linearGradient id="goldFlow" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" style="stop-color:#d4af37;stop-opacity:0" />
              <stop offset="50%" style="stop-color:#ffd700;stop-opacity:0.8" />
              <stop offset="100%" style="stop-color:#d4af37;stop-opacity:0" />
            </linearGradient>

            <!-- 流光滤镜 -->
            <filter id="glow">
              <feGaussianBlur stdDeviation="2.5" result="coloredBlur"/>
              <feMerge>
                <feMergeNode in="coloredBlur"/>
                <feMergeNode in="SourceGraphic"/>
              </feMerge>
            </filter>
          </defs>

          <!-- 主轨道 -->
          <path
            d="M 50 250 Q 500 50 950 250"
            stroke="url(#gradient)"
            stroke-width="3"
            fill="none"
            class="track-path"
          />

          <!-- 鎏金流光效果 -->
          <path
            d="M 50 250 Q 500 50 950 250"
            stroke="url(#goldFlow)"
            stroke-width="6"
            fill="none"
            class="track-glow"
            filter="url(#glow)"
          />
        </svg>

        <!-- 时间节点卡片 -->
        <div
          v-for="(node, index) in visibleNodes"
          :key="node.id"
          class="timeline3d-node"
          :style="getNodeStyle(node.originalIndex)"
          @click="goToWork(node.id)"
          @mouseenter="playSound('hover')"
        >
          <!-- 3D卡片容器 -->
          <div class="card3d">
            <!-- 卡片正面 -->
            <div class="card3d-front">
              <!-- 竹简造型装饰 -->
              <div class="bamboo-frame">
                <!-- 顶部竹片 -->
                <div class="bamboo-strip top"></div>
                <!-- 底部竹片 -->
                <div class="bamboo-strip bottom"></div>
              </div>

              <!-- 日期标签（天干地支风格） -->
              <div class="node-date">
                <span class="date-icon">📅</span>
                {{ node.dateLabel }}
              </div>

              <!-- 3D节点标记（玉琮造型） -->
              <div class="node-marker">
                <div class="marker-inner jade-cong">
                  <div class="jade-inner">
                    <span v-if="node.isMilestone" class="badge">{{ node.badgeText }}</span>
                    <span v-else class="mark-icon">🎋</span>
                  </div>
                </div>
              </div>

              <!-- 内容区域 -->
              <div class="node-content">
                <div class="work-title">{{ node.title }}</div>
                <div class="work-stats">
                  <span class="stat-item">
                    <span class="stat-icon">👍</span>
                    <span class="stat-number">{{ node.likes }}</span>
                  </span>
                  <span class="dot">·</span>
                  <span class="stat-item">
                    <span class="stat-icon">💬</span>
                    <span class="stat-number">{{ node.comments }}</span>
                  </span>
                </div>
              </div>
            </div>

            <!-- 卡片背面（详情预览） -->
            <div class="card3d-back">
              <div class="back-decoration">
                <div class="back-pattern"></div>
              </div>
              <div class="preview-text">
                <span class="preview-icon">📜</span>
                <span>点击查看详情</span>
              </div>
              <div class="preview-subtitle">诗词详情</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 滚动提示 -->
    <div class="scroll-hint" v-if="showScrollHint">
      <span class="hint-icon">↔</span>
      <span class="hint-text">滚动查看更多</span>
    </div>

    <!-- 详情弹窗 -->
    <transition name="detail-fade">
      <div v-if="showDetail" class="detail-modal" @click="closeDetail">
        <div class="detail-overlay"></div>

        <div class="detail-content" @click.stop>
          <!-- 关闭按钮 -->
          <button class="detail-close" @click="closeDetail">
            <span>✕</span>
          </button>

          <!-- 3D装饰 -->
          <div class="detail-decoration">
            <div class="decoration-line top"></div>
            <div class="decoration-line bottom"></div>

            <!-- 古风装饰角落 -->
            <div class="corner-decoration top-left">
              <svg viewBox="0 0 40 40" class="corner-svg">
                <path d="M 5 5 L 15 5 L 15 7 L 7 7 L 7 15 L 5 15 Z" fill="currentColor" opacity="0.3"/>
                <path d="M 8 8 L 12 8 L 12 9 L 9 9 L 9 12 L 8 12 Z" fill="currentColor" opacity="0.2"/>
              </svg>
            </div>
            <div class="corner-decoration top-right">
              <svg viewBox="0 0 40 40" class="corner-svg">
                <path d="M 35 5 L 25 5 L 25 7 L 33 7 L 33 15 L 35 15 Z" fill="currentColor" opacity="0.3"/>
                <path d="M 32 8 L 28 8 L 28 9 L 31 9 L 31 12 L 32 12 Z" fill="currentColor" opacity="0.2"/>
              </svg>
            </div>
            <div class="corner-decoration bottom-left">
              <svg viewBox="0 0 40 40" class="corner-svg">
                <path d="M 5 35 L 15 35 L 15 33 L 7 33 L 7 25 L 5 25 Z" fill="currentColor" opacity="0.3"/>
                <path d="M 8 32 L 12 32 L 12 31 L 9 31 L 9 28 L 8 28 Z" fill="currentColor" opacity="0.2"/>
              </svg>
            </div>
            <div class="corner-decoration bottom-right">
              <svg viewBox="0 0 40 40" class="corner-svg">
                <path d="M 35 35 L 25 35 L 25 33 L 33 33 L 33 25 L 35 25 Z" fill="currentColor" opacity="0.3"/>
                <path d="M 32 32 L 28 32 L 28 31 L 31 31 L 31 28 L 32 28 Z" fill="currentColor" opacity="0.2"/>
              </svg>
            </div>

            <!-- 云纹装饰 -->
            <div class="cloud-decoration">
              <svg viewBox="0 0 100 40" class="cloud-svg">
                <path d="M 10 20 Q 15 10, 25 15 T 40 15 T 55 20 T 70 15 T 85 20 Q 90 25, 85 30 T 70 35 T 55 30 T 40 35 T 25 30 T 10 20 Z"
                      fill="none" stroke="currentColor" stroke-width="1" opacity="0.15"/>
              </svg>
            </div>
          </div>

          <!-- 内容区 -->
          <div class="detail-body">
            <div class="detail-icon">📜</div>
            <h3 class="detail-title">{{ selectedNode?.title }}</h3>
            <div class="detail-meta">
              <span class="meta-item">
                <span class="meta-icon">📅</span>
                {{ selectedNode?.dateLabel }}
              </span>
              <span class="meta-item">
                <span class="meta-icon">👍</span>
                {{ selectedNode?.likes }}
              </span>
              <span class="meta-item">
                <span class="meta-icon">💬</span>
                {{ selectedNode?.comments }}
              </span>
            </div>

            <div class="detail-divider">
              <span class="divider-icon">♦</span>
            </div>

            <p class="detail-description">
              点击下方按钮查看完整诗词内容
            </p>

            <button class="detail-action" @click="goToWork(selectedNode?.id)">
              <span>查看详情</span>
              <span class="action-arrow">→</span>
            </button>
          </div>
        </div>
      </div>
    </transition>

    <!-- 错误提示 -->
    <transition name="error-shake">
      <div v-if="showError" class="error-message">
        <div class="error-content">
          <span class="error-icon">⚠️</span>
          <span class="error-text">{{ errorMessage }}</span>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue';
import { useRouter } from 'vue-router';
import gsap from 'gsap';

const props = defineProps({
  timelineData: {
    type: Array,
    default: () => []
  }
});

// 页面切换动画
const isPageVisible = ref(true);

function playPageTransition() {
  const container = document.querySelector('.timeline3d-container');
  if (!container) return;

  // 页面淡入动画
  gsap.fromTo(container,
    {
      opacity: 0,
      scale: 0.95,
      filter: 'blur(10px)'
    },
    {
      opacity: 1,
      scale: 1,
      filter: 'blur(0px)',
      duration: 0.6,
      ease: 'power2.out'
    }
  );
}

const router = useRouter();
const sceneRef = ref(null);
const showScrollHint = ref(true);
const showDetail = ref(false);
const selectedNode = ref(null);
const showLoading = ref(true);
const showError = ref(false);
const errorMessage = ref('');

// FPS监控系统
const showFPS = ref(true);
const currentFPS = ref(60);
const frameCount = ref(0);
const lastTime = ref(performance.now());

// FPS监控（仅在开发环境）
const isDev = import.meta.env.DEV;

// 浏览器兼容性检测
const browserCapabilities = ref({
  webgl: false,
  css3d: false,
  webAudio: false,
  flexbox: false
});

function detectBrowserCapabilities() {
  // WebGL检测
  const canvas = document.createElement('canvas');
  browserCapabilities.value.webgl = !!(
    window.WebGLRenderingContext &&
    (canvas.getContext('webgl') || canvas.getContext('experimental-webgl'))
  );

  // CSS 3D检测
  browserCapabilities.value.css3d = 'CSS' in window && 'supports' in window.CSS &&
    CSS.supports('transform-style: preserve-3d');

  // Web Audio API检测
  browserCapabilities.value.webAudio = !!(window.AudioContext || window.webkitAudioContext);

  // Flexbox检测
  browserCapabilities.value.flexbox = CSS.supports('display', 'flex');

  // 如果不支持关键特性，使用降级方案
  if (!browserCapabilities.value.css3d) {
    console.warn('CSS 3D not supported, fallback to 2D mode');
    return false;
  }

  return true;
}

function updateFPS() {
  if (!isDev) {
    showFPS.value = false;
    return;
  }

  frameCount.value++;
  const currentTime = performance.now();
  const elapsed = currentTime - lastTime.value;

  if (elapsed >= 1000) {
    currentFPS.value = Math.round((frameCount.value * 1000) / elapsed);
    frameCount.value = 0;
    lastTime.value = currentTime;

    // FPS低于30时显示警告
    if (currentFPS.value < 30) {
      console.warn(`Low FPS detected: ${currentFPS.value} FPS`);
    }
  }

  requestAnimationFrame(updateFPS);
}

// 音效系统（使用Web Audio API生成简单音效）
const audioContext = ref(null);
const soundEnabled = ref(true);

function initAudio() {
  try {
    audioContext.value = new (window.AudioContext || window.webkitAudioContext)();
  } catch (e) {
    console.warn('Web Audio API not supported');
    soundEnabled.value = false;
  }
}

// 播放简单音效（正弦波）
function playSound(type) {
  if (!soundEnabled.value || !audioContext.value) return;

  const ctx = audioContext.value;
  const oscillator = ctx.createOscillator();
  const gainNode = ctx.createGain();

  oscillator.connect(gainNode);
  gainNode.connect(ctx.destination);

  switch(type) {
    case 'hover':
      // 悬停：短促的高音
      oscillator.frequency.value = 800;
      oscillator.type = 'sine';
      gainNode.gain.setValueAtTime(0.1, ctx.currentTime);
      gainNode.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.1);
      oscillator.start(ctx.currentTime);
      oscillator.stop(ctx.currentTime + 0.1);
      break;

    case 'click':
      // 点击：清脆的音效
      oscillator.frequency.value = 1000;
      oscillator.type = 'sine';
      gainNode.gain.setValueAtTime(0.15, ctx.currentTime);
      gainNode.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.15);
      oscillator.start(ctx.currentTime);
      oscillator.stop(ctx.currentTime + 0.15);
      break;

    case 'open':
      // 打开弹窗：渐入的音效
      oscillator.frequency.value = 600;
      oscillator.type = 'sine';
      gainNode.gain.setValueAtTime(0, ctx.currentTime);
      gainNode.gain.linearRampToValueAtTime(0.1, ctx.currentTime + 0.2);
      gainNode.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.4);
      oscillator.start(ctx.currentTime);
      oscillator.stop(ctx.currentTime + 0.4);
      break;

    case 'close':
      // 关闭弹窗：渐出的音效
      oscillator.frequency.value = 400;
      oscillator.type = 'sine';
      gainNode.gain.setValueAtTime(0.1, ctx.currentTime);
      gainNode.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.2);
      oscillator.start(ctx.currentTime);
      oscillator.stop(ctx.currentTime + 0.2);
      break;
  }
}
function showErrorMsg(message) {
  errorMessage.value = message;
  showError.value = true;

  // 3秒后自动消失
  setTimeout(() => {
    showError.value = false;
  }, 3000);
}

// 懒加载：只渲染可见节点（虚拟滚动）
const VISIBLE_BUFFER = 4; // 可见区域前后各渲染的节点数

const visibleNodes = computed(() => {
  const total = props.timelineData.length;

  // 节点少于10个，全部渲染
  if (total <= 10) {
    return props.timelineData.map((node, index) => ({
      ...node,
      originalIndex: index
    }));
  }

  // 获取当前滚动位置
  const scene = sceneRef.value;
  if (!scene) {
    return props.timelineData.slice(0, 10).map((node, index) => ({
      ...node,
      originalIndex: index
    }));
  }

  const scrollLeft = scene.scrollLeft;
  const containerWidth = scene.clientWidth;

  // 计算可见区域的节点索引范围
  const nodeWidth = 174; // 150px width + 24px gap
  const startIndex = Math.max(0, Math.floor((scrollLeft - containerWidth / 2) / nodeWidth) - VISIBLE_BUFFER);
  const endIndex = Math.min(total, Math.ceil((scrollLeft + containerWidth * 1.5) / nodeWidth) + VISIBLE_BUFFER);

  // 只返回可见区域的节点
  return props.timelineData.slice(startIndex, endIndex).map((node, index) => ({
    ...node,
    originalIndex: startIndex + index
  }));
});

// 计算每个节点的位置（沿弧形分布）
function getNodeStyle(index) {
  const total = props.timelineData.length;
  const progress = total > 1 ? index / (total - 1) : 0.5;

  // 沿贝塞尔曲线分布
  const t = progress;
  const x = 80 + (840 * t); // 增加左右边距，从50→80, 900→840
  const baseY = 250;
  const controlY = 50;
  const y = baseY + (controlY - baseY) * Math.sin(t * Math.PI);

  // Z轴深度（创造3D层次感）
  const z = Math.sin(t * Math.PI) * 100;

  // 旋转角度（面向观众）
  const rotateY = (t - 0.5) * -30;

  return {
    left: `${x}px`,
    top: `${y}px`,
    transform: `translateZ(${z}px) rotateY(${rotateY}deg)`,
    '--node-progress': t
  };
}

// 点击跳转到作品详情
function goToWork(id) {
  if (!id) {
    showErrorMsg('未找到该作品');
    return;
  }

  playSound('click');

  if (showDetail.value) {
    // 如果弹窗打开，直接跳转
    router.push(`/chuangzuo/${id}`);
  } else {
    // 如果弹窗关闭，先显示弹窗
    const node = props.timelineData.find(n => n.id === id);
    if (node) {
      openDetail(node);
    } else {
      showErrorMsg('未找到该作品');
    }
  }
}

// 打开详情弹窗
function openDetail(node) {
  selectedNode.value = node;
  showDetail.value = true;
  playSound('open');

  // 播放弹窗动画
  nextTick(() => {
    const content = document.querySelector('.detail-content');
    if (content) {
      gsap.fromTo(content,
        {
          scale: 0.8,
          opacity: 0,
          rotationY: -15
        },
        {
          scale: 1,
          opacity: 1,
          rotationY: 0,
          duration: 0.4,
          ease: 'back.out(1.7)'
        }
      );
    }
  });
}

// 关闭详情弹窗
function closeDetail() {
  playSound('close');
  const content = document.querySelector('.detail-content');

  if (content) {
    // 播放关闭动画
    gsap.to(content, {
      scale: 0.8,
      opacity: 0,
      rotationY: 15,
      duration: 0.3,
      ease: 'power2.in',
      onComplete: () => {
        showDetail.value = false;
        selectedNode.value = null;
      }
    });
  } else {
    showDetail.value = false;
    selectedNode.value = null;
  }
}

// 节流函数
function throttle(func, delay) {
  let lastCall = 0;
  return function(...args) {
    const now = Date.now();
    if (now - lastCall >= delay) {
      lastCall = now;
      return func.apply(this, args);
    }
  };
}

// 横向滚动控制
function setupScrollControl() {
  const scene = sceneRef.value;
  if (!scene) return;

  let isScrolling = false;
  let scrollTimeout;

  // 鼠标滚轮控制（节流优化）
  const handleWheel = throttle((e) => {
    if (!isScrolling) {
      isScrolling = true;

      gsap.to(scene, {
        scrollLeft: scene.scrollLeft + e.deltaY,
        duration: 0.5,
        ease: 'power2.out',
        onComplete: () => {
          clearTimeout(scrollTimeout);
          scrollTimeout = setTimeout(() => {
            isScrolling = false;
          }, 100);
        }
      });
    }

    e.preventDefault();
  }, 16); // 约60fps

  scene.addEventListener('wheel', handleWheel, { passive: false });

  // 触摸滑动控制（移动端优化）
  let touchStartX = 0;
  let touchStartY = 0;
  let isTouchScrolling = false;
  let touchStartTime = 0;

  scene.addEventListener('touchstart', (e) => {
    touchStartX = e.touches[0].clientX;
    touchStartY = e.touches[0].clientY;
    touchStartTime = Date.now();
    isTouchScrolling = false;
  }, { passive: true });

  const handleTouchMove = throttle((e) => {
    if (!isTouchScrolling) {
      const touchX = e.touches[0].clientX;
      const touchY = e.touches[0].clientY;
      const deltaX = touchStartX - touchX;
      const deltaY = touchStartY - touchY;

      // 判断是横向滑动还是纵向滑动
      if (Math.abs(deltaX) > Math.abs(deltaY) && Math.abs(deltaX) > 10) {
        // 横向滑动（阈值10px）
        isTouchScrolling = true;
        const sensitivity = window.innerWidth < 768 ? 2.0 : 1.5; // 移动端更灵敏
        scene.scrollLeft += deltaX * sensitivity;
        touchStartX = touchX;
        e.preventDefault();
      }
    }
  }, 16); // 约60fps

  scene.addEventListener('touchmove', handleTouchMove, { passive: false });

  // 触摸结束，重置状态
  scene.addEventListener('touchend', () => {
    isTouchScrolling = false;
  }, { passive: true });

  scene.addEventListener('touchcancel', () => {
    isTouchScrolling = false;
  }, { passive: true });
}

// 入场动画
function playEnterAnimation() {
  const nodes = document.querySelectorAll('.timeline3d-node');
  const track = document.querySelector('.track-path');
  const glow = document.querySelector('.track-glow');

  // 创建时间轴
  const tl = gsap.timeline();

  // 1. 先绘制轨道
  if (track) {
    tl.fromTo(track,
      { strokeDashoffset: 1000 },
      { strokeDashoffset: 0, duration: 1.5, ease: 'power2.out' },
      0
    );
  }

  // 2. 节点依次入场
  tl.fromTo(nodes,
    {
      opacity: 0,
      y: 60,
      scale: 0.7,
      rotationY: -45
    },
    {
      opacity: 1,
      y: 0,
      scale: 1,
      rotationY: 0,
      duration: 0.8,
      stagger: {
        each: 0.12,
        from: 'center'
      },
      ease: 'back.out(1.7)'
    },
    0.3  // 轨道开始绘制后0.3秒，节点开始入场
  );

  // 3. 鎏金流光淡入
  if (glow) {
    tl.fromTo(glow,
      { opacity: 0 },
      { opacity: 0.6, duration: 0.5 },
      1
    );
  }
}

// 鎏金流光动画
function playGoldFlowAnimation() {
  const glowPath = document.querySelector('.track-glow');
  if (!glowPath) return;

  // 创建流光效果
  gsap.to(glowPath, {
    strokeDashoffset: -1000,
    duration: 3,
    repeat: -1,
    ease: 'none'
  });
}

// 水墨晕染动画
function playInkSplashAnimation() {
  const splashes = document.querySelectorAll('.ink-splash');

  splashes.forEach((splash, index) => {
    gsap.fromTo(splash,
      {
        scale: 0,
        opacity: 0
      },
      {
        scale: 1,
        opacity: 0.6,
        duration: 2,
        delay: index * 0.5,
        ease: 'power2.out'
      }
    );
  });
}

// 隐藏滚动提示
function hideScrollHint() {
  showScrollHint.value = false;
}

// 键盘导航
function setupKeyboardNavigation() {
  const handleKeyDown = (e) => {
    const nodes = props.timelineData;
    if (nodes.length === 0) return;

    switch(e.key) {
      case 'ArrowLeft':
        e.preventDefault();
        navigateNode(-1);
        break;
      case 'ArrowRight':
        e.preventDefault();
        navigateNode(1);
        break;
      case 'Enter':
      case ' ':
        e.preventDefault();
        if (selectedNode.value) {
          goToWork(selectedNode.value.id);
        }
        break;
      case 'Escape':
        e.preventDefault();
        if (showDetail.value) {
          closeDetail();
        }
        break;
    }
  };

  window.addEventListener('keydown', handleKeyDown);

  // 清理函数
  return () => {
    window.removeEventListener('keydown', handleKeyDown);
  };
}

// 节点导航
let currentFocusIndex = -1;

function navigateNode(direction) {
  const nodes = props.timelineData;
  const newIndex = currentFocusIndex + direction;

  if (newIndex >= 0 && newIndex < nodes.length) {
    currentFocusIndex = newIndex;
    const node = nodes[newIndex];

    // 滚动到节点位置
    const scene = sceneRef.value;
    if (scene) {
      const nodeElement = document.querySelectorAll('.timeline3d-node')[newIndex];
      if (nodeElement) {
        nodeElement.scrollIntoView({
          behavior: 'smooth',
          block: 'nearest',
          inline: 'center'
        });
      }
    }

    // 高亮当前节点
    highlightNode(newIndex);
  }
}

// 高亮节点
function highlightNode(index) {
  const nodes = document.querySelectorAll('.timeline3d-node');

  nodes.forEach((node, i) => {
    if (i === index) {
      gsap.to(node, {
        scale: 1.15,
        duration: 0.3,
        ease: 'back.out(1.7)'
      });
    } else {
      gsap.to(node, {
        scale: 1,
        duration: 0.3
      });
    }
  });
}

onMounted(() => {
  // 检测浏览器兼容性
  const isCompatible = detectBrowserCapabilities();

  if (!isCompatible) {
    // 不兼容时显示提示
    showErrorMsg('您的浏览器不支持部分特性，建议使用Chrome/Firefox/Edge最新版本');
  }

  // 初始化音效系统
  initAudio();

  // 启动FPS监控
  updateFPS();

  setupScrollControl();

  const cleanupKeyboard = setupKeyboardNavigation();

  // 页面切换动画
  playPageTransition();

  // 1.5秒后隐藏加载动画，开始入场动画
  setTimeout(() => {
    showLoading.value = false;

    setTimeout(() => {
      playEnterAnimation();
      playGoldFlowAnimation();
      playInkSplashAnimation();
    }, 300);
  }, 1500);

  setTimeout(() => {
    hideScrollHint();
  }, 3000);

  // 清理
  onUnmounted(() => {
    cleanupKeyboard?.();
    if (audioContext.value) {
      audioContext.value.close();
      audioContext.value = null;
    }

    // 清理GSAP动画
    gsap.killTweensOf('.timeline3d-node');
    gsap.killTweensOf('.track-glow');
    gsap.killTweensOf('.ink-splash');
    gsap.killTweensOf('.detail-content');
    gsap.killTweensOf('.timeline3d-container');

    // 清理事件监听器
    const scene = sceneRef.value;
    if (scene) {
      scene.removeEventListener('wheel', () => {});
      scene.removeEventListener('touchstart', () => {});
      scene.removeEventListener('touchmove', () => {});
    }
  });
});

onUnmounted(() => {
  gsap.killTweensOf('.timeline3d-node');
  gsap.killTweensOf('.track-glow');
  gsap.killTweensOf('.ink-splash');
});
</script>

<style scoped>
/* 宣纸纹理背景 */
.paper-texture-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #F8F5F0;
  background-image:
    url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)' opacity='0.08'/%3E%3C/svg%3E"),
    radial-gradient(circle at 20% 30%, rgba(212, 175, 55, 0.05) 0%, transparent 50%),
    radial-gradient(circle at 80% 70%, rgba(45, 74, 64, 0.05) 0%, transparent 50%);
  pointer-events: none;
  z-index: -2;
  /* 优化字体渲染 */
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-rendering: optimizeLegibility;
  font-feature-settings: "kern" 1, "liga" 1;
}

/* 水墨晕染装饰 */
.ink-decoration {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  overflow: hidden;
  pointer-events: none;
  z-index: -1;
}

.ink-splash {
  position: absolute;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(26, 18, 11, 0.1) 0%, transparent 70%);
  filter: blur(20px);
}

.ink-splash-1 {
  width: 300px;
  height: 300px;
  top: 10%;
  left: 5%;
}

.ink-splash-2 {
  width: 400px;
  height: 400px;
  top: 50%;
  right: 10%;
}

.ink-splash-3 {
  width: 250px;
  height: 250px;
  bottom: 10%;
  left: 60%;
}

/* 3D场景容器 */
.timeline3d-container {
  position: relative;
  width: 100%;
  height: 600px;
  overflow: hidden;
  perspective: 1200px;
}

.timeline3d-scene {
  position: relative;
  width: 100%;
  height: 100%;
  overflow-x: auto;
  overflow-y: visible;
  transform-style: preserve-3d;
  scrollbar-width: thin;
  scrollbar-color: rgba(212, 175, 55, 0.3) transparent;
}

/* FPS监控 */
.fps-monitor {
  position: fixed;
  top: 10px;
  right: 10px;
  background: rgba(0, 0, 0, 0.8);
  color: #0f0;
  padding: 8px 12px;
  border-radius: 8px;
  font-family: 'Courier New', monospace;
  font-size: 14px;
  font-weight: 900;
  z-index: 9999;
  display: flex;
  align-items: center;
  gap: 4px;
  backdrop-filter: blur(4px);
}

.fps-value {
  font-size: 16px;
}

.fps-label {
  font-size: 12px;
  opacity: 0.8;
}

/* 自定义滚动条 */
.timeline3d-scene::-webkit-scrollbar {
  height: 8px;
}

.timeline3d-scene::-webkit-scrollbar-track {
  background: rgba(212, 175, 55, 0.1);
  border-radius: 4px;
}

.timeline3d-scene::-webkit-scrollbar-thumb {
  background: rgba(212, 175, 55, 0.3);
  border-radius: 4px;
  transition: background 0.3s;
}

.timeline3d-scene::-webkit-scrollbar-thumb:hover {
  background: rgba(212, 175, 55, 0.5);
}

/* 弧形轨道 */
.timeline3d-track {
  position: relative;
  width: 1000px;
  height: 300px;
  margin: 50px auto;
  transform-style: preserve-3d;
  padding: 0 40px; /* 增加内边距，给翻转留空间 */
}

/* 骨架屏 */
.skeleton-loading {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  gap: 24px;
  padding: 20px;
  justify-content: center;
  align-items: center;
}

.skeleton-node {
  width: 150px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  animation: skeletonPulse 1.5s ease-in-out infinite;
}

.skeleton-node:nth-child(2) {
  animation-delay: 0.2s;
}

.skeleton-node:nth-child(3) {
  animation-delay: 0.4s;
}

.skeleton-node:nth-child(4) {
  animation-delay: 0.6s;
}

.skeleton-node:nth-child(5) {
  animation-delay: 0.8s;
}

.skeleton-marker {
  width: 64px;
  height: 64px;
  border-radius: 12px;
  background: linear-gradient(90deg,
    rgba(212, 175, 55, 0.1) 0%,
    rgba(212, 175, 55, 0.2) 50%,
    rgba(212, 175, 55, 0.1) 100%
  );
  border: 2px solid rgba(212, 175, 55, 0.2);
}

.skeleton-content {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.skeleton-title {
  height: 20px;
  width: 80%;
  margin: 0 auto;
  background: linear-gradient(90deg,
    rgba(212, 175, 55, 0.1) 0%,
    rgba(212, 175, 55, 0.2) 50%,
    rgba(212, 175, 55, 0.1) 100%
  );
  border-radius: 4px;
}

.skeleton-stats {
  height: 14px;
  width: 60%;
  margin: 0 auto;
  background: linear-gradient(90deg,
    rgba(212, 175, 55, 0.1) 0%,
    rgba(212, 175, 55, 0.2) 50%,
    rgba(212, 175, 55, 0.1) 100%
  );
  border-radius: 4px;
}

@keyframes skeletonPulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.6;
  }
}

.track-line {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
}

.track-path {
  stroke-dasharray: 1000;
  stroke-dashoffset: 1000;
  animation: drawPath 2s ease-out forwards;
}

.track-glow {
  stroke-dasharray: 100 900;
  stroke-dashoffset: 1000;
  opacity: 0.6;
  filter: url(#glow);
}

@keyframes drawPath {
  to {
    stroke-dashoffset: 0;
  }
}

/* 3D节点 */
.timeline3d-node {
  position: absolute;
  width: 150px; /* 缩小宽度，从180→150 */
  transform-style: preserve-3d;
  cursor: pointer;
  transition: z-index 0s;
}

.timeline3d-node:hover {
  z-index: 1000;
}

.timeline3d-node:hover {
  z-index: 100;
}

.timeline3d-node:hover {
  z-index: 1000;
}

.timeline3d-node:hover .card3d {
  transform: rotateY(180deg);
}

/* 3D卡片 */
.card3d {
  position: relative;
  width: 100%;
  height: 240px;
  transform-style: preserve-3d;
  transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1);
  will-change: transform;
}

.card3d-front,
.card3d-back {
  position: absolute;
  width: 100%;
  height: 100%;
  backface-visibility: hidden;
  border-radius: 16px;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 16px;
  box-shadow: 0 8px 32px rgba(212, 175, 55, 0.25);
}

/* 卡片正面 */
.card3d-front {
  background: linear-gradient(135deg,
    rgba(253, 251, 247, 0.98),
    rgba(246, 240, 230, 0.95)
  );
  border: 2px solid rgba(212, 175, 55, 0.4);
  transform: rotateY(0deg);
  overflow: hidden;
  position: relative;
}

/* 竹简装饰框架 */
.bamboo-frame {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
}

.bamboo-strip {
  position: absolute;
  left: 0;
  right: 0;
  height: 12px;
  background: linear-gradient(90deg,
    rgba(139, 119, 101, 0.3),
    rgba(139, 119, 101, 0.1),
    rgba(139, 119, 101, 0.3)
  );
  border: 1px solid rgba(139, 119, 101, 0.2);
}

.bamboo-strip.top {
  top: 0;
  border-radius: 14px 14px 0 0;
}

.bamboo-strip.bottom {
  bottom: 0;
  border-radius: 0 0 14px 14px;
}

/* 卡片背面 */
.card3d-back {
  background: linear-gradient(135deg,
    rgba(212, 175, 55, 0.95),
    rgba(184, 134, 11, 0.9)
  );
  border: 2px solid #d4af37;
  transform: rotateY(180deg);
  justify-content: center;
  color: #fff;
  overflow: hidden;
}

.back-decoration {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  opacity: 0.1;
}

.back-pattern {
  width: 100%;
  height: 100%;
  background-image:
    repeating-linear-gradient(45deg,
      transparent,
      transparent 10px,
      rgba(255, 255, 255, 0.1) 10px,
      rgba(255, 255, 255, 0.1) 20px
    );
}

/* 日期标签 */
.node-date {
  font-size: 13px;
  color: #9d8b7a;
  font-weight: 700;
  margin-bottom: 12px;
  text-align: center;
  display: flex;
  align-items: center;
  gap: 4px;
  font-family: "思源宋体", "STSong", "SimSun", "KaiTi", "楷体", serif;
  letter-spacing: 0.5px;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.date-icon {
  font-size: 14px;
}

/* 节点标记（玉琮造型） */
.node-marker {
  width: 64px;
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  margin-bottom: 12px;
}

.jade-cong {
  width: 100%;
  height: 100%;
  border-radius: 12px;
  background: linear-gradient(135deg,
    rgba(212, 175, 55, 0.3),
    rgba(184, 134, 11, 0.2)
  );
  border: 3px solid #d4af37;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow:
    0 4px 16px rgba(212, 175, 55, 0.4),
    inset 0 2px 8px rgba(212, 175, 55, 0.3),
    inset 0 -2px 8px rgba(26, 18, 11, 0.1);
  position: relative;
}

.jade-inner {
  width: 44px;
  height: 44px;
  border-radius: 8px;
  background: linear-gradient(135deg, #fff, #f5f3ef);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 22px;
  box-shadow:
    inset 0 2px 4px rgba(255, 255, 255, 0.8),
    inset 0 -2px 4px rgba(0, 0, 0, 0.1);
}

.badge {
  position: absolute;
  top: -6px;
  right: -6px;
  background: linear-gradient(135deg, #ff6b6b, #ff4757);
  color: white;
  font-size: 10px;
  padding: 2px 6px;
  border-radius: 999px;
  font-weight: 900;
  border: 2px solid #fff;
  box-shadow: 0 2px 8px rgba(255, 71, 87, 0.5);
  white-space: nowrap;
  z-index: 10;
}

.mark-icon {
  font-size: 24px;
}

/* 内容区域 */
.node-content {
  text-align: center;
  width: 100%;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.work-title {
  font-weight: 900;
  color: #3a2e2b;
  font-size: 16px;
  margin-bottom: 12px;
  font-family: "思源宋体", "STSong", "SimSun", "KaiTi", "楷体", serif;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
  letter-spacing: 0.3px;
  text-shadow: 0 1px 1px rgba(255, 255, 255, 0.5);
  word-break: break-word;
  hyphens: auto;
}

.work-stats {
  font-size: 12px;
  color: #9d8b7a;
  display: flex;
  gap: 8px;
  align-items: center;
  justify-content: center;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 4px;
}

.stat-icon {
  font-size: 14px;
}

.stat-number {
  font-weight: 700;
  color: #3a2e2b;
}

.dot {
  color: rgba(212, 175, 55, 0.4);
  font-size: 14px;
}

/* 卡片背面内容 */
.preview-text {
  font-size: 18px;
  font-weight: 900;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  z-index: 1;
}

.preview-icon {
  font-size: 32px;
  display: block;
}

.preview-subtitle {
  font-size: 14px;
  font-weight: 700;
  color: rgba(255, 255, 255, 0.8);
  margin-top: 8px;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  z-index: 1;
}

/* 滚动提示 */
.scroll-hint {
  position: absolute;
  bottom: 24px;
  left: 50%;
  transform: translateX(-50%);
  background: linear-gradient(135deg,
    rgba(212, 175, 55, 0.95),
    rgba(184, 134, 11, 0.9)
  );
  color: #fff;
  padding: 12px 24px;
  border-radius: 999px;
  font-size: 14px;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 8px;
  box-shadow: 0 4px 16px rgba(212, 175, 55, 0.4);
  animation: pulse 2s infinite;
  z-index: 10;
}

.hint-icon {
  font-size: 18px;
  animation: slideX 1s ease-in-out infinite;
}

.hint-text {
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
    transform: translateX(-50%) scale(1);
  }
  50% {
    opacity: 0.85;
    transform: translateX(-50%) scale(0.98);
  }
}

@keyframes slideX {
  0%, 100% {
    transform: translateX(0);
  }
  50% {
    transform: translateX(-4px);
  }
}

/* 加载动画 */
.loading-animation {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(248, 245, 240, 0.95);
  z-index: 1000;
  backdrop-filter: blur(10px);
}

.scroll-container {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 20px 40px;
  background: linear-gradient(135deg,
    rgba(212, 175, 55, 0.1),
    rgba(184, 134, 11, 0.05)
  );
  border: 2px solid rgba(212, 175, 55, 0.3);
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(212, 175, 55, 0.2);
}

.scroll-left,
.scroll-right {
  width: 40px;
  height: 80px;
  background: linear-gradient(180deg,
    rgba(139, 119, 101, 0.4),
    rgba(139, 119, 101, 0.2)
  );
  border-radius: 8px;
  border: 2px solid rgba(139, 119, 101, 0.3);
  position: relative;
  overflow: hidden;
}

.scroll-left::before,
.scroll-right::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 30%;
  background: repeating-linear-gradient(
    180deg,
    transparent,
    transparent 4px,
    rgba(255, 255, 255, 0.2) 4px,
    rgba(255, 255, 255, 0.2) 8px
  );
}

.scroll-left {
  animation: scrollUnrollLeft 1.5s ease-out forwards;
  transform-origin: left center;
}

.scroll-right {
  animation: scrollUnrollRight 1.5s ease-out forwards;
  transform-origin: right center;
}

.scroll-center {
  flex: 1;
  text-align: center;
}

.scroll-text {
  font-size: 16px;
  font-weight: 900;
  color: #d4af37;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  animation: textFadeIn 1.5s ease-out forwards;
  opacity: 0;
}

@keyframes scrollUnrollLeft {
  0% {
    transform: scaleX(0);
  }
  100% {
    transform: scaleX(1);
  }
}

@keyframes scrollUnrollRight {
  0% {
    transform: scaleX(0);
  }
  100% {
    transform: scaleX(1);
  }
}

@keyframes textFadeIn {
  0% {
    opacity: 0;
    transform: scale(0.8);
  }
  50% {
    opacity: 0;
    transform: scale(0.8);
  }
  100% {
    opacity: 1;
    transform: scale(1);
  }
}

.loading-fade-enter-active,
.loading-fade-leave-active {
  transition: opacity 0.5s ease;
}

.loading-fade-enter-from,
.loading-fade-leave-to {
  opacity: 0;
}

/* 详情弹窗 */
.detail-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 10000;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.detail-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(26, 18, 11, 0.7);
  backdrop-filter: blur(8px);
}

.detail-content {
  position: relative;
  width: 100%;
  max-width: 480px;
  background: linear-gradient(135deg,
    rgba(253, 251, 247, 0.98),
    rgba(246, 240, 230, 0.95)
  );
  border-radius: 20px;
  border: 2px solid rgba(212, 175, 55, 0.4);
  box-shadow:
    0 20px 60px rgba(0, 0, 0, 0.3),
    0 0 40px rgba(212, 175, 55, 0.2);
  padding: 32px;
  transform-style: preserve-3d;
  perspective: 1000px;
}

.detail-close {
  position: absolute;
  top: 16px;
  right: 16px;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: linear-gradient(135deg,
    rgba(212, 175, 55, 0.2),
    rgba(184, 134, 11, 0.1)
  );
  border: 2px solid rgba(212, 175, 55, 0.3);
  color: #3a2e2b;
  font-size: 18px;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.detail-close:hover {
  background: linear-gradient(135deg,
    rgba(255, 107, 107, 0.9),
    rgba(255, 71, 87, 0.8)
  );
  border-color: #ff6b6b;
  color: #fff;
  transform: rotate(90deg);
}

.detail-decoration {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
}

.decoration-line {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  width: 60%;
  height: 2px;
  background: linear-gradient(90deg,
    transparent,
    rgba(212, 175, 55, 0.5),
    transparent
  );
}

.decoration-line.top {
  top: 8px;
}

.decoration-line.bottom {
  bottom: 8px;
}

.corner-decoration {
  position: absolute;
  width: 40px;
  height: 40px;
  pointer-events: none;
}

.corner-decoration.top-left {
  top: 8px;
  left: 8px;
}

.corner-decoration.top-right {
  top: 8px;
  right: 8px;
}

.corner-decoration.bottom-left {
  bottom: 8px;
  left: 8px;
}

.corner-decoration.bottom-right {
  bottom: 8px;
  right: 8px;
}

.corner-svg {
  width: 100%;
  height: 100%;
  color: #d4af37;
}

.cloud-decoration {
  position: absolute;
  bottom: 12px;
  left: 50%;
  transform: translateX(-50%);
  width: 80px;
  height: 32px;
  pointer-events: none;
}

.cloud-svg {
  width: 100%;
  height: 100%;
  color: #d4af37;
}

.detail-body {
  text-align: center;
}

.detail-icon {
  font-size: 48px;
  margin-bottom: 16px;
  display: block;
}

.detail-title {
  font-size: 24px;
  font-weight: 900;
  color: #3a2e2b;
  margin-bottom: 16px;
  font-family: "思源宋体", "STSong", "SimSun", "KaiTi", "楷体", serif;
  line-height: 1.5;
  letter-spacing: 0.5px;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  word-break: break-word;
}

.detail-meta {
  display: flex;
  justify-content: center;
  gap: 16px;
  margin-bottom: 20px;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  color: #9d8b7a;
  font-weight: 700;
}

.meta-icon {
  font-size: 16px;
}

.detail-divider {
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 20px 0;
}

.divider-icon {
  font-size: 12px;
  color: rgba(212, 175, 55, 0.5);
  padding: 0 16px;
  position: relative;
}

.divider-icon::before,
.divider-icon::after {
  content: '';
  position: absolute;
  top: 50%;
  width: 60px;
  height: 1px;
  background: linear-gradient(90deg,
    transparent,
    rgba(212, 175, 55, 0.3),
    transparent
  );
}

.divider-icon::before {
  right: 100%;
}

.divider-icon::after {
  left: 100%;
}

.detail-description {
  font-size: 15px;
  color: #6b5c54;
  line-height: 1.8;
  margin-bottom: 24px;
  font-family: "思源宋体", "STSong", "SimSun", "KaiTi", "楷体", serif;
  letter-spacing: 0.3px;
  text-align: justify;
  text-justify: inter-ideograph;
}

.detail-action {
  width: 100%;
  padding: 14px 24px;
  border-radius: 12px;
  background: linear-gradient(135deg,
    rgba(212, 175, 55, 0.9),
    rgba(184, 134, 11, 0.85)
  );
  border: 2px solid #d4af37;
  color: #fff;
  font-size: 16px;
  font-weight: 900;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

.detail-action:hover {
  background: linear-gradient(135deg,
    rgba(184, 134, 11, 1),
    rgba(212, 175, 55, 0.95)
  );
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(212, 175, 55, 0.4);
}

.action-arrow {
  font-size: 18px;
  transition: transform 0.3s ease;
}

.detail-action:hover .action-arrow {
  transform: translateX(4px);
}

/* 弹窗动画 */
.detail-fade-enter-active,
.detail-fade-leave-active {
  transition: opacity 0.3s ease;
}

.detail-fade-enter-from,
.detail-fade-leave-to {
  opacity: 0;
}

.detail-fade-enter-to .detail-overlay,
.detail-fade-leave-from .detail-overlay {
  opacity: 1;
}

.detail-fade-enter-from .detail-overlay,
.detail-fade-leave-to .detail-overlay {
  opacity: 0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .timeline3d-container {
    height: 400px;
  }

  .timeline3d-track {
    width: 800px;
    height: 200px;
    padding: 0 20px;
  }

  .timeline3d-node {
    width: 120px; /* 移动端进一步缩小 */
  }

  .card3d {
    height: 200px;
  }

  .node-marker {
    width: 54px;
    height: 54px;
  }

  .jade-inner {
    width: 36px;
    height: 36px;
    font-size: 18px;
  }

  .work-title {
    font-size: 14px;
  }

  .work-stats {
    font-size: 11px;
  }

  .bamboo-strip {
    height: 8px;
  }

  /* FPS监控移动端优化 */
  .fps-monitor {
    top: 5px;
    right: 5px;
    padding: 4px 8px;
    font-size: 12px;
  }

  .fps-value {
    font-size: 14px;
  }
}

/* 响应式设计 - 小屏手机 */
@media (max-width: 480px) {
  .timeline3d-container {
    height: 350px;
  }

  .timeline3d-track {
    width: 700px;
    height: 180px;
  }

  .timeline3d-node {
    width: 100px;
  }

  .card3d {
    height: 180px;
    padding: 12px;
  }

  .node-marker {
    width: 48px;
    height: 48px;
  }

  .jade-inner {
    width: 32px;
    height: 32px;
    font-size: 16px;
  }

  .work-title {
    font-size: 13px;
  }

  .work-stats {
    font-size: 10px;
  }
}

/* 错误提示 */
.error-message {
  position: fixed;
  top: 80px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 10001;
}

.error-content {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px 24px;
  background: linear-gradient(135deg,
    rgba(255, 107, 107, 0.95),
    rgba(255, 71, 87, 0.9)
  );
  border: 2px solid #ff6b6b;
  border-radius: 12px;
  box-shadow:
    0 8px 24px rgba(255, 71, 87, 0.4),
    0 0 40px rgba(255, 71, 87, 0.2);
  backdrop-filter: blur(10px);
}

.error-icon {
  font-size: 24px;
  animation: errorPulse 1s ease-in-out infinite;
}

.error-text {
  font-size: 15px;
  font-weight: 900;
  color: #fff;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

@keyframes errorPulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.2);
  }
}

.error-shake-enter-active {
  animation: shakeIn 0.5s ease-out;
}

.error-shake-leave-active {
  animation: shakeOut 0.3s ease-in;
}

@keyframes shakeIn {
  0% {
    opacity: 0;
    transform: translateX(-50%) translateY(-20px) scale(0.8);
  }
  50% {
    opacity: 1;
    transform: translateX(-50%) translateY(0) scale(1.05);
  }
  70% {
    transform: translateX(-52%) translateY(0) scale(1);
  }
  90% {
    transform: translateX(-48%) translateY(0) scale(1);
  }
  100% {
    opacity: 1;
    transform: translateX(-50%) translateY(0) scale(1);
  }
}

@keyframes shakeOut {
  0% {
    opacity: 1;
    transform: translateX(-50%) scale(1);
  }
  100% {
    opacity: 0;
    transform: translateX(-50%) translateY(-10px) scale(0.9);
  }
}
</style>
