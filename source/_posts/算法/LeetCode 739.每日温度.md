
---
title: LeetCode 739.每日温度
date: 2026-09-06 21:25:43
updated: 2026-09-06 21:25:43
categories:
  - 算法
tags:
  - 单调栈
  - 数组

description: 
keywords:
permalink: 
sticky:
---

## [LeetCode 739.每日温度](https://www.acwing.com/activity/content/problem/content/3329/)

## Thinking
输入：一个整数数组 `temperatures`，代表每一天的气温。
输出：等长数组 `answer`。
规则：
`answer[i]` = 在第 `i` 天之后，**第一个温度比它更高的那天，和第i天相差的天数**；
如果后面再也没有温度更高的一天 → `answer[i] = 0`。
例子：`[73,74,75,71,69,72,76,73]`
i=0(73)，下一个更高是74，间隔1天 → ans[0]=1
i=2(75)，后面直到76才更高，间隔4天 → ans[2]=4
i=6(76)，后面没有更高 → ans[6]=0

核心问题：**对每一个位置i，找右边第一个更大值的下标，求下标差**。

---

### 思路1：最直观暴力解法（人脑第一反应）
1. 遍历每一天 `i`（作为基准天）
2. 从它后一天 `j=i+1` 开始往后挨个检查
3. 一旦发现 `temperatures[j] > temperatures[i]`：
    - 记录间隔天数 `j‑i`
    - 不用继续往后找了，`break`
4. 如果循环跑完都没找到更大的值 → 结果保持0
5. 把所有结果存入结果数组返回

复杂度分析
两层循环，最坏情况严格递减数组：每一个i都要扫描到末尾
时间：$O(n^2)$
空间：$O(n)$（只存答案）

> 问题：数组很长（上万个数据）时，双重循环太慢，会超时。我们需要更快的算法。

---

### 思路2：思考暴力哪里做了重复工作
举个例子：`75,71,69,72`
- i=0（75）：向后看 71、69、72，都小于75，全部遍历一遍
- i=1（71）：向后看 69，再看到72
- i=2（69）：直接看到72

可以发现：**后面已经扫描对比过的数字，前面又重新扫描了一遍，大量重复比较！**
我们希望每个元素**只被访问一次**，时间做到 $O(n)$。

问题转化：如何保存已经遍历过的信息，避免重复回看？
👉 使用**单调栈**，栈用来保存还没有找到“更高温度”的下标。

---

### 思路3：单调栈优化思路（一步步推导）
栈的定义
栈里面**不放温度数值，存放数组下标**；
并且保证：栈中下标对应的温度，**从栈底到栈顶是递减的（单调递减栈 栈顶下标对应的温度，是当前栈里面最小的温度）**。 

遍历规则（从左往右遍历每一天i）
1. 当前遍历到第 `i` 天，温度是 `temperatures[i]`
2. 判断：如果当前温度 **大于栈顶下标对应的温度**
   - 说明：**栈顶那一天找到了第一个更高的温度！**
   - 弹出栈顶下标 `top_idx`
   - 答案 `res[top_idx] = i - top_idx`
   - 继续拿新的栈顶对比（可能多个旧日期都满足条件）
3. 如果当前温度 ≤ 栈顶温度，停止弹出，把当前下标i压入栈中
4. 循环走完，栈里剩下的下标，后面没有更高温度，答案保持初始值0

模拟一小段流程
数组：`[73,74,75]`
- i=0，栈空 → push 0，栈：[0]
- i=1，温度74 > temperatures[0]=73
    pop 0 → res[0]=1‑0=1；栈空，push1，栈：[1]
- i=2，温度75 > temperatures[1]=74
    pop1 → res[1]=2‑1=1；栈空，push2，栈：[2]
遍历结束，res[2]=0
最终结果：`[1,1,0]`

复杂度证明
每个下标**只会入栈一次、出栈一次**，总操作次数 $2n$
时间复杂度：$O(n)$
空间复杂度：$O(n)$（最坏严格递减，全部压入栈）

---

### 完整思考链路总结（做题时脑子里的流程）
1. 审题：右边第一个更大元素，求下标差，找不到填0
2. 朴素想法：双重循环暴力搜索，写出暴力代码，理解逻辑正确性
3. 发现缺点：大数据超时，存在大量重复比对
4. 寻找优化：希望每个元素只遍历一次 → 想到单调栈（**下一个更大元素经典模板题**）
5. 确定栈存储内容：存下标而不是数值，方便计算天数差
6. 确定栈单调性：维护**单调递减栈**
7. 写逻辑：只要当前值更大，不断更新栈顶答案；最后压入当前下标
8. 边界检查：最后剩余栈内元素自动保持0，不用额外处理
9. 对比两种代码：暴力适合理解，单调栈是面试最优解

---

面试简短话术（可以直接背）
> 这道题本质是求每个元素右侧第一个更大值的位置。首先可以用双重循环暴力求解，但是时间复杂度是 $O(n^2)$，大数据会超时。所以我们用单调递减栈优化，栈保存未找到更高温度的日期下标，遍历每一天，如果当前温度高于栈顶，就更新栈顶的等待天数，每个元素入栈出栈各一次，整体时间复杂度优化到 $O(n)$。

如果你需要，我可以给你**完整逐步骤表格模拟整个栈变化全过程**。






## 解法一（暴力法 时间复杂度 $O(n^2)$）

C++写法（超出时间限制47/48个通过的测试用例）
```c++
#include <vector>
using namespace std;

class Solution {
public:
    vector<int> dailyTemperatures(vector<int>& temperatures) {
        int n = temperatures.size();
        vector<int> res(n, 0); // 初始全部置0 Verctor的初始化方法  vector<int> res(temperatures.size());
        for(int i = 0; i < n; i++){
            for(int j = i + 1; j < n; j++){
                if(temperatures[j] > temperatures[i]){
                    res[i] = j - i;
                    break;
                }
            }
        }
        return res;
    }
};
```

Python写法（超出时间限制36/48个通过的测试用例）
```py
class Solution:
    def dailyTemperatures(self, temperatures: List[int]) -> List[int]:
        res = [0] * len(temperatures)
        for i in range(len(temperatures)):
            for j in range(i + 1, len(temperatures)):
                if temperatures[j] > temperatures[i]:
                    res[i] = j - i
                    break
        return res
```


## 解法二（单调栈解法 时间复杂度$O(n)$）
```c++
#include <vector>
#include <stack>
using namespace std;

class Solution {
public:
    vector<int> dailyTemperatures(vector<int>& temperatures) {
        int n = temperatures.size();
        vector<int> res(n, 0);
        stack<int> st;

        for(int i = 0; i < n; ++i){
            // 只要当前温度 > 栈顶保存下标对应的温度，就更新答案
            while(!st.empty() && temperatures[i] > temperatures[st.top()]){
                int idx = st.top();
                st.pop();
                res[idx] = i - idx;
            }
            st.push(i);
        }
        return res;
    }
};
```