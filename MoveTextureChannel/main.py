import unreal
import os

def process_textures():
    # 获取当前在内容浏览器中选择的文件夹
    selected_folders = unreal.EditorUtilityLibrary.get_selected_folder_paths()
    
    if not selected_folders or len(selected_folders) == 0:
        unreal.log_warning("请先在内容浏览器中选择一个文件夹，然后再运行此脚本")
        return
    
    selected_path = selected_folders[0]  # 使用第一个选中的文件夹
    unreal.log(f"处理目录: {selected_path}")
    
    # 获取选中目录下所有资产
    asset_registry = unreal.AssetRegistryHelpers.get_asset_registry()
    
    # 构造过滤器
    filter = unreal.ARFilter(
        class_names=["Texture2D"],
        package_paths=[selected_path],
        recursive_paths=True
    )
    
    # 获取所有纹理资产
    assets:[] = asset_registry.get_assets(filter)
    
    # 将获取的资产整理到字典中
    texture_assets = {}
    for asset in assets:
        asset_name = asset.asset_name
        asset_path = asset.object_path
        texture_assets[asset_name] = asset_path
    
    unreal.log(f"找到 {len(texture_assets)} 个纹理资产")
    
    # 建立_m_和_d_纹理的映射关系
    m_textures = {}
    d_textures = {}
    
    for texture_name, texture_path in texture_assets.items():
        if "_m_" in texture_name:
            base_name = texture_name.split("_m_")[0]
            m_textures[base_name] = texture_path
        elif "_d_" in texture_name:
            base_name = texture_name.split("_d_")[0]
            d_textures[base_name] = texture_path
    
    unreal.log(f"找到 {len(m_textures)} 个_m_纹理和 {len(d_textures)} 个_d_纹理")
    
    # 检查并处理纹理对
    processed_count = 0
    for base_name in m_textures:
        if base_name in d_textures:
            m_texture_path = m_textures[base_name]
            d_texture_path = d_textures[base_name]
            
            # 加载纹理资产
            m_texture_asset = unreal.EditorAssetLibrary.load_asset(m_texture_path)
            d_texture_asset = unreal.EditorAssetLibrary.load_asset(d_texture_path)
            
            if not m_texture_asset or not d_texture_asset:
                unreal.log_error(f"无法加载贴图: {base_name}")
                continue
            
            try:
                # 确保资产可编辑
                unreal.EditorAssetLibrary.checkout_asset(d_texture_path)
                
                # 获取纹理大小
                size_x = d_texture_asset.blueprint_get_size_x()
                size_y = d_texture_asset.blueprint_get_size_y()
                
                # 创建纹理编辑器
                m_texture_edit = unreal.TextureEditor.start_texture_edit(m_texture_asset)
                d_texture_edit = unreal.TextureEditor.start_texture_edit(d_texture_asset)
                
                # 获取像素数据
                m_pixels = unreal.TextureEditor.get_pixels(m_texture_edit, 0)
                d_pixels = unreal.TextureEditor.get_pixels(d_texture_edit, 0)
                
                # 修改像素数据 - 将m纹理的B通道复制到d纹理的A通道
                modified = False
                for y in range(size_y):
                    for x in range(size_x):
                        pixel_index = (y * size_x + x) * 4
                        if pixel_index + 3 < len(d_pixels) and pixel_index + 2 < len(m_pixels):
                            # 将m纹理的B通道(索引2)复制到d纹理的A通道(索引3)
                            d_pixels[pixel_index + 3] = m_pixels[pixel_index + 2]
                            modified = True
                
                if modified:
                    # 应用修改的像素数据
                    unreal.TextureEditor.set_pixels(d_texture_edit, 0, d_pixels)
                    unreal.TextureEditor.commit_texture_edit(d_texture_edit)
                    
                    # 取消m纹理的编辑会话
                    unreal.TextureEditor.cancel_texture_edit(m_texture_edit)
                    
                    # 保存修改后的资产
                    unreal.EditorAssetLibrary.save_loaded_asset(d_texture_asset)
                    processed_count += 1
                    unreal.log(f"已处理: {base_name} - 将 {os.path.basename(m_texture_path)} 的B通道复制到 {os.path.basename(d_texture_path)} 的A通道")
                else:
                    # 取消编辑会话
                    unreal.TextureEditor.cancel_texture_edit(m_texture_edit)
                    unreal.TextureEditor.cancel_texture_edit(d_texture_edit)
            
            except Exception as e:
                unreal.log_error(f"处理贴图 {base_name} 时发生错误: {str(e)}")
    
    unreal.log(f"处理完成! 共处理了 {processed_count} 对纹理。")

# 直接执行函数
process_textures()