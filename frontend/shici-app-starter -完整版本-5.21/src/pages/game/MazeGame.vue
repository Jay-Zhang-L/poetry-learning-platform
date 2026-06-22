<template>
  <div class="mazePage">
    <div class="pageBgDecor decor1"></div>
    <div class="pageBgDecor decor2"></div>

    <div class="mazeHero">
      <div class="heroLeft">
        <div class="heroBadge">韵脚迷阵</div>
        <div class="heroTitle">{{ levelData.title || '诗词迷宫' }}</div>
        <div class="heroSub">
          {{ levelData.poemTitle || '请选择诗词' }}
          <span v-if="levelData.poemAuthor"> · {{ levelData.poemAuthor }}</span>
        </div>
      </div>

      <div class="heroRight">
        <div class="heroStat">
          <div class="heroStatLabel">当前总分</div>
          <div class="heroStatValue">{{ progress.currentScore || 0 }}</div>
        </div>
        <div class="heroStat">
          <div class="heroStatLabel">已完成句数</div>
          <div class="heroStatValue">{{ solvedCount }}</div>
        </div>
      </div>
    </div>

    <div class="mazeTop">
      <div class="poemPanel cardPanel">
        <div class="panelHead">
          <div class="panelTitle">选择诗词</div>
          <div class="panelDesc">切换关卡后自动刷新迷阵</div>
        </div>

        <div class="poemList">
          <div
            v-for="item in levelList"
            :key="item.id"
            class="poemItem"
            :class="{ active: currentLevelNo === item.levelNo }"
            @click="switchLevel(item.levelNo)"
          >
            <div class="poemItemTop">
              <div class="poemName">{{ item.poemTitle }}</div>
              <div class="poemTag">第{{ item.levelNo }}关</div>
            </div>
            <div class="poemMeta">{{ item.poemAuthor }}</div>
          </div>
        </div>
      </div>

      <div class="mazeCenter cardPanel">
        <div class="mazeBoardTop">
          <div class="boardTips">
            <div class="tipsTitle">玩法提示</div>
            <div class="tipsText">
              只能按上下左右选择相邻文字；再次点击当前最后一个字可撤回。
            </div>
          </div>

          <div class="selectPreview">
            <div class="previewLabel">当前已选</div>
            <div class="previewText" :class="{ empty: !selectedText }">
              {{ selectedText || '暂未选择' }}
            </div>
          </div>
        </div>

        <div
          class="mazeGridWrap"
          :style="{ '--grid-size': levelData.sizeN || 1 }"
        >
          <div
            class="mazeGrid"
            :style="{ gridTemplateColumns: `repeat(${levelData.sizeN || 1}, 1fr)` }"
          >
            <div
              v-for="(cell, index) in flatGrid"
              :key="index"
              class="mazeCell"
              :class="cellClass(cell.row, cell.col)"
              @click="handleCellClick(cell)"
            >
              <span>{{ cell.text }}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="linePanel cardPanel">
        <div class="panelHead">
          <div class="panelTitle">诗句进度</div>
          <div class="panelDesc">未完成前不显示具体诗句</div>
        </div>

        <div class="lineList">
          <div
            v-for="(line, idx) in levelData.lines || []"
            :key="idx"
            class="lineItem"
            :class="{
              solved: solvedSet.has(idx),
              current: currentTargetLineIndex === idx
            }"
            @click="setTargetLine(idx)"
          >
            <div class="lineTop">
              <div class="lineIndex">第{{ idx + 1 }}句</div>
              <div class="lineState">
                {{ solvedSet.has(idx) ? '已解锁' : '未解锁' }}
              </div>
            </div>

            <div class="lineText" :class="{ masked: !solvedSet.has(idx) }">
              {{ solvedSet.has(idx) ? line : getMaskedLine(line) }}
            </div>

            <div class="lineHint">
              {{ solvedSet.has(idx) ? '已自动记录' : '点击设为当前目标句' }}
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="tipsBar">
      <div class="tipsCard">
        <div class="tipsCardLabel">当前目标</div>
        <div class="tipsCardValue">
          {{
            currentTargetLineIndex !== -1
              ? `第 ${currentTargetLineIndex + 1} 句`
              : '本关已全部完成'
          }}
        </div>
      </div>

      <div class="tipsCard messageCard">
        <div class="tipsCardLabel">状态提示</div>
        <div class="tipsCardValue warn">{{ message }}</div>
      </div>

      <div class="tipsCard">
        <div class="tipsCardLabel">完成进度</div>
        <div class="tipsCardValue">
          {{ solvedCount }}/{{ (levelData.lines || []).length }}
        </div>
      </div>
    </div>

    <div class="rankPanel cardPanel">
      <div class="rankHeader">
        <div>
          <div class="rankTitle">迷宫总排行榜</div>
          <div class="rankSub">所有页面都显示这一份总榜</div>
        </div>
      </div>

      <div class="rankTable">
        <div class="rankHead rankRow">
          <div>排名</div>
          <div>用户</div>
          <div>总分</div>
          <div>完成句数</div>
          <div>完成诗数</div>
          <div>最近完成时间</div>
        </div>

        <div
          v-for="(item, index) in rankList"
          :key="item.userId"
          class="rankRow bodyRow"
        >
          <div class="rankNo">{{ index + 1 }}</div>
          <div class="userCol">
            <img class="avatar" :src="fullAvatar(item.avatarUrl)" alt="" />
            <span>{{ item.nickname || item.username || ('用户' + item.userId) }}</span>
          </div>
          <div>{{ item.totalScore }}</div>
          <div>{{ item.totalLines }}</div>
          <div>{{ item.solvedPoems }}</div>
          <div>{{ item.latestSolveTime || '-' }}</div>
        </div>

        <div v-if="!rankList.length" class="emptyRank">暂无排行榜数据</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import {
  getMazeLevels,
  getMazeLevel,
  getMazeProgress,
  getMazeRank,
  submitMazeLine
} from '@/utils/api'

const seasonNo = ref(1)
const levelList = ref([])
const currentLevelNo = ref(1)

const levelData = ref({
  sizeN: 0,
  grid: [],
  lines: []
})

const progress = ref({
  currentScore: 0,
  solvedLineIndexes: []
})

const rankList = ref([])

const selectedCells = ref([])
const currentTargetLineIndex = ref(0)
const message = ref('请选择一句目标诗句，然后在字阵中按顺序点击')

const solvedSet = computed(() => new Set(progress.value.solvedLineIndexes || []))
const solvedCount = computed(() => (progress.value.solvedLineIndexes || []).length)

const flatGrid = computed(() => {
  const grid = levelData.value.grid || []
  const arr = []
  grid.forEach((row, rowIndex) => {
    row.forEach((text, colIndex) => {
      arr.push({
        row: rowIndex,
        col: colIndex,
        text
      })
    })
  })
  return arr
})

const selectedText = computed(() => selectedCells.value.map(i => i.text).join(''))

function fullAvatar(url) {
  if (!url) return 'https://dummyimage.com/80x80/f3e5c8/8c6239&text=%E8%AF%97'
  if (url.startsWith('http')) return url
  return `http://localhost:8080${url}`
}

function getMaskedLine(line) {
  if (!line) return ''
  return '·'.repeat(line.length)
}

function cellClass(row, col) {
  const idx = selectedCells.value.findIndex(i => i.row === row && i.col === col)
  const isSelected = idx !== -1
  const isLast =
    isSelected &&
    idx === selectedCells.value.length - 1 &&
    selectedCells.value.length > 0

  return {
    selected: isSelected,
    last: isLast
  }
}

function setTargetLine(idx) {
  if (solvedSet.value.has(idx)) {
    message.value = '这一句已经完成，可以继续挑战其他句子'
    currentTargetLineIndex.value = idx
    selectedCells.value = []
    return
  }

  currentTargetLineIndex.value = idx
  selectedCells.value = []
  message.value = `已选择第 ${idx + 1} 句，请开始连线`
}

function isAdjacent(a, b) {
  const dr = Math.abs(a.row - b.row)
  const dc = Math.abs(a.col - b.col)
  return dr + dc === 1
}

async function handleCellClick(cell) {
  if (currentTargetLineIndex.value === -1) {
    message.value = '本关已全部完成'
    return
  }

  const list = selectedCells.value
  const last = list[list.length - 1]

  if (!last) {
    selectedCells.value.push(cell)
    await tryAutoSubmit()
    return
  }

  if (last.row === cell.row && last.col === cell.col) {
    selectedCells.value.pop()
    message.value = '已撤回最后一个字'
    return
  }

  const alreadyInside = list.some(i => i.row === cell.row && i.col === cell.col)
  if (alreadyInside) {
    message.value = '不能重复选择已选中的其他字'
    return
  }

  if (!isAdjacent(last, cell)) {
    message.value = '只能选择上下左右相邻的字'
    return
  }

  selectedCells.value.push(cell)
  await tryAutoSubmit()
}

async function tryAutoSubmit() {
  const lines = levelData.value.lines || []
  const target = lines[currentTargetLineIndex.value]

  if (!target) return

  if (selectedText.value.length < target.length) return

  if (selectedText.value.length > target.length) {
    message.value = '已超过目标字数，请点击最后一个字回退'
    return
  }

  if (selectedText.value !== target) {
    message.value = '文字顺序不对，请继续回退调整'
    return
  }

  try {
    const res = await submitMazeLine({
      seasonNo: seasonNo.value,
      levelNo: currentLevelNo.value,
      lineIndex: currentTargetLineIndex.value,
      selectedPath: selectedCells.value.map(i => ({
        row: i.row,
        col: i.col
      }))
    })

    const data = res.data || res
    if (!data.correct) {
      message.value = '文字对了，但路径不正确，请重新尝试'
      return
    }

    progress.value.solvedLineIndexes = data.solvedLineIndexes || []
    progress.value.currentScore = data.currentTotalScore || 0

    if (data.alreadySolved) {
      message.value = '这一句之前已经完成过了'
    } else {
      message.value = `第 ${currentTargetLineIndex.value + 1} 句回答正确，已自动显示并加 1 分`
    }

    selectedCells.value = []

    const nextIdx = findNextUnsolved()
    currentTargetLineIndex.value = nextIdx

    if (nextIdx === -1) {
      message.value = '本关全部完成'
    }

    await loadRank()
  } catch (e) {
    message.value = '提交失败，请稍后重试'
  }
}

function findNextUnsolved() {
  const lines = levelData.value.lines || []
  for (let i = 0; i < lines.length; i++) {
    if (!solvedSet.value.has(i)) return i
  }
  return -1
}

async function loadLevels() {
  const res = await getMazeLevels(seasonNo.value)
  levelList.value = res.data || res || []
}

async function loadLevel() {
  const res = await getMazeLevel(seasonNo.value, currentLevelNo.value)
  levelData.value = res.data || res || { sizeN: 0, grid: [], lines: [] }
}

async function loadProgress() {
  try {
    const res = await getMazeProgress(seasonNo.value, currentLevelNo.value)
    progress.value = res.data || res || {
      currentScore: 0,
      solvedLineIndexes: []
    }

    const nextIdx = findNextUnsolved()
    currentTargetLineIndex.value = nextIdx
  } catch (e) {
    progress.value = {
      currentScore: 0,
      solvedLineIndexes: []
    }
    currentTargetLineIndex.value = 0
  }
}

async function loadRank() {
  const res = await getMazeRank(seasonNo.value)
  rankList.value = res.data || res || []
}

async function switchLevel(levelNo) {
  if (currentLevelNo.value === levelNo) return
  currentLevelNo.value = levelNo
  selectedCells.value = []
  await loadLevel()
  await loadProgress()
  message.value = '已切换诗词，请继续挑战'
}

onMounted(async () => {
  await loadLevels()
  if (levelList.value.length) {
    currentLevelNo.value = levelList.value[0].levelNo
  }
  await loadLevel()
  await loadProgress()
  await loadRank()
})
</script>

<style scoped>
.mazePage {
  position: relative;
  min-height: 100vh;
  width: 100%;
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  overflow-x: hidden;
  overflow-y: auto;
  background:
    radial-gradient(circle at top left, rgba(247, 210, 151, 0.22), transparent 28%),
    radial-gradient(circle at bottom right, rgba(181, 124, 63, 0.16), transparent 30%),
    linear-gradient(180deg, #f8f2e7 0%, #f0e2ca 55%, #ead7bb 100%);
  color: #4b3523;
}

:deep(html),
:deep(body),
:deep(#app) {
  margin: 0;
  padding: 0;
}

:deep(.mazePage),
:deep(main),
:deep(.main),
:deep(.content),
:deep(.page-container),
:deep(.router-view),
:deep(.layout-content),
:deep(.app-main) {
  margin: 0 !important;
  padding-left: 0 !important;
  padding-right: 0 !important;
}

.pageBgDecor {
  position: absolute;
  border-radius: 50%;
  pointer-events: none;
  filter: blur(8px);
  opacity: 0.45;
}

.decor1 {
  top: -120px;
  left: -80px;
  width: 320px;
  height: 320px;
  background: radial-gradient(circle, rgba(255, 230, 179, 0.9), transparent 70%);
}

.decor2 {
  right: -120px;
  bottom: 80px;
  width: 360px;
  height: 360px;
  background: radial-gradient(circle, rgba(190, 129, 63, 0.22), transparent 70%);
}

.mazeHero {
  position: relative;
  z-index: 1;
  display: flex;
  justify-content: space-between;
  gap: 20px;
  align-items: stretch;
  padding: 24px 28px;
  margin: 0;
  border-radius: 0;
  background:
    linear-gradient(135deg, rgba(121, 68, 25, 0.94), rgba(165, 104, 51, 0.9));
  color: #fff8ee;
  box-shadow: none;
}

.heroLeft {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.heroBadge {
  display: inline-flex;
  width: fit-content;
  padding: 6px 14px;
  border-radius: 999px;
  background: rgba(255, 245, 220, 0.16);
  border: 1px solid rgba(255, 244, 224, 0.2);
  font-size: 13px;
  letter-spacing: 1px;
  margin-bottom: 12px;
}

.heroTitle {
  font-size: 34px;
  font-weight: 800;
  line-height: 1.2;
}

.heroSub {
  margin-top: 8px;
  color: rgba(255, 245, 230, 0.88);
  font-size: 15px;
}

.heroRight {
  display: flex;
  gap: 14px;
  align-items: stretch;
}

.heroStat {
  min-width: 120px;
  padding: 16px 18px;
  border-radius: 20px;
  background: rgba(255, 248, 237, 0.12);
  border: 1px solid rgba(255, 246, 231, 0.16);
  text-align: center;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.heroStatLabel {
  font-size: 13px;
  color: rgba(255, 244, 227, 0.78);
}

.heroStatValue {
  margin-top: 6px;
  font-size: 30px;
  font-weight: 800;
}

.mazeTop {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: 280px 1fr 320px;
  gap: 0;
  align-items: stretch;
  margin: 0;
}

.cardPanel {
  background: rgba(255, 251, 245, 0.92);
  border: 1px solid rgba(169, 121, 68, 0.13);
  border-radius: 0;
  box-shadow: none;
  backdrop-filter: blur(4px);
}

.poemPanel,
.linePanel {
  padding: 18px;
}

.poemPanel {
  height: 1100px;
  display: flex;
  flex-direction: column;
}

.panelHead {
  margin-bottom: 14px;
}

.panelTitle,
.rankTitle {
  font-size: 22px;
  font-weight: 800;
  color: #5d3d23;
}

.panelDesc,
.rankSub {
  margin-top: 5px;
  font-size: 13px;
  color: #9a7651;
}

.poemList,
.lineList {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.poemList {
  flex: 1;
  min-height: 0;
  overflow-y: auto;
  padding-right: 6px;
}

.poemItem,
.lineItem {
  padding: 14px;
  border-radius: 18px;
  background: linear-gradient(180deg, #fffdf8 0%, #f9f0e2 100%);
  border: 1px solid rgba(177, 132, 83, 0.12);
  cursor: pointer;
  transition: all 0.22s ease;
}

.poemItem:hover,
.lineItem:hover {
  transform: translateY(-3px);
  box-shadow: 0 12px 24px rgba(135, 88, 43, 0.08);
}

.poemItem.active,
.lineItem.current {
  background: linear-gradient(135deg, #f7ead2, #f0d4a4);
  border-color: rgba(175, 130, 80, 0.32);
}

.lineItem.solved {
  background: linear-gradient(135deg, #eef8e6, #dceecf);
  border-color: rgba(85, 145, 72, 0.28);
}

.poemItemTop,
.lineTop {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.poemName {
  font-size: 16px;
  font-weight: 800;
}

.poemMeta,
.lineIndex,
.lineHint {
  font-size: 13px;
  color: #8b6b46;
}

.poemTag {
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(129, 78, 34, 0.08);
  font-size: 12px;
  white-space: nowrap;
}

.lineState {
  font-size: 12px;
  font-weight: 700;
  color: #7a5b38;
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(125, 84, 42, 0.08);
}

.lineText {
  margin: 10px 0 8px;
  min-height: 28px;
  font-size: 17px;
  line-height: 1.8;
  font-weight: 700;
  letter-spacing: 1px;
  color: #4c3623;
}

.lineText.masked {
  color: #c29a6c;
  letter-spacing: 3px;
}

.mazeCenter {
  padding: 20px;
}

.mazeBoardTop {
  display: grid;
  grid-template-columns: 1.2fr 1fr;
  gap: 14px;
  margin-bottom: 18px;
}

.boardTips,
.selectPreview {
  padding: 16px 18px;
  border-radius: 20px;
  background: linear-gradient(180deg, #fffaf1 0%, #f8ecdc 100%);
  border: 1px solid rgba(170, 122, 66, 0.12);
}

.tipsTitle,
.previewLabel,
.tipsCardLabel {
  font-size: 13px;
  color: #9a7651;
  margin-bottom: 8px;
}

.tipsText,
.previewText,
.tipsCardValue {
  font-size: 16px;
  font-weight: 700;
  line-height: 1.6;
  color: #553822;
}

.previewText.empty {
  color: #c29a6c;
  font-weight: 600;
}

.mazeGridWrap {
  padding: 18px;
  border-radius: 24px;
  background:
    linear-gradient(180deg, rgba(255, 253, 248, 0.88), rgba(246, 232, 209, 0.9));
  border: 1px solid rgba(170, 122, 66, 0.12);
}

.mazeGrid {
  display: grid;
  gap: 10px;
}

.mazeCell {
  position: relative;
  aspect-ratio: 1 / 1;
  border-radius: 18px;
  background: linear-gradient(180deg, #fffefb 0%, #f6ead8 100%);
  border: 1px solid rgba(164, 123, 72, 0.16);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 26px;
  font-weight: 800;
  cursor: pointer;
  user-select: none;
  transition: all 0.18s ease;
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.7);
}

.mazeCell:hover {
  transform: translateY(-2px) scale(1.02);
  box-shadow: 0 10px 20px rgba(131, 87, 44, 0.08);
}

.mazeCell.selected {
  background: linear-gradient(135deg, #d98e4f, #b96c37);
  color: #fff;
  border-color: rgba(164, 83, 26, 0.5);
  box-shadow: 0 12px 22px rgba(184, 106, 52, 0.24);
}

.mazeCell.last {
  outline: 2px solid rgba(255, 241, 214, 0.85);
  outline-offset: -3px;
}

.tipsBar {
  position: relative;
  z-index: 1;
  margin: 0;
  display: grid;
  grid-template-columns: 1fr 1.4fr 1fr;
  gap: 0;
}

.tipsCard {
  background: rgba(255, 251, 245, 0.92);
  border: 1px solid rgba(169, 121, 68, 0.13);
  border-radius: 0;
  padding: 16px 18px;
  box-shadow: none;
}

.messageCard .warn {
  color: #b3552f;
}

.rankPanel {
  position: relative;
  z-index: 1;
  margin: 0;
  padding: 20px;
}

.rankHeader {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 14px;
}

.rankTable {
  width: 100%;
}

.rankRow {
  display: grid;
  grid-template-columns: 90px 1.5fr 100px 120px 120px 220px;
  align-items: center;
  gap: 10px;
  padding: 14px 12px;
}

.rankHead {
  font-weight: 800;
  color: #7a5634;
  background: linear-gradient(180deg, #fcf4e8 0%, #f6e8d1 100%);
  border-radius: 0;
  margin-bottom: 8px;
}

.bodyRow {
  border-bottom: 1px solid rgba(153, 108, 59, 0.1);
}

.bodyRow:hover {
  background: rgba(248, 239, 224, 0.45);
  border-radius: 0;
}

.rankNo {
  font-weight: 800;
  color: #9b6b35;
}

.userCol {
  display: flex;
  align-items: center;
  gap: 10px;
  min-width: 0;
}

.avatar {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid rgba(187, 144, 92, 0.26);
}

.emptyRank {
  padding: 28px 0;
  text-align: center;
  color: #9c7a55;
}

@media (max-width: 1440px) {
  .mazeTop {
    grid-template-columns: 250px 1fr 300px;
  }

  .rankRow {
    grid-template-columns: 80px 1.4fr 90px 110px 110px 190px;
  }
}

@media (max-width: 1200px) {
  .mazeHero {
    flex-direction: column;
  }

  .heroRight {
    width: 100%;
  }

  .heroStat {
    flex: 1;
  }

  .mazeTop {
    grid-template-columns: 1fr;
  }

  .mazeBoardTop {
    grid-template-columns: 1fr;
  }

  .tipsBar {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .mazePage {
    padding: 0;
  }

  .mazeHero {
    padding: 18px 14px;
  }

  .poemPanel,
  .mazeCenter,
  .linePanel,
  .rankPanel,
  .tipsCard {
    padding-left: 14px;
    padding-right: 14px;
  }

  .heroTitle {
    font-size: 26px;
  }

  .mazeCell {
    font-size: 22px;
    border-radius: 14px;
  }

  .rankRow {
    grid-template-columns: 60px 1.3fr 70px 90px 90px 140px;
    font-size: 13px;
  }
}
</style>