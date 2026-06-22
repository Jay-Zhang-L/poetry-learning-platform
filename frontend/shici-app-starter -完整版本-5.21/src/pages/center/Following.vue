<template>
  <div class="page">
    <header class="head">
      <button class="back" type="button" @click="back">返回</button>
      <div class="title">关注</div>
      <button class="right" type="button" :disabled="loading" @click="reload">
        {{ loading ? "加载中..." : "刷新" }}
      </button>
    </header>

    <section class="panel">
      <div v-if="!loading && list.length===0" class="empty">暂无关注</div>

      <div class="items" v-else>
        <div class="item" v-for="u in list" :key="u.id">
          <div class="avatar" @click="openUser(u)">
            <img v-if="u.avatarUrl" :src="u.avatarUrl" alt="" />
            <span v-else>{{ (u.nickname || u.username || "U").slice(0,1) }}</span>
          </div>
          <div class="meta" @click="openUser(u)">
            <div class="name">{{ u.nickname || u.username || "用户" }}</div>
            <div class="sub">{{ u.bio || "这个人很懒，还没有简介" }}</div>
          </div>
          <button
            v-if="followRelationsStore.isMutualFollow(u.id)"
            class="btn mutual"
            type="button"
            disabled
          >
            互相关注
          </button>
          <button
            v-else
            class="btn danger"
            type="button"
            @click="unfollow(u)"
          >
            取消关注
          </button>
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
import { useFollowRelationsStore } from "@/stores/followRelations";

const router = useRouter();
const followRelationsStore = useFollowRelationsStore();
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
function openUser(u){
  // 跳转到作者主页
  router.push(`/author/${u.id}`);
}

async function fetchPage(p, append=false) {
  const resp = await apiFetch(`/api/user/following?page=${p}&size=${size}`);
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

async function unfollow(u) {
  if (!confirm(`确认取消关注 ${u.nickname || u.username || "该用户"}？`)) return;
  try {
    const resp = await apiFetch(`/api/user/follow/${u.id}`, {
      method: "DELETE",
    });
    const json = await resp.json().catch(() => null);
    if (!resp.ok || !json || json.code !== 0) throw new Error((json && json.msg) || "操作失败");

    // ✅ 更新全局状态
    followRelationsStore.removeFollowing(u.id);

    list.value = list.value.filter(x => x.id !== u.id);
  } catch (e) {
    alert(e.message || "操作失败");
  }
}

async function initFollowRelations() {
  if (!token.value) return;

  try {
    // 并行加载关注和粉丝列表数据，初始化全局状态
    const [followingRes, followersRes] = await Promise.all([
      apiFetch('/api/user/following?page=1&size=100'),
      apiFetch('/api/user/followers?page=1&size=100')
    ]);

    const followingData = await followingRes.json();
    const followersData = await followersRes.json();

    // 初始化全局状态
    if (followingData.code === 0 && followersData.code === 0) {
      followRelationsStore.initFromAPI({
        following: followingData.data?.items || [],
        followers: followersData.data?.items || []
      });
    }
  } catch (e) {
    console.error('初始化关注关系失败：', e);
  }
}

onMounted(() => {
  if (!token.value) return router.replace("/login");
  // 先初始化关注关系，再加载数据
  initFollowRelations();
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
  z-index: 100;
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
  grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
  gap: 16px;
  padding: 16px 0
}

@media (min-width: 1400px) {
  .items { grid-template-columns: repeat(auto-fill, minmax(440px, 1fr)) }
}

@media (min-width: 1024px) and (max-width: 1399px) {
  .items { grid-template-columns: repeat(auto-fill, minmax(400px, 1fr)) }
}

@media (min-width: 768px) and (max-width: 1023px) {
  .items { grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 14px }
}

@media (max-width: 767px) {
  .items { grid-template-columns: 1fr }
}

.item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  padding: 20px;
  border-radius: 16px;
  border: 1px solid rgba(212,175,55,0.15);
  background: rgba(255,255,255,0.95);
  box-shadow: 0 4px 16px rgba(212,175,55,0.08);
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
  text-align: center
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

.avatar {
  width: 72px;
  height: 72px;
  border-radius: 999px;
  overflow: hidden;
  background: linear-gradient(135deg, rgba(212,175,55,0.15), rgba(184,134,11,0.1));
  border: 2px solid rgba(212,175,55,0.3);
  display: grid;
  place-items: center;
  cursor: pointer;
  flex: 0 0 auto;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(212,175,55,0.1)
}

.avatar:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(212,175,55,0.2)
}

.avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover
}

.avatar span {
  font-weight: 900;
  color: #b8860b;
  font-size: 24px
}

.meta {
  flex: 1;
  min-width: 0;
  cursor: pointer;
  width: 100%
}

.name {
  font-weight: 900;
  color: #3a2e2b;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-size: 16px;
  margin-bottom: 6px
}

.sub {
  font-size: 13px;
  color: #9d8b7a;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  margin-bottom: 12px
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

.btn.danger {
  border-color: rgba(201,74,74,0.3);
  background: linear-gradient(135deg, rgba(255,240,240,0.9), rgba(255,220,220,0.8));
  color: #c94a4a
}

.btn.danger:hover {
  background: linear-gradient(135deg, rgba(255,220,220,0.9), rgba(255,200,200,0.8));
  border-color: rgba(201,74,74,0.5)
}

.btn.mutual {
  background: linear-gradient(135deg, #d4af37, #b8860b);
  color: white;
  border-color: rgba(212, 175, 55, 0.4);
  cursor: default;
}

.btn.mutual:hover {
  transform: none;
  box-shadow: none;
}

.btn.mutual:disabled {
  opacity: 1;
  cursor: not-allowed;
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
  .avatar { width: 64px; height: 64px }
  .avatar span { font-size: 20px }
}
</style>