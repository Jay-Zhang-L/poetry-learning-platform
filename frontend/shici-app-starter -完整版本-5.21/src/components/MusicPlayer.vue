<template>
  <div class="music-player">
    <audio
      ref="audioRef"
      :src="musicSrc"
      loop
      preload="auto"
      @canplay="onCanPlay"
      @play="onPlay"
      @pause="onPause"
      @error="onError"
    />
  </div>
</template>

<script setup>
import { ref, nextTick } from 'vue'
import musicSrc from '@/assets/music/魏小涵 - 飞雪玉花_H.ogg'

const audioRef = ref(null)
const isPlaying = ref(false)
const isLoaded = ref(false)

// 播放
const play = async () => {
  try {
    await nextTick()

    if (!audioRef.value) {
      console.warn('audio 元素不存在')
      return false
    }

    audioRef.value.volume = 0.3

    const result = audioRef.value.play()
    if (result instanceof Promise) {
      await result
    }

    isPlaying.value = true
    return true
  } catch (err) {
    console.warn('播放失败:', err)
    isPlaying.value = false
    return false
  }
}

// 暂停
const pause = () => {
  if (!audioRef.value) return false
  audioRef.value.pause()
  isPlaying.value = false
  return false
}

// 切换播放/暂停
const toggle = async () => {
  if (isPlaying.value) {
    pause()
    return false
  } else {
    return await play()
  }
}

// 获取播放状态
const getPlayingState = () => isPlaying.value

// 可以播放
const onCanPlay = () => {
  isLoaded.value = true
  if (audioRef.value) {
    audioRef.value.volume = 0.3
  }
}

// 播放事件
const onPlay = () => {
  isPlaying.value = true
}

// 暂停事件
const onPause = () => {
  isPlaying.value = false
}

// 加载错误
const onError = (e) => {
  console.error('音频加载失败:', e)
  isLoaded.value = false
  isPlaying.value = false
}

defineExpose({
  play,
  pause,
  toggle,
  getPlayingState
})
</script>

<style scoped>
.music-player {
  position: fixed;
  top: 0;
  left: 0;
  z-index: -9999;
  opacity: 0;
  pointer-events: none;
}
</style>