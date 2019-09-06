#R의 dataType
a <- 10
b = '문자'
c = TRUE
d = 10>20
e = NULL
f = NA
g = NaN
h = Inf

v1 = 1:5
v2 = c(100, 200, 300)
v3 = seq(from=10, to=100, by=20)
v4 = seq(10, 100, 20) #=v3
v5 = seq(100, 10.5, -20)
v6 = sequence(10)
v7 = rep(c(10, 20), times=2)
v8 = rep(c(10, 20), each=2)

m1 = matrix(1:10, nrow = 2)
m2 = matrix(1:10, nrow = 2, ncol = 5)
m3 = matrix(1:10, nrow = 2, ncol = 5, byrow = T)
m1[2,5]

arr1 = array(1:10, dim = 10)
arr2 = array(1:10, dim = c(2,5))
arr3 = array(1:20, dim = c(2,5,2))
arr3[2,5,2]
arr4 = array(1:15, dim = c(2,5,2))

alist = list(10, "문자", v8, m1, arr4)
alist[1] = 20
alist[[3]] = c(1,2,3,4)

#############################################DataFrame
id = 1:5
age = c(13,20,11,35,49)
gender = c('m','m','f','f','m')
height = c(130,150,183,167,158)

df1 = data.frame(id, age, gender, height)
df2 = data.frame(id, age, gender, height, stringsAsFactors = FALSE)

str(df1) #데이터의 구조
str(df2)

plot(df1$gender) #factor
plot(df2$gender) #char은 지원x

df1$gender[1] = '변경불가'
df2$gender[1] = '변경가능'

ID = c(1,2,3)
NAME = c('Kim','Yang','Park')
AGE = c(23,25,29)
GENDER = c('M','F','M')
JOIN_DATE = c('2019/07/01','2013/04/11','2019/07/30')
df = data.frame(ID, NAME, AGE, GENDER, JOIN_DATE, 
                stringsAsFactors = F)
str(df)
df$GENDER = as.factor(df$GENDER) #gender만 factor(요인)으로 변경.
df$GENDER
df[4] #4번째 컬럼

df$GENDER[1] = 'M'

df[1] #1번째 컬럼
df[c(1,2)] #1, 2번째 컬럼
df[-c(1,2)] #1, 2번째를 제외한 나머지 컬럼

#row로 접근
df[1,] #1행의 모든 컬럼
df[,1] #모든 행의 첫컬럼
df[,] #모든 값
df[1,1] #값 한개

df1[1,3] = 'm'

nrow(df) #행의 개수
ncol(df) #열의 개수

colnames(df)
rownames(df)

paste('R', 1, '행')
paste('R', 1, '행', sep="") #공백제거
paste0('R', 1, '행')

#행의 이름 변경
rownames(df) = paste0('R',1:3)
df[1,] #순서이용
df['R1',] #이름이용

#차원을 알아보기
dim(df)
dimnames(df) #list형태

class(iris)
dim(iris)
dimnames(iris)
colnames(iris)
nrow(iris)
ncol(iris)
iris[1,]
iris[,ncol(iris)]
iris$Species

#attach()...detach(): 컬럼명만 가지고 접근 가능.
attach(iris)
Species
detach(iris)


#package
install.packages("ggplot2") #하드에 저장
library(ggplot2) #메모리에 저장
?ggplot2
search() #package목록 보기
searchpaths()
.libPaths()

getwd()
setwd('C:/R_Source')

#\t : tab
#\n : new line
#\\ : \

#절대경로
read.table(file='c:/R_Source/data/survey_blank.txt', header = T,
           sep = " ")

#상대경로
#.. 부모폴더, . 현재폴더
read.table(file='./data/survey_blank.txt', header = T, sep = " ")
read.table(file='../R_Source/data/survey_blank.txt', header = T,
           sep = " ")

read.table(file='./data/survey_comma.txt', header = T, sep = ",")
df = read.table(file='./data/survey_tab.txt', header = T, sep = "\t",
                stringsAsFactors = F)

str(df)
#빈 문자는 default로 NA
#na.strings : "0"을 NA로 대체한다.
df = read.table(file='./data/na_data.txt', header = T, sep = "\t",
                na.strings = '0')

df = read.csv(file='./data/csv_exam.csv', header = T)
df["합계"] = df$math + df$english + df$science
df["평균"] = df["합계"] %/% 3

df = read.csv(file='./data/인구주택총조사2015.csv', header = T)
str(df)

install.packages("readxl")
library(readxl)
df = read_xlsx(path = './data/인구주택총조사2015.xlsx',
               col_names = TRUE, sheet = 1) #sheet에 순서 또는 이름

df2 = df[c(1,2,3,4)]
save(df2, file = "myData2.RData")
load(file = "myData2.RData")
df2

#iris데이터를 이용, 10건, 컬럼 1,2,5만 data frame으로 저장하기.
iris
new_iris = iris[1:10, c(1, 2, 5)]
save(new_iris, file = "iris10.RData")
load(file = 'iris50.RData')

write.table(df, file = "./data/new_iris50.txt", sep = ',',
            quote = FALSE)
write.csv(df, file = "./data/new_iris50.csv", quote = FALSE,
          row.names = FALSE)

install.packages("openxlsx")
library(openxlsx)

write.xlsx(df, file = "./data/new_iris50.xlsx")

a=10
b='R Programming'
save.image(file = 'myWork.RData')
load(file = 'myWork.RData')

#R데이터의 목록
ls()
#R데이터의 삭제
rm(a)
rm(list=ls())

?diamonds
nrow(diamonds)
ncol(diamonds)
class(diamonds)
str(diamonds)
head(diamonds)
head(diamonds, n=3)
tail(diamonds, n=4)
View(diamonds)

#dataframe 유지
class(diamonds[,2]) #default = FALSE
class(diamonds[,2, drop = FALSE]) 
#본래타입 - dataframe 유지x
class(diamonds[,2, drop = TRUE])

diamonds[, 1:3]
diamonds[, c(1,4,5)]
diamonds[, seq(1,5,2)]

diamonds[,'cut']
diamonds[,c('cut', 'color')]
#컬럼의 이름이 "c"로 시작하는 컬럼들만 선택.
diamonds[,grep("^c", colnames(diamonds))]
#컬럼의 이름이 "t"로 끝나는 컬럼들만 선택.
diamonds[,grep("t$", colnames(diamonds))]

df2 = diamonds[diamonds$cut == "Premium",]
a = diamonds$cut == "Premium"
b = diamonds$price >= 15000
diamonds[a & b,]

install.packages("dplyr")
library(dplyr)
#pipe : %>% (ctrl + shift + m)
diamonds %>% filter(cut == "Premium" & price >= 15000) %>% select('cut','price')

str(diamonds)
#변수추가하기
diamonds$xyz.sum = diamonds$x + diamonds$y + diamonds$z
diamonds$xyz.sum2 = rowSums(diamonds[, c('x','y','z')])

diamonds$xyz.mean = (diamonds$x + diamonds$y + diamonds$z)/3
diamonds$xyz.mean2 = rowMeans(diamonds[, c('x','y','z')])

diamonds[diamonds$price>=18500,]

a = c(TRUE, FALSE, TRUE, FALSE, TRUE)
v1 = c(10,20,30,40,50)
v2 = c("a","b","c","d","e")
df = data.frame(v1, v2)
df[a,]
#데이터 수정
diamonds[diamonds$price >= 18500,]
diamonds[diamonds$price >= 18500, "price"] = 19000

diamonds[diamonds$cut == "Fair" & diamonds$price >= 18500, c("cut","price","x")]

diamonds[diamonds$cut == "Fair" & diamonds$price >= 18500, "x"] = NA

#데이터 삭제
df2 = diamonds[!(diamonds$cut == "Fair" & diamonds$price >= 18500),]
aa = df2[df2$cut == "Fair" & df2$price >= 18500,]
nrow(aa)

df3 = diamonds[1:10, 1:5]
df3[!df3$cut == 'Premium',]
df3[-c(2,4),]

df3$depth = NULL 
subset(df3, select=-color)
#데이터 정렬
df3[order(df3$color),]
df3[order(df3$color, df3$cut),]
#color로 먼저 sort -> 같은 color값에 대해서 cut으로 sort
df3[order(df3$color, df3$cut, decreasing = TRUE),] #내림차순

levels(df3$cut)
is.ordered(df3$cut)
