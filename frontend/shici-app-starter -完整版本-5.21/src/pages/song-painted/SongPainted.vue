<template>
  <div class="song-painted-container" :class="{ 'fullscreen': isFullscreen }">
    <!-- 错误提示 -->
    <div v-if="loadError" class="error-fallback">
      <div class="error-content">
        <h3>⚠️ 千年调内容加载失败</h3>
        <p>{{ errorMessage }}</p>
        <button @click="retryLoading" class="retry-btn">重新加载</button>
        <p class="error-details">错误详情: {{ errorDetails }}</p>
      </div>
    </div>

    <!-- 加载指示器 -->
    <div v-if="isLoading && !loadError" class="loading-indicator">
      <div class="loading-content">
        <div class="spinner"></div>
        <p>正在加载千年调内容...</p>
      </div>
    </div>

    <!-- iframe -->
    <iframe
      v-show="!loadError"
      ref="songPaintedFrame"
      src="/song-painted/index.html"
      frameborder="0"
      allowfullscreen
      sandbox="allow-scripts allow-same-origin allow-forms allow-presentation allow-popups"
      @load="onIframeLoad"
      @error="onIframeError"
    ></iframe>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const songPaintedFrame = ref(null)
const isFullscreen = ref(false)
const isLoading = ref(true)
const loadError = ref(false)
const errorMessage = ref('')
const errorDetails = ref('')

const enterFullscreen = () => {
  isFullscreen.value = true
  document.documentElement.style.overflow = 'hidden'
}

const exitFullscreen = () => {
  isFullscreen.value = false
  document.documentElement.style.overflow = ''
}

const onIframeLoad = () => {
  try {
    isLoading.value = false
    loadError.value = false
    console.log('[SongPainted] iframe加载成功')
  } catch (error) {
    handleLoadError('iframe加载处理失败', error)
  }
}

const onIframeError = (error) => {
  handleLoadError('iframe加载失败', error)
}

const handleLoadError = (message, error) => {
  // 如果iframe已经成功加载，忽略后续的错误警告
  if (!isLoading.value && !loadError.value) {
    console.warn('[SongPainted] 忽略iframe加载后的非关键错误:', message)
    return
  }

  console.error('[SongPainted] 加载错误:', message, error)
  isLoading.value = false
  loadError.value = true
  errorMessage.value = message
  errorDetails.value = error?.message || '未知错误'
}

const retryLoading = () => {
  isLoading.value = true
  loadError.value = false
  errorMessage.value = ''
  errorDetails.value = ''

  // 重新加载iframe
  if (songPaintedFrame.value) {
    songPaintedFrame.value.src = songPaintedFrame.value.src
  }
}

// 监听iframe内部消息
const handleMessage = (event) => {
  try {
    // 验证消息来源
    if (event.origin !== window.location.origin) {
      console.warn('[SongPainted] 忽略非同源消息:', event.origin)
      return
    }

    // 处理来自千年调的消息
    if (event.data.type === 'ENTER_FULLSCREEN') {
      enterFullscreen()
    } else if (event.data.type === 'EXIT_FULLSCREEN') {
      exitFullscreen()
    } else if (event.data.type === 'LOAD_ERROR') {
      handleLoadError('千年调内容加载失败', event.data.error)
    } else if (event.data.type === 'LOAD_SUCCESS') {
      isLoading.value = false
      loadError.value = false
    }
  } catch (error) {
    console.error('[SongPainted] 消息处理错误:', error)
  }
}

onMounted(() => {
  window.addEventListener('message', handleMessage)
  console.log('[SongPainted] 组件已挂载，等待iframe加载...')

  // 设置超时检测
  setTimeout(() => {
    if (isLoading.value) {
      console.warn('[SongPainted] iframe加载超时')
      handleLoadError('内容加载超时，请检查网络连接', new Error('加载超时 (10s)'))
    }
  }, 10000) // 10秒超时
})

onUnmounted(() => {
  window.removeEventListener('message', handleMessage)
  exitFullscreen()
})
</script>

<style scoped>
.song-painted-container {
  width: 100%;
  height: 100vh;
  position: relative;
}

.song-painted-container.fullscreen {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  z-index: 9999;
  background: #000;
}

.song-painted-container iframe {
  width: 100%;
  height: 100%;
  border: none;
}

/* 加载指示器样式 */
.loading-indicator {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.9);
  z-index: 10;
}

.loading-content {
  text-align: center;
}

.spinner {
  width: 50px;
  height: 50px;
  margin: 0 auto 20px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading-content p {
  font-size: 16px;
  color: #333;
  margin: 0;
}

/* 错误提示样式 */
.error-fallback {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.95);
  z-index: 20;
}

.error-content {
  text-align: center;
  padding: 40px;
  max-width: 500px;
}

.error-content h3 {
  color: #e74c3c;
  margin-bottom: 20px;
  font-size: 24px;
}

.error-content p {
  color: #333;
  margin-bottom: 30px;
  font-size: 16px;
  line-height: 1.5;
}

.error-details {
  font-size: 14px;
  color: #7f8c8d;
  font-style: italic;
  margin-top: 20px;
}

.retry-btn {
  background: #3498db;
  color: white;
  border: none;
  padding: 12px 30px;
  font-size: 16px;
  border-radius: 5px;
  cursor: pointer;
  transition: background 0.3s;
}

.retry-btn:hover {
  background: #2980b9;
}

.retry-btn:active {
  transform: scale(0.98);
}
</style>
