import numpy as np
import imageio
import os

def read_offset_hdr(hdr_path: str, info_path: str = None) -> tuple:
    """
    读取偏移HDR文件并恢复原始数据
    
    Args:
        hdr_path: HDR文件路径
        info_path: 偏移信息文件路径 (如果为None会自动推导)
    
    Returns:
        tuple: (rgb_data, offset_info) 原始RGB数据和偏移信息
    """
    # 读取HDR文件
    hdr_data = imageio.imread(hdr_path, format='HDR')
    print(f"HDR文件尺寸: {hdr_data.shape}")
    print(f"HDR数据范围: [{np.min(hdr_data):.6f}, {np.max(hdr_data):.6f}]")
    
    # 读取偏移信息
    if info_path is None:
        info_path = hdr_path.replace('.hdr', '_offset_info.txt')
    
    if not os.path.exists(info_path):
        print(f"警告: 找不到偏移信息文件 {info_path}")
        return hdr_data, {}
    
    offset_info = {}
    with open(info_path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if '=' in line and not line.startswith('#'):
                key, value = line.split('=', 1)
                if key == 'offset_value':
                    offset_info['offset'] = float(value)
                elif key == 'original_size':
                    offset_info['size'] = value
                elif '_original_range' in key:
                    # 解析原始范围 [min, max]
                    channel = key.split('_')[0]
                    range_str = value.strip('[]')
                    min_val, max_val = map(float, range_str.split(', '))
                    offset_info[f'{channel}_range'] = (min_val, max_val)
    
    print(f"偏移量: {offset_info.get('offset', 0)}")
    
    # 恢复原始数据
    if 'offset' in offset_info:
        original_data = hdr_data - offset_info['offset']
        print(f"恢复后数据范围: [{np.min(original_data):.6f}, {np.max(original_data):.6f}]")
        return original_data, offset_info
    else:
        return hdr_data, offset_info

def test_read_hdr():
    """
    测试读取转换后的HDR文件
    """
    hdr_files = [
        "E:/G136/artist_dev/game/res/lichanglong/demo/vat/xx01_pos_offset.hdr",
        "E:/G136/artist_dev/game/res/lichanglong/demo/vat/xx01_rot_offset.hdr"
    ]
    
    for hdr_file in hdr_files:
        if os.path.exists(hdr_file):
            print(f"\n读取HDR文件: {os.path.basename(hdr_file)}")
            print("=" * 60)
            
            try:
                original_data, info = read_offset_hdr(hdr_file)
                
                print(f"数据形状: {original_data.shape}")
                print(f"通道统计:")
                for i, channel in enumerate(['R', 'G', 'B']):
                    if i < original_data.shape[2]:
                        channel_data = original_data[:, :, i]
                        print(f"  {channel}: [{np.min(channel_data):.6f}, {np.max(channel_data):.6f}]")
                        
                        # 验证是否恢复了负值
                        negative_count = np.sum(channel_data < 0)
                        positive_count = np.sum(channel_data > 0)
                        print(f"      负值像素: {negative_count}, 正值像素: {positive_count}")
                
                # 检查是否成功恢复了原始数据范围
                if info:
                    print(f"原始数据范围验证:")
                    for channel in ['R', 'G', 'B']:
                        range_key = f'{channel}_range'
                        if range_key in info:
                            expected_min, expected_max = info[range_key]
                            print(f"  {channel} 期望范围: [{expected_min:.6f}, {expected_max:.6f}]")
                
            except Exception as e:
                print(f"读取失败: {str(e)}")
        else:
            print(f"文件不存在: {hdr_file}")

def extract_vat_data(hdr_path: str, output_format: str = "numpy") -> dict:
    """
    从HDR文件中提取VAT数据
    
    Args:
        hdr_path: HDR文件路径
        output_format: 输出格式 ("numpy", "list", "shader_ready")
    
    Returns:
        dict: 包含VAT数据的字典
    """
    original_data, info = read_offset_hdr(hdr_path)
    
    vat_data = {
        'width': original_data.shape[1],
        'height': original_data.shape[0],
        'channels': original_data.shape[2] if len(original_data.shape) > 2 else 1
    }
    
    if output_format == "numpy":
        vat_data['R'] = original_data[:, :, 0] if original_data.shape[2] > 0 else None
        vat_data['G'] = original_data[:, :, 1] if original_data.shape[2] > 1 else None
        vat_data['B'] = original_data[:, :, 2] if original_data.shape[2] > 2 else None
        
    elif output_format == "shader_ready":
        # 为着色器使用准备数据（归一化到合适范围）
        # 这里你可能需要根据VAT的具体用途调整数值范围
        vat_data['position_data'] = original_data  # 位置数据
        vat_data['bounds'] = {
            'min': np.min(original_data, axis=(0, 1)),
            'max': np.max(original_data, axis=(0, 1))
        }
    
    return vat_data

if __name__ == "__main__":
    print("HDR数据读取和验证工具")
    print("=" * 50)
    
    # 测试读取HDR文件
    test_read_hdr()
    
    # 示例：提取VAT数据
    pos_hdr = "E:/G136/artist_dev/game/res/lichanglong/demo/vat/xx01_pos_offset.hdr"
    if os.path.exists(pos_hdr):
        print(f"\n\n提取VAT位置数据:")
        print("=" * 40)
        vat_pos = extract_vat_data(pos_hdr, "shader_ready")
        print(f"VAT尺寸: {vat_pos['width']}x{vat_pos['height']}")
        print(f"数据边界:")
        for i, channel in enumerate(['X', 'Y', 'Z']):
            if i < len(vat_pos['bounds']['min']):
                print(f"  {channel}: [{vat_pos['bounds']['min'][i]:.6f}, {vat_pos['bounds']['max'][i]:.6f}]")