<template>
  <div class="scenePage">
    <button class="backBtn" type="button" @click="goBack">返回</button>
    <iframe
      src="/viewers/bonsai_high.html"
      class="sceneFrame"
      frameborder="0"
    ></iframe>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

const goBack = () => {
  router.back()
}
</script>

<style scoped>
.scenePage {
  position: relative;
  width: 100%;
  height: 100vh;
  overflow: hidden;
  background: #000;
}

.sceneFrame {
  width: 100%;
  height: 100%;
  border: none;
  display: block;
}

.backBtn {
  position: absolute;
  top: 20px;
  left: 20px;
  z-index: 20;
  padding: 10px 16px;
  border: none;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.92);
  color: #111;
  cursor: pointer;
}
</style>