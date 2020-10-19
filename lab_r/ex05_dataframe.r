# install.packages('tidyverse')  # 필요한 패키지 설치.
library(tidyverse)  # 패키지를 메모리에 로딩.
search()  # 메모리에 로딩된 패키지 이름들을 검색.

# 데이터 프레임 파악.

# CSV 파일을 읽어서 데이터 프레임 생성.
exam <- read.csv(file = 'data/csv_exam.csv')

# 데이터 프레임 출력
exam  # 콘솔 출력
View(exam)  # 코드 편집기 창에 테이블(표) 형태로 보여줌.

head(exam, n = 3)  # 데이터 프레임 시작부분부터 일부분만 출력.
tail(exam, n = 5)  # 데이터 프레임 끝부분에서 일부분만 출력.
# head(), tail()에서 n의 기본값은 6.

dim(exam)  # 데이터 프레임의 dimension(차원) - 행/열 개수
dim(exam)[1]  # 행(observations) 개수
dim(exam)[2]  # 열(variables) 개수

str(exam)  # 데이터 프레임의 구조(structure)

summary(exam)  # 데이터 프레임의 기술 통계량 요약.
# descriptive statistics summary
# 최솟값(min), 최댓값(max), 평균(mean)
# 중앙값(median), 백분위값(25%, 50%, 75%)

summary(exam$science)  # 데이터 프레임의 특정 컬럼 요약.

colnames(exam)  # 데이터 프레임의 컬럼 이름들 (벡터)
colnames(exam)[1]  # 벡터[인덱스]

data <- 1:5
data
summary(data)

data <- 1:10
summary(data)

head(exam)

# exam 데이터 프레임에 세 과목의 총점 total 컬럼(변수)를 추가.
exam$total <- exam$math + exam$english + exam$science
exam

# exam 데이터 프레임에 세 과목의 평균 average 컬럼(변수)를 추가.
exam$average <- exam$total / 3
exam

# ifelse(조건식, 값1, 값2) 함수:
#   조건식이 TRUE이면 값1을 반환(return)
#   조건식이 FALSE이면 값2를 반환(return)
age <- 5
ifelse(age > 18, '성년', '미성년')

# exam 데이터 프레임에 result 컬럼(변수)를 추가.
# 평균점수가 60점 이상이면 Pass, 그렇지 않으면 Fail.
exam$result <- ifelse(exam$average >= 60, 'Pass', 'Fail')
exam

# exam 데이터 프레임에 grade 컬럼(변수)를 추가.
# 평균점수가 80점 이상이면 A,
# 평균점수가 60점 이상이면 B,
# 평균점수가 60점 미만이면 F.

exam$grade <- ifelse(exam$average >= 80, 'A', 
                     ifelse(exam$average >= 60, 'B', 'F'))
exam


# ggplot2::mpg 예제 데이터 프레임을 복사.
mpg_df <- as.data.frame(ggplot2::mpg)

# 앞에 있는 데이터 5개 row를 출력.
head(mpg_df, n = 5)
# 뒤에 있는 데이터 6개 row를 출력.
tail(mpg_df)  # head(), tail() 함수에서 n의 기본값 = 6.

# 데이터 프레임의 구조(행/열 개수, 변수 이름, 변수 타입)를 확인.
str(mpg_df)

# 데이터 프레임의 요약 통계량 출력.
summary(mpg_df)

# cty 컬럼의 이름을 city_mpg로 변경.
# hwy 컬럼의 이름을 highway_mpg로 변경.
mpg_df <- rename(mpg_df, city_mpg = cty, highway_mpg = hwy)
# (주의) rename() 함수의 결과를 저장해야 함!
head(mpg_df)

# city_mpg와 highway_mpg의 평균을 avg_mpg 컬럼으로 추가.
mpg_df$avg_mpg <- (mpg_df$city_mpg + mpg_df$highway_mpg) / 2
summary(mpg_df$avg_mpg)

# avg_mpg 컬럼의 값이 20 이상이면 pass, 그렇지 않으면 fail
# 컬럼(mpg_test)을 추가
mpg_df$mpg_test <- ifelse(mpg_df$avg_mpg >= 20, 'pass', 'fail')
head(mpg_df, n = 20)

