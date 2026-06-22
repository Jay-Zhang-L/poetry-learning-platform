<template>
  <div class="splatListPage">
    <div class="head">
      <div>
        <div class="mark">诗境空间</div>
        <h1>可进入的 3D 诗境</h1>
      </div>

      <div class="searchBar">
        <input
          v-model.trim="keyword"
          class="searchInput"
          placeholder="搜索诗词名、作者、朝代"
          @keyup.enter="loadList"
        />
        <button class="searchBtn" @click="loadList">搜索</button>
      </div>
    </div>

    <div v-if="loading" class="stateCard">加载中……</div>
    <div v-else-if="!list.length" class="stateCard">暂无诗境场景</div>

    <div v-else class="grid">
      <div
        v-for="item in list"
        :key="item.id"
        class="card"
        @click="goDetail(item.id)"
      >
        <div class="cardTitle">{{ item.title }}</div>
        <div class="cardMeta">{{ item.dynasty || '未知朝代' }} · {{ item.author || '未知作者' }}</div>
        <div class="cardDesc">{{ item.description || '暂无场景说明。' }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { searchSplatSceneList } from '@/utils/api'

const router = useRouter()
const keyword = ref('')
const loading = ref(false)
const list = ref([])

async function loadList() {
  loading.value = true
  try {
    const res = await searchSplatSceneList(keyword.value)
    list.value = Array.isArray(res?.data) ? res.data : []
  } catch (e) {
    console.error(e)
    list.value = []
  } finally {
    loading.value = false
  }
}

function goDetail(id) {
  router.push(`/splat/${id}`)
}

onMounted(() => {
  loadList()
})
</script>

<style scoped>
.splatListPage {
  min-height: 100vh;
  padding: 28px;
  background: linear-gradient(180deg, #f8f4ed 0%, #efe4d6 100%);
}

.head {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 20px;
  margin-bottom: 24px;
}

.mark {
  color: #8b3c2e;
  font-size: 13px;
  letter-spacing: 0.2em;
  margin-bottom: 8px;
}

.head h1 {
  margin: 0;
  font-size: 36px;
}

.searchBar {
  display: flex;
  gap: 10px;
}

.searchInput {
  width: 280px;
  height: 42px;
  padding: 0 14px;
  border: 1px solid rgba(139,60,46,0.18);
  background: #fffdf9;
}

.searchBtn {
  min-width: 90px;
  border: none;
  background: #8b3c2e;
  color: #fff;
  cursor: pointer;
}

.stateCard {
  padding: 18px;
  background: rgba(255,255,255,0.72);
  border: 1px solid rgba(139,60,46,0.14);
}

.grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 18px;
}

.card {
  padding: 22px;
  background: rgba(255,255,255,0.82);
  border: 1px solid rgba(139,60,46,0.14);
  cursor: pointer;
  transition: transform .2s ease, box-shadow .2s ease;
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 14px 30px rgba(0,0,0,0.08);
}

.cardTitle {
  font-size: 22px;
  font-weight: 700;
  margin-bottom: 10px;
}

.cardMeta {
  font-size: 13px;
  color: #7a6859;
  margin-bottom: 12px;
}

.cardDesc {
  font-size: 14px;
  line-height: 1.9;
  color: #4f4339;
}
</style>