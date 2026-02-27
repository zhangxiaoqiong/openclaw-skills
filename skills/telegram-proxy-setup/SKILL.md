---
name: telegram-proxy-setup
description: Configure Telegram bot channel for OpenClaw when behind a proxy. Use when setting up Telegram integration with HTTP/SOCKS5 proxy, troubleshooting Telegram connection issues, or approving Telegram user pairing codes. Covers Telegram-specific proxy configuration, gateway restart, and pairing approval workflow.
---

# Telegram Proxy Setup

Complete guide for configuring Telegram bot with proxy support in OpenClaw.

## Prerequisites

- OpenClaw installed and running
- Telegram bot token from @BotFather
- Proxy running on localhost (Clash, v2rayN, Sing-box, etc.)

## Configuration Steps

### 1. Set Telegram-Specific Proxy (Required)

Telegram Bot API calls need their own proxy setting:

```bash
openclaw config set channels.telegram.proxy "http://127.0.0.1:7897"
```

**Note:** `channels.telegram.proxy` is specifically for Telegram Bot API. It does NOT use global `HTTP_PROXY`.

### 2. Configure Telegram Bot Token

```bash
openclaw config set channels.telegram.enabled true
openclaw config set channels.telegram.botToken "YOUR_BOT_TOKEN"
openclaw config set channels.telegram.dmPolicy "pairing"
```

Or edit `~/.openclaw/openclaw.json` directly:

```json5
{
  channels: {
    telegram: {
      enabled: true,
      botToken: "123:abc",
      dmPolicy: "pairing",
      proxy: "http://127.0.0.1:7897",
    },
  },
}
```

### 3. Restart Gateway

```bash
openclaw gateway restart
```

### 4. Verify Telegram Status

```bash
openclaw status
```

Should show:
```
Telegram │ ON │ OK │ token config (xxxx) · accounts 1/1
```

If you see `setMyCommands failed` or network errors, the proxy isn't working. Check:
- Is proxy software running on port 7897?
- Try: `curl -x http://127.0.0.1:7897 https://api.telegram.org`

### 5. User Pairing Workflow

**User side:**
1. Open Telegram, search for bot username (e.g., `@clawbigxian_bot`)
2. Tap "Start" or send any message
3. Bot replies with pairing code: `Pairing code: 7JKSPBYU`

**Admin side:**
```bash
openclaw pairing approve telegram 7JKSPBYU
```

### 6. Test

User sends message on Telegram → You receive it in OpenClaw session.

## Optional: Global Proxy

If you also want other tools (web_search, web_fetch, etc.) to use proxy:

```bash
openclaw config set env.HTTP_PROXY "http://127.0.0.1:7897"
openclaw config set env.HTTPS_PROXY "http://127.0.0.1:7897"
openclaw config set env.NO_PROXY "localhost,127.0.0.1"
openclaw gateway restart
```

**But Telegram does NOT use these global settings.** Telegram only uses `channels.telegram.proxy`.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `setMyCommands failed` | Proxy not working. Check proxy software is running. Verify `channels.telegram.proxy` is set. |
| `Network request failed` | Check `channels.telegram.proxy` is correctly configured. |
| No pairing code received | Check gateway logs: `openclaw logs --follow` |
| Pairing approved but no messages | Verify user ID is correct; check `dmPolicy` setting. |

## SOCKS5 Proxy

If using SOCKS5:

```bash
openclaw config set channels.telegram.proxy "socks5://127.0.0.1:1080"
```

With authentication:
```bash
openclaw config set channels.telegram.proxy "socks5://user:pass@127.0.0.1:1080"
```

## Quick Reference

```bash
# Minimal setup (just Telegram)
openclaw config set channels.telegram.proxy "http://127.0.0.1:7897"
openclaw config set channels.telegram.enabled true
openclaw config set channels.telegram.botToken "YOUR_TOKEN"
openclaw config set channels.telegram.dmPolicy "pairing"
openclaw gateway restart
```

## Reference

- [Common Proxy Configs](references/proxy-configs.md) - Ports for Clash, v2rayN, Shadowsocks
