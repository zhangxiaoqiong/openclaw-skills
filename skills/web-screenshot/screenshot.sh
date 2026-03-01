#!/bin/bash
# Web Screenshot - 截图并发送

URL="$1"
TARGET="${2:-telegram}"
SIZE="${3:-1280x720}"

if [ -z "$URL" ]; then
    echo "Usage: screenshot.sh <url> [telegram|feishu] [widthxheight]"
    exit 1
fi

WIDTH=$(echo "$SIZE" | cut -d'x' -f1)
HEIGHT=$(echo "$SIZE" | cut -d'x' -f2)
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
OUTPUT_FILE="$HOME/.openclaw/workspace/screenshot-${TIMESTAMP}.png"

echo "📸 Screenshot: $URL (${WIDTH}x${HEIGHT})"

google-chrome --headless --disable-gpu \
    --screenshot="$OUTPUT_FILE" \
    --window-size="${WIDTH},${HEIGHT}" \
    "$URL" 2>/dev/null

if [ ! -f "$OUTPUT_FILE" ]; then
    echo "❌ Failed"
    exit 1
fi

echo "✅ Done: $(ls -lh "$OUTPUT_FILE" | awk '{print $5}')"

if [ "$TARGET" = "feishu" ]; then
    echo "📤 Sending to Feishu..."
    python3 "$HOME/.openclaw/skills/web-screenshot/feishu_send_image.py" \
        "$OUTPUT_FILE" "ou_00380781f62e46ba159213ff4b779cc6"
fi

rm -f "$OUTPUT_FILE"
