<template>
  <div class="shugePage">
    <section class="heroSection">
      <div class="heroStage">
        <div class="heroPanels">
          <button class="heroPanel side left" type="button" @click="prevImage">
            <img :src="heroImages[leftIndex]" alt="上一张" />
          </button>

          <button class="heroPanel center" type="button" @click="openViewer(currentIndex)">
            <img :src="heroImages[currentIndex]" alt="兰亭集序主图" />
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
        <h1 class="title">兰亭集序</h1>
        <div class="metaLine">撰目 王羲之 / 类目 古文、书法、艺术类 / 2026年04月01日</div>

        <div class="introText">
          <p>
            《兰亭集序》是东晋“书圣”王羲之的代表作，被誉为“天下第一行书”，兼具文学之美与书法之神。文章记叙了东晋永和九年，王羲之与谢安、孙绰等名士在会稽山阴兰亭修禊雅集的盛事，由宴游之乐引发对生命、时光的深刻哲思。
          </p>
          <p>
            书法上，其笔法精妙、章法自然、气韵生动，二十余个“之”字各有姿态，无一重复，尽显行书的灵动与潇洒；文学上，其文辞清丽、情感真挚，从乐到痛再到悲，层层递进，成为千古传诵的名篇。
          </p>
          <p>
            本页采用典藏专题式排版，把作品主图、题签信息、正文赏析和背景说明整合到同一页面里，让它更像一页可以细读、可以浏览细节、也可以继续延展的古籍主题展示页。
          </p>
        </div>

        <div class="catalogCard">
          <div class="catalogHead">目录</div>
          <div class="catalogList">
            <a href="#poem">全文原文</a>
            <a href="#translation">白话译文</a>
            <a href="#background">背景与情感</a>
            <a href="#analysis">名句赏析</a>
            <a href="#writer">王羲之其人</a>
            <a href="#extend">拓展阅读</a>
          </div>
        </div>

        <div class="inlineImageCard">
          <img :src="heroImages[currentIndex]" alt="兰亭集序主题图" />
          <div class="inlineImageCap">王国维书《兰亭集序》主题展示图</div>
        </div>

        <section id="poem" class="articleSection">
          <h2>全文原文</h2>
          <div class="articleCard poemText">
            永和九年，岁在癸丑，暮春之初，会于会稽山阴之兰亭，修禊事也。<br />
            群贤毕至，少长咸集。此地有崇山峻岭，茂林修竹；又有清流激湍，映带左右，<br />
            引以为流觞曲水，列坐其次。虽无丝竹管弦之盛，一觞一咏，亦足以畅叙幽情。<br />
            是日也，天朗气清，惠风和畅。仰观宇宙之大，俯察品类之盛，<br />
            所以游目骋怀，足以极视听之娱，信可乐也。<br /><br />
            夫人之相与，俯仰一世，或取诸怀抱，悟言一室之内；或因寄所托，放浪形骸之外。<br />
            虽趣舍万殊，静躁不同，当其欣于所遇，暂得于己，快然自足，不知老之将至；<br />
            及其所之既倦，情随事迁，感慨系之矣。向之所欣，俯仰之间，已为陈迹，<br />
            犹不能不以之兴怀。况修短随化，终期于尽。古人云：“死生亦大矣。”岂不痛哉！<br /><br />
            每览昔人兴感之由，若合一契，未尝不临文嗟悼，不能喻之于怀。<br />
            固知一死生为虚诞，齐彭殇为妄作。后之视今，亦犹今之视昔。<br />
            悲夫！故列叙时人，录其所述，虽世殊事异，所以兴怀，其致一也。<br />
            后之览者，亦将有感于斯文。
          </div>
        </section>

        <section id="translation" class="articleSection">
          <h2>白话译文</h2>
          <div class="articleCard splitCard">
            <div class="splitRow">
              <div class="splitTitle">永和九年，岁在癸丑，暮春之初，会于会稽山阴之兰亭，修禊事也</div>
              <div class="splitText">永和九年，是癸丑年，暮春三月初，我们在会稽郡山阴县的兰亭聚会，举行祓禊仪式。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">群贤毕至，少长咸集</div>
              <div class="splitText">众多贤才都汇聚于此，年长的和年少的都聚集在一起。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">此地有崇山峻岭，茂林修竹；又有清流激湍，映带左右</div>
              <div class="splitText">这里有高大险峻的山岭，茂盛的树林和修长的竹子；又有清澈湍急的溪流，辉映环绕在亭子的四周。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">引以为流觞曲水，列坐其次。虽无丝竹管弦之盛，一觞一咏，亦足以畅叙幽情</div>
              <div class="splitText">我们引溪水作为流觞的曲水，依次坐在曲水旁。虽然没有管弦齐奏的盛况，但一边饮酒一边赋诗，也足够畅快地抒发内心的幽情。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">是日也，天朗气清，惠风和畅。仰观宇宙之大，俯察品类之盛</div>
              <div class="splitText">这一天，天气晴朗，空气清新，和风温暖舒畅。抬头纵观广阔的天地，低头观察繁多的万物。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">夫人之相与，俯仰一世，或取诸怀抱，悟言一室之内；或因寄所托，放浪形骸之外</div>
              <div class="splitText">人与人相互交往，很快便度过一生。有的人在室内畅谈自己的胸怀抱负；有的人就着自己所爱好的事物，寄托情怀，放纵无羁地生活。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">固知一死生为虚诞，齐彭殇为妄作</div>
              <div class="splitText">本来就知道把生死等同的说法是不真实的，把长寿和短命等同起来的说法是妄造的。</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">后之视今，亦犹今之视昔。悲夫！</div>
              <div class="splitText">后人看待今人，也就像今人看待前人，可悲呀！</div>
            </div>
            <div class="splitRow">
              <div class="splitTitle">后之览者，亦将有感于斯文</div>
              <div class="splitText">后世的读者，也将对这次集会的诗文有所感慨。</div>
            </div>
          </div>
        </section>

        <section id="background" class="articleSection">
          <h2>背景与情感</h2>
          <div class="articleCard">
            <p>
              东晋永和九年（公元353年），王羲之时任会稽内史，邀请谢安、孙绰等四十一位名士，在山阴兰亭举行修禊活动。众人饮酒赋诗，汇为《兰亭集》，王羲之为之作序，即《兰亭集序》。
            </p>
            <p>
              文章前半部分极写宴游之乐，山水之美，群贤之雅；后半部分笔锋一转，由乐生痛，由痛生悲，抒发了对生命短暂、时光易逝的深沉感慨，批判了当时老庄“一死生、齐彭殇”的虚无思想，体现了魏晋文人对生命价值的觉醒与思考。
            </p>
            <p>
              全文情感起伏自然，从“信可乐也”到“岂不痛哉”再到“悲夫”，层层递进，将个人的生命体验上升为人类共通的情感，成为千古绝唱。
            </p>
          </div>
        </section>

        <section id="analysis" class="articleSection">
          <h2>名句赏析</h2>
          <div class="quoteCard">
            <div class="quoteMain">仰观宇宙之大，俯察品类之盛，所以游目骋怀，足以极视听之娱，信可乐也。</div>
            <div class="quoteSub">这一段是全文的“乐之极”，也是兰亭雅集的精神核心。</div>
          </div>

          <div class="articleCard">
            <p>
              “仰观”“俯察”二字，将人的视野从天地到万物完全打开，空间感极为开阔。“游目骋怀”则写出了精神的自由舒展，在山水之间，人的心灵与天地万物相融，达到了极致的审美愉悦。
            </p>
            <p>
              这句话不仅写出了兰亭的自然之美，更写出了魏晋名士的精神境界：在有限的生命里，通过对天地万物的观照，获得精神的无限自由，是中国文人“天人合一”思想的完美体现。
            </p>
          </div>

          <div class="quoteCard">
            <div class="quoteMain">固知一死生为虚诞，齐彭殇为妄作。</div>
            <div class="quoteSub">全文的思想转折点，是王羲之对生命态度的核心宣言。</div>
          </div>

          <div class="articleCard">
            <p>
              魏晋时期，老庄思想盛行，“一死生”“齐彭殇”是当时的主流思潮，认为生死、寿夭没有区别。王羲之却直言这种观点是“虚诞”“妄作”，直面生命的有限性，肯定生命的价值，体现了对生命的尊重与热爱。
            </p>
            <p>
              正是这种对生命的清醒认知，让《兰亭集序》超越了一般的宴游序文，成为具有深刻哲学内涵的千古名篇。
            </p>
          </div>
        </section>

        <section id="writer" class="articleSection">
          <h2>王羲之其人</h2>
          <div class="articleCard">
            <ul class="detailList">
              <li>东晋著名书法家，字逸少，号澹斋，世称“王右军”“书圣”。</li>
              <li>出身琅琊王氏，历任秘书郎、宁远将军、江州刺史，后为会稽内史。</li>
              <li>书法兼善隶、草、楷、行各体，博采众长，自成一家，影响深远。</li>
              <li>《兰亭集序》为其代表作，被誉为“天下第一行书”。</li>
              <li>与钟繇并称“钟王”，与其子王献之合称“二王”。</li>
            </ul>
          </div>
        </section>

        <section id="extend" class="articleSection">
          <h2>拓展阅读</h2>
          <div class="articleCard">
            <div class="extendGrid">
              <div class="extendItem">
                <div class="extendTitle">《快雪时晴帖》</div>
                <div class="extendText">王羲之行书代表作，仅28字，被乾隆誉为“天下无双，古今鲜对”。</div>
              </div>
              <div class="extendItem">
                <div class="extendTitle">《黄庭经》</div>
                <div class="extendText">王羲之小楷代表作，笔法精妙，气韵高古，为小楷典范。</div>
              </div>
              <div class="extendItem">
                <div class="extendTitle">《丧乱帖》</div>
                <div class="extendText">王羲之行草代表作，情感真挚，笔法跌宕，为唐摹本精品。</div>
              </div>
              <div class="extendItem">
                <div class="extendTitle">《兰亭集序》书法赏析</div>
                <div class="extendText">详解其笔法、章法、气韵，以及“二十个之字”的精妙变化。</div>
              </div>
            </div>
          </div>
        </section>
      </main>

      <aside class="sideCol">
        <div class="infoCard">
          <div class="infoBlock">
            <div class="infoTitle">作品信息</div>
            <div class="infoDesc">东晋·王羲之《兰亭集序》主题展示页</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">作者信息</div>
            <div class="infoDesc">王羲之，字逸少，东晋“书圣”，行书集大成者</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">形式信息</div>
            <div class="infoDesc">古籍专题排版 · 图文分栏 · 典藏式阅读页面</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">出处信息</div>
            <div class="infoDesc">相关文集：《王羲之集》，书法名帖：《兰亭序》</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">意象主题</div>
            <div class="infoDesc">兰亭雅集、山水、生命、哲思、书法</div>
          </div>

          <div class="infoBlock">
            <div class="infoTitle">核心名句</div>
            <div class="infoDesc">仰观宇宙之大，俯察品类之盛；后之视今，亦犹今之视昔</div>
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
import s1 from "@/assets/banners/b3.gif"
import s2 from "@/assets/banners/b3左.gif"
import s3 from "@/assets/banners/b3右.gif"

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