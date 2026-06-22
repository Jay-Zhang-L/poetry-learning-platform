<template>
  <Teleport to="body">
    <Transition name="toast" appear>
      <div v-if="visible" class="toast-container" :class="type">
        <div class="toast-content">
          <div class="toast-icon">
            <span v-if="type === 'success'">✓</span>
            <span v-else-if="type === 'error'">✕</span>
            <span v-else-if="type === 'warning'">⚠</span>
            <span v-else>ℹ</span>
          </div>
          <div class="toast-message">{{ message }}</div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const props = defineProps({
  message: {
    type: String,
    required: true
  },
  type: {
    type: String,
    default: 'info', // success, error, warning, info
    validator: (value) => ['success', 'error', 'warning', 'info'].includes(value)
  },
  duration: {
    type: Number,
    default: 3000
  }
});

const emit = defineEmits(['close']);

const visible = ref(false);

onMounted(() => {
  visible.value = true;
  
  if (props.duration > 0) {
    setTimeout(() => {
      close();
    }, props.duration);
  }
});

function close() {
  visible.value = false;
  setTimeout(() => {
    emit('close');
  }, 300); // 等待动画完成
}
</script>

<style scoped>
.toast-container {
  position: fixed;
  top: 80px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 9999;
  pointer-events: none;
}

.toast-content {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px 20px;
  border-radius: 12px;
  backdrop-filter: blur(10px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.2);
  min-width: 200px;
  max-width: 400px;
}

.toast-icon {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: bold;
  flex-shrink: 0;
}

.toast-message {
  font-size: 14px;
  font-weight: 500;
  line-height: 1.4;
}

/* 成功样式 */
.toast-container.success .toast-content {
  background: rgba(34, 197, 94, 0.9);
  color: white;
}

.toast-container.success .toast-icon {
  background: rgba(255, 255, 255, 0.2);
  color: white;
}

/* 错误样式 */
.toast-container.error .toast-content {
  background: rgba(239, 68, 68, 0.9);
  color: white;
}

.toast-container.error .toast-icon {
  background: rgba(255, 255, 255, 0.2);
  color: white;
}

/* 警告样式 */
.toast-container.warning .toast-content {
  background: rgba(245, 158, 11, 0.9);
  color: white;
}

.toast-container.warning .toast-icon {
  background: rgba(255, 255, 255, 0.2);
  color: white;
}

/* 信息样式 */
.toast-container.info .toast-content {
  background: rgba(59, 130, 246, 0.9);
  color: white;
}

.toast-container.info .toast-icon {
  background: rgba(255, 255, 255, 0.2);
  color: white;
}

/* 动画 */
.toast-enter-active,
.toast-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.toast-enter-from {
  opacity: 0;
  transform: translateX(-50%) translateY(-20px) scale(0.9);
}

.toast-leave-to {
  opacity: 0;
  transform: translateX(-50%) translateY(-20px) scale(0.9);
}
</style>