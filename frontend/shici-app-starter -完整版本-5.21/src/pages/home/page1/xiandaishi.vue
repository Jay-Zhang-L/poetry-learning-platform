<template>
  <div class="theme-page-container">
    <!-- iframe 主题内容 -->
    <div class="theme-iframe-wrapper">
      <iframe
        :src="themeUrl"
        class="theme-iframe"
        frameborder="0"
        allowfullscreen
        @load="onIframeLoad">
      </iframe>

      <!-- 加载指示器 -->
      <div v-if="isLoading" class="theme-loading">
        <div class="loading-spinner"></div>
        <p>正在加载{{ themeName }}...</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

// 主题配置
const themes = [
  { name: 'SHI', chineseName: '诗', num: 1 },
  { name: 'GE', chineseName: '歌', num: 2 },
  { name: 'FU', chineseName: '赋', num: 3 },
  { name: 'CI', chineseName: '词', num: 4 },
  { name: 'QU', chineseName: '曲', num: 5 },
  { name: 'XIANDAISHI', chineseName: '现代诗', num: 6 }
]

// 响应式数据
const isLoading = ref(true)

// 获取当前主题编号
const currentThemeNum = computed(() => {
  const pathMap = {
    '/home/page1/shi': 1,
    '/home/page1/ge': 2,
    '/home/page1/fu': 3,
    '/home/page1/ci': 4,
    '/home/page1/qu': 5,
    '/home/page1/xiandaishi': 6
  }
  return pathMap[route.path] || 6
})

// 当前主题
const currentTheme = computed(() => {
  return themes[currentThemeNum.value - 1] || themes[0]
})

// iframe URL
const themeUrl = computed(() => {
  // 在iframe加载前，先将主题编号存入localStorage
  setTimeout(() => {
    localStorage.setItem('songPaintedTheme', currentTheme.value.num)
    console.log(`[a${currentThemeNum.value}] 设置localStorage主题:`, currentTheme.value.num)
  }, 0)

  // 直接指向index.html避免参数丢失
  return `/song-painted/index.html?num=${currentTheme.value.num}`
})

// 主题名称
const themeName = computed(() => currentTheme.value.chineseName)

// iframe 加载完成
function onIframeLoad() {
  isLoading.value = false
  console.log(`主题 ${themeName.value} 加载完成`)
}

// 生命周期
onMounted(() => {
  console.log(`加载主题页面: ${themeUrl.value}`)
  console.log(`当前主题: ${themeName.value}`)
})
</script>

<style scoped>
.theme-page-container {
  width: 100%;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.theme-iframe-wrapper {
  flex: 1;
  position: relative;
  overflow: hidden;
}

.theme-iframe {
  width: 100%;
  height: 100vh;
  border: none;
}

.theme-loading {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  text-align: center;
  color: #dcdcc8;
  z-index: 100;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #667eea;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 10px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>