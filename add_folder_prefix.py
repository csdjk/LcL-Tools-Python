import os
import tkinter as tk
from tkinter import filedialog

# 添加前缀（把文件夹名作为前缀）

# 定义一个全局变量，用来存储文件夹路径
folder_path = ''


def add_folder_prefix(folder_path):
    for filename in os.listdir(folder_path):
        if os.path.isfile(os.path.join(folder_path, filename)) and not filename.startswith(os.path.basename(folder_path)):
            new_filename = os.path.basename(folder_path) + '.' + filename
            os.rename(os.path.join(folder_path, filename), os.path.join(folder_path, new_filename))
        elif os.path.isdir(os.path.join(folder_path, filename)):
            add_folder_prefix(os.path.join(folder_path, filename))

def select_folder():
    global folder_path
    folder_path = filedialog.askdirectory()
    path_label.config(text=folder_path)
   
def handle():
    add_folder_prefix(folder_path)

root = tk.Tk()
root.title("文件夹前缀添加工具")

path_label = tk.Label(root, text="")
path_label.config(font=("Arial", 14))
path_label.pack()

select_button = tk.Button(root, text="选择文件夹", command=select_folder)
select_button.config(width=10, height=2, bg='black', fg='white')
select_button.pack(side=tk.LEFT, padx=10, pady=10)

execute_button = tk.Button(root, text="执行", command=handle)
execute_button.config(width=10, height=2, bg='black', fg='white')
execute_button.pack(side=tk.RIGHT, padx=10, pady=10)

root.mainloop()