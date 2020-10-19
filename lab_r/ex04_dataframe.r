# Global Environment에 생성된 변수 객체들을 모두 삭제.
rm(list = ls())

# MS 엑셀 파일(xls, xlsx)의 내용을 읽어서 데이터프레임을 생성.
# 엑셀 파일을 읽고 쓰기 위한 패키지가 필요.
install.packages('readxl')

# 패키지를 사용할 수 있도록, 패키지를 메모리에 로드.
library(readxl)

# 메모리에 로드된 패키지 목록을 확인.
search()

exam_df <- read_excel(path = 'data/excel_exam.xlsx')

# 패키지이름::함수이름
# readxl::read_excel() 함수를 사용해서,
# excel_exam_sheet.xlsx 파일의 내용을 읽고 데이터 프레임을 생성
# (주의) 표가 3번째 sheet에 있음.
exam_df2 <- read_xlsx(path = 'data/excel_exam_sheet.xlsx',
                      sheet = 3)
exam_df2  # DF을 콘솔에 출력.

# tidyverse 패키지를 설치
install.packages('tidyverse')

# tidyverse 패키지를 메모리에 로드.
library(tidyverse)
search()

# excel_exam_novar.xlsx 파일을 읽어서 데이터 프레임을 생성.
# 8 observations(행, row)과 5 variables(열, column)이 있어야 함!
# (힌트) 엑셀 파일에는 컬럼 이름이 없음.
# 데이터 프레임의 컬럼 이름을 rename() 함수를 이용해서 변경.

exam_df3 <- read_xlsx(path = 'data/excel_exam_novar.xlsx')
# 엑셀 파일에서 1번째 행부터 데이터가 나옴. (컬럼 이름이 없음.)
# read_excel/xls/xlsx() 함수들은 1번째 행을 컬럼 이름이라고 생각.
# 따라서, read_excel() 함수를 호출할 때 1번째 행이 
# 컬럼 이름이 아니라고 설정을 해줘야 함!

exam_df3 <- read_xlsx(path = 'data/excel_exam_novar.xlsx',
                      col_names = FALSE)

# dplyr::rename() 함수 사용법
# rename(데이터 프레임 이름, 새로운 컬럼 이름 = 기존 컬럼 이름, ...)
exam_df3 <- rename(exam_df3,
                   id = ...1,
                   class = ...2,
                   math = ...3,
                   english = ...4,
                   science = ...5)

exam_df3

# 함수(function): 기능 수행, 계산 수행.
# 패키지(package): 함수들의 모음(꾸러미).
# 도움말 페이지: function_name {pacakge_name}
# 함수 호출: package_name::function_name()
# 함수를 호출할 때 패키지 이름을 생략할 수 있는 경우는,
# 그 패키지가 메모리에 로드되어 있을 때. (search()로 검색될 때.)

search()

# R에서 사용하는 데이터 파일 타입: RData
# (csv 텍스트 파일에 비해) 저장 용량이 작고, (읽기/쓰기) 속도 빠름.
# RData 타입의 파일로 저장: base::save()
# RData 타입의 파일을 읽어서 메모리에 로드: base::load()

# 데이터 프레임 1개를 저장/로드
save(exam_df, file = 'exam.rda')  # 파일 확장자: rda, rdata
rm(exam_df)  # 데이터 프레임 exam_df를 삭제
load(file = 'exam.rda')

# Global Environment에 생성된 모든 변수 객체들을 저장/로드.
ls()
save(list = ls(), file = 'exam_all.rdata')
rm(list = ls())  # Global Environment의 모든 객체 삭제.
load(file = 'exam_all.rdata')
