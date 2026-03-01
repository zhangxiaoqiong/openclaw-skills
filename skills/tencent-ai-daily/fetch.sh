#!/bin/bash
# 腾讯研究院 AI 速递自动抓取

TARGET_DATE="${1:-$(date +%Y%m%d)}"
SOHU_MEDIA="https://m.sohu.com/media/455313"

echo "🔍 抓取 AI 速递 $TARGET_DATE"

# 获取文章列表
LINKS=$(google-chrome --headless --disable-gpu \
  --dump-dom --virtual-time-budget=15000 "$SOHU_MEDIA" 2>/dev/null | \
  grep -oE 'a/[0-9]+_455313' | sort -u | head -20)

# 找匹配日期的文章
for link in $LINKS; do
  url="https://m.sohu.com/$link"
  title=$(curl -s "$url" | grep -oE '腾讯研究院AI速递 [0-9]+' | head -1)
  [[ "$title" == *"$TARGET_DATE"* ]] && { echo "✅ $title"; echo "🔗 $url"; curl -s "$url" | grep -A2 "^一、" | head -3; exit 0; }
done

echo "❌ 未找到 $TARGET_DATE 的文章"
exit 1
