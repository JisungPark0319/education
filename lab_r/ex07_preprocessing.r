# dplyr 패키지의 함수들을 사용한 데이터 전처리(preprocessing)
# filter(): 조건에 맞는 행(rows, observations)을 선택
# select(): 원하는 열(columns, variables)을 선택
# arrange(): 정렬
# mutate(): 파생 변수 추가
# group_by(): 그룹별 묶기
# summarize(), summarise(): 통계 값 계산(통계 함수 적용)

# data/csv_exam.csv 파일을 읽어서 데이터 프레임 생성
exam <- read.csv(file = 'data/csv_exam.csv')

# head, tail 출력
head(exam)
tail(exam)

# 데이터 프레임 구조 확인
str(exam)

# 데이터 프레임 요약 통계량
summary(exam)

# class 막대 그래프(카테고리 변수의 빈도수)
qplot(x = class, data = exam)

# math 히스토그램(연속형 변수의 구간 안의 데이터 개수)
qplot(x = math, data = exam, bins = 10)

# math box plot
qplot(y = math, data = exam, geom = 'boxplot')

# science ~ math 산점도 그래프(scatter plot)
qplot(x = math, y = science, data = exam)

# class가 1인 학생들(observations)을 선택
filter(exam, class == 1)
# 비교 연산자: ==, !=, >, >=, <, <=
# 논리 연산자: &, |, !

# 1, 2반 학생들 선택
filter(exam, class == 1 | class == 2)

# 1, 3, 5반 학생들 선택
filter(exam, class == 1 | class == 3 | class == 5)
filter(exam, class %in% c(1, 3, 5))

# 수학 점수가 50점 이상인 학생들 선택
filter(exam, math >= 50)

# 1반에서 수학 점수가 50점 이상인 학생들 선택
filter(exam, class == 1 & math >= 50)

# 영어 점수가 평균 이상인 학생들 선택
mean(exam$english)
filter(exam, english >= mean(english))

# 4반에서 영어 점수가 평균 이상인 학생들 선택
filter(exam, class == 4 & english >= mean(english))

# 수학, 영어 모두 평균 이상인 학생들 선택
filter(exam, math >= mean(math) & english >= mean(english))

# id, math 컬럼(variables)을 선택
select(exam, id, math)
select(exam, math, id)

# id, math, english, science를 선택
select(exam, id, math, english, science)
select(exam, -class)  # class 변수(컬럼) 제외하고 모든 변수 선택

# math, english, science를 선택
select(exam, math, english, science)
select(exam, -id, -class)

# 수학점수 50점 이상인 학생들의 id와 수학점수를 검색
# 1) 수학점수 50점 이상인 학생들의 데이터 프레임 만듦.
df <- filter(exam, math >= 50)
# 2) 1)에서 생성한 데이터 프레임에서 id, math 변수 선택.
select(df, id, math)

# 수학점수와 영어점수 모두 60점 이상인 학생들
filter(exam, math >= 60 & english >= 60)
filter(exam, math >= 60, english >= 60)
# filter() 함수에서 조건식들이 쉼표(,)로 연결되는 경우는 & 연산을 수행.

filter(exam, math >= 60 | english >= 60)

str(df)  # filter() 결과 - data.frame
df2 <- select(df, id, math)
str(df2)  # select() 결과 - data.frame

# pipe 연산자: %>%
# dplyr 패키지가 메모리에 로딩되어 있을 때만 사용 가능.
# 단축키: Ctrl + Shift + M
# 데이터 프레임 %>% 함수()
# 함수의 첫번째 argument로 데이터 프레임을 전달

filter(exam, class == 1)
exam %>% filter(class == 1)

select(exam, id, math)
exam %>% select(id, math)

# 수학점수 60점 이상인 학생들의 id, math를 검색
exam %>% filter(math >= 60) %>% select(id, math)
# select id, math from exam where math >= 60;

exam %>% 
  filter(math >= 60) %>% 
  select(id, math)

# 영어점수, 수학점수 모두 평균이상인 학생들의 
# class, math, english 검색.
df3 <- filter(exam, math >= mean(math) & english >= mean(english))
df3
select(df3, class, math, english)

exam %>% 
  filter(math >= mean(math) & english >= mean(english)) %>% 
  select(class, math, english)

# 1반 학생들의 id, class, math를 출력
exam %>% 
  filter(class == 1) %>% 
  select(id, class, math)

search()
library(tidyverse)
# ggplot2::mpg 데이터 프레임에서
mpg <- as.data.frame(ggplot2::mpg)
head(mpg)

# 1) 배기량(displ)이 4 이하인 자동차와 5 이상인 자동차의
# 고속도로 연비(hwy) 평균을 비교하세요.
df_displ4 <- filter(mpg, displ <= 4)
str(df_displ4)
df_displ5 <- filter(mpg, displ >= 5)

mean(df_displ4$hwy)
mean(df_displ5$hwy)

# df <- mpg %>% 
#   filter(displ <= 4) %>% 
#   select(hwy)
# str(df)
# str(df$hwy)

# 2) 자동차의 종류(class)가 compact인 자동차와 suv인 자동차의
# 고속도로 연비 평균을 비교하세요.
df_compact <- filter(mpg, class == 'compact')
mean(df_compact$hwy)
df_suv <- filter(mpg, class == 'suv')
mean(df_suv$hwy)

# 3) 자동차 제조사(manufacturer)들 중 가장 많은 모델을 갖고 있는
# 2개 제조사를 찾아서, 두 제조사의 고속도로 연비 평균을 비교하세요.
table(mpg$manufacturer)
# > dodge: 37개 모델, toyota: 34 모델
df_dodge <- filter(mpg, manufacturer == 'dodge')
mean(df_dodge$hwy)
df_toyota <- filter(mpg, manufacturer == 'toyota')
mean(df_toyota$hwy)

mpg %>% 
  group_by(manufacturer) %>% 
  summarise(n = n(), mean = round(mean(hwy), 1)) %>% 
  arrange(-n) %>% 
  head(n = 2)

