import pymxs
from pymxs import runtime as rt

def import_fbx_model():
    """
    自动导入FBX模型到3ds Max
    """
    try:
        # 定义FBX文件路径
        fbx_file_path = r"F:\Temp\output.fbx"
        
        # 检查文件是否存在
        import os
        if not os.path.exists(fbx_file_path):
            print(f"错误: 文件 {fbx_file_path} 不存在")
            return False
        
        # 获取3ds Max的运行时环境
        rt = pymxs.runtime
        
        # 设置FBX导入选项 (可选)
        rt.FBXImporterSetParam("Mode", rt.name("exmerge"))  # 合并到当前场景
        rt.FBXImporterSetParam("AxisConversionMethod", rt.name("None"))  # 坐标轴转换
        rt.FBXImporterSetParam("UpAxis", rt.name("Y"))  # Y轴向上
        
        # 导入FBX文件
        result = rt.importFile(
            fbx_file_path,
            rt.name("noPrompt"),  # 不显示导入对话框
            using=rt.FBXIMP  # 使用FBX导入器
        )
        
        if result:
            print(f"成功导入模型: {fbx_file_path}")
            
            # 可选: 适配视口到导入的对象
            rt.viewports.redraw()
            rt.max("zoom extents all")
            
            return True
        else:
            print(f"导入失败: {fbx_file_path}")
            return False
            
    except Exception as e:
        print(f"导入过程中发生错误: {str(e)}")
        return False

def import_fbx_with_options():
    """
    带有更多选项的FBX导入函数
    """
    try:
        fbx_file_path = r"F:\Temp\output.fbx"
        rt = pymxs.runtime
        
        # 详细的FBX导入设置
        rt.FBXImporterSetParam("Mode", rt.name("exmerge"))
        rt.FBXImporterSetParam("ConvertUnit", rt.name("cm"))  # 单位转换为厘米
        rt.FBXImporterSetParam("ScaleFactor", 1.0)  # 缩放因子
        rt.FBXImporterSetParam("Animation", True)  # 导入动画
        rt.FBXImporterSetParam("Cameras", True)  # 导入摄像机
        rt.FBXImporterSetParam("Lights", True)  # 导入灯光
        rt.FBXImporterSetParam("Materials", True)  # 导入材质
        rt.FBXImporterSetParam("Textures", True)  # 导入贴图
        
        # 执行导入
        result = rt.importFile(fbx_file_path, rt.name("noPrompt"), using=rt.FBXIMP)
        
        if result:
            print("FBX模型导入成功！")
            
            # 选中所有导入的对象
            imported_objects = rt.selection
            if imported_objects.count > 0:
                print(f"已导入 {imported_objects.count} 个对象")
            
            # 刷新视口
            rt.completeRedraw()
            
        return result
        
    except Exception as e:
        print(f"导入错误: {str(e)}")
        return False



print("max/auto_import.py 模块已加载")

# # 执行导入
# if __name__ == "__main__":
#     # 基础导入
#     import_fbx_model()
    
    # 或者使用带选项的导入
    # import_fbx_with_options()