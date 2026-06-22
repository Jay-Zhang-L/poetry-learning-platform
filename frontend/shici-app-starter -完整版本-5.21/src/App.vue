<template>
  <RouterView />
  <ChatAssistant />
  <MusicPlayer ref="musicPlayerRef" />
</template>

<script setup>
import { ref, provide } from 'vue'
import { RouterView } from 'vue-router'
import ChatAssistant from '@/components/ChatAssistant.vue'
import MusicPlayer from '@/components/MusicPlayer.vue'

const musicPlayerRef = ref(null)

const toggleMusic = () => {
  if (musicPlayerRef.value) {
    return musicPlayerRef.value.toggle()
  }
  return false
}

const playMusic = () => {
  if (musicPlayerRef.value) {
    musicPlayerRef.value.play()
  }
}

const pauseMusic = () => {
  if (musicPlayerRef.value) {
    musicPlayerRef.value.pause()
  }
}

const getMusicState = () => {
  if (musicPlayerRef.value) {
    return musicPlayerRef.value.getPlayingState()
  }
  return false
}

provide('musicControl', {
  toggle: toggleMusic,
  play: playMusic,
  pause: pauseMusic,
  getState: getMusicState
})
</script>