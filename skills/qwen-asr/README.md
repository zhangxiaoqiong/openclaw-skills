# Qwen-ASR Skill for OpenClaw

阿里云百炼语音识别 Skill，支持中文语音转文字。使用 OpenAI 兼容模式的同步接口，响应速度快。

## 功能特性

- 🎙️ **中文语音识别**：基于阿里云百炼 Qwen3-ASR-Flash 模型
- ⚡ **同步接口**：3-5 秒快速识别，无需轮询等待
- 🔧 **简单易用**：一行命令即可转录音频
- 🆓 **成本低廉**：按音频时长计费，性价比高

## 安装

1. 将本 skill 复制到 OpenClaw skills 目录：
```bash
cp -r qwen-asr ~/.openclaw/skills/
```

2. 配置阿里云百炼 API Key：
```bash
# 编辑 auth-profiles.json
~/.openclaw/agents/main/agent/auth-profiles.json
```

添加：
```json
{
  "profiles": {
    "dashscope:default": {
      "type": "api_key",
      "provider": "dashscope",
      "key": "sk-your-api-key"
    }
  }
}
```

获取 API Key：https://bailian.console.aliyun.com/

## 使用方法

### 命令行转录

```bash
# 转录单个音频文件
~/.openclaw/skills/qwen-asr/qwen-asr.sh /path/to/audio.wav

# 支持的格式：wav, ogg, mp3, m4a
~/.openclaw/skills/qwen-asr/qwen-asr.sh voice.ogg
```

### 在 OpenClaw 中自动处理语音

当收到语音消息时，OpenClaw 会自动调用此 skill 进行转录。

## 技术细节

- **模型**：`qwen3-asr-flash`（OpenAI 兼容模式）
- **接口**：同步调用（`chat.completions`）
- **平均耗时**：3-5 秒
- **支持语言**：中文（默认）

## 定价

阿里云百炼语音识别按音频时长计费：
- 具体价格请参考：https://www.aliyun.com/price/product?spm=a2c4g.11186623.0.0.7b7e59c0xY7T5X#/bailian/detail/bailian

## 依赖

- `curl`
- `python3`
- 阿里云百炼 API Key

## 文件说明

```
qwen-asr/
├── SKILL.md          # Skill 元数据
├── README.md         # 本文件
└── qwen-asr.sh       # 核心脚本
```

## License

MIT License

## 作者

OpenClaw Community
