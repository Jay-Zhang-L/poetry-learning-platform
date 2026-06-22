// src/utils/api.js

/* =========================
   基础配置
   ========================= */

// 使用 Vite 代理，开发环境不直接写死后端地址
const BASE_URL = "";

/**
 * 获取请求头，包含认证信息
 * @param {boolean} isFormData - 是否是 FormData 请求
 */
export function getAuthHeaders(isFormData = false, additionalHeaders = {}) {
  const headers = {
    ...additionalHeaders,
  };
  
  // 如果不是 FormData，才设置 Content-Type
  if (!isFormData) {
    headers["Content-Type"] = "application/json; charset=UTF-8";
  }

  const token = localStorage.getItem("token");
  if (token) {
    headers["Authorization"] = `Bearer ${token}`;
  }

  return headers;
}

/**
 * 统一处理响应
 */
async function handleResponse(response) {
  const contentType = response.headers.get("content-type") || "";
  const isJson = contentType.includes("application/json");

  let data;
  try {
    data = isJson ? await response.json() : await response.text();
  } catch (e) {
    data = null;
  }

  if (!response.ok) {
    const msg =
      (isJson && data && (data.msg || data.message || data.error)) ||
      `请求失败：${response.status} ${response.statusText}`;
    console.error("接口错误:", msg, data);
    throw new Error(msg);
  }

  return data;
}

/**
 * 通用认证请求 - 自动添加 Authorization header
 */
export async function authFetch(url, options = {}) {
  const finalUrl = url.startsWith("http") ? url : `${BASE_URL}${url}`;

  // 获取 Token 并添加到 headers
  const token = localStorage.getItem("token");
  const headers = {
    "Content-Type": "application/json; charset=UTF-8",
    ...(options.headers || {}),
  };
  
  if (token) {
    headers["Authorization"] = `Bearer ${token}`;
  }

  const finalOptions = {
    method: "GET",
    credentials: "include",
    ...options,
    headers: headers,
  };

  // 如果 body 是 FormData，删除 Content-Type 让浏览器自动设置
  if (finalOptions.body instanceof FormData) {
    delete headers["Content-Type"];
  }

  console.log("发送认证请求:", finalUrl, finalOptions);

  const response = await fetch(finalUrl, finalOptions);
  return handleResponse(response);
}

/* =========================
   通用请求方法
   ========================= */

export const authGet = (url, options = {}) =>
  authFetch(url, {
    method: "GET",
    ...options,
  });

/**
 * POST 请求，支持普通 JSON 和 FormData
 * @param {string} url - 请求地址
 * @param {Object|FormData} data - 请求数据
 * @param {Object} options - 额外配置
 */
export const authPost = (url, data = {}, options = {}) => {
  const isFormData = data instanceof FormData;
  
  const fetchOptions = {
    method: "POST",
    ...options,
  };
  
  if (isFormData) {
    // FormData 直接作为 body，不设置 Content-Type（让浏览器自动设置）
    fetchOptions.body = data;
    fetchOptions.headers = getAuthHeaders(true, options.headers || {});
  } else {
    // 普通 JSON 数据
    fetchOptions.body = JSON.stringify(data);
    fetchOptions.headers = getAuthHeaders(false, options.headers || {});
  }
  
  return authFetch(url, fetchOptions);
};

export const authPut = (url, data = {}, options = {}) =>
  authFetch(url, {
    method: "PUT",
    body: JSON.stringify(data),
    headers: getAuthHeaders(false, options.headers || {}),
    ...options,
  });

export const authDelete = (url, options = {}) =>
  authFetch(url, {
    method: "DELETE",
    headers: getAuthHeaders(false, options.headers || {}),
    ...options,
  });

/* =========================
   AI 相关接口
   ========================= */

const AI_BASE_URL = "/api/ai";

export function aiChat(message, mode = "三步法讲解", poemTitle = "") {
  return authPost(`${AI_BASE_URL}/chat`, {
    message,
    mode,
    poemTitle,
  });
}

export function getAiModes() {
  return authGet(`${AI_BASE_URL}/modes`);
}

export function checkAiHealth() {
  return authGet(`${AI_BASE_URL}/health`);
}

/**
 * AI润色接口
 * @param {string} content - 诗词内容
 */
export const polishPoem = (content) => {
  return authPost('/api/ai/polish', { content });
};

/**
 * 检查韵脚接口
 * @param {string} content - 诗词内容
 */
export const checkRhyme = (content) => {
  return authPost('/api/ai/check-rhyme', { content });
};

/**
 * 图片生成诗词接口
 * @param {FormData} formData - 包含图片的 FormData
 */
export const generateFromImage = (formData) => {
  return authPost('/api/ai/generate-from-image', formData);
};

/* =========================
   飞花令相关接口
   ========================= */

export function getFeiHuaTopics() {
  return authGet("/api/gameplay/feihua/topics");
}

export function startFeiHuaGame(data = {}) {
  return authPost("/api/gameplay/feihua/start", data);
}

export function getFeiHuaSession(sessionId) {
  return authGet(`/api/gameplay/feihua/session/${sessionId}`);
}

export function submitFeiHuaAnswer(data = {}) {
  return authPost("/api/gameplay/feihua/submit", data);
}

export function skipFeiHua(sessionId) {
  return authPost(`/api/gameplay/feihua/skip/${sessionId}`, {});
}

export function hintFeiHua(sessionId) {
  return authPost(`/api/gameplay/feihua/hint/${sessionId}`, {});
}

export function getFeiHuaRank() {
  return authGet("/api/gameplay/feihua/rank");
}

export function searchFeiHua(q) {
  const keyword = encodeURIComponent(q || "");
  return authGet(`/api/gameplay/feihua/search?q=${keyword}`);
}

/* =========================
   诗词接龙相关接口
   ========================= */

export function startRelayGame(data = {}) {
  return authPost("/api/gameplay/relay/start", data);
}

export function submitRelayAnswer(data = {}) {
  return authPost("/api/gameplay/relay/submit", data);
}

export function getRelaySession(sessionId) {
  return authGet(`/api/gameplay/relay/session/${sessionId}`);
}

export function getRelayHistory(sessionId) {
  return authGet(`/api/gameplay/relay/history/${sessionId}`);
}

export function getRelayRank() {
  return authGet("/api/gameplay/relay/rank");
}

/* =========================
   首页总排行榜接口
   ========================= */

export function getGameTotalRank() {
  return authGet("/api/gameplay/relay/rank/total");
}

/* =========================
   侧边栏排行接口
   ========================= */

export const getRanking48h = () => authGet('/api/ranking/48h');
export const getRanking10d = () => authGet('/api/ranking/10d');
export const getHot15d = () => authGet('/api/ranking/hot15d');
export const getEditorPick = () => authGet('/api/ranking/editor');

/* =========================
   朗诵模块接口
   ========================= */

export function getRecitePlaylists(type = "album") {
  return authGet(`/api/recite/playlists?type=${encodeURIComponent(type)}`);
}

export function getRecitePlaylistItems(playlistId) {
  return authGet(`/api/recite/playlists/${playlistId}/items`);
}

export function getRecitePlaylistVideos(playlistId) {
  return authGet(`/api/recite/playlists/${playlistId}/videos`);
}

// 收藏相关
export function getReciteMyFavorites() {
  return authGet("/api/recite/my/favorites");
}

export function getReciteMyFavoriteAudios() {
  return authGet("/api/recite/my/favorite-audios");
}

export function getReciteMyFavoriteVideos() {
  return authGet("/api/recite/my/favorite-videos");
}

// 最近播放相关
export function getReciteMyRecentPlaylists() {
  return authGet("/api/recite/my/recent-playlists");
}

export function getReciteMyRecentAudios() {
  return authGet("/api/recite/my/recent-audios");
}

export function getReciteMyRecentVideos() {
  return authGet("/api/recite/my/recent-videos");
}

export function getReciteMyRecent() {
  return authGet("/api/recite/my/recent");
}

// 大家都在听
export function getReciteListen() {
  return authGet("/api/recite/listen");
}

// 视频推荐
export function getReciteVideos(type = "master") {
  return authGet(`/api/recite/videos?type=${encodeURIComponent(type)}`);
}

// 播放记录
export function addRecitePlay(data = {}) {
  return authPost("/api/recite/play", data);
}

export function addReciteVideoPlay(data = {}) {
  return authPost("/api/recite/video/play", data);
}

// 收藏操作
export function addReciteFavorite(data = {}) {
  return authPost("/api/recite/favorite", data);
}

export function removeReciteFavorite(targetId, favoriteType) {
  return authDelete(
    `/api/recite/favorite?targetId=${encodeURIComponent(
      targetId
    )}&favoriteType=${encodeURIComponent(favoriteType)}`
  );
}

export function getReciteFavoriteStatus(targetId, favoriteType) {
  return authGet(
    `/api/recite/favorite/status?targetId=${encodeURIComponent(
      targetId
    )}&favoriteType=${encodeURIComponent(favoriteType)}`
  );
}

/* =========================
   视频模块接口
   ========================= */

export function getVideoList() {
  return authGet("/api/video/list");
}

export function getRecommendVideos() {
  return authGet("/api/video/recommend");
}

export function getVideoById(id) {
  return authGet(`/api/video/${id}`);
}

export function getVideosByCategory(category) {
  return authGet(`/api/video/category/${encodeURIComponent(category)}`);
}

export function addVideoView(id) {
  return authPost(`/api/video/${id}/view`, {});
}

/* =========================
   诗词趣消消接口
   ========================= */

export function getPoemMatchLevel(levelId = 1) {
  return authGet(`/api/game/poem-match/level/${levelId}`);
}

export function startPoemMatchGame(data = {}) {
  return authPost("/api/game/poem-match/start", data);
}

export function addPoemMatchScore(data = {}) {
  return authPost("/api/game/poem-match/add-score", data);
}

export function submitPoemMatchResult(data = {}) {
  return authPost("/api/game/poem-match/submit", data);
}

export function getPoemMatchRank() {
  return authGet("/api/game/poem-match/rank");
}

/* =========================
   知识卡片相关接口
   ========================= */

export function getKnowledgeList() {
  return authGet("/api/knowledge/list");
}

export function getKnowledgeDetail(pageKey) {
  return authGet(`/api/knowledge/detail/${pageKey}`);
}

/**
 * 获取诗词列表（分页）
 * @param {Object} params - 查询参数
 * @param {number} params.page - 页码
 * @param {number} params.size - 每页数量
 * @param {string} params.kw - 关键词搜索
 * @param {string} params.dynasty - 朝代筛选
 * @param {string} params.genre - 体裁筛选
 * @param {string} params.theme - 主题筛选
 * @param {string} params.sortKey - 排序字段
 * @returns {Promise<Object>} 分页诗词列表
 */
export function getPoemsList(params = {}) {
  const query = new URLSearchParams();
  if (params.page) query.append("page", params.page);
  if (params.size) query.append("size", params.size);
  if (params.kw) query.append("kw", params.kw);
  if (params.dynasty) query.append("dynasty", params.dynasty);
  if (params.genre) query.append("genre", params.genre);
  if (params.theme) query.append("theme", params.theme);
  if (params.sortKey) query.append("sortKey", params.sortKey);

  const url = `/api/poems/page${query.toString() ? "?" + query.toString() : ""}`;
  return authGet(url);
}

/**
 * 搜索诗词（简化的搜索接口）
 * @param {string} keyword - 搜索关键词
 * @param {number} limit - 返回数量限制
 * @returns {Promise<Array>} 诗词列表
 */
export function searchPoems(keyword = "", limit = 50) {
  const params = {
    page: 1,
    size: limit,
    kw: keyword || undefined,
    sortKey: "hot",
  };
  return getPoemsList(params);
}

/* =========================
   朗诵诗词选择接口
   ========================= */

/**
 * 获取可朗诵诗词列表（分页）
 * @param {Object} params - 查询参数
 * @param {number} params.difficultyLevel - 难度等级：1入门、2初级、3中级、4高级、5挑战
 * @param {string} params.emotionType - 情感类型：思乡、爱国、山水、送别、边塞、春景、秋景、豪放等
 * @param {string} params.keyword - 搜索关键词（匹配标题/诗人/内容）
 * @param {number} params.page - 页码，默认1
 * @param {number} params.size - 每页数量，默认10，最大50
 * @returns {Promise<Object>} 分页诗词列表
 */
export function getRecitePoems(params = {}) {
  const query = new URLSearchParams();
  if (params.difficultyLevel) query.append("difficultyLevel", params.difficultyLevel);
  if (params.emotionType) query.append("emotionType", params.emotionType);
  if (params.keyword) query.append("keyword", params.keyword);
  if (params.page) query.append("page", params.page);
  if (params.size) query.append("size", params.size);

  const url = `/api/recite/poems${query.toString() ? "?" + query.toString() : ""}`;
  return authGet(url);
}

/**
 * 获取朗诵诗词详情
 * @param {number|string} id - 诗词ID
 * @returns {Promise<Object>} 诗词详情
 */
export function getRecitePoemDetail(id) {
  return authGet(`/api/recite/poems/${id}`);
}

/* =========================
   朗诵录音评价相关接口
   ========================= */

/**
 * 提交录音并获取AI评价
 * @param {Object} data - 包含 poemId, poemTitle, poemContent, audio(Blob), audioDuration
 * @returns {Promise<Object>} 评价结果
 */
export async function submitReciteRecording(data) {
  const formData = new FormData();
  formData.append("poemId", data.poemId);
  if (data.poemTitle) formData.append("poemTitle", data.poemTitle);
  if (data.poemContent) formData.append("poemContent", data.poemContent);
  if (data.audio) formData.append("audio", data.audio, "recording.wav");
  if (data.audioDuration) formData.append("audioDuration", data.audioDuration);

  return authFetch("/api/recite/recording/submit", {
    method: "POST",
    body: formData,
  });
}

/**
 * 获取用户的录音评价记录列表
 * @returns {Promise<Array>} 录音评价记录列表
 */
export function getReciteRecordingList() {
  return authGet("/api/recite/recording/my");
}

/**
 * 获取用户对某首诗的录音评价记录
 * @param {number|string} poemId - 诗词ID
 * @returns {Promise<Array>} 录音评价记录列表
 */
export function getReciteRecordingByPoem(poemId) {
  return authGet(`/api/recite/recording/my/${poemId}`);
}

/**
 * 获取录音评价详情
 * @param {number|string} id - 录音评价ID
 * @returns {Promise<Object>} 录音评价详情
 */
export function getReciteRecordingDetail(id) {
  return authGet(`/api/recite/recording/${id}`);
}

/**
 * 删除录音评价记录
 * @param {number|string} id - 录音评价ID
 * @returns {Promise<string>} 删除结果
 */
export function deleteReciteRecording(id) {
  return authDelete(`/api/recite/recording/${id}`);
}

/* =========================
   迷宫游戏接口
   ========================= */

export function getMazeLevels(seasonNo = 1) {
  return authGet(`/api/game/maze/levels?seasonNo=${seasonNo}`);
}

export function getMazeLevel(seasonNo = 1, levelNo = 1) {
  return authGet(`/api/game/maze/level?seasonNo=${seasonNo}&levelNo=${levelNo}`);
}

export function getMazeProgress(seasonNo = 1, levelNo = 1) {
  return authGet(`/api/game/maze/progress?seasonNo=${seasonNo}&levelNo=${levelNo}`);
}

export function getMazeRank(seasonNo = 1) {
  return authGet(`/api/game/maze/rank?seasonNo=${seasonNo}`);
}

export function submitMazeLine(data = {}) {
  return authPost("/api/game/maze/submit-line", data);
}

/* =========================
   词典接口
   ========================= */

export function getDictionaryHome() {
  return authGet("/api/dictionary/home");
}

export function searchDictionary(keyword) {
  return authGet(`/api/dictionary/search?keyword=${encodeURIComponent(keyword || "")}`);
}

export function getDictionaryDetail(id) {
  return authGet(`/api/dictionary/${id}`);
}

/* =========================
   诗词收藏接口
   ========================= */

// 添加收藏
export function addPoemFavorite(poemId) {
  return authPost(`/api/poems/${poemId}/fav`, {});
}

// 取消收藏
export function removePoemFavorite(poemId) {
  return authDelete(`/api/poems/${poemId}/fav`);
}

// 获取收藏列表
export function getPoemFavorites(pageNum = 1, pageSize = 12) {
  return authGet(`/api/poems/favorites?pageNum=${pageNum}&pageSize=${pageSize}`);
}

// 检查收藏状态
export function checkPoemFavoriteStatus(poemId) {
  return authGet(`/api/poems/${poemId}/fav/status`);
}

/* =========================
   诗窗接口
   ========================= */

/**
 * 识诗搜索
 * 根据用户输入的诗句、关键词，搜索诗词
 */
export function searchShiChuangPoems(keyword = "", limit = 12) {
  const query = new URLSearchParams();
  if (keyword) query.append("keyword", keyword);
  if (limit) query.append("limit", limit);

  const url = `/api/shichuang/search${query.toString() ? "?" + query.toString() : ""}`;
  return authGet(url);
}

/**
 * 风景配诗推荐
 */
export function recommendShiChuangPoems(params = {}) {
  return authPost("/api/shichuang/recommend", {
    season: params.season || "",
    emotion: params.emotion || "",
    scenery: params.scenery || "",
    theme: params.theme || "",
    limit: params.limit || 12,
  });
}

export function getStoryRecommendations(params = {}) {
  const query = new URLSearchParams();
  if (params.storyId) query.append("storyId", params.storyId);
  if (params.dynasty) query.append("dynasty", params.dynasty);
  if (params.size) query.append("size", params.size);

  const url = `/api/recommendation/stories${query.toString() ? "?" + query.toString() : ""}`;
  return authGet(url);
}
export function getHotStories(size = 10) {
  return authGet(`/api/recommendation/hot?size=${size}`);
}
export function recordStoryAction(data = {}) {
  return authPost("/api/recommendation/action", data);
}
/**
 * 获取诗窗详情
 */
export function getShiChuangDetail(id) {
  return authGet(`/api/shichuang/${id}`);
}
/* =========================
   诗境空间接口
   ========================= */

/**
 * 搜索诗境场景列表
 * @param {string} keyword - 关键词，可匹配标题/作者/朝代
 */
export function searchSplatSceneList(keyword = "") {
  const query = new URLSearchParams();
  if (keyword) query.append("kw", keyword);

  const url = `/api/splat-scene/list${query.toString() ? "?" + query.toString() : ""}`;
  return authGet(url);
}

/**
 * 获取诗境场景详情
 * @param {number|string} id - 场景ID
 */
export function getSplatSceneDetail(id) {
  return authGet(`/api/splat-scene/detail?id=${encodeURIComponent(id)}`);
}