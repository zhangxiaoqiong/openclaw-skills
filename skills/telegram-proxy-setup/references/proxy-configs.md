# Common Proxy Configurations for Telegram

## Popular Proxy Software Ports

| Software | Default HTTP Port | Default SOCKS5 Port |
|----------|-------------------|---------------------|
| Clash | 7890 | 7891 |
| Clash Verge | 7897 | - |
| v2rayN | 10808 | 10808 |
| v2rayNG | 10808 | 10808 |
| Shadowsocks | - | 1080 |
| Sing-box | 2080 | 2081 |

## Configuration Examples

### Clash / Clash Verge (HTTP)

```bash
openclaw config set channels.telegram.proxy "http://127.0.0.1:7890"
```

### v2rayN (SOCKS5)

```bash
openclaw config set channels.telegram.proxy "socks5://127.0.0.1:10808"
```

### Shadowsocks (SOCKS5 with auth)

```bash
openclaw config set channels.telegram.proxy "socks5://user:pass@127.0.0.1:1080"
```

## Testing Proxy Connectivity

```bash
# Test HTTP proxy
curl -x http://127.0.0.1:7897 https://api.telegram.org

# Test SOCKS5 proxy
curl -x socks5://127.0.0.1:10808 https://api.telegram.org

# Test with verbose output
curl -v -x http://127.0.0.1:7897 https://api.telegram.org
```

## Firewall & Network Issues

### IPv6 Problems

Some hosts resolve `api.telegram.org` to IPv6 first, causing failures:

```bash
# Check DNS resolution
dig +short api.telegram.org A
dig +short api.telegram.org AAAA

# Force IPv4 in config
openclaw config set channels.telegram.network.autoSelectFamily false
```

Or set environment variable:
```bash
export OPENCLAW_TELEGRAM_DISABLE_AUTO_SELECT_FAMILY=1
```

### DNS Result Order

```bash
# Force IPv4 first (default on Node 22+)
openclaw config set channels.telegram.network.dnsResultOrder "ipv4first"
```

## Gateway Logs

View real-time logs:
```bash
openclaw logs --follow
```

Filter for Telegram:
```bash
openclaw logs --follow | grep -i telegram
```

## Alternative: Environment Variables

If config doesn't work, set proxy via env before starting gateway:

```bash
export HTTP_PROXY=http://127.0.0.1:7897
export HTTPS_PROXY=http://127.0.0.1:7897
export NO_PROXY=localhost,127.0.0.1
openclaw gateway start
```

Or add to `~/.openclaw/.env`:
```
HTTP_PROXY=http://127.0.0.1:7897
HTTPS_PROXY=http://127.0.0.1:7897
NO_PROXY=localhost,127.0.0.1
```
