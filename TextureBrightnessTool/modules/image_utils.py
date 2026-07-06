import os
import cv2
import numpy as np
import imageio.v2 as imageio

def gamma_to_linear(gamma_value):
    """将伽马空间的值转换到线性空间"""
    return np.power(gamma_value, 2.2)

def linear_to_gamma(linear_value):
    """将线性空间的值转换到伽马空间"""
    return np.power(linear_value, 1 / 2.2)

def load_image(file_path):
    """加载图像文件，支持常见格式和TGA格式"""
    ext = os.path.splitext(file_path)[1].lower()
    if ext == ".tga":
        img = imageio.imread(file_path)
        if img.shape[-1] == 4:  # 带Alpha通道
            img = cv2.cvtColor(img, cv2.COLOR_RGBA2BGRA)
        else:  # 不带Alpha通道
            img = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)
    else:
        img = cv2.imread(file_path, cv2.IMREAD_UNCHANGED)
    return img

def save_image(file_path, img):
    """保存图像文件，自动处理格式问题"""
    try:
        # 获取扩展名
        _, ext = os.path.splitext(file_path)
        ext = ext.lower()
        
        # TGA或PNG格式(需要处理Alpha通道)
        if ext in ['.tga', '.png']:
            # 检查图像是否有Alpha通道
            has_alpha = img.shape[2] == 4 if len(img.shape) == 3 and img.shape[2] <= 4 else False
            
            if has_alpha:
                # BGR转RGB，保留Alpha
                img_rgba = np.zeros_like(img)
                img_rgba[:, :, 0] = img[:, :, 2]  # R = B
                img_rgba[:, :, 1] = img[:, :, 1]  # G = G
                img_rgba[:, :, 2] = img[:, :, 0]  # B = R
                img_rgba[:, :, 3] = img[:, :, 3]  # A = A
                imageio.imwrite(file_path, img_rgba)
            else:
                # BGR转RGB, 无Alpha
                img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
                imageio.imwrite(file_path, img_rgb)
        else:
            # 其他格式使用OpenCV保存
            cv2.imwrite(file_path, img)
        return True
    except Exception as e:
        print(f"保存图像失败: {file_path}, 错误: {e}")
        return False

def check_brightness(img, threshold=0.92):
    """检查图像的亮度是否超过阈值"""
    if img is None:
        return False
    
    # 处理灰度图像
    if img.ndim == 2:
        img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)
    
    # 处理带Alpha通道的图像
    if img.shape[2] == 4:
        img = img[:, :, :3]
    
    # 转换为线性空间
    linear_img = gamma_to_linear(img / 255.0)
    
    # BGR转RGB再转HSV
    rgb_linear = linear_img[:, :, [2, 1, 0]]
    hsv = cv2.cvtColor((rgb_linear * 255).astype(np.uint8), cv2.COLOR_RGB2HSV)
    
    # 检查明度通道
    v = hsv[:, :, 2] / 255.0
    return np.any(v > threshold)

def should_include(filename):
    """判断文件是否应该被包含在亮度检查中"""
    name, _ = os.path.splitext(os.path.basename(filename))
    return name.endswith('_d') or name.endswith('_d_low')

def hsv_to_bgr(hsv_image):
    """将HSV图像转换回BGR格式"""
    rgb_image = cv2.cvtColor(hsv_image, cv2.COLOR_HSV2RGB)
    return rgb_image[:, :, [2, 1, 0]]


def process_brightness_curve(img, threshold_start=0.90, threshold_map=0.92, power=2.0):
    """
    对图像中超出阈值的像素进行平滑曲线映射处理
    小于等于threshold_start的像素不变，大于threshold_start的像素平滑压缩到threshold_map以下

    参数:
    img: 输入图像，BGR或BGRA格式
    threshold_start: 开始映射的亮度阈值
    threshold_map: 映射后的最大亮度值
    power: 控制曲线平滑度
    返回:
    处理后的图像，与输入图像格式相同
    """
    if img is None:
        return None

    # 保存原始图像格式信息
    has_alpha = img.shape[2] == 4 if len(img.shape) == 3 else False
    original_dtype = img.dtype

    # 转换为BGR格式（无Alpha通道）
    if len(img.shape) == 3 and img.shape[2] == 4:
        # 保存Alpha通道
        alpha_channel = img[:, :, 3].copy()
        img_bgr = img[:, :, :3].copy()
    elif len(img.shape) == 2:
        img_bgr = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)
    else:
        img_bgr = img.copy()

    # 转换为线性空间进行处理
    linear_img = gamma_to_linear(img_bgr / 255.0)

    # BGR转RGB再转HSV
    rgb_linear = linear_img[:, :, [2, 1, 0]]
    hsv = cv2.cvtColor((rgb_linear * 255).astype(np.uint8), cv2.COLOR_RGB2HSV)

    # 获取并归一化明度通道
    v = hsv[:, :, 2] / 255.0

    # 平滑曲线映射
    def smooth_curve(v, power=2.0):
        v = np.asarray(v)
        y = np.where(
            v <= threshold_start,
            v,
            threshold_start + (threshold_map - threshold_start) * ((v - threshold_start) / (1 - threshold_start)) ** (1/power)
        )
        y = np.clip(y, 0, threshold_map)
        return y

    v_new = smooth_curve(v, power=power)
    hsv[:, :, 2] = (v_new * 255).astype(np.uint8)

    # 转换回BGR格式
    rgb_image = cv2.cvtColor(hsv, cv2.COLOR_HSV2RGB)
    processed_bgr = rgb_image[:, :, [2, 1, 0]]

    # 转换回伽马空间
    processed_bgr = (linear_to_gamma(processed_bgr / 255.0) * 255).astype(np.uint8)

    # 重建原始格式
    if has_alpha:
        processed = np.zeros((img_bgr.shape[0], img_bgr.shape[1], 4), dtype=np.uint8)
        processed[:, :, :3] = processed_bgr
        processed[:, :, 3] = alpha_channel
    else:
        processed = processed_bgr

    return processed

# def process_brightness_curve(img, threshold=0.92):
#     """
#     对图像中超出阈值的像素进行曲线映射处理
#     公式：(1-(x-阈值))*x，其中x为像素归一化亮度值
    
#     参数:
#     img: 输入图像，BGR或BGRA格式
#     threshold: 亮度阈值，默认0.92
    
#     返回:
#     处理后的图像，与输入图像格式相同
#     """
#     if img is None:
#         return None
    
#     # 保存原始图像格式信息
#     has_alpha = img.shape[2] == 4 if len(img.shape) == 3 else False
#     original_dtype = img.dtype
    
#     # 转换为BGR格式（无Alpha通道）
#     if len(img.shape) == 3 and img.shape[2] == 4:
#         # 保存Alpha通道
#         alpha_channel = img[:, :, 3].copy()
#         img_bgr = img[:, :, :3].copy()
#     elif len(img.shape) == 2:
#         img_bgr = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)
#     else:
#         img_bgr = img.copy()
    
#     # 转换为线性空间进行处理
#     linear_img = gamma_to_linear(img_bgr / 255.0)
    
#     # BGR转RGB再转HSV
#     rgb_linear = linear_img[:, :, [2, 1, 0]]
#     hsv = cv2.cvtColor((rgb_linear * 255).astype(np.uint8), cv2.COLOR_RGB2HSV)
    
#     # 获取并归一化明度通道
#     v = hsv[:, :, 2] / 255.0
    
#     # 找到超出阈值的像素
#     over_threshold = v > threshold
    
#     if np.any(over_threshold):
#         # 对超出阈值的像素应用曲线映射公式：(1-(x-阈值))*x
#         v_over = v[over_threshold]
#         v_over = (1 - (v_over - threshold)) * v_over
#         # np.clip(v_channel[current_mask], clamp_min, clamp_max)
#         # v_over = np.clip(v_over, 0, 0.8)
#         v[over_threshold] = v_over
        
#         # 更新HSV图像中的V通道
#         hsv[:, :, 2] = (v * 255).astype(np.uint8)
        
#         # 转换回BGR格式
#         rgb_image = cv2.cvtColor(hsv, cv2.COLOR_HSV2RGB)
#         processed_bgr = rgb_image[:, :, [2, 1, 0]]
        
#         # 转换回伽马空间
#         processed_bgr = (linear_to_gamma(processed_bgr / 255.0) * 255).astype(np.uint8)
        
#         # 重建原始格式
#         if has_alpha:
#             processed = np.zeros((img_bgr.shape[0], img_bgr.shape[1], 4), dtype=np.uint8)
#             processed[:, :, :3] = processed_bgr
#             processed[:, :, 3] = alpha_channel
#         else:
#             processed = processed_bgr
        
#         return processed
#     else:
#         # 没有超出阈值的像素，直接返回原图
#         return img