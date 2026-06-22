<template>
  <div class="gamePage">
    <!-- 第一屏：游戏地图（固定全屏） -->
    <div class="game-map-section">
      <div class="game-map-container" ref="gameMapContainer">
        <!-- 背景图片 -->
        <div class="game-map-bg" :style="{ backgroundImage: `url(${gameMapImage})` }"></div>

        <!-- 标题 -->
        <div class="game-title">
          <span class="title-text">诗韵游园</span>
        </div>

        <!-- 书卷样式的游戏入口（位于建筑正上方） -->
        <div 
          v-for="(game, index) in gameHotspots" 
          :key="game.id"
          class="game-scroll-entrance"
          :class="{ 
            active: activeHotspot === index,
            clicked: clickedHotspot === index
          }"
          :style="getHotspotStyle(game)"
          @click="goToGame(game.path)"
          @mouseenter="activeHotspot = index"
          @mouseleave="activeHotspot = null"
        >
          <!-- 内部包装器：处理浮动与悬停缩放，防止外层动画冲突导致闪烁 -->
          <div class="scroll-wrapper">
            <!-- 书轴装饰 - 左 -->
            <div class="scroll-rod rod-left"></div>
            
            <!-- 书卷内容（游戏名称） -->
            <div class="scroll-body">
              <span class="scroll-text">{{ game.name }}</span>
            </div>
            
            <!-- 书轴装饰 - 右 -->
            <div class="scroll-rod rod-right"></div>
            
            <!-- 悬浮详情提示 -->
            <div class="hotspot-tooltip">
              <div class="tooltip-desc">{{ game.desc }}</div>
            </div>
          </div>
        </div>
        
        <!-- 地图装饰层 -->
        <div class="map-overlay"></div>
      </div>
    </div>

    <!-- 复古宣纸导航栏 -->
    <nav class="retro-navbar">
      <div class="nav-content">
        <div class="nav-item" @click="scrollToSection('game-map-container')">
          <span class="nav-text">诗境地图</span>
          <span class="nav-dot"></span>
        </div>
        <div class="nav-item" @click="scrollToSection('gamesSection')">
          <span class="nav-text">游园秘籍</span>
          <span class="nav-dot"></span>
        </div>
        <div class="nav-item" @click="scrollToSection('ruleCard')">
          <span class="nav-text">赛季风云</span>
          <span class="nav-dot"></span>
        </div>
        <div class="nav-item" @click="scrollToSection('rankSection')">
          <span class="nav-text">金榜题名</span>
        </div>
      </div>
    </nav>

    <!-- 第二屏：规则和赛季速览区域 -->
    <div class="game-wrapper" ref="gameWrapper">
      <div class="gamePageInner" :style="pageBg(bgTop1)">
        <section class="mainGrid">
          <div class="cardsWithRank">
            <div class="gamesSection">
              <div class="sectionHead"></div>
              <div class="scrollGrid scrollGrid4">
                <!-- 卡片1：飞花令 -->
                <article class="scrollCard game-card" :style="cardBgStyle(cardImages.feihua)">
                  <div class="card-image-area"></div>
                  <div class="card-overlay">
                    <div class="scrollTop">
                      <div>
                        <div class="scrollTitle">飞花令</div>
                        <div class="scrollSub">主题字入句，命中诗句即得分</div>
                      </div>
                      <div class="seal">梅</div>
                    </div>
                    <div class="tagRow">
                      <span class="tag">对战 · 赛季</span>
                      <span class="tag soft">梅花积累</span>
                    </div>
                    <div class="btnRow">
                      <button class="btn" @click="goToGame('/game/feihualing')">进入</button>
                      <button class="btn ghost" @click="startFeihua">开始</button>
                    </div>
                  </div>
                </article>

                <!-- 卡片2：诗词接龙 -->
                <article class="scrollCard game-card" :style="cardBgStyle(cardImages.jielong)">
                  <div class="card-image-area"></div>
                  <div class="card-overlay">
                    <div class="scrollTop">
                      <div>
                        <div class="scrollTitle">诗词接龙</div>
                        <div class="scrollSub">承接上句起落，句句相扣</div>
                      </div>
                      <div class="seal">龙</div>
                    </div>
                    <div class="tagRow">
                      <span class="tag">对战 · 赛季</span>
                      <span class="tag soft">龙纹点亮</span>
                    </div>
                    <div class="btnRow">
                      <button class="btn" @click="goToGame('/game/jielong')">进入</button>
                      <button class="btn ghost" @click="startJielong">开始</button>
                    </div>
                  </div>
                </article>

                <!-- 卡片3：诗词趣消消 -->
                <article class="scrollCard game-card" :style="cardBgStyle(cardImages.xiaoxiao)">
                  <div class="card-image-area"></div>
                  <div class="card-overlay">
                    <div class="scrollTop">
                      <div>
                        <div class="scrollTitle">诗词趣消消</div>
                        <div class="scrollSub">60个片段 · 6个槽位 · 8分钟限时挑战</div>
                      </div>
                      <div class="seal">消</div>
                    </div>
                    <div class="tagRow">
                      <span class="tag">闯关 · 积分</span>
                      <span class="tag soft">战旗进度</span>
                    </div>
                    <div class="btnRow">
                      <button class="btn ghost" @click="viewBattle">查看</button>
                      <button class="btn" @click="startBattle">挑战</button>
                    </div>
                  </div>
                </article>

                <!-- 卡片4：韵脚迷阵 -->
                <article class="scrollCard game-card" :style="cardBgStyle(cardImages.maze)">
                  <div class="card-image-area"></div>
                  <div class="card-overlay">
                    <div class="scrollTop">
                      <div>
                        <div class="scrollTitle">韵脚迷阵</div>
                        <div class="scrollSub">迷宫寻诗 · 按顺序踏字 · 点亮诗笺</div>
                      </div>
                      <div class="seal">阵</div>
                    </div>
                    <div class="tagRow">
                      <span class="tag">解谜 · 闯关</span>
                      <span class="tag soft">诗笺点亮</span>
                    </div>
                    <div class="btnRow">
                      <button class="btn ghost" @click="viewMaze">查看</button>
                      <button class="btn" @click="startMaze">挑战</button>
                    </div>
                  </div>
                </article>

                <!-- 卡片5：文才评古 -->
                <article class="scrollCard game-card" :style="cardBgStyle(cardImages.quiz)">
                  <div class="card-image-area"></div>
                  <div class="card-overlay">
                    <div class="scrollTop">
                      <div>
                        <div class="scrollTitle">文才评古</div>
                        <div class="scrollSub">20题 · 更稳定匹配你的诗人气质画像</div>
                      </div>
                      <div class="seal">测</div>
                    </div>
                    <div class="tagRow">
                      <span class="tag">测评 · 画像</span>
                      <span class="tag soft">可回看</span>
                    </div>
                    <div class="btnRow">
                      <button class="btn" @click="goToGame('/game/poet-quiz')">进入</button>
                      <button class="btn ghost" @click="goToGame('/game/poet-quiz')">开始</button>
                    </div>
                  </div>
                </article>

                <!-- 卡片6：诗友圈 -->
                <article class="scrollCard game-card" :style="cardBgStyle(cardImages.moments)">
                  <div class="card-image-area"></div>
                  <div class="card-overlay">
                    <div class="scrollTop">
                      <div>
                        <div class="scrollTitle">诗友圈</div>
                        <div class="scrollSub">读动态猜诗人 · 像刷朋友圈一样玩</div>
                      </div>
                      <div class="seal">友</div>
                    </div>
                    <div class="tagRow">
                      <span class="tag">动态 · 猜诗人</span>
                      <span class="tag soft">接口闯关</span>
                    </div>
                    <div class="btnRow">
                      <button class="btn" @click="goToGame('/game/poet-moments')">进入</button>
                      <button class="btn ghost" @click="goToGame('/game/poet-moments')">开始</button>
                    </div>
                  </div>
                </article>
              </div>
            </div>

            <!-- 排行榜 -->
            <div class="rankSection">
              <div class="rankCard2">
                <div class="rankTopBar">
                  <div class="rankTitleWrap">
                    <div class="rankMainTitle">今日榜单</div>
                  </div>
                </div>
                <div class="rankPanel">
                  <div class="rankRows">
                    <div v-if="rankLoading" class="rankEmpty">排行榜加载中...</div>
                    <template v-else-if="rankView.length">
                      <div
                        v-for="p in rankView"
                        :key="p.rk"
                        class="rankRow"
                        :class="{ me: p.isMe, top3: p.rk <= 3 }"
                      >
                        <span class="c rk">
                          <span class="rankNo" :class="`no${p.rk}`">{{ p.rk }}</span>
                        </span>
                        <span class="c u user">
                          <span v-if="p.avatarUrl" class="av avatarImgWrap">
                            <img
                              class="avatarImg"
                              :src="normalizeAvatar(p.avatarUrl)"
                              :alt="p.name"
                              @error="handleAvatarError(p)"
                            />
                          </span>
                          <span v-else class="av" :style="avatarStyle(p.name)">
                            {{ (p.name || '诗').slice(0, 1) }}
                          </span>
                          <span class="nameCol">
                            <span class="nm">{{ p.name }}</span>
                            <span class="userTag" v-if="p.rk <= 3">上榜</span>
                          </span>
                        </span>
                        <span class="c a">{{ p.acc }}</span>
                        <span class="c s">{{ p.score }}</span>
                      </div>
                    </template>
                    <div v-else class="rankEmpty">暂无排行榜数据</div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- 规则和赛季速览区域 -->
          <div class="ruleCard">
            <div class="ruleHead">
              <div>
                <div class="ruleTitle">赛季规则与奖励</div>
                <div class="ruleSub">本期公告 · 玩法说明 · 彩蛋提示</div>
              </div>
              <button class="btn ghost small" @click="viewRule">查看详情</button>
            </div>
            <ul class="ruleList">
              <li>飞花令：命中主题字入句得分；参与可积累梅花瓣。</li>
              <li>诗词接龙：承接上句起落，连续完成回合点亮龙纹。</li>
              <li>诗词趣消消：20句诗词拆成60个片段，放入6格槽位完成三片配对消除。</li>
              <li>韵脚迷阵：在汉字迷宫中按正确诗句顺序行走，点亮四句诗笺后通关。</li>
              <li>彩蛋：点击页面空白处收集诗句碎片，集齐可兑换特效称号。</li>
            </ul>
            <div class="statGrid statGrid5">
              <div class="stat"><div class="v">{{ liveJoin.toLocaleString() }}</div><div class="k">当前参与</div></div>
              <div class="stat"><div class="v">{{ shardGot }}/{{ shardTotal }}</div><div class="k">碎片收集</div></div>
              <div class="stat"><div class="v">{{ feihuaProgress }}%</div><div class="k">梅花积累</div></div>
              <div class="stat"><div class="v">{{ jielongProgress }}%</div><div class="k">龙纹点亮</div></div>
              <div class="stat"><div class="v">{{ mazeProgress }}%</div><div class="k">诗笺点亮</div></div>
            </div>
          </div>

          <div class="featureRow">
            <div class="overviewCard">
              <div class="overviewHead">
                <div>
                  <div class="overviewTitle">赛季速览</div>
                  <div class="overviewSub">本期进度 · 奖励目标 · 推荐入口</div>
                </div>
                <button class="btn ghost small" @click="enterSeason">查看赛季</button>
              </div>
              <div class="overviewGrid">
                <div class="overviewItem"><div class="overviewLabel">本期主题</div><div class="overviewValue">{{ seasonTheme }}</div></div>
                <div class="overviewItem"><div class="overviewLabel">赛季状态</div><div class="overviewValue">{{ seasonStatus }}</div></div>
                <div class="overviewItem"><div class="overviewLabel">推荐挑战</div><div class="overviewValue">韵脚迷阵</div></div>
                <div class="overviewItem"><div class="overviewLabel">当前热度</div><div class="overviewValue">{{ liveJoin.toLocaleString() }}</div></div>
              </div>
              <div class="taskList">
                <div class="taskRow">
                  <div class="taskText">
                    <div class="taskMain">完成 1 次飞花令</div>
                    <div class="taskSub">获得梅花碎片与赛季积分</div>
                  </div>
                  <button class="btn small" @click="goToGame('/game/feihualing')">前往</button>
                </div>
                <div class="taskRow">
                  <div class="taskText">
                    <div class="taskMain">完成 1 次诗词接龙</div>
                    <div class="taskSub">点亮龙纹进度，提升榜单表现</div>
                  </div>
                  <button class="btn small" @click="goToGame('/game/jielong')">前往</button>
                </div>
                <div class="taskRow">
                  <div class="taskText">
                    <div class="taskMain">完成 1 次趣消消挑战</div>
                    <div class="taskSub">闯关积分增长更快，适合冲榜</div>
                  </div>
                  <button class="btn small" @click="goToGame('/game/shici-match')">前往</button>
                </div>
                <div class="taskRow">
                  <div class="taskText">
                    <div class="taskMain">完成 1 次迷宫寻诗</div>
                    <div class="taskSub">点亮诗笺并解锁专属迷阵排行榜</div>
                  </div>
                  <button class="btn small" @click="goToGame('/game/maze')">前往</button>
                </div>
              </div>
            </div>
          </div>
        </section>

        <button class="forumBadge" @click="goToGame('/forum')" title="进入诗坛">
          <div class="fbInner">
            <div class="fbTitle">诗坛</div>
            <div class="fbSub">讨论 · 共创</div>
          </div>
          <span class="firefly f1"></span>
          <span class="firefly f2"></span>
          <span class="firefly f3"></span>
        </button>

        <div class="shards" aria-hidden="true">
          <button
            v-for="s in shardDots"
            :key="s.id"
            class="shard"
            :style="{ left: s.x + '%', top: s.y + '%', animationDelay: s.d + 's' }"
            @click="collectShard(s.id)"
            title="收集碎片"
          >
            <span class="shardIcon" :class="s.type"></span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref, onMounted, onBeforeUnmount, nextTick } from "vue";
import { useRouter, useRoute, onBeforeRouteLeave } from "vue-router";
import { getGameTotalRank } from "@/utils/api";

import bgTop1 from "@/assets/game/game-bg.jpg";
import rankBg6 from "@/assets/game/rank_bg_6.jpg";
import gameMapImage from "@/assets/game/game/gamebackend.jpg";

import cardFeihua from "@/assets/game/card_feihua.jpg";
import cardJielong from "@/assets/game/card_jielong.jpg";
import cardXiaoxiao from "@/assets/game/card_xiaoxiao.jpg";
import cardMaze from "@/assets/game/card_maze.jpg";
import cardQuiz from "@/assets/game/card_quiz.jpg";
import cardMoments from "@/assets/game/card_moments.jpg";

const router = useRouter();
const route = useRoute();

const GAME_RETURN_STATE_KEY = "gamePageReturnState";
const FEIHUA_RETURN_KEY = "feihua_return_state";
const SHICI_MATCH_RETURN_KEY = "shici_match_return_state";
const MAZE_RETURN_KEY = "maze_return_state";

// 游戏热点数据（对应地图上的建筑位置，调整y轴使其在建筑正上方）
const gameHotspots = ref([
  {
    id: 'feihua',
    name: '飞花令',
    desc: '主题字入句，命中诗句即得分',
    path: '/game/feihualing',
    position: { x: 15, y: 48 }, // 八达岭长城位置
    size: 100
  },
  {
    id: 'jielong',
    name: '诗词接龙',
    desc: '承接上句起落，句句相扣',
    path: '/game/jielong',
    position: { x: 35, y: 85 },
    size: 110
  },
  {
    id: 'xiaoxiao',
    name: '诗词趣消消',
    desc: '60个片段 · 限时挑战',
    path: '/game/shici-match',
    position: { x: 80, y: 65},
    size: 120
  },
  {
    id: 'maze',
    name: '韵脚迷阵',
    desc: '迷宫寻诗 · 点亮诗笺',
    path: '/game/maze',
    position: { x: 25, y: 65 },
    size: 110
  },
  {
    id: 'quiz',
    name: '文才评古',
    desc: '20题匹配诗人气质画像',
    path: '/game/poet-quiz',
    position: { x: 65, y: 48 }, // 对应建筑门口处
    size: 110
  },
  {
    id: 'moments',
    name: '诗友圈',
    desc: '片言知墨客 · 诗友交流',
    path: '/game/poet-moments',
    position: { x: 60, y: 86 }, // 门的正中心处，向左微调
    size: 120
  }
]);

const activeHotspot = ref(null);
const clickedHotspot = ref(null);

const go = (path) => {
  if (path) router.push(path);
};

const goToGame = (path) => {
  if (!path) return;
  saveGamePageState();
  saveSubGameReturnState(path);
  router.push(path);
};

function getHotspotStyle(game) {
  return {
    left: `${game.position.x}%`,
    top: `${game.position.y}%`,
    width: `${game.size}px`,
    transform: 'translate(-50%, -50%)'
  };
}

const cardImages = ref({
  feihua: cardFeihua,
  jielong: cardJielong,
  xiaoxiao: cardXiaoxiao,
  maze: cardMaze,
  quiz: cardQuiz,
  moments: cardMoments,
});

const gameWrapper = ref(null);
const gameMapContainer = ref(null);

function getScrollContainer() {
  let el = gameWrapper.value;

  while (el && el.parentElement) {
    el = el.parentElement;
    const style = window.getComputedStyle(el);
    const overflowY = style.overflowY;

    if (
      (overflowY === "auto" || overflowY === "scroll") &&
      el.scrollHeight > el.clientHeight
    ) {
      return el;
    }
  }

  return document.scrollingElement || document.documentElement || document.body;
}

function getCurrentScrollTop() {
  const scroller = getScrollContainer();
  return scroller?.scrollTop || 0;
}

function buildCurrentPageState() {
  const gameWrapperTop = gameWrapper.value?.offsetTop ?? window.innerHeight;

  return {
    path: route.path,
    fullPath: route.path,
    scrollTop: getCurrentScrollTop(),
    gameWrapperTop,
    time: Date.now(),
  };
}

function saveGamePageState() {
  const state = buildCurrentPageState();
  sessionStorage.setItem(GAME_RETURN_STATE_KEY, JSON.stringify(state));
}

function saveFeihuaReturnState() {
  const state = buildCurrentPageState();
  sessionStorage.setItem(FEIHUA_RETURN_KEY, JSON.stringify(state));
}

function saveSubGameReturnState(path) {
  if (typeof path !== "string") return;

  if (path.includes("feihua")) {
    saveFeihuaReturnState();
    return;
  }

  if (path.includes("shici-match")) {
    saveShiciMatchReturnState();
    return;
  }

  if (path.includes("maze")) {
    saveMazeReturnState();
  }
}
function saveShiciMatchReturnState() {
  const state = buildCurrentPageState();
  sessionStorage.setItem(SHICI_MATCH_RETURN_KEY, JSON.stringify(state));
}

function saveMazeReturnState() {
  const state = buildCurrentPageState();
  sessionStorage.setItem(MAZE_RETURN_KEY, JSON.stringify(state));
}

function readGamePageState() {
  try {
    const raw = sessionStorage.getItem(GAME_RETURN_STATE_KEY);
    if (!raw) return null;
    return JSON.parse(raw);
  } catch (error) {
    console.error("读取游戏页返回状态失败", error);
    return null;
  }
}

function clearGamePageState() {
  sessionStorage.removeItem(GAME_RETURN_STATE_KEY);
}

function restoreGamePageState() {
  const saved = readGamePageState();
  console.log("restoreGamePageState saved =", saved);
  console.log("当前 query =", route.query);

  if (!saved) return;

  const fromSubGame =
    route.query.restoreGame === "1" ||
    route.query.restoreFeihua === "1" ||
    route.query.restoreJielong === "1" ||
    route.query.restoreMaze === "1";

  if (!fromSubGame && saved.path !== route.path) return;

  nextTick(() => {
    const targetTop =
      typeof saved.scrollTop === "number" && saved.scrollTop > 0
        ? saved.scrollTop
        : saved.gameWrapperTop || gameWrapper.value?.offsetTop || window.innerHeight;

    console.log("准备恢复滚动到 =", targetTop);

    setTimeout(() => {
      const scroller = getScrollContainer();
      scroller.scrollTop = targetTop;

      setTimeout(() => {
        scroller.scrollTop = targetTop;
        console.log("实际滚动位置 =", scroller.scrollTop);
      }, 120);
    }, 160);

    clearGamePageState();

    if (
      route.query.restoreGame ||
      route.query.restoreFeihua ||
      route.query.restoreJielong ||
      route.query.restoreMaze
    ) {
      window.history.replaceState({}, "", route.path);
    }
  });
}

onBeforeRouteLeave((to) => {
  if (to.path.startsWith("/game/") && to.path !== route.path) {
    saveGamePageState();
  }
});

const seasonTheme = ref("雪");
const seasonStatus = ref("进行中");
const liveJoin = ref(13410);
const shardTotal = ref(12);
const shardGot = ref(1);
const feihuaProgress = ref(31);
const jielongProgress = ref(48);
const battleProgress = ref(22);
const mazeProgress = ref(16);

const rank = ref([]);
const rankLoading = ref(false);
const rankTab = ref("rank");
const rankView = computed(() => rank.value);

async function loadRank() {
  rankLoading.value = true;
  try {
    const res = await getGameTotalRank();
    const list = res?.data || [];
    rank.value = (Array.isArray(list) ? list : []).map((item, index) => ({
      rk: index + 1,
      name: item.nickname || item.username || `用户${index + 1}`,
      acc: item.correctCount ?? 0,
      score: item.totalScore ?? 0,
      isMe: false,
      avatarUrl: item.avatarUrl || "",
      userId: item.userId || null,
    }));
  } catch (e) {
    console.error("加载总排行榜失败", e);
    rank.value = [];
  } finally {
    rankLoading.value = false;
  }
}

const enterSeason = () => go("/season");
const startFeihua = () => goToGame("/game/feihualing");
const startJielong = () => goToGame("/game/jielong");
const viewBattle = () => go("/game/shici-match");
const startBattle = () => goToGame("/game/shici-match");
const viewMaze = () => go("/game/maze");
const startMaze = () => goToGame("/game/maze");
const viewRule = () => go("/game/maze");
const viewAllRank = () => go("/season");

const scrollToSection = (className) => {
  const element = document.querySelector(`.${className}`);
  if (element) {
    element.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }
};

const cardBgStyle = (imgUrl) => {
  if (!imgUrl) return {};
  return {
    "--card-img": `url(${imgUrl})`,
  };
};

const pageBg = (img) => ({ "--page-bg": `url(${img})` });
const panelBg = (img) => ({ "--panel-bg": `url(${img})` });

const avatarStyle = (name) => {
  const n = (name && name.charCodeAt(0)) || 65;
  const a = (n % 360 + 360) % 360;
  return {
    background: `linear-gradient(180deg, hsla(${a}, 55%, 78%, .95), hsla(${a}, 55%, 62%, .95))`,
  };
};

function normalizeAvatar(url) {
  if (!url) return "";
  if (url.startsWith("http://") || url.startsWith("https://")) return url;
  return url.startsWith("/") ? url : `/${url}`;
}

function handleAvatarError(item) {
  item.avatarUrl = "";
}

const shardDots = ref([
  { id: 1, x: 18, y: 72, d: 0.2, type: "snow" },
  { id: 2, x: 36, y: 82, d: 1.4, type: "plum" },
  { id: 3, x: 62, y: 68, d: 0.8, type: "boat" },
  { id: 4, x: 78, y: 78, d: 1.1, type: "moon" },
  { id: 5, x: 44, y: 62, d: 0.5, type: "snow" },
  { id: 6, x: 10, y: 86, d: 1.8, type: "plum" },
]);

const collectShard = (id) => {
  shardGot.value = Math.min(shardTotal.value, shardGot.value + 1);
  shardDots.value = shardDots.value.filter((s) => s.id !== id);
};

onMounted(() => {
  loadRank();
  restoreGamePageState();
});

onBeforeUnmount(() => {
});
</script>

<style scoped>
.gamePage {
  position: relative;
  min-height: 100vh;
  overflow-x: hidden;
  scroll-behavior: smooth;
}

/* ========== 复古宣纸导航栏 ========== */
.retro-navbar {
  position: sticky;
  top: 0;
  z-index: 100;
  width: 100%;
  height: 60px;
  background-color: #f4ecd8; /* 宣纸色 */
  background-image: radial-gradient(circle at 50% 50%, rgba(0,0,0,0.02) 0%, transparent 80%);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  border-bottom: 1px solid rgba(139, 69, 19, 0.15);
  display: flex;
  justify-content: center;
  align-items: center;
}

.nav-content {
  display: flex;
  align-items: center;
  gap: 40px;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 40px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.nav-text {
  font-family: "STKaiti", "楷体", "KaiTi", serif;
  font-size: 20px;
  font-weight: bold;
  color: #5d4037;
  letter-spacing: 2px;
  position: relative;
}

.nav-text::after {
  content: "";
  position: absolute;
  bottom: -4px;
  left: 0;
  width: 0;
  height: 2px;
  background-color: #8b4513;
  transition: width 0.3s ease;
}

.nav-item:hover .nav-text {
  color: #8b4513;
}

.nav-item:hover .nav-text::after {
  width: 100%;
}

.nav-dot {
  width: 6px;
  height: 6px;
  background-color: #8b4513;
  border-radius: 50%;
  opacity: 0.3;
}

/* ========== 第二屏包装器 ========== */
.game-wrapper {
  width: 100%;
}

.gamePageInner {
  position: relative;
  min-height: 100vh;
  padding-bottom: 90px;
  --wrap: min(1560px, calc(100% - 24px));
  background-image: var(--page-bg);
  background-size: cover;
  background-position: center;
  background-attachment: fixed;
  background-repeat: no-repeat;
}

.mainGrid,
.forumBadge {
  position: relative;
  z-index: 1;
}

.btn {
  height: 28px;
  padding: 0 12px;
  border-radius: 999px;
  border: 1px solid rgba(0, 0, 0, 0.1);
  background: rgba(255, 255, 255, 0.75);
  font-weight: 1000;
  font-size: 12px;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.btn:hover {
  transform: translateY(-1px);
  background: rgba(255, 255, 255, 0.92);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  border-color: rgba(0, 0, 0, 0.15);
}

.btn:active {
  transform: translateY(0);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.btn.ghost {
  background: rgba(255, 255, 255, 0.45);
}

.btn.ghost:hover {
  background: rgba(255, 255, 255, 0.65);
}

.btn.small {
  height: 24px;
  padding: 0 10px;
  font-weight: 900;
  font-size: 11px;
}

.mainGrid {
  width: var(--wrap);
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.gamesSection {
  flex: 1;
  min-width: 0;
}

.cardsWithRank {
  display: flex;
  gap: 16px;
  align-items: stretch;
}

.rankSection {
  width: 380px;
  flex-shrink: 0;
  position: sticky;
  top: 80px;
  align-self: flex-start;
  display: flex;
}

.gamesSection {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-height: 0;
  overflow-y: auto;
}

.scrollGrid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 14px;
  margin: 0;
  padding: 0;
}

.scrollGrid4 {
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 14px;
}

/* ========== 第一屏：游戏地图区域 ========== */
.game-map-section {
  position: relative;
  width: 100%;
  height: calc(100vh - 80px);
}

.game-map-container {
  position: relative;
  width: 100%;
  height: 100%;
  overflow: hidden;
}

/* 标题样式 */
.game-title {
  position: absolute;
  top: 25px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 20;
}

.title-text {
  font-size: 48px;
  font-weight: 800;
  font-family: "KaiTi", "楷体", "STKaiti", serif;
  letter-spacing: 20px;
  color: #333333;
}

.game-map-bg {
  position: absolute;
  inset: 0;
  background-size: cover;
  background-position: center;
  transition: transform 0.5s ease;
}

.game-map-container:hover .game-map-bg {
  transform: scale(1.02);
}

/* ========== 书卷样式游戏入口 ========== */
.game-scroll-entrance {
  position: absolute;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 10;
  height: 36px; /* 固定高度，装得下字体 */
  /* 不要在这里绑定动画了，我们将浮动效果交给内部的 wrapper 容器，或者优化动画触发机制 */
  /* 入场动画使用 animation，但是保持最终状态 forwards */
  animation: scrollFadeIn 0.8s cubic-bezier(0.4, 0, 0.2, 1) forwards;
  opacity: 0;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.2));
}

/* 创建一个专门负责浮动和悬停效果的内部包裹层 */
.scroll-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  width: 100%;
  animation: scrollFloat 3s ease-in-out infinite alternate;
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  transform-origin: center center;
}

@keyframes scrollFadeIn {
  from {
    opacity: 0;
    transform: translate(-50%, -30%) scale(0.8);
  }
  to {
    opacity: 1;
    transform: translate(-50%, -50%) scale(1);
  }
}

/* 持续上下浮动动画 (相对于自身不再带 translate(-50%, -50%)) */
@keyframes scrollFloat {
  0% {
    transform: translateY(-4px);
  }
  100% {
    transform: translateY(4px);
  }
}

.game-scroll-entrance:hover {
  z-index: 20;
}

.game-scroll-entrance:hover .scroll-wrapper,
.game-scroll-entrance.active .scroll-wrapper {
  animation-play-state: paused;
  transform: translateY(0) scale(1.15);
  filter: drop-shadow(0 8px 16px rgba(139, 119, 101, 0.3));
}

.game-scroll-entrance.clicked .scroll-wrapper {
  animation-play-state: paused;
  transform: translateY(0) scale(1.2);
  filter: brightness(1.1) drop-shadow(0 0 15px rgba(139, 119, 101, 0.4));
}

/* 书轴（卷轴杆）- 古风深黄纸感 */
.scroll-rod {
  width: 10px;
  height: 130%;
  background: linear-gradient(to right, #b5a078, #c9b58a, #b5a078);
  border-radius: 5px;
  box-shadow: 1px 1px 4px rgba(139, 109, 60, 0.5);
  z-index: 2;
  position: relative;
}



.rod-left {
  margin-right: -3px;
}

.rod-right {
  margin-left: -3px;
}

/* 书卷主体 */
.scroll-body {
  height: 100%;
  padding: 0 20px;
  background: linear-gradient(to bottom, #e8d5b7 0%, #d4c4a8 30%, #c9b99a 50%, #d4c4a8 70%, #e8d5b7 100%);
  border-top: 2px solid rgba(181, 160, 120, 0.4);
  border-bottom: 2px solid rgba(181, 160, 120, 0.4);
  border-left: 1px solid rgba(181, 160, 120, 0.2);
  border-right: 1px solid rgba(181, 160, 120, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 70px;
  box-shadow: 
    inset 0 2px 6px rgba(181, 160, 120, 0.2),
    inset 0 -2px 6px rgba(181, 160, 120, 0.1);
  position: relative;
  z-index: 1;
}

.scroll-body::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(to bottom, rgba(139, 119, 101, 0.15), transparent);
}

.scroll-body::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(to top, rgba(139, 119, 101, 0.15), transparent);
}

.scroll-text {
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  font-size: 15px;
  font-weight: bold;
  color: #5d4037;
  white-space: nowrap;
  letter-spacing: 1px;
  transition: color 0.3s ease;
}

.game-scroll-entrance:hover .scroll-text,
.game-scroll-entrance.active .scroll-text {
  color: #8b5a2b;
  text-shadow: 0 0 8px rgba(139, 90, 43, 0.3);
}

/* 悬停提示卡片 */
.hotspot-tooltip {
  position: absolute;
  top: calc(100% + 12px);
  left: 50%;
  transform: translateX(-50%) translateY(10px);
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(8px);
  border: 1px solid rgba(139, 69, 19, 0.2);
  border-radius: 8px;
  padding: 8px 12px;
  min-width: 140px;
  opacity: 0;
  visibility: hidden;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  pointer-events: none;
  z-index: 100;
  text-align: center;
}

.game-scroll-entrance:hover .hotspot-tooltip,
.game-scroll-entrance.active .hotspot-tooltip {
  opacity: 1;
  visibility: visible;
  transform: translateX(-50%) translateY(0);
}

.tooltip-desc {
  font-size: 12px;
  color: #5d4037;
  line-height: 1.4;
  font-weight: 500;
}

.hotspot-tooltip::after {
  content: '';
  position: absolute;
  bottom: 100%;
  left: 50%;
  transform: translateX(-50%);
  border-width: 6px;
  border-style: solid;
  border-color: transparent transparent rgba(255, 255, 255, 0.95) transparent;
}

.map-overlay {
  position: absolute;
  inset: 0;
  background: 
    radial-gradient(circle at 30% 20%, rgba(255, 255, 255, 0.15) 0%, transparent 30%),
    radial-gradient(circle at 70% 80%, rgba(255, 255, 255, 0.1) 0%, transparent 25%);
  pointer-events: none;
}

/* 游戏卡片样式 - 上部图片，下部白色文字区域 */
.game-card {
  position: relative;
  border-radius: 0 !important;
  overflow: hidden;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  cursor: pointer;
  margin: 0;
  display: flex;
  flex-direction: column;
  background: #f5f0e8;
  height: 100%;
}

.game-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 16px 32px rgba(0, 0, 0, 0.15);
  z-index: 5;
}

/* 图片区域 - 固定高度比例 */
.card-image-area {
  aspect-ratio: 16 / 9;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  background-color: #f5f0e8;
  flex-shrink: 0;
}

/* 将背景图片应用到图片区域 */
.game-card .card-image-area {
  background-image: var(--card-img);
}

/* 文字覆盖层 - 白色背景，紧凑布局 */
.card-overlay {
  position: relative;
  z-index: 2;
  padding: 6px;
  background: white;
  width: 100%;
  border-radius: 0 !important;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

/* 文字颜色改为黑色 */
.game-card .scrollTitle,
.game-card .scrollSub,
.game-card .tag,
.game-card .btnRow .btn,
.game-card .seal {
  color: #333 !important;
  text-shadow: none;
}

/* 印章样式调整 */
.game-card .seal {
  background: rgba(0, 0, 0, 0.08);
  border-radius: 50%;
  color: #666 !important;
  width: 24px;
  height: 24px;
  font-size: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

/* 标签样式 */
.game-card .tag {
  background: rgba(0, 0, 0, 0.06);
  color: #555 !important;
  height: 14px;
  padding: 0 4px;
  font-size: 7px;
}

.game-card .tag.soft {
  background: rgba(0, 0, 0, 0.04);
}

/* 按钮样式调整 */
.game-card .btn {
  background: #f0f0f0;
  color: #333;
  border: 1px solid #ddd;
  padding: 3px 6px;
  font-size: 10px;
}

.game-card .btn.ghost {
  background: transparent;
  color: #666;
  border: 1px solid #ccc;
  padding: 3px 6px;
  font-size: 10px;
}

.game-card .btn.ghost:hover {
  background: rgba(0, 0, 0, 0.05);
}

.scrollTop {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 4px;
  margin-bottom: 2px;
}

.scrollTitle {
  font-size: 12px;
  font-weight: 1000;
  color: #333;
  line-height: 1.1;
}

.scrollSub {
  opacity: 0.7;
  margin-top: 1px;
  font-weight: 700;
  font-size: 7px;
  color: #666;
  line-height: 1.2;
}

.tagRow {
  margin-bottom: 4px;
  display: flex;
  gap: 2px;
  flex-wrap: wrap;
}

.tag {
  height: 14px;
  padding: 0 4px;
  display: inline-flex;
  align-items: center;
  border-radius: 999px;
  font-weight: 900;
  font-size: 7px;
}

.btnRow {
  margin-top: 4px;
  display: flex;
  gap: 3px;
}

/* 确保所有卡片高度一致，内容紧凑 */
.scrollCard {
  height: 100%;
  display: flex;
  flex-direction: column;
}

/* 移除浮动画效果 */
.game-card {
  animation: none !important;
}

.ruleCard {
  width: 100%;
  border-radius: 0;
  border: 1px solid rgba(181, 160, 120, 0.4);
  background: #f0e8d8;
  box-shadow: 0 18px 50px rgba(0, 0, 0, 0.1), 0 6px 16px rgba(0, 0, 0, 0.05);
  padding: 20px 18px 24px;
}

.ruleHead {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
}

.ruleTitle {
  font-weight: 1000;
  font-size: 16px;
}

.ruleSub {
  opacity: 0.7;
  font-weight: 700;
  margin-top: 4px;
  font-size: 12px;
}

.ruleList {
  margin: 12px 0 0;
  padding-left: 18px;
  opacity: 0.82;
  line-height: 1.9;
  font-weight: 700;
}

.statGrid {
  margin-top: 12px;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 10px;
}

.statGrid5 {
  grid-template-columns: repeat(5, 1fr);
}

.stat {
  border-radius: 16px;
  border: 1px solid rgba(181, 160, 120, 0.3);
  background: linear-gradient(145deg, #e8d5b7 0%, #d4c4a8 100%);
  box-shadow: 
    0 2px 4px rgba(181, 160, 120, 0.2),
    inset 0 1px 0 rgba(255, 255, 255, 0.6);
  padding: 16px;
}

.stat .v {
  font-weight: 1000;
  font-size: 16px;
}

.stat .k {
  opacity: 0.7;
  font-weight: 800;
  font-size: 12px;
  margin-top: 4px;
}

.featureRow {
  width: 100%;
  display: grid;
  grid-template-columns: 1fr;
  gap: 14px;
}

.overviewCard {
  border-radius: 0;
  border: 1px solid rgba(181, 160, 120, 0.4);
  background: #f0e8d8;
  box-shadow: 0 18px 50px rgba(0, 0, 0, 0.12), 0 6px 16px rgba(0, 0, 0, 0.06);
  padding: 16px;
  overflow: hidden;
  position: relative;
}

.overviewHead {
  position: relative;
  z-index: 2;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
}

.overviewTitle {
  font-weight: 1000;
  font-size: 16px;
}

.overviewSub {
  opacity: 0.7;
  font-weight: 800;
  margin-top: 4px;
  font-size: 12px;
}

.overviewGrid {
  position: relative;
  z-index: 2;
  margin-top: 12px;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
}

.overviewItem {
  padding: 8px 0;
}

.overviewLabel {
  font-size: 12px;
  font-weight: 800;
  opacity: 0.68;
}

.overviewValue {
  margin-top: 6px;
  font-size: 18px;
  font-weight: 1000;
}

.taskList {
  position: relative;
  z-index: 2;
  margin-top: 12px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.taskRow {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 10px 0;
  border-bottom: 1px solid #333;
}

.taskRow:last-child {
  border-bottom: none;
}

.taskMain {
  font-weight: 1000;
}

.taskSub {
  margin-top: 4px;
  font-size: 12px;
  opacity: 0.7;
  font-weight: 700;
}



.rankCard2 {
  border-radius: 0;
  border: 1px solid rgba(200, 190, 165, 0.4);
  background: linear-gradient(180deg, #faf8f2 0%, #f5f0e8 50%, #f0ebe0 100%); /* 浅色宣纸渐变 */
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.06), 0 3px 8px rgba(0, 0, 0, 0.03);
  padding: 16px;
  overflow: hidden;
  position: relative;
  display: flex;
  flex-direction: column;
  height: 640px;
  min-height: 640px;
  max-height: 640px;
}

/* 移除覆盖层，保持纯宣纸色 */
.rankCard2::after {
  display: none;
}

.rankTopBar {
  position: relative;
  z-index: 2;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 10px;
  border-bottom: 1px solid rgba(200, 190, 165, 0.3);
  padding-bottom: 10px;
}

.rankTitleWrap {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.rankMainTitle {
  font-size: 18px;
  font-weight: 1000;
  color: #5d4f3d; /* 浅墨色 */
}

.rankBadge {
  position: relative;
  z-index: 2;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 6px 12px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.6);
  border: 1px solid rgba(200, 190, 165, 0.3);
  font-weight: 900;
  font-size: 11px;
  color: #6b5f4d;
}

.rankPanel {
  position: relative;
  z-index: 2;
  margin-top: 10px;
  display: flex;
  flex-direction: column;
  flex: 1;
  min-height: 0;
  overflow: hidden;
}

.rankHeader {
  display: grid;
  grid-template-columns: 44px minmax(0, 1fr) 60px 60px;
  gap: 10px;
  padding: 12px 14px;
  font-weight: 1000;
  opacity: 0.65;
  font-size: 13px;
  border-bottom: 1px solid rgba(200, 190, 165, 0.3);
  color: #6b5f4d;
}

.rankRows {
  height: 100%;
  min-height: 0;
  overflow-y: auto;
  overflow-x: hidden;
  padding: 10px 0;
  scroll-behavior: smooth;
  -webkit-overflow-scrolling: touch;
}

.rankRows::-webkit-scrollbar {
  width: 6px;
}

.rankRows::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.03);
  border-radius: 999px;
}

.rankRows::-webkit-scrollbar-thumb {
  background: rgba(0, 0, 0, 0.15);
  border-radius: 999px;
}

.rankRows::-webkit-scrollbar-thumb:hover {
  background: rgba(0, 0, 0, 0.25);
}

.rankRow {
  display: grid;
  grid-template-columns: 44px minmax(0, 1fr) 60px 60px;
  gap: 10px;
  align-items: center;
  padding: 12px 14px;
  background: transparent;
  border-bottom: 1px solid rgba(200, 190, 165, 0.2);
  margin-bottom: 0;
  color: #6b5f4d;
}

.rankRow.me {
  background: rgba(255, 255, 255, 0.4);
  border-color: rgba(200, 190, 165, 0.3);
}

.c {
  font-weight: 1000;
}

.c.s {
  text-align: right;
  color: rgba(150, 120, 60, 0.8);
}

.c.a {
  text-align: right;
  opacity: 0.55;
}

.user {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  min-width: 0;
}

.av {
  width: 32px;
  height: 32px;
  border-radius: 999px;
  display: grid;
  place-items: center;
  color: #6b5f4d;
  font-weight: 1000;
  border: 1px solid rgba(200, 190, 165, 0.4);
  background: rgba(255, 255, 255, 0.6);
  flex-shrink: 0;
}

.avatarImgWrap {
  overflow: hidden;
  padding: 0;
  background: #f3f3f3;
}

.avatarImg {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.nameCol {
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.nm {
  font-weight: 1000;
  font-size: 14px;
  line-height: 1.25;
  word-break: break-all;
}

.userTag {
  display: inline-flex;
  width: fit-content;
  padding: 2px 8px;
  border-radius: 999px;
  background: rgba(180, 160, 130, 0.15);
  border: 1px solid rgba(180, 160, 130, 0.25);
  font-size: 11px;
  font-weight: 900;
  color: #7a6a5a;
}

.rankNo {
  display: inline-flex;
  width: 28px;
  height: 28px;
  border-radius: 999px;
  align-items: center;
  justify-content: center;
  background: transparent;
  font-size: 13px;
  color: #6b5f4d;
}

.rankNo.no1 { color: #c97b9a; font-weight: 1000; }
.rankNo.no2 { color: #d4a06a; font-weight: 1000; }
.rankNo.no3 { color: #dcc86a; font-weight: 1000; }

.rankEmpty {
  padding: 20px 12px;
  text-align: center;
  color: rgba(0, 0, 0, 0.5);
  font-weight: 800;
}

.forumBadge {
  position: fixed;
  left: 18px;
  bottom: 18px;
  width: 92px;
  height: 92px;
  border-radius: 999px;
  border: 1px solid rgba(0, 0, 0, 0.08);
  background: rgba(255, 255, 255, 0.62);
  box-shadow: 0 18px 44px rgba(0, 0, 0, 0.12);
  cursor: pointer;
  backdrop-filter: blur(12px);
  z-index: 60;
}

.fbInner {
  position: absolute;
  inset: 10px;
  border-radius: 999px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  gap: 4px;
}

.fbTitle {
  font-weight: 1000;
}

.fbSub {
  opacity: 0.72;
  font-weight: 800;
  font-size: 12px;
}

.firefly {
  position: absolute;
  width: 10px;
  height: 10px;
  border-radius: 999px;
  background: rgba(255, 200, 120, 0.78);
  box-shadow: 0 0 0 8px rgba(255, 200, 120, 0.14);
  opacity: 0.65;
}

.f1 {
  left: 6px;
  top: 16px;
  animation: fly 3.8s ease-in-out infinite;
}

.f2 {
  right: 12px;
  top: 44px;
  animation: fly 4.6s ease-in-out infinite;
}

.f3 {
  left: 44px;
  bottom: 8px;
  animation: fly 4.2s ease-in-out infinite;
}

@keyframes fly {
  0%, 100% { transform: translate(0, 0); opacity: 0.55; }
  50% { transform: translate(6px, -8px); opacity: 0.85; }
}

.shards {
  position: absolute;
  inset: 0;
  pointer-events: none;
}

.shard {
  pointer-events: auto;
  position: absolute;
  width: 42px;
  height: 42px;
  border-radius: 999px;
  border: 1px solid rgba(0, 0, 0, 0.08);
  background: rgba(255, 255, 255, 0.52);
  backdrop-filter: blur(10px);
  box-shadow: 0 14px 30px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  animation: shardFloat 5.6s ease-in-out infinite;
}

@keyframes shardFloat {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-8px); }
}

.shardIcon {
  display: block;
  width: 100%;
  height: 100%;
  position: relative;
}

.shardIcon.snow::before {
  content: "";
  position: absolute;
  inset: 12px;
  border-radius: 999px;
  background:
    radial-gradient(circle at 50% 50%, rgba(120, 170, 210, 0.55), transparent 60%),
    conic-gradient(from 0deg, rgba(120, 170, 210, 0.55), rgba(120, 170, 210, 0.12), rgba(120, 170, 210, 0.55));
  mask: radial-gradient(circle, transparent 35%, #000 36%);
  opacity: 0.85;
}

.shardIcon.plum::before {
  content: "";
  position: absolute;
  left: 50%;
  top: 50%;
  width: 18px;
  height: 18px;
  transform: translate(-50%, -50%);
  background: radial-gradient(circle, rgba(220, 120, 140, 0.75), rgba(220, 120, 140, 0.18));
  border-radius: 999px;
  box-shadow:
    -10px 0 0 rgba(220, 120, 140, 0.55),
    10px 0 0 rgba(220, 120, 140, 0.55),
    0 -10px 0 rgba(220, 120, 140, 0.55),
    0 10px 0 rgba(220, 120, 140, 0.55);
  opacity: 0.9;
}

.shardIcon.boat::before {
  content: "";
  position: absolute;
  left: 50%;
  top: 52%;
  width: 22px;
  height: 12px;
  transform: translate(-50%, -50%);
  border-radius: 0 0 14px 14px;
  background: rgba(110, 140, 150, 0.55);
}

.shardIcon.boat::after {
  content: "";
  position: absolute;
  left: 52%;
  top: 34%;
  width: 12px;
  height: 18px;
  transform: translate(-50%, -50%);
  border-radius: 2px;
  background: rgba(110, 140, 150, 0.35);
}

.shardIcon.moon::before {
  content: "";
  position: absolute;
  left: 50%;
  top: 50%;
  width: 18px;
  height: 18px;
  transform: translate(-50%, -50%);
  border-radius: 999px;
  background: rgba(240, 220, 170, 0.75);
  box-shadow: 0 0 0 8px rgba(240, 220, 170, 0.14);
}

@media (max-width: 1200px) {
  .scrollGrid,
  .scrollGrid4 {
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
  }

  .statGrid5 {
    grid-template-columns: repeat(3, 1fr);
  }

  .hotspot-icon {
    font-size: 20px;
  }
}

@media (max-width: 1100px) {
  .cardsWithRank {
    flex-direction: column;
  }

  .rankSection {
    width: 100%;
    position: static;
  }
}

@media (max-width: 768px) {
  .gamesSection {
    width: 100%;
    max-width: none;
  }

  .scrollGrid,
  .scrollGrid4 {
    grid-template-columns: 1fr;
    gap: 12px;
  }

  .statGrid,
  .statGrid5 {
    grid-template-columns: repeat(2, 1fr);
  }

  .rankCard2 {
    height: auto;
    max-height: none;
    min-height: auto;
  }

  .overviewGrid {
    grid-template-columns: 1fr;
  }

  .game-map-container {
    aspect-ratio: 4 / 3;
    border-radius: 16px;
  }

  .hotspot-icon {
    font-size: 16px;
  }

  .hotspot-tooltip {
    min-width: 140px;
    padding: 8px 12px;
  }

  .tooltip-title {
    font-size: 14px;
  }

  .tooltip-desc {
    font-size: 10px;
  }
}

@media (max-width: 560px) {
  .ribbonInner {
    padding: 12px 14px;
  }

  .rankHeader,
  .rankRow {
    grid-template-columns: 32px minmax(0, 1fr) 48px 48px;
    gap: 6px;
  }

  .av {
    width: 30px;
    height: 30px;
  }

  .nm {
    font-size: 11px;
  }

  .taskRow {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>