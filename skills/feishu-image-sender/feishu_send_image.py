#!/usr/bin/env python3
"""
Feishu 图片发送工具
流程：上传图片获取 image_key -> 发送图片消息
"""

import requests
import sys
import json

# Feishu 应用配置
APP_ID = "cli_a9296aa41c785bd7"
APP_SECRET = "v7DZD2BB9nHfLkjqDuFrpjnoNl8NtrZe"

# 获取 tenant_access_token
def get_token():
    url = "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal"
    headers = {"Content-Type": "application/json"}
    data = {"app_id": APP_ID, "app_secret": APP_SECRET}
    
    resp = requests.post(url, headers=headers, json=data)
    result = resp.json()
    
    if result.get("code") == 0:
        return result["tenant_access_token"]
    else:
        raise Exception(f"获取token失败: {result}")

# 上传图片获取 image_key
def upload_image(token, image_path):
    url = "https://open.feishu.cn/open-apis/im/v1/images"
    headers = {"Authorization": f"Bearer {token}"}
    
    with open(image_path, "rb") as f:
        files = {"image": f}
        data = {"image_type": "message"}
        resp = requests.post(url, headers=headers, files=files, data=data)
    
    result = resp.json()
    print(f"上传响应: {json.dumps(result, indent=2)}")
    
    if result.get("code") == 0:
        return result["data"]["image_key"]
    else:
        raise Exception(f"上传图片失败: {result}")

# 发送图片消息
def send_image(token, chat_id, image_key):
    # receive_id_type 需要在 URL 查询参数中，使用 open_id
    url = f"https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=open_id"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    data = {
        "receive_id": chat_id,
        "msg_type": "image",
        "content": json.dumps({"image_key": image_key})
    }
    
    resp = requests.post(url, headers=headers, json=data)
    result = resp.json()
    
    if result.get("code") == 0:
        print("图片发送成功！")
        return True
    else:
        print(f"发送失败: {result}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("用法: python3 feishu_send_image.py <图片路径> <chat_id>")
        sys.exit(1)
    
    image_path = sys.argv[1]
    chat_id = sys.argv[2]
    
    try:
        print(f"正在发送图片: {image_path}")
        token = get_token()
        print("获取token成功")
        
        image_key = upload_image(token, image_path)
        print(f"上传图片成功, image_key: {image_key}")
        
        send_image(token, chat_id, image_key)
    except Exception as e:
        print(f"错误: {e}")
        sys.exit(1)
