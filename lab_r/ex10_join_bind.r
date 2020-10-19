# 데이터 프레임 합치기:
# join: 컬럼 이어 붙이기.
# bind: row(행) 이어 붙이기. column(열) 이어 붙이기.

library(tidyverse)
search()

# join: inner_join, left_join, right_join, full_join
emp <- data.frame(empno = c(100, 101, 102),
                  ename = c('Scott', 'King', 'Allen'),
                  deptno = c(10, 20, 30))
emp

dept <- data.frame(deptno = c(10, 20, 40),
                   dname = c('IT', 'HR', 'Sales'))
dept

# inner join: 두 데이터 프레임 모두 공통으로 가지고 있는 데이터.
inner_join(emp, dept, by = 'deptno')
inner_join(emp, dept)
# 두 데이터에서 공통 컬럼 이름이 같은 경우 by를 생략할 수 있음.

# left (outer) join:
left_join(emp, dept)
# NA: Not Available(값이 없음.)

# right (outer) join:
right_join(emp, dept)

# full (outer) join:
full_join(emp, dept)

emp %>% full_join(dept)


# bind_rows()
emp2 <- data.frame(empno = c(200, 201),
                   ename = c('Jane', 'Mary'),
                   deptno = c(10, 20))
emp2

bind_rows(emp, emp2)

df1 <- data.frame(id = c(1, 2), name = c('A', 'B'))
df1
df2 <- data.frame(id = c(3, 4), age = c(10, 20))
df2

bind_rows(df1, df2)


# join 연습
# ggplot2::mpg 데이터 프레임에는 fl 컬럼(연료 종류)이 있음.
fuel <- data.frame(fl = c('c', 'd', 'e', 'p', 'r'),
                   price = c(2.35, 2.38, 2.11, 2.76, 2.22))
fuel

# ggplot2::mpg 데이터 프레임 복사
mpg <- as.data.frame(ggplot2::mpg)

# mpg 데이터 프레임과 fuel 데이터 프레임 inner join
# model, fl, price 선택 head, tail
mpg %>% inner_join(fuel) %>% 
  select(model, fl, price) %>% 
  tail()

table(mpg$fl)
