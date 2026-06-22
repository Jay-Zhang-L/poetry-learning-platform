<!-- src/pages/home/components/HomeSearchBar.vue -->
<template>
  <div class="top">
    <div class="search">
      <span class="ico">搜</span>
      <input
        :value="modelValue"
        @input="$emit('update:modelValue', $event.target.value)"
        :placeholder="placeholder"
      />
    </div>
    <button class="miniBtn" @click="$emit('random')">{{ randomText }}</button>
  </div>
</template>

<script setup>
defineProps({
  modelValue: { type: String, default: "" },
  placeholder: { type: String, default: "搜索诗词 / 作者 / 名句" },
  randomText: { type: String, default: "随机一句" },
});
defineEmits(["update:modelValue", "random"]);
</script>

<style scoped>
.top{
  position:absolute;
  top: 16px;
  left: 50%;
  transform: translateX(-50%);
  width: min(980px, 92vw);
  display:flex;
  gap: 10px;
  align-items:center;
  z-index: 30;
}
.search{
  flex: 1;
  display:flex;
  align-items:center;
  gap: 8px;
  padding: 12px 14px;
  border-radius: 999px;
  background: rgba(255,255,255,.72);
  border: 1px solid rgba(0,0,0,.10);
  backdrop-filter: blur(10px);
}
.search input{
  border: none;
  outline: none;
  background: transparent;
  width: 100%;
  font-weight: 800;
}
.ico{
  opacity:.78;
  font-weight: 1000;
  width: 22px;
  text-align: center;
}
.miniBtn{
  height: 44px;
  padding: 0 16px;
  border-radius: 999px;
  border: 1px solid rgba(0,0,0,.12);
  background: rgba(255,255,255,.70);
  cursor:pointer;
  font-weight: 1000;
}
.miniBtn:hover{ background: rgba(255,255,255,.92); }
</style>
