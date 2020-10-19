# Random Forest: Bagging + Decision Tree Ensemble
# Bagging(Bootstrap Aggregating):
#   학습 세트에서 "중복을 허용"해서 샘플링하는 방법.
# Ensemble: 여러개의 알고리즘을 훈련.

install.packages('randomForest')
library(randomForest)

# Random Forest를 이용한 wisc_bc_data 분류
# 1. 데이터 준비
wisc_dc_data <- read.csv(file = 'data/wisc_bc_data.csv')
str(wisc_dc_data)

# 2. 데이터 탐색, 전처리, train/test 세트 분리
# id 변수(컬럼)를 제거
wisc_dc_data <- wisc_dc_data[-1]

# diagnosis 변수를 factor로 변환
wisc_dc_data$diagnosis <- factor(wisc_dc_data$diagnosis,
                                 levels = c('B', 'M'),
                                 labels = c('Benign', 'Malignant'))

str(wisc_dc_data)
table(wisc_dc_data$diagnosis)

# train/test 분리
train_size <- round(569 * 0.8)
train_idx <- 1:train_size

bc_train <- wisc_dc_data[train_idx, ]
bc_test <- wisc_dc_data[-train_idx, ]

# 3. random forest 모델 훈련
rf_classifier <- randomForest(formula = diagnosis ~ .,
                              data = bc_train)
rf_classifier

# 4. 예측, 평가
predictions <- predict(rf_classifier, bc_test)
mean(bc_test$diagnosis == predictions)

library(gmodels)
CrossTable(x = bc_test$diagnosis, y = predictions,
           prop.chisq = FALSE)

# 5. 모델 개선
# 1) randomForest() 함수의 여러가지 argument 값들을 변경, 테스트.
# 2) 다른 알고리즘의 훈련 결과와도 비교.

# iris, credit 데이터 등을 사용해서 Random Forest 분류 연습.



# Rnadom Forest를 이용한 concrete 강도 예측(regression)
# 1. 데이터 준비
concrete_df <- read.csv(file = 'data/concrete.csv')
str(concrete_df)

# train/test 분리
train_size <- 1030 * 0.8
train_idx <- 1:train_size

concrete_train <- concrete_df[train_idx, ]
concrete_test <- concrete_df[-train_idx, ]

# Random Forest 모델 훈련
rf_regressor <- randomForest(formula = strength ~ .,
                             data = concrete_train)
rf_regressor

# 테스트 세트로 예측, 평가
predictions <- predict(rf_regressor, concrete_test)
head(concrete_test$strength)
head(predictions)

# RMSE(Root Mean Square Errors)
library(ModelMetrics)
rmse(actual = concrete_test$strength, predicted = predictions)

# 다른 알고리즘(lm, ksvm, ...)의 RMSE 값과 비교.