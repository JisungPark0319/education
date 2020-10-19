# Linear Regression(선형 회귀)

library(tidyverse)

heights <- read.csv(file = 'data/heights.csv')
str(heights)

# son ~ father 산점도 그래프
ggplot(data = heights,
       mapping = aes(x = father, y = son)) +
  geom_point() +
  geom_smooth(method = 'lm')  # linear modeling: y ~ x

# lm: linear modeling
reg_model <- lm(formula = son ~ father, data = heights)
reg_model  #> son = a + b * father
reg_model$coefficients
reg_model$coefficients[1]  #> y절편(intercept)
reg_model$coefficients[2]  #> 기울기(slope)

ggplot(data = heights,
       mapping = aes(x = father, y = son)) +
  geom_point() +
  geom_smooth(method = 'lm') +
  geom_abline(intercept = reg_model$coefficients[1],
              slope = reg_model$coefficients[2],
              linetype = 'dashed', color = 'red')

# son(y) ~ father(x): son = a + b * father, y = a + b * x
mu_x <- mean(heights$father)  # father의 평균
mu_y <- mean(heights$son)     # son의 평균

var_x <- var(heights$father)  # father의 분산(variance)
var_y <- var(heights$son)     # son의 분산

# father(x)와 son(y)의 공분산(covariance)
cov_xy <- cov(heights$father, heights$son)

# 선형 회귀식(y = a + bx)의 기울기 b = Cov(x, y) / Var(x)
b <- cov_xy / var_x

# 선형 회귀 직선은 두 변수의 평균인 점(mu_x, mu_y)을 지남.
# y절편: a = mu_y - slope * mu_x
a <- mu_y - b * mu_x

reg_model$coefficients

ggplot(data = heights,
       mapping = aes(x = father, y = son)) +
  geom_point() +
  geom_vline(xintercept = mu_x, color = 'green') +
  geom_hline(yintercept = mu_y, color = 'green') +
  geom_smooth(method = 'lm')


# 단순 선형 회귀: 독립변수 1개, 종속변수 1개
# y = a + bx
lm_result <- lm(formula = son ~ father, data = heights)

# 단순 선형 회귀 결과 분석
lm_result
summary(lm_result)
#> Residuals: 잔차(오차, error)들의 요약 통계량
lm_result$residuals
min(lm_result$residuals)

#> Coefficients: 회귀 방정식의 계수들(절편, 기울기)
#    Estimate의 값들이 회귀 방정식의 계수로 추정된 값.
#    Pr(>|t|): p-value. 0.05보다 작은 경우 유의미하다고 말함.

#> Multiple R-squared: 
#    회귀 방정식이 관측치의 몇 %를 설명하는 지를 알려주는 값.
#    R^2 = 0.251: 전체 데이터의 25.1%를 잘 설명함.

# 선형 회귀 방정식 y = a + bx를 찾을 때
# 실제값과 예측값 사이의 오차들의 제곱의 합이 최소가 되도록.
# 실제값: heights$son
# 예측값: son_ex = intercept + slope * father 식으로 계산된 값.
# 잔차(residual): heights$son - son_ex

# 잔차(residual)들의 평균 ~ 0
mean(lm_result$residuals)

# 잔차들의 합, 또는 평균은 0이기 때문에, 
# 잔차들의 제곱의 합 또는 제곱의 평균을 계산
sqrt(mean(lm_result$residuals ^ 2))


# 다항 선형 회귀
# 1. 데이터 준비
insurance_df <- read.csv(file = 'data/insurance.csv')
str(insurance_df)
head(insurance_df)
summary(insurance_df)

table(insurance_df$sex)
table(insurance_df$smoker)
table(insurance_df$region)

# 다항 선형 회귀
# expenses = a + b1 * age + b2 * sex + b3 * bmi + 
#            b4 * children + b5 * smoker + b6 * region
# expenses ~ age + sex + bmi + children + smoker + region

insurance_lm <- lm(formula = expenses ~ ., 
                   data = insurance_df)
insurance_lm
#> 범주형 변수(sex, smoker, region)들을 0 또는 1로 변환.

summary(insurance_lm)

# 유의미하다고 볼 수 없는 변수들을 제외하고 linear modeling
insurance_lm_2 <- lm(formula = expenses ~ age + bmi + children + smoker,
                     data = insurance_df)
summary(insurance_lm_2)

# 데이터 프레임에 변수를 추가
insurance_df$age_square <- (insurance_df$age) ^ 2
head(insurance_df)

# bmi(body mass index) = 몸무게/키^2  (kg/m^2)
# bmi >= 25: 과체중, bmi >= 30: 비만
insurance_df$bmi30 <- ifelse(insurance_df$bmi >= 30, 1, 0)
head(insurance_df)

insurance_lm_3 <- lm(formula = expenses ~ age + bmi + children 
                     + smoker + age_square + bmi30 + bmi30 * smoker,
                     data = insurance_df)
summary(insurance_lm_3)
  
insurance_lm_4 <- lm(formula = expenses ~ bmi + children + smoker 
                     + age_square + bmi30 * smoker,
                     data = insurance_df)
summary(insurance_lm_4)
