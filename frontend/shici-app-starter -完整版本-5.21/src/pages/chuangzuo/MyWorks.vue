<template>
  <div class="myWorksPage">
    <div v-if="showDeleteModal" class="modalOverlay" @click="closeDeleteModal">
      <div class="modalCard" @click.stop>
        <div class="modalTitle">确认删除</div>
        <div class="modalContent">删除后将无法恢复，确定删除这篇作品吗？</div>
        <div class="modalActions">
          <button class="modalBtn" @click="closeDeleteModal">取消</button>
          <button class="modalBtn danger" @click="confirmDelete">确认删除</button>
        </div>
      </div>
    </div>

    <div class="container">
      <header class="topbar">
        <button class="backBtn" @click="router.back()">返回</button>
        <div class="title">我的作品</div>
        <button class="newBtn" @click="goPublish">新建</button>
      </header>

      <section class="statsGrid">
        <div class="statCard">
          <div class="statValue">{{ stats.totalWorks }}</div>
          <div class="statLabel">作品总数</div>
        </div>
        <div class="statCard">
          <div class="statValue">{{ stats.totalLikes }}</div>
          <div class="statLabel">获赞总数</div>
        </div>
        <div class="statCard">
          <div class="statValue">{{ stats.totalComments }}</div>
          <div class="statLabel">评论总数</div>
        </div>
        <div class="statCard">
          <div class="statValue">{{ stats.totalViews }}</div>
          <div class="statLabel">浏览总数</div>
        </div>
      </section>

      <section class="panel controls">
        <div class="filterTabs">
          <button
            v-for="filter in filters"
            :key="filter.key"
            class="filterTab"
            :class="{ active: activeFilter === filter.key }"
            @click="switchFilter(filter.key)"
          >
            {{ filter.label }}
          </button>
        </div>

        <select v-model="sortBy" class="select" @change="fetchAll">
          <option value="time">按时间</option>
          <option value="likes">按点赞</option>
          <option value="comments">按评论</option>
          <option value="views">按浏览</option>
        </select>
      </section>

      <section v-if="loading && works.length === 0" class="panel empty">
        <div class="emptyTitle">加载中...</div>
      </section>

      <section v-else-if="works.length > 0" class="worksList">
        <article v-for="work in works" :key="work.id" class="workCard">
          <div class="workHeader" @click="goDetail(work.id)">
            <div class="workType">{{ work.typeLabel }}</div>
            <div class="workTitle">{{ work.title || "无标题" }}</div>

            <!-- 新增：图片网格显示 -->
            <div v-if="work.images && work.images.length > 0" class="workImagesGrid">
              <div
                v-for="(img, imgIdx) in work.images.slice(0, 4)"
                :key="imgIdx"
                class="workImageItem"
              >
                <img
                  :src="img"
                  alt="作品图片"
                  loading="lazy"
                  @error="handleImageError($event)"
                />
              </div>
            </div>

            <div class="workExcerpt">{{ work.excerpt }}</div>
          </div>

          <div class="workMeta">
            <span>点赞 {{ work.likeCount || 0 }}</span>
            <span>评论 {{ work.commentCount || 0 }}</span>
            <span>浏览 {{ work.viewCount || 0 }}</span>
            <span>{{ formatDate(work.createdAt) }}</span>
          </div>

          <div class="workActions">
            <button class="actionBtn" @click="editWork(work)">编辑</button>
            <button class="actionBtn danger" @click="deleteWork(work)">删除</button>
          </div>
        </article>
      </section>

      <section v-else class="panel empty">
        <div class="emptyTitle">还没有作品</div>
        <div class="emptyDesc">开始创作你的第一篇诗词作品吧</div>
        <button class="newBtn" @click="goPublish">立即创作</button>
      </section>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from "vue";
import { useRouter } from "vue-router";
import { authDelete, authGet } from "@/utils/api";
import { checkLoginStatus } from "@/utils/auth";
import { showError, showSuccess } from "@/utils/toast";

const router = useRouter();

const stats = ref({
  totalWorks: 0,
  totalLikes: 0,
  totalComments: 0,
  totalViews: 0,
});

const filters = [
  { key: "all", label: "全部" },
  { key: "poem", label: "诗词" },
  { key: "ci", label: "词牌" },
  { key: "fu", label: "赋体" },
  { key: "couplet", label: "对联" },
  { key: "modern", label: "现代诗" },
  { key: "calligraphy", label: "书法" },
];

const typeLabels = {
  poem: "诗词创作",
  ci: "词牌填词",
  fu: "赋体创作",
  couplet: "对联创作",
  modern: "现代诗歌",
  calligraphy: "书法创作",
};

const activeFilter = ref("all");
const sortBy = ref("time");
const loading = ref(false);
const works = ref([]);
const showDeleteModal = ref(false);
const workToDelete = ref(null);

function formatDate(v) {
  if (!v) return "刚刚";
  const d = new Date(v);
  if (Number.isNaN(d.getTime())) return String(v);
  const pad = (n) => (n < 10 ? "0" + n : "" + n);
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
}

const fallbackImage = 'data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200"%3E%3Crect width="200" height="200" fill="%23f4efe4"/%3E%3Ctext x="100" y="100" text-anchor="middle" fill="%23997b59" font-size="16"%3E图片加载失败%3C/text%3E%3C/svg%3E';

function handleImageError(event) {
  event.target.src = fallbackImage;
  event.target.onerror = null; // 防止无限循环
}

function normalizeWork(w) {
  // 优先使用后端处理好的 imageUrls，如果没有则尝试解析 images 字段
  let images = w.imageUrls || w.images || [];

  if (typeof images === "string") {
    try {
      images = JSON.parse(images);
    } catch {
      images = [];
    }
  }

  return {
    ...w,
    images: Array.isArray(images) ? images : [],
    typeLabel: typeLabels[w.type] || "创作",
    excerpt: w.excerpt || (w.content ? w.content.slice(0, 100) + (w.content.length > 100 ? "..." : "") : ""),
  };
}

async function fetchWorks() {
  loading.value = true;
  try {
    const data = await authGet(
      `/api/creations/my?type=${encodeURIComponent(activeFilter.value)}&sortBy=${encodeURIComponent(sortBy.value)}`
    );
    if (data.code === 0 || data.code === 200) {
      works.value = (data.data?.list || []).map(normalizeWork);
    } else {
      works.value = [];
      showError(data.message || data.msg || "获取作品失败");
    }
  } catch (e) {
    console.error("获取作品失败：", e);
    showError(e.message || "获取作品失败");
  } finally {
    loading.value = false;
  }
}

async function fetchStats() {
  try {
    const data = await authGet("/api/creations/my/stats");
    if (data.code === 0 || data.code === 200) {
      stats.value = {
        totalWorks: data.data?.totalWorks || 0,
        totalLikes: data.data?.totalLikes || 0,
        totalComments: data.data?.totalComments || 0,
        totalViews: data.data?.totalViews || 0,
      };
    }
  } catch (e) {
    console.error("获取统计失败：", e);
  }
}

async function fetchAll() {
  await Promise.all([fetchWorks(), fetchStats()]);
}

function switchFilter(key) {
  activeFilter.value = key;
  fetchAll();
}

function goDetail(id) {
  router.push(`/chuangzuo/${id}`);
}

function goPublish() {
  router.push("/chuangzuo/publish");
}

function editWork(work) {
  router.push(`/chuangzuo/edit/${work.id}`);
}

function deleteWork(work) {
  workToDelete.value = work;
  showDeleteModal.value = true;
}

function closeDeleteModal() {
  showDeleteModal.value = false;
  workToDelete.value = null;
}

async function confirmDelete() {
  if (!workToDelete.value) return;
  try {
    const data = await authDelete(`/api/creations/${workToDelete.value.id}`);
    if (data.code === 0 || data.code === 200) {
      showSuccess("删除成功");
      closeDeleteModal();
      fetchAll();
    } else {
      showError(data.message || data.msg || "删除失败");
    }
  } catch (e) {
    console.error("删除失败：", e);
    showError(e.message || "删除失败");
  }
}

onMounted(() => {
  if (!checkLoginStatus(router)) return;
  fetchAll();
});
</script>

<style scoped>
.myWorksPage{
  min-height:100vh;
  background:
    radial-gradient(1200px 800px at 20% 10%, rgba(180, 200, 220, 0.08), transparent 60%),
    radial-gradient(900px 600px at 80% 20%, rgba(230, 220, 190, 0.12), transparent 55%),
    linear-gradient(135deg, #fdfbf7, #f5f3ef);
  padding-bottom:48px;
  position:relative
}

.myWorksPage::before{
  content:"";
  position:fixed;
  inset:0;
  background:url("@/assets/chuangzuo/竹.png");
  background-size:25%;
  opacity:0.06;
  pointer-events:none;
  z-index:-3
}

.container{
  width:100%;
  max-width:none;
  margin:0 auto;
  padding:0 48px;
  position:relative;
  z-index:1
}

@media (min-width: 1600px){
  .container{padding:0 64px}
}

@media (min-width: 1200px) and (max-width: 1599px){
  .container{padding:0 56px}
}

@media (min-width: 1024px) and (max-width: 1199px){
  .container{padding:0 48px}
}

@media (min-width: 768px) and (max-width: 1023px){
  .container{padding:0 32px}
}

@media (max-width: 767px){
  .container{padding:0 16px}
}

.topbar{
  position:sticky;
  top:0;
  z-index:100;
  display:flex;
  justify-content:space-between;
  align-items:center;
  padding:20px 0;
  background:linear-gradient(180deg,rgba(253,251,247,0.98),rgba(253,251,247,0.95),rgba(253,251,247,0));
  backdrop-filter:blur(10px);
  border-bottom:1px solid rgba(212,175,55,0.1)
}

.title{
  font-size:26px;
  font-weight:900;
  color:#3a2e2b;
  font-family:"思源宋体","STSong","SimSun",serif;
  letter-spacing:2px
}

.backBtn,.newBtn,.filterTab,.actionBtn,.modalBtn{cursor:pointer}
.backBtn,.newBtn,.filterTab,.actionBtn,.select{
  border:1px solid rgba(212,175,55,0.3);
  background:linear-gradient(135deg, rgba(253,249,242,0.9), rgba(246,240,230,0.8));
  border-radius:12px;
  padding:12px 20px;
  font-weight:900;
  color:#4a3b36;
  transition:all 0.3s ease
}

.backBtn:hover,.actionBtn:hover{
  background:linear-gradient(135deg, rgba(242,233,210,0.9), rgba(230,194,136,0.8));
  border-color:rgba(212,175,55,0.5);
  transform:translateY(-1px)
}

.newBtn{
  background:linear-gradient(135deg, #d4af37, #b8860b);
  color:#fff;
  border-color:rgba(212,175,55,0.4)
}

.newBtn:hover{
  background:linear-gradient(135deg, #b8860b, #9a7209);
  transform:translateY(-1px);
  box-shadow:0 4px 12px rgba(212,175,55,0.3)
}

.panel{
  background:rgba(255,255,255,0.85);
  border:1px solid rgba(212,175,55,0.15);
  border-radius:18px;
  padding:20px;
  margin-bottom:16px;
  box-shadow:0 4px 16px rgba(212,175,55,0.08)
}

.statsGrid{
  display:grid;
  grid-template-columns:repeat(auto-fit,minmax(200px,1fr));
  gap:16px;
  margin-bottom:24px;
  padding:16px 0
}

@media (min-width: 1200px){
  .statsGrid{grid-template-columns:repeat(4,1fr)}
}

.statCard{
  background:linear-gradient(135deg, rgba(255,255,255,0.95), rgba(253,249,242,0.9));
  border:1px solid rgba(212,175,55,0.2);
  border-radius:16px;
  padding:20px;
  text-align:center;
  box-shadow:0 4px 12px rgba(212,175,55,0.08),inset 0 1px 0 rgba(255,255,255,0.8);
  position:relative;
  overflow:hidden;
  transition:all 0.3s ease
}

.statCard:hover{
  transform:translateY(-2px);
  box-shadow:0 6px 16px rgba(212,175,55,0.12)
}

.statCard::after{
  content:"诗词";
  position:absolute;
  bottom:8px;
  right:8px;
  font-size:10px;
  color:rgba(212,175,55,0.2);
  font-weight:900;
  writing-mode:vertical-rl
}

.statValue{
  font-size:28px;
  font-weight:900;
  color:#d4af37;
  font-family:"思源宋体","STSong","SimSun",serif
}

.statLabel{
  font-size:14px;
  color:#9d8b7a;
  margin-top:8px;
  font-weight:700
}

.controls{
  display:flex;
  justify-content:space-between;
  align-items:center;
  gap:16px;
  flex-wrap:wrap;
  padding:16px 0;
  margin:16px 0
}

.filterTabs{
  display:flex;
  flex-wrap:wrap;
  gap:10px
}

.filterTab{
  padding:12px 20px;
  border:1px solid rgba(212,175,55,0.2);
  background:rgba(255,255,255,0.8);
  border-radius:12px;
  cursor:pointer;
  transition:all 0.3s ease;
  font-weight:700;
  color:#4a3b36
}

.filterTab:hover{
  border-color:rgba(212,175,55,0.4);
  background:rgba(253,249,242,0.9)
}

.filterTab.active{
  background:linear-gradient(135deg, #d4af37, #b8860b);
  color:#fff;
  border-color:transparent
}

.select{
  padding:12px 16px;
  border:1px solid rgba(212,175,55,0.2);
  background:rgba(255,255,255,0.8);
  border-radius:12px;
  color:#4a3b36;
  font-weight:700;
  cursor:pointer;
  outline:none
}

.worksList{
  display:grid;
  grid-template-columns:repeat(auto-fill,minmax(320px,1fr));
  gap:20px;
  padding:16px 0
}

@media (min-width: 1400px){
  .worksList{grid-template-columns:repeat(auto-fill,minmax(360px,1fr))}
}

@media (min-width: 1024px) and (max-width: 1399px){
  .worksList{grid-template-columns:repeat(auto-fill,minmax(320px,1fr))}
}

@media (min-width: 768px) and (max-width: 1023px){
  .worksList{grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:16px}
}

@media (max-width: 767px){
  .worksList{grid-template-columns:1fr}
}

.workCard{
  background:rgba(255,255,255,0.95);
  border:1px solid rgba(212,175,55,0.15);
  border-radius:16px;
  padding:20px;
  box-shadow:0 4px 16px rgba(212,175,55,0.08);
  transition:all 0.3s ease;
  position:relative;
  overflow:hidden
}

.workCard::before{
  content:"";
  position:absolute;
  top:0;
  left:0;
  width:4px;
  height:100%;
  background:linear-gradient(180deg, #d4af37, #b8860b)
}

.workCard:hover{
  transform:translateY(-4px);
  box-shadow:0 8px 24px rgba(212,175,55,0.15);
  border-color:rgba(212,175,55,0.3)
}

.workHeader{
  cursor:pointer
}

.workType{
  display:inline-flex;
  padding:6px 12px;
  border-radius:999px;
  background:linear-gradient(135deg, rgba(212,175,55,0.15), rgba(184,134,11,0.1));
  color:#b8860b;
  font-size:12px;
  font-weight:800;
  border:1px solid rgba(212,175,55,0.2)
}

.workTitle{
  font-size:18px;
  font-weight:900;
  margin:12px 0;
  color:#3a2e2b;
  font-family:"思源宋体","STSong","SimSun",serif
}

.workImagesGrid{
  display:grid;
  grid-template-columns:repeat(4,1fr);
  gap:8px;
  margin:12px 0
}

@media (max-width:768px){
  .workImagesGrid{
    grid-template-columns:repeat(2,1fr)
  }
}

.workImageItem{
  aspect-ratio:1;
  border-radius:8px;
  overflow:hidden;
  background:rgba(212,175,55,0.1);
  border:1px solid rgba(212,175,55,0.15)
}

.workImageItem img{
  width:100%;
  height:100%;
  object-fit:cover;
  transition:transform 0.3s ease
}

.workImageItem:hover img{
  transform:scale(1.05)
}

.workExcerpt{
  color:#4a3b36;
  line-height:1.8;
  font-size:14px
}

.workMeta{
  display:flex;
  flex-wrap:wrap;
  gap:14px;
  color:#9d8b7a;
  font-size:13px;
  margin-top:12px;
  padding-top:12px;
  border-top:1px dashed rgba(212,175,55,0.15)
}

.workActions{
  display:flex;
  gap:10px;
  margin-top:16px
}

.actionBtn.danger{
  color:#c94a4a;
  border-color:rgba(201,74,74,0.3);
  background:linear-gradient(135deg, rgba(255,240,240,0.9), rgba(255,220,220,0.8))
}

.actionBtn.danger:hover{
  border-color:rgba(201,74,74,0.5);
  background:linear-gradient(135deg, rgba(255,220,220,0.9), rgba(255,200,200,0.8))
}

.empty{
  text-align:center;
  padding:60px 20px;
  background:rgba(255,255,255,0.6);
  border:1px dashed rgba(212,175,55,0.2);
  border-radius:20px;
  margin:20px 0
}

.emptyTitle{
  font-size:20px;
  font-weight:900;
  color:#4a3b36;
  margin-bottom:12px;
  font-family:"思源宋体","STSong","SimSun",serif
}

.emptyDesc{
  color:#9d8b7a;
  margin-bottom:20px;
  font-size:15px
}

.modalOverlay{
  position:fixed;
  inset:0;
  background:rgba(0,0,0,0.4);
  backdrop-filter:blur(4px);
  display:grid;
  place-items:center;
  z-index:1000
}

.modalCard{
  width:min(400px,92vw);
  background:linear-gradient(135deg, rgba(255,255,255,0.98), rgba(253,249,242,0.95));
  border:1px solid rgba(212,175,55,0.2);
  border-radius:20px;
  padding:24px;
  box-shadow:0 20px 60px rgba(0,0,0,0.2)
}

.modalTitle{
  font-size:20px;
  font-weight:900;
  margin-bottom:12px;
  color:#3a2e2b;
  font-family:"思源宋体","STSong","SimSun",serif
}

.modalContent{
  color:#4a3b36;
  line-height:1.8;
  font-size:15px
}

.modalActions{
  display:flex;
  justify-content:flex-end;
  gap:12px;
  margin-top:20px
}

.modalBtn{
  border:1px solid rgba(212,175,55,0.3);
  background:linear-gradient(135deg, rgba(253,249,242,0.9), rgba(246,240,230,0.8));
  border-radius:12px;
  padding:12px 20px;
  font-weight:900;
  color:#4a3b36;
  transition:all 0.3s ease
}

.modalBtn.danger{
  background:linear-gradient(135deg, #c94a4a, #a83232);
  color:#fff;
  border-color:transparent
}

.modalBtn:hover{
  transform:translateY(-1px)
}

@media (max-width:768px){
  .statsGrid{grid-template-columns:repeat(2,1fr)}
  .controls{flex-direction:column;align-items:flex-start}
  .filterTabs{width:100%}
  .select{width:100%}
  .title{font-size:22px}
  .backBtn,.newBtn{padding:10px 16px}
}
</style>