<template>
  <div class="page">
    <div class="head">
      <div>
        <div class="kicker">社区讨论</div>
        <div class="h1">本期论坛</div>
        <div class="sub">围绕玩法、名句与心得自由交流。支持图片上传为第二阶段增强</div>
      </div>

      <div class="ops">
        <button class="btn ghost" @click="load">刷新</button>
        <button class="btn primary" @click="go('/post/new?seasonId=' + seasonId)">发布帖子</button>
        <button class="btn" @click="go('/season/' + seasonId)">返回本期</button>
      </div>
    </div>

    <div class="listCard">
      <div class="bar">
        <div class="lab">帖子列表</div>
        <div class="pager">
          <button class="mini" :disabled="page<=1" @click="page--; load()">上一页</button>
          <div class="pnum">第 {{ page }} 页</div>
          <button class="mini" @click="page++; load()">下一页</button>
        </div>
      </div>

      <div v-if="posts.length===0" class="empty">
        暂无帖子。你可以先发布第一条讨论。
      </div>

      <div v-else class="items">
        <div class="item" v-for="p in posts" :key="p.id" @click="go('/post/' + p.id)">
          <div class="title">{{ p.title }}</div>
          <div class="meta">
            <span>作者用户 {{ p.userId }}</span>
            <span>评论 {{ p.commentCount || 0 }}</span>
            <span class="time">{{ p.createdAt || '' }}</span>
          </div>
          <div class="snippet">{{ snippet(p.content) }}</div>
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

const seasonId = computed(()=> Number(route.query.seasonId || 1))
const page = ref(1)
const size = ref(10)
const posts = ref([])

function go(p){ router.push(p) }
function snippet(s){
  const t = String(s || '').trim()
  if(!t) return '—'
  return t.length > 90 ? t.slice(0, 90) + '…' : t
}

async function load(){
  try{
    const { data } = await axios.get('/api/forum/posts', {
      params: { seasonId: seasonId.value, page: page.value, size: size.value }
    })
    posts.value = data?.data || []
  }catch(e){
    posts.value = []
  }
}

onMounted(load)
</script>

<style scoped>
.page{ max-width: 1200px; margin: 0 auto; padding: 8px 0 24px; display: grid; gap: 12px; }

.head{
  border-radius: 18px;
  background: rgba(255,255,255,.55);
  border: 1px solid rgba(0,0,0,.08);
  backdrop-filter: blur(14px);
  box-shadow: 0 18px 56px rgba(0,0,0,.06);
  padding: 14px;
  display:flex; justify-content:space-between; align-items:center;
  gap:12px; flex-wrap:wrap;
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

.listCard{
  border-radius: 18px;
  background: rgba(255,255,255,.52);
  border: 1px solid rgba(0,0,0,.08);
  backdrop-filter: blur(14px);
  box-shadow: 0 18px 56px rgba(0,0,0,.06);
  padding: 14px;
}
.bar{ display:flex; justify-content:space-between; align-items:center; gap: 10px; }
.lab{ font-weight: 1000; opacity:.82; font-size: 12px; }
.pager{ display:flex; align-items:center; gap: 8px; }
.mini{
  height: 30px; padding: 0 10px; border-radius: 12px;
  border: 1px solid rgba(0,0,0,.12);
  background: rgba(255,255,255,.7);
  cursor:pointer; font-weight: 900; font-size: 12px;
}
.mini:disabled{ opacity:.55; cursor:not-allowed; }
.pnum{ opacity:.72; font-weight: 900; font-size: 12px; }

.empty{ margin-top: 12px; opacity:.7; font-weight: 800; font-size: 12px; line-height: 1.6; }

.items{ margin-top: 12px; display:grid; gap: 10px; }
.item{
  padding: 12px;
  border-radius: 16px;
  background: rgba(255,255,255,.64);
  border: 1px solid rgba(0,0,0,.08);
  cursor:pointer;
  transition: .18s;
}
.item:hover{ transform: translateY(-1px); box-shadow: 0 18px 46px rgba(0,0,0,.08); }
.title{ font-weight: 1000; }
.meta{ margin-top: 6px; opacity:.72; font-weight: 900; font-size: 12px; display:flex; gap: 10px; flex-wrap:wrap; }
.snippet{ margin-top: 8px; opacity:.82; font-weight: 800; font-size: 12px; line-height: 1.8; }
.time{ opacity:.55; }
</style>
