#복습#
#1. dataframe 만들기. 데이터 불러오기
num1 = factor(c(10,20,30,40,50)) #명목형
num2 = seq(100, 500, 100)
num3 = 1:5
char1 = c("월","화","수","목","금")
df = data.frame(num1,num2,num3,char1)

#2. 값 수정하기
df$char1 = paste0(df$char1, "요일")
df$num2 = df$num2 + 1
df = transform(df, num3=num3+2, num2=num2+3)

num1 = factor(c(10,20)) #명목형
num2 = seq(1,2)
num3 = 1:2
char1 = c("월","화")
df2 = data.frame(num1,num2,num3,char1)

#데이터프레임 합치기(row)-rbind
df3 = rbind(df, df2)
#col-cbind
char2 = c("김","박","이","정","임","최","강")
char3 = c("김2","박2","이2","정2","임2","최2","강2")
df4 = data.frame(char2, char3)

df5 = cbind(df3, df4)

char1 = c("월요일","화요일","수요일","목요일","금요일")
gender = c('m','f','m','m','f')
df6 = data.frame(char1, gender)

df7 = merge(df5, df6, key = "char1")
#3. 접근하기
typeof(df7$char1)
df7["char1"]
df7[1]
df[1,]
df[1,1]

#4.변형하기
#컬럼명 변경
names(df7)
names(df7) = c("A","B","C","D","E","G","H")

install.packages("reshape")
library(reshape)

df7 = reshape::rename(df7, c(A="요일", H="gender"))


#5. 정렬하기
order(df7$D) #순서
df7[order(df7$D),] #sort

install.packages("plyr")
library(plyr)
arrange(df7, D)
arrange(df7, desc(D))

#6. 열 삭제하기
df7["C"] = NULL
df7$C = NULL

#7. 데이터 분리하기
mylist = split(df7, df7$gender)
class(mylist) #list

mylist$m; mylist$f
class(mylist$f) #data.frame

mylist = split(iris, iris$Species)
mylist$setosa

#8. 조건에 맞는 데이터 추출하기
iris[iris$Sepal.Length >7.5,][c("Sepal.Length","Species")]

subset(iris, Sepal.Length >= 6 & Sepal.Length <= 7,
       select = c(Sepal.Length,Species))





######################################################################
#조건문
#if...else
x = 20
if(x > 10){
  print(paste(x, "는 10보다 큽니다."))
}else if(x == 20) {
  print("같습니다")
}else{
  print(paste(x, "는 10보다 작습니다."))
}

ifelse(x>10, paste(x, "는 10보다 큽니다."), 
       ifelse(x>5, paste(x, "는 5보다 큽니다."),paste(x, "는 10보다 작습니다.")))

library(ggplot2)
diamonds[diamonds$price >= 5000,]
diamonds$price.group = ifelse(diamonds$price > 5000, "5000이상", "5000미만")

df2 = diamonds[,c("price","price.group")]
df2[df2$price.group == "5000이상",]
split(df2, df2$price.group)

#반복문
for(i in 1:10){
  print("Hello World")
}

for(i in c(100,200,55)){
  print(i)
}

for(i in seq(1,10,2)){
  print(i)
}

for(i in sequence(5)){
  print(i)
}

for(i in 1:10){
  cat("hello",i,'\n')
}

i=1
repeat{
  print(i)
  if(i==10) break
  i = i+1
}

i=1
while(i <= 10){
  print(i)
  i = i+1
}

#iris data에서 Sepal.Length가 5~6사이에 있는 행들만 보기
#1,2번째 컬럼만
result <- c()
for (aa in 1:nrow(iris)){
  result <- c(result, iris[i, ])
}

iris[iris$Sepal.Length >= 5 & iris$Sepal.Length <= 6,c(1,2)]

#1~10까지 합계
total = 0
for(i in 1:10){
  total = total + i
}
print(total)


su = matrix(c(1:10))
apply(su, 2, sum) #margin - (1:행방향, 2:열방향)으로 더하기.

iris[,c(1:4)]
apply(iris[,c(1:4)], 2, mean)



#질적자료와 양적자료

#1.질적자료
#-원칙적으로 숫자로 표시될 수 없는 자료.
#-측정 대상의 특성을 분류하거나 확인할 목적으로 숫자를 부여하는 경우는 있지만 그 숫자들이 양적인 크기를 나타내는 것은 아니다.
#-예: 상표의 구분, 성별의 구분, 직업의 구분 등

#2. 양적자료
#-자료의 크기나 양을 숫자로 표현
#1)이산형 자료: 셀 수 있는 정수값으로 표현
#   -예: 불량품의 개수, 결점의 수, 가구수 등

#2)연속형 자료: 연속적인 양으로 표현 
#   -예: 성적, 길이, 무게, 온도 등




#질적자료
#빈도표
table(diamonds$color)
table(diamonds$clarity)
#default: ASC
sort(table(diamonds$cut))
#DESC
sort(table(diamonds$cut), decreasing = T)

round(prop.table(table(diamonds$cut))*100, digits = 2)

install.packages("prettyR")
library(prettyR)
freq(diamonds$cut)
freq(diamonds$cut, display.na = F) #NA은 출력하지 않는다.

#그래프
barplot(table(diamonds$cut), col = "skyblue", 
        name = "다이아몬드 품질 현황", 
        xlab = "cut",
        ylab = "빈도") #xlab: x축 제목, ylab: y축 제목
barplot(table(diamonds$cut), horiz = T)

colors()

#bar chart
ggplot(data=diamonds, mapping=aes(x=cut)) + geom_bar()
#pie chart
ggplot(data=diamonds, mapping=aes(x="", fill = cut)) + geom_bar() + coord_polar("y")
pie(table(diamonds$cut), radius = 1)




#양적자료
diamonds$gprice = cut(diamonds$price, breaks = c(0,5000,10000,15000,20000))
diamonds$gprice = cut(diamonds$price, breaks=seq(0, 20000, 5000))

table(diamonds$gprice)
round(prop.table(table(diamonds$gprice))*100, 2)

#히스토그램
hist(diamonds$price)
hist(diamonds$price, breaks = c(0,5000,10000,15000,20000))
hist(diamonds$price, breaks = 10) #구간의 개수를 정의.

boxplot(diamonds$price)
boxplot(diamonds$price, range = 1.5)
#cut별로 price
boxplot(diamonds$price ~ diamonds$cut, range = 1.5)
boxplot(price ~ cut, data=diamonds)

#mean():평균값
#이상치에 영향을 많이 받는다.
mean(diamonds$price) 
table(is.na(diamonds$price))
sum(is.na(diamonds$price))
mean(diamonds$price, na.rm = T)

nf = read.table("./data/na_data.txt", header = T, sep = "\t")
mean(nf$DATA1, na.rm = T, trim = 0.05)

#median():중위수, 자료의 중심을 알려줌.
#이상치에 영향을 덜 받는다.
median(diamonds$price)

max(diamonds$price)
min(diamonds$price)

max(diamonds$price)-min(diamonds$price)
#최소-최대의 차이
diff(range(diamonds$price))

summary(diamonds)
summary(diamonds$price)
#집단별로 기술통계량 구하기.
by(diamonds$price, diamonds$cut, summary)

str(diamonds)
#diamonds
#질적자료: cut, color, clarity, gprice
#양적자료: 나머지....

install.packages("psych")
library(psych)
describe(diamonds$price)
describeBy(diamonds$price, diamonds$cut)

install.packages("gmodels")
library(gmodels)
CrossTable(diamonds$cut, diamonds$color, pro.r = T, prop.c = T, digits = 1)

#stacked bar chart
barplot(table(diamonds$cut, diamonds$color),
        legend.text = levels(diamonds$cut),
        args.legend=list(x="topright"))
barplot(table(diamonds$cut, diamonds$color), beside = T,
        legend.text = levels(diamonds$cut),
        args.legend=list(x="topright"))

#산점도
plot(diamonds$carat, diamonds$price)
plot(diamonds[ , c("x", "y", "z")])
pairs(diamonds[ , c("carat", "price", "color")])


#mpg데이터의 cty와 hwy간의 어떤 관계를 알아보려고 합니다.
#x축은 cty, y축은 hwy로 된 산점도를 만들어 보세요.
plot(mpg$cty, mpg$hwy)

ggplot(mpg, aes(x=cty, y=hwy)) + geom_point()
mpg[,c("manufacturer","model","cty","hwy")]

#midwest데이터를 이용해서 전체 인구와 아시아인 인구 간에 관계.
#x축은 poptotal, y축은 popasian으로 된 산점도를 그려라.
#전체 인구는 50만명 이하, 아시아인 인구는 1만명 이하
ggplot(midwest, aes(x=poptotal, y=popasian)) + geom_point() + xlim(0, 500000) + ylim(0, 10000)

