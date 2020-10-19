# Missing Value(결측치) 처리
# NA: Not Available
x <- NA  # x는 값이 없음. x는 값을 모름.

# NA는 산술 연산(+, -, *, /, ...)이 불가능.
x + 1  #> NA

# NA는 비교(==, !=, >, <, ...)가 불가능.
x == 0  #> NA

x == NA   #> NA
NA == NA  #> NA
is.na(x)  #> TRUE

# NA를 비교 연산자에서 사용할 수 없는 이유:
chulsu_age <- NA  # 철수의 나이를 모름.
younghee_age <- NA  # 영희의 나이를 모름.
chulsu_age == younghee_age
# 철수의 나이와 영희의 나이가 같은가요? > 모름!

df <- data.frame(gender = c('M', 'F', NA, 'F', 'M'),
                 score = c(5, 4, 3, NA, 4))
df

is.na(df$gender)
is.na(df$score)
is.na(df)
table(is.na(df))

df
summary(df)
mean(df$score)  #> NA: 평균 모름(계산 못함.)
mean(df$score, na.rm = TRUE)  #> 16 / 4 = 4
# na.rm 파라미터: NA를 제거하고 계산할지(TRUE) 말지(FALSE)를 결정


# NA를 다른 값으로 대체
# 1) 기본값(0)
# 2) NA 제외한 평균
# 3) 가장 많이 등장하는 값(최빈값)
# 4) NA 제외한 중앙값

# df$score 변수 중 NA를 평균으로 대체
# (힌트) ifelse(), is.na(), mean()
df$score <- ifelse(is.na(df$score), 
                   mean(df$score, na.rm = TRUE),
                   df$score)
df
