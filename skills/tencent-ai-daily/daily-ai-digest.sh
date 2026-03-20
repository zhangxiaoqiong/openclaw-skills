#!/bin/bash
# 腾讯研究院AI速递每日监控脚本 v2
# 自动获取当日AI速递并发布到小红书

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/home/xqiong/.xiaohongshu/daily-ai-digest.log"
TODAY_STR=$(date +%Y.%m.%d)
XHS_MCP_URL="${MCP_URL:-http://localhost:18060/mcp}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 检查MCP服务
check_mcp() {
    if ! curl -s --connect-timeout 3 "$XHS_MCP_URL" > /dev/null 2>&1; then
        log "MCP服务未运行，启动中..."
        cd /home/xqiong/.xiaohongshu
        nohup /home/xqiong/.local/bin/xiaohongshu-mcp-linux-amd64 -port :18060 > mcp.log 2>&1 &
        sleep 5
    fi
}

# 检查登录
check_login() {
    RESPONSE=$(cd "$SCRIPT_DIR" && timeout 30 ./mcp-call.sh check_login_status 2>&1) || true
    if echo "$RESPONSE" | grep -q "未登录"; then
        log "未登录小红书，需要重新扫码登录"
        return 1
    fi
    return 0
}

# 获取当日AI速递URL
get_today_url() {
    log "检查当日AI速递: $TODAY_STR"
    
    # 从列表页提取当日AI速递
    HTML=$(curl -sL "https://m.sohu.com/media/455313" 2>/dev/null)
    
    # 查找匹配当天日期的AI速递
    TODAY_ARTICLE=$(echo "$HTML" | grep -oP '(?<=<a href="//m\.sohu\.com/a/)\d+(?=_455313[^"]*">[^<]*AI速递\s*'"$(date +%Y%m%d)"'")' | head -1)
    
    if [ -z "$TODAY_ARTICLE" ]; then
        log "今日暂无AI速递文章"
        return 1
    fi
    
    echo "https://m.sohu.com/a/${TODAY_ARTICLE}_455313"
    return 0
}

# 生成封面图
generate_cover() {
    log "生成封面图..."
    cd ~/.openclaw/skills/qwen-image && ./qwen-image.sh "科技感蓝色AI主题 $(date +%Y年%m月%d日)" > /dev/null 2>&1
    
    latest_img=$(ls -t /home/xqiong/.openclaw/workspace/generated/qwen_*.png 2>/dev/null | head -1)
    if [ -n "$latest_img" ] && [ -f "$latest_img" ]; then
        echo "$latest_img"
        return 0
    fi
    echo ""
    return 1
}

# 发布到小红书
publish() {
    local title="$1"
    local content="$2" 
    local cover="$3"
    local tags="$4"
    
    log "发布到小红书: $title"
    
    # 构建JSON
    JSON=$(jq -n \
        --arg t "$title" \
        --arg c "$content" \
        --arg img "$cover" \
        --argjson tags "$tags" \
        '{title: $t, content: $c, images: [$img], tags: $tags}')
    
    cd "$SCRIPT_DIR" && timeout 90 ./mcp-call.sh publish_content "$JSON" 2>&1
}

# 主流程
main() {
    log "========== 开始每日AI速递监控 =========="
    
    check_mcp
    check_login || exit 1
    
    ARTICLE_URL=$(get_today_url) || {
        log "未找到当日AI速递，退出"
        exit 0
    }
    
    log "获取文章: $ARTICLE_URL"
    
    # 获取文章内容 - 简化提取
    CONTENT=$(curl -sL "$ARTICLE_URL" 2>/dev/null | \
        grep -oP '(?<="brief":" 或者 "").*?(?=","cover")' | \
        head -1 | \
        sed 's/\\n/\n/g' | \
        cut -c1-2000)
    
    # 如果提取失败，使用通用内容
    if [ -z "$CONTENT" ] || [ ${#CONTENT} -lt 50 ]; then
        CONTENT="今日AI速递，请查看原文"
    fi
    
    # 生成封面
    COVER=$(generate_cover) || COVER=""
    
    # 发布
    TITLE="${TODAY_STR} 今日AI必看"
    TAGS='["AI","人工智能","英伟达","小米","OpenClaw"]'
    
    if publish "$TITLE" "$CONTENT" "$COVER" "$TAGS"; then
        log "发布成功！"
    else
        log "发布失败"
        exit 1
    fi
    
    log "========== 监控完成 =========="
}

main "$@"
