
/* ***********************************************************************************
테이블 생성
- 구문
create table 테이블 이름(
  컬럼 설정
)
<컬럼설정>
- 컬럼명  데이터타입  [default 값]  [제약조건],...
- 데이터타입
    -문자열 : char/nchar - 고정길이, varchar2/nvarchar2/clob - 가변길이
    -숫자 : number, number(전체자릿수, 소수부자릿수)
    -날짜/시간 : date, timestamp
- default : 기본값. 값을 입력하지 않았을 때 넣어줄 기본값.

<제약조건 설정>
- primary key(PK) : 행식별 컬럼, not null, 유일값을 가짐(unique)
- unique key(UK)  : 유일값을 가지는 컬럼, null을 가질 수 있다.
- not null(nn)    : 값이 없어서는 안되는 컬럼.
- check key(ck)   : 컬럼에 들어갈 수 있는 값의 조건을 직접 설정.
- foreign key(FK) : 다른 테이블의 primary key컬럼의 값만 가질 수 있는 컬럼. 
                    다른 테이블을 참조할 때 사용하는 컬럼.
                    
- 컬럼 레벨 설정
    - 컬럼 설정에 같이 설정
- 테이블 레벨 설정
    - 컬럼 설정뒤에 따로 설정

- 기본 문법 : constraint 제약조건이름 제약조건타입
- 테이블 제약 조건 조회
    - USER_CONSTRAINTS 딕셔너리 뷰에서 조회
    
테이블 삭제
- 구분
DROP TABLE 테이블이름 [CASCADE CONSTRAINTS] --부모 테이블 삭제시 참조하는 자식 테이블의 제약 조건을 없앰.
*********************************************************************************** */
drop table parent_tb cascade constraints;

--컬럼레벨 제약조건 설정
create table parent_tb(
    no number constraint parent_tb_pk primary key,
    name varchar2(50) not null, --not null은 컬럼 레벨로 설정.
    birthday date default sysdate, --기본값: sysdate, nullable 컬럼.
    email varchar2(100) constraint parent_email_uk unique,
    gender char(1) not null constraint parent_gender_ck check(gender in ('M', 'F'))   
);

insert into parent_tb (no, name, email, gender)
values (100, '김철수', 'abc@naver.com', 'M');

insert into parent_tb (no, name, birthday, email, gender)
values (101, '유재석', null, 'jsy@gmail.com', 'M');

insert into parent_tb (no, name, birthday, email, gender)
values (102, '유재석', null, 'jsy@gmail.com', 'M'); --email은 UK이기 때문에 동일한 값을 가질 수 없다.

insert into parent_tb (no, name, birthday, email, gender)
values (103, '이영희', null, 'young2@gmail.com', 'f'); -- M or F만 가질 수 있다.(대소문자 구분)

select * from parent_tb;
select to_char(birthday, 'hh24:mi:ss') from parent_tb;

select * from user_tables; --테이블 정보 조회
desc parent_tb; --컬럼정보

select * from user_constraints
where table_name = 'PARENT_TB'; --모든 제약조건 정보 조회.

drop table child_tb;
--테이블 레벨의 제약조건 설정.
create table child_tb(
    no number,             --PK
    jumin_num char(14),    --UK
    age number not null,   --CK(10~90)
    parent_no number,      --FK
    constraint child_pk primary key(no),
    constraint child_jumin_uk unique(jumin_num),
    constraint child_age_ck check(age between 10 and 90),
    --1. constraint child_parent_fk foreign key(parent_no) references parent_tb
    --2. constraint child_parent_fk foreign key(parent_no) references parent_tb on delete set null
        --on delete set null : 부모 테이블의 참조 행이 삭제되면 null로 값을 변경.
    constraint child_parent_fk foreign key(parent_no) references parent_tb on delete cascade
        --on delete set cascade : 부모 테이블의 참조 행이 삭제되면 자식의 행도 같이 삭제.

);

insert into child_tb values (100, '123456-1234567', 35, 100);
insert into child_tb values (101, null, 15, 100);
insert into child_tb values (102, null, 35, 100); --null값에 대해서는 unique는 관여x. null은 알 수 없는 값으로 여러개 넣을 수 있다.
insert into child_tb values (103, '151003-2134587', 5, 100); --age: 10에서 90사이...
insert into child_tb values (104, '651113-1125879', 54, 200); --FK: 200은 parent_tb에 없는 값으로 error.


select * from child_tb;
delete from parent_tb where no = 100; 

--테이블 생성_TEST word 정리
--출판사 테이블 생성.
drop table publisher cascade constraints;
create table publisher(
    publisher_no number not null constraint publisher_pk primary key,
    publisher_name varchar2(50) not null,
    publisher_address varchar2(100),
    publisher_tel varchar2(20) not null
);

--책 테이블 생성.
drop table book;
create table book(
    isbn varchar2(13),
    title varchar2(50) not null,
    author varchar2(50) not null,
    page number(4) not null,
    price number(8) not null,
    publish_date date default sysdate not null ,
    publisher_no number not null,
    constraint book_pk primary key(isbn),
    constraint book_price_ck check(price >= 0),
    constraint book_page_ck check(page >= 0),
    constraint publisher_fk foreign key(publisher_no) references publisher
);

select * from publisher;
select * from book;

/* ************************************************************************************
ALTER : 테이블 수정

컬럼 관련 수정

- 컬럼 추가
  ALTER TABLE 테이블이름 ADD (추가할 컬럼설정 [, 추가할 컬럼설정])
  - 하나의 컬럼만 추가할 경우 ( ) 는 생략가능

- 컬럼 수정
  ALTER TABLE 테이블이름 MODIFY (수정할컬럼명  변경설정 [, 수정할컬럼명  변경설정])
	- 하나의 컬럼만 수정할 경우 ( )는 생략 가능
	- 숫자/문자열 컬럼은 크기를 늘릴 수 있다.
		- 크기를 줄일 수 있는 경우 : 열에 값이 없거나 모든 값이 줄이려는 크기보다 작은 경우
	- 데이터가 모두 NULL이면 데이터타입을 변경할 수 있다. (단 CHAR<->VARCHAR2 는 가능.)

- 컬럼 삭제	
  ALTER TABLE 테이블이름 DROP COLUMN 컬럼이름 [CASCADE CONSTRAINTS]
    - CASCADE CONSTRAINTS : 삭제하는 컬럼이 Primary Key인 경우 그 컬럼을 참조하는 다른 테이블의 Foreign key 설정을 모두 삭제한다.
	- 한번에 하나의 컬럼만 삭제 가능.
	
  ALTER TABLE 테이블이름 SET UNUSED (컬럼명 [, ..])
  ALTER TABLE 테이블이름 DROP UNUSED COLUMNS
	- SET UNUSED 설정시 컬럼을 바로 삭제하지 않고 삭제 표시를 한다. 
	- 설정된 컬럼은 사용할 수 없으나 실제 디스크에는 저장되 있다. 그래서 속도가 빠르다.
	- DROP UNUSED COLUMNS 로 SET UNUSED된 컬럼을 디스크에서 삭제한다. 

- 컬럼 이름 바꾸기
  ALTER TABLE 테이블이름 RENAME COLUMN 원래이름 TO 바꿀이름;

**************************************************************************************  
제약 조건 관련 수정
-제약조건 추가
  ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건 설정

- 제약조건 삭제
  ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건이름
  PRIMARY KEY 제거: ALTER TABLE 테이블명 DROP PRIMARY KEY [CASCADE]
	- CASECADE : 제거하는 Primary Key를 Foreign key 가진 다른 테이블의 Foreign key 설정을 모두 삭제한다.

- NOT NULL <-> NULL 변환은 컬럼 수정을 통해 한다.
   - ALTER TABLE 테이블명 MODIFY (컬럼명 NOT NULL),  - ALTER TABLE 테이블명 MODIFY (컬럼명 NULL)  
************************************************************************************ */

--customers copy => cust (not null을 제외한 제약 조건은 copy가 안됨.)
create table cust as
select * from customers where 1=0; --값은 빼고 테이블 틀만 복사.

create table ord as
select * from orders where 1=0;

select * from user_constraints where table_name = 'ORD';

--제약조건
--CUST: PK
alter table cust add constraint cust_pk primary key(cust_id);
alter table ord add constraint ord_cust_fk foreign key(cust_id) references cust;

--컬럼추가
alter table cust add (age number default 0 not null);
desc cust;

--컬럼수정
alter table cust modify (cust_name null, address null, postal_code null, phone_number not null);
alter table cust modify (cust_name varchar2(100));
alter table cust rename column age to cust_age; --컬럼이름 변경.

--컬럼삭제
alter table cust drop column cust_age; --컬럼 삭제시 하나씩만 삭제 가능.
--제약조건 삭제
alter table cust drop primary key cascade;


--TODO: emp 테이블을 카피해서 emp2를 생성
drop table emp2;
create table emp2 as
select * from emp where 1=0;

--TODO: gender 컬럼을 추가: type char(1)
alter table emp2 add gender char(1);


--TODO: email 컬럼 추가. type: varchar2(100),  not null  컬럼
alter table emp2 add email varchar2(100) not null;


--TODO: jumin_num(주민번호) 컬럼을 추가. type: char(14), null 허용. 유일한 값을 가지는 컬럼.
alter table emp2 add jumin_num char(14) constraint emp_jumin_uk unique;


--TODO: emp_id 를 primary key 로 변경
--alter table emp2 modify emp_id primary key;
alter table emp2 add primary key(emp_id);

  
--TODO: gender 컬럼의 M, F 저장하도록  제약조건 추가
alter table emp2 add constraint emp_gender_ck check( gender in ('M', 'F'));


--TODO: salary 컬럼에 0이상의 값들만 들어가도록 제약조건 추가
alter table emp2 add constraint emp_sal_ck check(salary >= 0);

--TODO: email 컬럼을 null을 가질 수 있되 다른 행과 같은 값을 가지지 못하도록 제약 조건 변경
alter table emp2 add constraint emp_email_uk unique(email);


--TODO: emp_name 의 데이터 타입을 varchar2(100) 으로 변환
alter table emp2 modify emp_name varchar2(100);


-- TODO: job_id를 not null 컬럼으로 변경
alter table emp2 modify job_id not null;


--TODO: dept_id를 not null 컬럼으로 변경
alter table emp2 modify dept_id not null;



--TODO: job_id  를 null 허용 컬럼으로 변경
alter table emp2 modify job_id null;


--TODO: dept_id  를 null 허용 컬럼으로 변경
alter table emp2 modify dept_id null;



--TODO: 위에서 지정한 emp_email_uk 제약 조건을 제거
alter table emp2 drop constraint emp_email_uk;


--TODO: 위에서 지정한 emp_salary_ck 제약 조건을 제거
alter table emp2 drop constraint emp_sal_ck;


--TODO: primary key 제약조건 제거
alter table emp2 drop primary key cascade;


--TODO: gender 컬럼제거
alter table emp2 drop column gender;


--TODO: email 컬럼 제거
alter table emp2 drop column email;

select * from emp2;
desc emp2;




