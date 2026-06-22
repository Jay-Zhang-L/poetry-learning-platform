<template>
  <div class="detailPage">
    <section class="hero" :style="{ backgroundImage: `url(${bg})` }">
      <div class="heroMask"></div>

      <div class="closeWrap">
        <button class="closeBtn" type="button" @click="goBack">✕</button>
      </div>

      <div class="heroContent">
        <div class="heroTitle">{{ title }}</div>
        <div class="heroDesc">{{ desc }}</div>
      </div>
    </section>

    <section class="contentSection">
      <div class="contentWrap">
        <div class="sectionTitle">古体诗分类内容</div>
        <div class="sectionSub">这里以后可以接你的真实数据、分类、诗词列表、详情内容</div>

        <div class="cardGrid">
          <div class="poemCard" v-for="i in 12" :key="i">
            <div class="cardTop">
              <div class="cardTag">古体</div>
              <div class="cardIndex">0{{ i }}</div>
            </div>
            <div class="cardTitle">诗词示例 {{ i }}</div>
            <div class="cardText">
              这里放这一分类下的诗词简介、名句、作者信息或者跳转入口。
            </div>
            <button class="cardBtn" type="button">查看详情</button>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import bg from '@/assets/home/scroll/1.jpg'

const router = useRouter()

const detailKey = 'a1'
const title = '古体诗'
const desc = '山水入诗 · 意境悠远'

function goBack() {
  sessionStorage.setItem('homeReturnMenuKey', detailKey)
  router.push('/home')
}
</script>

<style scoped>
.detailPage {
  width: 100%;
  min-height: 100vh;
  background: #f7f4ee;
}

.hero {
  position: relative;
  width: 100%;
  height: 32vh;
  min-height: 260px;
  max-height: 380px;
  background-size: cover;
  background-position: center;
  overflow: hidden;
}

.heroMask {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, 0.18) 0%, rgba(0, 0, 0, 0.34) 100%);
}

.closeWrap {
  position: absolute;
  top: 20px;
  right: 20px;
  z-index: 10;
}

.closeBtn {
  width: 42px;
  height: 42px;
  border-radius: 50%;
  border: none;
  background: rgba(0, 0, 0, 0.35);
  color: #fff;
  font-size: 20px;
  line-height: 1;
  cursor: pointer;
  backdrop-filter: blur(6px);
  transition: transform 0.25s ease, background 0.25s ease;
}

.closeBtn:hover {
  transform: scale(1.08);
  background: rgba(0, 0, 0, 0.55);
}

.heroContent {
  position: absolute;
  left: 48px;
  right: 48px;
  bottom: 34px;
  z-index: 3;
  color: #fff;
}

.heroTitle {
  font-size: 52px;
  font-weight: 700;
  line-height: 1.1;
  margin-bottom: 12px;
}

.heroDesc {
  font-size: 18px;
  opacity: 0.92;
  line-height: 1.7;
}

.contentSection {
  position: relative;
  margin-top: 0;
  background: #f7f4ee;
  border-radius: 0;
  z-index: 2;
  min-height: 62vh;
}

.contentWrap {
  max-width: 1440px;
  margin: 0 auto;
  padding: 42px 32px 64px;
}

.sectionTitle {
  font-size: 30px;
  font-weight: 700;
  color: #1f1a17;
  margin-bottom: 10px;
}

.sectionSub {
  font-size: 15px;
  color: #7a6f66;
  margin-bottom: 30px;
  line-height: 1.8;
}

.cardGrid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 22px;
}

.poemCard {
  background: #fff;
  border-radius: 22px;
  padding: 22px 22px 20px;
  box-shadow: 0 12px 30px rgba(44, 34, 24, 0.08);
  transition: transform 0.28s ease, box-shadow 0.28s ease;
}

.poemCard:hover {
  transform: translateY(-6px);
  box-shadow: 0 18px 38px rgba(44, 34, 24, 0.12);
}

.cardTop {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 18px;
}

.cardTag {
  display: inline-flex;
  align-items: center;
  height: 28px;
  padding: 0 12px;
  border-radius: 999px;
  background: #f2ece2;
  color: #7a5a35;
  font-size: 13px;
}

.cardIndex {
  color: #b8aa98;
  font-size: 13px;
}

.cardTitle {
  font-size: 22px;
  font-weight: 700;
  color: #241d18;
  margin-bottom: 14px;
}

.cardText {
  font-size: 14px;
  line-height: 1.9;
  color: #6e6257;
  min-height: 78px;
}

.cardBtn {
  margin-top: 18px;
  border: none;
  background: #1f1a17;
  color: #fff;
  height: 42px;
  padding: 0 18px;
  border-radius: 999px;
  cursor: pointer;
  transition: all 0.25s ease;
}

.cardBtn:hover {
  transform: translateY(-2px);
  opacity: 0.92;
}

@media (max-width: 1200px) {
  .cardGrid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}

@media (max-width: 900px) {
  .heroTitle {
    font-size: 40px;
  }

  .cardGrid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .hero {
    height: 30vh;
    min-height: 220px;
  }

  .heroContent {
    left: 22px;
    right: 22px;
    bottom: 24px;
  }

  .heroTitle {
    font-size: 30px;
  }

  .heroDesc {
    font-size: 14px;
  }

  .contentWrap {
    padding: 30px 16px 46px;
  }

  .cardGrid {
    grid-template-columns: 1fr;
  }
}
</style>
