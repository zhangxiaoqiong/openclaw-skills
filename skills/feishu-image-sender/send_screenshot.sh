#!/bin/bash
# Send screenshot of webpage to Feishu
# Usage: send_screenshot.sh <url> <open_id>

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="$SCRIPT_DIR/feishu_send_image.py"

# Check arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 <url> <open_id>"
    echo "Example: $0 'https://www.baidu.com' 'ou_00380781f62e46ba159213ff4b779cc6'"
    exit 1
fi

URL="$1"
OPEN_ID="$2"

# Generate temporary filename
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SCREENSHOT_FILE="/tmp/screenshot_${TIMESTAMP}.png"

echo "📸 Taking screenshot of: $URL"

# Take screenshot using Chrome headless
google-chrome --headless --disable-gpu \
    --screenshot="$SCREENSHOT_FILE" \
    --window-size=1280,720 \
    --hide-scrollbars \
    "$URL" 2>/dev/null

if [ ! -f "$SCREENSHOT_FILE" ]; then
    echo "❌ Screenshot failed!"
    exit 1
fi

echo "✅ Screenshot saved: $SCREENSHOT_FILE"
echo "📤 Sending to Feishu..."

# Send to Feishu
python3 "$PYTHON_SCRIPT" "$SCREENSHOT_FILE" "$OPEN_ID"

# Optional: Clean up screenshot file
# rm -f "$SCREENSHOT_FILE"

echo "🎉 Done!"
