from math import exp
import torch

# 视频上的例子：
x = torch.ones(2, 2);
x.requires_grad_(True)      # requires_grad_设置为True，可以追踪历史
print(x)

y = x + 2
print(y)
z = y * y * 3
print(z)
out = z.mean();
print(out)

out.backward()      # out就相当于是损失函数，从它这个地方开始向前传播
print(x.grad)       # 得到 dout / dx ，也就是得到了out对x的梯度

print(z.detach().numpy()) # 不能直接转

# 为什么在反向传播时需要把x的梯度值清零的原因（自动会累加的，会对之后的结果造成影响，https://blog.csdn.net/Fhujinwu/article/details/108567324）：
# x.grad.zero_()
# w = x.sum()
# w.backward()
# print(x.grad)


# 自己随便弄的一个例子：
# x = torch.ones(2, 2, requires_grad=True)
# y = exp(x)
# z = y + 1
# w = 1 / z

# print(w)