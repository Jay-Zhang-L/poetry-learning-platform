import { createRouter, createWebHistory } from "vue-router";
import MainLayout from "../layouts/MainLayout.vue";
import Dictionary from "@/pages/dictionary/Dictionary.vue";

// ??
import Home from "../pages/Home.vue";
import Recite from "../pages/Recite.vue";
import Chuangzuo from "../pages/chuangzuo.vue";
import Library from "../pages/Library.vue";
import Center from "../pages/Center.vue";
import PoetryWindow from "../pages/PoetryWindow.vue";
import StoryPage from "../pages/story/StoryPage.vue";

// AI / ?? / ???
import AIAgentSquare from "../pages/AIAgentSquare.vue";
import AITeacher from "../pages/AITeacher.vue";
import PoetryMap from "../pages/PoetryMap.vue";
import KnowledgeBase from "../pages/KnowledgeBase.vue";
import KnowledgeDetail from "../pages/KnowledgeDetail.vue";
import AgentChat from "../pages/season/AgentChat.vue";

// 鐧诲綍娉ㄥ唽
import Login from "../pages/auth/Login.vue";
import Register from "../pages/auth/Register.vue";

// 娓告垙
import Game from "../pages/Game.vue";
import Feihualing from "../pages/game/Feihualing.vue";
import Jielong from "../pages/game/Jielong.vue";
import ShiciMatch from "../pages/game/ShiciMatch.vue";
import MazeGame from "../pages/game/MazeGame.vue";
import PoetQuiz from "../pages/game/PoetQuiz.vue";
import PoetMoments from "../pages/game/PoetMoments.vue";
import PoetMomentsRecords from "../pages/game/PoetMomentsRecords.vue";
import PoetMomentsPoetDetail from "../pages/game/PoetMomentsPoetDetail.vue";

// 璧涘
import Season from "../pages/season/Season.vue";

// 璁哄潧
import ForumList from "../pages/forum/ForumList.vue";
import PostDetail from "../pages/forum/PostDetail.vue";
import PostEditor from "../pages/forum/PostEditor.vue";

// 鏈楄褰曢煶璇勪环
import Recording from "../recite/Recording.vue";
import RecordingHistory from "../recite/RecordingHistory.vue";

// 鍒涗綔鎵╁睍
import ChuangzuoPublish from "../pages/chuangzuo/Publish.vue";
import ChuangzuoMy from "../pages/chuangzuo/MyWorks.vue";
import ChuangzuoSearch from "../pages/chuangzuo/Search.vue";
import ChuangzuoDetail from "../pages/chuangzuo/Detail.vue";
import ChuangzuoNotifications from "../pages/chuangzuo/Notifications.vue";
import AuthorProfile from "../pages/chuangzuo/Author.vue";

// 绉佷俊鑱婂ぉ
import Chat from "../pages/chat/Chat.vue";

// ????
import SongPainted from "../pages/song-painted/SongPainted.vue";
import PhysicsBookDemo from "../pages/PhysicsBookDemo.vue";

// ???????
const CenterProfile = () => import("../pages/center/Profile.vue");
const CenterHistory = () => import("../pages/center/History.vue");
const CenterFav = () => import("../pages/center/Fav.vue");
const CenterFeedback = () => import("../pages/center/Feedback.vue");
const CenterSettings = () => import("../pages/center/Settings.vue");
const CenterLikes = () => import("../pages/center/Likes.vue");
const CenterLikedMe = () => import("../pages/center/LikedMe.vue");
const CenterMutualFollowing = () => import("../pages/center/MutualFollowing.vue");
const CenterCreationStats = () => import("../pages/center/CreationStats.vue");
const CenterFollowing = () => import("../pages/center/Following.vue");
const CenterFollowers = () => import("../pages/center/Followers.vue");
const CenterConversations = () => import("../pages/center/Conversations.vue");

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: "/login", name: "Login", component: Login },
    { path: "/register", name: "Register", component: Register },

    {
      path: "/",
      component: MainLayout,
      children: [
        { path: "", redirect: "/home" },
        // ???
        { path: "home", name: "Home", component: Home },
        { path: "home/page4/shi", name: "HomeShi", component: () => import("@/pages/home/page4/shi.vue"), meta: { fullscreen: true, title: "诗" } },
        { path: "home/page4/ge", name: "HomeGe", component: () => import("@/pages/home/page4/ge.vue"), meta: { fullscreen: true, title: "歌" } },
        { path: "home/page4/fu", name: "HomeFu", component: () => import("@/pages/home/page4/fu.vue"), meta: { fullscreen: true, title: "赋" } },
        { path: "home/page4/ci", name: "HomeCi", component: () => import("@/pages/home/page4/ci.vue"), meta: { fullscreen: true, title: "词" } },
        { path: "home/page4/qu", name: "HomeQu", component: () => import("@/pages/home/page4/qu.vue"), meta: { fullscreen: true, title: "曲" } },
        {
          path: "home/page4/xiandaishi",
          name: "HomeXiandaishi",
          component: () => import("@/pages/home/page4/xiandaishi.vue"),
          meta: { fullscreen: true, title: "现代诗" },
        },

        { path: "home/page2/a1", name: "HomeA1", component: () => import("@/pages/home/page2/a1.vue"), meta: { fullscreen: true, title: "鍏堢Е" } },
        { path: "home/page2/a2", name: "HomeA2", component: () => import("@/pages/home/page2/a2.vue"), meta: { fullscreen: true, title: "榄忔檵" } },
        { path: "home/page2/a3", name: "HomeA3", component: () => import("@/pages/home/page2/a3.vue"), meta: { fullscreen: true, title: "鍞愪唬" } },
        { path: "home/page2/a4", name: "HomeA4", component: () => import("@/pages/home/page2/a4.vue"), meta: { fullscreen: true, title: "瀹嬩唬" } },
        { path: "home/page2/a5", name: "HomeA5", component: () => import("@/pages/home/page2/a5.vue"), meta: { fullscreen: true, title: "鍏冧唬" } },
        { path: "home/page2/a6", name: "HomeA6", component: () => import("@/pages/home/page2/a6.vue"), meta: { fullscreen: true, title: "娓呬唬" } },

        { path: "recite", name: "Recite", component: Recite },
        { path: "chuangzuo", name: "Chuangzuo", component: Chuangzuo },
        { path: "learn", name: "Learn", component: Chuangzuo },
        { path: "library", name: "Library", component: Library },

        // 千年谱·画
        {
          path: "song-painted",
          name: "SongPainted",
          component: SongPainted,
          meta: {
            title: "千年谱·画",
            requiresAuth: false,
            fullscreen: true,
          },
        },

        // 璇楃獥
        {
          path: "shichuang",
          name: "PoetryWindow",
          component: PoetryWindow,
          meta: { title: "璇楃獥" },
        },

        // 璇楀绌洪棿
        {
          path: "splat",
          name: "SplatSceneList",
          component: () => import("@/pages/splat/SplatSceneList.vue"),
          meta: { title: "璇楀绌洪棿" },
        },
        {
          path: "splat/:id",
          name: "SplatSceneDetail",
          component: () => import("@/pages/splat/SplatSceneDetail.vue"),
          props: true,
          meta: { title: "鍦烘櫙璇︽儏", fullscreen: true },
        },
        {
          path: "scene/bonsai",
          name: "SplatScene",
          component: () => import("@/pages/SplatScene.vue"),
        },

        // 鍏告晠
        {
          path: "story",
          name: "StoryPage",
          component: StoryPage,
          meta: { title: "鍏告晠婧簮" },
        },

        // AI
        { path: "ai", name: "AIAgentSquare", component: AIAgentSquare },
        { path: "ai-teacher", name: "AITeacher", component: AITeacher },
        { path: "poetry-map", name: "PoetryMap", component: PoetryMap },

        // 知识库
        {
          path: "knowledge-base",
          name: "KnowledgeBase",
          component: KnowledgeBase,
          meta: { title: "知识库" },
        },
        {
          path: "knowledge-detail",
          name: "KnowledgeDetail",
          component: KnowledgeDetail,
          meta: { title: "鐭ヨ瘑璇︽儏" },
        },

        {
          path: "dictionary",
          name: "Dictionary",
          component: Dictionary,
        },

        // 涓汉涓績
        { path: "center", name: "Center", component: Center },
        { path: "center/profile", name: "CenterProfile", component: CenterProfile },
        { path: "center/history", name: "CenterHistory", component: CenterHistory },
        { path: "center/fav", name: "CenterFav", component: CenterFav },
        { path: "center/feedback", name: "CenterFeedback", component: CenterFeedback },
        { path: "center/settings", name: "CenterSettings", component: CenterSettings },
        { path: "center/likes", name: "CenterLikes", component: CenterLikes },
        { path: "center/liked-me", name: "CenterLikedMe", component: CenterLikedMe },
        { path: "center/mutual-following", name: "CenterMutualFollowing", component: CenterMutualFollowing },
        { path: "center/following", name: "CenterFollowing", component: CenterFollowing },
        { path: "center/followers", name: "CenterFollowers", component: CenterFollowers },
        { path: "center/creation-stats", name: "CenterCreationStats", component: CenterCreationStats },
        { path: "center/conversations", name: "CenterConversations", component: CenterConversations },

        // 璇嶅吀璇︽儏椤?        { path: "b2", component: () => import("@/pages/dictionary/b2.vue") },
        { path: "b1", component: () => import("@/pages/dictionary/b1.vue") },
        { path: "b3", component: () => import("@/pages/dictionary/b3.vue") },
        { path: "b4", component: () => import("@/pages/dictionary/b4.vue") },
        { path: "b5", component: () => import("@/pages/dictionary/b5.vue") },

        // 娓告垙
        { path: "game", name: "Game", component: Game },
        { path: "game/feihualing", name: "Feihualing", component: Feihualing },
        { path: "game/jielong", name: "Jielong", component: Jielong },
        { path: "game/shici-match", name: "ShiciMatch", component: ShiciMatch },
        { path: "game/maze", name: "MazeGame", component: MazeGame },
        { path: "game/poet-quiz", name: "PoetQuiz", component: PoetQuiz },
        { path: "game/poet-moments", name: "PoetMoments", component: PoetMoments },
        { path: "game/poet-moments/records", name: "PoetMomentsRecords", component: PoetMomentsRecords },
        { path: "game/poet-moments/poet", name: "PoetMomentsPoetDetail", component: PoetMomentsPoetDetail },

        // 璧涘
        { path: "season", name: "Season", component: Season },

        // 璁哄潧
        { path: "forum", name: "ForumList", component: ForumList },
        { path: "forum/new", name: "PostEditor", component: PostEditor },
        { path: "forum/post/:id", name: "PostDetail", component: PostDetail, props: true },

        // 鏈楄褰曢煶璇勪环
        { path: "recite/recording", name: "Recording", component: Recording },
        { path: "recite/recording/history", name: "RecordingHistory", component: RecordingHistory },

        // 鍒涗綔
        { path: "chuangzuo/publish", name: "ChuangzuoPublish", component: ChuangzuoPublish },
        { path: "chuangzuo/edit/:id", name: "ChuangzuoEdit", component: ChuangzuoPublish, props: true },
        { path: "chuangzuo/my", name: "ChuangzuoMy", component: ChuangzuoMy },
        { path: "chuangzuo/search", name: "ChuangzuoSearch", component: ChuangzuoSearch },
        { path: "chuangzuo/notifications", name: "ChuangzuoNotifications", component: ChuangzuoNotifications },
        { path: "chuangzuo/:id", name: "ChuangzuoDetail", component: ChuangzuoDetail, props: true },

        // 浣滆€呬富椤?
        { path: "author/:id", name: "AuthorProfile", component: AuthorProfile, props: true },

        // 绉佷俊鑱婂ぉ
        { path: "chat/:id", name: "Chat", component: Chat, props: true },
      ],
    },

    { path: "/agent-chat", name: "AgentChat", component: AgentChat },
    { path: "/physics-book/:bookId?", name: "PhysicsBookDemo", component: PhysicsBookDemo, props: true },

    { path: "/:pathMatch(.*)*", redirect: "/home" },
  ],
});

export default router;

