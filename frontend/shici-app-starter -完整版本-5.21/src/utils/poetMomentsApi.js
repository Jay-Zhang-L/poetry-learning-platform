import { authGet, authPost } from "@/utils/api";

function ensureSuccess(res) {
    const code = res?.code;
    if (code === 200) return res;
    const msg = res?.message || res?.msg || "请求失败";
    throw new Error(msg);
}

/** GET /api/game/random-moment */
export async function fetchRandomMoment() {
    const res = await authGet("/api/game/random-moment");
    return ensureSuccess(res);
}

/** POST /api/game/submit-answer */
export async function submitMomentAnswer(data) {
    const res = await authPost("/api/game/submit-answer", data);
    return ensureSuccess(res);
}

/** GET /api/game/user-records?user_id= */
export async function fetchUserRecords(userId) {
    const q = new URLSearchParams({ user_id: String(userId) });
    const res = await authGet(`/api/game/user-records?${q.toString()}`);
    return ensureSuccess(res);
}

/** GET /api/game/poet-detail?poet_id= */
export async function fetchPoetDetail(poetId) {
    const q = new URLSearchParams({ poet_id: String(poetId) });
    const res = await authGet(`/api/game/poet-detail?${q.toString()}`);
    return ensureSuccess(res);
}