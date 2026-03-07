#!/bin/bash
# 腾讯研究院 AI 速递自动抓取

TARGET_DATE="${1:-$(date +%Y%m%d)}"
SOHU_MEDIA="https://www.sohu.com/media/455313"

echo "🔍 抓取 AI 速递 $TARGET_DATE"
echo "📡 访问搜狐媒体号..."

# 使用 PC 端获取文章列表
LINKS=$(google-chrome --headless --disable-gpu \
  --dump-dom \
  --virtual-time-budget=15000 \
  "$SOHU_MEDIA" 2>/dev/null | \
  grep -oE 'https://www\.sohu\.com/a/[0-9]+_455313' | \
  awk '!seen[$0]++' | head -5)

if [ -z "$LINKS" ]; then
  echo "❌ 未获取到文章列表"
  exit 1
fi

echo "找到前5个链接:"
echo "$LINKS"
echo ""

# 检查每个链接
for url in $LINKS; do
  # 提取文章 ID
  article_id=$(echo "$url" | grep -oE '[0-9]+' | head -1)
  
  # 获取内容
  content=$(curl -s "$url" 2>/dev/null | grep -oE '一、|二、|三、|四、|五、|六、七、八' | head -10)
  
  if [ -n "$content" ]; then
    echo "✅ 找到文章: $url"
    echo "========== 内容摘要 =========="
    curl -s "$url" 2>/dev/null | grep -oE '一、[^<]{1,100}|二、[^<]{1,100}|三、[^<]{1,100}|四、[^<]{1,100}|五、[^<]{1,100}' | head -5
    echo ""
    echo "🔗 原文: $url"
    exit 0
  fi
done

echo "❌ 未找到 $TARGET_DATE 的文章"
exit 1
