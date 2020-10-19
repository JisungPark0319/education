# SVM(Support Vector Machine)을 사용한 분류(classification)

# iris 품종 분류
iris_df <- as.data.frame(datasets::iris)
head(iris_df)

# 데이터를 랜덤하게 섞고, train(훈련)/test(검증) 세트로 분리.
train_size <- 150 * 0.8
train_idx <- sample(150, size = train_size)
#> 1:150 정수들 중에서 랜덤하게 120(size)개를 선택

iris_train <- iris_df[train_idx, ]
head(iris_train)

iris_test <- iris_df[-train_idx, ]
head(iris_test)

prop.table(table(iris_train$Species))
prop.table(table(iris_test$Species))

# SVM 알고리즘 구현 패키지 설치
install.packages('kernlab')
library(kernlab)

# SVM 모델을 훈련
svm_classifier <- ksvm(x = Species ~ .,        # 관심변수 ~ .
                       data = iris_train,      # 훈련 세트(데이터 프레임)
                       kernel = 'vanilladot')  # kernel 함수 이름
# ksvm() 함수의 scaled argument:
#   훈련 세트(데이터 프레임)의 변수들을 scaling할 것인지 아닌지를 결정.
#   scaled = TRUE: ksvm() 함수가 변수들을 표준화(평균 0, 표준편차 1)를 실행.
#   scaled의 기본값은 TRUE.

# 테스트 세트를 모델에 적용해서, 예측, 평가
predictions <- predict(svm_classifier, iris_test)
predictions  # SVM 모델이 예측한 결과

# 정확도
mean(iris_test$Species == predictions)

# Confusion Matrix
library(gmodels)
CrossTable(x = iris_test$Species, y = predictions,
           prop.chisq = FALSE)

# Gaussian RBF 커널 함수, Polynomial 커널 함수와 결과 비교.
svm_rbf <- ksvm(x = Species ~ ., data = iris_train,
                kernel = 'rbfdot')
predictions_rbf <- predict(svm_rbf, iris_test)
mean(iris_test$Species == predictions_rbf)
CrossTable(x = iris_test$Species, y = predictions_rbf,
           prop.chisq = FALSE)

svm_poly <- ksvm(x = Species ~ ., data = iris_train,
                 kernel = 'polydot')
predictions_poly <- predict(svm_poly, iris_test)
mean(iris_test$Species == predictions_poly)
CrossTable(x = iris_test$Species, y = predictions_poly,
           prop.chisq = FALSE)


# wisc_bc_data.csv (종양 데이터)
# 1. 데이터 준비
wisc_bc_data <- read.csv(file = 'data/wisc_bc_data.csv')
str(wisc_bc_data)

# 환자 아이디(id)는 데이터 프레임에서 제거
wisc_bc_data <- wisc_bc_data[-1]  # data_frame[-col_index]
str(wisc_bc_data)

# 2. 데이터 탐색, 전처리, train/test 분리

# 분류를 하려고 하는 관심 변수 diagnosis를 factor로 변환해야 함!
wisc_bc_data$diagnosis <- factor(x = wisc_bc_data$diagnosis,
                                 levels = c('B', 'M'),
                                 labels = c('Benign', 'Malignant'))
str(wisc_bc_data)

train_size <- round(569 * 0.8)
train_idx <- 1:train_size

bc_train <- wisc_bc_data[train_idx, ]
bc_test <- wisc_bc_data[-train_idx, ]

prop.table(table(bc_train$diagnosis))
prop.table(table(bc_test$diagnosis))

# 3. SVM 모델 훈련(kernel = GaussianRBF)
set.seed(1)
sample(10)

svm_classifier <- ksvm(x = diagnosis ~ ., 
                       data = bc_train, 
                       kernel = 'polydot')

# 4. 테스트 세트 예측, 평가
predictions <- predict(svm_classifier, bc_test)
# 정확도(accuracy)
mean(bc_test$diagnosis == predictions)
# 혼돈 행렬
CrossTable(x = bc_test$diagnosis, y = predictions,
           prop.chisq = FALSE)

# 5. 개선(kernel = Polynomial, Linear)


# letterdata.csv: 
# OCR(Optical Character Recognition, 광학 문자 인식) 데이터
letter_df <- read.csv(file = 'data/letterdata.csv',
                      stringsAsFactors = TRUE)
str(letter_df)
table(letter_df$letter)
head(letter_df)
tail(letter_df)

# train/test 분리
train_size <- 20000 * 0.8
train_idx <- 1:train_size

letter_train <- letter_df[train_idx, ]
letter_test <- letter_df[-train_idx, ]

table(letter_train$letter)
table(letter_test$letter)

# 모델 훈련
svm_classifier <- ksvm(x = letter ~ .,
                       data = letter_train,
                       kernel = 'rbfdot')

# 예측
predictions <- predict(svm_classifier, letter_test)

# 평가: 실제값과 예측값 비교
mean(letter_test$letter == predictions)

CrossTable(x = letter_test$letter, y = predictions)
