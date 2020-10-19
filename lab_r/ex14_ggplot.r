library(tidyverse)

# 선 그래프(line graph):
# 시계열 데이터를 표현할 때 많이 사용.
# 시계열 데이터: 시간에 따라서 변하는 데이터. 환율, 주식, 인구수, 감염자수.

# ggplot2::economics 데이터 프레임.
economics <- as.data.frame(ggplot2::economics)

head(economics)
tail(economics)

str(economics)

summary(economics)

# pop(인구) ~ date 시계열(time series) 그래프
ggplot(data = economics) +
  geom_line(mapping = aes(x = date, y = pop))

# unemploy(실업자) ~ date 시계열 그래프
ggplot(data = economics) +
  geom_line(mapping = aes(x = date, y = unemploy))

# economics 데이터 프레임에 unemploy_rate 변수 추가
# unemploy_rate: 전체 인구 대비 실업자 비율(0 ~ 1.0)
# unemploy_rate 시계열 그래프

economics$unemploy_rate <- economics$unemploy / economics$pop
head(economics)

economics <- mutate(economics, unemp_pct = unemploy / pop * 100)
head(economics)

ggplot(data = economics) +
  geom_line(mapping = aes(x = date, y = unemploy_rate))

# psavert ~ date 시계열 그래프
ggplot(data = economics) +
  geom_line(mapping = aes(x = date,  y = psavert))


# Faceting: 한개의 plot에 여러개의 그래프를 그리는 것.

# 구동방식(drv)별 hwy ~ displ 산점도 그래프
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(facets = ~ drv)

# hwy ~ displ 산점도 그래프. class별로 facet을 나눠서.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(facets = ~ class, nrow = 2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(facets = cyl ~ drv)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(facets = . ~ drv)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(facets = drv ~ .)

# drv별 hwy의 box plot. class별로 facet을 나눠서.
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = drv, y = hwy)) +
  facet_wrap(facets = ~ class)

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = drv, y = hwy)) +
  facet_grid(facets = class ~ .)
