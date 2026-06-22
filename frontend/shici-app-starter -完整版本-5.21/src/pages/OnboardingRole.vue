<template>
  <div class="wrap">
    <div class="panel glass fade-in">
      <div class="head">
        <div>
          <div class="title">选择你的身份</div>
          <div class="sub muted">身份将影响：推荐内容、解释深度、学习路径与AI讲解风格</div>
        </div>
        <div class="seal" aria-hidden="true">卷</div>
      </div>

      <div class="grid">
        <button class="role" @click="pick('primary')">
          <div class="h">小学</div>
          <div class="d muted">注音与配图 · 轻任务 · 更鼓励</div>
        </button>
        <button class="role" @click="pick('junior')">
          <div class="h">初中</div>
          <div class="d muted">课内必背 · 背诵巩固 · 基础赏析</div>
        </button>
        <button class="role" @click="pick('senior')">
          <div class="h">高中</div>
          <div class="d muted">鉴赏考点 · 术语手法 · 题型训练</div>
        </button>
        <button class="role" @click="pick('lover')">
          <div class="h">爱好者</div>
          <div class="d muted">专题意境 · 典故深挖 · 名句收藏</div>
        </button>
      </div>

      <div class="foot">
        <div class="hint muted">可在【中心】随时切换</div>
        <div class="mini muted">提示：点击任意卡片进入首页（电脑端优先展示）</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { useProfileStore } from '../stores/profile'

const router = useRouter()
const profile = useProfileStore()

function pick(role) {
  profile.setRole(role)
  router.replace('/home')
}
</script>

<style scoped>
.wrap{
  min-height:100vh;
  display:grid;
  place-items:center;
  padding: 26px;
}
.panel{
  width: min(980px, 100%);
  padding: 22px;
  border-radius: 26px;
  box-shadow: 0 22px 70px rgba(0,0,0,.16);
  position: relative;
  overflow: hidden;
}

/* 炫技感：卷轴背景漂移（不用点也在动） */
.panel::before{
  content:"";
  position:absolute; inset:-30%;
  background:
    radial-gradient(400px 240px at 25% 25%, rgba(0,0,0,.06), transparent 60%),
    radial-gradient(500px 320px at 75% 45%, rgba(0,0,0,.05), transparent 62%);
  animation: drift 8s ease-in-out infinite alternate;
  pointer-events:none;
}
@keyframes drift{
  from{ transform: translate3d(-2%, -1%,0) scale(1.03); }
  to{ transform: translate3d(2%, 1%,0) scale(1.06); }
}

.head{
  display:flex;
  align-items:flex-start;
  justify-content:space-between;
  gap:14px;
  position: relative;
}
.title{ font-size: 22px; font-weight: 1000; letter-spacing: .5px; }
.sub{ margin-top: 8px; line-height: 1.6; }
.seal{
  width: 48px; height:48px; border-radius: 18px;
  display:grid; place-items:center;
  background: rgba(0,0,0,.86); color:#fff; font-weight:1000;
  box-shadow: 0 18px 40px rgba(0,0,0,.22);
}

.grid{
  margin-top: 16px;
  display:grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
  position: relative;
}

/* 入场动画：卡片逐个上浮 */
.role{
  text-align:left;
  padding: 16px;
  border-radius: 20px;
  border: 1px solid rgba(0,0,0,.10);
  background: rgba(255,255,255,.86);
  cursor:pointer;
  transition: transform .14s ease, box-shadow .14s ease;
  animation: rise .42s ease both;
}
.role:nth-child(1){ animation-delay: .02s; }
.role:nth-child(2){ animation-delay: .06s; }
.role:nth-child(3){ animation-delay: .10s; }
.role:nth-child(4){ animation-delay: .14s; }

@keyframes rise{
  from{ opacity:0; transform: translateY(10px); }
  to{ opacity:1; transform: translateY(0); }
}

.role:hover{ transform: translateY(-2px); box-shadow: 0 18px 36px rgba(0,0,0,.14); }
.h{ font-weight: 1000; font-size: 16px; }
.d{ margin-top: 6px; font-size: 13px; line-height: 1.55; }

.foot{
  margin-top: 14px;
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:10px;
  position: relative;
}
.mini{ font-size: 12px; opacity: .7; }

@media (max-width: 760px){
  .grid{ grid-template-columns: 1fr; }
  .foot{ flex-direction: column; align-items:flex-start; }
}
</style>
