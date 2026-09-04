---
title: 图算法实践：用 Dijkstra 找到带权图中的最短路
date: 2026-08-26 11:45:00
categories:
  - 算法
tags:
  - 图算法
  - Dijkstra
  - TypeScript
description: 从邻接表和优先队列开始，实现一个适用于非负权图的最短路算法。
---

Dijkstra 的核心是贪心选择：每次从“当前已知距离最小”的节点出发，用它尝试松弛相邻边。只要边权非负，已经取出的最小距离就不会再被更短路径改写。

## 实现

```ts
type Edge = { to: string; weight: number };
type Graph = Record<string, Edge[]>;

class MinHeap {
  private data: Array<[number, string]> = [];

  push(item: [number, string]) {
    this.data.push(item);
    this.up(this.data.length - 1);
  }

  pop(): [number, string] | undefined {
    if (this.data.length === 0) return undefined;
    const first = this.data[0];
    const last = this.data.pop()!;
    if (this.data.length > 0) {
      this.data[0] = last;
      this.down(0);
    }
    return first;
  }

  private up(index: number) {
    while (index > 0) {
      const parent = Math.floor((index - 1) / 2);
      if (this.data[parent][0] <= this.data[index][0]) break;
      [this.data[parent], this.data[index]] = [this.data[index], this.data[parent]];
      index = parent;
    }
  }

  private down(index: number) {
    while (true) {
      const left = index * 2 + 1;
      const right = left + 1;
      let smallest = index;
      if (left < this.data.length && this.data[left][0] < this.data[smallest][0]) {
        smallest = left;
      }
      if (right < this.data.length && this.data[right][0] < this.data[smallest][0]) {
        smallest = right;
      }
      if (smallest === index) break;
      [this.data[index], this.data[smallest]] = [this.data[smallest], this.data[index]];
      index = smallest;
    }
  }
}

function shortestPaths(graph: Graph, start: string): Record<string, number> {
  const distance: Record<string, number> = {};
  for (const node of Object.keys(graph)) distance[node] = Infinity;
  distance[start] = 0;

  const heap = new MinHeap();
  heap.push([0, start]);

  while (true) {
    const current = heap.pop();
    if (!current) break;
    const [knownDistance, node] = current;
    if (knownDistance !== distance[node]) continue; // stale heap entry

    for (const edge of graph[node] ?? []) {
      const candidate = knownDistance + edge.weight;
      if (candidate < (distance[edge.to] ?? Infinity)) {
        distance[edge.to] = candidate;
        heap.push([candidate, edge.to]);
      }
    }
  }

  return distance;
}
```

使用二叉堆时，时间复杂度为 `O((V + E) log V)`，空间复杂度为 `O(V + E)`。如果图中可能出现负权边，Dijkstra 就不再适用，应考虑 Bellman-Ford；如果所有边权都相同，BFS 更简单。

## 一个工程化提醒

算法实现里最容易被忽略的是“过期堆元素”。同一个节点可能被多次松弛并推入堆，弹出时如果距离不是当前最优值，就应该跳过。这个判断既避免重复计算，也让实现不必额外实现 decrease-key 操作。
