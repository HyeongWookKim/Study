# coding: utf-8
import os
# 작업 directory 변경
os.chdir("C:/Users/Brian/Desktop/Data Science/DL_study/밑바닥부터 시작하는 딥러닝_1/deep-learning-from-scratch-master")
import numpy as np
from common.functions import softmax, cross_entropy_error
from common.gradient import numerical_gradient


class simpleNet:
    def __init__(self):
        self.W = np.random.randn(2, 3) # 정규분포로 초기화

    def predict(self, x):
        return np.dot(x, self.W)

    def loss(self, x, t):
        z = self.predict(x)
        y = softmax(z)
        loss = cross_entropy_error(y, t)

        return loss

x = np.array([0.6, 0.9])
t = np.array([0, 0, 1])

net = simpleNet()

f = lambda w: net.loss(x, t)
# 위의 함수 정의 코드는 다음과 동일한 코드임
# def f(W):
#     return net.loss(x, t)
dW = numerical_gradient(f, net.W)

print(dW)