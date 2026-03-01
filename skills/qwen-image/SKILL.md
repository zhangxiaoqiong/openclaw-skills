# Qwen Image Generation Skill

阿里云百炼 Qwen 文生图

## Usage

```bash
# 生成图片
~/.openclaw/skills/qwen-image/qwen-image.sh "一只可爱的猫咪在草地上"

# 或使用环境变量设置 API Key
export DASHSCOPE_API_KEY="your-api-key"
~/.openclaw/skills/qwen-image/qwen-image.sh "新年快乐的红色背景"
```

## Model

- **qwen-image-max**: 千问文生图（高质量）
- 图片尺寸: 1024x1024
- 异步生成，约 10-30 秒

## Requirements

- DashScope API Key
- 开通图像生成服务

## API Endpoint

```
POST https://dashscope.aliyuncs.com/api/v1/tasks
```

## Response

- Task ID
- 轮询等待生成
- 返回图片 URL
