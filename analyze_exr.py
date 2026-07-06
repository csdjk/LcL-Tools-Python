import numpy as np
import OpenEXR
import Imath

def analyze_exr_data(exr_path: str):
    """
    分析EXR文件的数据范围和特性
    """
    try:
        # 打开EXR文件
        exr_file = OpenEXR.InputFile(exr_path)
        header = exr_file.header()
        
        # 获取图像尺寸
        dw = header['dataWindow']
        width = dw.max.x - dw.min.x + 1
        height = dw.max.y - dw.min.y + 1
        
        print(f"分析文件: {exr_path}")
        print(f"图像尺寸: {width}x{height}")
        
        # 获取通道信息
        channels = header['channels'].keys()
        print(f"通道列表: {list(channels)}")
        
        # 读取所有通道数据
        FLOAT = Imath.PixelType(Imath.PixelType.FLOAT)
        
        for channel_name in channels:
            channel_str = exr_file.channel(channel_name, FLOAT)
            channel_data = np.frombuffer(channel_str, dtype=np.float32).reshape(height, width)
            
            # 统计数据
            min_val = np.min(channel_data)
            max_val = np.max(channel_data)
            mean_val = np.mean(channel_data)
            
            # 负值统计
            negative_count = np.sum(channel_data < 0)
            positive_count = np.sum(channel_data > 0)
            zero_count = np.sum(channel_data == 0)
            
            print(f"\n通道 '{channel_name}':")
            print(f"  数值范围: [{min_val:.6f}, {max_val:.6f}]")
            print(f"  平均值: {mean_val:.6f}")
            print(f"  负值像素: {negative_count} ({negative_count/(width*height)*100:.2f}%)")
            print(f"  正值像素: {positive_count} ({positive_count/(width*height)*100:.2f}%)")
            print(f"  零值像素: {zero_count} ({zero_count/(width*height)*100:.2f}%)")
            
            # 显示一些具体的负值示例
            if negative_count > 0:
                negative_indices = np.where(channel_data < 0)
                sample_negatives = channel_data[negative_indices][:10]  # 前10个负值
                print(f"  负值示例: {sample_negatives}")
        
        exr_file.close()
        
    except Exception as e:
        print(f"分析失败: {str(e)}")

if __name__ == "__main__":
    # 分析你的EXR文件
    exr_files = [
        "E:/G136/artist_dev/game/res/models/char/body/xingxingsz01/textures/xx01_pos.exr",
        "E:/G136/artist_dev/game/res/models/char/body/xingxingsz01/textures/xx01_rot.exr"
    ]
    
    for exr_file in exr_files:
        analyze_exr_data(exr_file)
        print("=" * 80)