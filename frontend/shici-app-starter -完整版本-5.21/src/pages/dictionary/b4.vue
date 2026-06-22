<template>
  <div class="shugePage">
    <section class="heroSection">
      <div class="heroStage">
        <div class="heroPanels">
          <button class="heroPanel side left" type="button" @click="prevImage">
            <img :src="heroImages[leftIndex]" alt="上一张" />
          </button>

          <button class="heroPanel center" type="button" @click="openViewer(currentIndex)">
            <img :src="heroImages[currentIndex]" alt="定风波主图" />
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
        <h1 class="title">定风波·莫听穿林打叶声</h1>
        <div class="metaLine">撰目 苏轼 / 类目 宋词、书法、艺术类 / 2026年04月01日</div>

        <div class="introText">
          <p>
            《定风波·莫听穿林打叶声》是北宋文豪苏轼的千古名篇，作于黄州贬谪时期。全词以途中遇雨为引子，借自然风雨写人生逆境，将旷达超脱的人生态度融入寻常景物，是苏轼豪放词风与人生哲学的完美体现。
          </p>
          <p>
            尤其“竹杖芒鞋轻胜马，谁怕？一蓑烟雨任平生”一句，道尽了苏轼在逆境中从容不迫、笑对人生的精神境界，成为后世无数人在困境中汲取力量的精神坐标。
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
            <a href="#writer">苏轼其人</a>
            <a href="#extend">拓展阅读</a>
          </div>
        </div>

        <div class="inlineImageCard">
          <img :src="heroImages[currentIndex]" alt="定风波主题图" />
          <div class="inlineImageCap">苏轼《定风波·莫听穿林打叶声》主题展示图</div>
        </div>

        <section id="poem" class="articleSection">
          <h2>全词原文</h2>
          <div class="articleCard poemText">
            三月七日，沙湖道中遇雨，雨具先去，同行皆狼狈，余独不觉。已而遂晴，故作此词。<br /><br />
            莫听穿林打叶声，何妨吟啸且徐行。<br />
            竹杖芒鞋轻胜马，谁怕？一蓑烟雨任平生。<br /><br />
            料峭春风吹酒醒，微冷，山头斜照却相迎。<br />
            回首向来萧瑟处，归去，也无风雨也无晴。
          </div>
        </section>

        <section id="translation" class="articleSection">
          <h2>白话译文</h2>
          <div class="articleCard splitCard">
            <div class="splitRow">
              <div class="splitTitle">莫听穿林打叶声，何妨吟啸且徐行</div>
              <div class="splitText">不用在意那穿林打叶的雨声，不妨放开喉咙吟诗长啸，悠然前行。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">竹杖芒鞋轻胜马，谁怕？一蓑烟雨任平生</div>
              <div class="splitText">竹杖草鞋轻便胜过骑马，有什么可怕？一身蓑衣任凭风吹雨打，照样过我的一生。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">料峭春风吹酒醒，微冷，山头斜照却相迎</div>
              <div class="splitText">微凉的春风吹醒了酒意，稍感寒冷，山头的夕阳却迎面照来。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">回首向来萧瑟处，归去，也无风雨也无晴</div>
              <div class="splitText">回头望一眼刚才遇雨的萧瑟之地，转身归去，对我来说，既无所谓风雨，也无所谓天晴。</div>
            </div>
          </div>
        </section>

        <section id="background" class="articleSection">
          <h2>背景与情感</h2>
          <div class="articleCard">
            <p>
              这首词写于宋神宗元丰五年（1082年），苏轼因“乌台诗案”被贬为黄州团练副使的第三个春天。他在黄州沙湖道中途中遇雨，雨具被人带走，同行者皆狼狈不堪，唯有苏轼泰然处之，雨后写下这首千古名篇。
            </p>
            <p>
              词中的“风雨”既是眼前的自然风雨，更是苏轼人生中政治风雨、人生逆境的象征。全词从遇雨的坦然，到雨后的彻悟，层层递进，将苏轼在逆境中旷达超脱、宠辱不惊的人生态度展现得淋漓尽致。
            </p>
            <p>
              它不仅是一首词，更是苏轼人生哲学的宣言：无论顺境逆境，都能从容面对，最终达到“也无风雨也无晴”的超然境界。
            </p>
          </div>
        </section>

        <section id="analysis" class="articleSection">
          <h2>名句赏析</h2>
          <div class="quoteCard">
            <div class="quoteMain">竹杖芒鞋轻胜马，谁怕？一蓑烟雨任平生。</div>
            <div class="quoteSub">全词的精神核心，苏轼旷达人生的千古绝唱。</div>
          </div>

          <div class="articleCard">
            <p>
              “竹杖芒鞋”是山野之人的装束，“马”是官宦出行的象征。苏轼却直言“轻胜马”，在他眼中，官场的束缚远不如山野的自由可贵，哪怕身处逆境，也能活出轻松自在的人生。
            </p>
            <p>
              “一蓑烟雨任平生”更是将个人的遭遇升华为整个人生的态度：一生风雨，我自坦然承受，不怨天、不尤人，以从容之姿面对一切。这句话成为了中国文人逆境中精神的灯塔，穿越千年依然振聋发聩。
            </p>
          </div>

          <div class="quoteCard">
            <div class="quoteMain">回首向来萧瑟处，归去，也无风雨也无晴。</div>
            <div class="quoteSub">全词的思想升华，苏轼人生境界的终极体现。</div>
          </div>

          <div class="articleCard">
            <p>
              风雨过后，回望来路，那些曾经的坎坷、磨难、荣辱，都已归于平静。“也无风雨也无晴”，是苏轼对人生的终极彻悟：人生本无绝对的顺逆，外界的风雨晴暖，都无法影响内心的安宁与超然。
            </p>
            <p>
              这是一种超越了悲喜、宠辱不惊的人生境界，是苏轼一生颠沛流离却始终乐观的精神根源，也是中国传统文化中最高的人生智慧之一。
            </p>
          </div>
        </section>

        <section id="writer" class="articleSection">
          <h2>苏轼其人</h2>
          <div class="articleCard">
            <ul class="detailList">
              <li>北宋文豪，字子瞻，号东坡居士，世称“苏东坡”。</li>
              <li>宋代文学最高成就的代表，豪放词派开创者，“唐宋八大家”之一。</li>
              <li>诗、词、文、书、画无一不精，书法“宋四家”之首，文人画开创者。</li>
              <li>一生颠沛流离，却始终以旷达乐观面对人生，是中国文化史上的全能型天才。</li>
              <li>代表作：《念奴娇·赤壁怀古》《水调歌头·明月几时有》《赤壁赋》等。</li>
            </ul>
          </div>
        </section>

        <section id="extend" class="articleSection">
          <h2>拓展阅读</h2>
          <div class="articleCard">
            <div class="extendGrid">
              <div class="extendItem">
                <div class="extendTitle">念奴娇·赤壁怀古</div>
                <div class="extendText">豪放词的巅峰之作，怀古咏史，气势磅礴，千古绝唱。</div>
              </div>
              <div class="extendItem">
                <div class="extendTitle">水调歌头·明月几时有</div>
                <div class="extendText">中秋词的千古第一，写尽思念与旷达，“但愿人长久，千里共婵娟”家喻户晓。</div>
              </div>
              <div class="extendItem">
                <div class="extendTitle">赤壁赋</div>
                <div class="extendText">文辞优美，哲理深邃，将人生感悟融入山水之间，千古名篇。</div>
              </div>
              <div class="extendItem">
                <div class="extendTitle">江城子·乙卯正月二十日夜记梦</div>
                <div class="extendText">千古第一悼亡词，情感真挚，催人泪下，婉约词的巅峰之作。</div>
              </div>
            </div>
          </div>
        </section>
      </main>

      <aside class="sideCol">
        <div class="infoCard">
          <div class="infoBlock">
            <div class="infoTitle">作品信息</div>
            <div class="infoDesc">北宋·苏轼《定风波·莫听穿林打叶声》主题展示页</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">作者信息</div>
            <div class="infoDesc">苏轼，字子瞻，号东坡居士，北宋豪放词宗、文坛领袖</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">形式信息</div>
            <div class="infoDesc">古籍专题排版 · 图文分栏 · 典藏式阅读页面</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">出处信息</div>
            <div class="infoDesc">相关词集：《东坡乐府》《东坡七集》</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">意象主题</div>
            <div class="infoDesc">风雨、竹杖芒鞋、旷达、逆境、人生哲思</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">核心名句</div>
            <div class="infoDesc">一蓑烟雨任平生；也无风雨也无晴</div>
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
import s1 from "@/assets/banners/b4.gif"
import s2 from "@/assets/banners/b4左.gif"
import s3 from "@/assets/banners/b4右.gif"

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