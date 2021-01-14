# R 데이터 시각화와 ggplot2 패키지

## par(), pallete
?pch
par(mfrow = c(1, 1))

install.packages("RColorBrewer")
library(RColorBrewer)

display.brewer.all() # 이산형 또는 범주형 변수들의 색상 지원
# 순위형(Sequential), 발산형(Diverging), 범주형(Qualitative) 변수들의 색상 유형 제공
display.brewer.all(type = "seq")
display.brewer.all(type = "div")
display.brewer.all(type = "qual")

display.brewer.all(n = 5, type = "seq") # 필요한 색의 수 = 5
display.brewer.all(colorblindFriendly = TRUE, n = 4) # 색맹친화적인 색상 선택

?brewer.pal
my_pal <- brewer.pal(7, "Greens") # 녹색 계통의 7가지 색상 
my_pal # RGE No. 반환

## R 그래프 내장함수
apt <- read.csv('데이터_아파트매매가격.csv') # 실습 데이터 불러오기(아파트 실거래 자료)
str(apt) # 데이터 구조 확인하기
apt$price_pyung = apt$apt_price / apt$area_m2 * 3.3 # 평당 아파트 거래가격(만원) 생성하기 
str(apt$price_pyung) # 생성된 아파트 평당 가격 구조 확인

attach(apt)
x <- ifelse(year_built < 1980, "1970s", # 아파트 건축년대 변수생성 작업: 1970년대 건축된 아파트 
            ifelse(year_built >= 1980 & year_built < 1990, "1980s" , # 1980년대 건축된 아파트
                   ifelse(year_built >= 1990 & year_built < 2000, "1990s" , # 1990년대 건축된 아파트 
                          ifelse(year_built >= 2000 & year_built < 2010, "2000s" ,  # 2000년대 건축된 아파트 
                                 "2010s")))) # 2010년대 건축된 아파트 
apt <- transform(apt, yr_built = x) # 아파트 건축년대 집단 
attach(apt)
table(yr_built)

### 박스 그래프
?boxplot() # Box Plots

boxplot(price_pyung) # 평당 가격 박스 그래프 
boxplot(price_pyung ~ yr_built) # 아파트 건축년대별 평당 가격 박스 그래프 

boxplot(price_pyung ~ yr_built, col = (c("green", "blue", "yellow", "red", "grey")))
brewer.pal.info # 선택 가능한 계열 색상 종류와 크기 확인
my_pal <- brewer.pal(5, "Oranges") # 오렌지 계통의 5가지 색상 설정
boxplot(price_pyung ~ yr_built, col= my_pal) # 색상 변환

# 읍면동별 아파트 건축년대별 박스 그래프
boxplot(price_pyung ~ urban + yr_built, horizontal = TRUE) # 수평으로 박스 그래프
boxplot(price_pyung ~ urban + yr_built, horizontal = TRUE, # 수평으로 박스 그래프
        las = 2, # las = 2: 축의 레이블을 세로로 나타내기
        at = c(1:3, 5:7, 9:11, 13:15, 17:19), # 박스 그래프의 위치 설정(년대별 한 칸 띄우기) 
        col = rainbow(15),  # 무지개 색 계통의 색상 15개 자동 설정
        main = "충청북도 아파트 건축년대별 읍면동별 거래가격 분포", # 제목 설정
        xlab = "만원/평") # x축 제목 설정

?grid
grid(col = "gray", lty = 5, lwd = 1.5) # 그리드 추가: 회색, 선 형태, 두께

?rainbow # Color Palettes; heat.colors, terrain.colors 등 다수 사용 가능

### 점 그래프 
?dotchart() # Dot Plots: 벡터나 행렬에서만 유효한 사용 함수

x <- as.matrix(table(address_sigungu)) # 시군구별 일원 빈도분포표 행렬 할당
dotchart(x, main = "시군구별 거래건수")
table(address_sigungu) # 시군구별 빈도분포표와 비교

y <- as.matrix(table(urban, yr_built)) # 읍면동별 건축년대별 이원빈도분포효 행렬 할당
dotchart(y, 
         xlab = "거래건수", 
         ylab = "읍면동별 건축년대별 구분", 
         bg = "gold", 
         gcolor = "blue",
         main = "시군구별 읍면동별 거래건수")

### 막대그래프 
?barplot # Bar Plots: 막대그래프: Creates a bar plot with vertical or horizontal bars.
par(mfrow = c(2, 2)) # 그래프 패러미터 설정: 한 화면에 2x2행렬 창 설정
counts <- table(urban)
barplot(counts, main = '거래건수 분포', xlab = '읍면동') # las = 2 옵션을 넣어주면 축의 레이블을 세로로 나타내줌
barplot(counts, horiz = TRUE, xlab = '거래지역 유형', 
        names.arg = c('동지역', '면지역', '읍지역'), las = 2)

# Stacked Bar Plot with Colors and Legend
counts <- table(urban, address_sigungu)
class(counts); ncol(counts)
barplot(counts, main = '시군구별 읍면동별 아파트 거래건수', xlab = '거래지역 유형',
        col = my_pal, legend = rownames(counts))
barplot(counts, main = "시군구별 읍면동별 아파트 거래건수",
        xlab = "거래지역유형", # x축 제목
        col = rainbow(ncol(counts)), # 색상과 색 갯수 설정
        legend = rownames(counts),
        beside = TRUE, # values in each column are juxtaposed rather than stacked.
        args.legend = list(x = "topleft"), # 범례 위치 변경
        las = 2) # las=2, 축의 레이블을 세로로 나타내기

### 히스토그램: hist()
?hist # Histograms
hist(price_pyung) # 평당 가격에 대한 히스토그램
summary(price_pyung)

hist(price_pyung, breaks = seq(0, 2000, 100)) # sequence()함수 활용 구간 설정

hist(price_pyung, # 평당 가격
     main = "평당 아파트 가격 히스토그램", # 제목
     xlab = "평당가격(만원)",  # x축 제목
     border = "blue", # 경계 색상
     col = "green", # 색상 설정
     xlim = c(80, 2000), # x축 최소 및 최대 값 설정
     las = 1, # 값 라벨 가로로 설정
     breaks = 30) # 30개 구간으로 설정

hist(price_pyung, # 평당 가격
     main = "평당 아파트 가격 히스토그램", # 제목
     xlab = "평당가격(만원)",  # x축 제목
     freq = FALSE, # y측 값 표현을 확률밀도(density)로 설정 
     border = "blue", # 경계 색상
     col = "gray", # 색상 설정
     xlim = c(80, 2000), # x축 최소 및 최대값 설정
     las = 1, # 값 라벨 가로로 설정
     breaks = 50) # 50개 구간으로 설정

### plot() 함수
?plot # Generic X-Y Plotting
plot(price_pyung) # 평당 가격 
plot(area_m2, price_pyung, # 전용면적과 평당 가격 산포도 작성
     main = "전용면적과 평당 가격 산포도")

plot(area_m2, apt_price,
     cex = 0.5,  # 2배 작게
     fg = "blue", # 전경색 테두리 블루
     pch = 13, # 1 ~ 25개의 모양이 준비되어 있음
     main = "충북지역 아파트 거래자료를 활용한 산포도",
     xlab = "전용면적(m2)",
     ylab = "거래가격(만원)")

plot(apt_price, apt_price, # 실거래가와 평당 환산 거래가격 산포도 
     cex = 0.3, # 점크기 0.3배 
     main = "아파트 거래가와 평당 환산 거래가 산포도",
     xlab = "평당 환산가격(만원)",
     ylab = "거래가격(만원)")

grid(col = "gray", lty = 5, lwd = 1.5) # 그리드 추가: 회색, 선형태, 두께
detach()


#### plot()함수: 선그래프 작성
par(mfrow = c(1, 3)) # 그래픽 패러미터: 한 창에 세 개 그래프 설정
x <- 1:20 # 1부터 20까지 
y <-  exp(-x / 2) # y 값 산정
plot(x, y)
plot(x, y, 
     type = "l", # 선 형태
     col = "green", # 선 색
     lwd = 5, # 선 두께
     xlab = "time", # x축 제목
     ylab = "concentration", # y축 제목
     main = "Exponential decay") # 제목

z = 0.1 * exp(x / 10) # z 값 설정
plot(x, y, type = "b", col = "green", lwd = 5, pch = 8, 
     xlab = "time", ylab = "concentration", ylim = range(y, z))
lines(x, z, # 선 그래프 추가
      type = "b", col = "red", lwd = 2, pch = 19)

par(mfrow = c(1, 1)) # 그래픽 패러미터: 한 창에 한 개 그래프 설정

#*** 연습문제 01: 다음 중 R에서 벡터나 행렬에서만 작성할 수 있는 그래프 함수를 모두 고르시오.
#* 정답: dotchart()
?boxplot()
?dotchart()
?barplot()
?hist()
?plot()

#*** 연습문제 02: 시군구별 읍면동별 아파트 거래건수를 아래와 같이 그래프로 작성하고자 한다. 적합한 그래프 함수 명령문을 적으시오.
attach(apt)
counts <- table(urban, address_sigungu)
counts

barplot(counts, main = "시군구별 읍면동별 아파트 거래건수",
        xlab = "거래지역유형", # x축 제목
        col = rainbow(ncol(counts)), # 색상과 색 갯수  설정
        legend = rownames(counts),
        beside = FALSE, # 없어도 됨: values in each column are juxtaposed rather than stacked.
        args.legend = list(x = "topleft"), # 범례 위치 변경
        las = 2) # las = 2: 축의 레이블을 세로로 나타내기

#*** 연습문제 03: 실습 데이터인 “데이터_아파트매매가격.csv“에 있는 아파트 거래년월(ym_sale)을 활용하여
# 계절(season) 변수를 봄, 여름, 가을, 겨울로 구분하여 해당 데이터에 요인변수를 생성하여 그래프를 작성하고자 한다.
# ifelse문을 활용하여 season변수를 생성하는 명령문을 작성하시오. 
# 그리고 어느 계절에 가장 많은 아파트 거래 건수가 있으며, 거래건수가 얼마인지 적으시오.
# 이 때, 실습 데이터를 apt로 객체에 할당한 후 추가 생성 변수를 해당 데이터에 추가하고, 
# 봄=201903:201905, 여름=201906:201908, 가을=201809:201811, 겨울=201812:201902로 구분하시오.
str(ym_sale)
table(ym_sale)

apt$season <- ifelse(ym_sale <= 201811, '가을',
                     ifelse(ym_sale >= 201812 & ym_sale <= 201902, '겨울',
                            ifelse(ym_sale >= 201903 & ym_sale <=201905, '봄',
                                   '여름')))
table(ym_sale, season)
table(season) # 정답: 봄에 아파트 거래 건수가 가장 많으며, 거래 건수는 총 3510건

#*** 연습문제 04: 연습문제 2번과 같이 조건에 맞는 값으로 데이터를 구분하는 새로운 변수를 생성할 때, 
### ifelse문 이외에 사용할 수 있는 방법은 무엇인가요?
#* which(), %in%, [ ]을 사용한 방법
autumn <- apt[which(ym_sale %in% c(201809:201811)), ]
winter <- apt[which(ym_sale %in% c(201812:201902)), ]
spring <- apt[which(ym_sale %in% c(201903:201905)), ]
summer <- apt[which(ym_sale %in% c(201906:201908)), ]

autumn$season <- c('가을')
table(autumn$season)
winter$season <- c('겨을')
table(winter$season)
spring$season <- c('봄')
table(spring$season)
summer$season <- c('여름')
table(summer$season)

apt2 <- rbind(autumn, winter, spring, summer)
str(apt2)
table(apt2$ym_sale, apt2$season)
table(apt2$season)

#*** 연습문제 05: 제곱미터당 아파트 거래가격 변수를 생성(price_m2)하고, 읍면동별 계절별 박스 그래프를 아래와 같이 작성하고자 한다. 적합한 명령문들을 적으시오.
apt$price_m2 <- apt_price / area_m2 # 제곱미터당 아파트 거래가격(만원) 생성하기

boxplot(price_m2 ~ urban + season, 
        horizontal = FALSE, # 수직으로 박스 그래프: 없어도 됨
        las = 2, # 축의 레이블을 세로로 나타내기
        at = c(1:3, 5:7, 9:11, 13:15),
        col = rainbow(12),  # 무지개 색 계통의 색상 12개 자동 설정
        main = "읍면동별 계절별 아파트 제곱미터당 거래가격 분포", # 제목 설정
        xlab = "읍면동별 계절별 구분",
        ylab = "아파트 거래가격(만원/m2)") # x축 제목 설정

?grid
grid(ny = 6, nx = 0, col = "gray", lty = 5, lwd = 1.5) # 그리드 추가: y축 6개 그리그 구분, 회색, 선 형태, 선 두께

summary(price_m2) # 정답: 201.9

#*** 연습문제 06: 왜 '가을'에 '읍지역'에서 거래된 아파트의 제곱미터당 중위가격이 가장 높을까요?
table(yr_built, urban)

apt %>% 
  group_by(urban) %>% 
  summarise(mean = mean(price_m2),
            median = median(price_m2),
            n = n())

apt %>% 
  group_by(yr_built, urban) %>% 
  summarise(mean = mean(price_m2),
            median = median(price_m2),
            n = n())

# 정답: '동지역'은 오래된 아파트들이 보다 많이 거래되었고, 거래건수가 상대적으로 적고 새로운 아파트들이 많기 때문임


##### ------------- Ggplot2 패키지와 데이터 시각화 -------------------- #####

## ggplot2()
install.packages("dplyr")
install.packages("ggplot2")
library(dplyr)
library(ggplot2)

### ggplot2로 그래프 작성 시작 두가지 기본 함수
?ggplot2 # Create Elegant Data Visualisations Using the Grammar of Graphics
ggplot(data = apt, # mpg 데이터 
       aes(x = area_m2, # x,y 좌표계 미학적 요소: x = 전용면적(m2)
           y = price_pyung)) # y = 평당 아파트 거래가격(만원)

?qplot # Quick plot
qplot(x = area_m2, # 전용면적(m2)
      y = price_pyung, # 평당 아파트 거래가격(만원)
      color = urban, # 거래 아파트 지역의 읍면동 여부
      data = apt, # 데이터  
      geom = "point") # 점 그래프

?last_plot # etrieve the last plot to be modified or created.
last_plot()

?ggsave # device = one of "eps", "ps", "tex" (pictex), "pdf", "jpeg", "tiff", "png", "bmp", "svg" or "wmf" (windows only).
ggsave("test_plot.png", width = 8, height = 5)
file.exists("test_plot.png")

### geoms() 함수
#**  Use a geom to represent data points, use the geom’s aesthetic properties to represent variables. 
#** Each function returns a layer.
str(apt)

apt %>% # 사용할 데이터 셋
  filter(urban == "동") %>% # 데이터 추출
  ggplot(., aes(x = yr_built, y = price_pyung)) + # ggplot 그래프 셋팅
  geom_boxplot() # 박스 그래프 생성

apt %>% # 사용할 데이터 셋
  filter(yr_built == "2010s") %>% # 데이터 추출
  ggplot(., aes(x = urban, y = price_pyung)) + # ggplot 그래프 셋팅
  geom_boxplot() # 박스 그래프 생성


#### 한 개 변수(x) 그래프 작성 
##### 연속형 변수 
(a <- ggplot(data = apt, aes(x = area_m2))) # 전용면적 그래프 셋팅

?geom_area # 리본 또는 면적 그래프(Ribbons and area plots)
a + geom_area(stat = "bin") # 면적 그래프

?geom_density # 완만한 확률밀도 추정함수 그래프(Smoothed density estimates)
a + geom_density(kernel = "gaussian") # 커널밀도 함수 그래프

?geom_dotplot # 점 그래프: a dot plot, the width of a dot corresponds to the bin width
a + geom_dotplot(binwidth = 5) # 5의 막대간격인 점 그래프

?geom_freqpoly # 빈도폴리곤 그래프(frequency polygons)
a + geom_freqpoly(binwidth = 5) # 5의 간격인 빈도 폴리곤 그래프

?geom_histogram # Histograms
a + geom_histogram(binwidth = 5) # 히스토 그램


##### 한 개의 이산형 변수
(b <- ggplot(apt, aes(urban))) # apt 자료의 urban 명목변수 그래프 셋팅

?geom_bar # Bar charts
b + geom_bar() # 막대 그래프

#### 두 개의 변수
##### 두 개의 연속형 변수(x, y)
(c <- ggplot(apt, aes(area_m2, price_pyung))) # 그래프 셋팅(x = 전용면적, y= 평당 아파트 가격)

?geom_blank() # Draw nothing, a useful way of ensuring common scales between different plots
c + geom_blank() # 빈 그래프: x, y의 스케일 확인 방법

?geom_point() # Points: scatterplots
c + geom_point() # 산점도 그래프

?geom_jitter # 중첩되지 않는 점 그래프(Jittered points)
#*** a convenient shortcut for geom_point(position = "jitter"). 
#*** It adds a small amount of random variation to the location of each point, 
#*** and is a useful way of handling overplotting caused by discreteness in smaller datasets.
c + geom_jitter(cex = 0.3) # 중첩되지 않는 점 그래프

install.packages("quantreg")
library(quantreg)

?geom_quantile() # Quantile regression
#*** fits a quantile regression to the data and draws the fitted quantiles with lines. 
#*** This is as a continuous analogue to geom_boxplot()
c + geom_quantile() # 분위별 회귀계수: quantiles = c(0.25, 0.5, 0.75)
c + geom_quantile(quantiles = c(0.05, 0.5, 0.95)) # y ~ x

c + geom_point() + geom_quantile(colour = 'red', size = 1, lty = 1)
c + geom_point() + geom_quantile(colour = "blue", size = 1, lty = 2)

?geom_rug # Rug plots in the margins
#*** a compact visualisation designed to supplement a 2d display with the two 1d marginal distributions. 
#*** Rug plots display individual cases so are best used with smaller datasets
c + geom_rug()  # 여백에 구획분포 그래프 생성
c + geom_rug() + 
  geom_point(cex = 0.2, colour = "gray") + # 구획 그래프와 점(산포도) 그래프 중첩
  geom_quantile(quantiles = c(0.25, 0.5, 0.75)) # y ~ x 중첩

?geom_smooth # Smoothed conditional means: Aids the eye in seeing patterns in the presence of overplotting
c + geom_smooth(method = "auto", colour = "green") # 자동선택: using method = 'lm', 'glm', loess', 'gam' 중 선택
c + geom_smooth(method = "glm", colour = "yellow") # 매끄러운 선형회귀 그래프

c + geom_point() +  # 산포도 & 매끄러운 회귀선 중첩 
  geom_smooth(method = "loess") # using method = 'loess'

c + geom_rug() + # 여백에 구간 분포 추가
    geom_jitter(cex = 0.3) + # 중첩되지 않는 점(jitters) 그래프 추가
    geom_smooth(method = "lm", colour = "blue") + # 매끄러운 일반화 회귀 그래프 추가
    geom_smooth(method = "loess", colour = "red") # loess 회귀 그래프 중첩

?geom_text # adds text directly to the plot. geom_label() draws a rectangle behind the text, making it easier to read.
c + geom_text(aes(label = urban)) # 값별 읍면동 라벨 부여

##### x = 이산형 변수, y = 연속형 변수
d <- ggplot(apt, aes(urban, price_pyung)) # 미학 그래프 셋팅(x = 읍면동, y = 평당 아파트 가격) 

?geom_bar # Bar charts
d + geom_bar(stat = "identity") # 막대 그리프(y = 읍면동별 거래건수)

?geom_boxplot # box and whiskers plot 
#*** The boxplot compactly displays the distribution of a continuous variable. 
#*** It visualises five summary statistics (the median, two hinges and two whiskers), and all "outlying" points individually.
d + geom_boxplot()

?geom_dotplot() # Dot plot(데이터가 클 경우에는 비추천)
#*** In a dot plot, the width of a dot corresponds to the bin width (or maximum width, depending on the binning algorithm), 
#*** and dots are stacked, with each dot representing one observation.
d + geom_dotplot(binaxis = "y", # The axis to bin along, "x" (default) or "y"
                 stackgroups = TRUE, # should dots be stacked across groups?
                 method = "dotdensity", #  "dotdensity" 또는 "histodot"
                 binwidth = 4, # Defaults to 1/30 of the range of the data
                 binpositions = "all") # "all" determines positions of the bins with all the data taken togethe
  
?geom_violin # Violin plot, bot plot과 유사하지만 분포의 형태 보다 시각적으로 표현
d + geom_violin(scale = "area") # (default), all violins have the same area (before trimming the tails)
d + geom_violin(scale = "count") # areas are scaled proportionally to the number of observations.
d + geom_violin(scale = "width") # all violins have the same maximum width.

##### 두 개의 이산형 변수들(x, y)
e <- ggplot(apt, aes(x = urban, y = address_sigungu)) # x: 읍면동, y: 시군구
e + geom_jitter(cex = 0.2) # 시군구별 읍면동별 jitter 그래프(점의 크기 = 0.2배)

##### 이변량 연속형 분포 그래프
f <- ggplot(apt, aes(area_m2, price_pyung)) # x: 전용면적, y: 평당 가격 >> 그래프 셋팅

?geom_bin2d # 빈도를 추가한 사각형 셀 적외선 열지도(Heatmap of 2d bin counts)
f + geom_bin2d()

?geom_density2d() # Contours of a 2d density estimate: Perform a 2D kernel density estimation
f + geom_density2d() # 커널밀도 함수 추정치의 등고선 그래프(맵)

install.packages("hexbin") # Package `hexbin` required for `stat_binhex`.
library(hexbin)
?geom_hex # exagonal heatmap of 2d bin counts: 빈도를 추가한 육각형 셀 적외선 열지도(Heatmap of 2d bin counts)
f + geom_hex()

##### 이변량 연속형 변수 함수 그래프: 시계열 그래프에 보다 적합
# 실습데이터 불러오기(충북지역 월별 매매가격지수)
# <참고> 이 데이터를 제공받지 못함..따라서 아래의 코드는 그냥 참고만 하도록 하겠음
m_housing_index <- read.csv('주택유형별_월별_충북지역_매매가격지수.csv')
str(m_housing_index) # 데이터 구조 확인하기: 2017년 11월 = 100(불변가격)

# 기본 그래프 셋팅
g <- ggplot(m_housing_index, aes(year_month, apartment))

?geom_area # 면적 a y interval defined by ymin and yma
g + geom_area()

?geom_line() # Connect observations
g + geom_line() # connects them in order of the variable on the x axis

?geom_step() # creates a stairstep plot, highlighting exactly when changes occur. 
g + geom_step(colour = "blue", lty = 2) # creates a stairstep plot, highlighting exactly when changes occur

g + geom_line(colour = "red") + # 선 그래프
    geom_step(colour = "blue", lty = 2) # creates a stairstep plot, highlighting exactly when changes occur


##### 지도 그래프 작성
?USArrests # Violent Crime Rates by US State
str(USArrests) # 데이터 구조 확인하기
View(USArrests)
data <- data.frame(murder = USArrests$Murder, # 미국 주별 십만명당 살인죄 체포건수
                   state = tolower(rownames(USArrests))) # 행 이름 미국 주명 소문자로 변환
head(data)

install.packages('maps') # maps 패키지 설치
library(maps)

head(map_data("state")) # xy 좌표와 주명 지도
map <- map_data("state")

h <- ggplot(data, # 미국 주별 살인건수 데이터
            aes(fill = murder)) # 미학요소로 살인건수 빈도로 색상 분포

?geom_map # Polygons from a reference map
h + geom_map(aes(map_id = state), # 미학 요소로 map_id는 필수, 여기서는 state 
             map = map) + # Data frame that contains the map coordinates. 
  expand_limits(x = map$long, y = map$lat) # x축과 y축의 한계값까지 경계 확장

##### 세 가지 변수들 그래프
?seals # Vector field of seal movements: the paths of moving animals
str(seals) # A data frame with 1155 rows and 4 variables

seals$z <- with(seals, sqrt(delta_long^2 + delta_lat^2)) # 동물 이동거리 계산 

i <- ggplot(seals, # seals 데이터
            aes(long, lat)) # x, y 좌표

?geom_contour # 2d contours of a 3d surface
#*** to visualise 3d surfaces in 2d. To be a valid surface, 
#*** the data must contain only a single row for each unique combination of the variables mapped to the x and y aesthetics. 
#*** Contouring tends to work best when x and y form a (roughly) evenly spaced grid\
i + geom_contour(aes(z = z)) # z는 x, y 좌표별 한 개의 값일 경우 사용

?geom_raster # Rectangles: a high performance special case for when all the tiles are the same size.
i + geom_raster(aes(fill = z), hjust = 0.5, vjust = 0.5, interpolate = FALSE)
i + geom_raster(aes(fill = z), hjust = 0.5, vjust = 0.5, interpolate = TRUE)

?geom_tile # uses the center of the tile and its size (x, y, width, height).
i + geom_tile(aes(fill = z))

?geom_spoke # Line segments parameterised by location, direction and distance
#*** It is useful when you have variables that describe direction and distance. 
#*** The angles start from east and increase counterclockwise.
i + geom_point() +
  geom_spoke(angle = seals$z, radius = seals$z)

#### Graphical Primitives
j <- ggplot(map, aes(long, lat)) 
str(map)
summary(map)

?geom_polygon # Polygons: the start and end points are connected and the inside is coloured by fill
j + geom_polygon(aes(group = group))


str(m_housing_index)
k <- ggplot(m_housing_index, # 월별 매매 가격지수 데이터(객체) 
            aes(year_month, apartment)) # 년월과 아파트 매매거래지수 그래프 틀 작성
?geom_path # connects the observations in the order in which they appear in the data
k + geom_path(lineend = "butt", # Line end style (round, butt, square).
              linejoin = "round", # Line join style (round, mitre, bevel).
              linemitre = 1) # Line mitre limit (number greater than 1).: 1로 제한 

?geom_ribbon # displays a y interval defined by ymin and ymax
k + geom_ribbon(aes(ymin = apartment - 5, ymax = apartment + 5))

k + geom_ribbon(aes(ymin = mult_f_h, ymax = single_f_h)) + # 리본과 선 그래프 겹쳐서 작성
  geom_line(colour = "red") # connects them in order of the variable on the x axis

#******* 연습문제 07: 아파트 실거래 자료(객체: apt) 중에서 거래일(day_sale)별 그래프 셋팅하고(틀을 만들고),
# 바그래프(geom_bar)를 만드는 데, 읍면동(urban) 거래건수를 쌓아서(stack), 아래와 같은 그래프를 작성하고자 한다. 적합한 명령문을 작성하시오.
str(apt)
l <- ggplot(apt, aes(day_sale))
l + geom_bar(aes(fill = urban))

l2 <- ggplot(apt, aes(yr_built)) # 추가 예제
l2 + geom_bar(aes(fill = urban))

#******* 연습문제 08: ggplot2 패키지 함수로 아파트 거래자료에서 전용면적과 평당 가격으로 그래프를 셋팅하고, 
# 이들 두 값들의 분포에 대하여 커널밀도 추정을 하여 등고선 맵을 작성하라는 명령문은? 실행결과는 다음과 같다.
m <- ggplot(apt, aes(area_m2, price_pyung))
m + geom_density2d()

ggplot(apt, aes(area_m2, price_pyung)) + geom_density2d()

#******* 연습문제 09: 아파트, 연립/다세대, 단독 주택 월별 매매가격지수 변동 추세 확인
summary(m_housing_index) # 단독 주택 가격지수 가장 높음

n <- ggplot(m_housing_index, aes(year_month, single_f_h))    # 월별 단독주택 그래프 틀 작성
n + geom_line(aes(year_month, apartment), colour = 'red') +  # 월별 아파트 거래지수
  geom_line(aes(year_month, mult_f_h), colour = 'blue') +    # 월별 다세대/다가구 거래지수
  geom_line(aes(year_month, single_f_h), colour = 'black') + # 월별 단독주택 거래지수
  theme(legend.position = 'bottom') # Legend 위치 설정


### Stats - An alternative way to build a layer (geoms와 사용하는 방법은 거의 동일!)
#### 1D distributions
a <- ggplot(data = apt, # 데이터 셋
            aes(x = area_m2)) # 전용면적 변수로 그래프 틀 작성

?stat_bin() #geom_histogram()) 과 동일, Visualise the distribution of a single continuous variable by dividing the x axis into bins and counting the number of observations in each bin.
a + stat_bin(binwidth = 2) # Histograms (geom_histogram()) 과 동일

?stat_density() # Smoothed density estimates, geom_density()와 동일
a + stat_density(adjust = 1, kernel = "gaussian") # geom_density()와 동일

#### 2D distributions
c <- ggplot(apt, # 아파트 거래가격 데이터
            aes(area_m2, price_pyung)) # 그래프 셋팅(x = 전용면적, y= 평당 아파트 가격) 

?stat_bin2d # Heatmap of 2d bin counts: geom_bin2d()함수와 동일
c + stat_bin2d(bins = 30, drop = TRUE) # TRUE removes all cells with 0 counts.

?stat_binhex # Hexagonal heatmap of 2d bin counts: geom_hex()와 동일
c  + stat_binhex(bins = 30)

?stat_density2d # Contours of a 2d density estimate: geom_density_2d()와 동일 
c + stat_density2d(contour = TRUE, n = 100) # n	= number of grid points in each direction

#### 3 Variables
seals$z <- with(seals, sqrt(delta_long^2 + delta_lat^2)) # 동물 이동거리 계산 
i <- ggplot(seals, # seals 데이터
            aes(long, lat)) # x, y 좌표

?stat_contour # 2d contours of a 3d surface: geom_contour()
i + stat_contour(aes(z = z))

?stat_spoke # Line segments parameterised by location, direction and distance
i + geom_point() +
  stat_spoke(aes(radius = seals$z, angle = seals$ z)) # 더 이상 사용되지 않으므로, geom_spoke()로 사용 권장

?stat_summary_hex # Bin and summarise in 2d (rectangle & hexagons)
#*** The data are divided into bins defined by x and y, and then the values of z in each cell is are summarised with fun.
i  + stat_summary_hex(aes(z = seals$z), bins = 30, fun = mean)

#### Comparisons: x = 이산변수, y=연속변수
d <- ggplot(apt, # 아파트 실거래 가격 자료
            aes(urban, price_pyung)) # 미학 그래프 셋팅(x = 읍면동, y= 평당 아파트 가격) 

?stat_boxplot # A box and whiskers plot: geom_boxplot()
d + stat_boxplot(coef = 1.5) # coef	= Length of the whiskers as multiple of interquartile range (IQR). Defaults to 1.5.

?stat_ydensity # Violin plot: geom_violin()
d + stat_ydensity(adjust = 1, kernel = "gaussian", scale = "area")

#### Functions
g <- ggplot(m_housing_index, # 월별 주택매매 가격지수 데이터
            aes(year_month, apartment)) # 년월과 아파트 매매지수 그래프 틀 작성

?stat_ecdf() # Compute empirical cumulative distribution
g + stat_ecdf(n = 40) # n: if NULL, do not interpolate. If not NULL, this is the number of points to interpolate with.

?stat_quantile() # Quantile regression: geom_quantile()
g + stat_quantile(quantiles = c(0.25, 0.5, 0.75), # 25%tile, 50%tile, 75%tile로 분위회귀 수행 후 회귀직선
                  formula = y ~ log(x), # y를 종속변수로 하고, 설명변수인 x는 로그화 하여 모형 설정
                  method = "rq") # 사용할 회귀식 함수:  "rq" (for quantreg::rq()) and "rqss" (for quantreg::rqss()).

?stat_smooth() # Smoothed conditional means: geom_smooth()
g + stat_smooth(method = "auto", # "auto" the smoothing method is chosen based on the size of the largest group (across all panels)
                formula = y ~ x, # 선형회귀식
                se = TRUE, # Display confidence interval around smooth? (TRUE by default
                n = 80, # n	= Number of points at which to evaluate smoother.
                fullrange = FALSE, # fullrangeShould the fit span the full range of the plot, or just the data?
                level = 0.95) # Level of confidence interval to use (0.95 by default).

#### General Purpose
?stat_function # Compute function for each x value
ggplot() + # 그래프 셋팅
  stat_function(aes(x = -3:3), # 데이터 
                fun = dnorm, # Function to use.: 정규확률밀도
                n = 150, # Number of points to interpolate along
                args = list(sd = 0.5)) # List of additional arguments to pass to fun

?stat_identity # Leave data as is 데이터 그대로 표현
g + stat_identity() # The identity statistic leaves the data unchanged.
c + stat_identity()

?stat_qq # A quantile-quantile plot: geom_qq()와 동일
#***  a graphical method for comparing two probability distributions by plotting their quantiles against each other: https://en.wikipedia.org/wiki/Q%E2%80%93Q_plot
?sample # Random Samples
ggplot() + stat_qq(aes(sample = 1:100), # 1부터 100까지 숫자 벡터를 무작위 표본 추출  
                   distribution = qt, # Distribution function to use
                   dparams = list(df = 5)) # Additional parameters passed on to distribution function.

?stat_sum() # Count overlapping points: geom_count()
g  + stat_sum()
c + stat_sum()

?stat_unique # Remove duplicates
g  + stat_unique()
c  + stat_unique(cex = 0.3)

### Scales 제어
#### scale_manual() 함수: Create your own discrete scale
#*** These functions allow you to specify your own set of mappings from levels in the data to aesthetic values.
?scale_colour_manual()
?scale_fill_manual()
?scale_size_manual()
?scale_shape_manual()
?scale_linetype_manual()
?scale_alpha_manual()
?scale_discrete_manual()

c <- ggplot(apt, # 아파트 거래가격 데이터
            aes(area_m2, price_pyung)) # 그래프 셋팅(x = 전용면적, y= 평당 아파트 가격) 
cc <- c + geom_point(aes(colour = urban), cex = 0.5)
?scale_colour_manual  
cc + scale_colour_manual(values = rainbow(3))

?scale_fill_manual
b <- ggplot(apt, aes(urban)) # apt 자료의 urban 명목변수 그래프 셋팅
(bb <- b + geom_bar(aes(fill = urban))) # 막대 그래프
bb + scale_fill_manual(values = c("skyblue", "royalblue", "blue"), # 색상
                       name = "거래지역 읍면동", # 범례 제목
                       labels = c("동지역", "면지역", "읍지역")) # 라벨 재명명(순서대로)
#### x와 y의 위치 스케일
?scale_x_log10()  # *에는 x 또는 y가 올 수 있다. 변수에 상용로그(log10())을 취한 결과를 x 또는 y-위치로 한다.
?scale_x_reverse() # x 또는 y-위치를 뒤집는다.
?scale_x_sqrt() # 변수에 제곱근(sqrt())을 취한 결과를 x 또는 y-위치로 한다.


#### 색상과 면색 스케일
##### 이산 변수
n <- b + geom_bar(aes(fill = urban))

?scale_fill_brewer # Sequential, diverging and qualitative colour scales from colorbrewer.org
n + scale_fill_brewer(palette = "Blues") # 블루 계통 연속 색상 자동 지정 

?scale_fill_grey # Sequential grey colour scales
n + scale_fill_grey( # 회색 계통의 연속 색상 설정
  start = 0.2, # start	= grey value at low end of palette
  end = 0.8, # end	= grey value at high end of palette
  na.value = "red") # na.value = Colour to use for missing values 

##### 연속 변수 * 작동하지 않음 
str(mpg)
a <- ggplot(mpg, aes(hwy))
o <- a + geom_dotplot(aes(fill = cty))
o + scale_fill_gradient(low = "red", high = "yellow") 
o + scale_fill_gradientn(colours = terrain.colors(6))

#### Shape scales
str(apt)
c <- ggplot(apt, # 아파트 거래가격 데이터
            aes(area_m2, price_pyung)) # 그래프 셋팅(x = 전용면적, y= 평당 아파트 가격) 
p <- c + geom_jitter(aes(shape = urban), cex = 0.7)

?scale_shape # Scales for shapes: maps discrete variables to six easily discernible shapes
p + scale_shape(solid = FALSE) # Should the shapes be solid, TRUE, or hollow, FALSE?

?scale_shape_manual # scale_shape_manual(..., values)
p + scale_shape_manual(values = c(3:5)) # 점의 형태(유형) 지정


#### Size scales
q <- c + geom_point(aes(size = apt_price))
q

?scale_size_area # Scales for area or radius
q + scale_size_area(max_size = 4) # a value of 0 is mapped to a size of 0

### Coordinate Systems
b <- ggplot(apt, aes(urban)) # apt 자료의 urban 명목변수 그래프 셋팅
(r <- b + geom_bar()) # 막대 그래프

?coord_cartesian # Cartesian coordinates(카테시안 좌표)
r + coord_cartesian(xlim = c(0, 5)) # Limits for the x and y axes.

rr <- c + geom_point(aes(colour = factor(urban)), cex = 0.5)
?coord_fixed # Cartesian coordinates with fixed "aspect ratio"
rr + coord_fixed(ratio = 1/2) # aspect ratio, expressed as y / x

?coord_flip # Cartesian coordinates with x and y flipped(뒤집다)
rr + coord_flip() # horizontal becomes vertical, and vertical, horizontal.

str(apt)
ggplot(apt, aes(urban, apt_price)) +
  geom_boxplot() +
  coord_flip()

# A pie chart = stacked bar chart + polar coordinates
rrr <- ggplot(apt, aes(x = factor(1), fill = address_sigungu)) +
  geom_bar(width = 1)
rrr                
?coord_polar # most commonly used for pie charts, which are a stacked bar chart in polar coordinates.
rrr + coord_polar(theta = "y")

#### Faceting: Facets divide a plot into subplots based on the values of one or more discrete variables.
t <- ggplot(apt, 
            aes(area_m2, floor_no)) + # 면적과 층수 
  geom_jitter() # jitter 점분포 그래프

t + facet_grid(. ~ season) # 계절별 그래프 세로로
t + facet_grid(urban ~ .) # 읍면동별 그래프 가로로
t + facet_grid(urban ~ season) # 계절별 세로, 읍면동별 세로로
t + facet_wrap(~ season) # 사각형 행렬 분할로

#~~~~ Set scales to let axis limits vary across facets
t + facet_grid(urban ~  season)
t + facet_grid(urban ~  season, scales = "free")
t + facet_grid(urban ~  season, scales = "free_x")
t + facet_grid(urban ~  season, scales = "free_y")

#### Position Adjustments
#***** Position adjustments determine how to arrange geoms that would otherwise occupy the same space
s <- ggplot(apt, aes(urban, fill = season))
s + geom_bar(position = "dodge") # Arrange elements side by side
s + geom_bar(position = "fill") # Stack elements on top of one another, "normalize height"
s + geom_bar(position = "stack") # Stack elements on top of one another
c + geom_point(position = "jitter") # Add random noise to X and Y position of each element to avoid overplotting

#### Labels
c <- ggplot(apt, # 아파트 거래가격 데이터
            aes(area_m2, price_pyung)) # 그래프 셋팅(x = 전용면적, y= 평당 아파트 가격) 
cc <- c + geom_point(aes(colour = factor(urban)), cex = 0.5)

## 방법 (1)
cc + ggtitle("층북 아파트 실거래 자료: 읍면동별 전용면적과 평당 가격 산포도") +  # Add a main title above the plot
  xlab("전용면적(m2)") +  # Change the label on the X axis
  ylab("평당가격(단위: 만원)") # Change the label on the Y axis

## 방법 (2)
cc + labs(title = "충북 아파트 거래", x = "전용면적", y = "평당가격") # All of the above

#### theme() 예: Legends 위치조정 
q <- c + geom_point(aes(size = apt_price))
qq <- q + scale_size_area(max_size = 4) # a value of 0 is mapped to a size of 0

?theme # Modify components of a theme
qq + theme(legend.position = "bottom") # Place legend at "bottom", "top", "left", or "right"

#### Themes
?theme_bw()

qq + theme_bw() # White background with grid lines 
qq + theme_classic() #  White background no gridlines 
qq + theme_grey() # Grey background (default theme)
qq + theme_minimal() # Minimal theme
qq + theme_linedraw() # only black lines of various widths on white backgrounds,
qq + theme_light() # with light grey lines and axes, to direct more attention towards the data
qq + theme_dark() # a dark background. 
qq + theme_void() # A completely empty theme.

# 종합 1:
x <- ggplot() +
  geom_boxplot(data = apt, aes(x = address_sigungu, y = price_pyung,
               fill = urban)) +
  coord_flip() +
  theme(legend.position = 'bottom')+
  labs(title = '충북 시군구별 평당 아파트 가격 분포',
       x = '시군구', 
       y = '아파트 가격(만원/평)') +
  scale_fill_brewer(palette = 'Blues')
x

# 종합 2:
yr_price <- ggplot(apt, aes(x = year_built, y = price_pyung, color = urban)) +
  geom_point() + scale_color_brewer(palette = 'Set1') +
  geom_smooth(method = 'loess') +
  labs(title = '아파트 건축년도별 평당 아파트 가격 추이',
       x = '건축년도',
       y = '아파트 거래가격(만원/평)') +
  theme_bw()
yr_price

#******* 연습문제 10: 실습자료인 "data_by_sigungu_2018.xlsx" 파일을 불러들인 후, 
# 인구밀도(pop_density)와 아파트 매매가격지수(apt_sale_price)에 대하여 아래와 같은 그래프를 작성하고자 한다.
# 명령문을 작성하시오.
library(readxl)
city <- read_excel('data_by_sigungu_2018.xlsx')
str(city)

q <- ggplot(city, aes(x = pop_density, y = apt_sale_price)) +
  geom_point(aes(color = sido), na.rm = TRUE) +
  labs(title = '전국 시군구별 인구밀도와 아파트 매매 가격지수 산포도',
       x = '인구밀도',
       y = '아파트 매매 가격지수') +
  theme_bw()
q

#***** 연습문제 11: 종합 2의 그래프를 '2019년 8월'에 '청주시'에서만 거래된 데이터를 추출하여, 동일한 그래프를 작성하는 명령문을 작성하시오.
# 이 때 dplyr 패키지 함수를 활용하시오.
library(dplyr)
str(apt)
table(address_sigungu)

# 방법 (1)
apt %>% 
  filter(ym_sale == 201908 & 
           (address_sigungu %in% c('청주상당구', '청주서원구', '청주청원구', '청주흥덕구'))) %>% 
  ggplot(aes(x = year_built, y = price_pyung, color = urban)) +
  geom_point() + scale_color_brewer(palette = 'Set1') +
  geom_smooth(method = 'loess') +
  labs(title = '아파트 건축년도별 평당 아파트 가격 추이',
       x = '건축년도',
       y = '아파트 거래가격(만원/평)') +
  theme_bw()

# 방법 (2)
apt %>% filter(ym_sale == 201908 & 
                 (address_sigungu == "청주상당구" | 
                    address_sigungu == "청주서원구" | 
                    address_sigungu == "청주청원구" | 
                    address_sigungu == "청주흥덕구" )) %>%
  ggplot(., aes(x = year_built, y = price_pyung, color = urban)) + 
  geom_point() + scale_color_brewer(palette = "Set1") +
  geom_smooth(method = 'loess') +
  labs(title ="청주시 아파트 건축년도별 평당 아파트 가격 추이", 
       x = "건축년도", 
       y = "아파트 거래가격(만원/평)") +
  theme_bw()