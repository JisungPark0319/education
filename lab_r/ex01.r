# 주석(comment): 프로그램에 설명을 작성.

x <- 1  # 변수 x에 값 1을 저장.
# Ctrl+Enter: 현재 커서가 있는 위치의 한 문장을 실행.

y <- 2  # 변수 y에 값 2를 저장.

x  # 변수 x의 값을 출력.
y

# x + y의 값을 출력.
x + y
# 산술연산(+, -, *, /)
x - y
x * y
x / y

# 계산 결과를 다른 변수에 저장.
plus <- x + y
plus

x - y -> minus  # (x - y)의 결과를 minus 변수에 저장.

# Global Environment(전역 환경)에 생성된 변수들의 이름을 확인.
ls()  # list

# Global Environment에 생성된 변수 객체를 삭제.
rm(minus)  # remove

# Global Environment에 생성된 모든 변수 객체들을 삭제.
rm(list = ls())
