# coding: utf-8
import os
# 작업 directory 변경
os.chdir("C:/Users/Brian/Desktop/Data Science/DL_study/밑바닥부터 시작하는 딥러닝_1/deep-learning-from-scratch-master")
import numpy as np
from ch07.simple_convnet import SimpleConvNet


network = SimpleConvNet(input_dim=(1,10, 10), 
                        conv_param = {'filter_num':10, 'filter_size':3, 'pad':0, 'stride':1},
                        hidden_size=10, output_size=10, weight_init_std=0.01)

X = np.random.rand(100).reshape((1, 1, 10, 10))
T = np.array([1]).reshape((1,1))

grad_num = network.numerical_gradient(X, T)
grad = network.gradient(X, T)

for key, val in grad_num.items():
    print(key, np.abs(grad_num[key] - grad[key]).mean())