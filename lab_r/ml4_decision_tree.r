# 의사결정 나무(decision tree)를 사용한 대출 위험 예측

library(tidyverse)  # 데이터 전처리, 시각화
library(C50)        # 의사결정 나무 알고리즘
library(gmodels)    # CrossTable

# 1. CSV 파일에서 데이터 읽고, 데이터 프레임 생성
credit_df <- read.csv(file = 'data/credit.csv',
                      encoding = 'UTF-8')
str(credit_df)
head(credit_df)
#> 목적: default(채무불이행, 파산) 예측

summary(credit_df)

table(credit_df$checking_balance)
table(credit_df$default)

# 관심 변수 default를 카테고리 변수(factor)로 변환
credit_df$default <- factor(x = credit_df$default,
                            levels = c('no', 'yes'))
summary(credit_df)


# 2. 데이터 탐색
# checking_balance 별 default==yes인 자료의 개수
credit_df %>% 
  filter(default == 'yes') %>% 
  group_by(checking_balance) %>% 
  summarise(default = n())

# savings_balance 별 default==yes인 자료의 개수
credit_df %>% 
  filter(default == 'yes') %>% 
  group_by(savings_balance) %>% 
  summarise(default = n()) %>% 
  arrange(desc(default))

# amount ~ age 산점도 그래프. 색깔은 default 여부에 따라서.
qplot(data = credit_df, x = age, y = amount, color = default)

# amount ~ months_loan_duration 산점 그래프.
# 색깔은 default 여부에 따라서.
qplot(data = credit_df, 
      x = months_loan_duration, y = amount, 
      color = default)

# savings_balance 별 amount의 box plot
qplot(data = credit_df,
      x = savings_balance, y = amount,
      geom = 'boxplot')

# 데이터 프레임을 훈련, 테스트 세트(9:1)로 분리
# 1) 데이터 프레임에서 레이블을 분리
credit_data <- credit_df[, 1:16]  #> 데이터 프레임
credit_labels <- credit_df[, 17]  #> 벡터

# 2) 훈련 세트, 훈련 레이블, 테스트 세트, 테스트 레이블
train_set <- credit_data[1:900, ]
train_labels <- credit_labels[1:900]

test_set <- credit_data[901:1000, ]
test_labels <- credit_labels[901:1000]

table(train_labels)
prop.table(table(train_labels))

table(test_labels)
prop.table(table(test_labels))

# 3. 모델 선택, 학습
model <- C5.0(x = train_set,     # 데이터 프레임
              y = train_labels)  # factor(레이블)
model
#> Number of samples = observations 개수(데이터 프레임 row 개수)
#> Number of predictors = variables 개수(데이터 프레임 coloum 개수)
#> Tree size: 나무의 깊이(depth)

summary(model)

plot(model)
plot(model, subtree = 21)

# 모델 사용, 예측, 모델 평가
predictions <- predict(model, test_set)
predictions

mean(predictions == test_labels)
#> 테스트 세트의 예측 정확도(accuracy): 0.67
#> 훈련 세트의 정확도: (612 + 172) / 900 = 0.876
#> 과적합(overfitting)

# 5. 모델 개선
model_2 <- C5.0(x = train_set,
                y = train_labels,
                trials = 10)  # trials: 트리 개수(AdaBoost)
model_2
#> Number of boosting iterations = 생성된 트리 개수
#> Average tree size = 평균 트리 크기(depth)

summary(model_2)

predictions_2 <- predict(model_2, test_set)
mean(predictions_2 == test_labels)  #> 0.67
CrossTable(x = test_labels, y = predictions_2,
           prop.chisq = FALSE)


# Decision Tree 개선 방법 2:
# 오류(error)에 대한 비용(손실, cost) 가중치를 설정
# -> 비용이 큰 오류가 작아지도록 트리가 만들어 짐.

# 비용 행렬
matrix_dim_names <- list(predicted = c('no', 'yes'),
                         actual = c('no', 'yes'))
matrix_dim_names

cost_matrix <- matrix(data = c(0, 1, 4, 0), nrow = 2,
                      dimnames = matrix_dim_names)
cost_matrix

# 모델 학습(훈련)
model_3 <- C5.0(x = train_set,
                y = train_labels,
                costs = cost_matrix)

summary(model_3)

predictions_3 <- predict(model_3, test_set)
mean(predictions_3 == test_labels)
CrossTable(x = test_labels, y = predictions_3, 
           prop.chisq = FALSE)
