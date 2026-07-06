import numpy as np
import matplotlib.pyplot as plt

threshold_start = 0.90   # 开始映射的阈值
threshold_map = 0.92     # 映射后的最大值
x = np.linspace(0, 1, 1000)

def smooth_curve(x, power=2.0):
    """
    平滑亮度映射曲线：
    - 输入小于等于 threshold_start 时，输出等于输入（线性不变）
    - 输入大于 threshold_start 时，采用幂函数平滑过渡，将 [threshold_start, 1] 区间映射到 [threshold_start, threshold_map] 区间
    - power 控制过渡的平滑度，越大过渡越陡
    - 输出最大不会超过 threshold_map
    """
    x = np.asarray(x)
    y = np.where(
        x <= threshold_start,
        x,
        threshold_start + (threshold_map - threshold_start) * ((x - threshold_start) / (1 - threshold_start)) ** (1/power)
    )
    y = np.clip(y, 0, threshold_map)
    return y

plt.figure(figsize=(8, 6))
plt.plot(x, x, label='Linear (No Clamp)')
plt.plot(x, smooth_curve(x, power=2.0), label=f'Smooth (start={threshold_start}, map={threshold_map})')
plt.axvline(threshold_start, color='gray', linestyle='--', label='Start Threshold')
plt.axhline(threshold_map, color='red', linestyle='--', label='Map Threshold')

# 标记阈值点
y_val = smooth_curve(threshold_start)
plt.scatter([threshold_start], [y_val], color='C1', s=60, marker='o', edgecolors='k', zorder=5)
plt.text(threshold_start, y_val, f'  ({threshold_start:.2f},{y_val:.2f})', color='C1', va='bottom', fontsize=9)

plt.xlabel('Input')
plt.ylabel('Output')
plt.title('Smooth Tone Mapping Curve')
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()