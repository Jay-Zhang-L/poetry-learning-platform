<template>
  <div class="shugePage">
    <section class="heroSection">
      <div class="heroStage">
        <div class="heroPanels">
          <button class="heroPanel side left" type="button" @click="prevImage">
            <img :src="heroImages[leftIndex]" alt="上一张" />
          </button>

          <button class="heroPanel center" type="button" @click="openViewer(currentIndex)">
            <img :src="heroImages[currentIndex]" alt="滕王阁序主图" />
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
        <h1 class="title">滕王阁序并序</h1>
        <div class="metaLine">撰目 王勃 / 类目 骈文、古文、名楼题咏 / 2026年04月01日</div>

        <div class="introText">
          <p>
            《滕王阁序并序》是初唐文学家王勃最负盛名的骈文代表作，也是中国古代辞章艺术中极具标志性的一篇名作。它以滕王阁盛会为背景，以高华典丽的辞采，写山川形胜、宴集盛况、人生感慨与身世抱负，气势开阔，节奏飞动。
          </p>
          <p>
            文中既有“豫章故郡，洪都新府”的起笔铺陈，也有“落霞与孤鹜齐飞，秋水共长天一色”的千古名句，更有“老当益壮，宁移白首之心；穷且益坚，不坠青云之志”的精神力量。景、事、情、志相互交织，使全篇既华美又有骨力。
          </p>
          <p>
            本页延续你 b2 的版式结构，做成典藏专题式阅读页，把主图轮播、作品信息、正文节选、语义梳理、名句赏析和背景说明整合在一起，整体气质更适合《滕王阁序》这种大篇章内容。
          </p>
        </div>

        <div class="catalogCard">
          <div class="catalogHead">目录</div>
          <div class="catalogList">
            <a href="#text">原文节选</a>
            <a href="#translation">白话梳理</a>
            <a href="#background">写作背景</a>
            <a href="#analysis">名句赏析</a>
            <a href="#writer">王勃其人</a>
            <a href="#extend">拓展阅读</a>
          </div>
        </div>

        <div class="inlineImageCard">
          <img :src="heroImages[currentIndex]" alt="滕王阁序主题图" />
          <div class="inlineImageCap">《滕王阁序并序》主题展示图</div>
        </div>

        <section id="text" class="articleSection">
          <h2>原文节选</h2>
          <div class="articleCard poemText">
            豫章故郡，洪都新府。星分翼轸，地接衡庐。<br />
            襟三江而带五湖，控蛮荆而引瓯越。<br /><br />

            物华天宝，龙光射牛斗之墟；人杰地灵，徐孺下陈蕃之榻。<br />
            雄州雾列，俊采星驰。台隍枕夷夏之交，宾主尽东南之美。<br /><br />

            时维九月，序属三秋。潦水尽而寒潭清，烟光凝而暮山紫。<br />
            俨骖騑于上路，访风景于崇阿。<br />
            临帝子之长洲，得天人之旧馆。<br /><br />

            层峦耸翠，上出重霄；飞阁流丹，下临无地。<br />
            鹤汀凫渚，穷岛屿之萦回；桂殿兰宫，即冈峦之体势。<br /><br />

            落霞与孤鹜齐飞，秋水共长天一色。<br />
            渔舟唱晚，响穷彭蠡之滨；雁阵惊寒，声断衡阳之浦。<br /><br />

            老当益壮，宁移白首之心；穷且益坚，不坠青云之志。
          </div>
        </section>

        <section id="translation" class="articleSection">
          <h2>白话梳理</h2>
          <div class="articleCard splitCard">
            <div class="splitRow">
              <div class="splitTitle">豫章故郡，洪都新府</div>
              <div class="splitText">这里是豫章旧郡，如今称作洪州新府，先从地理形势开篇。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">襟三江而带五湖，控蛮荆而引瓯越</div>
              <div class="splitText">写出洪州地势宏阔，连接江湖，牵引四方，气象雄浑。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">物华天宝，人杰地灵</div>
              <div class="splitText">赞美此地珍宝丰饶、人物俊杰，既写自然，也写人文。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">时维九月，序属三秋</div>
              <div class="splitText">点明时令，正值深秋，秋气清肃，为后面写景做铺垫。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">层峦耸翠，飞阁流丹</div>
              <div class="splitText">山峦高耸，阁楼鲜明，写出滕王阁建筑与周围景色的立体层次。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">落霞与孤鹜齐飞，秋水共长天一色</div>
              <div class="splitText">晚霞、飞鸟、秋水、长天融为一体，形成极为开阔而空灵的画面。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">老当益壮，穷且益坚</div>
              <div class="splitText">即使身处困顿，也应坚持志向，不因处境艰难而放弃理想。</div>
            </div>
          </div>
        </section>

        <section id="background" class="articleSection">
          <h2>写作背景</h2>
          <div class="articleCard">
            <p>
              《滕王阁序》作于唐高宗上元二年，王勃赴交趾探亲，途经洪州，恰逢都督阎公在滕王阁大宴宾客，于是即席作序。相传王勃年少才高，当场挥笔成章，因此这篇文章也常被看作“才子文章”的典型代表。
            </p>
            <p>
              这篇文章并不只是单纯写楼。前半部分极写滕王阁所在地域之胜、宴会之盛、山水之美，后半部分则逐渐转入作者自身的身世感慨。文章由景入情，由情入志，最后落到士人困顿而不改其志的精神上，所以它不只是华丽，而是有内在力量。
            </p>
          </div>
        </section>

        <section id="analysis" class="articleSection">
          <h2>名句赏析</h2>
          <div class="quoteCard">
            <div class="quoteMain">落霞与孤鹜齐飞，秋水共长天一色。</div>
            <div class="quoteSub">这是《滕王阁序》中最广为流传的一联，也是中国古代写景名句中的高峰。</div>
          </div>

          <div class="articleCard">
            <p>
              这两句最强的地方，不只是画面美，而是空间一下被写开了。落霞在天边铺开，孤鹜从空中掠过，秋水与长天相接，视线从近处延伸到远处，整个天地被打通，读起来有一种极强的展开感。
            </p>
            <p>
              “齐飞”让画面有了动态，“一色”又把天地统一起来，于是动静结合，远近兼备。它不是细碎的景物描写，而是一种大开大合的视觉组织，所以一句就能撑起整篇文章最著名的审美高点。
            </p>
          </div>

          <div class="quoteCard" style="margin-top: 18px;">
            <div class="quoteMain">老当益壮，宁移白首之心；穷且益坚，不坠青云之志。</div>
            <div class="quoteSub">这一段使文章从写景转入写志，形成精神上的抬升。</div>
          </div>

          <div class="articleCard">
            <p>
              前面写景写宴，已经足够华丽；到了这里，文章真正立住了。王勃把个人遭际与士人理想放在一起表达，语气坚定，节奏有力，因此整篇文章不仅有辞采，还有骨气。
            </p>
          </div>
        </section>

        <section id="writer" class="articleSection">
          <h2>王勃其人</h2>
          <div class="articleCard">
            <ul class="detailList">
              <li>初唐四杰之一，年少成名，才气极盛。</li>
              <li>擅长骈文与诗歌，文章气势纵横，辞采华美。</li>
              <li>代表作包括《滕王阁序》《送杜少府之任蜀州》等。</li>
              <li>其文风对初唐文学由齐梁余风向盛唐气象转变具有重要意义。</li>
            </ul>
          </div>
        </section>

        <section id="extend" class="articleSection">
          <h2>拓展阅读</h2>
          <div class="articleCard">
            <div class="extendGrid">
              <div class="extendItem">
                <div class="extendTitle">送杜少府之任蜀州</div>
                <div class="extendText">“海内存知己，天涯若比邻”，是王勃最广为人知的名篇之一。</div>
              </div>
              <div class="extendItem">
                <div class="extendTitle">秋日登洪府滕王阁饯别序</div>
                <div class="extendText">可结合整篇背景再读，体会序文与宴集题材的关系。</div>
              </div>
              <div class="extendItem">
                <div class="extendTitle">初唐四杰作品选</div>
                <div class="extendText">可对比杨炯、卢照邻、骆宾王，感受初唐文风转变。</div>
              </div>
              <div class="extendItem">
                <div class="extendTitle">唐代名楼题咏</div>
                <div class="extendText">可与《黄鹤楼》《岳阳楼记》等同类名篇对照阅读。</div>
              </div>
            </div>
          </div>
        </section>
      </main>

      <aside class="sideCol">
        <div class="infoCard">
          <div class="infoBlock">
            <div class="infoTitle">作品信息</div>
            <div class="infoDesc">初唐·王勃《滕王阁序并序》专题展示页</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">作者信息</div>
            <div class="infoDesc">王勃，初唐四杰之一，少年才俊，骈文名家</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">形式信息</div>
            <div class="infoDesc">古籍专题排版 · 图文分栏 · 典藏式阅读页面</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">出处信息</div>
            <div class="infoDesc">唐代骈文名篇，滕王阁宴集即席而作</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">意象主题</div>
            <div class="infoDesc">高阁、秋水、长天、宴集、身世、志向</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">核心名句</div>
            <div class="infoDesc">落霞与孤鹜齐飞，秋水共长天一色</div>
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
import s1 from "@/assets/banners/b1.gif"
import s2 from "@/assets/banners/b1左.gif"
import s3 from "@/assets/banners/b1右.gif"

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