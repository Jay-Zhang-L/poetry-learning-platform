import { createApp } from 'vue'
import App from './App.vue'

/** 路由 & 状态 */
import router from './router'
import { createPinia } from 'pinia'

/** 全局样式（如果你项目有这些文件就保留；没有就删掉对应行） */
import './styles/global.css'

/** ECharts 组件 */
import ECharts from 'vue-echarts'
import 'echarts'

const app = createApp(App)

// Pinia
app.use(createPinia())

// Router
app.use(router)

// 注册全局图表组件：<VChart />
app.component('VChart', ECharts)

app.mount('#app')
