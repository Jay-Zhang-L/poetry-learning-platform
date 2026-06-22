<template>
  <div class="page">
    <header class="navBar">
      <button type="button" class="navBack" @click="goBack">‹</button>
      <span class="navTitle">诗人主页</span>
      <span class="navSpacer" />
    </header>

    <div v-if="err" class="banner">{{ err }}</div>
    <div v-else-if="loading" class="banner">加载中…</div>

    <template v-else-if="poet">
      <div class="headCard">
        <img v-if="poet.image_url" class="bigAv" :src="poet.image_url" alt="" />
        <div v-else class="bigAv placeholder">{{ poet.name?.slice(0, 1) }}</div>
        <div class="headTxt">
          <h1 class="name">{{ poet.name }}</h1>
          <div class="dyn">{{ poet.dynasty }}</div>
          <div v-if="life" class="life">{{ life }}</div>
        </div>
      </div>
      <p class="desc">{{ poet.description }}</p>

      <div class="secTitle">TA 的朋友圈</div>
      <ul class="moments">
        <li v-for="m in moments" :key="m.moment_id" class="mItem">
          <p class="mText">{{ m.content }}</p>
          <img v-if="m.image_url" class="mImg" :src="m.image_url" alt="" loading="lazy" />
          <div class="mFoot">
            <span class="likes">♥ {{ m.likes_count ?? 0 }}</span>
            <span class="mTime">{{ m.created_at }}</span>
          </div>
        </li>
        <li v-if="!moments.length" class="empty">暂无动态</li>
      </ul>
    </template>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { fetchPoetDetail } from "@/utils/poetMomentsApi";

const route = useRoute();
const router = useRouter();

const loading = ref(true);
const err = ref("");
const poet = ref(null);

const moments = computed(() => {
  const list = poet.value?.moments;
  return Array.isArray(list) ? list : [];
});

const life = computed(() => {
  const p = poet.value;
  if (!p) return "";
  if (p.birth_year != null && p.death_year != null) {
    return `${p.birth_year} — ${p.death_year}`;
  }
  return "";
});

function poetIdFromRoute() {
  const q = route.query.poet_id ?? route.query.poetId;
  return q != null ? String(q) : "";
}

function goBack() {
  router.back();
}

async function load() {
  const id = poetIdFromRoute();
  if (!id) {
    err.value = "缺少 poet_id";
    poet.value = null;
    loading.value = false;
    return;
  }
  loading.value = true;
  err.value = "";
  try {
    const res = await fetchPoetDetail(id);
    poet.value = res?.data || null;
  } catch (e) {
    err.value = e?.message || "加载失败";
    poet.value = null;
  } finally {
    loading.value = false;
  }
}

onMounted(load);
watch(() => route.query.poet_id, load);
</script>

<style scoped>
.page {
  min-height: 100vh;
  background: #f7f4ee;
  padding-bottom: 24px;
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

.banner {
  margin: 12px 16px;
  padding: 12px;
  background: #fff;
  color: #666;
  text-align: center;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.headCard {
  display: flex;
  gap: 16px;
  padding: 20px;
  background: #fff;
  border-radius: 12px;
  margin: 16px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}
.bigAv {
  width: 80px;
  height: 80px;
  border-radius: 12px;
  object-fit: cover;
  flex-shrink: 0;
  background: #eee;
  border: 1px solid #e5e5e5;
}
.bigAv.placeholder {
  display: grid;
  place-items: center;
  font-size: 32px;
  font-weight: 800;
  color: #fff;
  background: #07c160;
  border: none;
}
.headTxt {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  justify-content: center;
}
.name {
  margin: 0;
  font-size: 22px;
  font-weight: 700;
  color: #000;
}
.dyn {
  margin-top: 8px;
  font-size: 15px;
  color: #576b95;
  font-weight: 600;
}
.life {
  margin-top: 4px;
  font-size: 14px;
  color: #888;
}

.desc {
  margin: 0 16px 16px;
  padding: 16px;
  background: #fff;
  font-size: 16px;
  line-height: 1.6;
  color: #333;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.secTitle {
  padding: 16px 16px 8px;
  font-size: 14px;
  color: #888;
  font-weight: 600;
}

.moments {
  list-style: none;
  margin: 0;
  padding: 0;
}
.mItem {
  background: #fff;
  padding: 16px;
  margin: 0 16px 12px;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}
.mText {
  margin: 0;
  font-size: 16px;
  line-height: 1.55;
  white-space: pre-wrap;
  word-break: break-word;
  color: #000;
}
.mImg {
  margin-top: 12px;
  max-width: 100%;
  max-height: 400px;
  object-fit: cover;
  border-radius: 8px;
  display: block;
}
.mFoot {
  margin-top: 12px;
  display: flex;
  justify-content: space-between;
  font-size: 13px;
  color: #b2b2b2;
}
.likes {
  color: #576b95;
  font-weight: 500;
}

.empty {
  margin: 16px;
  padding: 32px 16px;
  text-align: center;
  color: #999;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}
</style>