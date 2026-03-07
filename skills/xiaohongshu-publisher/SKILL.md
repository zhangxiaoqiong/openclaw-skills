---
name: xiaohongshu-publisher
description: "Automated Xiaohongshu (Little Red Book) content publishing. Use when user asks to 'publish to Xiaohongshu', 'post on 小红书', 'send to Xiaohongshu', or any request to create and publish notes on the Xiaohongshu creator platform. Handles login check, QR code screenshot for authentication, cover image generation, title/content filling, and publishing."
---

# Xiaohongshu Publisher

Automated publishing to Xiaohongshu (小红书) creator platform.

## Workflow

### Step 1: Check Login Status
1. Navigate to `https://creator.xiaohongshu.com/`
2. Check if user is already logged in (look for username/avatar in top-right corner)
3. If logged in → proceed to Step 3
4. If NOT logged in → proceed to Step 2

### Step 2: Handle Login (if needed)
1. Click on QR code icon to switch to QR login
2. Screenshot the QR code page
3. Send screenshot to user via message tool
4. Wait for user confirmation that they have scanned the code
5. Verify login success by checking for username/avatar

### Step 3: Create Cover Image
1. Use the provided Python script to generate a cover image:
   ```bash
   python3 ~/.openclaw/skills/xiaohongshu-publisher/scripts/generate_cover.py "<title>" "<output_path>"
   ```
2. The script creates a 900x1200px cover with gradient background
3. Upload the generated cover image

### Step 4: Fill Content
1. Click "发布笔记" → "上传图文"
2. Upload the generated cover image
3. Fill in title (max 20 characters recommended)
4. Fill in body content with proper formatting
5. Add relevant hashtags

### Step 5: Publish
1. Click "发布" button
2. Wait for confirmation
3. Verify publication in "笔记管理" section

## Cover Image Generation

The cover generation script creates professional-looking covers with:
- Dark gradient background (#1a1a2e to #2d2d5a)
- Title at top with cyan accent color
- Content sections with emoji icons
- Hashtags at bottom
- 900x1200px (3:4 ratio optimized for Xiaohongshu)

## Important Notes

- **Session Persistence**: Login state is maintained in browser, so subsequent publishes don't require re-login
- **Content Format**: Supports text, emojis, and bullet points
- **Image Upload**: Cover images are uploaded via browser automation
- **Publishing Time**: Notes may take a few minutes to appear in "审核中" before going live

## Example Usage

User: "帮我发一条小红书，内容是今天AI新闻"

Response:
1. Check login → If not logged in, show QR code
2. Generate cover with AI news theme
3. Create title: "2026.03.07 AI日报｜今日必看"
4. Fill body with AI news content
5. Publish

## Troubleshooting

- **QR code expired**: Regenerate screenshot
- **Upload failed**: Check image path and retry
- **Publish button not found**: Content may be auto-saved to drafts
