import os
from PyQt5.QtWidgets import QProgressDialog, QApplication
from . import image_utils

class BatchScanner:
    """批量扫描图像文件并检查亮度的模块"""
    
    def __init__(self):
        self.supported_exts = [".png", ".jpg", ".jpeg", ".bmp", ".tga"]
        
    def scan_folder(self, folder, threshold=0.92, out_txt=None, parent=None):
        """扫描文件夹中的图像文件，检查亮度是否超过阈值"""
        # 收集符合条件的文件列表
        file_list = []
        for root, _, files in os.walk(folder):
            for name in files:
                ext = os.path.splitext(name)[1].lower()
                if ext in self.supported_exts and image_utils.should_include(name):
                    file_list.append(os.path.join(root, name))
        
        total = len(file_list)
        result = []
        
        # 创建进度对话框
        progress = QProgressDialog("正在扫描图片...", "取消", 0, total, parent)
        progress.setWindowTitle("扫描进度")
        progress.setMinimumDuration(0)
        progress.setValue(0)
        progress.setAutoClose(True)
        progress.setAutoReset(True)
        
        # 处理每个文件
        for idx, path in enumerate(file_list):
            progress.setValue(idx)
            QApplication.processEvents()
            if progress.wasCanceled():
                print("用户取消了操作。")
                break
            
            try:
                img = image_utils.load_image(path)
                if image_utils.check_brightness(img, threshold):
                    print(f"超出阈值: {path}")
                    result.append(path)
            except Exception as e:
                print(f"处理失败: {path}，原因: {e}")
        
        progress.setValue(total)
        
        # 输出结果到文件
        if out_txt is None:
            out_txt = os.path.join(os.getcwd(), "exceed_brightness.txt")
        
        with open(out_txt, "w", encoding="utf-8") as f:
            for line in result:
                f.write(line + "\n")
                
        print(f"检查完成，超出阈值的图片已写入: {out_txt}")
        return out_txt, len(result)
        
    def process_folder(self, folder, threshold=0.92, parent=None):
        """
        批量处理文件夹中亮度超出阈值的图像文件
        使用曲线映射公式 (1-(x-阈值))*x 处理超出阈值的像素
        
        参数:
        folder: 要处理的文件夹路径
        threshold: 亮度阈值
        parent: 父窗口，用于创建进度对话框
        
        返回:
        处理的文件数量和成功处理的文件数量的元组
        """
        # 收集符合条件的文件列表
        file_list = []
        for root, _, files in os.walk(folder):
            for name in files:
                ext = os.path.splitext(name)[1].lower()
                if ext in self.supported_exts and image_utils.should_include(name):
                    file_list.append(os.path.join(root, name))
        
        total = len(file_list)
        processed_count = 0
        success_count = 0
        
        # 创建进度对话框
        progress = QProgressDialog("正在处理图片...", "取消", 0, total, parent)
        progress.setWindowTitle("处理进度")
        progress.setMinimumDuration(0)
        progress.setValue(0)
        progress.setAutoClose(True)
        progress.setAutoReset(True)
        
        # 处理每个文件
        for idx, path in enumerate(file_list):
            progress.setValue(idx)
            QApplication.processEvents()
            if progress.wasCanceled():
                print("用户取消了操作。")
                break
            
            try:
                # 加载图像
                img = image_utils.load_image(path)
                
                # 检查是否需要处理
                if image_utils.check_brightness(img, threshold):
                    processed_count += 1
                    
                    # 应用曲线映射处理
                    processed_img = image_utils.process_brightness_curve(img,threshold-0.02, threshold,1.5)
                    
                    # 保存处理后的图像（替换原图）
                    if image_utils.save_image(path, processed_img):
                        success_count += 1
                        print(f"处理并保存: {path}")
                    
                    # 验证处理后的图像是否仍超出阈值
                    if image_utils.check_brightness(processed_img, threshold):
                        print(f"警告: 处理后的图片 {path} 仍然超出阈值!")
            except Exception as e:
                print(f"处理失败: {path}，原因: {e}")
        
        progress.setValue(total)
        print(f"处理完成，共处理 {processed_count} 张图片，成功 {success_count} 张")
        
        return processed_count, success_count