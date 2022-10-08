import torch
import numpy as np
from matplotlib import pyplot as plt

# 学习率
learning_rate = 0.1

# (1)准备数据
x_input = torch.rand(500, 1)
# print("x_input: ")
# print(x_input)

# 真实曲线
y_real = 3 * x_input + 0.6

# 构造预测曲线
w = torch.rand(1, requires_grad=True)           # 初始值随机取
b = torch.zeros(1, requires_grad=True)          # 截距初始值为0
# y_predict = matmul(x_input, w) + b            # 注意这个方法可以让张量相乘，并保存到历史中，
# y_predict = x_input * w + b                     # 看来运算符已经重载了，和matmul是相同的效果
# print(w.shape)
# print(b.shape)
# print("w: ")
# print(w)
# print("y_predict:")
# print(y_predict)

# 进行锻炼
for i in range(50):
    # 每一次锻炼需要更新参数，更新损失函数，更新预测的那条曲线
    y_predict = x_input * w + b
    # 更新损失函数
    loss = (y_predict - y_real).pow(2).mean()        # 均值损失函数（有问题，只能均值吗，还不能随便乘了是吧）
    # 更新预测曲线
    # 梯度非零时需要置为0，不然会影响到下一次的训练，因为tensor的梯度会累加
    if w.grad is not None:
        w.grad.zero_()
    if b.grad is not None:
        b.grad.zero_()

    loss.backward()
    # 更新参数
    w.data = w.data - w.grad * learning_rate
    b.data = b.data - b.grad * learning_rate
    if i % 50 == 0:
        print(loss)
        print("w: ", w.item())
        print("b: ", w.item())

# 画图，怎么个画法
plt.figure(figsize=(8, 4))
plt.scatter(x_input.numpy().reshape(-1), y_real.numpy().reshape(-1))
y_predict = x_input * w + b
plt.plot(x_input.numpy().reshape(-1), y_predict.detach().numpy().reshape(-1), c = 'r')
plt.show()