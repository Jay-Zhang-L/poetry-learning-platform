<template>
  <div class="scene-detail-page">
    <div class="scene-header">
      <button class="back-btn" @click="goBack">返回</button>

      <div class="scene-meta">
        <h1>{{ sceneData?.title || '诗境空间' }}</h1>
        <p>{{ sceneData?.dynasty || '未知朝代' }} · {{ sceneData?.author || '未知作者' }}</p>
      </div>
    </div>

    <div v-if="sceneData?.description" class="scene-desc">
      <div class="desc-title">场景说明</div>
      <p>{{ sceneData.description }}</p>
    </div>

    <div v-if="loading" class="scene-state">正在加载诗境详情……</div>
    <div v-else-if="errorText" class="scene-state error">{{ errorText }}</div>

    <iframe
      v-else-if="iframeUrl"
      :src="iframeUrl"
      class="scene-frame"
      frameborder="0"
    ></iframe>

    <div v-else class="scene-state error">未找到场景文件地址</div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getSplatSceneDetail } from '@/utils/api'

const route = useRoute()
const router = useRouter()

const loading = ref(true)
const errorText = ref('')
const sceneData = ref(null)

const iframeUrl = computed(() => {
  const url = sceneData.value?.splatUrl || ''
  if (!url) return ''
  return url
})

function goBack() {
  router.back()
}

onMounted(async () => {
  loading.value = true
  errorText.value = ''

  try {
    const id = route.params.id
    if (!id) {
      errorText.value = '缺少场景编号'
      return
    }

    const result = await getSplatSceneDetail(id)
    const data = result?.data || null

    if (!data) {
      errorText.value = '未找到诗境详情'
      return
    }

    if (!data.splatUrl) {
      errorText.value = '未找到场景文件地址'
      return
    }

    sceneData.value = data
  } catch (err) {
    console.error('加载诗境详情失败 =', err)
    errorText.value = err.message || '加载诗境失败'
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.scene-detail-page {
  min-height: 100vh;
  background: #f3ede3;
  padding: 18px 16px 24px;
}

.scene-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 18px;
}

.back-btn {
  min-width: 66px;
  height: 40px;
  border: none;
  background: #98352b;
  color: #fff;
  cursor: pointer;
  font-size: 14px;
}

.scene-meta h1 {
  margin: 0;
  color: #2f2824;
  font-size: 28px;
}

.scene-meta p {
  margin: 6px 0 0;
  color: #7f6d60;
  font-size: 14px;
}

.scene-desc {
  margin-bottom: 18px;
  padding: 18px;
  background: rgba(255, 255, 255, 0.6);
  border: 1px solid rgba(122, 84, 64, 0.12);
}

.desc-title {
  margin-bottom: 10px;
  color: #2f2824;
  font-size: 16px;
  font-weight: 700;
}

.scene-desc p {
  margin: 0;
  color: #56463d;
  line-height: 1.9;
}

.scene-state {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 520px;
  background: #2a2019;
  color: #fff;
  font-size: 20px;
}

.scene-state.error {
  color: #fff;
}

.scene-frame {
  width: 100%;
  height: 78vh;
  min-height: 620px;
  border: none;
  display: block;
  background: #000;
}

@media (max-width: 768px) {
  .scene-meta h1 {
    font-size: 22px;
  }

  .scene-frame {
    height: 70vh;
    min-height: 480px;
  }
}
</style>