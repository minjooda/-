/* *****************************************
뷰 (View)
- 하나 또는 여러 테이블로 부터 데이터의 부분 집합을 논리적으로 표현하는 것.
- 실제 데이터를 가지고 있는 것이 아니라 해당 데이터의 조회 SELECT 쿼리를 가지고 있는 것.
- 뷰를 이용해 조회뿐만 아니라 데이터 수정(insert/update/delete)도 가능하다.

- 목적
  - 복잡한 select문을 간결하게 처리 가능
  - 사용자의 데이터 접근을 제한 

- 뷰의 종류
  - 단순뷰 
	- 하나의 테이블에서 데이터를 조회하며 함수를 사용하지 않는다.  

  - 복합뷰
	- 여러 테이블에서 데이터를 조회한다. (데이터의 변경은 사용자에 따라 안 될 수도 있다.)
	- 함수나 group by를 이용해 조회한다.
	
- 뷰를 이용한 DML(INSERT/DELETE/UPDATE) 작업이 안되는 경우
	- 다음 항목이 포함되 있는 뷰는 insert/delete/update 할 수 없다.
		- 그룹함수
		- group by 절
		- distinct 
		- rownum 
		- SELECT 절에 표현식이 있는 경우
		- View와 연결된 행에 NOT NULL 열이 있는 경우
		

- 구문
CREATE [OR REPLACE] VIEW 뷰이름
AS
SELECT 문
[WITH CHECK OPTION]
[WITH READ ONLY]


- OR REPLACE
	- 같은 이름의 뷰가 있을 경우 삭제하고 새로 생성한다.
	
- WITH CHECK OPTION
	- View에서 조회될 수 있는 값만 insert또는 update할 수 있다.

- WITH READ ONLY
	- 읽기 전용 View로 설정. INSERT/DELETE/UPDATE를 할 수 없다.
	
View 제거
DROP VIEW VIEW이름;	

뷰는 수정할 수 없다.
**************************************** */

create view emp_view
as 
select * from emp where dept_id = 60;

select * from emp_view;

select e.emp_name, d.dept_name
from emp_view e, dept d
where e.dept_id = d.dept_id;

update emp_view 
set comm_pct = 0.5 
where emp_id = 104;

select * from emp where emp_id = 104; --view를 update하면 실제 데이터가 수정된다.

create or replace view emp_view
as
select emp_id, emp_name, dept_id
from emp;

insert into emp_view values (5000, 'Sara', 60); --emp table로 삽입이 되기 때문에 hire_date 등 not null컬럼 때문에 에러.

create view dept_view
as
select * from dept where loc = 'New York';

select * from dept_view;
insert into dept_view values (300, '세무서', 'seoul');

select * from dept;

create view dept_view2
as
select * from dept where loc = 'New York'
with check option;

select * from dept_view2;

insert into dept_view2 values (301, 'seoul part', 'seoul'); --해당 view에서 존재하는 값만 가능(오류)
                                                            --즉, view의 where절의 조건들을 만족하는 값들만 변경할 수 있다.
update dept_view2
set dept_name = 'security'
where dept_id = 10; --view에 없는 데이터이므로 update가 안됨(0행 변경)

create view dept_view3
as
select * from dept where loc = 'New York'
with read only;

select * from dept_view3;
insert into dept_view3 values (302, 'security', 'seoul');


create view emp_name_view
as
select emp_name, length(emp_name) name_length --함수 사용시 꼭 alias를 줄 것.
from emp;

select * from emp_name_view;

create view emp_view2
as
select dept_id, max(salary) 최대급여, min(salary) 최소급여
from emp
group by dept_id;

update emp
set salary = 20000
where emp_id = 108;

select * from emp_view2;
select * from emp where emp_id = 108;

create view emp_dept_view
as
select e.emp_id, e.emp_name, e.salary, e.job_id, e.hire_date, e.comm_pct,
       d.dept_id, d.dept_name, d.loc
from emp e left join dept d on e.dept_id = d.dept_id;

select * from emp_dept_view where loc = 'Seattle';



--TODO: 급여(salary)가 10000 이상인 직원들의 모든 컬럼들을 조회하는 View 생성
create view emp_sal_view
as
select * from emp where salary >= 10000;

select * from emp_sal_view;

--TODO: 부서위치(dept.loc) 가 'Seattle'인 부서의 모든 컬럼들을 조회하는 View 생성
create view dept_loc_view
as
select * from dept where loc = 'Seattle';

select * from dept_loc_view;



--TODO: JOB_ID가 'FI_ACCOUNT', 'FI_MGR' 인 직원들의 직원_ID(emp.emp_id), 직원이름(emp.emp_name), 업무_ID(emp.job_id), 
-- 업무명(job.job_title), 업무최대급여(job.max_salary), 최소급여(job.min_salary)를 조회하는 View를 생성
create or replace view emp_job_view
as
select emp_id, emp_name, e.job_id, job_title, max_salary, min_salary
from emp e left join job j on e.job_id = j.job_id
where e.job_id in ('FI_ACCOUNT', 'FI_MGR');

select * from emp_job_view;


--TODO: 직원들의 정보와 직원의 급여 등급(salary_grade.grade)을 조회하는 View를 생성
create view emp_grade_view
as
--select emp_id, emp_name, job_id, mgr_id, hire_date, salary, comm_pct, dept_id, grade
select emp.*, grade
from emp, salary_grade
where emp.salary between low_sal and high_sal;

select * from emp_grade_view;

--TODO: 직원의 id(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 급여(emp.salary), 입사일(emp.hire_date),
--   상사이름(emp.emp_name), 상사의입사일(emp.hire_date), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회하는 View를 생성
-- 상사가 없는 직원의 경우 상사이름, 상사의입사일을 null로 출력.
-- 부서가 없는 직원의 경우 '미배치'로 출력
-- 업무가 없는 직원의 경우 '업무없음' 으로 출력
create view emp_join_view
as
select e.emp_id 직원id, e.emp_name 직원이름, nvl(j.job_title, '업무없음') 업무명, e.salary 급여, e.hire_date 입사일,
       m.emp_name 상사이름, m.hire_date 상사입사일,
       nvl(dept_name, '미배치') 소속부서, nvl(loc, '미배치') 위치 
from emp e left join job j on e.job_id = j.job_id
           left join emp m on e.mgr_id = m.emp_id
           left join dept d on e.dept_id = d.dept_id;

select * from emp_join_view;

--TODO: 업무별 급여의 통계값을 조회하는 View 생성. 출력 컬럼 업무명, 급여의 합계, 평균, 최대, 최소값을 조회하는 View를 생성 
create or replace view sal_avg_view
as
select job_title, sum(salary) 급여합계, round(avg(salary), 2) 급여평균, max(salary) 최대급여, min(salary) 최소급여
from emp e, job j
where e.job_id = j.job_id
group by job_title;

select * from sal_avg_view;


--TODO: 직원수, 부서개수, 업무의 개수를  조회하는 View를 생성
create or replace view count_view
as
select '직원수' label, count(*) cnt from emp
union all
select '부서수', count(*) from dept
union all
select '업무수', count(*) from job;

select * from count_view;


/* **************************************************************************************************************
시퀀스 : SEQUENCE
- 자동증가하는 숫자를 제공하는 오라클 객체
- 테이블 컬럼이 자동증가하는 고유번호를 가질때 사용한다.
	- 하나의 시퀀스를 여러 테이블이 공유하면 중간이 빈 값들이 들어갈 수 있다.

생성 구문
CREATE SEQUENCE sequence이름
	[INCREMENT BY n]	
	[START WITH n]                		  
	[MAXVALUE n | NOMAXVALUE]   
	[MINVALUE n | NOMINVALUE]	
	[CYCLE | NOCYCLE(기본)]		
	[CACHE n | NOCACHE]		  

- INCREMENT BY n: 증가치 설정. 생략시 1
- START WITH n: 시작 값 설정. 생략시 0
	- 시작값 설정시
	 - 증가: MINVALUE 보다 크커나 같은 값이어야 한다.
	 - 감소: MAXVALUE 보다 작거나 같은 값이어야 한다.
- MAXVALUE n: 시퀀스가 생성할 수 있는 최대값을 지정
- NOMAXVALUE : 시퀀스가 생성할 수 있는 최대값을 오름차순의 경우 10^27 의 값. 내림차순의 경우 -1을 자동으로 설정. 
- MINVALUE n :최소 시퀀스 값을 지정
- NOMINVALUE :시퀀스가 생성하는 최소값을 오름차순의 경우 1, 내림차순의 경우 -(10^26)으로 설정
- CYCLE 또는 NOCYCLE : 최대/최소값까지 갔을때 순환할 지 여부. NOCYCLE이 기본값(순환반복하지 않는다.)
- CACHE|NOCACHE : 캐쉬 사용여부 지정.(오라클 서버가 시퀀스가 제공할 값을 미리 조회해 메모리에 저장) NOCACHE가 기본값(CACHE를 사용하지 않는다. )
                  캐쉬 기본 값 = 20

시퀀스 자동증가값 조회
 - sequence이름.nextval  : 다음 증감치 조회
 - sequence이름.currval  : 현재 시퀀스값 조회


시퀀스 수정
ALTER SEQUENCE 수정할 시퀀스이름
	[INCREMENT BY n]	               		  
	[MAXVALUE n | NOMAXVALUE]   
	[MINVALUE n | NOMINVALUE]	
	[CYCLE | NOCYCLE(기본)]		
	[CACHE n | NOCACHE]	

수정후 생성되는 값들이 영향을 받는다. (그래서 start with 절은 수정대상이 아니다.)	  


시퀀스 제거
DROP SEQUENCE sequence이름
	
************************************************************************************************************** */

-- 1부터 1씩 자동증가하는 시퀀스
create sequence ex01_seq;
select * from user_sequences;

select ex02_seq.nextval from dual;

-- 1부터 50까지 10씩 자동증가 하는 시퀀스
create sequence ex02_seq
       increment by 10
       maxvalue 50;


 alter sequence ex02_seq 
       cycle 
       nocache;


-- 100 부터 150까지 10씩 자동증가하는 시퀀스
create sequence ex03_seq
       increment by 10
       start with 100
       maxvalue 150;
 
 select ex03_seq.nextval from dual;
 select ex03_seq.currval from dual;
 

-- 100 부터 150까지 2씩 자동증가하되 최대값에 다다르면 순환하는 시퀀스
create sequence ex04_seq
       increment by 2
       start with 100
       maxvalue 150
       cycle; --cycle은 시퀀스가 생성하는 숫자의 개수가 cache size보다 커야한다.
       
select ex04_seq.nextval from dual; -- cycle시 minvalue 값부터 시작한다.


create sequence ex05_seq
       increment by 10
       start with 100
       maxvalue 150
       minvalue 100
       cycle
       cache 3;
       
select ex05_seq.nextval from dual;


-- -1부터 자동 감소하는 시퀀스
create sequence ex06_seq
       increment by -1;

select * from user_sequences;       
select ex06_seq.nextval from dual;


-- -1부터 -50까지 -10씩 자동 감소하는 시퀀스
create sequence ex07_seq
       increment by -10
       minvalue -50;
       
select ex07_seq.nextval from dual;

-- -10부터 -100까지 -10씩 감소하는 시퀀스
drop sequence ex08_seq;
create sequence ex08_seq
       increment by -10
       start with -10
       minvalue -100
       cycle --감소: 순환시 maxvalue부터 시작.
       nocache; 

alter sequence ex08_seq
      maxvalue -10; --현재 값보다 큰 값이어야 한다.
      
-- 100 부터 -100까지 -100씩 자동 감소하는 시퀀스
-- 감소: sequence가 만드는 값은 최대 maxvalue보다 클 수 없다.
create sequence ex09_seq
       increment by -100
       start with 100
       minvalue -100
       maxvalue 100;
       
select ex09_seq.nextval from dual;



-- 15에서 -15까지 1씩 감소하는 시퀀스 작성
create sequence ex10_seq
       increment by -1
       start with 15
       minvalue -15
       maxvalue 15;

select ex10_seq.nextval from dual;

-- -10 부터 1씩 증가하는 시퀀스 작성
-- 증가: 시퀀스가 생성하는 값이 minvalue보다 작아서는 안된다.
create sequence ex11_seq
       start with -10 --start with 이하 값으로 설정.
       minvalue -10;

--제거
drop sequence ex10_seq;

-- Sequence를 이용한 값 insert
create table items(
    no number primary key, --1씩 자동증가
    name varchar2(100) not null
);

drop sequence item_no_seq;
create sequence item_no_seq;

insert into items values (item_no_seq.nextval, '연필'||ex01_seq.nextval);
select * from items;

rollback; --sequence는 rollback 대상이 아니다.

create table dept_copy
as
select * from dept where 1=0;
-- TODO: 부서ID(dept.dept_id)의 값을 자동증가 시키는 sequence를 생성. 10 부터 10씩 증가하는 sequence
-- 위에서 생성한 sequence를 사용해서  dept_copy에 5개의 행을 insert.
drop sequence dept_id_seq;
create sequence dept_id_seq
       increment by 10
       start with 10;
       
insert into dept_copy (dept_id, dept_name, loc) values (dept_id_seq.nextval, '부서'||ex01_seq.nextval, 'korea');
select * from dept_copy;

-- TODO: 직원ID(emp.emp_id)의 값을 자동증가 시키는 sequence를 생성. 10 부터 1씩 증가하는 sequence
-- 위에서 생성한 sequence를 사용해 emp_copy에 값을 5행 insert
create table emp_copy
as
select * from emp where 1=0;

create sequence emp_id_seq
       start with 10;
       
insert into emp_copy (emp_id, emp_name, hire_date, salary) values (emp_id_seq.nextval, '아무개', sysdate, 5000);
select * from emp_copy;