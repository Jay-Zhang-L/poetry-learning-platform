<template>
  <div class="publishPage">
    <div class="paperTexture"></div>
    <div class="paperShade"></div>

    <div class="container">
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

        <div class="titleWrap">
          <div class="titleMain">发布创作</div>
          <div class="titleSub">落笔成章，留白见意</div>
        </div>

        <button class="publishBtn" :disabled="!canPublish || submitting" @click="publish">
          {{ submitting ? "发布中" : "发布" }}
        </button>
      </header>

      <section class="introCard">
        <div class="introLeft">
          <div class="introMark">创作页</div>
          <div class="introText">
            保留正文、说明、标签与封面，页面视觉压低，重点回到内容本身。
          </div>
        </div>

        <div class="typeBlock" v-if="selectedType">
          <span class="typeName">{{ selectedType.label }}</span>
        </div>

        <div v-else class="typeEmpty">
          <span>请先选择创作类型</span>
          <button class="ghostBtn" @click="goSelectType">选择类型</button>
        </div>
      </section>

      <div class="editorCard">
        <div class="field">
          <label class="label">作品标题</label>
          <input
            v-model="form.title"
            class="input"
            maxlength="50"
            placeholder="给你的作品起一个标题（选填）"
          />
          <div class="hint">{{ form.title.length }}/50</div>
        </div>

        <div class="field contentField">
          <div class="labelRow">
            <label class="label required">诗词正文</label>
            <span class="contentTip">正文是页面核心，建议先完成正文，再补标签与说明</span>
          </div>
          <textarea
            v-model="form.content"
            class="textarea contentTextarea"
            maxlength="2000"
            placeholder="请输入正文内容"
            @input="onContentChange"
          ></textarea>
          <div class="hint">{{ form.content.length }}/2000</div>
        </div>

        <div class="field aiSection">
          <div class="aiTop">
            <div class="aiTitleWrap">
              <span class="aiDot"></span>
              <span class="aiTitle">AI润色助手</span>
            </div>

            <button
              class="toggleSwitch"
              :class="{ active: aiPolishEnabled }"
              type="button"
              @click="toggleAiPolish"
            >
              <span class="switchKnob"></span>
            </button>
          </div>

          <div class="aiDesc">
            开启后，自动检查错字、韵脚与整体表达，给出润色建议。
          </div>

          <div v-if="aiPolishEnabled && polishResult" class="polishCard">
            <div class="polishHeader">
              <span>润色建议</span>
              <button
                class="smallActionBtn"
                @click="applyAllSuggestions"
                v-if="polishResult.spellingErrors?.length"
              >
                一键应用
              </button>
            </div>

            <div v-if="polishResult.spellingErrors?.length" class="polishBlock">
              <div class="polishBlockTitle">错别字检查</div>
              <div
                v-for="(err, idx) in polishResult.spellingErrors"
                :key="idx"
                class="suggestionItem"
              >
                <span class="original">{{ err.original }}</span>
                <span class="arrow">→</span>
                <span class="suggested">{{ err.suggested }}</span>
                <button class="miniBtn" @click="applySuggestion(err, 'spelling')">应用</button>
                <span class="reason">{{ err.reason }}</span>
              </div>
            </div>

            <div v-if="polishResult.rhymeInfo" class="polishBlock">
              <div class="polishBlockTitle">韵脚检查</div>
              <div class="statusLine">
                <span class="statusBadge" :class="polishResult.rhymeInfo.status === '正确' ? 'good' : 'warn'">
                  {{ polishResult.rhymeInfo.status }}
                </span>
                <span v-if="polishResult.rhymeInfo.currentRhyme" class="statusText">
                  当前韵脚：{{ polishResult.rhymeInfo.currentRhyme }}
                </span>
              </div>
              <div v-if="polishResult.rhymeInfo.suggestion" class="suggestionText">
                建议：{{ polishResult.rhymeInfo.suggestion }}
              </div>
            </div>

            <div v-if="polishResult.rhythmInfo" class="polishBlock">
              <div class="polishBlockTitle">韵律检查</div>
              <div class="suggestionText">{{ polishResult.rhythmInfo.detail }}</div>
              <div v-if="polishResult.rhythmInfo.suggestion" class="suggestionText">
                建议：{{ polishResult.rhythmInfo.suggestion }}
              </div>
            </div>

            <div v-if="polishResult.generalAdvice" class="polishBlock">
              <div class="polishBlockTitle">整体建议</div>
              <div class="suggestionText">{{ polishResult.generalAdvice }}</div>
            </div>
          </div>

          <div v-if="polishLoading" class="polishLoading">
            <span class="loadingDot"></span>
            <span>正在分析内容</span>
          </div>
        </div>

        <div class="field">
          <label class="label">创作说明</label>
          <textarea
            v-model="form.description"
            class="textarea smallTextarea"
            maxlength="500"
            placeholder="请输入创作灵感、背景或说明（选填）"
          ></textarea>
          <div class="hint">{{ form.description.length }}/500</div>
        </div>

        <div class="field">
          <div class="labelRow">
            <label class="label">话题标签</label>
            <span class="contentTip">保留 20 个精选标签，不再铺得太满</span>
          </div>

          <div class="tagInput">
            <div class="tagList" v-if="form.tags.length">
              <span v-for="tag in form.tags" :key="tag" class="tag activeTag">
                #{{ tag }}
                <button class="tagRemove" type="button" @click="removeTag(tag)">×</button>
              </span>
            </div>

            <div class="tagEditor">
              <input
                v-model.trim="tagInput"
                class="tagField"
                maxlength="12"
                placeholder="输入标签后按回车"
                @keydown.enter.prevent="addTag"
              />
              <button class="ghostBtn compactBtn" type="button" @click="addTag">添加</button>
            </div>
          </div>

          <div class="hotTags">
            <button
              v-for="tag in hotTags"
              :key="tag"
              type="button"
              class="hotTag"
              @click="addHotTag(tag)"
            >
              {{ tag }}
            </button>
          </div>
        </div>

        <div class="field">
          <label class="label">可见范围</label>
          <div class="privacyOptions">
            <button
              v-for="item in privacyOptions"
              :key="item.value"
              type="button"
              class="privacyBtn"
              :class="{ active: form.privacy === item.value }"
              @click="form.privacy = item.value"
            >
              {{ item.label }}
            </button>
          </div>
        </div>

        <div class="field">
          <label class="label">封面图片（可选）</label>
          <div class="uploadWrap">
            <input
              ref="fileInput"
              type="file"
              accept="image/png,image/jpeg,image/jpg"
              multiple
              class="hiddenInput"
              @change="handleFileChange"
            />

            <div class="imageGrid">
              <div
                v-for="(preview, idx) in imagePreviews"
                :key="idx"
                class="imageItem"
              >
                <img :src="preview" alt="" />
                <button
                  class="removeImageBtn"
                  type="button"
                  @click="removeImage(idx)"
                >
                  ×
                </button>
              </div>

              <button
                v-if="imageFiles.length < 9"
                type="button"
                class="uploadBtn"
                @click="fileInput?.click()"
              >
                <span>选择图片</span>
              </button>
            </div>
          </div>
          <div class="hint">最多 9 张，支持 JPG、PNG 格式，大图会自动压缩</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { authPost } from "@/utils/api";
import { isLoggedIn } from "@/utils/auth";
import { showError, showSuccess, showWarning } from "@/utils/toast";

const router = useRouter();
const route = useRoute();

const fileInput = ref(null);
const submitting = ref(false);
const tagInput = ref("");

const imageFiles = ref([]);
const imagePreviews = ref([]);

const aiPolishEnabled = ref(false);
const polishResult = ref(null);
const polishLoading = ref(false);
let polishTimer = null;

const createTypes = [
  { key: "poem", label: "诗词创作" },
  { key: "ci", label: "词牌填词" },
  { key: "fu", label: "赋体创作" },
  { key: "couplet", label: "对联创作" },
  { key: "modern", label: "现代诗歌" },
  { key: "calligraphy", label: "书法创作" },
];

const privacyOptions = [
  { value: "public", label: "公开" },
  { value: "followers", label: "仅关注可见" },
  { value: "private", label: "仅自己可见" },
];

const hotTags = [
  "唐诗", "宋词", "元曲", "古风", "原创",
  "山水", "田园", "边塞", "咏物", "抒情",
  "春景", "夏景", "秋景", "冬景",
  "离愁", "思乡", "豪放", "婉约",
  "人生", "哲理",
];

const form = ref({
  title: "",
  content: "",
  description: "",
  tags: [],
  privacy: "public",
  type: "",
});

const selectedType = computed(() => {
  const type = String(route.query.type || "").trim();
  return createTypes.find((item) => item.key === type);
});

const canPublish = computed(() => {
  return !!selectedType.value && !!form.value.content.trim();
});

const onContentChange = () => {
  if (aiPolishEnabled.value && form.value.content.trim()) {
    triggerPolish();
  }
};

const triggerPolish = () => {
  if (polishTimer) clearTimeout(polishTimer);
  polishTimer = setTimeout(() => {
    callPolishAPI();
  }, 800);
};

const callPolishAPI = async () => {
  const content = form.value.content.trim();
  if (!content || content.length < 10) return;

  polishLoading.value = true;
  try {
    const res = await authPost("/api/ai/polish", { content });
    if (res.code === 200) {
      polishResult.value = res.data;
    }
  } catch (error) {
    console.error("润色失败:", error);
  } finally {
    polishLoading.value = false;
  }
};

const toggleAiPolish = () => {
  aiPolishEnabled.value = !aiPolishEnabled.value;
  if (!aiPolishEnabled.value) {
    polishResult.value = null;
    if (polishTimer) clearTimeout(polishTimer);
  } else if (form.value.content.trim()) {
    triggerPolish();
  }
};

const applySuggestion = (suggestion, type) => {
  if (type === "spelling") {
    form.value.content = form.value.content.replace(suggestion.original, suggestion.suggested);
    showSuccess("已应用建议");
    triggerPolish();
  }
};

const applyAllSuggestions = () => {
  let newContent = form.value.content;
  if (polishResult.value?.spellingErrors) {
    polishResult.value.spellingErrors.forEach((err) => {
      newContent = newContent.replace(err.original, err.suggested);
    });
  }
  form.value.content = newContent;
  showSuccess("已应用所有建议");
  triggerPolish();
};

function goBack() {
  router.back();
}

function goSelectType() {
  router.push("/chuangzuo");
}

function addTag() {
  const tag = tagInput.value.trim();
  if (!tag) return;

  if (form.value.tags.includes(tag)) {
    showWarning("标签已存在");
    return;
  }

  if (form.value.tags.length >= 8) {
    showWarning("最多添加 8 个标签");
    return;
  }

  form.value.tags.push(tag);
  tagInput.value = "";
}

function addHotTag(tag) {
  if (form.value.tags.includes(tag)) return;

  if (form.value.tags.length >= 8) {
    showWarning("最多添加 8 个标签");
    return;
  }

  form.value.tags.push(tag);
}

function removeTag(tag) {
  form.value.tags = form.value.tags.filter((item) => item !== tag);
}

async function compressImage(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = (evt) => {
      const img = new Image();
      img.src = evt.target.result;
      img.onload = () => {
        const canvas = document.createElement("canvas");
        let width = img.width;
        let height = img.height;

        const maxWidth = 800;
        if (width > maxWidth) {
          height = (height * maxWidth) / width;
          width = maxWidth;
        }

        canvas.width = width;
        canvas.height = height;
        const ctx = canvas.getContext("2d");
        ctx.drawImage(img, 0, 0, width, height);

        const compressedDataUrl = canvas.toDataURL("image/jpeg", 0.7);

        fetch(compressedDataUrl)
          .then((res) => res.blob())
          .then((blob) => {
            const compressedFile = new File([blob], file.name, { type: "image/jpeg" });
            resolve(compressedFile);
          })
          .catch(reject);
      };
      img.onerror = reject;
    };
    reader.onerror = reject;
  });
}

async function handleFileChange(e) {
  const files = Array.from(e.target.files || []);
  if (!files.length) return;

  const remain = 9 - imageFiles.value.length;
  const picked = files.slice(0, remain);

  for (const file of picked) {
    if (!/^image\/(png|jpe?g)$/i.test(file.type)) {
      showWarning(`图片 ${file.name} 格式不支持，请上传 JPG 或 PNG`);
      continue;
    }

    let finalFile = file;

    if (file.size > 2 * 1024 * 1024) {
      showWarning(`图片 ${file.name} 较大，正在压缩...`);
      try {
        finalFile = await compressImage(file);
        showSuccess(`图片 ${file.name} 压缩完成`);
      } catch (err) {
        console.error("压缩失败:", err);
        showWarning(`图片 ${file.name} 压缩失败，将使用原图`);
      }
    }

    imageFiles.value.push(finalFile);
    const previewUrl = URL.createObjectURL(finalFile);
    imagePreviews.value.push(previewUrl);
  }

  e.target.value = "";
}

function removeImage(index) {
  if (imagePreviews.value[index]) {
    URL.revokeObjectURL(imagePreviews.value[index]);
  }
  imageFiles.value.splice(index, 1);
  imagePreviews.value.splice(index, 1);
}

async function publish() {
  if (!isLoggedIn()) {
    showWarning("暂未登录，请登录后进行");
    router.push("/login");
    return;
  }

  if (!selectedType.value) {
    showWarning("请先选择创作类型");
    return;
  }

  if (!form.value.content.trim()) {
    showWarning("请输入正文内容");
    return;
  }

  if (submitting.value) return;
  submitting.value = true;

  try {
    const formData = new FormData();
    formData.append("title", form.value.title.trim());
    formData.append("content", form.value.content.trim());
    formData.append("description", form.value.description.trim());
    formData.append("type", selectedType.value.key);
    formData.append("privacy", form.value.privacy);

    form.value.tags.forEach((tag) => formData.append("tags", tag));

    for (const file of imageFiles.value) {
      formData.append("images", file);
    }

    const res = await authPost("/api/creations", formData);

    if (res.code === 200 || res.code === 0) {
      showSuccess("发布成功");
      const id = res.data?.id;
      if (id) {
        router.replace(`/chuangzuo/${id}`);
      } else {
        router.replace("/chuangzuo/my");
      }
    } else {
      throw new Error(res.message || "发布失败");
    }
  } catch (e) {
    console.error("发布错误:", e);
    showError(e.message || "发布失败");
  } finally {
    submitting.value = false;
  }
}

onMounted(() => {
  if (!isLoggedIn()) {
    showWarning("暂未登录，请登录后进行");
    router.replace("/login");
    return;
  }

  if (selectedType.value) {
    form.value.type = selectedType.value.key;
  }
});
</script>

<style scoped>
:root {
  --paper: #f6f1e7;
  --paper-soft: #fbf8f2;
  --ink: #342c28;
  --ink-soft: #7b6f66;
  --line: rgba(114, 88, 69, 0.14);
  --red-main: #a66a56;
  --red-soft: rgba(166, 106, 86, 0.1);
  --red-deep: #8e5645;
}

.publishPage {
  position: relative;
  min-height: 100vh;
  background: linear-gradient(180deg, #f4efe6 0%, #f7f3ec 30%, #f5f0e7 100%);
  padding: 24px 0 40px;
  overflow: hidden;
}

.paperTexture,
.paperShade {
  position: fixed;
  inset: 0;
  pointer-events: none;
}

.paperTexture {
  opacity: 0.18;
  background:
    radial-gradient(circle at 12% 10%, rgba(127, 91, 72, 0.04) 0, transparent 28%),
    radial-gradient(circle at 86% 18%, rgba(127, 91, 72, 0.03) 0, transparent 24%),
    radial-gradient(circle at 50% 100%, rgba(127, 91, 72, 0.04) 0, transparent 32%);
}

.paperShade {
  background:
    linear-gradient(180deg, rgba(255, 255, 255, 0.18), transparent 20%, transparent 80%, rgba(141, 107, 80, 0.04));
}

.container {
  position: relative;
  z-index: 1;
  width: min(980px, 94vw);
  margin: 0 auto;
}

.topbar {
  position: sticky;
  top: 0;
  z-index: 10;
  display: grid;
  grid-template-columns: auto 1fr auto;
  align-items: center;
  gap: 16px;
  padding: 14px 0 20px;
  background: linear-gradient(180deg, rgba(246, 241, 231, 0.96), rgba(246, 241, 231, 0.82), rgba(246, 241, 231, 0));
  backdrop-filter: blur(8px);
}

.titleWrap {
  text-align: center;
}

.titleMain {
  font-size: 34px;
  line-height: 1;
  color: var(--ink);
  font-weight: 500;
  letter-spacing: 4px;
}

.titleSub {
  margin-top: 10px;
  font-size: 12px;
  color: rgba(52, 44, 40, 0.45);
  letter-spacing: 3px;
}

.introCard,
.editorCard {
  background: rgba(251, 248, 242, 0.78);
  border: 1px solid var(--line);
  border-radius: 24px;
  box-shadow: 0 8px 30px rgba(66, 48, 39, 0.04);
}

.introCard {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  padding: 20px 22px;
  margin-bottom: 16px;
}

.introLeft {
  min-width: 0;
}

.introMark {
  display: inline-flex;
  align-items: center;
  height: 28px;
  padding: 0 12px;
  border-radius: 999px;
  background: var(--red-soft);
  color: var(--red-deep);
  font-size: 12px;
  font-weight: 700;
}

.introText {
  margin-top: 10px;
  color: var(--ink-soft);
  font-size: 14px;
  line-height: 1.8;
}

.typeBlock,
.typeEmpty {
  flex-shrink: 0;
}

.typeName {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 112px;
  height: 42px;
  padding: 0 18px;
  border-radius: 999px;
  background: rgba(166, 106, 86, 0.12);
  color: var(--red-deep);
  font-weight: 700;
}

.typeEmpty {
  display: flex;
  align-items: center;
  gap: 12px;
  color: var(--ink-soft);
  font-size: 14px;
}

.editorCard {
  padding: 26px 24px 28px;
}

.field + .field {
  margin-top: 24px;
}

.labelRow {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 10px;
}

.label {
  display: block;
  margin-bottom: 10px;
  color: var(--ink);
  font-size: 16px;
  font-weight: 700;
}

.label.required::after {
  content: " *";
  color: #b25a50;
}

.contentTip {
  color: rgba(52, 44, 40, 0.42);
  font-size: 12px;
  white-space: nowrap;
}

.input,
.textarea,
.tagField {
  width: 100%;
  box-sizing: border-box;
  border: 1px solid rgba(114, 88, 69, 0.12);
  background: rgba(255, 253, 249, 0.88);
  color: var(--ink);
  border-radius: 18px;
  outline: none;
  transition: 0.22s ease;
}

.input:focus,
.textarea:focus,
.tagField:focus {
  border-color: rgba(166, 106, 86, 0.42);
  box-shadow: 0 0 0 4px rgba(166, 106, 86, 0.08);
  background: #fffdfa;
}

.input {
  height: 52px;
  padding: 0 16px;
  font-size: 15px;
}

.textarea {
  min-height: 140px;
  padding: 14px 16px;
  font-size: 15px;
  line-height: 1.9;
  resize: vertical;
}

.contentTextarea {
  min-height: 320px;
  background:
    linear-gradient(180deg, rgba(255, 253, 249, 0.98), rgba(251, 248, 242, 0.96));
}

.smallTextarea {
  min-height: 120px;
}

.hint {
  margin-top: 8px;
  color: rgba(52, 44, 40, 0.38);
  font-size: 12px;
}

.aiSection {
  padding: 18px 18px 16px;
  border: 1px solid rgba(114, 88, 69, 0.1);
  border-radius: 20px;
  background: rgba(255, 252, 247, 0.78);
}

.aiTop {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.aiTitleWrap {
  display: flex;
  align-items: center;
  gap: 10px;
}

.aiDot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: var(--red-main);
}

.aiTitle {
  color: var(--ink);
  font-size: 15px;
  font-weight: 700;
}

.aiDesc {
  margin-top: 8px;
  color: rgba(52, 44, 40, 0.48);
  font-size: 13px;
  line-height: 1.7;
}

.toggleSwitch {
  position: relative;
  width: 48px;
  height: 28px;
  padding: 0;
  border: none;
  border-radius: 999px;
  background: rgba(122, 114, 107, 0.22);
  cursor: pointer;
  transition: 0.22s ease;
}

.toggleSwitch.active {
  background: rgba(166, 106, 86, 0.9);
}

.switchKnob {
  position: absolute;
  top: 3px;
  left: 3px;
  width: 22px;
  height: 22px;
  border-radius: 50%;
  background: #fff;
  transition: transform 0.22s ease;
}

.toggleSwitch.active .switchKnob {
  transform: translateX(20px);
}

.polishCard {
  margin-top: 16px;
  padding: 16px;
  border-radius: 18px;
  border: 1px solid rgba(114, 88, 69, 0.1);
  background: rgba(250, 246, 239, 0.92);
}

.polishHeader {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 14px;
  color: var(--ink);
  font-weight: 700;
}

.polishBlock + .polishBlock {
  margin-top: 14px;
}

.polishBlockTitle {
  margin-bottom: 8px;
  color: var(--red-deep);
  font-size: 13px;
  font-weight: 700;
}

.suggestionItem {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 8px;
  padding: 8px 0;
  border-bottom: 1px dashed rgba(114, 88, 69, 0.12);
}

.original {
  color: #b55d57;
  text-decoration: line-through;
}

.suggested {
  color: #577b5f;
  font-weight: 700;
}

.reason,
.suggestionText,
.statusText {
  color: rgba(52, 44, 40, 0.58);
  font-size: 13px;
  line-height: 1.7;
}

.statusLine {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.statusBadge {
  display: inline-flex;
  align-items: center;
  height: 26px;
  padding: 0 10px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 700;
}

.statusBadge.good {
  background: rgba(90, 125, 98, 0.14);
  color: #557a62;
}

.statusBadge.warn {
  background: rgba(179, 126, 79, 0.14);
  color: #9a6a46;
}

.polishLoading {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 14px;
  color: rgba(52, 44, 40, 0.52);
  font-size: 13px;
}

.loadingDot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: var(--red-main);
  animation: blink 1s infinite ease-in-out;
}

@keyframes blink {
  0%, 100% { opacity: 0.35; }
  50% { opacity: 1; }
}

.tagInput {
  padding: 14px;
  border-radius: 18px;
  border: 1px solid rgba(114, 88, 69, 0.1);
  background: rgba(255, 252, 247, 0.84);
}

.tagList {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 14px;
}

.tag {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  height: 34px;
  padding: 0 12px;
  border-radius: 999px;
  font-size: 13px;
  font-weight: 600;
}

.activeTag {
  background: rgba(166, 106, 86, 0.12);
  color: var(--red-deep);
  border: 1px solid rgba(166, 106, 86, 0.16);
}

.tagRemove {
  padding: 0;
  border: none;
  background: transparent;
  color: inherit;
  cursor: pointer;
  font-size: 16px;
  line-height: 1;
}

.tagEditor {
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 10px;
}

.tagField {
  height: 44px;
  padding: 0 14px;
  font-size: 14px;
}

.hotTags,
.privacyOptions {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.hotTags {
  margin-top: 14px;
}

.hotTag,
.privacyBtn,
.ghostBtn,
.compactBtn,
.uploadBtn,
.smallActionBtn,
.miniBtn,
.backBtn,
.publishBtn {
  cursor: pointer;
  transition: 0.22s ease;
}

.hotTag,
.privacyBtn {
  height: 36px;
  padding: 0 14px;
  border-radius: 999px;
  border: 1px solid rgba(114, 88, 69, 0.12);
  background: rgba(255, 252, 247, 0.82);
  color: var(--ink);
  font-size: 13px;
  font-weight: 600;
}

.hotTag:hover,
.privacyBtn:hover {
  border-color: rgba(166, 106, 86, 0.24);
  background: rgba(166, 106, 86, 0.07);
}

.privacyBtn.active {
  border-color: rgba(166, 106, 86, 0.18);
  background: rgba(166, 106, 86, 0.12);
  color: var(--red-deep);
}

.ghostBtn,
.backBtn,
.compactBtn,
.smallActionBtn,
.miniBtn {
  border: 1px solid rgba(114, 88, 69, 0.12);
  background: rgba(255, 252, 247, 0.86);
  color: var(--ink);
}

.ghostBtn,
.backBtn,
.publishBtn {
  height: 42px;
  padding: 0 18px;
  border-radius: 14px;
  font-size: 14px;
  font-weight: 700;
}

.compactBtn,
.smallActionBtn,
.miniBtn {
  border-radius: 12px;
  font-size: 12px;
  font-weight: 700;
}

.compactBtn {
  height: 44px;
  padding: 0 16px;
}

.smallActionBtn {
  height: 34px;
  padding: 0 12px;
}

.miniBtn {
  height: 28px;
  padding: 0 10px;
}

.backBtn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.backBtn svg {
  width: 18px;
  height: 18px;
}

.backBtn:hover,
.ghostBtn:hover,
.compactBtn:hover,
.smallActionBtn:hover,
.miniBtn:hover {
  border-color: rgba(166, 106, 86, 0.22);
  background: rgba(166, 106, 86, 0.08);
}

.publishBtn {
  border: 1px solid rgba(166, 106, 86, 0.18);
  background: rgba(166, 106, 86, 0.9);
  color: #fff;
}

.publishBtn:hover:not(:disabled) {
  background: var(--red-deep);
}

.publishBtn:disabled {
  opacity: 0.55;
  cursor: not-allowed;
}

.hiddenInput {
  display: none;
}

.imageGrid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(118px, 1fr));
  gap: 12px;
}

.imageItem,
.uploadBtn {
  position: relative;
  aspect-ratio: 1 / 1;
  border-radius: 18px;
  overflow: hidden;
  border: 1px solid rgba(114, 88, 69, 0.1);
  background: rgba(255, 252, 247, 0.86);
}

.uploadBtn {
  display: grid;
  place-items: center;
  color: var(--red-deep);
  font-weight: 700;
}

.imageItem img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.removeImageBtn {
  position: absolute;
  top: 8px;
  right: 8px;
  width: 28px;
  height: 28px;
  border: none;
  border-radius: 50%;
  background: rgba(52, 44, 40, 0.58);
  color: #fff;
  cursor: pointer;
}

@media (max-width: 768px) {
  .container {
    width: 96vw;
  }

  .topbar {
    grid-template-columns: auto 1fr auto;
    gap: 10px;
  }

  .titleMain {
    font-size: 24px;
    letter-spacing: 2px;
  }

  .titleSub,
  .contentTip {
    display: none;
  }

  .introCard {
    flex-direction: column;
    align-items: flex-start;
  }

  .editorCard {
    padding: 18px 16px 20px;
  }

  .tagEditor {
    grid-template-columns: 1fr;
  }

  .contentTextarea {
    min-height: 260px;
  }
}
</style>
