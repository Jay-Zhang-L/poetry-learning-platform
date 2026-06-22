<template>
  <canvas ref="cv" class="cv"></canvas>
</template>

<script setup>
import { onMounted, onBeforeUnmount, ref } from 'vue'

const cv = ref(null)
let ctx, w, h, raf = 0
const ripples = []
const dust = []

function setupDust(){
  dust.length = 0
  const n = Math.min(90, Math.floor((w*h)/22000))
  for (let i=0;i<n;i++){
    dust.push({
      x: Math.random()*w,
      y: Math.random()*h,
      r: 0.8 + Math.random()*1.6,
      a: 0.06 + Math.random()*0.10,
      vx: (Math.random()-.5)*0.18,
      vy: (Math.random()-.5)*0.12
    })
  }
}

function resize() {
  const el = cv.value
  w = el.clientWidth
  h = el.clientHeight
  el.width = Math.floor(w * devicePixelRatio)
  el.height = Math.floor(h * devicePixelRatio)
  ctx = el.getContext('2d')
  ctx.setTransform(devicePixelRatio,0,0,devicePixelRatio,0,0)
  setupDust()
}

function addRipple(x, y) {
  ripples.push({ x, y, r: 0, a: 0.32, lw: 1 })
}

function loop() {
  ctx.clearRect(0, 0, w, h)

  // paper shade
  const g = ctx.createRadialGradient(w*0.2, h*0.2, 10, w*0.2, h*0.2, Math.max(w,h))
  g.addColorStop(0, 'rgba(0,0,0,0.03)')
  g.addColorStop(1, 'rgba(0,0,0,0)')
  ctx.fillStyle = g
  ctx.fillRect(0,0,w,h)

  // dust ink particles
  for (const d of dust){
    d.x += d.vx; d.y += d.vy
    if (d.x< -10) d.x = w+10
    if (d.x> w+10) d.x = -10
    if (d.y< -10) d.y = h+10
    if (d.y> h+10) d.y = -10
    ctx.beginPath()
    ctx.arc(d.x,d.y,d.r,0,Math.PI*2)
    ctx.fillStyle = `rgba(0,0,0,${d.a})`
    ctx.fill()
  }

  // ripples
  for (let i = ripples.length - 1; i >= 0; i--) {
    const r = ripples[i]
    r.r += 1.55
    r.a *= 0.985
    r.lw *= 0.995

    ctx.beginPath()
    ctx.arc(r.x, r.y, r.r, 0, Math.PI * 2)
    ctx.strokeStyle = `rgba(0,0,0,${r.a})`
    ctx.lineWidth = Math.max(0.6, r.lw)
    ctx.stroke()

    if (r.a < 0.018) ripples.splice(i, 1)
  }

  raf = requestAnimationFrame(loop)
}

function onPointer(e) {
  const rect = cv.value.getBoundingClientRect()
  const p = e.touches ? e.touches[0] : e
  addRipple(p.clientX - rect.left, p.clientY - rect.top)
}

onMounted(() => {
  resize()
  window.addEventListener('resize', resize)
  cv.value.addEventListener('click', onPointer)
  cv.value.addEventListener('touchstart', onPointer, { passive: true })
  raf = requestAnimationFrame(loop)
})
onBeforeUnmount(() => {
  window.removeEventListener('resize', resize)
  cancelAnimationFrame(raf)
})
</script>

<style scoped>
.cv{ position:absolute; inset:0; width:100%; height:100%; pointer-events:auto; }
</style>
