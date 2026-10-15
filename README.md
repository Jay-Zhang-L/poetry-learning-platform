<div align="center">

# 诗韵华章

### 基于数字人文的诗词研习平台

在阅读中理解诗词，在交互中走近诗意。

**Vue 3 · Spring Boot 3 · MyBatis · MySQL · Three.js · AI**

[功能介绍](#功能介绍) · [界面展示](docs/screenshots.md) · [本地运行](docs/getting-started.md) · [数据库导入](database/README.md) · [技术架构](docs/architecture.md)

</div>

![诗词交互展厅](docs/images/poetry-gallery.png)

## 项目介绍

**诗韵华章**是面向古诗词学习与文化体验的 Web 平台，将诗词检索、典故释义、AI 辅助学习、朗诵练习、三维诗境和创作交流整合在同一网站中。用户既可以查阅一首诗的内容与背景，也可以与 AI 虚拟诗人对话、参与飞花令，或发布自己的作品。

项目采用前后端分离架构，以中国传统书画、古籍和园林意象组织界面，探索数字技术在诗词学习中的应用。

**作者：[Jay-Zhang-L](https://github.com/Jay-Zhang-L)。项目由作者独立开发，曾在竞赛中获奖。**

> 当前公开内容包括 Web 前端、Java 后端及作者导出的 MySQL 数据库快照（81 张表的结构与现有演示数据）。数据库可按[导入说明](database/README.md)初始化，AI、OCR、语音及部分媒体资源仍需另行配置。详见[运行指南](docs/getting-started.md)与[公开范围说明](docs/project-status.md)。

## 项目亮点

- **诗词与场景结合**：通过 Three.js 交互展厅、Gaussian Splatting 场景查看器、诗窗和诗人足迹地图，提供多种观察诗词意境的方式。
- **AI 辅助阅读与创作**：接入 DeepSeek、智谱 AI，支持诗词问答、虚拟诗人对话、创作润色与韵脚检查。
- **图片进入学习流程**：对接 PaddleOCR 识别图片中的文字，通过通义千问视觉服务分析画面，辅助识诗与配诗。
- **朗诵与互动练习**：提供音频播放、录音上传，以及飞花令、诗词接龙、韵脚迷阵等游戏。
- **学习延伸到创作交流**：整合作品发布、评论、点赞收藏、关注、论坛和个人数据看板。

## 功能介绍

| 模块 | 主要功能 | 页面入口示例 |
| --- | --- | --- |
| 首页与诗词展厅 | 诗词文化介绍、朝代专题、诗词螺旋交互展示 | `/home` |
| 藏书阁 | 诗词浏览、搜索筛选、详情阅读、收藏、古籍翻页 | `/library` |
| 词典与典故 | 字词查询、典故浏览与检索、典故推荐 | `/dictionary`、`/story` |
| AI 学诗 | AI 助手、虚拟诗人对话、AI 教师、语音交互 | `/ai`、`/ai-teacher` |
| 诗境可视化 | 诗窗、三维场景浏览、诗人足迹地图 | `/shichuang`、`/splat`、`/poetry-map` |
| 朗诵练习 | 朗诵资源、录音、练习记录与评价流程 | `/recite`、`/recite/recording` |
| 互动游戏 | 飞花令、诗词接龙、诗词趣消消、韵脚迷阵、一诗定魂、诗人朋友圈 | `/game` |
| 创作与社区 | 作品发布、AI 润色、评论互动、排行榜、论坛 | `/chuangzuo`、`/forum` |
| 个人诗阁 | 个人资料、收藏、浏览记录、关注关系、创作统计 | `/center` |

功能入口依据当前路由与业务代码整理，具体效果取决于数据库、媒体文件和外部服务的配置。

## 界面预览

以下图片来自项目答辩材料中的实际界面截图，展示答辩版本的设计与功能。

### 藏书阁与诗词阅读

![藏书阁诗词列表](docs/images/library.png)

### AI 虚拟诗人对话

![与 AI 虚拟诗人对话](docs/images/ai-poet.jpg)

### 创作与交流

![作品创作社区](docs/images/community.png)

[查看互动游戏、朗诵练习及个人看板等更多界面 →](docs/screenshots.md)

## 技术栈

版本信息来自当前 `package.json` 与 `pom.xml`，前端依赖声明使用 `^` 版本范围。

| 层次 | 技术 |
| --- | --- |
| 前端框架 | Vue 3.5、Vite 6、Vue Router 4.5、Pinia 2.2 |
| UI 与请求 | Element Plus 2.13、Fetch / Axios |
| 可视化与动效 | Three.js 0.183、ECharts 6、GSAP 3.14、Lottie Web、Matter.js |
| 三维场景 | `@mkkellogg/gaussian-splats-3d`、HTML 场景查看器 |
| 后端 | Java 17、Spring Boot 3.3.2、MyBatis Spring Boot Starter 3.0.3 |
| 数据存储 | MySQL，项目使用 MySQL 8 环境 |
| 接口文档 | Springdoc OpenAPI 2.6.0 |
| AI 与语音 | DeepSeek、智谱 AI、通义千问视觉、百度语音 |
| OCR | Java 侧对接独立 PaddleOCR HTTP 服务 |

当前身份认证使用 **Bearer Token 与服务端 Token 查询**。技术实现与答辩材料的对应关系见[公开范围说明](docs/project-status.md)。

## 仓库结构

```text
poetry-learning-platform/
├── README.md
├── .gitignore
├── .gitattributes
├── database/
│   ├── README.md                 # 数据库快照与导入步骤
│   └── shici-full.sql            # 81 张表的结构与现有演示数据
├── docs/
│   ├── getting-started.md       # 环境、配置、启动与常见问题
│   ├── architecture.md          # 分层结构与核心流程
│   ├── screenshots.md           # 答辩版本界面展示
│   ├── project-status.md        # 公开范围、依赖与后续整理
│   └── images/                  # 从答辩材料提取的展示图片
├── frontend/
│   └── shici-app-starter -完整版本-5.21/
│       ├── package.json
│       ├── vite.config.js
│       ├── public/
│       └── src/
└── backend/
    └── shici-app-5.1/
        └── shici-app-server/
            ├── pom.xml
            ├── application-local.example.yml
            └── src/main/
                ├── java/com/shici/
                └── resources/
```

## 本地运行

准备 Node.js 22 LTS、JDK 17、Maven 3.9 和 MySQL 8。先按[数据库说明](database/README.md)导入 `database/shici-full.sql`，再按[完整运行指南](docs/getting-started.md)配置服务与资源。

```bash
git clone https://github.com/Jay-Zhang-L/poetry-learning-platform.git
cd poetry-learning-platform
```

前端：

```bash
cd "frontend/shici-app-starter -完整版本-5.21"
npm install
npm run dev
```

后端需先按指南准备本地配置和数据库，再在另一个终端执行：

```bash
cd backend/shici-app-5.1/shici-app-server
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

前端默认地址为 `http://localhost:5173`，后端默认端口为 `8080`。启动前端开发服务器只代表页面服务可用，业务数据与 AI 能力仍需要后端及相应依赖。

## 作者与项目工作

作者独立完成项目开发，工作覆盖前端页面与交互、Java 后端接口、数据接入、AI 服务集成以及项目功能联调。

欢迎通过 [Issues](https://github.com/Jay-Zhang-L/poetry-learning-platform/issues) 反馈问题。描述问题时请附上页面入口、复现步骤、运行环境和脱敏后的错误信息。

## 素材与使用说明

本仓库用于项目展示与技术交流，目前尚未选定开源许可证。代码复用与再分发请先联系作者确认授权。诗词数据库、书画、音视频和三维场景等素材的权利归各自权利人所有，不能将仓库的公开展示视为对第三方素材的授权。

展示图片取自作者提供的项目答辩 PPT，来源页码记录在[界面展示](docs/screenshots.md)中。
