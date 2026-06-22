<template>
  <div class="authorPage">
    <header class="hero">
      <button class="iconBtn backBtn" type="button" @click="$router.back()">返回</button>

      <div class="cover" :style="coverStyle"></div>
      <div class="coverShade"></div>

      <div class="heroMain">
        <div class="avatarWrap">
          <img v-if="detail?.user?.avatarUrl" class="avatar" :src="fullUrl(detail.user.avatarUrl)" alt="" />
          <div v-else class="avatar placeholder">
            <span class="avatarText">{{ avatarText }}</span>
          </div>
        </div>

        <div class="meta">
          <div class="nameRow">
            <div class="name">{{ detail?.user?.nickname || "未命名用户" }}</div>
            <span class="chip nameTag" v-if="detail?.user?.role">{{ roleText(detail.user.role) }}</span>
          </div>

          <div class="subRow">
            <span class="chip">@{{ detail?.user?.username || "unknown" }}</span>
          </div>

          <div class="bio">{{ detail?.user?.bio || "这个人很懒，还没有简介" }}</div>

          <div class="statsLine">
            <button type="button" class="statItem">
              <span class="num">{{ detail?.user?.likeCount || 0 }}</span>
              <span class="lbl">获赞</span>
            </button>
            <span class="sep"></span>
            <button type="button" class="statItem">
              <span class="num">{{ detail?.user?.followingCount || 0 }}</span>
              <span class="lbl">关注</span>
            </button>
            <span class="sep"></span>
            <button type="button" class="statItem">
              <span class="num">{{ detail?.user?.followerCount || 0 }}</span>
              <span class="lbl">粉丝</span>
            </button>
          </div>

          <div class="ops">
            <button v-if="detail?.isSelf" type="button" class="btn primary" @click="goMyProfile">编辑资料</button>
            <template v-else>
              <button type="button" class="btn" :class="{ primary: !detail?.followed }" @click="toggleFollow" :disabled="followLoading">
                {{ followLoading ? "处理中..." : detail?.followed ? "已关注" : "关注" }}
              </button>
              <button type="button" class="btn" @click="toChat" title="私信功能开发中">💬 私信</button>
            </template>
          </div>
        </div>
      </div>
    </header>

    <section class="panel worksPanel">
      <div class="sectionHead">
        <h3 class="sectionTitle">TA 的作品</h3>
        <span class="sectionCount">共 {{ works.length }} 篇</span>
      </div>

      <div v-if="loading" class="emptyState">正在加载...</div>
      <div v-else-if="!works.length" class="emptyState">暂无作品</div>

      <div v-else class="worksGrid">
        <div v-for="item in works" :key="item.id" class="workCard" @click="goDetail(item.id)">
          <div class="workHeader">
            <span class="typeBadge">{{ typeText(item.type) }}</span>
            <span class="timeText">{{ formatTime(item.createdAt) }}</span>
          </div>

          <div class="workTitle">{{ item.title || "无标题" }}</div>

          <!-- 新增：图片网格显示 -->
          <div v-if="item.imageUrls && item.imageUrls.length > 0" class="workImagesGrid">
            <div
              v-for="(img, imgIdx) in item.imageUrls.slice(0, 4)"
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

          <div class="workContent">{{ item.content || "暂无内容" }}</div>

          <div class="workStats">
            <span class="stat">👍 {{ item.likeCount || 0 }}</span>
            <span class="stat">💬 {{ item.commentCount || 0 }}</span>
            <span class="stat">👁️ {{ item.viewCount || 0 }}</span>
          </div>
        </div>
      </div>
    </section>

    <div class="safeBottom"></div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { authGet, authPost, authDelete } from "@/utils/api";

const API = "http://localhost:8080";
const route = useRoute();
const router = useRouter();

const detail = ref(null);
const works = ref([]);
const loading = ref(false);
const followLoading = ref(false);

const fallbackImage = 'data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200"%3E%3Crect width="200" height="200" fill="%23f4efe4"/%3E%3Ctext x="100" y="100" text-anchor="middle" fill="%23997b59" font-size="16"%3E图片加载失败%3C/text%3E%3C/svg%3E';

function handleImageError(event) {
  event.target.src = fallbackImage;
  event.target.onerror = null; // 防止无限循环
}

function isSuccess(res) {
  return res && (res.code === 0 || res.code === 200);
}

function fullUrl(path) {
  if (!path) return "";
  if (path.startsWith("http://") || path.startsWith("https://")) return path;
  return API + path;
}

function roleText(role) {
  if (role === "student") return "学生";
  if (role === "teacher") return "教师";
  return role || "用户";
}

function typeText(type) {
  const map = {
    poem: "诗词创作",
    ci: "词牌填词",
    fu: "赋体创作",
    couplet: "对联创作",
    modern: "现代诗歌",
    calligraphy: "书法创作",
  };
  return map[type] || "创作作品";
}

function formatTime(v) {
  if (!v) return "";
  return String(v).replace("T", " ").slice(0, 16);
}

function normalizeWorks(list) {
  if (!Array.isArray(list)) return [];
  return list.map((item) => ({
    ...item,
    likeCount: Number(item.likeCount || 0),
    commentCount: Number(item.commentCount || 0),
    saveCount: Number(item.saveCount || 0),
    viewCount: Number(item.viewCount || 0),
    // 优先使用后端处理好的 imageUrls，如果没有则尝试解析 images
    imageUrls: item.imageUrls || (typeof item.images === 'string' ? JSON.parse(item.images || '[]') : item.images || []),
  }));
}

async function loadAuthor() {
  const id = route.params.id;
  const res = await authGet(`${API}/api/user/profile/${id}`);
  if (isSuccess(res)) {
    detail.value = res.data;
  } else {
    throw new Error(res.msg || res.message || "加载作者信息失败");
  }
}

async function loadWorks() {
  const id = route.params.id;
  const res = await authGet(`${API}/api/creations/user/${id}`);

  if (isSuccess(res)) {
    works.value = normalizeWorks(res.data?.list || []);
  } else {
    works.value = [];
  }
}

async function toggleFollow() {
  if (!detail.value) return;

  const id = route.params.id;
  followLoading.value = true;

  try {
    let res;
    if (detail.value.followed) {
      res = await authDelete(`${API}/api/user/follow/${id}`);
    } else {
      res = await authPost(`${API}/api/user/follow/${id}`, {});
    }

    if (!isSuccess(res)) {
      throw new Error(res.msg || res.message || "操作失败");
    }

    await loadAuthor();
  } catch (e) {
    alert(e.message || "操作失败");
  } finally {
    followLoading.value = false;
  }
}

function goMyProfile() {
  router.push("/center/profile");
}

function goDetail(id) {
  router.push(`/chuangzuo/${id}`);
}

function toChat() {
  if (!detail.value) return;
  if (!detail.value.followed) {
    alert("请先关注对方，后续可扩展为互关后私信");
    return;
  }
  router.push(`/chat/${detail.value.user.id}`);
}

const avatarText = computed(() => {
  const n = detail.value?.user?.nickname || detail.value?.user?.username || "我";
  return n.slice(0, 1);
});

const coverStyle = computed(() => {
  if (detail.value?.user?.coverUrl) return `background-image:url(${fullUrl(detail.value.user.coverUrl)});`;
  return `
    background-image:
      radial-gradient(900px 450px at 10% 30%, rgba(255,255,255,.22), transparent 60%),
      radial-gradient(700px 420px at 80% 10%, rgba(255,255,255,.18), transparent 60%),
      linear-gradient(120deg, rgba(20,22,30,.96), rgba(18,20,28,.86), rgba(20,22,30,.96));
  `;
});

async function init() {
  loading.value = true;
  try {
    await Promise.all([loadAuthor(), loadWorks()]);
  } catch (e) {
    alert(e.message || "加载失败");
  } finally {
    loading.value = false;
  }
}

onMounted(init);

watch(
  () => route.params.id,
  () => {
    init();
  }
);
</script>

<style scoped>
.authorPage {
  min-height: 100vh;
  position: relative;
  background: var(--bg0);
  color: var(--text);
}

/* 水墨晕染 + 浅竹纹质感 */
.authorPage::before {
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
.authorPage::after {
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

.hero {
  position: relative;
  height: 360px;
  overflow: visible;
  margin: 0;
  width: 100%;
  z-index: 2;
  display: flex;
  align-items: center;
  justify-content: flex-start;
}

@media (max-width: 768px) {
  .hero { height: 320px }
}

@media (max-width: 480px) {
  .hero { height: 280px }
}

/* 返回按钮 */
.backBtn {
  position: absolute;
  top: 16px;
  left: 48px;
  z-index: 10;
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

.backBtn:hover {
  background: linear-gradient(135deg, rgba(242, 233, 210, 0.9), rgba(230, 194, 136, 0.8));
  border-color: rgba(212, 175, 55, 0.5);
  transform: translateY(-1px);
}

@media (min-width: 1600px) {
  .backBtn { left: 64px }
}

@media (min-width: 1200px) and (max-width: 1599px) {
  .backBtn { left: 56px }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .backBtn { left: 32px }
}

@media (max-width: 767px) {
  .backBtn { left: 16px }
}

/* 用户信息区 */
.heroMain {
  position: relative;
  z-index: 2;
  display: grid;
  grid-template-columns: auto 1fr;
  gap: 16px;
  padding: 24px 48px;
  align-items: center;
  pointer-events: auto;
  justify-content: start;
  width: 100%;
  margin: 0;
}

@media (min-width: 1600px) {
  .heroMain { padding: 24px 64px }
}

@media (min-width: 1200px) and (max-width: 1599px) {
  .heroMain { padding: 24px 56px }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .heroMain { padding: 20px 32px }
}

@media (max-width: 767px) {
  .heroMain {
    padding: 20px;
    grid-template-columns: 1fr;
    gap: 20px;
    text-align: center;
  }
}

/* 封面层 */
.cover,
.coverShade {
  pointer-events: none;
}

.cover {
  position: absolute;
  inset: 0;
  background-size: cover;
  background-position: center;
  transform: scale(1.02);
  filter: saturate(0.95) brightness(0.95);
}

.coverShade {
  position: absolute;
  inset: 0;
  background: transparent;
}

.avatarWrap {
  width: 100px;
  height: 100px;
  border-radius: 999px;
  overflow: hidden;
  border: 2px solid rgba(212, 175, 55, 0.4);
  box-shadow: 0 4px 12px rgba(212, 175, 55, 0.2);
  background: rgba(255, 255, 255, 0.9);
  position: relative;
  margin-top: 0;
  z-index: 3;
  transition: all 0.3s ease;
}

@media (min-width: 768px) and (max-width: 1199px) {
  .avatarWrap {
    width: 110px;
    height: 110px;
  }
}

@media (min-width: 1200px) {
  .avatarWrap {
    width: 120px;
    height: 120px;
    border-width: 3px;
  }
}

@media (min-width: 1600px) {
  .avatarWrap {
    width: 130px;
    height: 130px;
  }
}

@media (max-width: 767px) {
  .avatarWrap {
    width: 90px;
    height: 90px;
    margin-top: -20px;
  }
}

/* 印章效果 */
.avatarWrap::after {
  content: "诗";
  position: absolute;
  bottom: 2px;
  right: 2px;
  width: 24px;
  height: 24px;
  border-radius: 4px;
  background: rgba(212, 175, 55, 0.2);
  color: #3a2e2b;
  font-size: 12px;
  font-weight: 900;
  display: grid;
  place-items: center;
  border: 1px solid rgba(212, 175, 55, 0.3);
}

.avatar {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar.placeholder {
  display: grid;
  place-items: center;
  background: rgba(212, 175, 55, 0.1);
}

.avatarText {
  font-weight: 900;
  font-size: 28px;
  color: #4a3b36;
}

@media (min-width: 1200px) {
  .avatarText { font-size: 32px }
}

@media (min-width: 1600px) {
  .avatarText { font-size: 36px }
}

.meta {
  min-width: 0;
  color: #3a2e2b;
  margin-top: 0;
}

.nameRow {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 8px;
  flex-wrap: wrap;
}

@media (max-width: 767px) {
  .nameRow { justify-content: center }
}

.name {
  font-size: 20px;
  font-weight: 900;
  letter-spacing: 1px;
  color: #3a2e2b;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

@media (min-width: 1200px) {
  .name {
    font-size: 24px;
    letter-spacing: 2px;
  }
}

@media (min-width: 1600px) {
  .name { font-size: 28px }
}

.chip {
  font-size: 12px;
  padding: 4px 10px;
  border-radius: 12px;
  background: linear-gradient(135deg, #f2e9d2, #e6c288);
  color: #3a2e2b;
  border: 1px solid rgba(212, 175, 55, 0.2);
  font-weight: 700;
}

.nameTag {
  flex-shrink: 0;
}

.subRow {
  margin-top: 8px;
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

@media (max-width: 767px) {
  .subRow { justify-content: center }
}

.bio {
  margin-top: 10px;
  font-size: 13px;
  color: #4a3b36;
  line-height: 1.6;
  max-width: 560px;
  opacity: 0.85;
}

@media (min-width: 1200px) {
  .bio {
    font-size: 14px;
    max-width: 680px;
  }
}

@media (min-width: 1600px) {
  .bio {
    font-size: 15px;
    max-width: 800px;
  }
}

@media (max-width: 767px) {
  .bio { margin: 10px auto }
}

.statsLine {
  margin-top: 16px;
  display: flex;
  align-items: center;
  gap: 24px;
  padding: 0;
}

@media (min-width: 1200px) {
  .statsLine {
    gap: 32px;
    margin-top: 20px;
  }
}

@media (min-width: 1600px) {
  .statsLine { gap: 40px }
}

@media (max-width: 767px) {
  .statsLine { justify-content: center }
}

.statItem {
  border: 0;
  background: transparent;
  color: #4a3b36;
  cursor: default;
  display: inline-flex;
  align-items: baseline;
  gap: 6px;
  padding: 0;
}

.statItem .num {
  font-weight: 900;
  font-size: 22px;
  color: #d4af37;
}

@media (min-width: 1200px) {
  .statItem .num { font-size: 26px }
}

@media (min-width: 1600px) {
  .statItem .num { font-size: 30px }
}

.statItem .lbl {
  font-size: 13px;
  color: #9d8b7a;
  font-weight: 700;
}

@media (min-width: 1200px) {
  .statItem .lbl { font-size: 14px }
}

.sep {
  width: 1px;
  height: 20px;
  background: rgba(212, 175, 55, 0.3);
}

.ops {
  margin-top: 16px;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

@media (max-width: 767px) {
  .ops { justify-content: center }
}

.btn {
  border-radius: 12px;
  padding: 9px 16px;
  border: 1px solid rgba(212, 175, 55, 0.3);
  background: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  font-weight: 900;
  color: #4a3b36;
  transition: all 0.3s ease;
}

@media (min-width: 1200px) {
  .btn {
    padding: 10px 20px;
    font-size: 14px;
  }
}

.btn:hover {
  background: linear-gradient(135deg, rgba(242, 233, 210, 0.8), rgba(230, 194, 136, 0.6));
  border-color: rgba(212, 175, 55, 0.5);
  transform: translateY(-1px);
}

.btn.primary {
  background: linear-gradient(135deg, #e6c288, #d4af37);
  color: #fff;
  border-color: rgba(212, 175, 55, 0.4);
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* 作品面板 */
.panel {
  width: 100%;
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
  .panel { margin: 24px 0 0 }
}

.worksPanel {
  padding: 20px 48px;
}

@media (min-width: 1600px) {
  .worksPanel { padding: 24px 64px }
}

@media (min-width: 1200px) and (max-width: 1599px) {
  .worksPanel { padding: 24px 56px }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .worksPanel { padding: 20px 32px }
}

@media (max-width: 767px) {
  .worksPanel { padding: 20px 16px }
}

.sectionHead {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px dashed rgba(212, 175, 55, 0.2);
}

.sectionTitle {
  margin: 0;
  font-size: 20px;
  font-weight: 900;
  color: #3a2e2b;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  letter-spacing: 1px;
}

@media (min-width: 1200px) {
  .sectionTitle { font-size: 22px }
}

.sectionCount {
  font-size: 14px;
  color: #9d8b7a;
  font-weight: 700;
}

.emptyState {
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

.worksGrid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
  gap: 20px;
  padding: 16px 0;
}

@media (min-width: 1600px) {
  .worksGrid { grid-template-columns: repeat(auto-fill, minmax(440px, 1fr)) }
}

@media (min-width: 1200px) and (max-width: 1599px) {
  .worksGrid { grid-template-columns: repeat(auto-fill, minmax(400px, 1fr)) }
}

@media (min-width: 768px) and (max-width: 1199px) {
  .worksGrid { grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 16px }
}

@media (max-width: 767px) {
  .worksGrid { grid-template-columns: 1fr }
}

.workCard {
  border-radius: 16px;
  border: 1px dashed rgba(212, 175, 55, 0.15);
  background: rgba(255, 255, 255, 0.95);
  padding: 20px;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.workCard::before {
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

.workCard:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(212, 175, 55, 0.12);
  border-color: rgba(212, 175, 55, 0.3);
  border-style: solid;
}

.workCard:hover::before {
  opacity: 1;
}

.workHeader {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
}

.typeBadge {
  display: inline-block;
  padding: 4px 10px;
  border-radius: 12px;
  background: linear-gradient(135deg, #f2e9d2, #e6c288);
  color: #3a2e2b;
  font-size: 12px;
  font-weight: 700;
  border: 1px solid rgba(212, 175, 55, 0.2);
}

.timeText {
  font-size: 13px;
  color: #9d8b7a;
  font-weight: 700;
}

.workTitle {
  margin-top: 14px;
  font-size: 18px;
  font-weight: 900;
  color: #3a2e2b;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  line-height: 1.4;
}

@media (min-width: 1200px) {
  .workTitle { font-size: 20px }
}

.workContent {
  margin-top: 10px;
  font-size: 14px;
  line-height: 1.8;
  color: #4a3b36;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  opacity: 0.85;
}

.workImagesGrid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px;
  margin: 12px 0;
}

.workImageItem {
  aspect-ratio: 1;
  border-radius: 8px;
  overflow: hidden;
  background: rgba(212, 175, 55, 0.1);
}

.workImageItem img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.workImageItem:hover img {
  transform: scale(1.05);
}

@media (max-width: 768px) {
  .workImagesGrid {
    grid-template-columns: repeat(2, 1fr);
  }
}

.workStats {
  margin-top: 14px;
  display: flex;
  gap: 20px;
  font-size: 13px;
  color: #9d8b7a;
  font-weight: 700;
}

.workStats .stat {
  display: flex;
  align-items: center;
  gap: 4px;
}

.safeBottom { height: 24px }
</style>