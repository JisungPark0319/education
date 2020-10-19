# dplyr 패키지의 함수들 - 데이터 가공, 전처리
library(tidyverse)
search()

# data/csv_exam.csv 파일을 읽어서 데이터 프레임 생성.
exam <- read.csv(file = 'data/csv_exam.csv')
head(exam)

# arrange(): 정렬
# 수학점수(math)의 오름차순 정렬
arrange(exam, math)

# math의 내림차순 정렬
arrange(exam, desc(math))
arrange(exam, -math)

# class의 오름차순 ==> math의 오름차순
arrange(exam, class, math)

# class의 오름차순 ==> math의 내림차순
arrange(exam, class, desc(math))

# math 점수 상위 5명을 출력
# 1) math의 내림차순으로 정렬
exam_arranged_by_math <- arrange(exam, desc(math))
exam_arranged_by_math
# 2) 정렬된 데이터 프레임에서 위에서 5개만 출력
head(exam_arranged_by_math, n = 5)

# pipe 연산자 연쇄 호출(chain call)
exam %>% 
  arrange(desc(math)) %>% 
  head(n = 5)

# 1반에서 수학점수 상위 2명을 출력
exam %>% 
  filter(class == 1) %>% 
  arrange(desc(math)) %>% 
  head(n = 2)

# 1, 2반 학생들 중에서 수학 점수 상위 3명의 id, class, math를 출력
exam %>% 
  filter(class %in% c(1, 2)) %>%  # class == 1 | class == 2
  arrange(desc(math)) %>% 
  head(n = 3) %>% 
  select(id, class, math)


# 파생 변수 추가
# data_frame$new_var <- 계산식
# mutate(data_frame, new_var = 계산식, ...)

# exam 데이터 프레임에 세 과목 총점 컬럼(변수) total을 추가.
# exam$total <- exam$math + exam$english + exam$science
# 위 방식은 exam 데이터 프레임을 변경.

mutate(exam, total = math + english + science)
# > mutate 이후에 exam 데이터 프레임의 컬럼(변수) 개수? 5개
# mutate 함수는 컬럼이 추가된 새로운 데이터 프레임을 반환(return)
# 원본 exam 데이터 프레임은 변경되지 않음!

exam_added <- mutate(exam, total = math + english + science)

# exam 데이터 프레임에 세과목의 총점과 평균을 추가.
mutate(exam,
       total = math + english + science,
       avgerage = total / 3)

# exam 데이터 프레임에 세과목 평균(average)과 학점(grade) 컬럼 추가.
# 학점은, 평균이 85점 이상이면 'A',
# 평균이 70점 이상이면 'B',
# 평균이 55점 이상이면 'C',
# 평균이 55점 미만이면 'F'
mutate(exam,
       average = (math + english + science) / 3,
       grade = ifelse(average >= 85, 'A',  
                      ifelse(average >= 70, 'B', 
                             ifelse(average >= 55, 'C', 'F'))))

# exam 데이터 프레임에서 세과목 평균(average) 상위 5명을 출력
exam %>% 
  mutate(average = (math + english + science) / 3) %>% 
  arrange(desc(average)) %>% 
  head(n = 5)

# summarise(), summarize(): 통계(집계) 함수 적용
# 전체 학생들의 수학 점수 평균
mean(exam$math)
summarise(exam, mean(math))
summarise(exam, avg_math = mean(math))

# 전체 학생들의 수학 평균, 영어 평균, 과학 평균
summarise(exam,
          avg_math = mean(math),
          avg_eng = mean(english),
          avg_sci = mean(science))

# class별 모든 과목의 평균, 학생수 출력
exam %>% 
  group_by(class) %>% 
  summarise(mean_math = mean(math), 
            mean_english = mean(english), 
            mean_science = mean(science),
            counts = n())

# class 별 math의 평균. math의 평균이 60점 이상인 class만 출력.
# math 평균 점수가 높은 반부터 내림차순으로 출력.
# select avg(math) as MEAN_MATH
# from exam 
# group by class 
# having avg(math) >= 60
# order by MEAN_MATH desc;

exam %>% 
  group_by(class) %>% 
  summarise(mean_math = mean(math)) %>% 
  filter(mean_math >= 60) %>% 
  arrange(desc(mean_math))


