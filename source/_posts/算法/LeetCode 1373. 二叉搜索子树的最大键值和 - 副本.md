---
title: LeetCode 1373. 二叉搜索子树的最大键值和
date: 2026-09-06 14:30:34
updated: 2026-09-06 14:30:34
categories:
  - 算法
tags:
  - 二叉搜索树
  - 递归
  - 二叉树
  - 后序遍历
description: 
keywords:
permalink: 
cover: https://cdn.jsdelivr.net/gh/JayAShore/blog-images@main/images/d3bafbf1-ae80-4e40-90cb-6a9c1e9d3f19.png
stick:
---



> 在一棵二叉树中，找到**是二叉搜索树 (BST)** 的子树，计算它所有节点值的和，求最大的那个和（允许答案为 0）。二叉搜索树一般都采用递归来做。什么是二叉搜索树？左子树的最大值小于根节点小于右子树的最小值。

# BST 核心判定规则

一棵子树是合法 BST 必须满足：

1. 左子树所有节点值 **< 当前节点值**
2. 右子树所有节点值 **> 当前节点值**
3. 左右子树本身也必须是合法 BST

因此后序遍历（先处理左右孩子，再判断当前节点）最合适。

# C++代码

```c++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    const int INF = 1e8; //  
    int ans = 0; //空树也可以看成是一棵二叉搜索树

    vector<int> dfs(TreeNode* root){
        // {子树总和, 子树最小值, 子树最大值}
        vector<int> left = {0, root->val, -INF}; // 初始化左子树 left{}; 可以省略=  （左子树不存在的时候） 
        vector<int> right= {0, INF, root->val};  // 初始化右子树 右子树返回最大值 Lmax < val < Rmin

        if (root->left) left = dfs(root->left);     // 左子树存在的话
        if (root->right) right = dfs(root->right);  // 右子树存在的话

        if (left[2] < root->val && root->val < right[1])
        {
            int sum = left[0] + right[0] + root->val;
            ans = max(ans, sum);
            return {sum, left[1], right[2]};
        }
        return {-INF, -INF, INF}; //不合法不成立的情况
    }
    int maxSumBST(TreeNode* root) {
        dfs(root);
        return ans;
    }
};
```

算法整体思路总结

1. **后序遍历**：先算左子树信息，再算右子树，最后判断当前节点能不能构成 BST
2. 每个子树向上传递 3 个信息：总和、最小值、最大值
3. 判断 BST 规则：左子树最大值 < 当前值 < 右子树最小值
4. 维护全局变量保存最大合法 BST 子树和，结果最小为 0

**时间 O (n)**：每个节点只访问一次

**空间 O (h)**：递归栈深度，h 为树高，最坏单链 O (n)



>  有个坑，如果是负数的话直接返回0，因为空的树是任意树的子树，也算二叉搜索树，其“最大和”为0
