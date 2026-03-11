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
    curl -s "$url" 2>/dev/null | \
      sed 's/<[^>]*>//g' | \
      tr '\n' ' ' | \
      sed 's/  */ /g' | \
      grep -oE '一、GPT[^👋]+' | \
      sed 's/二、/\\n\\n二、/g' | \
      sed 's/三、/\\n\\n三、/g' | \
      sed 's/四、/\\n\\n四、/g' | \
      sed 's/五、/\\n\\n五、/g' | \
      sed 's/六、/\\n\\n六、/g' | \
      sed 's/七、/\\n\\n七、/g' | \
      sed 's/八、/\\n\\n八、/g' | \
      sed 's/九、/\\n\\n九、/g' | \
      sed 's/十、/\\n\\n十、/g' | \
      sed 's/👋.*//' | \
      sed 's/前沿科技.*//' | \
      sed 's/报告观点.*//' | \
      sed 's/if (window.*//'
    echo ""
    echo "🔗 原文: $url"
    exit 0
  fi
done

echo "❌ 未找到 $TARGET_DATE 的文章"
exit 1
