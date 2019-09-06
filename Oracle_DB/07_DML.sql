/* *********************************************************************
INSERT 문 - 행 추가
구문
 - 한행추가 :
   - INSERT INTO 테이블명 (컬럼 [, 컬럼]) VALUES (값 [, 값[])
   - 모든 컬럼에 값을 넣을 경우 컬럼 지정구문은 생략 할 수 있다.

 - 조회결과를 INSERT 하기 (subquery 이용)
   - INSERT INTO 테이블명 (컬럼 [, 컬럼])  SELECT 구문
	- INSERT할 컬럼과 조회한(subquery) 컬럼의 개수와 타입이 맞아야 한다.
	- 모든 컬럼에 다 넣을 경우 컬럼 설정은 생략할 수 있다.
  
************************************************************************ */

--모든 컬럼의 값을 넣을 경우 컬럼 선택은 생략 가능.
--단, 값의 순서는 테이블 생성시 지정한 컬럼순.
insert into emp (emp_id, emp_name, job_id, mgr_id, hire_date, salary, comm_pct, dept_id) 
       values ('1000', 'JYP', 'IT_PROG', 120, '2019-07-15', 5000, 0.1, 60);

--NULL: null값
--Date: '년/월/일' 이외의 조합은 to_date()변환, sysdate: 실행시점의 일시 반환하는 함수.
insert into emp values ('1100', 'IU', NULL, 120, to_date('2015/03', 'yyyy/mm'), 5000, 0.1, NULL);

select * from emp order by emp_id desc;

insert into emp (emp_id, emp_name, hire_date) values (1212, 'John', '2013/10/05'); --salary의 not null제약 조건 -> 반드시 값이 들어가야 한다.(error)
insert into emp (emp_id, emp_name, hire_date, salary) values (1212, 'John', '2013/10/05', 1000000); --salary의 정수부: 5자리 -> 7자리 (데이터 크기가 컬럼의 크기보다 크면 에러)

--제약조건: primary key(기본키) 컬럼에 같은 값을 insert못함.
--         foreign key(외래키) 컬럼에는 반드시 부모테이블의 primary key컬럼에 있는 값들만 넣을 수 있다.
insert into emp (emp_id, emp_name, hire_date, salary, dept_id) values (1100, 'John', '2013/10/05', 10000, 500);

create table emp2(
    emp_id NUMBER(6),
    emp_name VARCHAR(20),
    salary NUMBER(7,2)
);

--emp에서 조회한 값을 emp2에 insert
insert into emp2 (emp_id, emp_name, salary) 
select emp_id, emp_name, salary
from emp
where dept_id = 10;

select * from emp2;

--TODO: 부서별 직원의 급여에 대한 통계 테이블 생성.
--      조회결과를 insert. 집계: 합계, 평균, 최대, 최소, 분산, 표준편차
drop table salary_stat;
create table salary_stat(
    dept_id NUMBER(6),
    salary_sum NUMBER(15,2),
    salary_avg NUMBER(10,2),
    salary_max number(7,2),
    salary_min number(7,2),
    salary_var number(20,2),
    salary_stddev number(7,2)
);

insert into salary_stat
select dept_id, sum(salary), round(avg(salary), 2), max(salary), min(salary),
       round(variance(salary),2) ,round(stddev(salary),2)
from emp
group by dept_id
order by 1;

select * from salary_stat;

/* *********************************************************************
UPDATE : 테이블의 컬럼의 값을 수정
UPDATE 테이블명
SET    변경할 컬럼 = 변경할 값  [, 변경할 컬럼 = 변경할 값]
[WHERE 제약조건]

 - UPDATE: 변경할 테이블 지정
 - SET: 변경할 컬럼과 값을 지정
 - WHERE: 변경할 행을 선택. 
************************************************************************ */



-- 직원 ID가 200인 직원의 급여를 5000으로 변경
update emp
set salary = 5000
where emp_id = 200;

select *
from emp
where emp_id = 200;

rollback;
commit;

-- 직원 ID가 200인 직원의 급여를 10% 인상한 값으로 변경.
update emp
set salary = salary * 1.1
where emp_id = 200;

-- 부서 ID가 100인 직원의 커미션 비율을 0.2로 salary는 3000을 더한 값으로 변경.
update emp
set comm_pct = 0.2, salary = salary + 3000
where dept_id = 100;


-- TODO: 부서 ID가 100인 직원들의 급여를 100% 인상
update emp
set salary = salary * 2
where dept_id = 100;


-- TODO: IT 부서의 직원들의 급여를 3배 인상
update emp
set salary = salary * 3
where dept_id = (select dept_id from dept where dept_name = 'IT');


-- TODO: EMP2 테이블의 모든 데이터를 MGR_ID는 NULL로 HIRE_DATE 는 현재일시로 COMM_PCT는 0.5로 수정.
update emp2
set mgr_id = NULL, hire_date = sysdate, comm_pct = 0.5;

/* *********************************************************************
DELETE : 테이블의 행을 삭제
구문 
 - DELETE FROM 테이블명 [WHERE 제약조건]
   - WHERE: 삭제할 행을 선택

!자식테이블에서 참조되고 있는 값은 삭제할 수 없다.
    -자식테이블의 참조 값을 변경하거나 그 행을 삭제 한 뒤 처리한다.
************************************************************************ */

select * from emp where job_id = 'SA_MAN';

-- TODO: 부서 ID가 없는 직원들을 삭제
delete from emp where job_id is null;


-- TODO: 담당 업무(emp.job_id)가 'SA_MAN'이고 급여(emp.salary) 가 12000 미만인 직원들을 삭제.
-- 해당 emp_id가 mgr_id로 참조 -> 따라서 참조하던 mgr_id 값을 변경 후 삭제.
delete from emp where salary < 12000 and job_id = 'SA_MAN';

update emp
set mgr_id = null
where emp_id in (select emp_id from emp where mgr_id in (148, 149)); --참조하고 있는 값들을 null로 변경


-- TODO: comm_pct 가 null이고 job_id 가 IT_PROG인 직원들을 삭제
delete from emp where comm_pct is null and job_id = 'IT_PROG';

rollback;


create table emp_copy
as
select * from emp;

delete from emp_copy;
select * from emp_copy;
rollback;

--truncate table 테이블명; => DDL문, 자동커밋.
--전체 데이터를 삭제 (delete from 테이블명;)
--!rollback을 이용해 복구가 안된다.
truncate table emp_copy;

drop table emp_copy;

/*
주로 DML(insert, update, delete)
1. commit: 작업이 정상적으로 끝났을 때 데이터 변경 부분 적용.
2. rollback: 작업이 비정상적으로 끝났을 때 시작 지점으로 다시 되돌린다.(데이터 원상복구)
3. savepoint 이름: 해당지점으로 다시 되돌린다.

DDL구문이 실행되면 commit이 자동 실행, rollback 할 수 없음.
client tool을 종료해도 commit이 자동 실행.
*/