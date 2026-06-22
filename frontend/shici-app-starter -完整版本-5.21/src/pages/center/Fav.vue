<template>
  <div class="favPage">
    <!-- 左侧导航栏 -->
    <aside class="sidebar">
      <button class="backBtn" @click="router.back()">返回</button>
      <nav class="sidebarNav">
        <button
          v-for="tab in tabs"
          :key="tab.key"
          class="navItem"
          :class="{ active: activeTab === tab.key }"
          @click="switchTab(tab.key)"
        >
          <span class="navIcon">{{ tab.icon }}</span>
          <span class="navLabel">{{ tab.label }}</span>
        </button>
      </nav>
    </aside>

    <!-- 右侧内容区 -->
    <main class="mainContent">
      <header class="contentHead">
        <h1 class="contentTitle">{{ currentTabLabel }}</h1>
        <button class="refreshBtn" :disabled="loading" @click="reload">
          {{ loading ? "加载中..." : "刷新" }}
        </button>
      </header>

      <div class="contentBody">
        <div v-if="!loading && list.length === 0" class="empty">
          <div class="emptyIcon">💾</div>
          <div class="emptyTitle">暂无收藏</div>
          <div class="emptyDesc">收藏的作品会在这里显示</div>
        </div>

        <div v-else-if="list.length > 0" class="grid">
          <article
            v-for="item in list"
            :key="item.id"
            class="card"
            @click="goToDetail(item)"
          >
            <div v-if="item.coverImage" class="cardCover">
              <img :src="item.coverImage" alt="" />
              <span class="cardType">{{ getTypeLabel(item.type) }}</span>
            </div>
            <div class="cardBody">
              <h3 class="cardTitle">{{ item.title || "无标题" }}</h3>
              <p class="cardExcerpt">{{ item.excerpt || item.content }}</p>
              <div class="cardMeta">
                <span v-if="item.authorName">作者：{{ item.authorName }}</span>
                <span>收藏于：{{ formatDate(item.createdAt) }}</span>
              </div>
            </div>
          </article>
        </div>

        <div v-if="hasMore" class="moreBtn">
          <button class="btn" :disabled="loadingMore" @click="loadMore">
            {{ loadingMore ? "加载中..." : "加载更多" }}
          </button>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import { useRouter } from "vue-router";
import {
  getReciteMyFavorites,
  getReciteMyFavoriteAudios,
  getReciteMyFavoriteVideos,
  getPoemFavorites
} from "@/utils/api";

const router = useRouter();
const token = computed(() => localStorage.getItem("token") || "");

const tabs = [
  { key: "creation", label: "创作收藏", icon: "📝" },
  { key: "recite", label: "朗诵收藏", icon: "🎤" },
  { key: "library", label: "书库收藏", icon: "📚" },
];

const activeTab = ref("creation");
const list = ref([]);
const loading = ref(false);
const loadingMore = ref(false);
const page = ref(1);
const size = 12;
const hasMore = ref(true);

const currentTabLabel = computed(() => {
  const tab = tabs.find(t => t.key === activeTab.value);
  return tab ? tab.label : "收藏";
});

const typeLabels = {
  poem: "诗词",
  ci: "词牌",
  fu: "赋体",
  couplet: "对联",
  modern: "现代诗",
  calligraphy: "书法",
  playlist: "诗单",
  audio: "音频",
  video: "视频",
};

function getTypeLabel(type) {
  return typeLabels[type] || "作品";
}

function formatDate(v) {
  if (!v) return "-";
  const d = new Date(v);
  const pad = (n) => String(n).padStart(2, "0");
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
}

function switchTab(key) {
  activeTab.value = key;
  page.value = 1;
  list.value = [];
  hasMore.value = true;
  fetchList();
}

async function fetchList() {
  loading.value = true;
  try {
    let items = [];

    if (activeTab.value === "creation") {
      // 创作收藏：保持原有逻辑
      const resp = await fetch(`/api/user/fav?tab=creation&page=${page.value}&size=${size}`, {
        headers: {
          "Authorization": `Bearer ${token.value}`,
        },
      });
      const json = await resp.json().catch(() => null);
      if (!resp.ok || !json || json.code !== 0) {
        throw new Error((json && json.msg) || "加载失败");
      }
      items = (json.data && (json.data.list || json.data)) || [];
    } else if (activeTab.value === "recite") {
      // 朗诵收藏：合并诗单、音频、视频
      const [playlistsRes, audiosRes, videosRes] = await Promise.all([
        getReciteMyFavorites(),
        getReciteMyFavoriteAudios(),
        getReciteMyFavoriteVideos(),
      ]);

      const playlists = playlistsRes?.data || [];
      const audios = audiosRes?.data || [];
      const videos = videosRes?.data || [];

      // 转换为统一格式
      items = [
        ...playlists.map(p => ({
          id: p.id,
          targetId: p.id,
          type: "playlist",
          title: p.name,
          excerpt: p.description,
          coverImage: p.cover,
          createdAt: p.createdAt || new Date().toISOString()
        })),
        ...audios.map(a => ({
          id: a.id,
          targetId: a.id,
          type: "audio",
          title: a.title,
          excerpt: a.subtitle,
          coverImage: a.cover,
          createdAt: a.createdAt || new Date().toISOString()
        })),
        ...videos.map(v => ({
          id: v.id,
          targetId: v.id,
          type: "video",
          title: v.title,
          excerpt: v.description,
          coverImage: v.thumbnail,
          authorName: v.author,
          createdAt: v.createdAt || new Date().toISOString()
        }))
      ];
    } else if (activeTab.value === "library") {
      // 书库收藏：使用专门的书库收藏API
      const resp = await getPoemFavorites(page.value, size);

      const payload = resp?.data || resp;
      const total = payload?.total || 0;
      const rows = payload?.items || payload?.rows || payload?.list || payload?.records || [];

      items = rows.map(p => ({
        id: p.id,
        targetId: p.id,
        type: "poem",
        title: p.title,
        excerpt: p.content ? p.content.substring(0, 100) + "..." : p.translation || "",
        coverImage: p.cover_url || p.coverUrl || p.cover || "",
        authorName: p.author || "",
        createdAt: p.createdAt || new Date().toISOString()
      }));

      hasMore.value = (page.value * size) < total;
    }

    list.value = items.map(item => ({
      ...item,
      excerpt: item.excerpt || (item.content ? item.content.substring(0, 100) + "..." : ""),
    }));

    hasMore.value = items.length >= size;
  } catch (e) {
    console.error(e);
    alert(e.message || "加载失败");
  } finally {
    loading.value = false;
  }
}

async function reload() {
  page.value = 1;
  await fetchList();
}

async function loadMore() {
  if (!hasMore.value || loadingMore.value) return;
  loadingMore.value = true;
  page.value += 1;
  try {
    let items = [];

    if (activeTab.value === "creation") {
      const resp = await fetch(`/api/user/fav?tab=${activeTab.value}&page=${page.value}&size=${size}`, {
        headers: {
          "Authorization": `Bearer ${token.value}`,
        },
      });
      const json = await resp.json().catch(() => null);
      if (!resp.ok || !json || json.code !== 0) {
        throw new Error((json && json.msg) || "加载失败");
      }
      items = (json.data && (json.data.list || json.data)) || [];
    } else if (activeTab.value === "recite") {
      // 朗诵收藏暂不支持分页加载更多
      items = [];
    } else if (activeTab.value === "library") {
      // 书库收藏：使用分页API加载更多
      const resp = await getPoemFavorites(page.value, size);

      const payload = resp?.data || resp;
      const total = payload?.total || 0;
      const rows = payload?.items || payload?.rows || payload?.list || payload?.records || [];

      items = rows.map(p => ({
        id: p.id,
        targetId: p.id,
        type: "poem",
        title: p.title,
        excerpt: p.content ? p.content.substring(0, 100) + "..." : p.translation || "",
        coverImage: p.cover_url || p.coverUrl || p.cover || "",
        authorName: p.author || "",
        createdAt: p.createdAt || new Date().toISOString()
      }));

      hasMore.value = (page.value * size) < total;
    }

    list.value = list.value.concat(items.map(item => ({
      ...item,
      excerpt: item.excerpt || (item.content ? item.content.substring(0, 100) + "..." : ""),
    })));

    hasMore.value = items.length >= size;
  } catch (e) {
    page.value -= 1;
    console.error(e);
  } finally {
    loadingMore.value = false;
  }
}

function goToDetail(item) {
  console.log('点击收藏卡片:', item);

  if (activeTab.value === "creation" && item.targetId) {
    // 创作收藏：跳转到创作详情页
    router.push(`/chuangzuo/${item.targetId}`);

  } else if (activeTab.value === "library" && item.targetId) {
    // 书库收藏：跳转到书库页面，通过id参数打开详情
    router.push({
      path: '/library',
      query: { id: item.targetId }
    });

  } else if (activeTab.value === "recite") {
    // 朗诵收藏：跳转到朗诵页面，通过参数自动打开/播放
    if (item.type === "playlist") {
      router.push({
        path: '/recite',
        query: { playlist: item.targetId || item.id }
      });
    } else if (item.type === "audio") {
      router.push({
        path: '/recite',
        query: { audio: item.targetId || item.id }
      });
    } else if (item.type === "video") {
      router.push({
        path: '/recite',
        query: { video: item.targetId || item.id }
      });
    } else {
      alert(`跳转到朗诵：${item.title}`);
    }

  } else {
    alert("跳转功能开发中");
  }
}

onMounted(() => {
  if (!token.value) {
    router.replace("/login");
    return;
  }
  fetchList();
});
</script>

<style scoped>
.favPage {
  display: flex;
  min-height: 100vh;
  background:
    radial-gradient(1200px 800px at 20% 10%, rgba(180, 200, 220, 0.08), transparent 60%),
    radial-gradient(900px 600px at 80% 20%, rgba(230, 220, 190, 0.12), transparent 55%),
    linear-gradient(135deg, #fdfbf7, #f5f3ef);
  position: relative
}

.favPage::before {
  content: "";
  position: fixed;
  inset: 0;
  background: url("@/assets/chuangzuo/竹.png");
  background-size: 25%;
  opacity: 0.06;
  pointer-events: none;
  z-index: -3
}

/* 左侧导航栏 */
.sidebar {
  width: 240px;
  background: linear-gradient(180deg, rgba(253,249,242,0.95), rgba(246,240,230,0.9));
  border-right: 1px solid rgba(212,175,55,0.15);
  padding: 24px 0;
  flex-shrink: 0;
  box-shadow: 4px 0 12px rgba(212,175,55,0.08);
  position: relative;
  z-index: 10
}

.sidebar::before {
  content: "";
  position: absolute;
  top: 0;
  right: 0;
  width: 2px;
  height: 100%;
  background: linear-gradient(180deg, #d4af37, #b8860b);
  opacity: 0.3
}

.backBtn {
  margin: 0 20px 16px;
  padding: 10px 18px;
  border-radius: 12px;
  border: 1px solid rgba(212,175,55,0.3);
  background: linear-gradient(135deg, rgba(253,249,242,0.9), rgba(246,240,230,0.8));
  cursor: pointer;
  font-weight: 900;
  font-size: 14px;
  transition: all 0.3s ease;
  color: #4a3b36
}

.backBtn:hover {
  background: linear-gradient(135deg, rgba(242,233,210,0.9), rgba(230,194,136,0.8));
  border-color: rgba(212,175,55,0.5);
  transform: translateY(-1px)
}

.sidebarTitle {
  padding: 0 20px 24px;
  font-size: 20px;
  font-weight: 900;
  color: #3a2e2b;
  letter-spacing: 2px;
  font-family: "思源宋体", "STSong", "SimSun", serif
}

.sidebarNav {
  display: flex;
  flex-direction: column;
  gap: 10px
}

.navItem {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px 24px;
  margin: 0 12px;
  border-radius: 12px;
  border: 1px solid transparent;
  background: transparent;
  cursor: pointer;
  font-size: 14px;
  font-weight: 700;
  color: #4a3b36;
  transition: all 0.3s ease
}

.navItem:hover {
  background: rgba(212,175,55,0.1);
  border-color: rgba(212,175,55,0.2);
  transform: translateX(4px)
}

.navItem.active {
  background: linear-gradient(135deg, #d4af37, #b8860b);
  color: #fff;
  border-color: transparent;
  box-shadow: 0 4px 12px rgba(212,175,55,0.25)
}

.navIcon {
  font-size: 20px
}

.navLabel {
  flex: 1;
  text-align: left
}

/* 右侧内容区 */
.mainContent {
  flex: 1;
  padding: 24px 32px;
  overflow-y: auto;
  position: relative;
  z-index: 1
}

@media (min-width: 1600px) {
  .mainContent { padding: 24px 48px }
}

@media (min-width: 1200px) and (max-width: 1599px) {
  .mainContent { padding: 24px 40px }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .mainContent { padding: 20px 32px }
}

@media (max-width: 767px) {
  .mainContent { padding: 16px }
}

.contentHead {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid rgba(212,175,55,0.15)
}

.contentTitle {
  font-size: 26px;
  font-weight: 900;
  color: #3a2e2b;
  margin: 0;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  letter-spacing: 1px
}

.refreshBtn {
  padding: 12px 20px;
  border-radius: 12px;
  border: 1px solid rgba(212,175,55,0.3);
  background: linear-gradient(135deg, rgba(253,249,242,0.9), rgba(246,240,230,0.8));
  cursor: pointer;
  font-weight: 900;
  color: #4a3b36;
  transition: all 0.3s ease
}

.refreshBtn:hover:not(:disabled) {
  background: linear-gradient(135deg, rgba(242,233,210,0.9), rgba(230,194,136,0.8));
  border-color: rgba(212,175,55,0.5);
  transform: translateY(-1px)
}

.refreshBtn:disabled {
  opacity: 0.6;
  cursor: not-allowed
}

.contentBody {
  max-width: none;
  width: 100%
}

/* 网格布局 */
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 20px;
  padding: 16px 0
}

@media (min-width: 1400px) {
  .grid { grid-template-columns: repeat(auto-fill, minmax(360px, 1fr)) }
}

@media (min-width: 1024px) and (max-width: 1399px) {
  .grid { grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)) }
}

@media (min-width: 768px) and (max-width: 1023px) {
  .grid { grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 16px }
}

@media (max-width: 767px) {
  .grid { grid-template-columns: 1fr }
}

.card {
  background: rgba(255,255,255,0.95);
  border: 1px solid rgba(212,175,55,0.15);
  border-radius: 16px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  box-shadow: 0 4px 16px rgba(212,175,55,0.08)
}

.card::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: linear-gradient(180deg, #d4af37, #b8860b)
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(212,175,55,0.15);
  border-color: rgba(212,175,55,0.3)
}

.cardCover {
  position: relative;
  height: 180px;
  overflow: hidden
}

.cardCover img {
  width: 100%;
  height: 100%;
  object-fit: cover
}

.cardType {
  position: absolute;
  bottom: 8px;
  right: 8px;
  padding: 6px 12px;
  border-radius: 8px;
  background: linear-gradient(135deg, rgba(212,175,55,0.9), rgba(184,134,11,0.85));
  color: #fff;
  font-size: 12px;
  font-weight: 900;
  border: 1px solid rgba(255,255,255,0.3)
}

.cardBody {
  padding: 16px
}

.cardTitle {
  margin: 0 0 8px 0;
  font-size: 16px;
  font-weight: 900;
  color: #3a2e2b;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap
}

.cardExcerpt {
  margin: 0 0 12px 0;
  font-size: 14px;
  color: #4a3b36;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden
}

.cardMeta {
  display: flex;
  gap: 12px;
  font-size: 13px;
  color: #9d8b7a;
  padding-top: 12px;
  border-top: 1px dashed rgba(212,175,55,0.15)
}

/* 空状态 */
.empty {
  text-align: center;
  padding: 60px 20px;
  background: rgba(255,255,255,0.6);
  border: 1px dashed rgba(212,175,55,0.2);
  border-radius: 20px;
  margin: 20px 0
}

.emptyIcon {
  font-size: 64px;
  margin-bottom: 16px
}

.emptyTitle {
  font-size: 20px;
  font-weight: 900;
  color: #4a3b36;
  margin-bottom: 12px;
  font-family: "思源宋体", "STSong", "SimSun", serif
}

.emptyDesc {
  font-size: 15px;
  color: #9d8b7a
}

/* 加载更多 */
.moreBtn {
  margin-top: 24px;
  padding: 24px 48px 16px;
  text-align: center;
  border-top: 1px dashed rgba(212,175,55,0.15);
  grid-column: 1 / -1
}

@media (min-width: 1600px) {
  .moreBtn { padding: 28px 64px 20px; margin-top: 28px }
}

@media (min-width: 1200px) and (max-width: 1599px) {
  .moreBtn { padding: 24px 56px 16px }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .moreBtn { padding: 20px 32px 12px }
}

@media (max-width: 767px) {
  .moreBtn { padding: 16px; margin-top: 16px }
}

.btn {
  height: 42px;
  padding: 0 28px;
  border-radius: 12px;
  border: 1px solid rgba(212,175,55,0.3);
  background: linear-gradient(135deg, rgba(253,249,242,0.9), rgba(246,240,230,0.8));
  cursor: pointer;
  font-weight: 900;
  color: #4a3b36;
  transition: all 0.3s ease;
  font-size: 14px
}

.btn:hover:not(:disabled) {
  background: linear-gradient(135deg, rgba(242,233,210,0.9), rgba(230,194,136,0.8));
  border-color: rgba(212,175,55,0.5);
  transform: translateY(-1px)
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed
}

@media (max-width: 768px) {
  .favPage {
    flex-direction: column
  }

  .sidebar {
    width: 100%;
    border-right: none;
    border-bottom: 1px solid rgba(212,175,55,0.15)
  }

  .sidebarTitle {
    padding: 16px 20px
  }

  .sidebarNav {
    flex-direction: row;
    overflow-x: auto;
    padding: 0 20px 16px
  }

  .navItem {
    flex-shrink: 0
  }

  .contentTitle {
    font-size: 22px
  }
}
</style>
