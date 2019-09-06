/* **********************
사용자 계정 관리
*********************** */
/* *****************************************
사용자 계정 조회
- 관리자 계정(SYSTEM, SYS)의 dba_users 뷰 조회
- 접속한 사용자 계정 조회: user_users 뷰 사용
****************************************** */
-- 사용자 계정 조회
select * from dba_users;
select * from user_users;
select * from user_views;
select * from dba_views;


/* ************************************
- 사용자 계정 생성
 구문
 CREATE USER 계정명 IDENTIFIED BY 패스워드 
 [DEFAULT TABLESPACE 테이블스페이스이름]  		--사용자의 기본 테이블스페이스 지정. 테이블 생성시 따로 지정하지 않으면 이 테이블 스페이스를 사용한다.
 [TEMPORARY TABLESPACE 테이블스페이스이름] 		-- 사용자의 임시테이블스페이스 지정
 [QUOTA SIZE|UNLIMITED ON 테이블스페이스이름]  --테이블스페이스에서 사용자가 사용할 공간의 상한값. 단위 K|M, unlimited 무제한
 [PASSWORD EXPIRE]                         		        --계정의 패스워드를 만료시킨 상태로 생성. 사용자 로그인시 패스워드를 등록하게 한다.
 [ACCOUNT LOC/UNLOCK]                      		    --사용자 계정을 잠그거나 푼상태로 생성(기본값: UNLOCK)
 
************************************ */
-- 사용자 계정 생성- username: test_user, password: 1111, users 테이블스페이스 10M 사용
create user test_user identified by 1111
quota 10m on users
quota 10m on system;

grant create session, create table to test_user;

drop user a_user;
create user a_user identified by 1111
default tablespace users
quota unlimited on users --users 테이블스페이스를 사용할 수 있다.
quota 10m on system --system 테이블스페이스를 사용할 수 있다.
password expire; --암호만료


grant create session, create table to a_user;

select * from dba_tablespaces;
--Guide: 접속은 sqlplus에서 해본다. 

/* ************************************
사용자 계정 변경
ALTER USER 계정명 수정할 항목
************************************** */

-- 패스워드 변경
-- ALTER USER 계정명 INDENTIFIED BY 새패스워드
alter user a_user indentified by oracle;


-- 사용자 패스워드 만료(expire)/계정 잠그기(lock) : 관리자 계정만 가능
-- 만료: 사용자가 로그인시 새로운 패스워드를 입력받는다.
-- 잠그기: 사용을 제한한다. 관리자가 풀어줄 때 까지 로그인이 안된다.

-- 패스워드 만료
alter user a_user password expire;

 
-- 계정 잠그기(lock)
alter user a_user account lock;
  
-- 잠금 풀기(unlock)
alter user a_user account unlock;
  
  
/* ************************************
- 사용자 삭제
 구문
 DROP USER 계정명 [CASCADE]
 - CASCADE : 삭제하려는 계정이 객체(TABLE등)를 소유하는 경우 소유 객체를 같이 삭제 한다. --GUIDE: 테이블등이 있으면 DROP 안된다 CASCADE 옵션줘야함.
************************************ */

-- test_user 계정 삭제
drop user a_user cascade;


/* **********************
사용자 권한과 롤
- 권한 : 특정한 작업을 수행할 수 있는 권한(권리)
- 롤(Role): 여러개의 권한을 모아 둔 것.

사용자 권한 설정
- 사용자가 데이터베이스와 관련되어 어떤 일을 할 수있는지를 설정하는 것.
- 구문
 GRANT 권한종류 TO 대상 [ WITH ADMIN OPTION]
    - 권한종류 
         - 여러 권한을 한번에 줄때는 , 를 구분자로 해서 지정한다.
         -  ALL PRIVILEGES: 모든 권한을 다 준다.
    - 대상
        - 사용자계정명
        - ROLE
        - PUBLIC : 생성된 모든 사용자에게 권한을 부여한다.
    - WITH ADMIN OPTION 을 지정하면 부여받은 권한을 다른 사용자에게 부여할 수 있다. 

- 권한의 두가지
  - 시스템 권한: 데이터베이스 작업과 관련된 권한
  - 객체(object)권한: 사용자가 다른사용자가 소유한 특정 객체(ex: 테이블)에 접근, 조작할 수 있는 권한
- 주요 시스템권한 - 관리자 계정에서 준다.
Guide: (create 하면 drop, alter 권한도 생긴다.)
    - CREATE SESSION : DB 접속(CONNECT) 권한
    - CREATE TABLE : 테이블 생성권한
    - CREATE PROCEDURE : 프로시저 생성권한
    - CREATE VIEW : VIEW 생성권한
    - CREATE TRIGGER: 트리거 생성 권한
    - CREATE TYPE : 레코드, 컬렉션등 타입 생성권한
    - GREATE SEQUENCE : 시퀀스 생성 권한
- 객체 권한
    - 사용자가 소유한 특정객체(테이블, 뷰, 시퀀스, 프로시저)를 다른 사용자가 접근하거나 조작할 수 있는 권한.
    - 객체의 소유자(생성자)는 객체에 대한 모든 권한을 가진진다.
    - 객체 소유자로 로그인한 뒤 다른 사용자에게 권한을 준다. 
    - 객체에 따른 명령어 권한
        - ALTER : 테이블, 시퀀스
        - INSERT : 테이블, 뷰
        - DELETE : 테이블, 뷰
        - UPDATE: 테이블, 뷰
        - SELECT : 테이블, 뷰, 시퀀스
        - EXECUTE : 프로시저
     - 구문 : GRANT 명령어 ON 테이블 TO 사용자_계정;
 
-- 권한 회수(삭제 )
REVOKE 부여한 권한 FROM 사용자_계정;
*********************** */
-- test_user 계정 생성.
drop user test_user;
create user test_user identified by 1111
quota 10m on users;
-- test_user 사용자에게 접속, 테이블 생성, 시퀀스 생성의 권한을 부여
grant create session, create table, create sequence to test_user;

alter user test_user default tablespace users;

-- SCOTT_JOIN 계정에서 test_user 계정에게 EMP 테이블의 SELECT 권한을 준다.
grant select, insert on emp to test_user;

--다른 계정의 객체(테이블)에 접근 - 계정명.테이블명
select * from scott_join.emp;
insert into scott_join.emp values (220, 'Daven', 'AD_VP', null, sysdate, 5000, null, 90);


-- SCOTT_JOIN 계정에서 test_user 계정에게 DEPT 테이블의 DELETE, SELECT 권한을 준다.
grant select, delete on dept to test_user;



--SCOTT_JOIN계정에서 test_user 계정에게 준 dept 테이블 select 권한을 회수한다..
revoke select on emp from test_user;



-- test_user 계정의 시스템 권한 중 테이블생성, 시퀀스 생성 권한을 회수한다.
revoke create table, create sequence from test_user;


/* **********************
사용자 ROLE 설정
- 오라클에서 사용자의 권한들을 특정 목적에 따라 묶어 놓은 ROLE을 제공. 

-- 오라클 제공 ROLE
  - CONNECT: 데이터베이스 접속과 관련된 권한을 묶어 놓은 ROLE
  - RESOURCE: 오라클 데이터베이스 기본 객체(테이블, 뷰, 인덱스, 프로시저, 시퀀스)을 생성, 변경, 삭제할 수 있는 권한을 묶어놓은 ROLE
  - DBA : 오라클 데이터베이스를 관리하기 위한 124개의 권한을 묶어 놓은 ROLE
  - SYSDBA: 데이터베이스 시작/종료/관리를 위한 ROLE
  - SYSOPER : SYSDBA권한과 데이터베이스를 생성할 수 있는 ROLE
  
- 사용자에게 ROLE 부여
 GRANT ROLE TO 사용자계정;
 - 사용자의 ROLE 철회
 REVOKE ROLE FROM 사용자계정;
 
- ROLE 생성
1. ROLE 생성
	- CREATE ROLE ROLE이름 
2. ROLE에 권한 부여
	- GRANT 권한 TO ROLE이름
3. 사용자에게 ROLE 지정
	- GRANT ROLE이름 TO 계정명 [, ..]


*********************** */
create user test_user2 identified by 1111;
alter user test_user2 default tablespace users quota 10m on users;
--role
create role manager_role; --  role 생성.
grant create session, create table, create view to manager_role; --role에 권한을 담는다.

grant manager_role to test_user2;



/*
TODO
1. 사용자 계정 생성
    - username/password는 알아서 지정.
    - 기본 테이블스페이스로 users 설정
    - users 테이블 스페이스에서 10m를 사용하도록 설정
    
2. 1에서 생성한 사용자에게 DB 연결, 테이블 생성 권한 부여

3. 1에서 생성한 계정으로 접속 확인.

4. 1에서 생성한 사용자의 패스워드 변경

5. 변경된 패스워드로 접속 확인

6. 테이블 생성 확인한다.

7. 관리자 계정으로 접속해서 1에서 생성한 계정에 테이블 생성 권한 삭제 

8. 1에서 생성한 계정에 접속한 뒤 테이블 생성이 되는지 확인한다.

9. 관리자 계정에서 1에서 생성한 계정 삭제
*/
create user test_user3 identified by 1111
default tablespace users
quota 10m on users;

grant create session, create table to test_user3;
alter user test_user3 identified by oracle;

revoke create table from test_user3;

drop user test_user3 cascade;
/*
TODO
1. 테이블스페이스 생성
    - 이름 : hr_tbs
    - 데이터파일 : 경로/hr_tbs1.dbf  , size : 50m

2. 1에서 생성한 테이블스페이스에 데이터파일 추가
    - 데이터파일:  경로/hr_tbs2.dbf,  size: 50m 
    
3.  사용자 계정 생성
    - username/password는 알아서 지정.
    - 기본 테이블스페이스로 hr_tbs 설정
    - hr_tbs 테이블스페이스에서 용량을 무제한으로 사용하도록 설정.
    - 패스워드는 만료된 상태로 설정해서 처음접속시 패스워드를 입력하도록 한다.
    
4. ROLE 생성
    - 이름 : director_role
    - 권한 : 연결, 테이블생성, 뷰생성, 시퀀스 생성

5. 3에서 생성한 사용자에게 4에서 생성한 ROLE을 부여한다.

6. 3에서 생성한 계정으로 접속후 테이블, 뷰, 시퀀스를 생성해서 권한이 부여되었는지 체크한다.

7. SCOTT_JOIN 으로 접속해서 3에서 생성한 계정에게 EMP 테이블에 대한 조회 권한을 부여한다.

8 3에서 생성한 계정으로 접속후 SCOTT_JOIN의 EMP 테이블을 조회한다.



*/
create tablespace hr_tbs
datafile 'C:\oraclexe\app\oracle\oradata\XE\hr_tbs2.dbf' size 50m;

alter tablespace hr_tbs add datafile 'C:\oraclexe\app\oracle\oradata\XE\hr_tbs1.dbf' size 50m;

select * from dba_data_files;

create user test_user4 identified by 1111
default tablespace hr_tbs
quota unlimited on hr_tbs
password expire;

create role director_role;
grant create session, create table, create view, create sequence to director_role;
grant director_role to test_user4;

grant select on emp to test_user4;
