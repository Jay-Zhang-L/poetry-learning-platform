<template>
  <div class="poetry-window">
    <div class="page-texture"></div>
    <div class="ink-wash ink-left"></div>
    <div class="ink-wash ink-right"></div>

    <section class="hero">
      <div class="hero-inner">
        <button class="enter-splat-btn" @click="openSplatDialog">进入诗境</button>
        <img class="hero-decor hero-decor-left" :src="zuobianDecor" alt="" />
        <img class="hero-decor hero-decor-right" :src="youbianDecor" alt="" />
        <p class="hero-mark">诗窗</p>
        <h1>寻韵诗境</h1>
        <p class="hero-desc">
          观图而识诗，因景而配句。以温润纸色承载诗意，用含蓄的朱砂点染页面层次。
        </p>
      </div>
    </section>

    <section class="content-wrap">
      <div class="panel panel-left">
        <div class="panel-decor"></div>
        <div class="panel-head">
          <p class="panel-en">Image to Poem</p>
          <h2>图片识诗</h2>
          <span class="panel-line"></span>
        </div>

        <label class="upload-box left-upload">
          <input type="file" accept="image/*" @change="onFileChange" />
          <div class="upload-inner">
            <div class="upload-icon-wrap">
              <span class="upload-icon"></span>
            </div>
            <div class="upload-copy">
              <span class="upload-title">上传诗词图片</span>
              <span class="upload-sub">支持拍照图片、书页截图、海报局部内容</span>
            </div>
          </div>
        </label>

        <transition name="fade-up">
          <div v-if="preview" class="preview-frame poetry-frame">
            <div class="frame-corner left-top"></div>
            <div class="frame-corner right-top"></div>
            <div class="frame-corner left-bottom"></div>
            <div class="frame-corner right-bottom"></div>
            <img :src="preview" alt="诗词图片预览" />
          </div>
        </transition>

        <transition name="fade-up">
          <div v-if="loading" class="status-card">识别中，请稍候……</div>
        </transition>

        <div class="section-block">
          <div class="section-title">识别内容</div>
          <div class="paper-card recognized-paper">
            <div class="paper-head">
              <span class="paper-chip">OCR 结果</span>
              <span class="paper-note">自动提取图片中的诗句内容</span>
            </div>
            <div class="paper-body">
              <pre class="recognized-text">{{ recognizedText || '这里将显示 OCR 识别出的诗句内容' }}</pre>
            </div>
          </div>
        </div>

        <transition name="fade-up">
          <div v-if="bestPoem" class="poem-main-card">
            <div class="card-top">
              <span class="badge">最佳匹配</span>
            </div>
            <h3>{{ bestPoem.title || '未匹配到标题' }}</h3>
            <p class="meta">{{ bestPoem.dynasty || '未知朝代' }} · {{ bestPoem.author || '未知作者' }}</p>
            <pre class="content">{{ bestPoem.content || '暂无全文' }}</pre>
            <div v-if="bestPoem.translation" class="extra">
              <div class="extra-title">译文</div>
              <p>{{ bestPoem.translation }}</p>
            </div>
            <div v-if="bestPoem.analysis" class="extra">
              <div class="extra-title">赏析</div>
              <p>{{ bestPoem.analysis }}</p>
            </div>
          </div>
        </transition>

        <div v-if="loading" class="status-card">识别中，请稍候……</div>
        <div v-else-if="recognizedText && !bestPoem" class="empty-tip">暂未匹配到完整诗词</div>

        <div v-if="poems.length > 1" class="candidate-block">
          <div class="section-title">其他候选结果</div>
          <div v-for="poem in poems.slice(1)" :key="poem.id" class="poem-card">
            <div class="poem-card-head">
              <h4>{{ poem.title }}</h4>
              <p class="meta">{{ poem.dynasty || '未知朝代' }} · {{ poem.author || '未知作者' }}</p>
            </div>
            <pre class="content short-content">{{ poem.content }}</pre>
          </div>
        </div>
      </div>

      <div class="panel panel-right">
        <div class="panel-decor mountain-decor"></div>
        <div class="panel-head">
          <p class="panel-en">Scene to Poem</p>
          <h2>风景配诗</h2>
          <span class="panel-line"></span>
        </div>

        <label class="upload-box right-upload">
          <input type="file" accept="image/*" @change="onSceneChange" />
          <div class="upload-inner">
            <div class="upload-icon-wrap scenic-icon-wrap">
              <span class="upload-icon scenic-icon"></span>
            </div>
            <div class="upload-copy">
              <span class="upload-title">上传风景图片</span>
              <span class="upload-sub">山水、园林、云月、江湖等意境图像皆可</span>
            </div>
          </div>
        </label>

        <transition name="fade-up">
          <div v-if="scenePreview" class="preview-frame scene-frame">
            <div class="frame-corner left-top"></div>
            <div class="frame-corner right-top"></div>
            <div class="frame-corner left-bottom"></div>
            <div class="frame-corner right-bottom"></div>
            <img :src="scenePreview" alt="风景图片预览" />
          </div>
        </transition>

        <transition name="fade-up">
          <div v-if="sceneLoading" class="status-card">分析中，请稍候……</div>
        </transition>

        <div v-if="sceneList.length" class="scene-result-list">
          <div class="section-title">推荐结果</div>
          <div
            v-for="poem in sceneList"
            :key="poem.id"
            class="scene-card clickable"
            @click="openSceneDetail(poem)"
          >
            <div class="scene-card-top">
              <span class="scene-tag">意境相合</span>
              <span class="detail-link">点击查看详情 ›</span>
            </div>
            <h3>{{ poem.title }}</h3>
            <p class="meta">{{ poem.dynasty || '未知朝代' }} · {{ poem.author || '未知作者' }}</p>
            <p class="reason">推荐理由：{{ poem.reason || '意象、色调与诗词情境较为接近。' }}</p>
          </div>
        </div>

        <div v-else-if="scenePreview && !sceneLoading" class="empty-tip">暂无推荐结果</div>
      </div>
    </section>

    <section class="bottom-showcase">
      <div class="showcase-head">
        <p class="showcase-mark">诗窗说明</p>
        <h2>如何使用</h2>
      </div>
      <div class="showcase-grid">
        <div class="showcase-card" v-for="(item, i) in howToItems" :key="i">
          <span class="showcase-no">{{ String(i + 1).padStart(2, '0') }}</span>
          <h3>{{ item.title }}</h3>
          <p>{{ item.desc }}</p>
        </div>
      </div>
    </section>

    <!-- 详情弹层 -->
    <transition name="mask-fade">
      <div v-if="detailVisible" class="detail-mask" @click="closeDetail">
        <transition name="panel-rise">
          <div v-if="detailVisible" class="detail-panel" @click.stop>
            <button class="panel-close" @click="closeDetail">×</button>
            <div v-if="detailLoading" class="status-card">详情加载中，请稍候……</div>
            <template v-else-if="detailData">
              <div class="detail-top"><span class="badge">诗词详情</span></div>
              <h2 class="detail-title">{{ detailData.title || '未命名' }}</h2>
              <p class="meta detail-meta">{{ detailData.dynasty || '未知朝代' }} · {{ detailData.author || '未知作者' }}</p>
              <div v-if="detailData.reason" class="detail-block">
                <div class="extra-title">推荐理由</div>
                <p>{{ detailData.reason }}</p>
              </div>
              <div v-if="detailData.content" class="detail-block">
                <div class="extra-title">原文</div>
                <pre class="content">{{ detailData.content }}</pre>
              </div>
              <div v-if="detailData.translation" class="detail-block">
                <div class="extra-title">译文</div>
                <p>{{ detailData.translation }}</p>
              </div>
              <div v-if="detailData.analysis" class="detail-block">
                <div class="extra-title">赏析</div>
                <p>{{ detailData.analysis }}</p>
              </div>
            </template>
            <div v-else class="empty-tip">暂无详情数据</div>
          </div>
        </transition>
      </div>
    </transition>

    <!-- 诗境入口弹层 -->
    <transition name="mask-fade">
      <div v-if="splatDialogVisible" class="splat-mask" @click="closeSplatDialog">
        <transition name="panel-rise">
          <div v-if="splatDialogVisible" class="splat-panel" @click.stop>
            <button class="panel-close" @click="closeSplatDialog">×</button>
            <div class="splat-head">
              <p class="showcase-mark">诗境入口</p>
              <h2>选择诗词进入 3D 诗境</h2>
            </div>
            <div class="splat-search-bar">
              <input
                v-model.trim="splatKeyword"
                class="splat-search-input"
                placeholder="请输入诗词名、作者或朝代"
                @keyup.enter="searchSplatScenes"
              />
              <button class="splat-search-btn" @click="searchSplatScenes">搜索</button>
            </div>
            <div v-if="splatLoading" class="status-card">搜索中，请稍候……</div>
            <div v-else-if="!splatList.length" class="empty-tip">暂无可进入的诗境场景</div>
            <div v-else class="splat-result-list">
              <div v-for="item in splatList" :key="item.id" class="scene-card clickable">
                <div class="scene-card-top">
                  <span class="scene-tag">可进入诗境</span>
                  <span class="detail-link enter-link" @click="enterSplatScene(item)">进入 ›</span>
                </div>
                <h3>{{ item.title }}</h3>
                <p class="meta">{{ item.dynasty || '未知朝代' }} · {{ item.author || '未知作者' }}</p>
                <p class="reason">{{ item.description || '该诗词已收录对应 3D 诗境，可点击进入。' }}</p>
              </div>
            </div>
          </div>
        </transition>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { searchSplatSceneList } from '@/utils/api'
import youbianDecor from '@/assets/shichuang/youbian-removebg-preview.png'
import zuobianDecor from '@/assets/shichuang/zuobian-removebg-preview.png'

const router = useRouter()
const API_BASE = 'http://localhost:8080/api/shichuang'

const preview = ref('')
const recognizedText = ref('')
const poems = ref([])
const bestPoem = ref(null)
const loading = ref(false)

const scenePreview = ref('')
const sceneList = ref([])
const sceneLoading = ref(false)

const detailVisible = ref(false)
const detailLoading = ref(false)
const detailData = ref(null)

const splatDialogVisible = ref(false)
const splatKeyword = ref('')
const splatLoading = ref(false)
const splatList = ref([])

const howToItems = [
  { title: '上传图片', desc: '左侧适合书页、截图、题字图片，右侧适合山水、园林、月夜、江景等风景图像。' },
  { title: '获得结果', desc: '图片识诗会展示识别文本与匹配诗词，风景配诗会给出推荐结果，并支持点击查看完整内容。' },
  { title: '阅读详情', desc: '详情层中保留题目、作者、原文、译文、赏析与推荐理由，便于展示与讲解。' }
]

async function onFileChange(e) {
  const file = e.target.files?.[0]
  if (!file) return
  preview.value = URL.createObjectURL(file)
  recognizedText.value = ''
  poems.value = []
  bestPoem.value = null
  const formData = new FormData()
  formData.append('image', file)
  loading.value = true
  try {
    const res = await fetch(`${API_BASE}/recognize-from-image`, { method: 'POST', body: formData })
    const result = await res.json()
    if (res.status !== 200 || result.code !== 200) { alert(result.message || '识诗失败'); return }
    const data = result.data || {}
    recognizedText.value = data.recognizedText || ''
    poems.value = Array.isArray(data.poems) ? data.poems : []
    bestPoem.value = data.bestPoem || (poems.value.length ? poems.value[0] : null)
  } catch (err) { alert('识诗请求失败') } finally { loading.value = false }
}

async function onSceneChange(e) {
  const file = e.target.files?.[0]
  if (!file) return
  scenePreview.value = URL.createObjectURL(file)
  sceneList.value = []
  const formData = new FormData()
  formData.append('image', file)
  sceneLoading.value = true
  try {
    const res = await fetch(`${API_BASE}/recommend-by-image`, { method: 'POST', body: formData })
    const result = await res.json()
    if (res.status !== 200 || result.code !== 200) { alert(result.message || '风景配诗失败'); return }
    sceneList.value = Array.isArray(result.data?.poems) ? result.data.poems : []
  } catch (err) { alert('风景配诗请求失败') } finally { sceneLoading.value = false }
}

async function openSceneDetail(poem) {
  if (!poem?.id) return
  detailVisible.value = true
  detailLoading.value = true
  detailData.value = null
  try {
    const res = await fetch(`${API_BASE}/detail/${poem.id}`)
    const result = await res.json()
    if (res.status !== 200 || result.code !== 200) { alert(result.message || '获取详情失败'); closeDetail(); return }
    detailData.value = { ...result.data, reason: poem.reason || result.data?.reason || '' }
  } catch (err) { alert('获取详情失败'); closeDetail() } finally { detailLoading.value = false }
}

function closeDetail() { detailVisible.value = false; detailLoading.value = false; detailData.value = null }

function openSplatDialog() { splatDialogVisible.value = true; splatKeyword.value = ''; splatList.value = [] }
function closeSplatDialog() { splatDialogVisible.value = false; splatKeyword.value = ''; splatList.value = []; splatLoading.value = false }

async function searchSplatScenes() {
  splatLoading.value = true
  try {
    const res = await searchSplatSceneList(splatKeyword.value)
    splatList.value = Array.isArray(res?.data) ? res.data : []
  } catch (err) { alert(err.message || '搜索诗境失败'); splatList.value = [] } finally { splatLoading.value = false }
}

function enterSplatScene(item) {
  if (!item?.id) return
  closeSplatDialog()
  router.push(`/splat/${item.id}`)
}
</script>

<style scoped>
/* ===== CSS 变量 — 与朗诵页面保持一致 ===== */
.poetry-window {
  --red: #8a3830;
  --red-deep: #5e2520;
  --red-soft: #b8706a;
  --red-glow: rgba(138, 56, 48, 0.13);
  --gold: #c2a060;
  --gold-light: #e0cc98;
  --gold-dark: #8a6830;
  --paper: #f8f4eb;
  --paper-bg: rgba(248, 244, 235, 0.95);
  --paper-card: rgba(251, 246, 237, 0.92);
  --paper2: #fcf8f0;
  --paper3: #ede3cc;
  --ink: #261c18;
  --text: #56463d;
  --muted: #8a7a6a;
  --border: rgba(122, 84, 64, 0.16);
  --border-solid: #d4bc98;
  --line: rgba(72, 60, 46, 0.12);
  --line-strong: rgba(72, 60, 46, 0.2);

  position: relative;
  min-height: 100vh;
  overflow-x: hidden;
  font-family: 'PingFang SC', 'Microsoft YaHei', 'Noto Sans SC', sans-serif;
  color: var(--ink);
  background: var(--paper-bg);
}

.poetry-window::before {
  content: "";
  position: fixed;
  inset: 0;
  z-index: -2;
  background:
    linear-gradient(rgba(248, 244, 235, 0.92), rgba(248, 244, 235, 0.96)),
    var(--paper) center center / cover no-repeat;
  pointer-events: none;
}

.poetry-window::after {
  content: "";
  position: fixed;
  inset: 0;
  z-index: -1;
  background:
    radial-gradient(900px 420px at 20% 12%, rgba(155, 123, 71, 0.06), transparent 65%),
    radial-gradient(800px 380px at 80% 24%, rgba(138, 47, 43, 0.04), transparent 70%),
    radial-gradient(900px 480px at 50% 100%, rgba(120, 105, 90, 0.05), transparent 66%);
  pointer-events: none;
}

/* ===== 纹理与墨晕 ===== */
.page-texture {
  position: absolute;
  inset: 0;
  pointer-events: none;
  opacity: 0.35;
  background:
    linear-gradient(to right, rgba(108, 87, 71, 0.025) 1px, transparent 1px),
    linear-gradient(to bottom, rgba(108, 87, 71, 0.02) 1px, transparent 1px);
  background-size: 34px 34px;
}

.ink-wash { position: absolute; pointer-events: none; filter: blur(8px); opacity: 0.5; }
.ink-left { top: 120px; left: -110px; width: 340px; height: 340px; background: radial-gradient(circle, rgba(155, 123, 71, 0.08), transparent 68%); }
.ink-right { top: 320px; right: -120px; width: 420px; height: 420px; background: radial-gradient(circle, rgba(138, 47, 43, 0.05), transparent 70%); }

/* ===== Hero ===== */
.hero {
  position: relative;
  z-index: 1;
  padding: 24px 0 26px;
}

.hero-inner {
  position: relative;
  width: calc(100vw - 32px);
  margin: 0 auto;
  min-height: 360px;
  padding: 76px 200px 68px;
  border: 1px solid rgba(122, 84, 64, 0.15);
  background:
    linear-gradient(180deg, rgba(251, 248, 242, 0.93), rgba(247, 242, 235, 0.97));
  box-shadow: 0 18px 48px rgba(83, 61, 46, 0.07);
  text-align: center;
  overflow: hidden;
}

/* 内嵌框线 */
.hero-inner::after {
  content: '';
  position: absolute;
  inset: 16px;
  border: 1px solid rgba(138, 56, 48, 0.07);
  pointer-events: none;
}

/* 左右竖线装饰 */
.hero-inner::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(90deg,
    rgba(118, 101, 84, 0.06) 0 2px,
    transparent 2px calc(100% - 2px),
    rgba(118, 101, 84, 0.06) calc(100% - 2px));
  pointer-events: none;
}

.hero-decor {
  position: absolute;
  z-index: 0;
  pointer-events: none;
  user-select: none;
  opacity: 0.98;
}
.hero-decor-left { left: -18px; bottom: 0; width: min(42vw, 760px); height: auto; }
.hero-decor-right { top: 50%; right: 8px; width: min(19vw, 300px); transform: translateY(-50%); opacity: 0.96; }

.hero-mark, .showcase-mark {
  position: relative;
  z-index: 1;
  margin: 0 0 12px;
  color: var(--red);
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 0.42em;
  text-indent: 0.42em;
}

.hero h1 {
  position: relative;
  z-index: 1;
  margin: 0;
  color: var(--ink);
  font-size: 56px;
  font-weight: 700;
  letter-spacing: 0.06em;
  transition: letter-spacing 0.4s ease;
}
.hero-inner:hover h1 { letter-spacing: 0.1em; }

.hero-desc {
  position: relative;
  z-index: 1;
  max-width: 860px;
  margin: 18px auto 0;
  color: #6d5a4e;
  font-size: 16px;
  line-height: 1.95;
}

/* 进入诗境按钮 */
.enter-splat-btn {
  position: absolute;
  top: 18px; right: 18px;
  z-index: 3;
  height: 40px;
  padding: 0 20px;
  border: 1px solid rgba(138, 56, 48, 0.22);
  background: rgba(252, 248, 242, 0.9);
  color: var(--red-deep);
  font-size: 14px;
  font-weight: 700;
  letter-spacing: 2px;
  cursor: pointer;
  transition: all 0.3s ease;
  position: absolute;
  overflow: hidden;
}
.enter-splat-btn::before {
  content: '';
  position: absolute;
  top: 0; left: -100%; width: 100%; height: 100%;
  background: linear-gradient(90deg, transparent, rgba(194, 160, 96, 0.2), transparent);
  transition: left 0.5s ease;
}
.enter-splat-btn:hover::before { left: 100%; }
.enter-splat-btn:hover {
  background: var(--red);
  color: var(--paper2);
  border-color: var(--red);
  transform: translateY(-2px);
  box-shadow: 0 8px 20px var(--red-glow);
}
.enter-splat-btn:active { transform: translateY(0); }

/* ===== 双栏布局 ===== */
.content-wrap {
  position: relative;
  z-index: 1;
  width: min(1660px, calc(100vw - 48px));
  margin: 0 auto;
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
  gap: 24px;
}

/* ===== 面板通用 ===== */
.panel {
  position: relative;
  min-width: 0;
  padding: 30px;
  border: 1px solid var(--border);
  background: linear-gradient(180deg, rgba(252, 248, 241, 0.95), rgba(247, 239, 229, 0.98));
  box-shadow: 0 20px 50px rgba(81, 62, 47, 0.06);
  overflow: hidden;
  transition: box-shadow 0.3s ease, background 0.3s ease;
}

.panel:hover {
  background: linear-gradient(180deg, rgba(253, 249, 243, 0.97), rgba(248, 241, 231, 0.99));
  box-shadow: 0 24px 60px rgba(81, 62, 47, 0.09);
}

/* 内嵌细框 */
.panel::before {
  content: '';
  position: absolute;
  inset: 12px;
  border: 1px solid rgba(138, 56, 48, 0.07);
  pointer-events: none;
}

/* 顶部彩条 */
.panel::after {
  content: '';
  position: absolute;
  top: 0; left: 0; width: 100%; height: 4px;
  background: linear-gradient(90deg,
    rgba(138, 56, 48, 0.82),
    rgba(194, 160, 96, 0.36),
    rgba(138, 56, 48, 0.82));
}

.panel-left {
  background:
    linear-gradient(180deg, rgba(252, 248, 241, 0.97), rgba(246, 238, 226, 0.98)),
    repeating-linear-gradient(0deg,
      rgba(128, 96, 76, 0.012), rgba(128, 96, 76, 0.012) 1px,
      transparent 1px, transparent 9px);
}

.panel-right {
  background: linear-gradient(180deg, rgba(252, 248, 241, 0.96), rgba(245, 236, 224, 0.98));
}

.panel-decor {
  position: absolute;
  top: 18px; right: 18px;
  width: 196px; height: 196px;
  background: radial-gradient(circle, rgba(138, 56, 48, 0.07), transparent 66%);
  pointer-events: none;
}
.mountain-decor {
  background:
    radial-gradient(circle at 70% 28%, rgba(138, 56, 48, 0.065), transparent 46%),
    radial-gradient(circle at 34% 72%, rgba(133, 98, 73, 0.05), transparent 42%);
}

/* ===== 面板标题 ===== */
.panel-head {
  position: relative;
  z-index: 1;
  padding-bottom: 14px;
}

.panel-en {
  margin: 0 0 8px;
  color: var(--red);
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.18em;
  text-transform: uppercase;
}

.panel-head h2 {
  margin: 0;
  color: var(--ink);
  font-size: 30px;
  font-weight: 700;
  letter-spacing: 3px;
  transition: letter-spacing 0.3s ease, color 0.3s ease;
}
.panel:hover .panel-head h2 { letter-spacing: 4px; color: var(--red); }

.panel-line {
  display: block;
  width: 80px;
  height: 2px;
  margin-top: 12px;
  background: linear-gradient(90deg, var(--red), rgba(194, 160, 96, 0.2));
  transition: width 0.4s ease;
}
.panel:hover .panel-line { width: 120px; }

/* ===== 上传区域 ===== */
.upload-box {
  position: relative;
  display: block;
  margin-top: 14px;
  cursor: pointer;
}
.upload-box input { display: none; }

.upload-inner {
  position: relative;
  display: flex;
  align-items: center;
  gap: 18px;
  min-height: 120px;
  padding: 22px;
  border: 1px dashed rgba(138, 56, 48, 0.3);
  background: linear-gradient(180deg, rgba(255, 252, 248, 0.9), rgba(248, 242, 233, 0.97));
  transition: all 0.3s cubic-bezier(0.23, 1, 0.32, 1);
}

.upload-inner::before {
  content: '';
  position: absolute;
  inset: 10px;
  border: 1px solid rgba(138, 56, 48, 0.07);
  pointer-events: none;
  transition: border-color 0.3s ease;
}

.upload-box:hover .upload-inner {
  transform: translateY(-4px) scale(1.005);
  border-color: rgba(138, 56, 48, 0.5);
  box-shadow: 0 16px 36px rgba(97, 56, 45, 0.09);
  background: linear-gradient(180deg, rgba(255, 252, 248, 0.98), rgba(249, 242, 232, 1));
}
.upload-box:hover .upload-inner::before { border-color: rgba(138, 56, 48, 0.12); }
.upload-box:active .upload-inner { transform: translateY(-2px) scale(1.002); }

.upload-icon-wrap {
  position: relative;
  flex: 0 0 64px;
  width: 64px; height: 64px;
  border: 1px solid rgba(138, 56, 48, 0.15);
  background: linear-gradient(180deg, rgba(138, 56, 48, 0.1), rgba(138, 56, 48, 0.04));
  transition: all 0.3s ease;
}
.upload-box:hover .upload-icon-wrap {
  border-color: rgba(138, 56, 48, 0.3);
  background: linear-gradient(180deg, rgba(138, 56, 48, 0.15), rgba(138, 56, 48, 0.07));
  transform: rotate(2deg);
}

.upload-icon {
  position: absolute;
  inset: 14px 17px;
  border: 1.8px solid rgba(94, 37, 32, 0.76);
}
.upload-icon::before, .upload-icon::after { content: ''; position: absolute; }
.upload-icon::before {
  left: 5px; bottom: 5px; width: 20px; height: 12px;
  border-left: 1.8px solid rgba(94, 37, 32, 0.76);
  border-bottom: 1.8px solid rgba(94, 37, 32, 0.76);
  transform: skewX(-32deg);
}
.upload-icon::after {
  top: 5px; right: 5px; width: 7px; height: 7px;
  border-radius: 50%;
  background: rgba(94, 37, 32, 0.8);
}

.scenic-icon::before {
  left: 2px; bottom: 4px; width: 24px; height: 14px;
  border: none;
  background:
    linear-gradient(135deg, transparent 48%, rgba(94, 37, 32, 0.8) 49%, rgba(94, 37, 32, 0.8) 55%, transparent 56%),
    linear-gradient(45deg, transparent 49%, rgba(94, 37, 32, 0.8) 50%, rgba(94, 37, 32, 0.8) 56%, transparent 57%);
}
.scenic-icon::after {
  top: 4px; right: 3px; width: 10px; height: 10px;
  border-radius: 50%;
  background: rgba(94, 37, 32, 0.8);
  box-shadow: -16px 18px 0 -3px rgba(94, 37, 32, 0.8);
}

.upload-copy { display: flex; flex-direction: column; gap: 8px; }
.upload-title { color: var(--red-deep); font-size: 23px; font-weight: 700; transition: color 0.3s ease; }
.upload-box:hover .upload-title { color: var(--red); }
.upload-sub { color: var(--muted); font-size: 13px; line-height: 1.85; }

/* ===== 预览图 ===== */
.preview-frame {
  position: relative;
  margin-top: 18px;
  padding: 12px;
  border: 1px solid rgba(122, 84, 64, 0.17);
  background: rgba(255, 251, 244, 0.96);
  box-shadow: 0 12px 30px rgba(83, 61, 46, 0.05);
  transition: box-shadow 0.3s ease;
}
.preview-frame:hover { box-shadow: 0 16px 40px rgba(83, 61, 46, 0.09); }
.preview-frame img { display: block; width: 100%; max-height: 460px; object-fit: cover; transition: filter 0.4s ease; }
.preview-frame:hover img { filter: contrast(1.02) brightness(1.02); }
.scene-frame img { max-height: 520px; }

.frame-corner {
  position: absolute;
  width: 16px; height: 16px;
  border-color: rgba(138, 56, 48, 0.65);
  border-style: solid;
  transition: all 0.3s ease;
}
.preview-frame:hover .frame-corner { border-color: rgba(138, 56, 48, 0.9); width: 20px; height: 20px; }
.left-top   { top: 7px;    left: 7px;   border-width: 2px 0 0 2px; }
.right-top  { top: 7px;    right: 7px;  border-width: 2px 2px 0 0; }
.left-bottom  { left: 7px;  bottom: 7px; border-width: 0 0 2px 2px; }
.right-bottom { right: 7px; bottom: 7px; border-width: 0 2px 2px 0; }

/* ===== 区块标题 ===== */
.section-block, .candidate-block, .scene-result-list { margin-top: 18px; }

.section-title {
  position: relative;
  margin-bottom: 12px;
  padding-left: 12px;
  color: var(--red-deep);
  font-size: 15px;
  font-weight: 700;
  letter-spacing: 3px;
  border-left: 3px solid var(--red);
}

/* ===== 内容卡片通用 ===== */
.paper-card, .poem-main-card, .scene-card, .poem-card {
  position: relative;
  margin-top: 16px;
  padding: 20px 22px 18px;
  border: 1px solid var(--line);
  background: rgba(255, 255, 255, 0.5);
  box-shadow: 0 4px 16px rgba(72, 60, 46, 0.04);
  transition: all 0.35s cubic-bezier(0.23, 1, 0.32, 1);
}

/* 顶部渐变横条 */
.paper-card::before, .poem-main-card::before, .scene-card::before, .poem-card::before {
  content: '';
  position: absolute;
  left: 0; top: 0; width: 100%; height: 3px;
  background: linear-gradient(90deg,
    rgba(138, 56, 48, 0.7),
    rgba(194, 160, 96, 0.25),
    rgba(138, 56, 48, 0.7));
}

/* 左侧竖线（hover 展开） */
.paper-card::after, .poem-main-card::after, .scene-card::after, .poem-card::after {
  content: '';
  position: absolute;
  left: 0; top: 3px; bottom: 0; width: 3px;
  background: linear-gradient(180deg, var(--red), rgba(138, 56, 48, 0.2));
  transform: scaleY(0);
  transform-origin: top center;
  transition: transform 0.35s cubic-bezier(0.23, 1, 0.32, 1);
}

.paper-card:hover, .poem-main-card:hover, .poem-card:hover {
  border-color: rgba(138, 56, 48, 0.2);
  background: rgba(255, 255, 255, 0.8);
  box-shadow: 0 8px 24px rgba(72, 60, 46, 0.08);
  transform: translateY(-3px);
}
.paper-card:hover::after, .poem-main-card:hover::after, .poem-card:hover::after { transform: scaleY(1); }

/* ===== 标签 chip ===== */
.paper-head, .card-top, .scene-card-top {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}

.paper-chip, .badge, .scene-tag {
  display: inline-flex;
  align-items: center;
  min-height: 28px;
  padding: 3px 12px;
  border: 1px solid rgba(138, 56, 48, 0.18);
  border-radius: 999px;
  background: linear-gradient(180deg, rgba(138, 56, 48, 0.12), rgba(138, 56, 48, 0.05));
  color: var(--red-deep);
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 1px;
  transition: all 0.3s ease;
}
.paper-card:hover .paper-chip, .poem-main-card:hover .badge, .scene-card:hover .scene-tag {
  background: linear-gradient(180deg, rgba(138, 56, 48, 0.18), rgba(138, 56, 48, 0.09));
  border-color: rgba(138, 56, 48, 0.35);
}

.paper-note, .detail-link { color: var(--muted); font-size: 12px; }
.detail-link { transition: color 0.2s ease; }
.detail-link:hover { color: var(--red); }

.paper-body { position: relative; z-index: 1; }

.recognized-text, .content {
  margin: 0;
  white-space: pre-wrap;
  word-break: break-word;
  color: #3a302a;
  font-size: 15px;
  line-height: 2;
  font-family: 'PingFang SC', 'Microsoft YaHei', 'Noto Sans SC', sans-serif;
}
.recognized-paper .recognized-text { min-height: 120px; }

/* ===== 诗词标题 ===== */
.poem-main-card h3, .scene-card h3, .poem-card h4 {
  position: relative;
  z-index: 1;
  margin: 0;
  color: var(--ink);
  font-weight: 700;
  transition: color 0.3s ease;
}
.poem-main-card h3, .scene-card h3 { font-size: 27px; letter-spacing: 2px; }
.poem-card h4 { font-size: 21px; letter-spacing: 1px; }
.poem-main-card:hover h3, .poem-card:hover h4 { color: var(--red); }

.meta { position: relative; z-index: 1; margin: 8px 0 0; color: var(--muted); font-size: 14px; }
.content { position: relative; z-index: 1; margin-top: 14px; }
.short-content { max-height: 190px; overflow: auto; padding-right: 4px; }
.short-content::-webkit-scrollbar, .detail-panel::-webkit-scrollbar, .splat-panel::-webkit-scrollbar { width: 5px; }
.short-content::-webkit-scrollbar-thumb, .detail-panel::-webkit-scrollbar-thumb, .splat-panel::-webkit-scrollbar-thumb {
  background: rgba(138, 56, 48, 0.22); border-radius: 999px;
}

.extra, .detail-block {
  position: relative; z-index: 1;
  margin-top: 16px; padding-top: 14px;
  border-top: 1px dashed rgba(138, 56, 48, 0.12);
}

.extra-title {
  margin-bottom: 8px;
  color: var(--red-deep);
  font-size: 14px;
  font-weight: 700;
  letter-spacing: 2px;
  padding-left: 8px;
  border-left: 2px solid var(--red);
}

.extra p, .reason, .detail-block p, .showcase-card p {
  margin: 0; color: var(--text); font-size: 14px; line-height: 1.95;
}

/* ===== 风景配诗卡片 hover ===== */
.clickable { cursor: pointer; transition: all 0.3s cubic-bezier(0.23, 1, 0.32, 1); }
.clickable:hover {
  transform: translateY(-5px);
  border-color: rgba(138, 56, 48, 0.3);
  box-shadow: 0 18px 40px rgba(94, 56, 45, 0.09);
}
.clickable:hover::after { transform: scaleY(1); }

/* ===== 状态提示 ===== */
.status-card, .empty-tip {
  margin-top: 16px;
  padding: 13px 16px;
  border-left: 3px solid var(--red);
  background: rgba(138, 56, 48, 0.06);
  color: #70584e;
  font-size: 14px;
}

/* ===== 底部说明 ===== */
.bottom-showcase {
  position: relative; z-index: 1;
  width: min(1660px, calc(100vw - 48px));
  margin: 28px auto 0;
  padding: 0 0 48px;
}

.showcase-head { margin-bottom: 20px; text-align: center; }
.showcase-head h2 { margin: 0; color: var(--ink); font-size: 34px; font-weight: 700; letter-spacing: 4px; }

.showcase-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 18px;
}

.showcase-card {
  position: relative;
  padding: 24px 22px;
  border: 1px solid rgba(122, 84, 64, 0.13);
  background: linear-gradient(180deg, rgba(255, 252, 247, 0.92), rgba(247, 239, 228, 0.98));
  box-shadow: 0 10px 28px rgba(85, 68, 49, 0.05);
  transition: all 0.35s cubic-bezier(0.23, 1, 0.32, 1);
  overflow: hidden;
}

.showcase-card::before {
  content: '';
  position: absolute;
  top: 0; left: 0; width: 100%; height: 3px;
  background: linear-gradient(90deg,
    rgba(138, 56, 48, 0.86),
    rgba(194, 160, 96, 0.26),
    rgba(138, 56, 48, 0.86));
}

/* 水印大字 */
.showcase-card::after {
  content: attr(data-no);
  position: absolute;
  right: -6px; bottom: -12px;
  font-size: 90px;
  font-family: Georgia, serif;
  font-weight: 700;
  color: rgba(138, 56, 48, 0.04);
  pointer-events: none;
  line-height: 1;
  transition: all 0.4s ease;
}

.showcase-card:hover {
  transform: translateY(-5px);
  border-color: rgba(138, 56, 48, 0.25);
  box-shadow: 0 18px 42px rgba(85, 68, 49, 0.1);
}
.showcase-card:hover::after { color: rgba(138, 56, 48, 0.07); transform: rotate(-4deg); }

.showcase-no {
  display: inline-block;
  margin-bottom: 12px;
  color: var(--red);
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 2px;
}

.showcase-card h3 { margin: 0 0 10px; color: var(--ink); font-size: 22px; font-weight: 700; transition: color 0.3s ease; }
.showcase-card:hover h3 { color: var(--red); }

/* ===== 弹层通用 ===== */
.detail-mask, .splat-mask {
  position: fixed;
  inset: 0; z-index: 1000;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  background: rgba(38, 28, 24, 0.45);
  backdrop-filter: blur(3px);
}
.splat-mask { z-index: 1200; }

.detail-panel, .splat-panel {
  position: relative;
  width: min(900px, 92vw);
  max-height: 86vh;
  overflow-y: auto;
  padding: 30px 28px 24px;
  border: 1px solid rgba(122, 84, 64, 0.16);
  background: linear-gradient(180deg, rgba(255, 252, 247, 0.99), rgba(247, 239, 229, 0.99));
  box-shadow: 0 28px 64px rgba(55, 42, 34, 0.2);
}

/* 内嵌框 */
.detail-panel::before, .splat-panel::before {
  content: '';
  position: absolute; inset: 12px;
  border: 1px solid rgba(138, 56, 48, 0.07);
  pointer-events: none;
}

/* 顶部彩条 */
.detail-panel::after, .splat-panel::after {
  content: '';
  position: absolute;
  top: 0; left: 0; width: 100%; height: 5px;
  background: linear-gradient(90deg,
    rgba(138, 56, 48, 0.9),
    rgba(194, 160, 96, 0.32),
    rgba(138, 56, 48, 0.9));
}

.panel-close {
  position: absolute;
  top: 14px; right: 16px;
  width: 36px; height: 36px;
  border: 1px solid rgba(138, 56, 48, 0.16);
  background: rgba(138, 56, 48, 0.05);
  color: var(--red-deep);
  font-size: 22px;
  line-height: 1;
  cursor: pointer;
  display: grid;
  place-items: center;
  transition: all 0.25s ease;
}
.panel-close:hover {
  background: var(--red);
  color: var(--paper2);
  border-color: var(--red);
  transform: rotate(90deg);
}

.detail-top { position: relative; z-index: 1; margin-bottom: 12px; }
.detail-title { margin: 4px 0 0; color: var(--ink); font-size: 32px; font-weight: 700; letter-spacing: 3px; }
.detail-meta { margin-bottom: 4px; }

/* ===== 诗境搜索 ===== */
.splat-head { margin-bottom: 18px; }
.splat-head h2 { margin: 0; color: var(--ink); font-size: 28px; font-weight: 700; letter-spacing: 2px; }

.splat-search-bar { display: flex; gap: 10px; margin-bottom: 18px; }
.splat-search-input {
  flex: 1; height: 42px; padding: 0 14px;
  border: 1px solid rgba(138, 56, 48, 0.18);
  background: rgba(255, 253, 249, 0.98);
  outline: none; font-size: 14px; color: var(--ink);
  transition: border-color 0.25s ease, box-shadow 0.25s ease;
}
.splat-search-input:focus {
  border-color: rgba(138, 56, 48, 0.4);
  box-shadow: 0 0 0 3px rgba(138, 56, 48, 0.07);
}

.splat-search-btn {
  min-width: 88px; height: 42px;
  border: none;
  background: var(--red);
  color: rgba(255, 248, 235, 0.96);
  font-size: 14px; font-weight: 700; letter-spacing: 2px;
  cursor: pointer;
  transition: all 0.25s ease;
}
.splat-search-btn:hover { background: var(--red-deep); transform: translateY(-2px); box-shadow: 0 8px 18px var(--red-glow); }
.splat-search-btn:active { transform: translateY(0); }

.splat-result-list { display: grid; gap: 12px; }

.enter-link { cursor: pointer; color: var(--red-deep); font-weight: 700; transition: all 0.2s ease; }
.enter-link:hover { color: var(--red); letter-spacing: 1px; }

/* ===== 过渡动画 ===== */
.fade-up-enter-active, .fade-up-leave-active { transition: all 0.28s ease; }
.fade-up-enter-from, .fade-up-leave-to { opacity: 0; transform: translateY(10px); }

.mask-fade-enter-active, .mask-fade-leave-active { transition: opacity 0.25s ease; }
.mask-fade-enter-from, .mask-fade-leave-to { opacity: 0; }

.panel-rise-enter-active { animation: panelRiseIn 0.32s cubic-bezier(0.23, 1, 0.32, 1) both; }
.panel-rise-leave-active { animation: panelRiseOut 0.2s ease both; }
@keyframes panelRiseIn {
  from { opacity: 0; transform: translateY(24px) scale(0.97); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}
@keyframes panelRiseOut {
  from { opacity: 1; transform: translateY(0) scale(1); }
  to { opacity: 0; transform: translateY(12px) scale(0.98); }
}

/* ===== 响应式 ===== */
@media (max-width: 1400px) {
  .hero-inner { width: calc(100vw - 24px); min-height: 330px; padding: 62px 168px 56px; }
  .content-wrap, .bottom-showcase { width: min(100%, calc(100vw - 36px)); }
  .hero-decor-left { left: -24px; width: min(46vw, 660px); }
  .hero-decor-right { right: 0; width: min(22vw, 280px); }
}

@media (max-width: 1200px) {
  .content-wrap { grid-template-columns: 1fr; }
  .showcase-grid { grid-template-columns: 1fr; }
  .hero-inner { min-height: 300px; padding: 54px 112px 48px; }
}

@media (max-width: 768px) {
  .hero { padding: 16px 0 18px; }
  .hero-inner { width: calc(100vw - 12px); min-height: 250px; padding: 34px 24px 28px; }
  .hero h1 { font-size: 36px; }
  .hero-desc { font-size: 14px; }
  .content-wrap, .bottom-showcase { width: calc(100vw - 20px); }
  .panel { padding: 18px; }
  .panel-head h2, .showcase-head h2 { font-size: 24px; }
  .upload-inner { padding: 16px; min-height: 100px; }
  .upload-title { font-size: 19px; }
  .poem-main-card h3, .scene-card h3, .detail-title { font-size: 22px; }
  .detail-panel, .splat-panel { width: calc(100vw - 20px); padding: 22px 16px 18px; }
  .detail-mask, .splat-mask { padding: 10px; }
  .hero-decor-left { left: -200px; bottom: 0; width: 105vw; opacity: 0.75; }
  .hero-decor-right { top: auto; bottom: 100px; right: -2px; transform: none; width: 300px; opacity: 0.8; }
  .enter-splat-btn { top: 10px; right: 10px; height: 36px; padding: 0 14px; font-size: 13px; }
  .splat-search-bar { flex-direction: column; }
  .splat-search-btn { width: 100%; min-width: 0; }
}
</style>
