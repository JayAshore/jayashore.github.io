---
title: LeetCode 5. 最长回文子串
date: 2026-09-06 15:38:57
updated: 2026-09-06 15:38:57
categories:
  - 算法
tags:
  - 字符串
  - 双指针
  - 动态规划
  - 枚举
  - Manacher 算法
description: 
keywords:
permalink: 
cover: https://cdn.jsdelivr.net/gh/JayAShore/blog-images@main/images/d3bafbf1-ae80-4e40-90cb-6a9c1e9d3f19.png
sticky: 
---

## [LeetCode 5. 最长回文子串](https://www.acwing.com/activity/content/problem/content/2330/)

## Thinking

回文分两种情况：
1. 奇数长度：中心点是一个字符，例如 aba，中心是 b
2. 偶数长度：中心点是两个相邻字符中间，例如 abba，中心在两个 b 之间

> 暴力枚举每一个可能的中心，不断向外扩散，记录最长的那一段回文字符串。AcWing 139. 进阶



奇数长度：L初始化成i - 1、R初始化成i + 1、[L + 1, R - 1] 是以i为中心的回文串。

R - 1 - (L + 1) + 1 = R-L-1

偶数长度：L初始化成i、R初始化成i + 1


## 解法一（暴力）




## 解法二（双指针）

C++代码
```c++
class Solution {
public:
    string longestPalindrome(string s) {
        string res;  // res 用来保存当前找到的最长回文子串
        for (int i = 0; i < s.size(); i ++ ){  // 遍历每一个位置 i，作为回文的中心点
            int l = i - 1, r = i + 1; // 当字符串的长度是奇数的时候 左右指针从左右的位置出发
            while (l >=0 && r < s.size() && s[l] ==s[r]) l --, r ++;  // 向左右扩散：左右边界合法，并且两个字符相等就继续往外走
            if (res.size() < r - l - 1) res = s.substr(l + 1, r - l - 1); // s.substr(pos, len)：从下标 l+1 开始，截取长度为 r‑l‑1 的子串

            l = i, r = i + 1;
            while (l >=0 && r < s.size() && s[l] == s[r]) l --, r ++;
            if (res.size() < r - l - 1) res = s.substr(l + 1, r - l - 1);
        }
        return res;
    }
};
```

Python代码
```py
class Solution:
    def longestPalindrome(self, s: str) -> str:
        res = ""
        for i in range(len(s)):
            # 奇数情况
            L, R = i - 1, i + 1
            while L >= 0 and R < len(s) and s[L] == s[R]:
                L -= 1
                R += 1
            if len(res) < R - L - 1:
                res = s[L + 1: R] # （切片是左闭右开区间）
            # 偶数的情况
            L, R = i, i + 1
            while L >= 0 and R < len(s) and s[L] == s[R]:
                L -= 1
                R += 1
            if len(res) < R - L - 1:
                res = s[L + 1: R]
        return res
```

时间 & 空间复杂度
- 时间复杂度：$O(n^2)$，n 是字符串长度。一共 $2n$ 个中心，每个中心最多向外扩散 $O(n)$ 步
- 空间复杂度：$O(1)$（除了保存答案的字符串）



## 解法三（Manacher）

设原字符串长度为 $n$
每一个原字符后面追加一个 `#`，开头再加一个 `#`(这个就是+1的来源)
新串总长度公式：
$$
len(t) = 1 + 2\times n
$$
- $2n$ 永远是偶数
- $1 + \text{偶数} = \boldsymbol{奇数}$

不管原来 $n$ 是奇数还是偶数：
$$
\begin{align*}
n=3 \quad&\Rightarrow 1+2\times3=7 \quad(\text{奇数})\\
n=2 \quad&\Rightarrow 1+2\times2=5 \quad(\text{奇数})\\
n=1 \quad&\Rightarrow 1+2\times1=3 \quad(\text{奇数})
\end{align*}
$$
✅ **预处理之后整个字符串 $t$ 的长度永远是奇数**

```py
class Solution:
    def longestPalindrome(self, s: str) -> str:
    # 1. 预处理字符串，插入 #，统一奇偶
        t = '#'
        for ch in s:
            t += ch + '#'
        n = len(t)
        p = [0] * n  # p数组：每个位置的回文半径
        center = right = 0  # 当前最右回文的中心、右边界
        max_len = 0
        max_center = 0

        for i in range(n):
            # 利用镜像点加速，如果i在右边界内，先给一个初始半径
            mirror = 2 * center - i
            if i < right:
                p[i] = min(right - i, p[mirror])
            
            # 中心扩散，尝试向外扩展
            while i + p[i] + 1 < n and i - (p[i] + 1) >= 0 and t[i + p[i] + 1] == t[i - (p[i] + 1)]:
                p[i] += 1
            
            # 如果当前回文突破了right，更新边界和中心
            if i + p[i] > right:
                center = i
                right = i + p[i]
            
            # 更新全局最长
            if p[i] > max_len:
                max_len = p[i]
                max_center = i
        
        # 映射回原始字符串
        start = (max_center - max_len) // 2
        return s[start: start + max_len]
```