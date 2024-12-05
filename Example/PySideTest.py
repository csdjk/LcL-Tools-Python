import sys
import random
from tkinter import filedialog
from PySide6 import QtCore, QtWidgets, QtGui

# 获取文件路径对话框
# file_name = QFileDialog.getOpenFileName(self,"open file dialog","C:\Users\Administrator\Desktop","Txt files(*.txt)")
#        ##"open file Dialog "为文件对话框的标题，第三个是打开的默认路径，第四个是文件类型过滤器
# QFileDialog.getOpenFileName(self, "选择你要上传的pdf文件", r"C:\\", "文件类型 (*.pdf)")
# # 保存文件对话框
# file_path =  QFileDialog.getSaveFileName(self,"save file","C:\Users\Administrator\Desktop" ,"xj3dp files (*.xj3dp);;all files(*.*)")
# # file_path即为文件即将保存的绝对路径。形参中的第二个为对话框标题，第三个为打开后的默认给路径，第四个为文件类型过滤器


# # 选择文件夹对话框：
# dir_path=QFileDialog.getExistingDirectory(self,"choose directory","C:\Users\Administrator\Desktop")
# # dir_path即为选择的文件夹的绝对路径，第二形参为对话框标题，第三个为对话框打开后默认的路径。
# 以上返回的都是QString类型的对象，若想不出现编码问题，建议用如下语句将QString转换为python的string对象
# str=unicode(your_path.toUtf8(), 'utf-8', 'ignore')

class MyWidget(QtWidgets.QWidget):
    def __init__(self):
        super().__init__()

        self.hello = ["Hallo Welt", "Hei maailma", "Hola Mundo", "Привет мир"]

        self.button = QtWidgets.QPushButton("Click me!")
        self.text = QtWidgets.QLabel(
            "Hello World", alignment=QtCore.Qt.AlignCenter)

        self.layout = QtWidgets.QVBoxLayout(self)
        self.layout.addWidget(self.text)
        self.layout.addWidget(self.button)
        
        self.button.clicked.connect(self.magic)

    @QtCore.Slot()
    def magic(self):
        self.text.setText(random.choice(self.hello))


if __name__ == "__main__":
    app = QtWidgets.QApplication([])

    widget = MyWidget()
    widget.resize(800, 600)
    widget.show()

    sys.exit(app.exec())
