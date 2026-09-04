---
title: 算法笔记：滑动窗口如何把平方复杂度降到线性
date: 2026-08-24 15:20:00
categories:
  - 算法
tags:
  - 算法
  - 双指针
  - Python
description: 以“无重复字符的最长子串”为例，理解滑动窗口的维护不变量和复杂度。
---

滑动窗口适合处理连续区间问题。它的关键不是“两个指针”，而是维护一个不变量：窗口始终满足题目要求。每次右指针扩大窗口；如果不变量被破坏，就移动左指针直到恢复。

## 问题

给定字符串 `s`，返回不含重复字符的最长子串长度。例如 `abcabcbb` 的答案是 `3`，因为最长窗口是 `abc`。

暴力方法枚举所有区间并检查重复字符，复杂度是 `O(n²)`。滑动窗口让每个字符最多被左右指针各访问一次。

```python
def longest_unique_substring(s: str) -> int:
    """Return the length of the longest substring without repeated chars."""
    left = 0
    answer = 0
    last_seen: dict[str, int] = {}

    for right, char in enumerate(s):
        # If char is inside the current window, jump left directly.
        if char in last_seen and last_seen[char] >= left:
            left = last_seen[char] + 1

        last_seen[char] = right
        answer = max(answer, right - left + 1)

    return answer


assert longest_unique_substring('abcabcbb') == 3
assert longest_unique_substring('bbbbb') == 1
assert longest_unique_substring('') == 0
```

## 不变量与复杂度

在处理完第 `right` 个字符后，`s[left:right + 1]` 一定没有重复字符。`last_seen` 保存字符最近一次出现的位置，因此左指针可以直接跳跃，不需要逐格回退。

- 时间复杂度：`O(n)`，每个字符最多更新一次。
- 空间复杂度：`O(min(n, 字符集大小))`。

遇到类似题目时，可以先问自己：“窗口需要维护什么信息？”如果是计数，就用哈希表；如果是单调最值，通常可以考虑单调队列；如果窗口条件只能扩大不能恢复，就要重新检查方法是否适用。
