---
title: 从 Markdown 到网页：我的本地写作工作流
date: 2026-08-28 19:00:00
categories:
  - 工程实践
tags:
  - Hexo
  - 写作
  - Butterfly
description: 记录这个站点的本地开发方式，以及如何让文章、代码和实验结果保持可复现。
---

这个博客使用 Hexo 生成静态页面，Butterfly 负责展示层。文章仍然是普通 Markdown 文件，因此写作和发布之间没有数据库或后台服务作为额外障碍。

## 常用命令

```bash
# 安装依赖
npm install

# 清理缓存并生成静态文件
npm run clean
npm run build

# 启动本地预览，默认访问 http://localhost:4000
npm run server
```

## 一篇文章的最小结构

```markdown
---
title: 文章标题
date: 2026-09-04 09:00:00
categories:
  - 工程实践
tags:
  - Markdown
---

正文从这里开始。
```

我会把代码示例控制在一个可以独立阅读的范围，并在文中说明复杂度、前提条件和失败场景。这样文章不仅是知识索引，也能成为下一次实验的起点。

## 为什么保留本地构建

本地生成可以尽早发现 front matter 拼写错误、Markdown 解析问题和主题模板兼容性问题。对包含代码的文章来说，先在本地打开页面确认代码块、目录和移动端布局，再提交到远端，反馈周期会短很多。
