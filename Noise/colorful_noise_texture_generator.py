import numpy as np
import cv2
from PIL import Image, ImageDraw
import random
import argparse
import os
from scipy.spatial import Voronoi
import colorsys


class ColorfulNoiseGenerator:
    def __init__(self, width=512, height=512, seed=None):
        """
        初始化彩色噪声生成器
        
        Args:
            width: 纹理宽度
            height: 纹理高度
            seed: 随机种子，用于重现结果
        """
        self.width = width
        self.height = height
        if seed is not None:
            random.seed(seed)
            np.random.seed(seed)
        
    def generate_random_colors(self, num_colors=50):
        """
        生成随机鲜艳的颜色列表
        """
        colors = []
        
        # 添加一些基础鲜艳颜色
        base_colors = [
            (255, 0, 0),    # 红
            (0, 255, 0),    # 绿
            (0, 0, 255),    # 蓝
            (255, 255, 0),  # 黄
            (255, 0, 255),  # 洋红
            (0, 255, 255),  # 青
            (255, 128, 0),  # 橙
            (128, 0, 255),  # 紫
            (255, 0, 128),  # 粉红
            (0, 0, 0),      # 黑
            (255, 255, 255), # 白
            (128, 128, 128), # 灰
        ]
        
        colors.extend(base_colors)
        
        # 生成更多随机鲜艳颜色
        for _ in range(num_colors - len(base_colors)):
            # 使用HSV颜色空间生成鲜艳颜色
            hue = random.random()
            saturation = random.uniform(0.7, 1.0)  # 高饱和度
            value = random.uniform(0.6, 1.0)       # 高亮度
            
            rgb = colorsys.hsv_to_rgb(hue, saturation, value)
            rgb = tuple(int(c * 255) for c in rgb)
            colors.append(rgb)
        
        return colors
    
    def generate_voronoi_noise(self, num_points=200, colors=None):
        """
        生成基于Voronoi图的彩色噪声
        """
        if colors is None:
            colors = self.generate_random_colors()
        
        # 生成随机点
        points = []
        for _ in range(num_points):
            x = random.uniform(-self.width * 0.2, self.width * 1.2)
            y = random.uniform(-self.height * 0.2, self.height * 1.2)
            points.append([x, y])
        
        points = np.array(points)
        
        # 创建Voronoi图
        vor = Voronoi(points)
        
        # 创建图像
        image = np.zeros((self.height, self.width, 3), dtype=np.uint8)
        
        # 为每个像素找到最近的Voronoi点并着色
        for y in range(self.height):
            for x in range(self.width):
                # 找到最近的点
                distances = np.sum((points - np.array([x, y]))**2, axis=1)
                nearest_point_idx = np.argmin(distances)
                
                # 分配颜色
                color_idx = nearest_point_idx % len(colors)
                image[y, x] = colors[color_idx]
        
        return image
    
    def generate_cellular_noise(self, cell_size_range=(5, 25), colors=None):
        """
        生成细胞状的彩色噪声
        """
        if colors is None:
            colors = self.generate_random_colors()
        
        image = np.zeros((self.height, self.width, 3), dtype=np.uint8)
        
        # 使用PIL进行绘制，性能更好
        pil_image = Image.new('RGB', (self.width, self.height), (0, 0, 0))
        draw = ImageDraw.Draw(pil_image)
        
        # 生成随机多边形
        num_polygons = random.randint(300, 800)
        
        for _ in range(num_polygons):
            # 随机中心点
            center_x = random.randint(0, self.width)
            center_y = random.randint(0, self.height)
            
            # 随机多边形
            num_vertices = random.randint(3, 8)
            size = random.randint(*cell_size_range)
            
            vertices = []
            for i in range(num_vertices):
                angle = (2 * np.pi * i / num_vertices) + random.uniform(-0.5, 0.5)
                radius = size + random.uniform(-size*0.3, size*0.3)
                
                x = center_x + int(radius * np.cos(angle))
                y = center_y + int(radius * np.sin(angle))
                vertices.append((x, y))
            
            # 随机颜色
            color = random.choice(colors)
            
            # 绘制多边形
            draw.polygon(vertices, fill=color)
        
        return np.array(pil_image)
    
    def generate_pixel_noise(self, block_size_range=(2, 8), colors=None):
        """
        生成像素块状的彩色噪声
        """
        if colors is None:
            colors = self.generate_random_colors()
        
        image = np.zeros((self.height, self.width, 3), dtype=np.uint8)
        
        y = 0
        while y < self.height:
            x = 0
            while x < self.width:
                # 随机块大小
                block_w = random.randint(*block_size_range)
                block_h = random.randint(*block_size_range)
                
                # 确保不超出边界
                block_w = min(block_w, self.width - x)
                block_h = min(block_h, self.height - y)
                
                # 随机颜色
                color = random.choice(colors)
                
                # 填充块
                image[y:y+block_h, x:x+block_w] = color
                
                x += block_w
            y += random.randint(*block_size_range)
        
        return image
    
    def generate_mixed_noise(self, colors=None, **kwargs):
        """
        生成混合类型的彩色噪声（最接近您提供的图片效果）
        """
        if colors is None:
            colors = self.generate_random_colors(60)
        
        # 先生成基础的像素块噪声
        image = self.generate_pixel_noise(
            block_size_range=kwargs.get('block_size_range', (3, 12)), 
            colors=colors
        )
        
        # 添加一些不规则形状
        pil_image = Image.fromarray(image)
        draw = ImageDraw.Draw(pil_image)
        
        # 添加随机不规则形状
        num_shapes = random.randint(50, 150)
        for _ in range(num_shapes):
            shape_type = random.choice(['ellipse', 'polygon', 'rectangle'])
            color = random.choice(colors)
            
            if shape_type == 'ellipse':
                # 随机椭圆
                x1 = random.randint(0, self.width)
                y1 = random.randint(0, self.height)
                w = random.randint(5, 30)
                h = random.randint(5, 30)
                x2, y2 = x1 + w, y1 + h
                draw.ellipse([x1, y1, x2, y2], fill=color)
                
            elif shape_type == 'polygon':
                # 随机多边形
                center_x = random.randint(0, self.width)
                center_y = random.randint(0, self.height)
                num_vertices = random.randint(3, 6)
                size = random.randint(8, 25)
                
                vertices = []
                for i in range(num_vertices):
                    angle = (2 * np.pi * i / num_vertices) + random.uniform(-1, 1)
                    radius = size + random.uniform(-size*0.4, size*0.4)
                    
                    x = center_x + int(radius * np.cos(angle))
                    y = center_y + int(radius * np.sin(angle))
                    vertices.append((x, y))
                
                draw.polygon(vertices, fill=color)
            
            elif shape_type == 'rectangle':
                # 随机矩形
                x1 = random.randint(0, self.width)
                y1 = random.randint(0, self.height)
                w = random.randint(5, 25)
                h = random.randint(5, 25)
                x2, y2 = x1 + w, y1 + h
                draw.rectangle([x1, y1, x2, y2], fill=color)
        
        return np.array(pil_image)
    
    def add_noise_variation(self, image, variation_strength=0.1):
        """
        为图像添加轻微的颜色变化
        """
        noise = np.random.normal(0, variation_strength * 255, image.shape)
        noisy_image = image.astype(np.float32) + noise
        noisy_image = np.clip(noisy_image, 0, 255)
        return noisy_image.astype(np.uint8)
    
    def save_texture(self, image, filename, format='PNG'):
        """
        保存纹理图像
        """
        if format.upper() in ['JPG', 'JPEG']:
            cv2.imwrite(filename, cv2.cvtColor(image, cv2.COLOR_RGB2BGR))
        else:
            Image.fromarray(image).save(filename, format=format)
        print(f"纹理已保存到: {filename}")


def main():
    parser = argparse.ArgumentParser(description='彩色几何噪声纹理生成器')
    parser.add_argument('--width', type=int, default=512, help='纹理宽度 (默认: 512)')
    parser.add_argument('--height', type=int, default=512, help='纹理高度 (默认: 512)')
    parser.add_argument('--output', type=str, default='colorful_noise_texture.png', 
                       help='输出文件名 (默认: colorful_noise_texture.png)')
    parser.add_argument('--type', type=str, default='mixed', 
                       choices=['voronoi', 'cellular', 'pixel', 'mixed'],
                       help='噪声类型 (默认: mixed)')
    parser.add_argument('--seed', type=int, help='随机种子')
    parser.add_argument('--num-colors', type=int, default=50, help='颜色数量 (默认: 50)')
    parser.add_argument('--block-size-min', type=int, default=3, help='最小块尺寸 (默认: 3)')
    parser.add_argument('--block-size-max', type=int, default=12, help='最大块尺寸 (默认: 12)')
    parser.add_argument('--add-noise', action='store_true', help='添加颜色噪声变化')
    parser.add_argument('--batch', type=int, help='批量生成数量')
    
    args = parser.parse_args()
    
    print("彩色几何噪声纹理生成器")
    print("=" * 50)
    print(f"纹理尺寸: {args.width} x {args.height}")
    print(f"噪声类型: {args.type}")
    print(f"颜色数量: {args.num_colors}")
    
    if args.batch:
        print(f"批量生成: {args.batch} 张")
        
        # 批量生成
        for i in range(args.batch):
            # 为每张图使用不同的随机种子
            seed = args.seed + i if args.seed else None
            generator = ColorfulNoiseGenerator(args.width, args.height, seed)
            
            # 生成颜色
            colors = generator.generate_random_colors(args.num_colors)
            
            # 生成纹理
            if args.type == 'voronoi':
                image = generator.generate_voronoi_noise(colors=colors)
            elif args.type == 'cellular':
                image = generator.generate_cellular_noise(colors=colors)
            elif args.type == 'pixel':
                image = generator.generate_pixel_noise(
                    block_size_range=(args.block_size_min, args.block_size_max),
                    colors=colors
                )
            else:  # mixed
                image = generator.generate_mixed_noise(
                    colors=colors,
                    block_size_range=(args.block_size_min, args.block_size_max)
                )
            
            # 添加噪声变化
            if args.add_noise:
                image = generator.add_noise_variation(image)
            
            # 生成文件名
            name, ext = os.path.splitext(args.output)
            filename = f"{name}_{i+1:03d}{ext}"
            
            # 保存
            generator.save_texture(image, filename)
            print(f"已生成 {i+1}/{args.batch}: {filename}")
    
    else:
        # 单张生成
        generator = ColorfulNoiseGenerator(args.width, args.height, args.seed)
        
        # 生成颜色
        colors = generator.generate_random_colors(args.num_colors)
        
        # 生成纹理
        print(f"正在生成 {args.type} 类型纹理...")
        
        if args.type == 'voronoi':
            image = generator.generate_voronoi_noise(colors=colors)
        elif args.type == 'cellular':
            image = generator.generate_cellular_noise(colors=colors)
        elif args.type == 'pixel':
            image = generator.generate_pixel_noise(
                block_size_range=(args.block_size_min, args.block_size_max),
                colors=colors
            )
        else:  # mixed
            image = generator.generate_mixed_noise(
                colors=colors,
                block_size_range=(args.block_size_min, args.block_size_max)
            )
        
        # 添加噪声变化
        if args.add_noise:
            print("添加颜色噪声变化...")
            image = generator.add_noise_variation(image)
        
        # 保存
        generator.save_texture(image, args.output)
        
        # 显示预览（如果可能）
        try:
            import matplotlib.pyplot as plt
            plt.figure(figsize=(10, 10))
            plt.imshow(image)
            plt.axis('off')
            plt.title(f'生成的彩色噪声纹理 ({args.type})')
            plt.tight_layout()
            plt.show()
        except ImportError:
            print("matplotlib 未安装，跳过预览显示")
    
    print("\n生成完成!")


if __name__ == "__main__":
    main()