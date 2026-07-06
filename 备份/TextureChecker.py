import numpy as np
import cv2
from PyQt5.QtWidgets import (
    QApplication,
    QLabel,
    QVBoxLayout,
    QHBoxLayout,
    QWidget,
    QLineEdit,
    QCheckBox,
    QSlider,
    QPushButton,
    QButtonGroup,
    QFrame,
    QScrollArea,
    QGridLayout,
    QColorDialog,
    QMessageBox,
    QFileDialog,
    QComboBox,
    QMenu,
    QTabWidget,
    QGroupBox
)
from PyQt5.QtGui import QPixmap, QImage, QColor
from PyQt5.QtCore import Qt, QFile, QTextStream
import imageio.v2 as imageio
import os
import json

# 导入自定义模块
import image_utils
import batch_scanner

# 声明通道按钮样式常量，由于这些需要动态切换，单独处理
CHANNEL_BUTTON_DEFAULT_STYLE = "background-color: none; border: 1px solid gray; padding: 5px;"
CHANNEL_BUTTON_HIGHLIGHT_STYLE = "background-color: lightblue; border: 2px solid blue; padding: 5px;"


# 添加这个函数来加载材质阈值配置
def load_material_thresholds():
    """加载材质阈值配置"""
    default_thresholds = {
        "布料": 0.90,
        "皮肤": 0.87,
        "玉石": 0.82,
        "金属": 0.92
    }
    
    try:
        # 尝试从配置文件加载
        current_dir = os.path.dirname(os.path.abspath(__file__))
        config_path = os.path.join(current_dir, "config", "material_thresholds.json")
        if os.path.exists(config_path):
            with open(config_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        else:
            # 如果配置文件不存在，创建默认配置
            os.makedirs(os.path.join(current_dir, "config"), exist_ok=True)
            with open(config_path, 'w', encoding='utf-8') as f:
                json.dump(default_thresholds, f, ensure_ascii=False, indent=4)
            return default_thresholds
    except Exception as e:
        print(f"加载材质阈值配置失败：{e}")
        return default_thresholds
    
def load_stylesheet(app):
    try:
        current_dir = os.path.dirname(os.path.abspath(__file__))
        qss_path = os.path.join(current_dir, "style", "style.qss")
        with open(qss_path, "r", encoding="utf-8") as f:
            app.setStyleSheet(f.read())
    except Exception as e:
        print(f"加载样式表失败：{e}")



class ColorBox(QFrame):
    """自定义颜色显示框"""
    def __init__(self, color, parent=None):
        super().__init__(parent)
        self.color = color
        self.setFixedSize(20, 20)
        self.setStyleSheet(f"background-color: rgb({color[2]},{color[1]},{color[0]}); border: 1px solid #808080;")

class RegionParamItem(QFrame):
    """区域参数项组件"""
    def __init__(self, region_id, color_value, parent=None):
        super().__init__(parent)
        self.parent_widget = parent
        self.region_id = region_id
        self.color_value = color_value  # 原始色值（0-1之间）
        
        # 加载材质阈值配置
        self.material_thresholds = load_material_thresholds()
        
        # 初始参数值
        self.error_value = 0.05
        self.threshold_value = 0.90
        self.brightness_factor = 1.00
        self.clamp_min = 0.0
        self.clamp_max = 1.0
        
        # 显示颜色值
        color_display = [int(color_value * 255)] * 3  # 灰度值转RGB显示
        
        # 设置外观
        self.setFrameShape(QFrame.StyledPanel)
        
        # 使用网格布局实现更紧凑的UI
        self.grid = QGridLayout(self)
        self.grid.setContentsMargins(8, 8, 8, 8)
        self.grid.setHorizontalSpacing(5)
        self.grid.setVerticalSpacing(1)  # 减小垂直间距
        
        # 创建颜色显示框和删除按钮
        self.color_box = ColorBox(color_display)
        self.remove_button = QPushButton("✕")
        self.remove_button.setFixedSize(20, 20)  # 设置为方形
        self.remove_button.setObjectName("remove_button")
        self.remove_button.clicked.connect(self.remove_item)
        
        # 第一行：颜色框和颜色值信息
        self.grid.addWidget(self.color_box, 0, 0)
        
        # 创建一个标签来显示颜色值和范围
        min_val = max(0.0, self.color_value - self.error_value)
        max_val = min(1.0, self.color_value + self.error_value)
        self.value_info_label = QLabel(f"值: {self.color_value:.2f} (范围: {min_val:.2f} ~ {max_val:.2f})")
        self.grid.addWidget(self.value_info_label, 0, 1, 1, 4)
        
        self.grid.addWidget(self.remove_button, 0, 5)  # 放在最右侧
        
        # 第二行：误差值
        self.grid.addWidget(QLabel("误差:"), 1, 0)
        
        self.error_slider = QSlider(Qt.Horizontal)
        self.error_slider.setMinimum(1)
        self.error_slider.setMaximum(50)
        self.error_slider.setValue(int(self.error_value * 100))
        self.error_slider.valueChanged.connect(self.on_error_slider_changed)
        self.grid.addWidget(self.error_slider, 1, 1, 1, 3)  # 跨越3列
        
        self.error_input = QLineEdit(f"{self.error_value:.2f}")
        self.error_input.setFixedWidth(45)
        self.error_input.textChanged.connect(self.on_error_input_changed)
        self.grid.addWidget(self.error_input, 1, 4)
        
        # 第三行：明度阈值
        self.grid.addWidget(QLabel("阈值:"), 2, 0)
        
        self.threshold_slider = QSlider(Qt.Horizontal)
        self.threshold_slider.setMinimum(0)
        self.threshold_slider.setMaximum(100)
        self.threshold_slider.setValue(int(self.threshold_value * 100))
        self.threshold_slider.valueChanged.connect(self.on_threshold_slider_changed)
        self.grid.addWidget(self.threshold_slider, 2, 1, 1, 3)
        
        self.threshold_input = QLineEdit(f"{self.threshold_value:.2f}")
        self.threshold_input.setFixedWidth(45)
        self.threshold_input.textChanged.connect(self.on_threshold_input_changed)
        self.grid.addWidget(self.threshold_input, 2, 4)
        
        # 阈值预设下拉框
        self.threshold_preset = QComboBox()
        self.threshold_preset.setFixedWidth(60)
        self.threshold_preset.addItem("自定义")
        # 添加材质预设
        for material, value in self.material_thresholds.items():
            self.threshold_preset.addItem(f"{material}")
        self.threshold_preset.currentIndexChanged.connect(self.on_threshold_preset_changed)
        self.grid.addWidget(self.threshold_preset, 2, 5)
        
        # 第四行：亮度系数
        self.grid.addWidget(QLabel("亮度:"), 3, 0)
        
        self.brightness_slider = QSlider(Qt.Horizontal)
        self.brightness_slider.setMinimum(1)
        self.brightness_slider.setMaximum(200)
        self.brightness_slider.setValue(int(self.brightness_factor * 100))
        self.brightness_slider.valueChanged.connect(self.on_brightness_slider_changed)
        self.grid.addWidget(self.brightness_slider, 3, 1, 1, 3)
        
        self.brightness_input = QLineEdit(f"{self.brightness_factor:.2f}")
        self.brightness_input.setFixedWidth(45)
        self.brightness_input.textChanged.connect(self.on_brightness_input_changed)
        self.grid.addWidget(self.brightness_input, 3, 4)
        
        # 第五行：Clamp范围
        self.grid.addWidget(QLabel("Clamp:"), 4, 0)
        
        self.clamp_min_input = QLineEdit(f"{self.clamp_min:.1f}")
        self.clamp_min_input.setFixedWidth(45)
        self.clamp_min_input.textChanged.connect(self.on_clamp_input_changed)
        self.grid.addWidget(self.clamp_min_input, 4, 1)
        
        self.grid.addWidget(QLabel("~"), 4, 2, Qt.AlignCenter)
        
        self.clamp_max_input = QLineEdit(f"{self.clamp_max:.1f}")
        self.clamp_max_input.setFixedWidth(45)
        self.clamp_max_input.textChanged.connect(self.on_clamp_input_changed)
        self.grid.addWidget(self.clamp_max_input, 4, 3)
    
    def update_value_info_label(self):
        """更新颜色值和范围信息标签"""
        min_val = max(0.0, self.color_value - self.error_value)
        max_val = min(1.0, self.color_value + self.error_value)
        self.value_info_label.setText(
            f"值: {self.color_value:.2f} (范围: {min_val:.2f} ~ {max_val:.2f})"
        )
    
    def on_threshold_preset_changed(self, index):
        """处理阈值预设下拉框选择变更"""
        if index == 0:  # "自定义"选项
            return
        
        # 获取选中的材质名称
        material = self.threshold_preset.currentText()
        
        # 设置对应的阈值
        if material in self.material_thresholds:
            value = self.material_thresholds[material]
            self.threshold_value = value
            
            # 更新滑块和输入框
            self.threshold_slider.blockSignals(True)
            self.threshold_slider.setValue(int(value * 100))
            self.threshold_slider.blockSignals(False)
            
            self.threshold_input.blockSignals(True)
            self.threshold_input.setText(f"{value:.2f}")
            self.threshold_input.blockSignals(False)
            
            # 更新预览
            self.parent_widget.update_brightness_preview()
    
    def remove_item(self):
        """删除当前区域项"""
        self.parent_widget.remove_region_item(self.region_id)
    
    def on_error_slider_changed(self, value):
        """误差值滑动条更新处理"""
        self.error_value = value / 100.0
        self.error_input.blockSignals(True)
        self.error_input.setText(f"{self.error_value:.2f}")
        self.error_input.blockSignals(False)
        
        # 更新值信息标签
        self.update_value_info_label()
        
        self.update_region_mask()
    
    def on_error_input_changed(self):
        """误差值输入框更新处理"""
        try:
            value = float(self.error_input.text())
            if value < 0.01:
                value = 0.01
            elif value > 0.50:
                value = 0.50
            
            self.error_value = value
            self.error_slider.blockSignals(True)
            self.error_slider.setValue(int(value * 100))
            self.error_slider.blockSignals(False)
            
            # 更新值信息标签
            self.update_value_info_label()
            
            self.update_region_mask()
        except ValueError:
            pass
    
    def on_threshold_slider_changed(self, value):
        """明度阈值滑动条更新处理"""
        self.threshold_value = value / 100.0
        self.threshold_input.blockSignals(True)
        self.threshold_input.setText(f"{self.threshold_value:.2f}")
        self.threshold_input.blockSignals(False)
        
        # 设置下拉框为"自定义"
        self.threshold_preset.blockSignals(True)
        self.threshold_preset.setCurrentIndex(0)
        self.threshold_preset.blockSignals(False)
        
        self.parent_widget.update_brightness_preview()
    
    def on_threshold_input_changed(self):
        """明度阈值输入框更新处理"""
        try:
            value = float(self.threshold_input.text())
            if value < 0.0:
                value = 0.0
            elif value > 1.0:
                value = 1.0
            
            self.threshold_value = value
            self.threshold_slider.blockSignals(True)
            self.threshold_slider.setValue(int(value * 100))
            self.threshold_slider.blockSignals(False)
            
            # 检查输入的值是否匹配任何预设
            found_match = False
            for i in range(1, self.threshold_preset.count()):
                material = self.threshold_preset.itemText(i)
                if abs(self.material_thresholds[material] - value) < 0.001:
                    self.threshold_preset.blockSignals(True)
                    self.threshold_preset.setCurrentIndex(i)
                    self.threshold_preset.blockSignals(False)
                    found_match = True
                    break
            
            # 如果没有匹配的预设，设置为"自定义"
            if not found_match:
                self.threshold_preset.blockSignals(True)
                self.threshold_preset.setCurrentIndex(0)
                self.threshold_preset.blockSignals(False)
            
            self.parent_widget.update_brightness_preview()
        except ValueError:
            pass
    
    def on_brightness_slider_changed(self, value):
        """亮度系数滑动条更新处理"""
        self.brightness_factor = value / 100.0
        self.brightness_input.blockSignals(True)
        self.brightness_input.setText(f"{self.brightness_factor:.2f}")
        self.brightness_input.blockSignals(False)
        self.parent_widget.update_brightness_preview()
    
    def on_brightness_input_changed(self):
        """亮度系数输入框更新处理"""
        try:
            value = float(self.brightness_input.text())
            if value < 0.01:
                value = 0.01
            elif value > 2.0:
                value = 2.0
            
            self.brightness_factor = value
            self.brightness_slider.blockSignals(True)
            self.brightness_slider.setValue(int(value * 100))
            self.brightness_slider.blockSignals(False)
            self.parent_widget.update_brightness_preview()
        except ValueError:
            pass
    
    def on_clamp_input_changed(self):
        """Clamp范围输入框更新处理"""
        try:
            clamp_min = float(self.clamp_min_input.text())
            clamp_max = float(self.clamp_max_input.text())
            
            if clamp_min > clamp_max:
                clamp_min = clamp_max
                self.clamp_min_input.blockSignals(True)
                self.clamp_min_input.setText(f"{clamp_min:.1f}")
                self.clamp_min_input.blockSignals(False)
            
            if clamp_max < clamp_min:
                clamp_max = clamp_min
                self.clamp_max_input.blockSignals(True)
                self.clamp_max_input.setText(f"{clamp_max:.1f}")
                self.clamp_max_input.blockSignals(False)
            
            self.clamp_min = clamp_min
            self.clamp_max = clamp_max
            self.parent_widget.update_brightness_preview()
        except ValueError:
            pass
    
    def update_region_mask(self):
        """更新该区域的掩码"""
        self.parent_widget.update_specific_region_mask(self.region_id)

class DraggableLabel(QLabel):
    def __init__(self, parent=None, label_type=None):
        super().__init__(parent)
        self.label_type = label_type
        self.setAcceptDrops(True)

    def dragEnterEvent(self, event):
        if event.mimeData().hasUrls():
            event.accept()
        else:
            event.ignore()

    def dropEvent(self, event):
        urls = event.mimeData().urls()
        if urls:
            file_path = urls[0].toLocalFile()
            if self.label_type == "base":
                self.parent().load_base_image(file_path)
            elif self.label_type == "mask":
                self.parent().load_mask_image(file_path)

    def mousePressEvent(self, event):
        """处理鼠标点击事件"""
        if event.button() == Qt.LeftButton and self.label_type == "mask":
            if self.parent().is_picking_color:
                # 吸取颜色值
                self.parent().pick_color_from_mask(event.pos())
                # 退出吸取模式
                self.parent().disable_pick_color_mode()
        elif event.button() == Qt.RightButton:
            # 显示右键菜单
            self.show_context_menu(event.pos())

    def show_context_menu(self, position):
        """显示右键菜单"""
        menu = QMenu(self)
        delete_action = menu.addAction("删除")
        action = menu.exec_(self.mapToGlobal(position))
        if action == delete_action:
            self.delete_image()

    def delete_image(self):
        """删除当前区域图片"""
        if self.label_type == "base":
            self.parent().base_image = None
            self.setPixmap(QPixmap())  # 清空图片显示
            self.setText("固有色图片已删除")
        elif self.label_type == "mask":
            self.parent().mask_image = None
            self.setPixmap(QPixmap())  # 清空图片显示
            self.setText("Mask 图片已删除")
            # 清空区域参数
            for region_id in list(self.parent().region_items.keys()):
                self.parent().remove_region_item(region_id)


class TextureChecker(QWidget):
    def __init__(self):
        super().__init__()
        self.current_mask_channel = "RGB"  # 默认显示RGB
        self.is_picking_color = False      # 初始化吸取模式状态
        self.region_items = {}            # 存储区域参数项
        self.region_masks = {}            # 存储区域的掩码
        self.next_region_id = 0          # 区域ID计数器
        
        # 默认标记颜色为红色
        self.highlight_color = QColor(255, 0, 0)  # RGB值
        
        # 创建批量扫描器
        self.batch_scanner = batch_scanner.BatchScanner()
        
        self.init_ui()

    def init_ui(self):
        self.setWindowTitle("Texture Checker")
        self.resize(800, 800)  # 增加窗口大小以容纳右侧区域参数
        self.setAcceptDrops(True)

        # 主布局
        self.main_layout = QVBoxLayout()
        
        # 创建选项卡控件
        self.tabs = QTabWidget()
        
        # 创建单张图片分析标签页
        self.single_tab = QWidget()
        self.create_single_image_tab()
        self.tabs.addTab(self.single_tab, "单张分析")
        
        # 创建批量扫描标签页
        self.batch_tab = QWidget()
        self.create_batch_scan_tab()
        self.tabs.addTab(self.batch_tab, "批量扫描")
        
        # 将选项卡添加到主布局
        self.main_layout.addWidget(self.tabs)
        
        self.setLayout(self.main_layout)
    
    def create_single_image_tab(self):
        """创建单张图片分析标签页"""
        # 水平布局放置图片区和参数区
        self.single_layout = QHBoxLayout(self.single_tab)

        # 左侧图片和参数区域
        self.left_layout = QVBoxLayout()

        # 图片预览区布局（包含两个图片预览区域）
        self.preview_layout = QHBoxLayout()
        self.preview_layout.setSpacing(10)  # 设置布局间的间距

        # 固有色图片区域
        self.base_layout = QVBoxLayout()
        self.base_layout.setSpacing(2)  # 减小垂直间距

        # 固有色图片标题
        base_title = QLabel("固有色图片区域")
        base_title.setAlignment(Qt.AlignCenter)
        base_title.setProperty("class", "preview_title")  # 添加CSS类名
        self.base_layout.addWidget(base_title)

        # 固有色图片预览
        self.base_image_label = DraggableLabel(self, label_type="base")
        self.base_image_label.setAlignment(Qt.AlignCenter)
        self.base_image_label.setFixedSize(380, 380)
        self.base_image_label.setObjectName("base_image_label")  # 添加ID
        self.base_layout.addWidget(self.base_image_label)

        # 添加明度检查选项在固有色图片下方
        brightness_check_layout = QHBoxLayout()
        
        # 检查明度复选框
        self.check_brightness_checkbox = QCheckBox("检查明度")
        self.check_brightness_checkbox.setChecked(True)
        self.check_brightness_checkbox.stateChanged.connect(self.on_brightness_check_changed)
        brightness_check_layout.addWidget(self.check_brightness_checkbox)
        
        # 颜色选择按钮
        self.highlight_color_button = QPushButton()
        self.highlight_color_button.setFixedSize(24, 24)
        self.highlight_color_button.setToolTip("设置高亮颜色")
        self.update_highlight_color_button()
        self.highlight_color_button.clicked.connect(self.choose_highlight_color)
        brightness_check_layout.addWidget(self.highlight_color_button)
        
        # 查看明度复选框
        self.view_brightness_checkbox = QCheckBox("查看明度")
        self.view_brightness_checkbox.setChecked(False)
        self.view_brightness_checkbox.stateChanged.connect(self.on_view_brightness_changed)
        brightness_check_layout.addWidget(self.view_brightness_checkbox)
        
        brightness_check_layout.addStretch()
        self.base_layout.addLayout(brightness_check_layout)

        # 将固有色区域添加到预览布局
        self.preview_layout.addLayout(self.base_layout)

        # Mask 图片区域
        self.mask_layout = QVBoxLayout()
        self.mask_layout.setSpacing(2)  # 减小垂直间距

        # Mask 图片标题
        mask_title = QLabel("Mask 图片区域")
        mask_title.setAlignment(Qt.AlignCenter)
        mask_title.setProperty("class", "preview_title")  # 添加CSS类名
        self.mask_layout.addWidget(mask_title)

        # Mask 图片预览
        self.mask_image_label = DraggableLabel(self, label_type="mask")
        self.mask_image_label.setAlignment(Qt.AlignCenter)
        self.mask_image_label.setFixedSize(380, 380)
        self.mask_image_label.setObjectName("mask_image_label")  # 添加ID
        self.mask_layout.addWidget(self.mask_image_label)

        # 添加RGBA通道切换按钮
        self.channel_buttons_layout = QHBoxLayout()
        self.channel_buttons_layout.setSpacing(2)  # 减小按钮```python
        # 添加RGBA通道切换按钮
        self.channel_buttons_layout = QHBoxLayout()
        self.channel_buttons_layout.setSpacing(2)  # 减小按钮之间的间隔

        # 创建按钮组
        self.channel_button_group = QButtonGroup(self)

        # 创建RGBA按钮
        self.rgb_button = QPushButton("RGB")
        self.r_button = QPushButton("R")
        self.g_button = QPushButton("G")
        self.b_button = QPushButton("B")
        self.a_button = QPushButton("A")
        
        # 设置按钮的默认样式（这些需要动态切换，不使用QSS方式）
        self.rgb_button.setStyleSheet(CHANNEL_BUTTON_DEFAULT_STYLE)
        self.r_button.setStyleSheet(CHANNEL_BUTTON_DEFAULT_STYLE)
        self.g_button.setStyleSheet(CHANNEL_BUTTON_DEFAULT_STYLE)
        self.b_button.setStyleSheet(CHANNEL_BUTTON_DEFAULT_STYLE)
        self.a_button.setStyleSheet(CHANNEL_BUTTON_DEFAULT_STYLE)
        
        # 连接按钮点击事件
        self.rgb_button.clicked.connect(lambda: self.change_mask_channel("RGB"))
        self.r_button.clicked.connect(lambda: self.change_mask_channel("R"))
        self.g_button.clicked.connect(lambda: self.change_mask_channel("G"))
        self.b_button.clicked.connect(lambda: self.change_mask_channel("B"))
        self.a_button.clicked.connect(lambda: self.change_mask_channel("A"))

        # 添加按钮到按钮组
        self.channel_button_group.addButton(self.rgb_button)
        self.channel_button_group.addButton(self.r_button)
        self.channel_button_group.addButton(self.g_button)
        self.channel_button_group.addButton(self.b_button)
        self.channel_button_group.addButton(self.a_button)

        # 添加按钮到布局
        self.channel_buttons_layout.addWidget(self.rgb_button)
        self.channel_buttons_layout.addWidget(self.r_button)
        self.channel_buttons_layout.addWidget(self.g_button)
        self.channel_buttons_layout.addWidget(self.b_button)
        self.channel_buttons_layout.addWidget(self.a_button)

        # 保存样式引用
        self.default_style = CHANNEL_BUTTON_DEFAULT_STYLE
        self.highlight_style = CHANNEL_BUTTON_HIGHLIGHT_STYLE

        # 默认高亮 RGB 按钮
        self.rgb_button.setStyleSheet(CHANNEL_BUTTON_HIGHLIGHT_STYLE)

        # 添加"吸取"按钮
        self.pick_color_button = QPushButton("吸取")
        self.pick_color_button.clicked.connect(self.enable_pick_color_mode)
        self.channel_buttons_layout.addWidget(self.pick_color_button)
        
        # 将通道切换按钮布局添加到Mask布局
        self.mask_layout.addLayout(self.channel_buttons_layout)

        # 将Mask布局添加到预览布局
        self.preview_layout.addLayout(self.mask_layout)

        # 添加预览布局到左侧布局
        self.left_layout.addLayout(self.preview_layout)

        # 保存和另存为按钮
        save_buttons_layout = QHBoxLayout()
        self.save_button = QPushButton("保存")
        self.save_button.clicked.connect(self.save_image)
        save_buttons_layout.addWidget(self.save_button)

        self.save_as_button = QPushButton("另存为")
        self.save_as_button.clicked.connect(self.save_image_as)
        save_buttons_layout.addWidget(self.save_as_button)
        
        self.left_layout.addLayout(save_buttons_layout)
        
        # 添加左侧布局到主布局
        self.main_layout.addLayout(self.left_layout)
        
        # 右侧区域参数列表
        self.right_layout = QVBoxLayout()
        title_label = QLabel("<b>区域参数列表</b>")
        title_label.setObjectName("region_title_label")
        self.right_layout.addWidget(title_label)
        
        # 创建一个滚动区域来容纳区域参数组
        self.scroll_area = QScrollArea()
        self.scroll_area.setWidgetResizable(True)
        self.scroll_area.setMinimumWidth(400)
        self.scroll_area.setHorizontalScrollBarPolicy(Qt.ScrollBarAlwaysOff)
        
        # 创建一个容器窗口来放置区域参数
        self.region_container = QWidget()
        self.region_layout = QVBoxLayout(self.region_container)
        self.region_layout.setSpacing(4)  # 减小区域项之间的间距
        self.region_layout.setContentsMargins(5, 5, 5, 5)  # 减小边距
        self.region_layout.addStretch()
        
        self.scroll_area.setWidget(self.region_container)
        self.right_layout.addWidget(self.scroll_area)
        
        # 添加右侧布局到主布局
        self.single_layout.addLayout(self.right_layout)
        
    def create_batch_scan_tab(self):
        """创建批量扫描标签页"""
        batch_layout = QVBoxLayout(self.batch_tab)
        
        # 创建路径选择区域
        path_group = QGroupBox("扫描设置")
        path_layout = QVBoxLayout(path_group)
        
        # 文件夹路径选择
        folder_layout = QHBoxLayout()
        folder_layout.addWidget(QLabel("扫描路径:"))
        self.folder_path_edit = QLineEdit()
        folder_layout.addWidget(self.folder_path_edit)
        browse_btn = QPushButton("浏览")
        browse_btn.clicked.connect(self.browse_folder)
        folder_layout.addWidget(browse_btn)
        path_layout.addLayout(folder_layout)
        
        # 阈值设置区域
        threshold_layout = QHBoxLayout()
        threshold_layout.addWidget(QLabel("亮度阈值:"))
        
        # 添加阈值滑块
        self.threshold_slider = QSlider(Qt.Horizontal)
        self.threshold_slider.setMinimum(70)
        self.threshold_slider.setMaximum(100)
        self.threshold_slider.setValue(92)
        self.threshold_slider.valueChanged.connect(self.on_threshold_slider_changed)
        threshold_layout.addWidget(self.threshold_slider)
        
        # 添加阈值输入框
        self.threshold_input = QLineEdit("0.92")
        self.threshold_input.setFixedWidth(50)
        self.threshold_input.textChanged.connect(self.on_threshold_input_changed)
        threshold_layout.addWidget(self.threshold_input)
        
        # 添加阈值预设下拉框
        self.threshold_preset = QComboBox()
        self.threshold_preset.setFixedWidth(80)
        self.threshold_preset.addItem("自定义")
        
        # 加载材质阈值配置
        material_thresholds = load_material_thresholds()
        for material, value in material_thresholds.items():
            self.threshold_preset.addItem(f"{material}")
        self.threshold_preset.currentIndexChanged.connect(self.on_batch_threshold_preset_changed)
        threshold_layout.addWidget(self.threshold_preset)
        
        path_layout.addLayout(threshold_layout)
        
        # 添加输出文件选择
        output_layout = QHBoxLayout()
        output_layout.addWidget(QLabel("结果输出:"))
        self.output_path_edit = QLineEdit(os.path.join(os.getcwd(), "exceed_brightness.txt"))
        output_layout.addWidget(self.output_path_edit)
        output_browse_btn = QPushButton("浏览")
        output_browse_btn.clicked.connect(self.browse_output_file)
        output_layout.addWidget(output_browse_btn)
        path_layout.addLayout(output_layout)
        
        batch_layout.addWidget(path_group)
        
        # 创建操作按钮区域
        action_layout = QHBoxLayout()
        
        # 开始扫描按钮
        start_scan_btn = QPushButton("开始扫描")
        start_scan_btn.clicked.connect(self.start_batch_scan)
        action_layout.addWidget(start_scan_btn)
        
        # 添加批量处理按钮
        process_btn = QPushButton("批量处理")
        process_btn.setToolTip("批量处理超出阈值的像素")
        process_btn.clicked.connect(self.start_batch_process)
        action_layout.addWidget(process_btn)
        
        # 添加查看结果按钮
        view_result_btn = QPushButton("查看结果")
        view_result_btn.clicked.connect(self.view_scan_result)
        action_layout.addWidget(view_result_btn)
        
        batch_layout.addLayout(action_layout)
        
        # 创建结果显示区域
        result_group = QGroupBox("扫描结果")
        result_layout = QVBoxLayout(result_group)
        
        self.result_label = QLabel("未开始扫描")
        result_layout.addWidget(self.result_label)
        
        # 创建结果列表区域（滚动区域）
        self.result_scroll = QScrollArea()
        self.result_scroll.setWidgetResizable(True)
        self.result_container = QWidget()
        self.result_list_layout = QVBoxLayout(self.result_container)
        self.result_scroll.setWidget(self.result_container)
        result_layout.addWidget(self.result_scroll)
        
        batch_layout.addWidget(result_group)

    # 添加颜色选择按钮的样式更新方法
    def update_highlight_color_button(self):
        """更新高亮颜色按钮的背景色"""
        self.highlight_color_button.setStyleSheet(
            f"background-color: rgb({self.highlight_color.red()}, "
            f"{self.highlight_color.green()}, {self.highlight_color.blue()}); "
            f"border: 1px solid #808080;"
        )

    # 添加颜色选择对话框方法
    def choose_highlight_color(self):
        """打开颜色选择器选择高亮颜色"""
        color = QColorDialog.getColor(self.highlight_color, self, "选择高亮颜色")
        if color.isValid():
            self.highlight_color = color
            self.update_highlight_color_button()
            self.update_brightness_preview()

    # 添加查看明度复选框状态变更处理方法
    def on_view_brightness_changed(self):
        """处理查看明度复选框状态变更"""
        if hasattr(self, "temp_hsv_image"):
            self.update_brightness_preview()

    # 更新on_brightness_check_changed方法
    def on_brightness_check_changed(self):
        """处理检查明度复选框状态变更"""
        if hasattr(self, "temp_hsv_image"):
            self.update_brightness_preview()
            
    def enable_pick_color_mode(self):
        """启用吸取模式"""
        if not hasattr(self, "mask_image"):
            QMessageBox.warning(self, "警告", "请先加载 Mask 图片！")
            return

        if self.current_mask_channel == "RGB":
            QMessageBox.warning(self, "警告", "请切换到单通道模式（R/G/B/A）进行吸取！")
            return
            
        # 设置鼠标指针为吸取图标
        self.setCursor(Qt.CrossCursor)  # 使用十字光标作为吸取图标
        self.is_picking_color = True
    
    def disable_pick_color_mode(self):
        """退出吸取模式"""
        self.setCursor(Qt.ArrowCursor)  # 恢复默认鼠标指针
        self.is_picking_color = False
           
    def pick_color_from_mask(self, pos):
        """从 Mask 图片中吸取颜色值"""
        if not hasattr(self, "mask_image"):
            QMessageBox.warning(self, "警告", "没有加载 Mask 图片！")
            return

        # 获取 QLabel 的尺寸和图片的尺寸
        label_width, label_height = self.mask_image_label.width(), self.mask_image_label.height()
        image_height, image_width = self.mask_image.shape[:2]

        # 计算点击位置在图片中的对应坐标
        x = int(pos.x() * image_width / label_width)
        y = int(pos.y() * image_height / label_height)

        # 确保坐标在图片范围内
        if x < 0 or x >= image_width or y < 0 or y >= image_height:
            return

        # 获取当前通道的值
        if self.current_mask_channel == "RGB":
            QMessageBox.warning(self, "警告", "请切换到单通道模式（R/G/B/A）进行吸取！")
            return
        elif self.current_mask_channel == "R":
            value = self.mask_image[y, x, 2] / 255.0  # R 通道
        elif self.current_mask_channel == "G":
            value = self.mask_image[y, x, 1] / 255.0  # G 通道
        elif self.current_mask_channel == "B":
            value = self.mask_image[y, x, 0] / 255.0  # B 通道
        elif self.current_mask_channel == "A" and self.mask_image.shape[2] == 4:
            value = self.mask_image[y, x, 3] / 255.0  # A 通道
        else:
            QMessageBox.warning(self, "警告", "当前通道不支持吸取！")
            return

        # 检查是否已经存在相同值的区域
        for region_id, item in self.region_items.items():
            if abs(item.color_value - value) < 0.01:
                QMessageBox.information(self, "提示", "已存在相似颜色值的区域！")
                return

        # 设置吸取的值
        self.picked_value = value
        
        # 创建新的区域参数项
        self.add_new_region_item(value)
    
    def add_new_region_item(self, color_value):
        """添加新的区域参数项"""
        region_id = self.next_region_id
        self.next_region_id += 1
        
        # 创建新的区域参数项
        region_item = RegionParamItem(region_id, color_value, self)
        
        # 添加到区域参数字典
        self.region_items[region_id] = region_item
        
        # 添加到UI
        self.region_layout.insertWidget(0, region_item)
        
        # 如果超过8个，移除最旧的那个
        if len(self.region_items) > 8:
            oldest_id = min(self.region_items.keys())
            self.remove_region_item(oldest_id)
        
        # 生成该区域的掩码
        self.update_specific_region_mask(region_id)
        
        # 更新预览
        self.update_brightness_preview()
    
    def remove_region_item(self, region_id):
        """移除指定区域参数项"""
        if region_id in self.region_items:
            # 从UI中移除
            region_item = self.region_items[region_id]
            self.region_layout.removeWidget(region_item)
            region_item.deleteLater()
            
            # 从字典中移除
            del self.region_items[region_id]
            
            # 从掩码字典中移除
            if region_id in self.region_masks:
                del self.region_masks[region_id]
            
            # 更新预览
            self.update_brightness_preview()
    
    def update_specific_region_mask(self, region_id):
        """更新特定区域的掩码"""
        if not hasattr(self, "mask_image") or region_id not in self.region_items:
            return
                
        region_item = self.region_items[region_id]
        
        # 获取当前通道的值
        if self.current_mask_channel == "R":
            channel = self.mask_image[:, :, 2] / 255.0  # R 通道
        elif self.current_mask_channel == "G":
            channel = self.mask_image[:, :, 1] / 255.0  # G 通道
        elif self.current_mask_channel == "B":
            channel = self.mask_image[:, :, 0] / 255.0  # B 通道
        elif self.current_mask_channel == "A" and self.mask_image.shape[2] == 4:
            channel = self.mask_image[:, :, 3] / 255.0  # A 通道
        else:
            return

        # 检查是否有基础图像作为参考尺寸
        target_shape = None
        if hasattr(self, "base_image") and self.base_image is not None:
            target_shape = self.base_image.shape[:2]
        elif hasattr(self, "temp_hsv_image"):
            target_shape = self.temp_hsv_image.shape[:2]
            
        # 获取误差值
        error_value = region_item.error_value
        
        # 根据吸取的范围生成布尔掩码
        color_value = region_item.color_value
        min_val, max_val = color_value - error_value, color_value + error_value
        region_mask = (channel >= max(0.0, min_val)) & (channel <= min(1.0, max_val))
        
        # 如果尺寸不匹配，进行缩放处理
        if target_shape is not None and region_mask.shape != target_shape:
            region_mask = cv2.resize(
                region_mask.astype(np.uint8), 
                (target_shape[1], target_shape[0]),
                interpolation=cv2.INTER_NEAREST
            ).astype(bool)
        
        # 保存区域掩码
        self.region_masks[region_id] = region_mask
        
        # 更新预览
        self.update_brightness_preview()
    
    def on_brightness_check_changed(self):
        if hasattr(self, "temp_hsv_image"):
            self.update_brightness_preview()

    def hsv_to_bgr(self, hsv_image):
        """将HSV图像转换回BGR格式"""
        rgb_image = cv2.cvtColor(hsv_image, cv2.COLOR_HSV2RGB)
        return rgb_image[:, :, [2, 1, 0]]

    def update_specific_region_mask(self, region_id):
        """更新特定区域的掩码"""
        if not hasattr(self, "mask_image") or region_id not in self.region_items:
            return
                
        region_item = self.region_items[region_id]
        
        # 获取当前通道的值
        if self.current_mask_channel == "R":
            channel = self.mask_image[:, :, 2] / 255.0  # R 通道
        elif self.current_mask_channel == "G":
            channel = self.mask_image[:, :, 1] / 255.0  # G 通道
        elif self.current_mask_channel == "B":
            channel = self.mask_image[:, :, 0] / 255.0  # B 通道
        elif self.current_mask_channel == "A" and self.mask_image.shape[2] == 4:
            channel = self.mask_image[:, :, 3] / 255.0  # A 通道
        else:
            return

        # 获取误差值
        error_value = region_item.error_value
        
        # 根据吸取的范围生成布尔掩码
        color_value = region_item.color_value
        min_val, max_val = color_value - error_value, color_value + error_value
        region_mask = (channel >= max(0.0, min_val)) & (channel <= min(1.0, max_val))
        
        # 保存区域掩码
        self.region_masks[region_id] = region_mask
        
        # 更新预览
        self.update_brightness_preview()

    def apply_brightness_adjustments(self, v_channel):
        """
        对明度通道应用所有区域的亮度调整

        参数:
        v_channel: 归一化的明度通道 (0-1范围)

        返回:
        调整后的明度通道 (0-1范围)
        """
        # 如果有区域参数
        if self.region_items:
            # 创建一个全为 False 的掩码，用于记录已处理的像素
            processed_mask = np.zeros_like(v_channel, dtype=bool)
            
            # 分别处理每个区域
            for region_id, region_item in self.region_items.items():
                if region_id in self.region_masks:
                    region_mask = self.region_masks[region_id]
                    
                    # 确保区域掩码与当前通道尺寸一致
                    if region_mask.shape != v_channel.shape:
                        # 如果尺寸不匹配，调整掩码尺寸
                        region_mask = cv2.resize(
                            region_mask.astype(np.uint8), 
                            (v_channel.shape[1], v_channel.shape[0]),
                            interpolation=cv2.INTER_NEAREST
                        ).astype(bool)
                        # 更新掩码缓存
                        self.region_masks[region_id] = region_mask
                    
                    # 只处理尚未处理的像素
                    current_mask = region_mask & (~processed_mask)
                    
                    # 应用该区域的参数
                    brightness_factor = region_item.brightness_factor
                    clamp_min = region_item.clamp_min
                    clamp_max = region_item.clamp_max
                    
                    # 调整明度通道
                    v_channel[current_mask] *= brightness_factor
                    v_channel[current_mask] = np.clip(v_channel[current_mask], clamp_min, clamp_max)
                    
                    # 更新已处理掩码
                    processed_mask |= current_mask

        return v_channel
        
        
    def create_full_image_region(self):
        """创建一个覆盖全图的区域项"""
        # 检查是否已经存在全图区域item
        for region_id, item in self.region_items.items():
            if hasattr(item, "is_full_image_region") and item.is_full_image_region:
                return  # 已经存在，不需要重复创建
        
        # 创建一个覆盖全图的区域项
        region_id = self.next_region_id
        self.next_region_id += 1
        
        # 创建区域参数项，默认值0.5（中等灰度）
        region_item = RegionParamItem(region_id, 0.5, self)
        # 标记为全图区域item
        region_item.is_full_image_region = True
        
        # 添加到区域参数字典
        self.region_items[region_id] = region_item
        
        # 添加到UI
        self.region_layout.insertWidget(0, region_item)
        
        # 如果有base_image，创建全图掩码
        if hasattr(self, "base_image") and self.base_image is not None:
            # 创建全图mask（所有像素都为True）
            full_mask = np.ones(self.base_image.shape[:2], dtype=bool)
            self.region_masks[region_id] = full_mask
            
            # 更新预览
            self.update_brightness_preview()
    
    def remove_full_image_region(self):
        """删除全图区域的item（如果存在）"""
        # 查找并删除全图区域item
        for region_id, item in list(self.region_items.items()):
            if hasattr(item, "is_full_image_region") and item.is_full_image_region:
                self.remove_region_item(region_id)
                break
                
    def update_brightness_preview(self):
        """更新亮度预览，根据当前UI设置决定显示方式"""
        if not hasattr(self, "temp_hsv_image"):
            return
        
        # 获取当前的HSV图像的副本
        hsv_preview = self.temp_hsv_image.copy()
        
        # 获取明度通道并归一化到0-1范围
        v_channel = hsv_preview[:, :, 2] / 255.0
        
        # 应用亮度调整
        v_channel = self.apply_brightness_adjustments(v_channel)
        
        # 转回伽马空间
        v_channel_gamma = image_utils.linear_to_gamma(v_channel)
        
        # 检查是否有区域超过明度阈值
        exceeded_mask = np.zeros_like(v_channel, dtype=bool)
        
        for region_id, region_item in self.region_items.items():
            if region_id in self.region_masks:
                # 获取该区域的明度阈值
                threshold = region_item.threshold_value
                
                # 该区域内明度超过阈值的部分
                current_exceeded = (v_channel > threshold) & self.region_masks[region_id]
                
                # 更新总的超出阈值掩码
                exceeded_mask |= current_exceeded
        
        # 处理HSV根据当前的UI设置
        if self.view_brightness_checkbox.isChecked():
            # 查看明度模式 - 显示灰度明度图像
            preview_image = np.zeros((hsv_preview.shape[0], hsv_preview.shape[1], 3), dtype=np.uint8)
            
            # 将明度值复制到所有颜色通道上形成灰度图
            v_channel_display = (v_channel_gamma * 255).astype(np.uint8)
            preview_image[:, :, 0] = v_channel_display
            preview_image[:, :, 1] = v_channel_display
            preview_image[:, :, 2] = v_channel_display
            
            # 如果同时勾选了检查明度，在灰度图上标记超过阈值的部分
            if self.check_brightness_checkbox.isChecked() and np.any(exceeded_mask):
                # 获取用户选择的高亮颜色
                b_color = self.highlight_color.blue()
                g_color = self.highlight_color.green()
                r_color = self.highlight_color.red()
                
                # 将超出阈值的区域标记为用户选择的颜色
                preview_image[exceeded_mask, 0] = b_color  # B通道
                preview_image[exceeded_mask, 1] = g_color  # G通道
                preview_image[exceeded_mask, 2] = r_color  # R通道
        else:
            # 普通模式 - 显示处理后的彩色图像
            hsv_preview[:, :, 2] = (v_channel * 255).astype(np.uint8)
            preview_image = self.hsv_to_bgr(hsv_preview)
            
            # 转换为伽马空间
            preview_image = (image_utils.linear_to_gamma(preview_image / 255.0) * 255).astype(np.uint8)
            
            # 如果勾选了检查明度，在彩色图上标记超过阈值的部分
            if self.check_brightness_checkbox.isChecked() and np.any(exceeded_mask):
                # 获取用户选择的高亮颜色
                b_color = self.highlight_color.blue()
                g_color = self.highlight_color.green()
                r_color = self.highlight_color.red()
                
                # 将超出阈值的区域标记为用户选择的颜色
                preview_image[exceeded_mask, 0] = b_color  # B通道
                preview_image[exceeded_mask, 1] = g_color  # G通道
                preview_image[exceeded_mask, 2] = r_color  # R通道
        
        # 更新预览
        self.update_preview(preview_image, self.base_image_label)

    def get_processed_image(self):
        """获取处理后的图像，应用所有亮度调整并转换回伽马空间"""
        if not hasattr(self, "temp_hsv_image"):
            return None
            
        # 获取当前的HSV图像的副本
        hsv_processed = self.temp_hsv_image.copy()
        
        # 获取明度通道并归一化到0-1范围
        v_channel = hsv_processed[:, :, 2] / 255.0
        
        # 应用亮度调整
        v_channel = self.apply_brightness_adjustments(v_channel)
        
        # 更新HSV图像的V通道
        hsv_processed[:, :, 2] = (v_channel * 255).astype(np.uint8)
        
        # 将HSV转换回BGR
        processed_bgr = self.hsv_to_bgr(hsv_processed)
        
        # 转换为伽马空间 (线性空间 -> 伽马空间)
        # 首先将BGR图像归一化到0-1
        processed_bgr_norm = processed_bgr / 255.0
        # 应用线性到伽马的转换
        gamma_corrected_image = image_utils.linear_to_gamma(processed_bgr_norm)
        # 转回0-255范围并转为uint8类型
        gamma_corrected_image = (gamma_corrected_image * 255).astype(np.uint8)
        
        return gamma_corrected_image


    def change_mask_channel(self, channel):
        self.current_mask_channel = channel
        # 重置所有按钮的样式为默认样式
        self.rgb_button.setStyleSheet(self.default_style)
        self.r_button.setStyleSheet(self.default_style)
        self.g_button.setStyleSheet(self.default_style)
        self.b_button.setStyleSheet(self.default_style)
        self.a_button.setStyleSheet(self.default_style)

        # 根据当前通道高亮对应按钮
        if channel == "RGB":
            self.rgb_button.setStyleSheet(self.highlight_style)
        elif channel == "R":
            self.r_button.setStyleSheet(self.highlight_style)
        elif channel == "G":
            self.g_button.setStyleSheet(self.highlight_style)
        elif channel == "B":
            self.b_button.setStyleSheet(self.highlight_style)
        elif channel == "A":
            self.a_button.setStyleSheet(self.highlight_style)

        # 更新 Mask 预览
        if hasattr(self, "mask_image"):
            self.update_mask_preview()
        
        # 清空区域参数（因为通道更改后需要重新吸取）
        for region_id in list(self.region_items.keys()):
            self.remove_region_item(region_id)

    def update_mask_preview(self):
        if not hasattr(self, "mask_image"):
            return

        if self.current_mask_channel == "RGB":
            # 显示RGB通道
            if self.mask_image.shape[2] == 4:  # 如果有Alpha通道
                display_image = self.mask_image[:, :, :3].copy()
            else:
                display_image = self.mask_image.copy()
        elif self.current_mask_channel == "R":
            # 显示R通道
            r_channel = self.mask_image[:, :, 2].copy()  # OpenCV中是BGR顺序
            display_image = np.zeros_like(self.mask_image[:, :, :3])
            display_image[:, :, 2] = r_channel  # 在R通道显示
        elif self.current_mask_channel == "G":
            # 显示G通道
            g_channel = self.mask_image[:, :, 1].copy()
            display_image = np.zeros_like(self.mask_image[:, :, :3])
            display_image[:, :, 1] = g_channel  # 在G通道显示
        elif self.current_mask_channel == "B":
            # 显示B通道
            b_channel = self.mask_image[:, :, 0].copy()
            display_image = np.zeros_like(self.mask_image[:, :, :3])
            display_image[:, :, 0] = b_channel  # 在B通道显示
        elif self.current_mask_channel == "A" and self.mask_image.shape[2] == 4:
            # 显示Alpha通道
            a_channel = self.mask_image[:, :, 3].copy()
            # 将Alpha通道显示为灰度图像(复制到所有通道)
            display_image = np.zeros_like(self.mask_image[:, :, :3])
            display_image[:, :, 0] = a_channel
            display_image[:, :, 1] = a_channel
            display_image[:, :, 2] = a_channel
        else:
            # 默认显示RGB
            if self.mask_image.shape[2] == 4:  # 如果有Alpha通道
                display_image = self.mask_image[:, :, :3].copy()
            else:
                display_image = self.mask_image.copy()

        self.update_preview(display_image, self.mask_image_label)

    def browse_folder(self):
        """浏览并选择要扫描的文件夹"""
        folder = QFileDialog.getExistingDirectory(self, "选择要扫描的文件夹")
        if folder:
            self.folder_path_edit.setText(folder)
    
    def browse_output_file(self):
        """浏览并选择结果输出文件"""
        file_path, _ = QFileDialog.getSaveFileName(self, "保存扫描结果", "", "文本文件 (*.txt)")
        if file_path:
            self.output_path_edit.setText(file_path)
    
    def on_threshold_slider_changed(self, value):
        """批量扫描阈值滑块值改变的处理"""
        threshold = value / 100.0
        self.threshold_input.blockSignals(True)
        self.threshold_input.setText(f"{threshold:.2f}")
        self.threshold_input.blockSignals(False)
        
        # 设置下拉框为"自定义"
        self.threshold_preset.blockSignals(True)
        self.threshold_preset.setCurrentIndex(0)
        self.threshold_preset.blockSignals(False)
    
    def on_threshold_input_changed(self):
        """批量扫描阈值输入框值改变的处理"""
        try:
            value = float(self.threshold_input.text())
            if 0 <= value <= 1:
                self.threshold_slider.blockSignals(True)
                self.threshold_slider.setValue(int(value * 100))
                self.threshold_slider.blockSignals(False)
                
                # 检查输入的值是否匹配任何预设
                material_thresholds = load_material_thresholds()
                found_match = False
                
                for i in range(1, self.threshold_preset.count()):
                    material = self.threshold_preset.itemText(i)
                    if abs(material_thresholds[material] - value) < 0.001:
                        self.threshold_preset.blockSignals(True)
                        self.threshold_preset.setCurrentIndex(i)
                        self.threshold_preset.blockSignals(False)
                        found_match = True
                        break
                
                # 如果没有匹配的预设，设置为"自定义"
                if not found_match:
                    self.threshold_preset.blockSignals(True)
                    self.threshold_preset.setCurrentIndex(0)
                    self.threshold_preset.blockSignals(False)
        except ValueError:
            pass
    
    def on_batch_threshold_preset_changed(self, index):
        """批量扫描阈值预设下拉框选择变更"""
        if index == 0:  # "自定义"选项
            return
        
        # 获取选中的材质名称
        material = self.threshold_preset.currentText()
        
        # 设置对应的阈值
        material_thresholds = load_material_thresholds()
        if material in material_thresholds:
            value = material_thresholds[material]
            
            # 更新滑块和输入框
            self.threshold_slider.blockSignals(True)
            self.threshold_slider.setValue(int(value * 100))
            self.threshold_slider.blockSignals(False)
            
            self.threshold_input.blockSignals(True)
            self.threshold_input.setText(f"{value:.2f}")
            self.threshold_input.blockSignals(False)
    
    def start_batch_scan(self):
        """开始批量扫描图片"""
        folder = self.folder_path_edit.text().strip()
        if not folder or not os.path.isdir(folder):
            QMessageBox.warning(self, "提示", "请选择有效的文件夹路径！")
            return
        
        # 获取当前阈值
        try:
            threshold = float(self.threshold_input.text())
        except ValueError:
            threshold = 0.92
        
        # 获取输出文件路径
        output_path = self.output_path_edit.text().strip()
        if not output_path:
            output_path = os.path.join(os.getcwd(), "exceed_brightness.txt")
        
        # 开始扫描
        out_txt, count = self.batch_scanner.scan_folder(folder, threshold, output_path, self)
        
        # 显示扫描结果
        self.result_label.setText(f"扫描完成: 共找到 {count} 个超出阈值的图片")
        
        # 直接在UI中显示结果，不弹窗
        if count > 0:
            # 自动加载并显示结果
            self.display_scan_results(out_txt)
        
    def start_batch_process(self):
        """开始批量处理超出阈值的图片"""
        folder = self.folder_path_edit.text().strip()
        if not folder or not os.path.isdir(folder):
            QMessageBox.warning(self, "提示", "请选择有效的文件夹路径！")
            return
        
        # 获取当前阈值
        try:
            threshold = float(self.threshold_input.text())
        except ValueError:
            threshold = 0.92
        
        # 弹出确认对话框
        reply = QMessageBox.warning(
            self,
            "确认批量处理",
            "即将对文件夹中超出阈值的贴图进行曲线映射处理，\n"
            f"应用公式: (1-(x-{threshold:.2f}))*x\n\n"
            "处理后的图片将替换原图，此操作不可恢复！\n\n"
            "确定要继续吗？",
            QMessageBox.Yes | QMessageBox.No,
            QMessageBox.No
        )
        
        if reply != QMessageBox.Yes:
            return
        
        # 开始批量处理
        processed_count, success_count = self.batch_scanner.process_folder(folder, threshold, self)
        
        # 更新结果标签
        self.result_label.setText(f"批量处理完成: 共处理 {processed_count} 张图片，成功 {success_count} 张")
        
        # 如果有输出文件路径，重新扫描一次以更新结果
        output_path = self.output_path_edit.text().strip()
        if output_path:
            # 再次扫描以更新结果列表
            out_txt, count = self.batch_scanner.scan_folder(folder, threshold, output_path, self)
            if count > 0:
                self.display_scan_results(out_txt)
            else:
                # 清空结果列表
                while self.result_list_layout.count():
                    item = self.result_list_layout.takeAt(0)
                    if item.widget():
                        item.widget().deleteLater()
                # 添加一个弹性空间
                self.result_list_layout.addStretch()
    
    def display_scan_results(self, result_file):
        """显示扫描结果"""
        # 清空旧结果
        while self.result_list_layout.count():
            item = self.result_list_layout.takeAt(0)
            if item.widget():
                item.widget().deleteLater()
        
        # 设置布局间距为0，使列表更紧凑
        self.result_list_layout.setSpacing(0)
        
        # 读取结果文件
        try:
            with open(result_file, "r", encoding="utf-8") as f:
                lines = f.readlines()
            
            # 如果没有结果，显示提示信息
            if not lines:
                no_result_label = QLabel("没有找到超出阈值的图片")
                no_result_label.setAlignment(Qt.AlignCenter)
                self.result_list_layout.addWidget(no_result_label)
            else:
                # 添加结果数量标签
                count_label = QLabel(f"找到 {len(lines)} 个超出阈值的图片:")
                count_label.setStyleSheet("font-weight: bold;")
                self.result_list_layout.addWidget(count_label)
                
                # 添加结果项
                for line in lines:
                    path = line.strip()
                    if path:
                        item_widget = QWidget()
                        item_layout = QHBoxLayout(item_widget)
                        # 减小项目的内边距，使内容更紧凑
                        item_layout.setContentsMargins(1, 1, 1, 1)
                        # 设置水平间距更小
                        item_layout.setSpacing(4)
                        
                        # 显示文件名，并设置完整路径为工具提示
                        path_label = QLabel(os.path.basename(path))
                        path_label.setToolTip(path)
                        # 如果文件名太长，显示省略号
                        path_label.setMaximumWidth(300)
                        path_label.setMinimumWidth(200)
                        path_label.setTextInteractionFlags(Qt.TextSelectableByMouse)
                        item_layout.addWidget(path_label)
                        
                        # 添加弹性空间
                        item_layout.addStretch()
                        
                        # 查看按钮
                        view_btn = QPushButton("查看")
                        view_btn.setFixedWidth(50)
                        view_btn.setFixedHeight(22)  # 减小按钮高度
                        view_btn.clicked.connect(lambda checked, p=path: self.load_result_image(p))
                        
                        btn_font = view_btn.font()
                        btn_font.setPointSize(8)  # 设置较小的字体大小
                        view_btn.setFont(btn_font) 
                        item_layout.addWidget(view_btn)
                        
                        # 减小项目widget的高度，使列表更紧凑
                        item_widget.setFixedHeight(24)
                        self.result_list_layout.addWidget(item_widget)
            
            # 添加一个弹性空间
            self.result_list_layout.addStretch()
            
        except Exception as e:
            QMessageBox.warning(self, "警告", f"读取结果文件失败: {str(e)}")
    
    def load_result_image(self, path):
        """加载结果图片进行查看"""
        self.tabs.setCurrentIndex(0)  # 切换到单张分析标签页
        self.load_base_image(path)
    
    def view_scan_result(self):
        """查看扫描结果文件"""
        path = self.output_path_edit.text().strip()
        if path and os.path.exists(path):
            try:
                import subprocess
                import platform
                
                if platform.system() == "Windows":
                    os.startfile(path)
                elif platform.system() == "Darwin":  # macOS
                    subprocess.call(["open", path])
                else:  # Linux
                    subprocess.call(["xdg-open", path])
            except Exception as e:
                QMessageBox.warning(self, "警告", f"无法打开文件: {str(e)}")
        else:
            QMessageBox.warning(self, "提示", "结果文件不存在！")
    
    
    def load_base_image(self, file_path):
        """加载固有色图片"""
        try:
            # 读取图像
            self.base_image = image_utils.load_image(file_path)
            if self.base_image is None:
                QMessageBox.warning(self, "警告", f"无法打开图像文件: {file_path}")
                return
            
            # 转换为线性空间
            self.temp_linear_image = image_utils.gamma_to_linear(self.base_image / 255.0)
            rgb_linear = self.temp_linear_image[:, :, [2, 1, 0]]  # BGR -> RGB
            
            # 转换为HSV
            # self.temp_hsv_image = cv2.cvtColor(rgb_linear, cv2.COLOR_BGR2HSV)
            self.temp_hsv_image = cv2.cvtColor((rgb_linear * 255).astype(np.uint8), cv2.COLOR_RGB2HSV)
            
            # 保存路径
            self.base_image_path = file_path
            
            # 调整图像显示
            max_size = 380
            height, width = self.base_image.shape[:2]
            scale = max_size / max(height, width)
            
            # 计算缩放后的尺寸
            display_width = int(width * scale)
            display_height = int(height * scale)
            
            # 缩放图像
            display_img = cv2.resize(self.base_image, (display_width, display_height))
            
            # 转换为QPixmap
            qimg = QImage(display_img.data, display_width, display_height, 
                        display_img.strides[0], QImage.Format_BGR888)
            pixmap = QPixmap.fromImage(qimg)
            
            # 清空提示文本
            self.base_image_label.clear()
            self.base_image_label.setPixmap(pixmap)
            
            # 更新明度预览
            self.update_brightness_preview()
            
            # 检查是否有mask图像，如果没有，创建一个全区域item
            if not hasattr(self, "mask_image") or self.mask_image is None:
                # 创建全区域item
                self.create_full_image_region()
            
        except Exception as e:
            QMessageBox.warning(self, "警告", f"加载图像时发生错误: {str(e)}")

    def load_mask_image(self, file_path):
        """加载Mask图片"""
        try:
            # 读取图像
            self.mask_image = image_utils.load_image(file_path)
            
            if self.mask_image is None:
                QMessageBox.warning(self, "警告", f"无法打开图像文件: {file_path}")
                return
            
            # 保存路径
            self.mask_image_path = file_path
            
            # 调整图像显示
            max_size = 380
            height, width = self.mask_image.shape[:2]
            scale = max_size / max(height, width)
            
            # 计算缩放后的尺寸
            display_width = int(width * scale)
            display_height = int(height * scale)
            
            # 缩放图像
            display_img = cv2.resize(self.mask_image, (display_width, display_height))
            
            # 转换为QPixmap
            if self.mask_image.shape[2] == 4:
                qimg = QImage(display_img.data, display_width, display_height, 
                            display_img.strides[0], QImage.Format_BGRA8888)
            else:
                qimg = QImage(display_img.data, display_width, display_height, 
                            display_img.strides[0], QImage.Format_BGR888)
            pixmap = QPixmap.fromImage(qimg)
            
            # 清空提示文本
            self.mask_image_label.clear()
            self.mask_image_label.setPixmap(pixmap)
            
            # 显示RGB通道
            self.change_mask_channel("RGB")
            
            # 当加载mask图片时，删除全区域item
            self.remove_full_image_region()
            
        except Exception as e:
            QMessageBox.warning(self, "警告", f"加载图像时发生错误: {str(e)}")

    def update_preview(self, image, label):
        height, width, channel = image.shape

        # 将BGR转换为RGB以便Qt正确显示
        converted = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        bytes_per_line = 3 * width
        q_image = QImage(
            converted.data, width, height, bytes_per_line, QImage.Format_RGB888
        )

        pixmap = QPixmap.fromImage(q_image)
        # 缩放图片以适应QLabel的大小，保持宽高比
        scaled_pixmap = pixmap.scaled(
            label.size(), Qt.KeepAspectRatio, Qt.SmoothTransformation
        )
        label.setPixmap(scaled_pixmap)
        

    def dragEnterEvent(self, event):
        if event.mimeData().hasUrls():
            event.accept()
        else:
            event.ignore()
            
    def save_image_as(self):
        if not hasattr(self, "temp_hsv_image"):
            QMessageBox.warning(self, "警告", "没有可保存的图片！")
            return

        file_path, _ = QFileDialog.getSaveFileName(
            self, "另存为", "", "图片文件 (*.png *.jpg *.jpeg *.bmp *.tga)"
        )
        if file_path:
            # 获取处理后的图像
            processed_image = self.get_processed_image()
            
            # 获取文件扩展名
            _, ext = os.path.splitext(file_path)
            ext = ext.lower()
            
            # 如果没有扩展名，则添加.tga
            if not ext:
                file_path += '.tga'
                ext = '.tga'
            
            # 检查是否为TGA格式或PNG格式（需要保留alpha）
            if ext in ['.tga', '.png']:
                try:
                    from PIL import Image
                    # 获取原始图像的alpha通道（如果有）
                    original_alpha = None
                    if hasattr(self, "base_image") and self.base_image.shape[2] == 4:
                        original_alpha = self.base_image[:, :, 3]
                    
                    # OpenCV使用BGR顺序，而PIL使用RGB顺序
                    rgb_image = cv2.cvtColor(processed_image, cv2.COLOR_BGR2RGB)
                    
                    # 如果有alpha通道，合并处理后的RGB与原始alpha
                    if original_alpha is not None:
                        # 创建RGBA图像
                        rgba = np.zeros((rgb_image.shape[0], rgb_image.shape[1], 4), dtype=np.uint8)
                        rgba[:, :, :3] = rgb_image
                        rgba[:, :, 3] = original_alpha
                        img = Image.fromarray(rgba)
                    else:
                        img = Image.fromarray(rgb_image)
                    
                    # 保存图像
                    img.save(file_path)
                    QMessageBox.information(self, "保存成功", f"图片已保存为: {file_path}")
                except ImportError:
                    QMessageBox.warning(self, "警告", "保存带alpha通道的图像需要安装PIL库。请使用pip install pillow安装。")
                except Exception as e:
                    QMessageBox.warning(self, "保存失败", f"保存图像时发生错误: {str(e)}")
            else:
                # 其他格式使用OpenCV保存（不保留alpha）
                try:
                    result = cv2.imwrite(file_path, processed_image)
                    if result:
                        QMessageBox.information(self, "保存成功", f"图片已保存为: {file_path}")
                    else:
                        QMessageBox.warning(self, "保存失败", "OpenCV无法保存此格式，请尝试其他格式或使用TGA")
                except Exception as e:
                    QMessageBox.warning(self, "保存失败", f"保存图像时发生错误: {str(e)}")

    def save_image(self):
        if not hasattr(self, "temp_hsv_image"):
            QMessageBox.warning(self, "警告", "没有可保存的图片！")
            return

        reply = QMessageBox.question(
            self,
            "确认保存",
            "此操作将覆盖原图，是否继续？",
            QMessageBox.Yes | QMessageBox.No,
            QMessageBox.No,
        )
        if reply == QMessageBox.Yes:
            # 获取处理后的图像
            processed_image = self.get_processed_image()
            
            # 获取原图的文件扩展名
            _, ext = os.path.splitext(self.base_image_path)
            ext = ext.lower()
            
            # 检查是否为TGA格式或PNG格式（需要保留alpha）
            if ext in ['.tga', '.png']:
                try:
                    from PIL import Image
                    # 获取原始图像的alpha通道（如果有）
                    original_alpha = None
                    if hasattr(self, "base_image") and self.base_image.shape[2] == 4:
                        original_alpha = self.base_image[:, :, 3]
                    
                    # OpenCV使用BGR顺序，而PIL使用RGB顺序
                    rgb_image = cv2.cvtColor(processed_image, cv2.COLOR_BGR2RGB)
                    
                    # 如果有alpha通道，合并处理后的RGB与原始alpha
                    if original_alpha is not None:
                        # 创建RGBA图像
                        rgba = np.zeros((rgb_image.shape[0], rgb_image.shape[1], 4), dtype=np.uint8)
                        rgba[:, :, :3] = rgb_image
                        rgba[:, :, 3] = original_alpha
                        img = Image.fromarray(rgba)
                    else:
                        img = Image.fromarray(rgb_image)
                    
                    # 保存图像
                    img.save(self.base_image_path)
                    QMessageBox.information(self, "保存成功", "图片已保存，并保留了原始alpha通道！")
                except ImportError:
                    QMessageBox.warning(self, "警告", "保存带alpha通道的图像需要安装PIL库。请使用pip install pillow安装。")
                except Exception as e:
                    QMessageBox.warning(self, "保存失败", f"保存图像时发生错误: {str(e)}")
            else:
                # 其他格式使用OpenCV保存（不保留alpha）
                try:
                    result = cv2.imwrite(self.base_image_path, processed_image)
                    if result:
                        QMessageBox.information(self, "保存成功", "图片已保存！")
                    else:
                        QMessageBox.warning(self, "保存失败", "OpenCV无法保存此格式")
                except Exception as e:
                    QMessageBox.warning(self, "保存失败", f"保存图像时发生错误: {str(e)}")

if __name__ == "__main__":
    app = QApplication([])
    # 加载QSS样式表
    load_stylesheet(app)
    
    window = TextureChecker()
    window.show()
    app.exec_()