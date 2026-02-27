# Telegram Proxy Setup Skill for OpenClaw

A skill for configuring Telegram bot integration in OpenClaw when behind a proxy.

## What This Skill Covers

- Setting up Telegram-specific proxy (`channels.telegram.proxy`)
- Configuring Telegram bot token and DM policy
- Troubleshooting Telegram connection issues (`setMyCommands failed`)
- User pairing and approval workflow

## Important

**Telegram Bot API does NOT use global `HTTP_PROXY`**. It only uses `channels.telegram.proxy`:

```bash
# This is what Telegram needs:
openclaw config set channels.telegram.proxy "http://127.0.0.1:7897"

# These are OPTIONAL (for other tools like web_search):
openclaw config set env.HTTP_PROXY "http://127.0.0.1:7897"
```

## Quick Start

See [SKILL.md](SKILL.md) for full instructions.

### TL;DR

```bash
# 1. Set Telegram proxy (REQUIRED)
openclaw config set channels.telegram.proxy "http://127.0.0.1:7897"

# 2. Configure bot
openclaw config set channels.telegram.enabled true
openclaw config set channels.telegram.botToken "YOUR_TOKEN"
openclaw config set channels.telegram.dmPolicy "pairing"

# 3. Restart
openclaw gateway restart

# 4. Approve user
openclaw pairing approve telegram CODE
```

## Common Proxy Ports

| Software | HTTP | SOCKS5 |
|----------|------|--------|
| Clash | 7890 | 7891 |
| Clash Verge | 7897 | - |
| v2rayN | 10808 | 10808 |
| Shadowsocks | - | 1080 |

## References

- [Proxy Configurations](references/proxy-configs.md) - Common setups and troubleshooting

## License

MIT
