library(tidyverse)

# ggplot2::mpg 패키지를 복사
mpg <- as.data.frame(ggplot2::mpg)

# 1) cty, hwy 변수의 평균을 파생 변수(avg_mpg)로 추가
mpg_added <- mutate(mpg, avg_mpg = (cty + hwy) / 2)
head(mpg_added)

# 2) avg_mpg 값 상위 3개 자동차 모델 정보 출력
mpg_added %>% arrange(desc(avg_mpg)) %>% head(n = 3)

# 3) 1), 2)와 같은 결과를 주는 pipe 연산자 호출 구문을 작성.
head(mpg)
mpg %>% 
  mutate(avg_mpg = (cty + hwy) / 2) %>% 
  arrange(desc(avg_mpg)) %>% 
  head(n = 3)

# summarise() 함수에서 사용되는 통계(집계) 함수들:
#   n(): 빈도수
#   mean(): 평균
#   sd(): 표준편차(standard deviation)
#   sum(): 합계
#   min(): 최솟값
#   max(): 최댓값
#   median(): 중앙값

# mpg 데이터 프레임에서 연도별로 cty 컬럼에 위의 모든 함수 적용
mpg %>% 
  group_by(year) %>% 
  summarise(counts = n(), mean = mean(cty), sd = sd(cty),
            sum = sum(cty), min = min(cty), max = max(cty),
            median = median(cty))

# 회사별 suv의 시내연비와 고속도로 연비 평균을 구하고,
# 연비 평균의 내림차순 정렬했을 때 상위 5개를 출력
mpg %>% 
  filter(class == 'suv') %>%   # suv 차종만 선택
  mutate(avg_mpg = (cty + hwy) / 2) %>%  # 시내/고속도로 연비 평균 추가
  group_by(manufacturer) %>%  # 자동차 회사별로 그룹 지어서
  summarise(mean_total = mean(avg_mpg), counts = n()) %>%  # 통합연비 평균
  arrange(desc(mean_total)) %>%  # 통합연비 내림차순 정렬
  head(n = 5)  # 상위 5위까지 출력


# class별 cty 평균을 출력.
mpg %>% 
  group_by(class) %>% 
  summarise(mean_cty = mean(cty))

# class별 cty 평균을 cty 평균 내림차순으로 출력.
mpg %>% 
  group_by(class) %>% 
  summarise(mean_cty = mean(cty)) %>% 
  arrange(desc(mean_cty))

# 자동차 회사별 hwy의 평균이 가장 높은 곳 1 ~ 3위를 출력.
mpg %>% 
  group_by(manufacturer) %>% 
  summarise(mean_hwy = mean(hwy)) %>% 
  arrange(desc(mean_hwy)) %>% 
  head(n = 3)

# 자동차 회사별 compact 자동차 차종 수를 내림차순으로 출력.
mpg %>% 
  filter(class == 'compact') %>% 
  group_by(manufacturer) %>% 
  summarise(counts = n()) %>% 
  arrange(desc(counts))


## ggplot2::midwest 데이터 프레임을 복사
midwest <- as.data.frame(ggplot2::midwest)
colnames(midwest)

# 1) 전체인구 대비 미성년 인구 백분율 변수를 추가하세요.
#    (Hint) poptotal: 전체인구수, popadults: 성인인구수
# 미성년자 인구수 = poptotal - popadults
# 미성년자 인구 백분율 = (poptotal - popadults) / poptotal * 100 (%)
midwest_added <- mutate(midwest,
                        child_pct = (poptotal - popadults) / poptotal * 100)

# 2) 미성년 인구 비율이 높은 상위 5개 county의 미성년 인구 비율 출력.
midwest_added %>% 
  arrange(desc(child_pct)) %>% 
  head(n = 5) %>% 
  select(county, child_pct)

# 3) 미성년 인구 비율이 40% 이상이면, 'large',
#    30 ~ 40%이면, 'middle'
#    30% 미만이면, 'small'
#    값을 갖는 파생 변수를 추가하고, 
#    각 비율 등급에는 몇 개 지역이 있는 지 찾아보세요.
midwest %>% 
  mutate(child_pct = (poptotal - popadults) / poptotal * 100,
         child_grade = ifelse(child_pct >= 40, 'large',
                              ifelse(child_pct >= 30, 'middle', 'small'))) %>% 
  group_by(child_grade) %>% 
  summarise(n = n())


midwest_added$child_grade <- 
  ifelse(midwest_added$child_pct >= 40, 'large', 
         ifelse(midwest_added$child_pct >= 30, 'middle', 'small'))

table(midwest_added$child_grade)

midwest_added %>% 
  group_by(child_grade) %>% 
  summarise(count = n())

# 4) poptotal과 popasian 변수를 사용해서
#    전체인구 대비 아시아 인구 비율 파생 변수를 추가하고,
#    아시아 인구 비율 상위 10위까지의 county, 아시아 인구 비율을 출력.
midwest %>% 
  mutate(asian_ratio = popasian / poptotal * 100) %>% 
  arrange(desc(asian_ratio)) %>% 
  head(n = 10) %>% 
  select(county, state, asian_ratio)

