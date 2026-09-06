---
title: AcWing 1574. 接雨水
date: 2026-09-06 13:36:25
updated: 2026-09-06 13:36:25
categories:
  - 算法
tags:
  - 二分
  - 排序
description: Acwing算法基础课！
keywords:
stick:
permalink: 
---


### 题目描述
给定 $n$ 个非负整数表示每个宽度为 $1$ 的柱子的高度图，计算按此排列的柱子，下雨之后能接多少雨水。

例如，当给定数字序列为 `0,1,0,2,1,0,1,3,2,1,2,1` 时，柱子高度图如下所示，最多可以接 $6$ 个单位的雨水。

![rainwatertrap.png](https://cdn.jsdelivr.net/gh/JayAShore/blog-images@main/images/rainwatertrap.png)

#### 输入格式

第一行包含整数 $n$。

第二行包含 $n$ 个非负整数。

#### 输出格式

输出一个整数，表示最大接水量。

#### 数据范围

$1 \le n \le 10^5$,  
序列中元素均不大于 $1000$。

#### 输入样例：

```
12
0 1 0 2 1 0 1 3 2 1 2 1
```

#### 输出样例：

```
6
```

---
### 解法1(暴力枚举)  
#### 时间复杂度

$O(n)$

#### 空间复杂度

$O(n)$

#### Python代码
```
def trap(height):
	if not height:
		return 0
	n = len(height)
	lef_max = [0] * n
	right_max = [0] * n
	
	left_max[0] = height[0]
	for i in range(1,n):
		left_max[i] = max(left_max[i - 1], height[i])
	
	right_max[n - 1] = height[n - 1]
	
	for i in range(n - 2, -1, -1):
		right_max[i] = max(right_max[i + 1], height[i])
	
	water = 0
	for i in range(n):
		water += min(left_max[i], right_max[i]) - height[i]
	reutrn water
```





位置i能装的水，取决于它两边最高的墙，其中更矮的那边的高度。

所以问题就变成了，对于每个位置i，怎么能不浪费的计算两边分别最高的墙。





###  视频讲解

[力扣 42 接雨水 1 ｜ 最优解双指针 时间O(n) 空间O(1)_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV18mWfzZE4D/?spm_id_from=333.337.search-card.all.click&vd_source=1265e04aa69e7d92894b3513298d5a88)

[马老师教学字节面试经典算法题《接雨水》，做完当场笑得翻皮水_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Hc3p6cEGL/?spm_id_from=333.337.search-card.all.click&vd_source=1265e04aa69e7d92894b3513298d5a88)

[接雨水问题 | LeetCode 42_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1R8zkBgEKG?spm_id_from=333.788.videopod.sections&vd_source=1265e04aa69e7d92894b3513298d5a88)

