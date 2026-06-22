<template>
  <nav class="poetry-navigation">
    <div class="nav-container">
      <div class="nav-items">
        <router-link to="/home" class="nav-item" :class="{ active: currentPath === '/home' }">
          首页
        </router-link>
        <div class="nav-divider"></div>

        <router-link to="/home/page4/shi" class="nav-item" :class="{ active: currentPath === '/home/page4/shi' }">
          <span class="nav-text">诗</span>
        </router-link>
        <div class="nav-divider"></div>

        <router-link to="/home/page4/ge" class="nav-item" :class="{ active: currentPath === '/home/page4/ge' }">
          <span class="nav-text">歌</span>
        </router-link>
        <div class="nav-divider"></div>

        <router-link to="/home/page4/fu" class="nav-item" :class="{ active: currentPath === '/home/page4/fu' }">
          <span class="nav-text">赋</span>
        </router-link>
        <div class="nav-divider"></div>

        <router-link to="/home/page4/ci" class="nav-item" :class="{ active: currentPath === '/home/page4/ci' }">
          <span class="nav-text">词</span>
        </router-link>
        <div class="nav-divider"></div>

        <router-link to="/home/page4/qu" class="nav-item" :class="{ active: currentPath === '/home/page4/qu' }">
          <span class="nav-text">曲</span>
        </router-link>
        <div class="nav-divider"></div>

        <router-link to="/home/page4/xiandaishi" class="nav-item" :class="{ active: currentPath === '/home/page4/xiandaishi' }">
          <span class="nav-text">现代诗</span>
        </router-link>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const currentPath = computed(() => route.path)
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;600;700&display=swap');

.poetry-navigation {
  width: 100%;
  padding: 0.5rem 0 0.5rem 30px; /* 减少到2/3高度 */
  background: white;
  border-top: 1px solid #F5F1E8; /* 极细的浅米色描边 */
  border-bottom: 1px solid #F5F1E8; /* 极细的浅米色描边 */
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03); /* 极淡的阴影，弱化边界感 */
}

.nav-container {
  /* 移除居中和最大宽度限制 */
}

.nav-items {
  display: flex;
  align-items: center;
  gap: 0;
  padding: 0.3rem 0; /* 减少内边距 */
  /* 移除背景、边框、圆角、阴影 */
}

.nav-item {
  font-family: 'Noto Serif SC', 'STSong', 'SimSun', serif;
  font-size: 1rem;
  font-weight: 600;
  color: #333333;
  text-decoration: none;
  padding: 0.4rem 0.8rem; /* 减少padding */
  transition: all 0.3s ease;
  position: relative;
  border-radius: 4px;
}

.nav-item:hover {
  color: #8B7355;
  background: rgba(139, 115, 85, 0.06);
}

.nav-item.active {
  color: #D4AF37; /* 金色 */
  font-size: 1.1rem; /* 选中态字号稍大 */
  font-weight: 700;
}

.nav-item.active .nav-text {
  background: linear-gradient(135deg, #D4AF37 0%, #F4D03F 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.nav-text {
  display: inline-block;
}

.nav-divider {
  width: 1px;
  height: 16px; /* 稍微缩短 */
  background: #CCCCCC;
  margin: 0 0.8rem; /* 减小间距 */
  border-left: 1px dashed #999999;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .poetry-navigation {
    padding: 0.4rem 0 0.4rem 15px; /* 移动端减小到2/3 */
  }

  .nav-items {
    gap: 0.3rem;
    padding: 0.2rem 0; /* 减少内边距 */
    overflow-x: auto;
    justify-content: flex-start;
    white-space: nowrap;
  }

  .nav-item {
    font-size: 0.9rem;
    padding: 0.3rem 0.6rem; /* 减少padding */
  }

  .nav-divider {
    margin: 0 0.5rem;
    height: 14px;
  }
}

/* 平板端 */
@media (min-width: 769px) and (max-width: 1024px) {
  .nav-item {
    font-size: 0.95rem;
    padding: 0.4rem 0.7rem; /* 减少padding */
  }

  .nav-divider {
    margin: 0 0.7rem;
  }
}

/* 大屏优化 */
@media (min-width: 1400px) {
  .poetry-navigation {
    padding: 0.6rem 0 0.6rem 30px; /* 大屏减少到2/3 */
  }

  .nav-items {
    padding: 0.3rem 0; /* 减少内边距 */
  }

  .nav-item {
    font-size: 1.1rem;
    padding: 0.5rem 1rem; /* 减少padding */
  }

  .nav-divider {
    margin: 0 1rem;
  }
}
</style>