# coding: utf-8
import os
# 작업 directory 변경
os.chdir("C:/Users/Brian/Desktop/Data Science/DL_study/밑바닥부터 시작하는 딥러닝_1/deep-learning-from-scratch-master")
import numpy as np
from dataset.mnist import load_mnist
from ch05.two_layer_net import TwoLayerNet


# 데이터 읽기
(x_train, t_train), (x_test, t_test) = load_mnist(normalize = True, one_hot_label = True)

network = TwoLayerNet(input_size = 784, hidden_size = 50, output_size = 10)

x_batch = x_train[:3]
t_batch = t_train[:3]

# 기울기 확인
grad_numerical = network.numerical_gradient(x_batch, t_batch) # 수치 미분 방식
grad_backprop = network.gradient(x_batch, t_batch)            # 오차역전파 방식

# 각 가중치의 절대 오차의 평균을 구한다
for key in grad_numerical.keys():
    diff = np.average(np.abs(grad_backprop[key] - grad_numerical[key]))
    print(key + ":" + str(diff))