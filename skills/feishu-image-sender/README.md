# Feishu Image Sender Skill

飞书图片发送工具 - 解决 OpenClaw 无法直接发送本地图片到飞书的问题。

## 问题背景

OpenClaw 的 `message` 工具在发送到 Feishu 时，直接传递本地文件路径会导致图片无法显示。这是因为飞书要求：

1. 先将图片上传到飞书服务器获取 `image_key`
2. 再用 `image_key` 发送图片消息

## 解决方案

本 Skill 封装了完整的图片发送流程：

```
网页截图 → 上传飞书获取 image_key → 发送图片消息
```

## 安装

1. 确保已安装依赖：
```bash
# Ubuntu/Debian
sudo apt-get install -y google-chrome-stable python3 python3-requests

# 安装中文字体（可选，但推荐）
sudo apt-get install -y fonts-noto-cjk
```

2. 配置飞书应用凭证：
编辑 `feishu_send_image.py`，填入你的 App ID 和 App Secret：
```python
APP_ID = "cli_xxxxxxxxxx"
APP_SECRET = "xxxxxxxxxx"
```

## 使用方法

### 方式一：截图并发送（推荐）

```bash
~/.openclaw/skills/feishu-image-sender/send_screenshot.sh \
    "https://www.baidu.com" \
    "ou_00380781f62e46ba159213ff4b779cc6"
```

### 方式二：发送已有图片

```bash
python3 ~/.openclaw/skills/feishu-image-sender/feishu_send_image.py \
    /path/to/your/image.png \
    "ou_00380781f62e46ba159213ff4b779cc6"
```

### 方式三：在 OpenClaw 中使用

当你让我截图并发送到飞书时，我会自动调用此 Skill。

## 技术要点

### 飞书 API 调用流程

1. **获取 tenant_access_token**
   ```
   POST https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal
   ```

2. **上传图片获取 image_key**
   ```
   POST https://open.feishu.cn/open-apis/im/v1/images
   Form Data: image_type=message, image=(binary)
   ```

3. **发送图片消息**
   ```
   POST https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=open_id
   Body: {"receive_id": "ou_xxx", "msg_type": "image", "content": "{\"image_key\": \"img_v3_xxx\"}"}
   ```

### 关键注意事项

- `receive_id_type` 必须是 `open_id`，不是 `user_id`
- `image_key` 有有效期，建议立即使用
- 图片大小限制 20MB
- 支持的格式：PNG, JPG, JPEG, GIF

## 文件结构

```
feishu-image-sender/
├── SKILL.md              # Skill 定义和使用说明
├── README.md             # 本文件
├── feishu_send_image.py  # 核心 Python 脚本
└── send_screenshot.sh    # 截图+发送一站式脚本
```

## 常见问题

### Q: 截图后出现白屏或乱码？
**A**: 安装中文字体：`sudo apt-get install fonts-noto-cjk`

### Q: "receive_id_type is required" 错误？
**A**: 确保 URL 中包含 `?receive_id_type=open_id` 查询参数

### Q: "id not exist" 错误？
**A**: 使用 `open_id`（以 `ou_` 开头）而不是 `user_id`

### Q: 如何获取用户的 open_id？
**A**: 从 OpenClaw 的 inbound_meta 中可以看到：`"chat_id": "user:ou_xxxxxx"`

## 许可证

MIT License

## 作者

OpenClaw Community
