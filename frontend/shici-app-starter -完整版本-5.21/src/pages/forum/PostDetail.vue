<template>
  <div class="wrap">
    <div class="top">
      <button class="btn ghost" @click="go('/forum')">返回列表</button>
      <button class="btn ghost" @click="share">转发</button>
    </div>

    <article class="card">
      <div class="title">{{ post.title }}</div>
      <div class="meta">{{ post.author }} · {{ post.time }}</div>
      <div class="content">{{ post.content }}</div>

      <div class="imgs" v-if="post.images?.length">
        <div class="img" v-for="(x,i) in post.images" :key="i">
          <div class="ph">图片占位</div>
          <div class="cap">{{ x }}</div>
        </div>
      </div>

      <div class="tags">
        <span class="tag" v-for="t in post.tags" :key="t"># {{ t }}</span>
      </div>
    </article>

    <section class="cmt">
      <div class="ct">评论</div>

      <div class="editor">
        <input v-model="cmt" class="inp" placeholder="写下你的看法（演示版）" @keydown.enter="send" />
        <button class="btn primary" @click="send" :disabled="!cmt.trim()">发送</button>
      </div>

      <div class="list">
        <div class="it" v-for="(x,i) in comments" :key="i">
          <div class="who">{{ x.who }}</div>
          <div class="txt">{{ x.text }}</div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { computed, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { showInfo } from "@/utils/toast";
const route = useRoute();
const router = useRouter();
function go(p){ router.push(p); }

const id = computed(() => Number(route.params.id || 1));

const post = computed(() => {
  const map = {
    1: {
      title: "飞花令关键词怎么抢得更快",
      author: "同学A",
      time: "2026-02-08 08:30",
      tags: ["飞花令","技巧"],
      content: "我发现先打出常见句式再替换关键词更快，比如先输入‘举头望明月’，再改成包含关键词的句子。你们有没有更好的输入策略？",
      images: ["操作截图1", "操作截图2"],
    },
    2: {
      title: "接龙到‘月’字我总断，求句库推荐",
      author: "同学B",
      time: "2026-02-08 09:10",
      tags: ["接龙","句库"],
      content: "有没有适合接龙的短句合集？最好是唐诗常见句，长度短一点更适合连击。",
      images: [],
    },
  };
  return map[id.value] || map[1];
});

const cmt = ref("");
const comments = ref([
  { who: "同学C", text: "可以提前准备关键词常见名句清单，输入时直接复制替换。" },
  { who: "同学D", text: "建议加输入框自动补全，体验会更像竞赛。" },
]);

function send(){
  const t = cmt.value.trim();
  if (!t) return;
  comments.value.unshift({ who: "我", text: t });
  cmt.value = "";
}
function share(){
  showInfo("演示：已复制分享文案（第二阶段接入真实转发接口）");
}
</script>

<style scoped>
.wrap{ max-width: 1100px; margin: 0 auto; padding: 14px 16px 24px; }
.top{ display:flex; gap: 10px; }

.card{
  margin-top: 12px;
  border-radius: 22px;
  border: 1px solid rgba(0,0,0,.08);
  background: rgba(255,255,255,.60);
  backdrop-filter: blur(12px);
  box-shadow: 0 22px 64px rgba(0,0,0,.08);
  padding: 16px;
}
.title{ font-weight:1000; font-size:20px; }
.meta{ margin-top:6px; opacity:.7; font-weight:800; font-size:12px; }
.content{ margin-top: 12px; line-height: 1.9; font-weight:800; opacity:.86; white-space: pre-wrap; }

.imgs{ margin-top: 12px; display:grid; grid-template-columns: repeat(2, 1fr); gap: 10px; }
.img{
  border-radius: 18px;
  border: 1px solid rgba(0,0,0,.08);
  background: rgba(255,255,255,.68);
  overflow:hidden;
}
.ph{ height: 160px; display:grid; place-items:center; opacity:.7; font-weight:900; }
.cap{ padding: 10px 12px; opacity:.7; font-weight:800; font-size:12px; }

.tags{ margin-top: 12px; display:flex; gap: 8px; flex-wrap:wrap; }
.tag{
  padding: 6px 10px;
  border-radius: 999px;
  background: rgba(60,80,70,.10);
  border: 1px solid rgba(60,80,70,.16);
  font-weight:900; font-size:12px;
}

.cmt{
  margin-top: 12px;
  border-radius: 22px;
  border: 1px solid rgba(0,0,0,.08);
  background: rgba(255,255,255,.58);
  backdrop-filter: blur(12px);
  padding: 16px;
}
.ct{ font-weight:1000; }
.editor{ margin-top: 10px; display:flex; gap: 10px; flex-wrap:wrap; }
.inp{
  flex:1; min-width: 260px;
  height: 40px;
  padding: 0 14px;
  border-radius: 14px;
  border: 1px solid rgba(0,0,0,.10);
  background: rgba(255,255,255,.72);
  outline:none;
  font-weight:900;
}
.list{ margin-top: 12px; display:flex; flex-direction:column; gap: 8px; }
.it{
  display:grid;
  grid-template-columns: 80px 1fr;
  gap: 10px;
  align-items:start;
  padding: 10px 12px;
  border-radius: 16px;
  border: 1px solid rgba(0,0,0,.08);
  background: rgba(255,255,255,.68);
}
.who{ font-weight:1000; opacity:.72; }
.txt{ font-weight:800; opacity:.9; line-height:1.7; }

.btn{
  height: 40px;
  padding: 0 14px;
  border-radius: 14px;
  border: 1px solid rgba(0,0,0,.10);
  background: rgba(255,255,255,.70);
  cursor:pointer;
  font-weight:1000;
}
.btn.primary{ background: rgba(60,80,70,.14); border-color: rgba(60,80,70,.22); }
.btn.ghost{ background: rgba(255,255,255,.45); }
.btn:disabled{ opacity:.45; cursor:not-allowed; }

@media (max-width: 760px){
  .imgs{ grid-template-columns: 1fr; }
}
</style>
