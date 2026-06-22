<template>
  <div class="ink-bg">
    <Transition name="modal">
      <div v-if="showCreateModal" class="createModalOverlay" @click="closeCreateModal">
        <div class="createModalCard" @click.stop>
          <div class="createModalHeader">
            <div class="createModalTitle">
              <span class="titleDecor"></span>
              <span class="titleText">选体题诗</span>
              <span class="titleDecor"></span>
            </div>
            <button class="createCloseBtn" @click="closeCreateModal" title="关闭">
              <span class="closeIcon">✕</span>
            </button>
          </div>
          <div class="createModalBody">
            <button
              v-for="(type, index) in createTypes"
              :key="type.key"
              class="createTypeBtn"
              :style="{ animationDelay: `${index * 0.05}s` }"
              @click="selectCreateType(type)"
            >
              <div class="createTypeIcon">
                <span class="iconEmoji">{{ type.icon }}</span>
              </div>
              <div class="createTypeInfo">
                <div class="createTypeLabel">{{ type.label }}</div>
                <div class="createTypeDesc">{{ type.desc }}</div>
              </div>
              <div class="createTypeArrow">
                <span class="arrowIcon">❯</span>
              </div>
            </button>
          </div>
        </div>
      </div>
    </Transition>

    <!-- 顶部改成更接近参考视频的波纹百叶窗 -->
    <section
      ref="bannerRef"
      class="creation-banner shutter-banner"
      @mousemove="handleBannerMouseMove"
      @mouseenter="handleBannerMouseEnter"
      @mouseleave="handleBannerMouseLeave"
    >
      <div class="shutter-track">
        <button
          v-for="(img, idx) in bannerImages"
          :key="idx"
          class="shutter-slat"
          :class="{ active: idx === activeBannerIndex }"
          :style="getSlatStyle(idx, img)"
          type="button"
          @mouseenter="setActiveBanner(idx)"
          @focus="setActiveBanner(idx)"
          @click="setActiveBanner(idx)"
        >
          <div class="slat-image"></div>
          <div class="slat-edge slat-edge-left"></div>
          <div class="slat-edge slat-edge-right"></div>
          <div class="slat-gloss"></div>
          <div class="slat-shadow"></div>

          <div class="slat-meta">
            <div class="slat-index">{{ String(idx + 1).padStart(2, '0') }}</div>
            <div class="slat-title">墨韵长卷</div>
            <div class="slat-sub">创作灵感 · 图卷 {{ idx + 1 }}</div>
          </div>
        </button>
      </div>
      <div class="banner-mask"></div>
    </section>

    <div class="top-bar">
      <div class="top-bar-left">
        <div class="logo">墨韵集</div>
      </div>
      <div class="top-bar-right">
        <button class="action-btn" @click="handleRefresh">
          <span>刷新</span>
        </button>
        <button class="action-btn" @click="goMyWorks">
          <span>我的创作</span>
        </button>
        <button class="action-btn publish-btn" @click="goPublish">
          <span>立即创作</span>
        </button>
        <button class="action-btn" @click="goNotifications">
          <span>消息</span>
          <span v-if="unreadCount > 0" class="badge">{{ unreadCount }}</span>
        </button>
        <button class="action-btn forum-btn" @click="openForumSidebar">
          <span>诗词论坛</span>
          <span v-if="forumUnreadCount > 0" class="badge">{{ forumUnreadCount }}</span>
        </button>
      </div>
    </div>

    <div class="search-section">
      <div class="search-bar">
        <div class="search-pill">
          <input
            class="search-input"
            v-model="searchKeyword"
            placeholder="寻章摘句 · 搜索创作"
            @keyup.enter="handleSearchInput"
          />
          <button class="search-btn" @click="handleSearchInput">搜索</button>
        </div>
      </div>

      <div class="tabs-container">
        <button
          v-for="tab in tabs"
          :key="tab.key"
          class="tab-btn"
          :class="{ active: activeTab === tab.key }"
          @click="switchTab(tab.key)"
        >
          {{ tab.label }}
        </button>
      </div>
    </div>

    <div class="two-column-layout">
      <div class="left-content">
        <div class="creations-feed">
          <div v-if="isSearching" class="search-status">
            <span class="search-keyword">"{{ searchKeyword }}"</span>
            <span class="search-result">找到 {{ searchResultCount }} 条结果</span>
            <button class="clear-search" @click="handleClearSearch">✕ 清空</button>
          </div>

          <div v-if="isSearching && displayedItems.length === 0 && !loading" class="empty-state">
            <div class="empty-icon">🔍</div>
            <div class="empty-title">未找到相关作品</div>
            <div class="empty-hint">试试搜索其他关键词</div>
          </div>

          <div v-if="loading && items.length === 0" class="skeleton-list">
            <div v-for="i in 6" :key="i" class="skeleton-card">
              <div class="skeleton-row">
                <div class="skeleton-avatar"></div>
                <div class="skeleton-line w40"></div>
              </div>
              <div class="skeleton-line w85"></div>
              <div class="skeleton-line w70"></div>
              <div class="skeleton-grid">
                <div v-for="k in 4" :key="k" class="skeleton-img"></div>
              </div>
            </div>
          </div>

          <div class="creations-list">
            <article
              v-for="(item, index) in displayedItems"
              :key="item.id"
              class="creation-card"
              @click="goDetail(item.id)"
            >
              <div class="card-author-row">
                <div class="author-info" @click.stop="goAuthor(item.author?.id)">
                  <img class="author-avatar" :src="item.author?.avatar || fallbackAvatar" alt="" />
                  <span class="author-name">{{ item.author?.name || '佚名' }}</span>
                </div>
                <div class="card-time">{{ formatTime(item.createdAt) }}</div>
              </div>

              <div class="card-title">{{ item.title || '无题' }}</div>

              <div v-if="item.images && item.images.length > 0" class="card-images-grid">
                <div v-for="(img, imgIdx) in item.images.slice(0, 4)" :key="imgIdx" class="card-image-item">
                  <img
                    :src="img"
                    alt="作品图片"
                    loading="lazy"
                    @error="handleImageError($event)"
                    @load="handleImageLoad($event, img)"
                  />
                </div>
              </div>

              <div class="card-content">
                {{ item.excerpt || item.content || '暂无内容' }}
              </div>

              <div class="card-actions" @click.stop>
                <button class="action-item" :class="{ active: item.viewerLiked }" @click="toggleLike(item)">
                  <span>❤️</span>
                  <span>点赞 {{ item.likeCount || 0 }}</span>
                </button>
                <button class="action-item" :class="{ active: item.viewerSaved }" @click="toggleSave(item)">
                  <span>🔖</span>
                  <span>收藏 {{ item.saveCount || 0 }}</span>
                </button>
                <div class="action-item view-item">
                  <span>👁️</span>
                  <span>浏览 {{ item.viewCount || 0 }}</span>
                </div>
              </div>

              <div v-if="index < displayedItems.length - 1" class="card-divider"></div>
            </article>
          </div>

          <div class="load-more" ref="sentinelRef">
            <div v-if="loading && items.length > 0" class="loading-text">加载中...</div>
            <div v-else-if="!hasMore && items.length > 0" class="loading-text">已经到底了</div>
          </div>
        </div>
      </div>

      <div class="right-sidebar">
        <div class="sidebar-section">
          <h3 class="sidebar-title">48小时阅读排行</h3>
          <div class="ranking-list">
            <div v-for="(item, idx) in ranking48h" :key="idx" class="ranking-item" @click="goToArticle(item.url)">
              <span class="ranking-num" :class="{ 'top3': idx < 3 }">{{ idx + 1 }}</span>
              <span class="ranking-title">{{ item.title }}</span>
            </div>
          </div>
        </div>

        <div class="sidebar-section">
          <h3 class="sidebar-title">10天推荐排行</h3>
          <div class="ranking-list">
            <div v-for="(item, idx) in ranking10d" :key="idx" class="ranking-item" @click="goToArticle(item.url)">
              <span class="ranking-num" :class="{ 'top3': idx < 3 }">{{ idx + 1 }}</span>
              <span class="ranking-title">{{ item.title }}</span>
            </div>
          </div>
        </div>

        <div class="sidebar-section">
          <h3 class="sidebar-title">15天热门创作</h3>
          <div class="ranking-list">
            <div v-for="(item, idx) in hot15d" :key="idx" class="ranking-item" @click="goToArticle(item.url)">
              <span class="ranking-num" :class="{ 'top3': idx < 3 }">{{ idx + 1 }}</span>
              <span class="ranking-title">{{ item.title }}</span>
            </div>
          </div>
        </div>

        <div class="sidebar-section">
          <h3 class="sidebar-title">编辑推荐</h3>
          <div class="ranking-list">
            <div v-for="(item, idx) in editorPick" :key="idx" class="ranking-item" @click="goToArticle(item.url)">
              <span class="ranking-num" :class="{ 'top3': idx < 3 }">{{ idx + 1 }}</span>
              <span class="ranking-title">{{ item.title }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div
      class="chat-sidebar"
      :class="{ 'chat-sidebar-open': chatSidebarVisible }"
    >
      <div class="chat-sidebar-header">
        <div class="sidebar-title">
          <span class="title-icon">💬</span>
          <span>诗词论坛</span>
        </div>
        <button class="sidebar-close" @click="closeForumSidebar">✕</button>
      </div>
      <div class="chat-sidebar-content">
        <ForumChat />
      </div>
    </div>

    <div
      v-if="chatSidebarVisible"
      class="chat-sidebar-overlay"
      @click="closeForumSidebar"
    ></div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, nextTick } from 'vue';
import { useRouter } from 'vue-router';
import { isLoggedIn } from '@/utils/auth';
import { showWarning } from '@/utils/toast';
import ForumChat from '@/components/ForumChat.vue';
import { getRanking48h, getRanking10d, getHot15d, getEditorPick } from '@/utils/api';

const router = useRouter();
const bannerRef = ref(null);

const bannerImages = Array.from({ length: 14 }, (_, i) =>
  new URL(`../assets/chuangzuo/banner-${i + 1}.jpg`, import.meta.url).href
);

const activeBannerIndex = ref(4);
const hoverCenter = ref(4);
const isBannerHovering = ref(false);

function setActiveBanner(index) {
  activeBannerIndex.value = index;
  hoverCenter.value = index;
}

function handleBannerMouseEnter() {
  isBannerHovering.value = true;
}

function handleBannerMouseLeave() {
  isBannerHovering.value = false;
  hoverCenter.value = activeBannerIndex.value;
}

function handleBannerMouseMove(e) {
  const el = bannerRef.value;
  if (!el) return;

  const rect = el.getBoundingClientRect();
  const x = e.clientX - rect.left;
  const ratio = Math.min(1, Math.max(0, x / rect.width));
  const center = ratio * (bannerImages.length - 1);

  hoverCenter.value = center;
  activeBannerIndex.value = Math.round(center);
}

function getWeights(center) {
  const count = bannerImages.length;
  const weights = [];

  for (let i = 0; i < count; i += 1) {
    const distance = Math.abs(i - center);

    // 更接近参考视频：中心自然鼓起，两边连续收窄，但不会只剩一条线
    const base = 0.95;
    const peak = 5.8;
    const spread = 1.28;

    const weight = base + peak * Math.exp(-(distance * distance) / (2 * spread * spread));
    weights.push(weight);
  }

  return weights;
}

function getSlatStyle(index, img) {
  const center = hoverCenter.value;
  const weights = getWeights(center);
  const sum = weights.reduce((a, b) => a + b, 0);
  const width = (weights[index] / sum) * 100;

  const distance = Math.abs(index - center);
  const side = index < center ? -1 : 1;
  const isActive = index === activeBannerIndex.value;

  // 参考效果是“平直长卷”，不是上下起伏翻牌，所以这里只保留很轻的角度
  const rotateY = side * Math.min(16, distance * 3.2);
  const scale = isActive ? 1.015 : Math.max(0.97, 1 - distance * 0.01);
  const brightness = Math.max(0.62, 0.98 - distance * 0.06);
  const saturate = Math.max(0.76, 1 - distance * 0.04);
  const blur = Math.min(0.25, distance * 0.03);
  const z = 200 - Math.round(distance * 10);
  const origin = index < center ? 'right center' : 'left center';
  const photoScale = isActive ? 1.015 : Math.max(1.04, 1.1 - distance * 0.015);

  return {
    '--bg-url': `url(${img})`,
    '--photo-scale': String(photoScale),
    width: `${width}%`,
    transform: `rotateY(${rotateY}deg) scale(${scale})`,
    transformOrigin: origin,
    filter: `brightness(${brightness}) saturate(${saturate}) blur(${blur}px)`,
    zIndex: String(z)
  };
}

const chatSidebarVisible = ref(false);
const forumUnreadCount = ref(3);

function openForumSidebar() {
  chatSidebarVisible.value = true;
}

function closeForumSidebar() {
  chatSidebarVisible.value = false;
}

const ranking48h = ref([]);
const ranking10d = ref([]);
const hot15d = ref([]);
const editorPick = ref([]);

async function fetchSidebarData() {
  try {
    const [res48h, res10d, resHot, resEditor] = await Promise.all([
      getRanking48h(),
      getRanking10d(),
      getHot15d(),
      getEditorPick()
    ]);

    if (res48h.code === 0 || res48h.code === 200) {
      ranking48h.value = res48h.data || [];
    }
    if (res10d.code === 0 || res10d.code === 200) {
      ranking10d.value = res10d.data || [];
    }
    if (resHot.code === 0 || resHot.code === 200) {
      hot15d.value = resHot.data || [];
    }
    if (resEditor.code === 0 || resEditor.code === 200) {
      editorPick.value = resEditor.data || [];
    }
  } catch (e) {
    console.error('获取侧边栏数据失败:', e);
  }
}

const showCreateModal = ref(false);
const createTypes = [
  { key: 'poem', label: '诗词创作', icon: '📝', desc: '五言、七言、律诗、绝句' },
  { key: 'ci', label: '词牌填词', icon: '🎵', desc: '满江红、水调歌头等' },
  { key: 'fu', label: '赋体创作', icon: '📜', desc: '骈赋、文赋、律赋' },
  { key: 'couplet', label: '对联创作', icon: '🏮', desc: '春联、挽联、贺联' },
  { key: 'modern', label: '现代诗歌', icon: '✨', desc: '自由诗、散文诗' },
  { key: 'calligraphy', label: '书法创作', icon: '🖌️', desc: '楷书、行书、草书' },
];

function closeCreateModal() {
  showCreateModal.value = false;
}

function selectCreateType(type) {
  if (!isLoggedIn()) {
    showWarning('暂未登录，请登录后进行');
    setTimeout(() => {
      router.push('/login');
    }, 2000);
    return;
  }
  closeCreateModal();
  router.push(`/chuangzuo/publish?type=${type.key}`);
}

const tabs = [
  { key: 'recommend', label: '推荐' },
  { key: 'follow', label: '关注' },
  { key: 'poem', label: '诗词' },
  { key: 'ci', label: '词牌' },
  { key: 'fu', label: '赋体' },
  { key: 'couplet', label: '对联' },
  { key: 'modern', label: '现代诗' },
  { key: 'calligraphy', label: '书法' }
];

const activeTab = ref('recommend');
const items = ref([]);
const displayedItems = ref([]);
const loading = ref(false);
const hasMore = ref(true);
const searchKeyword = ref('');
const isSearching = ref(false);
const searchResultCount = ref(0);
const unreadCount = ref(8);

const page = ref(1);
const pageSize = 10;
const sentinelRef = ref(null);
let observer = null;

const fallbackAvatar = 'data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40"%3E%3Ccircle cx="20" cy="20" r="20" fill="%23e8e0d0"/%3E%3Ctext x="20" y="26" text-anchor="middle" fill="%23997b59" font-size="16"%3E墨%3C/text%3E%3C/svg%3E';

const fallbackImage = 'data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200"%3E%3Crect width="200" height="200" fill="%23f4efe4"/%3E%3Ctext x="100" y="100" text-anchor="middle" fill="%23997b59" font-size="16"%3E图片加载失败%3C/text%3E%3C/svg%3E';

function handleImageError(event) {
  console.error('图片加载失败:', event.target.src);
  event.target.src = fallbackImage;
  event.target.onerror = null;
}

function handleImageLoad(event, src) {
  console.log('图片加载成功:', src);
}

function formatTime(time) {
  if (!time) return '刚刚';
  const now = new Date();
  const createTime = new Date(time);
  const diff = Math.floor((now - createTime) / 1000 / 60);
  if (diff < 1) return '刚刚';
  if (diff < 60) return `${diff}分钟前`;
  if (diff < 1440) return `${Math.floor(diff / 60)}小时前`;
  return `${Math.floor(diff / 1440)}天前`;
}

async function apiFetch(url, options = {}) {
  const token = localStorage.getItem("token");
  const headers = {
    "Content-Type": "application/json",
    ...(options.headers || {})
  };
  if (token) {
    headers["Authorization"] = `Bearer ${token}`;
  }

  const res = await fetch(url, {
    headers: headers,
    credentials: "include",
    ...options,
  });
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  const data = await res.json().catch(() => ({}));
  return data;
}

function normalizeItem(raw) {
  let imgs = raw.imageUrls || raw.images || raw.imgs || [];

  if (typeof imgs === "string") {
    try {
      imgs = JSON.parse(imgs);
    } catch {
      imgs = imgs.split(",").map((s) => s.trim()).filter(Boolean);
    }
  }

  if (!Array.isArray(imgs)) imgs = [];
  else imgs = imgs.slice(0, 4);

  return {
    id: raw.id ?? raw.workId ?? raw.creationId,
    title: raw.title ?? raw.workTitle ?? "",
    excerpt: raw.excerpt ?? raw.content ?? raw.summary ?? "",
    content: raw.content ?? raw.excerpt ?? "",
    createdAt: raw.createdAt ?? raw.createTime ?? raw.time ?? "",
    images: imgs,
    author: {
      id: raw.authorId ?? raw.userId ?? raw.author?.id,
      name: raw.authorName ?? raw.nickname ?? raw.author?.name ?? "佚名",
      avatar: raw.authorAvatar ?? raw.avatar ?? raw.author?.avatar ?? "",
    },
    likeCount: raw.likeCount ?? raw.likes ?? 0,
    saveCount: raw.saveCount ?? raw.saves ?? 0,
    viewerLiked: !!(raw.viewerLiked ?? raw.liked),
    viewerSaved: !!(raw.viewerSaved ?? raw.saved),
    viewCount: raw.viewCount ?? raw.views ?? raw.browseCount ?? 0,
  };
}

async function fetchList({ reset = false } = {}) {
  if (loading.value) return;
  loading.value = true;

  try {
    const curPage = reset ? 1 : page.value;
    const isTypeFilter = ['poem', 'ci', 'fu', 'couplet', 'modern', 'calligraphy'].includes(activeTab.value);
    const url = isTypeFilter
      ? `/api/creations?type=${activeTab.value}&page=${curPage}&pageSize=${pageSize}`
      : `/api/creations?tab=${activeTab.value}&page=${curPage}&pageSize=${pageSize}`;

    const data = await apiFetch(url);
    const list = data?.data?.list ?? data?.list ?? data?.rows ?? [];
    let mapped = list.map(normalizeItem);

    if (activeTab.value === 'recommend') {
      mapped = mapped.sort((a, b) => {
        const scoreA = (a.likeCount || 0) + (a.saveCount || 0) * 1.5;
        const scoreB = (b.likeCount || 0) + (b.saveCount || 0) * 1.5;
        return scoreB - scoreA;
      });
    }

    if (reset) items.value = mapped;
    else items.value = items.value.concat(mapped);

    if (!isSearching.value) {
      displayedItems.value = items.value;
    }

    hasMore.value = mapped.length >= pageSize;
    page.value = curPage + 1;
  } catch (e) {
    console.error("fetchList failed:", e);
    if (reset) items.value = [];
    hasMore.value = false;
  } finally {
    loading.value = false;
  }
}

async function switchTab(key) {
  activeTab.value = key;
  page.value = 1;
  hasMore.value = true;
  await fetchList({ reset: true });
}

function handleSearchInput() {
  const kw = searchKeyword.value.trim();
  if (!kw) {
    handleClearSearch();
    return;
  }

  isSearching.value = true;
  const results = items.value.filter(item =>
    item.title?.toLowerCase().includes(kw.toLowerCase()) ||
    item.excerpt?.toLowerCase().includes(kw.toLowerCase()) ||
    item.author?.name?.toLowerCase().includes(kw.toLowerCase())
  );
  displayedItems.value = results;
  searchResultCount.value = results.length;
}

function handleClearSearch() {
  searchKeyword.value = '';
  isSearching.value = false;
  displayedItems.value = items.value;
}

async function handleRefresh() {
  page.value = 1;
  hasMore.value = true;
  await fetchList({ reset: true });
}

async function toggleLike(item) {
  const old = item.viewerLiked;
  item.viewerLiked = !old;
  item.likeCount = Math.max(0, (item.likeCount || 0) + (item.viewerLiked ? 1 : -1));
  try {
    await apiFetch(`/api/creations/${item.id}/like`, {
      method: "POST",
      body: JSON.stringify({ like: item.viewerLiked }),
    });
  } catch (e) {
    item.viewerLiked = old;
    item.likeCount = Math.max(0, (item.likeCount || 0) + (old ? 1 : -1));
  }
}

async function toggleSave(item) {
  const old = item.viewerSaved;
  item.viewerSaved = !old;
  item.saveCount = Math.max(0, (item.saveCount || 0) + (item.viewerSaved ? 1 : -1));
  try {
    await apiFetch(`/api/creations/${item.id}/save`, {
      method: "POST",
      body: JSON.stringify({ save: item.viewerSaved }),
    });
  } catch (e) {
    item.viewerSaved = old;
    item.saveCount = Math.max(0, (item.saveCount || 0) + (old ? 1 : -1));
  }
}

function goDetail(id) {
  router.push(`/chuangzuo/${id}`);
}

function goToArticle(url) {
  if (url) {
    router.push(url);
  }
}

function goAuthor(authorId) {
  if (!authorId) return;
  router.push(`/author/${authorId}`);
}

function goMyWorks() {
  if (!isLoggedIn()) {
    showWarning('请先登录后查看我的作品');
    setTimeout(() => {
      router.push('/login');
    }, 2000);
    return;
  }
  router.push("/chuangzuo/my");
}

function goPublish() {
  if (!isLoggedIn()) {
    showWarning('暂未登录，请登录后进行');
    setTimeout(() => {
      router.push('/login');
    }, 2000);
    return;
  }
  showCreateModal.value = true;
}

function goNotifications() {
  if (!isLoggedIn()) {
    showWarning('请先登录后查看消息通知');
    setTimeout(() => {
      router.push('/login');
    }, 2000);
    return;
  }
  router.push("/chuangzuo/notifications");
}

function setupObserver() {
  if (observer) observer.disconnect();
  const sentinel = sentinelRef.value;
  if (!sentinel) return;

  observer = new IntersectionObserver(
    (entries) => {
      if (entries[0].isIntersecting && hasMore.value && !loading.value && !isSearching.value) {
        fetchList({ reset: false });
      }
    },
    { threshold: 0.1, rootMargin: '100px' }
  );
  observer.observe(sentinel);
}

onMounted(async () => {
  await fetchList({ reset: true });
  await nextTick();
  await fetchSidebarData();
  setupObserver();

  try {
    const res = await fetch('/api/notifications/unread-count', { credentials: 'include' });
    const data = await res.json();
    if (data.code === 0) {
      unreadCount.value = data.data || 0;
    }
  } catch (e) {
    console.error('获取未读数失败：', e);
  }
});

onBeforeUnmount(() => {
  if (observer) observer.disconnect();
});
</script>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.ink-bg {
  --paper-bg: #f3efe6;
  --paper-card: #f8f4eb;
  --paper-card-strong: #f4efe4;
  --ink: #2b2823;
  --sub-ink: #6f675d;
  --line: rgba(72, 60, 46, 0.14);
  --line-strong: rgba(72, 60, 46, 0.22);
  --accent: #8a2f2b;
  --gold: #9b7b47;

  min-height: 100vh;
  background: var(--paper-bg);
  font-family: "Microsoft YaHei", "PingFang SC", "Helvetica Neue", Arial, sans-serif;
  color: var(--ink);
}

/* 顶部波纹百叶窗 */
.creation-banner.shutter-banner {
  position: relative;
  width: 100%;
  height: clamp(300px, 25vw, 460px);
  overflow: hidden;
  background:
    radial-gradient(circle at 50% 20%, rgba(255,255,255,0.18), transparent 42%),
    linear-gradient(180deg, #d8c9ad 0%, #cbb590 100%);
  border-bottom: 1px solid var(--line);
  perspective: 1800px;
}

.shutter-track {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: stretch;
  justify-content: flex-start;
  transform-style: preserve-3d;
}

.shutter-slat {
  position: relative;
  height: 100%;
  flex: 0 0 auto;
  border: none;
  padding: 0;
  background: transparent;
  cursor: pointer;
  overflow: hidden;
  transition:
    width 0.42s cubic-bezier(0.22, 1, 0.36, 1),
    transform 0.42s cubic-bezier(0.22, 1, 0.36, 1),
    filter 0.28s ease;
  box-shadow:
    inset 1px 0 rgba(255,255,255,0.16),
    inset -1px 0 rgba(36, 25, 12, 0.18);
  will-change: width, transform, filter;
}

.slat-image,
.slat-edge,
.slat-gloss,
.slat-shadow,
.slat-meta {
  position: absolute;
}

.slat-image {
  inset: 0;
  background-image: var(--bg-url);
  background-size: cover;
  background-position: center center;
  transform: scale(var(--photo-scale, 1.06));
  transition: transform 0.36s ease;
}

.slat-edge {
  top: 0;
  bottom: 0;
  width: 10px;
  pointer-events: none;
}

.slat-edge-left {
  left: 0;
  background: linear-gradient(90deg, rgba(255,255,255,0.22), rgba(255,255,255,0.02));
}

.slat-edge-right {
  right: 0;
  background: linear-gradient(270deg, rgba(0,0,0,0.20), rgba(0,0,0,0.02));
}

.slat-gloss {
  inset: 0;
  background:
    linear-gradient(90deg, rgba(255,255,255,0.14), rgba(255,255,255,0.00) 26%, rgba(255,255,255,0.00) 72%, rgba(255,255,255,0.08)),
    linear-gradient(180deg, rgba(255,255,255,0.08), rgba(255,255,255,0.00) 40%, rgba(0,0,0,0.08));
  pointer-events: none;
}

.slat-shadow {
  inset: 0;
  background:
    linear-gradient(180deg, rgba(0,0,0,0.06), rgba(0,0,0,0.18)),
    repeating-linear-gradient(
      90deg,
      rgba(255,255,255,0.06) 0px,
      rgba(255,255,255,0.06) 1px,
      rgba(255,255,255,0.00) 1px,
      rgba(255,255,255,0.00) 12px,
      rgba(0,0,0,0.04) 13px
    );
  mix-blend-mode: soft-light;
  pointer-events: none;
}

.slat-meta {
  left: 16px;
  right: 12px;
  bottom: 16px;
  color: #f5efe5;
  text-align: left;
  text-shadow: 0 2px 10px rgba(0,0,0,0.36);
  opacity: 0;
  transform: translateY(14px);
  transition: opacity 0.28s ease, transform 0.35s ease;
  pointer-events: none;
  z-index: 3;
}

.shutter-slat.active .slat-meta {
  opacity: 1;
  transform: translateY(0);
}

.slat-index {
  font-size: 12px;
  letter-spacing: 0.22em;
  margin-bottom: 8px;
  opacity: 0.9;
}

.slat-title {
  font-size: clamp(18px, 1.4vw, 26px);
  font-weight: 700;
  letter-spacing: 0.08em;
  margin-bottom: 6px;
}

.slat-sub {
  font-size: 13px;
  opacity: 0.92;
}

.banner-mask {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 72px;
  background: linear-gradient(180deg, rgba(243,239,230,0), rgba(243,239,230,0.28));
  pointer-events: none;
}

.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 40px;
  background: var(--paper-card);
  border-bottom: 1px solid var(--line);
  position: sticky;
  top: 0;
  z-index: 100;
}

.logo {
  font-size: 22px;
  font-weight: bold;
  background: linear-gradient(135deg, var(--gold), #c2a06a);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.top-bar-right {
  display: flex;
  gap: 10px;
  align-items: center;
  flex-wrap: wrap;
}

.action-btn {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 6px 8px;
  background: transparent;
  border: none;
  font-size: 14px;
  font-weight: 500;
  color: var(--ink);
  cursor: pointer;
  transition: all 0.2s;
  position: relative;
}

.action-btn:hover {
  color: var(--accent);
  background: transparent;
}

.action-btn:hover::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  right: 0;
  height: 2px;
  background: var(--accent);
  border-radius: 2px;
}

.publish-btn {
  background: linear-gradient(135deg, var(--gold), #b99257);
  border: none;
  color: #fff;
  padding: 6px 14px;
  border-radius: 20px;
}

.publish-btn:hover {
  background: linear-gradient(135deg, #b28b55, var(--gold));
  color: #fff;
}

.publish-btn:hover::after {
  display: none;
}

.forum-btn {
  background: linear-gradient(135deg, #9f2f25, #c44a3f);
  border: none;
  color: #fff;
  padding: 6px 14px;
  border-radius: 20px;
}

.forum-btn:hover {
  background: linear-gradient(135deg, #c44a3f, #9f2f25);
  color: #fff;
}

.forum-btn:hover::after {
  display: none;
}

.badge {
  position: absolute;
  top: -5px;
  right: -5px;
  background: #c64646;
  color: white;
  font-size: 9px;
  font-weight: bold;
  padding: 2px 5px;
  border-radius: 10px;
  min-width: 16px;
  text-align: center;
}

.search-section {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px 40px;
}

.search-bar {
  display: flex;
  margin-bottom: 16px;
  position: relative;
}

.search-pill {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 8px;
  background: var(--paper-card);
  border: 1px solid var(--line);
  border-radius: 48px;
  padding: 10px 16px;
  transition: all 0.2s;
  padding-right: 80px;
}

.search-pill:focus-within {
  border-color: var(--gold);
  box-shadow: 0 0 0 2px rgba(155, 123, 71, 0.16);
}

.search-input {
  flex: 1;
  border: none;
  background: transparent;
  outline: none;
  font-size: 14px;
  font-family: inherit;
  color: var(--ink);
}

.search-input::placeholder {
  color: #9a8f82;
}

.search-btn {
  position: absolute;
  right: 6px;
  top: 50%;
  transform: translateY(-50%);
  padding: 6px 20px;
  background: linear-gradient(135deg, var(--gold), #b99257);
  border: none;
  border-radius: 40px;
  color: #fff;
  font-weight: 600;
  cursor: pointer;
  font-size: 13px;
  transition: all 0.2s;
  white-space: nowrap;
}

.search-btn:hover {
  background: linear-gradient(135deg, #b28b55, var(--gold));
}

.tabs-container {
  display: flex;
  gap: 24px;
  overflow-x: auto;
  padding-bottom: 8px;
  border-bottom: 1px solid var(--line);
}

.tabs-container::-webkit-scrollbar {
  display: none;
}

.tab-btn {
  flex-shrink: 0;
  padding: 8px 0;
  background: transparent;
  border: none;
  font-size: 15px;
  font-weight: 500;
  color: var(--sub-ink);
  cursor: pointer;
  transition: all 0.2s;
  position: relative;
}

.tab-btn:hover {
  color: var(--accent);
}

.tab-btn.active {
  color: var(--accent);
}

.tab-btn.active::after {
  content: '';
  position: absolute;
  bottom: -9px;
  left: 0;
  right: 0;
  height: 2px;
  background: var(--accent);
  border-radius: 2px;
}

.two-column-layout {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 40px 60px;
  display: flex;
  gap: 60px;
  align-items: flex-start;
}

.left-content {
  flex: 1;
  min-width: 0;
}

.right-sidebar {
  width: 280px;
  flex-shrink: 0;
  position: sticky;
  top: 80px;
  align-self: flex-start;
  max-height: calc(100vh - 100px);
  overflow-y: auto;
}

.right-sidebar::-webkit-scrollbar {
  width: 4px;
}

.sidebar-section {
  margin-bottom: 32px;
}

.sidebar-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--ink);
  margin-bottom: 16px;
  padding-bottom: 8px;
  border-bottom: 2px solid var(--line);
  letter-spacing: 1px;
}

.ranking-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.ranking-item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  font-size: 13px;
  line-height: 1.5;
  cursor: pointer;
  transition: color 0.2s;
}

.ranking-item:hover {
  color: var(--accent);
}

.ranking-num {
  flex-shrink: 0;
  width: 22px;
  color: #8f8273;
  font-size: 13px;
  font-weight: 500;
}

.ranking-num.top3 {
  color: var(--accent);
  font-weight: 700;
}

.ranking-title {
  color: var(--sub-ink);
  transition: color 0.2s;
}

.ranking-item:hover .ranking-title {
  color: var(--accent);
}

.creations-list {
  display: flex;
  flex-direction: column;
}

.creation-card {
  background: transparent;
  padding: 20px 0;
  cursor: pointer;
  transition: background 0.2s;
}

.creation-card:hover {
  background: rgba(255, 255, 255, 0.35);
}

.card-author-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.author-info {
  display: flex;
  align-items: center;
  gap: 8px;
}

.author-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  object-fit: cover;
  background: #e8e0d0;
}

.author-name {
  font-size: 14px;
  font-weight: 500;
  color: var(--sub-ink);
}

.card-time {
  font-size: 12px;
  color: #8a7f73;
}

.card-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--ink);
  margin-bottom: 12px;
}

.card-images-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px;
  margin: 12px 0;
}

.card-image-item {
  aspect-ratio: 1;
  border-radius: 8px;
  overflow: hidden;
  background: var(--paper-card);
}

.card-image-item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.card-content {
  font-size: 14px;
  line-height: 1.6;
  color: var(--sub-ink);
  margin: 12px 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-actions {
  display: flex;
  gap: 24px;
  margin-bottom: 8px;
}

.action-item {
  display: flex;
  align-items: center;
  gap: 5px;
  background: transparent;
  border: none;
  font-size: 13px;
  color: #8e7f6b;
  cursor: pointer;
  padding: 4px 8px;
  transition: all 0.2s;
  border-radius: 20px;
}

.action-item:hover {
  background: rgba(155, 123, 71, 0.08);
}

.action-item.active {
  color: var(--accent);
}

.view-item {
  cursor: default;
}

.view-item:hover {
  background: transparent;
}

.card-divider {
  height: 1px;
  background: var(--line);
  margin: 0;
}

.search-status {
  background: var(--paper-card-strong);
  padding: 10px 14px;
  margin-bottom: 16px;
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.search-keyword {
  font-weight: 600;
  color: var(--accent);
}

.search-result {
  color: var(--sub-ink);
  font-size: 13px;
}

.clear-search {
  margin-left: auto;
  background: transparent;
  border: none;
  color: #c64646;
  cursor: pointer;
  font-size: 12px;
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #8a7f73;
}

.empty-icon {
  font-size: 56px;
  margin-bottom: 12px;
}

.empty-title {
  font-size: 16px;
  margin-bottom: 6px;
}

.empty-hint {
  font-size: 12px;
}

.load-more {
  text-align: center;
  padding: 28px;
}

.loading-text {
  color: #8a7f73;
  font-size: 12px;
}

.skeleton-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.skeleton-card {
  background: transparent;
  padding: 20px 0;
}

.skeleton-row {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
}

.skeleton-avatar {
  width: 32px;
  height: 32px;
  background: #e2dacd;
  border-radius: 50%;
}

.skeleton-line {
  height: 12px;
  background: #e2dacd;
  border-radius: 6px;
}

.skeleton-line.w40 { width: 40%; }
.skeleton-line.w70 { width: 70%; }
.skeleton-line.w85 { width: 85%; }

.skeleton-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px;
  margin-top: 10px;
}

.skeleton-img {
  aspect-ratio: 1;
  background: #e2dacd;
  border-radius: 8px;
}

.chat-sidebar {
  position: fixed;
  top: 0;
  right: -630px;
  width: 630px;
  height: 100vh;
  background: var(--paper-card);
  z-index: 1000;
  transition: right 0.3s ease;
  display: flex;
  flex-direction: column;
  box-shadow: -4px 0 20px rgba(0, 0, 0, 0.1);
  border-radius: 0;
}

.chat-sidebar-open {
  right: 0;
}

.chat-sidebar-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 16px;
  background: var(--paper-card);
  border-bottom: 1px solid var(--line);
  flex-shrink: 0;
}

.chat-sidebar-header .sidebar-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  font-weight: 600;
  color: var(--accent);
  margin: 0;
  padding: 0;
  border: none;
}

.title-icon {
  font-size: 16px;
}

.sidebar-close {
  width: 24px;
  height: 24px;
  border: none;
  background: rgba(138, 47, 43, 0.08);
  cursor: pointer;
  font-size: 14px;
  color: var(--accent);
  transition: all 0.2s ease;
  border-radius: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.sidebar-close:hover {
  color: var(--accent);
  background: rgba(138, 47, 43, 0.14);
}

.chat-sidebar-content {
  flex: 1;
  overflow: hidden;
  padding: 0;
}

.chat-sidebar-content > * {
  height: 100%;
  width: 100%;
}

.chat-sidebar-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100vh;
  background: rgba(0, 0, 0, 0.4);
  z-index: 999;
  backdrop-filter: blur(2px);
}

.createModalOverlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(4px);
  z-index: 1000;
  display: flex;
  align-items: center;
  justify-content: center;
}

.createModalCard {
  width: 500px;
  max-width: 90%;
  max-height: 80vh;
  background: var(--paper-card);
  border-radius: 24px;
  overflow: hidden;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
}

.createModalHeader {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid var(--line);
}

.createModalTitle {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 20px;
  font-weight: bold;
  color: var(--ink);
}

.createCloseBtn {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: none;
  background: var(--paper-card-strong);
  cursor: pointer;
  color: var(--ink);
}

.createModalBody {
  padding: 16px;
  max-height: 60vh;
  overflow-y: auto;
}

.createTypeBtn {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px;
  margin-bottom: 12px;
  border: 1px solid var(--line);
  border-radius: 16px;
  background: var(--paper-card);
  cursor: pointer;
  transition: all 0.2s;
}

.createTypeBtn:hover {
  border-color: var(--line-strong);
  box-shadow: 0 2px 8px rgba(72, 60, 46, 0.08);
}

.createTypeIcon {
  width: 48px;
  height: 48px;
  background: var(--paper-card-strong);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.iconEmoji {
  font-size: 24px;
}

.createTypeInfo {
  flex: 1;
  text-align: left;
}

.createTypeLabel {
  font-weight: bold;
  color: var(--ink);
  margin-bottom: 4px;
}

.createTypeDesc {
  font-size: 12px;
  color: #8a7f73;
}

.createTypeArrow .arrowIcon {
  font-size: 18px;
  color: #9a8f82;
}

.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

@media (max-width: 900px) {
  .two-column-layout {
    flex-direction: column;
    gap: 40px;
  }

  .right-sidebar {
    width: 100%;
    position: static;
    max-height: none;
    overflow-y: visible;
  }

  .sidebar-section {
    margin-bottom: 24px;
  }

  .ranking-list {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 12px 20px;
  }
}

@media (max-width: 768px) {
  .top-bar {
    padding: 10px 16px;
    flex-wrap: wrap;
  }

  .top-bar-right {
    flex-wrap: wrap;
    gap: 6px;
  }

  .action-btn {
    padding: 5px 10px;
    font-size: 12px;
  }

  .search-section {
    padding: 16px;
  }

  .two-column-layout {
    padding: 0 16px 40px;
  }

  .card-title {
    font-size: 16px;
  }

  .tabs-container {
    gap: 5px;
  }

  .tab-btn {
    padding: 5px 12px;
    font-size: 12px;
  }

  .creation-banner.shutter-banner {
    height: 240px;
  }

  .shutter-track {
    overflow-x: auto;
    overflow-y: hidden;
    perspective: none;
  }

  .shutter-slat {
    width: 42vw !important;
    min-width: 42vw;
    transform: none !important;
    filter: none !important;
  }

  .slat-meta {
    opacity: 1;
    transform: none;
  }

  .ranking-list {
    grid-template-columns: 1fr;
  }

  .chat-sidebar {
    width: 100%;
    right: -100%;
  }
}
</style>