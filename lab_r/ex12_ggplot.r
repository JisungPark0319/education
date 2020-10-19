# ggplot2::ggplot() 함수를 사용한 데이터 시각화(Visualization)

library(tidyverse)
search()

mpg <- as.data.frame(ggplot2::mpg)
head(mpg)

# cty(시내주행연비) ~ displ(배기량)
# quick plot
qplot(x = displ, y = cty, data = mpg)

# ggplot
ggplot(data = mpg) +  # 그래프 (배경) 활성화
  geom_point(mapping = aes(x = displ, y = cty))  # 그래프 종류
  # 옵션들 추가

# cty ~ displ, 점의 색깔을 drv(구동 방식)에 따라서 다르게.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = cty, color = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = cty)) +
  geom_point() +
  xlab('배기량 (L)') +
  ylab('시내 주행 연비 (mile/galon)')

# ggplot 그래프는 단계별로 변수에 저장할 수 있음.
g <- ggplot(data = mpg, mapping = aes(x = displ, y = cty))
g <- g + geom_point()
g <- g + xlab('배기량') + ylab('도심 연비')
g

# hwy ~ cty 산점도 그래프(scatter plot) - geom_point()
ggplot(data = mpg) +
  geom_point(mapping = aes(x = cty, y = hwy)) +
  xlab('도심 연비') +
  ylab('고속도로 연비') +
  ggtitle('고속도로 vs 도심 연비')

# hwy ~ displ 산점도 그래프.
# 점의 색깔이 class에 따라서 바뀌도록.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

ggplot(data = mpg,
       mapping = aes(x = displ, y = hwy, color = class)) +
  geom_point()

ggplot(data = mpg,
       mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class))


# aesthetic mapping: aes()
# "변수(데이터 프레임의 컬럼)에 따라서" 달라지는 
# 색깔, 모양, 크기, ... 등의 설정을 mapping
# 변수에 따라서 달라지는 것이 아니라, 한가지 값으로만 설정할 때는
# aes()을 사용하지 않음!

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy),
             color = 'blue')

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = 'blue'))

# hwy ~ displ 산점도 그래프
# 색깔(color)는 class에 따라서, 모양(shape)은 drv에 따라서 다르게.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy,
                           color = class, shape = drv))

# geometry 함수들:
g <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy))
g + geom_smooth()
g + geom_point() + geom_smooth()

# hwy ~ displ 산점도(geom_point) + 회귀 곡선(geom_smooth)
# 점의 색깔(color)을 drv에 따라서 다르게 mapping
# 곡선 모양(linetype)을 drv에 따라서 다르게 mapping
g + geom_point(mapping = aes(color = drv)) +
  geom_smooth(mapping = aes(linetype = drv))

# 위 그래프와 아래 그래프의 차이?
ggplot(data = mpg, 
       mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(mapping = aes(linetype = drv))


