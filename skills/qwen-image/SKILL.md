---
name: qwen-image
description: 阿里云百炼 Qwen 文生图 - 使用通义万相生成图片
version: 1.1.0
author: OpenClaw
license: MIT
metadata:
  openclaw:
    emoji: "🎨"
    os: ["linux"]
    requires:
      tools: ["curl", "python3"]
    tags: ["image", "ai", "generation", "wanx"]
---

# Qwen Image Generation Skill

阿里云百炼通义万相文生图

## 使用方法

```bash
# 生成图片（默认保存到本地）
~/.openclaw/skills/qwen-image/qwen-image.sh "一只可爱的猫咪"

# 发送到飞书
~/.openclaw/skills/qwen-image/qwen-image.sh "新年快乐的红色背景" feishu

# 发送到 Telegram（保存路径，需手动发送）
~/.openclaw/skills/qwen-image/qwen-image.sh "美丽的风景" telegram

# 同时发送到两个渠道
~/.openclaw/skills/qwen-image/qwen-image.sh "中国山水画" both
```

## 模型参数

- **模型**: wanx-v1 (通义万相)
- **尺寸**: 1024x1024
- **生成时间**: 15-30秒

## 配置

环境变量：
- `DASHSCOPE_API_KEY` - 百炼 API Key
- `FEISHU_CHAT_ID` - 飞书用户 ID
- `TELEGRAM_CHAT_ID` - Telegram Chat ID
- `QWEN_IMAGE_OUTPUT` - 输出目录

## 依赖

- curl
- python3
- feishu_send_image.py (用于飞书发送)
