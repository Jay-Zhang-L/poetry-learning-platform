<template>
  <div class="timeline3d-advanced-container" ref="containerRef">
    <!-- Three.js Canvas -->
    <canvas ref="canvasRef" class="timeline-canvas"></canvas>

    <!-- 加载动画 -->
    <transition name="loading-fade">
      <div v-if="showLoading" class="loading-animation-3d">
        <div class="scroll-container">
          <div class="scroll-left"></div>
          <div class="scroll-center">
            <div class="scroll-text">正在构建3D场景...</div>
          </div>
          <div class="scroll-right"></div>
        </div>
      </div>
    </transition>

    <!-- 空数据提示 -->
    <div v-if="timelineData.length === 0" class="empty-3d-state">
      <div class="empty-3d-content">
        <div class="empty-3d-icon">🎨</div>
        <div class="empty-3d-text">暂无创作数据</div>
        <div class="empty-3d-subtext">开始创作您的第一首诗词吧</div>
      </div>
    </div>

    <!-- UI层 -->
    <div class="ui-layer">
      <!-- 标题 -->
      <div class="timeline-title">
        <h1>创作时光轴</h1>
        <div class="title-decoration"></div>
      </div>

      <!-- 控制提示 -->
      <div class="controls-hint" v-if="showControlsHint">
        <div class="hint-item">
          <span class="hint-icon">🖱️</span>
          <span class="hint-text">拖拽旋转</span>
        </div>
        <div class="hint-item">
          <span class="hint-icon">🔄</span>
          <span class="hint-text">滚轮缩放</span>
        </div>
        <div class="hint-item">
          <span class="hint-icon">⌨️</span>
          <span class="hint-text">方向键导航</span>
        </div>
      </div>
    </div>

    <!-- 详情弹窗 -->
    <transition name="detail-fade">
      <div v-if="showDetail" class="detail-modal-3d" @click="closeDetail">
        <div class="detail-overlay"></div>
        <div class="detail-content-3d" @click.stop>
          <button class="detail-close" @click="closeDetail">
            <span>✕</span>
          </button>
          <div class="detail-decoration-3d">
            <div class="corner top-left"></div>
            <div class="corner top-right"></div>
            <div class="corner bottom-left"></div>
            <div class="corner bottom-right"></div>
          </div>
          <div class="detail-body-3d">
            <div class="detail-icon-3d">📜</div>
            <h3 class="detail-title-3d">{{ selectedNode?.title }}</h3>
            <div class="detail-meta-3d">
              <span class="meta-item-3d">
                <span class="meta-icon-3d">📅</span>
                {{ selectedNode?.dateLabel }}
              </span>
              <span class="meta-item-3d">
                <span class="meta-icon-3d">👍</span>
                {{ selectedNode?.likes }}
              </span>
              <span class="meta-item-3d">
                <span class="meta-icon-3d">💬</span>
                {{ selectedNode?.comments }}
              </span>
            </div>
            <div class="detail-divider-3d">
              <span class="divider-icon-3d">❖</span>
            </div>
            <p class="detail-description-3d">
              点击查看完整诗词内容和创作背景
            </p>
            <button class="detail-action-3d" @click="goToWork(selectedNode?.id)">
              <span>查看详情</span>
              <span class="action-arrow-3d">→</span>
            </button>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed, watch } from 'vue';
import { useRouter } from 'vue-router';
import * as THREE from 'three';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js';
import gsap from 'gsap';

const props = defineProps({
  timelineData: {
    type: Array,
    default: () => []
  }
});

const router = useRouter();
const containerRef = ref(null);
const canvasRef = ref(null);
const showLoading = ref(true);
const showControlsHint = ref(true);
const showDetail = ref(false);
const selectedNode = ref(null);

// 音频系统
const audioContext = ref(null);

// Three.js 核心对象
let scene, camera, renderer, controls;
let timelineGroup, cardsGroup, particlesGroup;
let raycaster, mouse;
let animationId;
const cards = [];
let hoveredCard = null;

// 初始化Three.js场景
function initThreeJS() {
  if (!canvasRef.value) return;

  console.log('Initializing Three.js...', {
    dataLength: props.timelineData.length,
    canvasSize: {
      width: canvasRef.value.clientWidth,
      height: canvasRef.value.clientHeight
    }
  });

  // 1. 创建场景
  scene = new THREE.Scene();
  scene.background = new THREE.Color(0xF8F5F0); // 宣纸白
  scene.fog = new THREE.Fog(0xF8F5F0, 10, 50);

  // 2. 创建相机
  const aspect = canvasRef.value.clientWidth / canvasRef.value.clientHeight;
  camera = new THREE.PerspectiveCamera(60, aspect, 0.1, 1000);

  // 响应式相机位置
  const isMobile = canvasRef.value.clientWidth < 768;
  camera.position.set(0, isMobile ? 7 : 5, isMobile ? 18 : 15);
  camera.lookAt(0, 0, 0);

  // 3. 创建渲染器
  renderer = new THREE.WebGLRenderer({
    canvas: canvasRef.value,
    antialias: true,
    alpha: true
  });
  renderer.setSize(canvasRef.value.clientWidth, canvasRef.value.clientHeight);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
  renderer.shadowMap.enabled = true;
  renderer.shadowMap.type = THREE.PCFSoftShadowMap;

  // 4. 创建控制器
  controls = new OrbitControls(camera, renderer.domElement);
  controls.enableDamping = true;
  controls.dampingFactor = 0.05;
  controls.maxPolarAngle = Math.PI / 2; // 限制俯仰角
  controls.minDistance = 8;
  controls.maxDistance = 25;

  // 5. 添加光照
  setupLighting();

  // 6. 创建时光轴
  if (props.timelineData.length > 0) {
    createTimeline();
  } else {
    console.warn('No timeline data available');
  }

  // 7. 创建背景
  createBackground();

  // 8. 创建粒子系统
  createParticles();

  // 9. 设置交互
  setupInteraction();

  // 10. 开始动画循环
  animate();

  // 11. 窗口大小调整
  window.addEventListener('resize', onWindowResize);

  // 12. 隐藏加载动画
  setTimeout(() => {
    showLoading.value = false;

    // 3秒后隐藏控制提示
    setTimeout(() => {
      showControlsHint.value = false;
    }, 3000);
  }, 2000);

  // 13. 初始化音频系统
  initAudioSystem();

  console.log('Three.js initialized successfully');
}

// 初始化音频系统
function initAudioSystem() {
  try {
    const AudioContext = window.AudioContext || window.webkitAudioContext;
    if (AudioContext) {
      audioContext.value = new AudioContext();
    }
  } catch (e) {
    console.warn('Web Audio API not supported:', e);
  }
}

// 播放音效
function playSound(type) {
  if (!audioContext.value) return;

  try {
    const ctx = audioContext.value;
    const oscillator = ctx.createOscillator();
    const gainNode = ctx.createGain();

    oscillator.connect(gainNode);
    gainNode.connect(ctx.destination);

    // 配置不同音效
    switch (type) {
      case 'hover':
        oscillator.frequency.setValueAtTime(800, ctx.currentTime);
        gainNode.gain.setValueAtTime(0.05, ctx.currentTime);
        gainNode.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.1);
        oscillator.stop(ctx.currentTime + 0.1);
        break;
      case 'click':
        oscillator.frequency.setValueAtTime(1000, ctx.currentTime);
        gainNode.gain.setValueAtTime(0.08, ctx.currentTime);
        gainNode.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.15);
        oscillator.stop(ctx.currentTime + 0.15);
        break;
      case 'open':
        oscillator.frequency.setValueAtTime(600, ctx.currentTime);
        oscillator.frequency.exponentialRampToValueAtTime(400, ctx.currentTime + 0.3);
        gainNode.gain.setValueAtTime(0.1, ctx.currentTime);
        gainNode.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.4);
        oscillator.stop(ctx.currentTime + 0.4);
        break;
      case 'close':
        oscillator.frequency.setValueAtTime(400, ctx.currentTime);
        oscillator.frequency.exponentialRampToValueAtTime(300, ctx.currentTime + 0.15);
        gainNode.gain.setValueAtTime(0.08, ctx.currentTime);
        gainNode.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.2);
        oscillator.stop(ctx.currentTime + 0.2);
        break;
    }

    oscillator.type = 'sine';
    oscillator.start(ctx.currentTime);
  } catch (e) {
    console.warn('Sound playback failed:', e);
  }
}

// 设置光照
function setupLighting() {
  // 环境光
  const ambientLight = new THREE.AmbientLight(0xffffff, 0.6);
  scene.add(ambientLight);

  // 主方向光（模拟太阳光）
  const directionalLight = new THREE.DirectionalLight(0xfff5e6, 0.8);
  directionalLight.position.set(10, 20, 10);
  directionalLight.castShadow = true;
  directionalLight.shadow.mapSize.width = 2048;
  directionalLight.shadow.mapSize.height = 2048;
  scene.add(directionalLight);

  // 点光源（鎏金效果）
  const pointLight1 = new THREE.PointLight(0xd4af37, 0.5, 20);
  pointLight1.position.set(0, 5, 0);
  scene.add(pointLight1);

  // 边缘光（增强3D感）
  const rectAreaLight = new THREE.RectAreaLight(0xffffff, 0.3);
  rectAreaLight.position.set(0, 10, -10);
  rectAreaLight.lookAt(0, 0, 0);
  rectAreaLight.width = 30;
  rectAreaLight.height = 10;
  scene.add(rectAreaLight);
}

// 创建弧形时光轴
function createTimeline() {
  timelineGroup = new THREE.Group();
  scene.add(timelineGroup);

  // 根据数据量调整曲线
  const dataLength = props.timelineData.length || 1;

  // 创建弧形路径
  const curvePoints = [];
  const spread = Math.max(10, dataLength * 2); // 根据数据量扩展范围

  for (let i = 0; i <= dataLength; i++) {
    const t = i / dataLength;
    const x = (t - 0.5) * spread * 2;
    const y = Math.sin(t * Math.PI) * 2; // 弧形高度
    const z = Math.cos(t * Math.PI * 2) * 2; // 螺旋深度
    curvePoints.push(new THREE.Vector3(x, y, z));
  }

  const curve = new THREE.CatmullRomCurve3(curvePoints);

  // 创建管道几何体（时光轴轨道）
  const tubeGeometry = new THREE.TubeGeometry(curve, 100, 0.15, 8, false);
  const tubeMaterial = new THREE.MeshStandardMaterial({
    color: 0xd4af37,
    metalness: 0.8,
    roughness: 0.2,
    emissive: 0xd4af37,
    emissiveIntensity: 0.2
  });
  const timelineMesh = new THREE.Mesh(tubeGeometry, tubeMaterial);
  timelineMesh.castShadow = true;
  timelineGroup.add(timelineMesh);

  // 创建卡片容器
  cardsGroup = new THREE.Group();
  timelineGroup.add(cardsGroup);

  // 沿曲线分布卡片
  if (props.timelineData.length > 0) {
    props.timelineData.forEach((node, index) => {
      const t = index / (props.timelineData.length - 1 || 1);
      const point = curve.getPointAt(t);
      create3DCard(node, point, index);
    });
  }
}

// 创建3D卡片
function create3DCard(node, position, index) {
  const cardGroup = new THREE.Group();
  cardGroup.position.copy(position);

  // 计算朝向（面向切线方向）
  const tangent = new THREE.Vector3(1, 0, 0); // 简化切线
  const targetPos = position.clone().add(tangent);
  cardGroup.lookAt(targetPos);

  // 卡片基座（玉琮造型）
  const baseGeometry = new THREE.CylinderGeometry(0.6, 0.6, 0.15, 8);
  const baseMaterial = new THREE.MeshStandardMaterial({
    color: 0xd4af37,
    metalness: 0.9,
    roughness: 0.1,
    emissive: 0xd4af37,
    emissiveIntensity: 0.3
  });
  const base = new THREE.Mesh(baseGeometry, baseMaterial);
  base.position.y = 0.5;
  base.castShadow = true;
  base.receiveShadow = true;
  cardGroup.add(base);

  // 卡片主体
  const cardGeometry = new THREE.BoxGeometry(1.2, 0.8, 0.1);
  const cardMaterial = new THREE.MeshStandardMaterial({
    color: 0xfaf5ef,
    metalness: 0.1,
    roughness: 0.8,
    side: THREE.DoubleSide
  });
  const card = new THREE.Mesh(cardGeometry, cardMaterial);
  card.position.y = 0.7;
  card.castShadow = true;
  card.receiveShadow = true;
  card.userData = { node, index }; // 存储数据
  cards.push(card);
  cardGroup.add(card);

  // 添加文字（使用Canvas纹理）
  createTextTexture(card, node);

  // 悬浮动画
  gsap.to(cardGroup.position, {
    y: position.y + Math.sin(index * 0.5) * 0.3,
    duration: 2 + index * 0.1,
    repeat: -1,
    yoyo: true,
    ease: "sine.inOut"
  });

  // 缓慢旋转
  gsap.to(cardGroup.rotation, {
    y: Math.PI * 2,
    duration: 20 + index * 2,
    repeat: -1,
    ease: "none"
  });

  cardsGroup.add(cardGroup);
  scene.add(cardGroup);
}

// 创建文字纹理
function createTextTexture(cardGroup, node) {
  const canvas = document.createElement('canvas');
  const ctx = canvas.getContext('2d');
  canvas.width = 256;
  canvas.height = 128;

  // 清空画布
  ctx.fillStyle = '#f5f3ef';
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  // 绘制文字
  ctx.fillStyle = '#3a2e2b';
  ctx.font = 'bold 20px "思源宋体", serif';
  ctx.textAlign = 'center';
  ctx.fillText(node.title, canvas.width / 2, 30);

  ctx.font = '14px "思源宋体", serif';
  ctx.fillStyle = '#9d8b7a';
  ctx.fillText(`👍 ${node.likes}  💬 ${node.comments}`, canvas.width / 2, 60);

  // 创建纹理
  const texture = new THREE.CanvasTexture(canvas);
  texture.needsUpdate = true;

  // 应用到卡片正面
  const faceMaterial = new THREE.MeshBasicMaterial({
    map: texture,
    transparent: true
  });

  const faceGeometry = new THREE.PlaneGeometry(1.0, 0.6);
  const face = new THREE.Mesh(faceGeometry, faceMaterial);
  face.position.set(0, 0.7, 0.06);
  cardGroup.add(face);
}

// 创建背景（水墨远山）
function createBackground() {
  // 远山（使用平面+透明度渐变）
  const mountainGeometry = new THREE.PlaneGeometry(60, 20);
  const mountainMaterial = new THREE.MeshBasicMaterial({
    color: 0x8b9bb4,
    transparent: true,
    opacity: 0.1,
    side: THREE.DoubleSide
  });
  const mountain = new THREE.Mesh(mountainGeometry, mountainMaterial);
  mountain.position.set(0, 5, -15);
  scene.add(mountain);

  // 云雾（粒子系统）
  const cloudGeometry = new THREE.BufferGeometry();
  const cloudCount = 50;
  const positions = new Float32Array(cloudCount * 3);

  for (let i = 0; i < cloudCount; i++) {
    positions[i * 3] = (Math.random() - 0.5) * 40;
    positions[i * 3 + 1] = Math.random() * 5 + 2;
    positions[i * 3 + 2] = (Math.random() - 0.5) * 20 - 10;
  }

  cloudGeometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));

  const cloudMaterial = new THREE.PointsMaterial({
    color: 0xffffff,
    size: 0.3,
    transparent: true,
    opacity: 0.3,
    sizeAttenuation: true
  });

  const clouds = new THREE.Points(cloudGeometry, cloudMaterial);
  scene.add(clouds);

  // 云雾缓慢移动
  gsap.to(clouds.position, {
    x: 10,
    duration: 60,
    repeat: -1,
    yoyo: true,
    ease: "sine.inOut"
  });
}

// 创建粒子系统（鎏金流光 + 水墨晕染）
function createParticles() {
  particlesGroup = new THREE.Group();
  scene.add(particlesGroup);

  // 1. 鎏金流光粒子
  const goldParticleCount = 200;
  const goldGeometry = new THREE.BufferGeometry();
  const goldPositions = new Float32Array(goldParticleCount * 3);

  for (let i = 0; i < goldParticleCount; i++) {
    const t = i / goldParticleCount;
    const angle = t * Math.PI * 20;
    const radius = 5 + Math.random() * 10;

    goldPositions[i * 3] = Math.cos(angle) * radius;
    goldPositions[i * 3 + 1] = Math.random() * 3;
    goldPositions[i * 3 + 2] = Math.sin(angle) * radius;
  }

  goldGeometry.setAttribute('position', new THREE.BufferAttribute(goldPositions, 3));

  const goldMaterial = new THREE.PointsMaterial({
    color: 0xd4af37,
    size: 0.08,
    transparent: true,
    opacity: 0.6,
    blending: THREE.AdditiveBlending
  });

  const goldParticles = new THREE.Points(goldGeometry, goldMaterial);
  particlesGroup.add(goldParticles);

  // 2. 水墨晕染粒子（深灰色）
  const inkParticleCount = 150;
  const inkGeometry = new THREE.BufferGeometry();
  const inkPositions = new Float32Array(inkParticleCount * 3);
  const inkSizes = new Float32Array(inkParticleCount);

  for (let i = 0; i < inkParticleCount; i++) {
    const angle = Math.random() * Math.PI * 2;
    const radius = 8 + Math.random() * 12;

    inkPositions[i * 3] = Math.cos(angle) * radius;
    inkPositions[i * 3 + 1] = Math.random() * 2 - 0.5;
    inkPositions[i * 3 + 2] = Math.sin(angle) * radius;

    // 随机大小
    inkSizes[i] = 0.1 + Math.random() * 0.3;
  }

  inkGeometry.setAttribute('position', new THREE.BufferAttribute(inkPositions, 3));
  inkGeometry.setAttribute('size', new THREE.BufferAttribute(inkSizes, 1));

  const inkMaterial = new THREE.PointsMaterial({
    color: 0x2a2a2a,
    size: 0.15,
    transparent: true,
    opacity: 0.4,
    sizeAttenuation: true,
    blending: THREE.NormalBlending
  });

  const inkParticles = new THREE.Points(inkGeometry, inkMaterial);
  particlesGroup.add(inkParticles);

  // 3. 创建水墨晕染球体（低透明度大球体）
  for (let i = 0; i < 5; i++) {
    const inkSplashGeometry = new THREE.SphereGeometry(1 + Math.random() * 2, 32, 32);
    const inkSplashMaterial = new THREE.MeshBasicMaterial({
      color: 0x1a1a1a,
      transparent: true,
      opacity: 0.05 + Math.random() * 0.1
    });
    const inkSplash = new THREE.Mesh(inkSplashGeometry, inkSplashMaterial);

    inkSplash.position.set(
      (Math.random() - 0.5) * 20,
      Math.random() * 3,
      (Math.random() - 0.5) * 10 - 5
    );

    // 脉动动画
    gsap.to(inkSplash.scale, {
      x: 1.5,
      y: 1.5,
      z: 1.5,
      duration: 3 + Math.random() * 2,
      repeat: -1,
      yoyo: true,
      ease: "sine.inOut"
    });

    particlesGroup.add(inkSplash);
  }

  // 粒子旋转
  gsap.to(particlesGroup.rotation, {
    y: Math.PI * 2,
    duration: 30,
    repeat: -1,
    ease: "none"
  });

  // 水墨粒子单独动画
  gsap.to(inkParticles.rotation, {
    y: Math.PI * 4,
    duration: 45,
    repeat: -1,
    ease: "none"
  });
}

// 设置交互
function setupInteraction() {
  raycaster = new THREE.Raycaster();
  mouse = new THREE.Vector2();

  // 鼠标移动
  renderer.domElement.addEventListener('mousemove', onMouseMove);

  // 鼠标点击
  renderer.domElement.addEventListener('click', onMouseClick);

  // 键盘事件
  window.addEventListener('keydown', onKeyDown);
}

// 鼠标移动处理
function onMouseMove(event) {
  const rect = renderer.domElement.getBoundingClientRect();
  mouse.x = ((event.clientX - rect.left) / rect.width) * 2 - 1;
  mouse.y = -((event.clientY - rect.top) / rect.height) * 2 + 1;

  raycaster.setFromCamera(mouse, camera);

  // 检测卡片相交
  const intersects = raycaster.intersectObjects(cards);

  if (intersects.length > 0) {
    const object = intersects[0].object;

    if (hoveredCard !== object) {
      // 恢复之前的卡片
      if (hoveredCard) {
        gsap.to(hoveredCard.scale, {
          x: 1,
          z: 1,
          duration: 0.3
        });
      }

      // 高亮当前卡片
      hoveredCard = object;
      gsap.to(object.scale, {
        x: 1.2,
        z: 1.2,
        duration: 0.3
      });

      renderer.domElement.style.cursor = 'pointer';

      // 播放悬停音效
      playSound('hover');
    }
  } else {
    if (hoveredCard) {
      gsap.to(hoveredCard.scale, {
        x: 1,
        z: 1,
        duration: 0.3
      });
      hoveredCard = null;
    }
    renderer.domElement.style.cursor = 'grab';
  }
}

// 鼠标点击处理
function onMouseClick(event) {
  if (hoveredCard) {
    const node = hoveredCard.userData.node;
    playSound('click');
    openDetail(node);
  }
}

// 键盘控制
function onKeyDown(event) {
  switch(event.key) {
    case 'ArrowLeft':
      moveSelection(-1);
      break;
    case 'ArrowRight':
      moveSelection(1);
      break;
    case 'Enter':
    case ' ':
      if (hoveredCard) {
        openDetail(hoveredCard.userData.node);
      }
      break;
    case 'Escape':
      closeDetail();
      break;
  }
}

// 移动选择
let selectedIndex = -1;

function moveSelection(direction) {
  const newIndex = selectedIndex + direction;

  if (newIndex >= 0 && newIndex < cards.length) {
    selectedIndex = newIndex;
    const card = cards[newIndex];
    const cardGroup = card.parent;

    // 高亮选中卡片
    cards.forEach((c, i) => {
      const scale = i === newIndex ? 1.2 : 1;
      gsap.to(c.scale, {
        x: scale,
        z: scale,
        duration: 0.3
      });
    });

    // 移动相机焦点
    const targetPos = cardGroup.position.clone();
    gsap.to(camera.position, {
      x: targetPos.x,
      z: targetPos.z + 8,
      duration: 1,
      ease: "power2.out"
    });

    gsap.to(controls.target, {
      x: targetPos.x,
      z: targetPos.z,
      duration: 1,
      ease: "power2.out"
    });
  }
}

// 打开详情弹窗
function openDetail(node) {
  selectedNode.value = node;
  showDetail.value = true;
  playSound('open');

  // 3D相机动画
  gsap.to(camera.position, {
    x: camera.position.x,
    y: camera.position.y + 2,
    z: camera.position.z + 3,
    duration: 0.5,
    ease: "power2.out"
  });
}

// 关闭详情弹窗
function closeDetail() {
  showDetail.value = false;
  selectedNode.value = null;
  playSound('close');

  // 恢复相机位置
  gsap.to(camera.position, {
    y: 5,
    z: 15,
    duration: 0.5,
    ease: "power2.inOut"
  });
}

// 跳转到作品详情
function goToWork(id) {
  if (id) {
    router.push(`/chuangzuo/${id}`);
  }
}

// 动画循环
function animate() {
  animationId = requestAnimationFrame(animate);

  controls.update();
  renderer.render(scene, camera);
}

// 窗口大小调整
function onWindowResize() {
  if (!canvasRef.value || !camera || !renderer) return;

  const width = canvasRef.value.clientWidth;
  const height = canvasRef.value.clientHeight;

  camera.aspect = width / height;
  camera.updateProjectionMatrix();

  renderer.setSize(width, height);

  // 移动端性能优化：降低像素比
  const isMobile = width < 768;
  renderer.setPixelRatio(isMobile ? 1 : Math.min(window.devicePixelRatio, 2));
}

// 清理资源
function cleanup() {
  window.removeEventListener('resize', onWindowResize);

  if (animationId) {
    cancelAnimationFrame(animationId);
  }

  if (renderer) {
    renderer.dispose();
  }

  // 清理音频资源
  if (audioContext.value) {
    audioContext.value.close();
    audioContext.value = null;
  }

  // 清理几何体和材质
  scene.traverse((object) => {
    if (object.geometry) {
      object.geometry.dispose();
    }
    if (object.material) {
      if (Array.isArray(object.material)) {
        object.material.forEach(m => m.dispose());
      } else {
        object.material.dispose();
      }
    }
  });

  // 清理GSAP
  gsap.killTweensOf('*');
}

// 监听数据变化
watch(() => props.timelineData, (newData) => {
  if (newData && newData.length > 0 && timelineGroup) {
    // 重新创建时光轴
    scene.remove(timelineGroup);
    createTimeline();
  }
}, { deep: true });

onMounted(() => {
  // 如果没有数据，创建测试数据
  if (!props.timelineData || props.timelineData.length === 0) {
    console.warn('No timeline data provided, using mock data');
    // 使用模拟数据但不修改props
    const mockData = [
      {
        id: 1,
        date: '2026-03-01',
        dateLabel: '春分',
        title: '春日感怀',
        likes: 128,
        comments: 32,
        isMilestone: true,
        badgeText: '第一首'
      },
      {
        id: 2,
        date: '2026-03-15',
        dateLabel: '清明',
        title: '清明寄思',
        likes: 256,
        comments: 64
      },
      {
        id: 3,
        date: '2026-04-01',
        dateLabel: '谷雨',
        title: '谷雨即景',
        likes: 189,
        comments: 45
      },
      {
        id: 4,
        date: '2026-04-15',
        dateLabel: '立夏',
        title: '夏日初长',
        likes: 342,
        comments: 87
      },
      {
        id: 5,
        date: '2026-05-01',
        dateLabel: '小满',
        title: '小满时节',
        likes: 421,
        comments: 98
      }
    ];

    // 临时替换props用于初始化
    Object.defineProperty(props, 'timelineData', {
      value: mockData,
      writable: false,
      configurable: true
    });
  }

  initThreeJS();
});

onUnmounted(() => {
  cleanup();
});
</script>

<style scoped>
.timeline3d-advanced-container {
  position: relative;
  width: 100%;
  height: 600px;
  overflow: hidden;
  background: linear-gradient(135deg, #fdfbf7, #f5f3ef);
}

.timeline-canvas {
  width: 100%;
  height: 100%;
  display: block;
}

/* UI层 */
.ui-layer {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
}

.timeline-title {
  position: absolute;
  top: 20px;
  left: 50%;
  transform: translateX(-50%);
  text-align: center;
  pointer-events: none;
}

.timeline-title h1 {
  font-size: 28px;
  font-weight: 900;
  color: #3a2e2b;
  margin: 0;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  letter-spacing: 2px;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.title-decoration {
  width: 200px;
  height: 2px;
  background: linear-gradient(90deg,
    transparent,
    #d4af37,
    transparent
  );
  margin: 8px auto 0;
}

/* 控制提示 */
.controls-hint {
  position: absolute;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 24px;
  padding: 12px 24px;
  background: rgba(212, 175, 55, 0.9);
  border-radius: 12px;
  backdrop-filter: blur(8px);
}

.hint-item {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #fff;
  font-size: 14px;
  font-weight: 700;
  font-family: "思源宋体", serif;
}

.hint-icon {
  font-size: 18px;
}

/* 加载动画 */
.loading-animation-3d {
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
  0% { transform: scaleX(0); }
  100% { transform: scaleX(1); }
}

@keyframes scrollUnrollRight {
  0% { transform: scaleX(0); }
  100% { transform: scaleX(1); }
}

@keyframes textFadeIn {
  0% { opacity: 0; transform: scale(0.8); }
  50% { opacity: 0; transform: scale(0.8); }
  100% { opacity: 1; transform: scale(1); }
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
.detail-modal-3d {
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
  pointer-events: auto;
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

.detail-content-3d {
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
  pointer-events: auto;
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

.detail-decoration-3d {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
}

.corner {
  position: absolute;
  width: 24px;
  height: 24px;
  opacity: 0.3;
}

.corner::before {
  content: '';
  position: absolute;
  background: #d4af37;
}

.corner.top-left {
  top: 8px;
  left: 8px;
  border-top: 2px solid;
  border-left: 2px solid;
}

.corner.top-right {
  top: 8px;
  right: 8px;
  border-top: 2px solid;
  border-right: 2px solid;
}

.corner.bottom-left {
  bottom: 8px;
  left: 8px;
  border-bottom: 2px solid;
  border-left: 2px solid;
}

.corner.bottom-right {
  bottom: 8px;
  right: 8px;
  border-bottom: 2px solid;
  border-right: 2px solid;
}

.detail-body-3d {
  text-align: center;
}

.detail-icon-3d {
  font-size: 48px;
  margin-bottom: 16px;
}

.detail-title-3d {
  font-size: 24px;
  font-weight: 900;
  color: #3a2e2b;
  margin-bottom: 16px;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  line-height: 1.4;
}

.detail-meta-3d {
  display: flex;
  justify-content: center;
  gap: 16px;
  margin-bottom: 20px;
}

.meta-item-3d {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  color: #9d8b7a;
  font-weight: 700;
}

.meta-icon-3d {
  font-size: 16px;
}

.detail-divider-3d {
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 20px 0;
}

.divider-icon-3d {
  font-size: 12px;
  color: rgba(212, 175, 55, 0.5);
  padding: 0 16px;
  position: relative;
}

.divider-icon-3d::before,
.divider-icon-3d::after {
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

.divider-icon-3d::before {
  right: 100%;
}

.divider-icon-3d::after {
  left: 100%;
}

.detail-description-3d {
  font-size: 15px;
  color: #6b5c54;
  line-height: 1.8;
  margin-bottom: 24px;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

.detail-action-3d {
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

.detail-action-3d:hover {
  background: linear-gradient(135deg,
    rgba(184, 134, 11, 1),
    rgba(212, 175, 55, 0.95)
  );
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(212, 175, 55, 0.4);
}

.action-arrow-3d {
  font-size: 18px;
  transition: transform 0.3s ease;
}

.detail-action-3d:hover .action-arrow-3d {
  transform: translateX(4px);
}

.detail-fade-enter-active,
.detail-fade-leave-active {
  transition: opacity 0.3s ease;
}

.detail-fade-enter-from,
.detail-fade-leave-to {
  opacity: 0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .timeline3d-advanced-container {
    height: 400px;
  }

  .timeline-title h1 {
    font-size: 20px;
  }

  .title-decoration {
    width: 150px;
  }

  .controls-hint {
    flex-direction: column;
    gap: 8px;
    padding: 8px 16px;
  }

  .hint-item {
    font-size: 12px;
  }

  .hint-icon {
    font-size: 16px;
  }

  .detail-content-3d {
    max-width: 90%;
    padding: 24px;
  }

  .detail-title-3d {
    font-size: 20px;
  }

  .detail-meta-3d {
    flex-direction: column;
    gap: 8px;
  }
}

@media (max-width: 480px) {
  .timeline3d-advanced-container {
    height: 350px;
  }

  .timeline-title h1 {
    font-size: 18px;
  }

  .controls-hint {
    bottom: 10px;
    padding: 6px 12px;
  }
}

/* 空3D状态 */
.empty-3d-state {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #fdfbf7, #f5f3ef);
  z-index: 100;
}

.empty-3d-content {
  text-align: center;
  padding: 40px;
}

.empty-3d-icon {
  font-size: 64px;
  margin-bottom: 20px;
  opacity: 0.8;
}

.empty-3d-text {
  font-size: 24px;
  font-weight: 900;
  color: #3a2e2b;
  margin-bottom: 12px;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

.empty-3d-subtext {
  font-size: 16px;
  color: #9d8b7a;
  font-weight: 700;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

</style>
