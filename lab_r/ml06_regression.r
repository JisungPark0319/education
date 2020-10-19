# 1. 데이터 수집
redwine_df <- read.csv(file = 'data/redwines.csv')
str(redwine_df)
summary(redwine_df)
head(redwine_df)

# 2. 데이터 탐색, 전처리, 훈련/테스트 세트 분리
# 훈련:테스트 = 0.8:0.2
train_size <- round(1599 * 0.8)
train_idx <- 1:test_size  # 1:1279
# rm(list = c('test_size', 'test_idx'))

X_train <- redwine_df[train_idx, ]  # 훈련 세트
X_test <- redwine_df[-train_idx, ]  # 테스트 세트

summary(X_train$quality)
summary(X_test$quality)

# 3. 기계 학습 알고리즘(모델) 훈련
# Linear Regression 모델: quality ~ .
linreg <- lm(formula = quality ~ ., data = X_train)
summary(linreg)

# 4. 모델 평가(평가 지표: 분류 - 정확도, 수치예측 - 오차)
# 훈련된 모델에 테스트 세트를 줘서 예측을 함.
predictions <- predict(linreg, X_test)
head(predictions, n = 10)     # 모델의 예측값
head(X_test$quality, n = 10)  # 테스트 데이터의 실제값

# 예측값과 실제값 사이의 오차들 합
sum(X_test$quality - predictions)  # 0에 가까운 값
mean(X_test$quality - predictions)  # 오차들의 평균 ~ 0

# 수치 예측 문제에서 모델의 성능을 평가할 때는, 오차들의 부호(+, -)를
# 제거한 값들의 평균으로 평가를 함.
# 1) 오차들의 절대값들의 평균(MAE: Mean Absolute Errors)
# 2) 오차들의 제곱들의 평균(MSE: Mean Square Errors)
# -> RMSE(Root Mean Square Errors): 오차 제곱 평균의 제곱근
mae_redwine <- mean(abs(X_test$quality - predictions))
mae_redwine
mse_redwine <- mean((X_test$quality - predictions)^2)
mse_redwine
rmse_redwine <- sqrt(mse_redwine)
rmse_redwine

install.packages('ModelMetrics')
library(ModelMetrics)
mae(actual = X_test$quality, predicted = predictions)
mse(actual = X_test$quality, predicted = predictions)
rmse(actual = X_test$quality, predicted = predictions)

# 5. 모델 개선


# Regression Tree 알고리즘 적용
install.packages(c('rpart', 'rpart.plot'))
# Recursive Partitioning
# rpart: regression tree 생성 패키지
# rpart.plot: regression tree를 시각화

library(rpart)
library(rpart.plot)
search()

# 모델 훈련
rpart_model <- rpart(formula = quality ~ ., data = X_train)
rpart_model  # tree

rpart.plot(rpart_model, cex = 0.7)

# 테스트 세트로 예측, 평가
predictions_rpart <- predict(rpart_model, X_test)
head(predictions_rpart, n = 10)
head(X_test$quality, n = 10)

mae(actual = X_test$quality, predicted = predictions_rpart)
mse(actual = X_test$quality, predicted = predictions_rpart)

