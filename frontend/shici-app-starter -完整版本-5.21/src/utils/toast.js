import { createApp } from 'vue';
import Toast from '@/components/Toast.vue';

let toastId = 0;

/**
 * 显示Toast提示
 * @param {string} message - 提示消息
 * @param {string} type - 提示类型: success, error, warning, info
 * @param {number} duration - 显示时长(毫秒)，0表示不自动关闭
 */
export function showToast(message, type = 'info', duration = 3000) {
  const id = ++toastId;
  
  // 创建容器
  const container = document.createElement('div');
  container.id = `toast-${id}`;
  document.body.appendChild(container);
  
  // 创建Vue应用实例
  const app = createApp(Toast, {
    message,
    type,
    duration,
    onClose: () => {
      // 清理DOM
      app.unmount();
      if (container.parentNode) {
        container.parentNode.removeChild(container);
      }
    }
  });
  
  // 挂载到容器
  app.mount(container);
  
  return id;
}

/**
 * 显示成功提示
 * @param {string} message - 提示消息
 * @param {number} duration - 显示时长
 */
export function showSuccess(message, duration = 3000) {
  return showToast(message, 'success', duration);
}

/**
 * 显示错误提示
 * @param {string} message - 提示消息
 * @param {number} duration - 显示时长
 */
export function showError(message, duration = 4000) {
  return showToast(message, 'error', duration);
}

/**
 * 显示警告提示
 * @param {string} message - 提示消息
 * @param {number} duration - 显示时长
 */
export function showWarning(message, duration = 3500) {
  return showToast(message, 'warning', duration);
}

/**
 * 显示信息提示
 * @param {string} message - 提示消息
 * @param {number} duration - 显示时长
 */
export function showInfo(message, duration = 3000) {
  return showToast(message, 'info', duration);
}