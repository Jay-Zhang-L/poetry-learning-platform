<template>
  <div class="knowledge-base-page">
    <div class="kb-container">
      <div class="kb-header">
        <h1>诗词知识普及</h1>
        <p>点击卡片，探索诗词的无穷魅力</p>
      </div>

      <div class="kb-cards-grid">
        <div
          v-for="card in cardsData"
          :key="card.id"
          class="kb-card"
          @click="goToDetail(card)"
        >
          <div class="kb-card-image" :style="getCardImageStyle(card)">
            <span class="kb-card-category">{{ card.category }}</span>
          </div>

          <div class="kb-card-content">
            <h3 class="kb-card-title">{{ card.title }}</h3>
            <p class="kb-card-description">{{ card.description }}</p>
            <div class="kb-card-footer">
              <span class="kb-read-more">阅读更多 →</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const cardsData = ref([])

const defaultCards = [
  {
    id: 1,
    title: '杜甫的诗歌艺术',
    description: '诗圣的创作历程与艺术成就，解析杜诗沉郁顿挫的风格特点与家国情怀。',
    category: '诗人专题',
    imageBg: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    coverUrl: '',
    page: 'dufu'
  },
  {
    id: 2,
    title: '边塞诗的豪迈风格',
    description: '岑参、王昌龄的边塞诗赏析，感受大漠孤烟、金戈铁马的壮阔意境。',
    category: '诗歌流派',
    imageBg: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
    coverUrl: '',
    page: 'biansai'
  },
  {
    id: 3,
    title: '如何遣词用韵？',
    description: '诗词创作的基本技巧，从平仄对仗到意象运用，手把手教你写诗。',
    category: '创作技巧',
    imageBg: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
    coverUrl: '',
    page: 'poetry-skills'
  },
  {
    id: 4,
    title: '冰雪为卿',
    description: '古典诗词中的冰雪意象，解析高洁品格的象征与文人情怀。',
    category: '意象解读',
    imageBg: 'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)',
    coverUrl: '',
    page: 'ice-snow'
  },
  {
    id: 5,
    title: '轮终皎洁',
    description: '明月意象的千年传承，从《诗经》到唐宋诗词中的月亮情怀。',
    category: '意象解读',
    imageBg: 'linear-gradient(135deg, #fa709a 0%, #fee140 100%)',
    coverUrl: '',
    page: 'moon'
  },
  {
    id: 6,
    title: '到西洲',
    description: '江南水乡的诗词画卷，解析西洲、江南等地理意象的文化内涵。',
    category: '地理意象',
    imageBg: 'linear-gradient(135deg, #30cfd0 0%, #330867 100%)',
    coverUrl: '',
    page: 'xizhou'
  },
  {
    id: 7,
    title: '我意',
    description: '诗词中的自我表达，探讨诗人如何通过作品抒发胸臆与人生感悟。',
    category: '情感解读',
    imageBg: 'linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)',
    coverUrl: '',
    page: 'self'
  },
  {
    id: 8,
    title: '许天',
    description: '天人合一的哲学思想在诗词中的体现，解读古代文人的宇宙观。',
    category: '哲学思想',
    imageBg: 'linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%)',
    coverUrl: '',
    page: 'heaven'
  },
  {
    id: 9,
    title: '少时',
    description: '少年情怀与时光感慨，解析诗词中的青春主题与怀旧情结。',
    category: '情感解读',
    imageBg: 'linear-gradient(135deg, #fbc2eb 0%, #a6c1ee 100%)',
    coverUrl: '',
    page: 'youth'
  },
  {
    id: 10,
    title: '何年',
    description: '时间主题的诗词探索，解读诗人对岁月流逝的感慨与哲思。',
    category: '哲学思想',
    imageBg: 'linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%)',
    coverUrl: '',
    page: 'time'
  },
  {
    id: 11,
    title: '醉霓裳',
    description: '霓裳羽衣曲与唐代乐舞诗，感受盛唐气象下的艺术繁荣。',
    category: '乐舞诗词',
    imageBg: 'linear-gradient(135deg, #fccb90 0%, #d57eeb 100%)',
    coverUrl: '',
    page: 'dance'
  },
  {
    id: 12,
    title: '落梧桐',
    description: '梧桐意象的悲秋传统，解读古典诗词中的孤寂与愁思。',
    category: '意象解读',
    imageBg: 'linear-gradient(135deg, #e0c3fc 0%, #8ec5fc 100%)',
    coverUrl: '',
    page: 'wutong'
  },
  {
    id: 13,
    title: '水，送清秋',
    description: '流水意象与时光流逝，解析诗词中水的哲学意蕴。',
    category: '意象解读',
    imageBg: 'linear-gradient(135deg, #96e6a1 0%, #d4fc79 100%)',
    coverUrl: '',
    page: 'water'
  },
  {
    id: 14,
    title: '雨乍停',
    description: '雨后初晴的诗词意境，解读自然景象背后的情感表达。',
    category: '自然意象',
    imageBg: 'linear-gradient(135deg, #a1c4fd 0%, #c2e9fb 100%)',
    coverUrl: '',
    page: 'rain'
  }
]

const normalizeUrl = (url) => {
  if (!url) return ''
  if (url.startsWith('http://') || url.startsWith('https://')) return url
  return `http://localhost:8080${url}`
}

const getCardImageStyle = (card) => {
  if (card.coverUrl) {
    return {
      backgroundImage: `url(${card.coverUrl})`,
      backgroundSize: 'cover',
      backgroundPosition: 'center',
      backgroundRepeat: 'no-repeat'
    }
  }

  return {
    background: card.imageBg || 'linear-gradient(135deg, #d9d9d9 0%, #efefef 100%)'
  }
}

const loadKnowledgeList = async () => {
  try {
    const res = await fetch('http://localhost:8080/api/knowledge/list')
    const result = await res.json()

    if (result.code === 200 && Array.isArray(result.data) && result.data.length) {
      cardsData.value = result.data.map(item => ({
        id: item.id,
        title: item.title || '',
        description: item.description || item.fullDescription || '',
        category: item.category || '',
        imageBg: item.imageBg || '',
        coverUrl: normalizeUrl(item.coverUrl || ''),
        page: item.pageKey || item.page || ''
      }))
    } else {
      cardsData.value = defaultCards
    }
  } catch (error) {
    console.error('获取知识列表失败：', error)
    cardsData.value = defaultCards
  }
}

const goToDetail = (card) => {
  router.push({
    path: '/knowledge-detail',
    query: {
      id: card.id,
      title: card.title,
      page: card.page
    }
  })
}

onMounted(() => {
  loadKnowledgeList()
})
</script>

<style scoped>
.knowledge-base-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #e9ecef 100%);
  padding: 80px 20px 40px;
}

.kb-container {
  max-width: 1200px;
  margin: 0 auto;
}

.kb-header {
  text-align: center;
  margin-bottom: 40px;
}

.kb-header h1 {
  font-size: 2.2rem;
  color: #2c3e50;
  margin-bottom: 12px;
}

.kb-header p {
  color: #7f8c8d;
  font-size: 1rem;
}

.kb-cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 28px;
}

.kb-card {
  background: white;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
  cursor: pointer;
}

.kb-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
}

.kb-card-image {
  height: 180px;
  position: relative;
  display: flex;
  align-items: flex-end;
  justify-content: flex-start;
  padding: 16px;
}

.kb-card-category {
  background: rgba(0, 0, 0, 0.56);
  color: white;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 0.75rem;
  font-weight: 500;
  letter-spacing: 1px;
}

.kb-card-content {
  padding: 20px;
}

.kb-card-title {
  font-size: 1.35rem;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 10px;
  line-height: 1.4;
}

.kb-card-description {
  font-size: 0.9rem;
  color: #7f8c8d;
  line-height: 1.5;
  margin-bottom: 16px;
}

.kb-card-footer {
  display: flex;
  justify-content: flex-end;
  border-top: 1px solid #ecf0f1;
  padding-top: 14px;
  margin-top: 8px;
}

.kb-read-more {
  color: #3498db;
  font-size: 0.85rem;
  font-weight: 500;
}

@media (max-width: 768px) {
  .knowledge-base-page {
    padding: 100px 16px 40px;
  }

  .kb-cards-grid {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .kb-header h1 {
    font-size: 1.6rem;
  }
}
</style>