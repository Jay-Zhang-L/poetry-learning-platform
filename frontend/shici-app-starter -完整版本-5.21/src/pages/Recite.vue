<template>
  <div class="recitePage" :style="paperStyle">
    <section class="topRibbon">
   <div class="ribbonBg"></div>
      <div class="ribbonMask"></div>

      <div class="ribbonInner ribbonLayout">
        <div class="ribbonTopLeft">
          <div class="metaRow">
          
          </div>
          <div class="metaRow actionRow">
            <button class="btn primary recording-btn" @click="goToRecordingPage">
              开始录音朗诵
            </button>
            <button class="btn ghost recording-btn" @click="goToRecordingHistory">
              查看录音记录
            </button>
          </div>
        </div>

        <div class="ribbonHero">
          <div class="ribbonTitle">朗诵练习</div>
          <div class="ribbonSub">音频跟读 · 专题鉴赏 · 视频示范</div>
        </div>

        <div class="ribbonBottomRight">
          <div class="ribbonActions">
            
            <div class="hotBadge">
              <span class="dot"></span>
             
            </div>
          </div>
        </div>
      </div>

      <div class="poemMarquee" aria-hidden="true">
        <div class="poemTrack">
          <span v-for="(p, i) in marqueeTexts" :key="i" class="poemItem">{{ p }}</span>
          <span v-for="(p, i) in marqueeTexts" :key="'b' + i" class="poemItem">{{ p }}</span>
        </div>
      </div>
    </section>

    <section class="mainWrap">
      <div class="audioHubCard">
        <div class="hubTop">

          <div class="searchPill">
            <span class="sIcon">⌕</span>
            <input
  class="sIpt"
  v-model="hubKeyword"
  @input="doSearch"
  placeholder="搜索作品名 / 专题名"/>
          </div>
        </div>

        <div class="hubTabs">
          <button
            v-for="t in hubTabs"
            :key="t.key"
            class="hubTab"
            :class="{ active: hubTab === t.key }"
            @click="switchHubTab(t.key)"
          >
            {{ t.label }}
          </button>
        </div>

        <div v-if="hubTab === 'mine'" class="mineSubTabs">
          <button
            class="mineSubTab"
            :class="{ active: mineTab === 'playlist' }"
            @click="switchMineTab('playlist')"
          >
            收藏诗单
          </button>
          <button
            class="mineSubTab"
            :class="{ active: mineTab === 'audio' }"
            @click="switchMineTab('audio')"
          >
            收藏音频
          </button>
          <button
            class="mineSubTab"
            :class="{ active: mineTab === 'video' }"
            @click="switchMineTab('video')"
          >
            收藏视频
          </button>
        </div>

        <div v-if="hubTab === 'recent'" class="mineSubTabs">
          <button
            class="mineSubTab"
            :class="{ active: recentTab === 'playlist' }"
            @click="switchRecentTab('playlist')"
          >
            最近诗单
          </button>
          <button
            class="mineSubTab"
            :class="{ active: recentTab === 'audio' }"
            @click="switchRecentTab('audio')"
          >
            最近音频
          </button>
          <button
            class="mineSubTab"
            :class="{ active: recentTab === 'video' }"
            @click="switchRecentTab('video')"
          >
            最近视频
          </button>
        </div>

        <div class="hubSecHead">
          <div class="secTitle">{{ hubSectionTitle }}</div>
          <button class="moreBtn" @click="goHubMore">更多</button>
        </div>

        <div v-if="hubKeyword.trim()" class="search-result-box">
  <div v-if="searchAudios.length">
    <div class="colTitle">音频结果</div>
    <div class="songRow" v-for="item in searchAudios" :key="'audio-' + item.id" @click="playSong(item)">
      <div class="songMain">
        <div class="songName">{{ item.title }}</div>
        <div class="songMeta">{{ item.subtitle || '朗诵音频' }}</div>
      </div>
      <div class="songActions">
        <button class="rowIconBtn solid" @click.stop="playSong(item)">▶</button>
      </div>
    </div>
  </div>

  <div v-if="searchVideos.length" style="margin-top: 14px">
    <div class="colTitle">视频结果</div>
    <div class="songRow" v-for="item in searchVideos" :key="'video-' + item.id" @click="playVideo(item)">
      <div class="songMain">
        <div class="songName">{{ item.title }}</div>
        <div class="songMeta">{{ item.author || '朗诵视频' }}</div>
      </div>
      <div class="songActions">
        <button class="rowIconBtn solid" @click.stop="playVideo(item)">▶</button>
      </div>
    </div>
  </div>

  <div v-if="!searchAudios.length && !searchVideos.length" class="emptyBox">暂无搜索结果</div>
</div>

<div class="playlistGrid" v-if="!hubKeyword.trim() && showPlaylistGrid">
          <div
            class="plist"
            v-for="p in filteredHubList"
            :key="p.id"
            @click="openPlaylist(p)"
          >
            <div class="plistCover" :style="bgImg(p.cover || defaultCover)">
              <div class="coverShade" aria-hidden="true"></div>

              <template v-if="hubTab === 'taste'">
                <div class="tasteActionWrap">
                  <button class="tasteDetailBtn" @click.stop="openTasteDetail(p)">
                    查看详情
                  </button>
                </div>
                <button class="plistPlay" @click.stop="playTastePlaylist(p)">▶</button>
                <button class="plistFav tasteFavBtn" @click.stop="togglePlaylistFavorite(p)">
                  {{ isPlaylistFavorited(p.id) ? "♥" : "♡" }}
                </button>
              </template>

              <template v-else>
                <button class="plistFav" @click.stop="togglePlaylistFavorite(p)">
                  {{ isPlaylistFavorited(p.id) ? "♥" : "♡" }}
                </button>
                <button class="plistPlay" @click.stop="playPlaylist(p)">▶</button>
              </template>
            </div>

            <div class="plistInfo">
              <div class="plistName">{{ p.name }}</div>
              <div class="plistDesc">{{ p.description || "暂无简介" }}</div>
              <div class="plistTag">
                {{ hubTab === "taste" ? "专题鉴赏" : p.type || "诗单" }}
              </div>
            </div>
          </div>

          <div v-if="!filteredHubList.length" class="emptyBox">暂无数据</div>
        </div>

        <div
          class="favoriteAudioList"
          v-if="(hubTab === 'mine' && (mineTab === 'audio' || mineTab === 'video')) || (hubTab === 'recent' && (recentTab === 'audio' || recentTab === 'video'))"
        >
          <div
            class="favAudioRow"
            v-for="item in currentMediaList"
            :key="item.id"
            @click="playMediaItem(item)"
          >
            <div class="favAudioCover" :style="bgImg(item.cover || item.thumbnail || defaultCover)">
              <div class="playIconOverlay" v-if="item.thumbnail">▶</div>
            </div>
            <div class="favAudioInfo">
              <div class="favAudioTitle">{{ item.title }}</div>
              <div class="favAudioSub">{{ item.subtitle || item.author || "朗诵音频" }}</div>
              <div class="videoTags" style="margin-top: 6px" v-if="item.tags">
                <span v-for="tag in normalizeTags(item.tags)" :key="tag" class="videoTag">{{ tag }}</span>
              </div>
            </div>
            <div class="favAudioActions">
              <button class="rowIconBtn" @click.stop="toggleMediaFavorite(item)">
                {{ isMediaFavorited(item.id) ? "♥" : "♡" }}
              </button>
              <button class="rowIconBtn solid" @click.stop="playMediaItem(item)">▶</button>
            </div>
          </div>

          <div v-if="!currentMediaList.length" class="emptyBox">
            {{ getEmptyMessage() }}
          </div>
        </div>

        <section
          v-if="hubTab === 'taste' && tasteDetailVisible"
          class="tasteDetailPanel"
          ref="tasteDetailRef"
        >
          <div class="tasteDetailHead">
            <div>
              <div class="tasteDetailTitle">
                {{ currentTastePlaylist?.name || "专题鉴赏" }}
              </div>
              <div class="tasteDetailSub">
                {{ currentTastePlaylist?.description || "点击左侧视频切换播放" }}
              </div>
            </div>

            <button class="pill" @click="closeTasteDetail">收起</button>
          </div>

          <div class="tasteDetailBody">
            <aside class="tasteSidebar">
              <div class="tasteSidebarTitle">鉴赏视频集</div>

              <div v-if="tasteVideoLoading" class="emptyBox">加载中...</div>

              <div v-else-if="!tasteVideoList.length" class="emptyBox">
                当前专题暂无视频
              </div>

              <div v-else class="tasteVideoList">
                <div
                  v-for="video in tasteVideoList"
                  :key="video.id"
                  class="tasteVideoCard"
                  :class="{ active: currentTasteVideo?.id === video.id }"
                  @click="playTasteVideo(video)"
                >
                  <div class="tasteVideoCardTitle">{{ video.title || "未命名视频" }}</div>
                  <div
                    class="tasteVideoCardThumb"
                    :style="bgImg(video.thumbnail || currentTastePlaylist?.cover || defaultCover)"
                  ></div>
                  <div class="tasteVideoCardMeta">
                    <span>{{ video.author || "诗词鉴赏" }}</span>
                    <span v-if="video.duration">· {{ video.duration }}</span>
                  </div>
                  <button class="tasteVideoFavBtn" @click.stop="toggleTasteVideoFavorite(video)">
                    {{ isVideoFavorited(video.id) ? "♥" : "♡" }}
                  </button>
                </div>
              </div>
            </aside>

            <div class="tastePlayerWrap">
              <div class="tastePlayerHead">
                <div class="secTitle">专题鉴赏</div>
              </div>

              <div v-if="currentTasteVideo" class="tastePlayerCard">
                <div class="tastePlayerBox">
                  <video
                    ref="tasteVideoRef"
                    :src="toMediaUrl(currentTasteVideo.videoUrl)"
                    controls
                    autoplay
                    playsinline
                  >
                    您的浏览器不支持视频播放
                  </video>
                </div>

                <div class="tastePlayerInfo">
                  <div class="tasteNowTitle">{{ currentTasteVideo.title }}</div>
                  <div class="tasteNowMeta">
                    <span>{{ currentTasteVideo.author || "诗词鉴赏" }}</span>
                    <span v-if="currentTasteVideo.quality">· {{ currentTasteVideo.quality }}</span>
                    <span v-if="currentTasteVideo.views">· {{ formatViews(currentTasteVideo.views) }}次观看</span>
                  </div>
                  <div class="tasteNowDesc">
                    {{ currentTasteVideo.description || "暂无专题说明" }}
                  </div>
                  <div class="tasteActions">
                    <button class="pill" @click="toggleTasteVideoFavorite(currentTasteVideo)">
                      {{ isVideoFavorited(currentTasteVideo.id) ? "已收藏" : "收藏" }}
                    </button>
                  </div>
                </div>
              </div>

              <div v-else class="emptyBox">请选择左侧视频开始播放</div>
            </div>
          </div>
        </section>

        <div
          class="hubSecHead"
          style="margin-top: 14px"
          v-if="hubTab === 'album' || hubTab === 'taste'"
        >
          <div class="secTitle">大家都在听</div>
          <button class="moreBtn" @click="go('/audio/rank')">更多</button>
        </div>

        <div class="listenGrid" v-if="hubTab === 'album' || hubTab === 'taste'">
          <div class="listenCol">
            <div class="colTitle">热门</div>
            <div class="songRow" v-for="s in hotList" :key="s.id" @click="playSong(s)">
              <div class="songMain">
                <div class="songName">{{ s.title }}</div>
                <div class="songMeta">{{ s.subtitle || "朗诵音频" }}</div>
                <span class="badgeUp" v-if="s.up">上榜</span>
              </div>

              <div class="songActions">
                <button class="rowIconBtn" @click.stop="toggleAudioFavorite(s)">
                  {{ isAudioFavorited(s.id) ? "♥" : "♡" }}
                </button>
                <button class="rowIconBtn solid" @click.stop="playSong(s)">▶</button>
              </div>
            </div>
          </div>

          <div class="listenCol">
            <div class="colTitle">精选</div>
            <div class="songRow" v-for="s in pickList" :key="s.id" @click="playSong(s)">
              <div class="songMain">
                <div class="songName">{{ s.title }}</div>
                <div class="songMeta">{{ s.subtitle || "精选朗诵" }}</div>
              </div>

              <div class="songActions">
                <button class="rowIconBtn" @click.stop="toggleAudioFavorite(s)">
                  {{ isAudioFavorited(s.id) ? "♥" : "♡" }}
                </button>
                <button class="rowIconBtn solid" @click.stop="playSong(s)">▶</button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <section class="videoRecommendSection">
        <div class="videoCard">
          <div class="videoHead">
            <div>
              <div class="videoTitle">朗诵视频推荐</div>
              <div class="videoSub">名师示范 · 学生作品 · 技巧讲解</div>
            </div>
            <div class="videoTabs">
              <button class="pill" :class="{ active: videoTab === 'master' }" @click="changeVideoTab('master')">
                名师示范
              </button>
              <button class="pill" :class="{ active: videoTab === 'student' }" @click="changeVideoTab('student')">
                学生作品
              </button>
              <button class="pill" :class="{ active: videoTab === 'tutorial' }" @click="changeVideoTab('tutorial')">
                技巧讲解
              </button>
            </div>
          </div>

          <div class="videoGrid">
            <div
              v-for="video in currentVideoList"
              :key="video.id"
              class="videoItem"
              @click="playVideo(video)"
            >
              <div class="videoThumb" :style="bgImg(video.thumbnail || defaultCover)">
                <div class="thumbOverlay"></div>
                <button class="videoCenterPlay">▶</button>
                <div class="videoDuration">{{ video.duration || "00:00" }}</div>
                <div class="videoQuality" v-if="video.quality">{{ video.quality }}</div>
                <button class="videoFavIcon" @click.stop="toggleVideoFavorite(video)">
                  {{ isVideoFavorited(video.id) ? "♥" : "♡" }}
                </button>
              </div>
              <div class="videoInfo">
                <div class="videoName">{{ video.title }}</div>
                <div class="videoMeta">
                  <span class="videoAuthor">{{ video.author || "诗词鉴赏" }}</span>
                  <span class="videoDot">·</span>
                  <span class="videoViews">{{ formatViews(video.views) }}次观看</span>
                </div>
                <div class="videoTags">
                  <span v-for="tag in normalizeTags(video.tags)" :key="tag" class="videoTag">{{ tag }}</span>
                </div>
              </div>
            </div>

            <div v-if="!currentVideoList.length" class="emptyBox">暂无视频推荐</div>
          </div>

          <div class="videoFoot">
            <button class="btn ghost" @click="refreshVideos">刷新推荐</button>
            <button class="btn primary" @click="goVideoCenter">更多视频</button>
          </div>
        </div>
      </section>

      <div v-if="videoPlayerOpen" class="videoModalMask" @click.self="closeVideoPlayer">
        <div class="videoModal">
          <div class="videoModalHead">
            <div class="videoModalTitle">{{ currentVideo?.title }}</div>
            <div class="videoModalActions">
              <button class="pill" :class="{ active: currentVideo?.favorited }" @click="toggleCurrentVideoFavorite">
                {{ currentVideo?.favorited ? "已收藏" : "收藏" }}
              </button>
              <button class="pill" :class="{ active: currentVideo?.liked }" @click="toggleVideoLike">
                {{ currentVideo?.liked ? "已点赞" : "点赞" }}
              </button>
              <button class="pill" @click="closeVideoPlayer">关闭</button>
            </div>
          </div>
          <div class="videoModalBody">
            <div class="videoPlayer">
              <video
                ref="videoRef"
                :src="toMediaUrl(currentVideo?.videoUrl)"
                controls
                autoplay
                @loadedmetadata="onVideoLoaded"
                @timeupdate="onVideoTimeUpdate"
              >
                您的浏览器不支持视频播放
              </video>
            </div>
            <div class="videoDetails">
              <div class="videoDetailInfo">
                <div class="videoDetailTitle">{{ currentVideo?.title }}</div>
                <div class="videoDetailMeta">
                  <span>{{ currentVideo?.author }}</span>
                  <span v-if="currentVideo?.views">· {{ formatViews(currentVideo?.views) }}次观看</span>
                  <span v-if="currentVideo?.quality">· {{ currentVideo?.quality }}</span>
                  <span v-if="currentVideo?.duration">· {{ currentVideo?.duration }}</span>
                </div>
                <div class="videoTags" v-if="currentVideo?.tags">
                  <span v-for="tag in normalizeTags(currentVideo.tags)" :key="tag" class="videoTag">{{ tag }}</span>
                </div>
                <div class="videoDetailDesc">{{ currentVideo?.description || "暂无描述" }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    

    <div v-if="queueVisible" class="queueMask" @click.self="queueVisible = false">
      <div class="queuePanel">
        <div class="queueHead">
          <div class="queueTitle">{{ currentPlaylistName || "播放列表" }}</div>
          <button class="pill" @click="queueVisible = false">关闭</button>
        </div>

        <div class="queueBody">
          <div
            class="queueItem"
            v-for="(item, index) in playQueue"
            :key="item.id"
            :class="{ active: currentQueueIndex === index }"
            @click="playQueueItem(index)"
          >
            <div class="queueIndex">{{ String(index + 1).padStart(2, "0") }}</div>
            <div class="queueInfo">
              <div class="queueItemTitle">{{ item.title }}</div>
              <div class="queueItemSub">{{ item.subtitle || "朗诵音频" }}</div>
            </div>
            <div class="queueActions">
              <button class="queueFavBtn" @click.stop="toggleAudioFavorite(item)">
                {{ isAudioFavorited(item.id) ? "♥" : "♡" }}
              </button>
              <div class="queuePlaying" v-if="currentQueueIndex === index">播放中</div>
            </div>
          </div>

          <div v-if="!playQueue.length" class="emptyBox">暂无可播放条目</div>
        </div>
      </div>
    </div>

    <div class="miniPlayer" v-if="nowPlaying">
      <div class="mpLeft" @click="go('/audio/now')">
        <div class="mpCover" :style="bgImg(nowPlaying.cover || defaultCover)"></div>
        <div class="mpInfo">
          <div class="mpTitle">{{ nowPlaying.title }}</div>
          <div class="mpSub">
            {{ nowPlaying.author || nowPlaying.subtitle || "朗诵音频" }}
          </div>
        </div>
      </div>

      <div class="mpRight">
        <button class="mpBtn fav" @click="toggleNowPlayingFavorite">
          {{ nowPlayingIsFavorited ? "已收藏" : "收藏" }}
        </button>
        <button class="mpBtn" @click="togglePlay">{{ playing ? "暂停" : "播放" }}</button>
        <button class="mpBtn ghost" @click="openQueue">列表</button>
      </div>
    </div>

    <audio
      ref="audioRef"
      :src="currentAudioUrl"
      preload="metadata"
      @timeupdate="onTimeUpdate"
      @loadedmetadata="onLoadedMeta"
      @ended="onEnded"
      @error="onAudioError"
    />
  </div>
</template>

<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from "vue";
import { useRouter } from "vue-router";
import axios from "axios";
import {
  getRecitePlaylists,
  getRecitePlaylistItems,
  getRecitePlaylistVideos,
  getReciteMyFavorites,
  getReciteMyFavoriteAudios,
  getReciteMyFavoriteVideos,
  getReciteMyRecentPlaylists,
  getReciteMyRecentAudios,
  getReciteMyRecentVideos,
  getReciteListen,
  getReciteVideos,
  addRecitePlay,
  addReciteVideoPlay,
  addReciteFavorite,
  removeReciteFavorite,
} from "@/utils/api";
import { isLoggedIn } from "@/utils/auth";
import { showWarning } from "@/utils/toast";

import paperBg from "@/assets/game/bg_page_1.jpg";
import defaultCover from "@/assets/game/card_feihua_3.jpg";

const router = useRouter();
const go = (p) => router.push(p);

const promptLogin = (message = "暂未登录，请登录后进行") => {
  showWarning(message);
  setTimeout(() => {
    router.push("/login");
  }, 1500);
};

const ensureLogin = (message) => {
  if (isLoggedIn()) return true;
  promptLogin(message);
  return false;
};

const goToRecordingPage = () => {
  router.push("/recite/recording");
};

const goToRecordingHistory = () => {
  router.push("/recite/recording/history");
};

const mediaBase = "http://localhost:8080";

const paperStyle = {
  "--paper": `url(${paperBg})`,
};

const toMediaUrl = (url) => {
  if (!url) return "";
  if (typeof url !== "string") return url;
  if (/^https?:\/\//i.test(url)) return url;
  if (url.startsWith("/files/")) return `${mediaBase}${url}`;
  return url;
};

const unwrap = (res, fallback = null) => {
  if (res && typeof res === "object" && "data" in res) return res.data ?? fallback;
  return res ?? fallback;
};

const task = ref({
  id: 0,
  title: "",
  durationMs: 0,
  level: "基础",
  demoAudioUrl: "",
});

const todaySubmit = ref(0);
const marqueeTexts = ref([
  "跟读要点：断句、停连、重音、语气、节奏。",
  "录音完成后提交，可生成评分与准确率。",
  "支持倍速练习：先慢后快，最后回到 1.0x。",
  "可扩展：老师点评、同学互评、音色与停顿检测。",
]);

const hubKeyword = ref("");
const searchAudios = ref([]);
const searchVideos = ref([]);
const hubTopic = ref("诗词朗诵");

const hubTabs = [
  { key: "album", label: "音频集" },
  { key: "taste", label: "鉴赏" },
  { key: "mine", label: "我的" },
  { key: "recent", label: "最近播放" },
];

const hubTab = ref("album");
const mineTab = ref("playlist");
const recentTab = ref("playlist");

const hubList = ref([]);
const favoriteAudioList = ref([]);
const recentAudioList = ref([]);
const favoriteVideoList = ref([]);
const recentVideoList = ref([]);

const favoritePlaylistIds = ref([]);
const favoriteAudioIds = ref([]);
const favoriteVideoIds = ref([]);

const hotList = ref([]);
const pickList = ref([]);

const playQueue = ref([]);
const currentQueueIndex = ref(-1);
const currentPlaylistId = ref(null);
const currentPlaylistName = ref("");
const queueVisible = ref(false);

const audioRef = ref(null);
const videoRef = ref(null);
const tasteVideoRef = ref(null);

const playing = ref(false);
const rate = ref(1.0);
const currentMs = ref(0);
const totalMs = ref(0);
const nowPlaying = ref(null);

const videoTab = ref("master");
const videoPlayerOpen = ref(false);
const currentVideo = ref(null);
const masterVideos = ref([]);
const studentVideos = ref([]);
const tutorialVideos = ref([]);

const tasteDetailVisible = ref(false);
const tasteDetailRef = ref(null);
const currentTastePlaylist = ref(null);
const tasteVideoList = ref([]);
const currentTasteVideo = ref(null);
const tasteVideoLoading = ref(false);

const hubSectionTitle = computed(() => {
  if (hubTab.value === "album") return "精品诗单";
  if (hubTab.value === "taste") return "鉴赏专题";
  if (hubTab.value === "mine" && mineTab.value === "playlist") return "我的收藏诗单";
  if (hubTab.value === "mine" && mineTab.value === "audio") return "我的收藏音频";
  if (hubTab.value === "mine" && mineTab.value === "video") return "我的收藏视频";
  if (hubTab.value === "recent" && recentTab.value === "playlist") return "最近播放诗单";
  if (hubTab.value === "recent" && recentTab.value === "audio") return "最近播放音频";
  if (hubTab.value === "recent" && recentTab.value === "video") return "最近播放视频";
  return "诗单";
});

const filteredHubList = computed(() => {
  const kw = (hubKeyword.value || "").trim();
  const base = hubList.value || [];
  if (!kw) return base;
  return base.filter((x) => `${x.name || ""}${x.description || ""}`.includes(kw));
});

const currentMediaList = computed(() => {
  let list = [];
  if (hubTab.value === "mine") {
    if (mineTab.value === "audio") list = favoriteAudioList.value;
    else if (mineTab.value === "video") list = favoriteVideoList.value;
  } else if (hubTab.value === "recent") {
    if (recentTab.value === "audio") list = recentAudioList.value;
    else if (recentTab.value === "video") list = recentVideoList.value;
  }
  const kw = (hubKeyword.value || "").trim();
  if (!kw) return list;
  return list.filter((x) => `${x.title || ""}${x.subtitle || x.author || ""}`.includes(kw));
});

const showPlaylistGrid = computed(() => {
  if (hubTab.value === "album") return true;
  if (hubTab.value === "taste") return true;
  if (hubTab.value === "mine" && mineTab.value === "playlist") return true;
  if (hubTab.value === "recent" && recentTab.value === "playlist") return true;
  return false;
});

const currentAudioUrl = computed(() => {
  return toMediaUrl(nowPlaying.value?.audioUrl || task.value.demoAudioUrl || "");
});

const taskStatusText = computed(() => (playing.value ? "播放中" : "未播放"));

const videoShowCount = ref(2);
const shuffledVideos = ref([]);

const getBaseVideoList = () => {
  if (videoTab.value === "student") return studentVideos.value || [];
  if (videoTab.value === "tutorial") return tutorialVideos.value || [];
  return masterVideos.value || [];
};

const shuffleArray = (arr) => {
  const list = [...arr];
  for (let i = list.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [list[i], list[j]] = [list[j], list[i]];
  }
  return list;
};

const resetVideoRecommend = () => {
  videoShowCount.value = 2;
  shuffledVideos.value = shuffleArray(getBaseVideoList());
};

const currentVideoList = computed(() => {
  const base = getBaseVideoList();

  // 页面刚进来时，如果还没随机过，就先直接显示原始视频
  if (!shuffledVideos.value.length) {
    return base.slice(0, videoShowCount.value);
  }

  return shuffledVideos.value.slice(0, videoShowCount.value);
});

const nowPlayingIsFavorited = computed(() => {
  const id = nowPlaying.value?.id;
  return !!id && favoriteAudioIds.value.includes(id);
});

const bgImg = (img) => {
  const finalUrl = typeof img === "string" ? toMediaUrl(img) : img;
  return { backgroundImage: `url(${finalUrl})` };
};

const fmtMs = (ms) => {
  const s = Math.max(0, Math.floor((ms || 0) / 1000));
  const mm = String(Math.floor(s / 60)).padStart(2, "0");
  const ss = String(s % 60).padStart(2, "0");
  return `${mm}:${ss}`;
};

const formatViews = (views) => {
  const n = Number(views || 0);
  if (n >= 10000) return (n / 10000).toFixed(1) + "万";
  return n.toLocaleString();
};

const normalizeTags = (tags) => {
  if (Array.isArray(tags)) return tags;
  if (typeof tags === "string" && tags.trim()) {
    return tags.split(",").map((s) => s.trim()).filter(Boolean);
  }
  return [];
};

const isPlaylistFavorited = (id) => favoritePlaylistIds.value.includes(id);
const isAudioFavorited = (id) => favoriteAudioIds.value.includes(id);
const isVideoFavorited = (id) => favoriteVideoIds.value.includes(id);

const isMediaFavorited = (id) => {
  if (hubTab.value === "mine") {
    if (mineTab.value === "audio") return isAudioFavorited(id);
    if (mineTab.value === "video") return isVideoFavorited(id);
  } else if (hubTab.value === "recent") {
    if (recentTab.value === "audio") return isAudioFavorited(id);
    if (recentTab.value === "video") return isVideoFavorited(id);
  }
  return false;
};

const getEmptyMessage = () => {
  if (hubTab.value === "mine") {
    if (mineTab.value === "audio") return "暂无收藏音频";
    if (mineTab.value === "video") return "暂无收藏视频";
  }
  if (hubTab.value === "recent") {
    if (recentTab.value === "audio") return "暂无最近音频";
    if (recentTab.value === "video") return "暂无最近视频";
  }
  return "暂无数据";
};

const ensureAudioPlay = async () => {
  const el = audioRef.value;
  if (!el || !currentAudioUrl.value) return;
  el.playbackRate = rate.value;
  try {
    await el.play();
    playing.value = true;
  } catch (e) {
    playing.value = false;
    console.error("音频播放失败：", e);
  }
};

const togglePlay = async () => {
  const el = audioRef.value;
  if (!el || !currentAudioUrl.value) return;
  el.playbackRate = rate.value;
  if (playing.value) {
    el.pause();
    playing.value = false;
  } else {
    await ensureAudioPlay();
  }
};

const onLoadedMeta = () => {
  const el = audioRef.value;
  if (!el) return;
  totalMs.value = Math.floor((el.duration || 0) * 1000);
};

const onTimeUpdate = () => {
  const el = audioRef.value;
  if (!el) return;
  currentMs.value = Math.floor((el.currentTime || 0) * 1000);
};

const onEnded = async () => {
  playing.value = false;
  if (currentQueueIndex.value >= 0 && currentQueueIndex.value < playQueue.value.length - 1) {
    await playQueueItem(currentQueueIndex.value + 1);
  }
};

const onAudioError = () => {
  console.error("音频资源加载失败：", currentAudioUrl.value);
};

const loadFavoriteLists = async () => {
  if (!isLoggedIn()) {
    favoritePlaylistIds.value = [];
    favoriteAudioIds.value = [];
    favoriteVideoIds.value = [];
    favoriteAudioList.value = [];
    favoriteVideoList.value = [];
    if (hubTab.value === "mine") {
      hubList.value = [];
    }
    return;
  }
  try {
    const [playlistRes, audioRes, videoRes] = await Promise.all([
      getReciteMyFavorites(),
      getReciteMyFavoriteAudios(),
      getReciteMyFavoriteVideos(),
    ]);

    const playlists = unwrap(playlistRes, []) || [];
    const audios = unwrap(audioRes, []) || [];
    const videos = unwrap(videoRes, []) || [];

    favoritePlaylistIds.value = playlists.map((x) => x.id);
    favoriteAudioIds.value = audios.map((x) => x.id);
    favoriteVideoIds.value = videos.map((x) => x.id);

    if (hubTab.value === "mine" && mineTab.value === "playlist") {
      hubList.value = playlists;
    }
    favoriteAudioList.value = audios;
    favoriteVideoList.value = videos;
  } catch (e) {
    console.error("加载收藏失败：", e);
  }
};

const loadRecentLists = async () => {
  if (!isLoggedIn()) {
    recentAudioList.value = [];
    recentVideoList.value = [];
    if (hubTab.value === "recent") {
      hubList.value = [];
    }
    return;
  }
  try {
    const [playlistRes, audioRes, videoRes] = await Promise.all([
      getReciteMyRecentPlaylists(),
      getReciteMyRecentAudios(),
      getReciteMyRecentVideos(),
    ]);

    const playlists = unwrap(playlistRes, []) || [];
    const audios = unwrap(audioRes, []) || [];
    const videos = unwrap(videoRes, []) || [];

    if (hubTab.value === "recent" && recentTab.value === "playlist") {
      hubList.value = playlists;
    }
    recentAudioList.value = audios;
    recentVideoList.value = videos;
  } catch (e) {
    console.error("加载最近播放失败：", e);
  }
};

const togglePlaylistFavorite = async (p) => {
  if (!ensureLogin("暂未登录，请登录后再收藏")) return;
  try {
    if (isPlaylistFavorited(p.id)) {
      await removeReciteFavorite(p.id, "playlist");
      favoritePlaylistIds.value = favoritePlaylistIds.value.filter((id) => id !== p.id);
      if (hubTab.value === "mine" && mineTab.value === "playlist") {
        hubList.value = hubList.value.filter((item) => item.id !== p.id);
      }
    } else {
      await addReciteFavorite({ targetId: p.id, favoriteType: "playlist" });
      favoritePlaylistIds.value.push(p.id);
    }
  } catch (e) {
    console.error("切换诗单收藏失败：", e);
  }
};

const toggleAudioFavorite = async (item) => {
  if (!ensureLogin("暂未登录，请登录后再收藏")) return;
  try {
    if (isAudioFavorited(item.id)) {
      await removeReciteFavorite(item.id, "audio");
      favoriteAudioIds.value = favoriteAudioIds.value.filter((id) => id !== item.id);
      favoriteAudioList.value = favoriteAudioList.value.filter((x) => x.id !== item.id);
    } else {
      await addReciteFavorite({ targetId: item.id, favoriteType: "audio" });
      favoriteAudioIds.value.push(item.id);

      const exists = favoriteAudioList.value.some((x) => x.id === item.id);
      if (!exists) {
        favoriteAudioList.value.unshift({
          id: item.id,
          playlistId: item.playlistId || null,
          poemId: item.poemId || null,
          title: item.title,
          subtitle: item.subtitle,
          cover: item.cover,
          audioUrl: item.audioUrl,
        });
      }
    }
  } catch (e) {
    console.error("切换音频收藏失败：", e);
  }
};

const toggleVideoFavorite = async (video) => {
  if (!ensureLogin("暂未登录，请登录后再收藏")) return;
  try {
    if (isVideoFavorited(video.id)) {
      await removeReciteFavorite(video.id, "video");
      favoriteVideoIds.value = favoriteVideoIds.value.filter((id) => id !== video.id);
      favoriteVideoList.value = favoriteVideoList.value.filter((v) => v.id !== video.id);
      if (currentVideo.value && currentVideo.value.id === video.id) {
        currentVideo.value.favorited = false;
      }
    } else {
      await addReciteFavorite({ targetId: video.id, favoriteType: "video" });
      favoriteVideoIds.value.push(video.id);
      if (currentVideo.value && currentVideo.value.id === video.id) {
        currentVideo.value.favorited = true;
      }
      const exists = favoriteVideoList.value.some((v) => v.id === video.id);
      if (!exists) {
        favoriteVideoList.value.unshift({
          id: video.id,
          title: video.title,
          author: video.author,
          thumbnail: video.thumbnail,
          videoUrl: video.videoUrl,
          duration: video.duration,
          quality: video.quality,
          tags: video.tags,
          description: video.description,
        });
      }
    }
  } catch (e) {
    console.error("切换视频收藏失败：", e);
  }
};

const toggleTasteVideoFavorite = async (video) => {
  await toggleVideoFavorite(video);
};

const toggleMediaFavorite = async (item) => {
  if (hubTab.value === "mine") {
    if (mineTab.value === "audio") await toggleAudioFavorite(item);
    else if (mineTab.value === "video") await toggleVideoFavorite(item);
  } else if (hubTab.value === "recent") {
    if (recentTab.value === "audio") await toggleAudioFavorite(item);
    else if (recentTab.value === "video") await toggleVideoFavorite(item);
  }
};

const toggleNowPlayingFavorite = async () => {
  if (!nowPlaying.value?.id) return;
  await toggleAudioFavorite(nowPlaying.value);
};

const toggleCurrentVideoFavorite = async () => {
  if (!currentVideo.value) return;
  await toggleVideoFavorite(currentVideo.value);
};

const recordVideoPlay = async (video, playType = "video") => {
  try {
    await addReciteVideoPlay({
      videoId: video.id,
      playlistId: null,
      playSeconds: 0,
      playType: playType,
    });
  } catch (e) {
    console.error("记录视频播放失败：", e);
  }
};

const loadVideos = async (type) => {
  try {
    const res = await getReciteVideos(type);
    const list = unwrap(res, []) || [];
    list.forEach((v) => {
      v.favorited = isVideoFavorited(v.id);
    });
    if (type === "master") masterVideos.value = list;
    else if (type === "student") studentVideos.value = list;
    else tutorialVideos.value = list;
  } catch (e) {
    console.error("加载视频失败：", e);
  }
};

const changeVideoTab = async (type) => {
  videoTab.value = type;

  if (type === "master" && !masterVideos.value.length) await loadVideos("master");
  if (type === "student" && !studentVideos.value.length) await loadVideos("student");
  if (type === "tutorial" && !tutorialVideos.value.length) await loadVideos("tutorial");

  resetVideoRecommend();
};

const playVideo = async (video) => {
  currentVideo.value = {
    ...video,
    liked: !!video.liked,
    favorited: isVideoFavorited(video.id),
  };
  videoPlayerOpen.value = true;
  await recordVideoPlay(video, videoTab.value);
};

const playMediaItem = async (item) => {
  if (item.videoUrl) {
    await playVideo(item);
  } else if (item.audioUrl) {
    await playAnyAudio(item);
  }
};

const closeVideoPlayer = () => {
  videoPlayerOpen.value = false;
  currentVideo.value = null;
  if (videoRef.value) videoRef.value.pause();
};

const onVideoLoaded = () => {};
const onVideoTimeUpdate = () => {};

const toggleVideoLike = () => {
  if (currentVideo.value) currentVideo.value.liked = !currentVideo.value.liked;
};

const shareVideo = async () => {
  if (!currentVideo.value) return;
  const shareText = `推荐一个朗诵视频：${currentVideo.value.title}`;
  if (navigator.share) {
    await navigator.share({
      title: currentVideo.value.title,
      text: shareText,
      url: window.location.href,
    });
  } else {
    await navigator.clipboard.writeText(`${shareText} ${window.location.href}`);
  }
};

const refreshVideos = async () => {
  await loadVideos(videoTab.value);
  resetVideoRecommend();
};

const goVideoCenter = () => {
  const total = getBaseVideoList().length;
  videoShowCount.value = Math.min(videoShowCount.value + 2, total);
};

const loadHubList = async () => {
  try {
    if (hubTab.value === "album") {
      const res = await getRecitePlaylists("album");
      hubList.value = unwrap(res, []) || [];
      return;
    }

    if (hubTab.value === "taste") {
      const res = await getRecitePlaylists("taste");
      hubList.value = unwrap(res, []) || [];
      return;
    }

    if (hubTab.value === "mine") {
      if (!isLoggedIn()) {
        hubList.value = [];
        favoriteAudioList.value = [];
        favoriteVideoList.value = [];
        return;
      }
      if (mineTab.value === "playlist") {
        const res = await getReciteMyFavorites();
        hubList.value = unwrap(res, []) || [];
      } else if (mineTab.value === "audio") {
        const res = await getReciteMyFavoriteAudios();
        favoriteAudioList.value = unwrap(res, []) || [];
      } else if (mineTab.value === "video") {
        const res = await getReciteMyFavoriteVideos();
        favoriteVideoList.value = unwrap(res, []) || [];
        favoriteVideoIds.value = favoriteVideoList.value.map((v) => v.id);
      }
      return;
    }

    if (hubTab.value === "recent") {
      if (!isLoggedIn()) {
        hubList.value = [];
        recentAudioList.value = [];
        recentVideoList.value = [];
        return;
      }
      if (recentTab.value === "playlist") {
        const res = await getReciteMyRecentPlaylists();
        hubList.value = unwrap(res, []) || [];
      } else if (recentTab.value === "audio") {
        const res = await getReciteMyRecentAudios();
        recentAudioList.value = unwrap(res, []) || [];
      } else if (recentTab.value === "video") {
        const res = await getReciteMyRecentVideos();
        recentVideoList.value = unwrap(res, []) || [];
      }
    }
  } catch (e) {
    console.error("加载数据失败：", e);
    hubList.value = [];
    favoriteAudioList.value = [];
    recentAudioList.value = [];
    favoriteVideoList.value = [];
    recentVideoList.value = [];
  }
};

const loadListenData = async () => {
  try {
    const res = await getReciteListen();
    const data = unwrap(res, {}) || {};
    hotList.value = data.hotList || [];
    pickList.value = data.pickList || [];
  } catch (e) {
    console.error("加载大家都在听失败：", e);
    hotList.value = [];
    pickList.value = [];
  }
};
const doSearch = async () => {
  const kw = hubKeyword.value.trim();

  if (!kw) {
    searchAudios.value = [];
    searchVideos.value = [];
    return;
  }

  const res = await axios.get("/api/recite/search", {
    params: { keyword: kw },
  });

  const data = res.data?.data || {};
  searchAudios.value = data.audios || [];
  searchVideos.value = data.videos || [];
};

const refresh = async () => {
  await Promise.all([
    loadHubList(),
    loadListenData(),
    loadVideos(videoTab.value),
    loadFavoriteLists(),
    loadRecentLists(),
  ]);
  resetVideoRecommend();
};

const startTask = async () => {
  console.log("当前推荐朗诵任务后端暂未接入");
};

const switchHubTab = async (key) => {
  if ((key === "mine" || key === "recent") && !ensureLogin(`暂未登录，请登录后查看${key === "mine" ? "我的" : "最近播放"}`)) {
    return;
  }
  hubTab.value = key;
  if (key !== "taste") {
    tasteDetailVisible.value = false;
    currentTastePlaylist.value = null;
    currentTasteVideo.value = null;
    tasteVideoList.value = [];
  }
  await loadHubList();
};

const switchMineTab = async (key) => {
  if (!ensureLogin("暂未登录，请登录后查看我的收藏")) return;
  mineTab.value = key;
  await loadHubList();
};

const switchRecentTab = async (key) => {
  if (!ensureLogin("暂未登录，请登录后查看最近播放")) return;
  recentTab.value = key;
  await loadHubList();
};

const loadPlaylistQueue = async (playlistId) => {
  try {
    const res = await getRecitePlaylistItems(playlistId);
    const list = unwrap(res, []) || [];
    playQueue.value = list.map((item) => ({
      id: item.id,
      playlistId: item.playlistId,
      poemId: item.poemId,
      title: item.title,
      subtitle: item.subtitle,
      cover: item.cover,
      audioUrl: item.audioUrl,
    }));
  } catch (e) {
    console.error("加载诗单条目失败：", e);
    playQueue.value = [];
  }
};

const loadTasteVideoList = async (playlistId) => {
  try {
    tasteVideoLoading.value = true;
    const res = await getRecitePlaylistVideos(playlistId);
    const list = unwrap(res, []) || [];
    list.forEach((v) => {
      v.favorited = isVideoFavorited(v.id);
    });
    tasteVideoList.value = list;
    currentTasteVideo.value = list.length ? list[0] : null;

    await nextTick();
    if (tasteVideoRef.value && currentTasteVideo.value?.videoUrl) {
      tasteVideoRef.value.play().catch(() => {});
    }
  } catch (e) {
    console.error("加载鉴赏专题视频失败：", e);
    tasteVideoList.value = [];
    currentTasteVideo.value = null;
  } finally {
    tasteVideoLoading.value = false;
  }
};

const openTasteDetail = async (playlist) => {
  currentTastePlaylist.value = playlist;
  tasteDetailVisible.value = true;

  try {
    await addRecitePlay({
      poemId: null,
      playlistId: playlist.id,
      mediaId: null,
      playType: "taste",
    });
  } catch (e) {
    console.error("记录鉴赏专题播放失败：", e);
  }

  await loadTasteVideoList(playlist.id);
  await nextTick();
  tasteDetailRef.value?.scrollIntoView({ behavior: "smooth", block: "start" });
};

const closeTasteDetail = () => {
  tasteDetailVisible.value = false;
  currentTastePlaylist.value = null;
  tasteVideoList.value = [];
  currentTasteVideo.value = null;
  if (tasteVideoRef.value) tasteVideoRef.value.pause();
};

const playTasteVideo = async (video) => {
  currentTasteVideo.value = video;
  await recordVideoPlay(video, "taste");
  await nextTick();
  if (tasteVideoRef.value) {
    tasteVideoRef.value.currentTime = 0;
    tasteVideoRef.value.play().catch(() => {});
  }
};

const playTastePlaylist = async (p) => {
  try {
    await addRecitePlay({
      poemId: null,
      playlistId: p.id,
      mediaId: null,
      playType: "taste",
    });
  } catch (e) {
    console.error("记录鉴赏专题播放失败：", e);
  }

  await openTasteDetail(p);
};

const openPlaylist = async (p) => {
  if (hubTab.value === "taste") {
    await openTasteDetail(p);
    return;
  }
  currentPlaylistId.value = p.id;
  currentPlaylistName.value = p.name || "播放列表";
  await loadPlaylistQueue(p.id);
  queueVisible.value = true;
};

const playPlaylist = async (p) => {
  currentPlaylistId.value = p.id;
  currentPlaylistName.value = p.name || "播放列表";

  await loadPlaylistQueue(p.id);

  if (!playQueue.value.length) {
    console.warn("当前诗单没有音频条目");
    return;
  }

  await playQueueItem(0);

  try {
    await addRecitePlay({
      poemId: playQueue.value[0]?.poemId || null,
      playlistId: p.id,
      mediaId: playQueue.value[0]?.id || null,
      playType: "playlist",
    });
  } catch (e) {
    console.error("记录诗单播放失败：", e);
  }
};

const playQueueItem = async (index) => {
  const item = playQueue.value[index];
  if (!item) return;

  currentQueueIndex.value = index;
  nowPlaying.value = {
    id: item.id,
    title: item.title,
    author: item.subtitle || "朗诵音频",
    subtitle: item.subtitle || "朗诵音频",
    cover: item.cover || defaultCover,
    audioUrl: item.audioUrl || "",
    poemId: item.poemId || null,
    playlistId: item.playlistId || null,
  };

  await ensureAudioPlay();
  await loadListenData();

  try {
    await addRecitePlay({
      poemId: item.poemId || null,
      playlistId: item.playlistId || null,
      mediaId: item.id || null,
      playType: "song",
    });
  } catch (e) {
    console.error("记录队列播放失败：", e);
  }
};

const playSong = async (s) => {
  currentQueueIndex.value = -1;

  nowPlaying.value = {
    id: s.id,
    title: s.title,
    author: s.subtitle || "朗诵音频",
    subtitle: s.subtitle || "朗诵音频",
    cover: s.cover || defaultCover,
    audioUrl: s.audioUrl || "",
    poemId: s.poemId || null,
    playlistId: s.playlistId || null,
  };

  try {
    await addRecitePlay({
      poemId: s.poemId || null,
      playlistId: s.playlistId || null,
      mediaId: s.id || null,
      playType: "song",
    });
  } catch (e) {
    console.error("记录歌曲播放失败：", e);
  }

  await ensureAudioPlay();
  await loadListenData();
};

const playAnyAudio = async (item) => {
  currentQueueIndex.value = -1;

  nowPlaying.value = {
    id: item.id,
    title: item.title,
    author: item.subtitle || "朗诵音频",
    subtitle: item.subtitle || "朗诵音频",
    cover: item.cover || defaultCover,
    audioUrl: item.audioUrl || "",
    poemId: item.poemId || null,
    playlistId: item.playlistId || null,
  };

  try {
    await addRecitePlay({
      poemId: item.poemId || null,
      playlistId: item.playlistId || null,
      mediaId: item.id || null,
      playType: "song",
    });
  } catch (e) {
    console.error("记录音频播放失败：", e);
  }

  await ensureAudioPlay();
  await loadListenData();
};

const openQueue = async () => {
  if (!playQueue.value.length && currentPlaylistId.value) {
    await loadPlaylistQueue(currentPlaylistId.value);
  }
  queueVisible.value = true;
};

const goHubMore = () => {
  if (hubTab.value === "album") router.push("/recite/yinpin");
  else if (hubTab.value === "taste") router.push("/recite/jianshang");
  else if (hubTab.value === "mine") router.push("/recite/my");
  else router.push("/recite/recentplay");
};

watch(hubTab, async () => {
  await loadHubList();
});

watch(mineTab, async () => {
  if (hubTab.value === "mine") await loadHubList();
});

watch(recentTab, async () => {
  if (hubTab.value === "recent") await loadHubList();
});

onMounted(async () => {
  const el = audioRef.value;
  if (el) el.playbackRate = rate.value;

  await Promise.all([
    loadHubList(),
    loadListenData(),
    loadVideos("master"),
    loadFavoriteLists(),
    loadRecentLists(),
  ]);
});

onBeforeUnmount(() => {
  const el = audioRef.value;
  if (el) el.pause();
  if (videoRef.value) videoRef.value.pause();
  if (tasteVideoRef.value) tasteVideoRef.value.pause();
});
</script>

<style scoped>
:root {
  color-scheme: light;
}

.recitePage {
  --paper-bg: #f3efe6;
  --paper-card: #f8f4eb;
  --paper-card-strong: #f4efe4;
  --ink: #2b2823;
  --sub-ink: #6f675d;
  --line: rgba(72, 60, 46, 0.14);
  --line-strong: rgba(72, 60, 46, 0.22);
  --accent: #8a2f2b;
  --gold: #9b7b47;

  position: relative;
  z-index: 0;
  isolation: isolate;
  width: 100%;
  min-height: 100vh;
  padding: 0 0 120px;
  margin: 0;
  box-sizing: border-box;
  color: var(--ink);
  font-family: "STSong", "SimSun", "Songti SC", serif;
  overflow-x: hidden;
  background: var(--paper-bg);
}

.recitePage::before {
  content: "";
  position: fixed;
  inset: 0;
  z-index: -2;
  background:
    linear-gradient(rgba(248, 244, 235, 0.92), rgba(248, 244, 235, 0.96)),
    var(--paper) center center / cover no-repeat;
  pointer-events: none;
}

.recitePage::after {
  content: "";
  position: fixed;
  inset: 0;
  z-index: -1;
  background:
    radial-gradient(900px 420px at 20% 12%, rgba(155, 123, 71, 0.06), transparent 65%),
    radial-gradient(800px 380px at 80% 24%, rgba(138, 47, 43, 0.04), transparent 70%),
    radial-gradient(900px 480px at 50% 100%, rgba(120, 105, 90, 0.05), transparent 66%);
  pointer-events: none;
}

.topRibbon {
  position: relative;
  width: 100%;
  margin: 0 0 18px;
  overflow: hidden;
  border-bottom: 1px solid var(--line);
  background: transparent;
}
/* ===== 高级背景开始 ===== */
.ribbonBg {
  position: absolute;
  inset: 0;

  background-image: url('@/assets/langsong/上图背景.jpg');
  background-repeat: repeat-x;
  background-size: auto 110%;
  background-position: 0 center;

  animation: ribbonMoveRight 80s linear infinite;
  z-index: 0;
}

/* 第二层：慢速 + 呼吸 */
.ribbonBg::after {
  content: "";
  position: absolute;
  inset: 0;

  background-image: url('@/assets/langsong/上图背景.jpg');
  background-repeat: repeat-x;
  background-size: auto 115%;
  background-position: 0 center;

  opacity: 0.9;

  animation:
    ribbonMoveRightSlow 140s linear infinite,
    ribbonBreath 12s ease-in-out infinite;
}

/* 主流动 */
@keyframes ribbonMoveRight {
  0% { background-position: 0 center; }
  100% { background-position: 3000px center; }
}

/* 慢流动 */
@keyframes ribbonMoveRightSlow {
  0% { background-position: 0 center; }
  100% { background-position: 1500px center; }
}

/* 呼吸 */
@keyframes ribbonBreath {
  0% { transform: scale(1.02); }
  50% { transform: scale(1.06); }
  100% { transform: scale(1.02); }
}
/* ===== 高级背景结束 ===== */
.ribbonMask {
  position: absolute;
  inset: 0;
  background:
    linear-gradient(180deg, rgba(245, 240, 230, 0.0), rgba(245, 240, 230, 0.0)),
    linear-gradient(90deg, rgba(255,255,255,0.08), rgba(255,255,255,0.02));
}

.ribbonInner {
  position: relative;
  z-index: 2;
  padding: 26px 28px 54px;
  min-height: 150px;
}

.ribbonLayout {
  position: relative;
}

.ribbonTopLeft {
  position: absolute;
  top: 20px;
  left: 28px;
}

.ribbonHero {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 112px;
  text-align: center;
}

.ribbonBottomRight {
  position: absolute;
  right: 28px;
  bottom: 18px;
}

.ribbonTitle {
  font-size: 40px;
  font-weight: 600;
  letter-spacing: 3px;
  color: #312a23;
  text-shadow: 0 1px 0 rgba(255,255,255,0.35);
}

.ribbonSub {
  margin-top: 12px;
  font-size: 14px;
  line-height: 1.6;
  letter-spacing: 2px;
  color: var(--sub-ink);
}

.metaRow {
  margin-top: 0;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.actionRow {
  margin-top: 12px;
}

.chip,
.btn,
.hotBadge,
.pill,
.backBtn,
.topicPill,
.searchPill,
.hubTab,
.mineSubTab,
.moreBtn,
.rowIconBtn,
.queueFavBtn,
.mpBtn {
  appearance: none;
  border: 1px solid var(--line);
  outline: none;
  background: rgba(248, 244, 235, 0.9);
  color: var(--ink);
  box-shadow: none;
  transition: all 0.22s ease;
}

.chip {
  display: inline-flex;
  height: 32px;
  align-items: center;
  padding: 0 12px;
  border-radius: 999px;
  font-size: 13px;
  font-weight: 600;
  color: #4d4439;
}

.btn {
  height: 36px;
  padding: 0 16px;
  border-radius: 999px;
  font-weight: 600;
  cursor: pointer;
}

.btn.primary {
  background: rgba(138, 47, 43, 0.08);
  border-color: rgba(138, 47, 43, 0.2);
  color: #6d211d;
}

.btn.ghost {
  background: rgba(248, 244, 235, 0.75);
}

.btn:hover,
.pill:hover,
.moreBtn:hover,
.rowIconBtn:hover,
.backBtn:hover,
.topicPill:hover,
.hubTab:hover,
.mineSubTab:hover,
.mpBtn:hover,
.queueFavBtn:hover {
  transform: translateY(-1px);
  border-color: var(--line-strong);
  background: rgba(255, 252, 246, 0.98);
}

.hotBadge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  height: 36px;
  padding: 0 12px;
  border-radius: 999px;
  font-size: 13px;
  font-weight: 600;
  color: #5a4f43;
}

.hotBadge .dot {
  width: 8px;
  height: 8px;
  border-radius: 999px;
  background: var(--accent);
}

.ribbonActions {
  display: flex;
  gap: 10px;
  align-items: center;
}

.poemMarquee {
  position: relative;
  z-index: 2;
  padding: 10px 22px;
  overflow: hidden;
  border-top: 1px solid rgba(72, 60, 46, 0.08);
  background: rgba(250, 246, 238, 0.78);
}

.poemTrack {
  display: flex;
  align-items: center;
  gap: 28px;
  white-space: nowrap;
  animation: marquee 28s linear infinite;
  opacity: 0.72;
}

.poemItem {
  font-size: 13px;
  font-weight: 600;
  color: #73695d;
  letter-spacing: 1px;
}

@keyframes marquee {
  0% { transform: translateX(0); }
  100% { transform: translateX(-50%); }
}

.mainWrap {
  display: flex;
  flex-direction: column;
  gap: 16px;
  width: 100%;
  padding: 0 16px;
  box-sizing: border-box;
}

.audioHubCard,
.videoCard,
.tasteSidebar,
.tastePlayerWrap,
.listenCol,
.videoItem,
.videoModal,
.queuePanel {
  background: var(--paper-card);
  border: 1px solid var(--line);
  box-shadow: none;
}

.audioHubCard,
.videoCard {
  border-radius: 10px;
  padding: 18px;
}

.hubTop {
  display: block;
}

.searchFull {
  width: 100%;
  box-sizing: border-box;
}

.searchPill {
  height: 44px;
  border-radius: 0;
  display: flex;
  align-items: center;
  padding: 0 14px;
  gap: 8px;
}

.backBtn,
.topicPill {
  height: 38px;
  border-radius: 999px;
  font-weight: 600;
  cursor: pointer;
}

.backBtn {
  width: 46px;
}

.topicPill {
  padding: 0 12px;
}

.searchPill {
  height: 38px;
  border-radius: 999px;
  display: flex;
  align-items: center;
  padding: 0 12px;
  gap: 8px;
}

.sIcon {
  color: var(--sub-ink);
  font-weight: 600;
}

.sIpt {
  width: 100%;
  border: 0;
  outline: none;
  background: transparent;
  color: var(--ink);
  font-family: inherit;
  font-size: 14px;
  font-weight: 600;
}

.sIpt::placeholder {
  color: #8d8377;
}

.hubTabs {
  margin-top: 12px;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 10px;
}

.hubTab {
  height: 44px;
  border-radius: 999px;
  font-weight: 600;
  cursor: pointer;
}

.hubTab.active,
.mineSubTab.active,
.pill.active {
  background: rgba(138, 47, 43, 0.08);
  border-color: rgba(138, 47, 43, 0.2);
  color: #6d211d;
}

.mineSubTabs {
  margin-top: 12px;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.mineSubTab {
  height: 36px;
  padding: 0 14px;
  border-radius: 999px;
  font-weight: 600;
  cursor: pointer;
}

.hubSecHead {
  margin-top: 16px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.secTitle {
  font-size: 18px;
  font-weight: 700;
  letter-spacing: 1px;
  color: #322a22;
}

.moreBtn,
.pill {
  height: 34px;
  padding: 0 14px;
  border-radius: 999px;
  font-weight: 600;
  cursor: pointer;
}

.playlistGrid {
  margin-top: 12px;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 14px;
}

.plist {
  border-radius: 8px;
  background: var(--paper-card);
  border: 1px solid var(--line);
  overflow: hidden;
  cursor: pointer;
  transition: 0.22s ease;
}

.plist:hover {
  transform: translateY(-3px);
  border-color: var(--line-strong);
}

.plistCover {
  position: relative;
  background-size: cover;
  background-position: center;
  aspect-ratio: 16 / 9;
  min-height: 180px;
  overflow: hidden;
}

.plistCover::after {
  content: "";
  position: absolute;
  inset: 0;
  background: rgba(255,255,255,0.06);
}

.coverShade {
  position: absolute;
  inset: 0;
  background:
    linear-gradient(180deg, rgba(40, 30, 20, 0.02), rgba(40, 30, 20, 0) 48%),
    linear-gradient(0deg, rgba(40, 30, 20, 0.32), rgba(40, 30, 20, 0) 58%);
}

.plistInfo {
  padding: 14px;
}

.plistName {
  font-size: 16px;
  font-weight: 700;
  color: #312a23;
}

.plistDesc {
  margin-top: 8px;
  font-size: 13px;
  line-height: 1.75;
  color: var(--sub-ink);
  min-height: 44px;
}

.plistTag {
  margin-top: 10px;
  display: inline-flex;
  align-items: center;
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(155, 123, 71, 0.09);
  color: #715932;
  font-size: 12px;
  font-weight: 600;
}

.plistPlay,
.plistFav,
.videoFavIcon,
.tasteVideoFavBtn {
  position: absolute;
  width: 36px;
  height: 36px;
  border-radius: 999px;
  border: 1px solid rgba(255,255,255,0.28);
  background: rgba(26, 22, 18, 0.52);
  color: rgba(255,255,255,0.96);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: 0.2s ease;
}

.plistPlay:hover,
.plistFav:hover,
.videoFavIcon:hover,
.tasteVideoFavBtn:hover {
  transform: translateY(-1px);
  background: rgba(26, 22, 18, 0.66);
}

.plistPlay {
  right: 12px;
  bottom: 12px;
}

.plistFav {
  left: 12px;
  bottom: 12px;
}

.videoFavIcon {
  top: 8px;
  left: 8px;
}

.tasteFavBtn {
  top: 12px;
  right: 12px;
  left: auto;
  bottom: auto;
}

.tasteActionWrap {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: end;
  justify-content: center;
  padding-bottom: 18px;
  z-index: 2;
}

.tasteDetailBtn {
  height: 38px;
  padding: 0 18px;
  border-radius: 999px;
  background: rgba(248, 244, 235, 0.22);
  border: 1px solid rgba(255,255,255,0.28);
  color: #fff;
  font-family: inherit;
  font-weight: 600;
  cursor: pointer;
  transition: 0.2s ease;
}

.tasteDetailBtn:hover {
  background: rgba(248, 244, 235, 0.3);
}

.favoriteAudioList {
  margin-top: 12px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.favAudioRow {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  border-radius: 8px;
  background: var(--paper-card);
  border: 1px solid var(--line);
  cursor: pointer;
  transition: 0.2s ease;
}

.favAudioRow:hover {
  border-color: var(--line-strong);
  transform: translateY(-1px);
}

.favAudioCover {
  width: 72px;
  height: 72px;
  border-radius: 6px;
  background-size: cover;
  background-position: center;
  flex-shrink: 0;
  position: relative;
  overflow: hidden;
}

.favAudioCover::after {
  content: "";
  position: absolute;
  inset: 0;
  background: rgba(255,255,255,0.06);
}

.playIconOverlay {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 34px;
  height: 34px;
  border-radius: 50%;
  background: rgba(0,0,0,0.58);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  opacity: 0;
  transition: opacity 0.2s;
}

.favAudioCover:hover .playIconOverlay {
  opacity: 1;
}

.favAudioInfo {
  flex: 1;
  min-width: 0;
}

.favAudioTitle {
  font-weight: 700;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.favAudioSub {
  margin-top: 8px;
  color: var(--sub-ink);
  font-weight: 600;
  font-size: 13px;
}

.favAudioActions {
  display: flex;
  gap: 10px;
  align-items: center;
}

.tasteDetailPanel {
  margin-top: 16px;
  border-radius: 10px;
  padding: 16px;
  background: var(--paper-card-strong);
  border: 1px solid var(--line);
}

.tasteDetailHead {
  display: flex;
  align-items: start;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 14px;
}

.tasteDetailTitle {
  font-size: 24px;
  font-weight: 700;
  letter-spacing: 1px;
}

.tasteDetailSub {
  margin-top: 6px;
  color: var(--sub-ink);
  font-weight: 600;
}

.tasteDetailBody {
  display: grid;
  grid-template-columns: 360px 1fr;
  gap: 16px;
}

.tasteSidebar {
  border-radius: 8px;
  padding: 14px;
  min-height: 420px;
}

.tasteSidebarTitle {
  font-size: 16px;
  font-weight: 700;
  margin-bottom: 12px;
}

.tasteVideoList {
  display: flex;
  flex-direction: column;
  gap: 12px;
  max-height: 620px;
  overflow: auto;
  padding-right: 2px;
}

.tasteVideoCard {
  position: relative;
  border-radius: 8px;
  background: rgba(255,255,255,0.38);
  border: 1px solid rgba(72, 60, 46, 0.08);
  padding: 12px;
  cursor: pointer;
  transition: 0.2s ease;
}

.tasteVideoCard:hover {
  transform: translateY(-2px);
  border-color: var(--line-strong);
}

.tasteVideoCard.active {
  background: rgba(138, 47, 43, 0.06);
  border-color: rgba(138, 47, 43, 0.18);
}

.tasteVideoCardTitle {
  font-size: 15px;
  font-weight: 700;
  line-height: 1.5;
}

.tasteVideoCardThumb {
  margin-top: 10px;
  width: 100%;
  aspect-ratio: 16 / 9;
  border-radius: 6px;
  background-size: cover;
  background-position: center;
  position: relative;
  overflow: hidden;
}

.tasteVideoCardThumb::after {
  content: "";
  position: absolute;
  inset: 0;
  background: rgba(255,255,255,0.06);
}

.tasteVideoCardMeta {
  margin-top: 8px;
  color: var(--sub-ink);
  font-size: 12px;
  font-weight: 600;
}

.tastePlayerWrap {
  border-radius: 8px;
  padding: 14px;
  min-height: 420px;
}

.tastePlayerHead {
  margin-bottom: 12px;
}

.tastePlayerCard {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.tastePlayerBox {
  position: relative;
  width: 100%;
  aspect-ratio: 16 / 9;
  border-radius: 6px;
  overflow: hidden;
  background: #000;
}

.tastePlayerBox video {
  width: 100%;
  height: 100%;
  object-fit: contain;
  background: #000;
}

.tastePlayerInfo {
  border-radius: 8px;
  padding: 16px;
  background: rgba(255,255,255,0.45);
  border: 1px solid var(--line);
}

.tasteNowTitle {
  font-size: 20px;
  font-weight: 700;
  line-height: 1.45;
}

.tasteNowMeta {
  margin-top: 8px;
  font-size: 13px;
  color: var(--sub-ink);
  font-weight: 600;
}

.tasteNowDesc {
  margin-top: 12px;
  line-height: 1.9;
  font-size: 14px;
  color: #52493e;
}

.tasteActions {
  margin-top: 12px;
  display: flex;
  justify-content: flex-end;
}

.listenGrid {
  margin-top: 12px;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 14px;
}

.listenCol {
  border-radius: 8px;
  overflow: hidden;
}

.colTitle {
  padding: 14px;
  font-weight: 700;
  color: #362d24;
  border-bottom: 1px solid rgba(72, 60, 46, 0.08);
}

.songRow {
  padding: 14px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 12px;
  border-bottom: 1px dashed rgba(72, 60, 46, 0.08);
}

.songRow:last-child {
  border-bottom: 0;
}

.songMain {
  flex: 1;
  min-width: 0;
  position: relative;
}

.songName {
  font-weight: 700;
}

.songMeta {
  margin-top: 6px;
  color: var(--sub-ink);
  font-weight: 600;
  font-size: 12px;
}

.badgeUp {
  position: absolute;
  right: 4px;
  top: 2px;
  color: var(--accent);
  font-weight: 700;
}

.songActions {
  display: flex;
  gap: 8px;
  align-items: center;
}

.rowIconBtn {
  height: 34px;
  min-width: 34px;
  padding: 0 10px;
  border-radius: 999px;
  font-weight: 600;
  cursor: pointer;
}

.rowIconBtn.solid {
  background: rgba(138, 47, 43, 0.08);
  border-color: rgba(138, 47, 43, 0.18);
  color: #6d211d;
}

.videoRecommendSection {
  margin-top: 2px;
}

.videoHead {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 16px;
}

.videoTitle {
  font-size: 22px;
  font-weight: 700;
  letter-spacing: 1px;
}

.videoSub {
  color: var(--sub-ink);
  font-weight: 600;
  margin-top: 4px;
  font-size: 14px;
}

.videoTabs {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.videoGrid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 16px;
  margin-bottom: 16px;
}

.videoItem {
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: 0.22s ease;
}

.videoItem:hover {
  transform: translateY(-3px);
  border-color: var(--line-strong);
}

.videoThumb {
  position: relative;
  aspect-ratio: 16 / 9;
  background-size: cover;
  background-position: center;
  overflow: hidden;
}

.videoThumb::after {
  content: "";
  position: absolute;
  inset: 0;
  background: rgba(255,255,255,0.05);
}

.thumbOverlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(0,0,0,0.08), rgba(0,0,0,0.28));
}

.videoCenterPlay {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: rgba(0,0,0,0.56);
  border: 1px solid rgba(255,255,255,0.2);
  color: white;
  font-size: 18px;
  cursor: pointer;
}

.videoDuration,
.videoQuality {
  position: absolute;
  right: 8px;
  padding: 4px 8px;
  border-radius: 6px;
  color: white;
  font-size: 12px;
  font-weight: 700;
}

.videoDuration {
  bottom: 8px;
  background: rgba(0,0,0,0.7);
}

.videoQuality {
  top: 8px;
  background: rgba(138, 47, 43, 0.88);
}

.videoInfo {
  padding: 14px;
}

.videoName {
  font-weight: 700;
  font-size: 15px;
  margin-bottom: 8px;
  line-height: 1.6;
}

.videoMeta {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 13px;
  color: var(--sub-ink);
  font-weight: 600;
  margin-bottom: 8px;
}

.videoTags {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

.videoTag {
  padding: 3px 8px;
  border-radius: 999px;
  background: rgba(155, 123, 71, 0.1);
  color: #715932;
  font-size: 11px;
  font-weight: 600;
}

.videoFoot {
  display: flex;
  justify-content: center;
  gap: 12px;
}

.videoModalMask {
  position: fixed;
  inset: 0;
  background: rgba(25, 22, 18, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 200;
  padding: 20px;
}

.videoModal {
  width: min(1200px, 95vw);
  max-height: 90vh;
  border-radius: 10px;
  overflow: hidden;
}

.videoModalHead {
  padding: 16px 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid rgba(72, 60, 46, 0.08);
}

.videoModalActions {
  display: flex;
  gap: 10px;
}

.videoModalBody {
  display: flex;
  flex-direction: column;
}

.videoPlayer {
  position: relative;
  background: #000;
  aspect-ratio: 16 / 9;
}

.videoPlayer video {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.videoDetails {
  padding: 20px;
}

.videoModalTitle,
.videoDetailTitle {
  font-size: 20px;
  font-weight: 700;
}

.videoDetailMeta {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
  font-size: 14px;
  color: var(--sub-ink);
  font-weight: 600;
  margin: 12px 0;
}

.videoDetailDesc {
  font-size: 14px;
  line-height: 1.8;
  color: #534a40;
  font-weight: 600;
}

.emptyBox {
  padding: 26px 12px;
  text-align: center;
  font-weight: 600;
  color: #8a7f73;
}

.queueMask {
  position: fixed;
  inset: 0;
  background: rgba(24, 20, 16, 0.28);
  z-index: 180;
  display: flex;
  align-items: stretch;
  justify-content: flex-end;
}

.queuePanel {
  width: min(420px, 92vw);
  height: 100vh;
  border-radius: 12px 0 0 12px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.queueHead {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 18px;
  border-bottom: 1px solid rgba(72, 60, 46, 0.08);
}

.queueTitle {
  font-size: 18px;
  font-weight: 700;
}

.queueBody {
  flex: 1;
  overflow: auto;
  padding: 8px 0;
}

.queueItem {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 14px 18px;
  cursor: pointer;
  border-bottom: 1px dashed rgba(72, 60, 46, 0.08);
  transition: 0.2s ease;
}

.queueItem:hover {
  background: rgba(255,255,255,0.42);
}

.queueItem.active {
  background: rgba(138, 47, 43, 0.06);
}

.queueIndex {
  width: 34px;
  text-align: center;
  font-weight: 700;
  color: #85796d;
}

.queueInfo {
  min-width: 0;
  flex: 1;
}

.queueItemTitle {
  font-weight: 700;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.queueItemSub {
  margin-top: 5px;
  font-size: 12px;
  color: var(--sub-ink);
  font-weight: 600;
}

.queueActions {
  display: flex;
  align-items: center;
  gap: 8px;
}

.queueFavBtn {
  height: 32px;
  min-width: 32px;
  padding: 0 8px;
  border-radius: 999px;
  font-weight: 600;
  cursor: pointer;
}

.queuePlaying {
  color: var(--accent);
  font-weight: 700;
  font-size: 13px;
}

.miniPlayer {
  position: fixed;
  left: 14px;
  right: 14px;
  bottom: 14px;
  height: 72px;
  border-radius: 12px;
  background: rgba(248, 244, 235, 0.96);
  border: 1px solid var(--line);
  box-shadow: none;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 12px;
  z-index: 110;
}

.mpLeft {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  min-width: 0;
}

.mpCover {
  width: 48px;
  height: 48px;
  border-radius: 999px;
  background-size: cover;
  background-position: center;
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(72, 60, 46, 0.08);
}

.mpCover::after {
  content: "";
  position: absolute;
  inset: 0;
  background: rgba(255,255,255,0.05);
}

.mpInfo {
  min-width: 0;
}

.mpTitle {
  font-weight: 700;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 56vw;
}

.mpSub {
  margin-top: 6px;
  color: var(--sub-ink);
  font-weight: 600;
  font-size: 12px;
}

.mpRight {
  display: flex;
  gap: 10px;
  align-items: center;
}

.mpBtn {
  height: 36px;
  padding: 0 14px;
  border-radius: 999px;
  font-weight: 600;
  cursor: pointer;
}

.mpBtn.ghost {
  background: rgba(248, 244, 235, 0.75);
}

.mpBtn.fav {
  background: rgba(138, 47, 43, 0.08);
  border-color: rgba(138, 47, 43, 0.18);
  color: #6d211d;
}

.forumBadge {
  position: fixed;
  left: 18px;
  bottom: 104px;
  width: 92px;
  height: 92px;
  border-radius: 999px;
  background: rgba(248, 244, 235, 0.96);
  border: 1px solid var(--line);
  box-shadow: none;
  cursor: pointer;
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
}

.fbTitle {
  font-weight: 700;
  color: #372d24;
}

.fbSub {
  color: var(--sub-ink);
  font-weight: 600;
  font-size: 12px;
}

.sealMark {
  position: absolute;
  right: 10px;
  top: 10px;
  width: 14px;
  height: 14px;
  border-radius: 50%;
  background: rgba(138, 47, 43, 0.9);
  box-shadow: 0 0 0 2px rgba(138, 47, 43, 0.12);
}

:deep(main),
:deep(.el-main),
:deep(.layout-main),
:deep(.page-shell) {
  background: transparent !important;
}

@media (max-width: 1320px) {
  .playlistGrid { grid-template-columns: repeat(3, 1fr); }
  .tasteDetailBody { grid-template-columns: 320px 1fr; }
}

@media (max-width: 1100px) {
  .playlistGrid { grid-template-columns: repeat(2, 1fr); }
  .listenGrid { grid-template-columns: 1fr; }
  .videoGrid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
  .tasteDetailBody { grid-template-columns: 1fr; }
}

@media (max-width: 860px) {
  .mainWrap {
    padding: 0 10px;
  }



  .playlistGrid { grid-template-columns: 1fr; }
  .videoGrid { grid-template-columns: 1fr; }
  .hubTabs { grid-template-columns: repeat(2, 1fr); }

  .ribbonInner {
    padding: 32px 16px 24px;
  }

  .ribbonTopLeft,
  .ribbonBottomRight {
    position: static;
  }

  .ribbonLayout {
    display: flex;
    flex-direction: column;
    gap: 14px;
  }

  .ribbonHero {
    min-height: auto;
    order: -1;
  }

  .ribbonTitle {
    font-size: 30px;
  }

  .ribbonSub {
    font-size: 13px;
    margin-top: 8px;
  }

  .miniPlayer {
    height: auto;
    flex-direction: column;
    align-items: stretch;
    gap: 10px;
  }

  .mpRight {
    justify-content: flex-end;
  }

  .forumBadge {
    bottom: 124px;
  }
}
</style>