#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
贴图亮度工具集合主入口
包含单张贴图分析和批量贴图扫描功能
"""

import sys
from PyQt5.QtWidgets import QApplication
import TextureChecker
import image_utils
import batch_scanner
import FindTextureBrightness

def launch_texture_checker():
    """启动集成版贴图检查工具"""
    app = QApplication(sys.argv)
    
    # 确保当前工作目录设置正确
    import os
    # 获取脚本所在目录
    current_dir = os.path.dirname(os.path.abspath(__file__))
    # 将工作目录设置为脚本所在目录
    os.chdir(current_dir)
    
    # 加载样式表
    try:
        TextureChecker.load_stylesheet(app)
    except Exception as e:
        print(f"加载样式表失败: {e}")
    
    # 创建并显示主窗口
    window = TextureChecker.TextureChecker()
    window.show()
    
    # 运行应用
    sys.exit(app.exec_())

def launch_finder_tool():
    """启动传统的FindTextureBrightness工具"""
    app = QApplication(sys.argv)
    win = FindTextureBrightness.BrightnessCheckerUI()
    win.show()
    sys.exit(app.exec_())

if __name__ == "__main__":
    # 默认启动集成版工具
    launch_texture_checker()