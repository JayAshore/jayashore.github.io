---
title: Agent八股文面经
date: 2026-09-05 20:43:46
updated: 2026-09-05 20:43:46
categories:
  - 八股文
  - 大模型
  - Agent
tags:
  - 大模型
  - Agent
description: 一网打尽大模型面试习题！
keywords:
cover: https://cdn.jsdelivr.net/gh/JayAShore/blog-images@main/images/Agent%E5%85%AB%E8%82%A1%E6%96%87%E9%9D%A2%E7%BB%8F%EF%BC%9AAI%E6%B1%82%E8%81%8C%E6%8C%87%E5%8D%97.png
stick: 1
---


# 字节面试

+ 自我介绍
+ 请你详细介绍你的AI项目；
+ 你的项目中说到了面试评分，那么简历评分的内容是如何进行结构化输出的？从哪几个维度进行评分？
+ 项目中的RAG知识用到了哪些？离线上传和在线问答环节如何进行？
+ 你如何理解Agent中Harness的概念？
+ 你的Agent里面运行了一个长程的任务，它假设平时只允许需要运行5分钟就能结束。然后你新运行了一次，它运行了15-20分钟，也就是说跟之前比有明显的延迟，然后你会怎么分析这个延迟是什么导致的？如何解决上述这个问题？
+ Agent在执行过程中，肯定不可避免地要去调用一些工具，这些工具都有固定地入参，需要模型结合上下文去提供，+ 然后在这个过程中，如何去保障工具调用的可靠性？
+ 随着提问轮次的增加，上下文窗口会越来越大，该如何进行解决？
+ 压缩或者摘要肯定会丢失信息，如何使得这个信息丢失最小化？
+ 给定一个数n，如23121；给定一组数字A如{2，4，9}，求由A中元素组成的小于n的最大数，如小于23121的最大数是22999。




# 基础概念与架构模式
+ 用大白话说清楚什么是 Agent，它和传统对话系统、Siri 类助手的边界在哪？（字节跳动）
+ AI Agent 是什么？为什么要用 Agent 而不是直接调大模型？（字节跳动 / 快手 / 腾讯）
+ Agent 和 Workflow 有什么关系，分别适合什么场景？判断依据是什么？（字节跳动 / 百度 / 腾讯广告 / 得物）
+ 常见的 Agent 架构模式有哪些？（阿里巴巴）
+ ReAct 是什么？工作流程和优缺点分别是什么？（携程 / 腾讯 / 快手）
+ ReAct 和 Plan-Execute-Replan 的区别是什么？分别适用于哪些场景？（美团 / 小红书）
+ Plan-Execute-Replan 为什么需要一个监管 Agent？
+ Agent 项目通常如何设计整体架构、框架和部署流程？（小红书）
+ Agent和大模型在业务中有什么区别？（百度）
+ Agent 项目与传统后端项目的架构差异体现在哪？
+ 搭一个大模型应用，如何在「单次提示词 / Workflow / Agent」三种方案之间选型？
+ 什么时候应该固化成垂直领域 Agent，什么时候要保系统泛化性？
+ 最小可用 Agent 的核心模块是不是一个 ReAct Loop？除了工具调用还必须实现什么？
+ 企业落地 Agent 系统最大的瓶颈是什么？用 Agent 有哪些弊端？
+ Agent与Siri等传统智能助手的核心差异是什么？（字节跳动）
+ 复杂场景既需要 Plan-Execute 的全局规划、又需要 ReAct 的实时反馈，架构上怎么兼顾？
+ 请用通俗的话说明什么是 Agent，让非技术面试官也能听懂。（字节跳动）
+ AI Agent 如何选择底层大模型？多 Agent 场景下主 Agent 和子 Agent 该用一样大小的模型吗？（阿里巴巴 / 滴滴）
+ AI Agent 有哪些常见的模型或类型划分？（腾讯）




# 常见问题
这份题单是怎么整理出来的？
来源是公开面经，把 AI Agent 相关的提问单独抽出来重新归类，手动整理。

AI Agent 面试和大模型算法岗面试差别大吗？
差别很大。大模型算法岗重心在模型结构、训练和强化学习对齐，Agent 岗几乎不问 RLHF 推导，但工具调用、Harness、记忆与上下文工程、多智能体协作会问得非常细，还会要求现场演示或深挖你做过的 Agent 项目。如果两条线都要准备，可以搭配大模型面试题合集一起看。

只背这些题能过面试吗？
不能。这份题单解决的是「准备方向不跑偏」的问题——它告诉你面试官现在在问什么、往哪个方向追。但 Agent 面试有大量时间在挖你的项目细节和现场设计能力，几乎每道概念题后面都跟着一句「你们具体怎么做的、效果怎么量化的」。建议按题单排查知识盲区，同时准备一个能讲清楚设计取舍的真实案例。


# 参考链接

[2026最全大模型面经汇总｜Agent面试题、RAG面试题、Transformer面试题合集（含答案解析） | 代码随想录-全网最全算法数据结构刷题学习路线|图文+视频教程|免费开源](https://programmercarl.com/qita/0022.llminterview.html)

[github.com/bcefghj/ai-agent-interview-guide](https://github.com/bcefghj/ai-agent-interview-guide)

[2026最全AI大模型面试题 | Agent面试题 | AI应用开发面试题 | 小林coding](https://xiaolincoding.com/project/xiaolinnote.html)

[AI Agent 面试题与八股文汇总：155 道大厂真题按主题拆解（2026 面经） - 面灵AI](https://www.mianlingai.com/topics/ai-agent-interview-questions-2026/)

[Agent开发八股合集真实面经总结版_牛客网](https://www.nowcoder.com/feed/main/detail/76b321bffc5e460fb316813352d8d950)