#!/bin/bash
# Qwen ASR - 阿里云百炼语音识别（同步接口，更快）

AUDIO_FILE="$1"
API_KEY="sk-6aec5554356d4f2bba5d397b46c013f5"

if [ -z "$AUDIO_FILE" ] || [ ! -f "$AUDIO_FILE" ]; then
    echo "Usage: qwen-asr.sh <audio-file>" >&2
    exit 1
fi

# 上传文件
UPLOAD_RESULT=$(curl -s -X POST https://dashscope.aliyuncs.com/api/v1/files \
  -H "Authorization: Bearer $API_KEY" \
  -F "file=@$AUDIO_FILE" \
  -F "purpose=transcription")

FILE_ID=$(echo "$UPLOAD_RESULT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['data']['uploaded_files'][0]['file_id'])")

if [ -z "$FILE_ID" ]; then
    echo "Error: Upload failed" >&2
    exit 1
fi

# 获取文件 URL
FILE_INFO=$(curl -s "https://dashscope.aliyuncs.com/api/v1/files/$FILE_ID" \
  -H "Authorization: Bearer $API_KEY")
FILE_URL=$(echo "$FILE_INFO" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['data']['url'])")

# 使用同步接口识别（无需轮询，直接返回结果）
RESULT=$(curl -s -X POST 'https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions' \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"qwen3-asr-flash\",
    \"messages\": [
      {
        \"role\": \"user\",
        \"content\": [
          {
            \"type\": \"input_audio\",
            \"input_audio\": {
              \"data\": \"$FILE_URL\"
            }
          }
        ]
      }
    ],
    \"stream\": false,
    \"asr_options\": {
      \"enable_itn\": false
    }
  }")

# 提取文字
TEXT=$(echo "$RESULT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['choices'][0]['message']['content'])")

if [ -n "$TEXT" ]; then
    echo "$TEXT"
else
    echo "Error: $RESULT" >&2
    exit 1
fi
