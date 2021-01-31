# coding: utf-8

class MulLayer:
    # 인스턴스 변수인 x와 y를 초기화
    def __init__(self):
        self.x = None
        self.y = None

    def forward(self, x, y):
        self.x = x
        self.y = y                
        out = x * y

        return out

    def backward(self, dout):
        # x와 y를 바꾼다
        dx = dout * self.y
        dy = dout * self.x

        return dx, dy


class AddLayer:
    # 덧셈 계층에서는 초기화가 필요 없다
    def __init__(self):
        pass

    def forward(self, x, y):
        out = x + y

        return out

    def backward(self, dout):
        dx = dout * 1
        dy = dout * 1

        return dx, dy