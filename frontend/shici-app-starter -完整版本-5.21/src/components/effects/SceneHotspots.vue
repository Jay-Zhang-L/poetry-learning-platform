<template>
  <div class="layer" ref="layer" @click="hit">
    <button class="spot s1" @click.stop="tap('纸鹤', $event)" title="纸鹤"></button>
    <button class="spot s2" @click.stop="tap('灯笼', $event)" title="灯笼"></button>
    <button class="spot s3" @click.stop="tap('墨点', $event)" title="墨点"></button>

    <div class="toast" v-if="toast.show">{{ toast.text }}</div>

    <span
      v-for="p in pops"
      :key="p.id"
      class="pop"
      :style="{ left: p.x + 'px', top: p.y + 'px' }"
    ></span>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
const emit = defineEmits(['gain'])
const layer = ref(null)

const toast = reactive({ show:false, text:'' })
const pops = ref([])
let pid = 0

function tap(name, e){
  splash(e)
  toast.text = `获得灵感 +1（${name}）`
  toast.show = true
  emit('gain', 1)
  setTimeout(()=> toast.show=false, 900)
}

function hit(e){
  // 点任意位置：也给一点“可玩感”
  splash(e)
  emit('gain', 1)
}

function splash(e){
  const rect = layer.value?.getBoundingClientRect()
  if (!rect) return
  const x = e.clientX - rect.left
  const y = e.clientY - rect.top

  for (let i=0;i<12;i++){
    pops.value.push({
      id: ++pid,
      x: x + rand(-20, 20),
      y: y + rand(-20, 20)
    })
  }
  setTimeout(()=> pops.value.splice(0, 12), 380)
}

function rand(a,b){ return a + Math.random()*(b-a) }
</script>

<style scoped>
.layer{ position:absolute; inset:0; pointer-events:auto; }

.spot{
  position:absolute;
  width: 52px; height:52px;
  border-radius: 18px;
  background: rgba(255,255,255,.06);
  border: 1px solid rgba(255,255,255,.14);
  cursor:pointer;
  box-shadow: 0 16px 34px rgba(0,0,0,.10);
  backdrop-filter: blur(10px);
  transition: transform .15s ease, background .15s ease;
}
.spot:hover{ transform: translateY(-2px) scale(1.02); background: rgba(255,255,255,.12); }

.s1{ left: 8%; top: 22%; }
.s2{ left: 84%; top: 18%; }
.s3{ left: 74%; top: 72%; }

.toast{
  position:absolute; left:50%; top: 14px;
  transform: translateX(-50%);
  padding: 10px 14px;
  border-radius: 999px;
  background: rgba(0,0,0,.78);
  color:#fff;
  font-weight: 900;
  font-size: 12px;
  box-shadow: 0 18px 40px rgba(0,0,0,.25);
}

.pop{
  position:absolute;
  width: 6px; height: 6px;
  border-radius: 999px;
  background: rgba(0,0,0,.55);
  filter: blur(.2px);
  animation: pop .38s ease-out both;
}
@keyframes pop{
  from{ opacity:1; transform: scale(1) translateY(0); }
  to{ opacity:0; transform: scale(.2) translateY(-18px); }
}
</style>
