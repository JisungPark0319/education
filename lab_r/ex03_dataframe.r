# Data Frame(데이터 프레임): 표 형태로 데이터를 저장하는 타입.
# observation(관측치, 관찰값): 데이터 프레임의 행(row)
# variable(변수): 데이터 프레임의 열(column)

numbers <- 1:4  # 1 ~ 4까지 연속된 정수.
names <- c('aaa', 'bbb', 'ccc', 'ddd')
korean <- c(100, 50, 90, 70)
english <- c(87, 78, 99, 85)

# 번호, 이름, 국어, 영어 점수를 컬럼들로 갖는 data frame(표).
students <- data.frame(numbers, names, korean, english)
students  # data frame의 내용을 출력.

# DF에서 컬럼을 선택: data_frame$column_name
students$korean

scores <- data.frame(c(100, 90, 70, 60),
                     c(99, 88, 100, 0),
                     c(10, 20, 50, 70))
scores
scores$c.100..90..70..60.
# 컬럼 이름이 지정되지 않아서 자동으로 생성됨.

# data.frame() 함수를 호출할 때 컬럼 이름을 지정할 수 있음.
scores2 <- data.frame(korean = c(90, 95, 97, 100),
                      english = c(100, 30, 50, 0),
                      math = c(78, 99, 81, 0))
scores2
scores2$korean

mean(scores2$korean)  # korean 컬럼의 평균 계산

# 파일의 내용을 읽어서, 데이터 프레임 생성 - CSV, 엑셀(xls, xlsx)
getwd()  # get working directory

# Ctrl+Space: 코드 자동 완성 힌트
exam_df <- read.csv(file = 'data/csv_exam.csv')
exam_df

# 각 과목의 평균을 계산해서 출력
mean(exam_df$math)
mean(exam_df$english)
mean(exam_df$science)

# 각 학생들의 과목 점수들의 합계(total = math + english + science)
exam_df$math + exam_df$english + exam_df$science

# exam_df 데이터 프레임에 total 컬럼(변수)를 생성해서, 총점 저장.
exam_df$total <- exam_df$math + exam_df$english + exam_df$science
exam_df

# 파생 변수: 데이터 프레임이 가지고 있는 변수들을 사용해서 
# 새로운 컬럼을 추가하는 것.

# fruit_df 라는 이름으로 데이터 프레임을 생성.
# 컬럼(변수): fruit, price, quantity
# 생성된 데이터 프레임을 출력.
# 과일 가격의 평균 계산 출력.
# total_price 라는 이름의 파생 변수를 fruit_df 데이터 프레임에 추가.
# fruit_df를 fruits.csv 파일에 저장.

fruit_df <- data.frame(fruit = c('수박', '사과', '복숭아', '참외'),
                       price = c(1000, 200, 500, 150),
                       quantity = c(3, 5, 10, 5))
fruit_df

mean(fruit_df$price)

fruit_df$total_price <- fruit_df$price * fruit_df$quantity
fruit_df

write.csv(fruit_df, file = 'data/fruits.csv',
          row.names = FALSE)
