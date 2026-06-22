<template>
  <div class="agent-home">
    <!-- 第二层导航 - 智能体分类 -->
    <div v-show="showSecondNav" class="second-nav" @mouseenter="showSecondNav = true" @mouseleave="showSecondNav = false">
      <div class="second-nav-tabs">
        <span class="second-tab" :class="{ active: mainCategory === '首页' }" @click="mainCategory = '首页'">首页</span>
        <span class="second-tab" :class="{ active: mainCategory === '诗人' }" @click="mainCategory = '诗人'">诗人</span>
        <span class="second-tab" :class="{ active: mainCategory === '写作' }" @click="mainCategory = '写作'">写作</span>
        <span class="second-tab" :class="{ active: mainCategory === '情感' }" @click="mainCategory = '情感'">情感</span>
        <span class="second-tab" :class="{ active: mainCategory === '教育' }" @click="mainCategory = '教育'">教育</span>
        <span class="second-tab" :class="{ active: mainCategory === '工作' }" @click="mainCategory = '工作'">工作</span>
        <span class="second-tab" :class="{ active: mainCategory === '生活' }" @click="mainCategory = '生活'">生活</span>
        <span class="second-tab" :class="{ active: mainCategory === '趣味' }" @click="mainCategory = '趣味'">趣味</span>
      </div>
    </div>

    <!-- 主要内容区域 -->
    <div class="main-content">
      <!-- 首页内容 -->
      <div v-if="mainCategory === '首页'">
        <div class="fullscreen-carousel" ref="carouselRef" @touchstart="handleTouchStart" @touchmove="handleTouchMove" @touchend="handleTouchEnd">
          <div class="carousel-track" :style="{ transform: `translateX(-${currentSlide * 100}%)` }">
            <div class="carousel-slide" v-for="agent in heroAgents" :key="agent.id" @click="goToChat(agent)">
              <div class="fullscreen-image" :style="{ backgroundImage: `url(${agent.image})` }">
                <div class="carousel-overlay">
                  <div class="slide-content">
                    <span class="slide-emoji">{{ agent.emoji }}</span>
                    <div class="slide-info">
                      <div class="slide-name">{{ agent.name }}</div>
                      <div class="slide-desc">{{ agent.desc }}</div>
                      <div class="slide-category">{{ agent.category }}</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="carousel-dots">
            <span v-for="(agent, index) in heroAgents" :key="index" class="dot" :class="{ active: currentSlide === index }" @click="currentSlide = index"></span>
          </div>

          <button class="carousel-arrow left" @click="prevSlide">‹</button>
          <button class="carousel-arrow right" @click="nextSlide">›</button>
        </div>

        <!-- 每日推荐 -->
        <div class="daily-section">
          <div class="section-header">
            <h2 class="section-title">每日推荐</h2>
            <span class="section-more">查看更多 →</span>
          </div>
          <div class="horizontal-scroll">
            <div class="rect-card" v-for="agent in dailyRecommended" :key="agent.id" @click="goToChat(agent)">
              <div class="rect-image" :style="{ backgroundImage: `url(${agent.image})` }">
                <div class="card-overlay"></div>
              </div>
              <div class="rect-name">{{ agent.name }}</div>
              <div class="rect-desc">{{ agent.desc }}</div>
              <div class="rect-category">{{ agent.category }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- 诗人分类内容 -->
      <div v-if="mainCategory === '诗人'">
        <div class="sub-nav">
          <span class="sub-tab" :class="{ active: poetSubCategory === '全部' }" @click="poetSubCategory = '全部'">全部</span>
          <span class="sub-tab" :class="{ active: poetSubCategory === '唐代诗人' }" @click="poetSubCategory = '唐代诗人'">唐代诗人</span>
          <span class="sub-tab" :class="{ active: poetSubCategory === '宋代诗人' }" @click="poetSubCategory = '宋代诗人'">宋代诗人</span>
          <span class="sub-tab" :class="{ active: poetSubCategory === '元明清诗人' }" @click="poetSubCategory = '元明清诗人'">元明清诗人</span>
          <span class="sub-tab" :class="{ active: poetSubCategory === '秦汉魏晋南北朝' }" @click="poetSubCategory = '秦汉魏晋南北朝'">秦汉魏晋南北朝</span>
        </div>
        <div class="agents-grid">
          <div class="rect-card" v-for="agent in filteredPoets" :key="agent.id" @click="goToChat(agent)">
            <div class="rect-image" :style="{ backgroundImage: `url(${agent.image})` }">
              <div class="card-overlay"></div>
            </div>
            <div class="rect-name">{{ agent.name }}</div>
            <div class="rect-desc">{{ agent.desc }}</div>
          </div>
        </div>
      </div>

      <div v-if="mainCategory === '写作'">
        <div class="sub-nav">
          <span class="sub-tab" :class="{ active: writingSubCategory === '全部' }" @click="writingSubCategory = '全部'">全部</span>
          <span class="sub-tab" :class="{ active: writingSubCategory === '写作助手' }" @click="writingSubCategory = '写作助手'">写作助手</span>
          <span class="sub-tab" :class="{ active: writingSubCategory === '诗词曲赋' }" @click="writingSubCategory = '诗词曲赋'">诗词曲赋</span>
          <span class="sub-tab" :class="{ active: writingSubCategory === '文案寄语' }" @click="writingSubCategory = '文案寄语'">文案寄语</span>
          <span class="sub-tab" :class="{ active: writingSubCategory === '小说故事' }" @click="writingSubCategory = '小说故事'">小说故事</span>
          <span class="sub-tab" :class="{ active: writingSubCategory === '书评影评' }" @click="writingSubCategory = '书评影评'">书评影评</span>
          <span class="sub-tab" :class="{ active: writingSubCategory === '日记散文' }" @click="writingSubCategory = '日记散文'">日记散文</span>
        </div>
        <div class="agents-grid">
          <div class="rect-card" v-for="agent in filteredWriting" :key="agent.id" @click="goToChat(agent)">
            <div class="rect-image" :style="{ backgroundImage: `url(${agent.image})` }">
              <div class="card-overlay"></div>
            </div>
            <div class="rect-name">{{ agent.name }}</div>
            <div class="rect-desc">{{ agent.desc }}</div>
          </div>
        </div>
      </div>

      <div v-if="mainCategory === '情感'">
        <div class="sub-nav">
          <span class="sub-tab" :class="{ active: emotionalSubCategory === '全部' }" @click="emotionalSubCategory = '全部'">全部</span>
          <span class="sub-tab" :class="{ active: emotionalSubCategory === '情感陪伴' }" @click="emotionalSubCategory = '情感陪伴'">情感陪伴</span>
        </div>
        <div class="agents-grid">
          <div class="rect-card" v-for="agent in filteredEmotional" :key="agent.id" @click="goToChat(agent)">
            <div class="rect-image" :style="{ backgroundImage: `url(${agent.image})` }">
              <div class="card-overlay"></div>
            </div>
            <div class="rect-name">{{ agent.name }}</div>
            <div class="rect-desc">{{ agent.desc }}</div>
          </div>
        </div>
      </div>

      <div v-if="mainCategory === '教育'">
        <div class="sub-nav">
          <span class="sub-tab" :class="{ active: educationSubCategory === '全部' }" @click="educationSubCategory = '全部'">全部</span>
          <span class="sub-tab" :class="{ active: educationSubCategory === '教育学习' }" @click="educationSubCategory = '教育学习'">教育学习</span>
          <span class="sub-tab" :class="{ active: educationSubCategory === '学科老师' }" @click="educationSubCategory = '学科老师'">学科老师</span>
        </div>
        <div class="agents-grid">
          <div class="rect-card" v-for="agent in filteredEducation" :key="agent.id" @click="goToChat(agent)">
            <div class="rect-image" :style="{ backgroundImage: `url(${agent.image})` }">
              <div class="card-overlay"></div>
            </div>
            <div class="rect-name">{{ agent.name }}</div>
            <div class="rect-desc">{{ agent.desc }}</div>
          </div>
        </div>
      </div>

      <div v-if="mainCategory === '工作'">
        <div class="agents-grid">
          <div class="rect-card" v-for="agent in workAgents" :key="agent.id" @click="goToChat(agent)">
            <div class="rect-image" :style="{ backgroundImage: `url(${agent.image})` }">
              <div class="card-overlay"></div>
            </div>
            <div class="rect-name">{{ agent.name }}</div>
            <div class="rect-desc">{{ agent.desc }}</div>
          </div>
        </div>
      </div>

      <div v-if="mainCategory === '生活'">
        <div class="sub-nav">
          <span class="sub-tab" :class="{ active: lifeSubCategory === '全部' }" @click="lifeSubCategory = '全部'">全部</span>
          <span class="sub-tab" :class="{ active: lifeSubCategory === '姓名测试' }" @click="lifeSubCategory = '姓名测试'">姓名测试</span>
          <span class="sub-tab" :class="{ active: lifeSubCategory === '星座占卜' }" @click="lifeSubCategory = '星座占卜'">星座占卜</span>
          <span class="sub-tab" :class="{ active: lifeSubCategory === '美食大厨' }" @click="lifeSubCategory = '美食大厨'">美食大厨</span>
        </div>
        <div class="agents-grid">
          <div class="rect-card" v-for="agent in filteredLife" :key="agent.id" @click="goToChat(agent)">
            <div class="rect-image" :style="{ backgroundImage: `url(${agent.image})` }">
              <div class="card-overlay"></div>
            </div>
            <div class="rect-name">{{ agent.name }}</div>
            <div class="rect-desc">{{ agent.desc }}</div>
          </div>
        </div>
      </div>

      <div v-if="mainCategory === '趣味'">
        <div class="sub-nav">
          <span class="sub-tab" :class="{ active: funSubCategory === '全部' }" @click="funSubCategory = '全部'">全部</span>
        </div>
        <div class="agents-grid">
          <div class="rect-card" v-for="agent in funAgents" :key="agent.id" @click="goToChat(agent)">
            <div class="rect-image" :style="{ backgroundImage: `url(${agent.image})` }">
              <div class="card-overlay"></div>
            </div>
            <div class="rect-name">{{ agent.name }}</div>
            <div class="rect-desc">{{ agent.desc }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'

import linDaiyuImg from '@/assets/images/lin-daiyu.jpg'
import libaiImg from '@/assets/images/libai.jpg'
import poetryWriterImg from '@/assets/images/poetry-writer.jpg'
import companionImg from '@/assets/images/companion.jpg'
import poetryTeacherImg from '@/assets/images/poetry-teacher.jpg'
import workAssistantImg from '@/assets/images/work-assistant.jpg'
import foodMasterImg from '@/assets/images/food-master.jpg'

import dufuImg from '@/assets/images/dufu.jpg'
import sushiImg from '@/assets/images/sushi.jpg'
import essayWriterImg from '@/assets/images/essay-writer.jpg'
import companion2Img from '@/assets/images/companion2.jpg'
import historyTeacherImg from '@/assets/images/history-teacher.jpg'
import zodiacImg from '@/assets/images/zodiac.jpg'

import libaiImg2 from '@/assets/images/libai.jpg'
import dufuImg2 from '@/assets/images/dufu.jpg'
import baijuyiImg from '@/assets/images/baijuyi.jpg'
import wangweiImg from '@/assets/images/wangwei.jpg'
import lishangyinImg from '@/assets/images/lishangyin.jpg'
import dumuImg from '@/assets/images/dumu.jpg'
import sushiImg2 from '@/assets/images/sushi.jpg'
import liqingzhaoImg from '@/assets/images/liqingzhao.jpg'
import xinqijiImg from '@/assets/images/xinqiji.jpg'
import luyouImg from '@/assets/images/luyou.jpg'
import liuyongImg from '@/assets/images/liuyong.jpg'
import guanhanqingImg from '@/assets/images/guanhanqing.jpg'
import wangshifuImg from '@/assets/images/wangshifu.jpg'
import tangxianzuImg from '@/assets/images/tangxianzu.jpg'
import nalanxingdeImg from '@/assets/images/nalanxingde.jpg'
import quyuanImg from '@/assets/images/quyuan.jpg'
import caocaoImg from '@/assets/images/caocao.jpg'
import taoyuanmingImg from '@/assets/images/taoyuanming.jpg'
import xielingyunImg from '@/assets/images/xielingyun.jpg'

import rhymeHelperImg from '@/assets/images/rhyme-helper.jpg'
import ciPoetryImg from '@/assets/images/ci-poetry.jpg'
import sloganMakerImg from '@/assets/images/slogan-maker.jpg'
import greetingImg from '@/assets/images/greeting.jpg'
import storyTellerImg from '@/assets/images/story-teller.jpg'
import novelWriterImg from '@/assets/images/novel-writer.jpg'
import movieReviewImg from '@/assets/images/movie-review.jpg'
import bookReviewImg from '@/assets/images/book-review.jpg'
import diaryWriterImg from '@/assets/images/diary-writer.jpg'
import essayMasterImg from '@/assets/images/essay-master.jpg'

import companion3Img from '@/assets/images/companion3.jpg'
import companion4Img from '@/assets/images/companion4.jpg'
import companion5Img from '@/assets/images/companion5.jpg'

import chineseTeacherImg from '@/assets/images/chinese-teacher.jpg'
import mathTeacherImg from '@/assets/images/math-teacher.jpg'
import englishTeacherImg from '@/assets/images/english-teacher.jpg'
import physicsTeacherImg from '@/assets/images/physics-teacher.jpg'

import workAssistant1Img from '@/assets/images/work-assistant1.jpg'
import workAssistant2Img from '@/assets/images/work-assistant2.jpg'
import workAssistant3Img from '@/assets/images/work-assistant3.jpg'
import workAssistant4Img from '@/assets/images/work-assistant4.jpg'
import workAssistant5Img from '@/assets/images/work-assistant5.jpg'

import nameTestImg from '@/assets/images/name-test.jpg'
import nameAnalysisImg from '@/assets/images/name-analysis.jpg'
import horoscopeImg from '@/assets/images/horoscope.jpg'
import recipeImg from '@/assets/images/recipe.jpg'
import bakingImg from '@/assets/images/baking.jpg'

import dreamInterpImg from '@/assets/images/dream-interp.jpg'
import jokeMasterImg from '@/assets/images/joke-master.jpg'
import riddleKingImg from '@/assets/images/riddle-king.jpg'
import triviaKingImg from '@/assets/images/trivia-king.jpg'
import gameMasterImg from '@/assets/images/game-master.jpg'

const router = useRouter()

const showSecondNav = ref(false)

const handleShowSubNav = () => {
  showSecondNav.value = true
}

const handleHideSubNav = () => {
  showSecondNav.value = false
}

onMounted(() => {
  window.addEventListener('ai-subnav-show', handleShowSubNav)
  window.addEventListener('ai-subnav-hide', handleHideSubNav)
})

onUnmounted(() => {
  window.removeEventListener('ai-subnav-show', handleShowSubNav)
  window.removeEventListener('ai-subnav-hide', handleHideSubNav)
})

const mainCategory = ref('首页')
const poetSubCategory = ref('全部')
const writingSubCategory = ref('全部')
const emotionalSubCategory = ref('全部')
const educationSubCategory = ref('全部')
const lifeSubCategory = ref('全部')
const funSubCategory = ref('全部')

const currentSlide = ref(0)
const startX = ref(0)
const isDragging = ref(false)

const heroAgents = [
  { id: 'lin_daiyu', name: '林黛玉', desc: '潇湘妃子', category: '诗人', image: linDaiyuImg },
  { id: 'libai', name: '李白', desc: '诗仙', category: '诗人', image: libaiImg },
  { id: 'poetry_writer', name: '诗词写作', desc: '帮你写诗填词', category: '写作', image: poetryWriterImg },
  { id: 'companion1', name: '暖心姐姐', desc: '温暖陪伴', category: '情感', image: companionImg },
  { id: 'poetry_teacher', name: '诗词老师', desc: '讲解诗词', category: '教育', image: poetryTeacherImg },
  { id: 'work_assistant', name: '工作助手', desc: '职场帮手', category: '工作', image: workAssistantImg },
  { id: 'food_master', name: '美食大厨', desc: '菜谱大全', category: '生活', image: foodMasterImg },
]

const dailyRecommended = [
  { id: 'dufu', name: '杜甫', desc: '诗圣', category: '诗人', image: dufuImg },
  { id: 'sushi', name: '苏轼', desc: '东坡居士', category: '诗人', image: sushiImg },
  { id: 'essay_writer', name: '文章润色', desc: '优化你的文章', category: '写作', image: essayWriterImg },
  { id: 'companion2', name: '诗文助手', desc: '倾听心声', category: '情感', image: companion2Img },
  { id: 'history_teacher', name: '古文学老师', desc: '讲解古文', category: '教育', image: historyTeacherImg },
  { id: 'name_test', name: '每日运势', desc: '星座预测', subCategory: '星座占卜', image: nameTestImg },
]

const tangPoets = [
  { id: 'libai', name: '李白', desc: '诗仙', dynasty: '唐', image: libaiImg2 },
  { id: 'dufu', name: '杜甫', desc: '诗圣', dynasty: '唐', image: dufuImg2 },
  { id: 'bai_juyi', name: '白居易', desc: '香山居士', dynasty: '唐', image: baijuyiImg },
  { id: 'wangwei', name: '王维', desc: '诗佛', dynasty: '唐', image: wangweiImg },
  { id: 'li_shangyin', name: '李商隐', desc: '玉溪生', dynasty: '唐', image: lishangyinImg },
  { id: 'du_mu', name: '杜牧', desc: '樊川居士', dynasty: '唐', image: dumuImg },
]

const songPoets = [
  { id: 'sushi', name: '苏轼', desc: '东坡居士', dynasty: '宋', image: sushiImg2 },
  { id: 'liqingzhao', name: '李清照', desc: '易安居士', dynasty: '宋', image: liqingzhaoImg },
  { id: 'xinqiji', name: '辛弃疾', desc: '稼轩居士', dynasty: '宋', image: xinqijiImg },
  { id: 'luyou', name: '陆游', desc: '放翁', dynasty: '宋', image: luyouImg },
  { id: 'liuyong', name: '柳永', desc: '白衣卿相', dynasty: '宋', image: liuyongImg },
]

const yuanMingQingPoets = [
  { id: 'guanhanqing', name: '关汉卿', desc: '元曲四大家', dynasty: '元', image: guanhanqingImg },
  { id: 'wangshifu', name: '王实甫', desc: '西厢记作者', dynasty: '元', image: wangshifuImg },
  { id: 'tangxianzu', name: '汤显祖', desc: '牡丹亭作者', dynasty: '明', image: tangxianzuImg },
  { id: 'nalanxingde', name: '纳兰性德', desc: '清代词人', dynasty: '清', image: nalanxingdeImg },
]

const ancientPoets = [
  { id: 'quyuan', name: '屈原', desc: '楚辞之祖', dynasty: '战国', image: quyuanImg },
  { id: 'caocao', name: '曹操', desc: '魏武帝', dynasty: '三国', image: caocaoImg },
  { id: 'taoyuanming', name: '陶渊明', desc: '五柳先生', dynasty: '晋', image: taoyuanmingImg },
  { id: 'xie_lingyun', name: '谢灵运', desc: '山水诗祖', dynasty: '南北朝', image: xielingyunImg },
]

const allPoets = [...tangPoets, ...songPoets, ...yuanMingQingPoets, ...ancientPoets]

const writingAssistants = [
  { id: 'poetry_writer', name: '诗词写作', desc: '帮你写诗填词', subCategory: '写作助手', image: poetryWriterImg },
  { id: 'essay_writer', name: '文章润色', desc: '优化你的文章', subCategory: '写作助手', image: essayWriterImg },
  { id: 'rhyme_helper', name: '押韵助手', desc: '找韵脚神器', subCategory: '诗词曲赋', image: rhymeHelperImg },
  { id: 'ci_poetry', name: '词牌创作', desc: '填词专家', subCategory: '诗词曲赋', image: ciPoetryImg },
  { id: 'slogan_maker', name: '标语生成', desc: '创意标语', subCategory: '文案寄语', image: sloganMakerImg },
  { id: 'greeting', name: '祝福寄语', desc: '节日祝福', subCategory: '文案寄语', image: greetingImg },
  { id: 'story_teller', name: '故事大王', desc: '讲有趣的故事', subCategory: '小说故事', image: storyTellerImg },
  { id: 'novel_writer', name: '小说创作', desc: '写小说帮手', subCategory: '小说故事', image: novelWriterImg },
  { id: 'movie_review', name: '影评专家', desc: '电影评论', subCategory: '书评影评', image: movieReviewImg },
  { id: 'book_review', name: '书评达人', desc: '书籍点评', subCategory: '书评影评', image: bookReviewImg },
  { id: 'diary_writer', name: '日记助手', desc: '写日记指导', subCategory: '日记散文', image: diaryWriterImg },
  { id: 'essay_master', name: '散文大家', desc: '散文创作', subCategory: '日记散文', image: essayMasterImg },
]

const emotionalAgents = [
  { id: 'companion1', name: '暖心姐姐', desc: '温暖陪伴', subCategory: '情感陪伴', image: companionImg },
  { id: 'companion2', name: '诗文助手', desc: '倾听心声', subCategory: '情感陪伴', image: companion2Img },
  { id: 'companion3', name: '心灵导师', desc: '开导解惑', subCategory: '情感陪伴', image: companion3Img },
  { id: 'companion4', name: '温暖树洞', desc: '秘密倾诉', subCategory: '情感陪伴', image: companion4Img },
  { id: 'companion5', name: '治愈伙伴', desc: '治愈心灵', subCategory: '情感陪伴', image: companion5Img },
]

const educationAgents = [
  { id: 'poetry_teacher', name: '诗词老师', desc: '讲解诗词', subCategory: '教育学习', image: poetryTeacherImg },
  { id: 'history_teacher', name: '古文学老师', desc: '讲解古文', subCategory: '教育学习', image: historyTeacherImg },
  { id: 'chinese_teacher', name: '语文老师', desc: '语文辅导', subCategory: '教育学习', image: chineseTeacherImg },
  { id: 'math_teacher', name: '数学老师', desc: '数学辅导', subCategory: '学科老师', image: mathTeacherImg },
  { id: 'english_teacher', name: '英语老师', desc: '英语学习', subCategory: '学科老师', image: englishTeacherImg },
  { id: 'physics_teacher', name: '物理老师', desc: '物理辅导', subCategory: '学科老师', image: physicsTeacherImg },
]

const workAgents = [
  { id: 'work_assistant1', name: '职场导师', desc: '职业规划', image: workAssistant1Img },
  { id: 'work_assistant2', name: '简历优化', desc: '简历修改', image: workAssistant2Img },
  { id: 'work_assistant3', name: '面试辅导', desc: '面试技巧', image: workAssistant3Img },
  { id: 'work_assistant4', name: '办公软件', desc: 'Excel/PPT', image: workAssistant4Img },
  { id: 'work_assistant5', name: '职场沟通', desc: '沟通技巧', image: workAssistant5Img },
]

const lifeAgents = [
  { id: 'zodiac', name: '姓名测试', desc: '姓名评分', subCategory: '姓名测试', image: zodiacImg },
  { id: 'name_analysis', name: '姓名解析', desc: '姓名含义', subCategory: '姓名测试', image: nameAnalysisImg },
  { id: 'horoscope', name: '星座占卜', desc: '星座运势', subCategory: '星座占卜', image: horoscopeImg },
  { id: 'name_test', name: '每日运势', desc: '星座预测', subCategory: '星座占卜', image: nameTestImg },
  { id: 'food_master', name: '美食大厨', desc: '菜谱大全', subCategory: '美食大厨', image: foodMasterImg },
  { id: 'recipe', name: '家常菜谱', desc: '家常美食', subCategory: '美食大厨', image: recipeImg },
  { id: 'baking', name: '烘焙达人', desc: '甜点烘焙', subCategory: '美食大厨', image: bakingImg },
]

const funAgents = [
  { id: 'dream_interp', name: 'AI解梦', desc: '梦境解析', subCategory: '全部', image: dreamInterpImg },
  { id: 'joke_master', name: '笑话大师', desc: '让你开心一笑', subCategory: '全部', image: jokeMasterImg },
  { id: 'riddle_king', name: '谜语王', desc: '出谜猜谜', subCategory: '全部', image: riddleKingImg },
  { id: 'trivia_king', name: '冷知识王', desc: '趣味冷知识', subCategory: '全部', image: triviaKingImg },
  { id: 'game_master', name: '游戏专家', desc: '游戏攻略', subCategory: '全部', image: gameMasterImg },
]

const filteredPoets = computed(() => {
  if (poetSubCategory.value === '全部') return allPoets
  if (poetSubCategory.value === '唐代诗人') return tangPoets
  if (poetSubCategory.value === '宋代诗人') return songPoets
  if (poetSubCategory.value === '元明清诗人') return yuanMingQingPoets
  if (poetSubCategory.value === '秦汉魏晋南北朝') return ancientPoets
  return allPoets
})

const filteredWriting = computed(() => {
  if (writingSubCategory.value === '全部') return writingAssistants
  return writingAssistants.filter(a => a.subCategory === writingSubCategory.value)
})

const filteredEmotional = computed(() => {
  if (emotionalSubCategory.value === '全部') return emotionalAgents
  return emotionalAgents.filter(a => a.subCategory === emotionalSubCategory.value)
})

const filteredEducation = computed(() => {
  if (educationSubCategory.value === '全部') return educationAgents
  return educationAgents.filter(a => a.subCategory === educationSubCategory.value)
})

const filteredLife = computed(() => {
  if (lifeSubCategory.value === '全部') return lifeAgents
  return lifeAgents.filter(a => a.subCategory === lifeSubCategory.value)
})

const handleTouchStart = (e) => {
  startX.value = e.touches[0].clientX
  isDragging.value = true
}

const handleTouchMove = (e) => {
  if (!isDragging.value) return
  e.preventDefault()
}

const handleTouchEnd = (e) => {
  if (!isDragging.value) return

  const endX = e.changedTouches[0].clientX
  const diff = startX.value - endX

  if (Math.abs(diff) > 50) {
    if (diff > 0 && currentSlide.value < heroAgents.length - 1) {
      currentSlide.value++
    } else if (diff < 0 && currentSlide.value > 0) {
      currentSlide.value--
    }
  }

  isDragging.value = false
}

const prevSlide = () => {
  if (currentSlide.value > 0) {
    currentSlide.value--
  } else {
    currentSlide.value = heroAgents.length - 1
  }
}

const nextSlide = () => {
  if (currentSlide.value < heroAgents.length - 1) {
    currentSlide.value++
  } else {
    currentSlide.value = 0
  }
}

const goToChat = (agent) => {
  router.push({
    path: '/agent-chat',
    query: {
      id: agent.id,
      name: agent.name,
      dynasty: agent.dynasty || '',
      desc: agent.desc || '',
      image: agent.image || ''
    }
  })
}
</script>

<style scoped>
.agent-home {
  min-height: 100vh;
  color: #3a3328;
  background:
    radial-gradient(circle at 18% 16%, rgba(255, 255, 255, 0.82), transparent 34%),
    radial-gradient(circle at 82% 72%, rgba(210, 198, 172, 0.12), transparent 42%),
    linear-gradient(135deg, #f8f7f1 0%, #f1eee5 100%);
}

/* 第二层导航 - 智能体分类 */
.second-nav {
  position: sticky;
  top: 64px;
  z-index: 49;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 12px 32px;
  background: rgba(190, 170, 138, 0.75);
  border-bottom: 1px solid rgba(120, 96, 62, 0.35);
}

.second-nav-tabs {
  display: flex;
  gap: 24px;
}

.second-tab {
  font-size: 13px;
  color: #fffaf0;
  cursor: pointer;
  padding: 4px 0;
  transition: all 0.2s ease;
}

.second-tab:hover {
  color: #f9e0ac;
}

.second-tab.active {
  color: #f9e0ac;
  font-weight: 600;
  border-bottom: 2px solid #f1d399;
}

/* 主要内容区域 */
.main-content {
  max-width: 100%;
  margin: 0 auto;
  padding: 0;
}

/* 全屏轮播图 */
.fullscreen-carousel {
  width: 100%;
  overflow: hidden;
  margin-bottom: 0;
  position: relative;
  box-shadow: 0 10px 28px rgba(90, 70, 42, 0.08);
}

.carousel-track {
  display: flex;
  transition: transform 0.3s ease;
}

.carousel-slide {
  flex: 0 0 100%;
  cursor: pointer;
}

.fullscreen-image {
  width: 100%;
  aspect-ratio: 3.8 / 1;
  background-size: cover;
  background-position: center;
  position: relative;
}


/* 轮播图遮罩层 */
.carousel-overlay {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0.95;
  color: white;
  z-index: 2;
}

.slide-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  color: white;
  padding: 20px;
}

.slide-emoji {
  font-size: 60px;
  margin-bottom: 10px;
  color: white;
}

.slide-info {
  background: rgba(45, 34, 22, 0.26);
  backdrop-filter: blur(10px);
  padding: 12px 28px;
  border-radius: 40px;
  border: 1px solid rgba(255, 255, 255, 0.26);
}

.slide-name {
  font-size: 28px;
  font-weight: 600;
  margin-bottom: 2px;
  color: white;
}

.slide-desc {
  font-size: 14px;
  margin-bottom: 2px;
  color: rgba(255, 255, 255, 0.92);
}

.slide-category {
  font-size: 12px;
  opacity: 0.9;
  color: rgba(255, 255, 255, 0.9);
}

/* 轮播图指示器 */
.carousel-dots {
  position: absolute;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 8px;
  z-index: 10;
}

.dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.55);
  cursor: pointer;
  transition: all 0.2s;
}

.dot.active {
  width: 24px;
  border-radius: 10px;
  background: #f8f4ea;
}

/* 轮播图箭头 */
.carousel-arrow {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 42px;
  height: 42px;
  background: rgba(250, 246, 236, 0.36);
  border: 1px solid rgba(255, 255, 255, 0.28);
  color: white;
  font-size: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  backdrop-filter: blur(6px);
  z-index: 10;
}

.carousel-arrow:hover {
  background: rgba(250, 246, 236, 0.55);
}

.carousel-arrow.left {
  left: 20px;
}

.carousel-arrow.right {
  right: 20px;
}

/* 二级导航 */
.sub-nav {
  display: flex;
  gap: 16px;
  margin: 24px 32px;
  padding: 12px 0;
  border-bottom: 1px solid rgba(120, 96, 62, 0.12);
  overflow-x: auto;
  white-space: nowrap;
}

.sub-tab {
  font-size: 14px;
  color: #6d6252;
  cursor: pointer;
  padding: 4px 12px;
  border-radius: 16px;
}

.sub-tab.active {
  color: #7b5d3a;
  background: rgba(150, 120, 78, 0.1);
  font-weight: 600;
}

/* 每日推荐 */
.daily-section {
  margin-top: 36px;
  padding: 0 32px 48px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 18px;
}

.section-title {
  font-size: 21px;
  font-weight: 600;
  color: #3c3428;
  margin: 0;
}

.section-more {
  font-size: 14px;
  color: #8a6a43;
  cursor: pointer;
}

.section-more:hover {
  color: #6f5231;
}

/* 水平滚动 */
.horizontal-scroll {
  display: flex;
  gap: 24px;
  overflow-x: auto;
  padding: 8px 4px 18px;
}

.horizontal-scroll::-webkit-scrollbar {
  height: 4px;
}

.horizontal-scroll::-webkit-scrollbar-track {
  background: rgba(120, 96, 62, 0.08);
}

.horizontal-scroll::-webkit-scrollbar-thumb {
  background: rgba(120, 96, 62, 0.28);
  border-radius: 2px;
}

.horizontal-scroll .rect-card {
  flex: 0 0 320px;
}

/* 智能体网格 */
.agents-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 24px;
  padding: 24px 32px 48px;
}

/* 卡片 */
.rect-card {
  cursor: pointer;
  text-align: center;
  padding: 10px 10px 14px;
  background: rgba(250, 248, 241, 0.88);
  border: 1px solid rgba(125, 100, 65, 0.12);
  box-shadow: 0 8px 22px rgba(90, 70, 42, 0.07);
  transition: all 0.22s ease;
}

.rect-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 14px 30px rgba(90, 70, 42, 0.12);
  background: rgba(253, 251, 245, 0.95);
}

/* 卡片图片 */
.rect-image {
  width: 100%;
  aspect-ratio: 1.4 / 1;
  background-size: cover;
  background-position: center;
  position: relative;
  overflow: hidden;
  margin-bottom: 10px;
  box-shadow: 0 2px 8px rgba(90, 70, 42, 0.08);
}


/* 卡片遮罩层 */
.card-overlay {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: transparent;
}

.rect-name {
  font-size: 15px;
  font-weight: 600;
  color: #3c3428;
  margin-bottom: 3px;
}

.rect-desc {
  font-size: 12px;
  color: #7a7062;
}

.rect-category {
  font-size: 11px;
  color: #8a6a43;
  margin-top: 3px;
}

/* 响应式调整 */
@media (max-width: 768px) {
  .second-nav {
    padding: 12px 18px;
  }

  .second-nav-tabs {
    gap: 16px;
    overflow-x: auto;
    white-space: nowrap;
  }

  .daily-section {
    padding: 0 18px 36px;
  }

  .agents-grid {
    padding: 20px 18px 36px;
    gap: 18px;
  }

  .sub-nav {
    margin: 20px 18px;
  }

  .slide-name {
    font-size: 22px;
  }

  .slide-emoji {
    font-size: 48px;
  }
}

@media (max-width: 480px) {
  .slide-info {
    padding: 8px 16px;
  }

  .slide-name {
    font-size: 18px;
  }

  .horizontal-scroll .rect-card {
    flex: 0 0 260px;
  }
}
</style>
