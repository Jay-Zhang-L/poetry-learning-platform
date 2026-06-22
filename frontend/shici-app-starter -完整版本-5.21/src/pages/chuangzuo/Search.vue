<template>
  <div class="searchPage">
    <div class="container">
      <!-- 顶部栏 -->
      <header class="topbar">
        <button class="backBtn" @click="goBack">
          <svg viewBox="0 0 24 24" aria-hidden="true">
            <path
              d="M15 18l-6-6 6-6"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            />
          </svg>
          <span>返回</span>
        </button>

        <div class="title">搜索创作</div>

        <button class="clearBtn" v-if="keyword" @click="clearSearch">清空</button>
        <div v-else class="clearPlaceholder"></div>
      </header>

      <!-- 搜索框 -->
      <section class="searchBarWrap">
        <div class="searchBar">
          <svg class="searchIcon" viewBox="0 0 24 24" aria-hidden="true">
            <path
              d="M10 18a8 8 0 1 1 0-16 8 8 0 0 1 0 16Zm11 3-6.2-6.2"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
            />
          </svg>

          <input
            ref="inputRef"
            v-model.trim="keyword"
            class="searchInput"
            type="text"
            placeholder="搜索标题、正文、作者、标签"
            maxlength="50"
            @keydown.enter="doSearch(true)"
          />

          <button class="searchBtn" @click="doSearch(true)">搜索</button>
        </div>

        <div class="hotWrap">
          <span class="hotLabel">热门搜索：</span>
          <button
            v-for="tag in hotKeywords"
            :key="tag"
            class="hotTag"
            @click="pickHotKeyword(tag)"
          >
            {{ tag }}
          </button>
        </div>
      </section>

      <!-- 历史记录 -->
      <section v-if="historyKeywords.length > 0 && !searched" class="historyCard">
        <div class="sectionHead">
          <div class="sectionTitle">最近搜索</div>
          <button class="textBtn" @click="clearHistory">清空</button>
        </div>

        <div class="historyList">
          <button
            v-for="item in historyKeywords"
            :key="item"
            class="historyItem"
            @click="useHistory(item)"
          >
            {{ item }}
          </button>
        </div>
      </section>

      <!-- 筛选 -->
      <section class="filterCard">
        <div class="filterRow">
          <div class="filterLabel">类型</div>
          <div class="filterOptions">
            <button
              v-for="item in typeOptions"
              :key="item.value"
              class="filterBtn"
              :class="{ active: type === item.value }"
              @click="changeType(item.value)"
            >
              {{ item.label }}
            </button>
          </div>
        </div>

        <div class="filterRow">
          <div class="filterLabel">排序</div>
          <div class="filterOptions">
            <button
              v-for="item in sortOptions"
              :key="item.value"
              class="filterBtn"
              :class="{ active: sortBy === item.value }"
              @click="changeSort(item.value)"
            >
              {{ item.label }}
            </button>
          </div>
        </div>
      </section>

      <!-- 搜索提示 -->
      <section v-if="!searched && !loading" class="emptyState">
        <div class="emptyIcon">搜</div>
        <div class="emptyTitle">输入关键词搜索作品</div>
        <div class="emptyDesc">支持搜索标题、正文、作者昵称、标签</div>
      </section>

      <!-- 加载中 -->
      <section v-else-if="loading && list.length === 0" class="skeletonList">
        <div v-for="i in 5" :key="i" class="skCard">
          <div class="skLine w45"></div>
          <div class="skLine w80"></div>
          <div class="skLine w65"></div>
          <div class="skLine w30"></div>
        </div>
      </section>

      <!-- 结果 -->
      <section v-else class="resultCard">
        <div class="sectionHead">
          <div class="sectionTitle">
            搜索结果
            <span v-if="searched" class="countText">共 {{ total }} 条</span>
          </div>
        </div>

        <div v-if="list.length > 0" class="resultList">
          <article
            v-for="item in list"
            :key="item.id"
            class="workCard"
            @click="goDetail(item.id)"
          >
            <div class="workTop">
              <span class="typeTag">{{ getTypeLabel(item.type) }}</span>
              <span class="time">{{ formatDate(item.createdAt) }}</span>
            </div>

            <div class="workTitle">{{ item.title || "无标题" }}</div>

            <div class="workContent">
              {{ item.excerpt || item.content || "暂无内容" }}
            </div>

            <div v-if="item.tags && item.tags.length" class="tags">
              <span v-for="tag in item.tags" :key="tag" class="tag">#{{ tag }}</span>
            </div>

            <div class="workBottom">
              <div class="authorInfo">
                <img
                  class="avatar"
                  :src="item.authorAvatar || fallbackAvatar"
                  alt=""
                />
                <span class="authorName">{{ item.authorName || "佚名" }}</span>
              </div>

              <div class="stats">
                <span>点赞 {{ item.likeCount || 0 }}</span>
                <span>评论 {{ item.commentCount || 0 }}</span>
                <span>浏览 {{ item.viewCount || 0 }}</span>
              </div>
            </div>
          </article>
        </div>

        <div v-else-if="searched && !loading" class="emptyState small">
          <div class="emptyIcon">空</div>
          <div class="emptyTitle">没有找到相关作品</div>
          <div class="emptyDesc">换个关键词试试，比如“唐诗”“李白”“春天”</div>
        </div>

        <div v-if="list.length > 0" class="loadMoreBox">
          <button
            v-if="hasMore && !loading"
            class="loadMoreBtn"
            @click="loadMore"
          >
            加载更多
          </button>
          <div v-else-if="loading" class="loadingText">加载中...</div>
          <div v-else class="loadingText">已经到底了</div>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup>
import { nextTick, onMounted, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { authGet } from "@/utils/api";
import { showError, showWarning } from "@/utils/toast";

const router = useRouter();
const route = useRoute();
const inputRef = ref(null);

const keyword = ref("");
const type = ref("all");
const sortBy = ref("time");

const page = ref(1);
const pageSize = 10;
const total = ref(0);
const hasMore = ref(false);
const loading = ref(false);
const searched = ref(false);
const list = ref([]);

const hotKeywords = ["唐诗", "宋词", "李白", "杜甫", "春天", "乡愁", "书法", "原创"];
const historyKeywords = ref([]);

const typeOptions = [
  { value: "all", label: "全部" },
  { value: "poem", label: "诗词" },
  { value: "ci", label: "词牌" },
  { value: "fu", label: "赋体" },
  { value: "couplet", label: "对联" },
  { value: "modern", label: "现代诗" },
  { value: "calligraphy", label: "书法" },
];

const sortOptions = [
  { value: "time", label: "最新" },
  { value: "hot", label: "最热" },
  { value: "likes", label: "点赞" },
  { value: "views", label: "浏览" },
];

const typeLabels = {
  poem: "诗词创作",
  ci: "词牌填词",
  fu: "赋体创作",
  couplet: "对联创作",
  modern: "现代诗歌",
  calligraphy: "书法创作",
};

const fallbackAvatar =
  'data:image/svg+xml;utf8,' +
  encodeURIComponent(`
  <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64">
    <defs>
      <linearGradient id="g" x1="0" y1="0" x2="1" y2="1">
        <stop offset="0" stop-color="#d8d2c8"/>
        <stop offset="1" stop-color="#f1ece4"/>
      </linearGradient>
    </defs>
    <rect width="64" height="64" rx="14" fill="url(#g)"/>
    <circle cx="32" cy="24" r="11" fill="#fff" opacity="0.9"/>
    <path d="M14 56c4-10 11-16 18-16s14 6 18 16" fill="#fff" opacity="0.9"/>
  </svg>
`);

function getTypeLabel(typeValue) {
  return typeLabels[typeValue] || "创作";
}

function formatDate(v) {
  if (!v) return "刚刚";
  const d = new Date(v);
  if (Number.isNaN(d.getTime())) return String(v);
  const pad = (n) => (n < 10 ? "0" + n : "" + n);
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
}

function goBack() {
  router.back();
}

function goDetail(id) {
  router.push(`/chuangzuo/${id}`);
}

function loadHistory() {
  try {
    const raw = localStorage.getItem("creation_search_history");
    historyKeywords.value = raw ? JSON.parse(raw) : [];
  } catch {
    historyKeywords.value = [];
  }
}

function saveHistory(kw) {
  if (!kw) return;
  const arr = historyKeywords.value.filter((item) => item !== kw);
  arr.unshift(kw);
  historyKeywords.value = arr.slice(0, 10);
  localStorage.setItem(
    "creation_search_history",
    JSON.stringify(historyKeywords.value)
  );
}

function clearHistory() {
  historyKeywords.value = [];
  localStorage.removeItem("creation_search_history");
}

function useHistory(item) {
  keyword.value = item;
  doSearch(true);
}

function pickHotKeyword(item) {
  keyword.value = item;
  doSearch(true);
}

function clearSearch() {
  keyword.value = "";
  list.value = [];
  total.value = 0;
  page.value = 1;
  hasMore.value = false;
  searched.value = false;
  nextTick(() => inputRef.value?.focus());
}

function changeType(v) {
  type.value = v;
  if (searched.value) {
    doSearch(true);
  }
}

function changeSort(v) {
  sortBy.value = v;
  if (searched.value) {
    doSearch(true);
  }
}

function normalizeItem(item) {
  let tags = item.tags || [];
  if (typeof tags === "string") {
    try {
      tags = JSON.parse(tags);
    } catch {
      tags = tags
        .split(",")
        .map((s) => s.trim())
        .filter(Boolean);
    }
  }

  return {
    ...item,
    tags: Array.isArray(tags) ? tags : [],
    excerpt:
      item.excerpt ||
      (item.content
        ? item.content.slice(0, 100) + (item.content.length > 100 ? "..." : "")
        : ""),
  };
}

async function fetchList(reset = false) {
  if (loading.value) return;

  if (reset) {
    page.value = 1;
    list.value = [];
    total.value = 0;
    hasMore.value = false;
  }

  loading.value = true;
  searched.value = true;

  try {
    const q = keyword.value.trim();
    const url =
      `/api/creations/search?keyword=${encodeURIComponent(q)}` +
      `&type=${encodeURIComponent(type.value)}` +
      `&sortBy=${encodeURIComponent(sortBy.value)}` +
      `&page=${page.value}` +
      `&pageSize=${pageSize}`;

    const data = await authGet(url);

    if (data.code !== 0) {
      throw new Error(data.msg || "搜索失败");
    }

    const resp = data.data || {};
    const rows = (resp.list || []).map(normalizeItem);

    if (reset) {
      list.value = rows;
    } else {
      list.value = list.value.concat(rows);
    }

    total.value = resp.total || 0;
    hasMore.value =
      typeof resp.hasMore === "boolean"
        ? resp.hasMore
        : list.value.length < total.value;

    if (keyword.value.trim()) {
      saveHistory(keyword.value.trim());
    }
  } catch (e) {
    console.error("搜索创作失败：", e);
    showError(e.message || "搜索失败");
  } finally {
    loading.value = false;
  }
}

function doSearch(reset = true) {
  if (!keyword.value.trim()) {
    showWarning("请输入搜索关键词");
    return;
  }
  fetchList(reset);
}

function loadMore() {
  if (!hasMore.value || loading.value) return;
  page.value += 1;
  fetchList(false);
}

onMounted(async () => {
  loadHistory();

  const q = String(route.query.q || "").trim();
  const t = String(route.query.type || "").trim();
  const s = String(route.query.sortBy || "").trim();

  if (q) keyword.value = q;
  if (t) type.value = t;
  if (s) sortBy.value = s;

  await nextTick();
  inputRef.value?.focus();

  if (q) {
    doSearch(true);
  }
});

watch(
  () => route.query.q,
  (val) => {
    const q = String(val || "").trim();
    if (q && q !== keyword.value) {
      keyword.value = q;
      doSearch(true);
    }
  }
);
</script>

<style scoped>
.searchPage {
  min-height: 100vh;
  background:
    radial-gradient(circle at top left, rgba(220, 226, 221, 0.9), transparent 35%),
    linear-gradient(135deg, #f7f4ee 0%, #f1eee8 45%, #faf8f4 100%);
  padding: 0 0 40px;
}

.container {
  width: min(960px, 94vw);
  margin: 0 auto;
  padding: 16px 0 0;
}

.topbar {
  position: sticky;
  top: 0;
  z-index: 20;
  display: grid;
  grid-template-columns: auto 1fr auto;
  align-items: center;
  gap: 12px;
  padding: 12px 0 18px;
  background: linear-gradient(180deg, rgba(247,244,238,1) 0%, rgba(247,244,238,.94) 82%, rgba(247,244,238,0) 100%);
  backdrop-filter: blur(10px);
}

.backBtn,
.clearBtn,
.textBtn,
.hotTag,
.filterBtn,
.loadMoreBtn,
.searchBtn {
  cursor: pointer;
  transition: all .2s ease;
}

.backBtn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  height: 40px;
  padding: 0 14px;
  border-radius: 12px;
  border: 1px solid rgba(0,0,0,.1);
  background: rgba(255,255,255,.78);
  font-weight: 900;
}

.backBtn svg {
  width: 18px;
  height: 18px;
}

.title {
  text-align: center;
  font-size: 22px;
  font-weight: 1000;
  color: #2d2d2d;
}

.clearBtn,
.clearPlaceholder {
  min-width: 64px;
  height: 40px;
}

.clearBtn {
  border: 1px solid rgba(0,0,0,.08);
  border-radius: 12px;
  background: rgba(255,255,255,.72);
  font-weight: 900;
  color: rgba(0,0,0,.7);
}

.searchBarWrap,
.historyCard,
.filterCard,
.resultCard {
  background: rgba(255,255,255,.72);
  border: 1px solid rgba(0,0,0,.06);
  box-shadow: 0 14px 40px rgba(0,0,0,.06);
  backdrop-filter: blur(10px);
}

.searchBarWrap,
.historyCard,
.filterCard,
.resultCard {
  border-radius: 22px;
  margin-bottom: 16px;
  padding: 18px;
}

.searchBar {
  display: grid;
  grid-template-columns: 22px 1fr auto;
  align-items: center;
  gap: 12px;
  min-height: 54px;
  padding: 0 14px;
  border-radius: 16px;
  background: rgba(250,248,244,.95);
  border: 1px solid rgba(0,0,0,.08);
}

.searchIcon {
  width: 20px;
  height: 20px;
  color: rgba(0,0,0,.45);
}

.searchInput {
  height: 52px;
  border: none;
  background: transparent;
  outline: none;
  font-size: 15px;
  color: #2d2d2d;
}

.searchBtn {
  height: 38px;
  padding: 0 16px;
  border: none;
  border-radius: 12px;
  background: linear-gradient(135deg, #4a7bb8 0%, #2d5a8f 100%);
  color: #fff;
  font-weight: 900;
}

.hotWrap {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 14px;
  align-items: center;
}

.hotLabel {
  font-size: 13px;
  color: rgba(0,0,0,.55);
  font-weight: 900;
}

.hotTag,
.historyItem {
  border: 1px solid rgba(0,0,0,.08);
  background: rgba(255,255,255,.82);
  color: #6a5846;
  border-radius: 999px;
  padding: 8px 14px;
  font-size: 13px;
  font-weight: 900;
}

.sectionHead {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 14px;
}

.sectionTitle {
  font-size: 18px;
  font-weight: 1000;
  color: #2d2d2d;
}

.countText {
  margin-left: 8px;
  font-size: 13px;
  color: rgba(0,0,0,.5);
  font-weight: 800;
}

.textBtn {
  border: none;
  background: none;
  color: #4a7bb8;
  font-weight: 900;
}

.historyList {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.filterRow + .filterRow {
  margin-top: 14px;
}

.filterLabel {
  margin-bottom: 10px;
  font-size: 14px;
  font-weight: 1000;
  color: #2d2d2d;
}

.filterOptions {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.filterBtn {
  border: 1px solid rgba(0,0,0,.08);
  background: rgba(255,255,255,.82);
  border-radius: 999px;
  padding: 8px 16px;
  font-size: 13px;
  font-weight: 900;
  color: rgba(0,0,0,.68);
}

.filterBtn.active {
  color: #fff;
  border-color: transparent;
  background: linear-gradient(135deg, #4a7bb8 0%, #2d5a8f 100%);
  box-shadow: 0 8px 18px rgba(74,123,184,.2);
}

.resultList {
  display: grid;
  gap: 14px;
}

.workCard {
  padding: 18px;
  border-radius: 18px;
  background: rgba(252,250,246,.92);
  border: 1px solid rgba(0,0,0,.06);
  cursor: pointer;
  transition: transform .2s ease, box-shadow .2s ease;
}

.workCard:hover {
  transform: translateY(-3px);
  box-shadow: 0 12px 28px rgba(0,0,0,.07);
}

.workTop,
.workBottom,
.stats,
.authorInfo {
  display: flex;
  align-items: center;
}

.workTop,
.workBottom {
  justify-content: space-between;
  gap: 10px;
}

.workTitle {
  margin: 12px 0 10px;
  font-size: 20px;
  font-weight: 1000;
  color: #2d2d2d;
  line-height: 1.45;
}

.workContent {
  color: rgba(0,0,0,.74);
  line-height: 1.85;
  font-size: 14px;
  white-space: pre-wrap;
  margin-bottom: 12px;
}

.typeTag {
  display: inline-flex;
  align-items: center;
  padding: 6px 12px;
  border-radius: 999px;
  background: rgba(74,123,184,.12);
  color: #2d5a8f;
  font-size: 12px;
  font-weight: 1000;
}

.time {
  font-size: 12px;
  color: rgba(0,0,0,.45);
  font-weight: 800;
}

.tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 14px;
}

.tag {
  padding: 6px 10px;
  border-radius: 999px;
  background: rgba(212,165,116,.15);
  color: #8b7355;
  font-size: 12px;
  font-weight: 900;
}

.authorInfo {
  gap: 8px;
}

.avatar {
  width: 28px;
  height: 28px;
  object-fit: cover;
  border-radius: 999px;
}

.authorName {
  font-size: 13px;
  font-weight: 900;
  color: rgba(0,0,0,.7);
}

.stats {
  gap: 14px;
  font-size: 12px;
  color: rgba(0,0,0,.5);
  font-weight: 800;
  flex-wrap: wrap;
  justify-content: flex-end;
}

.emptyState {
  text-align: center;
  padding: 64px 20px;
  color: rgba(0,0,0,.55);
}

.emptyState.small {
  padding: 40px 20px 20px;
}

.emptyIcon {
  width: 72px;
  height: 72px;
  margin: 0 auto 14px;
  border-radius: 50%;
  display: grid;
  place-items: center;
  background: rgba(212,165,116,.12);
  color: #8b7355;
  font-size: 28px;
  font-weight: 1000;
}

.emptyTitle {
  font-size: 18px;
  font-weight: 1000;
  color: #2d2d2d;
  margin-bottom: 8px;
}

.emptyDesc {
  font-size: 14px;
  line-height: 1.7;
}

.loadMoreBox {
  padding-top: 16px;
  text-align: center;
}

.loadMoreBtn {
  min-width: 140px;
  height: 42px;
  border: 1px solid rgba(0,0,0,.08);
  border-radius: 12px;
  background: rgba(255,255,255,.9);
  font-weight: 900;
}

.loadingText {
  color: rgba(0,0,0,.5);
  font-size: 14px;
  padding: 10px 0 4px;
}

.skeletonList {
  display: grid;
  gap: 14px;
}

.skCard {
  padding: 18px;
  border-radius: 18px;
  background: rgba(255,255,255,.7);
  border: 1px solid rgba(0,0,0,.05);
}

.skLine {
  height: 14px;
  border-radius: 999px;
  margin-bottom: 12px;
  background: linear-gradient(90deg, rgba(0,0,0,.06), rgba(0,0,0,.03), rgba(0,0,0,.06));
  background-size: 200% 100%;
  animation: shimmer 1.4s linear infinite;
}

.w30 { width: 30%; }
.w45 { width: 45%; }
.w65 { width: 65%; }
.w80 { width: 80%; }

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}

@media (max-width: 768px) {
  .container {
    width: min(96vw, 96vw);
  }

  .title {
    font-size: 18px;
  }

  .searchBar {
    grid-template-columns: 20px 1fr;
  }

  .searchBtn {
    grid-column: 1 / -1;
    width: 100%;
  }

  .workBottom {
    flex-direction: column;
    align-items: flex-start;
  }

  .stats {
    justify-content: flex-start;
  }
}
</style>