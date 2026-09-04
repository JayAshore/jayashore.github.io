---
title: 用 TypeScript 写一个可测试的任务队列
date: 2026-08-20 09:30:00
updated: 2026-08-21 14:10:00
categories:
  - 工程实践
tags:
  - TypeScript
  - 代码
  - 测试
description: 从最小接口开始实现一个带并发控制、失败重试和测试边界的任务队列。
---

任务队列最容易写成“能跑就行”的循环，但一旦加入并发、失败重试和取消逻辑，隐含状态会迅速变多。一个更稳妥的做法是先把队列的职责限制在三件事：接收任务、控制并发、报告结果。

## 先定义边界

下面的实现有三个约束：

1. `concurrency` 控制同时运行的任务数。
2. 每个任务失败后最多重试 `retries` 次。
3. `onSettled` 只负责通知，不改变队列状态。

```ts
type Task<T> = () => Promise<T>;

interface QueueOptions {
  concurrency: number;
  retries?: number;
}

interface TaskResult<T> {
  ok: boolean;
  value?: T;
  error?: unknown;
  attempts: number;
}

export class TaskQueue {
  private readonly pending: Array<{
    task: Task<unknown>;
    resolve: (result: TaskResult<unknown>) => void;
  }> = [];

  private running = 0;
  private readonly concurrency: number;
  private readonly retries: number;

  constructor(options: QueueOptions) {
    if (!Number.isInteger(options.concurrency) || options.concurrency < 1) {
      throw new Error('concurrency must be a positive integer');
    }

    this.concurrency = options.concurrency;
    this.retries = Math.max(0, options.retries ?? 0);
  }

  add<T>(task: Task<T>): Promise<TaskResult<T>> {
    return new Promise((resolve) => {
      this.pending.push({
        task: task as Task<unknown>,
        resolve: resolve as (result: TaskResult<unknown>) => void,
      });
      this.pump();
    });
  }

  private pump(): void {
    while (this.running < this.concurrency && this.pending.length > 0) {
      const item = this.pending.shift()!;
      this.running += 1;
      void this.run(item).finally(() => {
        this.running -= 1;
        this.pump();
      });
    }
  }

  private async run(item: {
    task: Task<unknown>;
    resolve: (result: TaskResult<unknown>) => void;
  }): Promise<void> {
    let attempts = 0;

    while (attempts <= this.retries) {
      attempts += 1;
      try {
        const value = await item.task();
        item.resolve({ ok: true, value, attempts });
        return;
      } catch (error) {
        if (attempts > this.retries) {
          item.resolve({ ok: false, error, attempts });
        }
      }
    }
  }
}
```

## 测试比实现更早暴露问题

最值得测试的是边界，而不是私有字段：并发是否生效、失败是否按预期重试、最终结果是否可观察。

```ts
it('retries a failed task and returns the attempt count', async () => {
  const queue = new TaskQueue({ concurrency: 2, retries: 2 });
  let calls = 0;

  const result = await queue.add(async () => {
    calls += 1;
    if (calls < 3) throw new Error('temporary failure');
    return 'done';
  });

  expect(result).toEqual({ ok: true, value: 'done', attempts: 3 });
});
```

这个版本没有加入延迟、优先级和持久化，故意保留了扩展空间。先把状态机压缩到可解释的范围，后续再增加能力，维护成本会低很多。
