<template><canvas ref="cv" class="cv"></canvas></template>

<script setup>
import { onMounted, onBeforeUnmount, ref, watch } from 'vue'

const props = defineProps({
  level: { type: Number, default: 0 } // 0..1
})

const cv = ref(null)
let ctx, w, h, raf = 0
let t = 0

function resize(){
  const el = cv.value
  w = el.clientWidth
  h = el.clientHeight
  el.width = Math.floor(w * devicePixelRatio)
  el.height = Math.floor(h * devicePixelRatio)
  ctx = el.getContext('2d')
  ctx.setTransform(devicePixelRatio,0,0,devicePixelRatio,0,0)
}

function loop(){
  ctx.clearRect(0,0,w,h)
  const mid = h/2
  const amp = (8 + props.level * 38)
  const freq = 0.012 + props.level * 0.025

  ctx.beginPath()
  for (let x=0; x<=w; x+=2){
    const y = mid + Math.sin((x*freq)+t) * amp * (0.75 + 0.25*Math.sin(t*0.7))
    if (x===0) ctx.moveTo(x,y)
    else ctx.lineTo(x,y)
  }
  ctx.strokeStyle = 'rgba(0,0,0,.55)'
  ctx.lineWidth = 2
  ctx.stroke()

  // soft second line
  ctx.beginPath()
  for (let x=0; x<=w; x+=2){
    const y = mid + Math.sin((x*(freq*1.35))+t*1.2) * (amp*0.55)
    if (x===0) ctx.moveTo(x,y)
    else ctx.lineTo(x,y)
  }
  ctx.strokeStyle = 'rgba(0,0,0,.18)'
  ctx.lineWidth = 2
  ctx.stroke()

  t += 0.045 + props.level*0.05
  raf = requestAnimationFrame(loop)
}

onMounted(()=>{
  resize()
  window.addEventListener('resize', resize)
  raf = requestAnimationFrame(loop)
})
onBeforeUnmount(()=>{
  window.removeEventListener('resize', resize)
  cancelAnimationFrame(raf)
})
</script>

<style scoped>
.cv{ width:100%; height:90px; display:block; }
</style>
