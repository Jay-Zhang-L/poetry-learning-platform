<template>
<div
  class="app"
  :class="{ 'app-has-hua': showPortal && currentBackground === 'portal_01.png' }"
  :style="{ backgroundImage: currentBackground ? `url(${getBackgroundImageUrl(currentBackground)})` : '' }"
>
   <div class="hua-background" v-if="showPortal && currentBackground === 'portal_01.png'"></div>
<!-- 歌：右上角花枝 -->
<div class="hua2-right" v-if="showPortal && currentBackground === 'portal_02.png'"></div>

<!-- 歌：右侧燕子 -->
<div class="yanzi-right" v-if="showPortal && currentBackground === 'portal_02.png'"></div>
<!-- 词：左上角伸出来的花鸟 -->
<div class="bird2-left" v-if="showPortal && currentBackground === 'portal_04.png'"></div>



<!-- 现：右上偏左偏下的鹤 -->
<div class="he-right-top" v-if="showPortal && currentBackground === 'portal_06.png'"></div>
<!-- 曲：左上角飞鸟 -->
<div class="bird3-left-top" v-if="showPortal && currentBackground === 'portal_05.png'"></div>
    <div class="load" v-show="showLoad">
      <div class="tableCell">
        <h2 class="c">相逢笔墨山河里，共赏千年诗韵长</h2>
        <div class="progress"><span></span></div>
      </div>
    </div>

    <div class="portal" v-show="showPortal">
      <div class="partyPart">
        <img src="./assets/images/navigation/portal_partyBakCur.png" width="100%">
        <div class="PartConIcon">
          <div v-for="(item, index) in portalItems" :key="index"
            :class="['Part' + String(index + 1).padStart(2, '0'), 'PartIcon', { 'collect': hoverIndex === index || selectedIndex === index }]"
            @click="handleIconClick(index)" @mouseenter="handleMouseEnter(index)" @mouseleave="handleMouseLeave">
            <img :src="getHeaderImageUrl(index)" class="header-img">
          </div>
        </div>
      </div>
      <div class="other">
        <p><span class="share"></span></p>
      </div>
    </div>

    <div class="partyPartContent" v-show="!showPortal">
      <!-- 儿童主题页面 -->
      <div class="series Cool01 ertongPC" v-show="currentTheme === 'ertong'">
        <div class="ContentBg01">
          <div class="group01">
            <div data-img="28-origin.jpg" class="introduceFloat"></div>
            <div class="content group01_text">
              <div class="text choose01">
                <p>Art in the Song Dynasty contributed a significant genre portraying playful children at a time of
                  unprecedented baby booms made possible by economic and cultural prosperity across the Northern and
                  Southern Song periods. </p>
                <p>The simplicity of kids playing around, parental care for sons and daughters, and society's value of
                  offsprings as carriers of bloodlines and fortune can be seen or felt in classics like <i>Children at
                    Play on a Winter’s Day</i> by the imperial academy artist Su Hanchen.</p>
              </div>
            </div>
            <div class="group01_bg01">
              <img src="../assets/images/animations/Bottomplan.gif" data-echo="../assets/style/img/ertong/meihua.gif">
            </div>
            <div class="group01_bg02">
              <img class="group01_bg02_dryxt" src="../assets/images/animations/Bottomplan.gif"
                data-echo="../assets/style/img/ertong/dryxt.gif">
              <div class="group01_bg02_Text">
                <div class="text choose02">
                  <h2>Cats</h2>
                  <p>Household affection for cats is visible from Song’s “children at play” paintings in which the plump
                    pets pose playfully along with their young lords. Cats were often adopted as new family members with
                    gifts for their previous owners in exchange.</p>
                </div>
                <img class="faceHover" src="./assets/images/animations/Bottomplan.gif"
                  data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/ertong/group01_img02_hover.png">
              </div>
              <div class="cats Seeking02"><span></span><span></span><span></span></div>
              <a class="imgLeft"></a>
              <a class="imgRight"></a>
              <div class="imgBgHover01 choose03">
                <p>Adoring eyes on their frolicking company, the girl, in a white cross-collar gown and hair tied up in
                  three knots, has a colorful banner rod in arm. </p>
              </div>
              <div class="imgBgHover02 choose04">
                <p>The boy, in a light brown short gown and calico pants, hair braided into tresses, holds a stringed
                  peacock feather.</p>
              </div>
            </div>
          </div>

          <div class="group02">
            <div class="content group02_text">
              <div class="text ">
                <p>Besides pet cats, Song juniors weren’t short of toy options, either. Records identified the Chinese
                  word for “toy” to be originated right in this dynasty when a toy market culminated and matured. Such
                  toy stories were documented in <i>Children at Play in an Autumn Garden</i>, also painted by Su
                  Hanchen.</p>
                <p class="choose05"></p>
              </div>
            </div>
            <div class="group02_bg01">
              <img class="imgBg" src="./assets/images/animations/Bottomplan.gif"
                data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/ertong/group02_img03.gif">
              <a class="imgLeft"></a>
              <a class="imgRight"></a>
              <div class="imgBgHover01">
                <p class="choose06">The boy has a red shirt and white pants on, both with gold patterning prints. His
                  hair is shaved to leave only a tuft at the front, a popular style children at the time would sport.
                </p>
                <img class="" src="./assets/images/animations/Bottomplan.gif"
                  data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/ertong/group02_img03_hover01.png">
              </div>
              <div class="imgBgHover02 ">
                <p class="choose07">The girl wears a set of white calico gown and pants printed with floral patterns.
                  Her hair is tied in a pair of knots with blue and red ribbons, also accessorized with jade hairpins
                  and pearl ornaments.</p>
                <img class="" src="./assets/images/animations/Bottomplan.gif"
                  data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/ertong/group02_img03_hover02.png">
              </div>
            </div>
            <div class="group02_bg02" id="scrollbar1">
              <div class="scrollbar">
                <div class="track">
                  <div class="thumb">
                    <div class="end"></div>
                  </div>
                </div>
              </div>
              <div class="viewport">
                <div class="overview textImg Imgscrollbar choose11">
                </div>
              </div>
            </div>
            <div class="group02_bg04">
              <div class="textImg"><img class="imgBg" src="./assets/images/animations/Bottomplan.gif"
                  data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/ertong/group02_img04.png">
              </div>
            </div>
          </div>
        </div>
        <div class="ContentBg02">
          <img class="ContentBg02Bg" src="./assets/images/animations/Bottomplan.gif"
            data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/ertong/partContent01_groupBg02.png">
          <div class="group08">
            <div data-img="29-origin.jpg" class="introduceFloat"></div>
            <div class="group08_bg03">
              <model-viewer id="reveal" class="modelViewer" camera-controls="" auto-rotate="" shadow-softness="0"
                background-color="transparent" poster="style/img/ertong/group02_gif.png" autoplay=""
                animation-name="Running" ar="" shadow-intensity="0.5" camera-orbit="330deg 75deg auto"
                field-of-view="50deg" exposure="0.9" disable-zoom="" src="JSanim3D/Turntable.glb" alt="人马转盘"
                min-camera-orbit="auto 50deg auto" max-camera-orbit="auto 84deg auto"
                ar-status="not-presenting"></model-viewer>
            </div>
            <div class="group08_bg04">
              <a class="img01"></a>
              <a class="img02"></a>
              <a class="img03"></a>
              <a class="img04"></a>
              <a class="img05"></a>
              <a class="img06"></a>
              <div class="imgBgHover choose08">
              </div>
            </div>
            <div class="group08_bg05">
              <div class="textImg"><img class="imgBg" src="./assets/images/animations/Bottomplan.gif"
                  data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/ertong/group02_img05.png">
              </div>
            </div>
            <div class="group08_bg06">
              <div class="textImg"><img class="imgBg" src="./assets/images/animations/Bottomplan.gif"
                  data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/ertong/group02_img02.png">
              </div>
            </div>
          </div>

          <div class="group03">
            <div class="group03_bg01">
              <img class="imgBgHover01 heyeScrollMagic" src="../assets/images/animations/Bottomplan.gif"
                data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/ertong/group03_img01_hover01.png">
              <img class="imgBg" src="../assets/images/animations/Bottomplan.gif"
                data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/ertong/group03_img01.png">
            </div>
            <div class="group03_bg02">
              <img class="imgBg" src="../assets/images/animations/Bottomplan.gif"
                data-echo="../assets/style/img/ertong/htyxt.gif">
              <div class="group03_bg02_text01 ">
                <p class="choose09">Caring for juniors from newborn to adolescence had never been more established
                  culturally and scientifically. In this left detail of <i>Women and Children by a Lotus Pond</i>, a
                  moon-shaped fan painting, a young mother has a hand tenderly on her beloved baby.</p>
                <div data-img="68-origin.jpg" class="introduceFloat introduceFloat02"></div>
              </div>
              <div class="group03_text choose10">
                <p>Protective love for kids in Song social life can also be witnessed in genre paintings that offer an
                  insight into their outfit and ornament.</p>
              </div>
              <div class="group03_bg02_text02">
                <div data-img="105-origin.jpg" class="introduceFloat introduceFloat02"></div>
                <img class="text02imgBg" src="./assets/images/animations/Bottomplan.gif"
                  data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/ertong/group03_img03.png">
                <div class="group03_bg02_roll" id="scrollbar2">
                  <div class="scrollbar">
                    <div class="track">
                      <div class="thumb">
                        <div class="end"></div>
                      </div>
                    </div>
                  </div>
                  <div class="viewport">
                    <div class="overview textImg choose12"></div>
                  </div>
                </div>
              </div>
            </div>
            <div class="group03_bg03">
              <div data-img="32-origin.jpg" class="introduceFloat introduceFloat02"></div>
              <div class="bg03_text" id="scrollbar3">
                <div class="scrollbar">
                  <div class="track">
                    <div class="thumb">
                      <div class="end"></div>
                    </div>
                  </div>
                </div>
                <div class="viewport">
                  <div class="overview textImg choose13"></div>
                </div>
              </div>
              <div class="imgBg">
                <img class="imgBg" src="../assets/images/animations/Bottomplan.gif"
                  data-echo="../assets/style/img/ertong/chuangta.gif">
              </div>
            </div>
          </div>

          <div class="ContentBg02_bottom">
            <img class="hulanScrollMagic" src="../assets/images/animations/Bottomplan.gif"
              data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/ertong/group03_img05.png">
          </div>
        </div>
        <div class="ContentBg02_lion">
          <div class="wushiImg"><img class="lionScrollMagic" src="../assets/images/animations/Bottomplan.gif"
              data-echo="../assets/images/shiwu/shiwu0001.png"></div>
        </div>
        <div class="content group04">
          <h2 class="choose14"><span class="go01">Pure</span><span class="go02">Serene</span><span
              class="go02">Music:</span><span class="go01">Hillside</span><span class="go01">Garden</span>
            <p class="nameEn"><span class="go01">— Song</span><span class="go02">poet</span><span
                class="go02">Xin</span><span class="go01">Qiji</span></p>
          </h2>
          <h3 class="choose15"><span class="go02">The</span><span class="go02">west</span><span
              class="go02">wind</span><span class="go05">ripens</span><span class="go04">pears</span><span
              class="go04">and</span><span class="go03">dates</span><span class="go03">in</span><span
              class="go02">hillside</span><span class="go05">land:</span><br /><span class="go04">Children</span><span
              class="go03">come</span><span class="go05">stealthily,</span><span class="go03">long</span><span
              class="go02">pole</span><span class="go04">in</span><span class="go03">hand.</span><br /><span
              class="go05">Do</span><span class="go02">not</span><span class="go02">scare</span><span
              class="go04">them</span><span class="go02">out</span><span class="go03">of</span><span
              class="go03">their</span><span class="go04">pleasure!</span><br /><span class="go04">I</span><span
              class="go04">will</span><span class="go03">sit</span><span class="go02">quietly</span><span
              class="go04">at</span><span class="go04">leisure.</span></h3>
          <div class="group04_text">
            <p class="choose16"></p>
            <img src="./assets/images/animations/Bottomplan.gif"
              data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/ertong/group04_img01.png">
          </div>
        </div>
        <div class="publicGroup">
          <div class="groupVideo">
            <h2 class="publicGrouptH1"></h2>
            <div class="videoPlayList" id="videoPlayList01">
              <ul class="">
                <li style="display: block;" data-img="1-zh.jpg">
                  <div class="videoPlay"><img src="../assets/images/animations/Bottomplan.gif"
                      data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/dzc_output_painting/1-zh.jpg"></div>
                  <span class="videoIcon"></span>
                </li>
                <li data-img="7-zh.jpg">
                  <div class="videoPlay"><img src="../assets/images/animations/Bottomplan.gif"
                      data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/dzc_output_painting/7-zh.jpg"></div>
                  <span class="videoIcon"></span>
                </li>
                <li data-img="9-zh.jpg">
                  <div class="videoPlay"><img src="../assets/images/animations/Bottomplan.gif"
                      data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/dzc_output_painting/9-zh.jpg"></div>
                  <span class="videoIcon"></span>
                </li>
              </ul>
              <div class="pageList"><i class="left_btn"></i><span class="radius_btn"><i class="cur"></i><i
                    class=""></i><i class=""></i></span><i class="right_btn"></i></div>
            </div>
            <div class="more publicGrouptMore1"></div>
          </div>
          <div class="groupImage">
            <h2 class="publicGrouptH2"></h2>
            <div class="imageList">
              <div class="tab">
                <div class="img" data-img="31-origin.jpg"><img src="../assets/images/animations/Bottomplan.gif"
                    data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/images_gallery/childhood-PC01-31.jpg">
                </div>
                <div class="imgMany">
                  <ul>
                    <li class="wide" data-img="11-origin.jpg"><img src="../assets/images/animations/Bottomplan.gif"
                        data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/images_gallery/childhood-PC02-11.jpg">
                    </li>
                    <li class="nar" data-img="30-origin.jpg"><img src="../assets/images/animations/Bottomplan.gif"
                        data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/images_gallery/childhood-PC03-30.jpg">
                    </li>
                  </ul>
                  <ul>
                    <li class="nar" data-img="32-origin.jpg"><img src="../assets/images/animations/Bottomplan.gif"
                        data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/images_gallery/childhood-PC04-32.jpg">
                    </li>
                    <li class="wide" data-img="94-origin.jpg"><img src="../assets/images/animations/Bottomplan.gif"
                        data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/images_gallery/childhood-PC05-94.jpg">
                    </li>
                  </ul>
                </div>
                <div class="img" data-img="105-origin.jpg"><img src="../assets/images/animations/Bottomplan.gif"
                    data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/images_gallery/childhood-PC06-105.jpg">
                </div>
              </div>
            </div>
            <div class="btn">
              <a href="javascript:;" class="leftbtn"></a>
              <a href="javascript:;" class="rightbtn"></a>
            </div>
            <div class="more"><a target="_blank"
                href="https://news.cgtn.com/event/2022/The-Song-Painted/gallery/index.html"
                class="publicGrouptMore2">More ...</a></div>
          </div>
          <div class="groupWe">
            <div class="imgBg">
              <div class="imgBg01">
                <div class="imgBg02">
                  <p class="text01 copyright01"></p>
                  <p class="text02 copyright02"></p>
                </div>
              </div>
            </div>
          </div>
          <div class="footer_bdCon">
            <p>Copyright 2022 CGTN. Beijing ICP prepared NO.16065310-3</p>
          </div>
        </div>
      </div>

      <!-- 市井主题页面 -->
      <div class="series Cool02 shjingPC" v-show="currentTheme === 'shijing'">
        <div class="shijingbox1">
          <div class="sticky">
            <div class="shijingContentBg01">
              <div class="group01">
                <div class="shinvtu"><img src="../assets/images/animations/Bottomplan.gif"
                    data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shijing/shijing_shinvquan.gif"
                    alt=""></div>
                <div class="quan"><img src="../assets/images/animations/Bottomplan.gif"
                    data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shijing/shijing_hongquan.png"
                    alt="">
                  <div class="yun"><img src="../assets/images/animations/Bottomplan.gif"
                      data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shijing/shijing_yun.png"
                      alt=""></div>
                </div>
                <div class="tit choose01"></div>
                <div class="brief choose02"></div>
              </div>
            </div>
            <div class="shijingContentBg02">
              <!-- 市井主题内容 -->
            </div>
          </div>
        </div>
      </div>

      <!-- 艺人主题页面 -->
      <div class="series Cool03 yirenPC" v-show="currentTheme === 'yiren'">
        <!-- 艺人主题内容 -->
      </div>

      <!-- 仕女主题页面 -->
      <div class="series Cool04 shinvPC" v-show="currentTheme === 'shinv'">
        <div class="ContentBg01">
          <div class="group01">
            <div data-img="72-origin.jpg" class="introduceFloat"></div>
            <div class="content group01_text">
              <div class="text choose01">
                <p>The Song Dynasty (960-1279) was a golden age for women's fashion, with a rich variety of styles and
                  accessories that reflected the era's prosperity and cultural sophistication. </p>
                <p>From the elegant silk robes of noble ladies to the practical yet stylish outfits of common women,
                  Song fashion embodied both beauty and functionality. The period's art, especially paintings, provides
                  a vivid window into the sartorial tastes of the time.</p>
              </div>
            </div>
            <div class="group01_bg01">
              <img src="../assets/images/animations/Bottomplan.gif"
                data-echo="../assets/style/img/shinvImg/shinv_bg.gif">
            </div>
            <div class="group01_bg02">
              <img class="group01_bg02_dryxt" src="../assets/images/animations/Bottomplan.gif"
                data-echo="../assets/style/img/shinvImg/shinv_fashion.gif">
              <div class="group01_bg02_Text">
                <div class="text choose02">
                  <h2>Hairstyles</h2>
                  <p>Song women's hairstyles were elaborate and varied, often adorned with hairpins, combs, and flowers.
                    The "cloud bun" (yunji) and "phoenix crown" (fenghuangguan) were particularly popular among
                    noblewomen.</p>
                </div>
                <img class="faceHover" src="./assets/images/animations/Bottomplan.gif"
                  data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shinvImg/group01_img02_hover.png">
              </div>
              <div class="shinv Seeking02"><span></span><span></span><span></span></div>
              <a class="imgLeft"></a>
              <a class="imgRight"></a>
              <div class="imgBgHover01 choose03">
                <p>The lady wears a long, flowing silk robe with wide sleeves, a typical style of the Song Dynasty. Her
                  hair is styled in an elaborate bun adorned with jade hairpins.</p>
              </div>
              <div class="imgBgHover02 choose04">
                <p>The young woman's outfit features a high-waisted skirt and a cross-collar top, a common combination
                  for women of all social classes during the Song period.</p>
              </div>
            </div>
          </div>

          <div class="group02">
            <div class="content group02_text">
              <div class="text ">
                <p>Accessories played a crucial role in Song women's fashion, with jade, gold, and silver ornaments
                  being highly prized. Fans, purses, and embroidered handkerchiefs were also essential items.</p>
                <p class="choose05"></p>
              </div>
            </div>
            <div class="group02_bg01">
              <img class="imgBg" src="./assets/images/animations/Bottomplan.gif"
                data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shinvImg/group02_img03.gif">
              <a class="imgLeft"></a>
              <a class="imgRight"></a>
              <div class="imgBgHover01">
                <p class="choose06">The lady's headdress is a masterpiece of Song craftsmanship, featuring pearls, jade,
                  and gold filigree work.</p>
                <img class="" src="./assets/images/animations/Bottomplan.gif"
                  data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shinvImg/group02_img03_hover01.png">
              </div>
              <div class="imgBgHover02 ">
                <p class="choose07">The fan in her hand is made of silk with delicate floral patterns, a common
                  accessory for women during the Song Dynasty.</p>
                <img class="" src="./assets/images/animations/Bottomplan.gif"
                  data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shinvImg/group02_img03_hover02.png">
              </div>
            </div>
            <div class="group02_bg02" id="scrollbar1">
              <div class="scrollbar">
                <div class="track">
                  <div class="thumb">
                    <div class="end"></div>
                  </div>
                </div>
              </div>
              <div class="viewport">
                <div class="overview textImg Imgscrollbar choose11">
                </div>
              </div>
            </div>
            <div class="group02_bg04">
              <div class="textImg"><img class="imgBg" src="./assets/images/animations/Bottomplan.gif"
                  data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shinvImg/group02_img04.png">
              </div>
            </div>
          </div>
        </div>
        <div class="ContentBg02">
          <img class="ContentBg02Bg" src="./assets/images/animations/Bottomplan.gif"
            data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shinvImg/partContent01_groupBg02.png">
          <div class="group08">
            <div data-img="71-origin.jpg" class="introduceFloat"></div>
            <div class="group08_bg03">
              <img class="imgBg" src="./assets/images/animations/Bottomplan.gif"
                data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shinvImg/shinv_3dmodel.gif">
            </div>
            <div class="group08_bg04">
              <a class="img01"></a>
              <a class="img02"></a>
              <a class="img03"></a>
              <a class="img04"></a>
              <a class="img05"></a>
              <a class="img06"></a>
              <div class="imgBgHover choose08">
              </div>
            </div>
            <div class="group08_bg05">
              <div class="textImg"><img class="imgBg" src="./assets/images/animations/Bottomplan.gif"
                  data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shinvImg/group02_img05.png">
              </div>
            </div>
            <div class="group08_bg06">
              <div class="textImg"><img class="imgBg" src="./assets/images/animations/Bottomplan.gif"
                  data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shinvImg/group02_img02.png">
              </div>
            </div>
          </div>

          <div class="group03">
            <div class="group03_bg01">
              <img class="imgBgHover01 heyeScrollMagic" src="../assets/images/animations/Bottomplan.gif"
                data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shinvImg/group03_img01_hover01.png">
              <img class="imgBg" src="../assets/images/animations/Bottomplan.gif"
                data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shinvImg/group03_img01.png">
            </div>
            <div class="group03_bg02">
              <img class="imgBg" src="../assets/images/animations/Bottomplan.gif"
                data-echo="../assets/style/img/shinvImg/shinv_fashion2.gif">
              <div class="group03_bg02_text01 ">
                <p class="choose09">Song Dynasty paintings often depict women engaged in daily activities, providing
                  valuable insights into their clothing and lifestyle. This detail from a scroll painting shows a group
                  of women preparing for a festival.</p>
                <div data-img="45-origin.jpg" class="introduceFloat introduceFloat02"></div>
              </div>
              <div class="group03_text choose10">
                <p>Color played an important role in Song women's fashion, with red, blue, and green being particularly
                  popular. The use of natural dyes created subtle, elegant hues that complemented the wearer's
                  complexion.</p>
              </div>
              <div class="group03_bg02_text02">
                <div data-img="12-origin.jpg" class="introduceFloat introduceFloat02"></div>
                <img class="text02imgBg" src="./assets/images/animations/Bottomplan.gif"
                  data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shinvImg/group03_img03.png">
                <div class="group03_bg02_roll" id="scrollbar2">
                  <div class="scrollbar">
                    <div class="track">
                      <div class="thumb">
                        <div class="end"></div>
                      </div>
                    </div>
                  </div>
                  <div class="viewport">
                    <div class="overview textImg choose12"></div>
                  </div>
                </div>
              </div>
            </div>
            <div class="group03_bg03">
              <div data-img="83-origin.jpg" class="introduceFloat introduceFloat02"></div>
              <div class="bg03_text" id="scrollbar3">
                <div class="scrollbar">
                  <div class="track">
                    <div class="thumb">
                      <div class="end"></div>
                    </div>
                  </div>
                </div>
                <div class="viewport">
                  <div class="overview textImg choose13"></div>
                </div>
              </div>
              <div class="imgBg">
                <img class="imgBg" src="../assets/images/animations/Bottomplan.gif"
                  data-echo="../assets/style/img/shinvImg/shinv_accessories.gif">
              </div>
            </div>
          </div>

          <div class="ContentBg02_bottom">
            <img class="hulanScrollMagic" src="./assets/images/animations/Bottomplan.gif"
              data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shinvImg/group03_img05.png">
          </div>
        </div>
        <div class="content group04">
          <h2 class="choose14"><span class="go01">Elegant</span><span class="go02">Beauty:</span><span
              class="go01">Song</span><span class="go01">Women's</span><span class="go02">Fashion</span>
            <p class="nameEn"><span class="go01">— Song</span><span class="go02">poet</span><span
                class="go02">Li</span><span class="go01">Qingzhao</span></p>
          </h2>
          <h3 class="choose15"><span class="go02">Silk</span><span class="go02">robes</span><span
              class="go05">flow</span><span class="go04">like</span><span class="go04">clouds,</span><span
              class="go03">jade</span><span class="go03">ornaments</span><span class="go02">shine</span><span
              class="go05">bright:</span><br /><span class="go04">Song</span><span class="go03">women's</span><span
              class="go05">beauty</span><span class="go02">is</span><span class="go03">timeless,</span><span
              class="go04">a</span><span class="go03">vision</span><span class="go02">of</span><span
              class="go03">grace.</span><br /><span class="go05">Through</span><span class="go02">paintings</span><span
              class="go02">and</span><span class="go04">poetry,</span><span class="go03">we</span><span
              class="go02">still</span><span class="go03">admire</span><span class="go04">their</span><span
              class="go02">style</span><span class="go03">today.</span></h3>
          <div class="group04_text">
            <p class="choose16"></p>
            <img src="./assets/images/animations/Bottomplan.gif"
              data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/style/img/shinvImg/group04_img01.png">
          </div>
        </div>
        <div class="publicGroup">
          <div class="groupVideo">
            <h2 class="publicGrouptH1"></h2>
            <div class="videoPlayList" id="videoPlayList01">
              <ul class="">
                <li style="display: block;" data-img="10-zh.jpg">
                  <div class="videoPlay"><img src="../assets/images/animations/Bottomplan.gif"
                      data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/dzc_output_painting/10-zh.jpg"></div>
                  <span class="videoIcon"></span>
                </li>
                <li data-img="11-zh.jpg">
                  <div class="videoPlay"><img src="../assets/images/animations/Bottomplan.gif"
                      data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/dzc_output_painting/11-zh.jpg"></div>
                  <span class="videoIcon"></span>
                </li>
                <li data-img="12-zh.jpg">
                  <div class="videoPlay"><img src="../assets/images/animations/Bottomplan.gif"
                      data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/dzc_output_painting/12-zh.jpg"></div>
                  <span class="videoIcon"></span>
                </li>
              </ul>
              <div class="pageList"><i class="left_btn"></i><span class="radius_btn"><i class="cur"></i><i
                    class=""></i><i class=""></i></span><i class="right_btn"></i></div>
            </div>
            <div class="more publicGrouptMore1"></div>
          </div>
          <div class="groupImage">
            <h2 class="publicGrouptH2"></h2>
            <div class="imageList">
              <div class="tab">
                <div class="img" data-img="72-origin.jpg"><img src="../assets/images/animations/Bottomplan.gif"
                    data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/images_gallery/vogue-PC01-72.jpg">
                </div>
                <div class="imgMany">
                  <ul>
                    <li class="wide" data-img="71-origin.jpg"><img src="../assets/images/animations/Bottomplan.gif"
                        data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/images_gallery/vogue-PC02-71.jpg">
                    </li>
                    <li class="nar" data-img="45-origin.jpg"><img src="../assets/images/animations/Bottomplan.gif"
                        data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/images_gallery/vogue-PC03-45.jpg">
                    </li>
                  </ul>
                  <ul>
                    <li class="nar" data-img="12-origin.jpg"><img src="../assets/images/animations/Bottomplan.gif"
                        data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/images_gallery/vogue-PC04-12.jpg">
                    </li>
                    <li class="wide" data-img="83-origin.jpg"><img src="../assets/images/animations/Bottomplan.gif"
                        data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/images_gallery/vogue-PC05-83.jpg">
                    </li>
                  </ul>
                </div>
                <div class="img" data-img="22-origin.jpg"><img src="../assets/images/animations/Bottomplan.gif"
                    data-echo="https://news.cgtn.com/event/2022/The-Song-Painted/images_gallery/vogue-PC06-22.jpg">
                </div>
              </div>
            </div>
            <div class="btn">
              <a href="javascript:;" class="leftbtn"></a>
              <a href="javascript:;" class="rightbtn"></a>
            </div>
            <div class="more"><a target="_blank"
                href="https://news.cgtn.com/event/2022/The-Song-Painted/gallery/index.html"
                class="publicGrouptMore2">More ...</a></div>
          </div>
          <div class="groupWe">
            <div class="imgBg">
              <div class="imgBg01">
                <div class="imgBg02">
                  <p class="text01 copyright01"></p>
                  <p class="text02 copyright02"></p>
                </div>
              </div>
            </div>
          </div>
          <div class="footer_bdCon">
            <p>Copyright 2022 CGTN. Beijing ICP prepared NO.16065310-3</p>
          </div>
        </div>
      </div>

      <!-- 文人主题页面 -->
      <div class="series Cool05 wenrenPC" v-show="currentTheme === 'wenren'">
        <!-- 文人主题内容 -->
      </div>

      <!-- 神仙主题页面 -->
      <div class="series Cool06 shenxianPC" v-show="currentTheme === 'shenxian'">
        <!-- 神仙主题内容 -->
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'TheSongPainted',
  data() {
    return {
      showLoad: !sessionStorage.getItem('skipLoadAnimation'),
      showPortal: sessionStorage.getItem('skipLoadAnimation') || false,
      hoverIndex: -1,
      selectedIndex: -1,
      currentTheme: '',
      currentBackground: sessionStorage.getItem('skipLoadAnimation') ? 'portal_01.png' : '',

      // ✅ 新增：飞鸟数据
      birds: [],

      portalItems: [
        { key: 'ertong', name: 'Children', background: 'portal_01.png' },
        { key: 'shijing', name: 'Market', background: 'portal_02.png' },
        { key: 'yiren', name: 'Stage', background: 'portal_03.png' }, // ← 赋
        { key: 'shinv', name: 'Style', background: 'portal_04.png' },
        { key: 'wenren', name: 'Class', background: 'portal_05.png' },
        { key: 'shenxian', name: 'Faith', background: 'portal_06.png' }
      ]
    }
  },

  mounted() {
    this.originalFontSize = document.documentElement.style.fontSize;
    this.setBaseFontSize();
    this.checkUrlParam();
    this.initLoadAnimation();

    // ✅ 初始化生成一次（避免第一次空白）
    this.generateBirds();

    window.addEventListener('resize', this.setBaseFontSize);
    window.addEventListener('popstate', this.handlePopState);
  },

  beforeUnmount() {
    document.documentElement.style.fontSize = this.originalFontSize;
    window.removeEventListener('resize', this.setBaseFontSize);
    window.removeEventListener('popstate', this.handlePopState);
  },

  methods: {
    getHeaderImageUrl(index) {
      const imageName = `portal_header${String(index + 1).padStart(2, '0')}.png`;
      return new URL(`../assets/images/navigation/${imageName}`, import.meta.url).href;
    },

    getBackgroundImageUrl(backgroundName) {
      return new URL(`../assets/images/navigation/${backgroundName}`, import.meta.url).href;
    },

    // ✅ 鼠标移入：切背景 + 赋时刷新飞鸟
    handleMouseEnter(index) {
      this.hoverIndex = index;
      this.currentBackground = this.portalItems[index].background;

      // 只有赋（portal_03）生成飞鸟
      if (this.currentBackground === 'portal_03.png') {
        this.generateBirds();
      }
    },

    handleMouseLeave() {
      this.hoverIndex = -1;
      this.currentBackground = this.portalItems[0].background;
    },

    setBaseFontSize() {
      const deviceWidth = document.documentElement.clientWidth;
      const documentFontSize = deviceWidth / 28.80 + 'px';
      document.documentElement.style.fontSize = documentFontSize;
    },

    checkUrlParam() {
      const urlParams = new URLSearchParams(window.location.search);
      const numParam = urlParams.get('num');
      if (numParam) {
        const index = parseInt(numParam) - 1;
        if (index >= 0 && index < this.portalItems.length) {
          this.handleIconClick(index);
        }
      }
    },

    initLoadAnimation() {
      setTimeout(() => {
        this.showLoad = false;
        this.showPortal = true;
        this.currentBackground = this.portalItems[0].background;
        sessionStorage.setItem('skipLoadAnimation', 'true');
      }, 2500);
    },

    handleIconClick(index) {
      console.log(`点击主题按钮 ${index + 1}: ${this.portalItems[index].name}`);

      this.selectedIndex = index;

      const themePaths = [
        '/home/page4/shi',
        '/home/page4/ge',
        '/home/page4/fu',
        '/home/page4/ci',
        '/home/page4/qu',
        '/home/page4/xiandaishi'
      ];

      this.$router.push(themePaths[index]);
    },

    handlePopState() {
      this.showPortal = true;
      this.currentTheme = '';
      this.selectedIndex = -1;
      this.showLoad = false;
      this.currentBackground = this.portalItems[0].background;
    },

    updateURLParameter(key, value, replace) {
      const url = new URL(window.location.href);
      url.searchParams.set(key, value);
      const newUrl = url.toString();
      if (replace) {
        window.history.replaceState({ path: newUrl }, '', newUrl);
      } else {
        window.history.pushState({ path: newUrl }, '', newUrl);
      }
    },

    // ✅ 工具：随机数
    randomBetween(min, max) {
      return Math.random() * (max - min) + min;
    },

    // ✅ 核心：生成飞鸟（高度已经提高）
    generateBirds() {
      this.birds = Array.from({ length: 7 }, (_, i) => ({
        id: i + 1,

        // 🚀 重点：高度提高（以前太低）
        top: `${this.randomBetween(-12, 2)}%`,

        left: `${this.randomBetween(-10, 80)}%`,
        size: `${this.randomBetween(480, 840)}px`,
        duration: `${this.randomBetween(10, 18)}s`,
        delay: `${this.randomBetween(0, 6)}s`,
        scale: this.randomBetween(0.8, 1.2).toFixed(2)
      }));
    }
  }
}
</script>

<style>
/* 全局样式 */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html,
body {
  width: 100%;
  height: 100%;
  font-family: 'Arial', sans-serif;
  overflow-x: hidden;
}

.app {
  width: 100%;
  min-height: 100vh;
  position: relative;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  transition: background-image 0.3s ease-in-out;
  background-color: #f7f4ee;
}

/* 背景样式 */
.portal {
  width: 100%;
  height: 100%;
  position: absolute;
  background: transparent;
}

/* 导航样式 */
.navigation {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  z-index: 1000;
  background: rgba(255, 255, 255, 0.9);
  padding: 10px 0;
}

.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
}

.header_left a {
  text-decoration: none;
  color: #333;
  font-weight: bold;
}

.header_party ul {
  display: flex;
  list-style: none;
}

.header_party li {
  margin: 0 10px;
  text-align: center;
}

.header_party li img {
  width: 30px;
  height: 30px;
  margin-bottom: 5px;
}

.header_list {
  display: flex;
  align-items: center;
}

.list_dom {
  margin: 0 10px;
  width: 20px;
  height: 20px;
  cursor: pointer;
}

.clear {
  clear: both;
}

/* 加载动画样式 */
.load {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: #fff;
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
}

.tableCell {
  text-align: center;
}

.c {
  margin-bottom: 20px;
  font-size: 24px;
  color: #333;
}

.progress {
  width: 200px;
  height: 10px;
  background: #eee;
  border-radius: 5px;
  margin: 0 auto;
  overflow: hidden;
}

.progress span {
  display: block;
  width: 0;
  height: 100%;
  background: #000;
  animation: progress 2s linear forwards;
  border-radius: 5px;
}

@keyframes progress {
  from {
    width: 0;
  }

  to {
    width: 100%;
  }
}

/* 门户页面样式 */
.partyPart {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 8%;
  width: 100%;
  height: 72vh;
  min-height: 580px;
  pointer-events: none;
  overflow: visible;
}

.partyPart > img {
  position: absolute;
  left: 0;
  bottom: 0;
  width: 100%;
  height: auto;
  display: block;
  pointer-events: none;
  z-index: 1;
}

.PartConIcon {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: space-around;
  align-items: flex-end;
  padding: 0 2.5vw 0;
  pointer-events: auto;
  z-index: 4;
}

.PartIcon {
  width: 4.6em;
  height: 72vh;
  min-height: 580px;
  cursor: pointer;
  transition: transform 0.3s ease;
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-end;
  flex: 0 0 auto;

  --raise: 0px;
  --scale: 1;
  transform: translateY(var(--raise));
  transform-origin: center bottom;
}

/* 人物图本体放到伪元素里，单独控制缩放 */
.PartIcon::before {
  content: "";
  position: absolute;
  left: 50%;
  bottom: 0;
  width: 100%;
  height: 100%;
  transform: translateX(-50%) scale(var(--scale));
  transform-origin: center bottom;
  background-repeat: no-repeat;
  background-position: center bottom;
  background-size: contain;
  pointer-events: none;
  z-index: 1;
}

.PartIcon .header-img {
  width: 4em;
  height: auto;
  position: absolute;
  top: -3em;
  left: 50%;
  transform: translateX(-50%);
  z-index: 10;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.3s ease;
}

.PartIcon:hover .header-img,
.PartIcon.collect .header-img {
  opacity: 1;
}

/* 背景图改到伪元素上 */
.Part01::before {
  background-image: url(../assets/images/navigation/shi-libai.png);
}

.Part02::before {
  background-image: url(../assets/images/navigation/ge-quyuan.png);
}

.Part03::before {
  background-image: url(../assets/images/navigation/fu-caozhi.png);
}

.Part04::before {
  background-image: url(../assets/images/navigation/ci-liqingzhao.png);
}

.Part05::before {
  background-image: url(../assets/images/navigation/qu-mudanting.png);
}

.Part06::before {
  background-image: url(../assets/images/navigation/xiandaishige-wenyiduo.png);
}

/* hover 时容器不再额外缩放，只保留上下位置 */
.PartIcon.collect {
  transform: translateY(var(--raise));
  transform-origin: center bottom;
}

/* hover 时只放大人物图本体 */
.PartIcon.collect::before {
  transform: translateX(-50%) scale(calc(var(--scale) * 1.06));
  transform-origin: center bottom;
}

/* 前三个缩小一点，并单独校正到底部同一水平线 */
.Part01 {
  --raise: 75px;
  --scale: 0.88;
}

.Part02 {
  --raise: 70px;
  --scale: 0.86;
}

.Part03 {
  --raise: -8px;
  --scale: 0.87;
}

/* 后三个保持正常大小，按底线微调 */
.Part04 {
  --raise: 120px;
  --scale: 1.05;
}

.Part05 {
  --raise: 100px;
  --scale: 1.02;
}

.Part06 {
  --raise: 80px;
  --scale: 1.03;
}

.other p {
  display: flex;
  justify-content: center;
  align-items: center;
}

.other span {
  margin: 0 10px;
}

.other a {
  text-decoration: none;
  color: #333;
}

/* 主题页面样式 */
.partyPartContent {
  width: 100%;
  min-height: 100vh;
  background: #fff;
  padding-top: 100px;
}

.series {
  width: 100%;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .header {
    flex-direction: column;
    align-items: flex-start;
  }

  .header_party ul {
    flex-wrap: wrap;
  }

  .header_party li {
    margin: 5px;
  }

  .partyPart {
    width: 95%;
  }
}
/* 飘花层：只在诗的首页背景时显示，背景图上、人物下，不拦截点击 */
/* 诗：左上角小花瓣 */
.hua-background {
  position: absolute;

  top: 0;
  left: 10px;

  width: 320px;   /* 控制大小 */
  height: 320px;

  z-index: 2;
  pointer-events: none;

  background-image: url('../assets/home2/hua.gif');
  background-repeat: no-repeat;
  background-position: left top;
  background-size: contain;

  opacity: 0.9;
}

/* app 作为定位容器 */
.app {
  overflow: hidden;
}

/* 门户层压在花瓣上面，保证人物和点击都正常 */
.portal {
  z-index: 3;
}


/* 飞鸟层：赋专用 */
/* 赋：飞鸟层 */
.bird-layer {
  position: absolute;
  inset: 0;
  z-index: 2;
  pointer-events: none;
  overflow: hidden;
}

.bird-item {
  position: absolute;
  display: block;
  background-image: url('../assets/home2/bird.gif');
  background-repeat: no-repeat;
  background-position: center;
  background-size: contain;
  opacity: 0.9;
  will-change: transform, left, top, opacity;
  animation: birdFlyAcross linear infinite;
}

@keyframes birdFlyAcross {
  0% {
    transform: translateX(0) translateY(0) scale(1);
    opacity: 0;
  }
  10% {
    opacity: 0.95;
  }
  50% {
    transform: translateX(38vw) translateY(-1.2vw) scale(1.03);
    opacity: 1;
  }
  100% {
    transform: translateX(78vw) translateY(-2.2vw) scale(1.08);
    opacity: 0;
  }
}
/* 词：左上角伸出来的花鸟 */
.bird2-left {
  position: absolute;
  top: -6%;       /* 往上超出一点 */
  left: 0;      /* 往左超出一点（关键！） */

  width: 320px;   /* 你可以再调大 */
  height: 320px;

  z-index: 2;     /* 和 hua 一样层级 */
  pointer-events: none;

  background-image: url('../assets/home2/bird2.gif');
  background-repeat: no-repeat;
  background-size: contain;
  background-position: left top;

  opacity: 0.95;
}
/* 歌：右上角伸出来的花枝 */
.hua2-right {
  position: absolute;
  top: -3%;
  right: -2%;
  width: 360px;
  height: 360px;
  z-index: 2;
  pointer-events: none;
  background-image: url('../assets/home2/hua2.gif');
  background-repeat: no-repeat;
  background-size: contain;
  background-position: right top;
  opacity: 0.98;
}

/* 歌：偏右位置的燕子，靠近花枝 */
.yanzi-right {
  position: absolute;
  top: 12%;
  right: 14%;
  width: 150px;
  height: 150px;
  z-index: 2;
  pointer-events: none;
  background-image: url('../assets/home2/yanzi.gif');
  background-repeat: no-repeat;
  background-size: contain;
  background-position: center;
  opacity: 1;
}
/* 现：右上角往左+往下的鹤 */
.he-right-top {
  position: absolute;

  top: 10%;     /* 往下 */
  right: 18%;   /* 往左（不是贴边） */

  width: 260px;
  height: 260px;

  z-index: 2;
  pointer-events: none;

  background-image: url('../assets/home2/1.gif');
  background-repeat: no-repeat;
  background-size: contain;
  background-position: center;

  opacity: 1;
}/* 曲：左上角飞出来的鸟 */
.bird3-left-top {
  position: absolute;

  top: -5%;     /* 往上超一点 */
  left: -6%;    /* 往左超一点（关键：伸出来的感觉） */

  width: 280px;
  height: 280px;

  z-index: 2;
  pointer-events: none;

  background-image: url('../assets/home2/bird3.gif');
  background-repeat: no-repeat;
  background-size: contain;
  background-position: left top;

  opacity: 0.95;
}
</style>