import os
import cv2
import numpy as np
import imageio.v2 as imageio
from PyQt5.QtWidgets import (
    QApplication, QWidget, QVBoxLayout, QHBoxLayout, QLabel, QLineEdit,
    QPushButton, QFileDialog, QProgressDialog, QMessageBox
)

def gamma_to_linear(gamma_value):
    return np.power(gamma_value, 2.2)

def load_image(file_path):
    ext = os.path.splitext(file_path)[1].lower()
    if ext == ".tga":
        img = imageio.imread(file_path)
        if img.shape[-1] == 4:
            img = cv2.cvtColor(img, cv2.COLOR_RGBA2BGRA)
        else:
            img = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)
        return img
    else:
        img = cv2.imread(file_path, cv2.IMREAD_UNCHANGED)
        return img

def check_brightness(img, threshold=0.92):
    if img is None:
        return False
    if img.ndim == 2:
        img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)
    if img.shape[2] == 4:
        img = img[:, :, :3]
    linear_img = gamma_to_linear(img / 255.0)
    rgb_linear = linear_img[:, :, [2, 1, 0]]
    hsv = cv2.cvtColor((rgb_linear * 255).astype(np.uint8), cv2.COLOR_RGB2HSV)
    v = hsv[:, :, 2] / 255.0
    return np.any(v > threshold)

def should_include(filename):
    name, _ = os.path.splitext(os.path.basename(filename))
    return name.endswith('_d') or name.endswith('_d_low')

def scan_folder(folder, threshold=0.92, out_txt=None, parent=None):
    exts = [".png", ".jpg", ".jpeg", ".bmp", ".tga"]
    file_list = []
    for root, _, files in os.walk(folder):
        for name in files:
            ext = os.path.splitext(name)[1].lower()
            if ext in exts and should_include(name):
                file_list.append(os.path.join(root, name))
    total = len(file_list)
    result = []

    progress = QProgressDialog("正在扫描图片...", "取消", 0, total, parent)
    progress.setWindowTitle("进度")
    progress.setMinimumDuration(0)
    progress.setValue(0)
    progress.setAutoClose(True)
    progress.setAutoReset(True)

    for idx, path in enumerate(file_list):
        progress.setValue(idx)
        QApplication.processEvents()
        if progress.wasCanceled():
            print("用户取消了操作。")
            break
        try:
            img = load_image(path)
            if check_brightness(img, threshold):
                print(f"超出阈值: {path}")
                result.append(path)
        except Exception as e:
            print(f"处理失败: {path}，原因: {e}")

    progress.setValue(total)

    if out_txt is None:
        out_txt = os.path.join(os.getcwd(), "exceed_brightness.txt")
    with open(out_txt, "w", encoding="utf-8") as f:
        for line in result:
            f.write(line + "\n")
    print(f"检查完成，超出阈值的图片已写入: {out_txt}")
    return out_txt, len(result)

class BrightnessCheckerUI(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("贴图亮度检查工具")
        self.resize(480, 120)
        layout = QVBoxLayout()

        # 路径输入
        path_layout = QHBoxLayout()
        self.path_edit = QLineEdit()
        browse_btn = QPushButton("浏览")
        browse_btn.clicked.connect(self.browse_folder)
        path_layout.addWidget(QLabel("检查路径:"))
        path_layout.addWidget(self.path_edit)
        path_layout.addWidget(browse_btn)
        layout.addLayout(path_layout)

        # 检查按钮
        check_btn = QPushButton("开始检查")
        check_btn.clicked.connect(self.start_check)
        layout.addWidget(check_btn)

        self.setLayout(layout)

    def browse_folder(self):
        folder = QFileDialog.getExistingDirectory(self, "请选择要检查的文件夹")
        if folder:
            self.path_edit.setText(folder)

    def start_check(self):
        folder = self.path_edit.text().strip()
        if not folder or not os.path.isdir(folder):
            QMessageBox.warning(self, "提示", "请选择有效的文件夹路径！")
            return
        out_txt, count = scan_folder(folder, parent=self)
        QMessageBox.information(self, "完成", f"检查完成，超出阈值图片数量：{count}\n结果已写入：\n{out_txt}")

if __name__ == "__main__":
    import sys
    app = QApplication(sys.argv)
    win = BrightnessCheckerUI()
    win.show()
    sys.exit(app.exec_())