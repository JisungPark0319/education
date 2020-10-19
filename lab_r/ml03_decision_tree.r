# 의사결정 나무(Decision Tree)를 사용한 분류(classification)

library(tidyverse)

install.packages('C50')  # C5.0 알고리즘을 사용한 Tree 구현 패키지.
library(C50)  # 패키지를 메모리에 로드

search()

# 1. 데이터 수집
iris <- as.data.frame(datasets::iris)
str(iris)
summary(iris)
head(iris)

# 2. 데이터 탐색, 전처리

# Petal.Length ~ Petal.Width 산점도 그래프.
# 점의 색깔을 품종별로 다르게 표현.
ggplot(data = iris) +
  geom_point(mapping = aes(x = Petal.Width, y = Petal.Length,
                           color = Species),
             size = 3) +
  geom_hline(yintercept = 2.0, linetype = 'dashed', size = 1) +
  geom_vline(xintercept = 1.75, linetype = 'dashed', size = 1)

# iris 데이터 프레임을 데이터/레이블 분리.
iris_data <- iris[, 1:4]  #> 2차원 데이터 프레임
head(iris_data)
iris_labels <- iris[, 5]  #> 1차원 벡터
head(iris_labels)

# 데이터와 레이블을 8:2 비율로 train/test 세트를 분리.
shuffled_idx <- sample(150)
shuffled_idx
train_idx <- shuffled_idx[1:120]
test_idx <- shuffled_idx[121:150]

iris_train_set <- iris_data[train_idx, ]
iris_train_labels <- iris_labels[train_idx]

iris_test_set <- iris_data[test_idx, ]
iris_test_labels <- iris_labels[test_idx]

prop.table(table(iris_train_labels))
prop.table(table(iris_test_labels))

# 3. 머신 러닝 모델(알고리즘) 선택, 학습(훈련)
model <- C5.0(x = iris_train_set,     # x = 훈련 세트(데이터 프레임)
              y = iris_train_labels)  # y = 훈련 레이블(factor)
model
summary(model)
plot(model)
plot(model, subtree = 3)

# 4. 테스트 세트로 예측, 검증, 평가
predictions <- predict(model, iris_test_set)
predictions

# 정확도
mean(iris_test_labels == predictions)
which(iris_test_labels != predictions)

library(gmodels)
CrossTable(x = iris_test_labels, y = predictions,
           prop.chisq = FALSE)

# 5. 개선




