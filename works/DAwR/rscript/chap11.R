## dplyr

# 데이터프레임을 변형하는 데 필요한 함수를 다수 포함. %>%(파이프 연산자)를 지원해서 가독성 높은 코드를 쉽게 작성.


# === 파이프 연산자 ===

# table(벡터) <- 문자형, 범주형, 정수형 벡터의 원소별 '빈도수' 반환

# prop.table(table(벡터)) <- 벡터 원소별 빈도수를 '비율'로 반환

table(iris$Species)
# setosa versicolor  virginica 
#     50         50         50

prop.table(x = table(iris$Species))
#    setosa versicolor  virginica 
# 0.3333333  0.3333333  0.3333333

library(tidyverse)
# ── Attaching core tidyverse packages ──────────────────── tidyverse 2.0.0 ──
# ✔ dplyr     1.1.2     ✔ readr     2.1.4
# ✔ forcats   1.0.0     ✔ stringr   1.5.0
# ✔ ggplot2   3.4.2     ✔ tibble    3.2.1
# ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
# ✔ purrr     1.0.1     
# ── Conflicts ────────────────────────────────────── tidyverse_conflicts() ──
# ✖ dplyr::filter() masks stats::filter()
# ✖ dplyr::lag()    masks stats::lag()
# ℹ Use the conflicted package to force all conflicts to become errors

iris$Species %>% table() %>% prop.table() # shift + ctrl + m
#    setosa versicolor  virginica 
# 0.3333333  0.3333333  0.3333333


# === dplyr 사용 예제 ===

# df에서 컬럼을 선택하거나 제거
# 행번호로 행을 잘라내거나, 조건에 맞는 행 걸러내기
# 그룹 설정, 숫자 컬럼을 집계함수로 요약
# 기존 컬럼 변형, 새로운 컬럼 생성
# df 정렬 오름차순 혹은 내림차순

library(magrittr)
library(dplyr)

iris %>% # 150행 5열
    select(Sepal.Length, Species) %>% # 열 길이 2인 df 반환
    filter(Sepal.Length >= 5.2) %>% # Sepal.length가 5.2 이상인 109행 df 반환
    group_by(Species) %>% # 문자형 또는 범주형 컬럼을 데이터 그룹으로 나눔
    summarise(Count = n()) %>% # Count 컬럼 생성, Species 컬럼 원소별 빈도수
    mutate(Pcnt = Count / sum(Count)) %>% # Count 컬럼을 전체 빈도수로 나눠서 Pcnt 컬럼 생성, mutate() df 컬럼 변경에 사용
    arrange(desc(x = Pcnt)) # 정렬
# A tibble: 3 × 3
#   Species    Count  Pcnt
#   <fct>      <int> <dbl>
# 1 virginica     49 0.450
# 2 versicolor    46 0.422
# 3 setosa        14 0.128

# 티블은 항상 티블로 반환


## 데이터셋 준비

library(tidyverse)
url <- 'https://bit.ly/APT_Price_Gangnam_2020_csv' # 텍스트 데이터를 포함하는 링크로 문자형 벡터 url 생성 
guess_encoding(file = url) # 인코딩 방식 확인
# A tibble: 1 × 2
#   encoding confidence
#   <chr>         <dbl>
# 1 UTF-8             1

price <- read.csv(file = url, fileEncoding = 'UTF-8') # url에 포함된 텍스트 데이터를 읽고 df price 생성
str(object = price) # price 구조 확인
# 'data.frame':	3828 obs. of  8 variables:
# $ 일련번호  : chr  "11680-3752" "11680-566" "11680-340" "11680-532" ...
# $ 아파트    : chr  "대치아이파크" "아카데미스위트" "우성캐릭터" "포스코더샵" ...
# $ 도로명주소: chr  "서울특별시 강남구 선릉로 222" "서울특별시 강남구 언주로30길 21" "서울특별시 강남구 언주로 118" "서울특별시 강남구 삼성로 417" ...
# $ 월        : int  1 1 1 1 1 1 1 1 1 1 ...
# $ 일        : int  2 2 2 2 3 3 3 3 3 3 ...
# $ 전용면적  : num  115 164.9 132.9 139.5 39.6 ...
# $ 층        : int  10 7 5 3 13 13 8 7 4 5 ...
# $ 거래금액  : int  300000 200000 170000 247000 87000 210000 20200 120000 77000 224500 ...


## 컬럼 선택 및 삭제

price %>% select(아파트, 거래금액) %>% head()
#           아파트 거래금액
# 1   대치아이파크   300000
# 2 아카데미스위트   200000
# 3     우성캐릭터   170000
# 4     포스코더샵   247000
# 5       까치마을    87000
# 6           미성   210000

price %>% select(8, 2) %>% tail()
#      거래금액              아파트
# 3823   215000 청담대림이-편한세상
# 3824   185000            한솔마을
# 3825   184000                한양
# 3826   249000                한양
# 3827   397000                현대
# 3828    90000        SK허브프리모

price %>% select(-일련번호) -> price # 파이프 연산자 때문에 코드의 가독성위해 -> 사용 <- 도 가능
str(object = price)
# 'data.frame':	3828 obs. of  7 variables:
# $ 아파트    : chr  "대치아이파크" "아카데미스위트" "우성캐릭터" "포스코더샵" ...
# $ 도로명주소: chr  "서울특별시 강남구 선릉로 222" "서울특별시 강남구 언주로30길 21" "서울특별시 강남구 언주로 118" "서울특별시 강남구 삼성로 417" ...
# $ 월        : int  1 1 1 1 1 1 1 1 1 1 ...
# $ 일        : int  2 2 2 2 3 3 3 3 3 3 ...
# $ 전용면적  : num  115 164.9 132.9 139.5 39.6 ...
# $ 층        : int  10 7 5 3 13 13 8 7 4 5 ...
# $ 거래금액  : int  300000 200000 170000 247000 87000 210000 20200 120000 77000 224500 ...


## 컬럼명 변경

price %>% 
    rename(아파트명 = 아파트, 아파트주소 = 도로명주소) %>% 
    head()
#         아파트명                      아파트주소 월 일 전용면적 층 거래금액
# 1   대치아이파크    서울특별시 강남구 선릉로 222  1  2   114.97 10   300000
# 2 아카데미스위트 서울특별시 강남구 언주로30길 21  1  2   164.87  7   200000
# 3     우성캐릭터    서울특별시 강남구 언주로 118  1  2   132.94  5   170000
# 4     포스코더샵    서울특별시 강남구 삼성로 417  1  2   139.54  3   247000
# 5       까치마을 서울특별시 강남구 광평로19길 10  1  3    39.60 13    87000
# 6           미성  서울특별시 강남구 압구정로 113  1  3    74.40 13   210000

price %>% head()
#           아파트                      도로명주소 월 일 전용면적 층 거래금액
# 1   대치아이파크    서울특별시 강남구 선릉로 222  1  2   114.97 10   300000
# 2 아카데미스위트 서울특별시 강남구 언주로30길 21  1  2   164.87  7   200000
# 3     우성캐릭터    서울특별시 강남구 언주로 118  1  2   132.94  5   170000
# 4     포스코더샵    서울특별시 강남구 삼성로 417  1  2   139.54  3   247000
# 5       까치마을 서울특별시 강남구 광평로19길 10  1  3    39.60 13    87000
# 6           미성  서울특별시 강남구 압구정로 113  1  3    74.40 13   210000 # price에 할당 안함


## 필터링

price %>% filter(거래금액 >= 600000)
#         아파트                        도로명주소 월 일 전용면적 층 거래금액
# 1         현대    서울특별시 강남구 압구정로 201  8 14   245.20  5   650000
# 2         현대    서울특별시 강남구 압구정로 201 10 27   245.20  9   670000
# 3 효성빌라청담 서울특별시 강남구 압구정로71길 28 11 26   226.74  5   620000

price %>% filter(거래금액 < 600000, 층 >= 60)
#       아파트                      도로명주소 월 일 전용면적 층 거래금액
# 1 타워팰리스 서울특별시 강남구 언주로30길 26  5 11  185.622 63   350000
# 2 타워팰리스 서울특별시 강남구 언주로30길 26  7 25  235.740 67   542500
# 3 타워팰리스 서울특별시 강남구 언주로30길 26 10 27  185.622 66   380000


## 인덱스로 행 선택 및 삭제

price %>% slice(1:5)
#           아파트                      도로명주소 월 일 전용면적 층 거래금액
# 1   대치아이파크    서울특별시 강남구 선릉로 222  1  2   114.97 10   300000
# 2 아카데미스위트 서울특별시 강남구 언주로30길 21  1  2   164.87  7   200000
# 3     우성캐릭터    서울특별시 강남구 언주로 118  1  2   132.94  5   170000
# 4     포스코더샵    서울특별시 강남구 삼성로 417  1  2   139.54  3   247000
# 5       까치마을 서울특별시 강남구 광평로19길 10  1  3    39.60 13    87000

price %>% slice(seq(from = 1, to = 10, by = 2))
#         아파트                      도로명주소 월 일 전용면적 층 거래금액
# 1 대치아이파크    서울특별시 강남구 선릉로 222  1  2   114.97 10   300000
# 2   우성캐릭터    서울특별시 강남구 언주로 118  1  2   132.94  5   170000
# 3     까치마을 서울특별시 강남구 광평로19길 10  1  3    39.60 13    87000
# 4 우림루미아트  서울특별시 강남구 언주로90길 6  1  3    24.00  8    20200
# 5   현대하이츠 서울특별시 강남구 역삼로34길 12  1  3    99.22  4    77000


## 컬럼의 자료형 변환

price %>% 
    mutate(아파트 = as.factor(x = 아파트)) %>% 
    str()
# 'data.frame':	3828 obs. of  7 variables:
# $ 아파트    : Factor w/ 353 levels "e-편한세상","LG선릉에클라트",..: 74 201 243 301 43 130 237 304 343 347 ...
# $ 도로명주소: chr  "서울특별시 강남구 선릉로 222" "서울특별시 강남구 언주로30길 21" "서울특별시 강남구 언주로 118" "서울특별시 강남구 삼성로 417" ...
# $ 월        : int  1 1 1 1 1 1 1 1 1 1 ...
# $ 일        : int  2 2 2 2 3 3 3 3 3 3 ...
# $ 전용면적  : num  115 164.9 132.9 139.5 39.6 ...
# $ 층        : int  10 7 5 3 13 13 8 7 4 5 ...
# $ 거래금액  : int  300000 200000 170000 247000 87000 210000 20200 120000 77000 224500 ...


## 기존 컬럼 변경 및 새로운 컬럼 생성

# === 새로운 컬럼 생성 ===

price %>% mutate(단위금액 = 거래금액 / 전용면적) -> price # 
head(x = price) # 
#           아파트                      도로명주소 월 일 전용면적 층 거래금액
# 1   대치아이파크    서울특별시 강남구 선릉로 222  1  2   114.97 10   300000
# 2 아카데미스위트 서울특별시 강남구 언주로30길 21  1  2   164.87  7   200000
# 3     우성캐릭터    서울특별시 강남구 언주로 118  1  2   132.94  5   170000
# 4     포스코더샵    서울특별시 강남구 삼성로 417  1  2   139.54  3   247000
# 5       까치마을 서울특별시 강남구 광평로19길 10  1  3    39.60 13    87000
# 6           미성  서울특별시 강남구 압구정로 113  1  3    74.40 13   210000
#   단위금액
# 1 2609.376
# 2 1213.077
# 3 1278.772
# 4 1770.102
# 5 2196.970
# 6 2822.581


# === 기존 숫자형 컬럼 변경 ===
price %>% 
    mutate(거래금액 = 거래금액 / 10000, # 만원 -> 억원
           단위금액 = round(x = 단위금액 * 3.3, digits = 0)) -> price
head(x = price)
#           아파트                      도로명주소 월 일 전용면적 층 거래금액
# 1   대치아이파크    서울특별시 강남구 선릉로 222  1  2   114.97 10     30.0
# 2 아카데미스위트 서울특별시 강남구 언주로30길 21  1  2   164.87  7     20.0
# 3     우성캐릭터    서울특별시 강남구 언주로 118  1  2   132.94  5     17.0
# 4     포스코더샵    서울특별시 강남구 삼성로 417  1  2   139.54  3     24.7
# 5       까치마을 서울특별시 강남구 광평로19길 10  1  3    39.60 13      8.7
# 6           미성  서울특별시 강남구 압구정로 113  1  3    74.40 13     21.0
# 단위금액
# 1     8611
# 2     4003
# 3     4220
# 4     5841
# 5     7250
# 6     9315


# === 숫자형 컬럼으로 새로운 문자형 컬럼 생성 ===

price %>% 
    mutate(금액부분 = ifelse(test = 단위금액 >= 10000,
                         yes = '1억 이상',
                         no = '1억 미만')) -> price
head(x = price)
#           아파트                      도로명주소 월 일 전용면적 층 거래금액
# 1   대치아이파크    서울특별시 강남구 선릉로 222  1  2   114.97 10     30.0
# 2 아카데미스위트 서울특별시 강남구 언주로30길 21  1  2   164.87  7     20.0
# 3     우성캐릭터    서울특별시 강남구 언주로 118  1  2   132.94  5     17.0
# 4     포스코더샵    서울특별시 강남구 삼성로 417  1  2   139.54  3     24.7
# 5       까치마을 서울특별시 강남구 광평로19길 10  1  3    39.60 13      8.7
# 6           미성  서울특별시 강남구 압구정로 113  1  3    74.40 13     21.0
# 단위금액 금액부분
# 1     8611 1억 미만
# 2     4003 1억 미만
# 3     4220 1억 미만
# 4     5841 1억 미만
# 5     7250 1억 미만
# 6     9315 1억 미만


# === 숫자형 컬럼의 구간화 : ifelse() ===

price %>%
    mutate(금액구분2 = ifelse(test = 단위금액 >= 10000,
                          yes = '1억 이상',
                          no = ifelse(test = 단위금액 >= 5000,
                                      yes = '5천 이상',
                                      no = '5천 미만'))) %>% 
    head()
# #           아파트                      도로명주소 월 일 전용면적 층 거래금액
# # 1   대치아이파크    서울특별시 강남구 선릉로 222  1  2   114.97 10     30.0
# # 2 아카데미스위트 서울특별시 강남구 언주로30길 21  1  2   164.87  7     20.0
# # 3     우성캐릭터    서울특별시 강남구 언주로 118  1  2   132.94  5     17.0
# # 4     포스코더샵    서울특별시 강남구 삼성로 417  1  2   139.54  3     24.7
# # 5       까치마을 서울특별시 강남구 광평로19길 10  1  3    39.60 13      8.7
# # 6           미성  서울특별시 강남구 압구정로 113  1  3    74.40 13     21.0
# # 단위금액 금액부분 금액구분2
# # 1     8611 1억 미만  5천 이상
# # 2     4003 1억 미만  5천 미만
# # 3     4220 1억 미만  5천 미만
# # 4     5841 1억 미만  5천 이상
# # 5     7250 1억 미만  5천 이상
# # 6     9315 1억 미만  5천 이상
# 
# 
# ## === 숫자형 컬럼 구간화2 : case_when() ===
# 
# library(tidyverse)
# 
# price %>%
#     mutate(금액구분2 = case_when(단위금액 >= 10000 ~ '1억 이상',
#                              단위금액 >= 5000 ~ '5천 이상',
#                              단위금액 >= 0 ~ '5천 미만')) %>% 
#     head()
#           아파트                      도로명주소 월 일 전용면적 층 거래금액
# 1   대치아이파크    서울특별시 강남구 선릉로 222  1  2   114.97 10     30.0
# 2 아카데미스위트 서울특별시 강남구 언주로30길 21  1  2   164.87  7     20.0
# 3     우성캐릭터    서울특별시 강남구 언주로 118  1  2   132.94  5     17.0
# 4     포스코더샵    서울특별시 강남구 삼성로 417  1  2   139.54  3     24.7
# 5       까치마을 서울특별시 강남구 광평로19길 10  1  3    39.60 13      8.7
# 6           미성  서울특별시 강남구 압구정로 113  1  3    74.40 13     21.0
#   단위금액 금액부분 금액구분2
# 1     8611 1억 미만  5천 이상
# 2     4003 1억 미만  5천 미만
# 3     4220 1억 미만  5천 미만
# 4     5841 1억 미만  5천 이상
# 5     7250 1억 미만  5천 이상
# 6     9315 1억 미만  5천 이상


## 집계 함수로 데이터 요약

price %>% 
    group_by(월) %>% 
    summarise(거래건수 = n(), 평균금액 = mean(x = 거래금액))
# A tibble: 12 × 3
#       월 거래건수 평균금액
#    <int>    <int>    <dbl>
#  1     1      131     15.5
#  2     2      242     16.2
#  3     3      147     16.7
#  4     4      158     19.4
#  5     5      345     17.1
#  6     6      824     18.2
#  7     7      382     17.1
#  8     8      240     19.9
#  9     9      191     18.4
# 10    10      225     17.7
# 11    11      440     18.4
# 12    12      503     19.9


## 데이터프레임 형태 변환
# === Long type df ===

price %>% 
    group_by(아파트, 금액부분) %>%  # 아파트와 금액부분 컬럼으로 그룹 지정, 빈도수 계산해서 매매건수 컬럼으로 생성한 결과를 elong에 할당
    summarise(매매건수 = n()) -> elong # == summarize()
# `summarise()` has grouped output by '아파트'. You can override using the
# `.groups` argument. # 2개 이상의 컬럼으로 그룹을 지정해서 출력되는 안내문

head(x = elong)
# A tibble: 6 × 3
# Groups:   아파트 [5]
#     아파트         금액부분 매매건수
#     <chr>          <chr>       <int>
# 1 LG선릉에클라트 1억 미만       30
# 2 RudenHouse     1억 미만        3
# 3 SK허브프리모   1억 미만       10
# 4 SM드림빌       1억 미만        2
# 5 e-편한세상     1억 미만       38
# 6 e-편한세상     1억 이상        9 
# 같은 아파트에 대해 금액구분 컬럼의 원소인 '1억 미만'과 '1억 이상'이 세로로 생성됨 == long type


# === Long type과 Wide type 상호 변환 ===

# spread : long type -> wide type
# spread(data = long type df,
#        key = wide type의 컬럼명으로 펼칠 long type의 컬럼명,
#        value = wide type의 원소로 채울 long type의 컬럼명,
#        fill = wide type으로 변환할 때, 빈 칸에 채울 값(기본값은 NA))

# gather : wide type -> long type
# gather(data = wide type df,
#        key = long type의 컬럼명으로 펼칠 long type의 컬럼명,
#        value = wide type의 원소로 채울 long type의 컬럼명,
#        long type의 key와 value로 채울 wide type의 컬럼명 또는 인덱스,
#        (콜론 및 마이너스 사용 가능)
#        na.rm = wide type으로 변환할 때, NA 삭제 여부)

elong %>% 
    spread(key = 금액부분, value = 매매건수, fill = 0) -> widen # elong에서 금액부분의 원소를 컬럼명으로 펼치고, 매매건수를 원소로 채운 결과를 widen에 할당

head(x = widen)
# A tibble: 6 × 3
# Groups:   아파트 [6]
#     아파트         `1억 미만` `1억 이상` # 숫자로 시작하는 컬럼명이 백틱으로 감싸져 있음.
#     <chr>               <dbl>      <dbl>
# 1 e-편한세상             38          9 # 같은 아파트에 대해 '1억 미만'과 '1억 이상' 컬럼이 가로로 생성 == wide type
# 2 LG선릉에클라트         30          0
# 3 RudenHouse              3          0
# 4 SK허브프리모           10          0
# 5 SM드림빌                2          0
# 6 가람                   10          0

widen %>%
    gather(key = 금액타입, value = 거래건수, 2:3, na.rm = FALSE) %>% # widen에서 key와 value로 사용될 컬럼명으로 '금액타입'과 '거래건수'를 각각 설정하고, wide type의 2~3번째 컬럼명으로 long type의 key와 value를 채움.
    head()
# # A tibble: 6 × 3
# # Groups:   아파트 [6]
#     아파트         금액타입 거래건수 # long type으로 변환된 df를 출력. 컬럼명이 '금액타입'과 '거래건수'로 출력.
#     <chr>          <chr>       <dbl>
# 1 e-편한세상     1억 미만       38 # gather() 함수는 key에 지정된 원소를 오름차수능로 정렬하므로 'e-편한세상'에는 '1억 미만'에 대한 빈도수만 확인됨.
# 2 LG선릉에클라트 1억 미만       30 
# 3 RudenHouse     1억 미만        3
# 4 SK허브프리모   1억 미만       10
# 5 SM드림빌       1억 미만        2
# 6 가람           1억 미만       10


## 오름차순 및 내림차순 정렬
# === 정렬하기 ===

# df %>% arrange(desc(x = 컬럼명), 컬럼명, ...)

df <- price %>% select(아파트, 전용면적, 층, 거래금액, 단위금액) # price에서 일부 컬럼만 선택하고 df에 할당
df %>% arrange(desc(x = 거래금액)) %>% head() # df를 거래금액 컬럼 기준으로 내림차순 정렬
#             아파트 전용면적 층 거래금액 단위금액
# 1             현대  245.200  9    67.00     9017
# 2             현대  245.200  5    65.00     8748
# 3     효성빌라청담  226.740  5    62.00     9024
# 4         아이파크  195.388 23    57.00     9627
# 5 상지리츠빌카일룸  210.500  4    56.54     8864
# 6   청담어퍼하우스  200.380  5    55.80     9190

# 컬럼명을 2개 이상 지정하면 결과값을 얻을 수 없음.
df %>% arrange(desc(x = 층, 거래금액)) %>% head()
# Error in `arrange()`:
#     ! `desc()` must be called with exactly one argument.
# Run `rlang::last_trace()` to see where the error occurred.

df %>% arrange(desc(x = 층), desc(x = 거래금액)) %>% head() # 각각 정렬해야함.
#       아파트 전용면적 층 거래금액 단위금액
# 1 타워팰리스  235.740 67    54.25     7594
# 2 타워팰리스  185.622 66    38.00     6756
# 3 타워팰리스  185.622 63    35.00     6222
# 4 타워팰리스  222.480 58    38.20     5666
# 5 타워팰리스  164.970 58    29.00     5801
# 6 타워팰리스   78.990 58    13.80     5765 # 같은 층에 대해 거래금액 컬럼이 내림차순으로 정렬

df %>% arrange(desc(x = 층), 거래금액) %>% head()
#       아파트 전용면적 층 거래금액 단위금액
# 1 타워팰리스  235.740 67    54.25     7594
# 2 타워팰리스  185.622 66    38.00     6756
# 3 타워팰리스  185.622 63    35.00     6222
# 4 타워팰리스   78.990 58    13.80     5765 # 같은 층에 대해 거래금액 컬럼이 오름차순 정렬됨.
# 5 타워팰리스  164.970 58    29.00     5801
# 6 타워팰리스  222.480 58    38.20     5666


# === RDS 파일로 저장 ===

getwd()
# [1] "C:/Users/DA/GitHub/R/works/rscript/DAwR"
setwd(dir = './data')
saveRDS(object = price, file = 'APT_Price_Gangnam_2020.RDS')