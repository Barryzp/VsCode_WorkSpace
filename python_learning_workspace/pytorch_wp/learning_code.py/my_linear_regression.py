import torch
import matplotlib.pyplot as plt


# 定义学习率
learning_rate = 0.1

sample_step = 100

# 学习tensor向量
x_input = torch.arange(0, 1, 1 / sample_step)
y_real = -3 * x_input + 0.8

print(x_input.shape)
w = torch.ones(1, 1, requires_grad=True)
b = torch.tensor([0], dtype=torch.float64, requires_grad=True)
print(b)

for i in range(500):
    y_predict = x_input * w + b
    loss = (y_real - y_predict).pow(2).mean()
    if w.grad != None:
        w.grad.zero_()
    if b.grad != None:
        b.grad.zero_()
    
    # 梯度反向指的是损失函数对未知参数求导的反方向
    loss.backward()
    w.data = w.data - learning_rate * w.grad
    b.data = b.data - learning_rate * b.grad

    if i%10 == 0:
        print("w: ", w.item())
        print("b: ", b.item())


plt.scatter(x_input, y_real)
plt.plot(x_input.detach().numpy().reshape(-1), y_predict.detach().numpy().reshape(-1), c = "r")
plt.show()