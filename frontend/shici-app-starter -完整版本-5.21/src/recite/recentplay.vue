<template>
  <div class="subPage">
    <div class="subHead">
      <div>
        <div class="title">最近播放</div>
        <div class="sub">最近听过的内容会显示在这里</div>
      </div>
    </div>

    <div v-if="loading" class="emptyBox">加载中...</div>

    <div v-else-if="!list.length" class="emptyBox">暂无最近播放记录</div>

    <div v-else class="timeline">
      <div class="item" v-for="item in list" :key="item.id" @click="openItem(item)">
        <div class="thumb" :style="bgImg(item.cover || defaultCover)">
          <button class="playBtn" @click.stop="playItem(item)">▶</button>
        </div>
        <div class="content">
          <div class="name">{{ item.name }}</div>
          <div class="intro">{{ item.intro || "最近播放内容" }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from "vue";
import { getReciteMyRecent } from "@/utils/api";
import defaultCover from "@/assets/game/card_feihua_3.jpg";

const list = ref([]);
const loading = ref(false);

const bgImg = (img) => ({ backgroundImage: `url(${img})` });

const loadData = async () => {
  loading.value = true;
  try {
    const res = await getReciteMyRecent();
    list.value = res?.data || [];
  } catch (e) {
    console.error("加载最近播放失败：", e);
    list.value = [];
  } finally {
    loading.value = false;
  }
};

const openItem = (item) => {
  console.log("打开最近播放：", item);
};

const playItem = (item) => {
  console.log("播放最近内容：", item);
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
.timeline {
  display: flex;
  flex-direction: column;
  gap: 14px;
}
.item {
  display: grid;
  grid-template-columns: 220px 1fr;
  gap: 14px;
  align-items: center;
  border-radius: 18px;
  overflow: hidden;
  background: rgba(255,255,255,.82);
  border: 1px solid rgba(0,0,0,.08);
  padding: 12px;
  cursor: pointer;
  transition: .2s;
}
.item:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 30px rgba(0,0,0,.12);
}
.thumb {
  position: relative;
  height: 130px;
  border-radius: 14px;
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
.content {
  min-width: 0;
}
.name {
  font-weight: 1000;
  font-size: 18px;
}
.intro {
  margin-top: 10px;
  font-size: 14px;
  opacity: 0.72;
  line-height: 1.6;
}
.emptyBox {
  padding: 40px 0;
  text-align: center;
  font-weight: 800;
  opacity: 0.65;
}
@media (max-width: 900px) {
  .item {
    grid-template-columns: 1fr;
  }
  .thumb {
    height: 180px;
  }
}
</style>