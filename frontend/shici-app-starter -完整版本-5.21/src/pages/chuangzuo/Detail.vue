<template>
  <div class="detailPage">
    <div class="container">
      <header class="topbar">
        <button class="backBtn" @click="router.back()">返回</button>
        <div class="title">作品详情</div>
        <button
          v-if="isAuthor"
          class="moreBtn"
          @click="showActions = !showActions"
        >
          更多
        </button>
      </header>

      <div v-if="loading" class="panel empty">
        <div class="emptyTitle">加载中...</div>
      </div>

      <div v-else-if="work" class="content">
        <section class="panel">
          <div class="authorSection" @click="goUserHome">
            <img
              :src="getImageUrl(work.authorAvatar) || fallbackAvatar"
              class="avatar clickable"
              alt=""
            />
            <div class="authorInfo clickable">
              <div class="authorName">{{ work.authorName || "佚名" }}</div>
              <div class="time">{{ formatDate(work.createdAt) }}</div>
            </div>
          </div>

          <div class="typeTag">{{ getTypeLabel(work.type) }}</div>

          <h1 v-if="work.title" class="workTitle">{{ work.title }}</h1>

          <div class="workContent">{{ work.content || "暂无内容" }}</div>

          <div v-if="work.description" class="workDesc">
            <div class="descLabel">创作说明</div>
            <div class="descContent">{{ work.description }}</div>
          </div>

          <div v-if="work.images && work.images.length" class="imageGrid">
            <img
              v-for="(img, idx) in work.images"
              :key="img + idx"
              :src="getImageUrl(img)"
              class="workImage"
              @click="previewImage(idx)"
            />
          </div>

          <div v-if="work.tags && work.tags.length" class="tags">
            <span v-for="tag in work.tags" :key="tag" class="tag">#{{ tag }}</span>
          </div>

          <div class="stats">
            <span>{{ work.likeCount || 0 }} 点赞</span>
            <span>{{ work.commentCount || 0 }} 评论</span>
            <span>{{ work.saveCount || 0 }} 收藏</span>
            <span>{{ work.viewCount || 0 }} 浏览</span>
          </div>

          <div class="actions">
            <button
              class="actionBtn"
              :class="{ active: work.viewerLiked }"
              @click="toggleLike"
            >
              {{ work.viewerLiked ? "已点赞" : "点赞" }}
            </button>

            <button
              class="actionBtn"
              :class="{ active: work.viewerSaved }"
              @click="toggleSave"
            >
              {{ work.viewerSaved ? "已收藏" : "收藏" }}
            </button>

            <button class="actionBtn" @click="share">分享</button>
          </div>

          <div v-if="showActions && isAuthor" class="authorActions">
            <button class="actionBtn" @click="editWork">编辑</button>
            <button class="actionBtn danger" @click="deleteWork">删除</button>
          </div>
        </section>

        <section class="panel">
          <div class="sectionHead">
            <div class="sectionTitle">评论</div>
            <button
              v-if="hasMoreComments"
              class="textBtn"
              @click="loadMoreComments"
            >
              加载更多
            </button>
          </div>

          <div class="commentEditor">
            <textarea
              v-model="commentText"
              class="textarea"
              maxlength="300"
              placeholder="写下你的评论..."
            ></textarea>
            <div class="editorBottom">
              <span class="hint">{{ commentText.length }}/300</span>
              <button class="primaryBtn" @click="submitComment">发表评论</button>
            </div>
          </div>

          <div v-if="comments.length > 0" class="commentList">
            <article v-for="item in comments" :key="item.id" class="commentCard">
              <img
                :src="getImageUrl(item.userAvatar) || fallbackAvatar"
                class="commentAvatar"
                alt=""
              />
              <div class="commentMain">
                <div class="commentTop">
                  <span class="commentName">{{ item.userName || "用户" }}</span>
                  <span class="commentTime">{{ formatDate(item.createdAt) }}</span>
                </div>
                <div class="commentContent">{{ item.content }}</div>
              </div>
            </article>
          </div>

          <div v-else class="empty">
            <div class="emptyDesc">还没有评论，来抢沙发吧</div>
          </div>
        </section>
      </div>

      <section v-else class="panel empty">
        <div class="emptyTitle">作品不存在</div>
      </section>
    </div>

    <teleport to="body">
      <div v-if="preview.open" class="preview" @click="closePreview">
        <button class="pvBtn left" @click.stop="prevImg">上一张</button>
        <img
          class="pvImg"
          :src="getImageUrl(preview.images[preview.index])"
          alt=""
          @click.stop
        />
        <button class="pvBtn right" @click.stop="nextImg">下一张</button>
        <button class="pvClose" @click.stop="closePreview">关闭</button>
      </div>
    </teleport>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { authDelete, authGet, authPost } from "@/utils/api";
import { showError, showSuccess, showWarning } from "@/utils/toast";

const route = useRoute();
const router = useRouter();

const loading = ref(false);
const work = ref(null);
const comments = ref([]);
const commentText = ref("");
const commentPage = ref(1);
const hasMoreComments = ref(false);
const showActions = ref(false);

const preview = reactive({
  open: false,
  index: 0,
  images: [],
});

const typeLabels = {
  poem: "诗词创作",
  ci: "词牌填词",
  fu: "赋体创作",
  couplet: "对联创作",
  modern: "现代诗歌",
  calligraphy: "书法创作",
};

const fallbackAvatar =
  "data:image/svg+xml;utf8," +
  encodeURIComponent(`
  <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48">
    <rect width="48" height="48" rx="12" fill="#ece7df"/>
    <circle cx="24" cy="18" r="8" fill="#fff"/>
    <path d="M10 42c3-8 8-12 14-12s11 4 14 12" fill="#fff"/>
  </svg>
`);

const isAuthor = computed(() => {
  const currentUser = JSON.parse(localStorage.getItem("user") || "{}");
  if (!work.value) return false;
  return String(currentUser.id || "") === String(work.value.userId || work.value.authorId || "");
});

function isSuccess(res) {
  return res && (res.code === 0 || res.code === 200);
}

function getTypeLabel(type) {
  return typeLabels[type] || "创作";
}

function formatDate(v) {
  if (!v) return "刚刚";
  const d = new Date(v);
  if (Number.isNaN(d.getTime())) return String(v);
  const pad = (n) => (n < 10 ? "0" + n : "" + n);
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function getImageUrl(url) {
  if (!url) return "";
  if (/^https?:\/\//i.test(url)) return url;
  if (url.startsWith("data:")) return url;
  return url;
}

function normalizeWork(data) {
  let images = data?.images ?? [];
  if (typeof images === "string") {
    try {
      images = JSON.parse(images);
    } catch {
      images = images
        .split(",")
        .map((s) => s.trim())
        .filter(Boolean);
    }
  }
  if (!Array.isArray(images)) images = [];

  let tags = data?.tags ?? [];
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
  if (!Array.isArray(tags)) tags = [];

  let mentionUserIds = data?.mentionUserIds ?? [];
  if (typeof mentionUserIds === "string") {
    try {
      mentionUserIds = JSON.parse(mentionUserIds);
    } catch {
      mentionUserIds = [];
    }
  }
  if (!Array.isArray(mentionUserIds)) mentionUserIds = [];

  return {
    ...data,
    images,
    tags,
    mentionUserIds,
    viewerLiked: !!data?.viewerLiked,
    viewerSaved: !!data?.viewerSaved,
    likeCount: Number(data?.likeCount || 0),
    commentCount: Number(data?.commentCount || 0),
    saveCount: Number(data?.saveCount || 0),
    viewCount: Number(data?.viewCount || 0),
  };
}

function normalizeCommentList(raw) {
  if (!Array.isArray(raw)) return [];
  return raw.map((item) => ({
    ...item,
    userName: item.userName || item.nickname || item.username || "用户",
    userAvatar: item.userAvatar || item.avatar || "",
    content: item.content || "",
    createdAt: item.createdAt || item.createTime || item.created_at || "",
  }));
}

async function fetchWork() {
  loading.value = true;
  try {
    const data = await authGet(`/api/creations/${route.params.id}`);
    if (isSuccess(data)) {
      work.value = normalizeWork(data.data || {});
      // 记录浏览历史
      await recordViewHistory();
    } else {
      showError(data.msg || data.message || "获取作品失败");
      work.value = null;
    }
  } catch (e) {
    console.error("获取作品失败：", e);
    showError(e.message || "获取作品失败");
    work.value = null;
  } finally {
    loading.value = false;
  }
}

async function recordViewHistory() {
  try {
    const token = localStorage.getItem("token");
    if (!token) return; // 未登录不记录

    const workData = work.value;
    if (!workData) return;

    await authPost("/api/user/history", {
      type: "creation_work",
      targetId: workData.id,
      title: workData.title || "未命名作品",
      coverUrl: workData.images && workData.images.length > 0 ? workData.images[0] : null
    });
  } catch (e) {
    // 浏览历史记录失败不影响主流程，静默处理
    console.warn("记录浏览历史失败：", e);
  }
}

async function fetchComments() {
  try {
    const data = await authGet(
      `/api/comments?workId=${encodeURIComponent(route.params.id)}&page=${commentPage.value}&pageSize=20`
    );

    if (isSuccess(data)) {
      const rows = normalizeCommentList(
        data.data?.list || data.data?.rows || data.data || []
      );
      comments.value = commentPage.value === 1 ? rows : comments.value.concat(rows);
      hasMoreComments.value = !!(data.data?.hasMore || data.data?.pages > commentPage.value);
    } else {
      if (commentPage.value === 1) comments.value = [];
      hasMoreComments.value = false;
    }
  } catch (e) {
    console.error("获取评论失败：", e);
    if (commentPage.value === 1) comments.value = [];
    hasMoreComments.value = false;
  }
}

async function submitComment() {
  if (!commentText.value.trim()) {
    showWarning("请输入评论内容");
    return;
  }

  try {
    const data = await authPost("/api/comments", {
      workId: route.params.id,
      content: commentText.value.trim(),
    });

    if (isSuccess(data)) {
      commentText.value = "";
      commentPage.value = 1;
      await fetchComments();
      if (work.value) {
        work.value.commentCount = Number(work.value.commentCount || 0) + 1;
      }
      showSuccess("评论成功");
    } else {
      showError(data.msg || data.message || "评论失败");
    }
  } catch (e) {
    console.error("评论失败：", e);
    showError(e.message || "评论失败");
  }
}

function loadMoreComments() {
  commentPage.value += 1;
  fetchComments();
}

async function toggleLike() {
  if (!work.value) return;

  const old = !!work.value.viewerLiked;
  work.value.viewerLiked = !old;
  work.value.likeCount = Math.max(
    0,
    Number(work.value.likeCount || 0) + (work.value.viewerLiked ? 1 : -1)
  );

  try {
    const data = await authPost(`/api/creations/${work.value.id}/like`, {
      like: work.value.viewerLiked,
    });

    if (!isSuccess(data)) {
      throw new Error(data.msg || data.message || "点赞失败");
    }
  } catch (e) {
    work.value.viewerLiked = old;
    work.value.likeCount = Math.max(
      0,
      Number(work.value.likeCount || 0) + (old ? 1 : -1)
    );
    showError(e.message || "点赞失败");
  }
}

async function toggleSave() {
  if (!work.value) return;

  const old = !!work.value.viewerSaved;
  work.value.viewerSaved = !old;
  work.value.saveCount = Math.max(
    0,
    Number(work.value.saveCount || 0) + (work.value.viewerSaved ? 1 : -1)
  );

  try {
    const data = await authPost(`/api/creations/${work.value.id}/save`, {
      save: work.value.viewerSaved,
    });

    if (!isSuccess(data)) {
      throw new Error(data.msg || data.message || "收藏失败");
    }
  } catch (e) {
    work.value.viewerSaved = old;
    work.value.saveCount = Math.max(
      0,
      Number(work.value.saveCount || 0) + (old ? 1 : -1)
    );
    showError(e.message || "收藏失败");
  }
}

async function share() {
  try {
    await navigator.clipboard.writeText(`${location.origin}/author/${route.params.id}`);
    showSuccess("链接已复制");
  } catch (e) {
    showError("复制失败");
  }
}

function previewImage(index) {
  preview.images = work.value?.images || [];
  preview.index = index;
  preview.open = true;
}

function closePreview() {
  preview.open = false;
}

function prevImg() {
  if (!preview.images.length) return;
  preview.index = (preview.index - 1 + preview.images.length) % preview.images.length;
}

function nextImg() {
  if (!preview.images.length) return;
  preview.index = (preview.index + 1) % preview.images.length;
}

function goUserHome() {
  if (!work.value) return;

  const userId = work.value.userId || work.value.authorId;
  if (!userId) {
    showWarning("未找到作者信息");
    return;
  }

  router.push(`/author/${userId}`);
}

function editWork() {
  router.push(`/chuangzuo/edit/${route.params.id}`);
}

async function deleteWork() {
  if (!window.confirm("确定要删除这篇作品吗？")) return;

  try {
    const data = await authDelete(`/api/creations/${route.params.id}`);
    if (isSuccess(data)) {
      showSuccess("删除成功");
      setTimeout(() => {
        router.push("/chuangzuo");
      }, 800);
    } else {
      showError(data.msg || data.message || "删除失败");
    }
  } catch (e) {
    console.error("删除失败：", e);
    showError(e.message || "删除失败");
  }
}

onMounted(async () => {
  await Promise.all([fetchWork(), fetchComments()]);
});
</script>

<style scoped>
.detailPage {
  width: 100%;
  min-height: 100vh;
  margin: 0;
  background:
    radial-gradient(circle at top, rgba(191, 160, 106, 0.16), transparent 32%),
    linear-gradient(135deg, #fdfbf7, #f6f1e8 45%, #f3ede4);
  padding-bottom: 0;
  box-sizing: border-box;
}

.container {
  width: 100%;
  max-width: none;
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.content {
  width: 100%;
}

.topbar {
  position: sticky;
  top: 0;
  z-index: 10;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 36px;
  background: rgba(253, 251, 247, 0.94);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(104, 77, 42, 0.08);
  box-sizing: border-box;
}

.title {
  font-size: 22px;
  font-weight: 900;
  color: #2c241c;
  letter-spacing: 1px;
}

.backBtn,
.moreBtn,
.actionBtn,
.primaryBtn,
.textBtn {
  cursor: pointer;
}

.backBtn,
.moreBtn,
.actionBtn,
.primaryBtn,
.textBtn {
  border: 1px solid rgba(111, 82, 45, 0.12);
  background: rgba(255, 255, 255, 0.9);
  border-radius: 12px;
  padding: 10px 14px;
  transition: all 0.2s ease;
}

.backBtn:hover,
.moreBtn:hover,
.actionBtn:hover,
.primaryBtn:hover,
.textBtn:hover {
  transform: translateY(-1px);
  box-shadow: 0 10px 24px rgba(80, 60, 30, 0.08);
}

.primaryBtn {
  background: linear-gradient(135deg, #8f6735, #b28752);
  color: #fff;
  border-color: transparent;
}

.panel {
  width: 100%;
  margin: 0;
  margin-bottom: 0;
  padding: 28px 36px;
  box-sizing: border-box;
  background: rgba(255, 255, 255, 0.74);
  border: none;
  border-radius: 0;
  backdrop-filter: blur(14px);
  box-shadow: none;
  border-bottom: 1px solid rgba(104, 77, 42, 0.08);
}

.authorSection {
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
}

.clickable {
  cursor: pointer;
}

.authorSection:hover .authorName {
  color: #b28752;
}

.avatar {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid rgba(177, 138, 82, 0.18);
}

.authorName {
  font-weight: 900;
  font-size: 20px;
  color: #2d261e;
  transition: color 0.2s ease;
}

.time,
.hint,
.commentTime,
.emptyDesc {
  color: #7f7366;
  font-size: 14px;
}

.typeTag {
  display: inline-flex;
  margin-top: 18px;
  padding: 8px 14px;
  border-radius: 999px;
  background: rgba(166, 124, 67, 0.12);
  color: #8b5f26;
  font-size: 13px;
  font-weight: 800;
}

.workTitle {
  font-size: 42px;
  margin: 22px 0 16px;
  color: #2a2017;
  line-height: 1.35;
}

.workContent {
  line-height: 2.1;
  white-space: pre-wrap;
  color: #3a3128;
  font-size: 22px;
}

.workDesc {
  margin-top: 24px;
  padding: 18px 20px;
  border-radius: 18px;
  background: linear-gradient(
    135deg,
    rgba(184, 144, 88, 0.08),
    rgba(184, 144, 88, 0.04)
  );
  border: 1px solid rgba(184, 144, 88, 0.08);
}

.descLabel {
  font-weight: 800;
  margin-bottom: 8px;
  color: #73532b;
  font-size: 18px;
}

.descContent {
  line-height: 1.9;
  color: #5f5448;
  font-size: 16px;
}

.imageGrid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 16px;
  margin-top: 20px;
}

.workImage {
  width: 100%;
  height: 220px;
  object-fit: cover;
  border-radius: 16px;
  cursor: pointer;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.workImage:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 28px rgba(0, 0, 0, 0.12);
}

.tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 18px;
}

.tag {
  padding: 8px 12px;
  border-radius: 999px;
  background: rgba(212, 165, 116, 0.15);
  color: #8b7355;
  font-size: 13px;
  font-weight: 800;
}

.stats {
  display: flex;
  flex-wrap: wrap;
  gap: 18px;
  color: #7f7366;
  margin-top: 22px;
  font-size: 16px;
}

.actions,
.authorActions {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-top: 20px;
}

.actionBtn.active {
  background: linear-gradient(135deg, #8f6735, #b28752);
  color: #fff;
  border-color: transparent;
}

.actionBtn.danger {
  color: #c94a4a;
  border-color: rgba(201, 74, 74, 0.2);
}

.sectionHead,
.editorBottom,
.commentTop {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.sectionTitle {
  font-size: 30px;
  font-weight: 900;
  color: #2b231b;
}

.textarea {
  width: 100%;
  min-height: 160px;
  resize: vertical;
  border: 1px solid rgba(109, 84, 49, 0.1);
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.92);
  padding: 16px 18px;
  box-sizing: border-box;
  color: #372f26;
  outline: none;
  font-size: 16px;
}

.textarea:focus {
  border-color: rgba(170, 127, 70, 0.45);
  box-shadow: 0 0 0 3px rgba(170, 127, 70, 0.08);
}

.commentEditor {
  display: grid;
  gap: 12px;
}

.commentList {
  display: grid;
  gap: 14px;
  margin-top: 20px;
}

.commentCard {
  display: flex;
  gap: 14px;
  padding: 18px;
  border-radius: 18px;
  background: rgba(252, 250, 246, 0.88);
  border: 1px solid rgba(110, 84, 46, 0.05);
}

.commentAvatar {
  width: 46px;
  height: 46px;
  border-radius: 50%;
  object-fit: cover;
}

.commentName {
  font-weight: 800;
  color: #30271f;
  font-size: 17px;
}

.commentContent {
  line-height: 1.85;
  color: #4b4136;
  margin-top: 6px;
  white-space: pre-wrap;
  font-size: 16px;
}

.empty {
  text-align: center;
  padding: 40px 12px;
}

.emptyTitle {
  font-size: 22px;
  font-weight: 900;
  margin-bottom: 8px;
  color: #2d241c;
}

.preview {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.82);
  display: grid;
  place-items: center;
  z-index: 999;
}

.pvImg {
  max-width: min(92vw, 1200px);
  max-height: 82vh;
  border-radius: 12px;
}

.pvBtn,
.pvClose {
  position: fixed;
  border: none;
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.16);
  color: #fff;
  padding: 10px 14px;
  cursor: pointer;
}

.pvBtn.left {
  left: 16px;
  top: 50%;
  transform: translateY(-50%);
}

.pvBtn.right {
  right: 16px;
  top: 50%;
  transform: translateY(-50%);
}

.pvClose {
  top: 16px;
  right: 16px;
}

@media (max-width: 768px) {
  .topbar {
    padding: 14px 16px;
  }

  .panel {
    padding: 18px 16px;
  }

  .title {
    font-size: 18px;
  }

  .workTitle {
    font-size: 28px;
  }

  .workContent {
    font-size: 17px;
  }

  .sectionTitle {
    font-size: 24px;
  }

  .stats {
    gap: 10px;
    font-size: 13px;
  }

  .imageGrid {
    grid-template-columns: repeat(2, 1fr);
    gap: 10px;
  }

  .workImage {
    height: 150px;
  }

  .pvBtn.left,
  .pvBtn.right {
    top: auto;
    bottom: 20px;
    transform: none;
  }

  .pvBtn.left {
    left: 20px;
  }

  .pvBtn.right {
    right: 20px;
  }
}
</style>