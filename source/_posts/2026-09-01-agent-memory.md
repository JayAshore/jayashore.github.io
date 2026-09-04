---
title: Agent 记忆不是聊天记录：从状态管理开始设计
date: 2026-09-01 09:00:00
categories:
  - Agent
tags:
  - Agent
  - 记忆
  - 工程实践
description: 讨论 Agent 短期上下文、长期记忆和状态压缩之间的边界。
---

Agent 的“记忆”不应该简单等同于把所有历史消息都塞回 prompt。上下文越长，成本越高，噪声也越多。更实用的设计是把状态拆成短期上下文、任务状态和长期记忆三层。

## 三层状态

- **短期上下文**：当前任务最近几轮对话和工具结果，用来保持局部连贯性。
- **任务状态**：目标、已完成步骤、待处理事项和失败原因，用结构化数据保存。
- **长期记忆**：经过筛选的用户偏好、稳定事实和历史经验，不应自动保存所有内容。

```python
from dataclasses import dataclass, field
from typing import Any


@dataclass
class TaskState:
    goal: str
    completed: list[str] = field(default_factory=list)
    pending: list[str] = field(default_factory=list)
    facts: dict[str, Any] = field(default_factory=dict)

    def summary(self) -> str:
        return "\n".join([
            f"目标：{self.goal}",
            f"已完成：{', '.join(self.completed) or '无'}",
            f"待处理：{', '.join(self.pending) or '无'}",
        ])
```

## 什么时候应该写入长期记忆

可以用三个问题做过滤：这条信息是否稳定、未来是否有用、用户是否期望系统记住它？如果答案不明确，就只保留在当前任务状态里。记忆系统还应该支持查看、修改和删除，不能让用户面对一个无法解释的黑盒。

一个好的记忆系统不是让 Agent 永远记得更多，而是让它在正确的时机取回正确的信息。检索结果也要带来源和时间，避免把过期事实当成当前事实。
