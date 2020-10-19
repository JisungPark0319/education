# SVM(Support Vector Machine)을 사용한 수치 예측(Regression)

# white wine의 quality 값 예측
whitewine_df <- read.csv(file = 'data/whitewines.csv')
str(whitewine_df)
summary(whitewine_df$quality)

# train/test 분리
train_idx <- 1:round(4898 * 0.8)
wine_train <- whitewine_df[train_idx, ]
wine_test <- whitewine_df[-train_idx, ]

summary(wine_train$quality)
summary(wine_test$quality)

# 모델 훈련
library(kernlab)
svm_regressor <- ksvm(x = quality ~ .,
                      data = wine_train,
                      kernel = 'vanilladot')

# 테스트 세트 예측
predictions <- predict(svm_regressor, wine_test)
head(predictions, n = 10)  # 예측값
head(wine_test$quality, n = 10)  # 실제값  

# 수치 예측 평가 지표: MAE, MSE, RMSE(Root Mean Square Errors)
# sqrt(mean((actual - predict)^2))
library(ModelMetrics)
rmse(actual = wine_test$quality, predicted = predictions)
  

# concrete 강도(strength) 예측
# 1. 데이터 준비
concrete_df <- read.csv(file = 'data/concrete.csv')
str(concrete_df)
head(concrete_df)
tail(concrete_df)

# 2. 데이터 탐색, 전처리, train/test 분리
train_idx <- 1:round(1030 * 0.8)
X_train <- concrete_df[train_idx, ]
X_test <- concrete_df[-train_idx, ]

# 3. 모델 훈련
svm_regressor <- ksvm(x = strength ~ .,
                      data = X_train,
                      kernel = 'rbfdot')

# 4. 모델 평가
predictions <- predict(svm_regressor, X_test)
head(predictions)
head(X_test$strength)

rmse(actual = X_test$strength, predicted = predictions)

errors <- X_test$strength - predictions
summary(errors)

# concrete 데이터를 Linear Regression, Regression Tree를 사용했을 때
# 결과들과 비교.

