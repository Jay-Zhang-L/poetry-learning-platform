<template>
  <div class="page">
    <header class="navBar">
      <button type="button" class="navBack" @click="goBack">‹</button>
      <span class="navTitle">答题记录</span>
      <span class="navSpacer" />
    </header>

    <div v-if="summary" class="summary">
      <div class="sumItem">
        <div class="sumVal">{{ summary.total_attempts ?? 0 }}</div>
        <div class="sumLab">总次数</div>
      </div>
      <div class="sumItem">
        <div class="sumVal">{{ summary.correct_count ?? 0 }}</div>
        <div class="sumLab">正确</div>
      </div>
      <div class="sumItem">
        <div class="sumVal">{{ summary.accuracy ?? 0 }}%</div>
        <div class="sumLab">正确率</div>
      </div>
    </div>

    <div v-if="err" class="banner">{{ err }}</div>
    <div v-else-if="loading" class="banner">加载中…</div>

    <ul v-else class="list">
      <li v-for="r in records" :key="r.record_id" class="item">
        <div class="itemTop">
          <span class="badge" :class="r.is_correct ? 'ok' : 'bad'">
            {{ r.is_correct ? "对" : "错" }}
          </span>
          <span class="when">{{ r.created_at }}</span>
        </div>
        <p class="content">{{ r.content }}</p>
        <div class="names">
          <span>你选：<b>{{ r.selected_poet_name }}</b></span>
          <span>答案：<b>{{ r.correct_poet_name }}</b></span>
        </div>
      </li>
      <li v-if="!records.length" class="empty">暂无记录</li>
    </ul>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useRouter } from "vue-router";
import { fetchUserRecords } from "@/utils/poetMomentsApi";

const router = useRouter();
const loading = ref(true);
const err = ref("");
const payload = ref(null);

const summary = computed(() => payload.value || null);
const records = computed(() => {
  const list = payload.value?.records;
  return Array.isArray(list) ? list : [];
});

function currentUserId() {
  try {
    const u = JSON.parse(localStorage.getItem("user") || "{}");
    return u.id != null ? String(u.id) : "guest";
  } catch {
    return "guest";
  }
}

function goBack() {
  router.push("/game/poet-moments").catch(() => {});
}

async function load() {
  loading.value = true;
  err.value = "";
  try {
    const res = await fetchUserRecords(currentUserId());
    payload.value = res?.data || null;
  } catch (e) {
    err.value = e?.message || "加载失败";
    payload.value = null;
  } finally {
    loading.value = false;
  }
}

onMounted(load);
</script>

<style scoped>
.page {
  min-height: 100vh;
  background: #ededed;
}

.navBar {
  position: sticky;
  top: 0;
  z-index: 10;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 44px;
  background: #393a3f;
  color: #fff;
  font-size: 17px;
  font-weight: 600;
}
.navBack {
  position: absolute;
  left: 0;
  height: 44px;
  padding: 0 14px;
  border: none;
  background: transparent;
  color: #fff;
  font-size: 22px;
  line-height: 44px;
  cursor: pointer;
}
.navSpacer {
  position: absolute;
  right: 0;
  width: 44px;
}

.summary {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1px;
  background: #d9d9d9;
  margin: 0;
}
.sumItem {
  background: #fff;
  padding: 14px 8px;
  text-align: center;
}
.sumVal {
  font-size: 22px;
  font-weight: 800;
  color: #000;
}
.sumLab {
  font-size: 12px;
  color: #888;
  margin-top: 4px;
}

.banner {
  margin: 12px 16px;
  padding: 12px;
  background: #fff;
  color: #666;
  text-align: center;
  font-size: 14px;
}

.list {
  list-style: none;
  margin: 0;
  padding: 0 0 24px;
}

.item {
  background: #fff;
  padding: 14px 16px;
  border-bottom: 1px solid #e5e5e5;
}
.itemTop {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}
.badge {
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 4px;
  font-weight: 700;
}
.badge.ok {
  background: #e8f5e9;
  color: #2e7d32;
}
.badge.bad {
  background: #ffebee;
  color: #c62828;
}
.when {
  font-size: 12px;
  color: #b2b2b2;
}
.content {
  margin: 0;
  font-size: 15px;
  line-height: 1.5;
  color: #333;
  display: -webkit-box;
  -webkit-line-clamp: 4;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.names {
  margin-top: 10px;
  font-size: 13px;
  color: #666;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.empty {
  padding: 40px;
  text-align: center;
  color: #999;
  background: #fff;
}
</style>
