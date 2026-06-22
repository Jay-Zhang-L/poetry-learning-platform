// 登录状态检查工具函数
import { useProfileStore } from '@/stores/profile';
import { showError } from './toast';

/**
 * 检查用户登录状态
 * @param {Object} router - Vue Router实例
 * @returns {boolean} 是否已登录
 */
export function checkLoginStatus(router) {
  console.log('=== 开始检查登录状态 ===');
  
  // 检查token
  const token = localStorage.getItem('token');
  console.log('Token:', token ? '存在' : '不存在', token ? `(${token.substring(0, 20)}...)` : '');
  
  if (!token) {
    console.log('未找到token，跳转到登录页面');
    showError('登录已过期，请重新登录');
    setTimeout(() => {
      router.push('/login');
    }, 2000);
    return false;
  }

  // 检查用户信息
  const userStr = localStorage.getItem('user');
  console.log('User字符串:', userStr ? '存在' : '不存在');
  
  if (!userStr) {
    console.log('未找到用户信息，跳转到登录页面');
    showError('用户信息丢失，请重新登录');
    setTimeout(() => {
      router.push('/login');
    }, 2000);
    return false;
  }

  try {
    const user = JSON.parse(userStr);
    console.log('解析后的用户信息:', user);
    
    if (!user || !user.id) {
      console.log('用户信息无效，跳转到登录页面');
      showError('用户信息无效，请重新登录');
      setTimeout(() => {
        router.push('/login');
      }, 2000);
      return false;
    }
    
    console.log('登录检查通过，用户ID:', user.id);
    
    // 更新profile store
    const profileStore = useProfileStore();
    profileStore.setUser(user);
    return true;
  } catch (e) {
    console.error('解析用户信息失败：', e);
    showError('用户信息格式错误，请重新登录');
    setTimeout(() => {
      router.push('/login');
    }, 2000);
    return false;
  }
}

/**
 * 获取当前登录用户信息
 * @returns {Object|null} 用户信息或null
 */
export function getCurrentUser() {
  try {
    const userStr = localStorage.getItem('user');
    if (!userStr) return null;
    
    const user = JSON.parse(userStr);
    return user.id ? user : null;
  } catch (e) {
    console.error('获取用户信息失败：', e);
    return null;
  }
}

/**
 * 检查是否已登录（不跳转）
 * @returns {boolean} 是否已登录
 */
export function isLoggedIn() {
  const token = localStorage.getItem('token');
  const user = getCurrentUser();
  
  console.log('=== isLoggedIn 检查 ===');
  console.log('Token存在:', !!token);
  console.log('User存在:', !!user);
  console.log('User详情:', user);
  
  const result = !!(token && user);
  console.log('最终结果:', result);
  
  return result;
}

/**
 * 登出用户
 * @param {Object} router - Vue Router实例
 */
export function logout(router) {
  localStorage.removeItem('token');
  localStorage.removeItem('user');
  
  const profileStore = useProfileStore();
  profileStore.logout();
  
  router.push('/login');
}