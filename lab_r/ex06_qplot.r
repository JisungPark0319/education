# Quick Plot - ggplot 그래프를 쉽고 빠르게 그리는 기능.
library(tidyverse)

mpg <- as.data.frame(ggplot2::mpg)

head(mpg)

# y축에 사용할 변수 ~ x축에 사용할 변수
# cty(시내 주행 연비) ~ displ(배기량) 그래프
qplot(x = displ, y = cty, data = mpg)

# cty ~ year 그래프
qplot(x = year, y = cty, data = mpg)

# cty ~ cyl(실린더 개수) 그래프
qplot(x = cyl, y = cty, data = mpg)

# cty ~ drv(구동 방식) 그래프
qplot(x = drv, y = cty, data = mpg)

# 막대 그래프(bar plot): 
# 카테고리 변수의 빈도수(frequency, 개수)를 막대로 표현한 그래프.

# 구동 방식별 자동차 모델 개수 막대 그래프
table(mpg$drv)
qplot(x = drv, data = mpg)

# 연도별 자동차 모델 개수 막대 그래프
table(mpg$year)
qplot(x = year, data = mpg)

# 히스토그램(histogram):
# 연속형 변수를 일정한 구간으로 나눠서 그 구간 안에 포함된
# 데이터의 개수를 막대로 표현한 그래프.
qplot(x = cty, data = mpg, bins = 10)

# 상자그림(box plot)
# 요약 기술 통계량(최솟값, 최댓값, 백분위값)을 표현한 그래프.
summary(mpg$cty)
qplot(y = cty, data = mpg, geom = 'boxplot')

# ggplot2 패키지에는 midwest 예제 데이터 프레임이 있습니다.
# 1) ggplot2::midwest를 복사 -> 변수 생성
midwest <- as.data.frame(ggplot2::midwest)

# 2) midwest의 head, tail 출력
head(midwest)
tail(midwest)

# 3) midwest의 구조를 확인(row, column, 변수 이름/타입)
str(midwest)

# 4) midwest의 요약 기술 통계량
summary(midwest)

# 5) 변수 이름 변경: poptotal -> total, popasian -> asian
midwest <- rename(midwest, total = poptotal, asian = popasian)
colnames(midwest)

# 6) 파생 변수 asian_ratio: 전체 인구 대비 아시아 인구의 백분율.
midwest$asian_ratio <- (midwest$asian / midwest$total) * 100
midwest$asian_ratio
midwest$percasian

# 7) asian_ratio 변수의 평균
mean(midwest$asian_ratio)

# 8) 파생 변수 test: 
# asian_ratio가 평균보다 크면 'large', 그렇지 않으면 'small'
midwest$test <- ifelse(midwest$asian_ratio > mean(midwest$asian_ratio),
                       'large', 'small')

# 9) test 변수의 빈도수 테이블(도수 분포표)
table(midwest$test)

# 10) test 변수의 막대 그래프
qplot(x = test, data = midwest)


