# 복지 패널 데이터 분석

# 라이브러리 로드.
library(tidyverse)
search()

# 저장한 RData 파일을 로드.
load(file = 'data/welfare.RData')

welfare %>% 
  select(age, ages, age_range, income, job, gender) %>% 
  head()

welfare %>% 
  select(age, ages, age_range, income, job, gender) %>% 
  tail()

# 직종별 평균 월 소득 상위 10개를 찾고, 막대 그래프로 시각화.
income_by_job <- welfare %>%                
  filter(!is.na(job) & !is.na(income)) %>%  # job, income이 NA가 아닌 데이터
  group_by(job) %>%                         # 직종별로 그룹
  summarise(mean_income = mean(income)) %>% # 그룹별 평균 월 소득 계산
  arrange(desc(mean_income))                # 평균 월 소득 내림차순 정렬

top10 <- head(income_by_job, n = 10)
top10

ggplot(data = top10) +
  geom_col(mapping = aes(x = mean_income, 
                         y = reorder(job, mean_income)))

# 직종별 평균 월 소득 하위 10개를 찾고, 막대 그래프로 시각화.
bottom10 <- income_by_job %>% tail(n = 10)
bottom10

ggplot(data = bottom10) +
  geom_col(mapping = aes(x = mean_income, 
                         y = reorder(job, mean_income)))

# 소득이 있는 사람들 중에서 직종별 인구수
count_by_job <- welfare %>% 
  filter(!is.na(income) & !is.na(job)) %>% 
  group_by(job) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count))

head(count_by_job, n = 10)
tail(count_by_job, n = 10)

# 소득이 있는 직종별 인구수 요약
summary(count_by_job$count)

# 소득이 있는 데이터 중에서 직종별 평균 월 소득 상/하위 10개.
# 직종별 인구수가 10명 이상인 직종에 대해서만 고려.
income_by_job2 <- welfare %>% 
  filter(!is.na(income) & !is.na(job)) %>% # 소득과 직종이 NA가 아닌 데이터
  group_by(job) %>% # 직종별
  summarise(mean_income = mean(income), count = n()) %>% # 평균 소득, 인구수 
  filter(count >= 10) %>% # 직종별 인구수가 10명 이상인
  arrange(desc(mean_income)) # 평균 월 소득 내림차순 정렬

top10_2 <- head(income_by_job2, n = 10)
bottom10_2 <- tail(income_by_job2, n = 10)

top10_2
top10

bottom10_2

# 직종별 인구수가 10명 이상인 직종에 대해서,
# 남성의 평균 소득 상위 10개 직종
male_income_by_job <- welfare %>% 
  filter(!is.na(income) & !is.na(job) & gender == 'Male') %>% 
  group_by(job) %>% 
  summarise(mean_income = mean(income), count = n()) %>% 
  filter(count >= 10) %>% 
  arrange(desc(mean_income)) %>% 
  head(n = 10)

male_income_by_job

ggplot(data = male_income_by_job) +
  geom_col(mapping = aes(x = mean_income,
                         y = reorder(job, mean_income)))

# 여성의 평균 소득 상위 10개 직종
female_income_by_job <- welfare %>% 
  filter(!is.na(income) & !is.na(job) & gender == 'Female') %>% 
  group_by(job) %>% 
  summarise(mean_income = mean(income), count = n()) %>% 
  filter(count >= 10) %>% 
  arrange(desc(mean_income)) %>% 
  head(n = 10)

female_income_by_job

ggplot(data = female_income_by_job) +
  geom_col(mapping = aes(x = mean_income,
                         y = reorder(job, mean_income)))


# 소득이 있는 데이터 중에서,
# 1) 10대, 20대 남성 상위 10개 직종
df <- select(welfare, age, age_range, gender, income, job)
df <- welfare %>% select(age, age_range, gender, income, job)
head(df)
tail(df)

young_male_top10 <- df %>% 
  filter(!is.na(income) & !is.na(job) & gender == 'Male' &
           age_range %in% c('age10', 'age20')) %>% 
  group_by(job) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count)) %>% 
  head(n = 10)

young_male_top10

# 2) 10대, 20대 여성 상위 10개 직종
young_female_top10 <- df %>% 
  filter(!is.na(income) & !is.na(job) & gender == 'Female' &
           age_range %in% c('age10', 'age20')) %>% 
  group_by(job) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count)) %>% 
  head(n = 10)

young_female_top10

# 3) 3,4,50대 남성 상위 10개 직종
middle_male_top10 <- df %>% 
  filter(!is.na(income) & !is.na(job) & gender == 'Male' &
           age_range %in% c('age30', 'age40', 'age50')) %>% 
  group_by(job) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count)) %>% 
  head(n = 10)

middle_male_top10

# 4) 3,4,50대 여성 상위 10개 직종
middle_female_top10 <- df %>% 
  filter(!is.na(income) & !is.na(job) & gender == 'Female' &
           age_range %in% c('age30', 'age40', 'age50')) %>% 
  group_by(job) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count)) %>% 
  head(n = 10)

middle_female_top10


# 지역별 인구 분석

# welfare 데이터 프레임에서 필요한 변수(컬럼)들만 선택
welfare_subset <- welfare %>% 
  select(gender, birth, marriage, religion, income, job_code, region_code,
         age, ages, age_range, job)

head(welfare_subset)

# 지역 리스트(region_code, region) 데이터 프레임
region_list <- data.frame(region_code = 1:7,
                          region = c('서울',
                                     '수도권(인천/경기)',
                                     '부산/경남/울산',
                                     '대구/경북',
                                     '대전/충남',
                                     '강원/충북',
                                     '광주/전남/전북/제주도'))
region_list

# welfare_subset과 region_list merge(left join)
welfare_subset <- left_join(welfare_subset, region_list)
head(welfare_subset)

# region의 도수 분포표
table(welfare_subset$region)

# 지역별, 성별 인구수
welfare_subset %>% 
  group_by(region, gender) %>% 
  summarise(pop = n())

# 지역별, 성별 인구수 막대 그래프(막대 채움 색깔을 성별로 구분)
ggplot(data = welfare_subset) +
  geom_bar(mapping = aes(x = region, fill = gender),
           position = 'fill')

# 지역별 성비 계산(지역, 성별, 인구, 남/녀 인구합계, 비율)
welfare_subset %>% 
  group_by(region, gender) %>% 
  summarise(pop = n()) %>% 
  mutate(total = sum(pop), gender_pct = pop / total)

# 지역별, ages(young, middle, old)별 인구수, 비율 -> 막대 그래프
pop_by_region_ages <- welfare_subset %>% 
  group_by(region, ages) %>% 
  summarise(pop = n()) %>% 
  mutate(total = sum(pop), ages_pct = pop / total)

pop_by_region_ages

ggplot(data = welfare_subset) +
  geom_bar(mapping = aes(y = reorder(region, ages == 'old'), 
                         fill = ages),
           position = 'fill')

