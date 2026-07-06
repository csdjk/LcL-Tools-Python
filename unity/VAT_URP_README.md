# VAT Rigid Body Dynamics URP Shader

这是一个从Houdini SideFX VAT Shader Graph转换而来的URP Shader，专门用于播放预计算的刚体动力学动画。

## 主要改进

### 变量命名优化
- `_B_autoPlayback` → `_EnableAutoPlayback` (启用自动播放)
- `_gameTimeAtFirstFrame` → `_FirstFrameGameTime` (首帧游戏时间)
- `_displayFrame` → `_ManualDisplayFrame` (手动显示帧)
- `_playbackSpeed` → `_PlaybackSpeed` (播放速度)
- `_houdiniFPS` → `_HoudiniFPS` (Houdini FPS)
- `_B_interpolate` → `_EnableInterframeInterpolation` (启用帧间插值)
- `_B_interpolateCol` → `_EnableColorInterpolation` (启用颜色插值)
- `_B_surfaceNormals` → `_SupportSurfaceNormals` (支持表面法线)
- `_B_twoSidedNorms` → `_EnableTwoSidedNormals` (启用双面法线)
- `_posTexture` → `_PositionTexture` (位置纹理)
- `_rotTexture` → `_RotationTexture` (旋转纹理)
- `_colTexture` → `_ColorTexture` (颜色纹理)
- `_B_pscaleAreInPosA` → `_ScaleInPositionAlpha` (缩放在位置Alpha通道)
- `_globalPscaleMul` → `_GlobalScaleMultiplier` (全局缩放倍数)
- `_B_stretchByVel` → `_EnableVelocityStretch` (启用速度拉伸)
- `_stretchByVelAmount` → `_VelocityStretchAmount` (速度拉伸量)
- `_B_animateFirstFrame` → `_AnimateFirstFrame` (动画首帧)

### 代码结构优化
1. **清理了冗长的关键字排列组合代码**
2. **简化了复杂的数学计算逻辑**
3. **重构了四元数解码和旋转应用函数**
4. **优化了VAT UV坐标计算**
5. **添加了清晰的注释和文档**

### URP适配改进
1. **正确的URP Pass设置** (Universal Forward, ShadowCaster, DepthOnly)
2. **完整的URP光照系统集成**
3. **支持阴影投射和接收**
4. **支持雾效**
5. **正确的关键字管理**

## 使用方法

### 基本设置
1. 将Shader分配给材质
2. 设置VAT纹理：
   - `Position Texture`: 位置动画纹理
   - `Rotation Texture`: 旋转动画纹理
   - `Color Texture`: 颜色纹理（可选）

### 动画控制
- `Enable Auto Playback`: 启用自动播放
- `Playback Speed`: 播放速度倍率
- `Houdini FPS`: Houdini中的帧率
- `Frame Count`: 总帧数

### 高级功能
- `Enable Two Position Textures`: 对于高精度位置数据
- `Enable Interframe Interpolation`: 启用帧间插值以获得更平滑的动画
- `Enable Velocity Stretch`: 根据速度拉伸物体

## Shader Features
使用以下关键字来启用不同功能：
- `_ENABLE_COLOR_TEXTURE`: 启用颜色纹理
- `_ENABLE_TWO_POSITION_TEXTURES`: 启用双位置纹理
- `_ENABLE_SMOOTH_TRAJECTORIES`: 启用平滑轨迹
- `_ENABLE_NORMAL_TEXTURE`: 启用法线纹理

## 性能优化
1. 仅在需要时启用Shader Features
2. 根据项目需求调整LOD级别
3. 考虑使用GPU Instancing进行大量相同对象的渲染

## 兼容性
- Unity 2021.3+
- Universal Render Pipeline 12.0+
- 支持所有平台（PC、移动设备、主机）

## 注意事项
- 确保VAT纹理格式正确
- Piece ID必须正确设置在UV1.x通道中
- 边界信息应该与Houdini导出的数据匹配

## 故障排除

### 常见问题
1. **动画不播放**: 检查`Frame Count`和`Enable Auto Playback`设置
2. **位置偏移**: 验证边界设置是否与Houdini匹配
3. **旋转异常**: 确保旋转纹理格式正确（通常是RGBA32）
4. **性能问题**: 禁用不需要的Shader Features

### Debug技巧
- 使用Frame Debugger查看纹理采样
- 检查UV坐标是否在[0,1]范围内
- 验证Piece ID是否正确传递