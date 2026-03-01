---
name: feishu-image-sender
description: "Send local images to Feishu (Lark) chat. Use when: user asks to screenshot a webpage and send it to Feishu, or send any local image file to Feishu chat. This skill handles the full workflow: generate screenshot (via Chrome headless) or use existing image, upload to Feishu to get image_key, then send the image message."
homepage: https://open.feishu.cn/document/uAjLw4CM/ukTMukTMukTM/reference/im-v1/image/create
metadata:
  {
    "openclaw":
      {
        "emoji": "🖼️",
        "requires": { "bins": ["python3", "google-chrome"] },
      },
  }
---

# Feishu Image Sender

Send screenshots or local images to Feishu chat.

## Why This Skill Exists

OpenClaw's built-in `message` tool cannot directly send local images to Feishu because Feishu requires a specific workflow:
1. Upload image to Feishu server to get an `image_key`
2. Send message using the `image_key`

This skill automates the entire process.

## Prerequisites

- Python 3 with `requests` module
- Google Chrome (for screenshot functionality)
- Feishu Bot credentials (App ID and App Secret)

## Configuration

Edit `feishu_send_image.py` and set your credentials:

```python
APP_ID = "your_app_id"
APP_SECRET = "your_app_secret"
```

## Usage

### Send a webpage screenshot

```bash
# Screenshot a webpage and send to Feishu
~/.openclaw/skills/feishu-image-sender/send_screenshot.sh "https://www.baidu.com" "ou_xxxxxxxxxx"
```

### Send an existing image file

```bash
# Send existing image
python3 ~/.openclaw/skills/feishu-image-sender/feishu_send_image.py /path/to/image.png "ou_xxxxxxxxxx"
```

## API Reference

### Upload Image
```bash
POST https://open.feishu.cn/open-apis/im/v1/images
Authorization: Bearer {tenant_access_token}
Content-Type: multipart/form-data

Form Data:
- image: (binary file)
- image_type: "message"
```

Response:
```json
{
  "code": 0,
  "data": {
    "image_key": "img_v3_xxxxx"
  }
}
```

### Send Image Message
```bash
POST https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=open_id
Authorization: Bearer {tenant_access_token}
Content-Type: application/json

Body:
{
  "receive_id": "ou_xxxxxxxxxx",
  "msg_type": "image",
  "content": "{\"image_key\": \"img_v3_xxxxx\"}"
}
```

## Key Points

- `receive_id_type` must be `open_id` (not `user_id`)
- The `image_key` expires after a period of time
- Image size limit: 20MB
- Supported formats: PNG, JPG, JPEG, GIF

## Troubleshooting

### "receive_id_type is required"
Make sure to include `?receive_id_type=open_id` in the URL query string.

### "id not exist"
Use `open_id` format (starts with `ou_`) not `user_id`.

### Screenshot fails on Ubuntu
Install Chrome dependencies:
```bash
sudo apt-get install -y libnss3 libgbm1 fonts-noto-cjk
```

## Files

- `feishu_send_image.py` - Core Python script for sending images
- `send_screenshot.sh` - Convenience wrapper for webpage screenshots
- `SKILL.md` - This file
