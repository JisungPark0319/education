# 지도 위에 데이터 표현하기.

library(tidyverse)

# 지도 데이터를 가지고 있는 패키지 설치
install.packages('maps')

# ggplot2::coord_map() 함수를 사용할 때 필요한 패키지.
install.packages('mapproj')

# ggplot2::map_data(map) 함수는 
# maps 패키지가 가지고 있는 지도 데이터(map)를 
# 데이터 프레임으로 변환해 주는 함수.
usa <- map_data(map = 'usa')
head(usa)
tail(usa)

# longitude(경도): 영국 그리니치 천문대를 기준으로 동/서 방향 좌표.
#   동쪽으로 변할 때 +, 서쪽으로 변할 때는 -
# latitude(위도): 적도를 기준으로 남(-)/북(+) 방향 좌표.
# group: 함께 연결할 위도/경도 점들의 그룹(나라, 주, 도시, ...)
# order: 위도/경도 점들을 연결하는 순서
# region: 지역 이름

ggplot(data = usa,
       mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = 'white', color = 'black') +
  coord_quickmap()

ggplot(data = usa,
       mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = 'white', color = 'black') +
  coord_map(projection = 'polyconic')

# state: 미국 주 정보가 포함된 지도 데이터
usa_state <- map_data(map = 'state')
head(usa_state)
tail(usa_state)

ggplot(data = usa_state,
       mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(mapping = aes(fill = region), color = 'black') +
  coord_quickmap()


# maps 패키지의 세계지도(world) 데이터 중에서 몇 개 지역 선택
asia_map <- map_data(map = 'world',
                     region = c('South Korea', 'North Korea',
                                'China', 'Japan', 'India'))
head(asia_map)
tail(asia_map)

ggplot(data = asia_map,
       mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = 'white', color = 'black') +
  coord_map('polyconic')

# state 지도 데이터를 데이터 프레임으로 변환한 usa_state 객체
# datasets::USArrests 데이터 프레임
head(USArrests)
tail(USArrests)
str(USArrests)
# USArrests 데이터 프레임에서 주(state) 이름들은 컬럼이 아니고,
# 인덱스(행 이름)임!
# 지도 데이터 프레임과 join을 하려면 주 이름들이 컬럼이어야 함!

us_arrests <- rownames_to_column(USArrests, var = 'state')
head(us_arrests)
tail(us_arrests)
str(us_arrests)

head(usa_state)

# us_arrests의 state 변수는 첫글짜가 대문자.
# usa_state의 region 변수는 모든 글짜가 소문자.
# -> us_arrests의 state 변수를 모두 소문자로 변환.
us_arrests$state <- tolower(us_arrests$state)
head(us_arrests)

us_arrests$state
dplyr::distinct(usa_state, region)

# usa_state와 us_arrests를 left_join
state_arrests <- left_join(usa_state, us_arrests,
                           by = c('region' = 'state'))
head(state_arrests)
tail(state_arrests)

ggplot(data = state_arrests,
       mapping = aes(x = long, y = lat, group = group, 
                     fill = Murder)) +
  geom_polygon(color = 'black') +
  coord_quickmap() +
  scale_fill_continuous(low = 'white', high = 'darkred')


# 단계 구분도(choropleth plot)
# 지도 위에 통계 값들을 색깔 단계로 구분해서 표현한 그래프.
# 인구, 질병, 범죄 통계, ...

install.packages('ggiraphExtra')
library(ggiraphExtra)
search()

# 지도 데이터 프레임: usa_state
# 범죄 통계 데이터 프레임: us_arrests

ggChoropleth(data = us_arrests,
             map = usa_state,
             mapping = aes(fill = Murder, map_id = state))
# ggChoroplet() 함수의 arguements:
# data = 통계 데이터 프레임
#   지도 데이터의 region과 join할 수 있는 컬럼이 있어야 함.
# map = 지도 데이터 프레임
# mapping = aes(변수들에 따라서 설정하는 값들.)
#   map_id = 지도 데이터 프레임의 region과 일치하는
#            통계 데이터 프레임의 변수(컬럼) 이름
#   fill = 지도의 각 group을 채우는 색깔

