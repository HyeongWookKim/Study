# coding: utf-8
import os
# 작업 directory 변경
os.chdir("C:/Users/Brian/Desktop/Data Science/DL_study/밑바닥부터 시작하는 딥러닝_1/deep-learning-from-scratch-master")
import numpy as np
import pickle
from dataset.mnist import load_mnist
from common.functions import sigmoid, softmax


def get_data():
    (x_train, t_train), (x_test, t_test) = load_mnist(normalize = True, flatten = True, one_hot_label = False)
    return x_test, t_test

def init_network():
    with open('./ch03/sample_weight.pkl', 'rb') as f:
        network = pickle.load(f)

    return network

def predict(network, x):
    w1, w2, w3 = network['W1'], network['W2'], network['W3']
    b1, b2, b3 = network['b1'], network['b2'], network['b3']

    a1 = np.dot(x, w1) + b1
    z1 = sigmoid(a1)
    a2 = np.dot(z1, w2) + b2
    z2 = sigmoid(a2)
    a3 = np.dot(z2, w3) + b3
    y = softmax(a3)

    return y


x, t = get_data()
network = init_network()

batch_size = 100 # 배치 크기
accuracy_cnt = 0

for i in range(0, len(x), batch_size):
    x_batch = x[i: i + batch_size]
    y_batch = predict(network, x_batch)
    # 100 x 10 배열 중, 1번째 차원을 구성하는 각 원소에서(즉, 1번째 차원을 축으로) 최댓값의 인덱스를 찾는다.
    p = np.argmax(y_batch, axis = 1)
    # 넘파이 배열끼리 비교해서 True/False로 구성된 bool 배열을 만들고, 이 결과 배열에서 True가 몇 개인지 센다.
    accuracy_cnt += np.sum(p == t[i: i + batch_size])

print('Accuracy:' + str(float(accuracy_cnt) / len(x)))