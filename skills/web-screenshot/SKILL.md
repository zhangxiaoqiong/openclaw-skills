---
name: web-screenshot
description: 网页截图并发送到 Telegram - 使用 Chrome headless 截图任意网页
version: 1.0.0
author: OpenClaw Community
license: MIT
metadata:
  openclaw:
    emoji: "📸"
    os: ["linux"]
    requires:
      tools: ["google-chrome"]
    tags: ["screenshot", "web", "browser", "telegram"]
---

# Web Screenshot Skill

使用 Chrome headless 模式截取网页截图，并通过 Telegram 发送给用户。

## 功能

- 🌐 截取任意网页截图
- 📱 自动发送到当前 Telegram 聊天
- ⚡ 无需图形界面，纯命令行操作

## 依赖

- Google Chrome / Chromium 浏览器
- Linux 系统（支持 headless 模式）

## 使用方法

### 命令行

```bash
# 截图并发送
~/.openclaw/skills/web-screenshot/screenshot.sh https://example.com

# 指定窗口大小
~/.openclaw/skills/web-screenshot/screenshot.sh https://example.com 1920x1080
```

### 在 OpenClaw 中使用

发送消息：
```
截图 https://creator.xiaohongshu.com
```

## 技术细节

- 使用 Chrome `--headless` 模式
- 截图保存到 `~/.openclaw/workspace/screenshot-TIMESTAMP.png`
- 自动通过 Telegram 发送后删除临时文件

## 示例

```bash
# 小红书登录页
screenshot.sh https://creator.xiaohongshu.com

# 自定义尺寸
screenshot.sh https://www.google.com 1280x720
```
