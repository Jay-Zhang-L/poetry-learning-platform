import { authGet, authPost, authDelete } from "@/utils/api";

const BASE = "/api/gameplay/poet-quiz";

function ensureSuccess(res) {
    const code = res?.code;
    if (code === 200) return res;
    const msg = res?.message || res?.msg || "请求失败";
    throw new Error(msg);
}

export async function getPoetQuizList() {
    const res = await authGet(`${BASE}/quizzes`);
    return ensureSuccess(res);
}

export async function getPoetQuizDetail(quizId) {
    const res = await authGet(`${BASE}/quiz/${encodeURIComponent(quizId)}`);
    return ensureSuccess(res);
}

export async function startPoetQuiz(data = {}) {
    const res = await authPost(`${BASE}/start`, data);
    return ensureSuccess(res);
}

export async function answerPoetQuiz(data = {}) {
    const res = await authPost(`${BASE}/answer`, data);
    return ensureSuccess(res);
}

export async function submitPoetQuiz(data = {}) {
    const res = await authPost(`${BASE}/submit`, data);
    return ensureSuccess(res);
}

export async function getPoetQuizAttempt(attemptId) {
    const res = await authGet(`${BASE}/attempt/${encodeURIComponent(attemptId)}`);
    return ensureSuccess(res);
}

export async function getPoetProfile(poetId) {
    const res = await authGet(`${BASE}/poets/${encodeURIComponent(poetId)}`);
    return ensureSuccess(res);
}

// 获取历史记录列表
export async function getMyPoetQuizAttempts(params = {}) {
    const query = new URLSearchParams();
    if (params.page != null) query.append("page", String(params.page));
    if (params.size != null) query.append("size", String(params.size));
    if (params.status) query.append("status", String(params.status));

    const url = `${BASE}/attempts/my${query.toString() ? `?${query.toString()}` : ""}`;
    const res = await authGet(url);
    return ensureSuccess(res);
}

// 删除某条历史记录
export async function deletePoetQuizAttempt(attemptId) {
    const res = await authDelete(`${BASE}/attempt/${encodeURIComponent(attemptId)}`);
    return ensureSuccess(res);
}