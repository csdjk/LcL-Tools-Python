
-- 批量转换 MAX 文件到 FBX
-- 自动生成的 MAXScript

-- 设置路径
inputFolder = @"E:\\Temp\\136\\max"
outputFolder = @"E:\\Temp\\136\\fbx"

-- 确保输出文件夹存在
makeDir outputFolder

-- 获取所有 .max 文件
files = getFiles (inputFolder + "\*.max")

-- 遍历转换
for file in files do (
    print ("正在转换: " + file)
    
    -- 加载文件
    loadMaxFile file quiet:true
    
    -- 构造输出文件名
    baseName = getFilenameFile file
    fbxFile = outputFolder + "\\" + baseName + ".fbx"
    
    -- 导出为 FBX
    try (
        exportFile fbxFile #noPrompt
        print ("转换成功: " + fbxFile)
    ) catch (
        print ("转换失败: " + file)
    )
)

print "批量转换完成!"
