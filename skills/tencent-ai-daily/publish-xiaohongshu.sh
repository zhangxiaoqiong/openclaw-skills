#!/bin/bash
# AI速递获取并发布到小红书
# 使用方法: ~/.openclaw/skills/tencent-ai-daily/publish-xiaohongshu.sh

# 获取今天的日期
TODAY=$(date +%Y%m%d)
echo "📅 今日日期: $TODAY"

# 抓取最新AI速递
echo "🔍 抓取 AI 速递..."
LINKS=$(google-chrome --headless --disable-gpu \
  --dump-dom \
  --virtual-time-budget=15000 \
  "https://m.sohu.com/media/455313" 2>/dev/null | \
  grep -oE 'https://m\.sohu\.com/a/[0-9]+_455313[^"]*' | \
  sed 's/&amp;scm=.*//' | \
  awk '!seen[$0]++' | head -3)

if [ -z "$LINKS" ]; then
  echo "❌ 未获取到文章列表"
  exit 1
fi

# 找到今天的文章
for url in $LINKS; do
  title=$(curl -s "$url" 2>/dev/null | grep -oE '腾讯研究院AI速递 [0-9]+' | head -1)
  
  if [[ "$title" == *"$TODAY"* ]]; then
    echo "✅ 找到: $title"
    echo "🔗 $url"
    echo ""
    echo "📝 请在浏览器中手动发布，或使用自动化流程"
    echo "📋 流程: 写长文 → 填标题 → 填正文(详细版) → 等待2-3秒 → 一键排版 → 下一步 → 填标题 → 填正文描述 → 下一步 → 发布"
    exit 0
  fi
done

echo "❌ 未找到 $TODAY 的文章"
exit 1
