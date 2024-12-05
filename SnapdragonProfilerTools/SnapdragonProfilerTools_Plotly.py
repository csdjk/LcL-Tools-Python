import sys
from typing import Dict, Optional
import pandas as pd
import plotly.graph_objs as go
from plotly.subplots import make_subplots
from PyQt5.QtWidgets import (
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
)
from PyQt5.QtWebEngineWidgets import QWebEngineView

# 常量定义
BACKGROUND_COLOR = "#2E2E2E"
TEXT_COLOR = "white"
BAR_COLOR = "#5DADE2"
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
        self.fig_cache : Dict[str, go.Figure] = {}
        self.web_views : Dict[str, QWebEngineView] = {}
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
            lambda: self.plot_chart(attribute, float(freq_input.text()))
        )
        freq_layout = QHBoxLayout()
        freq_layout.addWidget(freq_label)
        freq_layout.addWidget(freq_input)
        freq_layout.addWidget(freq_btn)
        layout.addLayout(freq_layout)

    # 更新柱状图的 y 轴值
    # def update_chart_with_frequency(self, attribute, frequency):
    #     try:
    #         frequency = float(frequency)
    #         self.df["Time"] = self.df[attribute] / frequency
    #         self.df["Time_ms"] = self.df["Time"] * 1000  # 转换成毫秒
    #         # 更新现有柱状图的 y 轴值
    #         self.update_chart_y_axis("Clocks", self.df["Time_ms"])
            
    #     except ValueError:
    #         pass
        
    def update_chart_y_axis(self, attribute, new_y_values):
        web_view: QWebEngineView = self.web_views.get(attribute)
        fig: go.Figure = self.fig_cache.get(attribute)
        if fig and web_view:
            fig.data[0].update(y=new_y_values)
            fig.update_yaxes(title_text="耗时(ms)", range=[0, max(new_y_values) * 1.1])  # 调整 y 轴范围
            web_view.setHtml(fig.to_html(include_plotlyjs="cdn"))
            
    def plot_chart(self, attribute, frequency: Optional[float] = None):
        data = self.df[["ID", attribute]].fillna(0)
        max_value = data[attribute].max()
        max_index = data[attribute].idxmax()
        max_id = data["ID"].iloc[max_index]

        # 设置颜色，最大值的颜色不同
        colors = [MAX_BAR_COLOR if i == max_index else BAR_COLOR for i in range(len(data))]


        if attribute == "Clocks" and frequency:
            hovertext = [
                f"ID: {row['ID']}<br>Clocks: {row[attribute]}<br>耗时(ms): {(row[attribute] / frequency * 1000):.2f}"
                for _, row in self.df.iterrows()
            ]
        elif "Bytes" in attribute:
            hovertext = [
                f"ID: {row['ID']}<br>Bytes: {row[attribute]}<br>MB: {(row[attribute] / 1024 / 1024):.2f}M"
                for _, row in self.df.iterrows()
            ]
        elif "%" in attribute:
            hovertext = [
                f"ID: {row['ID']}<br>{attribute}: {row[attribute]}%"
                for _, row in self.df.iterrows()
            ]
        else:
            hovertext = [
                f"ID: {row['ID']}<br>{attribute}: {row[attribute]}"
                for _, row in self.df.iterrows()
            ]
            
        fig = make_subplots(rows=1, cols=1)

        bars = go.Bar(
            x=data["ID"],
            y=data[attribute],
            marker=dict(color=colors),
            name=attribute,
            hoverinfo="text",
            hovertext=hovertext,
            # hovertemplate="ID: %{x}<br>Value: %{y}<extra></extra>",
        )

        fig.add_trace(bars)

        fig.update_layout(
             title=dict(
                text=f"{attribute} per Draw Call",
                x=0.5  # 水平居中
            ),
            xaxis_title="Draw Call ID",
            yaxis_title=attribute,
            plot_bgcolor=BACKGROUND_COLOR,#图表背景颜色
            paper_bgcolor=BACKGROUND_COLOR,#Canvas背景颜色
            font=dict(color=TEXT_COLOR),
            hovermode="x unified",
            # xaxis=dict(showline=False, zeroline=False),  # 关闭 x 轴的边框和零线
            # yaxis=dict(showline=False, zeroline=False)   # 关闭 y 轴的边框和零线
        )

        total_count = len(data["ID"])
        if total_count <= 100:
            interval = 1
        elif total_count <= 300:
            interval = 5
        else:
            interval = 10

        fig.update_xaxes(
            tickvals=data["ID"][::interval],
            ticktext=data["ID"][::interval],
            tickangle=90,
        )

        # 最大值提示框
        fig.add_annotation(
            x=max_id,
            y=max_value,
            text=f"ID: {max_id}<br>{max_value}",
            showarrow=True,
            arrowhead=1,
            ax=0,
            ay=-40,
            bgcolor=MAX_BAR_COLOR,
        )
        
        # 删除旧的柱状图
        if attribute in self.fig_cache:
            del self.fig_cache[attribute]
        if attribute in self.web_views:
            self.tabs[attribute].removeWidget(self.web_views[attribute])
            del self.web_views[attribute]

        # 缓存fig
        self.fig_cache[attribute] = fig

        html = fig.to_html(include_plotlyjs="cdn")
        web_view = QWebEngineView()
        web_view.setHtml(html)
        # web_view.setStyleSheet("background-color: black;")
        self.tabs[attribute].addWidget(web_view)
        self.web_views[attribute] = web_view


# 使用示例
if __name__ == "__main__":
    app = QApplication(sys.argv)
    main_window = DrawCallPlotter()
    main_window.show()
    sys.exit(app.exec_())