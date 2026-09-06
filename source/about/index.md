---
title: 关于
date: 2026-09-05 12:00:00
type: about
comments: true
aside: true
---

<style>
.about-page {
  color: var(--font-color);
}

.about-hero {
  text-align: center;
  margin: 0 0 2.5rem;
}

.about-hero h1 {
  margin-bottom: .8rem;
  font-family: Georgia, serif;
  font-weight: 500;
}

.about-hero p {
  color: var(--anzhiyu-fontcolor);
  margin: 0;
}

.about-page h2 {
  margin-top: 2.3rem;
}

.about-page h2::before {
  color: var(--anzhiyu-theme);
}

.about-divider {
  position: relative;
  height: 1.4rem;
  margin: 2.4rem 0;
  border-top: 3px dotted #8ed3f4;
}

.about-divider::before {
  content: '\2702';
  position: absolute;
  top: -1.05rem;
  left: 1.4rem;
  padding: 0 .35rem;
  color: #69bff0;
  background: var(--card-bg);
  font-size: 1.55rem;
}

.about-tags {
  display: flex;
  flex-wrap: wrap;
  gap: .55rem;
  margin: 1rem 0;
}

.about-tags span {
  display: inline-block;
  padding: .25rem .7rem;
  border-radius: 999px;
  background: var(--text-bg-hover);
  color: var(--font-color);
  font-size: .9rem;
}

.about-callout {
  margin: 1.2rem 0;
  padding: 1rem 1.2rem;
  border-left: 4px solid var(--anzhiyu-theme);
  background: var(--anzhiyu-card-bg);
}

.about-links a {
  margin-right: 1rem;
}

@media screen and (max-width: 768px) {
  .about-hero h1 {
    font-size: 1.8rem;
  }

  .about-divider {
    margin: 1.8rem 0;
  }
}
</style>

<div class="about-page">
  <section class="about-hero">
    <h1>JayAShore</h1>
    <p>记录算法、工程实践与 Agent 思考的个人技术博客</p>
    <p class="about-links">
      <a href="https://github.com/JayAShore" target="_blank" rel="noopener noreferrer">GitHub</a>
      <a href="/">返回首页</a>
    </p>
  </section>

  <h2>你好 👋</h2>

  <p>我是 JayAShore，正在学习和实践算法、软件工程与智能体应用。</p>

  <ul>
    <li>关注数据结构、算法题和系统设计</li>
    <li>记录 Hexo、Git、自动化部署等工程实践</li>
    <li>探索 Agent、RAG 与大语言模型应用</li>
    <li>把学习过程整理成可以复现的文章和代码</li>
  </ul>

  <div class="about-tags">
    <span>Python</span>
    <span>C++</span>
    <span>JavaScript</span>
    <span>Git</span>
    <span>Hexo</span>
    <span>Agent</span>
    <span>Algorithms</span>
  </div>

  <div class="about-divider"></div>

  <h2>本站说明</h2>

  <p>本站主要记录学习笔记、算法推导、代码实践以及智能体相关实验。</p>

  <div class="about-callout">
    <strong>DOWN IS BETTER THAN PERFECT</strong>
    <p>先把想法做出来，再持续迭代和改进。</p>
  </div>

  <h2>内容方向</h2>

  <ul>
    <li><strong>算法：</strong>排序、二分、图算法、动态规划与题解总结</li>
    <li><strong>工程：</strong>Git、Linux、Hexo、部署和日常开发工具</li>
    <li><strong>Agent：</strong>工具调用、工作流编排、RAG 和应用实践</li>
  </ul>

  <div class="about-divider"></div>

  <h2>联系我</h2>

  <p>如果文章中有错误或你想交流相关内容，可以通过 GitHub 联系我。</p>

  <p class="about-links">
    <a href="https://github.com/JayAShore" target="_blank" rel="noopener noreferrer">GitHub 主页</a>
    <a href="https://github.com/JayAShore/jayashore.github.io" target="_blank" rel="noopener noreferrer">博客源码</a>
  </p>
</div>
