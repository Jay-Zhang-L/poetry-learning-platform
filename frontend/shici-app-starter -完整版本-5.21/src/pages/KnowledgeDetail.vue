<template>
  <div class="knowledge-detail-page">
    <div class="kd-container">
      <div class="kd-header" :style="headerStyle">
        <button class="kd-back-btn" @click="goBack">返回</button>
        <h1>{{ detailData.title || '诗词知识' }}</h1>
        <span v-if="detailData.category" class="kd-category">{{ detailData.category }}</span>
      </div>

      <div class="kd-content">
        <div class="kd-section">
          <h2>内容介绍</h2>
          <p class="kd-main-text">
            {{ detailData.fullDescription || '暂无内容介绍' }}
          </p>
        </div>

        <div class="kd-section">
          <h2>插图区域</h2>

          <div v-if="detailData.images.length" class="kd-illustration-area">
            <div class="kd-image-card" v-for="img in detailData.images" :key="img.id">
              <img
                class="kd-real-image"
                :src="img.imageUrl"
                :alt="img.imageDesc || detailData.title || '知识插图'"
                @error="handleImgError"
                @load="handleImgLoad(img.imageUrl)"
              />
              <p class="kd-image-desc">
                {{ img.imageDesc || detailData.title || '知识插图' }}
              </p>
            </div>
          </div>

          <div v-else-if="detailData.coverUrl" class="kd-illustration-area">
            <div class="kd-image-card">
              <img
                class="kd-real-image"
                :src="detailData.coverUrl"
                :alt="detailData.title || '知识插图'"
                @error="handleImgError"
                @load="handleImgLoad(detailData.coverUrl)"
              />
              <p class="kd-image-desc">
                {{ detailData.title || '知识插图' }}
              </p>
            </div>
          </div>

          <div v-else class="kd-empty-block">
            暂无插图
          </div>
        </div>

        <div class="kd-section">
          <h2>详细赏析</h2>
          <div
            v-if="detailData.detailText"
            class="kd-text-content"
            v-html="detailData.detailText"
          ></div>
          <div v-else class="kd-empty-block">
            暂无详细赏析
          </div>
        </div>

        <div class="kd-section">
          <h2>相关推荐</h2>
          <div class="kd-related-links">
            <span
              v-for="related in relatedTopics"
              :key="related.id"
              class="kd-related-item"
              @click="goToRelated(related)"
            >
              {{ related.title }}
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()

const defaultHeaderBg = 'linear-gradient(135deg, #a1c4fd 0%, #c2e9fb 100%)'

const detailData = ref({
  id: null,
  pageKey: '',
  title: '',
  category: '',
  fullDescription: '',
  detailText: '',
  imageBg: '',
  coverUrl: '',
  images: []
})

const relatedTopics = ref([
  { id: 1, title: '李白诗歌赏析', page: 'libai' },
  { id: 2, title: '宋词婉约派', page: 'wanyue' },
  { id: 3, title: '诗词格律入门', page: 'gelv' }
])

const normalizeUrl = (url) => {
  const value = String(url || '').trim().replace(/\\/g, '/')
  if (!value) return ''
  if (value.startsWith('http://') || value.startsWith('https://')) return encodeURI(value)
  if (value.startsWith('/')) return encodeURI(`http://localhost:8080${value}`)
  return encodeURI(`http://localhost:8080/${value}`)
}

const resetDetail = () => {
  detailData.value = {
    id: null,
    pageKey: '',
    title: '',
    category: '',
    fullDescription: '',
    detailText: '',
    imageBg: '',
    coverUrl: '',
    images: []
  }
}

const headerStyle = computed(() => {
  if (detailData.value.coverUrl) {
    return {
      backgroundImage: `linear-gradient(rgba(0,0,0,0.28), rgba(0,0,0,0.28)), url(${detailData.value.coverUrl})`,
      backgroundSize: 'cover',
      backgroundPosition: 'center',
      backgroundRepeat: 'no-repeat'
    }
  }

  if (detailData.value.imageBg) {
    return {
      backgroundImage: `linear-gradient(rgba(0,0,0,0.18), rgba(0,0,0,0.18)), url(${normalizeUrl(detailData.value.imageBg)})`,
      backgroundSize: 'cover',
      backgroundPosition: 'center',
      backgroundRepeat: 'no-repeat'
    }
  }

  return {
    background: defaultHeaderBg
  }
})

const handleImgError = (e) => {
  console.log('图片加载失败 src =', e.target.currentSrc || e.target.src)
}

const handleImgLoad = (url) => {
  console.log('图片加载成功 =', url)
}

const loadDetail = async () => {
  const pageKey = route.query.page
  if (!pageKey) {
    resetDetail()
    return
  }

  try {
    const res = await fetch(`http://localhost:8080/api/knowledge/detail/${pageKey}`)
    const result = await res.json()

    if (result.code === 200 && result.data) {
      detailData.value = {
        id: result.data.id ?? null,
        pageKey: result.data.pageKey || '',
        title: result.data.title || '',
        category: result.data.category || '',
        fullDescription: result.data.fullDescription || '',
        detailText: result.data.detailText || '',
        imageBg: result.data.imageBg || '',
        coverUrl: normalizeUrl(result.data.coverUrl || ''),
        images: Array.isArray(result.data.images)
          ? result.data.images.map(img => ({
              id: img.id,
              imageUrl: normalizeUrl(img.imageUrl || ''),
              imageDesc: img.imageDesc || '',
              sortOrder: img.sortOrder || 0
            }))
          : []
      }

      console.log('详情完整数据 =', detailData.value)
      console.log('插图数组 =', detailData.value.images)
    } else {
      console.error('知识详情接口返回失败：', result.message)
      resetDetail()
    }
  } catch (error) {
    console.error('获取知识详情失败：', error)
    resetDetail()
  }
}

const goBack = () => {
  router.push('/home')
}

const goToRelated = (related) => {
  router.push({
    path: '/knowledge-detail',
    query: {
      id: related.id,
      title: related.title,
      page: related.page
    }
  })
}

onMounted(() => {
  loadDetail()
})

watch(() => route.query.page, () => {
  loadDetail()
})
</script>

<style scoped>
.knowledge-detail-page {
  min-height: 100vh;
  background: #f6f7fb;
}

.kd-container {
  max-width: 1000px;
  margin: 0 auto;
}

.kd-header {
  padding: 60px 32px;
  text-align: center;
  color: #fff;
  position: relative;
}

.kd-back-btn {
  position: absolute;
  top: 20px;
  left: 20px;
  background: rgba(255, 255, 255, 0.18);
  border: none;
  color: #fff;
  padding: 8px 16px;
  border-radius: 999px;
  cursor: pointer;
  font-size: 14px;
}

.kd-header h1 {
  font-size: 34px;
  margin: 0 0 16px;
  font-weight: 700;
}

.kd-category {
  display: inline-block;
  background: rgba(255, 255, 255, 0.18);
  padding: 6px 16px;
  border-radius: 999px;
  font-size: 14px;
}

.kd-content {
  background: #fff;
  padding: 32px;
  border-radius: 0 0 24px 24px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
}

.kd-section {
  margin-bottom: 40px;
}

.kd-section:last-child {
  margin-bottom: 0;
}

.kd-section h2 {
  color: #1f2937;
  font-size: 24px;
  margin: 0 0 20px;
  padding-bottom: 10px;
  border-bottom: 2px solid #e9ecef;
}

.kd-main-text {
  color: #495057;
  line-height: 1.9;
  margin: 0;
  font-size: 16px;
  white-space: pre-line;
}

.kd-illustration-area {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

.kd-image-card {
  background: #fff;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
}

.kd-real-image {
  width: 100%;
  height: 260px;
  display: block;
  object-fit: cover;
  background: #f3f4f6;
}

.kd-image-desc {
  padding: 12px 14px;
  margin: 0;
  color: #666;
  line-height: 1.7;
  font-size: 14px;
}

.kd-text-content {
  background: #f8f9fa;
  padding: 24px;
  border-radius: 16px;
  line-height: 1.9;
  color: #374151;
  font-size: 16px;
}

.kd-text-content :deep(p) {
  margin: 0 0 16px;
}

.kd-text-content :deep(p:last-child) {
  margin-bottom: 0;
}

.kd-empty-block {
  padding: 24px;
  background: #f8f9fa;
  border-radius: 16px;
  color: #8b949e;
  text-align: center;
  font-size: 15px;
}

.kd-related-links {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
}

.kd-related-item {
  background: #e9ecef;
  padding: 8px 20px;
  border-radius: 999px;
  cursor: pointer;
  color: #495057;
  font-size: 14px;
}

.kd-related-item:hover {
  background: #3498db;
  color: #fff;
}

@media (max-width: 768px) {
  .kd-header {
    padding: 44px 20px;
  }

  .kd-header h1 {
    font-size: 28px;
  }

  .kd-content {
    padding: 20px;
  }

  .kd-section h2 {
    font-size: 20px;
  }

  .kd-real-image {
    height: 220px;
  }

  .kd-related-item {
    padding: 6px 14px;
    font-size: 12px;
  }
}
</style>