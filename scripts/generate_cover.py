#!/usr/bin/env python3
"""
Xiaohongshu Cover Image Generator
Generates professional cover images for Xiaohongshu notes
Usage: python3 generate_cover.py "<title>" <output_path>
"""

from PIL import Image, ImageDraw, ImageFont
import sys
import os

def generate_cover(title, output_path, content_items=None):
    """Generate a Xiaohongshu cover image"""
    
    # Create canvas (3:4 ratio recommended by Xiaohongshu)
    width, height = 900, 1200
    img = Image.new('RGB', (width, height), color='#1a1a2e')
    draw = ImageDraw.Draw(img)
    
    # Draw gradient background
    for y in range(height):
        r = int(26 + (y / height) * 40)
        g = int(26 + (y / height) * 60)
        b = int(46 + (y / height) * 80)
        draw.line([(0, y), (width, y)], fill=(r, g, b))
    
    # Try to load fonts
    try:
        # Try system Chinese fonts
        font_paths = [
            "/usr/share/fonts/truetype/noto/NotoSansCJK-Bold.ttc",
            "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc",
            "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
            "/System/Library/Fonts/PingFang.ttc",  # macOS
        ]
        
        font_title = None
        font_headline = None
        font_body = None
        font_small = None
        
        for path in font_paths:
            if os.path.exists(path):
                font_title = ImageFont.truetype(path, 60)
                font_headline = ImageFont.truetype(path, 42)
                font_body = ImageFont.truetype(path, 28)
                font_small = ImageFont.truetype(path, 24)
                break
        
        if font_title is None:
            raise Exception("No Chinese font found")
            
    except Exception as e:
        print(f"Font loading warning: {e}")
        font_title = ImageFont.load_default()
        font_headline = font_title
        font_body = font_title
        font_small = font_title
    
    # Draw title area
    title_y = 80
    
    # Date
    from datetime import datetime
    date_str = datetime.now().strftime("%Y.%m.%d")
    draw.text((width//2, title_y), date_str, fill='#00d4ff', font=font_title, anchor='mm')
    
    # Main title
    draw.text((width//2, title_y + 70), title, fill='#ffffff', font=font_title, anchor='mm')
    
    # Separator line
    draw.line([(100, 220), (width-100, 220)], fill='#00d4ff', width=3)
    
    # Content area (placeholder - will be filled by user content)
    y_pos = 280
    
    # Default content if none provided
    if content_items is None:
        content_items = [
            ("🔥", "AI前沿资讯", [
                "• 最新AI技术突破",
                "• 行业动态速递"
            ]),
            ("⚡", "科技快讯", [
                "• 算力升级",
                "• 产品发布"
            ]),
        ]
    
    for emoji, headline, bullets in content_items:
        if y_pos > height - 200:  # Leave space for footer
            break
            
        # Headline with emoji
        draw.text((60, y_pos), f"{emoji} {headline}", fill='#ff6b6b', font=font_headline)
        y_pos += 60
        
        # Bullet points
        for bullet in bullets:
            draw.text((80, y_pos), bullet, fill='#e0e0e0', font=font_body)
            y_pos += 45
        
        y_pos += 30  # Space between sections
    
    # Footer
    draw.line([(100, height-120), (width-100, height-120)], fill='#00d4ff', width=2)
    draw.text((width//2, height-70), "#AI #人工智能 #科技前沿", fill='#00d4ff', font=font_small, anchor='mm')
    draw.text((width//2, height-30), "每日AI速递", fill='#888888', font=font_small, anchor='mm')
    
    # Save image
    img.save(output_path, "PNG", quality=95)
    print(f"Cover generated: {output_path}")
    print(f"Size: {width}x{height}")
    
    return output_path

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 generate_cover.py '<title>' <output_path>")
        print("Example: python3 generate_cover.py '今日AI必看' /tmp/cover.png")
        sys.exit(1)
    
    title = sys.argv[1]
    output_path = sys.argv[2]
    
    generate_cover(title, output_path)
