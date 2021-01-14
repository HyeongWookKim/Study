# 01 R 프로그래밍 기초
## R 기초
### 연산
1+1
1/3
3*2.5
1 + (2-5)
1 % 5

?c() # Combine Values into a Vector or List
c(1, 3) - c(1, 3)
c(1) - c(1, 3)
c(1, 2) - c(1, 3, 1)
c(1, 2) - c(1, 3, 1, 4)

c(1, 3) / c(1, 3)
c(1) / c(1, 3)
c(1, 2) / c(1, 3, 1)
c(1, 2) / c(1, 3, 1, 4)

c(1, 3) * c(3)
c(1, 2, 3) * c(2, 3)
c(1, 2, 3) * c(1, 2, 1, 2, 1, 2)

1:5 * 2 # 콜론 연산
1:5 * 2:6
1:3 * 2:6
1:3 * 2:7

c(1, 3, 5) * 2:7 # 콜론과 c()의 연산
1:3 * 2:6

### 객체
#### 객체 생성
a <- 2 # 2를 a 라는 객체에 할당
abc = c(1, 3, 5) # c(1, 3, 5)의 벡터를 abc라는 객체에 할당
1:5 -> b # 1부터 5까지 연속된 숫자를 b라는 객체에 할당

#### 객체 확인
ls() # 객체 리스트 확인
a # 직접 a의 객체 내용 확인
abc
b


### 객체 연산
#### 객체와 벡터의 연산
a + 3
3 + abc
c(2, 3, 5) + abc

#### 객체와 객체의 연산
a * b
a / b

#### 객체 연산에서의 오류와 경고
b + abc
b + c(2, 3, 5)
a % b
a %% b  # 나머지
a %/% b # 몫

### 연습문제 01: 다음 중 객체 명명이 잘못된 것을 모두 고르시오.
A <- 1
abC <- 1
_var <- 1
3Car <- 1
car_var <- 1
car-var <- 1
Var* <- 1 <- 1
no_car <- 1
own.car <- 1
OWN <- 1
^car <- 1
자동차 <- 1
.자동차 <- 1
!소유 <- 1
수치_해석 <- 1

### 연습문제 02: X가 c(1:5)이고, y가 3:7일 때, 다음 연산의 결과를 적으시오.
x <- c(1:5)
y <- c(3:7)

x > 7
x <= 3
x[(x > 2) & (x <= 5)]
x - y


### 객체의 종류
#### 벡터
x <- c(1, 3, 5)
is.vector(x) # 벡터 여부 진단
length(x) # 벡터 길이 산정

y <- c("1", "3", "5") # 문자형 벡터
y

?mode
?typeof
?as.vector()

z <- as.vector(y, mode = 'numeric') # 실수형 벡터로 변환
z

mode(x)
mode(y)
mode(z)

typeof(x)
typeof(y)
typeof(z)

##### 정수형 벡터
x <- c(1, 3, 5)
mode(x)
typeof(x)

xL <- c(1L, 3L, 5L)
mode(xL)
typeof(xL)

sqrt(2)
sqrt(2)^2
sqrt(2)^2 - 2

##### 문자형 벡터
text <- c("hello", "my students", " ", "to my class!")
text
is.character(text)
typeof(text)
mode(text)

##### 논리형 벡터
logic <- c(TRUE, FALSE, TRUE, FALSE)
logic
typeof(logic)
length(logic)
3 - logic # TRUE: 1, FALSE: 0을 의미

#### 속성
x <- 1:9
attributes(x) # 속성확인
dim(x)

names(x) <- c("v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9")
attributes(x) # 속성확인

names(x) <- NULL # 속성 이름 제거
attributes(x) # 속성 제거

x + 1 # 실제 객체 값에 영향을 주지 않음

dim(x) <- c(3, 3) # 차원을 3*3으로 부여
x
attributes(x) # 속성확인
dim(x) <- NULL # 속성 제거
x

#### 행렬
m <- matrix(1:10, nrow = 2)
m

m2 <- matrix(m, ncol = 2, byrow = TRUE)
m2

class(m2)
attributes(m2)
dim(m2)
ncol(m2)
nrow(m2)

#### 배열
aa <- array(1:30, dim = c(2, 3, 5)) # 2x3 행렬이 5차원 배열
aa

class(aa)
attributes(aa)
dim(aa)

#### 리스트
x <- list(1:10, c('R', 'N'), c(TRUE, FALSE))
x

x2 <- list(1:10, c('R', 'N'), list(TRUE, FALSE)) # 리스트의 리스트
x2

#### 데이터 프레임
x <- data.frame(id = 1:3, name = c('R', 'N', 'S'), logic = c(TRUE, FALSE, TRUE))
x

class(x)
attributes(x)

y <- as.matrix(x) # 행렬로 강제변환
y # 단일 속성만 허용되기 때문에 문자로 모두 강제 변환
class(y)

#### 강제변환 (변환규칙: 문자형 > 숫자형 > 논리형)
x <- c(1, "T")
x

x2 <- c(1, FALSE)
x2

x3 <- c(1, "F", FALSE)
x3 

#### 요인: 범주형 정보
x <- c("male", "female", "female", "male", "female", "bi-gender")
x
typeof(x)
attributes(x)

x2 <- factor(x)
x2
typeof(x2)
attributes(x2)

?unclass
unclass(x2) # Level 표현없이 class 특징을 없애고, 단순한 상수만 출력
x2

#### NA(Not Available), NaN(Not a Number), NULL(없는 값)
x <- c(NaN, NA)
x
is.na(x)
is.nan(x)

x + 2

x <- NULL
x

#### 연습문제 03: 다음의 문자형 벡터를 숫자형 벡터로 전환하고, 그 속성값을 확인하는 명령문을 작성하시오.
z <- c('1', '5', '10')
z
typeof(z)
class(z)

z2 <- as.numeric(z)
z2
typeof(z2)
class(z2)

#### 연습문제 04: 하나의 벡터에서 문자형, 숫자형, 요인형, 논리형 값들이 모두 존재할 때, 
#### 어떠한 자료형으로 강제 변환되어 나타나는가?
x <- c("korea", 3, factor("num"), TRUE)
x


## R 함수
### 함수와 인수
#### 내장함수의 예
round(2.5456)
mean(c(1, 3, 5))
x <- 1:20
mean(x)
round(mean(x))
abs(-3)

#### 내장함수 정의와 내용
?round
?mean
?abs

#### 내장 함수에서의 인수 활용 방법
round(2.47245, digits = 3)
?round
args(round) # 해당 함수의 인수 확인 방법
round(2.47245, digits = 2)
?trunc
trunc(5.9987, digits = 3) # 자름

### 내장 함수의 종류
#### 숫자 함수
sqrt(10)
round(2.587, digits = 2)
trunc(2.387, digits = 2)
ceiling(2.387)
log(20)
exp(3)

#### 통계확률 함수
?dnorm # 정규분포 밀도(density) 함수: dnorm(x, mean = 0, sd = 1, log = FALSE)
dnorm(0.5, mean = 0, sd = 1) # returns the value of the probability density function
dnorm(0.5)
dnorm(4, mean = 5, sd = 3)

?pnorm # 정규분포 확률(density) 함수
pnorm(2) # pnorm(q, mean = 0, sd = 1)
pnorm(2, mean = 5, sd = 3)

?qnorm # 정규분포 분위(density) 함수: qnorm(p, mean = 0, sd = 1)
qnorm(.5) # 평균=0, 표준편차=1인 정규분포에서의 50번째 분위의 값은?
qnorm(.96)

?rnorm # 무작위(random) 정규분포 생성함수
rnorm(5) # rnorm(n, mean = 0, sd = 1)
rnorm(5, mean = 2, sd = 3)
x <- rnorm(10000) # rnorm(n, mean = 0, sd = 1)
plot(x)
hist(x)

#### 기타 통계함수
mean(1:20)
?mean
mean(c(5, 1:20), trim = 0.1) # 10% 상/하위 절사(trim) 평균
sd(1:20)
median(1:20)
quantile(1:20, c(0.3, 0.5, 0.7))
range(1:20)
sum(1:20)
min(1:20)
max(1:20)

### 사용자 정의 함수 만들기
# 예: 평균이 m이고, 표준편차가 s인 정규분포로 n개의 숫자를 무작위로 추출하여 
# 히스토그램을 그리고 또한 이의 중위값을 함수 작성
norm_hist <- function(n, m, s) {
  x <- rnorm(n, mean = m, sd = s)
  hist(x)
  median(x)
}

norm_hist(m = 0, s = 1, n = 1000) # 함수 호출
norm_hist(m = 150, s = 16, n = 15000) # 함수 호출

# R 사용자 정의 함수 정의 및 호출 추가 예제
#### X와 y의 객체를 제곱하여, 그 합을 구하는 함수 정의
f_xy <- function(x, y) {
  z <- x^2 + y^2
  return(z)
}

f_xy(x = 2, y = 3)
f_xy(x = 100, y = 25)
f_xy(x = 1, y = 3)
f_xy(x = 3, y = 7)

#### 객체 x의 평균, 표준편차, 최솟값, 최댓값을 구하는 사용자 정의 함수
x_stat <- function(x) {
  x_mean <- mean(x)
  x_sd <- sd(x)
  x_min <- min(x)
  x_max <- max(x)
  return(c(x_mean, x_sd, x_min, x_max))
}

x_stat(x = 1:20)
x_stat(x = 5:10)
x_stat(x = c(1, 3, 5, 7:15))

### 연습문제 05-07
#### 0.1968의 숫자에 대하여 소숫점 둘째 자리까지 반올림하고자 한다. 
#### 이 때 사용하게 되는 함수와 명령문은? 그 결과값은?
round(0.1968, digits = 2)

#### 평균이 1이고, 표준편차가 5인 정규분포로 10개의 숫자를 무작위로 추출하여 생성하라는 명령문을 작성하시오.
rnorm(10, m = 1, sd = 5)

#### 1부터 50까지 숫자로 된 벡터에 대하여 표준편차와 중위값, 그리고 합계를 구하시오. 
sd(1:50)
median(1:50)
sum(1:50)

### 연습문제 08
# 2개의 주사위(1:6)를 던져 나오는 숫자의 합을 구하는 함수를 정의하시오. 이때의 함수는 ‘r_dice’ 명명하고, 사용하는 무작위 무작위 샘플링 함수는 sample()이고, 복원 추출 인수(replace = TRUE)를 사용하시오.
?sample

r_dice <- function() {
  x <- c(1:6)
  y <- sample(x, size = 2, replace = TRUE)
  print(y)
  sum(y)
}

r_dice() # 함수호출1
r_dice() # 함수호출2
r_dice() # 함수호출3


## R 프로그래밍 기초
### 조건문
### 한 개의 숫자가 짝수인지 홀수인지에 따라 실행내용이 다를 경우의 조건문 작성
x <- 5
if (x %% 2 == 0) {
  y <- '짝수'
  print(y)
  } else {
  y <- '홀수'
  print(y)
  }

x <- c(-3:3, 7) # 다수의 숫자들인 경우 warning 발생
if (x %% 2 == 0) {
  y <- '짝수'
  print(y)
} else {
  y <- '홀수'
  print(y)
}

### 다수의 숫자들에 대하여 짝수인지 홀수인지에 따라 실행내용이 다를 경우의 조건문 작성
x <- c(-3:3, 7)
z <- ifelse(x %% 2 == 0, '짝수', '홀수')
xz <- data.frame(x, z)
xz

### 두 개 이상의 논리값 진단에 따른 조건문 작성성
x <- c(-5:5)
z <- ifelse(x %% 5 == 0, y <- 'zero',
            ifelse(x %% 5 == 1, y <- 'one',
                   ifelse(x %% 5 == 2, y <- 'two',
                          ifelse(x %% 5 == 3, y <- 'three', y <- 'four'))))
xz <- data.frame(x, z)
xz
                   
xy <- data.frame(x = c(1:10), y = c(14:5))
xy

xyz <- ifelse(xy$x >= 5 & xy$y >= 8, 'f1',
              ifelse(xy$x < 5 & xy$y >= 8, 'f2', 'f3'))
xyz

### 반복문
#### for 문
# 1부터 10까지 숫자 벡터인 객체 x에 1씩 더하면서 y = 10 + 5*x 값을 순차적으로 프린터하기
for(x in 1:10) {
  y <- 10 + 5 * x
  print(y)
}

#### while : 조건을 충족하면 종료(stop)
i <- 5
while(i <= 30) {
  i <- i + 3
}
i

#### while(TRUE 또는 FALSE): { if () break} => stop
j <- 1
while(TRUE) {
  j <- j + 3
  if (j > 25) break
}
j

# repeat { if ( _) break } => stop
k <- 1
repeat {
  k <- k + 5
  if (k > 25) break
}
k

#### next
i <- 1
while(i <= 10) {
  print(i)
  i < i + 1
}

i <- 1
while (i <= 10) {
  i <- i + 1
  if(i %% 2 != 0) {
    next # print()를 실행하지 않고 다시 while 문으로 반복
  }
  print(i)
}

### 연습문제09: if문을 활용하여 어떠한 숫자 또는 객체를 항상 양수가 되도록 하기 위한 조건문을 작성하시오.
num <- -5
if(num <= 0) {
  num <- num * -1
  print(num)
}

### 연습문제10: z가 홀수이면 x와 y를 더하고, 짝수이면 뺄셈을 실행하는 나만의 함수 정의와 호출
z_xy <- function(z, x, y) {
  ifelse(z %% 2 != 0, answer <- (x + y), answer <- (x - y))
  return(answer)
}

### 아래와 같이 if, else 문을 써서 사용자 함수를 구성할 수도 있음
### <참고> 전체 주석 처리: ctrl + shift + c
# z_xy <- function(z, x, y) {
#   if((z %% 2)== 1) {
#     answer <- (x + y)
#   }
#   else {
#     answer <- (x - y)
#   }
#   return(answer)
# }

z_xy(z = 5, x = 2, y = 3)
z_xy(z = 4, x = 7, y = 8)
z_xy(z = 7, x = 5, y = 6)


## R 패키지와 스크립트
### 패키지
?install.packages()
install.packages('ggplot2')
install.packages('dplyr')
## 아래와 같이 여러 개의 패키지를 한꺼번에 설치할 수 있음
# install.packages(c('ggplot2','dplyr'))

library(ggplot2)
library(dplyr)
## 아래와 같이 여러 개의 패키지를 한꺼번에 불러올 수 있음
# library(ggplot2, dplyr)

### 윈도우에서 R 업데이트 하기
install.packages('installr')
library(installr)
updateR()
## 아래의 명령어는 신규 패키지를 다운로드하고 설치를 진행하는 명령어
# install.R()
version # 버전 확인

### 패키지 업데이트
?update.packages

### 스크립트

# 끝