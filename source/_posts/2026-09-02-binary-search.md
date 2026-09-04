---
title: 二分查找的关键：每次缩小的到底是什么
date: 2026-09-02 14:30:00
categories:
  - 算法
tags:
  - 算法
  - 二分查找
  - Python
description: 用左闭右闭区间实现二分查找，并总结边界条件的推导方法。
---

二分查找并不只适用于“在有序数组中找一个数”。只要答案空间具有单调性，就可以不断排除一半候选。真正容易出错的部分是区间定义和循环不变量。

## 左闭右闭区间

下面的版本维护 `[left, right]`，因此循环条件是 `left <= right`。当中间值不是答案时，`mid` 已经被排除，边界必须跳过它。

```python
def binary_search(nums: list[int], target: int) -> int:
    left, right = 0, len(nums) - 1

    while left <= right:
        mid = left + (right - left) // 2
        if nums[mid] == target:
            return mid
        if nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1

    return -1


assert binary_search([1, 3, 5, 7, 9], 7) == 3
assert binary_search([1, 3, 5, 7, 9], 4) == -1
```

## 从查找变成判定

很多题目并没有直接要求返回数组中的元素，而是问“最小的最大值是多少”。这时可以写一个 `check(answer)`，判断给定答案是否可行，再对答案空间做二分。只要 `check` 的结果具有 `False...False, True...True` 或相反的单调结构，二分就能工作。

写代码前先明确三件事：区间是否包含右端点、循环结束时答案落在哪里、每次更新是否真的排除了 `mid`。把这三个问题写成注释，通常比记模板更可靠。
