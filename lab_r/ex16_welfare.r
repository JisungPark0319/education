# 한국 복지패널 데이터 분석

# 필요한 패키지 설치
# install.packages('tidyverse')  # 데이터 가공, 전처리, 시각화
# install.packages('readxl')  # 엑셀(xls, xlsx) 파일 처리
install.packages('foreign')  
# 통계 프로그램 SPSS에서 사용하는 파일(*.sav)을 R의 데이터 프레임으로 변환.

# 필요한 패키지를 메모리에 로드
library(tidyverse)
library(readxl)
library(foreign)

search()  # 로딩된 패키지 확인

# Koweps_hpc10_2015_beta1.sav 파일을 ./data 폴더에 복사
# ./data/Koweps_hpc10_2015_beta1.sav 파일을 읽어서 데이터 프레임 생성
welfare_org <- read.spss(file = 'data/Koweps_hpc10_2015_beta1.sav',
                         to.data.frame = TRUE)

head(welfare_org)

str(welfare_org)

# 변수(컬럼) 이름들을 분석하기 쉽게 변경
# h10_g3	==> gender(성별)
# h10_g4	==> birth(태어난 연도)
# h10_g10	==> marriage(혼인상태)
# h10_g11	==> religion(종교)
# h10_eco9	==> job_code(직종 코드)
# p1002_8aq1	==> income(일한달의 월 평균 임금)
# h10_reg7	==> region_code(7개 권역별 지역구분 코드)

# welfare <- welfare_org %>% rename(new = old, ...)
welfare <- rename(welfare_org,      # data_frame
                  gender = h10_g3,  # new_var_name = old_var_name
                  birth = h10_g4,
                  marriage = h10_g10,
                  religion = h10_g11,
                  job_code = h10_eco9,
                  income = p1002_8aq1,
                  region_code = h10_reg7)

# 성별(gender)의 도수 분포표
table(welfare$gender)  #> 7578 9086 
# ==> 성별은 NA가 없음.
# ==> 성별은 이상치(1, 2 이외의 값)가 없음.

class(welfare$gender)  #> numeric(숫자)
# 성별(gender) 변수는 숫자(1, 2)가 중요한 게 아니라,
# 카테고리(남성/여성)가 중요.

# 숫자 타입 변수를 카테고리 변수로 변환
welfare$gender <- factor(welfare$gender,
                         levels = c(1, 2),
                         labels = c('Male', 'Female'))
class(welfare$gender)  #> factor
table(welfare$gender)

# 성비 그래프 -> 막대 그래프
ggplot(data = welfare) +
  geom_bar(mapping = aes(x = gender, fill = gender))

# 월 수입(income) 변수 검토
class(welfare$income)  #> numeric
summary(welfare$income)  # 기술 통계량 요약

# 조사 설계서에 따라, 한달 수입의 정상 범위: 1 ~ 9998
# 정상 범위 이외의 값들은 NA 처리
welfare$income <- ifelse(welfare$income >= 1 & welfare$income <= 9998,
                         welfare$income, NA)
summary(welfare$income)

# 월 수입의 분포 -> histogram, box plot
ggplot(data = welfare) +
  geom_histogram(mapping = aes(x = income), binwidth = 50)

ggplot(data = welfare) +
  geom_boxplot(mapping = aes(y = income))

# 성별에 따른 월 수입의 차이?
# 성별 월 수입의 평균(hint: group_by -> summarise)
mean(welfare$income, na.rm = TRUE)

income_by_gender <- welfare %>% 
  group_by(gender) %>% 
  summarise(mean_income = mean(income, na.rm = TRUE))
income_by_gender

income_by_gender <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(gender) %>% 
  summarise(mean_income = mean(income))
income_by_gender

# 성별 월 수입 평균 그래프 -> 막대 그래프(col)
ggplot(data = income_by_gender) +
  geom_col(mapping = aes(x = gender, y = mean_income, fill = gender))

# 나이에 따른 월 수입 차이?
# birth(태어난 연도) 변수 검토
class(welfare$birth)  #> numeric
summary(welfare$birth)  #> NA 없음. 모든 값이 정상 범위 내.

# age(나이) 파생 변수 추가
welfare$age <- 2015 - welfare$birth  # 2015년 기준 나이 변환.
summary(welfare$age)

# 각 나이별 인구수
table(welfare$age)

# 각 나이별 인구 시각화
ggplot(data = welfare) +
  geom_bar(mapping = aes(x = age))

# 나이(age)별 평균 월 수입 계산/그래프
income_by_age2 <- welfare %>% 
  group_by(age) %>% 
  summarise(mean_inc = mean(income, na.rm = TRUE))
income_by_age2
income_by_age2[15:25, ]

income_by_age <- welfare %>% 
  filter(!is.na(income)) %>%  # 월 수입이 있는 데이터만 선택
  group_by(age) %>%  # 나이 별로 그룹 지어서
  summarise(mean_income = mean(income))  # 월 수입 평균 계산
income_by_age

ggplot(data = income_by_age) +
  geom_line(mapping = aes(x = age, y = mean_income))

# 평균 월 수입이 가장 많은 나이?
income_by_age %>% 
  filter(mean_income == max(mean_income))

age_with_max_income <- (filter(income_by_age,
                               mean_income == max(mean_income)))$age
age_with_max_income

ggplot(data = income_by_age) +
  geom_line(mapping = aes(x = age, y = mean_income)) +
  geom_vline(xintercept = age_with_max_income, color = 'red')

# 나이별, 성별 평균 월 수입 계산/그래프
income_by_age_gender <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age, gender) %>% 
  summarise(mean_income = mean(income))

income_by_age_gender

ggplot(data = income_by_age_gender) +
  geom_line(mapping = aes(x = age, y = mean_income, color = gender))

# 연령대(ages) 파생 변수 추가. 
# young: age < 30
# middle: 30 <= age < 60
# old: age >= 60

# welfare <- mutate(welfare, ages = ...)
welfare$ages <- ifelse(welfare$age < 30, 'young',
                       ifelse(welfare$age < 60, 'middle', 'old'))

# 연령대별 도수 분포표 -> 막대 그래프
table(welfare$ages)

welfare$ages <- factor(welfare$ages,
                       levels = c('young', 'middle', 'old'),
                       ordered = TRUE)
table(welfare$ages)

ggplot(data = welfare) +
  geom_bar(mapping = aes(x = ages, fill = ages))

# 연령대(ages)별 평균 월 수입 계산/그래프
income_by_ages <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ages) %>% 
  summarise(mean_income = mean(income))

income_by_ages

ggplot(data = income_by_ages) +
  geom_col(mapping = aes(x = ages, y = mean_income))

# 연령대별, 성별 평균 월 수입 계산/그래프
income_by_ages_gender <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ages, gender) %>% 
  summarise(mean_income = mean(income))

income_by_ages_gender

ggplot(data = income_by_ages_gender) +
  geom_col(mapping = aes(x = ages, y = mean_income, fill = gender))

ggplot(data = income_by_ages_gender) +
  geom_col(mapping = aes(x = ages, y = mean_income, fill = gender),
           position = 'dodge')

# age_range 파생 변수 추가
# age10: age < 20
# age20: age < 30
# age30: age < 40
# age40: age < 50
# age50: age < 60
# age60: age < 70
# age70: age < 80
# age80: age >= 80

welfare <- welfare %>% 
  mutate(age_range = 
           ifelse(age < 20, 'age10',
                  ifelse(age < 30, 'age20',
                         ifelse(age < 40, 'age30',
                                ifelse(age < 50, 'age40',
                                       ifelse(age < 60, 'age50',
                                              ifelse(age < 70, 'age60',
                                                     ifelse(age < 80, 'age70', 'age80'))))))))
table(welfare$age_range)

# age_range별 평균 월 소득 계산/막대 그래프
income_by_agerange <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age_range) %>% 
  summarise(mean_income = mean(income))

income_by_agerange

ggplot(data = income_by_agerange) +
  geom_col(mapping = aes(x = age_range, y = mean_income))

# age_range별, 성별 평균 월 소득 계산/막대 그래프
income_by_agerange_gender <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age_range, gender) %>% 
  summarise(mean_income = mean(income))

income_by_agerange_gender

ggplot(data = income_by_agerange_gender) +
  geom_col(mapping = aes(x = age_range, y = mean_income, 
                         fill = gender),
           position = 'dodge')


# 직종별 월 소득의 차이? 어떤 직종이 소득이 높을까?
summary(welfare$job_code)

# welfare 데이터 프레임에는 직종 코드만 있고, 직종 이름은 없음.
# 직종 코드와 직종 이름은 엑셀 파일에 정리되어 있음.
# welfare 데이터 프렘임과 엑셀 파일의 내용을 merge(join)

emp <- data.frame(empno = 1:4, dno = c(10, 20, 10, 20))
emp

dept <- data.frame(deptno = seq(10, 40, 10), 
                   dname = c('a', 'b', 'c', 'd'))
dept

left_join(emp, dept, by = c('dno' = 'deptno'))

# Koweps_Codebook.xlsx 파일의 sheet=2에는 직종 코드와 이름이 정리되어 있음.
df_jobs <- read_xlsx(path = 'data/Koweps_Codebook.xlsx',
                     sheet = 2)
head(df_jobs)
tail(df_jobs)

# welfare와 df_jobs를 left_join하고, 그 결과를 welfare에 저장.
welfare <- left_join(welfare, df_jobs,
                     by = c('job_code' = 'code_job'))
head(welfare$job)
tail(welfare$job)

# 직종에서 일하는 인구가 가장 많은 직종 상위 10개의 이름, 인구수
job_top10 <- welfare %>% 
  filter(!is.na(job)) %>%     # job이 있는 사람들만
  group_by(job) %>%           # job별로 그룹 지어서
  summarise(count = n()) %>%  # 해당 job에 속한 관측치 개수를 셈
  arrange(desc(count)) %>%    # 카운트 수의 내림차순 정렬
  head(n = 10)                # 상위 10개 선택

job_top10

# 남성이 가장 많이 일하는 직종 상위 10개의 이름, (남성) 인구수
job_male_top10 <- welfare %>% 
  filter(!is.na(job) & gender == 'Male') %>%
  group_by(job) %>%           # job별로 그룹 지어서
  summarise(count = n()) %>%  # 해당 job에 속한 관측치 개수를 셈
  arrange(desc(count)) %>%    # 카운트 수의 내림차순 정렬
  head(n = 10)                # 상위 10개 선택

job_male_top10

# 여성이 가장 많이 일하는 직종 상위 10개의 이름, (여성) 인구수
job_female_top10 <- welfare %>% 
  filter(!is.na(job) & gender == 'Female') %>%
  group_by(job) %>%           # job별로 그룹 지어서
  summarise(count = n()) %>%  # 해당 job에 속한 관측치 개수를 셈
  arrange(desc(count)) %>%    # 카운트 수의 내림차순 정렬
  head(n = 10)                # 상위 10개 선택

job_female_top10

# job_top10, job_male_top10, job_female_top10의 내용을 각각
# 가로 막대 그래프로 시각화.
# 막대의 크기 순으로 (인구수(count) 순서로) 정렬하세요. 
ggplot(data = job_top10) +
  geom_col(mapping = aes(x = count, y = reorder(job, count))) +
  xlab('인구수') + ylab('직종') +
  ggtitle('상위 10개 직종')

ggplot(data = job_male_top10) +
  geom_col(mapping = aes(x = count, y = reorder(job, count))) +
  xlab('인구수') + ylab('직종') +
  ggtitle('남성 상위 10개 직종')

ggplot(data = job_female_top10) +
  geom_col(mapping = aes(x = count, y = reorder(job, count))) +
  xlab('인구수') + ylab('직종') +
  ggtitle('여성 상위 10개 직종')

# welfare_org, welfare 데이터 프레임을 welfare.RData 파일에 저장하세요.
save(welfare_org, welfare, file = 'data/welfare.RData')

load(file = 'data/welfare.RData')
