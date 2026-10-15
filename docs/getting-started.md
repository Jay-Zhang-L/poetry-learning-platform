# 本地运行指南

## 当前复现条件

仓库提供 Web 前端、Java 后端、部分静态资源及 **`database/shici-full.sql` 数据库快照**。快照包含 81 张表的结构与现有演示数据，由作者从本地 MySQL 导出，并确认其中数据为虚拟演示数据。

先按[数据库导入说明](../database/README.md)初始化数据库。AI、OCR、语音功能需要各自的服务配置，数据库中引用的图片、录音、视频等文件也需要存在于对应资源目录。

答辩材料介绍的数据规模约为 33.8 万首诗词。当前导出快照的内容以 SQL 文件为准，本次未将该材料数字作为快照中已核实的诗词行数。

## 环境

| 依赖 | 环境建议 / 代码要求 |
| --- | --- |
| Node.js | 建议 22 LTS，用于运行当前 Vite 6 项目 |
| npm | 随 Node.js 安装 |
| JDK | 17，依据 `pom.xml` 的编译配置 |
| Maven | 建议 3.9，仓库未包含 Maven Wrapper |
| MySQL | 快照由 MySQL 8.0.43 导出，需先导入结构与数据 |
| 浏览器 | 支持 WebGL 与麦克风录音的现代浏览器 |

建议先确认：

```bash
node --version
npm --version
java -version
mvn -version
```

## 1. 获取代码

```bash
git clone https://github.com/Jay-Zhang-L/poetry-learning-platform.git
cd poetry-learning-platform
```

仓库包含较大的书画图片与三维场景文件，首次下载可能耗时。前端目录名称含有空格和中文，进入目录时请保留引号。

## 2. 准备数据库与本地配置

先按[数据库导入说明](../database/README.md)将 `database/shici-full.sql` 导入新建的空数据库。该文件包含建表与数据插入语句，MyBatis 不会替你执行初始化。

进入后端工程：

```bash
cd backend/shici-app-5.1/shici-app-server
```

将 `application-local.example.yml` 复制为同目录下的 `application-local.yml`。PowerShell 示例：

```powershell
Copy-Item application-local.example.yml application-local.yml
```

该本地配置会将文件目录放在后端工程的 `local-data/` 中，避免依赖原开发机器的 `D:/shici-files` 路径。它通过 `local` profile 加载，`application-local.yml` 已加入忽略规则。

数据库默认名称为 `shici`。导入快照后，在启动后端的同一个 PowerShell 终端设置：

```powershell
$env:DB_USERNAME = '你的数据库用户名'
$env:DB_PASSWORD = '你的数据库密码'
# 数据库地址或名称不同时再设置，例如：
$env:DB_URL = 'jdbc:mysql://127.0.0.1:3306/shici?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true'
New-Item -ItemType Directory -Force local-data/files/uploads, local-data/uploads/temp | Out-Null
```

其他终端请使用对应的环境变量设置方式。项目不自动加载 `.env` 文件。

默认配置与生产配置的数据库名不同，`local` 示例默认连接 `shici`。切换环境时应明确设置 `DB_URL`，并使用该环境自己的账号。

## 3. 按需配置 AI、语音与 OCR

| 环境变量 | 用途 | 所需外部依赖 |
| --- | --- | --- |
| `DEEPSEEK_API_KEY` | 诗词问答、虚拟诗人、润色等 | 可访问的 DeepSeek API 与有效额度 |
| `ZHIPU_API_KEY` | 智谱助手 | 智谱 AI API |
| `QWEN_API_KEY` | 图像意象分析 | 通义千问视觉 API |
| `BAIDU_SPEECH_API_KEY` | 语音识别与合成 | 百度语音服务 |
| `BAIDU_SPEECH_SECRET_KEY` | 百度语音鉴权 | 与上项配套的密钥 |
| `PADDLEOCR_URL` | 图片文字识别 | 独立部署的 OCR HTTP 服务 |

只设置需要使用的服务，例如：

```powershell
$env:DEEPSEEK_API_KEY = '替换为你自己的密钥'
```

未配置的服务不能提供相应能力，页面或接口可能返回服务错误。本指南不包含第三方服务账号的申请或付费操作。

OCR 默认请求 `http://127.0.0.1:8868/ocr`。当前 Java 客户端提交 `POST` JSON：

```json
{"imageBase64": "不含 data URL 前缀的图片 Base64"}
```

并读取响应中的 `text` 字段，例如 `{"text":"床前明月光"}`。OCR 服务实现与模型文件尚未公开，需要自行提供兼容此约定的服务。

## 4. 启动后端

在后端工程目录执行。PowerShell 下可使用引号保留 Maven 参数：

```powershell
mvn spring-boot:run '-Dspring-boot.run.profiles=local'
```

默认地址：

- 后端：`http://localhost:8080`
- Swagger UI：`http://localhost:8080/swagger-ui.html`
- OpenAPI JSON：`http://localhost:8080/v3/api-docs`

以上路径由项目配置定义，可用性以实际启动结果为准。

## 5. 启动前端

另开一个终端，从仓库根目录进入：

```bash
cd "frontend/shici-app-starter -完整版本-5.21"
npm install
npm run dev
```

打开 Vite 输出的地址，默认 `http://localhost:5173`。开发代理将 `/api`、`/images`、`/files`、`/uploads` 请求转发到 `http://localhost:8080`。

仓库已有 `pnpm-lock.yaml`，但其中未覆盖当前 `package.json` 的全部新增依赖。本指南先使用 `npm install`；统一包管理器并更新锁文件后，再使用相应的锁定安装命令。

## 构建与部署

前端构建命令为 `npm run build`，默认产物在前端工程的 `dist/`。后端打包命令为 `mvn package`，产物在后端工程的 `target/`。

部署前需要处理以下已有配置特点：

- 路由采用 `createWebHistory()`，静态服务器需要将前端页面路由回退到 `index.html`。
- Vite 的开发代理不会打包到 `dist/`，服务器需提供 API 与文件资源转发。
- 部分前端页面仍写有 `http://localhost:8080`，上线前需统一为实际服务地址或同源路径。
- `StaticResourceConfig.java` 仍有 `/game/**` 的本机绝对路径，应按部署目录调整。
- 数据库、上传目录、资源目录、CORS 和 AI 凭据需使用部署环境配置。

## 常见问题

| 现象 | 优先检查 |
| --- | --- |
| 页面打开但列表为空 / 接口报错 | 后端是否启动、是否导入完整表结构与业务数据 |
| 登录失败或数据库连接异常 | 数据库名、账号、密码、业务表与当前 Mapper 是否匹配 |
| AI 无法回复 | 对应 API 密钥、额度、网络连通性和模型配置 |
| OCR 无法识别 | 独立 OCR 服务是否启动、请求和返回格式是否兼容 |
| 图片、录音或三维场景缺失 | 数据库资源路径及本地媒体文件是否齐全 |
| 麦克风无法使用 | 浏览器权限；远程部署需要 HTTPS 或浏览器认可的安全上下文 |
| 刷新子页面后 404 | 静态服务器的前端路由回退配置 |

本指南基于源码、配置与作者提供的数据库快照编写。已确认导出文件包含 81 张表的建表语句、数据插入语句及完成标记；尚未重新导入测试，也未完成全站及外部服务的运行验证。
