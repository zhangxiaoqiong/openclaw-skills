---
name: formal-report
description: 正式调研报告输出流程 - 当需要输出正式的调研报告、研究报告、政策分析等长文内容时，自动使用飞书文档方式提供。适用于用户要求"调研报告"、"分析报告"、"政策解读"、"研究报告"等场景。
metadata:
  {
    "openclaw": { "emoji": "📋", "os": ["darwin", "linux", "win32"] },
  }
---

# 正式调研报告输出流程

当用户要求输出正式调研报告时，按以下流程执行：

## 触发条件

用户要求以下类型内容时自动触发：
- 调研报告、政策分析、研究报告
- 详细攻略、完整指南
- 任何需要正式文档留存的长文内容

## 输出流程

### 1. 创建飞书文档

使用 feishu_doc 工具创建文档：

```json
{
  "action": "create",
  "title": "报告标题",
  "content": "# 报告标题\n\n> 更新时间\n\n---"
}
```

### 2. 检查文档是否为空

创建后立即读取文档确认内容：

```json
{
  "action": "read",
  "doc_token": "刚才返回的 document_id"
}
```

**关键检查**：如果返回的 content 只有一个标题（少于 10 个字符），说明内容没写入成功！

### 3. 写入完整内容

如果内容为空，使用 write action 重新写入：

```json
{
  "action": "write",
  "doc_token": "document_id",
  "content": "完整的 Markdown 报告内容..."
}
```

### 4. 再次验证

写入后再次读取确认内容已写入。

### 5. 返回链接给用户

提供飞书文档链接：`https://feishu.cn/docx/[document_id]`

## 完整代码示例

```python
# 1. 创建文档
result = feishu_doc(action="create", title="调研报告", content="# 标题")
doc_id = result["document_id"]

# 2. 检查内容
check = feishu_doc(action="read", doc_token=doc_id)
if len(check["content"]) < 10:
    # 3. 内容为空，重新写入
    feishu_doc(action="write", doc_token=doc_id, content=完整报告)

# 4. 返回链接
return f"https://feishu.cn/docx/{doc_id}"
```

## 优化提示

- 创建文档后**必须检查** content 是否为空
- 如果为空，**立即用 write action** 重新写入
- 写入后**再次验证**确保成功
- 文档链接格式：`https://feishu.cn/docx/[document_id]`
- 保持内容结构清晰，使用表格、列表等 Markdown 格式

## 禁止事项

- 不要仅在聊天中输出长文报告
- 不要创建本地文件后要求用户自行复制
- 不要假设创建文档就等于写入成功
- 必须验证内容确实写入后再返回链接
