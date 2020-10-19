# 위스콘신 대학 유방암 데이터 프레임의 knn 분류

# 필요한 라이브러리들을 메모리에 로드
library(tidyverse)  # 데이터 전처리, 시각화, ...
library(class)      # knn 함수
library(gmodels)    # CrossTable 함수
search()

# 1. 데이터 수집
wisc_bc <- read.csv(file = 'data/wisc_bc_data.csv')
str(wisc_bc)
summary(wisc_bc)
head(wisc_bc)

# 2. 데이터 탐색, 전처리
# 환자 아이디(id)는 데이터 프레임에서 제거.
# diagnosis(진단): 암인지 아닌지 진단된 데이터 - 관심 변수.
# id, diagnosis 제외한 나머지 변수들 - 진단 검사 데이터.

# knn() 함수에서는 레이블들이 factor 타입이어야 함.
table(wisc_bc$diagnosis)
# B(Benign): 양성 종양(암 X)
# M(Malignant): 악성 종양(암 O)

wisc_bc$diagnosis <- factor(wisc_bc$diagnosis,
                            levels = c('B', 'M'),
                            labels = c('Benign', 'Malignant'))
str(wisc_bc$diagnosis)
head(wisc_bc$diagnosis, n = 10)
tail(wisc_bc$diagnosis, n = 10)

# data와 labels을 분리
bc_data <- wisc_bc[, 3:32]  # 569 x 30 (2차원 데이터 프레임)
bc_labels <- wisc_bc[, 2]   # 569 (1차원 벡터)

# pair plots(scatter plot matrices)
pairs(bc_data[, 1:5])

# 데이터를 훈련(train)/테스트(test) 세트 분리 - 8:2
train_size <- round(569 * 0.8)

# 훈련 세트, 훈련 레이블
train_set <- bc_data[1:train_size, ]
train_labels <- bc_labels[1:train_size]
table(train_labels)  # 카테고리 변수의 빈도수
prop.table(table(train_labels))  # 카테고리 변수의 비율

# 테스트 세트, 테스트 레이블
test_set <- bc_data[(train_size + 1):569, ]
test_labels <- bc_labels[(train_size + 1):569]
prop.table(table(test_labels))

# ---------- #
v <- c(1, 3, 9)
v
length(v)  #> 3: 벡터의 원소의 개수
dim(v)     #> NULL - 2차원 이상의 자료 타입에서만 dim을 사용.
v[3]

df <- data.frame(val = v)
df
length(df)  #> 1: 데이터 프레임의 컬럼(변수) 개수
dim(df)     #> 3 1: row 개수, column 개수
df[1]   #> 데이터 프레임 df의 첫번째 컬럼 선택.
df[1,]  #> 데이터 프레임 df의 첫번째 row의 모든 컬럼 선택.
# ---------- #

# 3. knn 알고리즘 적용, 예측값
predictions <- knn(train = train_set,
                   test = test_set,
                   cl = train_labels)
predictions

# 4. 평가(Evaluations)
# accuracy(정확도)
mean(predictions == test_labels)

# confusion matrix(혼동 행렬)
CrossTable(x = test_labels, y = predictions,
           prop.chisq = FALSE)

# 5. 개선(Improve)
# 변수들의 값의 크기가 제각각이어서 정규화 또는 표준화가 필요!

min_max_normalize <- function(x) {
  # 최솟값 -> 0, 최댓값 -> 1, 모든 값들을 0 ~ 1 값으로 변환
  return((x - min(x)) / (max(x) - min(x)))
}

bc_data_normalized <- 
  as.data.frame(lapply(bc_data, min_max_normalize))

summary(bc_data_normalized)

train_set_normalized <- bc_data_normalized[1:train_size, ]
test_set_normalized <- bc_data_normalized[(train_size + 1):569, ]

predictions2 <- knn(train = train_set_normalized,
                    test = test_set_normalized,
                    cl = train_labels)

mean(predictions2 == test_labels)

CrossTable(x = test_labels, y = predictions2, 
           prop.chisq = FALSE)

