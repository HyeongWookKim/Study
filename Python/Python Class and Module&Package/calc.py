### 스크립트 파일로 실행하거나 모듈로 사용하는 코드 만들기 ###
def add(a, b):
    return a + b
 
def mul(a, b):
    return a * b

# 프로그램의 시작점일 때만 아래의 코드를 실행함
# calc.py를 모듈로 사용하면 아무것도 출력되지 않음
# 스크립트 파일을 모듈로 사용할 때는 "calc.add()"와 "calc.mul()" 함수에 원하는 값을 넣어서 사용하면 됨
if __name__ == '__main__':
    print(add(10, 20))
    print(mul(10, 20))