library(tidyverse)

# gapminder 패키지를 설치.
install.packages('gapminder')

# gapminder 패키지를 메모리에 로드.
library(gapminder)
search()

gapminder <- as.data.frame(gapminder::gapminder)

head(gapminder)
tail(gapminder)

str(gapminder)

# 데이터 프레임에는 몇 개의 국가 이름이 있을까요?
# (hint) dplyr::distinct() 함수
# select distinct country from gapminder;
# select count(distinct country) from gapminder;
gapminder %>% distinct(country) %>% summarise(n = n())

# 대륙 이름은 몇 개가 있을까요?
gapminder %>% distinct(continent) %>% summarise(n = n())

# 데이터 프레임에서 year의 최솟값, 최댓값?
distinct(gapminder, year)
min(gapminder$year)
max(gapminder$year)
summarise(gapminder, min = min(year), max = max(year))

# 기대수명(lifeExp)이 최댓값인 관측치(observations)를 출력.
max(gapminder$lifeExp)
filter(gapminder, lifeExp == max(lifeExp))
gapminder %>% filter(lifeExp == max(lifeExp))

# 인구(pop)이 최댓값인 관측치를 출력.
gapminder %>% filter(pop == max(pop))

# 1인당GDP가 최댓값인 관측치를 출력.
gapminder %>% filter(gdpPercap == max(gdpPercap))

# 우리나라 통계 자료 출력.
gapminder %>% filter(country == 'Korea, Rep.')

# 국가 이름에 'Korea'가 포함된 관측치(observations)를 출력.
# (hint) stringr::str_detect() 함수 사용.
gapminder %>% filter(str_detect(country, 'Korea'))

# 대한민국의 연도별 인구수를 그래프(pop ~ year)
gapminder_kr <- filter(gapminder, country == 'Korea, Rep.')
gapminder_kr

ggplot(data = gapminder_kr) +
  geom_line(mapping = aes(x = year, y = pop))

ggplot(data = gapminder_kr, mapping = aes(x = year, y = pop)) + 
  geom_point() +
  geom_line()

# gdpPercap ~ year 그래프
ggplot(data = gapminder_kr) +
  geom_line(mapping = aes(x = year, y = gdpPercap))

# lifeExp ~ year 그래프
ggplot(data = gapminder_kr) +
  geom_line(mapping = aes(x = year, y = lifeExp))

gapminder %>% 
  filter(country == 'Korea, Rep.') %>% 
  ggplot() +
  geom_line(mapping = aes(x = year, y = pop))

# 2007년의 gdpPercap 상위 5개 나라를 찾고, 막대 그래프로 출력.
gdp_top5 <- gapminder %>% 
  filter(year == 2007) %>% 
  arrange(desc(gdpPercap)) %>% 
  head(n = 5)
  
gdp_top5  

ggplot(data = gdp_top5) +
  geom_col(mapping = aes(x = country, y = gdpPercap))
#> x축의 국가 이름들이 알파벳 오름차순 순서로 정렬되어 있음.

ggplot(data = gdp_top5) +
  geom_col(mapping = aes(x = reorder(country, desc(gdpPercap)),
                         y = gdpPercap))
#> x축의 국가 이름들을 gdpPercap의 내림차순으로 정렬.

# 막대 그래프의 종류:
# 1) 빈도 막대 그래프: x축 - 카테고리 변수, y축 - 빈도수(count)
#    geom_bar(mapping = aes(x = var_name))
# 2) 히스토그램(histogram): x축 - 연속형 변수, y축 - 구간 안에 포함된 빈도수.
#    geom_histogram(mapping = aes(x = var_name))
# 3) 막대 그래프: x축 - 카테고리 변수, y축 - 연속형 변수.
#    geom_col(mapping = aes(x = var_name1, y = var_name2))

ggplot(data = gdp_top5) +
  geom_col(mapping = aes(x = gdpPercap, 
                         y = reorder(country, gdpPercap)))

# 2007년 데이터에서 인구수 상위 5개 국가/인구수 그래프 출력.
pop_top5 <- gapminder %>% 
  filter(year == 2007) %>% 
  arrange(desc(pop)) %>% 
  head(n = 5)

pop_top5

ggplot(data = pop_top5) +
  geom_col(mapping = aes(x = reorder(country, desc(pop)),
                         y = pop))

# 2007년의 기대수명 상위 5개 국가/기대수명 그래프
life_top5 <- gapminder %>% 
  filter(year == 2007) %>% 
  arrange(desc(lifeExp)) %>% 
  head(n = 5)

life_top5

ggplot(data = life_top5) +
  geom_col(mapping = aes(x = reorder(country, desc(lifeExp)), 
                         y = lifeExp))

# 2007년의 기대수명 하위 5개 국가/기대수명 그래프
life_bottom5 <- gapminder %>% 
  filter(year == 2007) %>% 
  arrange(lifeExp) %>% 
  head(n = 5)

life_bottom5

ggplot(data = life_bottom5) +
  geom_col(mapping = aes(x = reorder(country, desc(lifeExp)), 
                         y = lifeExp))

# Egypt, Gabon, South Africa, Zimbabwe의 기대 수명 시계열 그래프.
df <- gapminder %>% 
  filter(country %in% c('Egypt', 'Gabon', 'South Africa', 'Zimbabwe'))

df

ggplot(data = df) +
  geom_line(mapping = aes(x = year, y = lifeExp, color = country))
