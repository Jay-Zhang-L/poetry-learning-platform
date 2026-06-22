<template>
  <div class="page">
    <header class="head">
      <button class="back" type="button" @click="back">返回</button>
      <div class="title">意见反馈</div>
      <button class="right" type="button" :disabled="sending" @click="submit">
        {{ sending ? "提交中..." : "提交" }}
      </button>
    </header>

    <section class="panel">
      <div class="label">反馈内容</div>
      <textarea class="ta" v-model.trim="content" maxlength="500" placeholder="请描述你的问题或建议（最多500字）"></textarea>
      <div class="count">{{ content.length }}/500</div>
      <div class="tip">提交后可在下方“我的反馈”查看记录</div>
    </section>

    <section class="panel">
      <div class="bar">
        <div class="label">我的反馈</div>
        <button class="btn" type="button" :disabled="loading" @click="reload">
          {{ loading ? "加载中..." : "刷新" }}
        </button>
      </div>

      <div v-if="!loading && list.length===0" class="empty">暂无反馈记录</div>

      <div class="items" v-else>
        <div class="item" v-for="it in list" :key="it.id">
          <div class="text">{{ it.content }}</div>
          <div class="sub">
            <span>{{ fmtTime(it.createdAt) }}</span>
            <span class="dot"></span>
            <span>{{ it.status || "已提交" }}</span>
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
import { authPost } from "@/utils/api";

const router = useRouter();
const token = computed(() => localStorage.getItem("token") || "");

function apiFetch(url, opts = {}) {
  const headers = Object.assign({}, opts.headers || {});
  if (token.value) headers.Authorization = "Bearer " + token.value;
  return fetch(url, { ...opts, headers });
}

const content = ref("");
const sending = ref(false);

const list = ref([]);
const loading = ref(false);
const loadingMore = ref(false);
const page = ref(1);
const size = 20;
const hasMore = ref(true);

function back() { router.back(); }

function fmtTime(v) {
  if (!v) return "-";
  const d = new Date(v);
  if (Number.isNaN(d.getTime())) return String(v);
  const pad = (n) => String(n).padStart(2, "0");
  return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

async function submit() {
  if (!content.value.trim()) {
    alert("请先填写反馈内容");
    return;
  }
  sending.value = true;
  try {
    const data = await authPost("/api/feedback", {
      content: content.value.trim()
    });

    if (data.code !== 200 && data.code !== 0) {
      throw new Error(data.message || "提交失败");
    }

    content.value = "";
    await reload();
    alert("提交成功");
  } catch (e) {
    alert(e.message || "提交失败");
  } finally {
    sending.value = false;
  }
}

async function fetchPage(p, append=false) {
  const resp = await apiFetch(`/api/feedback/my?page=${p}&size=${size}`);
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
  background: linear-gradient(180deg, rgba(253,251,247,0.98), rgba(253,251,247,0.95), rgba(253,251,247,0));
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(212,175,55,0.1);
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

/* 返回和提交按钮 */
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

/* 提交按钮使用金色渐变 */
.right {
  background: linear-gradient(135deg, #e6c288, #d4af37);
  color: #fff;
  border-color: rgba(212, 175, 55, 0.4);
}

.right:hover:not(:disabled) {
  background: linear-gradient(135deg, #d4af37, #c9a227);
}

.right:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  background: rgba(200, 200, 200, 0.3);
}

/* 页面标题 */
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

/* 标签文字 */
.label {
  font-size: 15px;
  font-weight: 900;
  color: #3a2e2b;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  letter-spacing: 1px;
}

/* 输入框 */
.ta {
  width: 100%;
  margin-top: 12px;
  border-radius: 16px;
  border: 1px dashed rgba(212, 175, 55, 0.25);
  background: rgba(255, 255, 255, 0.95);
  padding: 16px;
  min-height: 150px;
  outline: none;
  resize: vertical;
  font-size: 15px;
  color: #4a3b36;
  line-height: 1.6;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  transition: all 0.3s ease;
}

.ta:focus {
  border-color: rgba(212, 175, 55, 0.5);
  border-style: solid;
  box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
}

.ta::placeholder {
  color: #9d8b7a;
  font-weight: 700;
}

/* 字数统计 */
.count {
  margin-top: 8px;
  text-align: right;
  font-size: 13px;
  color: #9d8b7a;
  font-weight: 700;
}

/* 提示文字 */
.tip {
  margin-top: 10px;
  font-size: 13px;
  color: #9d8b7a;
  font-weight: 700;
  padding-left: 12px;
  border-left: 3px solid rgba(212, 175, 55, 0.3);
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

.bar .label {
  font-size: 18px;
  font-weight: 900;
  color: #3a2e2b;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  letter-spacing: 1px;
}

.bar .btn {
  height: 38px;
  padding: 0 20px;
  font-size: 14px;
}

/* 刷新/加载更多按钮 */
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

/* 空状态 */
.empty {
  padding: 60px 20px;
  text-align: center;
  background: rgba(255, 255, 255, 0.6);
  border: 1px dashed rgba(212, 175, 55, 0.2);
  border-radius: 20px;
  margin: 20px 0;
  font-size: 16px;
  color: #9d8b7a;
  font-weight: 700;
}

/* 反馈列表 */
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

.text {
  color: #4a3b36;
  line-height: 1.7;
  font-size: 15px;
}

.sub {
  margin-top: 12px;
  display: flex;
  gap: 12px;
  align-items: center;
  font-size: 13px;
  color: #9d8b7a;
  font-weight: 700;
}

.dot {
  width: 4px;
  height: 4px;
  border-radius: 999px;
  background: rgba(212, 175, 55, 0.4);
}

/* 状态标签 */
.sub span:last-child {
  padding: 4px 10px;
  border-radius: 8px;
  background: linear-gradient(135deg, #f2e9d2, #e6c288);
  color: #3a2e2b;
  border: 1px solid rgba(212, 175, 55, 0.2);
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

.space {
  height: 24px;
}
</style>