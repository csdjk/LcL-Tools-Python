#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
贴图亮度工具启动脚本
"""

import os
import sys

# 获取当前脚本所在目录
current_dir = os.path.dirname(os.path.abspath(__file__))
# 将当前目录添加到Python路径
sys.path.append(current_dir)

# 导入主模块并启动
from main import launch_texture_checker

if __name__ == "__main__":
    launch_texture_checker()