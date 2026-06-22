<template>
  <div class="shugePage">
    <section class="heroSection">
      <div class="heroStage">
        <div class="heroPanels">
          <button class="heroPanel side left" type="button" @click="prevImage">
            <img :src="heroImages[leftIndex]" alt="上一张" />
          </button>

          <button class="heroPanel center" type="button" @click="openViewer(currentIndex)">
            <img :src="heroImages[currentIndex]" alt="苏幕遮主图" />
            <div class="centerGlow"></div>
            <div class="heroHint">点击查看大图</div>
            <button class="switchBtn" type="button" @click.stop="nextImage">切换画面</button>
          </button>

          <button class="heroPanel side right" type="button" @click="nextImage">
            <img :src="heroImages[rightIndex]" alt="下一张" />
          </button>
        </div>

        <div class="thumbRail">
          <button
            v-for="(img, index) in heroImages"
            :key="img"
            class="thumbItem"
            :class="{ active: index === currentIndex }"
            type="button"
            @click="setCurrent(index)"
          >
            <img :src="img" :alt="`缩略图 ${index + 1}`" />
          </button>
        </div>
      </div>
    </section>

    <section class="contentWrap">
      <main class="mainCol">
        <h1 class="title">苏幕遮·燎沉香</h1>
        <div class="metaLine">撰目 未言 / 类目 宋词、书法、艺术类 / 2026年04月01日</div>

        <div class="introText">
          <p>
            此《苏幕遮·燎沉香》为北宋词人周邦彦的代表名篇，兼具清丽写景与深婉思乡双重气质。上片自室内暑气写到庭院晨景，再转入荷塘清景；下片由景生情，以羁旅之身回望江南故乡，情味深远。
          </p>
          <p>
            尤其“叶上初阳干宿雨，水面清圆，一一风荷举”一段，历来被视为宋词写荷的巅峰片段。全句不用浓艳辞藻，而以清圆、风举之态写尽荷叶精神，空灵、清润、自然，极见周邦彦炼字之功。
          </p>
          <p>
            本页采用典藏专题式排版，把作品主图、题签信息、正文赏析和背景说明整合到同一页面里，让它更像一页可以细读、可以浏览细节、也可以继续延展的古籍主题展示页。
          </p>
        </div>

        <div class="catalogCard">
          <div class="catalogHead">目录</div>
          <div class="catalogList">
            <a href="#poem">全词原文</a>
            <a href="#translation">白话译文</a>
            <a href="#background">背景与情感</a>
            <a href="#analysis">名句赏析</a>
            <a href="#writer">周邦彦其人</a>
            <a href="#extend">拓展阅读</a>
          </div>
        </div>

        <div class="inlineImageCard">
          <img :src="heroImages[currentIndex]" alt="苏幕遮主题图" />
          <div class="inlineImageCap">《苏幕遮·燎沉香》主题展示图</div>
        </div>

        <section id="poem" class="articleSection">
          <h2>全词原文</h2>
          <div class="articleCard poemText">
            燎沉香，消溽暑。鸟雀呼晴，侵晓窥檐语。<br />
            叶上初阳干宿雨，水面清圆，一一风荷举。<br /><br />
            故乡遥，何日去？家住吴门，久作长安旅。<br />
            五月渔郎相忆否？小楫轻舟，梦入芙蓉浦。
          </div>
        </section>

        <section id="translation" class="articleSection">
          <h2>白话译文</h2>
          <div class="articleCard splitCard">
            <div class="splitRow">
              <div class="splitTitle">燎沉香，消溽暑</div>
              <div class="splitText">点起沉香，驱散夏日潮湿闷热的暑气。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">鸟雀呼晴，侵晓窥檐语</div>
              <div class="splitText">天刚蒙蒙亮，鸟雀在檐边啼叫，仿佛在呼唤放晴。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">叶上初阳干宿雨，水面清圆，一一风荷举</div>
              <div class="splitText">初升的阳光晒干了荷叶上的夜雨，清圆的荷叶在风中一片片挺立起来。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">故乡遥，何日去</div>
              <div class="splitText">故乡那么遥远，我什么时候才能回去？</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">家住吴门，久作长安旅</div>
              <div class="splitText">我的家在吴地，却长久客居京城。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">五月渔郎相忆否？小楫轻舟，梦入芙蓉浦</div>
              <div class="splitText">五月的故乡水乡，不知那些渔人是否还记得我；梦里我驾着小舟，重回荷花深处。</div>
            </div>
          </div>
        </section>

        <section id="background" class="articleSection">
          <h2>背景与情感</h2>
          <div class="articleCard">
            <p>
              这首词写于周邦彦旅居京城时期。周邦彦本是江南之人，长期滞留京师，仕途与身世之感交织，因而这首词并不止于咏荷，而是借荷景引出乡思。上片先写清晨、鸟雀、宿雨、荷叶，层层推进，气息从闷热转向清润；下片则由景入情，从荷塘转到江南，从眼前写到梦中，虚实相生。
            </p>
            <p>
              它动人的地方，在于情绪并不直接堆叠，而是藏在景物背后。读到最后一句“梦入芙蓉浦”，才会发现上片的荷景其实早已埋下归乡之念。周邦彦最擅长的，正是这种不露痕迹的婉转铺叙。
            </p>
          </div>
        </section>

        <section id="analysis" class="articleSection">
          <h2>名句赏析</h2>
          <div class="quoteCard">
            <div class="quoteMain">叶上初阳干宿雨，水面清圆，一一风荷举。</div>
            <div class="quoteSub">这一段是全词最著名的部分，也是宋词写荷的代表性名句。</div>
          </div>

          <div class="articleCard">
            <p>
              “清圆”二字极见神采。它既写荷叶的圆润，也写雨后水面的洁净澄明；景物不繁，境界却很开阔。“举”字更是传神，不是静止的摆放，而是随风而起、自然舒展，让荷叶有了立体的生命感。
            </p>
            <p>
              全句没有刻意雕饰，却把雨后荷塘的清气、晨光的柔润、微风的流动感都写出来了。画面并不艳丽，反而因为留白多、动势轻，而显得格外耐看。这也正是周邦彦词风里最精细的一面。
            </p>
          </div>
        </section>

        <section id="writer" class="articleSection">
          <h2>周邦彦其人</h2>
          <div class="articleCard">
            <ul class="detailList">
              <li>北宋词人，字美成，号清真居士。</li>
              <li>婉约派集大成者，精通音律，长于铺叙与炼字。</li>
              <li>语言典丽，格律严整，对后来的姜夔、吴文英等人影响很大。</li>
              <li>后世常称其为“词家之冠”“词中老杜”。</li>
            </ul>
          </div>
        </section>

        <section id="extend" class="articleSection">
          <h2>拓展阅读</h2>
          <div class="articleCard">
            <div class="extendGrid">
              <div class="extendItem">
                <div class="extendTitle">兰陵王·柳</div>
                <div class="extendText">送别词中的高峰之作，格局开阔，情绪层层递进。</div>
              </div>
              <div class="extendItem">
                <div class="extendTitle">少年游·并刀如水</div>
                <div class="extendText">语言精丽，写情极细，兼有市井烟火与婉约雅致。</div>
              </div>
              <div class="extendItem">
                <div class="extendTitle">西河·金陵怀古</div>
                <div class="extendText">怀古与身世相融，结构完整，气象深沉。</div>
              </div>
              <div class="extendItem">
                <div class="extendTitle">蝶恋花·早行</div>
                <div class="extendText">旅途中写晨色与心绪，冷清而有余味。</div>
              </div>
            </div>
          </div>
        </section>
      </main>

      <aside class="sideCol">
        <div class="infoCard">
          <div class="infoBlock">
            <div class="infoTitle">作品信息</div>
            <div class="infoDesc">北宋·周邦彦《苏幕遮·燎沉香》主题展示页</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">作者信息</div>
            <div class="infoDesc">周邦彦，字美成，号清真居士，北宋婉约词宗</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">形式信息</div>
            <div class="infoDesc">古籍专题排版 · 图文分栏 · 典藏式阅读页面</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">出处信息</div>
            <div class="infoDesc">相关词集：《清真集》《片玉词》</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">意象主题</div>
            <div class="infoDesc">荷塘、清晨、江南、羁旅、梦归</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">核心名句</div>
            <div class="infoDesc">水面清圆，一一风荷举</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">页面亮点</div>
            <div class="infoDesc">顶部大图展示、目录跳转、正文细读、古籍风格信息侧栏</div>
          </div>
        </div>
      </aside>
    </section>

    <div v-if="viewerOpen" class="viewerMask" @click.self="closeViewer">
      <div class="viewerPanel">
        <button class="viewerClose" type="button" @click="closeViewer">×</button>
        <button class="viewerArrow left" type="button" @click.stop="prevImage">‹</button>
        <img :src="heroImages[currentIndex]" alt="大图预览" />
        <button class="viewerArrow right" type="button" @click.stop="nextImage">›</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref } from "vue"
import s1 from "@/assets/banners/b2.gif"
import s2 from "@/assets/banners/b2左.gif"
import s3 from "@/assets/banners/b2右.gif"

const heroImages = [s1, s2, s3]
const currentIndex = ref(0)
const viewerOpen = ref(false)

const leftIndex = computed(() => {
  return (currentIndex.value - 1 + heroImages.length) % heroImages.length
})

const rightIndex = computed(() => {
  return (currentIndex.value + 1) % heroImages.length
})

function setCurrent(index) {
  currentIndex.value = index
}

function prevImage() {
  currentIndex.value = (currentIndex.value - 1 + heroImages.length) % heroImages.length
}

function nextImage() {
  currentIndex.value = (currentIndex.value + 1) % heroImages.length
}

function openViewer(index) {
  currentIndex.value = index
  viewerOpen.value = true
}

function closeViewer() {
  viewerOpen.value = false
}
</script>

<style scoped>
.shugePage {
  min-height: 100vh;
  margin: 0;
  padding: 0;
  background:
    linear-gradient(180deg, #efede6 0%, #f5f1e8 24%, #f5f1e8 100%);
  color: #2f2a24;
  font-family: "STSong", "SimSun", "Songti SC", serif;
}

.heroSection {
  width: 100%;
  padding-top: 0;
  background:
    linear-gradient(rgba(103, 109, 93, 0.16), rgba(103, 109, 93, 0.16)),
    #d5cfbe;
  border-top: 8px solid rgba(255, 255, 255, 0.38);
}

.heroStage {
  width: min(1600px, calc(100% - 24px));
  margin: 0 auto;
  padding: 20px 0 12px;
}

.heroPanels {
  display: grid;
  grid-template-columns: 1fr 1.95fr 1fr;
  gap: 0;
  border: 1px solid rgba(140, 108, 76, 0.38);
  box-shadow: 0 18px 40px rgba(59, 47, 31, 0.08);
}

.heroPanel {
  position: relative;
  min-height: 520px;
  padding: 0;
  border: none;
  overflow: hidden;
  background: #c9c2ab;
  cursor: pointer;
}

.heroPanel + .heroPanel {
  border-left: 6px solid #1b1b1b;
}

.heroPanel img {
  width: 100%;
  height: 100%;
  display: block;
  object-fit: cover;
  filter: saturate(0.92) contrast(0.97);
  transition: transform 0.45s ease;
}

.heroPanel:hover img {
  transform: scale(1.02);
}

.heroPanel.center {
  min-height: 520px;
}

.centerGlow {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(circle at center, rgba(255, 255, 255, 0.02), rgba(0, 0, 0, 0.08));
  pointer-events: none;
}

.heroHint {
  position: absolute;
  left: 22px;
  bottom: 20px;
  padding: 8px 14px;
  background: rgba(33, 33, 33, 0.52);
  color: #fff;
  font-size: 14px;
  letter-spacing: 1px;
}

.switchBtn {
  position: absolute;
  right: 18px;
  bottom: 18px;
  border: none;
  background: rgba(45, 45, 45, 0.72);
  color: #fff;
  padding: 10px 18px;
  font-size: 15px;
  cursor: pointer;
}

.thumbRail {
  display: flex;
  justify-content: center;
  gap: 14px;
  padding: 16px 0 6px;
}

.thumbItem {
  width: 112px;
  height: 72px;
  padding: 0;
  border: 1px solid rgba(122, 97, 64, 0.22);
  background: #e6decd;
  cursor: pointer;
  overflow: hidden;
  opacity: 0.78;
  transition: all 0.28s ease;
}

.thumbItem.active {
  opacity: 1;
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(70, 56, 39, 0.12);
  border-color: rgba(140, 73, 57, 0.4);
}

.thumbItem img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.contentWrap {
  width: min(1240px, calc(100% - 60px));
  margin: 0 auto;
  display: grid;
  grid-template-columns: minmax(0, 1fr) 330px;
  gap: 52px;
  padding: 22px 0 80px;
}

.mainCol {
  min-width: 0;
}

.title {
  margin: 0;
  font-size: 56px;
  line-height: 1.14;
  font-weight: 500;
  color: #211d19;
}

.metaLine {
  margin-top: 10px;
  color: #6f665b;
  font-size: 19px;
  line-height: 1.8;
}

.introText {
  margin-top: 24px;
  font-size: 18px;
  line-height: 2.02;
  color: #2f2a24;
}

.introText p {
  margin: 0 0 18px;
}

.catalogCard {
  margin-top: 26px;
  padding: 18px 20px;
  background: rgba(255, 255, 255, 0.46);
  border: 1px solid rgba(123, 98, 66, 0.14);
}

.catalogHead {
  font-size: 24px;
  color: #8e302e;
  margin-bottom: 12px;
}

.catalogList {
  display: flex;
  flex-wrap: wrap;
  gap: 14px 18px;
}

.catalogList a {
  color: #473f34;
  text-decoration: none;
  padding-left: 12px;
  position: relative;
  font-size: 16px;
}

.catalogList a::before {
  content: "";
  position: absolute;
  left: 0;
  top: 9px;
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: #a33e3a;
}

.catalogList a:hover {
  color: #a33e3a;
}

.inlineImageCard {
  margin-top: 30px;
  background: #ece4d3;
  border: 1px solid rgba(125, 103, 74, 0.16);
  padding: 14px;
}

.inlineImageCard img {
  width: 100%;
  display: block;
}

.inlineImageCap {
  margin-top: 12px;
  color: #6c6258;
  font-size: 14px;
}

.articleSection {
  margin-top: 34px;
  scroll-margin-top: 24px;
}

.articleSection h2 {
  margin: 0 0 14px;
  font-size: 31px;
  font-weight: 500;
  color: #2a251f;
}

.articleCard {
  background: rgba(255, 255, 255, 0.48);
  border: 1px solid rgba(123, 98, 66, 0.14);
  padding: 24px 26px;
  font-size: 17px;
  line-height: 2;
  color: #302b25;
}

.articleCard p {
  margin: 0 0 16px;
}

.articleCard p:last-child {
  margin-bottom: 0;
}

.poemText {
  font-size: 21px;
  line-height: 2.15;
  letter-spacing: 0.4px;
}

.splitCard {
  display: grid;
  gap: 14px;
}

.splitRow {
  padding-bottom: 12px;
  border-bottom: 1px dashed rgba(127, 104, 76, 0.16);
}

.splitRow:last-child {
  padding-bottom: 0;
  border-bottom: none;
}

.splitTitle {
  font-size: 17px;
  color: #8f3330;
  margin-bottom: 4px;
}

.splitText {
  color: #2f2a24;
}

.quoteCard {
  padding: 24px 26px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.54), rgba(247, 241, 231, 0.72));
  border: 1px solid rgba(137, 108, 79, 0.16);
  margin-bottom: 14px;
}

.quoteMain {
  font-size: 30px;
  line-height: 1.7;
  color: #832e2b;
}

.quoteSub {
  margin-top: 10px;
  color: #655c52;
  font-size: 15px;
}

.detailList {
  margin: 0;
  padding-left: 20px;
}

.detailList li {
  margin-bottom: 8px;
}

.extendGrid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 16px;
}

.extendItem {
  background: rgba(245, 240, 231, 0.8);
  border: 1px solid rgba(132, 108, 78, 0.12);
  padding: 16px 16px 14px;
}

.extendTitle {
  font-size: 18px;
  color: #7f2f2c;
  margin-bottom: 8px;
}

.extendText {
  font-size: 15px;
  line-height: 1.9;
  color: #3d372f;
}

.sideCol {
  position: relative;
}

.infoCard {
  position: sticky;
  top: 28px;
  background: rgba(255, 255, 255, 0.54);
  border-left: 1px solid rgba(125, 101, 72, 0.18);
  padding-left: 28px;
}

.infoBlock {
  padding: 10px 0 18px;
  border-bottom: 1px dashed rgba(125, 101, 72, 0.16);
}

.infoBlock:last-child {
  border-bottom: none;
}

.infoTitle {
  margin-bottom: 8px;
  font-size: 27px;
  color: #913532;
}

.infoDesc {
  font-size: 17px;
  line-height: 1.85;
  color: #2f2a24;
}

.viewerMask {
  position: fixed;
  inset: 0;
  z-index: 90;
  background: rgba(22, 20, 18, 0.82);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
}

.viewerPanel {
  position: relative;
  width: min(1200px, 100%);
  max-height: 92vh;
  background: #111;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px 70px;
}

.viewerPanel img {
  max-width: 100%;
  max-height: 80vh;
  object-fit: contain;
}

.viewerClose {
  position: absolute;
  top: 14px;
  right: 18px;
  border: none;
  background: transparent;
  color: #fff;
  font-size: 34px;
  cursor: pointer;
}

.viewerArrow {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  border: none;
  width: 46px;
  height: 70px;
  background: rgba(255, 255, 255, 0.12);
  color: #fff;
  font-size: 34px;
  cursor: pointer;
}

.viewerArrow.left {
  left: 14px;
}

.viewerArrow.right {
  right: 14px;
}

@media (max-width: 1200px) {
  .heroPanels {
    grid-template-columns: 1fr;
  }

  .heroPanel {
    min-height: 360px;
  }

  .heroPanel + .heroPanel {
    border-left: none;
    border-top: 6px solid #1b1b1b;
  }

  .contentWrap {
    grid-template-columns: 1fr;
    gap: 30px;
  }

  .infoCard {
    position: static;
    border-left: none;
    padding-left: 0;
  }
}

@media (max-width: 768px) {
  .heroStage {
    width: calc(100% - 12px);
    padding-top: 12px;
  }

  .heroPanel {
    min-height: 250px;
  }

  .thumbRail {
    gap: 8px;
  }

  .thumbItem {
    width: 80px;
    height: 52px;
  }

  .contentWrap {
    width: calc(100% - 24px);
    padding: 18px 0 56px;
  }

  .title {
    font-size: 34px;
  }

  .metaLine,
  .introText,
  .infoDesc,
  .articleCard,
  .splitTitle,
  .splitText {
    font-size: 15px;
  }

  .poemText {
    font-size: 17px;
    line-height: 2;
  }

  .articleSection h2,
  .infoTitle,
  .catalogHead {
    font-size: 22px;
  }

  .quoteMain {
    font-size: 22px;
  }

  .extendGrid {
    grid-template-columns: 1fr;
  }

  .viewerPanel {
    padding: 28px 44px;
  }
}
</style>