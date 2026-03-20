---
name: daily-ai-digest
description: |
  腾讯研究院AI速递每日监控与自动发布技能。
  
  当用户提到以下内容时使用此 Skill：
  - "每日AI速递自动发布"
  - "定时发布小红书"
  - "监控AI速递并发布"
  - "设置每日小红书自动发布任务"
  
  此 Skill 会：
  1. 抓取腾讯研究院搜狐主页的AI速递文章
  2. 检测当天是否有新文章
  3. 生成封面图
  4. 自动发布到小红书
  5. 设置每日定时任务（crontab）

trigger: |
  - 每日AI速递
  - 自动发布小红书
  - 定时发布AI速递
  - 设置小红书自动发布
  - daily-ai-digest
---

# 腾讯研究院AI速递每日监控

## 功能

- 自动抓取腾讯研究院AI速递当日文章
- 格式化内容并生成封面图
- 一键发布到小红书
- 设置每日定时自动执行

## 使用方式

### 手动执行
```bash
bash ~/.agents/skills/xiaohongshu/scripts/daily-ai-digest.sh
```

### 查看日志
```bash
tail -f ~/.xiaohongshu/daily-ai-digest.log
```

### 查看Cron任务
```bash
crontab -l | grep daily-ai-digest
```

## 定时任务

默认每天 9:30 北京时间自动执行（crontab）。

修改时间：
```bash
# 编辑 crontab
crontab -e
# 修改行为：
# 30 9 * * * /home/xqiong/.agents/skills/xiaohongshu/scripts/daily-ai-digest.sh
```

## 依赖

- xiaohongshu-mcp 服务（小红书发布）
- qwen-image skill（封面图生成）
- curl、jq 工具

## 文件

- 脚本：`~/.agents/skills/xiaohongshu/scripts/daily-ai-digest.sh`
- 日志：`~/.xiaohongshu/daily-ai-digest.log`
- Cron日志：`~/.xiaohongshu/daily-cron.log`
