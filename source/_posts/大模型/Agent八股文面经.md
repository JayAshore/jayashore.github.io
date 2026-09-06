---
title: Agent面经宝典
date: 2026-09-05 20:43:46
updated: 2026-09-05 20:43:46
categories:
  - 八股文
tags:
  - 大模型
  - Agent
description: 
keywords:
permalink: 
cover: https://cdn.jsdelivr.net/gh/JayAShore/blog-images@main/images/Agent%E5%85%AB%E8%82%A1%E6%96%87%E9%9D%A2%E7%BB%8F%EF%BC%9AAI%E6%B1%82%E8%81%8C%E6%8C%87%E5%8D%97.png
stick: 1
---



# 百度
+ 实践过程中，一个问题大概要多少loop
> 业务场景差异很大：简单日志排查、明确指令一般2‑3 轮 loop；问题模糊、需要多次查日志 + 核对接口、多步骤定位的复杂故障，普遍4‑8 轮；极少数边界疑难问题会冲到 8 轮以上。线上生产环境我们一般不会放任无限循环。

+ 怎么评判这个loop次数是符合预期的呢？loop上限是依据什么取的

+ 查询日志接口是现有的是吧，怎么保证不会一次拉取过多的日志上下文爆掉呢

+ 你们怎么去评估这个Agent的效果的呢？以及后续怎么优化的呢？

+ 这几个点都是一些不同维度的指标，有些指标变好，有些指标变差，这个时候怎么判断优化的结果怎么样呢？
> 1. 先确定**业务核心目标**：比如首要目标是故障解决率，其次才是减少轮次、降低成本；2.使用**加权综合打分**，或者设定约束条件：主指标不能下跌，在主指标持平/提升的前提下优化次要指标；3.AB对照实验，统计显著性，不能看单个样本；4.分场景看收益：优化对高频核心问题收益明显，即使少量边缘case变差，整体版本依然可以接受，最后权衡成本与收益做版本取舍。

+ loop次数其实和读取的日志所涉及的量有关系，那么为什么还要把loop次数作为一个测试的指标呢？

+ IM项目中的AI助手和知识检索是怎么做的呢？是你自己做的吗？

+ API调用大模型的时候是分场景调用还是什么形式
> 是的，**按场景分流调度**：简单问答、摘要、工具决策使用性价比更高的轻量模型；复杂推理、长文本分析、故障根因总结使用更强的大基座；同时做限流、缓存、路由策略，控制成本。

+ 我看你们这个有一个向量检索，为什么对不同的文档进行分别进行切割和向量化
> 1. 不同类型文档格式、行文结构完全不一样：接口文档、运维手册、变更记录、FAQ适合不同切片策略；
2. 统一切割粒度会出现两种问题：短文档切得太碎丢失语义，长文档切片过大上下文冗余；
3. 分文档独立处理可以定制**切片大小、重叠步长、清洗规则**，提升检索精准度；后续也可以单独更新某一份文档，不用全量重刷整个知识库。

+ 用的什么embedding模型
> 我们优先使用开源中文embedding基座（例如bge系列）；参数量大概百M级别。
内部做过对比实验：bge、m3e等多款中文向量模型，在业务自建评测集上召回精度、排序效果、推理耗时综合对比，选出当前最优版本；后续也会持续评估更新的embedding模型迭代替换。


+ embedding模型是多大的模型，有没有尝试过其他的embedding模型呢？

+ RRF融合排序是怎么做的？什么原理呢
> RRF（Reciprocal Rank Fusion，倒数排名融合），是一种无需打分归一化的多路检索融合算法。
1. 分别拿到向量检索列表、ES关键词检索列表，各自自带排名；
2. 对每一条文档计算得分：$score=\sum \frac{1}{k+rank}$，k是平滑常量（一般取60）；rank代表文档在各自结果里的位次；
3. 将所有文档按照融合后的总分重新排序。
优点：不需要对齐两路检索的分数区间，兼容向量相似度和BM25两种完全不同的打分体系，兼顾语义召回和关键词精准匹配。


+ 所以这个RRF是使用的向量检索的结果和ES的结果来进行融合的吧？

+ 为什么还要再做一次rerank

+ 怎么优化这个rerank的结果呢？怎么确保现在rerank的效果是好的

+ 人工标注的规模有多大

+ 这个RAG评测平台的目标是什么呢？

+ 为什么这个平台可以解决人工标注的问题

+ 算法：输入一个数组，一个行数m，然后按照倒N的形状来输出

+ 假如这个问题改成先从上到下，再从左往右这样排列，怎么改呢？
> 

+ 你这边的base地有强要求吗？
> 可以接受目标 base 城市；如果项目阶段性需要短期出差支持也可以配合，整体稳定性优先。

+ 讲一下你的职业规划吧，你希望三年内做到什么地步
> 第一年：吃透 Agent、RAG 整套工程链路，独立负责模块落地，能够独立完成方案设计、评测迭代与问题排查；
第二年：主导完整业务 AI 助手项目，负责技术方案选型、实验评估、bad‑case 闭环优化，沉淀可复用的内部工具链与评测体系；
第三年：成长为该方向的技术骨干，能够牵头复杂 AI 工程化方案，带领小模块迭代，在大模型应用落地、自动化评测、Agent 可靠性优化上产出可复用的技术沉淀，支撑更多业务场景落地。

**反问环节**
+ 在AI的浪潮下，对开发岗位来说如何保持一个竞争力？现在AI的模型下，在实际生产过程中，比较困难点的在哪里呢？
+ 部门具体的业务都是什么。
+ 不同技术栈在考察不同背景的学生的时候，面试的时候会更看重哪些方面？



# 快手

+ 你在项目中使用过哪些 AI 编码辅助工具（Cursor、Codex）？如何协作保证代码质量？
+ 你设计过工具调用结果缓存吗？如何决定哪些结果可缓存，缓存多久？
+ 在多轮对话中，用户长期偏好（语言风格、地点）如何存储？用什么数据结构？
+ 如何确保 Agent 不泄露敏感信息？从输入过滤和输出脱敏两方面说明。



# 字节

+ 自我介绍
+ 请你详细介绍你的AI项目；
+ 你的项目中说到了面试评分，那么简历评分的内容是如何进行结构化输出的？从哪几个维度进行评分？（项目有关）
+ 项目中的RAG知识用到了哪些？离线上传和在线问答环节如何进行？（项目有关）
+ 你如何理解Agent中Harness的概念？
+ 你的Agent里面运行了一个长程的任务，它假设平时只允许需要运行5分钟就能结束。然后你新运行了一次，它运行了15-20分钟，也就是说跟之前比有明显的延迟，然后你会怎么分析这个延迟是什么导致的？如何解决上述这个问题？
+ Agent在执行过程中，肯定不可避免地要去调用一些工具，这些工具都有固定地入参，需要模型结合上下文去提供，+ 然后在这个过程中，如何去保障工具调用的可靠性？
+ 随着提问轮次的增加，上下文窗口会越来越大，该如何进行解决？
+ 压缩或者摘要肯定会丢失信息，如何使得这个信息丢失最小化？
+ 给定一个数n，如23121；给定一组数字A如{2，4，9}，求由A中元素组成的小于n的最大数，如小于23121的最大数是22999。



# 基础概念与架构模式

+ 用大白话说清楚什么是 Agent，它和传统对话系统、Siri 类助手的边界在哪？（字节跳动）
> 普通 Siri / 聊天机器人：你给一句明确指令，它做一件固定的事，做完就停。不会自己拆任务、不会主动查资料、遇到问题不会自己改方案。
Agent 是会自己干活的 AI 员工：听懂你的大目标之后，自己拆分步骤、自己判断要不要调用工具、中间错了自己调整，直到把整件完整事情做完，而不是只回答一句话。
边界：Siri：一问一答，单次动作，没有自主闭环；普通对话机器人：流程写死，人必须一步步引导；Agent：目标驱动，自主规划、自主纠错、多步闭环完成复杂任务。

+ AI Agent 是什么？为什么要用 Agent 而不是直接调大模型？（字节跳动 / 快手 / 腾讯）
> AI Agent（智能体）是一套「能自主规划、使用工具、迭代执行、完成完整目标」的智能系统，大模型只是它的大脑。
一个标准 Agent 一般由 5 个部分组成：
1、大模型 LLM（思考大脑）：负责理解目标、推理、写计划
2、记忆 Memory：短期对话上下文 + 长期知识库 / 历史任务
3、规划 Planning：把大目标拆成一步步子任务（反思、纠错）
4、工具调用 Tool Use：联网查数据、调用 API、操作文件、执行代码
5、行动 Action：循环执行 → 观察结果 → 判断是否完成（闭环）
简单对比：
裸大模型：你问一句，它输出一段文字；被动应答，一次性输出，不会自己干活
AI Agent：你给一个最终目标，它自己想步骤、找工具、试错，直到把整件事做完

+ Agent 和 Workflow 有什么关系，分别适合什么场景？判断依据是什么？（字节跳动 / 百度 / 腾讯广告 / 得物）
>  Workflow（工作流）：人提前把每一步顺序写死，固定分支，逻辑确定。比如：审批流、固定报表导出。优点稳定可控、确定性高；缺点不能应对意外情况。
Agent：步骤不写死，由大模型实时动态决定下一步做什么，分支灵活，能处理不确定、多变的问题。

+ 常见的 Agent 架构模式有哪些？（阿里巴巴）
>ReAct（推理 + 行动）：思考→调用工具→拿到结果再思考，循环闭环；
Plan‑Execute‑Replan（规划‑执行‑重规划）：先生成完整方案，分步执行，发现偏差重新改计划；
Reflection / Self‑Critique 自省式 Agent：执行完成之后自我复盘评估结果好不好；
Multi‑Agent 多智能体：拆分角色（规划 Agent、工具 Agent、校验 Agent）分工协作；
Tool‑call Agent（基础工具调用 Agent）：轻量单轮工具调用；
Cognitive Architecture（完整认知架构）：短期记忆、长期记忆、反思、规划全套模块（AutoGPT 这类）。

+ ReAct 是什么？工作流程和优缺点分别是什么？（携程 / 腾讯 / 快手）
> 流程循环，hought(思考我需要做什么) → Action(调用工具) → Observation(拿到返回结果)
优点：实现简单，实时根据最新结果调整下一步动作，适合动态、不可预测的场景；
缺点：短视，缺少全局视角，容易陷入局部循环，走弯路，长任务容易跑偏。


+ ReAct 和 Plan-Execute-Replan 的区别是什么？分别适用于哪些场景？（美团 / 小红书）
> ReAct：边走边想，每一步才决定下一步，没有完整前置方案。适合探索型、未知问题（网页搜索排查问题）；
Plan‑Execute‑Replan：先做完整全局方案，再一步步执行，中途发现计划走不通再重新规划。适合目标明确、步骤多、需要整体把控的长任务（写一份完整市场调研报告）。

+ Plan-Execute-Replan 为什么需要一个监管 Agent？
> 执行过程中会出现计划失效、结果不符合预期、执行出错、偏离业务约束。
监管 Agent 独立负责校验每一步结果、判断当前计划是否失效、触发重新规划、拦截错误操作，防止执行 Agent 盲目继续执行错误步骤，保证最终结果符合业务目标。

+ Agent 项目通常如何设计整体架构、框架和部署流程？（小红书）
> 1、业务层：用户输入、会话管理；
2、Agent 核心层：记忆模块（短期对话记忆 / 长期向量记忆）、规划模块、反思校验模块、工具路由；
3、工具层：函数 / 接口 / 数据库调用；
4、模型层：底层 LLM；
5、观测运维层：日志、Trace、评估、人工干预入口；


+ Agent和大模型在业务中有什么区别？（百度）
> 大模型：大脑，只会思考和输出文字，没有动手能力，没有流程；
Agent = 大脑 (LLM) + 手脚 (工具) + 记忆 + 做事流程 + 纠错机制；
业务上：大模型负责理解与推理；Agent 负责完整业务流程自动化执行。


+ Agent 项目与传统后端项目的架构差异体现在哪？
> 1、传统后端：逻辑硬编码，确定输入得到确定输出；
2、Agent 系统：非确定性系统，输出依赖 LLM 随机推理；
3、新增模块：记忆存储、规划、自省评估、工具调度；
4、运维方式变化：不能只监控接口报错，还要做效果评估、幻觉监控、人工兜底；
5、迭代方式：传统改代码；Agent 迭代 Prompt、工具集、评估数据集。

+ 搭一个大模型应用，如何在「单次提示词 / Workflow / Agent」三种方案之间选型？
> 1、单次 Prompt：简单一次性文本生成、翻译、摘要；步骤为 0，不需要外部工具；
2、Workflow：步骤固定、分支可控、业务规则确定，追求稳定可控；
3、Agent：目标复杂、步骤不确定、需要动态决策、中途校验重试。
优先级选型原则：能 Prompt 就不用 Workflow，能 Workflow 就不上 Agent，Agent 成本最高、不可控性最强。

+ 什么时候应该固化成垂直领域 Agent，什么时候要保系统泛化性？
> 1、垂直固化 Agent：业务场景固定、工具集合固定、有明确业务规则（电商客服 Agent、财务对账 Agent），收敛能力，减少幻觉，稳定性优先；
2、泛化通用 Agent：面向开放式需求，工具集庞大，用户任务不可预知，追求灵活能力。




+ 最小可用 Agent 的核心模块是不是一个 ReAct Loop？除了工具调用还必须实现什么？
> 最小可用 Agent 核心确实是 ReAct 循环；除此之外必备：
1、会话短期记忆；
2、停止判断逻辑（什么时候任务完成）；
3、简单结果校验；
4、异常捕获、重试机制；
5、没有记忆的单次工具调用不算完整 Agent。


+ 企业落地 Agent 系统最大的瓶颈是什么？用 Agent 有哪些弊端？
> 瓶颈:1、结果不可控、幻觉风险；2、工具可靠性问题（接口不稳定）；3、效果难以自动化评估；4、安全风险：自主调用高危业务接口；5、成本高、延迟高；
弊端：1、执行路径不可预测，调试困难；2、长任务容易发散，执行超时；3、对底层模型能力依赖极高；4、安全管控成本远高于传统系统。


+ Agent与Siri等传统智能助手的核心差异是什么？（字节跳动）
> Siri：被动单次执行，用户必须给出精准简短指令，完成单一动作；
Agent：目标驱动自主多步闭环。你给一个模糊大目标，它自己拆解执行、纠错，独立完成一件完整复杂工作。

+ 复杂场景既需要 Plan-Execute 的全局规划、又需要 ReAct 的实时反馈，架构上怎么兼顾？
> 采用混合架构，1. 规划层（PER）先生成全局粗粒度方案；2. 拆分成一个个子任务；3. 每个子任务内部用 ReAct 循环执行，实时根据工具返回动态决策； 4. 监管模块校验子任务结果，失败触发顶层重新规划。也就是：顶层全局规划，子步骤局部 ReAct 灵活执行。



+ 请用通俗的话说明什么是 Agent，让非技术面试官也能听懂。（字节跳动）
> 普通 AI 只会回答你问的一句话；Agent 相当于给 AI 配了双手、记事本和判断力。你只告诉它最终想要什么，它自己一步步查资料、操作系统，遇到问题自己调整办法，从头到尾把整件事做完交给你。

+ AI Agent 如何选择底层大模型？多 Agent 场景下主 Agent 和子 Agent 该用一样大小的模型吗？（阿里巴巴 / 滴滴）
> 主 Agent（规划、决策、复杂推理）：使用能力更强的大参数量模型，逻辑理解、反思纠错要求高；
子 Agent / 工具调用 Agent：任务简单，只是格式化参数、简单判断，可以使用轻量低成本小模型；
原则：重决策用大模型，简单动作调度用小模型节省成本。

+ AI Agent 有哪些常见的模型或类型划分？（腾讯）
> 按执行范式划分：ReAct Agent、Plan‑Execute‑Replan Agent、Self‑Reflection Agent；
按角色数量：单 Agent / Multi‑Agent 多智能体；
按领域：通用 Agent / 垂直业务 Agent；
按能力强弱：轻量工具调用 Agent、完整认知 Agent（记忆 + 规划 + 反思）；
按部署形态：代码解释器 Agent、工作流增强 Agent。


# Agent Harness 与运行时工程
`这一节是 2026 年才真正热起来的方向，很多概念半年前还不存在，考察的是理解力而不是背诵！！！
- Prompt Engineering、Context Engineering、Harness Engineering 三者有什么区别？（钉钉）
> 1、Prompt Engineering 提示词工程：只优化文本指令、Few‑shot、角色设定，改输入文本，不改动执行流程，是最上层的文本调优。
2、Context Engineering 上下文工程：管理上下文窗口、RAG 检索过滤、摘要压缩、记忆分片、去重，控制传给大模型的信息质量与长度，解决上下文溢出、信息噪声问题。
3、Harness Engineering 智能体基座工程：构建整套运行时框架，负责状态管理、工具调度、循环迭代、失败重试、快照持久化、多子 Agent 编排，管控完整执行生命周期，是 Agent 的底层运行骨架。
Prompt Engineering → 控制模型怎么思考
Context Engineering → 控制模型看到什么信息
Harness Engineering → 控制整个 Agent 怎么跑、失败怎么处理、状态怎么保存

- Agent Engineering 和 Harness 在软件开发中分别指什么？
> Agent Engineering（Agent 工程）：面向业务，定义 Agent 能力、工具集、业务逻辑、任务规划，做 Agent 本身的业务开发。
Harness：底层运行时 / 执行容器，提供统一调度、状态保存、错误降级、日志追踪、多轮循环的基础设施，是承载 Agent 运行的平台。
Agent Engineering = 完整做 Agent 这件事
Harness = Agent 运行和测试的底层基础设施

- Harness 做的事情 LangChain 等框架其实一直在做，为什么 harness 这个概念现在突然火了？区别是什么？（字节跳动大模型算法三面）
> LangChain 早期侧重链式调用封装；而 Harness 重点解决长任务持久状态、断点续跑、复杂循环、容错降级、可观测性、大规模生产部署。
LangChain：是开发 SDK，帮你快速写 Agent，轻量原型；
Agent Harness：面向生产级 Agent Runtime，原生支持快照、中断人工介入、长耗时任务容错，企业生产落地痛点催生该概念，不是替代 LangChain，而是更高阶运行范式。


- 聊一聊 Harness、Hermes 这类比较新的 Agent 设计范式，最近看过哪些相关论文？（字节跳动暑期）
> Harness范式：偏向Runtime 驱动：规划、工具调用可以交给模型，但是流程控制、状态保存、失败恢复由外部运行时接管，强工程化，适合长任务、多轮复杂 Agent。
Hermes（Prompt‑centric Agent 范式）：Hermes 强调统一函数调用格式，标准化工具调用 Schema，弱化复杂硬编码规划逻辑，把大量调度逻辑交给模型本身，偏向轻量化 Agent。
论文：AutoGen: Enabling Next‑Gen LLM Applications via Multi‑Agent Conversation（微软）—— 多 Agent 调度原型基座
LangGraph / State‑based Agent Execution（LangChain 团队工程报告）—— 状态机式 Agent 运行时
AgentBench: Evaluating LLMs as Agents — Agent 大规模评测 Harness 基准框架
OpenAI Agents SDK：标准化 Agent runtime，现代 Harness 设计思路代表
趋势总结：学术界早期研究模型能力；最近一年论文重点转向Agent 执行基础设施、标准化评估框架（也就是 Harness）。

- 市面上主流的开源 Agent Harness 框架有哪些？最近关注过哪些？（快手）
> LangGraph、AutoGen、AgentScope、LlamaIndex Workflow、Open‑Agents、CrewAI、Haystack 2.0，近期热度较高的是 LangGraph、AgentScope、OpenAI 新 Agent SDK。


- 你了解 Claude Code 的上下文管理方式和实现思路吗？（快手 / 蔚来）
> 我有所涉猎，我的认知里Claude Code是采用分层上下文策略：文件增量读取、动态上下文窗口滑动、代码摘要缓存、丢弃非变更文件片段；按需加载文件，不会一次性灌入全部代码库；同时支持用户指定上下文范围，配合结构化会话记忆控制 token 开销。


- 为什么不用 Deep Agents 框架而选 LangGraph？Deep Agents 不稳定的原因可能是什么？
> LangGraph 原生显式状态管理、可控分支循环、持久快照，可调试可回滚，生产可控。
Deep Agents 不稳定原因：隐式自我规划循环无约束、状态不可控、没有强制断点校验、自我反思发散不可控，缺少工程层面的容错边界。

- 业界 Agent Runtime 越来越多，平台侧如何统一适配和管理？
> 1、定义标准化 Agent 执行协议、状态结构、工具调用接口；
2、统一网关调度、日志埋点、指标监控；
3、适配器模式封装不同 Runtime；
4、统一持久化存储、权限、版本管理；
5、提供统一编排控制台。

- 未来更可能是一个 Super Agent 通吃所有任务，还是 Host Agent 加多个 Sub Agent 的组合？
> 中长期更偏向 Host 主 Agent + 多个专用 Sub‑Agent。单一 Super Agent 很难在所有细分任务上做到最优；主 Agent 负责任务拆分、路由、结果聚合，子 Agent 专精单一领域，成本可控、可独立迭代。

- LangChain 和 LangGraph 有什么区别？LangGraph 的状态快照机制怎么实现？（字节跳动 / 快手 / 阿里巴巴）
> LangChain：线性 Chain，无原生循环分支；LangGraph 是基于图的状态机，支持循环、分支、断点、持久化快照。
快照实现：自定义 State 对象，每一步节点执行完成序列化保存状态（内存 / 外部存储），节点执行完成生成 checkpoint，中断后从指定 checkpoint 恢复执行。

- Java 生态里为什么选 Spring AI 而不是 LangChain4j？（京东 / 字节跳动 / 快手）
> SpringAI 深度融入 Spring 全家桶，配置化开发、原生 SpringBoot 自动装配、企业生态成熟；LangChain4j 是 Java 版 LangChain，API 风格偏原生代码编程，与 Spring 体系整合成本更高。

-  Java 生态还有哪些主流 Agent 框架？（快手 / 京东）
> Python 生态主力：LangChain / LangGraph / AutoGen / CrewAI / Haystack / LlamaIndex / OpenAI Agents SDK
JS/TS：LangChain.js，Vercel AI SDK
Go：Go‑Agent 框架、自研轻量 Runtime


- Agent 的组装链 / 执行链如何设计，执行失败时如何降级？
> 执行链：规划节点 → 工具调用节点 → 结果校验节点 → 反思重试节点，用状态机做 DAG 编排；
降级策略：1）工具调用失败自动重试；2）多次失败切换备用工具；3）复杂失败交由人工介入；4）截断任务返回阶段性结果；5）切换更小难度的子方案兜底输出。


# 工具调用：Function Calling、MCP 与 Skills

- Function Calling 的原理是什么？模型如何知道该调用哪个工具？如何理解 Tool Use？（阿里巴巴 / 快手 / 京东）
- 如果大模型返回的 Function Call 参数格式不对，工程上怎么处理？（阿里巴巴）
- MCP 是什么？主要作用是什么？（字节跳动 / 腾讯 / 京东 / 阿里巴巴）
- MCP 是什么，它解决了什么问题？（抖音）
- MCP 协议底层原理是什么，和传统 Tool 注册方式有什么区别？（阿里巴巴）
- MCP 与 Function Calling 有什么区别？（字节跳动 / 快手 / 货拉拉 / 百度）
- MCP 是什么，MCP 的通信方式有哪些？（阿里巴巴）
- MCP Server 具体怎么开发？（阿里巴巴）
- MCP 在实际项目中可以用来做什么？
- MCP 应该如何设计才能兼顾扩展性和安全性？（字节跳动 / 携程）
- 没有 MCP 之前，多 Agent 协同是怎么做的？（靠 Function Calling 分发）
- MCP 是否已经过时？为什么现在讨论热度没那么高了？（阿里千问）
- A2A 和 MCP 是什么关系？多 Agent 之间的通信协议应该怎么设计？（阿里千问 / 字节跳动）
- MCP 和 Skills 有什么区别？（TikTok / 京东 / 字节跳动 / 美团 / 腾讯 / 阿里云 / 小红书）
- Prompt、MCP、Skills、Subagent 分别应该怎么理解？（字节跳动）
- Function Call、MCP、Skill 三者的边界在哪？（B站）
- AI Agent 里的 Skills 具体指什么？（美团）
- Agent Skill 是什么，模型是怎么被引导调用一个 Skill 的？
- 为什么用 Skills 能减少 token 消耗？（网易 / 快手 / 腾讯）
- 从使用经验来看，Skill 和 Rule 有什么区别？（腾讯 / 蚂蚁集团）
- Skill 的渐进式披露具体是怎么实现的？为什么 Agent 能力要采用渐进式披露？（美团）
- 如果让你设计一套 Agent Skill 系统，会怎么设计？一个好的 Skill 结构应该包含哪些字段？（快手）
- 注册了上百个候选 Skill，该怎么处理——检索、分层还是渐进式披露？（快手）
- 大规模工具集下如何降低工具调用幻觉、提升选对工具的准确率？（字节跳动 / 快手）
- 工具调用的编排放在 Skill 里还是 Agent 里？工具是在 Agent 内定义，还是由 MCP 平台统一提供？
- 如何决定哪个 Agent 能访问哪些 MCP 服务？是不是所有 Agent 都该能访问全部 MCP？
- 工具调用报错、长时间无响应、连续失败时，重试、超时与异常隔离策略怎么设计？（快手 / 蔚来）
- 多工具调用系统如何编排？通常包含哪些模块？（百度）
- Spring AI Alibaba 的 Function Calling 具体是如何实现的？（字节跳动 / 快手）

# 记忆管理与上下文工程

- Agent 的短期记忆和长期记忆如何实现、如何区分？（京东 / 携程 / 美团）
- Agent 记忆管理整体如何设计？记忆模块选什么数据库，选型依据是什么？（京东 / 京东科技 / 滴滴）
- 长期记忆和 RAG 有什么区别？Agent 的记忆为什么要区分长短期，架构上有什么不同？（阿里千问 / 通义）
- 记忆如何召回？如何避免不同问题召回的记忆相互污染？（字节跳动）
- 在 Agent 项目中如何设计上下文管理机制？（京东物流 / 阿里云）
- 检索 Agent 中如何进行上下文管理？（小红书）
- 上下文工程应该如何设计，涵盖哪些环节？最重要的是哪一环？（高德 / 字节跳动）
- 上下文压缩应该放在链路的哪一步？先压缩再向量化，还是反过来？（字节跳动）
- 长对话 / 上下文窗口受限时如何处理？滑动窗口 + 摘要方案具体怎么落地？（字节跳动 / 腾讯）
- 工具调用结果怎么压缩——原地压缩还是交给另一个模型处理？对执行效果和耗时有什么影响？（字节跳动 / 蔚来）
- 为什么上下文越长，模型结果反而越不稳定？为什么指令在上下文里的位置会影响效果？
- 快到上下文窗口阈值时，如何避免一次性大段压缩打断用户体验？（字节跳动）
- 除了压缩，还有哪些规避上下文窗口限制的方案？大结果卸载在工程上怎么实现？（字节跳动 / 蔚来）
- 多轮长任务如何避免「任务目标迷失」？如何理解「无限长记忆」和必须舍弃历史信息之间的矛盾？（字节跳动）
- 怎么区分上下文污染和工具污染？AI 工具上下文跑偏时，是继续控制上下文还是新开一个 session？（字节跳动）
- 长期运行的 Agent 面对数月甚至更久的历史对话，记忆系统怎么持续优化？（小红书 / 蔚来）
- 记忆有没有量化指标？怎么评测记忆对 Agent 效果的贡献？
- 多工具调用和长短期记忆场景下，哪些数据需要写入记忆？判断标准是什么？（百度）
- 如何保证压缩过程中不丢关键内容？压缩导致结果失真如何缓解？（小红书）

# 多智能体协作与编排

- 多 Agent 协作模式如何理解？多 Agent 相比单智能体的优势是什么？（阿里巴巴 / 美团）
- 常见的 Agent 架构模式有哪些，多 Agent 场景下如何选型？（阿里巴巴）
- 子 Agent 之间如何交互 / 通信？交互协议如何设计？串行还是并行执行，如何取舍？（美团 / 快手）
- 主 Agent 如何动态识别并选择要调用的子 Agent？固定工作流还是动态判断？（美团）
- 多个 Agent 策略结论 / 角色不一致时如何处理？（京东）
- 主 Agent 怎么知道子 Agent 已经执行完成？子任务结果如何回收？（蔚来）
- 多 Agent 用独立 JSON 消息做异步通信要怎么设计？通信失败有哪些兜底机制？（蔚来）
- 用 Markdown 文件在 Agent 之间传递任务时，如何防止任务拆分阶段的错误一路传播下去？（字节跳动）
- 多个 Agent 如何做到完全隔离（上下文、权限、存储）？跨 Agent 场景下统一存储怎么通信和传输？（字节跳动 / 蚂蚁集团）
- 多 Agent 调研类系统该选中心化还是去中心化调度？怎么做到子任务失败可回退、进度可观测？
- 除了路由分发，还有哪些常见的多 Agent 协作方式？Agent Team 和动态任务分发机制了解吗？（字节跳动）
- 多智能体是否真的能提升效率？相比单智能体的独特价值怎么证明、怎么评估？（字节跳动）
- 子 Agent 执行中发现需要额外的新任务，任务应该怎么流转和审批？（腾讯广告）
- Agent 平台的多模块集成架构如何设计？（腾讯）
- Agent的核心技术组成和执行链路是什么？（快手）

# 评估、幻觉与安全兜底
- 怎么降低ai幻觉？
- Agent 评估体系包括哪些维度？如何衡量 planning 能力 vs hallucination rate？（阿里巴巴）
- 如何构建 Agent 的评测体系？（Shopee / 小红书）
- Agent 项目应该统计哪些指标来衡量效果？（字节跳动）
- 智能体死循环 / 无限调用的原因及解决方案？为什么要设计三层防护机制？（字节跳动 / 快手）
- Agent 如何做权限控制避免越权 / 不合理操作？高危场景如何限制 Agent 直接执行真实资金操作？（腾讯 / 京东）
- Prompt Injection / Indirect Prompt Injection 是什么？如何防范恶意提示词注入？（钉钉 / 小红书）
- 沙箱机制如何实现？（B站系统设计）
- 生产环境 Agent 的四类典型故障——思考链错误传播、工具幻觉、JSON 格式崩坏、无限循环——分别怎么发生的？如何分三层解决？（字节跳动）
- 如何设计机制终止无效循环，而不是只依赖最大轮次？超时和重试限制怎么设？（字节跳动）
- 线上 Agent 一直调工具但不返回结果，怎么 Debug？多步任务失败时如何区分是 Prompt、模型、工具还是逻辑问题？（字节跳动 / 腾讯混元）
- 如何建立 Agent 的可观测性（轨迹留存、指标、回放）？（通义）
- 幻觉率怎么定义和计算？降幻觉的数字是怎么量化出来的？（字节跳动）
- 如果检测 Agent 自身也会幻觉，工程上如何保证检测 Agent 可靠？（美团）
- Agent 前序步骤产生幻觉、导致链式积累时应该如何处理？（美团）
- 如何区分「内容过时」和「模型幻觉」？（字节跳动）
- HITL：触发人工确认时 Agent Loop 处于什么状态？状态怎么暂停、暂存和恢复？（蔚来）
- 哪些内容必须人工审核、不能交给 Agent？运维类 Agent 能重启机器和服务时，高危操作怎么管控？（蚂蚁集团 / 唯品会）
- 如何防止网页、外部文档里的恶意指令注入 Agent？抓回来的内容怎么保证可信？（字节跳动）
- Agent 已经完成初始身份认证，为什么还需要连续认证？（字节跳动）
- Agent 执行到中间某个阶段出异常，如何断点恢复？整体兜底方案是什么？（字节跳动）
- Agent 的兜底策略如何设计？（京东 / 字节跳动）
- Agent 的执行过程要不要向用户透明展示？展示到什么粒度？

# 系统设计题（高频压轴）

- 设计一个多 Agent 自动 PR 系统，从沙箱、Agent 通信、上下文管理、工具触发、安全性几个角度展开。（B站）
- AI 客服 Agent 项目如何设计？RAG 如何分块和选择向量模型？（阿里巴巴）
- 视频问答 Agent / 股票分析 Agent 全链路如何设计？（阿里巴巴 / 快手 / 京东）
- 设计一个 AI 代码 Review Agent：输入一个 PR，整体方案怎么做？怎么保证它只提意见、不直接改代码？（字节跳动）
- 企业知识库 Agent 主要解决什么业务问题？完整链路、文档导入、权限隔离、效果评测怎么串起来？（Shopee / 字节跳动）
- 企业知识库 Agent 的消息推送功能如何设计？（Shopee）
- 设计一个内容标注 Agent（视频 / 图文）：流程如何划分，要用到素材里的哪些信息？（抖音）
- 设计电商客服 Agent：如何理解表达能力参差的用户的模糊需求？核心成功指标怎么定？（通义）
- 设计运维 / 故障排查 Agent：支付接口超时时它怎么跑完整套排查流程？高危操作如何管控？（字节跳动 / 唯品会）
- 设计多 Agent 文献调研系统：三个核心风险是什么，分别怎么应对？
- 请完整介绍一个 Agent 项目从需求到技术落地的全流程。（阿里云）
- 如何对比 GPT、Claude、Grok、Gemini、Manus 和 DeepSeek 的 Deep Research 功能？（抖音）
- 如何评价 Manus 当前推出的功能？（抖音）
- Manus、扣子空间等智能体产品有哪些体验问题，你会怎么改进？（抖音）
- 针对智能体 Plan 和 Report 阶段的不足，如何向研发提出可执行的需求？（抖音）

# Agent手撕代码

大模型岗的手撕分两类：一类是 Agent 特色的模型 / 工程手撕，一类是照常考的通用算法题，前者近一年权重明显上升。

- 脱离任何框架，手写一个 ReAct 模式的最小 Agent：工具注册、循环控制、终止条件、异常处理分别怎么实现？（2026 下半年新出现的高频手撕，应用岗尤其常考）

> ReAct 核心四要素:1、工具注册：字典维护工具名→函数、入参描述
2、循环控制：思考 (Thought) → 行动 (Action) → 观察 (Observation) 循环
3、终止条件：拿到最终答案标识 Finish，或者达到最大轮次
4、异常处理：工具不存在、参数错误、执行报错、超时捕获

```py
from typing import Callable, Dict, Any
import json

# ====================== 1.工具注册模块 ======================
class ToolRegistry:
    def __init__(self):
        self.tools: Dict[str, Dict[str, Any]] = {}

    def register(self, name: str, func: Callable, desc: str):
        self.tools[name] = {"fn": func, "desc": desc}

    def get_tool(self, name: str):
        return self.tools.get(name)

# 示例工具
def calculator(expr: str) -> str:
    return str(eval(expr))

def search(query: str) -> str:
    return f"搜索结果:{query}的相关资料"

registry = ToolRegistry()
registry.register("calculator", calculator, "数学计算，参数expr：表达式字符串")
registry.register("search", search, "联网搜索，参数query：搜索词")

# ====================== 2.ReAct Agent 主循环 ======================
class ReActAgent:
    def __init__(self, registry: ToolRegistry, max_step=5):
        self.registry = registry
        self.max_step = max_step
        self.history = []

    def llm_plan(self, prompt: str):
        """模拟大模型输出 Thought / Action / Finish"""
        if "计算" in prompt:
            return json.dumps({"thought":"需要调用计算器","action":"calculator","args":{"expr":"1+2*3"}})
        if "查资料" in prompt:
            return json.dumps({"thought":"调用搜索工具","action":"search","args":{"query":"人工智能发展"}})
        return json.dumps({"thought":"已有答案","action":"finish","args":{"ans":"任务结束"}})

    def run(self, user_query: str):
        step = 0
        while step < self.max_step:
            step += 1
            print(f"\n=====Step {step}=====")
            try:
                llm_out = self.llm_plan(user_query)
                data = json.loads(llm_out)
                thought = data["thought"]
                action_name = data["action"]
                args = data["args"]
                print(f"Thought:{thought}")

                # 终止条件
                if action_name == "finish":
                    return f"FinalAnswer: {args['ans']}"

                tool_item = self.registry.get_tool(action_name)
                if not tool_item:
                    obs = f"Error:工具 {action_name} 不存在"
                else:
                    fn = tool_item["fn"]
                    obs = fn(**args)
                print(f"Observation:{obs}")
                self.history.append({"step":step,"action":action_name,"obs":obs})
                user_query += f"\n观察:{obs}"

            except Exception as e:
                obs = f"Exception:{str(e)}"
                self.history.append({"step":step,"error":obs})
        return f"超过最大迭代轮次{self.max_step}，终止执行"

agent = ReActAgent(registry)
print(agent.run("帮我计算1+2*3"))
```

- 手写一个简易上下文压缩 / 滑动窗口摘要逻辑（给定消息列表和 token 上限，决定保留、摘要还是卸载）

> 规则：维护消息列表，给定 token 上限；策略：保留最近 N 条完整消息，更早的历史合并成一段摘要，超过阈值裁剪
策略区分：
总 token < limit：完整保留
轻微溢出：滑动窗口丢弃最早单条
大量超长：旧消息摘要压缩，最新交互完整保留（保证 LLM 感知最新意图）

```py
def count_token(text:str)->int:
    """模拟token计数"""
    return len(text)//3

def compress_messages(messages:list, token_limit:int):
    """
    messages: [{"role":"user","content":"xxx"},...]
    返回裁剪后的对话上下文
    """
    total = sum(count_token(m["content"]) for m in messages)
    if total <= token_limit:
        return messages.copy()
    # 保留最后2条原始对话，前面全部摘要压缩
    keep_recent = 2
    recent = messages[-keep_recent:]
    old_msgs = messages[:-keep_recent]
    summary_text = "【历史对话摘要】"+" | ".join([m["content"] for m in old_msgs])
    summary_msg = {"role":"system","content":summary_text}
    new_context = [summary_msg] + recent
    # 如果压缩后依然超限，递归丢弃更早摘要
    if sum(count_token(x["content"]) for x in new_context) > token_limit:
        return compress_messages(new_context, token_limit)
    return new_context
```

- Agent 如何完成一次完整的工具调用？从解析参数到执行、回传结果的链路要能手写出来。

> 1、 **上下文送入LLM**：prompt包含工具描述、对话历史，模型输出结构化工具调用JSON（工具名+入参）
2、 **输出解析层**：正则/json解析，校验字段合法性；捕获格式错误，生成纠错Observation回传给模型
3、 **参数校验**：检查必填参数、类型校验；缺失参数返回错误观察值，Agent重新思考补全参数
4、**路由分发**：工具注册表匹配函数，区分本地函数/HTTP API调用
5、**执行层**：捕获运行异常、超时控制；API调用增加重试
6、 **结果序列化**：把返回值转为字符串/JSON，包装成Observation
7、 **追加到对话历史**：将工具结果拼入上下文，开启下一轮ReAct循环
8、 **终止判断**：模型判断是否已经获得最终答案，输出结果结束循环

文字伪代码流程
```py
UserQuery → LLM(Thought + Action + Args)
→ Parser()
→ ValidateArgs()
→ DispatchTool()
→ RunTool() [try-catch/timeout]
→ BuildObservation()
→ AppendToHistory()
→ Loop or Finish
```

- 手写一个简单的多 Agent 消息路由器：按角色 / 能力把任务分发给对应子 Agent，并处理超时和失败重试。

> 能力匹配：关键词路由；工程版改用embedding相似度匹配
超时：Thread.join(timeout)
重试：while循环达到最大重试次数终止

```py
import threading, time
from dataclasses import dataclass

@dataclass
class SubAgent:
    name:str
    capability:list
    run_func:callable

class AgentRouter:
    def __init__(self,timeout=3,retry=2):
        self.agents = []
        self.timeout = timeout
        self.max_retry = retry

    def register_agent(self,agent:SubAgent):
        self.agents.append(agent)

    def match_agent(self,task:str):
        for a in self.agents:
            for skill in a.capability:
                if skill in task:
                    return a
        return None

    def exec_task(self, task:str):
        attempt = 0
        while attempt <= self.max_retry:
            attempt +=1
            target = self.match_agent(task)
            if not target:
                return {"status":"fail","msg":"无匹配子Agent"}
            res = {}
            def worker():
                try:
                    res["data"] = target.run_func(task)
                    res["ok"]=True
                except Exception as e:
                    res["ok"]=False
                    res["err"]=str(e)
            t = threading.Thread(target=worker)
            t.start()
            t.join(timeout=self.timeout)
            if t.is_alive():
                res = {"ok":False,"err":"timeout"}
            if res.get("ok"):
                return {"status":"success","agent":target.name,"result":res["data"]}
        return {"status":"fail","retry_exhaust","task":task}

# demo
def math_agent(task): return "计算完成"
def write_agent(task): return "文案生成完毕"

router = AgentRouter(timeout=2,retry=2)
router.register_agent(SubAgent("math_agent",["计算"],math_agent))
router.register_agent(SubAgent("writer",["写文案"],write_agent))

print(router.exec_task("帮我计算100!"))
```

- Java 动态代理有哪些实现方式？和 Agent 框架里的动态调度思路有什么可以类比的地方？

```py
111
```

- 手写一个死循环检测器：给定 Agent 的调用轨迹，判断是否陷入重复调用同一工具的死循环。

```py
212321321
```

- 反转链表 / 链表相加（双指针）/ 排序链表

```py
1231232112321321
```

- 二叉树层序遍历、接雨水、无重复字符的最长子串

```py
# 二叉树层序遍历 BFS
from collections import deque
class TreeNode:
    def __init__(self,val=0,left=None,right=None):
        self.val=val
        self.left=left
        self.right=right
def levelOrder(root):
    res = []
    if not root:return res
    q = deque([root])
    while q:
        level = []
        for _ in range(len(q)):
            node = q.popleft()
            level.append(node.val)
            if node.left:q.append(node.left)
            if node.right:q.append(node.right)
        res.append(level)
    return res

# 接雨水（双指针最优 O (n),O (1)）
def trap(height):
    l,r = 0,len(height)-1
    maxL,maxR = 0,0
    ans =0
    while l<r:
        if height[l]<height[r]:
            if height[l]>=maxL:
                maxL=height[l]
            else:
                ans+=maxL-height[l]
            l+=1
        else:
            if height[r]>=maxR:
                maxR=height[r]
            else:
                ans+=maxR-height[r]
            r-=1
    return ans
# 无重复字符的最长子串
def lengthOfLongestSubstring(s:str):
    win = set()
    l=0
    res=0
    for r in range(len(s)):
        while s[r] in win:
            win.remove(s[l])
            l+=1
        win.add(s[r])
        res = max(res,r-l+1)
    return res
```

[42. 接雨水 - 力扣（LeetCode）](https://leetcode.cn/problems/trapping-rain-water/description/)

- Top-K（快速选择 vs 堆，复杂度 / 并行化）、字符串解码 k[encoded]

Top‑K 对比

1. 快速选择（快排变形）

   - 时间复杂度：平均 O(n)，最坏 O(n2)；原地修改，空间O(1)
   - 适合单机内存数据；不适合超大并行场景

   

2. 小根堆

   - O(nlogk)；遍历全部元素，维护大小 k 的堆
   - 天然支持分布式并行，分片求局部 TopK 再合并，大数据场景首选

```py
# 字符串解码 k[xxx]（栈）
def decodeString(s: str) -> str:
    stack = []
    num = 0
    res = ""
    for c in s:
        if c.isdigit():
            num = num*10 + int(c)
        elif c == '[':
            stack.append((res,num))
            res = ""
            num = 0
        elif c == ']':
            pre_str, repeat = stack.pop()
            res = pre_str + res * repeat
        else:
            res += c
    return res
```


# 软性问题与职业发展

- 深挖简历里的 Agent 项目——落地逻辑、核心难点、指标怎么量化出来的、后续改进思路——**这是所有大厂面试的主线，占比最高！！！**

- 你自己搭过 Agent 吗？工作流是怎样的？能不能现场演示一下你负责的 Agent？（越来越常见的「当场验真」）
> 我独立基于 LangGraph/LangChain 搭建过任务型 Agent，完整工作流：1、用户输入 → 输入校验、过滤非法请求；2、Planner：LLM 输出结构化任务计划；3、Router 判断当前步骤是否需要调用工具；4、如果需要：参数校验 → 调用自定义 Skill/API；5、获取返回结果，送入 Reflection 节点校验结果是否满足子目标；、校验通过：进入下一个子任务；校验失败：重试、调整参数，最多 N 次重试上限；6、全部子任务完成后，聚合全部结果生成最终回答。本地可以启动 Demo，输入自然语言指令，观察：任务拆分日志、工具调用参数、反思重试过程；生产版本封装成 API，支持批量任务统计成功率指标。如果面试环境不方便跑代码，可以展示执行日志截图、状态流转图。

- 平时用哪些 AI 编程工具（Claude Code / Cursor / Codex / 通义灵码）？怎么用的？（高频闲聊切入）
> 工具清单：Codex、Cursor、Claude Code、通义灵码，偶尔 GitHub Copilot。1、先写清晰需求与约束；2、让 AI 输出方案与修改范围；3、小批量修改，逐文件 Review；4、写完立刻补充单元测试验证。

- 你在 AI 编程工具里装了哪些 Skill、写过哪些复杂 Skill？效果怎么验证的？（快手）
> Skill 本质就是给 Agent 封装好的可调用能力 + 约束描述。1、格式验证：输出必须符合 JSON Schema，参数合法；2、用例验证：准备一批标准测试 case，自动化运行，看输出是否符合预期；3、人工评估 + 线上灰度统计成功率，持续迭代 Skill 描述与示例。

- AI Coding 流程里如何避免大模型随意发挥、改坏历史功能？（阿里巴巴）
> 四层防护策略：1、范围约束：prompt 严格限定修改文件范围，禁止修改无关代码；2、增量修改策略：不允许全量重写整个文件，优先局部修改；3、自动化防护：修改后自动跑单元测试、CI 流水线，回归原有功能；4、人工 Code Review，同时开启 Git 版本快照，一旦出问题可以一键回滚；5、使用 Agent 的 Plan 模式：先输出变更方案，人确认之后再执行修改动作。

- AI 编程中的 Plan 模式和 Agent 模式有什么区别？（小红书）
> 1、Plan 模式（规划优先）先一次性生成完整的修改方案、文件列表、改动点，先审批再执行。人可以审核计划是否合理，风险可控；适合大型重构、高风险代码变更。不会无限制多轮调用模型。2、Agent 模式（自主迭代执行）模型边执行边观察结果，遇到错误自动调试、重试、多轮交互；自主闭环，无需人工一步步确认；适合调试、小问题排错，但风险更高，容易越权修改代码。一句话总结：Plan 控风险，Agent 擅长自主排错调试；生产级工程优先 Plan + 人工确认，调试场景用 Agent。

- 怎么看待从提示词工程到 Skill 这类概念的快速迭代？用框架和直接调大模型的差异在哪？（字节跳动）
> 1）从提示词到 Skill 的迭代意义：单纯写 Prompt 是一次性的、不可复用的；Skill 把能力描述、入参约束、示例、执行逻辑封装成标准化组件：可复用、可版本管理、独立评测、独立迭代，从一次性 prompt 变成工程化资产。
2）原生调用大模型 vs 使用 Agent 框架（LangGraph 等）1、直接裸调用 API：灵活轻量，适合简单单轮任务；但多轮记忆、状态流转、重试、校验全部要自己手写，工程成本极高，不可维护；2、Agent 框架：提供状态管理、工作流编排、持久化记忆、回调观测、可视化调试能力，把通用工程问题封装好；缺点是带来额外学习成本，复杂场景会被框架限制。
最佳实践：简单场景直接调用 API；多轮复杂任务、需要稳定迭代的业务 Agent 使用成熟框架。


- To C 和 To B 的 AI Agent 哪个会先爆发？未来 AI Agent 会是什么形态？（腾讯）
> 短期（1‑2 年）To B(Business) 会率先落地变现：企业愿意付费解决确定性工作流（数据分析、工单处理、代码开发、运维自动化），价值明确、ROI 可衡量；企业可以私有化部署，解决数据安全问题。
长期成熟之后 To C 迎来爆发:C 端用户对可靠性容忍度更低，幻觉问题一旦出现体验崩盘；而且 C 端付费意愿弱，商业化周期更长。
未来 Agent 形态：不是一个万能超级 Agent，而是大量垂直轻量化专用 Agent，互相调用协作；用户感知上是自然对话，底层是一套 Agent 服务编排平台。

- 你如何甄别 AI 输出的思路和内容是否准确，避免被幻觉带偏？（OPPO）
> 四层校验手段：1、事实溯源：要求 AI 给出引用来源、参考文档；2、结构化校验：JSON Schema、正则校验输出格式；3、工具交叉验证：重要结论调用外部接口 / 代码执行验算；4、反思自我校验：第二轮 Prompt 让模型自查结论是否存在矛盾；5、人工抽查 + 自动化评测数据集长期监控准确率。

- 你认为 Agent 的商业化成本是在上升还是下降？（拼多多）
> 长期趋势成本持续下降，短期落地成本很高
短期：Agent 是多轮调用 + 工具调度，Token 消耗高，整体单请求成本高于普通对话；工程开发、评估运维人力成本也很高；
长期：模型越来越廉价，小模型轻量化推理、路由策略（简单任务交给廉价小模型）、缓存复用结果；随着规模上涨边际成本持续压低。
商业化成功的关键：通过工程优化降低平均轮次，把单任务成本压到低于人工成本，才有商业价值。


- 平时关注哪些 AI Agent 相关的前沿技术？最近看过哪些相关论文或产品？
> 产品方向：Claude Code、Cursor Agent、Devin、OpenAI Agent SDK；LangGraph、AutoGen 多智能体协作框架；
论文 / 技术方向：结构化规划：Tree‑of‑Thought，Reflexion（反思 Self‑Reflection）；、多智能体协作：Multi‑Agent Debate；Agent 评估：自动评测数据集，自动化 Reward 反馈；轻量化 Agent：小模型 Agent，降低推理成本；Agent 记忆机制：短期上下文记忆 + 向量长期记忆。

# 备考重点

**大模型应用 / Agent 工程岗**（快手 / 腾讯 / 京东 / 网易 AI 应用开发）——重点在工具调用（Function Calling、MCP、Skills）、记忆与上下文工程、多智能体协作三块，几乎每题都会追一句「你们项目里具体怎么做的」，框架层面 LangGraph 和 Spring AI 都要能聊。

**2026 下半年新增的三个重灾区**：Agent Harness 与运行时工程（怎么设计、和 MCP / Skills 的边界在哪）、评估与安全兜底（Agent Loop 状态怎么暂停恢复、越权调用怎么监控、幻觉链式传播怎么截断）、多智能体编排（去中心化调度、子任务失败可回退、跨 Agent 隔离）。这三块几乎每轮都会问到，而且都要求结合项目讲出具体做法。

**面试官越来越爱追问「怎么量化」**：幻觉率怎么定义、记忆有没有指标、Agent 效果提升的百分比用哪个测试集算出来的。简历上写的每个数字都要能讲清楚是怎么算出来的——只报结论不报口径，基本会被一路追到底。




# 常见问题
这份题单是怎么整理出来的？
> 来源是互联网，我所看到的各位大佬面试的经验贴，把 AI Agent 相关的提问单独抽出来重新归类，手动整理。

AI Agent 面试和大模型算法岗面试差别大吗？
> 差别很大。大模型算法岗重心在模型结构、训练和强化学习对齐，Agent 岗几乎不问 RLHF 推导，但工具调用、Harness、记忆与上下文工程、多智能体协作会问得非常细，还会要求现场演示或深挖你做过的 Agent 项目。如果两条线都要准备，可以搭配大模型面试题合集一起看。

只背这些题能过面试吗？
> 不能。这份题单解决的是「准备方向不跑偏」的问题——它告诉你面试官现在在问什么、往哪个方向追。但 Agent 面试有大量时间在挖你的项目细节和现场设计能力，几乎每道概念题后面都跟着一句「你们具体怎么做的、效果怎么量化的」。建议按题单排查知识盲区，同时准备一个能讲清楚设计取舍的真实案例。


# 参考链接

[2026最全大模型面经汇总｜Agent面试题、RAG面试题、Transformer面试题合集（含答案解析） | 代码随想录-全网最全算法数据结构刷题学习路线|图文+视频教程|免费开源](https://programmercarl.com/qita/0022.llminterview.html)

[github.com/bcefghj/ai-agent-interview-guide](https://github.com/bcefghj/ai-agent-interview-guide)

[2026最全AI大模型面试题 | Agent面试题 | AI应用开发面试题 | 小林coding](https://xiaolincoding.com/project/xiaolinnote.html)

[AI Agent 面试题与八股文汇总：155 道大厂真题按主题拆解（2026 面经） - 面灵AI](https://www.mianlingai.com/topics/ai-agent-interview-questions-2026/)

[Agent开发八股合集真实面经总结版_牛客网](https://www.nowcoder.com/feed/main/detail/76b321bffc5e460fb316813352d8d950)