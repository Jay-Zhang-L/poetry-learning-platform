<template>
  <div class="page">
    <div class="head">
      <div>
        <div class="kicker">发布帖子</div>
        <div class="h1">写下你的观点</div>
        <div class="sub">建议包含：玩法心得 · 名句出处 · 规则改进建议</div>
      </div>

      <div class="ops">
        <button class="btn ghost" @click="goBack">返回</button>
        <button class="btn primary" :disabled="sending" @click="submit">
          {{ sending ? '发布中' : '发布' }}
        </button>
      </div>
    </div>

    <div class="card">
      <div class="lab">标题</div>
      <input v-model="title" placeholder="例如：飞花令主题字为「月」时的高命中诗句汇总" />

      <div class="lab" style="margin-top:12px;">正文</div>
      <textarea v-model="content" placeholder="输入正文内容"></textarea>

      <div class="tips">
        图片上传、转发、@评论将在第二阶段接入。当前可以先用文字与引用沉淀讨论质量。
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'

const route = useRoute()
const router = useRouter()

const seasonId = computed(()=> Number(route.query.seasonId || 1))
const title = ref('')
const content = ref('')
const sending = ref(false)

// MVP：先写死 demo 用户
const userId = 1

function goBack(){
  router.push(`/forum?seasonId=${seasonId.value}`)
}

async function submit(){
  if(!title.value.trim() || !content.value.trim()) return
  sending.value = true
  try{
    const { data } = await axios.post('/api/forum/post', {
      seasonId: seasonId.value,
      userId,
      title: title.value,
      content: content.value,
      imagesJson: null
    })
    const id = data?.data?.id
    if(id) router.push(`/post/${id}?seasonId=${seasonId.value}`)
    else goBack()
  } finally {
    sending.value = false
  }
}
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

.card{
  border-radius: 18px;
  background: rgba(255,255,255,.52);
  border: 1px solid rgba(0,0,0,.08);
  backdrop-filter: blur(14px);
  box-shadow: 0 18px 56px rgba(0,0,0,.06);
  padding: 14px;
}
.lab{ font-weight: 1000; opacity:.82; font-size: 12px; }
input{
  width: 100%;
  height: 42px;
  margin-top: 10px;
  border-radius: 14px;
  border: 1px solid rgba(0,0,0,.12);
  background: rgba(255,255,255,.72);
  padding: 0 12px;
  outline: none;
  font-weight: 900;
}
textarea{
  width: 100%;
  min-height: 220px;
  margin-top: 10px;
  border-radius: 14px;
  border: 1px solid rgba(0,0,0,.12);
  background: rgba(255,255,255,.72);
  padding: 12px;
  outline: none;
  resize: vertical;
  font-weight: 900;
  line-height: 1.8;
}
.tips{ margin-top: 10px; opacity:.72; font-weight: 800; font-size: 12px; line-height: 1.7; }
</style>
