<template>
  <div class="story-page">
    <div class="bg-ink"></div>
    <div class="bg-palace palace-top"></div>
    <div class="bg-palace palace-bottom"></div>

    <aside class="side-banner">
      <div class="side-top-title">诗词典故</div>
      <div class="side-top-line"></div>
      <div class="side-main-text">以典入诗 · 诗以载道</div>
      <div class="side-bottom">
        <div class="side-seal">典</div>
        <div class="side-small">诗词 · 典故</div>
        <div class="brand-mark">
          <strong>诗</strong>
          <span>诗典溯源</span>
          <small>POETIC ALLUSIONS</small>
        </div>
      </div>
    </aside>

    <main class="page-wrap">
      <section class="left-menu">
        <div class="menu-title">
          <span>典故分类</span>
          <small>Allusions</small>
        </div>
        <button
            v-for="item in categories"
            :key="item.id"
            class="menu-item"
            :class="{ active: currentCategoryId === item.id }"
            @click="changeCategory(item.id)"
        >
          <i></i>
          <span>{{ item.name }}</span>
        </button>

        <div class="hot-section">
          <div class="hot-title">
            <span>热门典故</span>
            <small>Hot</small>
          </div>
          <div v-if="hotLoading" class="hot-loading">加载中...</div>
          <div v-else-if="hotStories.length" class="hot-list">
            <button
                v-for="(item, idx) in hotStories"
                :key="'hot-' + item.id"
                class="hot-item"
                @click="loadDetail(item.id)"
            >
              <span class="hot-rank" :class="{ top: idx < 3 }">{{ idx + 1 }}</span>
              <span class="hot-name">{{ item.title }}</span>
              <span class="hot-heat">{{ item.heat }}</span>
            </button>
          </div>
        </div>
      </section>

      <section class="story-list-panel">
        <div class="list-head">
          <div>
            <strong>共 {{ stories.length }} 条典故</strong>
            <p>循典入诗，观文见史</p>
          </div>
          <div class="search">
            <input v-model="keyword" placeholder="搜索典故" @keyup.enter="loadStories" />
            <button @click="loadStories">搜</button>
          </div>
        </div>
        <div class="story-scroll">
          <article
              v-for="item in stories"
              :key="item.id"
              class="story-card"
              :class="{ active: selectedStoryId === item.id }"
              @click="loadDetail(item.id)"
          >
            <div class="story-cover" :style="getCoverStyle(item.id)">
              <img v-if="item.coverImage" :src="item.coverImage" alt="" loading="lazy" @load="rememberImageRatio($event, item.id)" />
              <div v-else class="ink-cover">
                <span>{{ item.title?.slice(0, 1) || '典' }}</span>
              </div>
            </div>
            <div class="story-info">
              <div class="title-row">
                <h3>{{ item.title }}</h3>
                <em>{{ categoryName(item.categoryId) }}</em>
              </div>
              <p>朝代：{{ item.dynasty || '未知' }}</p>
              <p>关键词：{{ item.keywords || '暂无' }}</p>
              <div class="card-bottom">
                <span>热度 {{ item.heat || 0 }}</span>
                <b>查看</b>
              </div>
            </div>
          </article>
        </div>
      </section>

      <section v-if="detail" class="detail-panel">
        <transition name="text-change" mode="out-in">
          <div class="detail-top" :key="'top-' + detail.story.id">
            <div>
              <div class="detail-mark">当前典故</div>
              <h1>{{ detail.story.title }}</h1>
              <p>
                朝代：{{ detail.story.dynasty || '未知' }}
                <span></span>
                关键词：{{ detail.story.keywords || '暂无' }}
              </p>
            </div>
            <div class="detail-actions">
              <button
                  class="action-btn"
                  :class="{ active: liked }"
                  @click="toggleLike"
                  title="点赞"
              >
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M14 9V5a3 3 0 0 0-3-3l-4 9v11h11.28a2 2 0 0 0 2-1.7l1.38-9a2 2 0 0 0-2-2.3H14z"/>
                  <path d="M7 22H4a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2h3"/>
                </svg>
                <span>{{ liked ? '已赞' : '点赞' }}</span>
              </button>
              <button
                  class="action-btn"
                  :class="{ active: faved }"
                  @click="toggleFav"
                  title="收藏"
              >
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/>
                </svg>
                <span>{{ faved ? '已藏' : '收藏' }}</span>
              </button>
              <button class="poster-btn" @click="showPosterTip = true">生成海报</button>
            </div>
          </div>
        </transition>

        <div class="feature-area">
          <transition name="paint" mode="out-in">
            <div class="feature-image" :key="'image-' + detail.story.id" :style="getFeatureStyle(detail.story.id)">
              <img v-if="detail.story.coverImage" :src="detail.story.coverImage" alt="" loading="eager" @load="rememberImageRatio($event, detail.story.id)" />
              <div v-else class="feature-ink">
                <div class="sun"></div>
                <div class="mountain m1"></div>
                <div class="mountain m2"></div>
                <strong>{{ detail.story.title }}</strong>
              </div>
            </div>
          </transition>

          <transition name="text-change" mode="out-in">
            <div class="intro-card" :key="'intro-' + detail.story.id">
              <h2>典故简介</h2>
              <p>{{ detail.story.summary }}</p>
              <div class="source">出处：{{ detail.story.source || '暂无' }}</div>
            </div>
          </transition>
        </div>

        <!-- ===== 关联诗词 ===== -->
        <section class="poem-section">
          <transition name="text-change" mode="out-in">
            <div class="section-title" :key="'poem-title-' + detail.story.id">
              <h2>关联诗词</h2>
              <span>{{ detail.poems?.length || 0 }} 首</span>
            </div>
          </transition>

          <transition name="cards-change" mode="out-in">
            <div
                v-if="detail.poems && detail.poems.length"
                class="poem-grid"
                :key="'poems-' + detail.story.id"
            >
              <article
                  v-for="(poem, idx) in detail.poems"
                  :key="poem.id"
                  class="poem-card"
                  :style="{ animationDelay: idx * 0.07 + 's' }"
              >
                <div class="poem-index">{{ String(idx + 1).padStart(2, '0') }}</div>

                <div class="poem-content">
                  <div class="poem-header">
                    <h3>《{{ poem.title }}》</h3>
                    <div class="poem-dynasty-badge">{{ poem.dynasty }}</div>
                  </div>
                  <p class="author">{{ poem.author }}</p>
                  <div class="poem-divider"></div>
                  <p class="poem-text">{{ poem.content }}</p>
                </div>

                <div class="poem-footer">
                  <div class="poem-footer-left">
                    <span class="poem-tag">诗词</span>
                  </div>
                  <button class="poem-detail-btn">
                    <span>查看详情</span>
                    <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
                      <path d="M2.5 6h7M6.5 3l3 3-3 3" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                  </button>
                </div>
              </article>
            </div>

            <div v-else class="empty" :key="'empty-poem-' + detail.story.id">
              暂无关联诗词
            </div>
          </transition>
        </section>

        <!-- ===== 典故解析 ===== -->
        <transition name="text-change" mode="out-in">
          <section class="analysis-card" :key="'analysis-' + detail.story.id">
            <div class="analysis-header">
              <h2>典故解析</h2>
              <div class="analysis-deco">
                <span></span><span></span><span></span>
              </div>
            </div>
            <div class="analysis-body">
              <div class="analysis-quote-mark">"</div>
              <p>{{ detail.story.content }}</p>
            </div>
            <div class="analysis-footer">
              <div class="analysis-seal">解</div>
              <span>{{ detail.story.title }} · 典故解析</span>
            </div>
          </section>
        </transition>

        <!-- ===== 推荐 ===== -->
        <section class="recommend-section">
          <transition name="text-change" mode="out-in">
            <div class="section-title" :key="'rec-title-' + detail.story.id">
              <h2>推荐</h2>
              <span v-if="recommendMeta.triggerType" class="rec-trigger-badge">
                {{ triggerTypeLabel(recommendMeta.triggerType) }}
              </span>
            </div>
          </transition>

          <transition name="cards-change" mode="out-in">
            <div v-if="recLoading" class="rec-loading" :key="'rec-loading'">
              <div class="rec-loading-spinner"></div>
              <span>正在为你推荐...</span>
            </div>

            <div
                v-else-if="recommendedStories.length"
                class="rec-grid"
                :key="'rec-' + detail.story.id"
            >
              <article
                  v-for="(item, idx) in recommendedStories"
                  :key="'rec-story-' + item.id"
                  class="rec-card"
                  :style="{ animationDelay: idx * 0.08 + 's' }"
                  @click="loadDetail(item.id)"
              >
                <div class="rec-cover" :style="getCoverStyle(item.id)">
                  <img v-if="item.coverImage" :src="item.coverImage" alt="" loading="lazy" @load="rememberImageRatio($event, item.id)" />
                  <div v-else class="rec-ink-cover">
                    <span>{{ item.title?.slice(0, 1) || '典' }}</span>
                  </div>
                </div>
                <div class="rec-info">
                  <div class="rec-header">
                    <h3>{{ item.title }}</h3>
                    <span class="rec-score">{{ (item.score * 100).toFixed(0) }}%</span>
                  </div>
                  <p class="rec-dynasty">{{ item.dynasty || '未知' }}</p>
                  <p class="rec-summary">{{ item.summary }}</p>
                  <div class="rec-tags">
                    <span v-for="tag in (item.tags || [])" :key="tag" class="rec-tag">{{ tag }}</span>
                  </div>
                  <div class="rec-reason">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/>
                    </svg>
                    <span>{{ item.reason }}</span>
                  </div>
                </div>
              </article>
            </div>

            <div v-else class="empty rec-empty" :key="'rec-empty-' + detail.story.id">
              暂无推荐典故
            </div>
          </transition>
        </section>
      </section>

      <section v-else class="detail-panel empty-panel">
        请选择一个典故查看详情
      </section>

      <aside class="right-count">
        <div>相关诗词</div>
        <strong>{{ detail?.poems?.length || 0 }}</strong>
        <span>首</span>
      </aside>
    </main>

    <transition name="toast">
      <div v-if="showPosterTip" class="toast" @animationend="showPosterTip = false">
        海报生成功能后续可接入
      </div>
    </transition>
    <transition name="toast">
      <div v-if="actionToast" class="toast toast-action" @animationend="actionToast = ''">
        {{ actionToast }}
      </div>
    </transition>
  </div>
</template>

<script setup>
import { onMounted, ref } from "vue";
import { authGet, authPost } from "@/utils/api";
import { isLoggedIn } from "@/utils/auth";

const API_BASE = "/api/story";

const categories = ref([]);
const stories = ref([]);
const detail = ref(null);

const currentCategoryId = ref(1);
const selectedStoryId = ref(null);
const keyword = ref("");
const showPosterTip = ref(false);
const actionToast = ref("");

const imageRatioMap = ref({});

const liked = ref(false);
const faved = ref(false);
const likeSet = ref(new Set(JSON.parse(localStorage.getItem("story_liked") || "[]")));
const favSet = ref(new Set(JSON.parse(localStorage.getItem("story_faved") || "[]")));

function persistLikeFav() {
  localStorage.setItem("story_liked", JSON.stringify([...likeSet.value]));
  localStorage.setItem("story_faved", JSON.stringify([...favSet.value]));
}

function syncLikeFavState(storyId) {
  liked.value = likeSet.value.has(storyId);
  faved.value = favSet.value.has(storyId);
}

const recommendedStories = ref([]);
const recLoading = ref(false);
const recommendMeta = ref({ triggerType: "", algorithmVersion: "", latencyMs: 0, cacheHit: false });

const hotStories = ref([]);
const hotLoading = ref(false);

function rememberImageRatio(event, id) {
  const img = event?.target;
  if (!img || !id || !img.naturalWidth || !img.naturalHeight) return;
  imageRatioMap.value[id] = `${img.naturalWidth} / ${img.naturalHeight}`;
}

function getCoverStyle(id) {
  return {
    "--img-ratio": imageRatioMap.value[id] || "3 / 4",
  };
}

function getFeatureStyle(id) {
  return {
    "--img-ratio": imageRatioMap.value[id] || "3 / 4",
  };
}

function categoryName(id) {
  const item = categories.value.find((c) => c.id === id);
  return item ? item.name : "典故";
}

function triggerTypeLabel(type) {
  const map = {
    content_based: "基于内容相似",
    collaborative_filtering: "猜你喜欢",
    popular: "推荐",
  };
  return map[type] || type;
}

function unwrapData(res) {
  if (!res) return null;
  if (res.data !== undefined) return res.data;
  return res;
}

async function loadCategories() {
  try {
    const res = await authGet(`${API_BASE}/categories`);
    categories.value = unwrapData(res) ?? [];
  } catch (e) {
    console.error("加载分类失败:", e);
  }
}

async function loadStories() {
  const params = new URLSearchParams();
  if (currentCategoryId.value) params.append("categoryId", currentCategoryId.value);
  if (keyword.value.trim()) params.append("keyword", keyword.value.trim());
  try {
    const res = await authGet(`${API_BASE}/list?${params.toString()}`);
    stories.value = unwrapData(res) ?? [];
    if (stories.value.length > 0) {
      await loadDetail(stories.value[0].id);
    } else {
      detail.value = null;
      selectedStoryId.value = null;
    }
  } catch (e) {
    console.error("加载典故列表失败:", e);
  }
}

async function loadDetail(id) {
  if (selectedStoryId.value === id) return;
  selectedStoryId.value = id;
  syncLikeFavState(id);
  try {
    const res = await authGet(`${API_BASE}/${id}`);
    detail.value = unwrapData(res) ?? null;
    recordAction(id, "view");
    loadRecommendations(id);
  } catch (e) {
    console.error("加载典故详情失败:", e);
  }
}

async function loadRecommendations(storyId) {
  recLoading.value = true;
  recommendedStories.value = [];
  recommendMeta.value = { triggerType: "", algorithmVersion: "", latencyMs: 0, cacheHit: false };
  try {
    const dynasty = detail.value?.story?.dynasty || "";
    const res = await authGet(`/api/recommendation/stories?storyId=${storyId}&dynasty=${encodeURIComponent(dynasty)}&size=6`);
    const data = unwrapData(res);
    if (data) {
      const stories = data.stories || (Array.isArray(data) ? data : []);
      if (stories.length > 0) {
        recommendedStories.value = stories;
        recommendMeta.value = {
          triggerType: data.triggerType || "",
          algorithmVersion: data.meta?.algorithmVersion || "",
          latencyMs: data.meta?.latencyMs || 0,
          cacheHit: data.meta?.cacheHit || false,
        };
      } else {
        await fallbackToHot(6);
      }
    } else {
      await fallbackToHot(6);
    }
  } catch (e) {
    console.error("加载推荐失败，降级为热门推荐:", e);
    await fallbackToHot(6);
  } finally {
    recLoading.value = false;
  }
}

async function fallbackToHot(size) {
  if (hotStories.value.length > 0) {
    recommendedStories.value = hotStories.value.slice(0, size).map((s) => ({
      ...s,
      reason: "推荐",
      tags: s.tags?.length ? s.tags : ["热门"],
      score: s.score ?? 1.0,
    }));
    recommendMeta.value.triggerType = "popular";
    return;
  }
  try {
    const res = await authGet(`/api/recommendation/hot?size=${size}`);
    const data = unwrapData(res);
    const stories = data?.stories || (Array.isArray(data) ? data : []);
    recommendedStories.value = stories.map((s) => ({
      ...s,
      reason: "推荐",
      tags: s.tags?.length ? s.tags : ["热门"],
      score: s.score ?? 1.0,
    }));
    recommendMeta.value.triggerType = "popular";
  } catch (e2) {
    console.error("热门推荐也失败:", e2);
  }
}

async function loadHotStories() {
  hotLoading.value = true;
  try {
    const res = await authGet("/api/recommendation/hot?size=8");
    const data = unwrapData(res);
    hotStories.value = data?.stories || (Array.isArray(data) ? data : []);
  } catch (e) {
    console.error("加载热门典故失败:", e);
  } finally {
    hotLoading.value = false;
  }
}

async function recordAction(storyId, actionType) {
  if (!isLoggedIn()) return;
  try {
    await authPost("/api/recommendation/action", { storyId, actionType });
  } catch (e) {
    console.error("记录行为失败:", e);
  }
}

async function toggleLike() {
  if (!detail.value?.story?.id) return;
  if (!isLoggedIn()) {
    actionToast.value = "请先登录后再点赞";
    return;
  }
  const id = detail.value.story.id;
  liked.value = !liked.value;
  if (liked.value) {
    likeSet.value.add(id);
  } else {
    likeSet.value.delete(id);
  }
  persistLikeFav();
  try {
    await recordAction(id, "like");
    actionToast.value = liked.value ? "已点赞" : "已取消点赞";
  } catch (e) {
    liked.value = !liked.value;
    if (liked.value) likeSet.value.add(id);
    else likeSet.value.delete(id);
    persistLikeFav();
  }
}

async function toggleFav() {
  if (!detail.value?.story?.id) return;
  if (!isLoggedIn()) {
    actionToast.value = "请先登录后再收藏";
    return;
  }
  const id = detail.value.story.id;
  faved.value = !faved.value;
  if (faved.value) {
    favSet.value.add(id);
  } else {
    favSet.value.delete(id);
  }
  persistLikeFav();
  try {
    await recordAction(id, "fav");
    actionToast.value = faved.value ? "已收藏" : "已取消收藏";
  } catch (e) {
    faved.value = !faved.value;
    if (faved.value) favSet.value.add(id);
    else favSet.value.delete(id);
    persistLikeFav();
  }
}

function changeCategory(id) {
  currentCategoryId.value = id;
  loadStories();
}

onMounted(async () => {
  await loadCategories();
  await loadStories();
  loadHotStories();
});
</script>

<style scoped>
.story-page {
  --red: #8c3a35;
  --red2: #a04f46;
  --red-dark: #5e2520;
  --red-glow: rgba(140, 58, 53, 0.15);
  --gold: #c9a46a;
  --gold-light: #ead8ad;
  --gold-dark: #8d6b36;
  --paper: #f8f4eb;
  --paper-bg: rgba(248, 244, 235, 0.95);
  --paper-card: rgba(251, 246, 237, 0.92);
  --paper2: #fbf6ea;
  --paper3: #efe3cc;
  --ink: #221814;
  --ink-light: #5b493b;
  --muted: #8b7a64;
  --border: #d8c5a1;
  --line: rgba(72, 60, 46, 0.12);
  --line-strong: rgba(72, 60, 46, 0.2);

  position: relative;
  min-height: calc(100vh - 64px);
  overflow: hidden;
  background: var(--paper-bg);
  color: var(--ink);
  cursor: default;
}

.story-page::before {
  content: "";
  position: fixed;
  inset: 0;
  z-index: -2;
  background:
      linear-gradient(rgba(248, 244, 235, 0.92), rgba(248, 244, 235, 0.96)),
      var(--paper) center center / cover no-repeat;
  pointer-events: none;
}

.story-page::after {
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

.bg-ink {
  position: absolute;
  inset: 0;
  background:
      linear-gradient(90deg, rgba(160, 125, 74, 0.08) 1px, transparent 1px),
      linear-gradient(180deg, rgba(160, 125, 74, 0.06) 1px, transparent 1px);
  background-size: 44px 44px;
  pointer-events: none;
  opacity: 0.5;
}
.bg-ink::after { display: none; }
.bg-palace { position: absolute; pointer-events: none; opacity: 0.4; }
.palace-top {
  right: 34px; top: -10px; width: 390px; height: 150px;
  background:
      linear-gradient(140deg, transparent 48%, rgba(165, 111, 49, 0.35) 49%, transparent 54%),
      linear-gradient(180deg, transparent 60%, rgba(159, 42, 31, 0.22) 61% 68%, transparent 69%);
}
.palace-bottom {
  right: 92px; bottom: 0; width: 530px; height: 210px;
  background:
      linear-gradient(135deg, transparent 48%, rgba(157, 113, 55, 0.45) 49%, rgba(157, 113, 55, 0.22) 53%, transparent 54%),
      linear-gradient(180deg, transparent 62%, rgba(179, 68, 47, 0.28) 63% 75%, transparent 76%);
}

.page-wrap {
  position: relative;
  z-index: 2;
  display: grid;
  grid-template-columns: 220px 390px minmax(0, 1fr) 72px;
  align-items: stretch;
  gap: 22px;
  padding: 86px 38px 46px 152px;
  box-sizing: border-box;
}

.side-banner {
  position: absolute;
  left: 0; top: 0; bottom: 0;
  z-index: 5;
  width: 112px;
  background: linear-gradient(90deg, rgba(255,255,255,0.18), transparent 42%), rgba(246, 239, 224, 0.92);
  border-right: 1px solid var(--border);
  color: var(--red);
  display: flex;
  align-items: center;
  flex-direction: column;
  animation: sideEnter 0.8s ease both;
}
@keyframes sideEnter {
  from { opacity: 0; transform: translateX(-24px); }
  to { opacity: 1; transform: translateX(0); }
}
.side-top-title { margin-top: 58px; font-size: 17px; font-weight: 700; letter-spacing: 4px; color: var(--red); transition: all 0.35s ease; }
.side-banner:hover .side-top-title { letter-spacing: 7px; transform: translateY(-3px); }
.side-top-line { width: 72px; height: 1px; background: var(--gold-dark); margin-top: 18px; transform-origin: left center; animation: lineGrow 1s ease both; }
@keyframes lineGrow { from { transform: scaleX(0); opacity: 0; } to { transform: scaleX(1); opacity: 1; } }
.side-main-text { writing-mode: vertical-rl; letter-spacing: 10px; font-size: 42px; line-height: 1.35; font-family: "STKaiti", "KaiTi", serif; color: var(--red); margin-top: 210px; transition: all 0.35s ease; animation: verticalTextIn 0.9s ease both; }
@keyframes verticalTextIn { from { opacity: 0; transform: translateY(28px); } to { opacity: 1; transform: translateY(0); } }
.side-banner:hover .side-main-text { letter-spacing: 13px; transform: translateY(-6px); }
.side-bottom { margin-top: auto; margin-bottom: 40px; display: flex; align-items: center; flex-direction: column; }
.side-seal { width: 28px; height: 28px; border: 2px solid var(--red); display: grid; place-items: center; font-weight: 700; font-size: 14px; color: var(--red); transition: all 0.35s ease; animation: sealPulse 2.6s ease-in-out infinite; }
@keyframes sealPulse {
  0%, 100% { transform: scale(1); box-shadow: 0 0 0 rgba(159, 42, 31, 0); }
  50% { transform: scale(1.08); box-shadow: 0 0 16px rgba(159, 42, 31, 0.18); }
}
.side-banner:hover .side-seal { transform: scale(1.14) rotate(6deg); animation: none; background: var(--red); color: var(--paper2); }
.side-small { writing-mode: vertical-rl; letter-spacing: 6px; font-size: 16px; margin-top: 18px; color: var(--red); transition: all 0.35s ease; }
.side-banner:hover .side-small { letter-spacing: 8px; transform: translateY(-4px); }
.brand-mark { margin-top: 28px; display: flex; align-items: center; flex-direction: column; color: var(--ink); transition: all 0.35s ease; }
.side-banner:hover .brand-mark { transform: translateY(-4px); }
.brand-mark strong { width: 34px; height: 34px; border: 3px solid var(--red); color: var(--red); display: grid; place-items: center; font-size: 18px; margin-bottom: 8px; transition: all 0.35s ease; }
.side-banner:hover .brand-mark strong { background: var(--red); color: var(--paper2); transform: rotate(4deg); }
.brand-mark span { font-size: 14px; font-weight: 700; letter-spacing: 2px; }
.brand-mark small { margin-top: 3px; font-size: 7px; letter-spacing: 0.5px; }

.left-menu,
.story-list-panel,
.detail-panel {
  background: var(--paper-card);
  border: 1px solid var(--line);
  transition: box-shadow 0.3s ease, background 0.3s ease, border-color 0.3s ease;
}
.left-menu:hover, .story-list-panel:hover, .detail-panel:hover {
  background: rgba(255, 255, 255, 0.96);
  border-color: var(--line-strong);
  box-shadow: 0 8px 28px rgba(72, 60, 46, 0.1);
}

.left-menu { min-height: 760px; padding: 34px 18px; }
.menu-title { padding: 0 6px 24px; border-bottom: 1px solid var(--border); margin-bottom: 18px; }
.menu-title span { display: block; color: var(--ink); font-size: 22px; font-weight: 700; letter-spacing: 4px; transition: all 0.3s ease; }
.menu-title:hover span { color: var(--red); letter-spacing: 5px; }
.menu-title small { display: block; margin-top: 7px; color: var(--muted); font-size: 12px; letter-spacing: 1px; }
.menu-item {
  position: relative; width: 100%; height: 52px; margin-bottom: 8px;
  border: none; border-left: 3px solid transparent;
  background: transparent; color: var(--ink-light);
  font-size: 15px; font-weight: 600; text-align: left;
  padding: 0 16px; cursor: pointer;
  display: flex; align-items: center; gap: 12px;
  overflow: hidden; transition: all 0.3s ease;
}
.menu-item::before { content: ""; position: absolute; left: 0; top: 8px; bottom: 8px; width: 0; background: var(--red); transition: width 0.3s ease; z-index: -1; }
.menu-item:hover::before, .menu-item.active::before { width: 100%; }
.menu-item i { width: 8px; height: 8px; border: 1px solid var(--gold-dark); transform: rotate(45deg); transition: all 0.3s ease; flex-shrink: 0; }
.menu-item:hover, .menu-item.active { color: var(--paper2); transform: translateX(6px) scale(1.01); border-left-color: var(--red); }
.menu-item:hover i, .menu-item.active i { border-color: var(--gold-light); background: var(--gold-light); transform: rotate(45deg) scale(1.15); }
.menu-item:active { transform: translateX(6px) scale(0.98); }

/* ===== 热门典故侧栏 ===== */
.hot-section {
  margin-top: 28px;
  padding-top: 20px;
  border-top: 1px solid var(--border);
}
.hot-title {
  padding: 0 6px 14px;
}
.hot-title span { display: block; color: var(--red); font-size: 15px; font-weight: 700; letter-spacing: 3px; }
.hot-title small { display: block; margin-top: 4px; color: var(--muted); font-size: 11px; letter-spacing: 1px; }
.hot-loading {
  text-align: center;
  color: var(--muted);
  font-size: 12px;
  padding: 12px 0;
}
.hot-list {
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.hot-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 7px 10px;
  border: none;
  background: transparent;
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: left;
  width: 100%;
}
.hot-item:hover {
  background: rgba(159, 42, 31, 0.06);
  transform: translateX(4px);
}
.hot-rank {
  width: 20px;
  height: 20px;
  display: grid;
  place-items: center;
  font-size: 11px;
  font-weight: 700;
  color: var(--muted);
  border: 1px solid var(--border);
  flex-shrink: 0;
  transition: all 0.25s ease;
}
.hot-rank.top {
  background: var(--red);
  color: var(--gold-light);
  border-color: var(--red);
}
.hot-item:hover .hot-rank.top {
  transform: scale(1.1);
}
.hot-name {
  flex: 1;
  font-size: 13px;
  color: var(--ink-light);
  font-weight: 600;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  transition: color 0.25s ease;
}
.hot-item:hover .hot-name {
  color: var(--red);
}
.hot-heat {
  font-size: 10px;
  color: var(--gold-dark);
  font-weight: 700;
  flex-shrink: 0;
}

/* ===== 列表面板 ===== */
.story-list-panel {
  height: 2350px;
  min-height: 820px;
  max-height: 2350px;
  padding: 20px 14px 14px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}
.list-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-height: 48px;
  margin-bottom: 10px;
  padding-bottom: 10px;
  border-bottom: 1px solid var(--border);
}
.list-head strong { color: var(--ink); font-size: 15px; font-weight: 700; transition: all 0.3s ease; }
.list-head:hover strong { color: var(--red); }
.list-head p { margin: 7px 0 0; color: var(--red); font-size: 13px; letter-spacing: 3px; }
.search { display: flex; height: 36px; border: 1px solid var(--border); background: rgba(251, 246, 234, 0.62); overflow: hidden; transition: all 0.3s ease; }
.search:focus-within { border-color: var(--red); box-shadow: 0 0 0 3px rgba(159, 42, 31, 0.08); }
.search input { width: 110px; border: none; outline: none; background: transparent; padding: 0 14px; color: var(--ink); font-size: 13px; }
.search input::placeholder { color: var(--muted); }
.search button { width: 42px; border: none; border-left: 1px solid var(--border); background: var(--red); color: var(--gold-light); font-weight: 700; font-size: 14px; cursor: pointer; transition: all 0.3s ease; position: relative; overflow: hidden; }
.search button::before { content: ""; position: absolute; top: 50%; left: 50%; width: 0; height: 0; background: rgba(255,255,255,0.16); border-radius: 50%; transform: translate(-50%, -50%); transition: all 0.5s ease; }
.search button:hover::before { width: 160px; height: 160px; }
.search button:hover { background: var(--red-dark); }
.search button:active { transform: scale(0.95); }
.story-scroll { flex: 1; overflow-y: auto; padding-right: 6px; min-height: 0; }
.story-scroll::-webkit-scrollbar { width: 6px; }
.story-scroll::-webkit-scrollbar-track { background: rgba(239, 227, 204, 0.5); }
.story-scroll::-webkit-scrollbar-thumb { background: var(--red); }
.story-scroll::-webkit-scrollbar-thumb:hover { background: var(--red-dark); }

.story-card {
  position: relative;
  display: flex;
  flex-direction: row;
  gap: 10px;
  align-items: stretch;
  padding: 7px;
  margin-bottom: 5px;
  background: rgba(246, 239, 224, 0.56);
  border: 1px solid rgba(216, 197, 161, 0.65);
  cursor: pointer;
  transition: all 0.3s ease;
  overflow: hidden;
}
.story-card::before {
  content: "";
  position: absolute;
  left: 0; top: 5px; bottom: 5px;
  width: 3px;
  background: var(--red);
  opacity: 0;
  transition: all 0.3s ease;
}
.story-card::after {
  content: "›";
  position: absolute;
  right: 6px; top: 50%;
  color: var(--red);
  font-size: 22px;
  font-weight: 300;
  opacity: 0;
  transform: translate(-6px, -50%);
  transition: all 0.3s ease;
}
.story-card:hover,
.story-card.active {
  border-color: var(--red);
  background: rgba(251, 246, 234, 0.92);
  transform: translateY(-2px) scale(1.01);
  box-shadow: 0 4px 12px rgba(98, 60, 36, 0.08);
}
.story-card:hover::before,
.story-card.active::before { opacity: 1; }
.story-card:hover::after,
.story-card.active::after { opacity: 1; transform: translate(0, -50%); }
.story-card:active { transform: translateY(-1px) scale(0.99); }

.story-cover {
  width: 65px;
  height: 85px;
  min-width: 65px;
  flex-shrink: 0;
  overflow: hidden;
  background:
      radial-gradient(circle at 50% 30%, rgba(255, 255, 255, 0.62), transparent 58%),
      linear-gradient(145deg, rgba(247, 238, 219, 0.96), rgba(226, 207, 172, 0.72));
  border: 1px solid var(--border);
  box-shadow: inset 0 0 8px rgba(72, 60, 46, 0.06);
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.story-cover img {
  width: 100%;
  height: auto;
  max-height: 85px;
  object-fit: contain;
  object-position: center;
  transition: filter 0.35s ease;
  filter: sepia(0.12) saturate(0.94) contrast(0.98);
}
.story-card:hover .story-cover { box-shadow: 0 2px 10px rgba(201, 164, 106, 0.2), inset 0 0 8px rgba(72, 60, 46, 0.04); }
.story-card:hover .story-cover img { filter: sepia(0.04) saturate(1) contrast(1.02); }
.ink-cover { width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: radial-gradient(circle at 30% 22%, rgba(159, 42, 31, 0.12), transparent 46%), var(--paper2); transition: all 0.3s ease; }
.story-card:hover .ink-cover { background: radial-gradient(circle at 30% 22%, rgba(159, 42, 31, 0.18), transparent 46%), var(--paper); }
.ink-cover span { font-size: 24px; color: var(--red); font-family: "STKaiti", "KaiTi", serif; font-weight: 700; transition: all 0.3s ease; }
.story-card:hover .ink-cover span { transform: scale(1.08); }

.story-info {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 1px;
  overflow: hidden;
}

.title-row {
  display: flex;
  align-items: center;
  gap: 5px;
  line-height: 1.15;
}
.title-row h3 {
  margin: 0;
  color: var(--ink);
  font-size: 14px;
  font-family: "STKaiti", "KaiTi", serif;
  font-weight: 700;
  transition: all 0.3s ease;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  flex: 1;
}
.story-card:hover .title-row h3 { color: var(--red); }
.title-row em {
  font-style: normal;
  font-size: 9px;
  padding: 1px 5px;
  background: transparent;
  border: 1px solid rgba(141, 107, 54, 0.35);
  color: var(--gold-dark);
  white-space: nowrap;
  transition: all 0.3s ease;
  font-weight: 600;
  flex-shrink: 0;
}
.story-card:hover .title-row em { background: rgba(201, 164, 106, 0.2); color: var(--red); }

.story-info p {
  margin: 0;
  color: var(--muted);
  font-size: 11px;
  line-height: 1.35;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  transition: color 0.3s ease;
}
.story-card:hover .story-info p { color: var(--ink-light); }

.card-bottom {
  margin-top: auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 3px;
}
.card-bottom span { color: var(--gold-dark); font-size: 12px; font-weight: 700; transition: all 0.3s ease; }
.story-card:hover .card-bottom span { color: var(--red); }
.card-bottom b { opacity: 0; color: var(--red); font-size: 12px; font-weight: 700; transition: all 0.3s ease; transform: translateX(-10px); }
.story-card:hover .card-bottom b, .story-card.active .card-bottom b { opacity: 1; transform: translateX(0); }

/* ===== 详情面板 ===== */
.detail-panel {
  min-height: 760px;
  padding: 34px 34px 60px;
  box-sizing: border-box;
  background: rgba(251, 246, 234, 0.72);
  position: relative;
  overflow: hidden;
}
.detail-panel::after {
  content: "";
  position: absolute; right: -16px; bottom: -10px; width: 420px; height: 150px;
  opacity: 0.54; pointer-events: none;
  background:
      linear-gradient(135deg, transparent 47%, rgba(157, 113, 55, 0.55) 48%, rgba(157, 113, 55, 0.28) 53%, transparent 54%),
      linear-gradient(180deg, transparent 62%, rgba(179, 68, 47, 0.32) 63% 75%, transparent 76%),
      repeating-linear-gradient(90deg, rgba(80, 112, 96, 0.22) 0 8px, rgba(203, 168, 102, 0.28) 8px 16px, transparent 16px 24px);
}

.detail-top { display: flex; justify-content: space-between; align-items: flex-start; gap: 20px; }
.detail-mark { display: inline-block; margin-bottom: 14px; padding-left: 12px; color: var(--red); font-size: 14px; letter-spacing: 2px; border-left: 4px solid var(--red); animation: markPulse 2s ease-in-out infinite; }
@keyframes markPulse { 0%, 100% { opacity: 0.82; } 50% { opacity: 1; } }
.detail-top h1 { margin: 0; color: var(--ink); font-size: 44px; letter-spacing: 7px; font-family: "STKaiti", "KaiTi", serif; font-weight: 700; line-height: 1.2; transition: all 0.3s ease; }
.detail-top:hover h1 { letter-spacing: 9px; color: var(--red); }
.detail-top p { margin: 14px 0 0; color: var(--muted); font-size: 15px; letter-spacing: 2px; }
.detail-top p span { display: inline-block; width: 1px; height: 12px; background: var(--gold); margin: 0 12px; vertical-align: -1px; }

/* ===== 详情操作按钮 ===== */
.detail-actions {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-shrink: 0;
}
.action-btn {
  display: flex;
  align-items: center;
  gap: 5px;
  height: 36px;
  padding: 0 16px;
  border: 1px solid var(--border);
  background: transparent;
  color: var(--ink-light);
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  letter-spacing: 1px;
}
.action-btn:hover {
  border-color: var(--red);
  color: var(--red);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(159, 42, 31, 0.1);
}
.action-btn.active {
  background: var(--red);
  color: var(--gold-light);
  border-color: var(--red);
}
.action-btn.active:hover {
  background: var(--red-dark);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(159, 42, 31, 0.2);
}
.action-btn:active {
  transform: translateY(0) scale(0.97);
}
.action-btn svg {
  transition: transform 0.3s ease;
}
.action-btn:hover svg {
  transform: scale(1.15);
}
.action-btn.active svg {
  fill: var(--gold-light);
  stroke: var(--gold-light);
}

.poster-btn {
  height: 40px; border: 1px solid var(--red); background: transparent; color: var(--red);
  padding: 0 24px; font-weight: 700; font-size: 14px; cursor: pointer;
  transition: all 0.35s ease; flex-shrink: 0; position: relative; overflow: hidden; letter-spacing: 2px;
}
.poster-btn::before { content: ""; position: absolute; top: 0; left: -100%; width: 100%; height: 100%; background: linear-gradient(90deg, transparent, rgba(201, 164, 106, 0.38), transparent); transition: left 0.5s ease; }
.poster-btn:hover::before { left: 100%; }
.poster-btn:hover { background: var(--red); color: var(--paper2); transform: translateY(-4px) scale(1.04); box-shadow: 0 10px 24px rgba(159, 42, 31, 0.18); }
.poster-btn:active { transform: translateY(-2px) scale(1.02); }

.feature-area {
  display: grid;
  grid-template-columns: minmax(230px, 300px) minmax(0, 1fr);
  gap: 28px;
  margin-top: 32px;
  align-items: stretch;
}
.feature-image {
  width: 100%;
  max-width: 300px;
  aspect-ratio: var(--img-ratio, 3 / 4);
  height: auto;
  min-height: 340px;
  max-height: 430px;
  justify-self: start;
  align-self: start;
  border: 1px solid var(--border);
  background:
      radial-gradient(circle at 50% 28%, rgba(255, 255, 255, 0.7), transparent 58%),
      linear-gradient(145deg, rgba(248, 239, 222, 0.98), rgba(224, 205, 169, 0.74));
  overflow: hidden;
  box-shadow:
      inset 0 0 45px rgba(36, 25, 21, 0.05),
      0 12px 26px rgba(72, 60, 46, 0.08);
  transition: all 0.4s ease;
  display: grid;
  place-items: center;
}
.feature-image:hover { border-color: var(--gold); box-shadow: inset 0 0 45px rgba(36, 25, 21, 0.04), 0 14px 32px rgba(98, 60, 36, 0.14); }
.feature-image img {
  width: 100%;
  height: 100%;
  display: block;
  object-fit: contain;
  object-position: center;
  transition: filter 0.45s ease;
  filter: sepia(0.16) saturate(0.96) contrast(0.98);
}
.feature-image:hover img { filter: sepia(0.04) saturate(1.04) brightness(1.02); }
.feature-ink { position: relative; width: 100%; height: 100%; overflow: hidden; background: radial-gradient(circle at 78% 22%, rgba(201, 164, 106, 0.42), transparent 70px), linear-gradient(145deg, var(--paper2), var(--paper3)); }
.sun { position: absolute; right: 60px; top: 36px; width: 58px; height: 58px; background: rgba(201, 164, 106, 0.65); border-radius: 50%; box-shadow: 0 0 36px rgba(201, 164, 106, 0.35); animation: sunGlow 4s ease-in-out infinite; }
@keyframes sunGlow { 0%, 100% { box-shadow: 0 0 32px rgba(201, 164, 106, 0.34); } 50% { box-shadow: 0 0 54px rgba(201, 164, 106, 0.58); } }
.mountain { position: absolute; bottom: 0; width: 120%; height: 140px; }
.m1 { left: -40px; background: linear-gradient(135deg, transparent 38%, rgba(36, 25, 21, 0.22) 39%, transparent 62%); animation: mountainMove 7s ease-in-out infinite alternate; }
.m2 { left: 60px; background: linear-gradient(45deg, transparent 44%, rgba(36, 25, 21, 0.16) 45%, transparent 68%); animation: mountainMove 9s ease-in-out infinite alternate-reverse; }
.feature-ink strong { position: absolute; left: 28px; bottom: 24px; color: var(--red); font-size: 32px; letter-spacing: 4px; font-family: "STKaiti", "KaiTi", serif; font-weight: 700; animation: textGlow 3s ease-in-out infinite; }
@keyframes textGlow { 0%, 100% { opacity: 0.86; } 50% { opacity: 1; } }

.intro-card { padding: 30px; background: rgba(255, 255, 255, 0.48); border: 1px solid var(--line); transition: all 0.3s ease; min-height: 0; }
.intro-card:hover { box-shadow: 0 8px 28px rgba(72, 60, 46, 0.08); transform: translateX(4px); background: rgba(255, 255, 255, 0.75); border-color: var(--line-strong); }
.intro-card h2, .section-title h2, .analysis-card h2 { margin: 0; color: var(--red); font-size: 22px; letter-spacing: 4px; font-family: "STKaiti", "KaiTi", serif; transition: all 0.3s ease; }
.intro-card:hover h2 { letter-spacing: 6px; }
.intro-card p { margin: 20px 0 0; color: var(--ink-light); line-height: 2; font-size: 15px; }
.source { margin-top: 24px; padding-top: 16px; border-top: 1px dashed var(--border); color: var(--gold-dark); font-weight: 700; font-size: 13px; }

.poem-section { margin-top: 38px; }
.section-title { display: flex; align-items: center; gap: 12px; padding: 8px 0; transition: all 0.3s ease; }
.section-title h2 { padding-left: 12px; border-left: 4px solid var(--red); }
.section-title span { padding: 4px 12px; background: transparent; border: 1px solid rgba(141, 107, 54, 0.38); color: var(--gold-dark); font-weight: 800; font-size: 12px; transition: all 0.3s ease; }
.section-title:hover span { background: rgba(201, 164, 106, 0.18); color: var(--red); }
.section-title:hover h2 { letter-spacing: 6px; }

.poem-grid {
  margin-top: 18px;
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px;
}

.poem-card {
  position: relative;
  min-height: 200px;
  padding: 0;
  background: rgba(255, 255, 255, 0.45);
  border: 1px solid var(--line);
  overflow: hidden;
  transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
  display: flex;
  flex-direction: column;
  animation: poemCardIn 0.5s ease both;
}

@keyframes poemCardIn {
  from { opacity: 0; transform: translateY(16px); }
  to { opacity: 1; transform: translateY(0); }
}

.poem-card::before {
  content: "";
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 3px;
  background: linear-gradient(90deg, var(--red), var(--gold), var(--red));
  background-size: 200% 100%;
  opacity: 0;
  transition: opacity 0.4s ease;
}

.poem-card::after {
  content: "";
  position: absolute;
  left: 0; top: 3px; bottom: 0;
  width: 3px;
  background: linear-gradient(180deg, var(--red) 0%, rgba(159,42,31,0.3) 100%);
  transform: scaleY(0);
  transform-origin: top center;
  transition: transform 0.4s cubic-bezier(0.23, 1, 0.32, 1);
}

.poem-card:hover {
  transform: translateY(-6px);
  border-color: rgba(138, 47, 43, 0.25);
  background: rgba(255, 255, 255, 0.92);
  box-shadow:
      0 12px 32px rgba(72, 60, 46, 0.1),
      0 4px 12px rgba(138, 47, 43, 0.06);
}

.poem-card:hover::before { opacity: 1; }
.poem-card:hover::after { transform: scaleY(1); }

.poem-index {
  position: absolute;
  top: 14px; right: 14px;
  font-size: 11px;
  font-family: Georgia, serif;
  color: rgba(141, 107, 54, 0.45);
  letter-spacing: 1px;
  font-weight: 700;
  transition: all 0.3s ease;
  line-height: 1;
}
.poem-card:hover .poem-index {
  color: var(--red);
  opacity: 0.7;
}

.poem-content {
  flex: 1;
  padding: 20px 20px 14px 20px;
}

.poem-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 8px;
  margin-bottom: 6px;
}

.poem-card h3 {
  margin: 0;
  color: var(--ink);
  font-size: 16px;
  font-family: "STKaiti", "KaiTi", serif;
  font-weight: 700;
  letter-spacing: 1px;
  line-height: 1.4;
  transition: all 0.3s ease;
  flex: 1;
}

.poem-card:hover h3 { color: var(--red); }

.poem-dynasty-badge {
  flex-shrink: 0;
  padding: 2px 8px;
  background: rgba(159, 42, 31, 0.08);
  border: 1px solid rgba(159, 42, 31, 0.2);
  color: var(--red);
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 1px;
  white-space: nowrap;
  transition: all 0.3s ease;
  margin-top: 2px;
}
.poem-card:hover .poem-dynasty-badge {
  background: rgba(159, 42, 31, 0.12);
  border-color: rgba(159, 42, 31, 0.4);
}

.author {
  margin: 0 0 10px;
  color: var(--gold-dark);
  font-size: 12px;
  letter-spacing: 1px;
  transition: color 0.3s ease;
}
.poem-card:hover .author { color: var(--red2); }

.poem-divider {
  height: 1px;
  background: linear-gradient(90deg, var(--border), transparent);
  margin-bottom: 10px;
  transition: all 0.3s ease;
}
.poem-card:hover .poem-divider {
  background: linear-gradient(90deg, rgba(159,42,31,0.3), transparent);
}

.poem-text {
  margin: 0;
  color: var(--ink-light);
  line-height: 1.9;
  font-size: 13px;
  max-height: 72px;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  transition: all 0.3s ease;
  font-family: "STKaiti", "KaiTi", serif;
  letter-spacing: 0.5px;
}
.poem-card:hover .poem-text { color: var(--ink); }

.poem-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 20px 14px;
  border-top: 1px dashed rgba(216, 197, 161, 0.6);
  margin-top: auto;
  background: rgba(246, 239, 224, 0.4);
  transition: all 0.3s ease;
}
.poem-card:hover .poem-footer {
  background: rgba(159, 42, 31, 0.04);
  border-top-color: rgba(159, 42, 31, 0.15);
}

.poem-footer-left {
  display: flex;
  align-items: center;
  gap: 6px;
}

.poem-tag {
  padding: 2px 8px;
  font-size: 10px;
  color: var(--gold-dark);
  border: 1px solid rgba(141, 107, 54, 0.3);
  letter-spacing: 1px;
  font-weight: 600;
  background: rgba(201, 164, 106, 0.08);
  transition: all 0.3s ease;
}
.poem-card:hover .poem-tag { border-color: rgba(159, 42, 31, 0.25); color: var(--red); background: rgba(159, 42, 31, 0.06); }

.poem-detail-btn {
  display: flex;
  align-items: center;
  gap: 5px;
  border: 1px solid var(--border);
  background: transparent;
  color: var(--ink-light);
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 1px;
  cursor: pointer;
  padding: 5px 12px;
  opacity: 0;
  transform: translateX(6px);
  transition: all 0.3s ease;
}
.poem-card:hover .poem-detail-btn {
  opacity: 1;
  transform: translateX(0);
  border-color: var(--red);
  color: var(--red);
}
.poem-detail-btn:hover {
  background: var(--red) !important;
  color: var(--paper2) !important;
  transform: translateX(0) scale(1.04) !important;
}
.poem-detail-btn:active { transform: scale(0.97) !important; }

.analysis-card {
  position: relative;
  margin-top: 38px;
  background: rgba(255, 255, 255, 0.45);
  border: 1px solid var(--line);
  overflow: hidden;
  transition: all 0.35s ease;
}

.analysis-card:hover {
  border-color: rgba(138, 47, 43, 0.2);
  background: rgba(255, 255, 255, 0.85);
  box-shadow: 0 8px 28px rgba(72, 60, 46, 0.08);
  transform: translateY(-2px);
}

.analysis-card::before {
  content: "";
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--red-dark), var(--red), var(--gold), var(--red), var(--red-dark));
}

.analysis-card::after {
  content: "解";
  position: absolute;
  right: -8px; bottom: -18px;
  font-size: 130px;
  font-family: "STKaiti", "KaiTi", serif;
  font-weight: 700;
  color: rgba(159, 42, 31, 0.045);
  pointer-events: none;
  line-height: 1;
  letter-spacing: 0;
  transition: all 0.4s ease;
  user-select: none;
}
.analysis-card:hover::after { color: rgba(159, 42, 31, 0.07); transform: rotate(-3deg); }

.analysis-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 22px 28px 18px;
  border-bottom: 1px solid rgba(216, 197, 161, 0.5);
}

.analysis-card h2 {
  padding-left: 14px;
  border-left: 4px solid var(--red);
  letter-spacing: 5px;
}
.analysis-card:hover h2 { letter-spacing: 7px; }

.analysis-deco {
  display: flex;
  gap: 5px;
  align-items: center;
}
.analysis-deco span {
  display: block;
  width: 6px; height: 6px;
  background: var(--gold);
  transform: rotate(45deg);
  transition: all 0.3s ease;
}
.analysis-deco span:nth-child(2) { background: var(--red); width: 8px; height: 8px; }
.analysis-deco span:nth-child(3) { background: var(--gold-dark); }
.analysis-card:hover .analysis-deco span { transform: rotate(45deg) scale(1.2); }

.analysis-body {
  position: relative;
  padding: 28px 36px 24px 52px;
}

.analysis-quote-mark {
  position: absolute;
  left: 26px; top: 16px;
  font-size: 52px;
  line-height: 1;
  font-family: Georgia, serif;
  color: rgba(159, 42, 31, 0.18);
  font-weight: 700;
  pointer-events: none;
  transition: all 0.3s ease;
}
.analysis-card:hover .analysis-quote-mark { color: rgba(159, 42, 31, 0.28); }

.analysis-body p {
  margin: 0;
  line-height: 2.1;
  color: var(--ink-light);
  font-size: 15px;
  letter-spacing: 0.5px;
  position: relative;
  z-index: 1;
  transition: color 0.3s ease;
}
.analysis-card:hover .analysis-body p { color: var(--ink); }

.analysis-footer {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px 28px 18px;
  border-top: 1px dashed rgba(216, 197, 161, 0.5);
  background: rgba(246, 239, 224, 0.4);
  transition: all 0.3s ease;
}
.analysis-card:hover .analysis-footer { background: rgba(159, 42, 31, 0.03); border-top-color: rgba(159, 42, 31, 0.12); }

.analysis-seal {
  width: 26px; height: 26px;
  border: 1.5px solid var(--red);
  display: grid; place-items: center;
  font-size: 13px; font-weight: 700;
  color: var(--red);
  flex-shrink: 0;
  transition: all 0.3s ease;
}
.analysis-card:hover .analysis-seal { background: var(--red); color: var(--paper2); transform: rotate(4deg); }

.analysis-footer span {
  font-size: 12px;
  color: var(--muted);
  letter-spacing: 2px;
  transition: color 0.3s ease;
}
.analysis-card:hover .analysis-footer span { color: var(--red2); }

/* ===== 推荐区域 ===== */
.recommend-section {
  margin-top: 38px;
}

.rec-trigger-badge {
  padding: 3px 10px;
  background: rgba(159, 42, 31, 0.08);
  border: 1px solid rgba(159, 42, 31, 0.2);
  color: var(--red);
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 1px;
  transition: all 0.3s ease;
}
.section-title:hover .rec-trigger-badge {
  background: rgba(159, 42, 31, 0.14);
  border-color: rgba(159, 42, 31, 0.35);
}

.rec-loading {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  min-height: 160px;
  color: var(--muted);
  font-size: 14px;
  letter-spacing: 1px;
}

.rec-loading-spinner {
  width: 22px;
  height: 22px;
  border: 2px solid var(--border);
  border-top-color: var(--red);
  border-radius: 50%;
  animation: recSpin 0.8s linear infinite;
}
@keyframes recSpin {
  to { transform: rotate(360deg); }
}

.rec-grid {
  margin-top: 18px;
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px;
}

.rec-card {
  position: relative;
  display: flex;
  flex-direction: column;
  background: rgba(255, 255, 255, 0.48);
  border: 1px solid var(--line);
  overflow: hidden;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
  animation: recCardIn 0.5s ease both;
}
@keyframes recCardIn {
  from { opacity: 0; transform: translateY(16px) scale(0.97); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}

.rec-card::before {
  content: "";
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 3px;
  background: linear-gradient(90deg, var(--gold), var(--red), var(--gold));
  opacity: 0;
  transition: opacity 0.4s ease;
}

.rec-card:hover {
  transform: translateY(-6px);
  border-color: rgba(138, 47, 43, 0.25);
  background: rgba(255, 255, 255, 0.92);
  box-shadow: 0 12px 32px rgba(72, 60, 46, 0.1), 0 4px 12px rgba(138, 47, 43, 0.06);
}

.rec-card:hover::before { opacity: 1; }

.rec-cover {
  width: 100%;
  height: 120px;
  overflow: hidden;
  background:
      radial-gradient(circle at 50% 30%, rgba(255, 255, 255, 0.62), transparent 58%),
      linear-gradient(145deg, rgba(247, 238, 219, 0.96), rgba(226, 207, 172, 0.72));
  display: flex;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid var(--line);
  transition: all 0.3s ease;
}
.rec-card:hover .rec-cover {
  border-bottom-color: rgba(159, 42, 31, 0.15);
}

.rec-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: filter 0.35s ease, transform 0.35s ease;
  filter: sepia(0.12) saturate(0.94);
}
.rec-card:hover .rec-cover img {
  filter: sepia(0.04) saturate(1.04);
  transform: scale(1.04);
}

.rec-ink-cover {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: radial-gradient(circle at 30% 22%, rgba(159, 42, 31, 0.1), transparent 46%), var(--paper2);
}
.rec-ink-cover span {
  font-size: 32px;
  color: var(--red);
  font-family: "STKaiti", "KaiTi", serif;
  font-weight: 700;
  transition: all 0.3s ease;
}
.rec-card:hover .rec-ink-cover span {
  transform: scale(1.1);
}

.rec-info {
  padding: 14px 16px 16px;
  display: flex;
  flex-direction: column;
  gap: 6px;
  flex: 1;
}

.rec-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}

.rec-header h3 {
  margin: 0;
  color: var(--ink);
  font-size: 15px;
  font-family: "STKaiti", "KaiTi", serif;
  font-weight: 700;
  letter-spacing: 1px;
  transition: color 0.3s ease;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  flex: 1;
}
.rec-card:hover .rec-header h3 { color: var(--red); }

.rec-score {
  flex-shrink: 0;
  padding: 2px 7px;
  background: rgba(159, 42, 31, 0.08);
  border: 1px solid rgba(159, 42, 31, 0.18);
  color: var(--red);
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.5px;
  transition: all 0.3s ease;
}
.rec-card:hover .rec-score {
  background: var(--red);
  color: var(--gold-light);
  border-color: var(--red);
}

.rec-dynasty {
  margin: 0;
  color: var(--gold-dark);
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 1px;
}

.rec-summary {
  margin: 0;
  color: var(--muted);
  font-size: 12px;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  transition: color 0.3s ease;
}
.rec-card:hover .rec-summary { color: var(--ink-light); }

.rec-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 5px;
  margin-top: 2px;
}

.rec-tag {
  padding: 1px 7px;
  font-size: 10px;
  color: var(--gold-dark);
  border: 1px solid rgba(141, 107, 54, 0.28);
  letter-spacing: 0.5px;
  font-weight: 600;
  background: rgba(201, 164, 106, 0.06);
  transition: all 0.3s ease;
}
.rec-card:hover .rec-tag {
  border-color: rgba(159, 42, 31, 0.22);
  color: var(--red);
  background: rgba(159, 42, 31, 0.05);
}

.rec-reason {
  display: flex;
  align-items: flex-start;
  gap: 5px;
  margin-top: auto;
  padding-top: 8px;
  border-top: 1px dashed rgba(216, 197, 161, 0.5);
  color: var(--muted);
  font-size: 11px;
  line-height: 1.5;
  transition: all 0.3s ease;
}
.rec-reason svg {
  flex-shrink: 0;
  margin-top: 1px;
  opacity: 0.5;
  transition: opacity 0.3s ease;
}
.rec-card:hover .rec-reason {
  color: var(--ink-light);
  border-top-color: rgba(159, 42, 31, 0.12);
}
.rec-card:hover .rec-reason svg {
  opacity: 0.8;
  color: var(--red);
}

.rec-empty {
  min-height: 160px;
}

/* ===== 右侧计数 ===== */
.right-count {
  width: 66px; height: 790px;
  background: linear-gradient(180deg, var(--red), var(--red-dark));
  border: 1px solid var(--gold);
  color: var(--gold-light);
  display: flex; align-items: center; flex-direction: column;
  padding: 24px 0;
  box-shadow: 0 18px 36px rgba(36, 25, 21, 0.2);
  animation: tagFloat 3.4s ease-in-out infinite alternate;
  transition: all 0.3s ease;
  cursor: pointer;
  box-sizing: border-box;
}
.right-count:hover { animation-play-state: paused; transform: scale(1.05); box-shadow: 0 20px 45px rgba(36, 25, 21, 0.26); }
.right-count div { writing-mode: vertical-rl; font-size: 20px; letter-spacing: 8px; font-weight: 700; color: var(--gold); }
.right-count strong { margin-top: 18px; font-size: 36px; font-family: Georgia, serif; color: var(--gold-light); animation: numPulse 2s ease-in-out infinite; }
@keyframes numPulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.1); } }
.right-count span { margin-top: 4px; font-size: 16px; color: var(--gold); }

.empty, .empty-panel {
  min-height: 240px; display: grid; place-items: center;
  color: var(--muted); border: 1px dashed var(--border);
  background: rgba(246, 239, 224, 0.62); font-size: 15px;
}

.toast {
  position: fixed; left: 50%; bottom: 42px; z-index: 99;
  transform: translateX(-50%);
  padding: 14px 28px; background: var(--red); color: var(--gold-light);
  box-shadow: 0 12px 30px var(--red-glow);
  animation: toastAni 2s ease forwards;
  font-weight: 600; border: 1px solid var(--gold);
}

.toast-action {
  background: var(--ink);
  border-color: var(--gold-dark);
}

.paint-enter-active { animation: paintIn 0.55s ease both; }
.paint-leave-active { animation: paintOut 0.22s ease both; }
.text-change-enter-active { animation: textIn 0.42s ease both; }
.text-change-leave-active { animation: textOut 0.18s ease both; }
.cards-change-enter-active { animation: cardsIn 0.42s ease both; }
.cards-change-leave-active { animation: textOut 0.18s ease both; }

@keyframes paintIn {
  0% { opacity: 0; clip-path: inset(0 100% 0 0); filter: blur(8px); transform: scale(1.05); }
  100% { opacity: 1; clip-path: inset(0 0 0 0); filter: blur(0); transform: scale(1); }
}
@keyframes paintOut {
  0% { opacity: 1; transform: scale(1); }
  100% { opacity: 0; transform: scale(0.95); }
}
@keyframes textIn {
  0% { opacity: 0; transform: translateY(20px); }
  100% { opacity: 1; transform: translateY(0); }
}
@keyframes textOut {
  0% { opacity: 1; }
  100% { opacity: 0; }
}
@keyframes cardsIn {
  0% { opacity: 0; transform: translateY(20px) scale(0.95); }
  100% { opacity: 1; transform: translateY(0) scale(1); }
}
@keyframes mountainMove {
  from { transform: translateX(-18px); }
  to { transform: translateX(18px); }
}
@keyframes tagFloat {
  from { transform: translateY(0); }
  to { transform: translateY(10px); }
}
@keyframes toastAni {
  0% { opacity: 0; transform: translate(-50%, 20px) scale(0.8); }
  15% { opacity: 1; transform: translate(-50%, 0) scale(1.05); }
  25% { transform: translate(-50%, 0) scale(1); }
  80% { opacity: 1; transform: translate(-50%, 0) scale(1); }
  100% { opacity: 0; transform: translate(-50%, -10px) scale(0.9); }
}

@media (max-width: 1450px) {
  .page-wrap { grid-template-columns: 200px 340px minmax(0, 1fr); padding-right: 28px; }
  .right-count { display: none; }
  .poem-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
  .rec-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
}
@media (max-width: 1120px) {
  .page-wrap { grid-template-columns: 1fr; padding: 30px 18px; }
  .side-banner { display: none; }
  .left-menu, .story-list-panel, .detail-panel {
    height: auto;
    max-height: none;
    min-height: auto;
  }
  .feature-area { grid-template-columns: 1fr; }
  .poem-grid { grid-template-columns: 1fr; }
  .rec-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
  .story-scroll { max-height: 500px; }
}
@media (max-width: 720px) {
  .detail-panel { padding: 24px 18px 46px; }
  .detail-top { flex-direction: column; }
  .detail-top h1 { font-size: 34px; letter-spacing: 4px; }
  .detail-actions { flex-wrap: wrap; }
  .feature-area { grid-template-columns: 1fr; }
  .feature-image { width: min(100%, 320px); max-width: 320px; justify-self: center; }
  .story-card { grid-template-columns: 82px minmax(0, 1fr); gap: 12px; }
  .story-cover { width: 82px; min-height: 104px; max-height: 124px; }
  .story-info p { font-size: 11px; }
  .rec-grid { grid-template-columns: 1fr; }
}
</style>
