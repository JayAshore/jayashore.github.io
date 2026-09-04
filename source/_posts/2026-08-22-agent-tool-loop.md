---
title: Agent 工程入门：从工具调用到可观测闭环
date: 2026-08-22 10:00:00
categories:
  - Agent
tags:
  - LLM
  - Agent
  - 工具调用
  - 可观测性
description: 一个实用的 Agent 不只是会聊天，还需要明确的工具协议、停止条件和可追踪的执行轨迹。
---

很多 Agent demo 的核心其实只有一个循环：让模型决定下一步，执行工具，把结果放回上下文，再让模型继续决定。真正困难的地方不在循环本身，而在于给它加上可靠的边界。

## 一个最小闭环

可以把一次 Agent 运行抽象成下面的状态流：

```text
用户目标 -> 模型决策 -> 工具执行 -> 结果校验
              ^                         |
              |------ 继续 / 结束 <-----|
```

工具必须拥有稳定的输入输出协议。模型可以决定调用哪个工具，但不应该决定工具的安全策略，例如超时、重试次数和权限范围。

```python
from dataclasses import dataclass
from typing import Any, Callable


@dataclass
class Tool:
    name: str
    description: str
    run: Callable[[dict[str, Any]], dict[str, Any]]


def run_agent(model, tools: dict[str, Tool], goal: str, max_steps: int = 8):
    messages = [{"role": "user", "content": goal}]
    trace = []

    for step in range(max_steps):
        decision = model.decide(messages, [
            {"name": tool.name, "description": tool.description}
            for tool in tools.values()
        ])
        trace.append({"step": step, "decision": decision})

        if decision["type"] == "final":
            return {"answer": decision["content"], "trace": trace}

        if decision["type"] != "tool_call":
            raise ValueError(f"unknown decision: {decision['type']}")

        tool = tools.get(decision["name"])
        if tool is None:
            messages.append({"role": "tool", "content": "tool_not_found"})
            continue

        try:
            result = tool.run(decision.get("arguments", {}))
        except Exception as error:
            result = {"ok": False, "error": str(error)}

        messages.append({
            "role": "assistant",
            "content": decision,
        })
        messages.append({
            "role": "tool",
            "name": tool.name,
            "content": result,
        })

    raise RuntimeError("agent stopped: maximum steps exceeded")
```

## 三个不能省略的护栏

**停止条件**：除了模型主动返回最终答案，还应该设置最大步数、单次调用超时和总预算。没有上限的 Agent 本质上是一个不可控的递归任务。

**输入校验**：工具参数要经过 schema 校验，尤其是文件写入、网络请求和数据库操作。模型输出永远应该被当作不可信输入。

**执行轨迹**：至少记录 `run_id`、步骤号、工具名、耗时、输入摘要、输出摘要和错误类型。完整记录提示词时，要先脱敏密钥和个人信息。

## Agent 的评估方式

不要只看最终回答像不像人。更有用的指标包括：任务成功率、工具调用准确率、平均步骤数、失败恢复率和单位任务成本。每次改 prompt 或工具描述，都用一组固定任务回归测试，才能知道变化究竟是变聪明了，还是只是碰巧答对。
