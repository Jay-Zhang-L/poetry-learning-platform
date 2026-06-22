<template>
  <div class="momentsPage">
    <header class="navBar">
      <button type="button" class="navBack" @click="goBack" aria-label="返回">‹</button>
      <span class="navTitle">诗人朋友圈</span>
      <button type="button" class="navLink" @click="goRecords">记录</button>
    </header>

    <div class="coverZone">
      <div class="coverImg" aria-hidden="true" />
      <div class="coverGradient" aria-hidden="true" />
    </div>

    <div class="feedHairline" />

    <main class="feed">
      <div v-if="loadErr" class="stateCard err">{{ loadErr }}</div>
      <div v-else-if="loading" class="stateCard">
        <span class="stateSpinner" aria-hidden="true" />
        加载中…
      </div>

      <article v-else-if="moment" class="momentCard">
        <div class="row">
          <div class="avatar mystery" aria-hidden="true">?</div>
          <div class="body">
            <div class="nickname">某位诗人</div>
            <p class="text">{{ moment.content }}</p>
            <div v-if="moment.image_url" class="photoWrap">
              <img class="photo" :src="moment.image_url" alt="" loading="lazy" @error="onImgErr" />
            </div>

            <div class="locHint" v-if="moment.image_url">猜猜是谁发的</div>

            <div class="momentFooter">
              <div class="footerLeft">
                <span class="time">{{ timeLabel }}</span>
                <span v-if="!moment.image_url" class="hint">猜猜是谁发的</span>
              </div>
              <div class="footerRight" ref="moreWrapRef">
                <button
                  type="button"
                  class="moreBtn"
                  :disabled="loading || submitting"
                  title="更多"
                  :aria-expanded="moreMenuOpen"
                  aria-haspopup="true"
                  aria-label="更多"
                  @click.stop="toggleMoreMenu"
                >
                  <span class="moreDots">⋯</span>
                </button>
                <div v-if="moreMenuOpen" class="moreMenu" role="menu" @click.stop>
                  <button type="button" class="moreMenuItem" role="menuitem" @click="onMenuRefresh">
                    换一条动态
                  </button>
                  <button type="button" class="moreMenuItem cancel" role="menuitem" @click="moreMenuOpen = false">
                    取消
                  </button>
                </div>
              </div>
            </div>

            <div class="guessLabel">你认为是谁？</div>
            <div class="guessBar">
              <button
                v-for="opt in moment.options"
                :key="opt.option_id"
                type="button"
                class="optBtn"
                :disabled="submitting"
                @click="pick(opt)"
              >
                {{ opt.poet_name }}
              </button>
            </div>

            <button type="button" class="linkRefresh" :disabled="loading || submitting" @click="refresh">
              换一条动态
            </button>
          </div>
        </div>
      </article>
    </main>

    <transition name="fade">
      <div v-if="resultOpen" class="mask" @click.self="closeResult">
        <div class="sheet" @click.stop>
          <div class="sheetGrab" aria-hidden="true" />
          <div class="sheetTitle">{{ result?.is_correct ? "猜对了" : "猜错了" }}</div>
          <p class="sheetSub">
            正确答案：<b>{{ result?.correct_poet_name }}</b>
          </p>
          <div v-if="result?.poet_info" class="miniPoet" @click="openPoet(result.correct_poet_id)">
            <img v-if="result.poet_info.image_url" class="miniImg" :src="result.poet_info.image_url" alt="" />
            <div v-else class="miniImg miniImgPh">{{ result.poet_info.name?.slice(0, 1) }}</div>
            <div class="miniTxt">
              <div class="miniName">{{ result.poet_info.name }}</div>
              <div class="miniDyn">{{ result.poet_info.dynasty }}</div>
            </div>
            <span class="chev">›</span>
          </div>
          <div class="sheetActions">
            <button type="button" class="primary" @click="afterResult">继续玩</button>
            <button type="button" class="ghost" @click="closeResult">关闭</button>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { computed, ref, onMounted, onUnmounted } from "vue";
import { useRouter } from "vue-router";
import { fetchRandomMoment, submitMomentAnswer } from "@/utils/poetMomentsApi";
import poetMomentsBg from "@/assets/game/poet-moments-bg.jpg";

const router = useRouter();

const coverBgUrl = `url("${poetMomentsBg}")`;

const loading = ref(true);
const submitting = ref(false);
const loadErr = ref("");
const moment = ref(null);
const resultOpen = ref(false);
const result = ref(null);
const moreMenuOpen = ref(false);
const moreWrapRef = ref(null);



const timeLabel = computed(() => {
  const d = new Date();
  const pad = (n) => String(n).padStart(2, "0");
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
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
  router.push("/game").catch(() => {});
}

function goRecords() {
  router.push("/game/poet-moments/records").catch(() => {});
}

function openPoet(poetId) {
  if (poetId == null) return;
  router.push({ path: "/game/poet-moments/poet", query: { poet_id: String(poetId) } }).catch(() => {});
}

async function loadMoment() {
  loading.value = true;
  loadErr.value = "";
  try {
    const res = await fetchRandomMoment();
    moment.value = res?.data || null;
  } catch (e) {
    loadErr.value = e?.message || "加载失败";
    moment.value = null;
  } finally {
    loading.value = false;
  }
}

function refresh() {
  resultOpen.value = false;
  result.value = null;
  moreMenuOpen.value = false;
  loadMoment();
}

function toggleMoreMenu() {
  moreMenuOpen.value = !moreMenuOpen.value;
}

function onMenuRefresh() {
  moreMenuOpen.value = false;
  refresh();
}

function onDocPointerDown(e) {
  if (!moreMenuOpen.value) return;
  const el = moreWrapRef.value;
  if (el && !el.contains(e.target)) {
    moreMenuOpen.value = false;
  }
}

async function pick(opt) {
  if (!moment.value || submitting.value) return;
  submitting.value = true;
  try {
    const res = await submitMomentAnswer({
      user_id: currentUserId(),
      moment_id: moment.value.moment_id,
      selected_poet_id: opt.poet_id,
    });
    result.value = res?.data || null;
    moreMenuOpen.value = false;
    resultOpen.value = true;
  } catch (e) {
    alert(e?.message || "提交失败");
  } finally {
    submitting.value = false;
  }
}

function closeResult() {
  resultOpen.value = false;
}

function afterResult() {
  closeResult();
  refresh();
}

function onImgErr(e) {
  e.target.style.display = "none";
}

onMounted(() => {
  loadMoment();
  document.addEventListener("pointerdown", onDocPointerDown, true);
});
onUnmounted(() => {
  document.removeEventListener("pointerdown", onDocPointerDown, true);
});
</script>

<style scoped>
.momentsPage {
  min-height: 100vh;
  min-height: 100dvh;
  background: #ededed;
  padding-bottom: calc(24px + env(safe-area-inset-bottom, 0px));
  font-family:
    -apple-system,
    BlinkMacSystemFont,
    "Helvetica Neue",
    "PingFang SC",
    "Hiragino Sans GB",
    "Microsoft YaHei",
    sans-serif;
  -webkit-font-smoothing: antialiased;
}

.navBar {
  position: sticky;
  top: 0;
  z-index: 20;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 44px;
  padding: 0 12px;
  padding-top: env(safe-area-inset-top, 0px);
  height: calc(44px + env(safe-area-inset-top, 0px));
  background: #1a1a1a;
  color: rgba(255, 255, 255, 0.95);
  font-size: 17px;
  font-weight: 600;
  letter-spacing: 0.02em;
  box-shadow: inset 0 -1px 0 rgba(255, 255, 255, 0.06);
}

.navBack,
.navLink {
  position: absolute;
  top: env(safe-area-inset-top, 0px);
  height: 44px;
  padding: 0 14px;
  border: none;
  background: transparent;
  color: rgba(255, 255, 255, 0.92);
  font-size: 28px;
  line-height: 44px;
  cursor: pointer;
  -webkit-tap-highlight-color: transparent;
}
.navBack {
  left: 4px;
  font-weight: 300;
}
.navLink {
  right: 4px;
  font-size: 16px;
  font-weight: 400;
}

.coverZone {
  position: relative;
  height: 260px;
  background: #6b6b6b;
}
.coverImg {
  height: 100%;
  background-image: v-bind(coverBgUrl);
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
}
.coverGradient {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 120px;
  background: linear-gradient(to top, rgba(0, 0, 0, 0.45) 0%, transparent 100%);
  pointer-events: none;
}



.feedHairline {
  height: 1px;
  background: #dcdcdc;
  margin-top: 24px;
  margin-bottom: 0;
}

.feed {
  margin-top: 0;
  padding: 0 0 16px;
  background: #ededed;
}

.stateCard {
  margin: 12px 0 0;
  padding: 28px 16px;
  background: #fff;
  text-align: center;
  color: #888;
  font-size: 15px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  border-top: 1px solid #e3e3e3;
  border-bottom: 1px solid #e3e3e3;
}
.stateCard.err {
  color: #fa5151;
}
.stateSpinner {
  width: 18px;
  height: 18px;
  border: 2px solid #e0e0e0;
  border-top-color: #07c160;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.momentCard {
  background: #fff;
  padding: 14px 16px 16px;
  border-top: 1px solid #e3e3e3;
  border-bottom: 1px solid #e3e3e3;
  margin-top: 0;
}

.row {
  display: flex;
  gap: 11px;
  align-items: flex-start;
}

.avatar {
  width: 42px;
  height: 42px;
  border-radius: 4px;
  flex-shrink: 0;
  background: #cfcfcf;
  display: grid;
  place-items: center;
  font-size: 18px;
  font-weight: 700;
  color: #5c5c5c;
}
.avatar.mystery {
  background: linear-gradient(160deg, #e8e8e8 0%, #bdbdbd 100%);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.6);
}

.body {
  flex: 1;
  min-width: 0;
  padding-top: 1px;
}

.nickname {
  font-size: 17px;
  font-weight: 600;
  color: #576b95;
  margin-bottom: 5px;
  line-height: 1.2;
}

.text {
  margin: 0;
  font-size: 16px;
  line-height: 1.55;
  color: #111;
  word-break: break-word;
  white-space: pre-wrap;
  letter-spacing: 0.01em;
}

/* 宽度随真实图片收缩，避免小图两侧出现灰条；大图仍不超过约屏宽的 2/3（仿朋友圈单图） */
.photoWrap {
  margin-top: 12px;
  width: fit-content;
  max-width: min(300px, 100%);
  border-radius: 8px;
  overflow: hidden;
  background: #f2f2f2;
  border: 1px solid rgba(0, 0, 0, 0.08);
  box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}
.photo {
  display: block;
  width: auto;
  max-width: 100%;
  max-height: 400px;
  object-fit: cover;
  vertical-align: middle;
}

.locHint {
  margin-top: 8px;
  font-size: 13px;
  color: #888;
}

.momentFooter {
  margin-top: 10px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  min-height: 22px;
}
.footerLeft {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 8px;
  font-size: 14px;
  color: #b2b2b2;
}
.time {
  color: #b2b2b2;
}
.hint {
  color: #8e8e8e;
  font-size: 13px;
}
.footerRight {
  flex-shrink: 0;
  position: relative;
}
.moreMenu {
  position: absolute;
  right: 0;
  top: calc(100% + 6px);
  z-index: 30;
  min-width: 132px;
  padding: 4px 0;
  background: #4c4c4c;
  border-radius: 6px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.22);
}
.moreMenu::before {
  content: "";
  position: absolute;
  right: 10px;
  top: -5px;
  width: 0;
  height: 0;
  border-left: 5px solid transparent;
  border-right: 5px solid transparent;
  border-bottom: 5px solid #4c4c4c;
}
.moreMenuItem {
  display: block;
  width: 100%;
  padding: 10px 16px;
  border: none;
  background: none;
  color: #fff;
  font-size: 15px;
  text-align: left;
  cursor: pointer;
  -webkit-tap-highlight-color: transparent;
}
.moreMenuItem:active {
  background: rgba(255, 255, 255, 0.08);
}
.moreMenuItem.cancel {
  color: rgba(255, 255, 255, 0.75);
  border-top: 1px solid rgba(255, 255, 255, 0.12);
  margin-top: 2px;
  padding-top: 10px;
}
.moreBtn {
  width: 36px;
  height: 22px;
  padding: 0;
  border: none;
  border-radius: 4px;
  background: #f7f7f7;
  cursor: pointer;
  display: grid;
  place-items: center;
  -webkit-tap-highlight-color: transparent;
}
.moreBtn:disabled {
  opacity: 0.45;
  cursor: not-allowed;
}
.moreBtn:active:not(:disabled) {
  background: #ebebeb;
}
.moreDots {
  display: block;
  font-size: 18px;
  line-height: 1;
  color: #576b95;
  font-weight: 700;
  letter-spacing: -0.12em;
  transform: translateY(-1px);
}

.guessLabel {
  margin-top: 14px;
  font-size: 13px;
  color: #8e8e8e;
  margin-bottom: 8px;
}

.guessBar {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 8px;
}
.optBtn {
  padding: 11px 10px;
  border-radius: 4px;
  border: 1px solid #e5e5e5;
  background: #fafafa;
  font-size: 15px;
  color: #333;
  cursor: pointer;
  text-align: center;
  -webkit-tap-highlight-color: transparent;
  transition: background 0.12s ease;
}
.optBtn:active:not(:disabled) {
  background: #f0f0f0;
}
.optBtn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.linkRefresh {
  margin-top: 14px;
  padding: 0;
  border: none;
  background: none;
  font-size: 14px;
  color: #576b95;
  cursor: pointer;
  -webkit-tap-highlight-color: transparent;
}
.linkRefresh:disabled {
  opacity: 0.45;
  cursor: not-allowed;
}

.mask {
  position: fixed;
  inset: 0;
  z-index: 100;
  margin: 0;
  padding: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  align-items: stretch;
}

.sheet {
  width: 100%;
  max-width: 100%;
  margin: 0;
  background: #f7f7f7;
  border-radius: 12px 12px 0 0;
  padding: 8px 16px calc(20px + env(safe-area-inset-bottom, 0px));
  box-sizing: border-box;
  box-shadow: none;
  flex-shrink: 0;
  transform: translateZ(0);
  -webkit-backface-visibility: hidden;
  backface-visibility: hidden;
}
.sheetGrab {
  width: 36px;
  height: 4px;
  border-radius: 2px;
  background: #d0d0d0;
  margin: 0 auto 14px;
}
.sheetTitle {
  font-size: 18px;
  font-weight: 600;
  text-align: center;
  color: #000;
}
.sheetSub {
  margin: 10px 0 0;
  text-align: center;
  font-size: 15px;
  color: #555;
  line-height: 1.45;
}

.miniPoet {
  margin-top: 16px;
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  background: #fff;
  border-radius: 8px;
  border: 1px solid #e6e6e6;
  cursor: pointer;
  -webkit-tap-highlight-color: transparent;
}
.miniImg {
  width: 48px;
  height: 48px;
  border-radius: 4px;
  object-fit: cover;
  background: #eee;
  flex-shrink: 0;
}
.miniImgPh {
  display: grid;
  place-items: center;
  font-size: 18px;
  font-weight: 600;
  color: #666;
  background: #eaeaea;
}
.miniTxt {
  flex: 1;
  min-width: 0;
}
.miniName {
  font-size: 16px;
  font-weight: 600;
  color: #000;
}
.miniDyn {
  font-size: 13px;
  color: #888;
  margin-top: 2px;
}
.chev {
  font-size: 20px;
  color: #c6c6c6;
  font-weight: 300;
}

.sheetActions {
  margin-top: 18px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.sheetActions .primary,
.sheetActions .ghost {
  height: 46px;
  border-radius: 8px;
  font-size: 17px;
  font-weight: 500;
  cursor: pointer;
  border: none;
  -webkit-tap-highlight-color: transparent;
}
.sheetActions .primary {
  background: #07c160;
  color: #fff;
}
.sheetActions .primary:active {
  filter: brightness(0.96);
}
.sheetActions .ghost {
  background: #fff;
  color: #333;
  border: 1px solid #d9d9d9;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.22s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
