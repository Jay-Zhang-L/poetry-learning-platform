<template>
  <div class="pageWrap">
    <!-- 背景 -->
    <div class="bg" :style="{ backgroundImage: `url(${bg})` }"></div>

    <!-- 顶部返回 -->
    <div class="topBar">
      <button class="backBtn" @click="goBack">返回</button>
    </div>

    <!-- 主内容 -->
    <div class="content">
      <div class="title">{{ title }}</div>
      <div class="desc">{{ desc }}</div>

      <!-- 示例内容区域 -->
      <div class="list">
        <div class="card" v-for="i in 8" :key="i">
          <div class="cardTitle">诗词示例 {{ i }}</div>
          <div class="cardText">这里放对应分类的诗词内容</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import bg from '@/assets/home/scroll/4.jpg'   // 每个页面可以换不同图

const router = useRouter()

const title = '古体诗'
const desc = '山水入诗 · 意境悠远'

function goBack() {
  router.back()
}
</script>

<style scoped>
.pageWrap {
  width: 100vw;
  height: 100vh;
  overflow-y: auto;
  position: relative;
  color: #fff;
}

/* 背景 */
.bg {
  position: fixed;
  inset: 0;
  background-size: cover;
  background-position: center;
  filter: brightness(0.55);
  z-index: 0;
}

/* 顶部 */
.topBar {
  position: fixed;
  top: 20px;
  left: 20px;
  z-index: 10;
}

.backBtn {
  padding: 8px 18px;
  background: rgba(0,0,0,0.4);
  border: none;
  color: #fff;
  cursor: pointer;
}

/* 内容 */
.content {
  position: relative;
  z-index: 2;
  padding: 120px 60px 60px;
}

.title {
  font-size: 64px;
  font-weight: 600;
  margin-bottom: 10px;
}

.desc {
  font-size: 18px;
  opacity: 0.8;
  margin-bottom: 40px;
}

/* 卡片 */
.list {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.card {
  background: rgba(0,0,0,0.4);
  padding: 20px;
  transition: all 0.3s;
}

.card:hover {
  transform: translateY(-6px);
}

.cardTitle {
  font-size: 18px;
  margin-bottom: 10px;
}

.cardText {
  font-size: 14px;
  opacity: 0.8;
}
</style>