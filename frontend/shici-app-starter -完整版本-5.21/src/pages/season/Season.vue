<template>
  <div class="page">
    <div class="hero">
      <div class="heroCard">
        <div class="left">
          <div class="kicker">本期活动</div>
          <div class="h1">{{ season?.title || '活动页' }}</div>
          <div class="sub">主题字：<b>{{ season?.theme || '—' }}</b> · 参与即计分 · 榜单实时更新</div>
        </div>

        <div class="ops">
          <button class="btn ghost" @click="loadAll">刷新</button>
          <button class="btn primary" @click="go('/game/fh')">去飞花令</button>
          <button class="btn" @click="go('/forum?seasonId=' + sid)">进入讨论</button>
        </div>
      </div>
    </div>

    <div class="grid">
      <div class="card">
        <div class="cardHead">
          <div class="lab">排行榜</div>
          <div class="muted">Top20</div>
        </div>

        <div v-if="rank.length===0" class="empty">暂无数据，先去提交一次飞花令</div>

        <div v-else class="list">
          <div class="row" v-for="(r,i) in rank" :key="i">
            <div class="idx">#{{ i+1 }}</div>
            <div class="who">用户 {{ r.user_id }}</div>
            <div class="score">{{ r.score }}</div>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="cardHead">
          <div class="lab">规则说明</div>
          <div class="muted">简版</div>
        </div>

        <div class="rules">
          <div class="p">1）飞花令：提交包含主题字的诗句，命中诗词库则得分。</div>
          <div class="p">2）接龙：承接上一句规则输入下一句，后续将接入数据库校验。</div>
          <div class="p">3）讨论区：按期发帖与评论，沉淀名句与玩法。</div>
        </div>

        <div class="cta">
          <button class="btn primary" @click="go('/forum?seasonId=' + sid)">去讨论区</button>
          <button class="btn ghost" @click="go('/game')">返回大厅</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'

const route = useRoute()
const router = useRouter()
const sid = computed(()=> Number(route.params.id || 1))

const season = ref(null)
const rank = ref([])

function go(p){ router.push(p) }

async function loadAll(){
  try{
    const { data: s } = await axios.get(`/api/season/${sid.value}`)
    season.value = s?.data || null
  }catch(e){
    try{
      const { data: s2 } = await axios.get('/api/season/current')
      season.value = s2?.data || null
    }catch(e2){}
  }

  try{
    const { data } = await axios.get(`/api/season/${sid.value}/rank`, { params: { top: 20 } })
    rank.value = data?.data || []
  }catch(e){}
}

onMounted(loadAll)
</script>

<style scoped>
.page{ max-width: 1200px; margin: 0 auto; padding: 8px 0 24px; display: grid; gap: 12px; }
.heroCard{
  border-radius: 18px;
  background: rgba(255,255,255,.55);
  border: 1px solid rgba(0,0,0,.08);
  backdrop-filter: blur(14px);
  box-shadow: 0 18px 56px rgba(0,0,0,.06);
  padding: 14px;
  display:flex;
  justify-content:space-between;
  align-items:center;
  gap:12px;
  flex-wrap:wrap;
}
.kicker{ font-weight:1000; opacity:.78; }
.h1{ margin-top: 2px; font-weight:1000; font-size:18px; }
.sub{ margin-top: 2px; opacity:.7; font-weight:900; font-size:12px; }

.ops{ display:flex; gap:10px; flex-wrap:wrap; }
.btn{
  height: 38px; padding: 0 14px; border-radius: 14px;
  border: 1px solid rgba(0,0,0,.12);
  background: rgba(255,255,255,.7);
  cursor: pointer; font-weight: 1000;
}
.btn.primary{ background: rgba(60,80,70,.14); border-color: rgba(60,80,70,.22); }
.btn.ghost{ background: rgba(255,255,255,.55); }

.grid{ display:grid; grid-template-columns: 1fr 1fr; gap: 12px; align-items:start; }
.card{
  border-radius: 18px;
  background: rgba(255,255,255,.52);
  border: 1px solid rgba(0,0,0,.08);
  backdrop-filter: blur(14px);
  box-shadow: 0 18px 56px rgba(0,0,0,.06);
  padding: 14px;
}
.cardHead{ display:flex; justify-content:space-between; align-items:center; gap: 10px; }
.lab{ font-weight: 1000; opacity:.82; font-size: 12px; }
.muted{ opacity:.65; font-weight: 900; font-size: 12px; }

.empty{ margin-top: 12px; opacity:.7; font-weight: 800; font-size: 12px; line-height: 1.6; }
.list{ margin-top: 10px; display:grid; gap: 8px; }
.row{
  display:flex; align-items:center; justify-content:space-between; gap: 10px;
  padding: 10px 12px;
  border-radius: 14px;
  background: rgba(255,255,255,.62);
  border: 1px solid rgba(0,0,0,.08);
}
.idx{ width: 48px; font-weight: 1000; opacity:.78; }
.who{ flex: 1; font-weight: 900; }
.score{ font-weight: 1000; }

.rules{ margin-top: 10px; display:grid; gap: 8px; }
.p{ opacity:.82; font-weight: 900; font-size: 12px; line-height: 1.8; }
.cta{ margin-top: 12px; display:flex; gap:10px; flex-wrap:wrap; }

@media (max-width: 980px){
  .grid{ grid-template-columns: 1fr; }
}
</style>
