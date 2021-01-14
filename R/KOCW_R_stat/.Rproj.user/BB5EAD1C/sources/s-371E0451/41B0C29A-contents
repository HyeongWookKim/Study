# R 정형데이터 분석 01: 평균차이검정, 상관분석, 회귀분석

## 데이터 준비 및 가공하기 
### 사용하게 될 패키지와 작업 폴더 파일 확인
library(dplyr) # dplyr 패키지 
library(ggplot2) # 데이터 시각화 ggplot2 패키지

### 데이터 불러오기와 데이터 마이닝
apt <- read.csv("데이터_아파트매매가격.csv") # csv 데이터 불러오기
str(apt) # 데이터 구조 확인하기 
summary(apt) # 데이터 전체 요약 통계 확인하기

attach(apt) # 데이터 객체 바로 접근하기
apt <- mutate(apt, price_pyung = apt_price / area_m2 * 3.3) # 아파트 거래 가격 평당 가격 변환하여 할당
x <- ifelse(year_built < 1980, "1970s", # 아파트 건축년대 변수생성 작업: 1970년대 건축된 아파트 
            ifelse(year_built >= 1980 & year_built < 1990, "1980s" , # 1980년대 건축된 아파트 
                   ifelse(year_built >= 1990 & year_built < 2000, "1990s" , # 1990년대 건축된 아파트 
                          ifelse(year_built >= 2000 & year_built < 2010, "2000s" ,  # 2000년대 건축된 아파트 
                                 "2010s")))) # 2010년대 건축된 아파트
apt <- mutate(apt, yr_built = x) # 아파트 건축년대 집단 
table(apt$yr_built) # 일원빈도분포표

apt <- mutate(apt, yr_built2 = ifelse(year_built < 2000, "Old", "New")) # 아파트 건축년대 2000년 기준 요인 변수 생성 
apt$yr_built2<- (as.factor(apt$yr_built2)) # 아파트 건축년대별 변수 yr_built: 문자 -> 요인 전환
table(apt$yr_built, apt$yr_built2) # 이원빈도분포표

apt$season <- ifelse(apt$ym_sale <= 201811, "가을", # 계절(season) 요인 변수 생성
                     ifelse(apt$ym_sale >= 201812 & apt$ym_sale <= 201902, "겨울" , 
                            ifelse(apt$ym_sale >= 201903 & apt$ym_sale <= 201905, "봄" , "여름"))) 
table(apt$ym_sale, apt$season)  # 이원빈도분포표

table(apt$urban) # 시군구별 빈도분포 확인
apt <- mutate(apt, urban2 = as.factor(ifelse(urban == "동", "도시", "농촌")))
table(apt$urban, apt$urban2)  # 이원빈도분포표

str(apt) # 데이터 구조 확인하기

apt2 <- select(apt, apt_price:urban, price_pyung:urban2, season) # 선택된 열만 추출하기 
str(apt2) # 데이터 구조 확인하기 

write.csv(apt2, "apt2.csv") # apt2  데이터 저장하기
file.exists("apt2.csv") # 저장된 파일 존재 확인하기
detach() # 데이터 객체 바로 접근하기 해제

## 평균 차이 검정
#*** t-test의 유형
#*** A. 독립 표본 t-test: 서로 다른 두개의 그룹 간의 평균 비교(예: 남자와 여자 간 소득의 차이 비교)
#*** B. 대응 표본 t-test : 하나의 집단에 대한 비교(예: 과외를 하기 전과 후의 반 학생들의 성적 변화)
#*** C. 단일 표본 t-test : 특정 집단의 평균이 어떤 숫자와 같은지 다른지를 비교
apt2 <- read.csv("apt2.csv") # apt2.csv 데이터 불러오기
str(apt2)

#* 도시와 농촌지역의 아파트의 평당 거래 가격(price_pyung)은 동일할까?
#* 1. 평균과 표준편차 확인하기
apt2 %>% # 객체
  group_by(urban2) %>% # 집단별 분류
  summarise(price_m = mean(price_pyung),  # 평당 가격 집단별 평균
            price_sd = sd(price_pyung)) # 표준편차 생성 및 확인

#* 2. 박스그래프로 분포 확인하기
ggplot(apt2, aes(urban2, price_pyung)) + # 미학 그래프 셋팅(x = 읍면동, y = 평당 아파트 가격) 
  geom_boxplot() + # 박스 그리프(도시 및 농촌지역 평당 거래 가격)
  labs(title = "충북 도시와 농촌지역별 아파트 평당 거래가격의 박스그래프", # 제목 
       x = "거래지역 유형", # x축 제목
       y = "평당 가격(단위: 만원)")  # y축 제목

#* 3-1. 정규성 검정: 히스토 그램과 shapiro.test
ggplot(apt2, aes(price_pyung)) + # 미학 그래프 셋팅(x = 읍면동, y= 평당 아파트 가격)
  facet_grid(. ~ urban2) + # 도시, 농촌지역 별 그래프 셋팅
  geom_histogram()+
  ggtitle('층북 아파트 실거래 가격: 농촌과 도시지역별 히스토 그램') +
  xlab('평당가격(단위: 만원)') +
  ylab('거래건수')

# Marginal density plot of y (right panel)
?col2rgb()
ggplot(apt2, aes(price_pyung, fill = urban2)) +
  geom_density(alpha = 0.5) +
  scale_fill_manual(values = c('gold', 'gray')) +
  theme(legend.position = 'bottom') + # 범례 위치: bottom, left, right, top, none, c(x, y)
  labs(title = '도시와 농촌지역별 평당 가격 밀도함수 그래프',
       x = '평당가격(만원)',
       y = '밀도(density)')

?shapiro.test() # Shapiro-Wilk Normality Test: 표본수가 3~5000에 있어야 실행
table(apt2$year_built) # 건축년도별 빈도분포표

x <- filter(apt2, year_built == 2019, urban2 == "도시")  # 건축년도가 2019년이고 거래지역이 도시인 데이터 추출
summary(x)
shapiro.test(x$price_pyung) # Shapiro-Wilk test for normality. H0: 정규분포이다.

y <- filter(apt2, year_built == 2019, urban2 == "농촌") # 건축년도가 2019년이고 거래지역이 농촌인 데이터 추출
summary(y)
shapiro.test(y$price_pyung) # Shapiro-Wilk test for normality. H0: 정규분포이다.

#* 3-2. 이분산성 검정: var.test
str(apt2)
?var.test() # F Test to Compare Two Variances
# H0: true ratio of variances is equal to 1
var.test(apt2[apt2$urban2 == '도시', 9], # 도시이면서 9번째 열(평당 가격) 데이터
         apt2[apt2$urban2 == '농촌', 9]) # 농촌이면서 9번째 열(평당 가격) 데이터

#* 4. 평균 검정: t.test
?t.test() # Student's t-Test: Performs one and two sample t-tests on vectors of data.
# H0: true difference in means is equal to 0
t.test(apt2[apt2$urban2 == '도시', 9], # 도시이면서 9번째 열(평당 가격) 데이터
       apt2[apt2$urban2 == '농촌', 9], # 농촌이면서 9번째 열(평당 가격) 데이터
       alternative = 'two.sided', # alternative = c("two.sided", "less", "greater")
       paired = FALSE, # 대응 표본 여부
       var.equal = FALSE) # 등분산성 여부 

649.9099-674.3314 # 평균 차이

# H0: true difference in means is equal to 0
t.test(price_pyung ~ urban2, # 평당 가격을 거래지역(urban2) 집단별로 비교
       data = apt2, # 비교할 데이터 객체 
       alternative = "two.sided", # alternative = c("two.sided", "less", "greater")
       paired = FALSE, # 대응 표본이 아닌 독립 표본
       var.equal = FALSE,  # 이분산성 가정하여 진단 
       conf.level = 0.99) # 신뢰구간 범위: 99%

### 대응 두 집단 표본 평균 검정(Paired sample t-test)
#* 학생들의 수치해석 중간고사 성적에 비하여 기말고사 성적의 평균이 증가했을까?
# 무작위 정규분포 형태의 표본 추출(평균 = 23): 무작위 이므로 각각 샘플링 마다 결과 다름
mid_score <- rnorm(n = 45, mean = 23, sd = 1)
# 무작위 정규분포 형태의 표본 추출(평균 = 23)
final_score <- rnorm(n = 45, mean = 24, sd = 1)
x <- as.data.frame(cbind(id= 1:45, mid = mid_score, final=final_score)) # 열로 결합하여 데이터 프레임으로 할당
class(x) # 속성 확인

#* 1. 요약 통계
summary(x) # x 객체 요약 통계
x <- mutate(x, diff = final - mid) # 대응 두 표본의 차이 변수 생성
summary(x$diff) # 차이 변수 요약 통계

#* 2. 집단별 분포 탐색: 히스토 그램과 박스그래프
par(mfrow = c(1, 2)) # 한 화면에 1*2 그래프 창 분할

hist(x$diff,
     main = "대응 두 표본 집단간 평균 차이 히스토그램", 
     xlab = "차이",
     ylab = "빈도(frequency)")

boxplot(x$diff, 
        main = "대응 두 표본 집단간 평균 차이 박스그래프",
        ylab = "차이")

#* 3-1. 정규성 검정
?shapiro.test()
shapiro.test(x$mid) # 중간고사 성적 정규성 검정
shapiro.test(x$final) # 기말고사 성적 정규성 검정

#* 3-2. 이분산성 검정
?var.test
var.test(x$mid, x$final, alternative = 'greater') # 오른쪽 단측 검정

#* 4. 대응 두 표본 평균검정(t-test)
t.test(x$mid, x$final, 
       alternative = "greater", # 오른쪽 단측 검정
       var.equal = TRUE, # 등분산성
       paired = TRUE) # 대응표본

### 단일표본 t-test (One sample t-test)
#* 지난 1년간 충청북도 지역의 아파트 평당 거래가격이 평균 670만원보다 작게 거래되었다고 할 수 있는가?

#* 1. 요약통계
mean(apt2$price_pyung)

#* 2. histgram 과 박스 그래프 
hist(apt2$price_pyung)
boxplot(apt2$price_pyung)

#* 3. 정규성 검정 (이 예제에서는 n > 30 이므로 생략 가능)
# shapiro.test(apt2$price_pyung)

#* 4. 단일 표본 t-검정
?t.test
t.test(apt2$price_pyung, # Ho: true mean is not less than 650
       mu = 670, # 비교하고자 하는 평균 값 설정
       alternative = "less", # 오른쪽 단측검정 선택
       conf.level = 0.95) # 신뢰구간 범위

#************* 연습문제 01
### 독립 두 표본 평균 검정: 예제 2
#* 2000년 이전(old)에 건축된 아파트와 이후(new)에 지어진 아파트의 평당 거래가격의 평균은 같을까?
#* 1. 평균과 표준편차 확인하기
apt2 %>% # 객체
  group_by(yr_built2) %>% # 집단별 분류
  summarise(size_no = n(), # 표본수 
            price_m = mean(price_pyung),  # 평당 가격 집단별 평균
            price_sd = sd(price_pyung)) # 표준편차 생성 및 확인

#* 2. 박스 그래프로 분포 확인하기
ggplot(apt2, aes(yr_built2, price_pyung)) + # 미학 그래프 셋팅(x = 읍면동, y= 평당 아파트 가격)
  geom_boxplot() + # 박스 그래프(도시 및 농촌지역 평당 거래 가격)
  labs(title = "충청북도 평당 거래가격 박스그래프", # 제목 
       x = "건축년도 구분", # x측 제목
       y = "평당 가격(단위: 만원)") # y측 제목

#* 3-1. 정규성 검정: 샘플수가 30보다 훨씬 크므로 생략 가능
ggplot(apt2, aes(price_pyung, fill = yr_built2)) + # 미학 그래프 셋팅(x = 읍면동, y = 평당 아파트 가격)
  geom_density(alpha = 0.5) +
  scale_fill_manual(values = c('gold', 'gray')) +
  theme(legend.position = c(0.9, 0.2)) + # 범례 위치표시: 패널 범위 x축과 y축 스케일 비율
  labs(title = '아파트 건축 연령(2000년 이전과 이후)별 평당 가격 밀도함수 그래프',
       x = '평당가격(만원)',
       y = '밀도(density)')

#* 3-2. 이분산성 검정: var.test
str(apt2)
var.test(price_pyung ~ yr_built2, data = apt2) # H0: true ratio of variances is equal to 1

#* 4. 평균 검정: t.test
# H0: true difference in means is equal to 0
t.test(price_pyung ~ yr_built2, # 평당 가격을 거래지역(yr_built2) 집단별로 비교
       data = apt2, # 비교할 데이터 객체 
       alternative = "two.sided", # alternative = c("two.sided", "less", "greater")
       paired = FALSE, # 대응 표본 여부
       var.equal = FALSE,  # 등분산성 여부 
       conf.level = 0.90) # 신뢰구간 범위


#******************* 분산분석 **********************#
### 일원분산분석
#* 계절별 아파트 거래 가격의 차이가 있는가?
?aov() # Fit an Analysis of Variance Model

#* 1. 요약 통계확인하기
apt2 %>% 
  group_by(season) %>% # 계절별 집단 구분
  summarise(n = n(), # 갯수
            mean = mean(price_pyung), # 평균
            var = var(price_pyung)) # 분산 요약통계

#* 2. 집단별 분포 확인하기
ggplot(apt2, aes(season, price_pyung, fill=season)) + # 미학 그래프 셋팅(x = 계절 요인, y= 평당 아파트 가격)
  geom_violin() + # 바이올린 그래프(도시 및 농촌지역 평당 거래 가격)
  scale_fill_manual(values = c('red','gray', 'blue', 'orange')) + 
  labs(title = "충청북도 계절별 아파트 평당 거래가격 바이올린 박스그래프", # 제목 
       x = "거래된 계절 유형", # x측 제목
       y = "평당 가격(단위: 만원)") # y측 제목

ggplot(apt2, aes(price_pyung)) + # 미학 그래프 셋팅(x = 읍면동, y = 평당 아파트 가격) 
  facet_grid(. ~ season) + # 도시, 농촌 지역별 그래프 셋팅
  geom_histogram() +
  ggtitle('층북 아파트 계절별 실거래 가격 히스토그램') +
  xlab('평당가격(단위: 만원)') +
  ylab('거래건수')

ggplot(apt2, aes(price_pyung, fill = season)) +
  geom_density(alpha = 0.3) +
  scale_fill_manual(values = c('red','gray', 'blue', 'orange')) +
  theme(legend.position = 'bottom') + # 범례 위치: bottom, left, right, top, none, c(x, y)
  labs(title = "계절별 아파트 평당 가격 확률밀도함수 그래프",
       x= "평당가격(만원)", 
       y = "밀도(density)")

#* 3. 분산분석
a.t <- aov(price_pyung ~ season, data = apt2) # 계절별 평당가격 분산분석
a.t # 할당 객체 결과
summary(a.t) # 분산분석 결과의 요약 통계

#* 4. 오차의 등분산성 검정
install.packages("lawstat")
library(lawstat)

?bartlett.test() # Bartlett Test of Homogeneity of Variances
b.t <- bartlett.test(price_pyung ~ season, data = apt2)
b.t

#* 5. 사후검정: 다중 비교
group_aov <- aov(price_pyung ~ season, data = apt2) # 절차 1: aov() 함수 실행

?TukeyHSD() # Compute Tukey Honest Significant Differences
TukeyHSD(group_aov) # 절차 2: Tukey 사후 검정

### 이원분산 분석
#* 계절별 읍면동별 아파트 거래 가격의 차이가 있는가?

#* 1. 요약통계 확인하기
apt2 %>% 
  group_by(season, urban) %>% # 계절별, 읍면동별  집단 구분
  summarise(n = n(), # 갯수
            mean = mean(price_pyung), # 평균
            var = var(price_pyung)) # 분산 요약통계

#* 2. 집단별 분포 확인하기
ggplot(apt2, aes(urban, price_pyung, fill = season)) + # 미학 그래프 셋팅(x = 읍면동 요인, y= 평당 아파트 가격)
  geom_boxplot() + # 박스 그래프(읍면동 평당 거래 가격)
  scale_fill_manual(values = c('red','gray', 'orange', 'yellow')) +
  labs(title = "충청북도 계절별 지역유형별 아파트 평당 거래가격 박스그래프", # 제목 
       x = "계절 및 거래지역의 유형", # x측 제목
       y = "평당 가격(단위: 만원)") # y측 제목

#* 3. 분산분석
# 이원분산분석: 상호작용항 미추가
a.t <- aov(price_pyung ~ season + urban, data = apt2) 
summary(a.t)
# 이원분산분석: 상호작용항 추가
a.t2 <- aov(price_pyung ~ season * urban, data = apt2) # formula에서 season과 urban은 생략 가능
summary(a.t2)

#* 4. 오차의 등분산성 검정
?bartlett.test() # Bartlett Test of Homogeneity of Variances
b.t <- bartlett.test(price_pyung ~ interaction(season, urban), data = apt2)
b.t

#* 5. 사후검정: 다중 비교
group_aov <- aov(price_pyung ~ season + urban, data = apt2) # 절차 1: aov() 함수 실행
TukeyHSD(group_aov) #  절차 2: 터키 사후 검정

group_aov <- aov(price_pyung ~ season * urban, data = apt2) # 절차 1: 상호작용항 추가
TukeyHSD(group_aov) #  절차 2: 터키 사후 검정

#************** 연습문제 03: 
#* 아파트 평당 거래 가격이 2개 수준의 농촌/도시 유형(urban2)별 5개 수준의 건축년대(yr_built)별 차이가 있는지 여부를 진단하고, 사후 검정으로 다중 검정을 수행하고자 한다.
#* 다음의 질문에 답하시오.
str(apt2)

#* 1. 요약 통계확인하기
apt2 %>% 
  group_by(urban2, yr_built) %>% 
  summarise(n = n(),
            mean = mean(price_pyung),
            var = var(price_pyung))

#* 2. 집단별 분포 확인하기
ggplot(apt2, aes(urban2, price_pyung, fill = yr_built)) +
  geom_boxplot() +
  scale_fill_manual(values = c('gold','gray', 'orange', 'yellow', 'blue')) +
  labs(title = "충청북도 건축년대별 지역유형별 아파트 평당 거래가격 박스그래프", # 제목 
       x = "읍면동별 건축년대별 유형", # x측 제목
       y = "평당 가격(단위: 만원)") # y측 제목

#* 3. 분산분석
a.t <- aov(price_pyung ~ urban2 + yr_built, data = apt2)
summary(a.t)

#* 4. 오차의 등분산성 검정
bartlett.test(price_pyung ~ interaction(urban2, yr_built), data = apt2)

#* 5. 사후검정: 다중 비교
group_aov <- aov(price_pyung ~ yr_built + urban, data=apt2) # 절차 1: aov() 함수 실행
TukeyHSD(group_aov) #  절차 2: 터키 사후 검정


#****************** 상관관계 분석 **************************#
## 데이터 불러와서 준비하기
apt3 <- mutate(apt2, built_age = 2019 - year_built) # 건축년도 연령 변수 생성
str(apt3)
write.csv(apt3, "apt3.csv")

apt3 <- read.csv("apt3.csv")
str(apt3)

attach(apt3)
par(mfrow = c(1, 1)) # 한 화면에 한 개의 그래프 창으로 환경 설정

### 공분산과 상관관계
?cov # Covariance
cov(price_pyung, floor_no) # 공분산: 평당 가격과 거래 아파트 층수
cov(price_pyung, built_age) # 공분산: 평당 가격과 거래 아파트 연령

?cor # Correlation
cor(price_pyung, floor_no) # 상관계수: 평당 가격과 거래 아파트 층수
cor(price_pyung, built_age) # 상관계수: 평당 가격과 거래 아파트 연령

cor.1 <- cov(price_pyung, floor_no) / sqrt(var(price_pyung) * var(floor_no))
cor.1 # 공분산과 분산을 이용하여 상관계수 구하기

cor.2 <- cov(price_pyung, built_age) / sqrt(var(price_pyung) * var(built_age))
cor.2 # 공분산과 분산을 이용하여 상관계수 구하기

?cor.test # test for Association/Correlation Between Paired Samples
cor.test(price_pyung, floor_no, method = 'pearson') # method = c("pearson", "kendall", "spearman")
cor.test(price_pyung, built_age)

#### 상관관계 분석절차
#* 아파트 평당 거래가격(price_pyung)과 아파트 건축년도(year_built)는 통계적으로 유의한 상관관계가 있는가? 그리고 그 관계는 어떠한가?
#* 1. 자료의 속성 확인
str(apt3) # 데이터 구조 확인하기
summary(apt3) # 결측치와 이상치 확인을 위한 요약통계

#* 2.산점도 그래프로 경향성 확인하기
ggplot(apt3, aes(built_age, price_pyung)) +
  geom_jitter(cex = 0.3) + # jitter 형태의 산점도 그래프: 점의 크기는 0.3배
  labs(title = "건축 연령과 아파트 평당 거래가격 산점도", # 제목
       x = "거래된 아파트 건축 연령(년)", # 축제목 
       y = "평당 거래가격(만원)")

#* 3. 분석방법론 선택과 상관계수 구하기
cor(built_age, price_pyung, method = 'pearson')

#* 4. 가설검정 및 통계적 유의성 진단
?cor.test
cor.test(built_age, price_pyung, method = 'pearson')

# 상관관계 검정 방법: Peasron(연속변수), Spearman(비모수, 순위(서열) 척도), Kendall(비모수, 순위(서열) 척도)
#* Kendall's tau or Spearman's rho statistic is used to estimate a rank-based measure of association. 
#* These tests may be used if the data do not necessarily come from a bivariate normal distribution.
cor.test(built_age, price_pyung, # 두 변수 상관관계 분석
         method = "pearson", # method="pearson"
         alternative = "two.sided") # no association(==0)

cor.test(built_age, price_pyung, # 두 변수 상관관계 분석
         method = "pearson", # method="pearson"
         alternative = "less") # negative association(<0)

cor.test(built_age, price_pyung, # 두 변수 상관관계 분석
         method = "pearson", # method="pearson"
         alternative = "greater" ) # corresponds to positive association(>0)

#* indicates the alternative hypothesis and must be one of "two.sided", "greater" or "less". 
# You can specify just the initial letter. 
# "greater" corresponds to positive association, 
# "less" to negative association.
## built_age가 범주형 변수라고 가정함(예시를 위해)
cor.test(built_age, price_pyung,
         method = "spearman", # method="spearman"
         exact = FALSE) # 동일순위(ties)가 있을 경우 정확한 p-값 산출하지 않도록 설정

cor.test(built_age, price_pyung,
         method = "kendall") # 상관관계 분석method="kendall"

#### 3개 이상 다중 변수 상관관계 매트릭스와 산점도 그래프: 
str(apt3)

#### 3개 이상 다중 변수 상관관계 계수 매트릭스 
v.cor <- apt3 %>% select(price_pyung, area_m2, floor_no, built_age)
cor(v.cor, method = 'pearson') # 해당 객체로 다중 상관관계 매트릭스 구하기
round(cor(v.cor), 3) # 소수점 세자리까지 반올림하여 결과 반환

##### 다중 기본 산점도 매트릭스
?pairs() # Scatterplot Matrices
pairs(formula =  ~ price_pyung + area_m2 + floor_no + built_age, # 산점도 적용 변수들
      data = apt3, # 데이터 객체
      cex = 0.2, # 점의 크기는 0.2배
      main = "아파트 거래자료 산점도 매트릭스 그래프") # 제목

pairs(formula =  ~ price_pyung + area_m2 + floor_no + built_age, # 산점도 적용 변수들
      data = apt3, # 데이터 객체
      lower.panel = NULL, # 대각선 아래 매트릭스 생략
      cex = 0.2, # 점의 크기는 0.2배
      main = "아파트 거래자료 산점도 매트릭스 그래프") # 제목

pairs(formula =  ~ price_pyung + area_m2 + floor_no + built_age, # 산점도 적용 변수들
      data = apt3, # 데이터 객체
      upper.panel = NULL, # 대각선 위 매트릭스 생략
      cex = 0.2, # 점의 크기는 0.2배
      main = "아파트 거래자료 산점도 매트릭스 그래프") # 제목

pairs(formula =  ~ price_pyung + area_m2 + floor_no + built_age, # 산점도 적용 변수들
      data = apt3, # 데이터 객체
      upper.panel = NULL, # 대각선 위 매트릭스 생략
      cex = 0.2, # 점의 크기는 0.2배
      main = "아파트 거래자료 산점도 매트릭스 그래프", # 제목
      panel = panel.smooth) # 패널에 추세선을 그릴


my_cols <- c("blue", "red")  # 2가지 색상 지정
pairs(formula =  ~ price_pyung + area_m2 + floor_no + built_age, # 산점도 적용 변수들
      data = apt3, # 데이터 객체
      col = my_cols[apt3$yr_built2],  # 건축년도 2000년 이전과 이후 점색 다르게 설정
      upper.panel = NULL, # 대각선 위 매트릭스 생략
      cex = 0.2, # 점의 크기는 0.2배
      main = "아파트 거래자료 산점도 매트릭스 그래프") # 제목

#*** 기타 다중 산점도 매트릭스 그래프 
install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)

?chart.Correlation() # On top the (absolute) value of the correlation plus the result of the cor.test as stars. On bottom, the bivariate scatterplots, with a fitted line
chart.Correlation(v.cor, # 산점도 매트릭스를 사용할 객체(또는 함수)
                  method = "pearson", #  method = c("pearson", "kendall", "spearman")
                  histogram = TRUE, # 우상단 부에 히스토 그램
                  cex = 0.2) # 점의 크기는 0.2배

install.packages("GGally")
library(GGally) 

?ggpairs() # A ggplot2 generalized pairs plot
ggpairs(v.cor)
ggpairs(v.cor, ggplot2::aes(colour ~ apt3$urban, # 읍면동별 추가
                            alpha = 0.5)) # 투명도 = 0.5

#***************** 연습문제 *****************#

#*** 건축되어진 년도(건축연령)가 오래될수록 아파트 평당 가격은 감소하는 경향이 있는가?
str(apt3)

cor.test(built_age, price_pyung,
         alternative = 'less',
         method = 'pearson')

ggplot(apt3, aes(built_age, price_pyung)) +
  geom_point() + 
  labs(title = "충북 아파트 건축연령과 평당 거래가격 산점도", # 제목 
       x = "건축연령(년)", # x측 제목
       y = "평당 거래가격(단위: 만원/평)")  # y측 제목

pairs(~ price_pyung + built_age, data = apt3,
      main = '충북 아파트 건축연령과 평당 거래가격 산점도',
      panel = panel.smooth)

library(PerformanceAnalytics)
v.cor2 <- apt3 %>% select(price_pyung, built_age)
chart.Correlation(v.cor2,
                  method = 'pearson',
                  historgram = TRUE,
                  cex = 0.2)


#************************ 회귀와 예측  **********************************#
## 선형회귀분석 - 선형회귀모형(linear regression model) 함수: lm()
apt3 <- read.csv("apt3.csv")
attach(apt3)
?lm() # Fitting Linear Models
#* 모형 공식 : https://faculty.chicagobooth.edu/richard.hahn/teaching/formulanotation.pdf

### 단순 선형회귀분석: 분석절차
#* 1. 요약 통계
x <- select(apt3, price_pyung, built_age)
str(x)
summary(x)

#* 2. 산점도 그래프
ggplot(apt3, aes(built_age, price_pyung)) +
  geom_jitter(cex = 0.5, col = 'black') + # 중첩되지 않는 점 그래프
  labs(title = "아파트 단지 건축연령과 평당 거래가격 선형 회귀선", 
       x = "건축연령(년)", 
       y ="평당가격(만원)")

#* 3. 모형구축
out <- lm(price_pyung ~ built_age, data = apt3) # 종속변수 ~ 설명변수

#* 4. 모형 및 회귀계수 진단
summary(out) # out 객체에 저장된 회귀분석의 결과 호출

#* 5. 다중공선성 진단: 단순 선형회귀모형에는 적용 안됨(추후에 나올 다중 선형회귀모형에서는 적용됨)

#* 6. 회귀모형 가정 진단
par(mfrow = c(2, 2))
plot(out, cex = 0.3) # 선형회귀 진단 그래프

par(mfrow = c(1, 1))

#* 7. 결과해석
ggplot(apt3, aes(built_age, price_pyung)) +
  geom_jitter(cex = 0.2, col = 'gray') +
  geom_smooth(method = 'lm', level = 0.95) + # lm 예측 선형회귀식
  geom_text(aes(x = 25, y = 700, label = 'Y = 1026.2 - 21.96X'),
            color = 'red',
            size = 5) +
  geom_text(aes(x = 30, y = 600, label = '(Adj R-sq = 0.6325)'),
            color = 'red',
            size = 4) +
  labs(title = "아파트 단지 건축연령과 평당 거래가격 선형 회귀선", 
       x = "건축연령(년)", 
       y="평당가격(만원)")

### 다중 선형회귀분석: 2개 이상의 설명(원인) 변수와 하나의 종속변수
### 다중 선형회귀분석: 분석절차
#* 1. 요약 통계
x <- select(apt3, price_pyung, area_m2, floor_no, built_age, urban2) # 다중선형회귀모형 선택 변수들 선정
str(x)
x$urban2 <- as.factor(x$urban2)
str(x)
summary(x)

#* 2. 산점도 그래프 
my_cols <- c("blue", "red")  # 2가지 색상 지정
pairs(formula = ~ price_pyung + area_m2 + floor_no + built_age,
      data = x,
      col = my_cols[x$urban2],
      upper.panel = NULL,
      cex = 0.2,
      main = '아파트 거래자료 산점도 매트릭스 그래프')

library(PerformanceAnalytics)
chart.Correlation(x, # 산점도 매트릭스를 사용할 객체(또는 함수)
                  method = "pearson", #  method = c("pearson", "kendall", "spearman")
                  histogram = TRUE, # 우측 상단부에 히스토그램
                  cex = 0.2) # 점의 크기는 0.2배

#* 3. 모형 구축
out2 <- lm(price_pyung ~ area_m2 + floor_no + built_age + urban2)

#* 4. 모형진단
summary(out2)

#* 5. 다중공선성(Multicollinearity) 진단: vif
library(car)

?vif() # Variance Inflation Factors
vif(out2)
round(vif(out2), 3)

#* 6. 회귀모형 가정 진단
par(mfrow = c(2, 2))
plot(out2, cex = 0.3) # 선형회귀 진단 그래프

par(mfrow = c(1, 1))

#* 7. 표준화 회귀계수: 변수의 상대적 중요성(영향력)의 크기 비교
install.packages("lm.beta")
library(lm.beta)
?lm.beta()

# lm.beta(회귀분석 결과)
out2 <- lm(price_pyung ~ area_m2 + floor_no + built_age + urban2, data = apt3)
summary(out2) # 다중선형회귀모형 결과 반환

beta <- lm.beta(out2) # 표준화 회귀계수 할당
beta
coef(out2) # 비표준화 회귀계수와 비교

#********************** 연습문제06: 선형회귀분석 
#* 최근 거래되어진 아파트의 건축연령(built_age)과 거래지역(urban2)가 평당 거래가격(price_pyung)에 미치는 영향에 대한 회귀분석을 실시하여 그 결과를 확인해보시오.
### 선형 회귀선 그래프 작성
out3 <- lm(price_pyung ~ built_age + urban2)
summary(out3)

#********************** 연습문제07: 표준화 회귀계수
#* 아파트 거래가격(price_pyung)에 영향을 미치는 독립변수로 floor_no, area_m2, built_age, urban, season을 투입하여 선형회귀모형을 구축하여 회귀분석을 실시하였다. 
out4 <- lm(price_pyung ~ floor_no + area_m2 + built_age + urban + season)

#* 아파트 거래가격은 어느 계절에 거래되었을 때 가장 높은 가격대를 형성하는지, 계절명을 적으시오.
summary(out4) # 정답: 가을

#* 표준화 회귀계수를 활용하였을 때 어떠한 독립변수가 아파트 가격에 상대적으로 가장 큰 영향력(중요도)을 가지고 있는 지 그 변수명과 표준화 회귀계수의 값을 적으시오.
lm.beta(out4) # built_age : -0.80102621


#################### 상호작용 효과와 주 효과 ####################
#* 실습1: 아파트 평당 실거래 가격에 대한 층수(floor_no)와 건축연령(built_age)의 상호작용 효과는? 이 때의 다중공선성은 발생할까?
# 상호작용항이 있는 회귀모형
out5 <- lm(price_pyung ~ area_m2 + floor_no + built_age + urban2 + floor_no * built_age)
summary(out5) # 회귀분석 결과 반환
round(vif(out5), 3) # VIF 값 반환: 소숫점 셋째자리에서 반올림

# 상호작용항이 없는 회귀모형
out6 <- lm(price_pyung ~ area_m2 + floor_no + built_age  + urban2)
summary(out6)
round(vif(out6), 3) # 다중공선성 진단하는 vif 반환

#* 실습2: 아파트 평당 실거래 가격에 대한 전용면적(area_m2)과 층수(floor_no)와의 상호작용 효과는? 이 때의 다중공선성은 발생할까?
out7 <- lm(price_pyung ~ area_m2 + floor_no + built_age + urban2 + area_m2 * floor_no)
summary(out7) # 회귀분석 결과 반환
round(vif(out7), 3) # 다중공선성 진단하는 vif 반환

detach()

#* 편차변환(centering) >> 다중공선성 문제를 완화시켜줌
apt3 <- apt3 %>%
         mutate(area_m22 = area_m2 - mean(area_m2), # 전용면적 편차변환: area_m22
                floor_no2 = floor_no - mean(floor_no)) # 층수 편차변환: floor_no2
attach(apt3)
out8 <- lm(price_pyung ~ area_m22 + floor_no2 + built_age + urban2 + area_m22 * floor_no2)  
summary(out8) # 회귀분석 결과 반환
round(vif(out8), 3) # 편차변환 모형 vif 반환

#* 실습3: 도시와 농촌지역에서 각각 거래된 아파트의 건축연령과 상호작용은 평당 실거래 가격에 어떠한 영향을 미칠까?
out9 <- lm(price_pyung ~ area_m2 + floor_no + built_age + urban2 + built_age * urban2)
summary(out9) # 회귀분석 결과 반환
round(vif(out9), 3) # 편차변환 모형 vif 반환

#********************** 연습문제08: 상호작용항
#* 아파트 거래가격(price_pyung)에 영향을 미치는 독립변수로 built_age와 season, 그리고 이 두 변수의 상호작용항을 투입하여 모형을 구축하고 회귀분석을 실시하였다.
out10 <- lm(price_pyung ~ built_age + season + built_age * season)
summary(out10)
#####* 건축연령이 오래된 아파트일수록 어느 계절에 거래되어지면 아파트 가격이 상대적으로 보다 낮게 거래될까요? 그 계절명은? 
#* >> 정답: 봄
#####* 그 상호작용 회귀계수값은? 
#* >> 정답: -1.7430


#******************************** 모형 비교와 최적 모형 선택 **************************#
#### 모형 비교
#* 실습1: 아파트 평당 실거래가격(price_pyung)에 영향을 미치는 독립변수들을 0개, 1개, 2개로 추가하였을 대, 어떤 회귀모형이 아파트 가격의 결정모형으로 보다 더 적합한 지를 진단하시오.
lm_1 <- lm(price_pyung ~ area_m2) # 독립변수가 1개인 모형
lm_2 <- lm(price_pyung ~ area_m2 + floor_no) # 독립변수가 1개 더 추가된 모형
lm_3 <- lm(price_pyung ~ area_m2 + floor_no + built_age) # 독립변수가 2개 더 추가된 모형

#* 조정 결정계수로 비교
summary(lm_1) ; summary(lm_2); summary(lm_3) # 3개의 회귀모형 분석결과 반환

AIC(lm_1, lm_2, lm_3) # AIC 정보량 기준으로 평가
BIC(lm_1, lm_2, lm_3) # BIC 정보량 기준으로 평가

anova(lm_1,lm_2) # ANOVA로 모델 간의 비교 및 평가
anova(lm_2,lm_3) # ANOVA로 모델 간의 비교 및 평가

#### 변수선택법과 최적모형 선택
#* 모든 가능한 변수 구축 회귀모형 비교
install.packages("MASS")
install.packages("leaps")
library(MASS)
library(leaps)

str(apt3) # 데이터 구조 확인하기 
names(apt3) # 변수명 확인하기

full.model <- lm(price_pyung ~ area_m2 + floor_no + built_age + urban + season,
                 data = apt3)
summary(full.model) # 모형 결과 반환

?stepAIC # Choose a model by AIC in a Stepwise Algorithm
lm_bw <- stepAIC(full.model, # Stepwise regression model
                 direction = "backward", # "both", "backward", "forward" 중 선택
                 trace = TRUE) # 단계별 선택별 과정 추적 내용 제시
summary(lm_bw) # stepAIC 결과 반환


?regsubsets() # "leaps" 패키지: functions for model selection
lm_fw <- regsubsets(price_pyung ~ area_m2 + floor_no +  built_age + urban +  season,
                    method = 'forward', # forward selection, backward selection or sequential replacement 
                    data = apt3)
summary(lm_fw) # regsubsets 결과 반환
plot(lm_fw, scale = 'adjr2') # 투입 변수별 조정계수 그래프 생성(Adj R2 기준)

#************* 연습문제 09
#* 아래와 같이 아파트 평당 거래가격에 영향을 미치는 설명변수들을 세개의 모형에 각각 달리 투입하여 회귀분석을 실행하고자 한다. 
#* 이들 중 최적의 회귀모형을 분산분석(anova())으로 채택하고자 할 때 어떤 모형이 최적인 지 그 결과를 실행하고, 최적의 모형은 어떤 것인지 적으시오.
lm_e09_1 <- lm(price_pyung ~ floor_no) # 1번
lm_e09_2 <- lm(price_pyung ~ floor_no + built_age) # 2번
lm_e09_3 <- lm(price_pyung ~ floor_no + season) # 3번

anova(lm_e09_1, lm_e09_2)
anova(lm_e09_2, lm_e09_3) # 2번 모형이 최적의 모형임

summary(lm_e09_1) # 0.229 
summary(lm_e09_2) # 0.6639(best model)
summary(lm_e09_3) # 0.2305

#************* 연습문제 10: 이들 중 최적의 회귀모형을 AIC 통계량으로 선택하고자 한다. 이 때 각각의 AIC 값을 적으시오.
AIC(lm_e09_1); AIC(lm_e09_2); AIC(lm_e09_3)


#******************* 비선형 회귀모형 ************************#
##### 비선형 회귀모형
### 1. 다항회귀모형
detach()
apt3 <- read.csv("apt3.csv")
apt4 <- apt3 %>% filter(urban2 == "도시") # '도시'에 해당하는 데이터만 추출
str(apt4)
attach(apt4)

### 다중 다항회귀분석: 제곱 세제곱 등의 함수형태
?poly()

lm_p1 <- lm(price_pyung ~ built_age) # 건축연령 1차함수 형태
summary(lm_p1)

lm_p2 <- lm(price_pyung ~ poly(built_age, 2)) # 건축연령 2차함수 형태
summary(lm_p2)

lm_p3 <- lm(price_pyung ~ poly(built_age, 3)) # 건축연령 3차함수 형태
summary(lm_p3)

lm_p4 <- lm(price_pyung ~ area_m2 + floor_no + built_age + urban2) # 건축연령 1차함수 형태
summary(lm_p4)

lm_p5 <- lm(price_pyung ~ area_m2 + floor_no + poly(built_age, 2) + urban2) # 건축연령 2차함수 형태
summary(lm_p5)

### 2. 분위회귀모형
install.packages("quantreg")
library(quantreg)

?rq # Quantile Regression
# 선형회귀모형형
lm_0 <- lm(price_pyung ~ built_age, data = apt4) # 건축연령 독립변수
summary(lm_0) # 선형회귀 결과

# 분위회귀모형
lm_q <- rq(price_pyung ~ built_age, data = apt4)  # 건축연령 독립변수
summary(lm_q) # 분위회귀 결과

plot(built_age, price_pyung, # 추정 회귀식 작성
     pch = 16, 
     cex = 0.3, col = "gray", # 점의 크기 0.3 색상 = gray
     main = "건축연령이 아파트 평당 거래가격에 미치는 영향")
abline(lm(price_pyung ~ built_age, data = apt4), col = "red", lty = 2) # 선형회귀 추세선
abline(rq(price_pyung ~ built_age, data = apt4), col = "blue", lty = 2) # 분위회귀 추세선(평균값)
legend("topright", legend = c("선형회귀", "분위회귀"), col = c("red", "blue"), lty = 2)

lm_q2 <- rq(price_pyung ~ built_age, # 건축연령 독립변수
            tau = seq(0, 1, by = 0.1), # 분위의 구분을 10% 분위로 11개 구간 작성
            data = apt4)
lm_q2$coefficients # 분위회귀계수 확인
coef(lm_q2) # 또 다른 회귀계수 확인 방법

# plotting different quantiles
colors <- c("#ffe6e6", "#ffcccc", "#ff9999", "#ff6666", "#ff3333",
            "#ff0000", "#cc0000", "#b30000", "#800000", "#4d0000", "#000000")
plot(price_pyung ~ built_age, data = apt4, 
     pch = 16,
     col = "gray",
     cex = 0.2,
     main = "건축연령과 아파트 평당 거래 가격",
     xlab = "건축연령(년)",
     ylab = "평당 아파트 실거래 가격(만원)")
abline(lm(price_pyung ~ built_age),
       lwd = 5,
       col = "black",
       lty = 2)

for (j in 1:ncol(lm_q2$coefficients)) {
  abline(coef(lm_q2)[, j], col = colors[j])
}

### 스플라인 모형
#* 실습: 건축연령(built_age)과 아파트 평당 거래가격(price_pyung)의 관계를 비선형으로 가정하고, 
#* 이를 스플라인 회귀와 스무딩 스플라인 회귀 분석을 시행하고, 이를 선형회귀와 그 결과를 비교하여 보시오.
install.packages("splines")
library(splines)

lm <- lm(price_pyung ~ built_age, data = apt4)
summary(lm)

# Generating Test Data
range(built_age)
agelims <- range(built_age)
age.grid <- seq(from = agelims[1], to = agelims[2])

lm_s <- lm(price_pyung ~ bs(built_age, knots = c(5, 10, 20, 30))) # 4개의 조각으로 구분
summary(lm_s)

#Plotting the Regression Line to the scatterplot 
par(mfrow = c(1, 1))

plot(built_age, price_pyung, 
     col = "gray",
     cex = 0.3,
     xlab = "건축연령(년)",
     ylab = "평당 거래가격(만원)",
     main = "스플라인 회귀 vs 선형회귀")

points(age.grid,
       predict(lm_s, newdata = list(built_age = age.grid)),
       col = "darkgreen",
       lwd = 3, type = "l")

#adding cutpoints
abline(v = c(5, 10,20,30),
       lty = 2,
       col = "blue")
#adding linear regression modeling line
abline(lm,
       lty = 2,
       lwd = 3,
       col = "red")

legend("topright",
       c("Spline Regression", "Linear Regression"),
       col = c("darkgreen", "red"),
       lwd = 3)

#fitting smoothing splines using smooth.spline(X, Y, df = ...)
?smooth.spline() # Fit a Smoothing Spline
lm_ss <- smooth.spline(built_age, price_pyung, df = 16) # 16차 k(다항함수 형태)

#Plotting both cubic and Smoothing Splines 
plot(built_age, price_pyung,
     col = "gray",
     cex = 0.3,
     xlab = "건축연령(년)",
     ylab = "평당 거래가격(만원)",
     main = "Smoothing Spline")

points(age.grid,
       predict(lm_s, newdata = list(built_age = age.grid)),
       col = "darkgreen",
       lwd = 2,
       type = "l")

#adding cutpoints
abline(v = c(5, 10, 20, 30),
       lty = 2,
       col = "green")
lines(lm_ss,
      col = "red",
      lwd = 2)

legend("topright",
       c("Smoothing Spline with 16 df", "Cubic Spline"),
       col = c("red","darkgreen"),
       lwd = 2)

# Implementing Cross Validation to select value of λ and Implement Smoothing Splines:
?smooth.spline()
# df 옵션 대신에 cv = TRUE 옵션을 사용하면, Knots(df)의 개수를 추정하여 적용함
lm_ss2 <- smooth.spline(built_age, price_pyung, cv = TRUE)
# ordinary leave-one-out (TRUE) or ‘generalized’ cross-validation (GCV) when FALSE; 
# is used for smoothing parameter computation only when both spar and df are not specified; 
# it is used however to determine cv.crit in the result. Setting it to NA for speedup skips the evaluation of leverages and any score.

lm_ss2 #It selects $\lambda=0.0279$ and df = 6.794596 as it is a Heuristic and can take various values for how rough the #function is

plot(built_age, price_pyung,
     col = "gray",
     cex = 0.3,
     xlab = "건축연령(년)",
     ylab = "평당 거래가격(만원)",
     main = "Smoothing Spline vs. Spline vs. Linear")

points(age.grid,
       predict(lm_s, newdata = list(built_age = age.grid)),
       col = "darkgreen",
       lwd = 2,
       type = "l")

#adding cutpoints
abline(v = c(5, 10, 20, 30),
       lty = 2,
       col = "green")
#Plotting Line predicted Smoothing Spline Regression with df =16
lines(lm_ss,
      lwd = 2,
      lty = 2,
      col = "blue")
#Plotting Line predicted Smoothing Spline Regression with CV estimation 
lines(lm_ss2,
      lwd = 2,
      col = "purple")
#adding linear regression modeling line
abline(lm,
       lty = 2,
       lwd = 2,
       col = "red")

legend("topright",
       c("Smoothing Spline with df(knots)=16",
         "Smoothing spline with cv est.",
         "Spline",
         "Linear"),
       col = c("blue", "purple", "darkgreen", "red"),
       lwd = 2)

### 일반화가법모형(genalized additive model)
install.packages("mgcv")
library(mgcv)

#* 실습1: 층수(floor_no)와 아파트 평당 거래가격(price_pyung)의 관계를 비선형으로 가정하고, 
#* GAM으로 추정하고, 선형회귀 결과와 비교하여 보자. 
lm <- lm(price_pyung ~ floor_no)
summary(lm)

par(mfrow = c(1, 2))

plot(price_pyung ~ floor_no,  
     cex = 0.3,
     col = "gray",
     xlab = "층수",
     ylab = "평당 거래가격(만원)",
     main = "선형추정")
abline(lm, lty = 2, col = "red")

?gam() # Generalized additive models with integrated smoothness estimation
lm_gam <- gam(price_pyung ~ s(floor_no), # 층수 = f(x)
              data = apt4)
summary(lm_gam) # gam 결과 반환

plot(lm_gam, se = TRUE, # gam graph
     xlab = "층수",
     ylab = "평당 거래가격(만원)",
     main = "GAM 추정")

#* 실습2. 층수(floor_no)와 아파트 평당 거래가격(price_pyung)의 관계를 비선형으로 가정하고, GAM으로 추정하고, 
#* 이후 선형관계로 가정한 추가 독립변수로 built_age와 area_m2를 차례로 투입하여 그 결과를 비교하여 보자. 
lm_gam1 <- gam(price_pyung ~ s(floor_no), # 층수 = f(x)
               data = apt4)
summary(lm_gam1) # gam 결과 반환

par(mfrow = c(1, 3))

plot(lm_gam1, se = TRUE, # gam graph
     xlab = "층수",
     ylab = "평당 거래가격(만원)",
     main = "GAM 추정1 : 선형 = 없음")

lm_gam2 <- gam(price_pyung ~ s(floor_no) + built_age) # 선형 건축연령 독립변수 추가
summary(lm_gam2)

plot(lm_gam2, se = TRUE,  # gam graph
     xlab = "층수",
     ylab = "평당 거래가격(만원)",
     main = "GAM 추정2 : 선형 = 건축연령")

lm_gam3 <- gam(price_pyung ~ s(floor_no) + built_age + area_m2)
summary(lm_gam3)

plot(lm_gam3, se = TRUE,
     xlab = "층수",
     ylab = "평당 거래가격(만원)",
     main = "GAM 추정3 : 선형 = 건축연령 + 전용면적")

#*************** 연습문제 11
#* 아파트 층수가 평당 아파트 거래가격에 미치는 영향이 아파트 가격의 분위별로 다를 것으로 예상된다. 75분위 이상의 아파트 가격 구간과 25분위 이상이 아파트 구간별로 층수가 아파트 평당 거래가격에 미치는 영향을 분위회귀모형의 회귀계수로 확인하여 보자.
#* 75분위 상위 구간과 25분위 하위 구간의 회귀계수를 적으시오.
#* 이 결과로 볼 때, 아파트 평당 가격은 비싼 아파트 일수록 높은 층수에서 아파트 가격이 보다 비싸게 거래되는 지를 진단하시오.
lm_e11 <- rq(price_pyung ~ floor_no, # 분위회귀모형
             tau = c(0.25, 0.5, 0.75), # 분위의 구분을 4개 구간 작성
             data = apt4)
lm_e11$coefficients # 분위회귀계수 확인
coef(lm_e11) # 또 다른 회귀계수 확인 방법

# plotting different quantiles
colors <- c("gold", "blue", "red")
plot(price_pyung ~ floor_no, data = apt4, 
     pch = 16,
     col = "gray",
     cex = 0.2,
     main = "층수와 아파트 평당 거래 가격",
     xlab = "층수",
     ylab = "평당 아파트 실거래 가격(만원)")
abline(lm(price_pyung ~ floor_no),
       lwd = 5,
       col = "black",
       lty = 2)

for (j in 1:ncol(lm_e11$coefficients)) {
  abline(coef(lm_e11)[, j], col = colors[j])
}

#***************** 연습문제 12
# 아파트 층수는 로얄층이 있다고 한다. 충북지역 아파트 최근 거래자료를 활용하여 층수에 대한 이차다항식으로 단순회귀모형을 적용하고 그 결과를 확인하시오. 
lm_e12 <- lm(price_pyung ~ poly(area_m2, 2), # 건축연령 이차함수 형태
             data = apt4) 
summary(lm_e12)

#**************** 연습문제 13
#* 층수(floor_no)와 건축연령(built_age)가 아파트 평당 거래가격(price_pyung)의 관계를 비선형으로, 
#* 전용면적(area_m2)를 선형으로 가정하여 GAM으로 추정하여 보자. 
#* 그리고 이들 세 변수 모두 선형으로 가정한 선형회귀 분석결과와 비교하여 보자.
lm_e13 <- lm(price_pyung ~ floor_no + built_age + area_m2)
summary(lm_e13)

lm_gam_e13 <- gam(price_pyung ~ s(floor_no) + s(built_age) + area_m2)
summary(lm_gam_e13)

par(mfrow = c(1, 2))
plot(lm_gam_e13,
     ylab = "평당 거래가격(만원)",
     main = "GAM 추정")

par(mfrow = c(1, 1))