import sys
import numpy as np
from PyQt6.QtWidgets import QApplication, QMainWindow, QLabel, QPushButton, QVBoxLayout, QWidget
from PyQt6.QtCore import Qt
import pyqtgraph as pg

# 常量定义
BACKGROUND_COLOR = "#2E2E2E"  # 深灰色背景
TEXT_COLOR = "#FFFFFF"  # 白色文字
BAR_COLOR = "#3498DB"  # 蓝色条形图
HIGHLIGHT_COLOR = "#2ECC71"  # 绿色高亮
MAX_BAR_COLOR = "#E74C3C"  # 红色最大值条形图
ANNOTATION_COLOR = "#FFFFFF"  # 白色注释

data_x = list(range(0, 50))
data_y = np.random.randint(1, 100, size=50).tolist()

class CustomBarGraphItem(pg.BarGraphItem):
    def __init__(self, parent:pg.PlotWidget, show_tips=True, **kwargs):
        super().__init__(**kwargs)
        self.parent = parent
        print(self.scene())
        print(parent)
        print(parent == self.scene())
        
        self.setAcceptHoverEvents(True)
        self.default_brushes = self.opts['brushes']
        self.show_tips = show_tips
        
        # 创建 QLabel 作为提示
        self.label = QLabel("", self.parent)
        self.label.setStyleSheet(f"""
            background-color: {BACKGROUND_COLOR};
            color: {TEXT_COLOR};
            border: 1px solid {TEXT_COLOR};
            border-radius: 10px;
            padding: 5px;
            text-align: center;
        """)
        self.label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.label.setVisible(False)

        self.highlight_color = HIGHLIGHT_COLOR

        # 创建垂直线
        self.v_line = pg.InfiniteLine(angle=90, movable=False, pen=pg.mkPen(HIGHLIGHT_COLOR))
        self.parent.addItem(self.v_line)
        self.v_line.setVisible(False)
        self.v_line.setPen(pg.mkPen(self.highlight_color, style=Qt.PenStyle.DashLine))
        
    def setTipStyle(self, background_color=None, text_color=None, font_size=None, border_radius=None):
        style = "background-color: {}; color: {}; font-size: {}; border-radius: {}; padding: 5px; text-align: center;".format(
            background_color if background_color else BACKGROUND_COLOR,
            text_color if text_color else TEXT_COLOR,
            font_size if font_size else "12px",
            border_radius if border_radius else "10px"
        )
        self.label.setStyleSheet(style)

    def setHighlightColor(self, color):
        self.highlight_color = color
        self.v_line.setPen(pg.mkPen(color, style=Qt.PenStyle.DashLine))
        
    def hoverMoveEvent(self, event):
        pos = event.pos()
        index = self._getBarIndex(pos, True)
        if index is not None:
            self.opts['brushes'] = [pg.mkBrush(self.highlight_color) if i == index else brush for i, brush in enumerate(self.default_brushes)]
            super().setOpts(**self.opts)
            
            datax = self.opts["x"]
            datay = self.opts["height"]

            # 显示垂直线
            self.v_line.setPos(datax[index])
            self.v_line.setVisible(True)
            
            if self.show_tips:
                self.label.setText(f"x: {datax[index]}, y: {datay[index]}")
                scene_pos = self.mapToScene(pos)
                view_pos = self.parent.mapFromScene(scene_pos)
                self.label.move(view_pos.x() + 10, view_pos.y() - 20)  # 调整位置
                self.label.setVisible(True)
        event.accept()

    def hoverLeaveEvent(self, event):
        self.opts['brushes'] = self.default_brushes
        super().setOpts(**self.opts)
        
        self.label.setVisible(False)
        self.v_line.setVisible(False)
        event.accept()
        
    def updateData(self, y):
        self.opts['height'] = y
        super().setOpts(**self.opts)

    def _getBarIndex(self, pos, use_x_range=False):
        if use_x_range:
            x_pos = pos.x()
            for i, rect in enumerate(self._rectarray.instances()):
                if rect.left() <= x_pos <= rect.right():
                    return i
        else:
            for i, rect in enumerate(self._rectarray.instances()):
                if rect.contains(pos):
                    return i
        return None

class MyWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("柱状图示例")
        self.setGeometry(100, 100, 800, 600)

        self.plot_widget = pg.PlotWidget()
        self.plot_widget.showGrid(x=True, y=True)
        self.plot_widget.setLabel('left', "Value", color=TEXT_COLOR)
        self.plot_widget.setLabel('bottom', 'DrawCall ID', color=TEXT_COLOR)
        self.plot_widget.setBackground(BACKGROUND_COLOR)  # 设置背景颜色

        self.button = QPushButton("翻倍Y轴值")
        self.button.clicked.connect(self.double_y_values)

        layout = QVBoxLayout()
        layout.addWidget(self.plot_widget)
        layout.addWidget(self.button)

        container = QWidget()
        container.setLayout(layout)
        self.setCentralWidget(container)

        self.plot()

    def plot(self):
        self.x = data_x
        self.y = data_y
        self.max_index = np.argmax(self.y)

        brushes = [pg.mkBrush(BAR_COLOR) for _ in self.y]
        brushes[self.max_index] = pg.mkBrush(MAX_BAR_COLOR)

        self.bar_item = CustomBarGraphItem(
            parent=self.plot_widget,
            x=self.x, height=self.y, width=0.8, brushes=brushes
        )
        self.bar_item.setTipStyle(background_color=HIGHLIGHT_COLOR, font_size="15px", border_radius="10px")
        self.plot_widget.addItem(self.bar_item)

        # 设置 x 轴标签间隔
        self.plot_widget.getAxis("bottom").setTicks(
            [[(i, str(i)) for i in range(0, 51, 5)], []]
        )

    def double_y_values(self):
        self.y = [value * 2 for value in self.y]
        self.bar_item.updateData(self.y)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MyWindow()
    window.show()
    sys.exit(app.exec())