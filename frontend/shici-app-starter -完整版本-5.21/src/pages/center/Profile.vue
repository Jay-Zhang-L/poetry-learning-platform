<template>
  <div class="profilePage">
    <!-- 竹纹背景 -->
    <div class="bgBamboo"></div>

    <!-- 水墨晕染渐变层 -->
    <div class="bgInk"></div>

    <div class="contentWrapper">
      <!-- 页面头部 -->
      <header class="pageHeader">
        <button class="navBtn backBtn" type="button" @click="goBack">
          <span class="btnIcon">←</span>
          <span class="btnText">返回</span>
        </button>

        <div class="pageTitle">
          <span class="titleMain">编辑资料</span>
          <span class="titleSub">个人信息</span>
        </div>

        <button class="navBtn saveBtn" type="button" :disabled="saving" @click="onSave">
          <span class="btnIcon" v-if="!saving">保存</span>
          <span class="btnIcon" v-else>...</span>
        </button>
      </header>

      <!-- 加载状态 -->
      <div v-if="loading" class="loadingContainer">
        <div class="loadingContent">
          <div class="loadingSpinner"></div>
          <div class="loadingText">正在加载个人信息...</div>
        </div>
      </div>

      <!-- 主要内容 -->
      <div v-else class="mainContent">

        <!-- 头像和封面上传区域 -->
        <section class="uploadSection">
          <div class="uploadGrid">

            <!-- 头像上传 -->
            <div class="uploadCard avatarCard">
              <div class="cardHeader">
                <span class="cardTitle">头像</span>
                <span class="cardSubtitle">Avatar</span>
              </div>

              <div class="avatarPreviewArea">
                <div class="avatarFrame" :class="{ 'hasImage': !!avatarPreviewUrl }">
                  <img v-if="avatarPreviewUrl" :src="avatarPreviewUrl" alt="头像" />
                  <div v-else class="avatarPlaceholder">
                    <span class="placeholderText">{{ form.nickname?.slice(0, 1) || form.username?.slice(0, 1) || "诗" }}</span>
                  </div>

                  <!-- 印章装饰 -->
                  <div class="sealDecor" v-if="!avatarPreviewUrl">诗</div>
                </div>
              </div>

              <div class="uploadActions">
                <label class="uploadBtn">
                  <input type="file" accept="image/*" @change="onAvatarChange" />
                  <span class="uploadBtnIcon">📷</span>
                  <span class="uploadBtnText">选择头像</span>
                </label>
              </div>

              <div class="uploadHint">
                <span class="hintIcon">ℹ</span>
                <span class="hintText">支持 JPG、PNG 格式，建议正方形图片</span>
              </div>
            </div>

            <!-- 封面上传 -->
            <div class="uploadCard coverCard">
              <div class="cardHeader">
                <span class="cardTitle">背景封面</span>
                <span class="cardSubtitle">Cover</span>
              </div>

              <div class="coverPreviewArea">
                <div class="coverFrame" :class="{ 'hasImage': !!coverPreviewUrl }">
                  <img v-if="coverPreviewUrl" :src="coverPreviewUrl" alt="封面" />
                  <div v-else class="coverPlaceholder">
                    <span class="placeholderText">暂无封面</span>
                    <span class="placeholderSub">建议上传横图</span>
                  </div>
                </div>
              </div>

              <div class="uploadActions">
                <label class="uploadBtn">
                  <input type="file" accept="image/*" @change="onCoverChange" />
                  <span class="uploadBtnIcon">🖼️</span>
                  <span class="uploadBtnText">选择封面</span>
                </label>
              </div>

              <div class="uploadHint">
                <span class="hintIcon">ℹ</span>
                <span class="hintText">建议比例 16:9，展示在个人主页顶部</span>
              </div>
            </div>
          </div>
        </section>

        <!-- 基本信息表单 -->
        <section class="formSection">
          <div class="sectionTitle">
            <span class="titleText">基本信息</span>
            <span class="titleDecor"></span>
          </div>

          <div class="formGrid">
            <!-- 账号（只读） -->
            <div class="formItem readonly">
              <label class="formLabel">
                <span class="labelIcon">👤</span>
                <span class="labelText">账号</span>
              </label>
              <div class="formInput readonlyInput">
                <span class="readonlyText">{{ form.username || '未设置' }}</span>
                <span class="readonlyIcon">🔒</span>
              </div>
            </div>

            <!-- 身份（只读） -->
            <div class="formItem readonly">
              <label class="formLabel">
                <span class="labelIcon">🎭</span>
                <span class="labelText">身份</span>
              </label>
              <div class="formInput readonlyInput">
                <span class="readonlyText">{{ roleText }}</span>
                <span class="readonlyIcon">🏷️</span>
              </div>
            </div>

            <!-- 昵称（可编辑） -->
            <div class="formItem">
              <label class="formLabel">
                <span class="labelIcon">✏️</span>
                <span class="labelText">昵称</span>
              </label>
              <input
                v-model="form.nickname"
                class="formInput"
                placeholder="请输入昵称"
                maxlength="20"
              />
              <span class="charCount">{{ (form.nickname || '').length }}/20</span>
            </div>

            <!-- 简介（可编辑，全宽） -->
            <div class="formItem fullwidth">
              <label class="formLabel">
                <span class="labelIcon">📝</span>
                <span class="labelText">个人简介</span>
              </label>
              <textarea
                v-model="form.bio"
                class="formInput textarea"
                placeholder="介绍一下自己吧..."
                maxlength="200"
                rows="4"
              ></textarea>
              <span class="charCount">{{ (form.bio || '').length }}/200</span>
            </div>
          </div>
        </section>
      </div>
    </div>

    <!-- 底部安全区域 -->
    <div class="safeBottom"></div>
  </div>
</template>

<script setup>
import { reactive, ref, computed, onMounted } from "vue";
import { useRouter } from "vue-router";
import { authGet, authPut, authPost } from "@/utils/request";

const router = useRouter();
const API_BASE = "http://localhost:8080";

const loading = ref(false);
const saving = ref(false);

const form = reactive({
  id: null,
  username: "",
  nickname: "",
  role: "",
  grade: null,
  bio: "",
  avatarUrl: "",
  coverUrl: "",
});

const avatarPreviewUrl = computed(() => buildFileUrl(form.avatarUrl));
const coverPreviewUrl = computed(() => buildFileUrl(form.coverUrl));

const roleText = computed(() => {
  if (form.role === "student") return "学生";
  if (form.role === "teacher") return "教师";
  return form.role || "未知";
});

function goBack() {
  router.back();
}

function buildFileUrl(path) {
  if (!path) return "";
  if (path.startsWith("http://") || path.startsWith("https://")) return path;
  return `${API_BASE}${path}`;
}

async function loadProfile() {
  loading.value = true;
  try {
    const res = await authGet(`${API_BASE}/api/user/me`);
    if (res.code !== 0) {
      throw new Error(res.msg || "加载个人信息失败");
    }

    const data = res.data || {};
    form.id = data.id ?? null;
    form.username = data.username || "";
    form.nickname = data.nickname || "";
    form.role = data.role || "";
    form.grade = data.grade ?? null;
    form.bio = data.bio || "";
    form.avatarUrl = data.avatarUrl || "";
    form.coverUrl = data.coverUrl || "";
  } catch (e) {
    alert(e.message || "加载个人信息失败");
  } finally {
    loading.value = false;
  }
}

async function onAvatarChange(event) {
  const file = event.target.files?.[0];
  if (!file) return;

  const formData = new FormData();
  formData.append("file", file);

  try {
    const res = await authPost(`${API_BASE}/api/upload/avatar`, formData);
    if (res.code !== 200 && res.code !== 0) {
      throw new Error(res.msg || "头像上传失败");
    }
    form.avatarUrl = res.data?.url || "";
  } catch (e) {
    alert(e.message || "头像上传失败");
  }
}

async function onCoverChange(event) {
  const file = event.target.files?.[0];
  if (!file) return;

  const formData = new FormData();
  formData.append("file", file);

  try {
    const res = await authPost(`${API_BASE}/api/upload/cover`, formData);
    if (res.code !== 200 && res.code !== 0) {
      throw new Error(res.msg || "封面上传失败");
    }
    form.coverUrl = res.data?.url || "";
  } catch (e) {
    alert(e.message || "封面上传失败");
  }
}

async function onSave() {
  if (!form.nickname?.trim()) {
    alert("请输入昵称");
    return;
  }

  saving.value = true;
  try {
    const payload = {
      nickname: form.nickname?.trim(),
      grade: form.grade,
      bio: form.bio?.trim(),
      avatarUrl: form.avatarUrl,
      coverUrl: form.coverUrl,
    };

    const res = await authPut(`${API_BASE}/api/user/profile`, payload);
    if (res.code !== 0) {
      throw new Error(res.msg || "保存失败");
    }

    // 更新localStorage中的用户信息
    const storedUser = localStorage.getItem("user");
    if (storedUser) {
      try {
        const userData = JSON.parse(storedUser);
        Object.assign(userData, payload);
        localStorage.setItem("user", JSON.stringify(userData));
      } catch (e) {
        console.error("更新本地用户信息失败:", e);
      }
    }

    alert("保存成功");
    await loadProfile();
  } catch (e) {
    alert(e.message || "保存失败");
  } finally {
    saving.value = false;
  }
}

onMounted(() => {
  loadProfile();
});
</script>

<style scoped>
/* =========================
   全局容器和背景
   ========================= */
.profilePage {
  min-height: 100vh;
  position: relative;
  background: var(--bg0);
  color: var(--text);
  overflow-x: hidden;
}

/* 竹纹背景 */
.bgBamboo {
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
.bgInk {
  position: fixed;
  inset: 0;
  background:
    radial-gradient(1200px 700px at 20% 10%, rgba(140, 170, 160, 0.12), transparent 60%),
    radial-gradient(900px 500px at 80% 20%, rgba(180, 200, 220, 0.08), transparent 55%),
    radial-gradient(1000px 600px at 50% 90%, rgba(230, 220, 190, 0.15), transparent 55%);
  pointer-events: none;
  z-index: -2;
}

.contentWrapper {
  position: relative;
  z-index: 2;
  max-width: 1400px;
  margin: 0 auto;
  padding: 0;
}

/* =========================
   页面头部
   ========================= */
.pageHeader {
  position: sticky;
  top: 0;
  z-index: 100;
  width: 100%;
  padding: 24px 48px 16px;
  margin: 0;
  display: grid;
  grid-template-columns: 100px 1fr 100px;
  gap: 16px;
  align-items: center;
  background: linear-gradient(180deg, rgba(253, 251, 247, 0.98), rgba(253, 251, 247, 0.95), rgba(253, 251, 247, 0));
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(212, 175, 55, 0.1);
}

.pageTitle {
  text-align: center;
}

.titleMain {
  display: block;
  font-weight: 900;
  letter-spacing: 3px;
  color: #3a2e2b;
  font-size: 24px;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

.titleSub {
  display: block;
  font-size: 12px;
  color: #9d8b7a;
  font-weight: 700;
  letter-spacing: 2px;
  margin-top: 4px;
}

.navBtn {
  height: 42px;
  border-radius: 12px;
  border: 1px solid rgba(212, 175, 55, 0.3);
  background: linear-gradient(135deg, rgba(253, 249, 242, 0.9), rgba(246, 240, 230, 0.8));
  cursor: pointer;
  font-weight: 900;
  color: #4a3b36;
  padding: 0 20px;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.navBtn:hover:not(:disabled) {
  background: linear-gradient(135deg, rgba(242, 233, 210, 0.9), rgba(230, 194, 136, 0.8));
  border-color: rgba(212, 175, 55, 0.5);
  transform: translateY(-1px);
}

.saveBtn {
  background: linear-gradient(135deg, #e6c288, #f5db83);
  color: #fff;
  border-color: rgba(212, 175, 55, 0.4);
}

.saveBtn:hover:not(:disabled) {
  background: linear-gradient(135deg, #f0e3b9, #fae294);
}

.saveBtn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* =========================
   加载状态
   ========================= */
.loadingContainer {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 60vh;
  padding: 48px;
}

.loadingContent {
  text-align: center;
}

.loadingSpinner {
  width: 48px;
  height: 48px;
  border: 4px solid rgba(212, 175, 55, 0.2);
  border-top-color: #d4af37;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 20px;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loadingText {
  font-size: 16px;
  color: #9d8b7a;
  font-weight: 700;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

/* =========================
   主内容区域
   ========================= */
.mainContent {
  padding: 20px 48px 32px;
}

/* =========================
   上传区域
   ========================= */
.uploadSection {
  margin-bottom: 24px;
}

.uploadGrid {
  display: grid;
  grid-template-columns: 320px 1fr;
  gap: 24px;
}

.uploadCard {
  background: rgba(253, 249, 242, 0.9);
  border: 1px solid rgba(212, 175, 55, 0.2);
  border-radius: 20px;
  box-shadow: 0 4px 16px rgba(212, 175, 55, 0.08);
  backdrop-filter: blur(12px);
  padding: 24px;
  transition: all 0.3s ease;
}

.uploadCard:hover {
  box-shadow: 0 8px 24px rgba(212, 175, 55, 0.15);
  transform: translateY(-2px);
}

.cardHeader {
  margin-bottom: 20px;
  text-align: center;
}

.cardTitle {
  display: block;
  font-size: 18px;
  font-weight: 900;
  color: #3a2e2b;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  letter-spacing: 2px;
  margin-bottom: 4px;
}

.cardSubtitle {
  display: block;
  font-size: 12px;
  color: #9d8b7a;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1px;
}

/* 头像预览 */
.avatarPreviewArea {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.avatarFrame {
  width: 140px;
  height: 140px;
  border-radius: 50%;
  overflow: hidden;
  background: rgba(212, 175, 55, 0.1);
  border: 3px solid rgba(212, 175, 55, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(212, 175, 55, 0.2);
}

.avatarFrame.hasImage {
  border-color: rgba(212, 175, 55, 0.5);
}

.avatarFrame img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatarPlaceholder {
  font-size: 48px;
  font-weight: 900;
  color: #4a3b36;
}

.placeholderText {
  display: block;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

.sealDecor {
  position: absolute;
  bottom: 4px;
  right: 4px;
  width: 28px;
  height: 28px;
  border-radius: 4px;
  background: rgba(212, 175, 55, 0.3);
  color: #3a2e2b;
  font-size: 14px;
  font-weight: 900;
  display: grid;
  place-items: center;
  border: 1px solid rgba(212, 175, 55, 0.4);
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

/* 封面预览 */
.coverPreviewArea {
  margin-bottom: 20px;
}

.coverFrame {
  width: 100%;
  height: 200px;
  border-radius: 16px;
  overflow: hidden;
  background: rgba(212, 175, 55, 0.05);
  border: 2px dashed rgba(212, 175, 55, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  transition: all 0.3s ease;
}

.coverFrame.hasImage {
  border-style: solid;
  border-color: rgba(212, 175, 55, 0.3);
}

.coverFrame img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.coverPlaceholder {
  text-align: center;
}

.coverPlaceholder .placeholderText {
  font-size: 16px;
  color: #9d8b7a;
  font-weight: 700;
  display: block;
  margin-bottom: 8px;
}

.placeholderSub {
  font-size: 13px;
  color: #9d8b7a;
  font-weight: 700;
}

/* 上传按钮 */
.uploadActions {
  margin-bottom: 16px;
  text-align: center;
}

.uploadBtn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 12px 24px;
  border-radius: 12px;
  border: 1px solid rgba(212, 175, 55, 0.3);
  background: linear-gradient(135deg, rgba(253, 249, 242, 0.9), rgba(246, 240, 230, 0.8));
  cursor: pointer;
  font-weight: 900;
  color: #4a3b36;
  transition: all 0.3s ease;
}

.uploadBtn:hover {
  background: linear-gradient(135deg, rgba(242, 233, 210, 0.9), rgba(230, 194, 136, 0.8));
  border-color: rgba(212, 175, 55, 0.5);
  transform: translateY(-1px);
}

.uploadBtn input {
  display: none;
}

.uploadBtnIcon {
  font-size: 18px;
}

.uploadBtnText {
  font-size: 14px;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

/* 提示信息 */
.uploadHint {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px;
  background: rgba(212, 175, 55, 0.05);
  border-radius: 8px;
  border: 1px dashed rgba(212, 175, 55, 0.15);
}

.hintIcon {
  font-size: 14px;
  color: #9d8b7a;
}

.hintText {
  font-size: 12px;
  color: #9d8b7a;
  font-weight: 700;
}

/* =========================
   表单区域
   ========================= */
.formSection {
  background: rgba(253, 249, 242, 0.9);
  border: 1px solid rgba(212, 175, 55, 0.2);
  border-radius: 20px;
  box-shadow: 0 4px 16px rgba(212, 175, 55, 0.08);
  backdrop-filter: blur(12px);
  padding: 28px;
  margin-bottom: 24px;
}

.sectionTitle {
  margin-bottom: 24px;
  text-align: center;
  position: relative;
}

.titleText {
  font-size: 20px;
  font-weight: 900;
  color: #3a2e2b;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  letter-spacing: 3px;
}

.titleDecor {
  display: block;
  width: 60px;
  height: 3px;
  background: linear-gradient(90deg, transparent, #d4af37, transparent);
  margin: 12px auto 0;
  border-radius: 2px;
}

.formGrid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.formItem {
  position: relative;
}

.formItem.fullwidth {
  grid-column: 1 / -1;
}

.formLabel {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 15px;
  font-weight: 900;
  color: #4a3b36;
  font-family: "思源宋体", "STSong", "SimSun", serif;
  letter-spacing: 1px;
  margin-bottom: 10px;
}

.labelIcon {
  font-size: 16px;
}

/* 表单输入框 */
.formInput {
  width: 100%;
  border: 1px dashed rgba(212, 175, 55, 0.25);
  background: rgba(255, 255, 255, 0.95);
  border-radius: 12px;
  padding: 14px 16px;
  font-size: 15px;
  color: #4a3b36;
  outline: none;
  transition: all 0.3s ease;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

.formInput:focus {
  border-color: rgba(212, 175, 55, 0.5);
  border-style: solid;
  box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
  background: rgba(255, 255, 255, 1);
}

.formInput::placeholder {
  color: #9d8b7a;
  font-weight: 700;
}

.textarea {
  resize: vertical;
  min-height: 120px;
  line-height: 1.6;
}

/* 只读输入框 */
.readonlyInput {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 16px;
  background: rgba(212, 175, 55, 0.08);
  border: 1px dashed rgba(212, 175, 55, 0.15);
  border-radius: 12px;
}

.readonlyText {
  color: #9d8b7a;
  font-weight: 700;
  font-family: "思源宋体", "STSong", "SimSun", serif;
}

.readonlyIcon {
  font-size: 14px;
  opacity: 0.6;
}

/* 字符计数 */
.charCount {
  position: absolute;
  bottom: 10px;
  right: 14px;
  font-size: 12px;
  color: #9d8b7a;
  font-weight: 700;
  pointer-events: none;
}

.textarea + .charCount {
  bottom: 14px;
}

/* =========================
   底部安全区域
   ========================= */
.safeBottom {
  height: 32px;
}

/* =========================
   响应式设计
   ========================= */
@media (max-width: 1200px) {
  .pageHeader {
    padding: 20px 32px 12px;
  }

  .mainContent {
    padding: 20px 32px 24px;
  }

  .uploadGrid {
    grid-template-columns: 280px 1fr;
    gap: 20px;
  }

  .formGrid {
    grid-template-columns: 1fr 1fr;
  }
}

@media (max-width: 900px) {
  .uploadGrid,
  .formGrid,
  .statsGrid {
    grid-template-columns: 1fr;
  }

  .formItem.fullwidth {
    grid-column: auto;
  }

  .pageHeader {
    grid-template-columns: 80px 1fr 80px;
  }
}

@media (max-width: 768px) {
  .pageHeader {
    padding: 16px 20px 12px;
    grid-template-columns: 60px 1fr 60px;
  }

  .mainContent {
    padding: 16px 20px 20px;
  }

  .titleMain {
    font-size: 20px;
    letter-spacing: 2px;
  }

  .titleSub {
    font-size: 11px;
  }

  .uploadCard {
    padding: 20px;
  }

  .formSection {
    padding: 20px;
  }

  .avatarFrame {
    width: 120px;
    height: 120px;
  }

  .coverFrame {
    height: 160px;
  }

  .statCard {
    padding: 16px;
  }

  .statIcon {
    font-size: 24px;
    width: 48px;
    height: 48px;
  }

  .statNum {
    font-size: 24px;
  }
}

@media (max-width: 480px) {
  .pageHeader {
    padding: 12px 16px 8px;
  }

  .mainContent {
    padding: 12px 16px 16px;
  }

  .navBtn {
    height: 36px;
    padding: 0 12px;
    font-size: 13px;
  }

  .titleMain {
    font-size: 18px;
  }

  .uploadCard,
  .formSection {
    padding: 16px;
    border-radius: 16px;
  }

  .formGrid {
    gap: 16px;
  }

  .statsGrid {
    gap: 12px;
  }
}
</style>