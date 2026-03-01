---
name: qwen-asr
description: 阿里云百炼语音识别 (Qwen-ASR) - 支持中文语音转文字，同步接口响应快
version: 1.0.0
author: OpenClaw Community
license: MIT
metadata:
  openclaw:
    emoji: "🎙️"
    os: ["darwin", "linux", "win32"]
    requires:
      env: ["DASHSCOPE_API_KEY"]
      tools: ["curl", "python3"]
    tags: ["speech", "asr", "audio", "chinese"]
---

# Qwen-ASR Skill

阿里云百炼语音识别服务，使用 OpenAI 兼容模式的同步接口，支持快速中文语音转文字。

## 快速开始

```bash
# 转录音频
~/.openclaw/skills/qwen-asr/qwen-asr.sh audio.ogg
```

## 配置

需要配置阿里云百炼 API Key：
- 获取地址：https://bailian.console.aliyun.com/
- 配置位置：`~/.openclaw/agents/main/agent/auth-profiles.json`

## 技术参数

- **模型**: `qwen3-asr-flash`
- **接口**: OpenAI 兼容模式 (chat.completions)
- **调用方式**: 同步
- **平均响应**: 3-5 秒
- **语言支持**: 中文

## 更多信息

详见 [README.md](README.md)
