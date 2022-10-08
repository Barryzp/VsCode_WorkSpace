from cmath import cos
import matplotlib.pyplot as plt
import numpy as np

# 如何画一条直线：
xpoints = np.array([0, 1, 2, 0.5])
ypoints = np.array([0, 0.8, 1, 4])
# plt.plot()函数来画线，前面是x坐标组成的数组，后面是y坐标构成的数组，其中的参数是这样的：
# https://www.runoob.com/matplotlib/matplotlib-pyplot.html
plt.plot(xpoints, ypoints,'b-.')  # 'o'代表只显示点

# 再画一条正弦曲线和余弦曲线
x = np.arange(0, 4 * np.pi, 0.1)        # 0.1代表步长
sin_y = np.sin(x)
cos_y = np.cos(x)
plt.plot(x, sin_y, x, cos_y)
plt.show()
