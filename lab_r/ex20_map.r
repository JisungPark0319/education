# install.packages('패키지이름'):
#   R 패키지 공식 저장소(repository)에서 패키지를 다운받고 설치.
#   https://cran.r-project.org/
#   Central R Archive Network
# R 저장소에 등록되지 않은 패키지들도 있음.
# 개인/단체의 github에만 저장되어 있는 패키지를 설치할 필요가 있을 수도 있음.
# devtools 패키지: github에 저장된 패키지를 설치해주는 패키지.

install.packages('devtools')

devtools::install_github('cardiomoon/kormaps2014')

# 필요한 패키지들을 메모리에 로드.
library(tidyverse)
library(ggiraphExtra)
library(kormaps2014)

search()

# maps 패키지의 세계 지도 데이터에서 한국만 선택 그래프.
korea_map <- map_data(map = 'world',
                      region = c('South Korea', 'North Korea'))
head(korea_map)
tail(korea_map)
distinct(korea_map, region)
distinct(korea_map, subregion)

ggplot(data = korea_map,
       mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = 'white', color = 'black') +
  coord_quickmap()

# kormaps2014 지도 데이터 이용
str(kormap1)
head(kormap1)
tail(kormap1)

ggplot(data = kormap1,
       mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = 'white', color = 'black') +
  coord_quickmap()

str(kormap2)
head(kormap2)
tail(kormap2)

# 서울시의 구 이름들을 filtering해서 서울시 지도를 그려보세요.
seoul_gu = c('강남구', '강동구', '강북구', '강서구', '관악구',
             '광진구', '구로구', '금천구', '노원구', '도봉구',
             '동대문구', '동작구', '마포구', '서대문구', '서초구',
             '성동구', '성북구', '송파구', '양천구', '영등포구',
             '용산구', '은평구', '종로구', '중구', '중랑구')

seoul_gu_map <- filter(kormap2, sigungu_nm %in% seoul_gu)
head(seoul_gu_map)
tail(seoul_gu_map)

ggplot(data = seoul_gu_map,
       mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = 'white', color = 'black') +
  coord_quickmap()

# 시군구 코드 11로 시작하면 서울.
seoul_gu_map <- filter(kormap2, str_starts(sigungu_cd, '11'))
head(seoul_gu_map)
tail(seoul_gu_map)

ggplot(data = seoul_gu_map,
       mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = 'white', color = 'black') +
  coord_quickmap()

# 인구 통계 데이터
str(korpop1)  #> Error in nchar
# 데이터 프레임의 컬럼(변수) 이름들이 한글이 포함되어 있어서,
# 문자열 인코딩/디코딩에서 오류가 발생
str(changeCode(korpop1))

head(korpop1)

# kormap1, korpop1 데이터 프레임을 사용해서, 시도별 인구 그래프.
str(kormap1)
str(changeCode(korpop1))
# kormap1, korpop1은 공통된 컬럼 code를 가지고 있음.

# korpop1 데이터 프레임에서
# 1) 변수 이름을 한글 -> 영어 변경
#    행정구역별_읍면동 -> sido_name, 총인구_명 -> pop
# 2) code, sido_name, pop 컬럼 선택
korpop1 <- kormaps2014::korpop1 %>% 
  rename(sido_name = 행정구역별_읍면동, pop = 총인구_명) %>% 
  select(code, sido_name, pop)
head(korpop1)
tail(korpop1)

# kormap1과 korpop1을 join
kor_pop <- left_join(kormap1, korpop1, by = 'code')
head(kor_pop)
tail(kor_pop)

# kor_pop 데이터 프레임을 사용해서 인구를 지도 위에 표현.
ggplot(data = kor_pop,
       mapping = aes(x = long, y = lat, group = group, fill = pop)) +
  geom_polygon(color = 'black') +
  coord_quickmap() +
  scale_fill_continuous(low = 'white', high = 'darkorange')

ggChoropleth(data = korpop1,
             map = kormap1,
             mapping = aes(fill = pop, map_id = code),
             interactive = TRUE)


# korpop2, kormap2 데이터 프레임을 사용해서
# 서울의 구별 인구를 지도 위에 표현.

str(kormap2)
seoul_gu_map <- filter(kormap2, str_starts(code, '11'))

str(changeCode(korpop2))
seoul_gu_pop <- korpop2 %>% 
  filter(str_starts(code, '11')) %>% 
  rename(name = 행정구역별_읍면동, pop = 총인구_명) %>% 
  select(code, name, pop)
head(seoul_gu_pop)
tail(seoul_gu_pop)

ggChoropleth(data = seoul_gu_pop,
             map = seoul_gu_map,
             mapping = aes(fill = pop, map_id = code),
             interactive = TRUE)

str(kormaps2014::tbc)


