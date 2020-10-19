# scalar(스칼라): 한개의 값이 저장된 변수.
# vector(벡터): 여러개의 값이 저장된 변수.

# scalar의 예
a <- 100  # 숫자 한개를 저장하는 변수.
b <- '오쌤'  # 문자열 한개를 저장하는 변수.
b
# R에서는 문자열을 작은따옴표('') 또는 큰따옴표("")로 묶음.

c <- TRUE  # 논릿값(boolean: TRUE, FALSE) 한개를 저장하는 변수.
c

d <- 'TRUE'  # 문자열을 저장.
d

is_big <- (3 > 5)
is_big


# vector의 예
# c(): combine
numbers <- c(1, 2, 10, 20, 5, 9)
numbers  # numbers 변수에 저장된 모든 값들을 출력.
numbers[6]  # 벡터[인덱스]: 값 1개를 출력.

student_names <- c('Aaa', 'Bbb', 'Ccc')
student_names
student_names[1]

is_bigs <- c(100 > 10, 1 > 10, 0 > -1)
is_bigs
is_bigs[1]

# vector를 생성하는 방법(함수):
# c() 함수

# 범위 연산자(start:end)를 사용
numbers <- 1:10
numbers

# seq(from, to, by) 함수 사용 - 수열 생성
numbers <- seq(1, 20)
numbers

odds <- seq(1, 20, 2)
odds

evens <- seq(2, 20, 2)
evens

countdown <- seq(10, 1, -1)
countdown

# 함수(function): 기능, 연산.
# argument: 함수를 호출할 때 함수에게 전달하는 값.
# 필수 argument: 함수를 호출할 때 반드시 전달해야 하는 argument.
# 옵션 argument: 기본값이 설정되어 있어서, 함수를 호출할 때
# 생략해도 되는 argument.
# parameter: argument를 저장하기 위한 변수
# 함수를 호출할 때는 parameter 이름을 명시해도 되고, 생략해도 됨.
# 만약 parameter 이름을 생략할 때는 반드시 정해진 순서대로 
# argument를 함수에게 전달해야 함!

# 파라미터 이름을 생략하고 함수 호출.
numbers <- seq(1, 10, 2)  

# 파라미터 이름을 명시하고 함수 호출.
numbers <- seq(from = 1, to = 10, by = 2)  
numbers

# 파라미터 이름을 명시할 때는, argument 순서를 지키지 않아도 괜찮음.
numbers <- seq(by = -1, from = 10, to = 1)
numbers

# vector 저장된 원소를 찾는 방법 - 인덱스
student_names <- c('Abc', '오쌤', '홍길동', 'ITWILL')
student_names[2]  # vector[index]
student_names[2:4]  # 인덱스 2 ~ 인덱스 4 까지
student_names[c(1, 4)]  # c(1, 4) ==> 1, 4

# vector student_names에서 'ITWILL'을 '아이티윌' 변경
student_names[4] <- '아이티윌'
student_names

# vector와 scalar의 사칙연산
numbers <- c(1, 10, 100)
numbers
numbers + 1

# vector와 vector의 사칙연산
numbers1 = c(1, 5, 10)
numbers2 = c(2, 7, 9)
numbers1 - numbers2
