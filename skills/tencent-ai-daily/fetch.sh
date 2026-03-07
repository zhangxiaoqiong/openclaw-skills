#!/bin/bash
# 腾讯研究院 AI 速递自动抓取

TARGET_DATE="${1:-$(date +%Y%m%d)}"
SOHU_MEDIA="https://m.sohu.com/media/455313"

echo "🔍 抓取 AI 速递 $TARGET_DATE"
echo "📡 访问搜狐媒体号..."

# 提取前3个文章链接
LINKS=$(google-chrome --headless --disable-gpu \
  --dump-dom \
  --virtual-time-budget=15000 \
  "$SOHU_MEDIA" 2>/dev/null | \
  grep -oE 'https://m\.sohu\.com/a/[0-9]+_455313[^"]*' | \
  sed 's/&amp;scm=.*//' | \
  awk '!seen[$0]++' | head -3)

if [ -z "$LINKS" ]; then
  echo "❌ 未获取到文章列表"
  exit 1
fi

echo "找到前3个链接:"
echo "$LINKS"
echo ""

# 检查每个链接
for url in $LINKS; do
  title=$(curl -s "$url" 2>/dev/null | grep -oE '腾讯研究院AI速递 [0-9]+' | head -1)
  
  if [[ "$title" == *"$TARGET_DATE"* ]]; then
    echo "✅ 找到: $title"
    echo "🔗 $url"
    echo ""
    echo "========== 内容 =========="
    curl -s "$url" 2>/dev/null | grep -E "^一、|^二、|^三、|^四、|^五、|^六、|^七、|^八、" | head -10
    echo ""
    echo "🔗 原文: $url"
    exit 0
  fi
done

echo "❌ 未找到 $TARGET_DATE 的文章"
exit 1
