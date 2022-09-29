from pyexpat import model
from statistics import mode
from wsgiref.headers import tspecials
import tensorflow as tf
import pandas as pd
import matplotlib.pyplot as plt
import keras
import keras.layers as layer


csv_path = 'D:/learning_files/datasets/income.csv'
data = pd.read_csv(csv_path)

x = data.Education
y = data.Income

model = keras.Sequential()
model.add(layer.Dense(1, input_shape=(1,)))

model.compile(optimizer='adam', loss='mse')     #梯度下降算法-均方差
history = model.fit(x, y, epochs=500)

model.summary()

model.predict(pd.Series([20]))

# plt.scatter(data.Education, data.Income)

print('paused for showing pic')