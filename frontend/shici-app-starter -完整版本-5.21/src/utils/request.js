// src/utils/request.js

/**
 * 获取请求头，包含认证信息
 * @param {Object} additionalHeaders - 额外的请求头
 * @param {any} body - 请求体，用于判断是否为 FormData
 * @returns {Object} 完整的请求头
 */
export function getAuthHeaders(additionalHeaders = {}, body = null) {
  const headers = {
    ...additionalHeaders,
  };

  // 只有非 FormData 时才设置 JSON Content-Type
  if (!(body instanceof FormData) && !headers["Content-Type"]) {
    headers["Content-Type"] = "application/json";
  }

  const token = localStorage.getItem("token");
  if (token) {
    headers["Authorization"] = `Bearer ${token}`;
  }

  return headers;
}

/**
 * 统一处理响应
 * @param {Response} response
 * @returns {Promise<any>}
 */
export async function handleResponse(response) {
  const contentType = response.headers.get("content-type") || "";

  let result;
  if (contentType.includes("application/json")) {
    result = await response.json();
  } else {
    const text = await response.text();
    result = {
      code: response.ok ? 200 : response.status,
      msg: text || (response.ok ? "成功" : "请求失败"),
      data: null,
    };
  }

  if (!response.ok) {
    throw new Error(result?.msg || `HTTP ${response.status}`);
  }

  return result;
}

/**
 * 发送认证请求
 * @param {string} url - 请求URL
 * @param {Object} options - fetch选项
 * @returns {Promise<any>}
 */
export async function authFetch(url, options = {}) {
  const body = options.body ?? null;

  const defaultOptions = {
    credentials: "include",
    headers: getAuthHeaders(options.headers || {}, body),
  };

  const finalOptions = {
    ...defaultOptions,
    ...options,
    headers: {
      ...defaultOptions.headers,
      ...(options.headers || {}),
    },
  };

  // FormData 时移除手动设置的 Content-Type，让浏览器自动带 boundary
  if (body instanceof FormData) {
    delete finalOptions.headers["Content-Type"];
  }

  console.log("发送认证请求:", url, finalOptions);

  const response = await fetch(url, finalOptions);
  return handleResponse(response);
}

/**
 * 发送POST请求（带认证）
 */
export async function authPost(url, data, options = {}) {
  return authFetch(url, {
    method: "POST",
    body: data instanceof FormData ? data : JSON.stringify(data),
    ...options,
  });
}

/**
 * 发送GET请求（带认证）
 */
export async function authGet(url, options = {}) {
  return authFetch(url, {
    method: "GET",
    ...options,
  });
}

/**
 * 发送PUT请求（带认证）
 */
export async function authPut(url, data, options = {}) {
  return authFetch(url, {
    method: "PUT",
    body: data instanceof FormData ? data : JSON.stringify(data),
    ...options,
  });
}

/**
 * 发送DELETE请求（带认证）
 */
export async function authDelete(url, options = {}) {
  return authFetch(url, {
    method: "DELETE",
    ...options,
  });
}