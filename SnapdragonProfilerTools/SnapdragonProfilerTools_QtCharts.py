import sys
from typing import Dict, Optional
import pandas as pd
from PyQt6.QtCore import Qt, QPoint
from PyQt6.QtWidgets import (
    QApplication,
    QMainWindow,
    QTabWidget,
    QWidget,
    QVBoxLayout,
    QScrollArea,
    QHBoxLayout,
    QLineEdit,
    QPushButton,
    QFileDialog,
    QLabel,
    QToolTip,
)
from PyQt6.QtCharts import QChart, QChartView, QBarSet, QBarSeries, QValueAxis, QBarCategoryAxis,QCategoryAxis
from PyQt6.QtGui import QPainter, QBrush, QColor, QFont, QCursor

# 常量定义
BACKGROUND_COLOR = "#2E2E2E"
TEXT_COLOR = "white"
# BAR_COLOR = "#5DADE2" #blue
BAR_COLOR = "#80C342"  #green
HIGHLIGHT_COLOR = "#F7DC6F"
MAX_BAR_COLOR = "#E74C3C"
ANNOTATION_COLOR = "white"


class DrawCallPlotter(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Draw Call Attributes Plotter")
        self.setMinimumSize(800, 600)

        # 加载样式表
        with open("styles.qss", "r") as f:
            self.setStyleSheet(f.read())

        # 创建文件路径输入框和按钮
        self.file_label = QLabel("CSV文件路径:", self)

        self.file_input = QLineEdit(self)
        self.file_input.setText("pgame_city.csv")
        self.file_input.setPlaceholderText("选择CSV文件路径")

        self.browse_button = QPushButton("浏览", self)
        self.browse_button.clicked.connect(self.browse_file)

        self.load_button = QPushButton("加载", self)
        self.load_button.clicked.connect(self.load_csv)

        # 布局
        input_layout = QHBoxLayout()
        input_layout.addWidget(self.file_label)
        input_layout.addWidget(self.file_input)
        input_layout.addWidget(self.browse_button)
        input_layout.addWidget(self.load_button)

        input_widget = QWidget()
        input_widget.setLayout(input_layout)

        self.main_layout = QVBoxLayout()
        self.main_layout.addWidget(input_widget)

        self.tab_control = QTabWidget()
        self.main_layout.addWidget(self.tab_control)

        main_widget = QWidget()
        main_widget.setLayout(self.main_layout)
        self.setCentralWidget(main_widget)

    def browse_file(self):
        file_name, _ = QFileDialog.getOpenFileName(
            self, "选择CSV文件", "", "CSV Files (*.csv)"
        )
        if file_name:
            self.file_input.setText(file_name)

    def load_csv(self):
        csv_file = self.file_input.text()
        if csv_file:
            self.df = pd.read_csv(csv_file)
            self.df.columns = self.df.columns.str.strip()
            self.df = self.df.dropna(subset=["ID"]).reset_index(drop=True)
            self.df["ID"] = self.df["ID"].astype(int)
            self.df = self.df.fillna(0)
            self.attributes = [
                col
                for col in self.df.columns
                if col != "ID"
                and col != "Context"
                and pd.api.types.is_numeric_dtype(self.df[col])
            ]                             
            self.plot_initial_charts()

    def plot_initial_charts(self):
        self.tab_control.clear()
        self.tabs: Dict[str, QVBoxLayout] = {}
        for attribute in self.attributes:
            scroll_area = QScrollArea()
            scroll_area.setWidgetResizable(True)
            scroll_content = QWidget()
            scroll_layout = QVBoxLayout(scroll_content)
            scroll_area.setWidget(scroll_content)
            self.tab_control.addTab(scroll_area, attribute)
            self.tabs[attribute] = scroll_layout
            if attribute == "Clocks":
                self.add_frequency_input(scroll_layout, attribute)
            self.plot_chart(attribute)

    def add_frequency_input(self, layout, attribute):
        freq_label = QLabel("频率(Clocks/Second):", self)
        freq_input = QLineEdit(self)
        freq_input.setPlaceholderText("输入频率")
     
        freq_btn = QPushButton("计算耗时(ms)", self)
        freq_btn.clicked.connect(
            lambda: self.update_chart_clocks(attribute, float(freq_input.text()))
        )
        freq_layout = QHBoxLayout()
        freq_layout.addWidget(freq_label)
        freq_layout.addWidget(freq_input)
        freq_layout.addWidget(freq_btn)
        layout.addLayout(freq_layout)


    def update_chart_clocks(self, attribute, frequency):
        
        data = self.df[attribute] / frequency * 1000  # 转换成毫秒
        self.axis_y.setTitleText("耗时(ms)")
        self.axis_y.setTitleVisible(True)
        for i, value in enumerate(data):
            self.bar_set.replace(i, value)
        self.axis_y.setRange(0, max(data) * 1.1)
    
    
    
    def plot_chart(self, attribute):
        data = self.df[["ID", attribute]].fillna(0)
        max_value = data[attribute].max()
        self.max_index = data[attribute].idxmax()
        max_id = data["ID"].iloc[self.max_index]

        self.bar_set = QBarSet(attribute)
        self.bar_set.setBorderColor(QColor(Qt.GlobalColor.transparent))
        self.bar_set.append(data[attribute])

        # 高亮最大值
        self.bar_set.selectBar(self.max_index)
        self.bar_set.setSelectedColor(QColor(MAX_BAR_COLOR))
        
        series = QBarSeries()
        series.hovered.connect(self.bar_hovered)
        series.append(self.bar_set)

        chart = QChart()
        chart.addSeries(series)
        chart.setTitle(f"{attribute} per Draw Call")
        chart.setAnimationOptions(QChart.AnimationOption.SeriesAnimations)

        # 创建X轴
        axis_x = QBarCategoryAxis()
        total_count = len(data["ID"])
        if total_count <= 100:
            interval = 1
        elif total_count <= 300:
            interval = 5
        else:
            interval = 10

        # data_x = [str(id) if i % interval == 0 else "-" for i, id in enumerate(data["ID"])]
        data_x = [str(id) for i, id in enumerate(data["ID"])]
        
        # print(data_x)
        axis_x.append(data_x)
        axis_x.setTitleText("DrawCall ID")
        axis_x.setLabelsBrush(QBrush(QColor(TEXT_COLOR)))
        axis_x.setTitleVisible(True)
        axis_x.setTitleBrush(QBrush(QColor(TEXT_COLOR)))
        chart.addAxis(axis_x, Qt.AlignmentFlag.AlignBottom)
        series.attachAxis(axis_x)

        # 创建Y轴
        self.axis_y = QValueAxis()
        self.axis_y.setRange(0, max_value * 1.1)
        self.axis_y.setLabelsBrush(QBrush(QColor(TEXT_COLOR)))
        self.axis_y.setTitleText(attribute)
        self.axis_y.setTitleBrush(QBrush(QColor(TEXT_COLOR)))
        self.axis_y.setTitleVisible(True)
        chart.addAxis(self.axis_y, Qt.AlignmentFlag.AlignLeft)
        series.attachAxis(self.axis_y)

        chart.setBackgroundBrush(QBrush(QColor(BACKGROUND_COLOR)))
        chart.setTitleBrush(QBrush(QColor(TEXT_COLOR)))
        chart.setTitleFont(QFont("Arial", 14))
        chart.legend().setLabelColor(QColor(TEXT_COLOR))
        
        chart_view = QChartView(chart)
        chart_view.setRenderHint(QPainter.RenderHint.Antialiasing)

        self.tabs[attribute].addWidget(chart_view)
        
    
    def bar_hovered(self, status, index, bar_set: QBarSet):
        if self.max_index != index:
            bar_set.setBarSelected(index, status)
        
        if status:
            attribute = bar_set.label()
            value = bar_set.at(index)
            tooltip_text = f"ID: {index} \n {value}"
            
            if "%" in attribute:
                tooltip_text += "%"
            elif "Bytes" in attribute:
                mb_value = value / (1024 * 1024)
                tooltip_text += f"\n {mb_value:.2f} MB"
            
            QToolTip.showText(QCursor.pos(), tooltip_text, msecShowTime=99999)
        else:
            QToolTip.hideText()

# 使用示例
if __name__ == "__main__":
    app = QApplication(sys.argv)
    main_window = DrawCallPlotter()
    main_window.show()
    sys.exit(app.exec())