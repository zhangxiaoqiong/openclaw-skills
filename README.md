# OpenClaw Skills Collection

A collection of skills for OpenClaw - extending AI agent capabilities with specialized knowledge and workflows.

## What is OpenClaw?

[OpenClaw](https://github.com/openclaw/openclaw) is an open-source AI agent framework that brings AI agents to your favorite messaging platforms (Telegram, WhatsApp, Discord, Slack, etc.).

## What are Skills?

Skills are modular, self-contained packages that extend agent capabilities by providing specialized knowledge, workflows, and tools. They transform a general-purpose agent into a specialized agent equipped with procedural knowledge.

## Skills in this Collection

| Skill | Description |
|-------|-------------|
| [feishu-image-sender](skills/feishu-image-sender/) | Send screenshots and local images to Feishu (Lark) chat - solves OpenClaw's direct image sending limitation |
| [telegram-proxy-setup](skills/telegram-proxy-setup/) | Configure Telegram bot channel when behind HTTP/SOCKS5 proxy |

## How to Use

1. Download the `.skill` file or clone this repo
2. Place skill folder in your OpenClaw workspace: `~/.openclaw/workspace/skills/`
3. The skill will be automatically available to your agent

## How to Contribute

1. Fork this repository
2. Create your skill following the [OpenClaw skill guidelines](https://docs.openclaw.ai/skills)
3. Submit a pull request

## Skill Structure

```
skill-name/
├── SKILL.md              # Required - skill definition and instructions
├── README.md             # Optional - human-readable documentation
└── references/           # Optional - reference materials
    └── example.md
```

## License

MIT - See [LICENSE](LICENSE) for details.

## Resources

- [OpenClaw Documentation](https://docs.openclaw.ai)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)
- [Skill Creator Guide](https://docs.openclaw.ai/skills/creating)
