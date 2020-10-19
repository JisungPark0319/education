# kNN 알고리즘을 이용한 Iris(붓꽃) 품종 분류
# k Nearest Neighbor(k 최근접 이웃)

library(tidyverse)

# 1. 데이터 셋 준비
# iris 예제 데이터 셋을 복사
iris <- as.data.frame(iris)
head(iris)
tail(iris)
str(iris)


# 2. 데이터 셋 탐색, 가공(전처리)
# iris의 품종(Species)
table(iris$Species)

# Petal.Length ~ Petal.Width 산점도 그래프. 
# 점의 색깔을 Species별로 다르게.
qplot(data = iris, x = Petal.Width, y = Petal.Length, color = Species)

# Sepal.Length ~ Sepal.Width
ggplot(data = iris) +
  geom_point(mapping = aes(x = Sepal.Width, y = Sepal.Length,
                           color = Species))

# Petal.Length ~ Sepal.Length 
qplot(data = iris, x = Sepal.Length, y = Petal.Length, color = Species)

# 데이터 프레임에서 인덱스(row, column 위치)로 원소 선택.
head(iris)
iris[1, 1]
iris[1, 2]
iris[1, 1:2]
iris[1, c(1, 4)]
iris[, 1:4]

# pair plots(scatter plot matrices)
pt_colors <- c('red', 'green', 'blue')
pairs(iris[, 1:4], col = pt_colors[iris$Species])


# 3. 모델(머신 러닝 알고리즘) 선택, 훈련(training)
# 데이터 셋을 훈련 셋(100)과 테스트 셋(50)을 분리.
# 데이터 프레임을 단순히 순서대로 100개, 50개의 row로 분리 -> 문제 생김.
# 데이터들이 섞여 있지 않아서 virginica 품종이 훈련되지 않는 문제.
# 데이터 셋을 분리하기 전에 무작위로 섞어줘야 함!

sample(10)
# sample(n): 1 ~ n까지 정수를 무작위로 섞인 값을 반환.
shuffled_idx <- sample(10)
shuffled_idx[1:7]  # random하게 섞인 10개 숫자 중에서 앞에서 7개 선택
shuffled_idx[8:10] # random하게 섞인 10개 숫자 중에서 뒤에서 3개 선택

# iris observation 개수만큼 random하게 섞인 인덱스:
shuffled_idx <- sample(150)
shuffled_idx

# data_frame[row_index, col_index]
# 훈련 셋(train set), 훈련 레이블(train label) 분리.
train_set <- iris[shuffled_idx[1:100], 1:4]
train_labels <- iris[shuffled_idx[1:100], 5]
head(train_set, n = 10)
train_labels[1:10]

# 테스트 셋(test set), 테스트 레이블(test label) 분리.
test_set <- iris[shuffled_idx[101:150], 1:4]
test_labels <- iris[shuffled_idx[101:150], 5]
head(test_set)
test_labels[1:6]

# train_labels의 각 품종별 빈도수
table(train_labels)
# test_labels의 각 품종별 빈도수
table(test_labels)

# kNN 알고리즘에 train_set, train_labels, test_set을 적용해서
# test_set의 예측값들을 찾음.

install.packages('class')  # classification(분류)
library(class)

predicts <- knn(train = train_set,
                test = test_set,
                cl = train_labels,
                k = 11)
predicts  # knn 알고리즘이 테스트 셋의 결과를 예측한 값.
test_labels  # 실제 값(품종)

# 예측값과 실제값 비교 -> 평가
predicts == test_labels
sum(predicts == test_labels)  # 예측이 맞은 개수
mean(predicts == test_labels)  # 예측 정확도(accuracy)

# 예측값과 실제값이 다른 인덱스(위치)
wrong_idx <- which(predicts != test_labels)
wrong_predicts <- test_set[wrong_idx, ]

# Confusion Matrix 작성
install.packages('gmodels')
library(gmodels)

CrossTable(x = test_labels, y = predicts)

# 예측 결과 시각화
ggplot(data = test_set) +
  geom_point(mapping = aes(x = Petal.Length, y = Petal.Width,
                           color = test_labels)) +
  geom_point(data = wrong_predicts,
             mapping = aes(x = Petal.Length, y = Petal.Width),
             shape = 'x', size = 3, color = 'red')
  

# 정규화/표준화의 필요성
# 변수(특징)들마다 단위, 크기가 서로 달라서,
# 거리를 계산할 때 미치는 영향이 달라질 수 있음.
# 모든 변수들이 거리를 계산할 때 비슷한 영향을 미치도록 크기 변환.
summary(iris)

# 함수이름 <- function(파라미터 선언) {기능 작성}
min_max_normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

v1 <- seq(1, 5)
v1
min_max_normalize(v1)

v2 <- seq(10, 50, 10)
v2
min_max_normalize(v2)

df <- data.frame(width = v1, length = v2)
df
lapply(df, min_max_normalize)
# lapply(데이터 프레임, 함수 이름)
# 데이터 프레임의 각 변수(컬럼)를 하나씩 함수의 argument로 전달.

df_normalized <- as.data.frame(lapply(df, min_max_normalize))
df_normalized

# iris 데이터 프레임에서 1 ~ 4번째 컬럼들을 normalize(정규화)
iris_normalized <- 
  as.data.frame(lapply(iris[, 1:4], min_max_normalize))

head(iris_normalized)
summary(iris_normalized)

# 훈련/테스트 셋 분리
shuffled_idx <- sample(150)
shuffled_idx

train_set <- iris_normalized[shuffled_idx[1:100], ]
str(train_set)
train_labels <- iris[shuffled_idx[1:100], 5]
table(train_labels)

test_set <- iris_normalized[shuffled_idx[101:150], ]
str(test_set)
test_labels <- iris[shuffled_idx[101:150], 5]
table(test_labels)

# kNN 알고리즘 적용, 예측
predicts <- knn(train = train_set,  # 훈련 데이터
                test = test_set,    # 테스트 데이터
                cl = train_labels,  # 훈련 데이터 레이블(정답)
                k = 1)
predicts

# 평가: 예측값과 실제값 비교
mean(predicts == test_labels)

CrossTable(x = test_labels, y = predicts)


# 정규화(Normalization): 변수들의 값을 0 ~ 1 사이의 값들로 변환.
# 표준화(Standardization): 변수들의 평균을 0, 표준편차를 1로 변환.

# 1) 함수 작성
standard_scaler <- function(x) {
  # x_new = (x - mean) / standard_deviation
  # x_new: 평균이 0이고, 표준편차가 1이 됨.
  return((x - mean(x)) / sd(x))
}

v <- 1:5
v
mean(v)
sd(v)
v_new <- standard_scaler(v)
v_new
mean(v_new)
sd(v_new)

# 위의 과정을 반복
iris <- as.data.frame(datasets::iris)
str(iris)
summary(iris)

# iris 데이터 프레임을 (수치) 데이터와 레이블(품종)로 구분.
iris_data <- iris[, 1:4]
iris_labels <- iris[, 5]
head(iris_data)
head(iris_labels)

# 2) iris 데이터를 표준화
iris_data <- as.data.frame(lapply(iris_data, standard_scaler))
summary(iris_data)
sd(iris_data$Sepal.Length)

# 3) train/test set 분리
# 데이터와 레이블들을 랜덤하게 섞어준 후, train(100)/test(50) 분리.
shuffled_idx <- sample(150)
shuffled_idx

train_set <- iris_data[shuffled_idx[1:100], ]
train_labels <- iris_labels[shuffled_idx[1:100]]
table(train_labels)

test_set <- iris_data[shuffled_idx[101:150], ]
test_labels <- iris_labels[shuffled_idx[101:150]]
table(test_labels)

# 4) knn 알고리즘 적용, 예측
predictions <- knn(train = train_set,
                   test = test_set,
                   cl = train_labels,
                   k = 11)
predictions

# 5) 평가
# 정확도(accuracy)
mean(predictions == test_labels)

# confusion matrix(혼동 행렬)
CrossTable(x = test_labels,
           y = predictions,
           prop.chisq = FALSE)
