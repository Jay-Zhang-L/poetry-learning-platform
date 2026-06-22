<template>
  <div class="page">
    <header class="head">
      <button class="back" type="button" @click="back">返回</button>
      <div class="title">获赞记录</div>
      <button class="right" type="button" :disabled="loading" @click="reload">
        {{ loading ? "加载中..." : "刷新" }}
      </button>
    </header>

    <section class="panel">
      <div class="bar">
        <div class="hint">显示其他用户点赞你作品的记录</div>
        <div class="summary">共获赞 {{ totalLikes }} 次</div>
      </div>

      <div v-if="!loading && list.length === 0" class="empty">
        <div class="emptyIcon">❤️</div>
        <div class="emptyTitle">暂无获赞记录</div>
        <div class="emptyDesc">你的作品被点赞后会显示在这里</div>
      </div>

      <div class="items" v-else>
        <div class="item" v-for="it in list" :key="it.id">
          <div class="left" @click="goToWork(it.workId)">
            <div class="avatar" @click.stop="goToUser(it.likerId)">
              <img v-if="it.likerAvatar" :src="it.likerAvatar" alt="" />
              <div v-else class="avatarPlaceholder">{{ (it.likerNickname || 'U').slice(0, 1) }}</div>
            </div>
            <div class="content">
              <div class="main">
                <span class="user">{{ it.likerNickname || it.likerUsername || '用户' }}</span>
                <span class="action">赞了你的作品</span>
              </div>
              <div class="work">{{ it.workTitle || '无标题作品' }}</div>
              <div class="time">{{ fmtTime(it.likedAt) }}</div>
            </div>
          </div>
        </div>

        <div class="more">
          <button class="btn ghost" type="button" :disabled="loadingMore || !hasMore" @click="loadMore">
            {{ hasMore ? (loadingMore ? "加载中..." : "加载更多") : "没有更多了" }}
          </button>
        </div>
      </div>
    </section>

    <div class="space"></div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import { useRouter } from "vue-router";

const router = useRouter();
const token = computed(() => localStorage.getItem("token") || "");

function apiFetch(url, opts = {}) {
  const headers = Object.assign({}, opts.headers || {});
  if (token.value) headers.Authorization = "Bearer " + token.value;
  return fetch(url, { ...opts, headers });
}

const list = ref([]);
const loading = ref(false);
const loadingMore = ref(false);
const page = ref(1);
const size = 20;
const hasMore = ref(true);
const totalLikes = ref(0);

function back() {
  router.back();
}

function fmtTime(v) {
  if (!v) return "-";
  const d = new Date(v);
  if (Number.isNaN(d.getTime())) return String(v);
  const pad = (n) => String(n).padStart(2, "0");
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function goToWork(workId) {
  if (workId) {
    router.push(`/chuangzuo/${workId}`);
  }
}

function goToUser(userId) {
  if (userId) {
    router.push(`/author/${userId}`);
  }
}

async function fetchPage(p, append = false) {
  const resp = await apiFetch(`/api/creations/my/likes?page=${p}&size=${size}`);
  const json = await resp.json().catch(() => null);
  if (!resp.ok || !json || (json.code !== 0 && json.code !== 200)) throw new Error((json && (json.msg || json.message)) || "加载失败");

  const items = (json.data && (json.data.items || json.data.list)) || json.data || [];
  const total = (json.data && json.data.total) ?? null;

  list.value = append ? list.value.concat(items) : items;

  if (total != null) {
    hasMore.value = list.value.length < total;
    totalLikes.value = total;
  } else {
    hasMore.value = items.length === size;
    totalLikes.value = list.value.length;
  }
}

async function reload() {
  loading.value = true;
  try {
    page.value = 1;
    await fetchPage(1, false);
  } catch (e) {
    alert(e.message || "加载失败");
  } finally {
    loading.value = false;
  }
}

async function loadMore() {
  if (!hasMore.value) return;
  loadingMore.value = true;
  try {
    page.value += 1;
    await fetchPage(page.value, true);
  } catch (e) {
    page.value -= 1;
    alert(e.message || "加载失败");
  } finally {
    loadingMore.value = false;
  }
}

onMounted(() => {
  if (!token.value) return router.replace("/login");
  reload();
});
</script>

<style scoped>
.page {
  min-height: 100vh;
  position: relative;
  background: var(--bg0);
  padding-bottom: 32px;
}

/* 竹纹背景 */
.page::before {
  content: "";
  position: fixed;
  inset: 0;
  background-image: url("@/assets/chuangzuo/竹.png");
  background-size: 25%;
  background-repeat: repeat;
  opacity: 0.08;
  pointer-events: none;
  z-index: -3;
}

/* 水墨晕染渐变层 */
.page::after {
  content: "";
  position: fixed;
  inset: 0;
  background:
    radial-gradient(1200px 700px at 20% 10%, rgba(140, 170, 160, 0.12), transparent 60%),
    radial-gradient(900px 500px at 80% 20%, rgba(180, 200, 220, 0.08), transparent 55%),
    radial-gradient(1000px 600px at 50% 90%, rgba(230, 220, 190, 0.15), transparent 55%);
  pointer-events: none;
  z-index: -2;
}

/* 头部导航 */
.head {
  position: sticky;
  top: 0;
  z-index: 40;
  width: 100%;
  padding: 24px 48px 16px;
  margin: 0;
  display: grid;
  grid-template-columns: 80px 1fr 100px;
  gap: 16px;
  align-items: center;
  background: linear-gradient(180deg, rgba(253, 251, 247, 0.98), rgba(253, 251, 247, 0.95), rgba(253, 251, 247, 0));
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(212, 175, 55, 0.1);
}

@media (min-width: 1600px) {
  .head { padding: 24px 64px 16px }
}

@media (min-width: 1200px) and (max-width: 1599px) {
  .head { padding: 24px 56px 16px }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .head { padding: 20px 32px 12px }
}

@media (max-width: 767px) {
  .head { padding: 16px; grid-template-columns: 60px 1fr 80px }
}

.back, .right {
  height: 40px;
  border-radius: 12px;
  border: 1px solid rgba(212, 175, 55, 0.3);
  background: linear-gradient(135deg, rgba(253, 249, 242, 0.9), rgba(246, 240, 230, 0.8));
  cursor: pointer;
  font-weight: 900;
  color: #4a3b36;
  padding: 0 20px;
  transition: all 0.3s ease;
}

.back:hover, .right:hover {
  background: linear-gradient(135deg, rgba(242, 233, 210, 0.9), rgba(230, 194, 136, 0.8));
  border-color: rgba(212, 175, 55, 0.5);
  transform: translateY(-1px);
}

.right:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  background: rgba(200, 200, 200, 0.3);
}

.title {
  text-align: center;
  font-weight: 900;
  letter-spacing: 2px;
  color: #3a2e2b;
  font-size: 24px;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

/* 面板容器 */
.panel {
  width: 100%;
  padding: 0 48px;
  margin: 20px 0 0;
  border-radius: 16px;
  background: rgba(253, 249, 242, 0.9);
  border: 1px solid rgba(212, 175, 55, 0.2);
  box-shadow: 0 4px 16px rgba(212, 175, 55, 0.08);
  backdrop-filter: blur(12px);
  position: relative;
  z-index: 2;
}

@media (min-width: 1600px) {
  .panel { padding: 0 64px }
}

@media (min-width: 1200px) and (max-width: 1599px) {
  .panel { padding: 0 56px }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .panel { padding: 0 32px }
}

@media (max-width: 767px) {
  .panel { padding: 0 16px }
}

.panel > div {
  padding: 24px;
}

@media (max-width: 767px) {
  .panel > div { padding: 20px }
}

/* 工具栏 */
.bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px dashed rgba(212, 175, 55, 0.15);
}

.hint {
  font-size: 14px;
  color: #9d8b7a;
  font-weight: 700;
}

.summary {
  font-size: 14px;
  color: #d4af37;
  font-weight: 900;
}

/* 空状态 */
.empty {
  padding: 60px 20px;
  text-align: center;
  background: rgba(255, 255, 255, 0.6);
  border: 1px dashed rgba(212, 175, 55, 0.2);
  border-radius: 20px;
  margin: 20px 0;
}

.emptyIcon {
  font-size: 64px;
  margin-bottom: 20px;
}

.emptyTitle {
  font-size: 18px;
  color: #4a3b36;
  font-weight: 900;
  margin-bottom: 8px;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

.emptyDesc {
  font-size: 14px;
  color: #9d8b7a;
  font-weight: 700;
}

/* 获赞记录列表 */
.items {
  display: grid;
  gap: 16px;
  padding: 16px 0;
}

.item {
  padding: 20px;
  border-radius: 16px;
  border: 1px dashed rgba(212, 175, 55, 0.15);
  background: rgba(255, 255, 255, 0.95);
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
  cursor: pointer;
}

/* 左侧金色竖线装饰 */
.item::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: linear-gradient(180deg, #d4af37, #b8860b);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.item:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(212, 175, 55, 0.12);
  border-color: rgba(212, 175, 55, 0.3);
  border-style: solid;
}

.item:hover::before {
  opacity: 1;
}

.left {
  display: flex;
  gap: 16px;
  align-items: flex-start;
  width: 100%;
}

/* 头像 */
.avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  overflow: hidden;
  border: 2px solid rgba(212, 175, 55, 0.3);
  flex-shrink: 0;
  cursor: pointer;
  transition: all 0.3s ease;
}

.avatar:hover {
  border-color: rgba(212, 175, 55, 0.6);
  transform: scale(1.05);
}

.avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatarPlaceholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(212, 175, 55, 0.1);
  font-weight: 900;
  font-size: 18px;
  color: #4a3b36;
}

/* 内容区域 */
.content {
  flex: 1;
  min-width: 0;
}

.main {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  flex-wrap: wrap;
}

.user {
  font-size: 16px;
  font-weight: 900;
  color: #4a3b36;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

.action {
  font-size: 14px;
  color: #9d8b7a;
  font-weight: 700;
}

.work {
  font-size: 15px;
  color: #d4af37;
  font-weight: 900;
  margin-bottom: 6px;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.time {
  font-size: 13px;
  color: #9d8b7a;
  font-weight: 700;
}

/* 加载更多区域 */
.more {
  display: flex;
  justify-content: center;
  padding: 24px 48px 16px;
  margin-top: 16px;
  border-top: 1px dashed rgba(212, 175, 55, 0.15);
}

@media (min-width: 1600px) {
  .more { padding: 28px 64px 20px }
}

@media (min-width: 1200px) and (max-width: 1599px) {
  .more { padding: 24px 56px 16px }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .more { padding: 20px 32px 12px }
}

@media (max-width: 767px) {
  .more { padding: 16px; margin-top: 12px }
}

.btn {
  height: 42px;
  padding: 0 28px;
  border-radius: 12px;
  border: 1px solid rgba(212, 175, 55, 0.3);
  background: linear-gradient(135deg, rgba(253, 249, 242, 0.9), rgba(246, 240, 230, 0.8));
  cursor: pointer;
  font-weight: 900;
  color: #4a3b36;
  transition: all 0.3s ease;
  font-size: 14px;
}

.btn:hover:not(:disabled) {
  background: linear-gradient(135deg, rgba(242, 233, 210, 0.9), rgba(230, 194, 136, 0.8));
  border-color: rgba(212, 175, 55, 0.5);
  transform: translateY(-1px);
}

.btn.ghost {
  background: transparent;
  border-color: rgba(212, 175, 55, 0.2);
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.space {
  height: 24px;
}
</style>