<template>
  <div class="mask" :class="{ on: show }" aria-hidden="true"></div>
</template>

<script setup>
import { ref } from 'vue'
const show = ref(false)

async function play(onMid = () => {}) {
  show.value = true
  await wait(180)
  onMid()
  await wait(260)
  show.value = false
}
function wait(ms){ return new Promise(r => setTimeout(r, ms)) }

defineExpose({ play })
</script>

<style scoped>
.mask{
  position:absolute; inset:0;
  pointer-events:none;
  opacity:0;
  transform: scale(1.06);
  background:
    radial-gradient(260px 220px at 20% 30%, rgba(0,0,0,.20), transparent 60%),
    radial-gradient(320px 260px at 75% 35%, rgba(0,0,0,.18), transparent 62%),
    radial-gradient(420px 320px at 45% 70%, rgba(0,0,0,.16), transparent 66%),
    radial-gradient(520px 420px at 55% 55%, rgba(0,0,0,.12), transparent 70%),
    rgba(0,0,0,0);
  filter: blur(10px);
  transition: opacity .22s ease, transform .22s ease;
}
.mask.on{
  opacity:1;
  transform: scale(1.0);
}
</style>
