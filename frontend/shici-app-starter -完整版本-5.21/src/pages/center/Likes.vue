<template>
  <div class="page">
    <header class="head">
      <button class="back" type="button" @click="back">返回</button>
      <div class="title">我的点赞</div>
      <button class="right" type="button" :disabled="loading" @click="reload">
        {{ loading ? "加载中..." : "刷新" }}
      </button>
    </header>

    <section class="panel">
      <div class="hint">这里展示你点赞过的所有作品</div>

      <div v-if="!loading && list.length===0" class="empty">暂无点赞记录</div>

      <div class="items" v-else>
        <div class="item" v-for="it in list" :key="it.id">
          <div class="main" @click="openItem(it)">
            <div class="name">{{ it.title || "无标题作品" }}</div>
            <div class="sub">
              <span>{{ it.authorName || "匿名作者" }}</span>
              <span class="dot"></span>
              <span>{{ fmtTime(it.createdAt) }}</span>
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

function back(){ router.back(); }

function fmtTime(v) {
  if (!v) return "-";
  const d = new Date(v);
  if (Number.isNaN(d.getTime())) return String(v);
  const pad = (n) => String(n).padStart(2, "0");
  return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function openItem(it) {
  if (it.targetId) return router.push(`/chuangzuo/${it.targetId}`);
  alert("无法跳转到作品详情");
}

async function fetchPage(p, append=false) {
  const resp = await apiFetch(`/api/user/likesReceived?page=${p}&size=${size}`);
  const json = await resp.json().catch(() => null);
  if (!resp.ok || !json || json.code !== 0) throw new Error((json && json.msg) || "加载失败");
  const items = (json.data && (json.data.items || json.data.list)) || json.data || [];
  const total = (json.data && json.data.total) ?? null;

  list.value = append ? list.value.concat(items) : items;

  if (total != null) hasMore.value = list.value.length < total;
  else hasMore.value = items.length === size;
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
  background:
    radial-gradient(1200px 800px at 20% 10%, rgba(180, 200, 220, 0.08), transparent 60%),
    radial-gradient(900px 600px at 80% 20%, rgba(230, 220, 190, 0.12), transparent 55%),
    linear-gradient(135deg, #fdfbf7, #f5f3ef);
  padding-bottom: 32px;
  position: relative
}

.page::before {
  content: "";
  position: fixed;
  inset: 0;
  background: url("@/assets/chuangzuo/竹.png");
  background-size: 25%;
  opacity: 0.06;
  pointer-events: none;
  z-index: -3
}

.head {
  max-width: none;
  width: 100%;
  padding: 24px 48px 16px;
  margin: 0;
  display: grid;
  grid-template-columns: 80px 1fr 100px;
  gap: 16px;
  align-items: center;
  position: sticky;
  top: 0;
  z-index: 40;
  background: linear-gradient(180deg, rgba(253,251,247,0.98), rgba(253,251,247,0.95), rgba(253,251,247,0));
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(212,175,55,0.1)
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
  border: 1px solid rgba(212,175,55,0.3);
  background: linear-gradient(135deg, rgba(253,249,242,0.9), rgba(246,240,230,0.8));
  cursor: pointer;
  font-weight: 900;
  color: #4a3b36;
  padding: 0 20px;
  transition: all 0.3s ease
}

.back:hover, .right:hover {
  background: linear-gradient(135deg, rgba(242,233,210,0.9), rgba(230,194,136,0.8));
  border-color: rgba(212,175,55,0.5);
  transform: translateY(-1px)
}

.right:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  background: rgba(200,200,200,0.2)
}

.title {
  text-align: center;
  font-weight: 900;
  letter-spacing: 2px;
  color: #3a2e2b;
  font-size: 24px;
  font-family: "思源宋体", "STSong", "SimSun", serif
}

.panel {
  max-width: none;
  width: 100%;
  padding: 0 48px;
  margin: 0 auto 20px
}

.panel > div {
  background: rgba(255,255,255,0.85);
  border: 1px solid rgba(212,175,55,0.15);
  border-radius: 18px;
  padding: 20px;
  box-shadow: 0 4px 16px rgba(212,175,55,0.08)
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

.hint {
  font-size: 14px;
  color: #9d8b7a;
  margin-bottom: 12px;
  font-weight: 700
}

.empty {
  padding: 60px 20px;
  text-align: center;
  background: rgba(255,255,255,0.6);
  border: 1px dashed rgba(212,175,55,0.2);
  border-radius: 20px;
  margin: 20px 0;
  font-size: 16px;
  color: #9d8b7a;
  font-weight: 700
}

.items {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
  gap: 16px;
  padding: 16px 0
}

@media (min-width: 1400px) {
  .items { grid-template-columns: repeat(auto-fill, minmax(400px, 1fr)) }
}

@media (min-width: 768px) and (max-width: 1399px) {
  .items { grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)) }
}

@media (max-width: 767px) {
  .items { grid-template-columns: 1fr }
}

.item {
  padding: 16px;
  border-radius: 16px;
  border: 1px solid rgba(212,175,55,0.15);
  background: rgba(255,255,255,0.95);
  box-shadow: 0 4px 16px rgba(212,175,55,0.08);
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease
}

.item::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: linear-gradient(180deg, #d4af37, #b8860b)
}

.item:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(212,175,55,0.12);
  border-color: rgba(212,175,55,0.3)
}

.main {
  cursor: pointer
}

.name {
  font-weight: 900;
  color: #3a2e2b;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-size: 16px;
  margin-bottom: 8px
}

.sub {
  display: flex;
  gap: 8px;
  align-items: center;
  font-size: 13px;
  color: #9d8b7a;
  flex-wrap: wrap
}

.dot {
  width: 4px;
  height: 4px;
  border-radius: 999px;
  background: rgba(212,175,55,0.3)
}

.more {
  display: flex;
  justify-content: center;
  padding: 24px 48px 16px;
  margin-top: 16px;
  border-top: 1px dashed rgba(212,175,55,0.15);
  grid-column: 1 / -1
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

.btn.ghost {
  background: transparent;
  border-color: rgba(212,175,55,0.2)
}

.space {
  height: 24px
}

@media (max-width: 768px) {
  .title { font-size: 20px }
  .back, .right { height: 36px; padding: 0 16px }
}
</style>