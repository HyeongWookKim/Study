### 모듈에 클래스 작성하기 ###
class Person:
    def __init__(self, name, age, address):
        self.name = name
        self.age = age
        self.address = address
 
    def greeting(self):
        print('안녕하세요. 저는 {}입니다.'.format(self.name))