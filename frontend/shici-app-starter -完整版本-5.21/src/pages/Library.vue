<template>

  <div class="lib" :style="paperStyle">
    <div class="langSwitchBar">
      <button class="langBtn" :class="{ active: lang === 'zh' }" @click="setLang('zh')">中</button>
      <button class="langBtn" :class="{ active: lang === 'en' }" @click="setLang('en')">EN</button>
    </div>
    <div class="scrollSections" ref="scrollContainer">
      <section v-if="contentMode === 'shelf'" class="screenSection heroScreen">
        <div class="heroStage" :class="{ ghosting: heroExpandGhost.show }" ref="heroStageRef">
          <div class="heroMedia">
           <div
  v-for="(b, i) in banners"
  :key="b.id ?? i"
  class="heroBgLayer"
  :class="{
    current: i === bannerIndex,
    previous: i === previousBannerIndex
  }"
  @click="i === bannerIndex && openBannerLink(b)"
>
  <img :src="b.src" :alt="b.title" />
</div>
            <div class="heroShade"></div>

            <div
              v-if="heroExpandGhost.show"
              ref="heroExpandGhostRef"
              class="heroExpandGhost"
              :class="{ expanding: heroExpandGhost.phase === 'expanding', fading: heroExpandGhost.phase === 'fading' }"
              :style="heroExpandGhostStyle"
              aria-hidden="true"
              @transitionend="handleHeroGhostTransitionEnd"
            >
              <img :src="heroExpandGhost.src" :alt="heroExpandGhost.title || t('cover')" />
            </div>
            <div class="heroVignette"></div>
          </div>
<div class="heroContent">
  <div class="heroActions">
    <button class="heroMainBtn" @click="scrollToNextScreen">{{ t('startBrowse') }}</button>
  </div>
</div>

          <div class="heroCardsWrap">
            <transition-group 
              name="hero-cards" 
              tag="div" 
              class="heroCardsTrack" 
              ref="heroCardsTrackRef"
            >
              <button
                v-for="(b, i) in heroPreviewCards"
                :key="`${b.id ?? i}-${b._realIndex}`"
                class="heroFloatCard"
                :class="{ sourceHidden: heroExpandSourceIndex === b._realIndex }"
                :data-real-index="b._realIndex"
                :ref="(el) => setHeroCardRef(el, b._realIndex)"
                @click="handleBannerCardClick(b, $event)"
              >
                <img :src="b.src" :alt="b.title" />
                <div class="heroFloatMask"></div>
              </button>
            </transition-group>
          </div>

        </div>
      </section>

      <section class="screenSection contentScreen" :class="{ resultsContentScreen: contentMode === 'results', shelfContentScreen: contentMode === 'shelf' }">
        <div class="contentWrapper">
          <!-- 搜索区域：默认显示书架首页；搜索后进入原来的结果页 -->
          <div class="searchSection" :class="{ shelfSearchSection: contentMode === 'shelf', resultSearchSection: contentMode === 'results' }">
            <div v-if="contentMode === 'shelf'" class="shelfTitleRow titleCenterLine titleCenterLineMain">
              <img class="shelfTitleDecor shelfTitleDecorLeft" :src="shelfDecorLeft" alt="左侧装饰" />
              <h1 class="shelfMainTitle">{{ t('mainTitle') }}</h1>
              <img class="shelfTitleDecor shelfTitleDecorRight" :src="shelfDecorRight" alt="右侧装饰" />
            </div>

            <div class="searchCenter">
              <div class="searchBoxLight">
                <span class="searchIconLight">🔍</span>
                <input 
                  v-model="kw" 
                  type="text" 
                  :placeholder="t('searchPlaceholder')"
                  @keyup.enter="handleSearchSubmit"
                />
                <button class="searchSubmitBtnLight" @click="handleSearchSubmit">{{ t('search') }}</button>
              </div>
            </div>

            <div v-if="contentMode === 'results'" class="actionButtons">
              <button class="navTabInline shelfBackBtn" @click="backToShelf">{{ t('backToShelf') }}</button>

              <button class="navTabInline worksBtn" :class="{ active: viewMode === 'works' }" @click="viewMode = 'works'">
                {{ t('works') }}
              </button>
              <div class="navTabWrapperInline" v-click-outside="() => closeCategoryDropdown()">
                <button class="navTabInline" :class="{ active: viewMode === 'category' }" @click="toggleCategoryDropdown">
                  {{ t('category') }}
                  <span class="dropdownArrow" :class="{ up: categoryDropdownOpen }">▼</span>
                </button>
                <div v-if="categoryDropdownOpen" class="categoryDropdown">
                  <div class="categoryGroup">
                    <div class="categoryTitle">朝代</div>
                    <div class="categoryItems">
                      <button v-for="x in dynOptions" :key="x" class="categoryItem" :class="{ active: dyn === x }" @click="selectCategory('dynasty', x)">{{ x }}</button>
                    </div>
                  </div>
                  <div class="categoryGroup">
                    <div class="categoryTitle">体裁</div>
                    <div class="categoryItems">
                      <button v-for="x in genreOptions" :key="x" class="categoryItem" :class="{ active: genre === x }" @click="selectCategory('genre', x)">{{ x }}</button>
                    </div>
                  </div>
                  <div class="categoryGroup">
                    <div class="categoryTitle">主题</div>
                    <div class="categoryItems">
                      <button v-for="x in themeOptions" :key="x" class="categoryItem" :class="{ active: theme === x }" @click="selectCategory('theme', x)">{{ x }}</button>
                    </div>
                  </div>
                  <div class="categoryGroup">
                    <div class="categoryTitle">🌸 季节</div>
                    <div class="categoryItems">
                      <button v-for="x in seasonOptions" :key="x" class="categoryItem" :class="{ active: season === x }" @click="selectCategory('season', x)">{{ x }}</button>
                    </div>
                  </div>
                  <div class="categoryGroup">
                    <div class="categoryTitle">💭 情感</div>
                    <div class="categoryItems">
                      <button v-for="x in emotionOptions" :key="x" class="categoryItem" :class="{ active: emotion === x }" @click="selectCategory('emotion', x)">{{ x }}</button>
                    </div>
                  </div>
                  <div class="categoryGroup">
                    <div class="categoryTitle">🏔️ 景物</div>
                    <div class="categoryItems">
                      <button v-for="x in sceneryOptions" :key="x" class="categoryItem" :class="{ active: scenery === x }" @click="selectCategory('scenery', x)">{{ x }}</button>
                    </div>
                  </div>
                  <div class="categoryGroup">
                    <div class="categoryTitle">🎎 节日</div>
                    <div class="categoryItems">
                      <button v-for="x in festivalOptions" :key="x" class="categoryItem" :class="{ active: festival === x }" @click="selectCategory('festival', x)">{{ x }}</button>
                    </div>
                  </div>
                  <div class="categoryGroup">
                    <div class="categoryTitle">📖 历史时期</div>
                    <div class="categoryItems">
                      <button v-for="x in historicalPeriodOptions" :key="x" class="categoryItem" :class="{ active: historicalPeriod === x }" @click="selectCategory('historicalPeriod', x)">{{ x }}</button>
                    </div>
                  </div>
                  <div class="categoryGroup">
                    <div class="categoryTitle">📝 诗体</div>
                    <div class="categoryItems">
                      <button v-for="x in poeticFormOptions" :key="x" class="categoryItem" :class="{ active: poeticForm === x }" @click="selectCategory('poeticForm', x)">{{ x }}</button>
                    </div>
                  </div>
                  <div class="categoryGroup">
                    <div class="categoryTitle">✨ 修辞手法</div>
                    <div class="categoryItems">
                      <button v-for="x in rhetoricalDeviceOptions" :key="x" class="categoryItem" :class="{ active: rhetoricalDevice === x }" @click="selectCategory('rhetoricalDevice', x)">{{ x }}</button>
                    </div>
                  </div>
                </div>
              </div>
              <button class="navTabInline" :class="{ active: viewMode === 'author' }" @click="viewMode = 'author'">
                {{ t('author') }}
              </button>
              <button class="navTabInline" :class="{ active: viewMode === 'favorites' }" @click="viewMode = 'favorites'">
                {{ t('favorites') }}
              </button>
              <button class="resetBtnLight" @click="resetFilters">{{ t('reset') }}</button>
              <button class="shuffleBtnLight" @click="shuffle">{{ t('shuffle') }}</button>
            </div>
          </div>

          <!-- 入口页：书架 + 朝代竖轴 + 主题宫墙 -->
          <template v-if="contentMode === 'shelf'">
            <section class="libraryShelfLanding landingBlock">
              <div class="shelfRow shelfRowTop">
                <button
                  v-for="book in shelfBooks.slice(0, 5)"
                  :key="'top-' + book.id"
                  class="shelfBookBtn"
                  :title="book.name"
                  @click="openShelfBook(book)"
                >
                  <img class="shelfBookCover" :src="book.cover" :alt="book.name" />
                  <span class="shelfBookLabel">{{ book.name }}</span>
                </button>
                <img class="shelfBoard shelfBoardTop" :src="shelfBoard" alt="书架" />
              </div>

              <div class="shelfRow shelfRowBottom">
                <button
                  v-for="book in shelfBooks.slice(5, 10)"
                  :key="'bottom-' + book.id"
                  class="shelfBookBtn"
                  :title="book.name"
                  @click="openShelfBook(book)"
                >
                  <img class="shelfBookCover" :src="book.cover" :alt="book.name" />
                  <span class="shelfBookLabel">{{ book.name }}</span>
                </button>
                <img class="shelfBoard shelfBoardBottom" :src="shelfBoard" alt="书架" />
              </div>
            </section>

            <section class="onlineReadingPage landingBlock">
              <div class="subPageTitleRow dynastyTitleRow titleCenterLine titleCenterLineSub">
                <img class="subPageTitleDecor" :src="shelfDecorLeft" alt="左侧装饰" />
                <h2 class="subPageTitle">{{ t('dynasty') }}</h2>
                <img class="subPageTitleDecor" :src="shelfDecorRight" alt="右侧装饰" />
              </div>

              <div class="onlineReadingStage">
                <div class="onlineAxisArea" ref="onlineAxisAreaRef">
                  <button
                    v-for="(item, index) in onlineReadingOptions"
                    :key="'online-reading-' + item"
                    class="onlineAxisItem"
                    :style="{ '--delay': `${index * 0.055}s` }"
                    @click="openOnlineReadingLanding(item)"
                  >
                    <img class="onlineAxisImg" :src="dynastyAxisImg" alt="数轴" />
                    <span class="onlineAxisText">{{ item }}</span>
                  </button>
                </div>

                <aside class="onlineSearchPanel" :aria-label="t('moreReading')">
                  <div class="onlinePanelTitle">
                    <img class="onlinePanelDecor" :src="shelfDecorLeft" alt="左侧装饰" />
                    <span>{{ t('moreReading') }}</span>
                    <img class="onlinePanelDecor" :src="shelfDecorRight" alt="右侧装饰" />
                  </div>

                  <div class="onlineSearchForm">
                    <label class="onlineInputLine">
                      <span>{{ t('title') }}:</span>
                      <input v-model="onlineTitle" type="text" @keyup.enter="handleOnlineReadingSearch" />
                    </label>
                    <label class="onlineInputLine">
                      <span>{{ t('author') }}:</span>
                      <input v-model="onlineAuthor" type="text" @keyup.enter="handleOnlineReadingSearch" />
                    </label>
                    <label class="onlineInputLine">
                      <span>{{ t('quote') }}:</span>
                      <input v-model="onlineQuote" type="text" @keyup.enter="handleOnlineReadingSearch" />
                    </label>
                    <button class="onlineSearchBtn" @click="handleOnlineReadingSearch">{{ t('search') }}</button>
                  </div>
                </aside>
              </div>
            </section>

            <section class="themePage landingBlock" ref="themePageRef" :class="{ themeInView }">
              <img class="themeCraneFloat" :src="craneImg" alt="仙鹤" />
              <div class="subPageTitleRow themeTitleRow titleCenterLine titleCenterLineSub">
                <img class="subPageTitleDecor" :src="shelfDecorLeft" alt="左侧装饰" />
                <h2 class="subPageTitle">{{ t('theme') }}</h2>
                <img class="subPageTitleDecor" :src="shelfDecorRight" alt="右侧装饰" />
              </div>

              <div class="ancientBrowseShell">
                <img class="ancientCrane" :src="craneImg" alt="仙鹤" />
<div class="ancientSearchRow">
                  <label class="ancientSearchField">
                    <span>{{ t('name') }}:</span>
                    <input v-model="ancientTitle" type="text" @keyup.enter="handleAncientSearch" />
                  </label>
                  <label class="ancientSearchField">
                    <span>{{ t('era') }}:</span>
                    <input v-model="ancientEra" type="text" @keyup.enter="handleAncientSearch" />
                  </label>
                  <label class="ancientSearchField">
                    <span>{{ t('quote') }}:</span>
                    <input v-model="ancientQuote" type="text" @keyup.enter="handleAncientSearch" />
                  </label>
                  <button class="ancientSearchBtn" type="button" @click="handleAncientSearch">{{ t('search') }}</button>
                </div>

                <div class="themePalaceBox ancientPalaceBox">
                  <div class="themePalaceColumns" ref="themePalaceColumnsRef">
                    <button
                      v-for="(item, index) in themeLandingOptions"
                      :key="'theme-' + item"
                      class="themePalaceCol"
                      :style="{ '--delay': `${index * 0.08}s` }"
                      @click="openThemeLanding(item)"
                    >
                      <div class="themePalaceTextWrap theme-animated">
                        <img class="themePalaceIcon" :src="themeIconImg" alt="图标" />
                        <span class="themePalaceText">{{ item }}</span>
                      </div>
                    </button>
                  </div>

                  <div class="themeDragon"></div>
                  <img class="themeTiananmen" :src="palaceRoofImg" alt="天安门" />
                </div>
              </div>
            </section>
          </template>

          <section v-if="contentMode === 'results' && viewMode === 'works' && theme !== '全部'" class="topicHero">
            <div class="topicHeroCard" @mousemove="onTopicMove" @mouseleave="resetTopicMove">
              <div class="topicBg" :style="topicBgStyle" aria-hidden="true"></div>
              <div class="topicMask" aria-hidden="true"></div>

              <div class="topicContent">
                <div class="topicBadge">专题</div>
                <div class="topicTitle">{{ theme }}</div>
                <div class="topicDesc">{{ topicDesc(theme) }}</div>

                <div class="topicMeta">
                  <span class="pillDark">当前筛选：{{ theme }}</span>
                  <span class="pillDark">已加载：{{ list.length }} / {{ total }}</span>
                  <span class="pillDark">排序：{{ sortLabel }}</span>
                </div>

              </div>

              <div class="topicRelatedIntro">
                <div class="topicRelatedIntroTitle">相关介绍</div>
                <p>{{ topicRelatedIntro(theme) }}</p>
              </div>

              <div class="topicCorner" aria-hidden="true"></div>
            </div>
          </section>

          <!-- 作品视图 -->
          <div v-if="contentMode === 'results' && viewMode === 'works'" class="gridWrap" ref="gridWrapRef">
            <div class="gridHead">
              <div class="count">
                共 <b>{{ total }}</b> 条资料
                <span class="muted">· 已加载 {{ list.length }} 条</span>
                <span class="muted" v-if="loading">· 加载中</span>
              </div>
            </div>

            <div v-if="!loading && list.length === 0" class="empty">
              <div class="emptyTitle">暂无数据</div>
              <div class="emptySub">尝试清空筛选条件，或检查接口地址是否已改为 /api/poems/page。</div>
              <button class="pg" @click="resetFilters">一键重置</button>
            </div>

            <div class="grid" v-else>
              <article v-for="(item, index) in pageItems" :key="item.id" class="card cardElegant" @click="open(item)">
                <div class="poster posterElegant" :style="posterStyle(item)">
                  <div class="posterMask" aria-hidden="true"></div>
                  <div class="badges">
                    <span class="badge">{{ item.dynasty }}</span>
                    <span class="badge soft">{{ item.genre }}</span>
                    <span class="badge soft">{{ item.theme }}</span>
                  </div>
                </div>

                <div class="info infoElegant">
                  <div class="metaLine">类目 {{ item.theme || '诗词' }}, {{ item.genre || '作品' }}, {{ item.dynasty || '古典' }}</div>
                  <div class="title">{{ item.title }}</div>
                  <div class="meta">撰自 {{ item.author || '未署名' }} / {{ item.publishTime || item.createdAt || '暂无日期' }} / {{ item.commentCount ?? 0 }} 条评论</div>
                  <div class="excerpt">{{ item.analysis || item.translation || item.quote || item.content || '暂无简介' }}</div>
                  <div class="cardFoot" @click.stop>
                    <button class="cardGhostBtn" @click="open(item)">参与评论</button>
                    <button class="cardDarkBtn" @click="goToPhysicsBook(item, index)">浏览书籍</button>
                  </div>
                </div>
              </article>
            </div>

            <div ref="loadMoreRef" class="loadMore" v-if="list.length > 0">
              <div v-if="loading" class="muted">加载中...</div>
              <div v-else-if="!hasMore" class="muted">没有更多了</div>
              <button v-else class="loadMoreBtn" @click="loadMore">点击加载更多</button>
            </div>
          </div>

          <!-- 分类页面（扩展版） -->
          <div v-else-if="contentMode === 'results' && viewMode === 'category'" class="listWrap">
            <div class="listHead">
              <div class="listTitle">分类浏览</div>
              <div class="listSub">点击任意分类，自动筛选相关诗词</div>
            </div>

            <div class="catGridExtended">
              <div class="catPanel">
                <div class="catT">📜 朝代</div>
                <div class="catItems">
                  <button v-for="x in groupDynasty" :key="'d-' + x.key" class="catItem" @click="applyCategory('dynasty', x.key)">
                    <span class="catKey">{{ x.key }}</span>
                    <span class="catCnt">{{ x.count }}</span>
                  </button>
                </div>
              </div>

              <div class="catPanel">
                <div class="catT">✍️ 体裁</div>
                <div class="catItems">
                  <button v-for="x in groupGenre" :key="'g-' + x.key" class="catItem" @click="applyCategory('genre', x.key)">
                    <span class="catKey">{{ x.key }}</span>
                    <span class="catCnt">{{ x.count }}</span>
                  </button>
                </div>
              </div>

              <div class="catPanel">
                <div class="catT">🎨 主题</div>
                <div class="catItems">
                  <button v-for="x in groupTheme" :key="'t-' + x.key" class="catItem" @click="applyCategory('theme', x.key)">
                    <span class="catKey">{{ x.key }}</span>
                    <span class="catCnt">{{ x.count }}</span>
                  </button>
                </div>
              </div>

              <div class="catPanel">
                <div class="catT">🌸 季节</div>
                <div class="catItems">
                  <button v-for="x in groupSeason" :key="'s-' + x.key" class="catItem" @click="applyCategory('season', x.key)">
                    <span class="catKey">{{ x.key }}</span>
                    <span class="catCnt">{{ x.count }}</span>
                  </button>
                  <div v-if="groupSeason.length === 0" class="emptyCat">暂无数据</div>
                </div>
              </div>

              <div class="catPanel">
                <div class="catT">💭 情感</div>
                <div class="catItems">
                  <button v-for="x in groupEmotion" :key="'e-' + x.key" class="catItem" @click="applyCategory('emotion', x.key)">
                    <span class="catKey">{{ x.key }}</span>
                    <span class="catCnt">{{ x.count }}</span>
                  </button>
                  <div v-if="groupEmotion.length === 0" class="emptyCat">暂无数据</div>
                </div>
              </div>

              <div class="catPanel">
                <div class="catT">🏔️ 景物</div>
                <div class="catItems">
                  <button v-for="x in groupScenery" :key="'sc-' + x.key" class="catItem" @click="applyCategory('scenery', x.key)">
                    <span class="catKey">{{ x.key }}</span>
                    <span class="catCnt">{{ x.count }}</span>
                  </button>
                  <div v-if="groupScenery.length === 0" class="emptyCat">暂无数据</div>
                </div>
              </div>

              <div class="catPanel">
                <div class="catT">🎎 节日</div>
                <div class="catItems">
                  <button v-for="x in groupFestival" :key="'f-' + x.key" class="catItem" @click="applyCategory('festival', x.key)">
                    <span class="catKey">{{ x.key }}</span>
                    <span class="catCnt">{{ x.count }}</span>
                  </button>
                  <div v-if="groupFestival.length === 0" class="emptyCat">暂无数据</div>
                </div>
              </div>

              <div class="catPanel">
                <div class="catT">📖 历史时期</div>
                <div class="catItems">
                  <button v-for="x in groupHistoricalPeriod" :key="'h-' + x.key" class="catItem" @click="applyCategory('historicalPeriod', x.key)">
                    <span class="catKey">{{ x.key }}</span>
                    <span class="catCnt">{{ x.count }}</span>
                  </button>
                  <div v-if="groupHistoricalPeriod.length === 0" class="emptyCat">暂无数据</div>
                </div>
              </div>

              <div class="catPanel">
                <div class="catT">📝 诗体</div>
                <div class="catItems">
                  <button v-for="x in groupPoeticForm" :key="'pf-' + x.key" class="catItem" @click="applyCategory('poeticForm', x.key)">
                    <span class="catKey">{{ x.key }}</span>
                    <span class="catCnt">{{ x.count }}</span>
                  </button>
                  <div v-if="groupPoeticForm.length === 0" class="emptyCat">暂无数据</div>
                </div>
              </div>

              <div class="catPanel">
                <div class="catT">✨ 修辞手法</div>
                <div class="catItems">
                  <button v-for="x in groupRhetoricalDevice" :key="'rd-' + x.key" class="catItem" @click="applyCategory('rhetoricalDevice', x.key)">
                    <span class="catKey">{{ x.key }}</span>
                    <span class="catCnt">{{ x.count }}</span>
                  </button>
                  <div v-if="groupRhetoricalDevice.length === 0" class="emptyCat">暂无数据</div>
                </div>
              </div>
            </div>
          </div>

          <!-- 作者视图 -->
          <div v-else-if="contentMode === 'results' && viewMode === 'author'" class="listWrap">
            <div class="listHead">
              <div class="listTitle">作者</div>
              <div class="listSub">点击作者，自动切回作品视图并完成筛选</div>
            </div>
            <!-- 添加加载状态 -->
            <div v-if="authorLoading" class="empty">
              <div class="emptyTitle">加载中...</div>
            </div>

            <div v-else-if="groupAuthor.length === 0" class="empty">
              <div class="emptyTitle">暂无作者</div>
              <div class="emptySub">当前筛选条件下没有找到作者</div>
            </div>

            <div class="authorGrid">
              <button
                v-for="a in groupAuthor"
                :key="'a-' + a.key"
                class="authorCard"
                @click="applyAuthor(a.key)"
              >
                <div class="authorCardInner">
                  <div class="authorLeft">
                    <div class="authorAvatar">
                      <div class="authorAvatarText">
                        {{ a.key }}
                      </div>
                    </div>
                  </div>
                  <div class="authorRight">
                    <div class="authorRightMain">
                      <div class="authorTop">
                        <div class="authorName">{{ a.key }}</div>
                        <div class="authorCnt">{{ a.count }} 首</div>
                      </div>
                      <div class="authorMeta">
                        <span class="pillLite">代表朝代：{{ a.dynastyTop || "—" }}</span>
                        <span class="pillLite">常见体裁：{{ a.genreTop || "—" }}</span>
                      </div>
                      <div class="authorPoemSection" v-if="a.sampleTitle">
                        <div class="authorPoemTitle">《{{ a.sampleTitle }}》</div>
                        <div class="authorPoemContent">
                          {{ a.sampleContent || a.sampleQuote || "—" }}
                        </div>
                      </div>
                      <div class="authorQuote" v-else>
                        "{{ a.sampleQuote || "—" }}"
                      </div>
                    </div>
                    <div class="authorMoreRow">
                      <span class="authorMoreBtn">查看更多</span>
                    </div>
                  </div>
                </div>
              </button>
            </div>
          </div>

          <!-- 收藏视图 -->
          <div v-else-if="contentMode === 'results' && viewMode === 'favorites'" class="gridWrap">
            <div class="gridHead">
              <div class="count">
                共 <b>{{ favTotal }}</b> 条收藏
                <span class="muted">· 已加载 {{ favList.length }} 条</span>
                <span class="muted" v-if="favLoading">· 加载中</span>
              </div>
            </div>

            <div v-if="!favLoading && favList.length === 0" class="empty">
              <div class="emptyTitle">暂无收藏</div>
              <div class="emptySub">去作品页面收藏你喜欢的诗词吧~</div>
              <button class="pg" @click="viewMode = 'works'">去浏览作品</button>
            </div>

            <div class="grid" v-else>
              <article v-for="(item, index) in favList" :key="item.id" class="card cardElegant" @click="open(item)">
                <div class="poster posterElegant" :style="posterStyle(item)">
                  <div class="posterMask" aria-hidden="true"></div>
                  <div class="badges">
                    <span class="badge">{{ item.dynasty }}</span>
                    <span class="badge soft">{{ item.genre }}</span>
                    <span class="badge soft">{{ item.theme }}</span>
                  </div>
                </div>

                <div class="info infoElegant">
                  <div class="metaLine">类目 {{ item.theme || '诗词' }}, {{ item.genre || '作品' }}, {{ item.dynasty || '古典' }}</div>
                  <div class="title">{{ item.title }}</div>
                  <div class="meta">撰自 {{ item.author || '未署名' }} / {{ item.publishTime || item.createdAt || '暂无日期' }} / {{ item.commentCount ?? 0 }} 条评论</div>
                  <div class="excerpt">{{ item.analysis || item.translation || item.quote || item.content || '暂无简介' }}</div>
                  <div class="cardFoot" @click.stop>
                    <button class="cardGhostBtn" @click="open(item)">参与评论</button>
                    <button class="cardDarkBtn" @click="goToPhysicsBook(item, index)">浏览书籍</button>
                  </div>
                </div>
              </article>
            </div>

            <div ref="favLoadMoreRef" class="loadMore" v-if="favList.length > 0">
              <div v-if="favLoading" class="muted">加载中...</div>
              <div v-else-if="!favHasMore" class="muted">没有更多了</div>
              <button v-else class="loadMoreBtn" @click="loadMoreFav">点击加载更多</button>
            </div>
          </div>
        </div>
      </section>
    </div>

    <div class="modal detailPageModal" v-if="detail" @click.self="closeDetail">
      <div class="panel detailPagePanel detailReferencePanel detailShugePanel">
        <button class="close detailCloseBtn detailShugeClose" @click="closeDetail">×</button>

        <div class="detailShugeTopLine"></div>

        <div class="detailReferenceLayout detailShugeLayout">
          <section class="detailReferenceMain detailShugeMain">
            <header class="detailReferenceHeader detailShugeHeader">
              <div class="detailShugeHeaderInner">
                <div class="detailRefMetaLine detailShugeMetaLine">
                  <span>撰自 {{ detail.author || '未署名' }}</span>
                  <span>/ 类目 {{ detail.theme || '诗词' }}, {{ detail.genre || '作品' }}</span>
                  <span>/ {{ detail.publishTime || detail.createdAt || '暂无日期' }}</span>
                </div>
                <h1 class="detailRefTitle detailShugeTitle">{{ detail.title }}</h1>
                <div class="detailShugeSummary" v-if="detail.analysis || detail.translation || detail.content">
                  <p>{{ detail.analysis || detail.translation || detail.content }}</p>
                </div>
              </div>
            </header>

            <figure class="detailReferenceFigure detailShugeFigure">
              <div class="detailCover detailReferenceCover detailShugeCover" :style="posterStyle(detail, true)">
                <div class="posterMask strong detailShugeCoverMask" aria-hidden="true"></div>
                <div class="pBadges detailShugeBadges">
                  <span class="badge">{{ detail.dynasty || '未标注' }}</span>
                  <span class="badge soft">{{ detail.genre || '作品' }}</span>
                  <span class="badge soft">{{ detail.theme || '诗词' }}</span>
                </div>
              </div>
              <figcaption>{{ detail.quote || '典藏图像 / 资源展示' }}</figcaption>
            </figure>

            <div class="detailReferenceActions detailShugeActions">
              <button class="primary detailShugePrimary" @click="scrollToDetailBody">阅读全文</button>
              <button class="ghost detailShugeGhost" @click="playDetailAudio" :disabled="!detailAudioUrl">{{ playing ? '暂停朗读' : '播放朗读' }}</button>
              <button class="ghost detailShugeGhost" @click="quick('recite', detail)">去朗诵</button>
              <button class="ghost detailShugeGhost" @click="toggleFav(detail)">{{ detail.fav ? '取消收藏' : '加入收藏' }}</button>
            </div>

            <audio
              ref="audioRef"
              :src="detailAudioUrl"
              preload="none"
              @ended="playing = false"
              style="display:none;"
            />

            <div class="detailShugeDivider">
              <span>目 录</span>
            </div>

            <div class="detailReferenceBody detailShugeBody" ref="detailBodyRef">
              <section class="detailReferenceSection detailReferencePoem detailShugeSection detailShugePoem">
                <div class="detailReferenceSectionHead detailShugeSectionHead">
                  <div class="detailReferenceSectionTitle">原文</div>
                  <div class="detailReferenceSectionSub">POEM</div>
                </div>
                <div class="detailReferencePoemText detailShugePoemText" v-if="detail.content">{{ detail.content }}</div>
                <div class="detailReferenceEmpty" v-else>暂未收录原文内容</div>
              </section>

              <section class="detailReferenceSection detailShugeSection">
                <div class="detailReferenceSectionHead detailShugeSectionHead">
                  <div class="detailReferenceSectionTitle">译文</div>
                  <div class="detailReferenceSectionSub">TRANSLATION</div>
                </div>
                <div class="detailReferenceText detailShugeText" v-if="detail.translation">{{ detail.translation }}</div>
                <div class="detailReferenceEmpty" v-else>暂未收录译文内容</div>
              </section>

              <section class="detailReferenceSection detailShugeSection">
                <div class="detailReferenceSectionHead detailShugeSectionHead">
                  <div class="detailReferenceSectionTitle">赏析</div>
                  <div class="detailReferenceSectionSub">ANALYSIS</div>
                </div>
                <div class="detailReferenceText detailShugeText" v-if="detail.analysis">{{ detail.analysis }}</div>
                <div class="detailReferenceEmpty" v-else>暂未收录赏析内容</div>
              </section>

              <section class="detailReferenceSection detailReferenceTags detailShugeSection detailShugeTags" v-if="detail.tags && detail.tags.length">
                <div class="detailReferenceSectionHead detailShugeSectionHead">
                  <div class="detailReferenceSectionTitle">标签</div>
                  <div class="detailReferenceSectionSub">TAGS</div>
                </div>
                <div class="detailReferenceTagList detailShugeTagList">
                  <span class="detailReferenceTag detailShugeTag" v-for="x in detail.tags" :key="x"># {{ x }}</span>
                </div>
              </section>
            </div>
          </section>

          <aside class="detailReferenceAside detailShugeAside">
            <div class="detailShugeCornerIcon" aria-hidden="true">▥</div>

            <div class="detailReferenceAsideBlock detailShugeAsideBlock">
              <div class="detailReferenceAsideTitle detailShugeAsideTitle">刊印信息</div>
              <div class="detailReferenceInfoRow detailShugeInfoRow"><span>朝代</span><strong>{{ detail.dynasty || '未标注' }}</strong></div>
              <div class="detailReferenceInfoRow detailShugeInfoRow"><span>作者</span><strong>{{ detail.author || '未署名' }}</strong></div>
              <div class="detailReferenceInfoRow detailShugeInfoRow"><span>体裁</span><strong>{{ detail.genre || '作品' }}</strong></div>
              <div class="detailReferenceInfoRow detailShugeInfoRow"><span>主题</span><strong>{{ detail.theme || '诗词' }}</strong></div>
              <div class="detailReferenceInfoRow detailShugeInfoRow"><span>热度</span><strong>{{ detail.hot ?? 0 }}</strong></div>
              <div class="detailReferenceInfoRow detailShugeInfoRow"><span>难度</span><strong>{{ Number(detail.difficulty || 0).toFixed(1) }}</strong></div>
              <div class="detailReferenceInfoRow detailShugeInfoRow"><span>篇幅</span><strong>{{ detail.len ?? 0 }} 行</strong></div>
            </div>

            <div class="detailReferenceAsideBlock detailShugeAsideBlock" v-if="detail.season || detail.emotion || detail.scenery || detail.festival || detail.historicalPeriod || detail.poeticForm || detail.rhetoricalDevice">
              <div class="detailReferenceAsideTitle detailShugeAsideTitle">条目细目</div>
              <div class="detailReferenceInfoRow detailShugeInfoRow" v-if="detail.season"><span>季节</span><strong>{{ detail.season }}</strong></div>
              <div class="detailReferenceInfoRow detailShugeInfoRow" v-if="detail.emotion"><span>情感</span><strong>{{ detail.emotion }}</strong></div>
              <div class="detailReferenceInfoRow detailShugeInfoRow" v-if="detail.scenery"><span>景物</span><strong>{{ detail.scenery }}</strong></div>
              <div class="detailReferenceInfoRow detailShugeInfoRow" v-if="detail.festival"><span>节日</span><strong>{{ detail.festival }}</strong></div>
              <div class="detailReferenceInfoRow detailShugeInfoRow" v-if="detail.historicalPeriod"><span>时期</span><strong>{{ detail.historicalPeriod }}</strong></div>
              <div class="detailReferenceInfoRow detailShugeInfoRow" v-if="detail.poeticForm"><span>诗体</span><strong>{{ detail.poeticForm }}</strong></div>
              <div class="detailReferenceInfoRow detailShugeInfoRow" v-if="detail.rhetoricalDevice"><span>修辞</span><strong>{{ detail.rhetoricalDevice }}</strong></div>
            </div>

            <div class="detailReferenceAsideBlock detailShugeAsideBlock" v-if="detail.quote">
              <div class="detailReferenceAsideTitle detailShugeAsideTitle">摘录信息</div>
              <div class="detailReferenceQuote detailShugeQuote">{{ detail.quote }}</div>
            </div>

            <div class="detailReferenceAsideBlock detailShugeAsideBlock detailShugeActionBlock">
              <div class="detailReferenceAsideTitle detailShugeAsideTitle">内容修订</div>
              <button class="detailReferenceAsideBtn detailShugeAsideBtn" @click="scrollToDetailBody">阅读正文</button>
              <button class="detailReferenceAsideBtn detailShugeAsideBtn" @click="quick('recite', detail)">进入朗诵</button>
              <button class="detailReferenceAsideBtn detailShugeAsideBtn" @click="toggleFav(detail)">{{ detail.fav ? '取消收藏' : '加入收藏' }}</button>
            </div>
          </aside>
        </div>
      </div>
    </div>
  </div>

</template>

<script setup>

import { computed, ref, watch, onMounted, onUnmounted, nextTick } from "vue";
import { useRouter, useRoute } from "vue-router";
import axios from "axios";

import paperBg from "@/assets/library/paper.jpg";
import shelfBoard from "@/assets/library/zuozi.png";
import shelfDecorLeft from "@/assets/library/左.png";
import shelfDecorRight from "@/assets/library/右.png";
import bookCover1 from "@/assets/library/shuji1.png";
import bookCover2 from "@/assets/library/shuji2.png";
import bookCover3 from "@/assets/library/shuji3.png";
import bookCover4 from "@/assets/library/shuji4.png";
import bookCover5 from "@/assets/library/shuji5.png";
import bookCover6 from "@/assets/library/shuji6.png";
import bookCover7 from "@/assets/library/shuji7.png";
import bookCover8 from "@/assets/library/shuji8.png";
import bookCover9 from "@/assets/library/shuji9.png";
import bookCover10 from "@/assets/library/shuji10.png";
import dynastyAxisImg from "@/assets/library/shuzhou.png";
import palaceRoofImg from "@/assets/library/tiananmen.png";
import themeIconImg from "@/assets/library/tubiao.png";
import moreBooksBtnImg from "@/assets/library/anniu.png";
import craneImg from "@/assets/library/he.png";
import zhuanti1 from "@/assets/library/zhuanti1.jpg";
import zhuanti2 from "@/assets/library/zhuanti2.jpg";
import zhuanti3 from "@/assets/library/zhuanti3.jpg";
import zhuanti4 from "@/assets/library/zhuanti4.jpg";
import zhuanti5 from "@/assets/library/zhuanti5.jpg";
import zhuanti6 from "@/assets/library/zhuanti6.jpg";
import zhuanti7 from "@/assets/library/zhuanti7.jpg";
import zhuanti8 from "@/assets/library/zhuanti8.jpg";

import b1 from "@/assets/banners/b1.gif";
import b2 from "@/assets/banners/b2.gif";
import b3 from "@/assets/banners/b3.gif";
import b4 from "@/assets/banners/b4.gif";
import b5 from "@/assets/banners/b5.gif";

const router = useRouter();
const route = useRoute();
const LANG_KEY = "library_lang";
const lang = ref(localStorage.getItem(LANG_KEY) === "en" ? "en" : "zh");

const i18nMap = {
  zh: {
    cover: "封面",
    startBrowse: "开始浏览",
    mainTitle: "古诗词景物分类",
    searchPlaceholder: "搜索：诗名 / 作者 / 名句 / 标签",
    search: "搜索",
    backToShelf: "返回分类首页",
    works: "作品",
    category: "分类",
    author: "作者",
    favorites: "收藏",
    reset: "重置",
    shuffle: "换一批",
    dynasty: "朝代",
    moreReading: "更多在线阅读",
    title: "标题",
    quote: "名句",
    theme: "主题",
    name: "名称",
    era: "时代",
  },
  en: {
    cover: "Cover",
    startBrowse: "Start Browsing",
    mainTitle: "Classical Poetry Scenery Catalog",
    searchPlaceholder: "Search: title / author / quote / tag",
    search: "Search",
    backToShelf: "Back to Catalog",
    works: "Works",
    category: "Category",
    author: "Author",
    favorites: "Favorites",
    reset: "Reset",
    shuffle: "Shuffle",
    dynasty: "Dynasty",
    moreReading: "More Reading",
    title: "Title",
    quote: "Quote",
    theme: "Theme",
    name: "Name",
    era: "Era",
  },
};

function t(key) {
  return i18nMap[lang.value]?.[key] || i18nMap.zh[key] || key;
}

function setLang(next) {
  lang.value = next === "en" ? "en" : "zh";
  localStorage.setItem(LANG_KEY, lang.value);
}

const API_POEMS_PAGE = "/api/poems/page";
const API_POEMS_DETAIL = "/api/poems";
const API_POEMS_FAVORITES = "/api/poems/favorites";
const API_POEMS_FAV = "/api/poems";
const API_BANNERS = "/api/library/banners";

const viewMode = ref("works");
const contentMode = ref("shelf");
let suppressReload = false;

const paperStyle = computed(() => ({
  backgroundImage: `linear-gradient(180deg, rgba(254,253,251,.84) 0%, rgba(250,247,240,.86) 42%, rgba(244,236,216,.88) 100%), url(${paperBg})`,
  backgroundSize: "cover",
  backgroundPosition: "center top",
  backgroundAttachment: "fixed",
}));

const TOPIC_IMG = {
  喜悦: zhuanti1,
  悲伤: zhuanti2,
  豪迈: zhuanti3,
  思乡: zhuanti4,
  抒情: zhuanti5,
  离别: zhuanti6,
  宁静: zhuanti7,
  爱情: zhuanti8,
  山水: zhuanti1,
  友情: zhuanti2,
  励志: zhuanti3,
  边塞: zhuanti4,
  节令: zhuanti5,
  田园: zhuanti6,
};

function topicDesc(name) {
  const map = {
    山水: "清远空灵，意象流动，适合沉浸式浏览。",
    友情: "送别相知，温润含蓄，适合名句摘录。",
    思乡: "月色与乡愁交织，适合背诵与赏析。",
    励志: "凌云壮志，砥砺前行，适合学习解析。",
    边塞: "豪迈壮阔，家国情怀，适合朗诵氛围。",
    节令: "节气流转，物候人情，适合主题记忆。",
    田园: "闲适淡泊，烟火清欢，适合慢读收藏。",
  };
  return map[name] || "专题浏览";
}

function topicRelatedIntro(name) {
  const map = {
    喜悦: "收录欢欣明朗的诗词内容，呈现宴游、春景、相逢等积极情绪，适合快速浏览与情感赏析。",
    悲伤: "聚合离愁、身世、失意等相关作品，帮助用户从意象、情绪和背景中理解诗词的深层表达。",
    豪迈: "围绕边塞、壮志、家国等内容展开，突出气势、节奏与意境，适合朗诵展示和主题学习。",
    思乡: "以月夜、羁旅、故园等意象为线索，展示古诗词中常见的乡愁表达与情感递进。",
    抒情: "精选借景抒怀、托物言志类作品，便于从景物、情绪和语言风格三个角度进行赏析。",
    离别: "整理送别、远行、惜别相关诗词，突出场景描写与情感转折，适合名句积累。",
    宁静: "呈现山居、夜景、闲适等清雅意境，适合沉浸式阅读与古诗词意境感知。",
    爱情: "汇集相思、眷恋、等待等主题内容，帮助用户理解古典诗词中含蓄细腻的情感表达。",
    山水: "以山川、江河、云月等景物为核心，串联诗词意象与画面感，适合分类浏览。",
    友情: "聚合赠友、送友、怀友作品，突出知己情谊与古人交往中的诗意表达。",
    励志: "围绕志向、进取、坚守等内容，展示古诗词中的精神力量与人生表达。",
    边塞: "呈现边关风物、战争场景和家国情怀，适合结合历史背景进行理解。",
    节令: "按照节气、节日与时令景象组织内容，帮助用户建立诗词与传统文化的关联。",
    田园: "收录农事、村居、闲适生活相关作品，展现自然生活与淡泊心境。",
  };
  return map[name] || `围绕“${name}”主题整理相关诗词资料，便于从意象、情绪和名句角度进行浏览与赏析。`;
}

const topicMx = ref(0);
const topicMy = ref(0);

const isHeroJumping = ref(false);

function fastScrollTo(targetTop, duration = 170) {
  const el = scrollContainer.value;
  if (!el) return;

  const start = el.scrollTop;
  const distance = targetTop - start;
  let startTime = 0;

  const step = (time) => {
    if (!startTime) startTime = time;
    const progress = Math.min((time - startTime) / duration, 1);
    const eased = 1 - Math.pow(1 - progress, 4);
    el.scrollTop = start + distance * eased;
    if (progress < 1) requestAnimationFrame(step);
  };

  requestAnimationFrame(step);
}

function scrollToNextScreen() {
  scrollContainer.value?.scrollTo?.({ top: window.innerHeight, behavior: "smooth" });
}

function handleHeroWheel(e) {
  // 取消上下分屏拦截，让轮播页和下面内容在同一个滚动容器里自然滚动
  return;
}

function onTopicMove(e) {
  const el = e.currentTarget;
  const r = el.getBoundingClientRect();
  topicMx.value = (e.clientX - (r.left + r.width / 2)) / r.width;
  topicMy.value = (e.clientY - (r.top + r.height / 2)) / r.height;
}
function resetTopicMove() {
  topicMx.value = 0;
  topicMy.value = 0;
}
const topicBgStyle = computed(() => {
  const img = TOPIC_IMG[theme.value] || "";
  return {
    backgroundImage: `url(${img})`,
    transform: `translate3d(${(topicMx.value * 14).toFixed(2)}px, ${(topicMy.value * 12).toFixed(2)}px, 0) scale(1.07)`,
  };
});

const banners = ref([
  {
    id: 1,
    src: b1,
    title: "封面卡片",
    sub: "每条诗词都可以拥有更强的画面感和首页主视觉感。",
    link: "/b1",
  },
  {
    id: 2,
    src: b2,
    title: "专题诗词",
    sub: "围绕主题做浏览入口，让页面更像展示首页，而不是普通轮播。",
    link: "/b2",
  },
  {
    id: 3,
    src: b3,
    title: "典藏阅读",
    sub: "首屏展示氛围，第二屏承接检索、筛选、详情阅读。",
    link: "/b3",
  },
  {
    id: 4,
    src: b4,
    title: "沉浸浏览",
    sub: "用底部小卡向上放大成为主图，首屏切换更连贯、更干净。",
    link: "/b4",
  },
  {
    id: 5,
    src: b5,
    title: "词典拓展",
    sub: "新增第五张横幅后，下方四张预览可以稳定展示，同时保持主图不重复。",
    link: "/b5",
  },
]);

async function fetchBanners() {
  try {
    const res = await axios.get(API_BANNERS, { params: { enabled: 1 } });
    const arr = pickList(res);
    if (!arr.length) return;
    banners.value = arr
      .map((x, i) => ({
        id: x.id ?? i + 1,
        src: x.img_url || x.imgUrl || x.url || x.src,
        title: x.title || "横幅专题",
        sub: x.sub || x.subtitle || "专题展示",
      }))
      .filter((x) => !!x.src);
  } catch (e) {}
}

const bannerIndex = ref(0);
const previousBannerIndex = ref(-1);
const autoPlay = ref(true);
let timer = null;
const HERO_SWITCH_MS = 420;
const HERO_GHOST_FADE_MS = 80;

const heroStageRef = ref(null);
const heroCardsTrackRef = ref(null);
// 改为普通对象，避免在 ref 函数中触发响应式循环更新导致的 Maximum recursive updates exceeded 错误
const heroCardRefs = {};
const heroExpandGhostRef = ref(null);
const heroExpandGhost = ref({
  show: false,
  src: "",
  title: "",
  startX: 0,
  startY: 0,
  scaleX: 1,
  scaleY: 1,
  phase: "idle",
  pendingIndex: null,
  currentIndex: null,
});
const heroExpandSourceIndex = ref(null);
const heroSwitching = ref(false);

function setHeroCardRef(el, realIndex) {
  if (realIndex !== 0 && !realIndex) return;
  if (el) heroCardRefs[realIndex] = el;
  else delete heroCardRefs[realIndex];
}

function getHeroCardEl(realIndex, event) {
  const currentTarget = event?.currentTarget;
  if (currentTarget) return currentTarget;
  return heroCardRefs[realIndex] || null;
}

function resetHeroExpandGhost() {
  heroExpandGhost.value = {
    show: false,
    src: "",
    title: "",
    startX: 0,
    startY: 0,
    scaleX: 1,
    scaleY: 1,
    phase: "idle",
    pendingIndex: null,
    currentIndex: null,
  };
  heroExpandSourceIndex.value = null;
  heroSwitching.value = false;
}

function beginHeroCloneTransition(nextIndex, event = null) {
  const stageEl = heroStageRef.value;
  const cardEl = getHeroCardEl(nextIndex, event);
  const banner = banners.value?.[nextIndex];
  if (!stageEl || !cardEl || !banner?.src) return false;

  const stageRect = stageEl.getBoundingClientRect();
  const cardRect = cardEl.getBoundingClientRect();
  const startX = cardRect.left - stageRect.left;
  const startY = cardRect.top - stageRect.top;
  const scaleX = cardRect.width / Math.max(stageRect.width, 1);
  const scaleY = cardRect.height / Math.max(stageRect.height, 1);

  heroSwitching.value = true;
  heroExpandSourceIndex.value = nextIndex;
  heroExpandGhost.value = {
    show: true,
    src: banner.src,
    title: banner.title || "封面",
    startX,
    startY,
    scaleX,
    scaleY,
    phase: "idle",
    pendingIndex: nextIndex,
    currentIndex: bannerIndex.value,
  };

  requestAnimationFrame(() => {
    requestAnimationFrame(() => {
      if (!heroExpandGhost.value.show) return;
      heroExpandGhost.value = {
        ...heroExpandGhost.value,
        phase: "expanding",
      };
    });
  });

  return true;
}

function handleHeroGhostTransitionEnd(event) {
  if (event?.target !== heroExpandGhostRef.value) return;
  if (event?.propertyName !== "transform" && event?.propertyName !== "opacity") return;

  const state = heroExpandGhost.value;
  if (!state.show) return;

  if (state.phase === "expanding" && event.propertyName === "transform") {
    previousBannerIndex.value = state.currentIndex;
    bannerIndex.value = state.pendingIndex;
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        if (!heroExpandGhost.value.show) return;
        heroExpandGhost.value = {
          ...heroExpandGhost.value,
          phase: "fading",
        };
      });
    });
    return;
  }

  if (state.phase === "fading" && event.propertyName === "opacity") {
    previousBannerIndex.value = -1;
    resetHeroExpandGhost();
    restartAuto();
  }
}

const heroExpandGhostStyle = computed(() => {
  const state = heroExpandGhost.value;
  const isExpanded = state.phase === "expanding" || state.phase === "fading";
  return {
    transform: isExpanded
      ? "translate3d(0, 0, 0) scale3d(1, 1, 1)"
      : `translate3d(${state.startX}px, ${state.startY}px, 0) scale3d(${state.scaleX}, ${state.scaleY}, 1)`,
    opacity: state.phase === "fading" ? "0" : "1",
    borderRadius: isExpanded ? "0px" : "22px",
  };
});

const heroPreviewCards = computed(() => {
  const arr = banners.value || [];
  const len = arr.length;
  if (!len) return [];
  if (len === 1) {
    return [{
      ...arr[0],
      _realIndex: 0,
    }];
  }

  const maxCount = Math.min(4, len - 1);
  const result = [];

  for (let i = 1; i <= maxCount; i++) {
    const realIndex = (bannerIndex.value + i) % len;
    result.push({
      ...arr[realIndex],
      _realIndex: realIndex,
    });
  }

  return result;
});

function splitHeroTitle(title) {
  const s = String(title || "").trim();
  if (!s) return ["典藏", "诗词"];
  if (s.length <= 2) return [s, ""];
  if (s.length === 3) return [s.slice(0, 1), s.slice(1)];
  const mid = Math.ceil(s.length / 2);
  return [s.slice(0, mid), s.slice(mid)];
}

function restartAuto() {
  if (!autoPlay.value) return;
  startAuto();
}

function setBannerIndex(nextIndex, event = null) {
  if (!banners.value.length) return;
  if (nextIndex === bannerIndex.value || heroSwitching.value) return;

  stopAuto();
  const hasClone = beginHeroCloneTransition(nextIndex, event);
  if (!hasClone) {
    previousBannerIndex.value = bannerIndex.value;
    bannerIndex.value = nextIndex;
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        previousBannerIndex.value = -1;
        restartAuto();
      });
    });
  }
}

function prevBanner(event = null) {
  const len = banners.value.length;
  setBannerIndex((bannerIndex.value - 1 + len) % len, event);
}

function nextBanner(event = null) {
  const len = banners.value.length;
  setBannerIndex((bannerIndex.value + 1) % len, event);
}

function jumpBanner(i, event = null) {
  setBannerIndex(i, event);
}
function openBannerLink(target) {
  const item = typeof target === "number" ? banners.value[target] : target
  const link = item?.link ? String(item.link).trim() : ""
  if (!link) return
  router.push(link)
}

function handleBannerCardClick(b, event) {
  if (b._realIndex === bannerIndex.value) {
    openBannerLink(b)
    return
  }
  jumpBanner(b._realIndex, event)
}

function startAuto() {
  stopAuto();
  if (!autoPlay.value) return;
  timer = setInterval(() => nextBanner(), 2800);
}

function stopAuto() {
  if (timer) clearInterval(timer);
  timer = null;
}

const kw = ref("");
const dyn = ref("全部");
const genre = ref("全部");
const theme = ref("全部");
const sortKey = ref("hot");
const selectedAuthor = ref("");

const season = ref("全部");
const emotion = ref("全部");
const scenery = ref("全部");
const festival = ref("全部");
const historicalPeriod = ref("全部");
const poeticForm = ref("全部");
const rhetoricalDevice = ref("全部");


const seasonOptions = ["全部", "春", "夏", "秋", "冬"];
const emotionOptions = ["全部", "欢快", "忧愁", "豪迈", "思乡", "惜别", "闲适", "其他"];
const sceneryOptions = ["全部", "山水", "月夜", "城", "花鸟", "草木", "雪", "雨夜", "江海"];
const festivalOptions = ["全部", "春节", "元宵", "中秋", "重阳", "端午"];
const historicalPeriodOptions = ["全部", "初唐", "盛唐", "中唐", "晚唐", "北宋", "南宋"];
const poeticFormOptions = ["全部", "古风", "五律", "七绝", "七律", "五绝"];
const rhetoricalDeviceOptions = ["全部", "比喻","白描","设问"];


const dynOptions = ["全部", "唐", "宋", "元", "明", "清", "先秦"];
const genreOptions = ["全部", "诗", "词", "曲"];
const themeOptions = ["全部", "喜悦", "悲伤", "豪迈", "思乡", "抒情", "离别", "宁静", "爱情"];

const shelfCoverImgs = [bookCover1, bookCover2, bookCover3, bookCover4, bookCover5, bookCover6, bookCover7, bookCover8, bookCover9, bookCover10];
const shelfCategoryItems = [
  ...sceneryOptions.filter((x) => x !== "全部").slice(0, 8).map((value) => ({ type: "scenery", value })),
  ...themeOptions.filter((x) => x !== "全部").slice(0, 2).map((value) => ({ type: "theme", value })),
];
const dynLandingOptions = dynOptions.filter((x) => x !== "全部").slice(0, 6);
const themeLandingOptions = themeOptions.filter((x) => x !== "全部").slice(0, 8);
// 这里必须保持原来的六个朝代，不要改成在线阅读栏目名
const onlineReadingOptions = dynLandingOptions;
const onlineTitle = ref("");
const onlineAuthor = ref("");
const onlineQuote = ref("");
const ancientTitle = ref("");
const ancientEra = ref("");
const ancientQuote = ref("");

const shelfBooks = computed(() =>
  shelfCategoryItems.map((item, i) => ({
    id: i + 1,
    name: item.value,
    type: item.type,
    value: item.value,
    cover: shelfCoverImgs[i % shelfCoverImgs.length],
  }))
);

const sortLabel = computed(() => {
  const m = { hot: "热度", difficulty: "难度", len: "篇幅" };
  return m[sortKey.value] || sortKey.value;
});

const page = ref(1);
const pageSize = ref(12);
const loading = ref(false);
const total = ref(0);
const list = ref([]);

const hasMore = computed(() => list.value.length < (total.value || 0));
const pageItems = computed(() => list.value);

const favPage = ref(1);
const favPageSize = ref(12);
const favLoading = ref(false);
const favTotal = ref(0);
const favList = ref([]);
const favHasMore = computed(() => favList.value.length < (favTotal.value || 0));

const categoryDropdownOpen = ref(false);
const scrollContainer = ref(null);
const onlineAxisAreaRef = ref(null);
const themePalaceColumnsRef = ref(null);
const themePageRef = ref(null);
const themeInView = ref(false);

let axisObserver = null;
let themeObserver = null;

function setupAxisAnimationObserver() {
  if (!onlineAxisAreaRef.value) return;
  
  axisObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          triggerOnlineAxisAnimation();
        }
      });
    },
    { threshold: 0.3 }
  );
  
  axisObserver.observe(onlineAxisAreaRef.value);
}

function setupThemeAnimationObserver() {
  const target = themePageRef.value || themePalaceColumnsRef.value;
  if (!target) return;

  if (themeObserver) themeObserver.disconnect();

  themeObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          themeInView.value = true;
          triggerThemeAnimation();
        } else {
          themeInView.value = false;
          resetThemeAnimation();
        }
      });
    },
    { root: null, threshold: 0.28, rootMargin: "0px 0px -12% 0px" }
  );

  themeObserver.observe(target);
}

async function triggerOnlineAxisAnimation() {
  await nextTick();
  const container = onlineAxisAreaRef.value;
  if (!container) return;
  const items = container.querySelectorAll('.onlineAxisItem');
  items.forEach((item) => {
    // 先移除class，立即设置opacity为0防止闪烁
    item.classList.remove('axis-animated');
    item.style.opacity = '0';
    // 强制重绘
    void item.offsetWidth;
    // 移除临时样式，添加动画class
    item.style.opacity = '';
    item.classList.add('axis-animated');
  });
}

async function triggerThemeAnimation() {
  await nextTick();
  const container = themePalaceColumnsRef.value;
  if (!container) return;
  const items = container.querySelectorAll('.themePalaceTextWrap');
  items.forEach((item, index) => {
    item.classList.remove('theme-anim-run');
    item.style.transitionDelay = `${index * 0.11}s`;
    void item.offsetWidth;
    item.classList.add('theme-anim-run');
  });
}

function resetThemeAnimation() {
  const container = themePalaceColumnsRef.value;
  if (!container) return;
  const items = container.querySelectorAll('.themePalaceTextWrap');
  items.forEach((item) => {
    item.classList.remove('theme-anim-run');
  });
}

function toggleCategoryDropdown() {
  categoryDropdownOpen.value = !categoryDropdownOpen.value;
}
function closeCategoryDropdown() {
  categoryDropdownOpen.value = false;
}

function clearAllFiltersLocal() {
  dyn.value = "全部";
  genre.value = "全部";
  theme.value = "全部";
  season.value = "全部";
  emotion.value = "全部";
  scenery.value = "全部";
  festival.value = "全部";
  historicalPeriod.value = "全部";
  poeticForm.value = "全部";
  rhetoricalDevice.value = "全部";
  selectedAuthor.value = "";
}

async function backToShelf() {
  suppressReload = true;
  kw.value = "";
  clearAllFiltersLocal();
  suppressReload = false;
  contentMode.value = "shelf";
  viewMode.value = "works";
  categoryDropdownOpen.value = false;

  await nextTick();

  // 返回分类首页后，固定回到分类内容起点，避免停留在中间位置导致“朝代/主题错位”观感
  scrollContainer.value?.scrollTo?.({ top: window.innerHeight, behavior: "auto" });

  // shelf 内容是条件渲染，回切后重新绑定观察器，确保朝代/主题区域动画与可见状态正常
  if (axisObserver) axisObserver.disconnect();
  if (themeObserver) themeObserver.disconnect();
  setupAxisAnimationObserver();
  setupThemeAnimationObserver();
}

async function goLandingFilter(type, value) {
  suppressReload = true;
  kw.value = "";
  clearAllFiltersLocal();
  if (type === "dynasty") dyn.value = value;
  if (type === "theme") theme.value = value;
  if (type === "scenery") scenery.value = value;
  suppressReload = false;

  contentMode.value = "results";
  viewMode.value = "works";
  categoryDropdownOpen.value = false;
  await resetAndReload();
  await nextTick();
  scrollToResultsTop();
}

async function openShelfBook(book) {
  if (!book) return;
  await goLandingFilter(book.type, book.value);
}

async function openDynastyLanding(value) {
  if (!value) return;
  await goLandingFilter("dynasty", value);
}

async function openThemeLanding(value) {
  if (!value) return;
  await goLandingFilter("theme", value);
}

async function openOnlineReadingLanding(value) {
  // 左侧数轴现在是朝代，点击后按朝代筛选
  if (!value) return;
  await goLandingFilter("dynasty", value);
}

async function handleOnlineReadingSearch() {
  const parts = [onlineTitle.value, onlineAuthor.value, onlineQuote.value]
    .map((x) => String(x || "").trim())
    .filter(Boolean);
  if (!parts.length) return;
  suppressReload = true;
  kw.value = parts.join(" ");
  clearAllFiltersLocal();
  suppressReload = false;
  contentMode.value = "results";
  viewMode.value = "works";
  categoryDropdownOpen.value = false;
  await resetAndReload();
  await nextTick();
  scrollToResultsTop();
}

async function handleAncientSearch() {
  const parts = [ancientTitle.value, ancientEra.value, ancientQuote.value]
    .map((x) => String(x || "").trim())
    .filter(Boolean);
  if (!parts.length) return;
  suppressReload = true;
  kw.value = parts.join(" ");
  clearAllFiltersLocal();
  suppressReload = false;
  contentMode.value = "results";
  viewMode.value = "works";
  categoryDropdownOpen.value = false;
  await resetAndReload();
  await nextTick();
  scrollToResultsTop();
}

async function openAncientMore() {
  suppressReload = true;
  kw.value = "";
  clearAllFiltersLocal();
  suppressReload = false;
  contentMode.value = "results";
  viewMode.value = "works";
  categoryDropdownOpen.value = false;
  await resetAndReload();
  await nextTick();
  scrollToResultsTop();
}
function selectCategory(type, value) {
  contentMode.value = "results";
  if (type === 'dynasty') dyn.value = value;
  if (type === 'genre') genre.value = value;
  if (type === 'theme') theme.value = value;
  if (type === 'season') season.value = value;
  if (type === 'emotion') emotion.value = value;
  if (type === 'scenery') scenery.value = value;
  if (type === 'festival') festival.value = value;
  if (type === 'historicalPeriod') historicalPeriod.value = value;
  if (type === 'poeticForm') poeticForm.value = value;
  if (type === 'rhetoricalDevice') rhetoricalDevice.value = value;
  categoryDropdownOpen.value = false;
  viewMode.value = "works";
  resetAndReload();
}
function resetFilters() {
  suppressReload = true;
  kw.value = "";
  clearAllFiltersLocal();
  suppressReload = false;
  contentMode.value = "results";
  resetAndReload();
}

async function handleSearchSubmit() {
  if (!kw.value.trim()) return;
  contentMode.value = "results";
  viewMode.value = "works";
  await resetAndReload();
  await nextTick();
  scrollToResultsTop();
}

async function fetchPoems(mode = "reset") {
  if (loading.value) return;
  loading.value = true;

  try {
    const params = {
      page: page.value,
      size: pageSize.value,
      kw: kw.value.trim() || undefined,
      dynasty: dyn.value === "全部" ? undefined : dyn.value,
      genre: genre.value === "全部" ? undefined : genre.value,
      theme: theme.value === "全部" ? undefined : theme.value,
      season: season.value === "全部" ? undefined : season.value,
      emotion: emotion.value === "全部" ? undefined : emotion.value,
      scenery: scenery.value === "全部" ? undefined : scenery.value,
      festival: festival.value === "全部" ? undefined : festival.value,
      historicalPeriod: historicalPeriod.value === "全部" ? undefined : historicalPeriod.value,
      poeticForm: poeticForm.value === "全部" ? undefined : poeticForm.value,
      rhetoricalDevice: rhetoricalDevice.value === "全部" ? undefined : rhetoricalDevice.value,
      sortKey: sortKey.value,
    };

    const res = await axios.get(API_POEMS_PAGE, { params });
    const payload = pickPayload(res);

    const t = payload?.total ?? 0;
    const rows = payload?.items ?? payload?.rows ?? payload?.list ?? payload?.records ?? [];

    total.value = Number(t || 0);
    const newRows = normalizeRows(rows);

    if (mode === "append") {
      const exists = new Set(list.value.map((x) => x.id));
      list.value = list.value.concat(newRows.filter((x) => !exists.has(x.id)));
    } else {
      list.value = newRows;
    }
  } finally {
    loading.value = false;
  }
}

async function fetchPoemDetail(id) {
  const res = await axios.get(`${API_POEMS_DETAIL}/${id}`);
  const payload = pickPayload(res);
  return normalizeOne(payload);
}
async function loadMore() {
  if (!hasMore.value || loading.value) return;
  page.value += 1;
  await fetchPoems("append");
}

function resetAndReload() {
  page.value = 1;
  list.value = [];
  total.value = 0;
  // 如果当前在作者视图，刷新作者列表
  if (viewMode.value === "author") {
    fetchAuthorsByCategory();
  }
  return fetchPoems("reset");
}

async function fetchFavorites(mode = "reset") {
  if (favLoading.value) return;
  favLoading.value = true;

  try {
    const params = {
      pageNum: favPage.value,
      pageSize: favPageSize.value,
    };

    const res = await axios.get(API_POEMS_FAVORITES, { params });
    const payload = pickPayload(res);

    const t = payload?.total ?? 0;
    const rows = payload?.items ?? payload?.rows ?? payload?.list ?? payload?.records ?? [];

    favTotal.value = Number(t || 0);
    const newRows = normalizeRows(rows);

    if (mode === "append") {
      const exists = new Set(favList.value.map((x) => x.id));
      favList.value = favList.value.concat(newRows.filter((x) => !exists.has(x.id)));
    } else {
      favList.value = newRows;
    }
  } finally {
    favLoading.value = false;
  }
}

async function loadMoreFav() {
  if (!favHasMore.value || favLoading.value) return;
  favPage.value += 1;
  await fetchFavorites("append");
}

async function addFavorite(poemId) {
  await axios.post(`${API_POEMS_FAV}/${poemId}/fav`);
}

async function removeFavorite(poemId) {
  await axios.delete(`${API_POEMS_FAV}/${poemId}/fav`);
}

let kwTimer = null;

// 监听分类筛选条件变化（添加 selectedAuthor）
watch([dyn, genre, theme, sortKey, season, emotion, scenery, festival, 
       historicalPeriod, poeticForm, rhetoricalDevice, selectedAuthor], 
       () => {
         if (suppressReload || contentMode.value !== "results") return;
         resetAndReload();
         // 当分类筛选条件变化时，刷新作者列表（如果当前在作者视图）
         if (viewMode.value === "author") {
           fetchAuthorsByCategory();
         }
       });

// 监听搜索关键词
watch(kw, () => {
  if (suppressReload || contentMode.value !== "results") return;
  if (kwTimer) clearTimeout(kwTimer);
  kwTimer = setTimeout(() => {
    resetAndReload();
    // 搜索后也刷新作者列表
    if (viewMode.value === "author") {
      fetchAuthorsByCategory();
    }
  }, 260);
});

// 监听视图模式切换
watch(viewMode, (newMode) => {
  if (newMode === "favorites" && favList.value.length === 0) {
    favPage.value = 1;
    favList.value = [];
    fetchFavorites("reset");
  }
  // 新增：切换到作者视图时获取作者列表
  if (newMode === "author") {
    fetchAuthorsByCategory();
  }
});
async function shuffle() {
  contentMode.value = "results";
  viewMode.value = "works";
  page.value = 1;
  list.value = [];
  total.value = 0;
  try {
    const params = {
      page: 1,
      size: pageSize.value,
      sortKey: "random",
      theme: theme.value === "全部" ? undefined : theme.value,
    };
    const res = await axios.get(API_POEMS_PAGE, { params });
    const payload = pickPayload(res);
    total.value = Number(payload?.total ?? 0);
    list.value = normalizeRows(payload?.items ?? payload?.rows ?? payload?.list ?? payload?.records ?? []);
  } catch (e) {
    resetAndReload();
  }
}

function resolveAudio(url) {
  if (!url) return "";
  const s = String(url).trim();
  if (!s) return "";
  if (s.startsWith("http://") || s.startsWith("https://")) return s;
  if (s.startsWith("/files/")) return s;
  if (s.startsWith("files/")) return "/" + s;
  if (s.startsWith("/audio/")) return "/files" + s;
  if (s.startsWith("audio/")) return "/files/" + s;
  if (s.startsWith("/")) return "/files" + s;
  return "/files/" + s;
}

function resolveCover(url) {
  if (!url) return "";
  const s = String(url).trim();
  if (!s) return "";
  if (s.startsWith("http://") || s.startsWith("https://")) return s;
  if (s.startsWith("/")) return s;
  return `/${s}`;
}

const detail = ref(null);
const detailLoading = ref(false);

async function open(item) {
  stopAudio();
  detail.value = normalizeOne(item);
  detailLoading.value = true;
  try {
    const full = await fetchPoemDetail(item.id);
    detail.value = full;
  } finally {
    detailLoading.value = false;
  }
}

function goToPhysicsBook(item, index) {
  const bookIndex = index % 3;
  const bookId = ['1', '2', '3'][bookIndex];
  router.push(`/physics-book/${bookId}`);
}

function closeDetail() {
  stopAudio();
  detail.value = null;
}

async function toggleFav(item) {
  try {
    if (item.fav) {
      await removeFavorite(item.id);
      item.fav = false;
      if (detail.value && detail.value.id === item.id) {
        detail.value.fav = false;
      }
      if (viewMode.value === "favorites") {
        const index = favList.value.findIndex(x => x.id === item.id);
        if (index !== -1) {
          favList.value.splice(index, 1);
          favTotal.value--;
        }
      }
    } else {
      await addFavorite(item.id);
      item.fav = true;
      if (detail.value && detail.value.id === item.id) {
        detail.value.fav = true;
      }
    }
  } catch (error) {
    console.error('收藏操作失败:', error);
    alert(error.response?.data?.msg || error.message || '操作失败，请稍后重试');
  }
}

function quick(type) {
  if (type === "recite") {
    stopAudio();
    detail.value = null;
    router.push("/recite");
  }
}

const audioRef = ref(null);
const playing = ref(false);

const detailAudioUrl = computed(() => {
  const d = detail.value;
  return resolveAudio(d?.audioUrl || "");
});

watch(detailAudioUrl, () => {
  stopAudio();
  const el = audioRef.value;
  if (el) {
    try { el.load(); } catch (e) {}
  }
});

async function playDetailAudio() {
  const el = audioRef.value;
  const url = detailAudioUrl.value;
  if (!el || !url) return;

  if (playing.value) {
    el.pause();
    playing.value = false;
    return;
  }

  try {
    if (el.src !== new URL(url, window.location.origin).href) {
      el.src = url;
      el.load();
    }
    await el.play();
    playing.value = true;
  } catch (e) {
    playing.value = false;
  }
}

function stopAudio() {
  const el = audioRef.value;
  if (!el) {
    playing.value = false;
    return;
  }
  try {
    el.pause();
    el.currentTime = 0;
  } catch (e) {}
  playing.value = false;
}

const detailBodyRef = ref(null);
async function scrollToDetailBody() {
  await nextTick();
  detailBodyRef.value?.scrollIntoView?.({ behavior: "smooth", block: "start" });
}

function normalizeTagValue(tags) {
  if (Array.isArray(tags)) return tags.map((s) => String(s).trim()).filter(Boolean);
  if (typeof tags === "string") return tags.split(/[,，]/).map((s) => s.trim()).filter(Boolean);
  return [];
}

function normalizeOne(x = {}) {
  const tags = x.tags ?? x.tag ?? x.tagsStr ?? "";
  const rawAudio = x.audio_url || x.audioUrl || x.audio || "";
  return {
    id: x.id,
    title: x.title || "",
    author: x.author || "",
    dynasty: x.dynasty || "",
    genre: x.genre || "",
    theme: x.theme || "",
    difficulty: x.difficulty ?? 0,
    hot: x.hot ?? 0,
    len: x.len ?? 0,
    quote: x.quote ?? "",
    content: x.content ?? "",
    translation: x.translation ?? "",
    analysis: x.analysis ?? "",
    coverUrl: x.cover_url || x.coverUrl || x.cover || "",
    tags: normalizeTagValue(tags),
    fav: Boolean(x.fav),
    audioUrl: resolveAudio(rawAudio),
    season: x.season || "",
    emotion: x.emotion || "",
    scenery: x.scenery || "",
    festival: x.festival || "",
    historicalPeriod: x.historicalPeriod || x.historical_period || "",
    poeticForm: x.poeticForm || x.poetic_form || "",
    rhetoricalDevice: x.rhetoricalDevice || x.rhetorical_device || "",
  };
}

function normalizeRows(rows) {
  return (Array.isArray(rows) ? rows : []).map(normalizeOne);
}

function posterStyle(item, isDetail = false) {
  const cover = resolveCover(item?.coverUrl);
  const topicFallback = TOPIC_IMG[item?.theme] || "";
  const img = cover || topicFallback;
  const g1 = "radial-gradient(900px 420px at 22% 12%, rgba(255,255,255,.55), transparent 60%)";
  const g2 = "linear-gradient(135deg, rgba(120,170,150,.55), rgba(255,255,255,.94))";

  if (!img) {
    return {
      backgroundImage: `${g1}, ${g2}`,
      backgroundSize: "cover",
      backgroundPosition: "center",
    };
  }

  return {
    backgroundImage: `${g1}, url(${img})`,
    backgroundSize: "cover",
    backgroundPosition: "center",
    height: isDetail ? "320px" : undefined,
  };
}

function pickPayload(res) {
  const d = res?.data;
  if (!d) return {};
  if (d.data && typeof d.data === "object") return d.data;
  if (typeof d === "object" && ("rows" in d || "total" in d || "items" in d)) return d;
  return d;
}

function pickList(res) {
  const payload = pickPayload(res);
  if (Array.isArray(payload)) return payload;
  if (Array.isArray(payload?.items)) return payload.items;
  if (Array.isArray(payload?.rows)) return payload.rows;
  if (Array.isArray(payload?.data)) return payload.data;
  return [];
}

const loadMoreRef = ref(null);
const favLoadMoreRef = ref(null);
let io = null;
let favIo = null;

async function setupInfiniteScroll() {
  await nextTick();
  if (io) io.disconnect();
  io = new IntersectionObserver(
    (entries) => {
      if (entries[0]?.isIntersecting && viewMode.value === "works") loadMore();
    },
    { root: null, threshold: 0.1 }
  );
  if (loadMoreRef.value) io.observe(loadMoreRef.value);
}

async function setupFavInfiniteScroll() {
  await nextTick();
  if (favIo) favIo.disconnect();
  favIo = new IntersectionObserver(
    (entries) => {
      if (entries[0]?.isIntersecting && viewMode.value === "favorites") loadMoreFav();
    },
    { root: null, threshold: 0.1 }
  );
  if (favLoadMoreRef.value) favIo.observe(favLoadMoreRef.value);
}

const gridWrapRef = ref(null);
function scrollToGrid() {
  gridWrapRef.value?.scrollIntoView?.({ behavior: "smooth", block: "start" });
}

function scrollToResultsTop() {
  const el = scrollContainer.value;
  if (el) {
    el.scrollTo({ top: 0, behavior: "auto" });
    el.scrollTop = 0;
  } else {
    window.scrollTo({ top: 0, behavior: "auto" });
  }
}

// 缓存计算结果，避免每次都创建新对象导致的递归更新
const groupCache = ref({
  dynasty: [],
  genre: [],
  theme: [],
  season: [],
  emotion: [],
  scenery: [],
  festival: [],
  historicalPeriod: [],
  poeticForm: [],
  rhetoricalDevice: [],
});

// 生成缓存键，只考虑与分组相关的字段
function generateGroupCacheKey(key) {
  return list.value.map(item => `${item?.[key] || ""}`).join("|");
}

function buildGroup(key, minCount = 1) {
  const cacheKey = generateGroupCacheKey(key);
  const currentCache = groupCache.value[key];
  
  // 如果缓存存在且与当前数据匹配，直接返回缓存
  if (currentCache && currentCache.cacheKey === cacheKey) {
    return currentCache.data;
  }
  
  const map = new Map();
  for (const it of list.value) {
    const k = String(it?.[key] || "").trim();
    if (!k || k === "") continue;
    map.set(k, (map.get(k) || 0) + 1);
  }
  
  const result = [...map.entries()]
    .map(([k, c]) => ({ key: k, count: c }))
    .filter((x) => x.count >= minCount)
    .sort((a, b) => b.count - a.count || a.key.localeCompare(b.key, "zh-Hans-CN"));
  
  // 更新缓存
  groupCache.value[key] = { cacheKey, data: result };
  return result;
}

const groupDynasty = computed(() => buildGroup("dynasty"));
const groupGenre = computed(() => buildGroup("genre"));
const groupTheme = computed(() => buildGroup("theme"));
const groupSeason = computed(() => buildGroup("season"));
const groupEmotion = computed(() => buildGroup("emotion"));
const groupScenery = computed(() => buildGroup("scenery"));
const groupFestival = computed(() => buildGroup("festival"));
const groupHistoricalPeriod = computed(() => buildGroup("historicalPeriod"));
const groupPoeticForm = computed(() => buildGroup("poeticForm"));
const groupRhetoricalDevice = computed(() => buildGroup("rhetoricalDevice"));

function applyCategory(type, value) {
  suppressReload = true;
  kw.value = "";
  clearAllFiltersLocal();

  switch(type) {
    case 'dynasty': dyn.value = value; break;
    case 'genre': genre.value = value; break;
    case 'theme': theme.value = value; break;
    case 'season': season.value = value; break;
    case 'emotion': emotion.value = value; break;
    case 'scenery': scenery.value = value; break;
    case 'festival': festival.value = value; break;
    case 'historicalPeriod': historicalPeriod.value = value; break;
    case 'poeticForm': poeticForm.value = value; break;
    case 'rhetoricalDevice': rhetoricalDevice.value = value; break;
  }

  suppressReload = false;
  contentMode.value = "results";
  viewMode.value = "works";
  resetAndReload();
  scrollToGrid();
}


// 缓存作者分组结果
const authorGroupCache = ref({
  cacheKey: '',
  data: []
});

// 生成作者分组缓存键
function generateAuthorGroupCacheKey() {
  return list.value.map(item => `${item?.author || ""}|${item?.dynasty || ""}|${item?.genre || ""}|${item?.quote || ""}`).join("|");
}

function buildAuthorGroup() {
  const cacheKey = generateAuthorGroupCacheKey();
  
  // 如果缓存存在且与当前数据匹配，直接返回缓存
  if (authorGroupCache.value.cacheKey === cacheKey) {
    return authorGroupCache.value.data;
  }
  
  const map = new Map();
  for (const it of list.value) {
    const name = String(it?.author || "").trim();
    if (!name) continue;

    if (!map.has(name)) {
      map.set(name, {
        key: name,
        count: 0,
        dynastyMap: new Map(),
        genreMap: new Map(),
        sampleQuote: "",
        sampleTitle: "",
        sampleContent: "",
      });
    }
    const o = map.get(name);
    o.count += 1;

    const d = String(it?.dynasty || "").trim();
    const g = String(it?.genre || "").trim();
    if (d) o.dynastyMap.set(d, (o.dynastyMap.get(d) || 0) + 1);
    if (g) o.genreMap.set(g, (o.genreMap.get(g) || 0) + 1);
    if (!o.sampleQuote && it?.quote) o.sampleQuote = it.quote;
    if (!o.sampleTitle && it?.title) o.sampleTitle = it.title;
    if (!o.sampleContent && it?.content) o.sampleContent = it.content;
  }

  const pickTop = (m) => [...m.entries()].sort((a, b) => b[1] - a[1])[0]?.[0] || "";

  const result = [...map.values()]
    .map((x) => ({
      key: x.key,
      count: x.count,
      dynastyTop: pickTop(x.dynastyMap),
      genreTop: pickTop(x.genreMap),
      sampleQuote: x.sampleQuote,
      sampleTitle: x.sampleTitle,
      sampleContent: x.sampleContent,
    }))
    .sort((a, b) => b.count - a.count || a.key.localeCompare(b.key, "zh-Hans-CN"));
  
  // 更新缓存
  authorGroupCache.value = { cacheKey, data: result };
  return result;
}// ==================== 作者列表（从后端API获取） ====================
const authorListFromApi = ref([]);
const authorLoading = ref(false);

// 获取作者列表（根据当前分类筛选条件）
async function fetchAuthorsByCategory() {
  if (authorLoading.value) return;
  authorLoading.value = true;
  
  try {
    const params = {
      dynasty: dyn.value === "全部" ? undefined : dyn.value,
      genre: genre.value === "全部" ? undefined : genre.value,
      theme: theme.value === "全部" ? undefined : theme.value,
      season: season.value === "全部" ? undefined : season.value,
      emotion: emotion.value === "全部" ? undefined : emotion.value,
      scenery: scenery.value === "全部" ? undefined : scenery.value,
      festival: festival.value === "全部" ? undefined : festival.value,
      historicalPeriod: historicalPeriod.value === "全部" ? undefined : historicalPeriod.value,
      poeticForm: poeticForm.value === "全部" ? undefined : poeticForm.value,
      rhetoricalDevice: rhetoricalDevice.value === "全部" ? undefined : rhetoricalDevice.value,
    };
    
    const res = await axios.get("/api/poems/authors", { params });
    const data = pickList(res);
    authorListFromApi.value = Array.isArray(data) ? data : [];
  } catch (e) {
    console.error("获取作者列表失败:", e);
    authorListFromApi.value = [];
  } finally {
    authorLoading.value = false;
  }
}

// 替换为：从 API 获取的作者数据
const groupAuthor = computed(() => {
  return authorListFromApi.value.map(item => ({
    key: item.key || item.author || "",
    count: item.count || 0,
    dynastyTop: item.dynastyTop || "",
    genreTop: item.genreTop || "",
    sampleTitle: item.sampleTitle || "",
    sampleQuote: item.sampleQuote || "",
    sampleContent: item.sampleContent || "",
  }));
});

function applyAuthor(authorName) {
  contentMode.value = "results";
  kw.value = authorName;
  viewMode.value = "works";
  resetAndReload();
  scrollToGrid();
}

const vClickOutside = {
  mounted(el, binding) {
    el._clickOutsideHandler = (event) => {
      if (!(el === event.target || el.contains(event.target))) {
        binding.value();
      }
    };
    document.addEventListener('click', el._clickOutsideHandler);
  },
  unmounted(el) {
    document.removeEventListener('click', el._clickOutsideHandler);
    delete el._clickOutsideHandler;
  }
};



onMounted(async () => {
  startAuto();
  await Promise.allSettled([fetchBanners()]);
  await resetAndReload();  // ✅ 等待数据加载完成
  await setupInfiniteScroll();
  await setupFavInfiniteScroll();
  scrollContainer.value?.addEventListener("wheel", handleHeroWheel, { passive: false });

  // 设置数轴动画监听器
  setupAxisAnimationObserver();
  // 初始触发一次动画
  triggerOnlineAxisAnimation();

  // 设置主题动画监听器：滚到天安门主题区域时再触发文字浮现
  setupThemeAnimationObserver();

  // 处理路由参数：从收藏页面跳转时自动打开诗词详情
  // ⚠️ 在数据加载完成后处理，确保 list.value 已填充
  if (route.query.id) {
    // 先在当前列表中查找
    const item = list.value.find(p => p.id == route.query.id);
    if (item) {
      // 找到了，直接打开
      open(item);
    } else {
      // 当前列表中没有，直接获取详情
      try {
        const full = await fetchPoemDetail(route.query.id);
        open(full);
      } catch (e) {
        console.error('获取诗词详情失败:', e);
      }
    }
  }
  await fetchAuthorsByCategory(); 
});

// 监听路由参数变化
watch(() => route.query.id, async (newId) => {
  if (newId) {
    // 查找诗词并打开详情
    const item = list.value.find(p => p.id == newId);
    if (item) {
      open(item);
    } else {
      // 如果当前列表中没有，尝试获取诗词详情
      try {
        const full = await fetchPoemDetail(newId);
        open(full);  // fetchPoemDetail 已经返回了 normalizeOne 的结果
      } catch (e) {
        console.error('获取诗词详情失败:', e);
      }
    }
  }
});

onUnmounted(() => {
  stopAuto();
  stopAudio();
  if (io) io.disconnect();
  if (favIo) favIo.disconnect();
  if (axisObserver) axisObserver.disconnect();
  if (themeObserver) themeObserver.disconnect();
  scrollContainer.value?.removeEventListener("wheel", handleHeroWheel);
});

</script>

<style scoped>

.lib {
  width: 100%;
  margin: 0;
  padding: 0;
  position: relative;
  color: rgba(20, 20, 20, 0.92);
  height: 100vh;
  overflow: hidden;
}

.langSwitchBar {
  position: absolute;
  top: 14px;
  right: 18px;
  z-index: 80;
  display: inline-flex;
  gap: 8px;
}

.langBtn {
  border: 1px solid rgba(94, 69, 38, 0.3);
  background: rgba(255, 248, 235, 0.82);
  color: #5f4122;
  border-radius: 999px;
  padding: 4px 12px;
  font-size: 13px;
  cursor: pointer;
}

.langBtn.active {
  background: #7a4c21;
  color: #fff4e2;
}

.lib::before {
  content: "";
  position: fixed;
  inset: 0;
  background-color: #F5F5DC;
  background-size: cover;
  background-position: center;
  opacity: 1;
  z-index: -3;
}
.lib::after {
  content: "";
  position: fixed;
  inset: 0;
  background:
    radial-gradient(900px 520px at 18% 18%, rgba(120, 170, 150, 0.12), transparent 60%),
    radial-gradient(900px 520px at 82% 40%, rgba(140, 170, 220, 0.10), transparent 60%),
    radial-gradient(900px 520px at 50% 92%, rgba(230, 210, 170, 0.10), transparent 62%),
    linear-gradient(180deg, rgba(255, 255, 255, 0.18), rgba(255, 255, 255, 0.06));
  z-index: -2;
}

.scrollSections {
  height: 100vh;
  overflow-y: scroll;
  scroll-snap-type: y mandatory;
  scroll-behavior: smooth;
}

.scrollSections::-webkit-scrollbar {
  width: 6px;
}

.scrollSections::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.1);
  border-radius: 3px;
}

.scrollSections::-webkit-scrollbar-thumb {
  background: rgba(212, 175, 55, 0.3);
  border-radius: 3px;
}

.screenSection {
  height: 100vh;
  width: 100%;
  scroll-snap-align: start;
  scroll-snap-stop: always;
  position: relative;
  overflow-y: auto;
  overflow-x: hidden;
}

.heroScreen {
  display: flex;
  align-items: center;
  justify-content: center;
}

.heroScreen .heroCard {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.contentScreen {
  background: transparent;
  overflow-y: auto;
  padding-bottom: 30px;
}

.contentWrapper {
  width: 100%;
  max-width: 1560px;
  margin: 0 auto;
}

.searchSection {
  padding: 0 20px 16px;
  background: transparent;
}

.searchCenter {
  display: flex;
  justify-content: center;
  margin-bottom: 16px;
}

.searchBoxLight {
  display: flex;
  align-items: center;
  width: 60%;
  min-width: 300px;
  background: rgba(255, 255, 220, 0.85);
  backdrop-filter: blur(4px);
  border-radius: 48px;
  padding: 4px 8px 4px 20px;
  border: 1px solid rgba(0, 0, 0, 0.1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.searchBoxLight:focus-within {
  background: rgba(255, 255, 220, 0.95);
  border-color: rgba(138, 47, 43, 0.6);
}

.searchIconLight {
  font-size: 18px;
  color: #8b7355;
  margin-right: 8px;
}

.searchBoxLight input {
  flex: 1;
  background: transparent;
  border: none;
  outline: none;
  color: #2d2d2d;
  font-size: 15px;
  padding: 12px 0;
}

.searchBoxLight input::placeholder {
  color: #9d8b7a;
}

.searchSubmitBtnLight {
  background: rgba(255, 240, 238, 0.9);
  border: 1px solid rgba(138, 47, 43, 0.3);
  border-radius: 32px;
  padding: 8px 24px;
  color: #8B2323;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.searchSubmitBtnLight:hover {
  background: rgba(255, 240, 238, 1);
  border-color: rgba(138, 47, 43, 0.5);
  transform: translateY(-1px);
}

.actionButtons {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  flex-wrap: wrap;
}

.resetBtnLight, .shuffleBtnLight, .navTabInline {
  height: 36px;
  padding: 0 16px;
  border-radius: 32px;
  border: 1px solid rgba(138, 47, 43, 0.3);
  background: rgba(255, 240, 238, 0.8);
  cursor: pointer;
  font-weight: 600;
  font-size: 14px;
  color: #8B2323;
  transition: all 0.2s ease;
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.resetBtnLight:hover, .shuffleBtnLight:hover, .navTabInline:hover {
  background: rgba(255, 240, 238, 1);
  border-color: rgba(138, 47, 43, 0.5);
  transform: translateY(-1px);
}

.navTabInline.active {
  background: rgba(138, 47, 43, 0.85);
  border-color: rgba(138, 47, 43, 1);
  color: #fff;
}

.resetBtnLight {
  background: rgba(255, 240, 238, 0.9);
}

.worksBtn {
  background: rgba(255, 240, 238, 0.9) !important;
  border: 1px solid rgba(138, 47, 43, 0.3) !important;
  color: #8B2323 !important;
}

.worksBtn:hover {
  background: rgba(255, 240, 238, 1) !important;
  border-color: rgba(138, 47, 43, 0.5) !important;
  transform: translateY(-1px);
}

.shuffleBtnLight {
  background: rgba(255, 240, 238, 0.9);
  border: 1px solid rgba(138, 47, 43, 0.3);
  color: #8B2323;
}

.shuffleBtnLight:hover {
  background: rgba(255, 240, 238, 1);
  border-color: rgba(138, 47, 43, 0.5);
  transform: translateY(-1px);
}

.navTabWrapperInline {
  position: relative;
  display: inline-block;
}

.dropdownArrow {
  font-size: 10px;
  transition: transform 0.2s ease;
}

.dropdownArrow.up {
  transform: rotate(180deg);
}

.categoryDropdown {
  position: absolute;
  top: 100%;
  left: 0;
  margin-top: 8px;
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(12px);
  border-radius: 20px;
  padding: 16px 20px;
  min-width: 280px;
  z-index: 100;
  border: 1px solid rgba(0, 0, 0, 0.08);
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.12);
  max-height: 70vh;
  overflow-y: auto;
}

.categoryGroup {
  margin-bottom: 16px;
}

.categoryGroup:last-child {
  margin-bottom: 0;
}

.categoryTitle {
  font-size: 13px;
  font-weight: 700;
  color: #9d8b7a;
  margin-bottom: 10px;
  letter-spacing: 0.5px;
}

.categoryItems {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.categoryItem {
  padding: 6px 14px;
  border-radius: 30px;
  border: 1px solid rgba(0, 0, 0, 0.1);
  background: rgba(255, 255, 220, 0.6);
  font-size: 13px;
  font-weight: 500;
  color: #4a3b36;
  cursor: pointer;
  transition: all 0.2s ease;
}

.categoryItem:hover {
  background: rgba(205, 92, 92, 0.2);
  border-color: rgba(205, 92, 92, 0.4);
}

.categoryItem.active {
  background: rgba(205, 92, 92, 0.3);
  border-color: rgba(205, 92, 92, 0.5);
  color: #8B0000;
  font-weight: 600;
}

.bannerContainer {
  position: relative;
  width: 100%;
}

.navArrow {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: rgba(138, 47, 43, 0.55);
  backdrop-filter: blur(2px);
  border: 1px solid rgba(201, 64, 67, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 20;
  opacity: 0.7;
}

.navArrow:hover {
  background: rgba(138, 47, 43, 0.8);
  opacity: 1;
}

.leftArrow { left: 20px; }
.rightArrow { right: 20px; }

.bannerWrap {
  border-radius: 0;
  overflow: hidden;
  user-select: none;
  touch-action: pan-y;
  width: 100%;
}

.bannerTrack { display: flex; width: 100%; }

.banner {
  min-width: 100%;
  height: 100vh;
  position: relative;
  background: #1a1a1a;
}

/* 轮播背景图 - 透明度调高 */
.bannerBg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  opacity: 0.85;
  filter: blur(2px);
  transform: scale(1.05);
  transition: transform 0.3s ease;
}

.banner:hover .bannerBg {
  transform: scale(1.08);
}

/* 半透明遮罩，让文字更突出 */
.bannerOverlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.35);
  z-index: 1;
}

/* 竖排大字效果 - 前后交错排列 */
.verticalPoetryGrid {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 2;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 40px 20px;
  gap: 15px;
  pointer-events: none;
}

.verticalCol {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  flex: 1;
  height: 100%;
  gap: 12px;
  opacity: 0;
  animation: fadeInCol 0.8s ease forwards;
}

/* 前后交错效果 - 不同列不同位置偏移 */
.col1 { animation-delay: 0.05s; transform: translateZ(30px); margin-top: -20px; }
.col2 { animation-delay: 0.1s; transform: translateZ(25px); margin-top: 15px; }
.col3 { animation-delay: 0.15s; transform: translateZ(20px); margin-top: -10px; }
.col4 { animation-delay: 0.2s; transform: translateZ(15px); margin-top: 25px; }
.col5 { animation-delay: 0.25s; transform: translateZ(10px); margin-top: -5px; }
.col6 { animation-delay: 0.3s; transform: translateZ(5px); margin-top: 30px; }
.col7 { animation-delay: 0.35s; transform: translateZ(0px); margin-top: -15px; }
.col8 { animation-delay: 0.4s; transform: translateZ(-5px); margin-top: 20px; }
.col9 { animation-delay: 0.45s; transform: translateZ(-10px); margin-top: -8px; }
.col10 { animation-delay: 0.5s; transform: translateZ(-15px); margin-top: 35px; }
.col11 { animation-delay: 0.55s; transform: translateZ(-20px); margin-top: -12px; }
.col12 { animation-delay: 0.6s; transform: translateZ(-25px); margin-top: 18px; }
.col13 { animation-delay: 0.65s; transform: translateZ(-30px); margin-top: -3px; }
.col14 { animation-delay: 0.7s; transform: translateZ(-35px); margin-top: 28px; }
.col15 { animation-delay: 0.75s; transform: translateZ(-40px); margin-top: -6px; }

@keyframes fadeInCol {
  from {
    opacity: 0;
    transform: translateY(30px) translateZ(0);
  }
  to {
    opacity: 1;
    transform: translateY(0) translateZ(0);
  }
}

.char {
  font-family: "华文行书", "华文楷书", "KaiTi", "楷体", serif;
  font-size: 48px;
  font-weight: 600;
  color: #1a1a1a;
  text-shadow: 1px 1px 2px rgba(255, 255, 255, 0.9);
  letter-spacing: 8px;
  line-height: 1.3;
  transition: all 0.3s ease;
  white-space: nowrap;
  writing-mode: horizontal-tb;
}

/* 不同列不同字体大小，增加层次感 */
.col1 .char { font-size: 52px; }
.col2 .char { font-size: 48px; }
.col3 .char { font-size: 44px; }
.col4 .char { font-size: 50px; }
.col5 .char { font-size: 54px; }
.col6 .char { font-size: 42px; }
.col7 .char { font-size: 46px; }
.col8 .char { font-size: 44px; }
.col9 .char { font-size: 40px; }
.col10 .char { font-size: 48px; }
.col11 .char { font-size: 45px; }
.col12 .char { font-size: 52px; }
.col13 .char { font-size: 47px; }
.col14 .char { font-size: 50px; }
.col15 .char { font-size: 53px; }

.banner:hover .char {
  transform: translateX(3px);
  color: #2c2c2c;
}

.shine {
  position: absolute;
  inset: -30%;
  background: radial-gradient(600px 240px at 30% 30%, rgba(255,255,255,.15), transparent 55%);
  pointer-events: none;
  animation: shineMove 6s ease-in-out infinite;
  z-index: 3;
}

@keyframes shineMove {
  0% { transform: translateX(-6%) translateY(-2%); opacity: .45; }
  50% { transform: translateX(6%) translateY(2%); opacity: .65; }
  100% { transform: translateX(-6%) translateY(-2%); opacity: .45; }
}

.dots { 
  margin-top: 16px; 
  display: flex; 
  justify-content: center; 
  gap: 10px;
  padding-bottom: 20px;
}

.dot {
  width: 8px;
  height: 8px;
  border-radius: 999px;
  background: rgba(0,0,0,.3);
  cursor: pointer;
}

.dot.on {
  background: rgba(60,80,70,.85);
  width: 24px;
  border-radius: 4px;
}

.scrollHint {
  position: absolute;
  bottom: 30px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  animation: bounce 2s ease-in-out infinite;
  z-index: 10;
}

.scrollArrow {
  font-size: 16px;
  animation: bounceArrow 1.5s ease-in-out infinite;
}

@keyframes bounce {
  0%, 100% { transform: translateX(-50%) translateY(0); }
  50% { transform: translateX(-50%) translateY(8px); }
}

@keyframes bounceArrow {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(4px); }
}

.topicHero { margin-top: 14px; padding: 0 20px; }

.topicHeroCard {
  position: relative;
  height: 360px;
  border-radius: 24px;
  overflow: hidden;
  border: 1px solid rgba(0,0,0,.10);
  box-shadow: 0 22px 64px rgba(0,0,0,.12);
}

.topicBg {
  position: absolute;
  inset: -10%;
  background-size: cover;
  background-position: center;
  will-change: transform;
  transition: transform .1s linear;
}

.topicMask {
  position: absolute;
  inset: 0;
  background: radial-gradient(1200px 520px at 22% 68%, rgba(255,255,255,.06), transparent 60%),
              linear-gradient(90deg, rgba(0,0,0,.64) 0%, rgba(0,0,0,.2) 48%, rgba(0,0,0,.08) 100%);
}

.topicContent {
  position: absolute;
  left: 18px;
  bottom: 18px;
  color: rgba(255,255,255,.96);
  max-width: min(720px, 78vw);
}

.topicBadge {
  display: inline-flex;
  align-items: center;
  border-radius: 999px;
  color: #fff;
  height: 26px;
  padding: 0 10px;
  background: rgba(255,255,255,.18);
  border: 1px solid rgba(255,255,255,.26);
  font-size: 12px;
}

.topicTitle { margin-top: 10px; font-weight: 1000; font-size: 34px; }
.topicDesc { margin-top: 6px; opacity: .92; font-size: 13px; line-height: 1.7; }
.topicMeta { margin-top: 10px; display: flex; flex-wrap: wrap; gap: 8px; }

.pillDark {
  display: inline-flex;
  align-items: center;
  border-radius: 999px;
  color: #fff;
  padding: 6px 10px;
  background: rgba(255,255,255,.14);
  border: 1px solid rgba(255,255,255,.22);
  font-size: 12px;
}

.topicOps { margin-top: 12px; display: flex; gap: 10px; flex-wrap: wrap; }

.tbtn {
  height: 38px;
  padding: 0 14px;
  border-radius: 14px;
  border: 1px solid rgba(255,255,255,.28);
  background: rgba(255,255,255,.14);
  color: #fff;
  cursor: pointer;
  font-weight: 1000;
}

.tbtn.primary { background: linear-gradient(135deg, #b32418, #7a1b14); color: #fff; }
.tbtn.ghost { background: rgba(179, 36, 24, 0.12); color: #7a1b14; }

.topicCorner {
  position: absolute;
  right: -60px;
  top: -60px;
  width: 220px;
  height: 220px;
  border-radius: 999px;
  background: radial-gradient(circle at 30% 30%, rgba(255,255,255,.2), transparent 55%);
}

.gridWrap, .listWrap {
  margin-top: 14px;
  padding: 14px 20px;
  background: transparent;
}

.gridHead, .listHead {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  margin-bottom: 12px;
}

.count, .listTitle { font-weight: 1000; }
.muted { opacity: .68; font-size: 12px; }

.grid { display: grid; grid-template-columns: repeat(6, 1fr); gap: 14px; }

.card {
  border-radius: 20px;
  overflow: hidden;
  background: rgba(255,255,220,.3);
  border: 1px solid rgba(0,0,0,.10);
  cursor: pointer;
  transition: .22s;
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 52px rgba(0,0,0,.14);
}

.poster {
  position: relative;
  height: 250px;
  background-size: cover;
  background-position: center;
}

.posterMask {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(0,0,0,.10) 0%, rgba(0,0,0,.16) 38%, rgba(0,0,0,.44) 100%);
}

.posterMask.strong {
  background: linear-gradient(180deg, rgba(0,0,0,.08) 0%, rgba(0,0,0,.10) 35%, rgba(0,0,0,.38) 100%);
}

.badges, .pBadges {
  position: absolute;
  top: 10px;
  left: 10px;
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  z-index: 2;
}

.badge {
  padding: 4px 8px;
  border-radius: 999px;
  background: rgba(0,0,0,.55);
  color: #fff;
  font-size: 12px;
  font-weight: 1000;
}

.badge.soft {
  background: rgba(255,255,255,.16);
  border: 1px solid rgba(255,255,255,.22);
}

.rating {
  position: absolute;
  bottom: 10px;
  left: 10px;
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 10px;
  border-radius: 999px;
  background: rgba(255,255,255,.62);
  z-index: 2;
}

.star { color: #b86b2f; }
.score { font-weight: 1000; }
.muted2 { opacity: .72; font-size: 12px; }

.hover {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  justify-content: end;
  gap: 8px;
  padding: 12px;
  opacity: 0;
  transform: translateY(8px);
  transition: .2s;
  color: #4a3b36;
  z-index: 3;
  background: linear-gradient(180deg, transparent 0%, rgba(255,255,255,.95) 100%);
  border-radius: 20px;
}

.card:hover .hover {
  opacity: 1;
  transform: translateY(0);
}

.hTitle { font-weight: 1000; font-size: 15px; }
.hMeta, .hLine { font-size: 12px; opacity: .8; }
.hActions { display: flex; gap: 8px; margin-top: 4px; }

.hBtn {
  height: 32px;
  padding: 0 14px;
  border-radius: 999px;
  border: 1px solid rgba(138, 47, 43, 0.3);
  background: rgba(255, 240, 238, 0.9);
  cursor: pointer;
  font-weight: 600;
  color: #8B2323;
  transition: all 0.2s ease;
}

.hBtn:hover {
  background: linear-gradient(135deg, #b32418, #7a1b14);
  color: #fff;
  border-color: transparent;
  transform: translateY(-1px);
}

.hBtn.ghost {
  background: rgba(255, 240, 238, 0.8);
  border: 1px solid rgba(138, 47, 43, 0.25);
}

.hBtn.ghost:hover {
  background: rgba(138, 47, 43, 0.15);
}

.info {
  padding: 12px 12px 14px;
  background: linear-gradient(180deg, #f4ecd8 0%, #e8dcc0 100%);
}

.title { font-weight: 1000; font-size: 15px; }
.meta { opacity: .74; font-size: 12px; margin-top: 2px; }
.tags { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 8px; }

.tag, .pillLite {
  padding: 5px 9px;
  border-radius: 999px;
  background: rgba(60,80,70,.10);
  border: 1px solid rgba(60,80,70,.16);
  font-size: 12px;
}

.empty {
  padding: 22px;
  border-radius: 18px;
  background: rgba(255,255,255,.24);
  border: 1px solid rgba(0,0,0,.10);
}

.emptyTitle { font-weight: 1000; font-size: 16px; }
.emptySub { margin-top: 6px; opacity: .74; font-size: 12px; }

.loadMore { margin-top: 16px; display: flex; justify-content: center; align-items: center; padding: 18px 0; }

.loadMoreBtn {
  height: 40px;
  padding: 0 24px;
  border-radius: 32px;
  border: 1px solid rgba(138, 47, 43, 0.3);
  background: rgba(255, 240, 238, 0.9);
  cursor: pointer;
  font-weight: 600;
  font-size: 14px;
  color: #8B2323;
  transition: all 0.2s ease;
}

.loadMoreBtn:hover {
  background: linear-gradient(135deg, #b32418, #7a1b14);
  color: #fff;
  border-color: transparent;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(138, 47, 43, 0.3);
}

.catGridExtended {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 14px;
}

.catPanel {
  border-radius: 18px;
  background: rgba(255,255,255,.26);
  border: 1px solid rgba(0,0,0,.08);
  padding: 14px;
}

.catT {
  font-weight: 1000;
  margin-bottom: 12px;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 6px;
  border-bottom: 1px solid rgba(0,0,0,.08);
  padding-bottom: 8px;
}

.catItems {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.catItem {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 12px;
  border-radius: 999px;
  border: 1px solid rgba(0,0,0,.08);
  background: rgba(255,255,255,.5);
  cursor: pointer;
  font-size: 13px;
}

.catItem:hover {
  background: rgba(138, 47, 43, 0.15);
}

.catKey { font-weight: 600; }
.catCnt {
  padding: 2px 6px;
  border-radius: 999px;
  background: rgba(0,0,0,.06);
  font-size: 11px;
}

.emptyCat {
  padding: 12px;
  text-align: center;
  color: rgba(0,0,0,.4);
  font-size: 12px;
  width: 100%;
}

.pExtRow {
  margin-top: 14px;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.authorGrid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 16px;
}

.authorCard {
  text-align: left;
  border-radius: 18px;
  background: rgba(255,255,255,.26);
  border: 1px solid rgba(0,0,0,.08);
  padding: 12px 16px;
  cursor: pointer;
}

.authorCard:hover {
  transform: translateY(-2px);
  box-shadow: 0 18px 46px rgba(0,0,0,.12);
}

.authorCardInner {
  display: flex;
  align-items: center;
  gap: 18px;
}

.authorLeft {
  flex: 0 0 auto;
  min-width: 140px;
}

.authorRight {
  flex: 1 1 auto;
  min-width: 0;
  display: flex;
  align-items: center;
  gap: 24px;
}

.authorRightMain {
  flex: 1 1 auto;
  min-width: 0;
}

.authorMoreRow {
  flex: 0 0 auto;
}

.authorMoreBtn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 8px 20px;
  border-radius: 999px;
  background: rgba(255, 240, 238, 0.96);
  border: 1px solid rgba(179, 36, 24, 0.25);
  font-size: 13px;
  font-weight: 600;
  color: #7a1b14;
  cursor: pointer;
  transition: all 0.2s ease;
}

.authorMoreBtn:hover {
  background: linear-gradient(135deg, #b32418, #7a1b14);
  border-color: transparent;
  color: #fff;
  transform: translateY(-1px);
}

.authorAvatar {
  width: 112px;
  height: 112px;
  border-radius: 50%;
  border: 2px solid rgba(179, 36, 24, 0.9);
  background: rgba(179, 36, 24, 0.06);
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.authorAvatarText {
  padding: 0 8px;
  font-size: 20px;
  font-weight: 700;
  color: #7a1b14;
  line-height: 1.4;
  text-align: center;
  writing-mode: vertical-rl;
  text-orientation: upright;
}

.authorTop {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  gap: 10px;
}

.authorName { font-weight: 1000; font-size: 15px; }
.authorCnt { opacity: .72; font-size: 12px; }
.authorMeta { margin-top: 8px; display: flex; flex-wrap: wrap; gap: 8px; }
.authorQuote { margin-top: 10px; opacity: .86; font-size: 12px; line-height: 1.7; }
.authorPoemSection {
  margin-top: 12px;
  padding: 12px 16px;
  background: rgba(255, 255, 255, 0.6);
  border-radius: 10px;
  border: 1px solid rgba(138, 47, 43, 0.12);
}
.authorPoemTitle {
  font-size: 15px;
  font-weight: 700;
  color: #6d211d;
  margin-bottom: 8px;
}
.authorPoemContent {
  font-size: 13px;
  line-height: 1.85;
  color: #444;
  white-space: pre-line;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 6;
  overflow: hidden;
}

.modal {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,.42);
  backdrop-filter: blur(10px);
  z-index: 999;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
}

.panel {
  width: min(1180px, 96vw);
  max-height: 90vh;
  overflow: auto;
  border-radius: 28px;
  background: rgba(255,255,255,.95);
  border: 1px solid rgba(0,0,0,.12);
  box-shadow: 0 26px 70px rgba(0,0,0,.22);
}

.detailHero {
  display: grid;
  grid-template-columns: 380px 1fr;
  gap: 18px;
  padding: 18px;
}

.detailCover {
  height: 320px;
  border-radius: 22px;
  overflow: hidden;
  position: relative;
  background-size: cover;
  background-position: center;
}

.detailMain {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-width: 0;
}

.titleRow {
  display: flex;
  align-items: start;
  justify-content: space-between;
  gap: 12px;
}

.pTitle { font-weight: 1000; font-size: 32px; line-height: 1.2; }
.pMeta { margin-top: 6px; opacity: .72; font-size: 15px; }
.pRow { margin-top: 14px; display: flex; flex-wrap: wrap; gap: 8px; }

.pill {
  padding: 7px 12px;
  border-radius: 999px;
  background: rgba(60,80,70,.12);
  border: 1px solid rgba(60,80,70,.18);
  font-size: 12px;
  font-weight: 900;
}

.pQuote {
  margin-top: 18px;
  padding: 16px 18px;
  border-radius: 18px;
  background: rgba(255,255,255,.6);
  border: 1px solid rgba(0,0,0,.08);
  font-weight: 1000;
  font-size: 18px;
  line-height: 1.8;
}

.pBtns {
  margin-top: 18px;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.close {
  width: 40px;
  height: 40px;
  border-radius: 999px;
  border: 1px solid rgba(138, 47, 43, 0.3);
  background: rgba(255, 240, 238, 0.9);
  color: #8B2323;
  cursor: pointer;
  font-size: 22px;
  transition: all 0.2s ease;
}

.close:hover {
  background: linear-gradient(135deg, #b32418, #7a1b14);
  color: #fff;
  border-color: transparent;
}

.pBody {
  padding: 0 18px 18px;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.readCard {
  padding: 18px;
  border-radius: 22px;
  background: rgba(255,255,255,.6);
  border: 1px solid rgba(0,0,0,.08);
}

.poemCard {
  grid-column: 1 / -1;
}

.secHead {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}

.secT { font-weight: 1000; font-size: 18px; }
.secSub { opacity: .45; font-size: 12px; text-transform: uppercase; }
.poem { white-space: pre-wrap; line-height: 2.15; font-weight: 900; font-size: 18px; }
.text { white-space: pre-wrap; line-height: 1.95; font-size: 14px; }
.chips { display: flex; flex-wrap: wrap; gap: 10px; }
.chip {
  padding: 7px 12px;
  border-radius: 999px;
  background: rgba(0,0,0,.05);
  border: 1px solid rgba(0,0,0,.08);
  font-size: 12px;
}
.emptyText { opacity: .58; line-height: 1.8; min-height: 64px; display: flex; align-items: center; }

.authorGrid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 16px;
}

@media (max-width: 1400px) {
  .grid { grid-template-columns: repeat(5, 1fr); }
  .authorGrid { grid-template-columns: 1fr; }
  .catGridExtended { grid-template-columns: repeat(3, 1fr); }
  .char { font-size: 40px !important; }
  .verticalPoetryGrid { padding: 30px 15px; gap: 12px; }
  .verticalCol { gap: 10px; }
}

@media (max-width: 1200px) {
  .grid { grid-template-columns: repeat(4, 1fr); }
  .catGridExtended { grid-template-columns: repeat(2, 1fr); }
  .authorGrid { grid-template-columns: 1fr; }
  .detailHero { grid-template-columns: 1fr; }
  .pBody { grid-template-columns: 1fr; }
  .searchBoxLight { width: 80%; }
  .char { font-size: 32px !important; }
  .verticalPoetryGrid { padding: 20px 10px; gap: 10px; }
  .verticalCol { gap: 8px; }
}

@media (max-width: 860px) {
  .grid { grid-template-columns: repeat(2, 1fr); }
  .authorGrid { grid-template-columns: 1fr; }
  .catGridExtended { grid-template-columns: 1fr; }
  .banner { height: 100vh; }
  .topicHeroCard { height: 280px; }
  .topicTitle { font-size: 26px; }
  .detailCover { height: 220px; }
  .pTitle { font-size: 24px; }
  .poem { font-size: 16px; }
  .searchBoxLight { width: 100%; min-width: auto; }
  .actionButtons { justify-content: center; }
  .navArrow { width: 28px; height: 28px; }
  .leftArrow { left: 10px; }
  .rightArrow { right: 10px; }
  .verticalPoetryGrid {
    flex-wrap: wrap;
    align-items: flex-start;
    justify-content: flex-start;
    gap: 8px;
    padding: 20px 10px;
  }
  .verticalCol {
    flex-direction: row;
    flex-wrap: wrap;
    gap: 6px;
    height: auto;
    margin-top: 0 !important;
  }
  .char {
    font-size: 24px !important;
    display: inline-block;
  }
}

@media (max-width: 480px) {
  .char {
    font-size: 18px !important;
  }
  .verticalCol {
    gap: 4px;
  }
  .verticalPoetryGrid {
    gap: 6px;
  }
}


/* ===== 来自第一页的首屏样式 ===== */

.lib {
  width: 100%;
  margin: 0;
  padding: 0;
  position: relative;
  color: rgba(20, 20, 20, 0.92);
  height: 100vh;
  overflow: hidden;
}

.lib::before {
  content: "";
  position: fixed;
  inset: 0;
  background-image: var(--paper);
  background-size: cover;
  background-position: center;
  opacity: 1;
  z-index: -3;
}

.lib::after {
  content: "";
  position: fixed;
  inset: 0;
  background:
    radial-gradient(900px 520px at 18% 18%, rgba(120, 170, 150, 0.12), transparent 60%),
    radial-gradient(900px 520px at 82% 40%, rgba(140, 170, 220, 0.1), transparent 60%),
    radial-gradient(900px 520px at 50% 92%, rgba(230, 210, 170, 0.1), transparent 62%),
    linear-gradient(180deg, rgba(255, 255, 255, 0.18), rgba(255, 255, 255, 0.06));
  z-index: -2;
}

.scrollSections {
  height: 100vh;
  overflow-y: auto;
  scroll-behavior: auto;
  scroll-snap-type: none;
  overscroll-behavior-y: contain;
}

.scrollSections::-webkit-scrollbar {
  width: 6px;
}

.scrollSections::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.1);
  border-radius: 3px;
}

.scrollSections::-webkit-scrollbar-thumb {
  background: rgba(212, 175, 55, 0.3);
  border-radius: 3px;
}

.scrollSections::-webkit-scrollbar-thumb:hover {
  background: rgba(212, 175, 55, 0.5);
}

.screenSection {
  min-height: 100vh;
  width: 100%;
  position: relative;
  overflow: hidden;
}

.heroScreen {
  height: 100vh;
  min-height: 100vh;
}

.heroStage {
  position: relative;
  width: 100%;
  height: 100vh;
  overflow: hidden;
  background: #111;
}

.heroMedia {
  position: absolute;
  inset: 0;
}
.heroBgLayer {
  position: absolute;
  inset: 0;
  opacity: 0;
  pointer-events: none;
  overflow: hidden;
  z-index: 1;
}
.heroBgLayer {
  position: absolute;
  inset: 0;
  opacity: 0;
  pointer-events: none;
  overflow: hidden;
  z-index: 1;
}

.heroBgLayer.previous {
  opacity: 1;
  z-index: 2;
  pointer-events: none;
}

.heroBgLayer img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transform: scale(1.008) translateZ(0);
  opacity: 0;
  will-change: transform, opacity;
  backface-visibility: hidden;
}
.heroBgLayer.current {
  opacity: 1;
  z-index: 3;
  pointer-events: auto;
  cursor: pointer;
}

.heroBgLayer.current img {
  animation: heroCurrentReveal 0.32s ease-out both;
}
.heroBgLayer.previous {
  opacity: 1;
  z-index: 2;
  pointer-events: none;
}
.heroBgLayer.previous img {
  animation: heroFadeOld 0.22s linear both;
}

@keyframes heroCurrentReveal {
  0% {
    transform: scale(1.006) translateZ(0);
    opacity: 0.94;
  }
  100% {
    transform: scale(1) translateZ(0);
    opacity: 1;
  }
}

@keyframes heroFadeOld {
  0% {
    transform: scale(1) translateZ(0);
    opacity: 1;
  }
  100% {
    transform: scale(1.002) translateZ(0);
    opacity: 0;
  }
}

.heroExpandGhost {
  position: absolute;
  inset: 0;
  z-index: 6;
  overflow: hidden;
  box-shadow: 0 28px 72px rgba(0, 0, 0, 0.32);
  transform-origin: top left;
  pointer-events: none;
  will-change: transform, opacity, border-radius;
  transition:
    transform 420ms cubic-bezier(0.22, 0.8, 0.22, 1),
    border-radius 420ms cubic-bezier(0.22, 0.8, 0.22, 1),
    opacity 80ms linear;
  backface-visibility: hidden;
}

.heroExpandGhost.expanding,
.heroExpandGhost.fading {
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.16);
}

.heroExpandGhost img {
  width: 100%;
  height: 100%;
  display: block;
  object-fit: cover;
  transform: scale(1.0001) translateZ(0);
  backface-visibility: hidden;
}

.heroShade {
  position: absolute;
  inset: 0;
  z-index: 4;
  background:
    linear-gradient(90deg, rgba(0, 0, 0, 0.18) 0%, rgba(0, 0, 0, 0.04) 42%, rgba(0, 0, 0, 0.06) 100%),
    linear-gradient(180deg, rgba(0, 0, 0, 0.02) 0%, rgba(0, 0, 0, 0.12) 100%);
  pointer-events: none;
}

.heroVignette {
  position: absolute;
  inset: 0;
  z-index: 5;
  background:
    radial-gradient(900px 420px at 18% 30%, rgba(255, 255, 255, 0.08), transparent 60%),
    radial-gradient(1200px 300px at 60% 100%, rgba(0, 0, 0, 0.12), transparent 62%);
  pointer-events: none;
}

.heroContent {
  position: absolute;
  left: 64px;
  top: 110px;
  z-index: 8;
  width: min(540px, 42vw);
  color: #fff;
}

.heroLine {
  width: 34px;
  height: 4px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.92);
  margin-bottom: 18px;
}

.heroTopText {
  font-size: 15px;
  font-weight: 700;
  opacity: 0.92;
  margin-bottom: 10px;
}

.heroMiniTitle {
  font-size: 24px;
  font-weight: 900;
  opacity: 0.95;
  margin-bottom: 20px;
}

.heroTitle {
  margin: 0;
  font-size: 78px;
  line-height: 1.04;
  font-weight: 1000;
  letter-spacing: 0.01em;
  text-shadow: 0 8px 24px rgba(0, 0, 0, 0.18);
}

.heroDesc {
  margin-top: 22px;
  font-size: 18px;
  line-height: 1.9;
  color: rgba(255, 255, 255, 0.9);
  max-width: 520px;
}

.heroActions {
  margin-top: 28px;
  display: flex;
  align-items: center;
  gap: 14px;
}

.heroMainBtn,
.heroGhostBtn {
  height: 46px;
  padding: 0 22px;
  border-radius: 999px;
  font-size: 14px;
  font-weight: 800;
  cursor: pointer;
  transition: all 0.22s ease;
}

.heroMainBtn {
  border: none;
  background: linear-gradient(135deg, #b32418, #7a1b14);
  color: #fff;
  box-shadow: 0 10px 24px rgba(138, 47, 43, 0.35);
}

.heroMainBtn:hover {
  transform: translateY(-1px);
  box-shadow: 0 12px 28px rgba(138, 47, 43, 0.45);
}

.heroGhostBtn {
  border: 1px solid rgba(138, 47, 43, 0.5);
  background: rgba(138, 47, 43, 0.15);
  color: #b32418;
  backdrop-filter: blur(6px);
}

.heroGhostBtn:hover {
  background: rgba(138, 47, 43, 0.25);
  transform: translateY(-1px);
}

.heroCardsWrap {
  position: absolute;
  right: 56px;
  bottom: 88px;
  z-index: 12;
  width: auto;
  max-width: 58vw;
  overflow: visible;
}

.heroCardsTrack {
  display: flex;
  align-items: flex-end;
  justify-content: flex-end;
  gap: 18px;
  padding: 0;
  position: relative;
}

.heroFloatCard {
  position: relative;
  flex: 0 0 auto;
  width: 200px;
  height: 270px;
  border: none;
  border-radius: 22px;
  overflow: hidden;
  padding: 0;
  background: rgba(255, 255, 255, 0.06);
  cursor: pointer;
  box-shadow: 0 18px 42px rgba(0, 0, 0, 0.22);
  opacity: 1;
  transform: translate3d(0, 0, 0);
  transition: transform 0.22s ease, box-shadow 0.22s ease, filter 0.22s ease, opacity 0.16s ease;
  will-change: transform;
}

.heroFloatCard.ghosting {
  opacity: 0;
  box-shadow: none;
}

.heroFloatCard:hover {
  transform: translateY(-6px);
  box-shadow: 0 24px 52px rgba(0, 0, 0, 0.28);
}

.heroFloatCard.sourceHidden {
  opacity: 0;
  transform: translateY(0) scale(0.98);
  pointer-events: none;
}

.heroFloatCard img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transform: scale(1);
  transition: transform 0.35s ease;
}

.heroFloatCard:hover img {
  transform: scale(1.03);
}

/* 核心：卡片排队依次向前滑动的“跟随感” */
/* .hero-cards-move 用于控制列表项位置交换时的 FLIP 动画 */
.hero-cards-move {
  /* 使用较长的动画时间和带有回弹感的曲线，让移动更顺滑 */
  transition: transform 1.2s cubic-bezier(0.2, 1, 0.2, 1) !important;
}

/* 关键：通过 nth-child 为不同位置的卡片设置不同的移动延迟 */
/* 这样当第一张离开后，后面的卡片会按照位置顺序依次开始滑动 */
.hero-cards-move:nth-child(1) { transition-delay: 0s !important; }
.hero-cards-move:nth-child(2) { transition-delay: 0.1s !important; }
.hero-cards-move:nth-child(3) { transition-delay: 0.2s !important; }
.hero-cards-move:nth-child(4) { transition-delay: 0.3s !important; }
.hero-cards-move:nth-child(5) { transition-delay: 0.4s !important; }

/* 入场效果 */
.hero-cards-enter-active {
  transition: all 0.8s cubic-bezier(0.2, 1, 0.2, 1);
  /* 新卡片总是进入队尾，所以它的延迟应该是最久的，等前面全部挪完再进 */
  transition-delay: 0.5s;
}

.hero-cards-enter-from {
  opacity: 0;
  transform: translateX(100px) scale(0.9);
}

/* 离场效果 */
.hero-cards-leave-active {
  position: absolute; /* 必须设为 absolute 以触发布局变化，从而触发 move 动画 */
  transition: all 0.5s cubic-bezier(0.2, 1, 0.2, 1);
  opacity: 0;
  transform: translateX(-150px) scale(0.8);
  pointer-events: none;
  z-index: 0;
}

.hero-cards-enter-from {
  opacity: 0;
  /* 从右侧较远处、略微缩小的状态滑入 */
  transform: translateX(120px) scale(0.9);
}

.heroFloatMask {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, 0.02) 0%, rgba(0, 0, 0, 0.08) 42%, rgba(0, 0, 0, 0.32) 100%);
}

.heroBottomOps {
  position: absolute;
  left: 64px;
  bottom: 42px;
  z-index: 10;
  display: flex;
  align-items: center;
  gap: 12px;
}

.heroMiniSwitch {
  height: 42px;
  padding: 0 18px;
  border-radius: 999px;
  border: 1px solid rgba(138, 47, 43, 0.4);
  background: rgba(138, 47, 43, 0.75);
  color: #fff;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
  backdrop-filter: blur(8px);
  transition: all 0.2s ease;
}

.heroMiniSwitch:hover {
  background: rgba(138, 47, 43, 0.85);
  transform: translateY(-1px);
}

.contentScreen {
  background: transparent;
  overflow-y: auto;
  padding-bottom: 30px;
}

.contentWrapper {
  width: 100%;
  max-width: 1560px;
  margin: 0 auto;
}

.searchSection {
  padding: 20px 20px 16px;
  background: transparent;
}

.searchCenter {
  display: flex;
  justify-content: center;
  margin-bottom: 16px;
}

.searchBoxLight {
  display: flex;
  align-items: center;
  width: 60%;
  min-width: 300px;
  background: rgba(244, 236, 216, 0.9);
  backdrop-filter: blur(4px);
  border-radius: 48px;
  padding: 4px 8px 4px 20px;
  border: 1px solid rgba(0, 0, 0, 0.1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.searchBoxLight:focus-within {
  background: rgba(244, 236, 216, 0.98);
  border-color: rgba(138, 47, 43, 0.6);
  box-shadow: 0 4px 12px rgba(138, 47, 43, 0.15);
}

.searchIconLight {
  font-size: 18px;
  color: #8b7355;
  margin-right: 8px;
}

.searchBoxLight input {
  flex: 1;
  background: transparent;
  border: none;
  outline: none;
  color: #2d2d2d;
  font-size: 15px;
  padding: 12px 0;
}

.searchBoxLight input::placeholder {
  color: #9d8b7a;
}

.searchSubmitBtnLight {
  background: rgba(255, 240, 238, 0.9);
  border: 1px solid rgba(138, 47, 43, 0.3);
  border-radius: 32px;
  padding: 8px 24px;
  color: #8B2323;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.searchSubmitBtnLight:hover {
  background: rgba(255, 240, 238, 1);
  border-color: rgba(138, 47, 43, 0.5);
  transform: translateY(-1px);
}

.actionButtons {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  flex-wrap: wrap;
}

.resetBtnLight,
.shuffleBtnLight {
  padding: 8px 20px;
  border-radius: 32px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 14px;
}

.resetBtnLight {
  background: rgba(255, 240, 238, 0.9);
  border: 1px solid rgba(138, 47, 43, 0.3);
  color: #8B2323;
}

.resetBtnLight:hover {
  background: rgba(255, 240, 238, 1);
  border-color: rgba(138, 47, 43, 0.5);
  transform: translateY(-1px);
}

.shuffleBtnLight {
  background: rgba(255, 240, 238, 0.9);
  border: 1px solid rgba(138, 47, 43, 0.3);
  color: #8B2323;
}

.shuffleBtnLight:hover {
  background: rgba(255, 240, 238, 1);
  border-color: rgba(138, 47, 43, 0.5);
  transform: translateY(-1px);
}

.topicHero {
  margin-top: 14px;
  padding: 0 20px;
}

.topicHeroCard {
  position: relative;
  height: 360px;
  border-radius: 24px;
  overflow: hidden;
  border: 1px solid rgba(0, 0, 0, 0.1);
  box-shadow: 0 22px 64px rgba(0, 0, 0, 0.12);
}

.topicBg {
  position: absolute;
  inset: -10%;
  background-size: cover;
  background-position: center;
  will-change: transform;
  transition: transform 0.1s linear;
}

.topicMask {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(1200px 520px at 22% 68%, rgba(255, 255, 255, 0.06), transparent 60%),
    linear-gradient(90deg, rgba(0, 0, 0, 0.64) 0%, rgba(0, 0, 0, 0.2) 48%, rgba(0, 0, 0, 0.08) 100%);
}

.topicContent {
  position: absolute;
  left: 18px;
  bottom: 18px;
  color: rgba(255, 255, 255, 0.96);
  max-width: min(720px, 78vw);
}

.topicBadge,
.pillDark {
  display: inline-flex;
  align-items: center;
  border-radius: 999px;
  color: #fff;
}

.topicBadge {
  height: 26px;
  padding: 0 10px;
  background: rgba(255, 255, 255, 0.18);
  border: 1px solid rgba(255, 255, 255, 0.26);
  font-size: 12px;
}

.topicTitle {
  margin-top: 10px;
  font-weight: 1000;
  font-size: 34px;
}

.topicDesc {
  margin-top: 6px;
  opacity: 0.92;
  font-size: 13px;
  line-height: 1.7;
}

.topicMeta {
  margin-top: 10px;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.pillDark {
  padding: 6px 10px;
  background: rgba(255, 255, 255, 0.14);
  border: 1px solid rgba(255, 255, 255, 0.22);
  font-size: 12px;
}

.topicOps {
  margin-top: 12px;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.tbtn {
  height: 38px;
  padding: 0 14px;
  border-radius: 14px;
  border: 1px solid rgba(138, 47, 43, 0.4);
  background: rgba(138, 47, 43, 0.15);
  color: #b32418;
  cursor: pointer;
  font-weight: 1000;
}

.tbtn.primary {
  background: linear-gradient(135deg, #b32418, #7a1b14);
  color: #fff;
  border-color: transparent;
}

.tbtn.ghost {
  background: rgba(179, 36, 24, 0.12);
  color: #7a1b14;
}

.topicCorner {
  position: absolute;
  right: -60px;
  top: -60px;
  width: 220px;
  height: 220px;
  border-radius: 999px;
  background: radial-gradient(circle at 30% 30%, rgba(255, 255, 255, 0.2), transparent 55%);
}

.gridWrap,
.listWrap {
  margin-top: 14px;
  padding: 14px 20px;
  border-radius: 0;
  background: transparent;
  border: none;
  box-shadow: none;
}

.gridHead,
.listHead {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  margin-bottom: 12px;
  flex-wrap: wrap;
}

.count,
.listTitle {
  font-weight: 1000;
}

.muted {
  opacity: 0.68;
  font-size: 12px;
}

.grid {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 14px;
}

.card {
  border-radius: 20px;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.3);
  border: 1px solid rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: 0.22s;
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 52px rgba(0, 0, 0, 0.14);
}

.poster {
  position: relative;
  height: 250px;
  background-size: cover;
  background-position: center;
}

.posterMask {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, 0.1) 0%, rgba(0, 0, 0, 0.16) 38%, rgba(0, 0, 0, 0.44) 100%);
}

.posterMask.strong {
  background: linear-gradient(180deg, rgba(0, 0, 0, 0.08) 0%, rgba(0, 0, 0, 0.1) 35%, rgba(0, 0, 0, 0.38) 100%);
}

.badges,
.pBadges {
  position: absolute;
  top: 10px;
  left: 10px;
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  z-index: 2;
}

.badge {
  padding: 4px 8px;
  border-radius: 999px;
  background: rgba(0, 0, 0, 0.55);
  color: #fff;
  font-size: 12px;
  font-weight: 1000;
}

.badge.soft {
  background: rgba(255, 255, 255, 0.16);
  border: 1px solid rgba(255, 255, 255, 0.22);
}

.rating {
  position: absolute;
  bottom: 10px;
  left: 10px;
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 10px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.62);
  z-index: 2;
}

.star {
  color: #b86b2f;
}

.score {
  font-weight: 1000;
}

.muted2 {
  opacity: 0.72;
  font-size: 12px;
}

.hover {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  justify-content: end;
  gap: 8px;
  padding: 12px;
  opacity: 0;
  transform: translateY(8px);
  transition: 0.2s;
  color: #fff;
  z-index: 3;
}

.card:hover .hover {
  opacity: 1;
  transform: translateY(0);
}

.hTitle {
  font-weight: 1000;
  font-size: 15px;
}

.hMeta,
.hLine {
  font-size: 12px;
  opacity: 0.9;
}

.hActions {
  display: flex;
  gap: 8px;
  margin-top: 4px;
}

.hBtn {
  height: 32px;
  padding: 0 10px;
  border-radius: 12px;
  border: 1px solid rgba(138, 47, 43, 0.35);
  background: rgba(138, 47, 43, 0.15);
  color: #fff;
  cursor: pointer;
}

.hBtn.ghost {
  background: rgba(138, 47, 43, 0.25);
}

.info {
  padding: 12px 12px 14px;
  background: linear-gradient(180deg, #f4ecd8 0%, #e8dcc0 100%);
}

.title {
  font-weight: 1000;
  font-size: 15px;
}

.meta {
  opacity: 0.74;
  font-size: 12px;
  margin-top: 2px;
}

.tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-top: 8px;
}

.tag,
.pillLite {
  padding: 5px 9px;
  border-radius: 999px;
  background: rgba(60, 80, 70, 0.1);
  border: 1px solid rgba(60, 80, 70, 0.16);
  font-size: 12px;
}

.empty {
  padding: 22px;
  border-radius: 18px;
  background: rgba(255, 255, 255, 0.24);
  border: 1px solid rgba(0, 0, 0, 0.1);
}

.emptyTitle {
  font-weight: 1000;
  font-size: 16px;
}

.emptySub {
  margin-top: 6px;
  opacity: 0.74;
  font-size: 12px;
}

.loadMore {
  margin-top: 16px;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 18px 0;
}

.catGrid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 12px;
}

.catPanel {
  border-radius: 18px;
  background: rgba(255, 255, 255, 0.26);
  border: 1px solid rgba(0, 0, 0, 0.08);
  padding: 12px;
}

.catT {
  font-weight: 1000;
  margin-bottom: 10px;
}

.catItems {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.catKey {
  opacity: 0.92;
}

.catCnt {
  padding: 2px 8px;
  border-radius: 999px;
  background: rgba(0, 0, 0, 0.06);
  font-size: 12px;
}

.authorGrid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 16px;
}

.authorCard {
  text-align: left;
  border-radius: 18px;
  background: rgba(255, 255, 255, 0.26);
  border: 1px solid rgba(0, 0, 0, 0.08);
  padding: 12px;
  cursor: pointer;
  transition: 0.18s;
}

.authorCard:hover {
  transform: translateY(-2px);
  box-shadow: 0 18px 46px rgba(0, 0, 0, 0.12);
}

.authorTop {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  gap: 10px;
}

.authorName {
  font-weight: 1000;
  font-size: 15px;
}

.authorCnt {
  opacity: 0.72;
  font-size: 12px;
}

.authorMeta {
  margin-top: 8px;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.authorQuote {
  margin-top: 10px;
  opacity: 0.86;
  font-size: 12px;
  line-height: 1.7;
}
.authorPoemSection {
  margin-top: 12px;
  padding: 12px 16px;
  background: rgba(255, 255, 255, 0.6);
  border-radius: 10px;
  border: 1px solid rgba(138, 47, 43, 0.12);
}
.authorPoemTitle {
  font-size: 15px;
  font-weight: 700;
  color: #6d211d;
  margin-bottom: 8px;
}
.authorPoemContent {
  font-size: 13px;
  line-height: 1.85;
  color: #444;
  white-space: pre-line;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 6;
  overflow: hidden;
}

.modal {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.42);
  backdrop-filter: blur(10px);
  z-index: 999;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
}

.panel {
  width: min(1180px, 96vw);
  max-height: 90vh;
  overflow: auto;
  border-radius: 28px;
  background: rgba(255, 255, 255, 0.92);
  border: 1px solid rgba(0, 0, 0, 0.12);
  box-shadow: 0 26px 70px rgba(0, 0, 0, 0.22);
}

.detailHero {
  display: grid;
  grid-template-columns: 380px 1fr;
  gap: 18px;
  padding: 18px;
}

.detailCover {
  height: 320px;
  border-radius: 22px;
  overflow: hidden;
  position: relative;
  background-size: cover;
  background-position: center;
  border: 1px solid rgba(0, 0, 0, 0.08);
}

.detailMain {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-width: 0;
}

.titleRow {
  display: flex;
  align-items: start;
  justify-content: space-between;
  gap: 12px;
}

.pTitle {
  font-weight: 1000;
  font-size: 32px;
  line-height: 1.2;
}

.pMeta {
  margin-top: 6px;
  opacity: 0.72;
  font-size: 15px;
}

.pRow {
  margin-top: 14px;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.pill {
  padding: 7px 12px;
  border-radius: 999px;
  background: rgba(60, 80, 70, 0.12);
  border: 1px solid rgba(60, 80, 70, 0.18);
  font-size: 12px;
  font-weight: 900;
}

.pQuote {
  margin-top: 18px;
  padding: 16px 18px;
  border-radius: 18px;
  background: rgba(255, 255, 255, 0.42);
  border: 1px solid rgba(0, 0, 0, 0.08);
  font-weight: 1000;
  font-size: 18px;
  line-height: 1.8;
}

.pBtns {
  margin-top: 18px;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.close {
  width: 40px;
  height: 40px;
  border-radius: 999px;
  border: 1px solid rgba(138, 47, 43, 0.3);
  background: rgba(255, 240, 238, 0.9);
  color: #8B2323;
  cursor: pointer;
  font-size: 22px;
  line-height: 36px;
  transition: all 0.2s ease;
}

.close:hover {
  background: linear-gradient(135deg, #b32418, #7a1b14);
  color: #fff;
  border-color: transparent;
}

.pBody {
  padding: 0 18px 18px;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.readCard {
  padding: 18px;
  border-radius: 22px;
  background: rgba(255, 255, 255, 0.42);
  border: 1px solid rgba(0, 0, 0, 0.08);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.45);
}

.poemCard {
  grid-column: 1 / -1;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.56), rgba(255, 255, 255, 0.4)), rgba(255, 255, 255, 0.42);
}

.secHead {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}

.secT {
  font-weight: 1000;
  font-size: 18px;
}

.secSub {
  opacity: 0.45;
  font-size: 12px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

.poem {
  white-space: pre-wrap;
  line-height: 2.15;
  font-weight: 900;
  font-size: 18px;
}

.text {
  white-space: pre-wrap;
  line-height: 1.95;
  font-size: 14px;
}

.chips {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.chip {
  padding: 7px 12px;
  border-radius: 999px;
  background: rgba(0, 0, 0, 0.05);
  border: 1px solid rgba(0, 0, 0, 0.08);
  font-size: 12px;
}

.emptyText {
  opacity: 0.58;
  line-height: 1.8;
  min-height: 64px;
  display: flex;
  align-items: center;
}

.categoryDropdown {
  position: absolute;
  top: 100%;
  left: 0;
  margin-top: 8px;
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(12px);
  border-radius: 20px;
  padding: 16px 20px;
  min-width: 280px;
  z-index: 100;
  border: 1px solid rgba(0, 0, 0, 0.08);
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.12);
}

.categoryGroup {
  margin-bottom: 16px;
}

.categoryGroup:last-child {
  margin-bottom: 0;
}

.categoryTitle {
  font-size: 13px;
  font-weight: 700;
  color: #9d8b7a;
  margin-bottom: 10px;
  letter-spacing: 0.5px;
}

.categoryItems {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.categoryItem {
  padding: 6px 14px;
  border-radius: 30px;
  border: 1px solid rgba(0, 0, 0, 0.1);
  background: rgba(255, 255, 220, 0.6);
  font-size: 13px;
  font-weight: 500;
  color: #4a3b36;
  cursor: pointer;
  transition: all 0.2s ease;
}

.categoryItem:hover {
  background: rgba(205, 92, 92, 0.2);
  border-color: rgba(205, 92, 92, 0.4);
}

.categoryItem.active {
  background: rgba(205, 92, 92, 0.3);
  border-color: rgba(205, 92, 92, 0.5);
  color: #8B0000;
  font-weight: 600;
}

.dropdownArrow {
  font-size: 10px;
  transition: transform 0.2s ease;
}

.dropdownArrow.up {
  transform: rotate(180deg);
}

.sortBtn {
  height: 34px;
  padding: 0 14px;
  border-radius: 999px;
  border: 1px solid rgba(138, 47, 43, 0.3);
  background: rgba(255, 240, 238, 0.8);
  color: #8B2323;
  cursor: pointer;
  font-weight: 600;
  transition: 0.2s;
}

.sortBtn.on {
  background: linear-gradient(135deg, #b32418, #7a1b14);
  border-color: transparent;
  color: #fff;
}

.sort {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.pg {
  height: 38px;
  padding: 0 16px;
  border-radius: 12px;
  border: 1px solid rgba(138, 47, 43, 0.3);
  background: rgba(255, 240, 238, 0.9);
  color: #8B2323;
  cursor: pointer;
  font-weight: 700;
}

.navTabInline {
  height: 36px;
  padding: 0 16px;
  border-radius: 32px;
  border: 1px solid rgba(0, 0, 0, 0.12);
  background: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  font-weight: 600;
  font-size: 14px;
  color: #4a3b36;
  transition: all 0.2s ease;
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.navTabInline:hover {
  background: rgba(255, 255, 255, 0.9);
  transform: translateY(-1px);
}

.navTabInline.active {
  background: rgba(179, 36, 24, 0.96);
  border-color: rgba(122, 27, 20, 1);
  color: #fff;
}

.navTabWrapperInline {
  position: relative;
  display: inline-block;
}

@media (max-width: 1400px) {
  .grid {
    grid-template-columns: repeat(5, 1fr);
  }

  .authorGrid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 1200px) {
  .heroContent {
    left: 34px;
    top: 90px;
    width: min(460px, 48vw);
  }

  .heroTitle {
    font-size: 60px;
  }

  .heroCardsWrap {
    right: 28px;
    bottom: 78px;
    max-width: 62vw;
  }

  .heroFloatCard {
    width: 168px;
    height: 228px;
  }

  .grid {
    grid-template-columns: repeat(4, 1fr);
  }

  .catGrid {
    grid-template-columns: 1fr;
  }

  .authorGrid {
    grid-template-columns: 1fr;
  }

  .detailHero {
    grid-template-columns: 1fr;
  }

  .pBody {
    grid-template-columns: 1fr;
  }

  .searchBoxLight {
    width: 80%;
  }
}

@media (max-width: 860px) {
  .heroBgLayer img {
    transform-origin: 50% 50%;
  }

  .heroContent {
    left: 20px;
    right: 20px;
    top: 74px;
    width: auto;
  }

  .heroLine {
    width: 24px;
    height: 3px;
    margin-bottom: 12px;
  }

  .heroTopText {
    font-size: 12px;
    margin-bottom: 6px;
  }

  .heroMiniTitle {
    font-size: 16px;
    margin-bottom: 14px;
  }

  .heroTitle {
    font-size: 42px;
  }

  .heroDesc {
    margin-top: 14px;
    font-size: 14px;
    line-height: 1.8;
    max-width: none;
  }

  .heroActions {
    margin-top: 18px;
    gap: 10px;
    flex-wrap: wrap;
  }

  .heroMainBtn,
  .heroGhostBtn {
    height: 40px;
    padding: 0 16px;
    font-size: 13px;
  }

  .heroCardsWrap {
    left: auto;
    right: 0;
    bottom: 92px;
    width: calc(100% - 16px);
    padding-left: 0;
    padding-right: 16px;
    transform: none;
    overflow-x: auto;
  }

  .heroCardsWrap::-webkit-scrollbar {
    display: none;
  }

  .heroCardsTrack {
    justify-content: flex-end;
    gap: 12px;
    padding-right: 0;
  }

  .heroFloatCard {
    width: 150px;
    height: 210px;
    border-radius: 18px;
    transform: none;
    opacity: 1;
    flex: 0 0 auto;
  }

  .heroBottomOps {
    left: 20px;
    bottom: 20px;
    gap: 10px;
  }

  .heroMiniSwitch {
    height: 36px;
    padding: 0 14px;
    font-size: 12px;
  }

  .grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .authorGrid {
    grid-template-columns: 1fr;
  }

  .topicHeroCard {
    height: 280px;
  }

  .topicTitle {
    font-size: 26px;
  }

  .detailCover {
    height: 220px;
  }

  .pTitle {
    font-size: 24px;
  }

  .poem {
    font-size: 16px;
  }

  .searchBoxLight {
    width: 100%;
    min-width: auto;
  }

  .actionButtons {
    justify-content: center;
  }
}



/* ===== 第二屏重做：三列大卡片 + 全屏详情 ===== */
.gridWrap {
  padding-top: 10px;
}

.grid {
  grid-template-columns: repeat(3, minmax(0, 1fr)) !important;
  gap: 28px !important;
  align-items: start;
}

.card {
  border-radius: 0 !important;
  background: #ffffff !important;
  border: none !important;
  box-shadow: 0 10px 28px rgba(0, 0, 0, 0.12) !important;
  overflow: hidden;
}

.card:hover {
  transform: translateY(-6px) !important;
  box-shadow: 0 18px 42px rgba(0, 0, 0, 0.18) !important;
}

.poster {
  height: 280px !important;
}

.info {
  padding: 18px 18px 16px !important;
  background: #ffffff !important;
}

.metaLine {
  font-size: 13px;
  color: rgba(0, 0, 0, 0.62);
  margin-bottom: 14px;
}

.title {
  font-size: 22px !important;
  line-height: 1.25;
  color: #161616;
}

.meta {
  margin-top: 10px !important;
  font-size: 14px !important;
  color: rgba(0, 0, 0, 0.58);
}

.excerpt {
  margin-top: 14px;
  font-size: 15px;
  line-height: 1.95;
  color: rgba(0, 0, 0, 0.7);
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 4;
  overflow: hidden;
  min-height: 7.8em;
}

.tags {
  margin-top: 16px !important;
}

.tag {
  background: #f4f1eb !important;
  border: 1px solid rgba(112, 86, 43, 0.12) !important;
  color: #6a5430;
}

.searchSection {
  position: sticky;
  top: 0;
  z-index: 30;
  padding-top: 12px;
  padding-bottom: 18px;
  background: linear-gradient(180deg, rgba(244, 236, 216, 0.98) 0%, rgba(244, 236, 216, 0.95) 70%, rgba(244, 236, 216, 0) 100%);
  backdrop-filter: blur(8px);
}

.modal {
  padding: 0 !important;
  background: rgba(17, 14, 8, 0.58) !important;
  backdrop-filter: blur(6px);
}

.panel {
  width: 100vw !important;
  height: 100vh !important;
  max-height: none !important;
  border-radius: 0 !important;
  border: none !important;
  background: #f8f4ec !important;
  overflow-y: auto !important;
  box-shadow: none !important;
}

.detailHero {
  grid-template-columns: minmax(320px, 34vw) minmax(0, 1fr) !important;
  gap: 28px !important;
  padding: 28px 32px 20px !important;
}

.detailCover {
  height: min(62vh, 560px) !important;
  border-radius: 0 !important;
}

.titleRow {
  gap: 20px;
}

.close {
  width: 52px;
  height: 52px;
  border-radius: 999px;
  font-size: 30px;
  background: rgba(138, 47, 43, 0.15);
  color: #8B2323;
  border: 1px solid rgba(138, 47, 43, 0.3);
}

.pTitle {
  font-size: 42px !important;
}

.pMeta {
  font-size: 18px !important;
}

.pQuote {
  font-size: 18px;
  line-height: 1.9;
}

.pBody {
  padding: 0 32px 36px !important;
}

.readCard {
  border-radius: 0 !important;
  background: #ffffff !important;
  box-shadow: 0 10px 26px rgba(0, 0, 0, 0.08);
}

@media (max-width: 1400px) {
  .grid {
    grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
  }
}

@media (max-width: 900px) {
  .grid {
    grid-template-columns: 1fr !important;
    gap: 20px !important;
  }

  .poster {
    height: 240px !important;
  }

  .detailHero {
    grid-template-columns: 1fr !important;
    padding: 22px 18px 14px !important;
  }

  .pBody {
    padding: 0 18px 24px !important;
  }

  .pTitle {
    font-size: 30px !important;
  }
}


.detailReferencePanel {
  width: min(1520px, calc(100vw - 48px)) !important;
  max-width: none !important;
  padding: 42px 54px 56px !important;
  background: #f5f2ea !important;
  border: 1px solid rgba(91, 72, 42, 0.12) !important;
  border-radius: 18px !important;
  box-shadow: 0 18px 50px rgba(0, 0, 0, 0.12) !important;
}
.detailReferenceLayout {
  display: grid;
  grid-template-columns: minmax(0, 1.72fr) 340px;
  gap: 56px;
  align-items: start;
}
.detailReferenceMain {
  min-width: 0;
}
.detailReferenceHeader {
  padding-bottom: 24px;
  border-bottom: 1px solid rgba(80, 67, 42, 0.12);
}
.detailRefMetaLine {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  font-size: 14px;
  color: rgba(31, 31, 31, 0.7);
  letter-spacing: 0.2px;
}
.detailRefTitle {
  margin: 14px 0 18px;
  font-size: clamp(34px, 4vw, 56px);
  line-height: 1.08;
  font-weight: 700;
  color: #171717;
}
.detailRefIntro {
  max-width: 980px;
  font-size: 18px;
  line-height: 2;
  color: #242424;
}
.detailRefIntro p {
  margin: 0;
  white-space: pre-line;
}
.detailReferenceFigure {
  margin: 28px 0 0;
}
.detailReferenceCover {
  height: clamp(340px, 44vw, 720px) !important;
  border-radius: 0 !important;
  overflow: hidden;
  box-shadow: none !important;
}
.detailReferenceFigure figcaption {
  margin-top: 10px;
  font-size: 13px;
  color: rgba(0, 0, 0, 0.42);
  letter-spacing: 1.2px;
}
.detailReferenceActions {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  margin: 28px 0 34px;
}
.detailReferenceBody {
  display: flex;
  flex-direction: column;
  gap: 22px;
}
.detailReferenceSection {
  background: #fff;
  border: 1px solid rgba(101, 82, 51, 0.12);
  padding: 30px 32px 34px;
  border-radius: 0;
  box-shadow: none;
}
.detailReferencePoem {
  padding-top: 34px;
}
.detailReferenceSectionHead {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
}
.detailReferenceSectionTitle {
  font-size: 22px;
  font-weight: 700;
  color: #121212;
}
.detailReferenceSectionSub {
  font-size: 14px;
  letter-spacing: 2px;
  color: rgba(0, 0, 0, 0.32);
}
.detailReferencePoemText {
  white-space: pre-line;
  font-size: 23px;
  line-height: 2.05;
  font-weight: 700;
  color: #191919;
}
.detailReferenceText {
  white-space: pre-line;
  font-size: 18px;
  line-height: 2;
  color: #242424;
}
.detailReferenceEmpty {
  font-size: 16px;
  color: rgba(0, 0, 0, 0.42);
}
.detailReferenceTags {
  padding-top: 24px;
}
.detailReferenceTagList {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}
.detailReferenceTag {
  padding: 9px 16px;
  border-radius: 999px;
  background: #efebe3;
  border: 1px solid rgba(0, 0, 0, 0.08);
  color: #3d3d3d;
  font-size: 14px;
}
.detailReferenceAside {
  position: sticky;
  top: 24px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.detailReferenceAsideBlock {
  background: transparent;
  border: 0;
  border-bottom: 1px solid rgba(95, 76, 48, 0.12);
  padding: 4px 0 16px;
}
.detailReferenceAsideTitle {
  margin-bottom: 16px;
  font-size: 16px;
  font-weight: 700;
  color: #171717;
}
.detailReferenceInfoRow {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 10px 0;
  border-bottom: 1px dashed rgba(0, 0, 0, 0.08);
}
.detailReferenceInfoRow:last-child {
  border-bottom: 0;
}
.detailReferenceInfoRow span {
  flex: 0 0 78px;
  font-size: 14px;
  color: rgba(0, 0, 0, 0.52);
}
.detailReferenceInfoRow strong {
  flex: 1;
  text-align: left;
  font-size: 15px;
  line-height: 1.8;
  color: #171717;
  font-weight: 500;
}
.detailReferenceQuote {
  font-size: 18px;
  line-height: 1.9;
  color: #1c1c1c;
}
.detailReferenceAsideBtn {
  display: block;
  width: 100%;
  margin-bottom: 10px;
  padding: 12px 14px;
  border: 1px solid rgba(138, 47, 43, 0.2);
  background: #fff;
  color: #171717;
  font-size: 14px;
  text-align: left;
  cursor: pointer;
  transition: transform 0.2s ease, border-color 0.2s ease, background 0.2s ease;
}
.detailReferenceAsideBtn:hover {
  transform: translateX(4px);
  border-color: rgba(138, 47, 43, 0.5);
  background: rgba(138, 47, 43, 0.05);
}
.detailReferenceAsideBtn:last-child {
  margin-bottom: 0;
}
@media (max-width: 1180px) {
  .detailReferenceLayout {
    grid-template-columns: 1fr;
    gap: 32px;
  }
  .detailReferenceAside {
    position: static;
  }
}
@media (max-width: 860px) {
  .detailReferencePanel {
    width: calc(100vw - 18px) !important;
    padding: 18px 14px 26px !important;
    border-radius: 10px !important;
  }
  .detailRefTitle {
    font-size: 32px;
  }
  .detailRefIntro {
    font-size: 16px;
    line-height: 1.85;
  }
  .detailReferenceCover {
    height: 280px !important;
  }
  .detailReferenceSection {
    padding: 22px 18px 24px;
  }
  .detailReferencePoemText {
    font-size: 18px;
    line-height: 1.9;
  }
  .detailReferenceText,
  .detailReferenceQuote {
    font-size: 16px;
    line-height: 1.9;
  }
}

</style>

<style scoped>
/* detail 全屏弹层可读性修正 */
.posterMask.strong {
  background: linear-gradient(
    180deg,
    rgba(8, 10, 14, 0.18) 0%,
    rgba(8, 10, 14, 0.26) 34%,
    rgba(8, 10, 14, 0.58) 72%,
    rgba(8, 10, 14, 0.82) 100%
  ) !important;
}

.detailCover {
  overflow: hidden;
}

.detailMain {
  position: relative;
  z-index: 2;
}

.detailMain > div {
  background: rgba(255, 248, 236, 0.94);
  border: 1px solid rgba(92, 70, 36, 0.12);
  box-shadow: 0 18px 42px rgba(0, 0, 0, 0.08);
  border-radius: 28px;
  padding: 26px 28px;
}

.pQuote {
  background: rgba(123, 94, 47, 0.08) !important;
  border: 1px solid rgba(123, 94, 47, 0.12) !important;
}

.pBtns .tbtn {
  min-width: 132px;
  min-height: 48px;
  border-radius: 999px;
}

.pBtns .tbtn.primary {
  background: linear-gradient(135deg, #b32418, #7a1b14) !important;
  color: #fff !important;
  border: none !important;
  box-shadow: 0 10px 24px rgba(138, 47, 43, 0.35);
}

.pBtns .tbtn.ghost {
  background: #fff !important;
  color: #8B2323 !important;
  border: 1px solid rgba(138, 47, 43, 0.35) !important;
}

.close {
  background: rgba(255, 240, 238, 0.95) !important;
  color: #8B2323 !important;
  border: 1px solid rgba(138, 47, 43, 0.3) !important;
}

@media (max-width: 900px) {
  .detailHero {
    position: relative;
    padding: 0 !important;
    gap: 0 !important;
  }

  .detailCover {
    height: 72vh !important;
    min-height: 560px;
    border-radius: 0 !important;
  }

  .detailMain {
    margin-top: -210px;
    padding: 0 16px 16px;
  }

  .detailMain > div {
    background: rgba(255, 248, 236, 0.96);
    border-radius: 26px;
    padding: 22px 20px;
  }

  .pBtns {
    gap: 12px;
  }

  .pBtns .tbtn {
    flex: 1 1 calc(50% - 6px);
  }
}

.detailReferencePanel {
  width: min(1520px, calc(100vw - 48px)) !important;
  max-width: none !important;
  padding: 42px 54px 56px !important;
  background: #f5f2ea !important;
  border: 1px solid rgba(91, 72, 42, 0.12) !important;
  border-radius: 18px !important;
  box-shadow: 0 18px 50px rgba(0, 0, 0, 0.12) !important;
}
.detailReferenceLayout {
  display: grid;
  grid-template-columns: minmax(0, 1.72fr) 340px;
  gap: 56px;
  align-items: start;
}
.detailReferenceMain {
  min-width: 0;
}
.detailReferenceHeader {
  padding-bottom: 24px;
  border-bottom: 1px solid rgba(80, 67, 42, 0.12);
}
.detailRefMetaLine {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  font-size: 14px;
  color: rgba(31, 31, 31, 0.7);
  letter-spacing: 0.2px;
}
.detailRefTitle {
  margin: 14px 0 18px;
  font-size: clamp(34px, 4vw, 56px);
  line-height: 1.08;
  font-weight: 700;
  color: #171717;
}
.detailRefIntro {
  max-width: 980px;
  font-size: 18px;
  line-height: 2;
  color: #242424;
}
.detailRefIntro p {
  margin: 0;
  white-space: pre-line;
}
.detailReferenceFigure {
  margin: 28px 0 0;
}
.detailReferenceCover {
  height: clamp(340px, 44vw, 720px) !important;
  border-radius: 0 !important;
  overflow: hidden;
  box-shadow: none !important;
}
.detailReferenceFigure figcaption {
  margin-top: 10px;
  font-size: 13px;
  color: rgba(0, 0, 0, 0.42);
  letter-spacing: 1.2px;
}
.detailReferenceActions {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  margin: 28px 0 34px;
}
.detailReferenceBody {
  display: flex;
  flex-direction: column;
  gap: 22px;
}
.detailReferenceSection {
  background: #fff;
  border: 1px solid rgba(101, 82, 51, 0.12);
  padding: 30px 32px 34px;
  border-radius: 0;
  box-shadow: none;
}
.detailReferencePoem {
  padding-top: 34px;
}
.detailReferenceSectionHead {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
}
.detailReferenceSectionTitle {
  font-size: 22px;
  font-weight: 700;
  color: #121212;
}
.detailReferenceSectionSub {
  font-size: 14px;
  letter-spacing: 2px;
  color: rgba(0, 0, 0, 0.32);
}
.detailReferencePoemText {
  white-space: pre-line;
  font-size: 23px;
  line-height: 2.05;
  font-weight: 700;
  color: #191919;
}
.detailReferenceText {
  white-space: pre-line;
  font-size: 18px;
  line-height: 2;
  color: #242424;
}
.detailReferenceEmpty {
  font-size: 16px;
  color: rgba(0, 0, 0, 0.42);
}
.detailReferenceTags {
  padding-top: 24px;
}
.detailReferenceTagList {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}
.detailReferenceTag {
  padding: 9px 16px;
  border-radius: 999px;
  background: #efebe3;
  border: 1px solid rgba(0, 0, 0, 0.08);
  color: #3d3d3d;
  font-size: 14px;
}
.detailReferenceAside {
  position: sticky;
  top: 24px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.detailReferenceAsideBlock {
  background: transparent;
  border: 0;
  border-bottom: 1px solid rgba(95, 76, 48, 0.12);
  padding: 4px 0 16px;
}
.detailReferenceAsideTitle {
  margin-bottom: 16px;
  font-size: 16px;
  font-weight: 700;
  color: #171717;
}
.detailReferenceInfoRow {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 10px 0;
  border-bottom: 1px dashed rgba(0, 0, 0, 0.08);
}
.detailReferenceInfoRow:last-child {
  border-bottom: 0;
}
.detailReferenceInfoRow span {
  flex: 0 0 78px;
  font-size: 14px;
  color: rgba(0, 0, 0, 0.52);
}
.detailReferenceInfoRow strong {
  flex: 1;
  text-align: left;
  font-size: 15px;
  line-height: 1.8;
  color: #171717;
  font-weight: 500;
}
.detailReferenceQuote {
  font-size: 18px;
  line-height: 1.9;
  color: #1c1c1c;
}
.detailReferenceAsideBtn {
  display: block;
  width: 100%;
  margin-bottom: 10px;
  padding: 12px 14px;
  border: 1px solid rgba(138, 47, 43, 0.2);
  background: #fff;
  color: #171717;
  font-size: 14px;
  text-align: left;
  cursor: pointer;
  transition: transform 0.2s ease, border-color 0.2s ease, background 0.2s ease;
}
.detailReferenceAsideBtn:hover {
  transform: translateX(4px);
  border-color: rgba(138, 47, 43, 0.5);
  background: rgba(138, 47, 43, 0.05);
}
.detailReferenceAsideBtn:last-child {
  margin-bottom: 0;
}
@media (max-width: 1180px) {
  .detailReferenceLayout {
    grid-template-columns: 1fr;
    gap: 32px;
  }
  .detailReferenceAside {
    position: static;
  }
}
@media (max-width: 860px) {
  .detailReferencePanel {
    width: calc(100vw - 18px) !important;
    padding: 18px 14px 26px !important;
    border-radius: 10px !important;
  }
  .detailRefTitle {
    font-size: 32px;
  }
  .detailRefIntro {
    font-size: 16px;
    line-height: 1.85;
  }
  .detailReferenceCover {
    height: 280px !important;
  }
  .detailReferenceSection {
    padding: 22px 18px 24px;
  }
  .detailReferencePoemText {
    font-size: 18px;
    line-height: 1.9;
  }
  .detailReferenceText,
  .detailReferenceQuote {
    font-size: 16px;
    line-height: 1.9;
  }
}

</style>

<style scoped>
/* 最终覆盖：四列、去雾、白底更短 */
.heroShade,
.bannerOverlay,
.heroVignette,
.posterMask,
.posterMask.strong {
  background: transparent !important;
}

.heroCard,
.card,
.panel,
.searchSection,
.modal,
.topRibbon,
.glassPanel,
.glassInnerPanel,
.audioHubCard,
.videoCard {
  backdrop-filter: none !important;
  -webkit-backdrop-filter: none !important;
  filter: none !important;
}

.searchSection {
  background: rgba(244, 236, 216, 0.98) !important;
}

.modal {
  background: rgba(17, 14, 8, 0.42) !important;
}

.grid {
  grid-template-columns: repeat(4, minmax(0, 1fr)) !important;
  gap: 22px !important;
}

.poster {
  height: 220px !important;
}

.info {
  padding: 12px 14px 12px !important;
}

.title {
  font-size: 18px !important;
  line-height: 1.2 !important;
  margin: 0 !important;
}

.meta {
  margin-top: 6px !important;
  margin-bottom: 0 !important;
  font-size: 13px !important;
  line-height: 1.35 !important;
}

.excerpt {
  margin-top: 10px !important;
  font-size: 14px !important;
  line-height: 1.7 !important;
  -webkit-line-clamp: 3 !important;
  min-height: auto !important;
}

.tags {
  margin-top: 10px !important;
}

.tag {
  padding: 4px 10px !important;
  font-size: 12px !important;
}

@media (max-width: 1600px) {
  .grid {
    grid-template-columns: repeat(4, minmax(0, 1fr)) !important;
  }
}

@media (max-width: 1200px) {
  .grid {
    grid-template-columns: repeat(3, minmax(0, 1fr)) !important;
  }
}

@media (max-width: 900px) {
  .grid {
    grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
  }

  .poster {
    height: 200px !important;
  }
}

@media (max-width: 640px) {
  .grid {
    grid-template-columns: 1fr !important;
  }
}

.detailReferencePanel {
  width: min(1520px, calc(100vw - 48px)) !important;
  max-width: none !important;
  padding: 42px 54px 56px !important;
  background: #f5f2ea !important;
  border: 1px solid rgba(91, 72, 42, 0.12) !important;
  border-radius: 18px !important;
  box-shadow: 0 18px 50px rgba(0, 0, 0, 0.12) !important;
}
.detailReferenceLayout {
  display: grid;
  grid-template-columns: minmax(0, 1.72fr) 340px;
  gap: 56px;
  align-items: start;
}
.detailReferenceMain {
  min-width: 0;
}
.detailReferenceHeader {
  padding-bottom: 24px;
  border-bottom: 1px solid rgba(80, 67, 42, 0.12);
}
.detailRefMetaLine {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  font-size: 14px;
  color: rgba(31, 31, 31, 0.7);
  letter-spacing: 0.2px;
}
.detailRefTitle {
  margin: 14px 0 18px;
  font-size: clamp(34px, 4vw, 56px);
  line-height: 1.08;
  font-weight: 700;
  color: #171717;
}
.detailRefIntro {
  max-width: 980px;
  font-size: 18px;
  line-height: 2;
  color: #242424;
}
.detailRefIntro p {
  margin: 0;
  white-space: pre-line;
}
.detailReferenceFigure {
  margin: 28px 0 0;
}
.detailReferenceCover {
  height: clamp(340px, 44vw, 720px) !important;
  border-radius: 0 !important;
  overflow: hidden;
  box-shadow: none !important;
}
.detailReferenceFigure figcaption {
  margin-top: 10px;
  font-size: 13px;
  color: rgba(0, 0, 0, 0.42);
  letter-spacing: 1.2px;
}
.detailReferenceActions {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  margin: 28px 0 34px;
}
.detailReferenceBody {
  display: flex;
  flex-direction: column;
  gap: 22px;
}
.detailReferenceSection {
  background: #fff;
  border: 1px solid rgba(101, 82, 51, 0.12);
  padding: 30px 32px 34px;
  border-radius: 0;
  box-shadow: none;
}
.detailReferencePoem {
  padding-top: 34px;
}
.detailReferenceSectionHead {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
}
.detailReferenceSectionTitle {
  font-size: 22px;
  font-weight: 700;
  color: #121212;
}
.detailReferenceSectionSub {
  font-size: 14px;
  letter-spacing: 2px;
  color: rgba(0, 0, 0, 0.32);
}
.detailReferencePoemText {
  white-space: pre-line;
  font-size: 23px;
  line-height: 2.05;
  font-weight: 700;
  color: #191919;
}
.detailReferenceText {
  white-space: pre-line;
  font-size: 18px;
  line-height: 2;
  color: #242424;
}
.detailReferenceEmpty {
  font-size: 16px;
  color: rgba(0, 0, 0, 0.42);
}
.detailReferenceTags {
  padding-top: 24px;
}
.detailReferenceTagList {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}
.detailReferenceTag {
  padding: 9px 16px;
  border-radius: 999px;
  background: #efebe3;
  border: 1px solid rgba(0, 0, 0, 0.08);
  color: #3d3d3d;
  font-size: 14px;
}
.detailReferenceAside {
  position: sticky;
  top: 24px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.detailReferenceAsideBlock {
  background: transparent;
  border: 0;
  border-bottom: 1px solid rgba(95, 76, 48, 0.12);
  padding: 4px 0 16px;
}
.detailReferenceAsideTitle {
  margin-bottom: 16px;
  font-size: 16px;
  font-weight: 700;
  color: #171717;
}
.detailReferenceInfoRow {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 10px 0;
  border-bottom: 1px dashed rgba(0, 0, 0, 0.08);
}
.detailReferenceInfoRow:last-child {
  border-bottom: 0;
}
.detailReferenceInfoRow span {
  flex: 0 0 78px;
  font-size: 14px;
  color: rgba(0, 0, 0, 0.52);
}
.detailReferenceInfoRow strong {
  flex: 1;
  text-align: left;
  font-size: 15px;
  line-height: 1.8;
  color: #171717;
  font-weight: 500;
}
.detailReferenceQuote {
  font-size: 18px;
  line-height: 1.9;
  color: #1c1c1c;
}
.detailReferenceAsideBtn {
  display: block;
  width: 100%;
  margin-bottom: 10px;
  padding: 12px 14px;
  border: 1px solid rgba(138, 47, 43, 0.2);
  background: #fff;
  color: #171717;
  font-size: 14px;
  text-align: left;
  cursor: pointer;
  transition: transform 0.2s ease, border-color 0.2s ease, background 0.2s ease;
}
.detailReferenceAsideBtn:hover {
  transform: translateX(4px);
  border-color: rgba(138, 47, 43, 0.5);
  background: rgba(138, 47, 43, 0.05);
}
.detailReferenceAsideBtn:last-child {
  margin-bottom: 0;
}
@media (max-width: 1180px) {
  .detailReferenceLayout {
    grid-template-columns: 1fr;
    gap: 32px;
  }
  .detailReferenceAside {
    position: static;
  }
}
@media (max-width: 860px) {
  .detailReferencePanel {
    width: calc(100vw - 18px) !important;
    padding: 18px 14px 26px !important;
    border-radius: 10px !important;
  }
  .detailRefTitle {
    font-size: 32px;
  }
  .detailRefIntro {
    font-size: 16px;
    line-height: 1.85;
  }
  .detailReferenceCover {
    height: 280px !important;
  }
  .detailReferenceSection {
    padding: 22px 18px 24px;
  }
  .detailReferencePoemText {
    font-size: 18px;
    line-height: 1.9;
  }
  .detailReferenceText,
  .detailReferenceQuote {
    font-size: 16px;
    line-height: 1.9;
  }
}

</style>


<style scoped>
/* 修正：第二屏搜索不再是白框，卡片悬停不再发白 */
.searchSection {
  background: linear-gradient(180deg, rgba(244, 236, 216, 0.98) 0%, rgba(244, 236, 216, 0.95) 72%, rgba(244, 236, 216, 0) 100%) !important;
  backdrop-filter: none !important;
}

.searchCenter {
  margin-bottom: 16px;
}

.searchBoxLight {
  width: min(1120px, 100%) !important;
  min-width: 0 !important;
  background: rgba(244, 236, 218, 0.58) !important;
  border: 1px solid rgba(162, 125, 55, 0.18) !important;
  box-shadow: none !important;
  backdrop-filter: none !important;
  -webkit-backdrop-filter: none !important;
}

.searchBoxLight:focus-within {
  background: rgba(244, 236, 218, 0.74) !important;
  border-color: rgba(212, 175, 55, 0.42) !important;
  box-shadow: none !important;
}

.searchBoxLight input {
  background: transparent !important;
}

.card {
  background: rgba(255, 252, 246, 0.96) !important;
}

.poster {
  position: relative;
  isolation: isolate;
}

.posterMask {
  background: linear-gradient(180deg, rgba(0, 0, 0, 0.04) 0%, rgba(0, 0, 0, 0.08) 42%, rgba(0, 0, 0, 0.22) 100%) !important;
  transition: opacity .22s ease, background .22s ease !important;
}

.hover {
  background: linear-gradient(180deg, rgba(10, 10, 10, 0.04) 0%, rgba(10, 10, 10, 0.12) 44%, rgba(10, 10, 10, 0.74) 100%) !important;
  transform: translateY(0) !important;
  transition: opacity .22s ease !important;
}

.card:hover .hover {
  opacity: 1 !important;
}

.card:hover .posterMask {
  background: linear-gradient(180deg, rgba(0, 0, 0, 0.05) 0%, rgba(0, 0, 0, 0.14) 44%, rgba(0, 0, 0, 0.34) 100%) !important;
}

.info {
  background: rgba(255, 252, 246, 0.98) !important;
}

@media (max-width: 900px) {
  .searchBoxLight {
    width: 100% !important;
  }
}

.detailReferencePanel {
  width: min(1520px, calc(100vw - 48px)) !important;
  max-width: none !important;
  padding: 42px 54px 56px !important;
  background: #f5f2ea !important;
  border: 1px solid rgba(91, 72, 42, 0.12) !important;
  border-radius: 18px !important;
  box-shadow: 0 18px 50px rgba(0, 0, 0, 0.12) !important;
}
.detailReferenceLayout {
  display: grid;
  grid-template-columns: minmax(0, 1.72fr) 340px;
  gap: 56px;
  align-items: start;
}
.detailReferenceMain {
  min-width: 0;
}
.detailReferenceHeader {
  padding-bottom: 24px;
  border-bottom: 1px solid rgba(80, 67, 42, 0.12);
}
.detailRefMetaLine {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  font-size: 14px;
  color: rgba(31, 31, 31, 0.7);
  letter-spacing: 0.2px;
}
.detailRefTitle {
  margin: 14px 0 18px;
  font-size: clamp(34px, 4vw, 56px);
  line-height: 1.08;
  font-weight: 700;
  color: #171717;
}
.detailRefIntro {
  max-width: 980px;
  font-size: 18px;
  line-height: 2;
  color: #242424;
}
.detailRefIntro p {
  margin: 0;
  white-space: pre-line;
}
.detailReferenceFigure {
  margin: 28px 0 0;
}
.detailReferenceCover {
  height: clamp(340px, 44vw, 720px) !important;
  border-radius: 0 !important;
  overflow: hidden;
  box-shadow: none !important;
}
.detailReferenceFigure figcaption {
  margin-top: 10px;
  font-size: 13px;
  color: rgba(0, 0, 0, 0.42);
  letter-spacing: 1.2px;
}
.detailReferenceActions {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  margin: 28px 0 34px;
}
.detailReferenceBody {
  display: flex;
  flex-direction: column;
  gap: 22px;
}
.detailReferenceSection {
  background: #fff;
  border: 1px solid rgba(101, 82, 51, 0.12);
  padding: 30px 32px 34px;
  border-radius: 0;
  box-shadow: none;
}
.detailReferencePoem {
  padding-top: 34px;
}
.detailReferenceSectionHead {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
}
.detailReferenceSectionTitle {
  font-size: 22px;
  font-weight: 700;
  color: #121212;
}
.detailReferenceSectionSub {
  font-size: 14px;
  letter-spacing: 2px;
  color: rgba(0, 0, 0, 0.32);
}
.detailReferencePoemText {
  white-space: pre-line;
  font-size: 23px;
  line-height: 2.05;
  font-weight: 700;
  color: #191919;
}
.detailReferenceText {
  white-space: pre-line;
  font-size: 18px;
  line-height: 2;
  color: #242424;
}
.detailReferenceEmpty {
  font-size: 16px;
  color: rgba(0, 0, 0, 0.42);
}
.detailReferenceTags {
  padding-top: 24px;
}
.detailReferenceTagList {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}
.detailReferenceTag {
  padding: 9px 16px;
  border-radius: 999px;
  background: #efebe3;
  border: 1px solid rgba(0, 0, 0, 0.08);
  color: #3d3d3d;
  font-size: 14px;
}
.detailReferenceAside {
  position: sticky;
  top: 24px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.detailReferenceAsideBlock {
  background: transparent;
  border: 0;
  border-bottom: 1px solid rgba(95, 76, 48, 0.12);
  padding: 4px 0 16px;
}
.detailReferenceAsideTitle {
  margin-bottom: 16px;
  font-size: 16px;
  font-weight: 700;
  color: #171717;
}
.detailReferenceInfoRow {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 10px 0;
  border-bottom: 1px dashed rgba(0, 0, 0, 0.08);
}
.detailReferenceInfoRow:last-child {
  border-bottom: 0;
}
.detailReferenceInfoRow span {
  flex: 0 0 78px;
  font-size: 14px;
  color: rgba(0, 0, 0, 0.52);
}
.detailReferenceInfoRow strong {
  flex: 1;
  text-align: left;
  font-size: 15px;
  line-height: 1.8;
  color: #171717;
  font-weight: 500;
}
.detailReferenceQuote {
  font-size: 18px;
  line-height: 1.9;
  color: #1c1c1c;
}
.detailReferenceAsideBtn {
  display: block;
  width: 100%;
  margin-bottom: 10px;
  padding: 12px 14px;
  border: 1px solid rgba(138, 47, 43, 0.2);
  background: #fff;
  color: #171717;
  font-size: 14px;
  text-align: left;
  cursor: pointer;
  transition: transform 0.2s ease, border-color 0.2s ease, background 0.2s ease;
}
.detailReferenceAsideBtn:hover {
  transform: translateX(4px);
  border-color: rgba(138, 47, 43, 0.5);
  background: rgba(138, 47, 43, 0.05);
}
.detailReferenceAsideBtn:last-child {
  margin-bottom: 0;
}
@media (max-width: 1180px) {
  .detailReferenceLayout {
    grid-template-columns: 1fr;
    gap: 32px;
  }
  .detailReferenceAside {
    position: static;
  }
}
@media (max-width: 860px) {
  .detailReferencePanel {
    width: calc(100vw - 18px) !important;
    padding: 18px 14px 26px !important;
    border-radius: 10px !important;
  }
  .detailRefTitle {
    font-size: 32px;
  }
  .detailRefIntro {
    font-size: 16px;
    line-height: 1.85;
  }
  .detailReferenceCover {
    height: 280px !important;
  }
  .detailReferenceSection {
    padding: 22px 18px 24px;
  }
  .detailReferencePoemText {
    font-size: 18px;
    line-height: 1.9;
  }
  .detailReferenceText,
  .detailReferenceQuote {
    font-size: 16px;
    line-height: 1.9;
  }
}

</style>

<style scoped>
/* 终版覆盖：第二屏铺满全宽、固定四列、详情弹层高级化 */
.contentScreen {
  padding-left: 0 !important;
  padding-right: 0 !important;
}

.contentWrapper {
  width: 100% !important;
  max-width: none !important;
  padding: 0 !important;
  margin: 0 !important;
}

.searchSection {
  width: 100% !important;
  max-width: none !important;
  margin: 0 0 28px 0 !important;
  padding: 14px 28px 20px !important;
  border-radius: 0 !important;
  background: linear-gradient(180deg, rgba(249,246,238,0.96) 0%, rgba(249,246,238,0.88) 70%, rgba(249,246,238,0.40) 100%) !important;
}

.searchCenter,
.actionButtons,
.gridHead,
.listHead,
.topicHero,
.gridWrap,
.listWrap {
  width: 100% !important;
  max-width: none !important;
}

.searchCenter {
  padding: 0 !important;
  margin: 0 0 18px 0 !important;
}

.searchBoxLight {
  width: 100% !important;
  max-width: none !important;
  min-width: 0 !important;
  border-radius: 999px !important;
}

.actionButtons {
  justify-content: flex-end !important;
  flex-wrap: wrap !important;
  gap: 12px !important;
}

.gridWrap,
.listWrap {
  padding: 0 28px 34px !important;
  margin: 0 !important;
}

.grid {
  display: grid !important;
  grid-template-columns: repeat(4, minmax(0, 1fr)) !important;
  gap: 22px !important;
  width: 100% !important;
}

.grid > * {
  min-width: 0 !important;
}

.card {
  width: 100% !important;
  margin: 0 !important;
  overflow: hidden !important;
  border-radius: 0 !important;
  background: rgba(255, 252, 246, 0.98) !important;
  box-shadow: 0 14px 34px rgba(82, 63, 26, 0.10) !important;
  transition: transform .22s ease, box-shadow .22s ease !important;
}

.card:hover {
  transform: translateY(-4px) !important;
  box-shadow: 0 18px 40px rgba(82, 63, 26, 0.16) !important;
}

.poster {
  height: 320px !important;
  border-radius: 0 !important;
}

.info {
  padding: 18px 18px 16px !important;
  background: rgba(255, 252, 246, 0.98) !important;
}

.metaLine {
  margin-bottom: 12px !important;
}

.title {
  font-size: 22px !important;
  line-height: 1.15 !important;
  margin-bottom: 10px !important;
}

.meta {
  font-size: 15px !important;
  line-height: 1.45 !important;
}

.excerpt {
  font-size: 16px !important;
  line-height: 1.75 !important;
  margin-top: 12px !important;
}

.tags {
  margin-top: 14px !important;
}

.tag {
  border-radius: 999px !important;
}

.modal {
  padding: 24px !important;
  background: rgba(22, 16, 7, 0.46) !important;
}

.panel {
  width: min(1520px, calc(100vw - 48px)) !important;
  max-width: none !important;
  max-height: calc(100vh - 48px) !important;
  padding: 22px !important;
  border-radius: 28px !important;
  background: linear-gradient(180deg, rgba(247,243,234,0.98) 0%, rgba(244,238,227,0.98) 100%) !important;
  box-shadow: 0 28px 80px rgba(43, 31, 10, 0.22) !important;
}

.detailHero {
  display: grid !important;
  grid-template-columns: 420px minmax(0, 1fr) !important;
  gap: 24px !important;
  align-items: start !important;
  margin-bottom: 24px !important;
}

.detailCover {
  align-self: start !important;
  position: sticky !important;
  top: 0 !important;
  min-height: 540px !important;
  border-radius: 24px !important;
  overflow: hidden !important;
  box-shadow: 0 18px 44px rgba(53, 38, 11, 0.16) !important;
}

.detailMain {
  display: grid !important;
  gap: 18px !important;
}

.titleRow,
.pRow,
.pExtRow,
.pQuote,
.pBtns {
  border-radius: 22px !important;
  background: rgba(255, 250, 241, 0.82) !important;
  border: 1px solid rgba(187, 158, 102, 0.16) !important;
  box-shadow: none !important;
}

.titleRow {
  padding: 24px 26px !important;
}

.pTitle {
  font-size: 56px !important;
  line-height: 1.02 !important;
  letter-spacing: 1px !important;
}

.pMeta {
  margin-top: 10px !important;
  font-size: 22px !important;
}

.close {
  width: 54px !important;
  height: 54px !important;
  border-radius: 50% !important;
}

.pRow,
.pExtRow,
.pBtns {
  padding: 18px 24px !important;
}

.pQuote {
  padding: 22px 24px !important;
  font-size: 28px !important;
  line-height: 1.5 !important;
}

.pBody {
  display: grid !important;
  grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
  gap: 18px !important;
}

.poemCard {
  grid-column: 1 / -1 !important;
}

.readCard {
  min-height: 220px !important;
  border-radius: 24px !important;
  background: rgba(255,255,255,0.72) !important;
  border: 1px solid rgba(187, 158, 102, 0.16) !important;
}

@media (max-width: 1500px) {
  .grid {
    grid-template-columns: repeat(4, minmax(0, 1fr)) !important;
  }

  .poster {
    height: 290px !important;
  }
}

@media (max-width: 1280px) {
  .grid {
    grid-template-columns: repeat(3, minmax(0, 1fr)) !important;
  }

  .detailHero {
    grid-template-columns: 320px minmax(0, 1fr) !important;
  }

  .pTitle {
    font-size: 42px !important;
  }
}

@media (max-width: 960px) {
  .gridWrap,
  .listWrap,
  .searchSection {
    padding-left: 16px !important;
    padding-right: 16px !important;
  }

  .grid {
    grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
  }

  .detailHero,
  .pBody {
    grid-template-columns: 1fr !important;
  }

  .detailCover {
    position: relative !important;
    min-height: 380px !important;
  }
}

@media (max-width: 640px) {
  .grid {
    grid-template-columns: 1fr !important;
  }

  .poster {
    height: 240px !important;
  }

  .pTitle {
    font-size: 34px !important;
  }
}

.detailReferencePanel {
  width: min(1520px, calc(100vw - 48px)) !important;
  max-width: none !important;
  padding: 42px 54px 56px !important;
  background: #f5f2ea !important;
  border: 1px solid rgba(91, 72, 42, 0.12) !important;
  border-radius: 18px !important;
  box-shadow: 0 18px 50px rgba(0, 0, 0, 0.12) !important;
}
.detailReferenceLayout {
  display: grid;
  grid-template-columns: minmax(0, 1.72fr) 340px;
  gap: 56px;
  align-items: start;
}
.detailReferenceMain {
  min-width: 0;
}
.detailReferenceHeader {
  padding-bottom: 24px;
  border-bottom: 1px solid rgba(80, 67, 42, 0.12);
}
.detailRefMetaLine {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  font-size: 14px;
  color: rgba(31, 31, 31, 0.7);
  letter-spacing: 0.2px;
}
.detailRefTitle {
  margin: 14px 0 18px;
  font-size: clamp(34px, 4vw, 56px);
  line-height: 1.08;
  font-weight: 700;
  color: #171717;
}
.detailRefIntro {
  max-width: 980px;
  font-size: 18px;
  line-height: 2;
  color: #242424;
}
.detailRefIntro p {
  margin: 0;
  white-space: pre-line;
}
.detailReferenceFigure {
  margin: 28px 0 0;
}
.detailReferenceCover {
  height: clamp(340px, 44vw, 720px) !important;
  border-radius: 0 !important;
  overflow: hidden;
  box-shadow: none !important;
}
.detailReferenceFigure figcaption {
  margin-top: 10px;
  font-size: 13px;
  color: rgba(0, 0, 0, 0.42);
  letter-spacing: 1.2px;
}
.detailReferenceActions {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  margin: 28px 0 34px;
}
.detailReferenceBody {
  display: flex;
  flex-direction: column;
  gap: 22px;
}
.detailReferenceSection {
  background: #fff;
  border: 1px solid rgba(101, 82, 51, 0.12);
  padding: 30px 32px 34px;
  border-radius: 0;
  box-shadow: none;
}
.detailReferencePoem {
  padding-top: 34px;
}
.detailReferenceSectionHead {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
}
.detailReferenceSectionTitle {
  font-size: 22px;
  font-weight: 700;
  color: #121212;
}
.detailReferenceSectionSub {
  font-size: 14px;
  letter-spacing: 2px;
  color: rgba(0, 0, 0, 0.32);
}
.detailReferencePoemText {
  white-space: pre-line;
  font-size: 23px;
  line-height: 2.05;
  font-weight: 700;
  color: #191919;
}
.detailReferenceText {
  white-space: pre-line;
  font-size: 18px;
  line-height: 2;
  color: #242424;
}
.detailReferenceEmpty {
  font-size: 16px;
  color: rgba(0, 0, 0, 0.42);
}
.detailReferenceTags {
  padding-top: 24px;
}
.detailReferenceTagList {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}
.detailReferenceTag {
  padding: 9px 16px;
  border-radius: 999px;
  background: #efebe3;
  border: 1px solid rgba(0, 0, 0, 0.08);
  color: #3d3d3d;
  font-size: 14px;
}
.detailReferenceAside {
  position: sticky;
  top: 24px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.detailReferenceAsideBlock {
  background: transparent;
  border: 0;
  border-bottom: 1px solid rgba(95, 76, 48, 0.12);
  padding: 4px 0 16px;
}
.detailReferenceAsideTitle {
  margin-bottom: 16px;
  font-size: 16px;
  font-weight: 700;
  color: #171717;
}
.detailReferenceInfoRow {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 10px 0;
  border-bottom: 1px dashed rgba(0, 0, 0, 0.08);
}
.detailReferenceInfoRow:last-child {
  border-bottom: 0;
}
.detailReferenceInfoRow span {
  flex: 0 0 78px;
  font-size: 14px;
  color: rgba(0, 0, 0, 0.52);
}
.detailReferenceInfoRow strong {
  flex: 1;
  text-align: left;
  font-size: 15px;
  line-height: 1.8;
  color: #171717;
  font-weight: 500;
}
.detailReferenceQuote {
  font-size: 18px;
  line-height: 1.9;
  color: #1c1c1c;
}
.detailReferenceAsideBtn {
  display: block;
  width: 100%;
  margin-bottom: 10px;
  padding: 12px 14px;
  border: 1px solid rgba(138, 47, 43, 0.2);
  background: #fff;
  color: #171717;
  font-size: 14px;
  text-align: left;
  cursor: pointer;
  transition: transform 0.2s ease, border-color 0.2s ease, background 0.2s ease;
}
.detailReferenceAsideBtn:hover {
  transform: translateX(4px);
  border-color: rgba(138, 47, 43, 0.5);
  background: rgba(138, 47, 43, 0.05);
}
.detailReferenceAsideBtn:last-child {
  margin-bottom: 0;
}
@media (max-width: 1180px) {
  .detailReferenceLayout {
    grid-template-columns: 1fr;
    gap: 32px;
  }
  .detailReferenceAside {
    position: static;
  }
}
@media (max-width: 860px) {
  .detailReferencePanel {
    width: calc(100vw - 18px) !important;
    padding: 18px 14px 26px !important;
    border-radius: 10px !important;
  }
  .detailRefTitle {
    font-size: 32px;
  }
  .detailRefIntro {
    font-size: 16px;
    line-height: 1.85;
  }
  .detailReferenceCover {
    height: 280px !important;
  }
  .detailReferenceSection {
    padding: 22px 18px 24px;
  }
  .detailReferencePoemText {
    font-size: 18px;
    line-height: 1.9;
  }
  .detailReferenceText,
  .detailReferenceQuote {
    font-size: 16px;
    line-height: 1.9;
  }
}

</style>


<style scoped>
.lib {
  background: linear-gradient(180deg, #fefdfb 0%, #faf7f0 40%, #f4ecd8 70%, #e8dcc0 100%) !important;
}
.contentScreen {
  background: linear-gradient(180deg, #fefdfb 0%, #faf7f0 40%, #f4ecd8 70%, #e8dcc0 100%) !important;
  min-height: 100vh;
}
.contentWrapper {
  width: min(1680px, calc(100vw - 36px));
  margin: 0 auto;
  padding: 34px 0 56px !important;
}
.searchSection {
  position: sticky;
  top: 0;
  z-index: 20;
  background: rgba(244, 236, 216, 0.98) !important;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(0,0,0,0.06);
  box-shadow: 0 16px 40px rgba(0,0,0,0.06);
  border-radius: 20px;
  padding: 18px 20px !important;
  margin-bottom: 28px !important;
}
.searchCenter {
  margin-bottom: 14px;
}
.searchBoxLight {
  height: 58px;
  border-radius: 16px !important;
  background: rgba(244, 236, 216, 0.95) !important;
  border: 1px solid rgba(0,0,0,0.08) !important;
  box-shadow: none !important;
}
.searchBoxLight input {
  font-size: 16px;
  color: #222;
}
.searchSubmitBtnLight, .resetBtnLight, .shuffleBtnLight, .navTabInline {
  border-radius: 12px !important;
  min-height: 42px;
}
.gridWrap {
  background: transparent !important;
  padding: 0 !important;
}
.gridHead {
  margin-bottom: 18px;
}
.grid {
  grid-template-columns: repeat(3, minmax(0, 1fr)) !important;
  gap: 28px !important;
}
.cardElegant {
  display: flex;
  flex-direction: column;
  background: linear-gradient(180deg, #e8d4b0 0%, #dcc490 100%) !important;
  border: 1px solid rgba(0,0,0,0.08) !important;
  border-radius: 0 !important;
  overflow: hidden;
  box-shadow: 0 10px 24px rgba(0,0,0,0.08) !important;
  transition: transform .22s ease, box-shadow .22s ease;
}
.cardElegant:hover {
  transform: translateY(-6px);
  box-shadow: 0 18px 38px rgba(0,0,0,0.12) !important;
}
.posterElegant {
  height: 292px !important;
  min-height: 292px;
  border-radius: 0 !important;
  margin: 0 !important;
  overflow: hidden;
}
.posterElegant .posterMask {
  background: linear-gradient(to top, rgba(0,0,0,0.14), rgba(0,0,0,0.02)) !important;
}
.cardElegant .rating,
.cardElegant .hover,
.cardElegant .tags {
  display: none !important;
}
.infoElegant {
  padding: 18px 20px 0 !important;
  background: linear-gradient(180deg, #f4ecd8 0%, #e8dcc0 100%) !important;
  min-height: 270px;
  display: flex;
  flex-direction: column;
}
.infoElegant .metaLine {
  font-size: 13px;
  color: #585858 !important;
  margin-bottom: 10px;
}
.infoElegant .title {
  font-size: 22px !important;
  line-height: 1.25;
  color: #111 !important;
  margin-bottom: 10px;
}
.infoElegant .meta {
  font-size: 13px;
  color: #666 !important;
  margin-bottom: 16px;
}
.infoElegant .excerpt {
  color: #3f3f3f !important;
  font-size: 16px;
  line-height: 1.85;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 4;
  overflow: hidden;
  min-height: 118px;
}
.cardFoot {
  margin-top: auto;
  display: flex;
  justify-content: flex-end;
  gap: 0;
  padding-top: 18px;
}
.cardGhostBtn,
.cardDarkBtn {
  height: 52px;
  padding: 0 26px;
  border: 0;
  font-size: 16px;
  cursor: pointer;
}
.cardGhostBtn {
  background: #F5F5DC;
  color: #6e6557;
}
.cardDarkBtn {
  background: #b32418;
  color: #fff;
}
.topicHero {
  margin-bottom: 24px;
}
.topicHeroCard {
  border-radius: 18px !important;
  overflow: hidden;
  box-shadow: 0 14px 34px rgba(0,0,0,.10) !important;
}
.detailPageModal {
  background: rgba(238, 238, 234, 0.92) !important;
  align-items: flex-start !important;
  padding: 22px !important;
  overflow-y: auto;
}
.detailPagePanel {
  width: min(1520px, calc(100vw - 44px)) !important;
  max-width: none !important;
  margin: 0 auto !important;
  background: #f6f5f1 !important;
  border-radius: 0 !important;
  box-shadow: 0 10px 30px rgba(0,0,0,0.08) !important;
  padding: 28px 34px 34px !important;
  position: relative;
}
.detailCloseBtn {
  position: sticky !important;
  top: 0;
  margin-left: auto;
  z-index: 3;
  display: grid;
  place-items: center;
  width: 44px;
  height: 44px;
  border-radius: 50%;
  border: 1px solid rgba(0,0,0,.08);
  background: rgba(255,255,255,.88);
  color: #333;
}
.detailPageGrid {
  display: grid;
  grid-template-columns: minmax(0, 1.7fr) 350px;
  gap: 54px;
  align-items: start;
}
.detailTopIntro {
  display: grid;
  gap: 20px;
  margin-bottom: 28px;
}
.detailTitleBlock .pTitle {
  font-size: 52px !important;
  line-height: 1.08;
  letter-spacing: 1px;
  color: #1f1f1f !important;
  margin-bottom: 10px;
}
.detailTitleBlock .pMeta {
  font-size: 18px !important;
  color: #5b5b5b !important;
}
.detailLeadText {
  max-width: 980px;
  color: #252525;
  font-size: 18px;
  line-height: 2.05;
}
.detailLeadText p {
  margin: 0;
}
.detailMainImage {
  margin: 0 0 26px;
}
.detailMainCover {
  height: 760px !important;
  border-radius: 0 !important;
  overflow: hidden;
  border: 1px solid rgba(0,0,0,.08);
  box-shadow: none !important;
}
.detailTopActions {
  margin-bottom: 24px;
  flex-wrap: wrap;
}
.detailTopActions .primary,
.detailTopActions .ghost {
  min-width: 132px;
  height: 46px;
  border-radius: 10px !important;
}
.detailArticleBody {
  display: grid;
  gap: 18px;
}
.detailArticleBody .readCard {
  background: #fff !important;
  border: 1px solid rgba(0,0,0,.07) !important;
  box-shadow: none !important;
  border-radius: 0 !important;
  padding: 24px 26px !important;
}
.detailArticleBody .poem,
.detailArticleBody .text {
  color: #222 !important;
  font-size: 18px;
  line-height: 2;
  white-space: pre-wrap;
}
.detailInfoAside {
  position: sticky;
  top: 24px;
}
.detailInfoCard {
  background: transparent;
  border-left: 1px solid rgba(0,0,0,0.10);
  padding-left: 26px;
}
.asideTitle {
  font-size: 28px;
  color: #1f1f1f;
  margin-bottom: 24px;
  font-weight: 700;
}
.asideRow {
  display: grid;
  grid-template-columns: 88px 1fr;
  gap: 14px;
  align-items: start;
  padding: 12px 0;
  border-bottom: 1px dashed rgba(0,0,0,.09);
  color: #444;
}
.asideRow span {
  color: #b26b6b;
}
.asideRow b {
  font-weight: 500;
  color: #222;
  line-height: 1.8;
}
.asideQuote {
  margin-top: 26px;
  color: #a12828;
  font-size: 18px;
  line-height: 1.9;
}
@media (max-width: 1400px) {
  .grid { grid-template-columns: repeat(2, minmax(0, 1fr)) !important; }
  .detailPageGrid { grid-template-columns: 1fr 300px; gap: 32px; }
  .detailMainCover { height: 620px !important; }
}
@media (max-width: 1080px) {
  .detailPageGrid { grid-template-columns: 1fr; }
  .detailInfoAside { position: static; }
  .detailInfoCard { border-left: 0; padding-left: 0; }
  .detailTitleBlock .pTitle { font-size: 38px !important; }
}
@media (max-width: 860px) {
  .grid { grid-template-columns: 1fr !important; }
  .contentWrapper { width: min(100vw - 20px, 1680px); }
  .detailPagePanel { width: calc(100vw - 18px) !important; padding: 18px 14px 24px !important; }
  .detailMainCover { height: 420px !important; }
  .detailTitleBlock .pTitle { font-size: 30px !important; }
  .detailLeadText, .detailArticleBody .poem, .detailArticleBody .text { font-size: 16px; }
  .searchSection { padding: 14px !important; border-radius: 14px; }
}

.detailReferencePanel {
  width: min(1520px, calc(100vw - 48px)) !important;
  max-width: none !important;
  padding: 42px 54px 56px !important;
  background: #f5f2ea !important;
  border: 1px solid rgba(91, 72, 42, 0.12) !important;
  border-radius: 18px !important;
  box-shadow: 0 18px 50px rgba(0, 0, 0, 0.12) !important;
}
.detailReferenceLayout {
  display: grid;
  grid-template-columns: minmax(0, 1.72fr) 340px;
  gap: 56px;
  align-items: start;
}
.detailReferenceMain {
  min-width: 0;
}
.detailReferenceHeader {
  padding-bottom: 24px;
  border-bottom: 1px solid rgba(80, 67, 42, 0.12);
}
.detailRefMetaLine {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  font-size: 14px;
  color: rgba(31, 31, 31, 0.7);
  letter-spacing: 0.2px;
}
.detailRefTitle {
  margin: 14px 0 18px;
  font-size: clamp(34px, 4vw, 56px);
  line-height: 1.08;
  font-weight: 700;
  color: #171717;
}
.detailRefIntro {
  max-width: 980px;
  font-size: 18px;
  line-height: 2;
  color: #242424;
}
.detailRefIntro p {
  margin: 0;
  white-space: pre-line;
}
.detailReferenceFigure {
  margin: 28px 0 0;
}
.detailReferenceCover {
  height: clamp(340px, 44vw, 720px) !important;
  border-radius: 0 !important;
  overflow: hidden;
  box-shadow: none !important;
}
.detailReferenceFigure figcaption {
  margin-top: 10px;
  font-size: 13px;
  color: rgba(0, 0, 0, 0.42);
  letter-spacing: 1.2px;
}
.detailReferenceActions {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  margin: 28px 0 34px;
}
.detailReferenceBody {
  display: flex;
  flex-direction: column;
  gap: 22px;
}
.detailReferenceSection {
  background: #fff;
  border: 1px solid rgba(101, 82, 51, 0.12);
  padding: 30px 32px 34px;
  border-radius: 0;
  box-shadow: none;
}
.detailReferencePoem {
  padding-top: 34px;
}
.detailReferenceSectionHead {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
}
.detailReferenceSectionTitle {
  font-size: 22px;
  font-weight: 700;
  color: #121212;
}
.detailReferenceSectionSub {
  font-size: 14px;
  letter-spacing: 2px;
  color: rgba(0, 0, 0, 0.32);
}
.detailReferencePoemText {
  white-space: pre-line;
  font-size: 23px;
  line-height: 2.05;
  font-weight: 700;
  color: #191919;
}
.detailReferenceText {
  white-space: pre-line;
  font-size: 18px;
  line-height: 2;
  color: #242424;
}
.detailReferenceEmpty {
  font-size: 16px;
  color: rgba(0, 0, 0, 0.42);
}
.detailReferenceTags {
  padding-top: 24px;
}
.detailReferenceTagList {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}
.detailReferenceTag {
  padding: 9px 16px;
  border-radius: 999px;
  background: #efebe3;
  border: 1px solid rgba(0, 0, 0, 0.08);
  color: #3d3d3d;
  font-size: 14px;
}
.detailReferenceAside {
  position: sticky;
  top: 24px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.detailReferenceAsideBlock {
  background: transparent;
  border: 0;
  border-bottom: 1px solid rgba(95, 76, 48, 0.12);
  padding: 4px 0 16px;
}
.detailReferenceAsideTitle {
  margin-bottom: 16px;
  font-size: 16px;
  font-weight: 700;
  color: #171717;
}
.detailReferenceInfoRow {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 10px 0;
  border-bottom: 1px dashed rgba(0, 0, 0, 0.08);
}
.detailReferenceInfoRow:last-child {
  border-bottom: 0;
}
.detailReferenceInfoRow span {
  flex: 0 0 78px;
  font-size: 14px;
  color: rgba(0, 0, 0, 0.52);
}
.detailReferenceInfoRow strong {
  flex: 1;
  text-align: left;
  font-size: 15px;
  line-height: 1.8;
  color: #171717;
  font-weight: 500;
}
.detailReferenceQuote {
  font-size: 18px;
  line-height: 1.9;
  color: #1c1c1c;
}
.detailReferenceAsideBtn {
  display: block;
  width: 100%;
  margin-bottom: 10px;
  padding: 12px 14px;
  border: 1px solid rgba(138, 47, 43, 0.2);
  background: #fff;
  color: #171717;
  font-size: 14px;
  text-align: left;
  cursor: pointer;
  transition: transform 0.2s ease, border-color 0.2s ease, background 0.2s ease;
}
.detailReferenceAsideBtn:hover {
  transform: translateX(4px);
  border-color: rgba(138, 47, 43, 0.5);
  background: rgba(138, 47, 43, 0.05);
}
.detailReferenceAsideBtn:last-child {
  margin-bottom: 0;
}
@media (max-width: 1180px) {
  .detailReferenceLayout {
    grid-template-columns: 1fr;
    gap: 32px;
  }
  .detailReferenceAside {
    position: static;
  }
}
@media (max-width: 860px) {
  .detailReferencePanel {
    width: calc(100vw - 18px) !important;
    padding: 18px 14px 26px !important;
    border-radius: 10px !important;
  }
  .detailRefTitle {
    font-size: 32px;
  }
  .detailRefIntro {
    font-size: 16px;
    line-height: 1.85;
  }
  .detailReferenceCover {
    height: 280px !important;
  }
  .detailReferenceSection {
    padding: 22px 18px 24px;
  }
  .detailReferencePoemText {
    font-size: 18px;
    line-height: 1.9;
  }
  .detailReferenceText,
  .detailReferenceQuote {
    font-size: 16px;
    line-height: 1.9;
  }
}

</style>

<style scoped>
.detailPageModal {
  background: rgba(239, 238, 232, 0.96) !important;
  backdrop-filter: blur(2px);
}
.detailPagePanel {
  width: min(1560px, calc(100vw - 40px)) !important;
  padding: 28px 34px 40px !important;
}
.detailPageGrid {
  display: grid;
  grid-template-columns: minmax(0, 1.78fr) 340px;
  gap: 42px;
  align-items: start;
}
.detailArticleCol {
  min-width: 0;
}
.detailTopIntro {
  display: grid;
  gap: 18px;
  margin-bottom: 24px;
}
.detailMetaStrip {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}
.detailMetaChip {
  display: inline-flex;
  align-items: center;
  min-height: 34px;
  padding: 0 14px;
  border-radius: 999px;
  border: 1px solid rgba(90, 79, 63, 0.10);
  background: rgba(255,255,255,0.72);
  color: #5a4f3f;
  font-size: 13px;
  letter-spacing: 0.5px;
}
.detailMetaChip.subtle {
  color: #7a736a;
}
.detailTitleBlock {
  padding-bottom: 18px;
  border-bottom: 1px solid rgba(0,0,0,.08);
}
.detailTitleBlock .pTitle {
  font-size: 58px !important;
  line-height: 1.04;
  margin-bottom: 12px;
}
.detailTitleBlock .pMeta {
  font-size: 17px !important;
  color: #666 !important;
  line-height: 1.8;
}
.detailLeadPanel {
  background: linear-gradient(180deg, rgba(255,255,255,.76), rgba(255,255,255,.52));
  border: 1px solid rgba(108, 96, 82, 0.08);
  border-radius: 18px;
  padding: 22px 24px;
}
.detailLeadText {
  max-width: none;
  font-size: 18px;
  line-height: 2;
  color: #2b2925;
}
.detailLeadText p {
  margin: 0;
}
.detailLeadQuote {
  font-size: 22px;
  line-height: 1.8;
  color: #8b2d2d;
  margin-bottom: 14px !important;
}
.detailMainImage {
  margin: 0 0 18px;
}
.detailMainCover {
  height: 760px !important;
  border-radius: 22px !important;
  overflow: hidden;
  border: 1px solid rgba(0,0,0,.08);
  box-shadow: 0 20px 46px rgba(0,0,0,.08) !important;
}
.detailImageCaption {
  margin-top: 10px;
  color: #7d746a;
  font-size: 13px;
  letter-spacing: 0.8px;
}
.detailActionBar {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-bottom: 26px;
}
.detailActionBar .primary,
.detailActionBar .ghost {
  min-width: 138px;
  height: 48px;
  border-radius: 12px !important;
}
.detailArticleBody {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 18px;
}
.detailWideCard {
  grid-column: 1 / -1;
}
.detailArticleBody .readCard {
  background: rgba(255,255,255,0.96) !important;
  border: 1px solid rgba(90, 79, 63, 0.08) !important;
  border-radius: 18px !important;
  padding: 24px 24px 26px !important;
  box-shadow: 0 10px 28px rgba(0,0,0,.04) !important;
}
.detailArticleBody .secHead {
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid rgba(0,0,0,.06);
}
.detailArticleBody .secT {
  font-size: 24px;
}
.detailArticleBody .secSub {
  color: #9a8f80;
}
.detailArticleBody .poem,
.detailArticleBody .text {
  font-size: 18px;
  line-height: 2;
  color: #25231f !important;
}
.detailArticleBody .chips {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}
.detailArticleBody .chip {
  background: #f5f1ea;
  border: 1px solid rgba(0,0,0,.06);
  color: #615646;
}
.detailInfoAside {
  position: sticky;
  top: 18px;
  display: grid;
  gap: 16px;
}
.detailInfoCard {
  background: rgba(255,255,255,0.82);
  border: 1px solid rgba(90, 79, 63, 0.08);
  border-radius: 18px;
  padding: 20px 20px 22px;
  box-shadow: 0 10px 24px rgba(0,0,0,.04);
}
.detailInfoPrimary {
  background: rgba(255,255,255,0.88);
}
.asideTitle,
.asideSmallTitle {
  color: #1f1f1f;
  font-weight: 700;
}
.asideTitle {
  font-size: 24px;
  margin-bottom: 18px;
}
.asideSmallTitle {
  font-size: 18px;
  margin-bottom: 14px;
}
.asideRow {
  grid-template-columns: 72px 1fr;
  gap: 12px;
  padding: 10px 0;
}
.asideRow span {
  color: #b36b6b;
}
.asideRow b {
  font-weight: 500;
  line-height: 1.8;
}
.detailQuoteCard {
  background: linear-gradient(180deg, rgba(255,255,255,.9), rgba(250,246,239,.92));
}
.asideQuote {
  margin-top: 0;
  font-size: 17px;
  line-height: 1.95;
  color: #8c2b2b;
}
.detailMiniOps {
  display: grid;
  gap: 10px;
}
.asideOpBtn {
  height: 44px;
  border: 1px solid rgba(0,0,0,.08);
  border-radius: 12px;
  background: #fff;
  color: #40372c;
  font-size: 15px;
  cursor: pointer;
  transition: all .2s ease;
}
.asideOpBtn:hover {
  transform: translateY(-1px);
  box-shadow: 0 8px 18px rgba(0,0,0,.06);
}
@media (max-width: 1180px) {
  .detailPageGrid {
    grid-template-columns: 1fr;
  }
  .detailInfoAside {
    position: static;
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}
@media (max-width: 860px) {
  .detailPagePanel {
    width: calc(100vw - 16px) !important;
    padding: 18px 12px 24px !important;
  }
  .detailTitleBlock .pTitle {
    font-size: 34px !important;
  }
  .detailLeadText,
  .detailArticleBody .poem,
  .detailArticleBody .text {
    font-size: 16px;
  }
  .detailMainCover {
    height: 400px !important;
  }
  .detailArticleBody,
  .detailInfoAside {
    grid-template-columns: 1fr;
  }
}

.detailReferencePanel {
  width: min(1520px, calc(100vw - 48px)) !important;
  max-width: none !important;
  padding: 42px 54px 56px !important;
  background: #f5f2ea !important;
  border: 1px solid rgba(91, 72, 42, 0.12) !important;
  border-radius: 18px !important;
  box-shadow: 0 18px 50px rgba(0, 0, 0, 0.12) !important;
}
.detailReferenceLayout {
  display: grid;
  grid-template-columns: minmax(0, 1.72fr) 340px;
  gap: 56px;
  align-items: start;
}
.detailReferenceMain {
  min-width: 0;
}
.detailReferenceHeader {
  padding-bottom: 24px;
  border-bottom: 1px solid rgba(80, 67, 42, 0.12);
}
.detailRefMetaLine {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  font-size: 14px;
  color: rgba(31, 31, 31, 0.7);
  letter-spacing: 0.2px;
}
.detailRefTitle {
  margin: 14px 0 18px;
  font-size: clamp(34px, 4vw, 56px);
  line-height: 1.08;
  font-weight: 700;
  color: #171717;
}
.detailRefIntro {
  max-width: 980px;
  font-size: 18px;
  line-height: 2;
  color: #242424;
}
.detailRefIntro p {
  margin: 0;
  white-space: pre-line;
}
.detailReferenceFigure {
  margin: 28px 0 0;
}
.detailReferenceCover {
  height: clamp(340px, 44vw, 720px) !important;
  border-radius: 0 !important;
  overflow: hidden;
  box-shadow: none !important;
}
.detailReferenceFigure figcaption {
  margin-top: 10px;
  font-size: 13px;
  color: rgba(0, 0, 0, 0.42);
  letter-spacing: 1.2px;
}
.detailReferenceActions {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  margin: 28px 0 34px;
}
.detailReferenceBody {
  display: flex;
  flex-direction: column;
  gap: 22px;
}
.detailReferenceSection {
  background: #fff;
  border: 1px solid rgba(101, 82, 51, 0.12);
  padding: 30px 32px 34px;
  border-radius: 0;
  box-shadow: none;
}
.detailReferencePoem {
  padding-top: 34px;
}
.detailReferenceSectionHead {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
}
.detailReferenceSectionTitle {
  font-size: 22px;
  font-weight: 700;
  color: #121212;
}
.detailReferenceSectionSub {
  font-size: 14px;
  letter-spacing: 2px;
  color: rgba(0, 0, 0, 0.32);
}
.detailReferencePoemText {
  white-space: pre-line;
  font-size: 23px;
  line-height: 2.05;
  font-weight: 700;
  color: #191919;
}
.detailReferenceText {
  white-space: pre-line;
  font-size: 18px;
  line-height: 2;
  color: #242424;
}
.detailReferenceEmpty {
  font-size: 16px;
  color: rgba(0, 0, 0, 0.42);
}
.detailReferenceTags {
  padding-top: 24px;
}
.detailReferenceTagList {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}
.detailReferenceTag {
  padding: 9px 16px;
  border-radius: 999px;
  background: #efebe3;
  border: 1px solid rgba(0, 0, 0, 0.08);
  color: #3d3d3d;
  font-size: 14px;
}
.detailReferenceAside {
  position: sticky;
  top: 24px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.detailReferenceAsideBlock {
  background: transparent;
  border: 0;
  border-bottom: 1px solid rgba(95, 76, 48, 0.12);
  padding: 4px 0 16px;
}
.detailReferenceAsideTitle {
  margin-bottom: 16px;
  font-size: 16px;
  font-weight: 700;
  color: #171717;
}
.detailReferenceInfoRow {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 10px 0;
  border-bottom: 1px dashed rgba(0, 0, 0, 0.08);
}
.detailReferenceInfoRow:last-child {
  border-bottom: 0;
}
.detailReferenceInfoRow span {
  flex: 0 0 78px;
  font-size: 14px;
  color: rgba(0, 0, 0, 0.52);
}
.detailReferenceInfoRow strong {
  flex: 1;
  text-align: left;
  font-size: 15px;
  line-height: 1.8;
  color: #171717;
  font-weight: 500;
}
.detailReferenceQuote {
  font-size: 18px;
  line-height: 1.9;
  color: #1c1c1c;
}
.detailReferenceAsideBtn {
  display: block;
  width: 100%;
  margin-bottom: 10px;
  padding: 12px 14px;
  border: 1px solid rgba(138, 47, 43, 0.2);
  background: #fff;
  color: #171717;
  font-size: 14px;
  text-align: left;
  cursor: pointer;
  transition: transform 0.2s ease, border-color 0.2s ease, background 0.2s ease;
}
.detailReferenceAsideBtn:hover {
  transform: translateX(4px);
  border-color: rgba(138, 47, 43, 0.5);
  background: rgba(138, 47, 43, 0.05);
}
.detailReferenceAsideBtn:last-child {
  margin-bottom: 0;
}
@media (max-width: 1180px) {
  .detailReferenceLayout {
    grid-template-columns: 1fr;
    gap: 32px;
  }
  .detailReferenceAside {
    position: static;
  }
}
@media (max-width: 860px) {
  .detailReferencePanel {
    width: calc(100vw - 18px) !important;
    padding: 18px 14px 26px !important;
    border-radius: 10px !important;
  }
  .detailRefTitle {
    font-size: 32px;
  }
  .detailRefIntro {
    font-size: 16px;
    line-height: 1.85;
  }
  .detailReferenceCover {
    height: 280px !important;
  }
  .detailReferenceSection {
    padding: 22px 18px 24px;
  }
  .detailReferencePoemText {
    font-size: 18px;
    line-height: 1.9;
  }
  .detailReferenceText,
  .detailReferenceQuote {
    font-size: 16px;
    line-height: 1.9;
  }
}

</style>

<style scoped>
.detailArticleDivider {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 34px 0 26px;
}
.detailArticleDivider::before {
  content: "";
  position: absolute;
  inset: 50% 0 auto 0;
  border-top: 1px solid rgba(0, 0, 0, 0.1);
}
.detailArticleDivider span {
  position: relative;
  z-index: 1;
  padding: 0 18px;
  background: #f6f5f1;
  color: #d96f6f;
  font-size: 24px;
  line-height: 1;
  letter-spacing: 2px;
}
.detailArticleBody {
  gap: 34px 28px !important;
  align-items: start;
}
.detailArticleBody .readCard {
  background: transparent !important;
  border: 0 !important;
  border-radius: 0 !important;
  box-shadow: none !important;
  padding: 0 !important;
  min-height: 0 !important;
}
.articleSection {
  position: relative;
  padding-top: 26px !important;
}
.articleSection::before {
  content: "";
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  border-top: 1px solid rgba(0, 0, 0, 0.08);
}
.articlePoemSection {
  padding-top: 18px !important;
}
.articlePoemSection::before,
.articleTagSection::before {
  border-top-color: rgba(0, 0, 0, 0.1);
}
.articleSecHead {
  display: flex !important;
  align-items: baseline;
  justify-content: space-between;
  gap: 20px;
  margin-bottom: 22px !important;
  padding-bottom: 0 !important;
  border-bottom: 0 !important;
}
.articleSecHead .secT {
  font-size: 22px !important;
  font-weight: 800 !important;
  color: #171717 !important;
  letter-spacing: 0.5px;
}
.articleSecHead .secSub {
  font-size: 14px !important;
  color: rgba(0, 0, 0, 0.32) !important;
  letter-spacing: 2px;
}
.articlePoemText {
  font-size: 22px !important;
  line-height: 2.05 !important;
  color: #171717 !important;
  font-weight: 700 !important;
  white-space: pre-line;
}
.articleBodyText {
  font-size: 18px !important;
  line-height: 2.05 !important;
  color: #242424 !important;
  white-space: pre-line;
}
.articleChips {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}
.articleChips .chip {
  border-radius: 999px !important;
  background: #ece8e1 !important;
  border: 1px solid rgba(0, 0, 0, 0.08) !important;
  color: #444 !important;
  padding: 10px 16px !important;
  font-size: 15px !important;
  box-shadow: none !important;
}
.detailArticleBody .emptyText {
  padding: 0 !important;
  background: transparent !important;
  border: 0 !important;
  color: rgba(0, 0, 0, 0.44) !important;
  font-size: 16px !important;
}
@media (max-width: 860px) {
  .detailArticleDivider {
    margin: 24px 0 18px;
  }
  .detailArticleDivider span {
    font-size: 20px;
    padding: 0 12px;
  }
  .articleSecHead .secT {
    font-size: 20px !important;
  }
  .articlePoemText {
    font-size: 18px !important;
    line-height: 1.9 !important;
  }
  .articleBodyText {
    font-size: 16px !important;
    line-height: 1.9 !important;
  }
}

.detailReferencePanel {
  width: min(1520px, calc(100vw - 48px)) !important;
  max-width: none !important;
  padding: 42px 54px 56px !important;
  background: #f5f2ea !important;
  border: 1px solid rgba(91, 72, 42, 0.12) !important;
  border-radius: 18px !important;
  box-shadow: 0 18px 50px rgba(0, 0, 0, 0.12) !important;
}
.detailReferenceLayout {
  display: grid;
  grid-template-columns: minmax(0, 1.72fr) 340px;
  gap: 56px;
  align-items: start;
}
.detailReferenceMain {
  min-width: 0;
}
.detailReferenceHeader {
  padding-bottom: 24px;
  border-bottom: 1px solid rgba(80, 67, 42, 0.12);
}
.detailRefMetaLine {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  font-size: 14px;
  color: rgba(31, 31, 31, 0.7);
  letter-spacing: 0.2px;
}
.detailRefTitle {
  margin: 14px 0 18px;
  font-size: clamp(34px, 4vw, 56px);
  line-height: 1.08;
  font-weight: 700;
  color: #171717;
}
.detailRefIntro {
  max-width: 980px;
  font-size: 18px;
  line-height: 2;
  color: #242424;
}
.detailRefIntro p {
  margin: 0;
  white-space: pre-line;
}
.detailReferenceFigure {
  margin: 28px 0 0;
}
.detailReferenceCover {
  height: clamp(340px, 44vw, 720px) !important;
  border-radius: 0 !important;
  overflow: hidden;
  box-shadow: none !important;
}
.detailReferenceFigure figcaption {
  margin-top: 10px;
  font-size: 13px;
  color: rgba(0, 0, 0, 0.42);
  letter-spacing: 1.2px;
}
.detailReferenceActions {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  margin: 28px 0 34px;
}
.detailReferenceBody {
  display: flex;
  flex-direction: column;
  gap: 22px;
}
.detailReferenceSection {
  background: #fff;
  border: 1px solid rgba(101, 82, 51, 0.12);
  padding: 30px 32px 34px;
  border-radius: 0;
  box-shadow: none;
}
.detailReferencePoem {
  padding-top: 34px;
}
.detailReferenceSectionHead {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
}
.detailReferenceSectionTitle {
  font-size: 22px;
  font-weight: 700;
  color: #121212;
}
.detailReferenceSectionSub {
  font-size: 14px;
  letter-spacing: 2px;
  color: rgba(0, 0, 0, 0.32);
}
.detailReferencePoemText {
  white-space: pre-line;
  font-size: 23px;
  line-height: 2.05;
  font-weight: 700;
  color: #191919;
}
.detailReferenceText {
  white-space: pre-line;
  font-size: 18px;
  line-height: 2;
  color: #242424;
}
.detailReferenceEmpty {
  font-size: 16px;
  color: rgba(0, 0, 0, 0.42);
}
.detailReferenceTags {
  padding-top: 24px;
}
.detailReferenceTagList {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}
.detailReferenceTag {
  padding: 9px 16px;
  border-radius: 999px;
  background: #efebe3;
  border: 1px solid rgba(0, 0, 0, 0.08);
  color: #3d3d3d;
  font-size: 14px;
}
.detailReferenceAside {
  position: sticky;
  top: 24px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.detailReferenceAsideBlock {
  background: transparent;
  border: 0;
  border-bottom: 1px solid rgba(95, 76, 48, 0.12);
  padding: 4px 0 16px;
}
.detailReferenceAsideTitle {
  margin-bottom: 16px;
  font-size: 16px;
  font-weight: 700;
  color: #171717;
}
.detailReferenceInfoRow {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 10px 0;
  border-bottom: 1px dashed rgba(0, 0, 0, 0.08);
}
.detailReferenceInfoRow:last-child {
  border-bottom: 0;
}
.detailReferenceInfoRow span {
  flex: 0 0 78px;
  font-size: 14px;
  color: rgba(0, 0, 0, 0.52);
}
.detailReferenceInfoRow strong {
  flex: 1;
  text-align: left;
  font-size: 15px;
  line-height: 1.8;
  color: #171717;
  font-weight: 500;
}
.detailReferenceQuote {
  font-size: 18px;
  line-height: 1.9;
  color: #1c1c1c;
}
.detailReferenceAsideBtn {
  display: block;
  width: 100%;
  margin-bottom: 10px;
  padding: 12px 14px;
  border: 1px solid rgba(138, 47, 43, 0.2);
  background: #fff;
  color: #171717;
  font-size: 14px;
  text-align: left;
  cursor: pointer;
  transition: transform 0.2s ease, border-color 0.2s ease, background 0.2s ease;
}
.detailReferenceAsideBtn:hover {
  transform: translateX(4px);
  border-color: rgba(138, 47, 43, 0.5);
  background: rgba(138, 47, 43, 0.05);
}
.detailReferenceAsideBtn:last-child {
  margin-bottom: 0;
}
@media (max-width: 1180px) {
  .detailReferenceLayout {
    grid-template-columns: 1fr;
    gap: 32px;
  }
  .detailReferenceAside {
    position: static;
  }
}
@media (max-width: 860px) {
  .detailReferencePanel {
    width: calc(100vw - 18px) !important;
    padding: 18px 14px 26px !important;
    border-radius: 10px !important;
  }
  .detailRefTitle {
    font-size: 32px;
  }
  .detailRefIntro {
    font-size: 16px;
    line-height: 1.85;
  }
  .detailReferenceCover {
    height: 280px !important;
  }
  .detailReferenceSection {
    padding: 22px 18px 24px;
  }
  .detailReferencePoemText {
    font-size: 18px;
    line-height: 1.9;
  }
  .detailReferenceText,
  .detailReferenceQuote {
    font-size: 16px;
    line-height: 1.9;
  }
}



/* ===== 书格风详情页终版覆盖 ===== */
.detailPageModal {
  padding: 0 !important;
  align-items: stretch !important;
  justify-content: stretch !important;
}
.detailShugePanel {
  position: relative;
  width: 100vw !important;
  max-width: none !important;
  height: 100vh !important;
  max-height: 100vh !important;
  overflow-y: auto !important;
  padding: 34px 56px 54px !important;
  background: #f3f0e8 !important;
  border-radius: 0 !important;
  border: 0 !important;
  box-shadow: none !important;
}
.detailShugeTopLine {
  display: none !important;
}
.detailShugeClose {
  position: fixed !important;
  top: 18px !important;
  right: 22px !important;
  width: 46px !important;
  height: 46px !important;
  border-radius: 50% !important;
  border: 1px solid rgba(90, 69, 36, 0.14) !important;
  background: rgba(255,255,255,0.9) !important;
  color: #473622 !important;
  z-index: 1005 !important;
  box-shadow: 0 10px 24px rgba(0,0,0,.12) !important;
}
.detailShugeLayout {
  min-height: calc(100vh - 96px);
  grid-template-columns: minmax(0, 1.78fr) 360px;
  gap: 60px;
}
.detailShugeMain {
  position: relative;
}
.detailShugeHeader {
  padding: 0 0 30px;
  border-bottom: none;
}
.detailShugeHeaderInner {
  position: relative;
  padding-right: 92px;
}
.detailShugeHeaderInner::after {
  content: '';
  position: absolute;
  left: 0;
  right: 92px;
  bottom: -8px;
  height: 1px;
  background: rgba(109, 86, 46, 0.14);
}
.detailShugeMetaLine {
  gap: 10px;
  font-size: 15px;
  color: rgba(50, 41, 27, 0.7);
}
.detailShugeTitle {
  margin: 12px 0 18px;
  font-size: clamp(40px, 4.2vw, 62px);
  line-height: 1.05;
  letter-spacing: 1px;
}
.detailShugeSummary {
  max-width: 980px;
  font-size: 20px;
  line-height: 2.02;
  color: #26211b;
}
.detailShugeSummary p {
  margin: 0;
  white-space: pre-line;
}
.detailShugeFigure {
  margin-top: 30px;
}
.detailShugeCover {
  height: clamp(420px, 46vw, 820px) !important;
  border: 1px solid rgba(110, 85, 42, 0.12);
  background-color: #e7ddc8;
}
.detailShugeCoverMask {
  background: linear-gradient(180deg, rgba(0,0,0,0.08) 0%, rgba(0,0,0,0.22) 100%) !important;
}
.detailShugeBadges {
  gap: 10px;
}
.detailShugeFigure figcaption {
  margin-top: 12px;
  color: rgba(57, 44, 26, 0.48);
  font-size: 13px;
  letter-spacing: 1.6px;
}
.detailShugeActions {
  gap: 12px;
  margin: 26px 0 30px;
}
.detailShugePrimary,
.detailShugeGhost {
  min-width: 126px;
  padding: 12px 18px !important;
  border-radius: 0 !important;
  letter-spacing: 0.5px;
}
.detailShugePrimary {
  background: #3a3126 !important;
}
.detailShugeGhost {
  background: #fff !important;
  border: 1px solid rgba(81, 63, 36, 0.16) !important;
}
.detailShugeDivider {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 10px 0 26px;
  color: #d96b69;
  font-size: 20px;
  letter-spacing: 4px;
}
.detailShugeDivider::before,
.detailShugeDivider::after {
  content: '';
  flex: 1;
  height: 1px;
  background: rgba(111, 89, 52, 0.12);
}
.detailShugeDivider::before { margin-right: 18px; }
.detailShugeDivider::after { margin-left: 18px; }
.detailShugeBody {
  gap: 24px;
}
.detailShugeSection {
  position: relative;
  background: #fffdf8;
  border: 1px solid rgba(110, 86, 41, 0.1);
  padding: 34px 36px 36px;
}
.detailShugeSection::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  width: 6px;
  height: 100%;
  background: linear-gradient(180deg, #e26e6d 0%, rgba(226, 110, 109, 0.05) 100%);
}
.detailShugePoem {
  background: #fff;
}
.detailShugeSectionHead {
  margin-bottom: 20px;
}
.detailShugePoemText {
  font-size: 28px;
  line-height: 2.15;
  font-weight: 700;
  letter-spacing: 0.3px;
  color: #17120d;
}
.detailShugeText {
  font-size: 18px;
  line-height: 2.08;
  color: #26211b;
}
.detailShugeTags {
  padding-top: 28px;
}
.detailShugeTagList {
  gap: 14px;
}
.detailShugeTag {
  padding: 9px 18px;
  background: #f4efe6;
  border: 1px solid rgba(88, 68, 37, 0.1);
  color: #453421;
}
.detailShugeAside {
  position: sticky;
  top: 24px;
  gap: 22px;
}
.detailShugeCornerIcon {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  margin-bottom: 8px;
  color: #4d4538;
  font-size: 36px;
  letter-spacing: -3px;
}
.detailShugeAsideBlock {
  padding: 0 0 18px;
  border-bottom: 1px solid rgba(103, 81, 46, 0.12);
}
.detailShugeAsideTitle {
  position: relative;
  margin-bottom: 16px;
  padding-left: 24px;
  font-size: 18px;
  font-weight: 700;
  color: #241c14;
}
.detailShugeAsideTitle::before {
  content: '◌';
  position: absolute;
  left: 0;
  top: -1px;
  color: #f07a74;
  font-size: 18px;
}
.detailShugeInfoRow {
  padding: 12px 0;
  gap: 18px;
  border-bottom: none;
}
.detailShugeInfoRow span {
  flex: 0 0 86px;
  color: rgba(54, 43, 27, 0.58);
}
.detailShugeInfoRow strong {
  font-size: 16px;
  line-height: 1.85;
  color: #1b140d;
  font-weight: 500;
}
.detailShugeQuote {
  font-size: 18px;
  line-height: 1.95;
  color: #1e1710;
}
.detailShugeActionBlock {
  border-bottom: 0;
}
.detailShugeAsideBtn {
  margin-bottom: 12px;
  padding: 13px 15px;
  border-radius: 0;
  background: #fff;
  border: 1px solid rgba(95, 73, 39, 0.12);
  font-size: 15px;
  color: #21170f;
}
.detailShugeAsideBtn:hover {
  transform: translateX(0);
  border-color: rgba(224, 106, 103, 0.46);
  color: #c54d4b;
}
@media (max-width: 1180px) {
  .detailShugePanel {
    width: 100vw !important;
    height: 100vh !important;
    padding: 24px 22px 34px !important;
  }
  .detailShugeLayout {
    grid-template-columns: 1fr;
    gap: 34px;
  }
  .detailShugeAside {
    position: static;
  }
}
@media (max-width: 860px) {
  .detailShugeTopLine {
    display: none !important;
  }
  .detailShugeTitle {
    font-size: 32px;
  }
  .detailShugeSummary {
    font-size: 16px;
    line-height: 1.9;
  }
  .detailShugeCover {
    height: 280px !important;
  }
  .detailShugeSection {
    padding: 24px 18px 24px 22px;
  }
  .detailShugePoemText {
    font-size: 20px;
    line-height: 2;
  }
  .detailShugeText,
  .detailShugeQuote,
  .detailShugeInfoRow strong {
    font-size: 15px;
    line-height: 1.9;
  }
  .detailShugeClose {
    top: 12px !important;
    right: 12px !important;
    width: 42px !important;
    height: 42px !important;
  }
  .detailShugeHeaderInner {
    padding-right: 70px;
  }
  .detailShugeHeaderInner::after {
    right: 70px;
  }
}

/* fullscreen hard override */
.modal,
.detailShugeModal {
  inset: 0 !important;
  padding: 0 !important;
  margin: 0 !important;
  width: 100vw !important;
  height: 100vh !important;
  display: block !important;
}

.panel,
.detailShugePanel {
  width: 100vw !important;
  max-width: 100vw !important;
  min-width: 100vw !important;
  height: 100vh !important;
  max-height: 100vh !important;
  min-height: 100vh !important;
  margin: 0 !important;
  border-radius: 0 !important;
  left: 0 !important;
  right: 0 !important;
}

.detailShugePanel {
  padding: 34px 34px 40px !important;
  box-sizing: border-box !important;
}




.heroActions{
  display:flex;
  justify-content:center;
  align-items:center;
}

.heroCardsWrap{
  width:min(1200px, calc(100vw - 80px));
  margin:0 auto;
}

.heroCardsTrack{
  display:flex;
  /* 使用 flex-start 以确保首张卡片离开后，后面的卡片能产生“向前移动”的视觉填充效果 */
  justify-content: flex-start;
  gap:18px;
  width:100%;
  position: relative;
}

.heroFloatCard{
  /* 显式计算宽度，防止 transition-group 在过渡期间由于 flex-grow 导致的尺寸抖动 */
  flex: 0 0 calc(25% - 13.5px);
  min-width:0;
}

.heroBottomOps{
  display:none !important;
}

</style>


<style scoped>
/* ===== 书库入口页：在当前文件基础上新增，不影响原来的结果页 ===== */
.searchSection.shelfSearchSection {
  position: relative !important;
  z-index: 5 !important;
  padding: 26px 40px 10px !important;
  margin: 0 !important;
  border: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
}

.shelfTitleRow {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 18px;
  margin: 0 auto 24px;
  user-select: none;
}

.shelfMainTitle {
  margin: 0;
  color: #5b4b3a;
  font-size: clamp(30px, 2.4vw, 44px);
  line-height: 1;
  font-weight: 700;
  letter-spacing: 5px;
  text-shadow: 0 1px 0 rgba(255,255,255,0.75);
}

.shelfTitleDecor {
  width: clamp(28px, 2vw, 42px);
  height: clamp(28px, 2vw, 42px);
  object-fit: contain;
  opacity: 0.92;
}

.searchSection.shelfSearchSection .searchCenter {
  margin: 0 auto 12px !important;
  padding: 0 !important;
}

.searchSection.shelfSearchSection .searchBoxLight {
  width: min(1320px, 92vw) !important;
  max-width: 1320px !important;
  height: 58px !important;
  min-width: 0 !important;
  border-radius: 999px !important;
  background: rgba(255, 255, 255, 0.84) !important;
  border: 1px solid rgba(125, 102, 67, 0.13) !important;
  box-shadow: 0 10px 28px rgba(68, 48, 18, 0.04) !important;
}

.searchSection.shelfSearchSection .searchSubmitBtnLight {
  min-width: 104px;
  height: 42px;
  border-radius: 999px !important;
}

.searchSection.resultSearchSection {
  position: sticky !important;
  top: 0 !important;
  z-index: 20 !important;
}

.shelfBackBtn {
  border-color: rgba(128, 100, 54, 0.28) !important;
  color: #6b4c25 !important;
  background: rgba(255, 252, 246, 0.86) !important;
}

.landingBlock {
  margin-bottom: clamp(64px, 7vh, 112px);
}

.libraryShelfLanding {
  position: relative;
  width: min(1580px, calc(100vw - 92px));
  margin: 0 auto;
  padding: 8px 0 8px;
  overflow: visible;
}

.shelfRow {
  position: relative;
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  height: clamp(360px, 37vh, 430px);
  padding: 0 clamp(96px, 7.6vw, 144px) clamp(40px, 3.8vw, 58px);
  margin: 0 auto clamp(82px, 8vh, 118px);
}

.shelfRowBottom {
  margin-bottom: 0;
}

.shelfBoard {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  width: 100%;
  height: clamp(48px, 4.6vw, 72px);
  object-fit: fill;
  z-index: 4;
  pointer-events: none;
  filter: drop-shadow(0 12px 14px rgba(72, 45, 12, 0.18));
}

.shelfBookBtn {
  position: relative;
  z-index: 2;
  width: clamp(120px, 11vw, 188px);
  height: clamp(198px, 18.5vw, 298px);
  margin: 0;
  padding: 0;
  border: 0;
  outline: none;
  background: transparent;
  cursor: pointer;
  transform-origin: 50% 100%;
  transition: transform 0.24s ease, filter 0.24s ease;
}

.shelfBookBtn:hover {
  transform: translateY(-12px) scale(1.035);
  filter: drop-shadow(0 18px 20px rgba(69, 43, 14, 0.22));
}

.shelfBookCover {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  box-shadow: 0 10px 22px rgba(60, 39, 14, 0.16);
  background: #e8dcc8;
}

.shelfBookLabel {
  position: absolute;
  left: 50%;
  bottom: 10px;
  transform: translateX(-50%);
  min-width: 72px;
  padding: 7px 14px;
  border-radius: 999px;
  background: rgba(248, 241, 225, 0.96);
  color: #5d4932;
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 1px;
  box-shadow: 0 6px 14px rgba(86, 58, 23, 0.12);
  white-space: nowrap;
}

.dynastyAxisSection {
  width: min(1280px, calc(100vw - 120px));
  margin-inline: auto;
  padding: 10px 0 0;
}

.dynastyAxisWrap {
  display: flex;
  align-items: stretch;
  justify-content: center;
  gap: clamp(14px, 1.55vw, 26px);
  flex-wrap: nowrap;
  overflow-x: auto;
  padding: 0 clamp(12px, 1vw, 20px);
}

.dynastyAxisItem {
  position: relative;
  flex: 0 0 auto;
  width: clamp(122px, 8vw, 150px);
  height: clamp(420px, 34vw, 560px);
  padding: 0;
  border: 0;
  background: transparent;
  cursor: pointer;
  opacity: 0;
  transform: translateY(24px);
  animation: landingRise 0.72s ease forwards;
  transition: filter .24s ease;
}

.dynastyAxisItem:hover {
  filter: drop-shadow(0 16px 18px rgba(84, 54, 20, .18));
}

.dynastyAxisImg {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: fill;
}

.dynastyAxisText {
  position: absolute;
  top: 44px;
  left: 50%;
  transform: translateX(-50%);
  writing-mode: vertical-rl;
  text-orientation: upright;
  color: #5d4934;
  font-size: clamp(20px, 1.8vw, 30px);
  letter-spacing: 5px;
  font-weight: 500;
}

.palaceThemeSection {
  width: min(1680px, calc(100vw - 72px));
  margin-inline: auto;
  padding: 10px 0 40px;
}

.palaceThemeStage {
  position: relative;
  min-height: clamp(540px, 44vw, 760px);
  border-radius: 16px;
  overflow: hidden;
  background: linear-gradient(180deg, rgba(245, 238, 223, 0.72), rgba(238, 229, 214, 0.72));
  box-shadow: inset 0 0 0 1px rgba(159, 137, 100, 0.10);
}

.palaceThemeStage::before {
  content: "";
  position: absolute;
  inset: 0;
  background:
    radial-gradient(circle at 18% 28%, rgba(255,255,255,0.35), transparent 24%),
    radial-gradient(circle at 77% 30%, rgba(255,255,255,0.26), transparent 24%),
    linear-gradient(180deg, rgba(255,255,255,0.18), rgba(255,255,255,0.04));
  pointer-events: none;
}

.palaceThemeColumns {
  position: absolute;
  inset: 0;
  display: grid;
  grid-template-columns: repeat(8, minmax(0, 1fr));
  z-index: 2;
  padding: 28px clamp(42px, 3vw, 56px) clamp(180px, 13vw, 220px);
}

.palaceThemeItem {
  position: relative;
  border: 0;
  padding: 0;
  background: rgba(232, 223, 206, 0.52);
  cursor: pointer;
  overflow: hidden;
}

.palaceThemeItem:nth-child(odd) {
  background: rgba(246, 240, 226, 0.72);
}

.palaceThemeItem::after {
  content: "";
  position: absolute;
  inset: auto 0 0 0;
  height: 0;
  background: linear-gradient(180deg, rgba(153, 42, 17, 0), rgba(153, 42, 17, 0.16));
  transition: height 0.3s ease;
}

.palaceThemeItem:hover::after {
  height: 100%;
}

.palaceThemeInner {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  gap: 14px;
  padding-top: 28px;
  opacity: 0;
  transform: translateY(40px);
  clip-path: inset(100% 0 0 0);
  animation: palaceFileUp 0.9s cubic-bezier(.22,.61,.36,1) forwards;
  animation-delay: var(--delay, 0s);
}

.palaceThemeIcon {
  width: 26px;
  height: 26px;
  object-fit: contain;
  opacity: 0.88;
}

.palaceThemeText {
  writing-mode: vertical-rl;
  text-orientation: upright;
  color: #564738;
  font-size: clamp(20px, 1.7vw, 32px);
  letter-spacing: 5px;
  line-height: 1.2;
  font-weight: 500;
}

.palaceThemeItem:hover .palaceThemeText {
  color: #7c2816;
}

.palaceThemeRoof {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  width: 100%;
  height: clamp(160px, 14vw, 240px);
  object-fit: fill;
  z-index: 3;
  pointer-events: none;
}

@keyframes landingRise {
  from {
    opacity: 0;
    transform: translateY(24px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes palaceFileUp {
  0% {
    opacity: 0;
    transform: translateY(42px);
    clip-path: inset(100% 0 0 0);
  }
  100% {
    opacity: 1;
    transform: translateY(0);
    clip-path: inset(0 0 0 0);
  }
}

@media (max-width: 1200px) {
  .libraryShelfLanding {
    width: min(100vw - 36px, 1180px);
  }

  .shelfRow {
    padding-left: clamp(44px, 5vw, 80px);
    padding-right: clamp(44px, 5vw, 80px);
  }

  .shelfBookBtn {
    width: clamp(98px, 13vw, 150px);
    height: clamp(168px, 22vw, 248px);
  }

  .dynastyAxisSection,
  .palaceThemeSection {
    width: min(100vw - 36px, 1180px);
  }

  .dynastyAxisItem {
    width: clamp(104px, 10vw, 124px);
    height: clamp(380px, 38vw, 480px);
  }

  .palaceThemeColumns {
    padding-left: 22px;
    padding-right: 22px;
    padding-bottom: 150px;
  }
}

@media (max-width: 760px) {
  .searchSection.shelfSearchSection {
    padding: 18px 14px 6px !important;
  }

  .shelfTitleRow {
    gap: 10px;
    margin-bottom: 18px;
  }

  .shelfMainTitle {
    font-size: 26px;
    letter-spacing: 2px;
  }

  .libraryShelfLanding {
    width: calc(100vw - 20px);
    min-height: auto;
    padding-bottom: 30px;
  }

  .shelfRow {
    height: auto;
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 20px 18px;
    padding: 18px 20px 72px;
    margin-bottom: 24px;
  }

  .shelfBoard {
    height: 54px;
  }

  .shelfBookBtn {
    justify-self: center;
    width: min(38vw, 145px);
    height: min(62vw, 230px);
  }

  .shelfBookLabel {
    font-size: 14px;
    padding: 6px 10px;
  }

  .dynastyAxisSection,
  .palaceThemeSection {
    width: calc(100vw - 20px);
  }

  .dynastyAxisWrap {
    justify-content: flex-start;
    padding: 0 8px 10px;
  }

  .dynastyAxisItem {
    width: 96px;
    height: 360px;
  }

  .dynastyAxisText {
    top: 34px;
    font-size: 22px;
  }

  .palaceThemeStage {
    min-height: 440px;
  }

  .palaceThemeColumns {
    grid-template-columns: repeat(4, minmax(0, 1fr));
    grid-auto-rows: 1fr;
    padding: 16px 8px 132px;
  }

  .palaceThemeText {
    font-size: 20px;
    letter-spacing: 3px;
  }

  .palaceThemeRoof {
    height: 122px;
  }
}
</style>

<style scoped>
/* ===== 最终整合版：书架页不动，只重做朝代页和主题页 ===== */

/* 首页标题：小一点，左右图标接近标题视觉高度 */
.shelfTitleRow {
  gap: 16px !important;
  margin-bottom: 28px !important;
}

.shelfMainTitle {
  font-size: clamp(38px, 3.05vw, 52px) !important;
  line-height: 1.06 !important;
  letter-spacing: 3px !important;
  font-weight: 700 !important;
}

.shelfTitleDecor {
  width: clamp(34px, 2.5vw, 46px) !important;
  height: clamp(34px, 2.5vw, 46px) !important;
  object-fit: contain !important;
  opacity: .98 !important;
}

/* 三个页面之间留适量空隙 */
.libraryShelfLanding.landingBlock {
  margin-bottom: clamp(78px, 8vh, 118px) !important;
}

/* 二、三页标题 */
.subPageTitleRow {
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  gap: 16px !important;
  margin: 34px auto 42px !important;
  user-select: none !important;
}

.subPageTitle {
  margin: 0 !important;
  color: #5a4a39 !important;
  font-size: clamp(36px, 2.8vw, 46px) !important;
  line-height: 1 !important;
  font-weight: 700 !important;
  letter-spacing: 4px !important;
}

.subPageTitleDecor {
  width: clamp(30px, 2.2vw, 40px) !important;
  height: clamp(30px, 2.2vw, 40px) !important;
  object-fit: contain !important;
  opacity: .98 !important;
}

/* ================= 朝代页 ================= */
.dynastyPage {
  width: 100% !important;
  margin: 0 auto clamp(92px, 10vh, 132px) !important;
  padding: 0 !important;
  background: transparent !important;
}

/* 六个数轴按原图排在一块，整体居中 */
.dynastyScrollRow {
  width: fit-content !important;
  max-width: calc(100vw - 120px) !important;
  margin: 0 auto !important;
  display: flex !important;
  align-items: flex-start !important;
  justify-content: center !important;
  gap: 2px !important;
  overflow: visible !important;
  padding: 0 !important;
}

.dynastyScrollItem {
  position: relative !important;
  width: auto !important;
  height: auto !important;
  padding: 0 !important;
  margin: 0 !important;
  border: none !important;
  background: transparent !important;
  cursor: pointer !important;
  overflow: visible !important;
  opacity: 0;
  transform: translateY(12px);
  animation: dynastyScrollIn .45s ease forwards;
  animation-delay: var(--delay, 0s);
}

/* 关键：直接用 img 显示 shuzhou.png，不再当背景，不拉伸、不压缩 */
.dynastyScrollImg {
  display: block !important;
  width: auto !important;
  height: auto !important;
  max-width: none !important;
  max-height: none !important;
  object-fit: initial !important;
}

.dynastyScrollText {
  position: absolute !important;
  left: 50% !important;
  top: 50% !important;
  transform: translate(-50%, -50%) !important;
  writing-mode: vertical-rl !important;
  text-orientation: upright !important;
  color: #5d4d3c !important;
  font-size: 22px !important;
  line-height: 1.15 !important;
  letter-spacing: 2px !important;
  font-weight: 500 !important;
  z-index: 5 !important;
  white-space: nowrap !important;
}

.dynastyScrollItem:hover {
  transform: translateY(-6px) !important;
}

@keyframes dynastyScrollIn {
  from {
    opacity: 0;
    transform: translateY(12px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* ================= 主题天安门页 ================= */
.themePage {
  width: min(1680px, calc(100vw - 40px)) !important;
  margin: 0 auto clamp(92px, 10vh, 132px) !important;
  padding: 0 !important;
  background: transparent !important;
}

.themePalaceBox {
  position: relative !important;
  width: 100% !important;
  height: clamp(660px, 44vw, 760px) !important;
  overflow: hidden !important;
  background: rgba(245, 238, 223, 0.88) !important;
}

.themePalaceColumns {
  position: absolute !important;
  left: 32px !important;
  right: 32px !important;
  top: 0 !important;
  bottom: clamp(150px, 12vw, 190px) !important;
  z-index: 3 !important;
  display: grid !important;
  grid-template-columns: repeat(8, 1fr) !important;
  gap: 0 !important;
}

.themePalaceCol {
  position: relative !important;
  border: none !important;
  background: rgba(220, 210, 192, 0.55) !important;
  padding: 0 !important;
  cursor: pointer !important;
  overflow: hidden !important;
}

.themePalaceCol:nth-child(even) {
  background: rgba(248, 242, 228, 0.78) !important;
}

.themePalaceCol:hover {
  background: rgba(228, 216, 195, 0.72) !important;
}

.themePalaceTextWrap {
  position: absolute !important;
  top: 38px !important;
  left: 50% !important;
  transform: translateX(-50%) !important;
  display: flex !important;
  flex-direction: column !important;
  align-items: center !important;
  gap: 12px !important;
  opacity: 0 !important;
}

.theme-anim-run {
  animation: themeFromTop 0.6s ease forwards !important;
  animation-delay: var(--delay, 0s) !important;
}

@keyframes themeFromTop {
  from {
    opacity: 0;
    transform: translate(-50%, -60px);
  }
  to {
    opacity: 1;
    transform: translate(-50%, 0);
  }
}

/* 强制初始状态为透明 */
.themePalaceTextWrap {
  opacity: 0 !important;
}

.themePalaceIcon {
  width: 16px !important;
  height: 16px !important;
  object-fit: contain !important;
}

.themePalaceText {
  writing-mode: vertical-rl !important;
  text-orientation: upright !important;
  color: #5a4a39 !important;
  font-size: clamp(24px, 1.8vw, 32px) !important;
  line-height: 1.15 !important;
  letter-spacing: 3px !important;
  font-weight: 500 !important;
}

.themeDragon {
  position: absolute !important;
  left: 5% !important;
  right: 5% !important;
  top: 80px !important;
  height: 420px !important;
  z-index: 2 !important;
  pointer-events: none !important;
  opacity: 0.42 !important;
  background-repeat: no-repeat !important;
  background-position: center center !important;
  background-size: contain !important;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1600 760'%3E%3Cg fill='none' stroke='rgba(255,255,255,0.95)' stroke-width='5' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M102 287c96-99 235-129 381-85 58 17 103 17 163-17 73-41 133-80 228-82 154-4 246 103 310 194 61 86 156 132 301 154'/%3E%3Cpath d='M141 351c99-2 173 35 233 98 62 65 121 89 213 73 92-16 149-59 195-123 40-56 75-94 149-126 54-23 124-26 214 7'/%3E%3Cpath d='M339 205c-55-20-87-56-108-104 52 21 96 25 131 4-10 41 0 78 31 111'/%3E%3Cpath d='M1232 186c43-7 83-34 102-77 27 39 57 68 111 84-47 3-84 22-114 52'/%3E%3Cpath d='M740 300c-44 53-56 101-47 165 9 63-20 127-79 187 87-14 152-56 194-135 31-57 58-85 124-123 78-44 123-106 133-186-63 56-124 80-201 74-54-5-92-16-124 18z'/%3E%3C/g%3E%3C/svg%3E") !important;
}

.themeTiananmen {
  position: absolute !important;
  left: 50% !important;
  bottom: 0 !important;
  transform: translateX(-50%) !important;
  width: 100% !important;
  height: auto !important;
  z-index: 4 !important;
  pointer-events: none !important;
}

@keyframes themeTextFloat {
  from {
    opacity: 0;
    transform: translate(-50%, 28px);
    filter: blur(4px);
  }
  to {
    opacity: 1;
    transform: translate(-50%, 0);
    filter: blur(0);
  }
}

@media (max-width: 900px) {
  .dynastyPage {
    overflow-x: auto !important;
    width: calc(100vw - 20px) !important;
  }

  .dynastyScrollRow {
    width: max-content !important;
    max-width: none !important;
    margin: 0 !important;
    padding: 0 10px !important;
  }

  .themePalaceColumns {
    left: 10px !important;
    right: 10px !important;
    grid-template-columns: repeat(4, 1fr) !important;
  }

  .themePalaceBox {
    height: 560px !important;
  }
}
</style>



<style scoped>
/* ===== 最终覆盖：单一滚动 + 数轴加宽挨在一起 ===== */

/* 保持一个滚动容器：轮播和下面内容一起往上走 */
.lib {
  height: 100vh !important;
  overflow: hidden !important;
}

.scrollSections {
  height: 100vh !important;
  overflow-y: auto !important;
  overflow-x: hidden !important;
  scroll-snap-type: none !important;
  scroll-behavior: smooth !important;
}

.screenSection {
  height: auto !important;
  min-height: 0 !important;
  overflow: visible !important;
  scroll-snap-align: none !important;
  scroll-snap-stop: normal !important;
}

.heroScreen {
  height: 100vh !important;
  min-height: 100vh !important;
  overflow: hidden !important;
}

.contentScreen {
  height: auto !important;
  min-height: 0 !important;
  overflow: visible !important;
  padding-bottom: 90px !important;
}

.contentWrapper {
  overflow: visible !important;
}

/* 朝代页标题和区域间距 */
.dynastyPage {
  width: 100% !important;
  margin: 86px auto 120px !important;
  padding: 0 !important;
  overflow: visible !important;
  background: transparent !important;
}

.subPageTitleRow {
  margin: 34px auto 46px !important;
}

/* 数轴：六个挨在一起，整体居中，强制更宽 */
.dynastyScrollRow {
  display: grid !important;
  grid-template-columns: repeat(6, 168px) !important;
  column-gap: 0 !important;
  width: fit-content !important;
  max-width: none !important;
  margin: 0 auto !important;
  padding: 0 !important;
  align-items: start !important;
  justify-content: center !important;
  overflow: visible !important;
  transform: translateX(-260px) !important;
}

.dynastyScrollItem {
  position: relative !important;
  display: block !important;
  width: 700px !important;
  height: 520px !important;
  padding: 0 !important;
  margin: 0 !important;
  border: 0 !important;
  background: transparent !important;
  overflow: visible !important;
  cursor: pointer !important;
  opacity: 1 !important;
  visibility: visible !important;
  transform: none !important;
  animation: none !important;
}

.dynastyScrollImg {
  display: block !important;
  width: 700px !important;
  height: 520px !important;
  max-width: none !important;
  max-height: none !important;
  object-fit: fill !important;
  opacity: 1 !important;
  visibility: visible !important;
}

.dynastyScrollText {
  position: absolute !important;
  left: 50% !important;
  top: 50% !important;
  transform: translate(-50%, -50%) !important;
  writing-mode: vertical-rl !important;
  text-orientation: upright !important;
  color: #5d4d3c !important;
  font-size: 24px !important;
  line-height: 1.12 !important;
  letter-spacing: 2px !important;
  font-weight: 500 !important;
  z-index: 20 !important;
  white-space: nowrap !important;
  opacity: 1 !important;
  visibility: visible !important;
  display: block !important;
}

/* 主题页文字兜底显示 */
.themePalaceTextWrap {
  opacity: 1 !important;
  visibility: visible !important;
  animation: none !important;
  filter: none !important;
  z-index: 50 !important;
}

.themePalaceIcon,
.themePalaceText {
  opacity: 1 !important;
  visibility: visible !important;
  display: block !important;
  z-index: 60 !important;
}

.themeTiananmen {
  z-index: 40 !important;
}

.themeDragon {
  z-index: 5 !important;
}

/* 小屏允许横向滚动，不压扁数轴 */
@media (max-width: 1100px) {
  .dynastyPage {
    width: calc(100vw - 20px) !important;
    overflow-x: auto !important;
  }

  .dynastyScrollRow {
    width: max-content !important;
    margin: 0 !important;
    padding: 0 10px !important;
  }
}
</style>

<style scoped>
/* ===== 最终修正：只改“图片作品展示页”的页面底色，书架/朝代/主题页不受影响 ===== */
.resultsContentScreen {
  background:
    linear-gradient(180deg, rgba(244, 236, 216, 0.98) 0%, rgba(232, 220, 192, 0.98) 100%),
    url("@/assets/library/paper.jpg") !important;
  background-size: cover !important;
  background-position: center top !important;
  background-attachment: fixed !important;
}

.resultsContentScreen .contentWrapper {
  background: transparent !important;
}

/* 作品图片列表区域：把原来发白的地方改成文档同款米黄宣纸色 */
.resultsContentScreen .gridWrap,
.resultsContentScreen .listWrap {
  background:
    linear-gradient(180deg, rgba(244, 236, 216, 0.98) 0%, rgba(232, 220, 192, 0.98) 100%),
    url("@/assets/library/paper.jpg") !important;
  background-size: cover !important;
  background-position: center top !important;
  border-radius: 0 !important;
  box-shadow: none !important;
}

/* 作品页的顶部筛选栏保持同色系，不再下面突然变白 */
.resultsContentScreen .searchSection.resultSearchSection {
  background: rgba(244, 236, 216, 0.98) !important;
  border-bottom: 1px solid rgba(116, 91, 52, 0.10) !important;
  box-shadow: 0 14px 30px rgba(82, 63, 26, 0.06) !important;
}

.resultsContentScreen .gridHead,
.resultsContentScreen .listHead {
  background: transparent !important;
}

/* 避免某些旧样式把作品页区域盖成纯白 */
.resultsContentScreen .empty,
.resultsContentScreen .catPanel,
.resultsContentScreen .authorCard {
  background: rgba(244, 236, 216, 0.74) !important;
}
</style>


<style scoped>
/* ===== 最终覆盖：只把搜索后“图片作品展示页”改成 Recite.vue 同款背景与卡片颜色 ===== */
.resultsContentScreen {
  --recite-paper-bg: #f3efe6;
  --recite-paper-card: #f8f4eb;
  --recite-paper-card-strong: #f4efe4;
  --recite-ink: #2b2823;
  --recite-sub-ink: #6f675d;
  --recite-line: rgba(72, 60, 46, 0.14);
  --recite-line-strong: rgba(72, 60, 46, 0.22);
  --recite-accent: #8a2f2b;
  --recite-gold: #9b7b47;

  background:
    radial-gradient(900px 420px at 20% 12%, rgba(155, 123, 71, 0.06), transparent 65%),
    radial-gradient(800px 380px at 80% 24%, rgba(138, 47, 43, 0.04), transparent 70%),
    radial-gradient(900px 480px at 50% 100%, rgba(120, 105, 90, 0.05), transparent 66%),
    linear-gradient(rgba(248, 244, 235, 0.92), rgba(248, 244, 235, 0.96)),
    url("@/assets/game/bg_page_1.jpg") center center / cover no-repeat !important;
  background-color: var(--recite-paper-bg) !important;
  color: var(--recite-ink) !important;
}

.resultsContentScreen .contentWrapper,
.resultsContentScreen .gridWrap,
.resultsContentScreen .listWrap,
.resultsContentScreen .topicHero,
.resultsContentScreen .gridHead,
.resultsContentScreen .listHead,
.resultsContentScreen .loadMore {
  background: transparent !important;
  box-shadow: none !important;
}

/* 顶部搜索/筛选区改成 Recite 的纸卡色 */
.resultsContentScreen .searchSection.resultSearchSection {
  background: var(--recite-paper-card) !important;
  border: 1px solid var(--recite-line) !important;
  box-shadow: none !important;
  backdrop-filter: none !important;
  -webkit-backdrop-filter: none !important;
}

.resultsContentScreen .searchBoxLight {
  background: rgba(248, 244, 235, 0.9) !important;
  border: 1px solid var(--recite-line) !important;
  box-shadow: none !important;
  color: var(--recite-ink) !important;
}

.resultsContentScreen .searchBoxLight:focus-within {
  background: rgba(255, 252, 246, 0.98) !important;
  border-color: var(--recite-line-strong) !important;
  box-shadow: none !important;
}

.resultsContentScreen .searchBoxLight input,
.resultsContentScreen .searchBoxLight input::placeholder {
  color: var(--recite-sub-ink) !important;
}

/* 顶部按钮改成 Recite 同款纸质按钮 */
.resultsContentScreen .searchSubmitBtnLight,
.resultsContentScreen .resetBtnLight,
.resultsContentScreen .shuffleBtnLight,
.resultsContentScreen .navTabInline,
.resultsContentScreen .shelfBackBtn,
.resultsContentScreen .loadMoreBtn,
.resultsContentScreen .cardGhostBtn {
  background: rgba(248, 244, 235, 0.9) !important;
  border: 1px solid var(--recite-line) !important;
  color: var(--recite-ink) !important;
  box-shadow: none !important;
}

.resultsContentScreen .searchSubmitBtnLight:hover,
.resultsContentScreen .resetBtnLight:hover,
.resultsContentScreen .shuffleBtnLight:hover,
.resultsContentScreen .navTabInline:hover,
.resultsContentScreen .shelfBackBtn:hover,
.resultsContentScreen .loadMoreBtn:hover,
.resultsContentScreen .cardGhostBtn:hover {
  background: rgba(255, 252, 246, 0.98) !important;
  border-color: var(--recite-line-strong) !important;
  transform: translateY(-1px) !important;
}

.resultsContentScreen .navTabInline.active,
.resultsContentScreen .worksBtn.active,
.resultsContentScreen .cardDarkBtn {
  background: rgba(138, 47, 43, 0.08) !important;
  border: 1px solid rgba(138, 47, 43, 0.2) !important;
  color: #6d211d !important;
  box-shadow: none !important;
}

/* 作品图片卡片：换成 Recite 的 paper-card 色，不再用偏黄渐变 */
.resultsContentScreen .card,
.resultsContentScreen .cardElegant,
.resultsContentScreen .authorCard,
.resultsContentScreen .catPanel,
.resultsContentScreen .empty {
  background: var(--recite-paper-card) !important;
  border: 1px solid var(--recite-line) !important;
  box-shadow: none !important;
  color: var(--recite-ink) !important;
}

.resultsContentScreen .card:hover,
.resultsContentScreen .cardElegant:hover,
.resultsContentScreen .authorCard:hover {
  border-color: var(--recite-line-strong) !important;
  box-shadow: none !important;
}

.resultsContentScreen .info,
.resultsContentScreen .infoElegant {
  background: var(--recite-paper-card) !important;
  color: var(--recite-ink) !important;
}

.resultsContentScreen .metaLine,
.resultsContentScreen .meta,
.resultsContentScreen .excerpt,
.resultsContentScreen .muted,
.resultsContentScreen .emptySub {
  color: var(--recite-sub-ink) !important;
}

.resultsContentScreen .title,
.resultsContentScreen .count,
.resultsContentScreen .listTitle,
.resultsContentScreen .emptyTitle {
  color: var(--recite-ink) !important;
}

/* 图片上只保留很轻的纸感遮罩，接近 Recite 的 cover 效果 */
.resultsContentScreen .posterMask,
.resultsContentScreen .posterMask.strong {
  background:
    linear-gradient(180deg, rgba(40, 30, 20, 0.02), rgba(40, 30, 20, 0) 48%),
    linear-gradient(0deg, rgba(40, 30, 20, 0.26), rgba(40, 30, 20, 0) 58%) !important;
}

.resultsContentScreen .badge {
  background: rgba(26, 22, 18, 0.52) !important;
  color: #fff !important;
  border: 1px solid rgba(248, 244, 235, 0.16) !important;
}

.resultsContentScreen .badge.soft {
  background: rgba(248, 244, 235, 0.22) !important;
  color: #fff !important;
}

/* 分类下拉也统一成 Recite 的纸卡色 */
.resultsContentScreen .categoryDropdown,
.resultsContentScreen .categoryItem,
.resultsContentScreen .catItem,
.resultsContentScreen .pillLite,
.resultsContentScreen .tag,
.resultsContentScreen .chip {
  background: var(--recite-paper-card) !important;
  border: 1px solid var(--recite-line) !important;
  color: var(--recite-ink) !important;
  box-shadow: none !important;
}

.resultsContentScreen .categoryItem.active,
.resultsContentScreen .catItem:hover,
.resultsContentScreen .categoryItem:hover {
  background: rgba(138, 47, 43, 0.08) !important;
  border-color: rgba(138, 47, 43, 0.2) !important;
  color: #6d211d !important;
}
</style>


<style scoped>
/* ===== 修正：进入作品结果页时不显示顶部轮播，页面直接从搜索栏开始 ===== */
.resultsContentScreen {
  min-height: 100vh !important;
  padding-top: 0 !important;
}

.resultsContentScreen .contentWrapper {
  padding-top: 0 !important;
}

.resultsContentScreen .searchSection.resultSearchSection {
  position: sticky !important;
  top: 0 !important;
  z-index: 80 !important;
  margin-top: 0 !important;
}
</style>


<style scoped>
/* ===== 在线阅读区：左侧数轴 + 右侧检索，按参考图比例排好 ===== */


/* 左侧 11 根数轴：从左侧开始，一根挨一根 */





/* 右侧在线阅读搜索 */









@keyframes onlineAxisRise {
  from {
    opacity: 0;
    transform: translateY(26px);
    filter: blur(3px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
    filter: blur(0);
  }
}

/* ===== 恢复天安门主题页，防止被在线阅读区覆盖 ===== */
.themePage {
  display: block !important;
  width: min(1680px, calc(100vw - 40px)) !important;
  margin: 0 auto clamp(92px, 10vh, 132px) !important;
  padding: 0 !important;
  background: transparent !important;
  overflow: visible !important;
}

.themePalaceBox {
  position: relative !important;
  width: 100% !important;
  height: clamp(660px, 44vw, 760px) !important;
  overflow: hidden !important;
  background: transparent !important;
}

.themePalaceColumns {
  position: absolute !important;
  left: 32px !important;
  right: 32px !important;
  top: 0 !important;
  bottom: clamp(155px, 12vw, 195px) !important;
  z-index: 3 !important;
  display: grid !important;
  grid-template-columns: repeat(8, 1fr) !important;
  gap: 0 !important;
  pointer-events: auto !important;
}

.themePalaceCol {
  position: relative !important;
  border: none !important;
  background: rgba(220, 210, 192, 0.46) !important;
  padding: 0 !important;
  cursor: pointer !important;
  overflow: hidden !important;
}

.themePalaceCol:nth-child(even) {
  background: rgba(248, 242, 228, 0.66) !important;
}

.themePalaceTextWrap {
  position: absolute !important;
  top: 38px !important;
  left: 50% !important;
  transform: translateX(-50%) !important;
  display: flex !important;
  flex-direction: column !important;
  align-items: center !important;
  gap: 12px !important;
  opacity: 0 !important;
  visibility: visible !important;
  animation: themeTextFloat 0.85s ease forwards !important;
  animation-delay: var(--delay, 0s) !important;
  z-index: 50 !important;
}

.themePalaceIcon {
  width: 16px !important;
  height: 16px !important;
  object-fit: contain !important;
}

.themePalaceText {
  writing-mode: vertical-rl !important;
  text-orientation: upright !important;
  color: #5a4a39 !important;
  font-size: clamp(24px, 1.8vw, 32px) !important;
  line-height: 1.15 !important;
  letter-spacing: 3px !important;
  font-weight: 500 !important;
}

.themeDragon {
  position: absolute !important;
  left: 5% !important;
  right: 5% !important;
  top: 80px !important;
  height: 420px !important;
  z-index: 2 !important;
  pointer-events: none !important;
  opacity: 0.42 !important;
}

.themeTiananmen {
  display: block !important;
  position: absolute !important;
  left: 50% !important;
  bottom: 0 !important;
  transform: translateX(-50%) !important;
  width: 100% !important;
  height: auto !important;
  z-index: 6 !important;
  opacity: 1 !important;
  visibility: visible !important;
  pointer-events: none !important;
}

@keyframes themeTextFloat {
  from {
    opacity: 0;
    transform: translate(-50%, 28px);
    filter: blur(4px);
  }
  to {
    opacity: 1;
    transform: translate(-50%, 0);
    filter: blur(0);
  }
}

@media (max-width: 1500px) {
}

@media (max-width: 1180px) {
}
</style>

<style scoped>
/* ===== 最终修正：把“数轴页”改成参考图布局，左侧数轴 + 右侧搜索在同一屏；不影响后面的天安门主题页 ===== */

/* 入口内容自然向下滚动，不再出现数轴和搜索框分成两页 */
.contentScreen,
.contentWrapper {
  overflow: visible !important;
}

/* 在线阅读整块：占一屏左右，和参考图一样左右排布 */


/* 左边 11 根数轴：从左开始，一根挨一根，不居中分散 */




/* 右侧搜索框：和数轴同一行，不再掉到下一页 */








@keyframes onlineAxisRiseFixed {
  from {
    opacity: 0;
    transform: translateY(28px);
    filter: blur(3px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
    filter: blur(0);
  }
}

/* 天安门主题页恢复：它在在线阅读区下面，独立展示，不被透明框压住 */
.themePage {
  display: block !important;
  width: min(1680px, calc(100vw - 40px)) !important;
  margin: 0 auto clamp(92px, 10vh, 132px) !important;
  padding: 0 !important;
  background: transparent !important;
  overflow: visible !important;
}

.themePalaceBox {
  position: relative !important;
  width: 100% !important;
  height: clamp(660px, 44vw, 760px) !important;
  overflow: hidden !important;
  background: transparent !important;
}

.themePalaceColumns {
  position: absolute !important;
  left: 32px !important;
  right: 32px !important;
  top: 0 !important;
  bottom: clamp(155px, 12vw, 195px) !important;
  z-index: 3 !important;
  display: grid !important;
  grid-template-columns: repeat(8, 1fr) !important;
  gap: 0 !important;
}

.themePalaceCol {
  position: relative !important;
  border: 0 !important;
  background: rgba(220, 210, 192, 0.30) !important;
  padding: 0 !important;
  cursor: pointer !important;
  overflow: hidden !important;
}

.themePalaceCol:nth-child(even) {
  background: rgba(248, 242, 228, 0.46) !important;
}

.themeTiananmen {
  position: absolute !important;
  left: 50% !important;
  bottom: 0 !important;
  transform: translateX(-50%) !important;
  width: 100% !important;
  height: auto !important;
  z-index: 40 !important;
  pointer-events: none !important;
  opacity: 1 !important;
  visibility: visible !important;
}

.themePalaceTextWrap,
.themePalaceIcon,
.themePalaceText {
  opacity: 1 !important;
  visibility: visible !important;
}

/* 窄屏时改成可横向滚，不把数轴压瘦 */
@media (max-width: 1500px) {


}
</style>

<style scoped>
/* ===== 最终强制覆盖：修复在线阅读区数轴消失、搜索框溢出、背景不统一 ===== */
:global(html),
:global(body),
:global(#app) {
  background: #f3ecd9 !important;
}

.lib,
.contentScreen,
.contentWrapper,
.searchSection.shelfSearchSection,

.lib::before,
.lib::after {
  background: transparent !important;
}















/* 天安门页不能被透明框压住 */
.themePalaceBox {
  background: transparent !important;
  overflow: hidden !important;
}
.themePalaceCol {
  background: rgba(220, 210, 192, 0.24) !important;
}
.themePalaceCol:nth-child(even) {
  background: rgba(248, 242, 228, 0.38) !important;
}
.themeTiananmen {
  display: block !important;
  opacity: 1 !important;
  visibility: visible !important;
  z-index: 50 !important;
}

@media (max-width: 1600px) {
}

@media (max-width: 1280px) {
}
</style>


<style scoped>
/* ===== 最终修正版：恢复六个朝代 + 背景彻底统一 + 左轴右搜同屏 ===== */
:global(html),
:global(body),
:global(#app) {
  background: #f4ecd8 !important;
}

.lib,
.scrollSections,
.screenSection,
.contentScreen,
.contentWrapper,
.shelfContentScreen,
.searchSection.shelfSearchSection,
.libraryShelfLanding,
.landingBlock,

.lib::before,
.lib::after {
  background: transparent !important;
  background-image: none !important;
}

/* 只保留一个统一底色，不再出现白色分段 */
.contentScreen {
  min-height: auto !important;
  padding-bottom: 90px !important;
}

.contentWrapper {
  width: 100% !important;
  max-width: none !important;
  margin: 0 !important;
  padding: 0 !important;
}

.searchSection.shelfSearchSection {
  border: 0 !important;
  margin: 0 !important;
  padding: 34px 40px 28px !important;
}

.libraryShelfLanding {
  width: min(1580px, calc(100vw - 92px)) !important;
  margin: 0 auto 96px !important;
}

/* 在线阅读/数轴区：左边 6 个朝代数轴，右边搜索框，同一屏显示 */














/* 主题页：只保留淡淡柱子，不要一整块透明框盖住天安门 */
.themePage {
  width: min(1680px, calc(100vw - 40px)) !important;
  margin: 0 auto 120px !important;
}

.themePalaceBox {
  background: transparent !important;
}

.themePalaceCol {
  background: rgba(220, 210, 192, 0.18) !important;
}

.themePalaceCol:nth-child(even) {
  background: rgba(248, 242, 228, 0.28) !important;
}

.themeTiananmen {
  display: block !important;
  opacity: 1 !important;
  visibility: visible !important;
  z-index: 50 !important;
}

@media (max-width: 1500px) {


}

@media (max-width: 1180px) {


}
</style>


<style scoped>
/* ===== 终极覆盖：补回朝代标题 + 标题图标同尺寸 + 数轴加宽 ===== */
:global(html),
:global(body),
:global(#app) {
  background: #f4ecd8 !important;
}

.lib,
.scrollSections,
.screenSection,
.contentScreen,
.contentWrapper,
.searchSection.shelfSearchSection,
.libraryShelfLanding,

.lib::before,
.lib::after {
  background: transparent !important;
  background-image: none !important;
}

/* 三个大标题：字稍小，左右图标放大到和文字视觉大小一致 */
.shelfTitleRow,
.subPageTitleRow {
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  gap: 20px !important;
  user-select: none !important;
}

.shelfMainTitle,
.subPageTitle {
  margin: 0 !important;
  color: #5a4a39 !important;
  font-size: 42px !important;
  line-height: 1 !important;
  font-weight: 800 !important;
  letter-spacing: 4px !important;
  text-shadow: none !important;
}

.shelfTitleDecor,
.subPageTitleDecor {
  width: 42px !important;
  height: 42px !important;
  flex: 0 0 42px !important;
  object-fit: contain !important;
  opacity: 1 !important;
}

.searchSection.shelfSearchSection {
  padding-top: 36px !important;
  padding-bottom: 28px !important;
  margin: 0 !important;
  border: 0 !important;
  box-shadow: none !important;
}

.shelfTitleRow {
  margin: 0 auto 26px !important;
}

.libraryShelfLanding {
  margin-bottom: 92px !important;
}

/* 朝代标题补回并固定在数轴区上方 */


/* 数轴区：六个朝代更宽，左侧一排；右侧搜索框不掉到下一页 */










/* 主题页标题同步 */
.themePage .subPageTitleRow {
  margin: 0 auto 44px !important;
}

.themePage {
  margin-top: 0 !important;
}

/* 天安门页不要被背景框盖住 */
.themePalaceBox {
  background: transparent !important;
}

.themePalaceCol {
  background: rgba(220, 210, 192, 0.18) !important;
}

.themePalaceCol:nth-child(even) {
  background: rgba(248, 242, 228, 0.28) !important;
}

.themeTiananmen {
  display: block !important;
  opacity: 1 !important;
  visibility: visible !important;
  z-index: 50 !important;
}

@media (max-width: 1500px) {
  .shelfMainTitle,
  .subPageTitle {
    font-size: 38px !important;
  }

  .shelfTitleDecor,
  .subPageTitleDecor {
    width: 38px !important;
    height: 38px !important;
    flex-basis: 38px !important;
  }


}

@media (max-width: 1180px) {


}
</style>


<style scoped>
/* ===== 本轮终改：标题装饰放大 + 主题页改成“古籍阅览”样式 ===== */
.shelfMainTitle,
.subPageTitle,
.ancientBrowseTitle {
  font-size: 34px !important;
  line-height: 1 !important;
  letter-spacing: 2px !important;
  font-weight: 700 !important;
  color: #5a4a39 !important;
}

.shelfTitleDecor,
.subPageTitleDecor,

.shelfTitleRow,
.subPageTitleRow,
.ancientBrowseTitleRow {
  gap: 12px !important;
}






.themePage {
  width: min(1720px, calc(100vw - 56px)) !important;
  margin: 0 auto 110px !important;
  background: #f4ecd8 !important;
}

.ancientBrowseShell {
  position: relative !important;
  width: 100% !important;
  margin: 0 auto !important;
  padding: 22px 24px 0 !important;
  box-sizing: border-box !important;
  background: #f4ecd8 !important;
}

.ancientBrowseHead {
  position: relative !important;
  display: flex !important;
  flex-direction: column !important;
  align-items: center !important;
  justify-content: center !important;
  padding-top: 4px !important;
}

.ancientBrowseTitleRow {
  margin: 0 auto 18px !important;
}

.ancientMoreBtn {
  position: relative !important;
  border: 0 !important;
  background: transparent !important;
  padding: 0 !important;
  cursor: pointer !important;
  margin: 0 auto 34px !important;
}

.ancientMoreBtnImg {
  display: block !important;
  width: 180px !important;
  height: auto !important;
}

.ancientCrane {
  position: absolute !important;
  right: 24px !important;
  top: 10px !important;
  width: 320px !important;
  height: auto !important;
  opacity: 0 !important;
  pointer-events: none !important;
  z-index: 4 !important;
  animation: craneSlideIn 1.15s ease-out .15s forwards !important;
}

@keyframes craneSlideIn {
  from { opacity: 0; transform: translateX(90px); }
  to { opacity: 0.78; transform: translateX(0); }
}

.ancientSearchRow {
  position: relative !important;
  z-index: 5 !important;
  display: grid !important;
  grid-template-columns: 1.15fr 1.15fr 1.15fr 138px !important;
  gap: 24px !important;
  align-items: center !important;
  width: calc(100% - 72px) !important;
  margin: 0 auto 34px !important;
  padding-right: 160px !important;
  box-sizing: border-box !important;
}

.ancientSearchField {
  height: 56px !important;
  display: flex !important;
  align-items: center !important;
  gap: 10px !important;
  padding: 0 20px !important;
  background: rgba(255,255,255,0.9) !important;
  border: 1px solid rgba(206, 190, 160, 0.8) !important;
  box-shadow: 8px 8px 0 rgba(141, 118, 79, 0.08) !important;
  box-sizing: border-box !important;
}

.ancientSearchField span {
  flex: 0 0 auto !important;
  color: #7a6751 !important;
  font-size: 16px !important;
}

.ancientSearchField input {
  flex: 1 !important;
  min-width: 0 !important;
  border: 0 !important;
  background: transparent !important;
  outline: none !important;
  color: #5a4a39 !important;
  font-size: 17px !important;
}

.ancientSearchBtn {
  height: 56px !important;
  border: 1px solid rgba(206, 190, 160, 0.85) !important;
  background: rgba(255,255,255,0.95) !important;
  color: #6d5a43 !important;
  font-size: 18px !important;
  font-weight: 700 !important;
  letter-spacing: 4px !important;
  cursor: pointer !important;
}

.ancientPalaceBox {
  width: 100% !important;
  height: 560px !important;
  overflow: hidden !important;
  background: transparent !important;
}

.ancientPalaceBox .themePalaceColumns {
  left: 72px !important;
  right: 72px !important;
  top: 0 !important;
  bottom: 128px !important;
  grid-template-columns: repeat(8, minmax(0, 1fr)) !important;
}

.ancientPalaceBox .themePalaceCol {
  background: rgba(222, 211, 192, 0.62) !important;
}

.ancientPalaceBox .themePalaceCol:nth-child(even) {
  background: rgba(247, 240, 224, 0.82) !important;
}

.themePalaceTextWrap {
  top: 86px !important;
  gap: 12px !important;
  opacity: 1 !important;
}

.themePalaceIcon {
  width: 34px !important;
  height: 34px !important;
  object-fit: contain !important;
}

.themePalaceText {
  font-size: 21px !important;
  line-height: 1.1 !important;
  letter-spacing: 2px !important;
}

.themeDragon {
  left: 8% !important;
  right: 8% !important;
  top: 22px !important;
  height: 440px !important;
  opacity: .34 !important;
  z-index: 2 !important;
}

.themeTiananmen {
  width: 100% !important;
  bottom: -2px !important;
  z-index: 4 !important;
}

@media (max-width: 1500px) {

  .ancientCrane {
    width: 270px !important;
  }

  .ancientSearchRow {
    padding-right: 120px !important;
  }
}

@media (max-width: 1280px) {
  .ancientSearchRow {
    grid-template-columns: 1fr !important;
    width: min(720px, calc(100% - 40px)) !important;
    padding-right: 0 !important;
  }

  .ancientCrane {
    display: none !important;
  }

  .ancientPalaceBox .themePalaceColumns {
    left: 28px !important;
    right: 28px !important;
  }
}
</style>


<style scoped>
/* ===== 严格修正版：数轴宽度二倍、六个紧贴、主题页去掉古籍阅览、天安门对齐、飞鹤显示 ===== */

/* 统一页面底色，避免分段 */
.lib,
.scrollSections,
.contentScreen,
.contentWrapper,
.searchSection,
.landingBlock,

/* 标题：字小一点，左右装饰比字更大 */
.shelfMainTitle,
.subPageTitle {
  font-size: 30px !important;
  line-height: 1 !important;
  letter-spacing: 2px !important;
  font-weight: 700 !important;
  color: #5a4a39 !important;
}

.shelfTitleDecor,
.subPageTitleDecor,

.subPageTitleRow,
.shelfTitleRow {
  gap: 12px !important;
}

/* ================= 朝代数轴区域 ================= */





/* 关键：不再依赖原图自身宽度，直接把图片横向拉宽二倍多 */


/* 右侧搜索框往左收，不跑出页面 */





/* ================= 主题 / 天安门区域 ================= */
.themePage {
  position: relative !important;
  width: min(1720px, calc(100vw - 48px)) !important;
  margin: 0 auto 90px !important;
  padding: 0 !important;
  overflow: visible !important;
  background: #f4ecd8 !important;
}

.themePage > .subPageTitleRow {
  margin: 0 auto 34px !important;
}

/* 模板已经删掉古籍阅览；这里再兜底隐藏，保证不出现 */
.ancientBrowseHead,
.ancientBrowseTitleRow,
.ancientBrowseTitle,
.ancientMoreBtn,
.ancientMoreBtnImg {
  display: none !important;
  width: 0 !important;
  height: 0 !important;
  opacity: 0 !important;
  pointer-events: none !important;
}

.ancientBrowseShell {
  position: relative !important;
  width: 100% !important;
  margin: 0 auto !important;
  padding: 6px 0 0 !important;
  background: #f4ecd8 !important;
  overflow: visible !important;
}

/* 飞鹤：直接放在主题页右上角，高层级显示，从右侧浮现 */
.themeCraneFloat,
.ancientCrane {
  display: block !important;
  position: absolute !important;
  right: 42px !important;
  top: 8px !important;
  width: 310px !important;
  height: auto !important;
  opacity: 0 !important;
  z-index: 30 !important;
  pointer-events: none !important;
  filter: contrast(1.15) drop-shadow(0 8px 12px rgba(90, 74, 57, .12)) !important;
  animation: craneShowFromRightStrict 1.15s ease-out .1s forwards !important;
}

.ancientCrane {
  right: 46px !important;
  top: 58px !important;
  width: 250px !important;
  z-index: 29 !important;
}

@keyframes craneShowFromRightStrict {
  0% { opacity: 0; transform: translateX(130px); }
  100% { opacity: .9; transform: translateX(0); }
}

.ancientSearchRow {
  position: relative !important;
  z-index: 8 !important;
  display: grid !important;
  grid-template-columns: 1.1fr 1.1fr 1.1fr 130px !important;
  gap: 22px !important;
  align-items: center !important;
  width: min(1500px, calc(100% - 150px)) !important;
  margin: 0 auto 28px !important;
  padding: 0 !important;
  box-sizing: border-box !important;
}

.ancientSearchField {
  height: 54px !important;
  background: rgba(255,255,255,.92) !important;
  border: 1px solid rgba(206, 190, 160, .75) !important;
  box-shadow: 8px 8px 0 rgba(141, 118, 79, .08) !important;
}

.ancientSearchBtn {
  height: 54px !important;
  background: rgba(255,255,255,.95) !important;
  color: #6d5a43 !important;
  border: 1px solid rgba(206, 190, 160, .85) !important;
  font-size: 18px !important;
  font-weight: 700 !important;
}

/* 天安门框：文字轴区域和天安门同一个左右边界，像参考图一样对齐 */
.ancientPalaceBox {
  position: relative !important;
  width: min(1640px, calc(100% - 90px)) !important;
  height: 635px !important;
  margin: 0 auto !important;
  overflow: hidden !important;
  background: transparent !important;
}

.ancientPalaceBox .themePalaceColumns {
  position: absolute !important;
  left: 0 !important;
  right: 0 !important;
  top: 0 !important;
  bottom: 138px !important;
  display: grid !important;
  grid-template-columns: repeat(8, minmax(0, 1fr)) !important;
  gap: 0 !important;
  z-index: 3 !important;
}

.ancientPalaceBox .themePalaceCol {
  position: relative !important;
  background: rgba(219, 208, 189, .62) !important;
}

.ancientPalaceBox .themePalaceCol:nth-child(even) {
  background: rgba(248, 241, 225, .84) !important;
}

.themeDragon {
  position: absolute !important;
  left: 0 !important;
  right: 0 !important;
  top: 18px !important;
  height: 430px !important;
  opacity: .30 !important;
  z-index: 2 !important;
}

.themePalaceTextWrap {
  top: 70px !important;
  gap: 8px !important;
  opacity: 1 !important;
  z-index: 5 !important;
}

/* 天安门宽度 = 文字轴区域宽度 */
.themeTiananmen {
  position: absolute !important;
  left: 0 !important;
  right: 0 !important;
  bottom: 0 !important;
  width: 100% !important;
  height: auto !important;
  display: block !important;
  opacity: 1 !important;
  visibility: visible !important;
  z-index: 4 !important;
}

.themePalaceIcon {
  width: 36px !important;
  height: 36px !important;
}

.themePalaceText {
  font-size: 19px !important;
  line-height: 1.08 !important;
  letter-spacing: 1px !important;
  color: #514333 !important;
}

@media (max-width: 1550px) {
  .themeCraneFloat {
    width: 250px !important;
    right: 20px !important;
  }
}

@media (max-width: 1280px) {
  .themeCraneFloat,
  .ancientCrane {
    display: none !important;
  }
  .ancientSearchRow {
    grid-template-columns: 1fr !important;
    width: calc(100% - 40px) !important;
  }
  .ancientPalaceBox {
    width: calc(100% - 36px) !important;
    height: 560px !important;
  }
}
</style>

<style scoped>
/* ===== 最终强制覆盖：修复天安门只剩一半、飞鹤不显示、数轴不贴合 ===== */

/* 统一底色，不再一段一段断开 */
.lib,
.scrollSections,
.contentScreen,
.contentWrapper,
.searchSection,
.landingBlock,

/* ================= 朝代页：六个数轴横向加宽并紧贴 ================= */







/* ================= 主题页：只保留主题 + 天安门 + 飞鹤 ================= */
.themePage {
  position: relative !important;
  width: min(1760px, calc(100vw - 44px)) !important;
  margin: 0 auto 90px !important;
  padding: 0 !important;
  overflow: visible !important;
}

.themePage > .subPageTitleRow {
  display: flex !important;
  margin: 0 auto 34px !important;
  visibility: visible !important;
  opacity: 1 !important;
}

/* 不要古籍阅览和它下面的搜索框 */
.ancientBrowseHead,
.ancientBrowseTitleRow,
.ancientBrowseTitle,
.ancientMoreBtn,
.ancientMoreBtnImg,
.ancientSearchRow {
  display: none !important;
  width: 0 !important;
  height: 0 !important;
  opacity: 0 !important;
  visibility: hidden !important;
  pointer-events: none !important;
  overflow: hidden !important;
  margin: 0 !important;
  padding: 0 !important;
}

.ancientBrowseShell {
  position: relative !important;
  width: 100% !important;
  margin: 0 auto !important;
  padding: 0 !important;
  overflow: visible !important;
}

/* 飞鹤强制显示，位置在主题页右上角，从右侧浮现 */
.themeCraneFloat,
.ancientCrane {
  display: block !important;
  position: absolute !important;
  right: 32px !important;
  top: 20px !important;
  width: 360px !important;
  height: auto !important;
  max-width: 22vw !important;
  opacity: 0 !important;
  visibility: visible !important;
  pointer-events: none !important;
  z-index: 100 !important;
  filter: contrast(1.35) brightness(.92) drop-shadow(0 10px 16px rgba(80, 65, 42, .18)) !important;
  animation: craneSlideInReally 1.15s ease-out .15s forwards !important;
}

.ancientCrane {
  top: 70px !important;
  right: 44px !important;
  width: 300px !important;
  max-width: 19vw !important;
  z-index: 99 !important;
}

@keyframes craneSlideInReally {
  from {
    opacity: 0;
    transform: translateX(130px);
  }
  to {
    opacity: .82;
    transform: translateX(0);
  }
}

/* 天安门整体容器：文字轴和天安门同宽同边界 */
.ancientPalaceBox {
  position: relative !important;
  width: min(1680px, calc(100% - 28px)) !important;
  height: 620px !important;
  margin: 0 auto !important;
  padding: 0 !important;
  overflow: hidden !important;
  box-sizing: border-box !important;
}

.ancientPalaceBox .themePalaceColumns,
.themePalaceColumns {
  position: absolute !important;
  left: 0 !important;
  right: 0 !important;
  top: 0 !important;
  bottom: 176px !important;
  width: 100% !important;
  display: grid !important;
  grid-template-columns: repeat(8, minmax(0, 1fr)) !important;
  gap: 0 !important;
  z-index: 6 !important;
  padding: 0 !important;
  margin: 0 !important;
  box-sizing: border-box !important;
}

.ancientPalaceBox .themePalaceCol,
.themePalaceCol {
  position: relative !important;
  height: 100% !important;
  border: 0 !important;
  margin: 0 !important;
  padding: 0 !important;
  background: rgba(222, 211, 192, .62) !important;
  overflow: hidden !important;
}

.ancientPalaceBox .themePalaceCol:nth-child(even),
.themePalaceCol:nth-child(even) {
  background: rgba(248, 241, 225, .86) !important;
}

.themePalaceTextWrap {
  position: absolute !important;
  top: 70px !important;
  left: 50% !important;
  transform: translateX(-50%) !important;
  display: flex !important;
  flex-direction: column !important;
  align-items: center !important;
  gap: 8px !important;
  opacity: 1 !important;
  visibility: visible !important;
  z-index: 9 !important;
  animation: none !important;
  filter: none !important;
}

.themePalaceIcon {
  width: 36px !important;
  height: 36px !important;
  min-width: 36px !important;
  min-height: 36px !important;
  object-fit: contain !important;
  opacity: 1 !important;
  visibility: visible !important;
}

.themePalaceText {
  writing-mode: vertical-rl !important;
  text-orientation: upright !important;
  font-size: 20px !important;
  line-height: 1.08 !important;
  letter-spacing: 1px !important;
  color: #514333 !important;
  font-weight: 500 !important;
  opacity: 1 !important;
  visibility: visible !important;
}

.themeDragon {
  position: absolute !important;
  left: 0 !important;
  right: 0 !important;
  top: 22px !important;
  width: 100% !important;
  height: 420px !important;
  opacity: .30 !important;
  z-index: 4 !important;
  pointer-events: none !important;
}

/* 重点修复：之前天安门只剩一半，是旧 transform: translateX(-50%) 没覆盖掉 */
.themeTiananmen {
  position: absolute !important;
  left: 0 !important;
  right: 0 !important;
  bottom: 0 !important;
  width: 100% !important;
  height: 225px !important;
  max-width: none !important;
  object-fit: fill !important;
  object-position: center bottom !important;
  display: block !important;
  transform: none !important;
  opacity: 1 !important;
  visibility: visible !important;
  z-index: 8 !important;
  pointer-events: none !important;
}

@media (max-width: 1550px) {
  .themeCraneFloat {
    width: 300px !important;
  }
}

@media (max-width: 1280px) {
  .themeCraneFloat,
  .ancientCrane {
    display: none !important;
  }
  .ancientPalaceBox {
    width: calc(100% - 24px) !important;
    height: 540px !important;
  }
  .themeTiananmen {
    height: 190px !important;
  }
  .ancientPalaceBox .themePalaceColumns,
  .themePalaceColumns {
    bottom: 148px !important;
  }
}
</style>

<style scoped>
/* =====================================================================
   最终强制修正版 v2：
   1）朝代数轴横向加宽，六个紧贴，不改文字内容；
   2）右侧“更多在线阅读”不跑出页面；
   3）主题页只保留“主题 + 天安门”，不显示“古籍阅览”；
   4）天安门使用原图比例，禁止被压扁；
   5）文字轴与天安门左右边界完全对齐；
   6）he.png 飞鹤强制显示，并从右侧浮现。
   ===================================================================== */

/* 全页面统一底色，避免上下分块断层 */
.lib,
.scrollSections,
.screenSection,
.contentScreen,
.contentWrapper,
.searchSection,
.searchSection.shelfSearchSection,
.libraryShelfLanding,

/* ===================== 朝代 / 更多在线阅读页 ===================== */


/* 标题左右图标放大，字略小 */
.shelfTitleDecor,
.subPageTitleDecor,

.shelfMainTitle,
.subPageTitle,

/* 核心：左侧六个朝代数轴 + 右侧搜索框，整体在一屏内 */












/* ===================== 主题 / 天安门页 ===================== */
.themePage {
  position: relative !important;
  width: min(1800px, calc(100vw - 28px)) !important;
  margin: 0 auto 90px !important;
  padding: 0 !important;
  overflow: visible !important;
}

.themePage > .subPageTitleRow {
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  gap: 14px !important;
  margin: 0 auto 44px !important;
  opacity: 1 !important;
  visibility: visible !important;
}

/* 不要古籍阅览标题、更多古籍按钮、古籍搜索框 */
.ancientBrowseHead,
.ancientBrowseTitleRow,
.ancientBrowseTitle,
.ancientMoreBtn,
.ancientMoreBtnImg,
.ancientSearchRow {
  display: none !important;
  visibility: hidden !important;
  opacity: 0 !important;
  width: 0 !important;
  height: 0 !important;
  margin: 0 !important;
  padding: 0 !important;
  overflow: hidden !important;
  pointer-events: none !important;
}

.ancientBrowseShell {
  position: relative !important;
  width: 100% !important;
  margin: 0 auto !important;
  padding: 0 !important;
  overflow: visible !important;
  box-sizing: border-box !important;
}

/* 飞鹤：两个 img 都强制显示，避免被旧 media query 隐藏 */
.themeCraneFloat,
.ancientCrane {
  display: block !important;
  position: absolute !important;
  right: 72px !important;
  top: 18px !important;
  width: 360px !important;
  max-width: 26vw !important;
  height: auto !important;
  opacity: 0 !important;
  visibility: visible !important;
  pointer-events: none !important;
  z-index: 999 !important;
  filter: brightness(.72) contrast(1.35) sepia(.18) drop-shadow(0 14px 18px rgba(80,65,42,.22)) !important;
  animation: libraryCraneFloatIn 1.15s ease-out .12s forwards !important;
}

.ancientCrane {
  top: 84px !important;
  right: 88px !important;
}

@keyframes libraryCraneFloatIn {
  from {
    opacity: 0;
    transform: translateX(140px) translateY(-8px);
  }
  to {
    opacity: .78;
    transform: translateX(0) translateY(0);
  }
}

/* 天安门容器：文字轴区域和图片同宽，不再错位 */
.ancientPalaceBox {
  --roof-space: clamp(260px, 16vw, 340px);
  position: relative !important;
  width: 100% !important;
  height: clamp(650px, 43vw, 760px) !important;
  margin: 0 auto !important;
  padding: 0 !important;
  overflow: hidden !important;
  background: transparent !important;
  box-sizing: border-box !important;
}

.ancientPalaceBox .themePalaceColumns,
.themePalaceColumns {
  position: absolute !important;
  left: 0 !important;
  right: 0 !important;
  top: 0 !important;
  bottom: var(--roof-space) !important;
  width: 100% !important;
  height: auto !important;
  display: grid !important;
  grid-template-columns: repeat(8, minmax(0, 1fr)) !important;
  gap: 0 !important;
  padding: 0 !important;
  margin: 0 !important;
  z-index: 6 !important;
  box-sizing: border-box !important;
}

.ancientPalaceBox .themePalaceCol,
.themePalaceCol {
  position: relative !important;
  height: 100% !important;
  margin: 0 !important;
  padding: 0 !important;
  border: 0 !important;
  background: rgba(222, 211, 192, .62) !important;
  overflow: hidden !important;
}

.ancientPalaceBox .themePalaceCol:nth-child(even),
.themePalaceCol:nth-child(even) {
  background: rgba(248, 241, 225, .86) !important;
}

.themePalaceTextWrap {
  position: absolute !important;
  top: 70px !important;
  left: 50% !important;
  transform: translateX(-50%) !important;
  display: flex !important;
  flex-direction: column !important;
  align-items: center !important;
  gap: 8px !important;
  opacity: 1 !important;
  visibility: visible !important;
  z-index: 9 !important;
  animation: none !important;
  filter: none !important;
}

.themePalaceIcon {
  display: block !important;
  width: 42px !important;
  height: 42px !important;
  min-width: 42px !important;
  min-height: 42px !important;
  object-fit: contain !important;
  opacity: .96 !important;
  visibility: visible !important;
}

.themePalaceText {
  display: block !important;
  writing-mode: vertical-rl !important;
  text-orientation: upright !important;
  color: #514333 !important;
  font-size: 21px !important;
  line-height: 1.08 !important;
  letter-spacing: 1px !important;
  font-weight: 500 !important;
  opacity: 1 !important;
  visibility: visible !important;
}

.themeDragon {
  position: absolute !important;
  left: 0 !important;
  right: 0 !important;
  top: 18px !important;
  width: 100% !important;
  height: calc(100% - var(--roof-space) + 60px) !important;
  opacity: .30 !important;
  z-index: 4 !important;
  pointer-events: none !important;
}

/* 关键修复：天安门保持原图比例，不设置固定 height，不 object-fit:fill，所以不会变扁 */
.themeTiananmen {
  position: absolute !important;
  left: 0 !important;
  right: 0 !important;
  bottom: 0 !important;
  width: 100% !important;
  min-width: 100% !important;
  max-width: 100% !important;
  height: auto !important;
  min-height: 0 !important;
  max-height: none !important;
  object-fit: contain !important;
  object-position: center bottom !important;
  transform: none !important;
  display: block !important;
  opacity: 1 !important;
  visibility: visible !important;
  z-index: 10 !important;
  pointer-events: none !important;
}

/* 窗口较窄时只允许整体缩一点，不隐藏鹤、不压扁天安门 */
@media (max-width: 1500px) {


  .themeCraneFloat,
  .ancientCrane {
    display: block !important;
    width: 280px !important;
    right: 44px !important;
  }

  .ancientPalaceBox {
    --roof-space: 250px;
    height: 640px !important;
  }
}

@media (max-width: 900px) {

  .themeCraneFloat,
  .ancientCrane {
    width: 210px !important;
    right: 18px !important;
    top: 22px !important;
  }

  .ancientPalaceBox {
    --roof-space: 190px;
    height: 530px !important;
  }
}
</style>

<style scoped>
/* =========================================================
   最终强覆盖：修正朝代数轴、右侧搜索、主题天安门、飞鹤显示
   放在文件最底部，专门压住前面所有重复样式
   ========================================================= */

/* 页面统一底色，避免一段一段颜色断开 */
.lib,
.scrollSections,
.contentScreen,
.contentWrapper,

/* 标题左右装饰：图标比文字更明显 */
.subPageTitleRow,

.subPageTitle {
  font-size: 38px !important;
  line-height: 1 !important;
  color: #5a4a39 !important;
  font-weight: 800 !important;
  letter-spacing: 4px !important;
}

.subPageTitleDecor {
  width: 58px !important;
  height: 58px !important;
  min-width: 58px !important;
  min-height: 58px !important;
  object-fit: contain !important;
  opacity: 1 !important;
  visibility: visible !important;
}

/* ======================= 朝代页：左侧六个数轴 + 右侧搜索 ======================= */















/* ======================= 主题页：只保留主题 + 天安门，不要古籍阅览 ======================= */
.themePage {
  position: relative !important;
  width: min(1760px, calc(100vw - 64px)) !important;
  margin: 0 auto 100px !important;
  padding: 0 !important;
  overflow: visible !important;
  box-sizing: border-box !important;
}

.themePage > .subPageTitleRow {
  margin: 0 auto 42px !important;
}

.ancientBrowseHead,
.ancientBrowseTitleRow,
.ancientBrowseTitle,
.ancientMoreBtn,
.ancientMoreBtnImg,
.ancientSearchRow {
  display: none !important;
  visibility: hidden !important;
  opacity: 0 !important;
  width: 0 !important;
  height: 0 !important;
  margin: 0 !important;
  padding: 0 !important;
  overflow: hidden !important;
  pointer-events: none !important;
}

.ancientBrowseShell {
  position: relative !important;
  width: 100% !important;
  margin: 0 auto !important;
  padding: 0 !important;
  overflow: visible !important;
  box-sizing: border-box !important;
}

/* 鹤只显示一只，直接用 he.png，从右侧浮现 */
.ancientCrane {
  display: none !important;
}

.themeCraneFloat {
  display: block !important;
  position: absolute !important;
  right: 42px !important;
  top: 8px !important;
  width: 310px !important;
  max-width: 22vw !important;
  height: auto !important;
  opacity: 0 !important;
  visibility: visible !important;
  pointer-events: none !important;
  z-index: 80 !important;
  filter: brightness(.72) contrast(1.28) sepia(.16) drop-shadow(0 16px 18px rgba(80,65,42,.18)) !important;
  animation: craneEnterFinal 1.05s ease-out .18s forwards !important;
}

@keyframes craneEnterFinal {
  from {
    opacity: 0;
    transform: translateX(120px) translateY(-10px);
  }
  to {
    opacity: .68;
    transform: translateX(0) translateY(0);
  }
}

/* 天安门整体框：文字轴和图片同一个宽度边界，图片不拉伸、不压扁 */
.ancientPalaceBox {
  --roof-h: 255px;
  position: relative !important;
  width: 100% !important;
  height: 660px !important;
  margin: 0 auto !important;
  padding: 0 !important;
  overflow: hidden !important;
  background: transparent !important;
  box-sizing: border-box !important;
}

.ancientPalaceBox .themePalaceColumns,
.themePalaceColumns {
  position: absolute !important;
  left: 0 !important;
  right: 0 !important;
  top: 0 !important;
  bottom: var(--roof-h) !important;
  width: 100% !important;
  height: auto !important;
  display: grid !important;
  grid-template-columns: repeat(8, minmax(0, 1fr)) !important;
  gap: 0 !important;
  padding: 0 !important;
  margin: 0 !important;
  z-index: 8 !important;
  box-sizing: border-box !important;
}

.ancientPalaceBox .themePalaceCol,
.themePalaceCol {
  position: relative !important;
  height: 100% !important;
  min-height: 0 !important;
  margin: 0 !important;
  padding: 0 !important;
  border: 0 !important;
  background: rgba(222, 211, 192, .64) !important;
  overflow: hidden !important;
  box-sizing: border-box !important;
}

.ancientPalaceBox .themePalaceCol:nth-child(even),
.themePalaceCol:nth-child(even) {
  background: rgba(248, 241, 225, .88) !important;
}

.themePalaceTextWrap {
  position: absolute !important;
  top: 72px !important;
  left: 50% !important;
  transform: translateX(-50%) !important;
  display: flex !important;
  flex-direction: column !important;
  align-items: center !important;
  gap: 10px !important;
  opacity: 1 !important;
  visibility: visible !important;
  z-index: 12 !important;
  animation: none !important;
  filter: none !important;
}

.themePalaceIcon {
  display: block !important;
  width: 44px !important;
  height: 44px !important;
  min-width: 44px !important;
  min-height: 44px !important;
  object-fit: contain !important;
  opacity: .95 !important;
  visibility: visible !important;
}

.themePalaceText {
  display: block !important;
  writing-mode: vertical-rl !important;
  text-orientation: upright !important;
  color: #514333 !important;
  font-size: 22px !important;
  line-height: 1.08 !important;
  letter-spacing: 1px !important;
  font-weight: 500 !important;
  opacity: 1 !important;
  visibility: visible !important;
}

.themeDragon {
  position: absolute !important;
  left: 0 !important;
  right: 0 !important;
  top: 16px !important;
  width: 100% !important;
  height: calc(100% - var(--roof-h) + 70px) !important;
  opacity: .30 !important;
  z-index: 6 !important;
  pointer-events: none !important;
  background-position: center center !important;
  background-size: 98% auto !important;
}

/* 关键：不再设置固定高度，不再 object-fit: fill，避免天安门被拉长/压扁 */
.themeTiananmen {
  position: absolute !important;
  left: 0 !important;
  right: 0 !important;
  bottom: 0 !important;
  width: 100% !important;
  height: auto !important;
  min-height: 0 !important;
  max-height: none !important;
  object-fit: contain !important;
  object-position: center bottom !important;
  transform: none !important;
  display: block !important;
  opacity: 1 !important;
  visibility: visible !important;
  z-index: 14 !important;
  pointer-events: none !important;
}

/* 防止小屏挤出去：宽度不够时整体缩小一点，但不变形 */
@media (max-width: 1500px) {




  .ancientPalaceBox {
    --roof-h: 230px;
    height: 610px !important;
  }

  .themeCraneFloat {
    width: 240px !important;
    right: 22px !important;
  }
}

@media (max-width: 1100px) {


  .themePage {
    overflow-x: auto !important;
  }

  .ancientPalaceBox {
    width: 1080px !important;
    max-width: none !important;
    --roof-h: 200px;
    height: 540px !important;
  }

  .themeCraneFloat {
    width: 200px !important;
  }
}
</style>

<style scoped>
/* ===== 最终修正：主题页文字轴和天安门之间不留空隙 ===== */
.themePage {
  background: transparent !important;
}

.ancientPalaceBox {
  position: relative !important;
  width: 100% !important;
  height: 660px !important;
  margin: 0 auto !important;
  padding: 0 !important;
  overflow: hidden !important;
  background: transparent !important;
  box-sizing: border-box !important;
}

/* 关键改动：bottom 改成 0，让文字轴一直铺到底部；天安门盖在上面，就不会出现中间空白 */
.ancientPalaceBox .themePalaceColumns,
.themePalaceColumns {
  position: absolute !important;
  left: 0 !important;
  right: 0 !important;
  top: 0 !important;
  bottom: 0 !important;
  width: 100% !important;
  height: 100% !important;
  display: grid !important;
  grid-template-columns: repeat(8, minmax(0, 1fr)) !important;
  gap: 0 !important;
  column-gap: 0 !important;
  row-gap: 0 !important;
  padding: 0 !important;
  margin: 0 !important;
  z-index: 8 !important;
  box-sizing: border-box !important;
}

.ancientPalaceBox .themePalaceCol,
.themePalaceCol {
  height: 100% !important;
  margin: 0 !important;
  padding: 0 !important;
  border: 0 !important;
  box-sizing: border-box !important;
  background: rgba(222, 211, 192, .64) !important;
}

.ancientPalaceBox .themePalaceCol:nth-child(even),
.themePalaceCol:nth-child(even) {
  background: rgba(248, 241, 225, .88) !important;
}

/* 天安门保持原比例，压在文字轴上方，不拉伸 */
.themeTiananmen {
  position: absolute !important;
  left: 0 !important;
  right: 0 !important;
  bottom: 0 !important;
  width: 100% !important;
  height: auto !important;
  object-fit: contain !important;
  object-position: center bottom !important;
  transform: none !important;
  z-index: 30 !important;
  display: block !important;
  opacity: 1 !important;
  visibility: visible !important;
}

.themeDragon {
  z-index: 12 !important;
  pointer-events: none !important;
}

.themePalaceTextWrap {
  z-index: 20 !important;
}

@media (max-width: 1100px) {
  .ancientPalaceBox {
    width: 1080px !important;
    max-width: none !important;
    height: 560px !important;
  }
}
</style>


<style scoped>
/* =========================================================
   朝代数轴统一样式：只保留这一套为准
   以后要调数轴，只改下面三个变量：--axis-w / --axis-h / --online-w
   ========================================================= */

.onlineReadingPage {
  --axis-w: clamp(148px, 9.2vw, 210px);
  --axis-h: clamp(520px, 32vw, 610px);
  --online-w: clamp(380px, 25vw, 500px);
  --axis-gap: clamp(28px, 3vw, 60px);

  width: 100% !important;
  margin: 76px auto 120px !important;
  padding: 0 !important;
  background: transparent !important;
  overflow: visible !important;
  box-sizing: border-box !important;
}

.onlineReadingPage .dynastyTitleRow {
  margin: 0 auto 42px !important;
}

/* 左边六个数轴 + 右边搜索框 */
.onlineReadingStage {
  width: min(
    calc(var(--axis-w) * 6 + var(--online-w) + var(--axis-gap)),
    calc(100vw - 72px)
  ) !important;
  margin: 0 auto !important;
  display: grid !important;
  grid-template-columns: calc(var(--axis-w) * 6) var(--online-w) !important;
  gap: var(--axis-gap) !important;
  align-items: center !important;
  justify-content: center !important;
  box-sizing: border-box !important;
  overflow: visible !important;
}

/* 六个数轴紧挨在一起，中间不留空隙 */
.onlineAxisArea {
  width: calc(var(--axis-w) * 6) !important;
  display: grid !important;
  grid-template-columns: repeat(6, var(--axis-w)) !important;
  gap: 20px !important;
  margin: 0 !important;
  padding: 0 !important;
  align-items: center !important;
  justify-items: center !important;
  overflow: visible !important;
}

.onlineAxisItem {
  position: relative !important;
  width: var(--axis-w) !important;
  height: var(--axis-h) !important;
  padding: 0 !important;
  margin: 0 !important;
  border: 0 !important;
  background: transparent !important;
  cursor: pointer !important;
  overflow: visible !important;
  opacity: 0;
}

.onlineAxisItem.axis-animated {
  animation-duration: 0.75s;
  animation-fill-mode: forwards;
  animation-timing-function: ease;
  animation-delay: var(--delay, 0s);
}

.onlineAxisItem.axis-animated:nth-child(odd) {
  animation-name: axisFromBottom;
}

.onlineAxisItem.axis-animated:nth-child(even) {
  animation-name: axisFromTop;
}

.onlineAxisImg {
  display: block !important;
  width: var(--axis-w) !important;
  height: var(--axis-h) !important;
  max-width: none !important;
  max-height: none !important;
  object-fit: fill !important;
  opacity: 1 !important;
  visibility: visible !important;
  transform: translateX(-65px) !important;
}

.onlineAxisText {
  position: absolute !important;
  left: 10% !important;
  top: 50% !important;
  transform: translate(-50%, -50%) !important;
  writing-mode: vertical-rl !important;
  text-orientation: upright !important;
  color: #5d4d3c !important;
  font-size: clamp(26px, 1.65vw, 34px) !important;
  line-height: 1.12 !important;
  letter-spacing: 2px !important;
  font-weight: 500 !important;
  white-space: nowrap !important;
  z-index: 5 !important;
}

@keyframes axisFromTop {
  from {
    opacity: 0;
    transform: translateY(-56px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes axisFromBottom {
  from {
    opacity: 0;
    transform: translateY(56px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 右侧“更多在线阅读” */
.onlineSearchPanel {
  width: var(--online-w) !important;
  max-width: var(--online-w) !important;
  margin: 0 !important;
  padding: 0 !important;
  box-sizing: border-box !important;
}

.onlinePanelTitle {
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  gap: 18px !important;
  margin: 0 0 34px !important;
  color: #5a4a39 !important;
  font-size: clamp(28px, 2vw, 40px) !important;
  font-weight: 700 !important;
  letter-spacing: 2px !important;
  white-space: nowrap !important;
}

.onlinePanelDecor {
  width: 56px !important;
  height: 56px !important;
  object-fit: contain !important;
}

.onlineSearchForm {
  display: flex !important;
  flex-direction: column !important;
  gap: 24px !important;
}

.onlineInputLine {
  width: 100% !important;
  height: 64px !important;
  display: flex !important;
  align-items: center !important;
  gap: 10px !important;
  padding: 0 28px !important;
  background: #fff !important;
  box-shadow: 10px 10px 0 rgba(92, 70, 36, 0.12) !important;
  box-sizing: border-box !important;
}

.onlineInputLine span {
  flex: 0 0 auto !important;
  color: #8b7a68 !important;
  font-size: 22px !important;
}

.onlineInputLine input {
  flex: 1 !important;
  min-width: 0 !important;
  height: 100% !important;
  border: 0 !important;
  outline: none !important;
  background: transparent !important;
  color: #5a4a39 !important;
  font-size: 22px !important;
}

.onlineSearchBtn {
  width: 100% !important;
  height: 74px !important;
  border: 0 !important;
  background: #ad7b3a !important;
  color: #fff !important;
  font-size: 30px !important;
  font-weight: 700 !important;
  letter-spacing: 16px !important;
  cursor: pointer !important;
  box-shadow: 10px 10px 0 rgba(92, 70, 36, 0.12) !important;
}

/* 小屏：不压扁数轴，改成横向滚动 */
@media (max-width: 1200px) {
  .onlineReadingPage {
    overflow-x: auto !important;
    padding-bottom: 18px !important;
  }

  .onlineReadingStage {
    width: max-content !important;
    grid-template-columns: calc(var(--axis-w) * 6) min(420px, 88vw) !important;
    padding: 0 32px !important;
    justify-content: start !important;
  }

  .onlineSearchPanel {
    width: min(420px, 88vw) !important;
    max-width: min(420px, 88vw) !important;
  }
}
</style>

<style scoped>
/* =========================================================
   标题位置修正版：只修标题，不动你原来的功能、数轴、天安门逻辑
   目的：
   1. “古诗词景物分类”放在搜索框下面、书架上面，并居中
   2. “朝代”“主题”标题居中，左右装饰图标不再跑到页面两边
   ========================================================= */

/* 第一屏书架入口：搜索框在上，标题在搜索框下面 */
.searchSection.shelfSearchSection {
  display: flex !important;
  flex-direction: column !important;
  align-items: stretch !important;
  justify-content: flex-start !important;
  background: transparent !important;
  box-shadow: none !important;
  border: 0 !important;
}

.searchSection.shelfSearchSection .searchCenter {
  order: 1 !important;
  width: 100% !important;
  margin: 0 auto 34px !important;
  display: flex !important;
  justify-content: center !important;
}

.searchSection.shelfSearchSection .shelfTitleRow {
  order: 2 !important;
  width: fit-content !important;
  max-width: 100% !important;
  margin: 0 auto 46px !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  gap: 18px !important;
  text-align: center !important;
}

.searchSection.shelfSearchSection .shelfMainTitle {
  margin: 0 !important;
  color: #5a4a39 !important;
  font-size: clamp(34px, 2.5vw, 46px) !important;
  line-height: 1 !important;
  font-weight: 700 !important;
  letter-spacing: 4px !important;
  white-space: nowrap !important;
  text-align: center !important;
}

.searchSection.shelfSearchSection .shelfTitleDecor {
  flex: 0 0 auto !important;
  width: clamp(44px, 3vw, 58px) !important;
  height: clamp(44px, 3vw, 58px) !important;
  object-fit: contain !important;
  display: block !important;
  opacity: 1 !important;
}

/* 第二屏朝代标题、第三屏主题标题：统一居中 */
.subPageTitleRow,
.onlineReadingPage .dynastyTitleRow,
.themePage > .subPageTitleRow {
  width: fit-content !important;
  max-width: 100% !important;
  margin-left: auto !important;
  margin-right: auto !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  gap: 18px !important;
  text-align: center !important;
}

.onlineReadingPage .dynastyTitleRow {
  margin-top: 0 !important;
  margin-bottom: 42px !important;
}

.themePage > .subPageTitleRow {
  margin-top: 34px !important;
  margin-bottom: 42px !important;
}

.subPageTitle {
  margin: 0 !important;
  color: #5a4a39 !important;
  font-size: clamp(34px, 2.45vw, 44px) !important;
  line-height: 1 !important;
  font-weight: 700 !important;
  letter-spacing: 4px !important;
  white-space: nowrap !important;
  text-align: center !important;
}

.subPageTitleDecor {
  flex: 0 0 auto !important;
  width: clamp(44px, 3vw, 58px) !important;
  height: clamp(44px, 3vw, 58px) !important;
  object-fit: contain !important;
  display: block !important;
  opacity: 1 !important;
}
</style>

<style scoped>
/* =========================================================
   最底部强制修正：标题左右图标贴近文字，做成“图标 标题 图标”的形式
   只改标题行，不改数轴、天安门、功能逻辑
   ========================================================= */
.searchSection.shelfSearchSection .shelfTitleRow,
.subPageTitleRow,
.onlineReadingPage .dynastyTitleRow,
.themePage > .subPageTitleRow {
  display: inline-flex !important;
  width: auto !important;
  max-width: none !important;
  min-width: 0 !important;
  margin-left: auto !important;
  margin-right: auto !important;
  align-items: center !important;
  justify-content: center !important;
  gap: 12px !important;
  text-align: center !important;
  position: relative !important;
}

.searchSection.shelfSearchSection .shelfMainTitle,
.subPageTitle {
  margin: 0 !important;
  padding: 0 !important;
  flex: 0 0 auto !important;
  white-space: nowrap !important;
  text-align: center !important;
  color: #5a4a39 !important;
  font-size: 38px !important;
  line-height: 1 !important;
  font-weight: 800 !important;
  letter-spacing: 3px !important;
}

.searchSection.shelfSearchSection .shelfTitleDecor,
.subPageTitleDecor,
.shelfTitleDecorLeft,
.shelfTitleDecorRight {
  position: static !important;
  left: auto !important;
  right: auto !important;
  top: auto !important;
  bottom: auto !important;
  transform: none !important;
  margin: 0 !important;
  padding: 0 !important;
  display: block !important;
  flex: 0 0 52px !important;
  width: 52px !important;
  height: 52px !important;
  min-width: 52px !important;
  min-height: 52px !important;
  max-width: 52px !important;
  max-height: 52px !important;
  object-fit: contain !important;
  opacity: 1 !important;
  visibility: visible !important;
}

.searchSection.shelfSearchSection {
  align-items: center !important;
}
</style>


<style scoped>
/* =========================================================
   【最终强制覆盖】标题统一修正
   效果：图标紧贴文字左右，整行水平居中；不会跑到页面两边。
   只作用于这三个标题：古诗词景物分类 / 朝代 / 主题。
   ========================================================= */

/* 书架首页：搜索框在上，标题在搜索框下方，整体居中 */
.searchSection.shelfSearchSection {
  display: flex !important;
  flex-direction: column !important;
  align-items: center !important;
  justify-content: flex-start !important;
}

.searchSection.shelfSearchSection .searchCenter {
  order: 1 !important;
  width: 100% !important;
}

/* 这行就是标题本体：不要再被撑满整屏 */
.searchSection.shelfSearchSection .titleCenterLineMain {
  order: 2 !important;
}

.titleCenterLine,
.searchSection.shelfSearchSection .titleCenterLine,
.onlineReadingPage > .titleCenterLine,
.themePage > .titleCenterLine {
  width: max-content !important;
  min-width: 0 !important;
  max-width: max-content !important;
  margin-left: auto !important;
  margin-right: auto !important;
  padding: 0 !important;
  display: flex !important;
  flex-direction: row !important;
  align-items: center !important;
  justify-content: center !important;
  gap: 14px !important;
  position: relative !important;
  left: auto !important;
  right: auto !important;
  top: auto !important;
  bottom: auto !important;
  transform: none !important;
  text-align: center !important;
}

/* 具体间距：书架标题在搜索框下面，朝代/主题标题各自居中 */
.searchSection.shelfSearchSection .titleCenterLineMain {
  margin-top: 28px !important;
  margin-bottom: 46px !important;
}

.onlineReadingPage > .titleCenterLineSub {
  margin-top: 0 !important;
  margin-bottom: 42px !important;
}

.themePage > .titleCenterLineSub {
  margin-top: 34px !important;
  margin-bottom: 42px !important;
}

/* 标题文字：固定不拉伸，不换行 */
.titleCenterLine > .shelfMainTitle,
.titleCenterLine > .subPageTitle {
  display: block !important;
  flex: 0 0 auto !important;
  width: auto !important;
  min-width: 0 !important;
  max-width: none !important;
  margin: 0 !important;
  padding: 0 !important;
  white-space: nowrap !important;
  text-align: center !important;
  color: #5a4a39 !important;
  font-size: 40px !important;
  line-height: 1 !important;
  font-weight: 800 !important;
  letter-spacing: 3px !important;
}

/* 左右图标：取消所有 absolute / 两侧定位，强制贴在文字左右 */
.titleCenterLine > .shelfTitleDecor,
.titleCenterLine > .subPageTitleDecor,
.titleCenterLine > img {
  position:· static !important;
  left: auto !important;
  right: auto !important;
  top: auto !important;
  bottom: auto !important;
  transform: none !important;
  display: block !important;
  flex: 0 0 54px !important;
  width: 54px !important;
  height: 54px !important;
  min-width: 54px !important;
  min-height: 54px !important;
  max-width: 54px !important;
  max-height: 54px !important;
  margin: 0 !important;
  padding: 0 !important;
  object-fit: contain !important;
  object-position: center !important;
  opacity: 1 !important;
  visibility: visible !important;
  clip-path: none !important;
}

/* 防止旧样式把左右两个图标推到页面两边 */
.titleCenterLine > .shelfTitleDecorLeft,
.titleCenterLine > .shelfTitleDecorRight {
  margin: 0 !important;
  float: none !important;
}

@media (max-width: 760px) {
  .titleCenterLine > .shelfMainTitle,
  .titleCenterLine > .subPageTitle {
    font-size: 30px !important;
    letter-spacing: 2px !important;
  }
  .titleCenterLine > .shelfTitleDecor,
  .titleCenterLine > .subPageTitleDecor,
  .titleCenterLine > img {
    flex-basis: 42px !important;
    width: 42px !important;
    height: 42px !important;
    min-width: 42px !important;
    min-height: 42px !important;
    max-width: 42px !important;
    max-height: 42px !important;
  }
}


/* ===== 天安门主题文字：滚到该区域时自动浮现 ===== */
.themePage .themePalaceTextWrap.theme-animated {
  opacity: 0 !important;
  transform: translate(-50%, 42px) !important;
  filter: blur(6px) !important;
  transition:
    opacity 0.85s ease,
    transform 0.85s cubic-bezier(.22,.61,.36,1),
    filter 0.85s ease !important;
  transition-delay: var(--delay, 0s) !important;
  will-change: opacity, transform, filter !important;
}

.themePage.themeInView .themePalaceTextWrap.theme-animated.theme-anim-run {
  opacity: 1 !important;
  transform: translate(-50%, 0) !important;
  filter: blur(0) !important;
}

.themePage .themePalaceIcon,
.themePage .themePalaceText {
  opacity: 1 !important;
  visibility: visible !important;
}

@media (prefers-reduced-motion: reduce) {
  .themePage .themePalaceTextWrap.theme-animated {
    opacity: 1 !important;
    transform: translate(-50%, 0) !important;
    filter: none !important;
    transition: none !important;
  }
}

</style>

<style scoped>
/* ===== 结果页专题大图最终修正：贴紧上方按钮、尺寸放大、直角边缘 ===== */
.resultsContentScreen .searchSection.resultSearchSection {
  margin: 0 !important;
  padding-bottom: 0 !important;
}

.resultsContentScreen .topicHero {
  width: 100% !important;
  max-width: none !important;
  margin: 0 !important;
  padding: 0 !important;
}

.resultsContentScreen .topicHeroCard {
  width: 100% !important;
  height: clamp(460px, 54vh, 620px) !important;
  margin: 0 !important;
  border-radius: 0 !important;
  border-left: 0 !important;
  border-right: 0 !important;
  overflow: hidden !important;
  box-shadow: none !important;
}

.resultsContentScreen .topicBg {
  inset: 0 !important;
  background-size: cover !important;
  background-position: center center !important;
}

.resultsContentScreen .topicMask {
  inset: 0 !important;
  border-radius: 0 !important;
}

.resultsContentScreen .topicContent {
  left: 48px !important;
  bottom: 34px !important;
}

.resultsContentScreen .topicRelatedIntro {
  position: absolute !important;
  right: 42px !important;
  bottom: 34px !important;
  z-index: 4 !important;
  width: min(430px, 34vw) !important;
  padding: 18px 22px !important;
  color: #fff !important;
  background: rgba(35, 30, 24, 0.36) !important;
  border: 1px solid rgba(255, 255, 255, 0.32) !important;
  backdrop-filter: blur(8px) !important;
  -webkit-backdrop-filter: blur(8px) !important;
  box-shadow: 0 10px 28px rgba(0, 0, 0, 0.16) !important;
}

.resultsContentScreen .topicRelatedIntroTitle {
  margin-bottom: 8px !important;
  font-size: 20px !important;
  font-weight: 900 !important;
  letter-spacing: 0.08em !important;
}

.resultsContentScreen .topicRelatedIntro p {
  margin: 0 !important;
  font-size: 14px !important;
  line-height: 1.75 !important;
  font-weight: 600 !important;
  text-align: justify !important;
}

@media (max-width: 900px) {
  .resultsContentScreen .topicRelatedIntro {
    right: 20px !important;
    bottom: 22px !important;
    width: min(360px, 46vw) !important;
    padding: 14px 16px !important;
  }
}

.resultsContentScreen .topicCorner {
  display: none !important;
}
</style>
