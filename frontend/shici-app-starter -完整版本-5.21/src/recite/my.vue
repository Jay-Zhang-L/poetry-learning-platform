<template>
  <div class="subPage">
    <div class="subHead">
      <div>
        <div class="title">我的收藏</div>
        <div class="sub">你收藏过的朗诵内容</div>
      </div>
    </div>

    <div v-if="loading" class="emptyBox">加载中...</div>

    <div v-else-if="!list.length" class="emptyBox">你还没有收藏内容</div>

    <div v-else class="grid">
      <div class="card" v-for="item in list" :key="item.id" @click="openItem(item)">
        <div class="cover" :style="bgImg(item.cover || defaultCover)">
          <button class="playBtn" @click.stop="playItem(item)">▶</button>
        </div>
        <div class="info">
          <div class="name">{{ item.name }}</div>
          <div class="intro">{{ item.intro || "已加入收藏" }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from "vue";
import { getReciteMyFavorites } from "@/utils/api";
import defaultCover from "@/assets/game/card_feihua_3.jpg";

const list = ref([]);
const loading = ref(false);

const bgImg = (img) => ({ backgroundImage: `url(${img})` });

const loadData = async () => {
  loading.value = true;
  try {
    const res = await getReciteMyFavorites();
    list.value = res?.data || [];
  } catch (e) {
    console.error("加载我的收藏失败：", e);
    list.value = [];
  } finally {
    loading.value = false;
  }
};

const openItem = (item) => {
  console.log("打开收藏：", item);
};

const playItem = (item) => {
  console.log("播放收藏：", item);
};

onMounted(loadData);
</script>

<style scoped>
.subPage {
  padding: 8px 0 0;
}
.subHead {
  margin-bottom: 14px;
}
.title {
  font-size: 26px;
  font-weight: 1000;
}
.sub {
  margin-top: 6px;
  opacity: 0.7;
  font-weight: 700;
}
.grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 14px;
}
.card {
  border-radius: 18px;
  overflow: hidden;
  background: rgba(255,255,255,.82);
  border: 1px solid rgba(0,0,0,.08);
  cursor: pointer;
  transition: .2s;
}
.card:hover {
  transform: translateY(-3px);
  box-shadow: 0 12px 30px rgba(0,0,0,.12);
}
.cover {
  position: relative;
  height: 170px;
  background-size: cover;
  background-position: center;
}
.playBtn {
  position: absolute;
  right: 12px;
  bottom: 12px;
  width: 38px;
  height: 38px;
  border-radius: 999px;
  border: 1px solid rgba(255,255,255,.35);
  background: rgba(20,20,20,.5);
  color: #fff;
  font-weight: 900;
  cursor: pointer;
}
.info {
  padding: 12px;
}
.name {
  font-weight: 1000;
  font-size: 16px;
}
.intro {
  margin-top: 8px;
  font-size: 13px;
  opacity: 0.7;
  line-height: 1.5;
}
.emptyBox {
  padding: 40px 0;
  text-align: center;
  font-weight: 800;
  opacity: 0.65;
}
@media (max-width: 1200px) {
  .grid { grid-template-columns: repeat(3, 1fr); }
}
@media (max-width: 900px) {
  .grid { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 640px) {
  .grid { grid-template-columns: 1fr; }
}
</style>