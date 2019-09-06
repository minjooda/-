
/* ******************************************************************
테이블 스페이스 조회

- 모든 테이블스페이스 확인
시스템 계정에서  dba_data_files 또는 dba_tablespaces 뷰를 이용해 조회
- 현재 접속한 계정의 default tablespace 확인
	- user_users 뷰의 default_tablespace 컬럼을 이용해 조회
******************************************************************* */
--현재 사용자의 default 테이블스페이스 조회.
select * from user_users;
select * from tabs; --현재 사용자 소유의 테이블 정보 조회.

select * from dba_data_files; --system 계정으로 접속.
select * from dba_tablespaces;




/* ***********************************************
테이블 스페이스 생성

create tablespace 테이블스페이스이름
datafile '테이블스페이스가 사용할 data파일의 경로'
size 파일크기  --k|m  키로바이트, 메가바이트
[autoextend on next 확장될 크기] --G: 생략시 증가 안함
[maxsize 최대파일크기] --생략시 최대사이즈 지정안함
[
default storage(
  initial 10K --테이블스페이스의 첫번째 extends 크기
  next  10K -- 다음 extends의 크기
  minextents 2 --생성할 extent 의 최소값
  maxextents 50 -- 생성할 extent의 최대개수
  pctincrease 50 -- extents 증가율
)
]
*********************************************** */
--system
create tablespace my_tbs
datafile 'C:\oraclexe\app\oracle\oradata\XE\my_tbs.dbf' size 10m;

--scott_join
create table test_tbs(
    txt varchar2(1000)
)tablespace my_tbs;

select * from tabs where table_name = 'TEST_TBS';

begin 
    for i in 1..50000
    loop
        insert into test_tbs values (i||'번째 실행');
    end loop;
    commit;
end;
/
select * from test_tbs;

--system
--테이블스페이스의 공간이 부족
--1. data file을 추가.
alter tablespace my_tbs add datafile 'C:\oraclexe\app\oracle\oradata\XE\my_tbs2.dbf' size 20m;
select * from dba_data_files;
--2. datafile의 크기(size)가 자동으로 늘어나도록 설정.
alter database datafile 'C:\oraclexe\app\oracle\oradata\XE\my_tbs.dbf' autoextend on next 10m; --10m씩 자동 증가.
--3. data file의 크기(size)를 늘린다.
alter database datafile 'C:\oraclexe\app\oracle\oradata\XE\my_tbs.dbf'
resize 20m;


/* *********************************
테이블 스페이스 삭제
drop tablesapce 테이블스페이스이름 [옵션]
- 옵션
	- including contents [and datafiles] : 데이터가 이미 들어 있는 경우 내용을 포함해 모두 삭제. 테이터가 있는 경우 이 옵션을 반드시 줘야 한다. 
										   and datafiles를 추가하면 테이블스페이스가 사용하는 데이터파일도 같이 디스크에서 삭제한다.
	- cascade constraints: 테이블스페이스내의 테이블의 primary key를 참조하는 foreign key 설정을 모두 삭제하고 테이블스페이스를 삭제한다.
********************************* */
drop tablespace my_tbs including contents and datafiles cascade constraints;
select * from dba_data_files;

