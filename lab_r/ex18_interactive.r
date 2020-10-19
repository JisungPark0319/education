library(tidyverse)

# interactive 그래프를 그리기 위한 패키지 설치
install.packages('plotly')
# 설치한 패키지를 메모리에 로드
library(plotly)

search()

# ggplot2::mpg 데이터 프레임
head(mpg)
str(mpg)

# 배기량(displ), 구동방식(drv)과 고속도로 연비(hwy)의 관계
# hwy ~ displ 산점도 그래프, drv에 따라서 점의 색깔을 설정(mapping)
g <- ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv))
g

ggplotly(g)

# drv별 hwy의 boxplot를 저장 -> ggplotly 사용
g <- ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = drv, y = hwy))
g

ggplotly(g)

# quick plot
qplot(x = displ, y = hwy, data = mpg, color = drv)

# ggplot 없이 interactive 그래프 작성
plot_ly(data = mpg, x = ~displ, y = ~hwy, color = ~drv)

qplot(data = mpg, x = drv, y = hwy, geom = 'boxplot')

plot_ly(data = mpg, x = ~drv, y = ~hwy, type = 'box')

# hwy ~ displ 산점도 그래프, 
# 점의 색깔은 drv에 따라서, 점의 모양은 class에 따라서 설정(mapping)
# 1) qplot() 사용
qplot(data = mpg, x = displ, y = hwy, geom = 'point',
      color = drv, shape = class)

# 2) plot_ly() 사용
plot_ly(data = mpg, x = ~displ, y = ~hwy, type = 'scatter',
        color = ~drv, symbol = ~class)

# 3) ggplot() + geom_point() 사용
g <- ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, 
                           color = drv, shape = class))
g

# 4) ggplotly() 사용
ggplotly(g)


# interactive 시계열 그래프

economics <- as.data.frame(ggplot2::economics)
str(economics)
summary(economics)

# 시간(date)에 따른 개인저축률(psavert)의 변화 - 시계열 그래프
qplot(data = economics, x = date, y = psavert, geom = 'line')

g <- ggplot(data = economics) +
  geom_line(mapping = aes(x = date, y = psavert))
g

plot_ly(data = economics, x = ~date, y = ~psavert, 
        type = 'scatter', mode = 'lines')

ggplotly(g)

# 실업률 파생 변수 추가
economics$unemploy_pct <- economics$unemploy / economics$pop * 100
summary(economics$unemploy_pct)

# 실업률 시계열 그래프(interactive)
plot_ly(data = economics, x = ~date, y = ~unemploy_pct,
        type = 'scatter', mode = 'lines')


# dygraphs 패키지를 사용한 시계열 그래프
install.packages('dygraphs')

library(xts)
library(dygraphs)

search()

# xts: dygraphs에서 사용하는 데이터 타입
# 데이터 프레임에서 시계열 그래프로 표현할 데이터를 xts로 변환
eco_psavert <- xts(x = economics$psavert,
                   order.by = economics$date)
class(eco_psavert)
str(eco_psavert)
head(eco_psavert)

eco_dyg <- dygraph(data = eco_psavert)
eco_dyg
dyRangeSelector(eco_dyg)

# 두 개 이상 변수의 시계열 그래프
# 저축률(psavert), 실업률(unemploy_pct) 변수를 xts 타입으로 변환.
eco1 <- xts(x = economics$psavert,
            order.by = economics$date)
eco2 <- xts(x = economics$unemploy_pct,
            order.by = economics$date)

head(eco1)
tail(eco1)
head(eco2)
tail(eco2)

# 각각의 시계열 변수(xts 타입 변수)들을 합침.
psave_unemp_xts <- cbind(psave_rt = eco1, unemp_rt = eco2)
head(psave_unemp_xts)
tail(psave_unemp_xts)

# 변수들이 합쳐진 시계열 데이터를 그래프로 그림.
dygraph(psave_unemp_xts)
