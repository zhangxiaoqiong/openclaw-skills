#!/bin/bash
# 阿里云百炼 文生图 Skill (通义万相 wanx-v1)
# Usage: qwen-image.sh "prompt" [telegram|feishu|both]

PROMPT="${1:-一只可爱的猫咪}"
TARGET="${2:-telegram}"  # telegram, feishu, or both
API_KEY="${DASHSCOPE_API_KEY:-sk-6aec5554356d4f2bba5d397b46c013f5}"
FEISHU_CHAT_ID="${FEISHU_CHAT_ID:-ou_00380781f62e46ba159213ff4b779cc6}"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-7966240102}"

echo "🎨 生成图片: $PROMPT"

# 提交异步任务
TASK_RESULT=$(curl -s -X POST "https://dashscope.aliyuncs.com/api/v1/services/aigc/text2image/image-synthesis" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -H "X-DashScope-Async: enable" \
  -d "{
    \"model\": \"wanx-v1\",
    \"input\": {
      \"prompt\": \"$PROMPT\"
    },
    \"parameters\": {
      \"size\": \"1024*1024\",
      \"n\": 1
    }
  }")

TASK_ID=$(echo "$TASK_RESULT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('output', {}).get('task_id', ''))" 2>/dev/null)

if [ -z "$TASK_ID" ]; then
  echo "❌ 提交任务失败"
  echo "$TASK_RESULT"
  exit 1
fi

echo "📋 Task ID: $TASK_ID"
echo "⏳ 等待生成 (约15-30秒)..."

# 轮询结果
for i in {1..30}; do
  sleep 2
  
  RESULT=$(curl -s "https://dashscope.aliyuncs.com/api/v1/tasks/$TASK_ID" \
    -H "Authorization: Bearer $API_KEY")
  
  STATUS=$(echo "$RESULT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('output', {}).get('task_status', ''))" 2>/dev/null)
  
  if [ "$STATUS" = "SUCCEEDED" ]; then
    IMAGE_URL=$(echo "$RESULT" | python3 -c "import sys, json; d=json.load(sys.stdin); print(d.get('output', {}).get('results', [{}])[0].get('url', ''))" 2>/dev/null)
    echo ""
    echo "✅ 图片生成成功！"
    
    # 下载图片
    OUTPUT_DIR="${QWEN_IMAGE_OUTPUT:-$HOME/.openclaw/workspace/generated}"
    mkdir -p "$OUTPUT_DIR"
    FILENAME="qwen_$(date +%Y%m%d_%H%M%S).png"
    OUTPUT_PATH="$OUTPUT_DIR/$FILENAME"
    
    curl -s -L "$IMAGE_URL" -o "$OUTPUT_PATH"
    
    if [ -f "$OUTPUT_PATH" ]; then
      echo "💾 已保存: $OUTPUT_PATH"
      
      # 发送到指定渠道
      if [ "$TARGET" = "feishu" ] || [ "$TARGET" = "both" ]; then
        echo "📤 发送到飞书..."
        python3 "$HOME/.openclaw/skills/web-screenshot/feishu_send_image.py" "$OUTPUT_PATH" "$FEISHU_CHAT_ID"
      fi
      
      if [ "$TARGET" = "telegram" ] || [ "$TARGET" = "both" ]; then
        echo "📤 发送到 Telegram..."
        # 使用 OpenClaw 的 message 工具发送
        echo "请手动发送或使用: openclaw message send --media $OUTPUT_PATH"
        echo "文件路径: $OUTPUT_PATH"
      fi
      
      # 如果 both，保留文件；否则删除
      if [ "$TARGET" != "both" ]; then
        rm -f "$OUTPUT_PATH"
      fi
    else
      echo "❌ 下载图片失败"
      echo "🔗 图片链接: $IMAGE_URL"
    fi
    
    exit 0
  elif [ "$STATUS" = "FAILED" ]; then
    echo ""
    echo "❌ 生成失败"
    echo "$RESULT"
    exit 1
  fi
done

echo ""
echo "⏰ 超时，请稍后手动查询:"
echo "   curl https://dashscope.aliyuncs.com/api/v1/tasks/$TASK_ID -H \"Authorization: Bearer \$API_KEY\""
