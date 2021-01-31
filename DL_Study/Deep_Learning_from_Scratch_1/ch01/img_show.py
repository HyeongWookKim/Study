# coding: utf-8
import matplotlib.pyplot as plt
from matplotlib.image import imread

path = "C:/Users/Brian/Desktop/Data Science/DL_study/밑바닥부터 시작하는 딥러닝_1/deep-learning-from-scratch-master"
img = imread('{}/dataset/cactus.png'.format(path)) # 이미지 읽어오기
plt.imshow(img)

plt.show()