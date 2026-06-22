// 诗词地图 API 接口
import { authGet } from './request.js';

const BASE_URL = '/api/poetry-map';

/**
 * 获取诗词地图概览数据（热力图）
 * @param {Object} params - 查询参数
 * @param {string} params.dynasty - 朝代筛选
 * @param {number} params.minHeat - 最小热度值
 * @returns {Promise} 
 */
export async function getMapOverview(params = {}) {
  const query = new URLSearchParams();
  if (params.dynasty) query.append('dynasty', params.dynasty);
  if (params.minHeat) query.append('minHeat', params.minHeat);
  
  const url = `${BASE_URL}/overview${query.toString() ? '?' + query.toString() : ''}`;
  return authGet(url);
}

/**
 * 获取地点详情
 * @param {number} locationId - 地点ID
 * @returns {Promise}
 */
export async function getLocationDetail(locationId) {
  return authGet(`${BASE_URL}/location/${locationId}`);
}

/**
 * 获取诗人路线
 * @param {number} poetId - 诗人ID
 * @returns {Promise}
 */
export async function getPoetRoute(poetId) {
  return authGet(`${BASE_URL}/poet/${poetId}/route`);
}

/**
 * 获取诗人关系网
 * @param {number} poetId - 诗人ID
 * @returns {Promise}
 */
export async function getPoetRelationships(poetId) {
  return authGet(`${BASE_URL}/poet/${poetId}/relationships`);
}

/**
 * 获取时间轴数据
 * @param {number} poetId - 诗人ID
 * @returns {Promise}
 */
export async function getTimeline(poetId) {
  return authGet(`${BASE_URL}/timeline/${poetId}`);
}

/**
 * 获取典故列表
 * @param {number} locationId - 地点ID
 * @returns {Promise}
 */
export async function getLocationAllusions(locationId) {
  return authGet(`${BASE_URL}/location/${locationId}/allusions`);
}

/**
 * 获取所有省份列表
 * @returns {Promise}
 */
export async function getProvinces() {
  return authGet(`${BASE_URL}/provinces`);
}

/**
 * 获取省份详情
 * @param {number} provinceId - 省份ID
 * @returns {Promise}
 */
export async function getProvinceDetail(provinceId) {
  return authGet(`${BASE_URL}/province/${provinceId}`);
}
