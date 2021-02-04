### 모듈 사용하기 ###
import square2               # import로 square2 모듈을 가져옴
 
print(square2.base)          # 모듈.변수 형식으로 모듈의 변수 사용
print(square2.square(10))    # 모듈.함수() 형식으로 모듈의 함수 사용


### from import로 변수, 함수 가져오기 ###
from square2 import base, square

print(base)
square(10)


### 모듈에 작성된 클래스 사용하기 ###
import person # import로 person 모듈을 가져옴
 
# 모듈.클래스()로 person 모듈의 클래스 사용
maria = person.Person('마리아', 20, '서울시 서초구 반포동')
maria.greeting()


### from import로 클래스 가져오기 ###
from person import Person

maria = Person('마리아', 20, '서울시 서초구 반포동')
maria.greeting()


### 모듈과 시작점 알아보기 ###
import hello # hello 모듈을 가져옴

print('main.py __name__:', __name__) # __name__ 변수 출력


### 패키지에 모듈 만들고 사용하기 ###
import calcpkg.operation    # calcpkg 패키지의 operation 모듈을 가져옴
import calcpkg.geometry     # calcpkg 패키지의 geometry 모듈을 가져옴
 
print(calcpkg.operation.add(10, 20))    # operation 모듈의 add 함수 사용
print(calcpkg.operation.mul(10, 20))    # operation 모듈의 mul 함수 사용
 
print(calcpkg.geometry.triangle_area(30, 40))    # geometry 모듈의 triangle_area 함수 사용
print(calcpkg.geometry.rectangle_area(30, 40))   # geometry 모듈의 rectangle_area 함수 사용


### from import로 패키지의 모듈에서 변수, 함수, 클래스 가져오기 ###
from calcpkg.operation import add, mul

add(10, 20)
mul(10, 20)


### import 패키지 형식으로 패키지만 가져와서 모듈을 사용하기 ### 
import calcpkg    # calcpkg 패키지만 가져옴
 
print(calcpkg.operation.add(10, 20))    # operation 모듈의 add 함수 사용
print(calcpkg.operation.mul(10, 20))    # operation 모듈의 mul 함수 사용
 
print(calcpkg.geometry.triangle_area(30, 40))    # geometry 모듈의 triangle_area 함수 사용
print(calcpkg.geometry.rectangle_area(30, 40))   # geometry 모듈의 rectangle_area 함수 사용


import calcpkg    # calcpkg 패키지만 가져옴
 
print(calcpkg.add(10, 20))   # 패키지.함수 형식으로 operation 모듈의 add 함수 사용
print(calcpkg.mul(10, 20))   # 패키지.함수 형식으로 operation 모듈의 mul 함수 사용
 
print(calcpkg.triangle_area(30, 40)) # 패키지.함수 형식으로 geometry 모듈의 triangle_area 함수 사용
print(calcpkg.rectangle_area(30, 40))# 패키지.함수 형식으로 geometry 모듈의 rectangle_area 함수 사용