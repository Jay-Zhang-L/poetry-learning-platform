# 诗韵华章 · Web 前端

基于 Vue 3 与 Vite 的诗词研习平台前端。功能、界面展示和作者信息见[仓库首页](../../README.md)，环境与配置见[完整运行指南](../../docs/getting-started.md)。

## 开发

建议使用 Node.js 22 LTS，在当前目录执行：

```bash
npm install
npm run dev
```

默认访问 `http://localhost:5173`。开发代理将 `/api`、`/images`、`/files` 和 `/uploads` 请求转发到 `http://localhost:8080`。

## 构建

```bash
npm run build
npm run preview
```

`preview` 用于预览构建结果，完整部署仍需要配置后端和反向代理。

## 目录

- `src/pages/`：首页、藏书阁、AI、游戏、创作、个人中心等页面。
- `src/recite/`：部分朗诵练习与历史页面。
- `src/components/`：公共与可视化交互组件。
- `src/router/`：页面路由。
- `src/utils/api.js`：请求封装与业务 API。
- `public/viewers/`：三维场景查看器。

数据库与外部服务未配置时，页面服务可以启动，但业务数据与部分交互功能不可用。当前源码的公开范围见[项目状态](../../docs/project-status.md)。
