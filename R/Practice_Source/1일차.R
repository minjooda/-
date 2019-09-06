#산술, 할당연산자
a = 10
a <- 20
30 -> a
b = 3
a + b
paste("a+b=", a+b)
paste("a-b=", a-b)
paste("a/b=", a/b)
paste("a*b=", a*b)
paste("a%/%b=", a%/%b) #몫
paste("a%%b=", a%%b) #나머지
paste("a^b=", a^b)
paste("a**b=", a**b)

#비교연산자
a = 10
b = 10
a == b
a != b
!(a == b)

#&, &&: 모두 참이면 참.
#&& :앞의 결과가 false이면 뒤를 수행안함.
a = 4
b = 4
a!=b & (b<-b+1)>5
a!=b && (b<-b+1)>5
a==b | (b<-b+1)>5
a==b || (b<-b+1)>5

a = c(0,2,3)
b = c(1,2,0) 
#값이 여러개인 경우
#&: 각각의 결과를 비교
#&&: 처음 하나의 결과만 비교.
a & b
a && b

#연산자 우선순위(=, <-): <-이 높다
a = b = 5
a <- (b = 4)
a = b <- 7

a = c(1,2,3,4,5)
mean(a) #평균값

#=은 최상위에서 사용.(error)
mean(a2 <- c(1,2,3,4,5))
a2

#데이터의 유형
t1 = 100
t2 = 'Hello'
t3 = TRUE
t4 = 1+2i
t5 = NULL #정의된 바가 없다.
t6 = NA #있어야 하는 데 없는 값...(결측치)
t7 = sqrt(-9) #NaN
t8 = Inf #무한대
t5 + 100 #알 수 없다.. 원하는 값이 아니다.
t6 + 100 #NA
t8 + 100

#원시자료형: 물리적인 자료형
mode(t1)
mode(t2)
mode(t3)
mode(t4)
mode(t5)
mode(t6)
#class: 객체지향 관점 numeric -> integer, double
#typeof: R언어 자체의 관점
t1 = 100L
mode(t1)   #numeric
class(t1)  #integer, double
typeof(t1) #integer, double

class(t2)
class(t3)

is.numeric(t1)
is.character(t1)

#데이터 타입에 우선순위를 가진다
#문자형>복수소형>수치형>논리형
a = c(100, '문자', 10>20, 1+2i)
a = c(100, 10>20, 1+2i)
a = c(100, 10>20)

#강제 형변환
n1 = 100
n2 = as.character(n1)
n3 = as.numeric(n2)
n4 = n3 + n1

#벡터: c()
v1 = c(1,2,3)
v2 = c('일','이','삼')
v3 = c(100, v1, v2)
v4 = 1:10 #1씩 증가
v5 = 10:1 #1씩 감소
v6 = 10:10
v7 = 3:-2.9 #범위를 초과하지 않는 선에서 정수형

s = seq(1,5,0.5)
#속성이름 사용시 순서 상관x
seq(from=1, to=5, by=2)
seq(from=1, by=2, to=5)
seq(from=5, to=1, by=-0.5)

sequence(5)
sequence(5.9)
sequence(1)
sequence(-1) #error

#지정된 데이터를 복사해주는 기능: rep()함수
v1 = rep('a', times=5)
v2 = rep('a', each=5)
rep(c('a','b'), times=3) #전체 3번 반복
rep(c('a','b'), each=3)  #각각 3번 반복

#each > times: each의 우선순위가 더 높다
#각각 2번씩 3번 반복
rep(c('a','b'), times=3, each=2)
rep(c('a','b'), times=c(3,2))

#length.out: 출력길이 제한
rep(c('a','b'), times=3, each=2, length.out=7)

#벡터의 속성
#벡터~값 한가지의 타입으로 값 한개 이상 묶음
v1 = 10
v2 = c(1,2,3,4,5)
v3 = 1:5
v4 = seq(1,10,2)
v5 = sequence(10)

mode(v1)
is.numeric(v2)
length(v2)
names(v2) #NULL : 정의된 바가 없다.
names(v2) = c('a','b','c','d','e')

v2[1] #1번째 출력 (0번째는 없다. index는 1부터 시작)
v2[1:3] #1~3번째 출력
v2[c(1,2,5)] #1,2,5번째 출력
v2[-c(1,4,5)] #1,4,5번째는 제외하고..
v2[-1] #1번째는 제외하고..
v2['d'] #이름이 있다면 이름으로 접근 가능.

#벡터연산
v1 = 1:5 #1,2,3,4,5
v2 = 10:13 #10,11,12,(10,11)
#원소의 개수가 모자를 경우 임의로 처음 수부터 재활용.
v1+v2
v1-v2
v1/v2
v1*v2

#5명의 점수가 있다. 벡터로 저장한다.
#이름이 있다.
score = c(88, 75, 90, 65, 72)
names(score) = c('a', 'b', 'c', 'd', 'e')

#10점씩 올려준다.
score = score + 10

#factor
we = c('m','m','f','f','m')
we[1] = 'a'

we = c('m','m','f','f','m')
we2 = factor(we)
levels(we2)
we2[1] = 'a' #error
we2[1] = 'f'
we3 = factor(we, levels = c('m','f'), labels = c('남자','여자'))

we4 = factor(we, levels = c('m','f'), labels = c('남자','여자'),
             ordered = TRUE)
sort(we4)


#factor에서 범주의 수를 알고 싶다.
nlevels(we4)
#범주형인지 알고 싶을 때...enumeration열거형
is.factor(we4)
#sort된 것인지 알고 싶을 때
is.ordered(we3)


#행렬
#rbind():행 방향, cbind():열 방향, matrix()

#default : 열이 먼저 채워진다.
#byrow = TRUE : row를 먼저 채운다.
matrix(data = 1:10, nrow = 2) 
matrix(data = 1:10, nrow = 2, byrow = TRUE) 
matrix(1:10, nrow = 5, ncol = 2, byrow = TRUE) 

data = c(2,4,6,8,10,12,14,16,18,20)
matrix(data, nrow = 5, ncol = 2, byrow = TRUE) 
mydata = matrix(sequence(10), nrow = 5, ncol = 2, byrow = TRUE) 

mydata[2, 2]
mydata[2,]
mydata[,2]

v1 = c(1,2,3,4,5)
v2 = c(10,20,30,40,50)
rbind(v1, v2)
cbind(v1, v2)

#배열(array): 3차원 이상 가질 수 있음.
#개수가 맞지 않으면 recycling.
a1 = array(1:10, dim = 10);a1
a2 = array(1:10, dim = c(2,5));a2
#2차원 접근은 matrix와 같다.
a2[2,2]
a2[2,]

#열부터 채운다.
a3 = array(1:15, dim = c(3,5));a3

?array

#2행 3열 5개
a4 = array(1:30, dim = c(2,3,5));a4
a4[,1,5]
a4[2,,5]
a4[,,5]

data()
iris
mydata = iris
mode(mydata)
class(mydata)

data(iris) #데이터를 객체화
View(iris) #table형태로 보여줘.



#리스트(list)
v1 = 1:5
m1 = matrix(1:4, nrow = 2, ncol = 2)
arr = array(1:15, c(3,5,2))
alist = list(v1,m1,arr)
alist[1]
alist[[1]][3] #데이터 값에 접근: list[[]]
alist[[2]][1,2]
alist[[3]][2,4,2]

alist[[1]]+10

blist = list("멀티", 100, c(1,2,3), iris)
blist[1] = '캠퍼스'
blist[2] = 200
blist[[3]] = blist[[3]] + 10
blist[4]
