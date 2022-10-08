from audioop import tostereo
from pyexpat import model
from statistics import mode
from turtle import forward
import torch
from torch import nn
from torch import cuda
from torch.utils.data import DataLoader
from torchvision import datasets
from torchvision.transforms import ToTensor

#在 torchvision，torchText，TorchVideo中都包括数据集
''' 多行注释：
从公开数据集里下载训练集
datasets中已经包括了许多的数据集(包括MNIST)，可以去里面看看
ToTensor()    #Convert a PIL Image or numpy.ndarray to tensor. 也就是转化成PyTorch能快速处理的tensor类型
tensor:张量，其实可以看成是多维数组。
使用如下下载数据集它会默认下载到文件夹父级，并且下载下来之后不会接着下载，会利用已经下载完毕的
'''

training_data = datasets.FashionMNIST(
    root="data",
    train=True,
    download=True,
    transform=ToTensor()    #Convert a PIL Image or numpy.ndarray to tensor. 也就是转化成PyTorch能快速处理的tensor类型
)

test_data = datasets.FashionMNIST(
    root="data",
    train=False,
    download=True,
    transform=ToTensor()
)

batch_size = 64

#创建一个训练集加载器对象
train_loader = DataLoader(training_data, batch_size=batch_size)
test_loader = DataLoader(test_data, batch_size=batch_size)

for X, y in test_loader:
    print(f"Shape of X [N, C, H, W]: {X.shape}")
    print(f"Shape of y: {y.shape} {y.dtype}")
    break


device = "cuda" if cuda.is_available() else "cpu"
print(f"Using {device} device")

class NeuralNetwork(nn.Module):
    def __init__(self) -> None:
        super(NeuralNetwork, self).__init__()
        self.flatten = nn.Flatten()
        self.linear_relu_stack = nn.Sequential(
            nn.Linear(28 * 28, 512),
            nn.ReLU(),
            nn.Linear(512, 512),
            nn.ReLU(),
            nn.Linear(512, 10),
        )
    def forward(self, x):
        x = self.flatten(x)
        logits = self.linear_relu_stack(x)
        return logits

model = NeuralNetwork().to(device)
print(model)