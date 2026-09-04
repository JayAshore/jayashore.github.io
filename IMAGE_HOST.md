# GitHub + jsDelivr 图床

图片放在 `source/images/` 下，提交到公开的 GitHub 仓库后，可以使用 jsDelivr 引用：

```text
https://cdn.jsdelivr.net/gh/JayAshore/jayashore.github.io@main/source/images/图片路径
```

## 上传图片

在 `D:\blog` 目录执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\upload-image.ps1 `
  -ImagePath "C:\Users\你的用户名\Pictures\demo.png" `
  -Folder "2026/09"
```

脚本会把图片复制到 `source/images/2026/09/`，并输出 jsDelivr URL 和 Markdown 写法。

## 发布图片

```powershell
git add source/images/
git commit -m "新增图片"
git push
```

推送完成后，在文章中使用脚本输出的 Markdown：

```markdown
![示例图片](https://cdn.jsdelivr.net/gh/JayAshore/jayashore.github.io@main/source/images/2026/09/demo.png)
```

图片仓库是公开的，不要上传身份证、密钥、Token 或其他隐私图片。建议每张图片使用唯一文件名，避免浏览器和 CDN 缓存旧内容。
