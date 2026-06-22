<template>
  <div class="poetry-map" :class="{ loaded: isLoaded, 'nav-collapsed': navCollapsed }">
    <!-- 黑金背景 -->
    <div class="map-bg"></div>


    <!-- 古风边框装饰 -->
    <div class="ancient-frame">
      <div class="frame-corner frame-tl"></div>
      <div class="frame-corner frame-tr"></div>
      <div class="frame-corner frame-bl"></div>
      <div class="frame-corner frame-br"></div>
      <div class="frame-edge frame-top"></div>
      <div class="frame-edge frame-bottom"></div>
      <div class="frame-edge frame-left"></div>
      <div class="frame-edge frame-right"></div>
    </div>

    <!-- 薄雾效果 -->

    <!-- 光效 -->






    <!-- 筛选面板遮罩层 -->
    <transition name="fade">
      <div v-if="showFilterPanel" class="filter-overlay" @click="showFilterPanel = false"></div>
    </transition>

    <!-- 左侧筛选面板 - 滑出式 -->
    <transition name="slide-left">
      <aside v-if="showFilterPanel" class="filter-panel">
        <!-- 面板标题 -->
        <div class="filter-panel-header">
          <h3 class="panel-title">筛选</h3>
          <button class="panel-close-btn" @click="showFilterPanel = false">×</button>
        </div>

        <!-- 朝代筛选 -->
        <div class="filter-section">
          <h4 class="section-title">朝代筛选</h4>
          <div class="dynasty-grid">
            <button
                v-for="d in dynasties"
                :key="d"
                :class="['dynasty-tag', { active: selectedDynasty === d }]"
                @click="selectDynasty(d)"
            >
              {{ d }}
            </button>
          </div>
        </div>

        <!-- 诗人搜索 -->
        <div class="filter-section">
          <h4 class="section-title">诗人搜索</h4>
          <div class="search-wrapper">
            <input
                v-model="poetSearchKeyword"
                type="text"
                placeholder="输入诗人姓名..."
                @input="onPoetSearch"
            />
            <div v-if="poetSearchResults.length > 0" class="poet-list">
              <div
                  v-for="poet in poetSearchResults"
                  :key="poet.id"
                  class="poet-item"
                  @click="selectPoet(poet); showFilterPanel = false"
              >
                <span class="poet-name">{{ poet.name }}</span>
                <span v-if="poet.dynasty" class="poet-dynasty">{{ poet.dynasty }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 操作按钮 -->
        <div class="filter-actions">
          <button class="filter-action-btn" @click="resetView(); showFilterPanel = false">
            重置视图
          </button>
        </div>
      </aside>
    </transition>

    <!-- 左侧导航栏 -->
    <aside class="left-nav">
      <!-- 筛选按钮 - 点击显示朝代筛选和诗人搜索面板 -->
      <button class="nav-toggle-btn" @click="showFilterPanel = !showFilterPanel" :title="showFilterPanel ? '关闭筛选面板' : '打开筛选面板'">
        <span class="toggle-icon">☰</span>
        <span class="toggle-label">筛选</span>
        <span class="toggle-dot"></span>
      </button>

      <!-- Logo区域 - 竖排文字居中显示 -->
      <div class="nav-logo">
        <div class="logo-signature-left">
          <span class="signature-text">陳永正題</span>

        </div>
        <h1 class="logo-title-vertical">中国历史诗词编年地图</h1>
      </div>

      <!-- 快捷操作按钮 -->
      <div class="nav-quick-actions">
        <button class="quick-action-btn" @click="toggleRouteMode" :title="routeMode ? '退出路线' : '诗人路线'">
          <span class="action-icon">⟡</span>
          <span class="action-text">{{ routeMode ? '退出' : '路线' }}</span>
        </button>
      </div>
    </aside>

    <!-- 地图加载状态 -->
    <div v-if="!mapLoaded" class="map-loading-overlay">
      <div class="loading-content">
        <div class="loading-spinner">
          <div class="spinner-ring"></div>
          <div class="spinner-ring"></div>
          <div class="spinner-ring"></div>
        </div>
        <div class="loading-text">
          <span class="loading-title">诗词地图</span>
          <span class="loading-status">{{ loadingStatus }}</span>
        </div>
        <div class="loading-progress">
          <div class="progress-bar" :style="{ width: loadingProgress + '%' }"></div>
        </div>
      </div>
    </div>

    <!-- 主体区域 -->
    <div class="main-content" :class="{ 'left-collapsed': leftPanelCollapsed, 'right-collapsed': rightPanelCollapsed }">
      <!-- 左侧面板 -->
      <aside class="left-panel" :class="{ 'collapsed': leftPanelCollapsed }">
        <!-- 面板折叠按钮 - 左 -->
        <button
            class="panel-toggle-btn left-toggle"
            @click="leftPanelCollapsed = !leftPanelCollapsed"
            :title="leftPanelCollapsed ? '展开面板' : '隐藏面板'"
        >
          <span class="toggle-icon">{{ leftPanelCollapsed ? '▶' : '◀' }}</span>
        </button>

        <div class="panel-tabs">
          <button
              :class="['panel-tab', { active: leftPanelTab === 'provinces' }]"
              @click="leftPanelTab = 'provinces'"
          >
            省份列表
          </button>
          <button
              :class="['panel-tab', { active: leftPanelTab === 'locations' }]"
              @click="leftPanelTab = 'locations'"
          >
            地点列表
          </button>
          <button
              :class="['panel-tab', { active: leftPanelTab === 'poets' }]"
              @click="leftPanelTab = 'poets'"
          >
            诗人列表
          </button>
        </div>

        <div class="panel-content">
          <!-- 省份列表 -->
          <div v-if="leftPanelTab === 'provinces'" class="province-list">
            <div class="list-header">
              <span class="list-count">共 {{ provinces.length }} 个省份</span>
            </div>
            <div
                v-for="prov in provinces"
                :key="prov.id"
                :class="['province-item', { active: selectedProvince?.id === prov.id }]"
                @click="selectProvince(prov)"
            >
              <div class="prov-main">
                <span class="prov-name">{{ prov.name }}</span>
                <span v-if="prov.historicalName" class="prov-historical-name">{{ prov.historicalName }}</span>
              </div>
              <div class="prov-meta">
                <span class="prov-poems">{{ prov.poemCount }} 首诗词</span>
                <span class="prov-poets">{{ prov.poetCount }} 位诗人</span>
              </div>
              <div v-if="prov.description" class="prov-desc">{{ prov.description.substring(0, 60) }}...</div>
            </div>
          </div>

          <!-- 地点列表 -->
          <div v-else-if="leftPanelTab === 'locations'" class="location-list">
            <div class="list-header">
              <span class="list-count">共 {{ locations.length }} 个地点</span>
              <select v-model="locationSort" class="sort-select">
                <option value="heat">按热度</option>
                <option value="name">按名称</option>
                <option value="poems">按诗词数</option>
              </select>
            </div>
            <div
                v-for="loc in sortedLocations"
                :key="loc.id"
                :class="['location-item', { active: selectedLocation?.id === loc.id }]"
                @click="selectLocation(loc)"
            >
              <div class="loc-main">
                <span class="loc-name">{{ loc.name }}</span>
                <div class="loc-heat">
                  <div class="heat-bar" :style="{ width: getHeatPercent(loc.heatValue) + '%' }"></div>
                </div>
              </div>
              <div class="loc-meta">
                <span class="loc-poems">{{ loc.poemCount }} 首</span>
                <span class="loc-poets">{{ loc.poetCount }} 位诗人</span>
              </div>
              <div class="loc-famous">
                <span v-for="p in loc.famousPoets?.slice(0, 3)" :key="p" class="famous-poet">
                  {{ p }}
                </span>
              </div>
            </div>
          </div>

          <!-- 诗人列表 -->
          <div v-else-if="leftPanelTab === 'poets'" class="poet-list">
            <div class="list-header">
              <span class="list-count">共 {{ poets.length }} 位诗人</span>
            </div>
            <div
                v-for="poet in poets"
                :key="poet.id"
                :class="['poet-item', { active: selectedPoet?.id === poet.id }]"
                @click="selectPoet(poet)"
            >
              <div class="poet-avatar">
                <img v-if="getPoetAvatar(poet.name)" :src="getPoetAvatar(poet.name)" :alt="poet.name" class="poet-avatar-img">
                <span v-else>{{ poet.name?.charAt(0) }}</span>
              </div>
              <div class="poet-info">
                <div class="poet-name-row">
                  <span class="poet-name">{{ poet.name }}</span>
                  <span v-if="poet.dynasty" class="poet-dynasty-tag">{{ poet.dynasty }}</span>
                </div>
                <div class="poet-years">{{ poet.birthYear }} - {{ poet.deathYear }}</div>
              </div>
            </div>
          </div>
        </div>
      </aside>

      <!-- 中央地图 -->
      <div class="map-container">
        <v-chart
            ref="chartRef"
            :option="chartOption"
            class="chart"
            @click="onMapClick"
            @georoam="onGeoRoam"
            autoresize
        />

        <!-- 悬浮地点卡片 -->
        <div
            v-if="showLocationCard && detailType === 'location' && locationDetail"
            class="location-floating-card"
            :style="{
            transform: `translate3d(${cardPosition.x + 15}px, ${cardPosition.y}px, 0) translateY(-100%)`
          }"
        >
          <div class="card-header">
            <div class="header-main">
              <h3 class="card-title">{{ locationDetail.name }}</h3>
              <span class="card-subtitle">{{ locationDetail.historicalName }}</span>
            </div>
            <button class="card-close-btn" @click.stop="closeLocationCard">×</button>
          </div>

          <div class="card-body">
            <!-- 简介 -->
            <div class="card-section">
              <h4 class="card-section-title">
                简介
              </h4>
              <p class="card-desc">{{ locationDetail.description }}</p>
            </div>

            <!-- 代表诗人区 -->
            <div class="card-section poets-section" v-if="locationDetail.representativePoets?.length">
              <h4 class="card-section-title">
                代表诗人
              </h4>
              <div class="mini-poet-list">
                <div
                    v-for="poet in locationDetail.representativePoets.slice(0, 3)"
                    :key="poet.id"
                    class="mini-poet-item"
                >
                  <div class="poet-avatar-small">
                    <img v-if="getPoetAvatar(poet.name)" :src="getPoetAvatar(poet.name)" :alt="poet.name" class="poet-avatar-img">
                    <span v-else>{{ poet.name?.charAt(0) }}</span>
                  </div>
                  <div class="poet-meta">
                    <span class="name">{{ poet.name }}</span>
                    <span class="dynasty">{{ poet.dynasty }}</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- 典故速览 -->
            <div class="card-section allusions-section" v-if="locationDetail.allusions?.length">
              <h4 class="card-section-title">
                千古典故
              </h4>
              <div class="mini-allusion">
                <span class="allusion-tag">{{ locationDetail.allusions[0].title }}</span>
                <p class="allusion-snippet">{{ locationDetail.allusions[0].content.substring(0, 45) }}...</p>
              </div>
            </div>

            <!-- 统计图表区（移动到最后） -->
            <div class="card-section stats-section">
              <h4 class="card-section-title">
                诗词统计
              </h4>
              <div class="stats-summary">
                <div class="dynasty-bars">
                  <div v-for="(count, dynasty) in locationDetail.poemStats?.byDynasty" :key="dynasty" class="bar-item">
                    <span class="bar-label">{{ dynasty }}</span>
                    <div class="bar-track">
                      <div class="bar-fill" :style="{ width: (count / (locationDetail.poemStats?.total || 1) * 100) + '%' }"></div>
                    </div>
                    <span class="bar-value">{{ count }}</span>
                  </div>
                </div>
                <!-- 共计多少首移动到最后一行 -->
                <div class="total-badge">
                  <span class="label">共计</span>
                  <span class="value">{{ locationDetail.poemStats?.total || selectedLocation?.poemCount }}</span>
                  <span class="unit">首</span>
                </div>
              </div>
            </div>
          </div>

          <!-- 卡片底部装饰 -->
          <div class="card-footer-decoration"></div>
        </div>

        <!-- 地图工具栏 -->
        <div class="map-tools">
          <button class="tool-btn" @click="zoomIn" title="放大">+</button>
          <button class="tool-btn" @click="zoomOut" title="缩小">-</button>
          <button class="tool-btn" @click="resetZoom" title="重置">⟲</button>
        </div>
      </div>

      <!-- 右侧面板 -->
      <aside class="right-panel" :class="{ 'expanded': !rightPanelCollapsed, 'collapsed': rightPanelCollapsed }">
        <!-- 面板折叠按钮 - 右 -->
        <button
            class="panel-toggle-btn right-toggle"
            @click="rightPanelCollapsed = !rightPanelCollapsed"
            :title="rightPanelCollapsed ? '展开面板' : '隐藏面板'"
        >
          <span class="toggle-icon">{{ rightPanelCollapsed ? '◀' : '▶' }}</span>
        </button>

        <!-- 列表视图：未选中详情时显示 -->
        <div v-if="!showDetail" class="list-view">
          <div class="panel-tabs">
            <button
                :class="['panel-tab', { active: leftPanelTab === 'provinces' }]"
                @click="leftPanelTab = 'provinces'"
            >
              省份
            </button>
            <button
                :class="['panel-tab', { active: leftPanelTab === 'locations' }]"
                @click="leftPanelTab = 'locations'"
            >
              地点
            </button>
            <button
                :class="['panel-tab', { active: leftPanelTab === 'poets' }]"
                @click="leftPanelTab = 'poets'"
            >
              诗人
            </button>
          </div>

          <div class="panel-content">
            <!-- 省份列表 -->
            <div v-if="leftPanelTab === 'provinces'" class="province-list">
              <div class="list-header">
                <span class="list-count">共 {{ provinces.length }} 个省份</span>
              </div>
              <div
                  v-for="prov in provinces"
                  :key="prov.id"
                  :class="['province-item', { active: selectedProvince?.id === prov.id }]"
                  @click="selectProvince(prov)"
              >
                <div class="prov-main">
                  <span class="prov-name">{{ prov.name }}</span>
                  <span v-if="prov.historicalName" class="prov-historical-name">{{ prov.historicalName }}</span>
                </div>
                <div class="prov-meta">
                  <span class="prov-poems">{{ prov.poemCount }} 首诗词</span>
                  <span class="prov-poets">{{ prov.poetCount }} 位诗人</span>
                </div>
                <div v-if="prov.description" class="prov-desc">{{ prov.description.substring(0, 60) }}...</div>
              </div>
            </div>

            <!-- 地点列表 -->
            <div v-else-if="leftPanelTab === 'locations'" class="location-list">
              <div class="list-header">
                <span class="list-count">共 {{ locations.length }} 个地点</span>
                <select v-model="locationSort" class="sort-select">
                  <option value="heat">按热度</option>
                  <option value="name">按名称</option>
                  <option value="poems">按诗词数</option>
                </select>
              </div>
              <div
                  v-for="loc in sortedLocations"
                  :key="loc.id"
                  :class="['location-item', { active: selectedLocation?.id === loc.id }]"
                  @click="selectLocation(loc)"
              >
                <div class="loc-main">
                  <span class="loc-name">{{ loc.name }}</span>
                  <div class="loc-heat">
                    <div class="heat-bar" :style="{ width: getHeatPercent(loc.heatValue) + '%' }"></div>
                  </div>
                </div>
                <div class="loc-meta">
                  <span class="loc-poems">{{ loc.poemCount }} 首</span>
                  <span class="loc-poets">{{ loc.poetCount }} 位诗人</span>
                </div>
                <div class="loc-famous">
                  <span v-for="p in loc.famousPoets?.slice(0, 3)" :key="p" class="famous-poet">
                    {{ p }}
                  </span>
                </div>
              </div>
            </div>

            <!-- 诗人列表 -->
            <div v-else-if="leftPanelTab === 'poets'" class="right-poet-list">
              <div class="list-header">
                <span class="list-count">共 {{ poets.length }} 位诗人</span>
              </div>
              <div
                  v-for="poet in poets"
                  :key="poet.id"
                  :class="['poet-item', { active: selectedPoet?.id === poet.id }]"
                  @click="selectPoet(poet)"
              >
                <div class="poet-avatar">
                  <img v-if="getPoetAvatar(poet.name)" :src="getPoetAvatar(poet.name)" :alt="poet.name" class="poet-avatar-img">
                  <span v-else>{{ poet.name?.charAt(0) }}</span>
                </div>
                <div class="poet-info">
                  <div class="poet-name-row">
                    <span class="poet-name">{{ poet.name }}</span>
                    <span v-if="poet.dynasty" class="poet-dynasty-tag">{{ poet.dynasty }}</span>
                  </div>
                  <div class="poet-years">{{ poet.birthYear }} - {{ poet.deathYear }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 地点详情 -->
        <div v-else-if="detailType === 'location'" class="detail-content">
          <div class="detail-header">
            <h2 class="detail-title">{{ locationDetail?.name }}</h2>
            <span class="detail-subtitle">{{ locationDetail?.historicalName }}</span>
            <button class="close-btn" @click="closeDetail">×</button>
          </div>

          <div class="detail-body">
            <div class="detail-section">
              <h3 class="section-title">代表诗人</h3>
              <div class="poet-cards">
                <div
                    v-for="poet in locationDetail?.representativePoets"
                    :key="poet.id"
                    class="poet-card"
                    @click="viewPoetRoute(poet)"
                >
                  <div class="poet-avatar">
                    <img v-if="getPoetAvatar(poet.name)" :src="getPoetAvatar(poet.name)" :alt="poet.name" class="poet-avatar-img">
                    <span v-else>{{ poet.name?.charAt(0) }}</span>
                  </div>
                  <div class="poet-info">
                    <span class="poet-name">{{ poet.name }}</span>
                    <span v-if="poet.dynasty" class="poet-dynasty">{{ poet.dynasty }}</span>
                    <span class="poet-poems">{{ poet.relatedPoems }} 首相关</span>
                  </div>
                </div>
              </div>
            </div>

            <div class="detail-section">
              <h3 class="section-title">典故</h3>
              <div class="allusion-list">
                <div v-for="allusion in locationDetail?.allusions" :key="allusion.id" class="allusion-item">
                  <div class="allusion-title">{{ allusion.title }}</div>
                  <div class="allusion-content">{{ allusion.content }}</div>
                  <span class="allusion-dynasty">{{ allusion.dynasty }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 省份详情 -->
        <div v-else-if="detailType === 'province'" class="detail-content">
          <div class="detail-header">
            <h2 class="detail-title">{{ provinceDetail?.name }}</h2>
            <span class="detail-subtitle">{{ provinceDetail?.historicalName }}</span>
            <button class="close-btn" @click="closeDetail">×</button>
          </div>

          <div class="detail-body">
            <div class="detail-section">
              <h3 class="section-title">诗词历史介绍</h3>
              <p class="section-text">{{ provinceDetail?.description }}</p>
            </div>

            <div class="detail-section">
              <h3 class="section-title">统计数据</h3>
              <div class="stats-grid">
                <div class="stat-item">
                  <span class="stat-value">{{ provinceDetail?.poemCount }}</span>
                  <span class="stat-label">相关诗词</span>
                </div>
                <div class="stat-item">
                  <span class="stat-value">{{ provinceDetail?.poetCount }}</span>
                  <span class="stat-label">相关诗人</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 诗人详情 -->
        <div v-else-if="detailType === 'poet'" class="detail-content">
          <div class="detail-header">
            <h2 class="detail-title">{{ selectedPoet?.name }}</h2>
            <span class="detail-subtitle">{{ selectedPoet?.dynasty ? selectedPoet.dynasty + '代' : '' }}诗人</span>
            <button class="close-btn" @click="closeDetail">×</button>
          </div>

          <div class="detail-body">
            <div class="detail-section">
              <h3 class="section-title">生平</h3>
              <p class="section-text">
                {{ selectedPoet?.birthYear }} - {{ selectedPoet?.deathYear }}
              </p>
            </div>

            <div class="detail-section">
              <h3 class="section-title">人生路线</h3>
              <div class="route-timeline">
                <div v-for="point in poetRoute" :key="point.order" class="route-point">
                  <div class="route-year">{{ point.year }}</div>
                  <div class="route-dot"></div>
                  <div class="route-info">
                    <span class="route-location">{{ point.locationName }}</span>
                    <span class="route-event">{{ point.event }}</span>
                    <div v-if="point.poems?.length" class="route-poems">
                      <span v-for="poem in point.poems" :key="poem.id" class="route-poem">
                        《{{ poem.title }}》
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="detail-section">
              <h3 class="section-title">诗人关系网</h3>
              <div class="relationship-chart">
                <v-chart :option="relationshipOption" class="rel-chart" autoresize />
              </div>
            </div>
          </div>
        </div>
      </aside>
    </div>


  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted, onUnmounted } from 'vue';
import VChart from 'vue-echarts';
import { use } from 'echarts/core';
import { CanvasRenderer } from 'echarts/renderers';
import { ScatterChart, EffectScatterChart, LinesChart, GraphChart } from 'echarts/charts';
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GeoComponent,
  VisualMapComponent
} from 'echarts/components';
import * as echarts from 'echarts';

import {
  getMapOverview,
  getLocationDetail,
  getPoetRoute,
  getPoetRelationships,
  getTimeline,
  getProvinces,
  getProvinceDetail
} from '@/utils/poetryMapApi.js';

// 导入背景图片
import mapBgImage from '@/assets/bg/map.jpg';

// 注册ECharts组件
use([
  CanvasRenderer,
  ScatterChart,
  EffectScatterChart,
  LinesChart,
  GraphChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GeoComponent,
  VisualMapComponent
]);

// 页面加载状态
const isLoaded = ref(false);

// 地图加载状态
const mapLoaded = ref(false);
const mapError = ref(false);
const loadingStatus = ref('正在初始化...');
const loadingProgress = ref(0);


// 数据状态
const locations = ref([]);
const provinces = ref([]);
const poets = ref([]);
const heatRange = ref({ min: 0, max: 100 });
const selectedDynasty = ref('全部');
const poetSearchKeyword = ref('');
const poetSearchResults = ref([]);
const selectedLocation = ref(null);
const selectedProvince = ref(null);
const selectedPoet = ref(null);
const locationDetail = ref(null);
const provinceDetail = ref(null);
const poetRoute = ref([]);
const poetRelationships = ref({ nodes: [], edges: [] });

const routeMode = ref(false);
const showDetail = ref(false);
const detailType = ref(null);
const showLocationCard = ref(false);
const cardPosition = ref({ x: 0, y: 0 });
const leftPanelTab = ref('provinces');
const locationSort = ref('heat');
const chartRef = ref(null);
const currentZoom = ref(1.9); // 当前地图缩放级别
const currentCenter = ref([105, 36]); // 当前地图中心点
const showFilterPanel = ref(false); // 筛选面板显示状态
const navCollapsed = ref(false); // 导航栏折叠状态
const showDynastyMenu = ref(false); // 朝代下拉菜单显示状态
const leftPanelCollapsed = ref(false); // 左侧面板折叠状态
const rightPanelCollapsed = ref(false); // 右侧面板折叠状态
const displayedRoutePoints = ref(0); // 已显示的路线点数量（用于逐点动画）
const focusedProvince = ref(null); // 当前聚焦的省份
let routeAnimationTimer = null; // 路线动画定时器
let routeZoomTimer = null; // 路线缩放定时器（用于动画完成后自动缩小）
let isRouteAnimating = false; // 标记是否正在展示路线
let activeRouteAnimationToken = 0; // 当前有效的路线动画令牌
let cardPositionRafId = null;

const initialGeoZoom = 1.9;
const initialGeoCenter = [105, 36];

// 朝代下拉菜单切换
function toggleDynastyMenu() {
  showDynastyMenu.value = !showDynastyMenu.value;
}

// 朝代选项：全部、主要朝代、其他
const dynasties = ['全部', '唐', '宋', '元', '明', '清', '其他'];

// 主要朝代列表（用于筛选）
const mainDynasties = ['唐', '宋', '元', '明', '清'];

// 诗人朝代映射表（常见诗人）
const poetDynastyMap = {
  // 唐代诗人
  '李白': '唐', '杜甫': '唐', '白居易': '唐', '王维': '唐', '孟浩然': '唐',
  '王勃': '唐', '李商隐': '唐', '杜牧': '唐', '刘禹锡': '唐', '韩愈': '唐',
  '柳宗元': '唐', '岑参': '唐', '高适': '唐', '王昌龄': '唐', '李贺': '唐',
  '张继': '唐', '孟郊': '唐', '贾岛': '唐', '元稹': '唐', '温庭筠': '唐',
  '张若虚': '唐', '贺知章': '唐', '陈子昂': '唐', '骆宾王': '唐', '宋之问': '唐',
  // 宋代诗人
  '苏轼': '宋', '陆游': '宋', '辛弃疾': '宋', '李清照': '宋', '欧阳修': '宋',
  '王安石': '宋', '黄庭坚': '宋', '柳永': '宋', '晏殊': '宋', '秦观': '宋',
  '范仲淹': '宋', '岳飞': '宋', '周邦彦': '宋', '姜夔': '宋', '杨万里': '宋',
  '范成大': '宋', '朱熹': '宋', '曾巩': '宋', '苏洵': '宋', '苏辙': '宋',
  // 先秦诗人
  '屈原': '先秦', '宋玉': '先秦',
  // 汉代诗人
  '司马相如': '汉', '班固': '汉', '张衡': '汉', '蔡文姬': '汉',
  // 魏晋诗人
  '曹操': '魏晋', '曹丕': '魏晋', '曹植': '魏晋', '陶渊明': '魏晋',
  '阮籍': '魏晋', '嵇康': '魏晋', '谢灵运': '魏晋',
  // 元代诗人
  '关汉卿': '元', '马致远': '元', '王实甫': '元', '白朴': '元',
  // 明代诗人
  '杨慎': '明', '于谦': '明', '高启': '明', '唐寅': '明',
  // 清代诗人
  '纳兰性德': '清', '龚自珍': '清', '袁枚': '清', '郑燮': '清',
  '赵翼': '清', '黄景仁': '清'
};

// 诗人头像映射
const poetAvatarMap = {
  '李白': new URL('../assets/bg/libai.jpg', import.meta.url).href,
  '杜甫': new URL('../assets/bg/dufu.jpg', import.meta.url).href
};

// 获取诗人头像
function getPoetAvatar(name) {
  return poetAvatarMap[name] || null;
}

// 计算属性：排序后的地点列表
const sortedLocations = computed(() => {
  const list = [...locations.value];
  if (locationSort.value === 'heat') {
    return list.sort((a, b) => b.heatValue - a.heatValue);
  } else if (locationSort.value === 'name') {
    return list.sort((a, b) => a.name.localeCompare(b.name, 'zh-CN'));
  } else if (locationSort.value === 'poems') {
    return list.sort((a, b) => b.poemCount - a.poemCount);
  }
  return list;
});

// 计算热度百分比
function getHeatPercent(heat) {
  const min = heatRange.value.min || 0;
  const max = heatRange.value.max || 100;
  return ((heat - min) / (max - min)) * 100;
}

// 地图配置
const chartOption = computed(() => {
  let filteredLocations = locations.value;
  if (focusedProvince.value) {
    filteredLocations = locations.value.filter(loc => {
      return loc.province === focusedProvince.value ||
          (loc.province && focusedProvince.value.includes(loc.province)) ||
          (focusedProvince.value.includes(loc.province || ''));
    });
  }

  const scatterData = filteredLocations.map(loc => ({
    name: loc.name,
    value: [loc.longitude, loc.latitude, loc.heatValue]
  }));

  // 根据已显示的路线点数量生成线段数据（逐点动画）
  const linesData = routeMode.value && displayedRoutePoints.value > 1
      ? poetRoute.value.slice(0, displayedRoutePoints.value - 1).map((point, i) => ({
        fromName: point.locationName,
        toName: poetRoute.value[i + 1].locationName,
        coords: [
          [point.longitude, point.latitude],
          [poetRoute.value[i + 1].longitude, poetRoute.value[i + 1].latitude]
        ]
      }))
      : [];

  return {
    backgroundColor: 'transparent',
    animation: false, // 全局关闭初始动画，提高漫游性能
    tooltip: {
      trigger: 'item',
      backgroundColor: 'rgba(240, 232, 216, 0.95)',
      borderColor: 'rgba(122, 99, 72, 0.25)',
      borderWidth: 1,
      textStyle: {
        color: 'rgba(0, 0, 0, 0.9)'
      },
      formatter: (params) => {
        if (params.componentType === 'geo') {
          let prov = provinces.value.find(p => p.name === params.name);
          if (!prov) {
            const simplifiedName = params.name.replace(/(省|自治区|市|特别行政区)$/, '');
            prov = provinces.value.find(p =>
                p.name === simplifiedName || p.name.includes(simplifiedName) || simplifiedName.includes(p.name)
            );
          }
          if (prov) {
            return `
              <div style="padding: 10px; min-width: 140px;">
                <div style="font-weight: bold; font-size: 15px; margin-bottom: 6px; color: #5c4033;">${prov.name}</div>
                <div style="color: #8b6914; font-size: 12px; margin-bottom: 8px;">${prov.historicalName || ''}</div>
                <div style="color: #6b4423; font-size: 13px; margin-bottom: 2px;">诗词数：${prov.poemCount} 首</div>
                <div style="color: #6b4423; font-size: 13px;">诗人数：${prov.poetCount} 位</div>
              </div>
            `;
          }
          return `<div style="padding: 8px;">${params.name}</div>`;
        }

        if (params.componentType === 'series' && params.seriesType === 'scatter') {
          const loc = locations.value.find(l => l.name === params.name);
          if (loc) {
            return `
              <div style="padding: 8px;">
                <div style="font-weight: bold; font-size: 14px; margin-bottom: 4px; color: rgba(0, 0, 0, 0.86);">${loc.name}</div>
                <div style="color: rgba(0, 0, 0, 0.62);">诗词数：${loc.poemCount}</div>
                <div style="color: rgba(0, 0, 0, 0.62);">诗人数：${loc.poetCount}</div>
                <div style="color: rgba(0, 0, 0, 0.62);">热度：${loc.heatValue?.toFixed(1)}</div>
              </div>
            `;
          }
        }
        return params.name;
      }
    },
    geo: {
      map: 'china',
      roam: true,
      zoom: currentZoom.value,
      center: currentCenter.value,
      scaleLimit: { min: 0.5, max: 10 },
      animationDurationUpdate: 0,
      label: {
        show: true,
        color: '#5c4033',
        fontSize: 12,
        fontWeight: 'normal'
      },
      itemStyle: {
        areaColor: focusedProvince.value ? 'rgba(200, 190, 175, 0.2)' : 'rgba(217, 198, 168, 0.82)',
        borderColor: focusedProvince.value ? 'rgba(119, 89, 49, 0.2)' : 'rgba(119, 89, 49, 0.52)',
        borderWidth: 1.5,
        cursor: 'pointer'
      },
      emphasis: {
        itemStyle: {
          areaColor: 'rgba(194, 168, 130, 0.9)',
          borderColor: 'rgba(119, 89, 49, 0.72)',
          borderWidth: 2
        },
        label: {
          show: true,
          color: '#8b4513',
          fontSize: 14,
          fontWeight: 'bold'
        }
      },
      select: {
        itemStyle: {
          areaColor: 'rgba(180, 155, 118, 0.92)',
          borderColor: 'rgba(119, 89, 49, 0.8)',
          borderWidth: 2
        }
      },
      regions: focusedProvince.value ? [{
        name: focusedProvince.value,
        itemStyle: {
          areaColor: 'rgba(242, 222, 198, 0.95)',
          borderColor: 'rgba(194, 89, 49, 0.8)',
          borderWidth: 2.5
        },
        label: {
          show: true,
          color: '#5c4033',
          fontSize: 14,
          fontWeight: 'bold'
        }
      }] : []
    },
    series: [
      {
        name: '诗词地点',
        type: 'scatter',
        coordinateSystem: 'geo',
        data: scatterData,
        symbol: 'path://M12,0C5.4,0,0,5.4,0,12c0,9,12,22,12,22s12-13,12-22C24,5.4,18.6,0,12,0z',
        symbolSize: 14,
        itemStyle: {
          color: '#c73e3a',
          borderColor: '#fff',
          borderWidth: 1.5,
          shadowBlur: 4,
          shadowColor: 'rgba(199, 62, 58, 0.35)'
        },
        label: {
          show: true,
          formatter: '{b}',
          position: 'right',
          fontSize: 12,
          fontWeight: 'bold',
          color: 'rgba(0, 0, 0, 0.75)',
          textBorderColor: 'rgba(255, 255, 255, 0.8)',
          textBorderWidth: 2,
          minMargin: 8,
        },
        emphasis: {
          label: {
            show: true,
            fontSize: 13,
            fontWeight: 'bold',
            color: 'rgba(0, 0, 0, 0.86)',
            textBorderColor: 'rgba(255, 255, 255, 0.9)',
            textBorderWidth: 2
          },
          itemStyle: {
            shadowBlur: 12,
            shadowColor: 'rgba(199, 62, 58, 0.5)',
            color: '#a52a2a'
          }
        }
      },
      {
        id: 'poet-route-lines',
        name: '诗人路线',
        type: 'lines',
        coordinateSystem: 'geo',
        zlevel: 1,
        effect: {
          show: false
        },
        lineStyle: {
          color: '#D9534F',
          width: 2.5,
          curveness: 0.18,
          opacity: 0.9
        },
        data: linesData,
        silent: true,
        animation: true,
        animationDuration: 1500,
        animationEasing: 'cubicInOut',
        animationDurationUpdate: 1500,
        animationEasingUpdate: 'cubicInOut'
      },
      {
        id: 'poet-route-points',
        name: '路线节点',
        type: 'scatter',
        coordinateSystem: 'geo',
        zlevel: 2,
        itemStyle: {
          color: '#CCFF00',
          opacity: 0.95
        },
        symbolSize: 11,
        data: routeMode.value && displayedRoutePoints.value > 0
            ? poetRoute.value.slice(0, displayedRoutePoints.value).map(point => ({
              name: point.locationName,
              value: [point.longitude, point.latitude]
            }))
            : [],
        animation: true,
        animationDuration: 800,
        animationEasing: 'elasticOut',
        animationDurationUpdate: 800
      }
    ]
  };
});
// 关系网配置
const relationshipOption = computed(() => ({
  tooltip: {
    trigger: 'item',
    formatter: (params) => {
      if (params.dataType === 'node') {
        return `${params.data.name} (${params.data.dynasty})`;
      } else if (params.dataType === 'edge') {
        return `${params.data.description || params.data.type}`;
      }
      return '';
    }
  },
  series: [{
    type: 'graph',
    layout: 'force',
    data: poetRelationships.value.nodes.map(n => ({
      ...n,
      symbolSize: 30,
      label: {
        show: true,
        fontSize: 10,
        color: 'rgba(0, 0, 0, 0.75)'
      },
      itemStyle: {
        color: '#D4AF37'
      }
    })),
    links: poetRelationships.value.edges.map(e => ({
      source: e.source,
      target: e.target,
      value: e.strength,
      lineStyle: {
        width: e.strength,
        curveness: 0.2,
        color: '#B8860B'
      }
    })),
    roam: true,
    label: { position: 'right' },
    force: {
      repulsion: 100,
      edgeLength: 80
    },
    emphasis: {
      focus: 'adjacency',
      lineStyle: { width: 3 }
    }
  }]
}));

// 获取热度颜色（金色系）
function getHeatColor(heat) {
  const percent = getHeatPercent(heat) / 100;
  // 从浅金 #f5d998 到深金 #c9a227
  const r = Math.round(245 - (245 - 201) * percent);
  const g = Math.round(217 - (217 - 162) * percent);
  const b = Math.round(152 - (152 - 39) * percent);
  return `rgb(${r}, ${g}, ${b})`;
}

// 加载地图数据
async function loadMapData() {
  try {
    // 不传递 dynasty 参数给后端，始终获取全部地点数据
    // 朝代筛选只在前端用于过滤诗人列表
    const res = await getMapOverview({});
    const data = res?.data || res;

    if (data?.locations) {
      // 始终显示所有地点，不按朝代过滤
      locations.value = data.locations;
      heatRange.value = data.heatRange || { min: 0, max: 100 };

      // 优先使用接口直接返回的 poets 数组，如果没有则从地点中提取
      let allPoets = [];

      if (data.poets && Array.isArray(data.poets) && data.poets.length > 0) {
        // 后端已返回完整诗人列表，直接使用
        allPoets = data.poets;
      } else {
        // 兼容旧逻辑：从地点中提取著名诗人
        const poetMap = new Map();
        data.locations.forEach(loc => {
          loc.famousPoets?.forEach(name => {
            if (!poetMap.has(name)) {
              const dynasty = poetDynastyMap[name] || '其他';
              poetMap.set(name, { id: poetMap.size + 1, name, dynasty });
            }
          });
        });
        allPoets = Array.from(poetMap.values());
      }

      // 根据选择的朝代过滤诗人（只过滤诗人列表，不影响地图）
      if (selectedDynasty.value === '全部') {
        poets.value = allPoets;
      } else if (selectedDynasty.value === '其他') {
        // 筛选出非主要朝代的诗人
        poets.value = allPoets.filter(p => !mainDynasties.includes(p.dynasty));
      } else {
        // 筛选特定朝代的诗人（支持"唐"或"唐代"等变体）
        poets.value = allPoets.filter(p => {
          if (!p.dynasty) return false;
          return p.dynasty === selectedDynasty.value ||
              p.dynasty.startsWith(selectedDynasty.value);
        });
      }

      // 如果过滤后为空但选择了特定朝代，显示该朝代的模拟诗人数据
      if (poets.value.length === 0 && selectedDynasty.value !== '全部') {
        const mockPoetsByDynasty = {
          '唐': [
            { id: 1, name: '李白', dynasty: '唐', birthYear: '701', deathYear: '762' },
            { id: 2, name: '杜甫', dynasty: '唐', birthYear: '712', deathYear: '770' },
            { id: 3, name: '白居易', dynasty: '唐', birthYear: '772', deathYear: '846' },
            { id: 4, name: '王维', dynasty: '唐', birthYear: '701', deathYear: '761' },
            { id: 5, name: '孟浩然', dynasty: '唐', birthYear: '689', deathYear: '740' },
          ],
          '宋': [
            { id: 6, name: '苏轼', dynasty: '宋', birthYear: '1037', deathYear: '1101' },
            { id: 7, name: '陆游', dynasty: '宋', birthYear: '1125', deathYear: '1210' },
            { id: 8, name: '辛弃疾', dynasty: '宋', birthYear: '1140', deathYear: '1207' },
            { id: 9, name: '李清照', dynasty: '宋', birthYear: '1084', deathYear: '1155' },
            { id: 10, name: '欧阳修', dynasty: '宋', birthYear: '1007', deathYear: '1072' },
          ],
          '元': [
            { id: 11, name: '关汉卿', dynasty: '元', birthYear: '1219', deathYear: '1301' },
            { id: 12, name: '马致远', dynasty: '元', birthYear: '1250', deathYear: '1321' },
          ],
          '明': [
            { id: 13, name: '于谦', dynasty: '明', birthYear: '1398', deathYear: '1457' },
            { id: 14, name: '杨慎', dynasty: '明', birthYear: '1488', deathYear: '1559' },
          ],
          '清': [
            { id: 15, name: '纳兰性德', dynasty: '清', birthYear: '1655', deathYear: '1685' },
            { id: 16, name: '龚自珍', dynasty: '清', birthYear: '1792', deathYear: '1841' },
          ],
        };
        const dynastyKey = selectedDynasty.value;
        if (mockPoetsByDynasty[dynastyKey]) {
          poets.value = mockPoetsByDynasty[dynastyKey];
        }
      }
    }
  } catch (error) {
    console.error('加载地图数据失败:', error);
  }
}

// 加载省份数据
async function loadProvinces() {
  try {
    const res = await getProvinces();
    const data = res?.data || res;
    if (data && Array.isArray(data)) {
      provinces.value = data;
    } else if (data?.data && Array.isArray(data.data)) {
      provinces.value = data.data;
    }
  } catch (error) {
    console.error('加载省份数据失败:', error);
    // 使用模拟数据
    provinces.value = [
      { id: 1, name: '陕西', historicalName: '关中、三秦', description: '陕西是中华文明的重要发祥地，古都西安曾是周、秦、汉、唐等十三个王朝的都城，留下了大量诗词名篇。', poemCount: 150, poetCount: 25 },
      { id: 2, name: '浙江', historicalName: '吴越', description: '浙江自古人文荟萃，杭州、绍兴等地孕育了众多著名诗人，留下了大量优美的诗词作品。', poemCount: 120, poetCount: 20 },
      { id: 3, name: '四川', historicalName: '巴蜀', description: '四川素有天府之国之称，山川秀美，物产丰富，是许多诗人的故乡或游历之地。', poemCount: 85, poetCount: 15 },
      { id: 4, name: '河南', historicalName: '中原', description: '河南是华夏文明的发源地，洛阳、开封等古都见证了无数诗词佳话。', poemCount: 200, poetCount: 30 },
      { id: 5, name: '江苏', historicalName: '江南', description: '江苏风景秀丽，南京、苏州等地自古就是文人墨客云集之地。', poemCount: 180, poetCount: 28 },
      { id: 6, name: '山东', historicalName: '齐鲁', description: '山东是孔孟之乡，文化底蕴深厚，孕育了众多著名诗人。', poemCount: 95, poetCount: 18 },
      { id: 7, name: '湖北', historicalName: '荆楚', description: '湖北地处长江中游，武汉、荆州等地留下了大量诗词名篇。', poemCount: 75, poetCount: 12 },
      { id: 8, name: '湖南', historicalName: '潇湘', description: '湖南山水秀丽，岳阳楼、洞庭湖等名胜激发了无数诗人的灵感。', poemCount: 88, poetCount: 16 },
    ];
  }
}

// 省份中心坐标映射
const provinceCenters = {
  '北京': [116.4074, 39.9042],
  '天津': [117.2008, 39.0842],
  '河北': [114.5025, 38.0458],
  '山西': [112.5317, 37.8719],
  '内蒙古': [111.6708, 40.8173],
  '辽宁': [123.4328, 41.8045],
  '吉林': [125.3245, 43.8268],
  '黑龙江': [126.6425, 45.8038],
  '上海': [121.4737, 31.2304],
  '江苏': [118.7969, 32.0603],
  '浙江': [120.1552, 30.2874],
  '安徽': [117.2272, 31.8229],
  '福建': [119.3062, 26.0753],
  '江西': [115.8921, 28.6765],
  '山东': [117.0009, 36.6754],
  '河南': [113.6253, 34.7466],
  '湖北': [114.3055, 30.5928],
  '湖南': [112.9388, 28.2281],
  '广东': [113.2644, 23.1291],
  '广西': [108.3200, 22.8241],
  '海南': [110.3312, 19.8987],
  '重庆': [106.5516, 29.5630],
  '四川': [104.0668, 30.5728],
  '贵州': [106.7135, 26.5784],
  '云南': [102.7183, 25.0406],
  '西藏': [91.1322, 29.6604],
  '陕西': [108.9480, 34.2619],
  '甘肃': [103.8235, 36.0611],
  '青海': [101.7798, 36.6173],
  '宁夏': [106.2782, 38.4663],
  '新疆': [87.6177, 43.7928],
  '香港': [114.1747, 22.2862],
  '澳门': [113.5491, 22.1987],
  '台湾': [121.5090, 25.0389]
};

// 选择省份
async function selectProvince(prov) {
  selectedProvince.value = prov;
  selectedLocation.value = null;
  selectedPoet.value = null;
  showDetail.value = true;
  detailType.value = 'province';
  showLocationCard.value = false;

  try {
    const res = await getProvinceDetail(prov.id);
    provinceDetail.value = res?.data || res;
  } catch (error) {
    console.error('获取省份详情失败:', error);
    provinceDetail.value = prov;
  }

  // 自动聚焦到选中的省份
  focusOnProvince(prov.name);
}

// 聚焦到指定省份
function focusOnProvince(provinceName) {
  const center = provinceCenters[provinceName];
  if (!center) return;

  const chart = chartRef.value;
  if (!chart) return;

  const chartInstance = chart.chart || chart;
  if (!chartInstance) return;

  // 设置地图中心和缩放级别（放大倍数调大）
  currentCenter.value = center;
  currentZoom.value = 7;

  chartInstance.setOption({
    geo: {
      center: center,
      zoom: 7,
      animationDurationUpdate: 1000,
      animationEasingUpdate: 'cubicInOut'
    }
  }, { notMerge: false });
}

// 选择朝代
function selectDynasty(dynasty) {
  selectedDynasty.value = dynasty;
  loadMapData();
}

// 诗人搜索
let searchTimer = null;
function onPoetSearch() {
  if (searchTimer) clearTimeout(searchTimer);
  searchTimer = setTimeout(() => {
    const keyword = poetSearchKeyword.value.trim().toLowerCase();
    if (!keyword) {
      poetSearchResults.value = [];
      return;
    }
    poetSearchResults.value = poets.value.filter(p =>
        p.name.toLowerCase().includes(keyword)
    ).slice(0, 5);
  }, 300);
}

// 选择地点
async function selectLocation(loc) {
  selectedLocation.value = loc;
  showDetail.value = true;
  detailType.value = 'location';
  showLocationCard.value = true;

  updateCardPosition(loc);

  try {
    const res = await getLocationDetail(loc.id);
    locationDetail.value = res?.data || res;
  } catch (error) {
    console.error('获取地点详情失败:', error);
    locationDetail.value = loc;
  }
}

function updateCardPosition(loc) {
  if (!loc) return;
  const chart = chartRef.value;
  if (chart) {
    const chartInstance = chart.chart || chart;
    if (chartInstance && loc.longitude && loc.latitude) {
      const pixel = chartInstance.convertToPixel('geo', [loc.longitude, loc.latitude]);
      if (pixel) {
        cardPosition.value = { x: pixel[0], y: pixel[1] };
      }
    }
  }
}

function scheduleUpdateCardPosition() {
  if (cardPositionRafId) cancelAnimationFrame(cardPositionRafId);
  cardPositionRafId = requestAnimationFrame(() => {
    cardPositionRafId = null;
    if (showLocationCard.value && selectedLocation.value) {
      updateCardPosition(selectedLocation.value);
    }
  });
}

function closeLocationCard() {
  showLocationCard.value = false;
}

// 选择诗人
async function selectPoet(poet) {
  selectedPoet.value = poet;
  poetSearchKeyword.value = '';
  poetSearchResults.value = [];
  showDetail.value = true;
  detailType.value = 'poet';
  showLocationCard.value = false;

  // 先清空之前的数据，防止数据残留混乱
  poetRoute.value = [];
  poetRelationships.value = { nodes: [], edges: [] };
  routeMode.value = false;
  displayedRoutePoints.value = 0; // 重置已显示的路线点数量

  // 如果正在展示路线，先清除之前的定时器
  if (routeAnimationTimer) {
    cancelAnimationFrame(routeAnimationTimer);
    routeAnimationTimer = null;
    activeRouteAnimationToken += 1;
  }
  if (routeZoomTimer) {
    clearTimeout(routeZoomTimer);
    routeZoomTimer = null;
  }
  isRouteAnimating = false; // 重置动画标记

  // 清空路线后立即清除地图上的显示，避免重影
  const chart = chartRef.value;
  if (chart) {
    const chartInstance = chart.chart || chart;
    if (chartInstance) {
      // 清除旧的路线数据，使用 notMerge: true 确保完全替换
      chartInstance.setOption({
        series: [
          { id: 'poet-route-lines', data: [] },
          { id: 'poet-route-points', data: [] }
        ]
      }, { notMerge: false, replaceMerge: ['series'] });
    }
  }

  try {
    const [routeRes, relRes, timelineRes] = await Promise.all([
      getPoetRoute(poet.id),
      getPoetRelationships(poet.id),
      getTimeline(poet.id)
    ]);

    // 确保返回的数据属于当前选中的诗人
    if (selectedPoet.value?.id !== poet.id) {
      return; // 如果用户已经切换到其他诗人，放弃本次数据更新
    }

    const originalRoute = routeRes?.data?.route || [];
    const normalizedRoute = originalRoute
        .filter(point => Number.isFinite(Number(point.longitude)) && Number.isFinite(Number(point.latitude)))
        .map(point => ({
          ...point,
          longitude: Number(point.longitude),
          latitude: Number(point.latitude),
          locationName: (point.locationName || '').trim()
        }));

    const uniqueRoute = [];
    const segmentSet = new Set();

    for (let i = 0; i < normalizedRoute.length; i++) {
      const currentPoint = normalizedRoute[i];
      const prevPoint = uniqueRoute[uniqueRoute.length - 1];

      if (
          prevPoint &&
          prevPoint.locationName === currentPoint.locationName &&
          Math.abs(prevPoint.longitude - currentPoint.longitude) < 0.000001 &&
          Math.abs(prevPoint.latitude - currentPoint.latitude) < 0.000001
      ) {
        continue;
      }

      uniqueRoute.push(currentPoint);
    }

    const cleanedRoute = uniqueRoute.filter((point, index, arr) => {
      if (index === 0) return true;
      const prev = arr[index - 1];
      const forwardKey = `${prev.longitude},${prev.latitude}->${point.longitude},${point.latitude}`;
      const reverseKey = `${point.longitude},${point.latitude}->${prev.longitude},${prev.latitude}`;
      if (segmentSet.has(forwardKey) || segmentSet.has(reverseKey)) {
        return false;
      }
      segmentSet.add(forwardKey);
      return true;
    });

    poetRoute.value = cleanedRoute;
    poetRelationships.value = relRes?.data || { nodes: [], edges: [] };

    // 如果有路线数据，自动开启路线模式并逐点展示
    if (poetRoute.value.length > 0) {
      routeMode.value = true;
      // 先平滑放大地图（耗时 1s）
      focusOnRoute();
      // 等待地图平滑过渡完成后再启动足迹绘制动画（延迟 1100ms）
      setTimeout(() => {
        startRouteAnimation();
      }, 1100);
    }
  } catch (error) {
    console.error('获取诗人信息失败:', error);
    // 请求失败时保持数据为空，不使用旧数据
  }
}

// 自动聚焦到诗人路线
function focusOnRoute() {
  if (poetRoute.value.length === 0) return;

  const chart = chartRef.value;
  if (!chart) return;

  const chartInstance = chart.chart || chart;
  if (!chartInstance) return;

  // 计算路线的边界
  let minLng = Infinity, maxLng = -Infinity;
  let minLat = Infinity, maxLat = -Infinity;

  poetRoute.value.forEach(point => {
    minLng = Math.min(minLng, point.longitude);
    maxLng = Math.max(maxLng, point.longitude);
    minLat = Math.min(minLat, point.latitude);
    maxLat = Math.max(maxLat, point.latitude);
  });

  // 计算中心点
  const centerLng = (minLng + maxLng) / 2;
  const centerLat = (minLat + maxLat) / 2;

  // 计算合适的缩放级别
  const lngRange = maxLng - minLng;
  const latRange = maxLat - minLat;
  const maxRange = Math.max(lngRange, latRange);

  // 根据范围计算缩放级别（调高倍率以实现特写感）
  let zoom;
  if (maxRange > 20) {
    zoom = 2.8;
  } else if (maxRange > 10) {
    zoom = 3.8;
  } else if (maxRange > 5) {
    zoom = 4.8;
  } else if (maxRange > 2) {
    zoom = 5.8;
  } else {
    zoom = 6.8;
  }

  // 同步更新响应式变量，保持状态一致
  currentZoom.value = zoom;
  currentCenter.value = [centerLng, centerLat];

  // 使用 setOption 触发局部补间动画，实现平滑聚焦特写
  chartInstance.setOption({
    geo: {
      zoom: zoom,
      center: [centerLng, centerLat],
      animationDurationUpdate: 1000,
      animationEasingUpdate: 'cubicInOut'
    }
  }, { notMerge: false });

  scheduleUpdateCardPosition();
}

// 启动路线逐点动画
function startRouteAnimation() {
  // 清除之前的动画
  if (routeAnimationTimer) {
    cancelAnimationFrame(routeAnimationTimer);
    routeAnimationTimer = null;
    activeRouteAnimationToken += 1;
  }
  if (routeZoomTimer) {
    clearTimeout(routeZoomTimer);
    routeZoomTimer = null;
  }

  const totalPoints = poetRoute.value.length;
  if (totalPoints === 0) return;

  // 标记正在展示动画
  isRouteAnimating = true;

  // 立即显示第一个点
  displayedRoutePoints.value = 1;

  // 优化动画执行，减少不必要的更新
  let animationFrameId = null;
  let lastUpdateTime = Date.now();
  const interval = 2000; // 每个点间隔从 800ms 增加到 2000ms，配合 ECharts 的 animationDuration 实现平滑衔接

  function animate() {
    const currentTime = Date.now();
    if (currentTime - lastUpdateTime >= interval) {
      if (displayedRoutePoints.value < totalPoints) {
        displayedRoutePoints.value++;
        lastUpdateTime = currentTime;
      } else {
        // 动画完成
        isRouteAnimating = false; // 标记动画已完成
        // 移除自动缩小地图的逻辑，保持地图放大状态
        return;
      }
    }
    animationFrameId = requestAnimationFrame(animate);
  }

  // 使用 requestAnimationFrame 代替 setInterval，提高动画性能
  animationFrameId = requestAnimationFrame(animate);

  // 保存动画帧 ID，以便后续清除
  routeAnimationTimer = animationFrameId;
}

// 查看诗人路线
function viewPoetRoute(poet) {
  routeMode.value = true;
  selectPoet(poet);
}

// 地图点击事件
function onMapClick(params) {
  if (!params.name) return;

  // 如果点击的是省份区域（geo组件）
  if (params.componentType === 'geo') {
    let prov = provinces.value.find(p => p.name === params.name);

    // 如果直接匹配失败，尝试去除"省"、"自治区"、"市"、"特别行政区"等后缀进行匹配
    if (!prov) {
      const simplifiedName = params.name.replace(/(省|自治区|市|特别行政区)$/, '');
      prov = provinces.value.find(p =>
          p.name === simplifiedName ||
          p.name.includes(simplifiedName) ||
          simplifiedName.includes(p.name)
      );
    }

    if (prov) {
      // 设置聚焦省份
      focusedProvince.value = params.name;
      leftPanelTab.value = 'provinces';
      selectProvince(prov);
      return;
    }
  }

  // 如果点击的是散点（诗词地点）
  if (params.componentType === 'series') {
    const loc = locations.value.find(l => l.name === params.name);
    if (loc) {
      leftPanelTab.value = 'locations';
      selectLocation(loc);
    }
  }
}

// 关闭详情
function closeDetail() {
  showDetail.value = false;
  detailType.value = null;
  selectedLocation.value = null;
  selectedProvince.value = null;
  selectedPoet.value = null;
  provinceDetail.value = null;
  showLocationCard.value = false;
  focusedProvince.value = null;

  if (routeAnimationTimer) {
    cancelAnimationFrame(routeAnimationTimer);
    routeAnimationTimer = null;
  }
  if (routeZoomTimer) {
    clearTimeout(routeZoomTimer);
    routeZoomTimer = null;
  }

  activeRouteAnimationToken += 1;
  routeMode.value = false;
  poetRoute.value = [];
  displayedRoutePoints.value = 0;
  isRouteAnimating = false;

  const chart = chartRef.value;
  const chartInstance = chart?.chart || chart;
  chartInstance?.setOption?.({
    series: [
      { id: 'poet-route-lines', data: [] },
      { id: 'poet-route-points', data: [] }
    ]
  }, { notMerge: false, replaceMerge: ['series'] });
}

// 切换路线模式
function toggleRouteMode() {
  routeMode.value = !routeMode.value;

  if (routeAnimationTimer) {
    cancelAnimationFrame(routeAnimationTimer);
    routeAnimationTimer = null;
  }
  if (routeZoomTimer) {
    clearTimeout(routeZoomTimer);
    routeZoomTimer = null;
  }

  activeRouteAnimationToken += 1;

  if (!routeMode.value) {
    displayedRoutePoints.value = 0;
    isRouteAnimating = false;

    const chart = chartRef.value;
    const chartInstance = chart?.chart || chart;
    chartInstance?.setOption?.({
      series: [
        { id: 'poet-route-lines', data: [] },
        { id: 'poet-route-points', data: [] }
      ]
    }, { notMerge: false, replaceMerge: ['series'] });
    return;
  }

  if (poetRoute.value.length > 0) {
    focusOnRoute();
    startRouteAnimation();
  }
}

// 重置视图
function resetView() {
  selectedDynasty.value = '全部';
  closeDetail();
  loadMapData();
  resetZoom();
}

// 地图缩放
function zoomIn() {
  const chart = chartRef.value;
  if (chart) {
    const chartInstance = chart.chart || chart;
    if (chartInstance) {
      let zoom = 1.9;
      try {
        const option = chartInstance.getOption();
        zoom = option?.geo?.[0]?.zoom || 1.9;
      } catch (e) {}
      const newZoom = Math.min(5, zoom * 1.3);
      currentZoom.value = newZoom;
      chartInstance.setOption({
        geo: { zoom: newZoom }
      });
      scheduleUpdateCardPosition();
    }
  }
}

function zoomOut() {
  const chart = chartRef.value;
  if (chart) {
    const chartInstance = chart.chart || chart;
    if (chartInstance) {
      let zoom = 1.9;
      try {
        const option = chartInstance.getOption();
        zoom = option?.geo?.[0]?.zoom || 1.9;
      } catch (e) {}
      const newZoom = Math.max(0.5, zoom / 1.3);
      currentZoom.value = newZoom;
      chartInstance.setOption({
        geo: { zoom: newZoom }
      });
      scheduleUpdateCardPosition();
    }
  }
}

function resetZoom() {
  const chart = chartRef.value;
  currentZoom.value = 1.9;
  currentCenter.value = [105, 36];
  if (chart) {
    const chartInstance = chart.chart || chart;
    if (chartInstance) {
      chartInstance.setOption({
        geo: { zoom: 1.9, center: [105, 36] }
      });
      scheduleUpdateCardPosition();
    }
  }
}

// 地图缩放事件监听
function onGeoRoam(params) {
  // 同步地图最新的缩放和中心点到 Vue 状态，防止 Vue 渲染时覆盖地图状态
  const chart = chartRef.value;
  if (chart) {
    const chartInstance = chart.chart || chart;
    const option = chartInstance.getOption();
    if (option && option.geo && option.geo[0]) {
      currentZoom.value = option.geo[0].zoom;
      currentCenter.value = option.geo[0].center;
    }
  }

  if (showLocationCard.value && selectedLocation.value) {
    scheduleUpdateCardPosition();
  }
}


// 简化的中国地图GeoJSON数据（备用，包含省份边界）
const simpleChinaGeoJson = {
  type: 'FeatureCollection',
  features: [
    { type: 'Feature', properties: { name: '中国' }, geometry: { type: 'Polygon', coordinates: [[[73, 18], [73, 54], [135, 54], [135, 18], [73, 18]]] } }
  ]
};

// 内置简化地图数据（省份轮廓）
const builtinChinaGeoJson = {
  "type": "FeatureCollection",
  "features": [
    {"type":"Feature","properties":{"name":"新疆"},"geometry":{"type":"Polygon","coordinates":[[[73.5,35],[73.5,49],[96.5,49],[96.5,35],[73.5,35]]]}},
    {"type":"Feature","properties":{"name":"西藏"},"geometry":{"type":"Polygon","coordinates":[[[78.5,26.5],[78.5,36],[99,36],[99,26.5],[78.5,26.5]]]}},
    {"type":"Feature","properties":{"name":"内蒙古"},"geometry":{"type":"Polygon","coordinates":[[[97,37],[97,53.5],[126,53.5],[126,37],[97,37]]]}},
    {"type":"Feature","properties":{"name":"青海"},"geometry":{"type":"Polygon","coordinates":[[[89.5,31.5],[89.5,39],[103,39],[103,31.5],[89.5,31.5]]]}},
    {"type":"Feature","properties":{"name":"四川"},"geometry":{"type":"Polygon","coordinates":[[[97,26],[97,34],[108.5,34],[108.5,26],[97,26]]]}},
    {"type":"Feature","properties":{"name":"黑龙江"},"geometry":{"type":"Polygon","coordinates":[[[121,43],[121,53.5],[135.5,53.5],[135.5,43],[121,43]]]}},
    {"type":"Feature","properties":{"name":"吉林"},"geometry":{"type":"Polygon","coordinates":[[[121.5,40.5],[121.5,47],[131.5,47],[131.5,40.5],[121.5,40.5]]]}},
    {"type":"Feature","properties":{"name":"辽宁"},"geometry":{"type":"Polygon","coordinates":[[[118.5,38.5],[118.5,43.5],[126,43.5],[126,38.5],[118.5,38.5]]]}},
    {"type":"Feature","properties":{"name":"甘肃"},"geometry":{"type":"Polygon","coordinates":[[[92.5,32.5],[92.5,42.5],[108.5,42.5],[108.5,32.5],[92.5,32.5]]]}},
    {"type":"Feature","properties":{"name":"河北"},"geometry":{"type":"Polygon","coordinates":[[[113.5,36],[113.5,42.5],[119.5,42.5],[119.5,36],[113.5,36]]]}},
    {"type":"Feature","properties":{"name":"山东"},"geometry":{"type":"Polygon","coordinates":[[[114.5,34],[114.5,38.5],[122.5,38.5],[122.5,34],[114.5,34]]]}},
    {"type":"Feature","properties":{"name":"河南"},"geometry":{"type":"Polygon","coordinates":[[[110,31],[110,36.5],[116.5,36.5],[116.5,31],[110,31]]]}},
    {"type":"Feature","properties":{"name":"江苏"},"geometry":{"type":"Polygon","coordinates":[[[116.5,30.5],[116.5,35],[122,35],[122,30.5],[116.5,30.5]]]}},
    {"type":"Feature","properties":{"name":"安徽"},"geometry":{"type":"Polygon","coordinates":[[[114.5,29],[114.5,34.5],[119.5,34.5],[119.5,29],[114.5,29]]]}},
    {"type":"Feature","properties":{"name":"湖北"},"geometry":{"type":"Polygon","coordinates":[[[108.5,29],[108.5,33.5],[116.5,33.5],[116.5,29],[108.5,29]]]}},
    {"type":"Feature","properties":{"name":"湖南"},"geometry":{"type":"Polygon","coordinates":[[[108.5,24.5],[108.5,30.5],[114.5,30.5],[114.5,24.5],[108.5,24.5]]]}},
    {"type":"Feature","properties":{"name":"江西"},"geometry":{"type":"Polygon","coordinates":[[[113.5,24],[113.5,30.5],[118.5,30.5],[118.5,24],[113.5,24]]]}},
    {"type":"Feature","properties":{"name":"浙江"},"geometry":{"type":"Polygon","coordinates":[[[118,27],[118,31.5],[123,31.5],[123,27],[118,27]]]}},
    {"type":"Feature","properties":{"name":"福建"},"geometry":{"type":"Polygon","coordinates":[[[115.5,23.5],[115.5,28.5],[120.5,28.5],[120.5,23.5],[115.5,23.5]]]}},
    {"type":"Feature","properties":{"name":"广东"},"geometry":{"type":"Polygon","coordinates":[[[109.5,20],[109.5,25.5],[117.5,25.5],[117.5,20],[109.5,20]]]}},
    {"type":"Feature","properties":{"name":"广西"},"geometry":{"type":"Polygon","coordinates":[[[104,20.5],[104,26.5],[112,26.5],[112,20.5],[104,20.5]]]}},
    {"type":"Feature","properties":{"name":"云南"},"geometry":{"type":"Polygon","coordinates":[[[97.5,21],[97.5,29.5],[106.5,29.5],[106.5,21],[97.5,21]]]}},
    {"type":"Feature","properties":{"name":"贵州"},"geometry":{"type":"Polygon","coordinates":[[[103.5,24.5],[103.5,29.5],[109.5,29.5],[109.5,24.5],[103.5,24.5]]]}},
    {"type":"Feature","properties":{"name":"陕西"},"geometry":{"type":"Polygon","coordinates":[[[105.5,31],[105.5,39.5],[111.5,39.5],[111.5,31],[105.5,31]]]}},
    {"type":"Feature","properties":{"name":"山西"},"geometry":{"type":"Polygon","coordinates":[[[110,34],[110,40.5],[114.5,40.5],[114.5,34],[110,34]]]}},
    {"type":"Feature","properties":{"name":"宁夏"},"geometry":{"type":"Polygon","coordinates":[[[104,35],[104,39.5],[107.5,39.5],[107.5,35],[104,35]]]}},
    {"type":"Feature","properties":{"name":"海南"},"geometry":{"type":"Polygon","coordinates":[[[108.5,18],[108.5,20.5],[111.5,20.5],[111.5,18],[108.5,18]]]}},
    {"type":"Feature","properties":{"name":"台湾"},"geometry":{"type":"Polygon","coordinates":[[[119.5,21.5],[119.5,25.5],[122,25.5],[122,21.5],[119.5,21.5]]]}},
    {"type":"Feature","properties":{"name":"北京"},"geometry":{"type":"Polygon","coordinates":[[[115.5,39],[115.5,41],[117.5,41],[117.5,39],[115.5,39]]]}},
    {"type":"Feature","properties":{"name":"天津"},"geometry":{"type":"Polygon","coordinates":[[[116.5,38.5],[116.5,40],[118.5,40],[118.5,38.5],[116.5,38.5]]]}},
    {"type":"Feature","properties":{"name":"上海"},"geometry":{"type":"Polygon","coordinates":[[[120.5,30.5],[120.5,31.5],[122.5,31.5],[122.5,30.5],[120.5,30.5]]]}},
    {"type":"Feature","properties":{"name":"重庆"},"geometry":{"type":"Polygon","coordinates":[[[105,28],[105,32.5],[110.5,32.5],[110.5,28],[105,28]]]}},
    {"type":"Feature","properties":{"name":"香港"},"geometry":{"type":"Polygon","coordinates":[[[113.8,22.2],[113.8,22.6],[114.4,22.6],[114.4,22.2],[113.8,22.2]]]}},
    {"type":"Feature","properties":{"name":"澳门"},"geometry":{"type":"Polygon","coordinates":[[[113.5,22.1],[113.5,22.3],[113.6,22.3],[113.6,22.1],[113.5,22.1]]]}}
  ]
};

// 初始化中国地图
async function initChinaMap() {
  loadingStatus.value = '正在加载地图资源...';
  loadingProgress.value = 10;

  // 优先使用内置地图数据，确保快速加载
  try {
    echarts.registerMap('china', builtinChinaGeoJson);
    mapLoaded.value = true;
    mapError.value = false;
    loadingStatus.value = '地图加载完成';
    loadingProgress.value = 50;
    console.log('使用内置地图数据加载成功');

    // 后台异步加载更详细的地图数据（可选）
    fetchDetailedMapData();
    return true;
  } catch (error) {
    console.error('内置地图初始化失败:', error);
  }

  // 尝试远程数据源
  const urls = [
    'https://geo.datav.aliyun.com/areas_v3/bound/100000_full.json',
    'https://unpkg.com/echarts/map/json/china.json'
  ];

  for (let i = 0; i < urls.length; i++) {
    const url = urls[i];
    loadingStatus.value = `正在尝试数据源 ${i + 1}/${urls.length}...`;
    loadingProgress.value = 10 + (i + 1) * 15;

    try {
      const response = await fetch(url);
      if (response.ok) {
        const chinaGeoJson = await response.json();
        echarts.registerMap('china', chinaGeoJson);
        mapLoaded.value = true;
        mapError.value = false;
        loadingStatus.value = '地图加载完成';
        loadingProgress.value = 50;
        console.log('地图加载成功:', url);
        return true;
      }
    } catch (error) {
      console.warn('地图数据源加载失败:', url, error);
    }
  }

  // 所有数据源都失败，使用简化地图
  try {
    echarts.registerMap('china', simpleChinaGeoJson);
    mapLoaded.value = true;
    mapError.value = false;
    loadingStatus.value = '地图加载完成（简化版）';
    loadingProgress.value = 50;
    console.log('使用简化地图');
    return true;
  } catch (error) {
    console.error('地图初始化完全失败:', error);
    mapError.value = true;
    loadingStatus.value = '地图加载失败';
    return false;
  }
}

// 后台异步加载详细地图数据
async function fetchDetailedMapData() {
  try {
    const response = await fetch('https://geo.datav.aliyun.com/areas_v3/bound/100000_full.json');
    if (response.ok) {
      const detailedGeoJson = await response.json();
      echarts.registerMap('china', detailedGeoJson);
      console.log('详细地图数据后台加载完成');
    }
  } catch (error) {
    // 静默失败，不影响已加载的内置地图
    console.log('详细地图数据后台加载跳过');
  }
}

// 生命周期
onMounted(async () => {
  // 并行初始化地图和加载数据
  loadingStatus.value = '正在初始化...';
  loadingProgress.value = 5;

  try {
    // 并行执行地图初始化和数据加载
    const [, dataResult, provinceResult] = await Promise.all([
      initChinaMap(),
      (async () => {
        loadingStatus.value = '正在加载诗词数据...';
        loadingProgress.value = 30;
        await loadMapData();
        loadingProgress.value = 80;
        return true;
      })(),
      loadProvinces()
    ]);

    loadingStatus.value = '加载完成';
    loadingProgress.value = 100;
  } catch (error) {
    console.error('初始化失败:', error);
    loadingStatus.value = '加载失败，请刷新重试';
  }

  // 延迟添加加载完成类，触发入场动画
  setTimeout(() => {
    isLoaded.value = true;
  }, 100);
});

onUnmounted(() => {
  if (searchTimer) clearTimeout(searchTimer);
  if (routeAnimationTimer) cancelAnimationFrame(routeAnimationTimer);
  if (routeZoomTimer) clearTimeout(routeZoomTimer);
  if (cardPositionRafId) cancelAnimationFrame(cardPositionRafId);
});
</script>

<style scoped>
/* ========== 深色古风水墨配色变量 ========== */
.poetry-map {
  /* 深色宣纸色系 - 更浓郁的古风韵味 */
  --paper-bg: #e8dcc8;
  --paper-light: #f0e8d8;
  --paper-warm: #dfd0b8;

  /* 墨色系 - 稍深以提高对比度 */
  --ink-dark: rgba(0, 0, 0, 0.9);
  --ink-medium: rgba(0, 0, 0, 0.68);
  --ink-light: rgba(0, 0, 0, 0.42);

  /* 古铜/棕色系（主色调）- 加深以匹配深色宣纸 */
  --bronze-primary: #7a6348;
  --bronze-light: #9a8068;
  --bronze-dark: #5d4a35;
  --bronze-glow: rgba(122, 99, 72, 0.35);

  /* 朱砂红（印章点缀） */
  --vermilion: #b83834;
  --vermilion-light: #d65854;

  /* 玻璃效果 - 适配深色宣纸背景 */
  --glass-bg: rgba(232, 220, 200, 0.85);
  --glass-light: rgba(240, 232, 216, 0.92);
  --glass-border: rgba(122, 99, 72, 0.12);

  /* 固定全屏布局，留出顶部主导航栏空间 */
  position: fixed;
  top: 64px;
  left: 0;
  right: 0;
  bottom: 0;
  width: 100vw;
  height: calc(100vh - 64px);
  display: flex;
  flex-direction: column;
  font-family: 'STKaiti', 'KaiTi', '楷体', 'PingFang SC', 'Microsoft YaHei', serif;
  overflow: hidden;
}

/* ========== 淡雅水墨背景 ========== */
.map-bg {
  position: absolute;
  inset: 0;
  background: url('@/assets/bg/map.jpg') center center / cover no-repeat;
  transform: translateZ(0);
  z-index: 0;
}



.map-bg-mask {
  position: absolute;
  inset: 0;
  background:
      radial-gradient(1200px 800px at 20% 25%, rgba(255, 255, 255, 0.3), transparent 60%),
      linear-gradient(180deg, rgba(255, 255, 255, 0.15), transparent);
  pointer-events: none;
  z-index: 1;
}

/* ========== 地图加载状态 ========== */
.map-loading-overlay {
  position: absolute;
  inset: 0;
  background: rgba(232, 220, 200, 0.96);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
  backdrop-filter: blur(8px);
}

.loading-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 24px;
}

.loading-spinner {
  position: relative;
  width: 80px;
  height: 80px;
}

.spinner-ring {
  position: absolute;
  inset: 0;
  border: 3px solid transparent;
  border-top-color: var(--bronze-primary);
  border-radius: 50%;
  animation: spin 1.2s linear infinite;
}

.spinner-ring:nth-child(2) {
  inset: 8px;
  border-top-color: var(--bronze-light);
  animation-delay: -0.4s;
  animation-duration: 1s;
}

.spinner-ring:nth-child(3) {
  inset: 16px;
  border-top-color: var(--vermilion);
  animation-delay: -0.2s;
  animation-duration: 0.8s;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading-text {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.loading-title {
  font-size: 24px;
  font-weight: bold;
  color: var(--ink-dark);
  letter-spacing: 4px;
}

.loading-status {
  font-size: 14px;
  color: var(--ink-medium);
}

.loading-progress {
  width: 200px;
  height: 4px;
  background: rgba(139, 115, 85, 0.15);
  border-radius: 2px;
  overflow: hidden;
}

.progress-bar {
  height: 100%;
  background: linear-gradient(90deg, var(--bronze-dark), var(--bronze-primary), var(--bronze-light));
  border-radius: 2px;
  transition: width 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

/* ========== 古风边框装饰 ========== */
.ancient-frame {
  position: absolute;
  inset: 0;
  pointer-events: none;
  z-index: 60;
}

.frame-corner {
  position: absolute;
  width: 80px;
  height: 80px;
  background: transparent;
}

.frame-corner::before,
.frame-corner::after {
  content: '';
  position: absolute;
}

.frame-tl {
  top: 12px;
  left: 12px;
}
.frame-tl::before {
  top: 0;
  left: 0;
  width: 60px;
  height: 3px;
  background: linear-gradient(90deg, rgba(139, 115, 85, 0.5), transparent);
}
.frame-tl::after {
  top: 0;
  left: 0;
  width: 3px;
  height: 60px;
  background: linear-gradient(180deg, rgba(139, 115, 85, 0.5), transparent);
}

.frame-tr {
  top: 12px;
  right: 12px;
}
.frame-tr::before {
  top: 0;
  right: 0;
  width: 60px;
  height: 3px;
  background: linear-gradient(270deg, rgba(139, 115, 85, 0.5), transparent);
}
.frame-tr::after {
  top: 0;
  right: 0;
  width: 3px;
  height: 60px;
  background: linear-gradient(180deg, rgba(139, 115, 85, 0.5), transparent);
}

.frame-bl {
  bottom: 12px;
  left: 12px;
}
.frame-bl::before {
  bottom: 0;
  left: 0;
  width: 60px;
  height: 3px;
  background: linear-gradient(90deg, rgba(139, 115, 85, 0.5), transparent);
}
.frame-bl::after {
  bottom: 0;
  left: 0;
  width: 3px;
  height: 60px;
  background: linear-gradient(0deg, rgba(139, 115, 85, 0.5), transparent);
}

.frame-br {
  bottom: 12px;
  right: 12px;
}
.frame-br::before {
  bottom: 0;
  right: 0;
  width: 60px;
  height: 3px;
  background: linear-gradient(270deg, rgba(139, 115, 85, 0.5), transparent);
}
.frame-br::after {
  bottom: 0;
  right: 0;
  width: 3px;
  height: 60px;
  background: linear-gradient(0deg, rgba(139, 115, 85, 0.5), transparent);
}

.frame-edge {
  position: absolute;
  opacity: 0.25;
}

.frame-top {
  top: 20px;
  left: 100px;
  right: 100px;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(139, 115, 85, 0.4), transparent);
}

.frame-bottom {
  bottom: 20px;
  left: 100px;
  right: 100px;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(139, 115, 85, 0.4), transparent);
}

.frame-left {
  left: 20px;
  top: 100px;
  bottom: 100px;
  width: 1px;
  background: linear-gradient(180deg, transparent, rgba(139, 115, 85, 0.4), transparent);
}

.frame-right {
  right: 20px;
  top: 100px;
  bottom: 100px;
  width: 1px;
  background: linear-gradient(180deg, transparent, rgba(139, 115, 85, 0.4), transparent);
}

/* ========== 印章装饰 ========== */
.seal-decoration {
  position: absolute;
  width: 48px;
  height: 48px;
  border: 2px solid rgba(199, 62, 58, 0.55);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 22px;
  font-weight: bold;
  color: rgba(199, 62, 58, 0.65);
  background: rgba(199, 62, 58, 0.06);
  transform: rotate(-8deg);
  z-index: 55;
  pointer-events: none;
  font-family: 'STKaiti', 'KaiTi', serif;
  box-shadow:
      inset 0 0 15px rgba(199, 62, 58, 0.08),
      0 0 20px rgba(199, 62, 58, 0.1);
}

.seal-decoration::before {
  content: '';
  position: absolute;
  inset: 3px;
  border: 1px solid rgba(199, 62, 58, 0.3);
  border-radius: 4px;
}

.seal-1 {
  top: 100px;
  right: 40px;
  animation: sealFloat 6s ease-in-out infinite;
}

.seal-2 {
  bottom: 150px;
  left: 40px;
  animation: sealFloat 6s ease-in-out infinite 1.5s;
}

@keyframes sealFloat {
  0%, 100% { transform: rotate(-8deg) translateY(0); }
  50% { transform: rotate(-8deg) translateY(-5px); }
}

/* ========== 薄雾效果 ========== */
.fog {
  position: absolute;
  inset: -30%;
  background:
      radial-gradient(circle at 20% 20%, rgba(255,255,255,.45), transparent 45%),
      radial-gradient(circle at 70% 35%, rgba(255,255,255,.30), transparent 48%);
  animation: drift 12s ease-in-out infinite alternate;
  pointer-events: none;
  z-index: 2;
  will-change: transform;
}

@keyframes drift {
  from { transform: translate3d(-1%, -0.5%, 0); }
  to   { transform: translate3d( 1%,  0.5%, 0); }
}

/* ========== 光效 ========== */
.light-effect {
  position: absolute;
  inset: -40%;
  background: radial-gradient(circle at 60% 40%, rgba(255,255,255,.45), transparent 55%);
  animation: sweep 8s ease-in-out infinite;
  pointer-events: none;
  z-index: 3;
  mix-blend-mode: screen;
  opacity: 0.45;
  will-change: transform;
}

@keyframes sweep {
  0%   { transform: translateX(-4%) translateY(1%); opacity: 0.30; }
  50%  { transform: translateX( 4%) translateY(-1%); opacity: 0.50; }
  100% { transform: translateX(-4%) translateY(1%); opacity: 0.30; }
}

/* ========== 水墨装饰背景 ========== */
.ink-decorations {
  position: absolute;
  inset: 0;
  pointer-events: none;
  overflow: hidden;
  z-index: 4;
}

.ink-blob {
  position: absolute;
  border-radius: 50%;
  filter: blur(100px);
  opacity: 0.2;
  animation: inkFloat 25s ease-in-out infinite;
}

.ink-blob-1 {
  width: 600px;
  height: 600px;
  background: radial-gradient(circle, rgba(139, 115, 85, 0.2) 0%, transparent 70%);
  top: -200px;
  left: -200px;
  animation-delay: 0s;
}

.ink-blob-2 {
  width: 700px;
  height: 700px;
  background: radial-gradient(circle, rgba(168, 144, 120, 0.15) 0%, transparent 70%);
  bottom: -250px;
  right: -250px;
  animation-delay: -8s;
}

.ink-blob-3 {
  width: 400px;
  height: 400px;
  background: radial-gradient(circle, rgba(199, 62, 58, 0.1) 0%, transparent 70%);
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  animation-delay: -16s;
}

@keyframes inkFloat {
  0%, 100% { transform: translate(0, 0) scale(1) rotate(0deg); }
  25% { transform: translate(50px, -50px) scale(1.2) rotate(5deg); }
  50% { transform: translate(-40px, 40px) scale(0.85) rotate(-3deg); }
  75% { transform: translate(40px, 50px) scale(1.15) rotate(2deg); }
}

/* ========== 入场动画（增强版） ========== */
.poetry-map > .left-nav,
.poetry-map > .main-content {
  opacity: 0;
  transform: translateX(-30px);
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1), transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.poetry-map.loaded > .left-nav {
  opacity: 1;
  transform: translateX(0);
  transition-delay: 0.1s;
}

.poetry-map.loaded > .main-content {
  opacity: 1;
  transform: translateX(0);
  transition-delay: 0.2s;
}

/* 左侧面板入场 */
.poetry-map.loaded .left-panel {
  animation: slideInLeft 0.3s cubic-bezier(0.4, 0, 0.2, 1) forwards;
  animation-delay: 0.25s;
}

@keyframes slideInLeft {
  from {
    opacity: 0;
    transform: translateX(-50px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateX(0) scale(1);
  }
}

/* 右侧面板入场 */
.poetry-map.loaded .right-panel {
  animation: slideInRight 0.3s cubic-bezier(0.4, 0, 0.2, 1) forwards;
  animation-delay: 0.3s;
}

@keyframes slideInRight {
  from {
    opacity: 0;
    transform: translateX(50px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateX(0) scale(1);
  }
}

/* 地图容器入场 */
.poetry-map.loaded .map-container {
  animation: fadeInScale 0.4s cubic-bezier(0.4, 0, 0.2, 1) forwards;
  animation-delay: 0.15s;
}

@keyframes fadeInScale {
  from {
    opacity: 0;
    transform: scale(0.92);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

/* 列表项依次入场 */
.location-item, .poet-item {
  animation: itemSlideIn 0.3s cubic-bezier(0.4, 0, 0.2, 1) forwards;
  opacity: 0;
}

@keyframes itemSlideIn {
  from {
    opacity: 0;
    transform: translateX(-25px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateX(0) scale(1);
  }
}

.poetry-map.loaded .location-item:nth-child(1) { animation-delay: 0.3s; }
.poetry-map.loaded .location-item:nth-child(2) { animation-delay: 0.34s; }
.poetry-map.loaded .location-item:nth-child(3) { animation-delay: 0.38s; }
.poetry-map.loaded .location-item:nth-child(4) { animation-delay: 0.42s; }
.poetry-map.loaded .location-item:nth-child(5) { animation-delay: 0.46s; }
.poetry-map.loaded .location-item:nth-child(6) { animation-delay: 0.5s; }
.poetry-map.loaded .location-item:nth-child(7) { animation-delay: 0.54s; }
.poetry-map.loaded .location-item:nth-child(8) { animation-delay: 0.58s; }

.poetry-map.loaded .poet-item:nth-child(1) { animation-delay: 0.3s; }
.poetry-map.loaded .poet-item:nth-child(2) { animation-delay: 0.34s; }
.poetry-map.loaded .poet-item:nth-child(3) { animation-delay: 0.38s; }
.poetry-map.loaded .poet-item:nth-child(4) { animation-delay: 0.42s; }
.poetry-map.loaded .poet-item:nth-child(5) { animation-delay: 0.46s; }

/* ========== 左侧筛选面板 - 滑出式 ========== */
.filter-panel {
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
  width: 360px;
  background: rgba(245, 240, 230, 0.99);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-right: 1px solid rgba(139, 115, 85, 0.25);
  box-shadow: 6px 0 40px rgba(0, 0, 0, 0.15);
  display: flex;
  flex-direction: column;
  z-index: 200;
  padding: 24px;
  box-sizing: border-box;
  overflow-y: auto;
}

/* 面板标题 */
.filter-panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid rgba(139, 115, 85, 0.15);
}

.panel-title {
  font-size: 18px;
  font-weight: 700;
  color: var(--ink-dark);
  margin: 0;
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
}

.panel-close-btn {
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  background: rgba(139, 115, 85, 0.1);
  border-radius: 8px;
  cursor: pointer;
  font-size: 18px;
  color: var(--ink-medium);
  transition: all 0.2s;
}

.panel-close-btn:hover {
  background: rgba(139, 115, 85, 0.2);
  color: var(--ink-dark);
}

/* 筛选区域 */
.filter-section {
  margin-bottom: 24px;
}

.section-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--ink-medium);
  margin: 0 0 12px;
  letter-spacing: 1px;
}

/* 朝代标签网格 */
.dynasty-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.dynasty-tag {
  padding: 8px 14px;
  border: 1px solid rgba(139, 115, 85, 0.25);
  background: rgba(255, 255, 255, 0.7);
  border-radius: 20px;
  font-size: 13px;
  color: var(--ink-medium);
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
}

.dynasty-tag:hover {
  background: rgba(201, 162, 39, 0.1);
  border-color: rgba(201, 162, 39, 0.3);
  color: var(--ink-dark);
}

.dynasty-tag.active {
  background: linear-gradient(135deg, #c9a227, #d4b43a);
  color: white;
  border-color: #c9a227;
  font-weight: 600;
}

/* 搜索包装器 */
.search-wrapper {
  position: relative;
}

.search-wrapper input {
  width: 100%;
  height: 40px;
  padding: 0 14px;
  border: 1px solid rgba(139, 115, 85, 0.25);
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.8);
  font-size: 13px;
  color: var(--ink-dark);
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  font-family: inherit;
  box-sizing: border-box;
}

.search-wrapper input::placeholder {
  color: var(--ink-light);
}

.search-wrapper input:focus {
  outline: none;
  border-color: var(--bronze-primary);
  background: rgba(255, 255, 255, 0.95);
  box-shadow: 0 0 0 3px rgba(139, 115, 85, 0.1);
}

/* 诗人列表 */
.poet-list {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  margin-top: 8px;
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(16px);
  border: 1px solid rgba(139, 115, 85, 0.2);
  border-radius: 12px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
  overflow: hidden;
  max-height: 200px;
  overflow-y: auto;
}

.poet-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 14px;
  cursor: pointer;
  transition: all 0.2s;
  border-bottom: 1px solid rgba(0, 0, 0, 0.04);
}

.poet-item:last-child {
  border-bottom: none;
}

.poet-item:hover {
  background: rgba(139, 115, 85, 0.06);
}

.poet-item .poet-name {
  font-weight: 600;
  color: var(--ink-dark);
  font-size: 13px;
}

.poet-item .poet-dynasty {
  font-size: 11px;
  color: var(--bronze-primary);
  background: rgba(139, 115, 85, 0.1);
  padding: 2px 8px;
  border-radius: 4px;
}

/* 操作按钮 */
.filter-actions {
  margin-top: auto;
  padding-top: 16px;
  border-top: 1px solid rgba(139, 115, 85, 0.15);
}

.filter-action-btn {
  width: 100%;
  padding: 12px;
  border: 1px solid rgba(139, 115, 85, 0.25);
  background: rgba(255, 255, 255, 0.8);
  border-radius: 10px;
  font-size: 14px;
  color: var(--ink-medium);
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  font-family: inherit;
}

.filter-action-btn:hover {
  background: rgba(139, 115, 85, 0.08);
  border-color: rgba(139, 115, 85, 0.35);
  color: var(--ink-dark);
}

/* 遮罩层样式 */
.filter-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.35);
  backdrop-filter: blur(4px);
  -webkit-backdrop-filter: blur(4px);
  z-index: 190;
  cursor: pointer;
}

/* 滑出动画 */
.slide-left-enter-active,
.slide-left-leave-active {
  transition: transform 0.35s cubic-bezier(0.4, 0, 0.2, 1);
}

.slide-left-enter-from,
.slide-left-leave-to {
  transform: translateX(-100%);
}

/* 淡入淡出动画 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* ========== 左侧导航栏 ========== */
.left-nav {
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
  width: 120px;
  background: rgba(240, 232, 216, 0.98);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-right: 1px solid rgba(139, 115, 85, 0.2);
  box-shadow: 4px 0 30px rgba(0, 0, 0, 0.08);
  display: flex;
  flex-direction: column;
  z-index: 100;
  overflow: hidden;
}

/* 筛选按钮 */
.nav-toggle-btn {
  position: relative;
  width: 60px;
  height: 60px;
  margin: 65px auto 10px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 2px;
  border: 1.5px solid rgba(139, 115, 85, 0.3);
  background: rgba(255, 255, 255, 0.9);
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.nav-toggle-btn:hover {
  background: rgba(255, 255, 255, 1);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.nav-toggle-btn:active {
  transform: translateY(0);
}

.toggle-icon {
  font-size: 18px;
  color: var(--ink-dark);
  letter-spacing: -2px;
}

.toggle-label {
  font-size: 11px;
  color: var(--ink-medium);
  font-weight: 500;
  letter-spacing: 1px;
}

.toggle-dot {
  position: absolute;
  top: -3px;
  left: -3px;
  width: 10px;
  height: 10px;
  background: #c73e3a;
  border-radius: 50%;
  border: 3px solid rgba(240, 232, 216, 0.98);
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% {
    box-shadow: 0 0 0 0 rgba(199, 62, 58, 0.4);
  }
  50% {
    box-shadow: 0 0 0 6px rgba(199, 62, 58, 0);
  }
}

/* Logo区域 - 竖排文字居中显示 */
.nav-logo {
  flex: 1;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  padding: 20px 0;
  gap: 15px;
}

.logo-title-vertical {
  writing-mode: vertical-rl;
  text-orientation: mixed;
  font-size: 26px;
  font-weight: 700;
  color: var(--ink-dark);
  letter-spacing: 8px;
  margin: 0;
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
  line-height: 1.8;
}

.logo-signature-left {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
}

.logo-signature {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 12px;
  gap: 8px;
}

.signature-text {
  font-size: 12px;
  color: var(--ink-medium);
  writing-mode: vertical-rl;
  letter-spacing: 3px;
  font-family: 'STKaiti', 'KaiTi', '楷体', serif;
}

.signature-seal {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #c73e3a;
  color: white;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
}

/* 快捷操作按钮 */
.nav-quick-actions {
  padding: 12px 8px;
}

.quick-action-btn {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  padding: 10px 6px;
  border: 1px solid rgba(139, 115, 85, 0.2);
  background: rgba(255, 255, 255, 0.6);
  border-radius: 8px;
  cursor: pointer;
  font-size: 12px;
  color: var(--ink-medium);
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  font-family: inherit;
}

.quick-action-btn:hover {
  background: rgba(255, 255, 255, 0.9);
  border-color: rgba(139, 115, 85, 0.3);
  color: var(--ink-dark);
}

.action-icon {
  font-size: 16px;
}

/* 诗人搜索 */

.signature-seal {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #c73e3a;
  color: white;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
}

/* 诗人搜索 */
.nav-search {
  padding: 0 8px 12px;
  position: relative;
}

.nav-search input {
  width: 100%;
  height: 34px;
  padding: 0 12px;
  border: 1px solid rgba(139, 115, 85, 0.2);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.7);
  font-size: 12px;
  color: var(--ink-dark);
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  font-family: inherit;
  box-sizing: border-box;
}

.nav-search input::placeholder {
  color: var(--ink-light);
}

.nav-search input:focus {
  outline: none;
  border-color: var(--bronze-primary);
  background: rgba(255, 255, 255, 0.9);
  box-shadow: 0 0 0 2px rgba(139, 115, 85, 0.1);
}

.search-dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  margin-top: 6px;
  background: var(--glass-light);
  backdrop-filter: blur(16px);
  border: 1px solid var(--glass-border);
  border-radius: 12px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
  overflow: hidden;
  z-index: 1000;
  animation: dropdownIn 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes dropdownIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.search-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 14px;
  cursor: pointer;
  transition: all 0.2s;
  border-bottom: 1px solid rgba(0, 0, 0, 0.04);
}

.search-item:last-child {
  border-bottom: none;
}

.search-item:hover {
  background: rgba(139, 115, 85, 0.08);
}

.search-item .poet-name {
  font-weight: 600;
  color: var(--ink-dark);
  font-size: 13px;
}

.search-item .poet-dynasty {
  font-size: 11px;
  color: var(--bronze-primary);
  background: rgba(139, 115, 85, 0.1);
  padding: 2px 8px;
  border-radius: 4px;
}

/* 操作按钮 */
.nav-actions {
  padding: 8px;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.nav-action-btn {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  padding: 10px 6px;
  border: 1px solid rgba(139, 115, 85, 0.2);
  background: rgba(255, 255, 255, 0.6);
  border-radius: 8px;
  cursor: pointer;
  font-size: 12px;
  color: var(--ink-medium);
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  font-family: inherit;
}

.nav-action-btn:hover {
  background: rgba(255, 255, 255, 0.9);
  border-color: rgba(139, 115, 85, 0.3);
  color: var(--ink-dark);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.nav-action-btn.primary {
  background: linear-gradient(135deg, #3c3225, #5c4033);
  color: #fff;
  border: none;
}

.nav-action-btn.primary:hover {
  box-shadow: 0 4px 16px rgba(60, 50, 37, 0.3);
}

.btn-icon {
  font-size: 16px;
}

.left-nav.collapsed .nav-action-btn .btn-text {
  display: none;
}

.left-nav.collapsed .nav-action-btn {
  justify-content: center;
  padding: 10px;
}

/* 折叠按钮 */
.left-nav .nav-collapse-btn {
  position: absolute;
  right: -16px;
  top: 50%;
  transform: translateY(-50%);
  width: 28px;
  height: 56px;
  border: 1px solid rgba(139, 115, 85, 0.2);
  background: rgba(240, 232, 216, 0.95);
  border-radius: 0 8px 8px 0;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 4px 0 12px rgba(0, 0, 0, 0.06);
  border-left: none;
  color: var(--bronze-primary);
  font-size: 12px;
  z-index: 10;
}

.left-nav .nav-collapse-btn:hover {
  background: rgba(240, 232, 216, 1);
  width: 32px;
  box-shadow: 4px 0 16px rgba(0, 0, 0, 0.1);
}

.left-nav .nav-collapse-btn span {
  display: inline-block;
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.left-nav .nav-collapse-btn span.rotated {
  transform: rotate(180deg);
}

/* 主体区域 */
.main-content {
  flex: 1;
  display: flex;
  overflow: hidden;
  min-height: 0;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  padding-left: 100px;
  box-sizing: border-box;
}

/* 面板折叠按钮通用样式 */
.panel-toggle-btn {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 24px;
  height: 64px;
  background: var(--glass-bg);
  backdrop-filter: blur(12px);
  border: 1px solid var(--glass-border);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 1001;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  color: var(--bronze-primary);
  font-size: 14px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.panel-toggle-btn:hover {
  background: var(--glass-light);
  color: var(--ink-dark);
  height: 80px;
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
}

.panel-toggle-btn.left-toggle {
  right: -24px;
  border-radius: 0 12px 12px 0;
  border-left: none;
}

.panel-toggle-btn.right-toggle {
  left: -24px;
  border-radius: 12px 0 0 12px;
  border-right: none;
}

.toggle-icon {
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 左侧面板（隐藏） */
.left-panel {
  display: none;
}

.left-panel.collapsed {
  display: none;
}

.left-panel.collapsed > *:not(.panel-toggle-btn) {
  opacity: 0;
  pointer-events: none;
}

.left-panel::before {
  content: '';
  position: absolute;
  right: 0;
  top: 0;
  bottom: 0;
  width: 1px;
  background: linear-gradient(180deg, transparent, rgba(139, 115, 85, 0.2), transparent);
}

/* 左侧面板装饰 */
.left-panel::after {
  content: '卷';
  position: absolute;
  top: 50%;
  left: -14px;
  transform: translateY(-50%);
  width: 28px;
  height: 56px;
  background: linear-gradient(135deg, rgba(139, 115, 85, 0.12), rgba(168, 144, 120, 0.06));
  border: 1px solid rgba(139, 115, 85, 0.18);
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  color: var(--bronze-primary);
  z-index: 10;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
}

.panel-tabs {
  display: flex;
  border-bottom: 1px solid rgba(122, 99, 72, 0.12);
  background: rgba(122, 99, 72, 0.06);
  position: relative;
}

.panel-tabs::before {
  content: '';
  position: absolute;
  bottom: 0;
  left: 20%;
  right: 20%;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(122, 99, 72, 0.25), transparent);
}

.panel-tab {
  flex: 1;
  padding: 16px;
  border: none;
  background: transparent;
  font-size: 15px;
  color: var(--ink-medium);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  font-family: inherit;
  letter-spacing: 2px;
}

.panel-tab:hover {
  color: var(--ink-dark);
}

.panel-tab.active {
  color: var(--ink-dark);
  background: rgba(255, 255, 255, 0.5);
}

.panel-tab.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 50px;
  height: 2px;
  background: linear-gradient(90deg, transparent, var(--bronze-primary), transparent);
}

.panel-content {
  flex: 1;
  overflow-y: auto;
  padding: 16px;
  position: relative;
}

/* 列表区域背景纹理 */
.panel-content::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image:
      repeating-linear-gradient(
          0deg,
          transparent,
          transparent 28px,
          rgba(122, 99, 72, 0.03) 28px,
          rgba(122, 99, 72, 0.03) 29px
      );
  pointer-events: none;
  z-index: 0;
}

.panel-content::-webkit-scrollbar {
  width: 6px;
}

.panel-content::-webkit-scrollbar-track {
  background: rgba(122, 99, 72, 0.05);
}

.panel-content::-webkit-scrollbar-thumb {
  background: rgba(122, 99, 72, 0.2);
  border-radius: 3px;
}

.list-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid rgba(139, 115, 85, 0.1);
  position: relative;
  z-index: 1;
}

.list-header::after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  width: 40px;
  height: 2px;
  background: var(--bronze-primary);
}

.list-count {
  font-size: 13px;
  color: var(--ink-medium);
  font-weight: 500;
  letter-spacing: 1px;
}

.sort-select {
  padding: 6px 12px;
  border: 1px solid rgba(139, 115, 85, 0.15);
  border-radius: 8px;
  font-size: 12px;
  background: rgba(255, 255, 255, 0.6);
  cursor: pointer;
  color: var(--ink-dark);
  font-family: inherit;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.sort-select:hover {
  border-color: rgba(139, 115, 85, 0.25);
  background: rgba(255, 255, 255, 0.85);
}

/* 右侧面板诗人列表 */
.right-poet-list {
  display: flex;
  flex-direction: column;
  gap: 0;
  position: relative;
  z-index: 1;
}

.right-poet-list .poet-item {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 14px;
  margin-bottom: 10px;
  background: rgba(240, 232, 216, 0.95);
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid rgba(122, 99, 72, 0.1);
  position: relative;
  overflow: hidden;
}

.right-poet-list .poet-item:hover {
  background: rgba(240, 232, 216, 1);
  transform: translateX(4px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
}

.right-poet-list .poet-item.active {
  background: rgba(201, 162, 39, 0.12);
  border-color: rgba(201, 162, 39, 0.3);
}

.right-poet-list .poet-avatar {
  width: 44px;
  height: 44px;
  min-width: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(145deg, rgba(139, 115, 85, 0.18), rgba(168, 144, 120, 0.08));
  color: var(--bronze-primary);
  border-radius: 10px;
  font-weight: bold;
  font-size: 18px;
  border: 1px solid rgba(139, 115, 85, 0.15);
  overflow: hidden;
}

.poet-avatar-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.right-poet-list .poet-info {
  flex: 1;
  min-width: 0;
}

.right-poet-list .poet-name-row {
  display: flex;
  align-items: center;
  gap: 8px;
}

.right-poet-list .poet-name {
  font-weight: 600;
  color: var(--ink-dark);
  font-size: 14px;
}

.right-poet-list .poet-dynasty-tag {
  padding: 2px 8px;
  background: rgba(139, 115, 85, 0.1);
  border-radius: 4px;
  font-size: 10px;
  color: var(--bronze-primary);
}

.right-poet-list .poet-years {
  font-size: 11px;
  color: var(--ink-light);
  margin-top: 2px;
}

.location-item, .poet-item {
  padding: 16px;
  margin-bottom: 12px;
  background: rgba(240, 232, 216, 0.95);
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid rgba(122, 99, 72, 0.1);
  position: relative;
  overflow: hidden;
  z-index: 1;
}

.location-item::before, .poet-item::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 3px;
  height: 100%;
  background: linear-gradient(180deg, var(--bronze-primary), var(--bronze-light));
  opacity: 0;
  transition: opacity 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.location-item::after, .poet-item::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(122, 99, 72, 0.06), transparent);
  transform: translateX(-100%);
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.location-item:hover::before, .poet-item:hover::before {
  opacity: 1;
}

.location-item:hover::after, .poet-item:hover::after {
  transform: translateX(100%);
}

.location-item:hover, .poet-item:hover {
  transform: translateX(6px);
  background: rgba(240, 232, 216, 0.95);
  border-color: rgba(122, 99, 72, 0.2);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
}

.location-item.active, .poet-item.active {
  border-color: rgba(122, 99, 72, 0.28);
  background: rgba(240, 232, 216, 0.95);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.location-item.active::before, .poet-item.active::before {
  opacity: 1;
}

/* 省份列表样式 */
.province-item {
  padding: 16px;
  margin-bottom: 12px;
  background: rgba(240, 232, 216, 0.95);
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid rgba(122, 99, 72, 0.1);
  position: relative;
  overflow: hidden;
  z-index: 1;
}

.province-item::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 3px;
  height: 100%;
  background: linear-gradient(180deg, var(--bronze-primary), var(--bronze-light));
  opacity: 0;
  transition: opacity 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.province-item::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(122, 99, 72, 0.06), transparent);
  transform: translateX(-100%);
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.province-item:hover::before {
  opacity: 1;
}

.province-item:hover::after {
  transform: translateX(100%);
}

.province-item:hover {
  transform: translateX(6px);
  background: rgba(240, 232, 216, 0.95);
  border-color: rgba(122, 99, 72, 0.2);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
}

.province-item.active {
  border-color: rgba(122, 99, 72, 0.28);
  background: rgba(240, 232, 216, 0.95);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.province-item.active::before {
  opacity: 1;
}

.prov-main {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 10px;
  gap: 8px;
}

.prov-name {
  font-weight: 600;
  font-size: 16px;
  color: var(--ink-dark);
  letter-spacing: 1px;
}

.prov-historical-name {
  font-size: 12px;
  color: var(--bronze-primary);
  background: rgba(122, 99, 72, 0.1);
  padding: 2px 8px;
  border-radius: 6px;
  border: 1px solid rgba(122, 99, 72, 0.15);
}

.prov-meta {
  display: flex;
  gap: 16px;
  font-size: 12px;
  color: var(--ink-light);
  margin-bottom: 8px;
}

.prov-poems, .prov-poets {
  display: flex;
  align-items: center;
  gap: 4px;
}

.prov-desc {
  font-size: 13px;
  color: var(--ink-medium);
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.loc-main {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.loc-name {
  font-weight: 600;
  font-size: 16px;
  color: var(--ink-dark);
  letter-spacing: 1px;
}

.prov-meta {
  display: flex;
  gap: 16px;
  font-size: 12px;
  color: var(--ink-light);
  margin-bottom: 8px;
}

.prov-poems, .prov-poets {
  display: flex;
  align-items: center;
  gap: 4px;
}

.prov-desc {
  font-size: 13px;
  color: var(--ink-medium);
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.loc-meta {
  display: flex;
  gap: 16px;
  font-size: 12px;
  color: var(--ink-light);
  margin-bottom: 10px;
}

.loc-heat {
  width: 80px;
  height: 6px;
  background: rgba(122, 99, 72, 0.12);
  border-radius: 3px;
  overflow: hidden;
}

.heat-bar {
  height: 100%;
  background: linear-gradient(90deg, rgba(201, 162, 39, 0.4), #c9a227, #d4b43a);
  border-radius: 3px;
  position: relative;
  transition: width 1.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.heat-bar::after {
  content: '';
  position: absolute;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 10px;
  height: 10px;
  background: #c9a227;
  border-radius: 50%;
  box-shadow: 0 0 10px rgba(201, 162, 39, 0.5), 0 0 20px rgba(201, 162, 39, 0.3);
  animation: heatPulse 2s ease-in-out infinite;
}

@keyframes heatPulse {
  0%, 100% { transform: translateY(-50%) scale(1); opacity: 1; }
  50% { transform: translateY(-50%) scale(1.6); opacity: 0.5; }
}

.loc-famous {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

.famous-poet {
  padding: 4px 12px;
  background: rgba(122, 99, 72, 0.12);
  border-radius: 8px;
  font-size: 11px;
  color: var(--bronze-primary);
  font-weight: 500;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid rgba(139, 115, 85, 0.12);
}

.famous-poet:hover {
  background: rgba(139, 115, 85, 0.15);
  transform: translateY(-2px);
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.06);
}

.poet-item {
  display: flex;
  align-items: center;
  gap: 14px;
}

.poet-avatar {
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(145deg, rgba(139, 115, 85, 0.18), rgba(168, 144, 120, 0.08));
  color: var(--bronze-primary);
  border-radius: 12px;
  font-weight: bold;
  font-size: 20px;
  position: relative;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
  border: 1px solid rgba(139, 115, 85, 0.15);
  overflow: hidden;
}

.poet-avatar::before {
  content: '';
  position: absolute;
  inset: -3px;
  border: 1px solid rgba(139, 115, 85, 0.2);
  border-radius: 15px;
  opacity: 0;
  transition: opacity 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.poet-item:hover .poet-avatar::before {
  opacity: 1;
  animation: ringPulse 2s ease-in-out infinite;
}

@keyframes ringPulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.1); }
}

.poet-info {
  flex: 1;
}

.poet-name-row {
  display: flex;
  align-items: center;
  gap: 10px;
}

.poet-name {
  font-weight: 600;
  color: var(--ink-dark);
  font-size: 15px;
}

.poet-dynasty-tag {
  padding: 3px 10px;
  background: rgba(139, 115, 85, 0.1);
  border-radius: 6px;
  font-size: 11px;
  color: var(--bronze-primary);
  border: 1px solid rgba(139, 115, 85, 0.12);
}

.poet-years {
  font-size: 12px;
  color: var(--ink-light);
  margin-top: 4px;
}

/* 中央地图（淡雅风格） */
.map-container {
  flex: 1;
  position: relative;
  background: transparent;
  overflow: hidden;
  border-left: 1px solid var(--glass-border);
  border-right: 1px solid var(--glass-border);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.left-collapsed .map-container {
  border-left: none;
}

.right-collapsed .map-container {
  border-right: none;
}

.map-container::before {
  content: '';
  position: absolute;
  inset: 0;
  background:
      radial-gradient(ellipse at 30% 30%, rgba(139, 115, 85, 0.03) 0%, transparent 50%),
      radial-gradient(ellipse at 70% 70%, rgba(168, 144, 120, 0.02) 0%, transparent 50%);
  pointer-events: none;
  animation: mapGlow 6s ease-in-out infinite;
}

/* 地图容器四角装饰 */
.map-container::after {
  content: '';
  position: absolute;
  inset: 15px;
  border: 1px solid rgba(139, 115, 85, 0.06);
  border-radius: 8px;
  pointer-events: none;
}

@keyframes mapGlow {
  0%, 100% { opacity: 0.6; }
  50% { opacity: 1; }
}

.chart {
  width: 100%;
  height: 100%;
}

.map-tools {
  position: absolute;
  top: 24px;
  right: 24px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  animation: toolsIn 0.3s cubic-bezier(0.4, 0, 0.2, 1) forwards;
  animation-delay: 0.3s;
  opacity: 0;
  transform: translateX(25px);
}

@keyframes toolsIn {
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.tool-btn {
  width: 46px;
  height: 46px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--glass-bg);
  backdrop-filter: blur(12px);
  border: 1px solid var(--glass-border);
  border-radius: 12px;
  font-size: 22px;
  color: var(--ink-medium);
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
  font-family: inherit;
}

.tool-btn:hover {
  transform: scale(1.15);
  color: var(--ink-dark);
  border-color: rgba(139, 115, 85, 0.25);
  background: var(--glass-light);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.tool-btn:active {
  transform: scale(0.95);
}

/* 右侧详情面板（淡雅玻璃风格） */
.right-panel {
  width: 90px;
  background: rgba(240, 232, 216, 0.95);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-left: 1px solid rgba(122, 99, 72, 0.2);
  display: flex;
  flex-direction: column;
  box-shadow: -4px 0 30px rgba(0, 0, 0, 0.05);
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1), width 0.3s cubic-bezier(0.4, 0, 0.2, 1), margin 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  z-index: 20;
}

.right-panel.collapsed {
  width: 0;
  min-width: 0;
  transform: translateX(100%);
  border-left: none;
}

.right-panel.collapsed > *:not(.panel-toggle-btn) {
  opacity: 0;
  pointer-events: none;
}

.right-panel.expanded {
  width: 350px;
}

.right-panel.collapsed.expanded {
  width: 0;
}

.right-panel::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 1px;
  background: linear-gradient(180deg, transparent, rgba(139, 115, 85, 0.25), transparent);
}

/* 右侧面板装饰角标 */
.right-panel::after {
  content: '录';
  position: absolute;
  top: 50%;
  right: -14px;
  transform: translateY(-50%);
  width: 28px;
  height: 56px;
  background: linear-gradient(135deg, rgba(139, 115, 85, 0.12), rgba(168, 144, 120, 0.06));
  border: 1px solid rgba(139, 115, 85, 0.18);
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  color: var(--bronze-primary);
  z-index: 10;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
}

/* 右侧列表视图 */
.list-view {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.empty-detail {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: var(--ink-light);
  padding: 40px;
}

.empty-icon {
  width: 80px;
  height: 80px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, rgba(139, 115, 85, 0.12), rgba(168, 144, 120, 0.06));
  border-radius: 50%;
  font-size: 32px;
  margin-bottom: 20px;
  position: relative;
  color: var(--bronze-primary);
  border: 2px dashed rgba(139, 115, 85, 0.2);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
}

.empty-icon::before {
  content: '';
  position: absolute;
  inset: -10px;
  border: 1px solid rgba(139, 115, 85, 0.15);
  border-radius: 50%;
  animation: emptyPulse 3s ease-in-out infinite;
  opacity: 0.5;
}

@keyframes emptyPulse {
  0%, 100% { transform: scale(1); opacity: 0.5; }
  50% { transform: scale(1.15); opacity: 0.2; }
}

.empty-text {
  font-size: 14px;
  letter-spacing: 2px;
  color: var(--ink-medium);
}

.detail-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  animation: detailIn 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes detailIn {
  from {
    opacity: 0;
    transform: translateX(30px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateX(0) scale(1);
  }
}

.detail-header {
  padding: 24px;
  border-bottom: 1px solid rgba(139, 115, 85, 0.1);
  position: relative;
  background: linear-gradient(135deg, rgba(139, 115, 85, 0.05), transparent);
}

/* 详情头部装饰线 */
.detail-header::before {
  content: '';
  position: absolute;
  top: 0;
  left: 20%;
  right: 20%;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(139, 115, 85, 0.2), transparent);
}

.detail-header::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(139, 115, 85, 0.25), transparent);
}

.detail-title {
  font-size: 26px;
  font-weight: 700;
  margin: 0 0 8px 0;
  background: linear-gradient(135deg, var(--ink-dark), var(--bronze-primary));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: 3px;
}

.detail-subtitle {
  font-size: 14px;
  color: var(--ink-medium);
  letter-spacing: 2px;
}

.close-btn {
  position: absolute;
  top: 20px;
  right: 20px;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.5);
  border: 1px solid var(--glass-border);
  border-radius: 50%;
  font-size: 22px;
  color: var(--ink-medium);
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.close-btn:hover {
  background: rgba(199, 62, 58, 0.1);
  color: var(--vermilion);
  border-color: rgba(199, 62, 58, 0.3);
  transform: rotate(90deg) scale(1.1);
}

.detail-body {
  flex: 1;
  overflow-y: auto;
  padding: 16px;
  position: relative;
}

/* 详情区域背景纹理 */
.detail-body::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image:
      repeating-linear-gradient(
          0deg,
          transparent,
          transparent 28px,
          rgba(139, 115, 85, 0.015) 28px,
          rgba(139, 115, 85, 0.015) 29px
      );
  pointer-events: none;
  z-index: 0;
}

.detail-body::-webkit-scrollbar {
  width: 6px;
}

.detail-body::-webkit-scrollbar-track {
  background: rgba(139, 115, 85, 0.03);
}

.detail-body::-webkit-scrollbar-thumb {
  background: rgba(139, 115, 85, 0.15);
  border-radius: 3px;
}

.detail-section {
  margin-bottom: 20px;
  position: relative;
  z-index: 1;
}

.section-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--ink-dark);
  margin: 0 0 14px 0;
  display: flex;
  align-items: center;
  gap: 8px;
  letter-spacing: 2px;
}

.section-title::before {
  content: '';
  width: 4px;
  height: 16px;
  background: linear-gradient(180deg, var(--bronze-primary), var(--bronze-light));
  border-radius: 2px;
}

.section-text {
  font-size: 14px;
  color: var(--ink-medium);
  line-height: 1.6;
  margin: 0;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
}

.stat-item {
  background: rgba(139, 115, 85, 0.06);
  padding: 12px;
  border-radius: 10px;
  text-align: center;
  border: 1px solid rgba(139, 115, 85, 0.1);
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.stat-item:hover {
  background: rgba(139, 115, 85, 0.1);
  transform: translateY(-2px);
}

.stat-item.small {
  padding: 8px;
}

.stat-value {
  display: block;
  font-size: 20px;
  font-weight: 700;
  color: var(--ink-dark);
}

.stat-item.small .stat-value {
  font-size: 16px;
}

.stat-label {
  font-size: 12px;
  color: var(--ink-light);
}

.poet-cards {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.poet-card {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px;
  background: rgba(255, 255, 255, 0.5);
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid rgba(139, 115, 85, 0.08);
}

.poet-card:hover {
  background: rgba(255, 255, 255, 0.75);
  border-color: rgba(139, 115, 85, 0.18);
  transform: translateX(4px);
}

.poet-card .poet-avatar {
  width: 36px;
  height: 36px;
  font-size: 14px;
  background: linear-gradient(145deg, rgba(139, 115, 85, 0.18), rgba(168, 144, 120, 0.08));
  border: 1px solid rgba(139, 115, 85, 0.15);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.poet-card .poet-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.poet-card .poet-name {
  font-size: 14px;
  color: var(--ink-dark);
}

.poet-card .poet-dynasty {
  font-size: 12px;
  color: var(--bronze-primary);
}

.poet-card .poet-poems {
  font-size: 11px;
  color: var(--ink-medium);
}

.allusion-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.allusion-item {
  padding: 12px;
  background: rgba(255, 255, 255, 0.4);
  border-radius: 10px;
  border: 1px solid rgba(139, 115, 85, 0.08);
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.allusion-item:hover {
  background: rgba(255, 255, 255, 0.6);
}

.allusion-title {
  font-weight: 600;
  font-size: 14px;
  margin-bottom: 6px;
  color: var(--ink-dark);
}

.allusion-content {
  font-size: 13px;
  color: var(--ink-medium);
  line-height: 1.6;
  margin-bottom: 8px;
}

.allusion-dynasty {
  font-size: 11px;
  color: var(--bronze-primary);
  padding: 3px 10px;
  background: rgba(139, 115, 85, 0.08);
  border-radius: 6px;
  border: 1px solid rgba(139, 115, 85, 0.1);
}

.route-timeline {
  position: relative;
  padding-left: 40px;
}

.route-point {
  position: relative;
  padding-bottom: 16px;
}

.route-year {
  position: absolute;
  left: -40px;
  width: 36px;
  text-align: right;
  font-size: 12px;
  color: var(--bronze-primary);
  font-weight: 600;
}

.route-dot {
  position: absolute;
  left: -6px;
  top: 4px;
  width: 10px;
  height: 10px;
  background: var(--bronze-primary);
  border-radius: 50%;
  border: 2px solid var(--paper-bg);
  box-shadow: 0 0 0 2px rgba(139, 115, 85, 0.3), 0 0 10px rgba(139, 115, 85, 0.2);
}

.route-point:not(:last-child)::before {
  content: '';
  position: absolute;
  left: -2px;
  top: 14px;
  width: 2px;
  height: calc(100% - 14px);
  background: linear-gradient(180deg, rgba(139, 115, 85, 0.3), rgba(139, 115, 85, 0.1));
}

.route-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.route-location {
  font-weight: 600;
  font-size: 14px;
  color: var(--ink-dark);
}

.route-event {
  font-size: 12px;
  color: var(--ink-medium);
}

.route-poems {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  margin-top: 6px;
}

.route-poem {
  font-size: 11px;
  color: var(--bronze-primary);
  padding: 3px 8px;
  background: rgba(139, 115, 85, 0.08);
  border-radius: 6px;
  border: 1px solid rgba(139, 115, 85, 0.1);
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.route-poem:hover {
  background: rgba(139, 115, 85, 0.12);
}

.relationship-chart {
  height: 200px;
  background: rgba(255, 255, 255, 0.4);
  border-radius: 12px;
  border: 1px solid rgba(139, 115, 85, 0.08);
}

.rel-chart {
  width: 100%;
  height: 100%;
}



/* 悬浮地点卡片 */
.location-floating-card {
  position: absolute;
  top: 0;
  left: 0;
  width: 320px;
  background: rgba(240, 232, 216, 0.96);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border: 1px solid rgba(122, 99, 72, 0.25);
  border-radius: 16px;
  box-shadow:
      0 15px 45px rgba(0, 0, 0, 0.14),
      inset 0 0 40px rgba(122, 99, 72, 0.06);
  z-index: 1000;
  padding: 0;
  pointer-events: auto;
  will-change: transform;
  transition: opacity 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  animation: cardFadeIn 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
}

.card-header {
  padding: 20px 20px 15px;
  background: linear-gradient(to bottom, rgba(122, 99, 72, 0.1), transparent);
  border-bottom: 1px solid rgba(122, 99, 72, 0.12);
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.header-main {
  flex: 1;
}

.card-title {
  font-size: 22px;
  font-weight: 700;
  color: var(--ink-dark);
  margin: 0;
  letter-spacing: 2px;
  text-shadow: 0 1px 2px rgba(0,0,0,0.05);
}

.card-subtitle {
  font-size: 13px;
  color: var(--bronze-primary);
  margin-top: 4px;
  display: block;
  letter-spacing: 1px;
}

.card-close-btn {
  background: rgba(122, 99, 72, 0.12);
  border: none;
  font-size: 20px;
  color: var(--ink-medium);
  cursor: pointer;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  margin-left: 10px;
}

.card-close-btn:hover {
  background: rgba(199, 62, 58, 0.1);
  color: var(--vermilion);
  transform: rotate(90deg);
}

.card-body {
  padding: 15px 20px 20px;
  max-height: 400px;
  overflow-y: auto;
}

.card-body::-webkit-scrollbar {
  width: 5px;
}

.card-body::-webkit-scrollbar-thumb {
  background: rgba(122, 99, 72, 0.22);
  border-radius: 10px;
}

.card-section {
  margin-bottom: 20px;
}

.card-desc {
  font-size: 14px;
  color: var(--ink-medium);
  line-height: 1.7;
  margin: 0;
  padding: 12px;
  background: rgba(122, 99, 72, 0.06);
  border-radius: 8px;
  border-left: 3px solid rgba(122, 99, 72, 0.22);
}

.card-section-title {
  font-size: 14px;
  font-weight: bold;
  color: var(--ink-dark);
  margin: 0 0 12px 0;
  display: flex;
  align-items: center;
  gap: 8px;
  letter-spacing: 1px;
}

.title-icon {
  font-size: 16px;
}

/* 统计区域样式 */
.stats-summary {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.total-badge {
  display: flex;
  align-items: baseline;
  justify-content: center;
  gap: 6px;
  padding: 6px 12px;
  background: linear-gradient(135deg, var(--ink-dark), #4a3b36);
  border-radius: 8px;
  color: #fff;
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.12);
  width: fit-content;
  margin: 0 auto;
}

.total-badge .label {
  font-size: 10px;
  opacity: 0.8;
}

.total-badge .value {
  font-size: 15px;
  font-weight: bold;
  font-family: 'Georgia', serif;
}

.total-badge .unit {
  font-size: 10px;
}

.dynasty-bars {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.bar-item {
  display: flex;
  align-items: center;
  gap: 10px;
}

.bar-label {
  width: 32px;
  font-size: 12px;
  color: var(--ink-medium);
}

.bar-track {
  flex: 1;
  height: 6px;
  background: rgba(139, 115, 85, 0.1);
  border-radius: 3px;
  overflow: hidden;
}

.bar-fill {
  height: 100%;
  background: linear-gradient(to right, var(--bronze-light), var(--bronze-primary));
  border-radius: 3px;
  transition: width 1s cubic-bezier(0.4, 0, 0.2, 1);
}

.bar-value {
  width: 30px;
  text-align: right;
  font-size: 12px;
  color: var(--ink-dark);
  font-weight: 600;
}

/* 诗人区域样式 */
.mini-poet-list {
  display: flex;
  gap: 12px;
}

.mini-poet-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  padding: 8px;
  background: #fff;
  border: 1px solid rgba(139, 115, 85, 0.1);
  border-radius: 10px;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.mini-poet-item:hover {
  transform: translateY(-2px);
  border-color: var(--bronze-primary);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.poet-avatar-small {
  width: 32px;
  height: 32px;
  background: var(--paper-warm);
  border: 1px solid var(--bronze-light);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  color: var(--bronze-primary);
  font-weight: bold;
  overflow: hidden;
}

.poet-meta {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.poet-meta .name {
  font-size: 12px;
  font-weight: bold;
  color: var(--ink-dark);
}

.poet-meta .dynasty {
  font-size: 10px;
  color: var(--ink-light);
}

/* 典故区域样式 */
.mini-allusion {
  padding: 12px;
  background: linear-gradient(135deg, rgba(139, 115, 85, 0.05), transparent);
  border-radius: 10px;
  border: 1px dashed rgba(139, 115, 85, 0.3);
}

.allusion-tag {
  display: inline-block;
  padding: 2px 8px;
  background: var(--vermilion);
  color: #fff;
  font-size: 11px;
  border-radius: 4px;
  margin-bottom: 8px;
}

.allusion-snippet {
  font-size: 13px;
  color: var(--ink-medium);
  line-height: 1.5;
  margin: 0;
  font-style: italic;
}

.card-footer-decoration {
  height: 4px;
  background: linear-gradient(to right,
  transparent,
  var(--bronze-primary),
  var(--vermilion),
  var(--bronze-primary),
  transparent
  );
  opacity: 0.6;
}

@keyframes cardFadeIn {
  from {
    opacity: 0;
    transform: translate(calc(var(--card-x) + 15px), calc(var(--card-y) - 90%)) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translate(calc(var(--card-x) + 15px), calc(var(--card-y) - 100%)) scale(1);
  }
}

.card-header {
  display: flex;
  align-items: center;
  margin-bottom: 12px;
  border-bottom: 1px solid rgba(139, 115, 85, 0.1);
  padding-bottom: 8px;
}

.card-title {
  font-size: 18px;
  font-weight: bold;
  color: var(--ink-dark);
  margin: 0;
  margin-right: 8px;
}

.card-subtitle {
  font-size: 12px;
  color: var(--ink-medium);
  flex-grow: 1;
}

.card-close-btn {
  background: none;
  border: none;
  font-size: 20px;
  color: var(--ink-medium);
  cursor: pointer;
  padding: 0 4px;
  transition: color 0.2s;
}

.card-close-btn:hover {
  color: var(--vermilion);
}

.card-body {
  max-height: 250px;
  overflow-y: auto;
}

.card-body::-webkit-scrollbar {
  width: 4px;
}

.card-body::-webkit-scrollbar-track {
  background: rgba(139, 115, 85, 0.03);
}

.card-body::-webkit-scrollbar-thumb {
  background: rgba(139, 115, 85, 0.15);
  border-radius: 2px;
}

.card-section {
  margin-bottom: 12px;
}

.card-desc {
  font-size: 13px;
  color: var(--ink-medium);
  line-height: 1.6;
  margin: 0;
}

.card-section-title {
  font-size: 13px;
  font-weight: bold;
  color: var(--ink-dark);
  margin: 0 0 8px 0;
  border-left: 3px solid var(--bronze-primary);
  padding-left: 8px;
}

/* 响应式 */
@media (max-width: 1200px) {
  .left-panel {
    width: 240px;
  }
  .right-panel {
    width: 260px;
  }
}

@media (max-width: 992px) {
  .left-panel {
    width: 200px;
  }
  .right-panel {
    width: 220px;
  }
  .dynasty-tabs {
    flex-wrap: wrap;
  }
}
/* ========== 直角卡片统一控制 ========== */
/* 地图点击地点后显示的小卡片：强制直角 */
.location-floating-card {
  border-radius: 0 !important;
}

/* 右侧列表区域三个列表：省份、地点、诗人卡片统一直角 */
.right-panel .province-item,
.right-panel .location-item,
.right-panel .right-poet-list .poet-item,
.right-panel .poet-item {
  border-radius: 0 !important;
}

/* 避免伪元素或内部背景造成圆角残留 */
.right-panel .province-item::before,
.right-panel .province-item::after,
.right-panel .location-item::before,
.right-panel .location-item::after,
.right-panel .right-poet-list .poet-item::before,
.right-panel .right-poet-list .poet-item::after,
.right-panel .poet-item::before,
.right-panel .poet-item::after {
  border-radius: 0 !important;
}

</style>
