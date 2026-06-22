<template>
  <div class="shugePage">
    <section class="heroSection">
      <div class="heroStage">
        <div class="heroPanels">
          <button class="heroPanel side left" type="button" @click="prevImage">
            <img :src="heroImages[leftIndex]" alt="上一张" />
          </button>

          <button class="heroPanel center" type="button" @click="openViewer(currentIndex)">
            <img :src="heroImages[currentIndex]" alt="离骚主图" />
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
        <h1 class="title">离骚（节选）</h1>
        <div class="metaLine">撰目 屈原 / 类目 楚辞、先秦文学、浪漫主义 / 2026年04月01日</div>

        <div class="introText">
          <p>
            《离骚》是战国时期楚国诗人屈原的代表作，也是中国古代最长的抒情诗，更是楚辞体的巅峰之作。全诗以诗人的身世、理想、遭遇为线索，将浪漫想象与现实情志融为一体，开创了中国文学“香草美人”的比兴传统。
          </p>
          <p>
            开篇“帝高阳之苗裔兮，朕皇考曰伯庸”一段，自叙身世与修德之志，是《离骚》最具代表性的开篇，尽显屈原高洁的人格与远大的政治抱负，成为千古传诵的经典。
          </p>
          <p>
            本页完全沿用你固定版式，做成典藏专题式阅读页，把主图轮播、作品信息、正文节选、白话梳理、背景、名句赏析与拓展阅读统一整合，气质工整统一。
          </p>
        </div>

        <div class="catalogCard">
          <div class="catalogHead">目录</div>
          <div class="catalogList">
            <a href="#text">原文节选</a>
            <a href="#translation">白话梳理</a>
            <a href="#background">写作背景</a>
            <a href="#analysis">名句赏析</a>
            <a href="#writer">屈原其人</a>
            <a href="#extend">拓展阅读</a>
          </div>
        </div>

        <div class="inlineImageCard">
          <img :src="heroImages[currentIndex]" alt="离骚主题图" />
          <div class="inlineImageCap">《离骚》开篇书法主题展示图</div>
        </div>

        <section id="text" class="articleSection">
          <h2>原文节选</h2>
          <div class="articleCard poemText">
            帝高阳之苗裔兮，朕皇考曰伯庸。<br />
            摄提贞于孟陬兮，惟庚寅吾以降。<br />
            皇览揆余初度兮，肇锡余以嘉名：<br />
            名余曰正则兮，字余曰灵均。<br /><br />
            纷吾既有此内美兮，又重之以修能。<br />
            扈江离与辟芷兮，纫秋兰以为佩。<br />
            汩余若将不及兮，恐年岁之不吾与。<br />
            朝搴阰之木兰兮，夕揽洲之宿莽。<br />
            日月忽其不淹兮，春与秋其代序。<br />
            惟草木之零落兮，恐美人之迟暮。<br />
            不抚壮而弃秽兮，何不改乎此度？<br />
            乘骐骥以驰骋兮，来吾道夫先路！
          </div>
        </section>

        <section id="translation" class="articleSection">
          <h2>白话梳理</h2>
          <div class="articleCard splitCard">
            <div class="splitRow">
              <div class="splitTitle">帝高阳之苗裔兮，朕皇考曰伯庸</div>
              <div class="splitText">我是古帝高阳氏的后裔，先父名叫伯庸。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">摄提贞于孟陬兮，惟庚寅吾以降</div>
              <div class="splitText">太岁在寅的孟春正月，庚寅日我降生人世。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">名余曰正则兮，字余曰灵均</div>
              <div class="splitText">父亲为我取名正则，取字灵均。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">扈江离与辟芷兮，纫秋兰以为佩</div>
              <div class="splitText">身披江离与辟芷，把秋兰串成佩饰，象征修德。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">恐年岁之不吾与</div>
              <div class="splitText">担心时光流逝，不等待我。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">乘骐骥以驰骋兮，来吾道夫先路</div>
              <div class="splitText">驾着骏马奔腾，我来为君王引路开路。</div>
            </div>
          </div>
        </section>

        <section id="background" class="articleSection">
          <h2>写作背景</h2>
          <div class="articleCard">
            <p>
              《离骚》作于屈原被楚怀王疏远、流放汉北时期。屈原出身楚国贵族，一心辅佐楚王变法图强，却遭奸佞排挤，政治理想破灭。他以诗歌抒发内心的愤懑、对家国的忠诚，以及对理想的执着追求，是中国古代文人“发愤以抒情”的源头。
            </p>
            <p>
              全诗以“香草美人”为核心比兴，将个人命运与国家命运紧密相连，既充满浪漫奇幻的想象，又饱含深沉的家国情怀，奠定了中国浪漫主义文学的基石。
            </p>
          </div>
        </section>

        <section id="analysis" class="articleSection">
          <h2>名句赏析</h2>
          <div class="quoteCard">
            <div class="quoteMain">扈江离与辟芷兮，纫秋兰以为佩。</div>
            <div class="quoteSub">《离骚》“香草美人”比兴传统的开篇代表。</div>
          </div>

          <div class="articleCard">
            <p>
              江离、辟芷、秋兰都是香草，屈原以佩戴香草象征自己修身洁行、品德高洁，开创了中国文学以香草喻君子的经典范式。这两句不仅是写景，更是屈原人格的自我写照。
            </p>
            <p>
              香草与后文的“美人”呼应，形成完整的比兴体系，让抽象的品德变得可感可触，成为后世文人表达高洁志向的经典意象。
            </p>
          </div>

          <div class="quoteCard" style="margin-top: 18px;">
            <div class="quoteMain">乘骐骥以驰骋兮，来吾道夫先路！</div>
            <div class="quoteSub">屈原政治理想与报国之志的集中体现。</div>
          </div>

          <div class="articleCard">
            <p>
              “骐骥”比喻贤才，“先路”意为开路先锋。屈原以骏马驰骋为喻，表达自己愿为楚王变法图强、引领楚国走向强盛的决心，尽显其忠君爱国、勇于担当的精神。
            </p>
            <p>
              这句是《离骚》开篇情志的升华，将个人修德与家国担当融为一体，奠定了全诗的精神基调。
            </p>
          </div>
        </section>

        <section id="writer" class="articleSection">
          <h2>屈原其人</h2>
          <div class="articleCard">
            <ul class="detailList">
              <li>战国时期楚国诗人、政治家，中国浪漫主义文学的奠基人。</li>
              <li>“楚辞”的创立者和代表作家，开创了“香草美人”的比兴传统。</li>
              <li>代表作《离骚》《九歌》《九章》《天问》等，《离骚》是中国最长抒情诗。</li>
              <li>其爱国精神与高洁人格，成为中国文人精神的标杆，端午因他而传承。</li>
            </ul>
          </div>
        </section>

        <section id="extend" class="articleSection">
          <h2>拓展阅读</h2>
          <div class="articleCard">
            <div class="extendGrid">
              <div class="extendItem">
                <div class="extendTitle">九歌·湘夫人</div>
                <div class="extendText">“袅袅兮秋风，洞庭波兮木叶下”，楚辞写景千古名句。</div>
              </div>
              <div class="extendItem">
                <div class="extendTitle">九章·橘颂</div>
                <div class="extendText">咏物言志的典范，以橘树喻君子品格。</div>
              </div>
              <div class="extendItem">
                <div class="extendTitle">天问</div>
                <div class="extendText">千古奇文，对天地自然、历史人事发出170余问。</div>
              </div>
              <div class="extendItem">
                <div class="extendTitle">九辩（宋玉）</div>
                <div class="extendText">楚辞经典，悲秋题材的开山之作，继承屈原文风。</div>
              </div>
            </div>
          </div>
        </section>
      </main>

      <aside class="sideCol">
        <div class="infoCard">
          <div class="infoBlock">
            <div class="infoTitle">作品信息</div>
            <div class="infoDesc">战国·屈原《离骚》（开篇节选）专题展示页</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">作者信息</div>
            <div class="infoDesc">屈原，战国楚大夫，楚辞鼻祖，浪漫主义文学奠基人</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">形式信息</div>
            <div class="infoDesc">古籍专题排版 · 图文分栏 · 典藏式阅读页面</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">出处信息</div>
            <div class="infoDesc">《楚辞》，屈原代表作，中国古代最长抒情诗</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">意象主题</div>
            <div class="infoDesc">香草美人、身世、理想、家国、浪漫主义</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">核心名句</div>
            <div class="infoDesc">扈江离与辟芷兮，纫秋兰以为佩；乘骐骥以驰骋兮，来吾道夫先路</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">页面亮点</div>
            <div class="infoDesc">顶部大图展示、目录跳转、原文细读、古籍风格信息侧栏</div>
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
import s1 from "@/assets/banners/b5.gif"
import s2 from "@/assets/banners/b5左.gif"
import s3 from "@/assets/banners/b5右.gif"

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
/* 完全和你给的滕王阁序样式一模一样，未做任何修改 */
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