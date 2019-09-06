create user scott_join identified by tiger; --계정생성
grant all privileges to scott_join; --모든 권한 부여.

select * from dept;
desc dept;

/* ****************************************
조인(JOIN) 이란
- 2개 이상의 테이블에 있는 컬럼들을 합쳐서 가상의 테이블을 만들어 조회하는 방식을 말한다.
 	- 소스테이블 : 내가 먼저 읽어야 한다고 생각하는 테이블
	- 타겟테이블 : 소스를 읽은 후 소스에 조인할 대상이 되는 테이블
 
- 각 테이블을 어떻게 합칠지를 표현하는 것을 조인 연산이라고 한다.
    - 조인 연산에 따른 조인종류
        - Equi join (=)연산자 사용, non-equi join (=)연산자 안 사용.
- 조인의 종류
    - Inner Join 
        - 양쪽 테이블에서 조인 조건을 만족하는 행들만 합친다. 
    - Outer Join
        - 한쪽 테이블의 행들을 모두 사용하고 다른 쪽 테이블은 조인 조건을 만족하는 행만 합친다. 조인조건을 만족하는 행이 없는 경우 NULL을 합친다.
        - 종류 : Left Outer Join,  Right Outer Join, Full Outer Join
    - Cross Join = 카티션 곱
        - 두 테이블의 곱집합을 반환한다.(A*B)
- 조인 문법
    - ANSI 조인 문법
        - 표준 SQL 문법
        - 오라클은 9i 부터 지원.
    - 오라클 조인 문법
        - 오라클 전용 문법이며 다른 DBMS는 지원하지 않는다.
**************************************** */        
        

/* ****************************************
-- inner join : ANSI 조인 구문
FROM  소스테이블a (INNER) JOIN 타겟테이블b ON 조인조건 

- inner는 생략 할 수 있다.
**************************************** */
-- 직원의 ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서이름(dept.dept_name)을 조회
select emp.emp_id, emp.emp_name, emp.hire_date, dept.dept_name
from emp inner join dept on emp.dept_id = dept.dept_id;

select E.emp_id, E.emp_name, E.hire_date, D.dept_name
from emp E inner join dept D on E.dept_id = D.dept_id; --테이블명의 별칭을 가지고 사용 가능.


-- 직원의 ID(emp.emp_id)가 100인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서이름(dept.dept_name)을 조회.
select emp.emp_id, emp.emp_name, emp.hire_date, dept.dept_name
from emp join dept on emp.dept_id = dept.dept_id
where emp_id = 100;


-- 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 담당업무명(job.job_title), 소속부서이름(dept.dept_name)을 조회
select emp_id, emp_name, salary, job_title, D.dept_name
from emp E join job J on E.job_id = J.job_id 
           join dept D on E.dept_id = D.dept_id;
      
      
-- 부서_ID(dept.dept_id)가 30인 부서의 이름(dept.dept_name), 위치(dept.loc), 그 부서에 소속된 직원의 이름(emp.emp_name)을 조회.
select dept_name, loc, emp_name
from dept inner join emp on dept.dept_id = emp.dept_id
where dept.dept_id = 30;


-- 직원의 ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 급여등급(salary_grade.grade) 를 조회. 급여 등급 오름차순으로 정렬
select emp_id, emp_name, salary, grade||'등급' 급여등급
from emp join salary_grade on salary between low_sal and high_sal
order by 4;


--TODO 200번대(200 ~ 299) 직원 ID(emp.emp_id)를 가진 직원들의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 오름차순으로 정렬.
select emp_id, emp_name, salary, dept_name, loc
from emp join dept on emp.dept_id = dept.dept_id
where emp_id between 200 and 299
order by 1;


--TODO 업무(emp.job_id)가 'FI_ACCOUNT'인 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무(emp.job_id), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회.  직원_ID의 오름차순으로 정렬.
select emp_id, emp_name, job_id, dept_name, loc
from emp join dept on emp.dept_id = dept.dept_id
where job_id = 'FI_ACCOUNT'
order by 1;


--TODO 커미션비율(emp.comm_pct)이 있는 직원들의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 커미션비율(emp.comm_pct), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 오름차순으로 정렬.
select emp_id, emp_name, salary, comm_pct, dept_name, loc
from emp join dept on emp.dept_id = dept.dept_id
where comm_pct is not null
order by 1;



--TODO 'New York'에 위치한(dept.loc) 부서의 부서_ID(dept.dept_id), 부서이름(dept.dept_name), 위치(dept.loc), 
--     그 부서에 소속된 직원_ID(emp.emp_id), 직원 이름(emp.emp_name), 업무(emp.job_id)를 조회. 부서_ID 의 오름차순으로 정렬.
select D.dept_id, dept_name, loc, emp_id, emp_name, job_id
from dept D join emp E on D.dept_id = E.dept_id
where loc = 'New York'
order by 1;

--TODO 직원_ID(emp.emp_id), 이름(emp.emp_name), 업무_ID(emp.job_id), 업무명(job.job_title) 를 조회.
select emp_id, emp_name, E.job_id, job_title
from emp E join job J on E.job_id = J.job_id; 

              
-- TODO: 직원 ID 가 200 인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 
--       담당업무명(job.job_title), 소속부서이름(dept.dept_name)을 조회              
select emp_id, emp_name, salary, job_title, dept_name
from emp join job on emp.job_id = job.job_id
         join dept on emp.dept_id = dept.dept_id
where emp_id = 200;


-- TODO: 'Shipping' 부서의 부서명(dept.dept_name), 위치(dept.loc), 소속 직원의 이름(emp.emp_name), 업무명(job.job_title)을 조회. 
--       직원이름 내림차순으로 정렬
select dept_name, loc, emp_name, job_title
from dept join emp on emp.dept_id = dept.dept_id
          join job on emp.job_id = job.job_id
where dept_name = 'Shipping'
order by 3 desc;



-- TODO:  'San Francisco' 에 근무(dept.loc)하는 직원의 id(emp.emp_id), 이름(emp.emp_name), 입사일(emp.hire_date)를 조회
--         입사일은 'yyyy-mm-dd' 형식으로 출력
select emp_id, emp_name, to_char(hire_date, 'yyyy-mm-dd') 입사일
from emp join dept on emp.dept_id = dept.dept_id
where loc = 'San Francisco';

-- TODO 부서별 급여(salary)의 평균을 조회. 부서이름(dept.dept_name)과 급여평균을 출력. 급여 평균이 높은 순서로 정렬.
-- 급여는 , 단위구분자와 $ 를 붙여 출력.
select to_char(avg(salary), 'fm$9,999,999') 급여평균, dept_name
from emp join dept on emp.dept_id = dept.dept_id
group by dept_name
order by avg(salary) desc;

--TODO 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 급여(emp.salary), 
--     급여등급(salary_grade.grade), 소속부서명(dept.dept_name)을 조회. 등급 내림차순으로 정렬
select emp_id, emp_name, job_title, salary, grade, dept_name
from emp join job on emp.job_id = job.job_id
         join dept on emp.dept_id = dept.dept_id
         join salary_grade on salary between low_sal and high_sal
order by 4 desc;


--TODO 급여등급이(salary_grade.grade) 1인 직원이 소속된 부서명(dept.dept_name)과 등급1인 직원의 수를 조회. 직원수가 많은 부서 순서대로 정렬.
select dept_name, count(*) 직원수
from emp join salary_grade on salary between low_sal and high_sal
         join dept on emp.dept_id = dept.dept_id
where grade = 1
group by dept_name
order by 2 desc ;

/* ###################################################################################### 
오라클 조인 
- Join할 테이블들을 from절에 나열한다.
- Join 연산은 where절에 기술한다. 

###################################################################################### */
-- 직원의 ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서이름(dept.dept_name)을 조회
-- 입사년도는 년도만 출력
select emp_id, emp_name, to_char(hire_date, 'yyyy'), dept_name
from emp, dept
where emp.dept_id = dept.dept_id;

-- 직원의 ID(emp.emp_id)가 100인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서이름(dept.dept_name)을 조회
-- 입사년도는 년도만 출력
select emp_id, emp_name, to_char(hire_date, 'yyyy'), dept_name
from emp, dept
where emp.dept_id = dept.dept_id and emp_id = 100;


-- 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 담당업무명(job.job_title), 소속부서이름(dept.dept_name)을 조회
select emp_id, emp_name, salary, job_title, dept_name
from emp, dept, job
where emp.dept_id = dept.dept_id and emp.job_id = job.job_id;


--TODO 200번대(200 ~ 299) 직원 ID(emp.emp_id)를 가진 직원들의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 오름차순으로 정렬.
select emp_id, emp_name, salary, dept_name, loc
from emp, dept
where emp.dept_id = dept.dept_id and emp_id between 200 and 299
order by 1;

--TODO 업무(emp.job_id)가 'FI_ACCOUNT'인 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무(emp.job_id), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회.  직원_ID의 오름차순으로 정렬.
select emp_id, emp_name, job_id, dept_name, loc
from emp, dept
where emp.dept_id = dept.dept_id and job_id = 'FI_ACCOUNT'
order by 1;


--TODO 커미션비율(emp.comm_pct)이 있는 직원들의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 커미션비율(emp.comm_pct), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 오름차순으로 정렬.
select emp_id, emp_name, salary, comm_pct, dept_name, loc
from emp, dept
where emp.dept_id = dept.dept_id and comm_pct is not null
order by 1;



--TODO 'New York'에 위치한(dept.loc) 부서의 부서_ID(dept.dept_id), 부서이름(dept.dept_name), 위치(dept.loc), 
--     그 부서에 소속된 직원_ID(emp.emp_id), 직원 이름(emp.emp_name), 업무(emp.job_id)를 조회. 부서_ID 의 오름차순으로 정렬.
select dept.dept_id, dept_name, loc, emp_id, emp_name, job_id
from emp, dept
where emp.dept_id = dept.dept_id and loc = 'New York'
order by emp_id;


--TODO 직원_ID(emp.emp_id), 이름(emp.emp_name), 업무_ID(emp.job_id), 업무명(job.job_title) 를 조회.
select emp_id, emp_name, emp.job_id, job_title
from emp, job
where emp.job_id = job.job_id;


             
-- TODO: 직원 ID 가 200 인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 
--       담당업무명(job.job_title), 소속부서이름(dept.dept_name)을 조회              
select emp_id, emp_name, salary, job_title, dept_name
from emp, job, dept
where emp.job_id = job.job_id and emp.dept_id = dept.dept_id and emp_id = 200;


-- TODO: 'Shipping' 부서의 부서명(dept.dept_name), 위치(dept.loc), 소속 직원의 이름(emp.emp_name), 업무명(job.job_title)을 조회. 
--       직원이름 내림차순으로 정렬
select dept_name, loc, emp_name, job_title
from emp, job, dept
where emp.job_id = job.job_id and emp.dept_id = dept.dept_id and dept_name = 'Shipping';

-- TODO:  'San Francisco' 에 근무(dept.loc)하는 직원의 id(emp.emp_id), 이름(emp.emp_name), 입사일(emp.hire_date)를 조회
--         입사일은 'yyyy-mm-dd' 형식으로 출력
select emp_id, emp_name, to_char(hire_date, 'yyyy-mm-dd')
from emp, dept
where emp.dept_id = dept.dept_id and loc = 'San Francisco';



--TODO 부서별 급여(salary)의 평균을 조회. 부서이름(dept.dept_name)과 급여평균을 출력. 급여 평균이 높은 순서로 정렬.
-- 급여는 , 단위구분자와 $ 를 붙여 출력.
select to_char(avg(salary), 'fm$99,999') 급여평균, dept_name
from emp, dept
where emp.dept_id = dept.dept_id
group by dept_name
order by avg(salary) desc;


--TODO 직원의 ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 급여등급(salary_grade.grade) 를 조회. 직원 id 오름차순으로 정렬
select emp_id, emp_name, salary, grade
from emp, salary_grade
where salary between low_sal and high_sal
order by 1;



--TODO 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 급여(emp.salary), 
--     급여등급(salary_grade.grade), 소속부서명(dept.dept_name)을 조회. 등급 내림차순으로 정렬
select emp_id, emp_name, job_title, salary, grade, dept_name
from emp, job, dept, salary_grade
where emp.job_id = job.job_id and emp.dept_id = dept.dept_id
      and salary between low_sal and high_sal
order by grade desc;

--TODO 급여등급이(salary_grade.grade) 1인 직원이 소속된 부서명(dept.dept_name)과 등급1인 직원의 수를 조회. 직원수가 많은 부서 순서대로 정렬.
select dept_name, count(*)
from dept, salary_grade, emp
where emp.dept_id = dept.dept_id
      and salary between low_sal and high_sal
      and grade = 1
group by dept_name
order by 2 desc;

/* ****************************************************
Self 조인
- 물리적으로 하나의 테이블을 두개의 테이블처럼 조인하는 것.
- 주로 계층관계 표현할 때 쓰임.
**************************************************** */
--직원의 ID(emp.emp_id), 이름(emp.emp_name), 상사이름(emp.emp_name)을 조회
select e.emp_id, e.emp_name 직원이름, m.emp_name 상사이름
from emp e join emp m on e.mgr_id = m.emp_id;

select e.emp_id, e.emp_name 직원이름, m.emp_name 상사이름
from emp e , emp m 
where e.mgr_id = m.emp_id;

-- TODO : EMP 테이블에서 직원 ID(emp.emp_id)가 110인 직원의 급여(salary)보다 많이 받는 
-- 직원들의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary)를 직원 ID(emp.emp_id) 오름차순으로 조회.
select e2.emp_id, e2.emp_name, e2.salary
from emp e1 join emp e2 on e1.salary < e2. salary
where e1.emp_id = 110
order by 1;

select e2.emp_id, e2.emp_name, e2.salary
from emp e1, emp e2
where e1.emp_id = 110 and e1.salary < e2.salary
order by 1;

/* ****************************************************
아우터 조인 (Outer Join)
-불충분 조인
    -조인 연산시 소스테이블의 행은 다 join하고 타겟테이블의 행은 조인 조건을 만족하면 붙이고 없으면 null처리.

1. left outer join: 구문상 소스 테이블이 왼쪽
2. right outer join: 구문상 소스 테이블이 오른쪽
3. full outer join: 둘 다 소스 테이블(오라클 조인문법은 지원안함.)

-ANSI 문법
from 테이블a [LEFT | RIGHT | FULL] (OUTER) JOIN 테이블b ON 조인조건
- OUTER는 생략 가능.

-오라클 JOIN 문법
- FROM 절에 조인할 테이블을 나열
- WHERE 절에 조인 조건을 작성
    - 타겟 테이블에 (+) 를 붙인다.
    - FULL OUTER JOIN은 지원하지 않는다.

**************************************************** */
-- 직원의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 부서명(dept.dept_name), 부서위치(dept.loc)를 조회. 
-- 부서가 없는 직원의 정보도 나오도록 조회. (부서정보는 null). dept_name의 내림차순으로 정렬한다.
select emp_id, emp_name, salary, dept_name, loc
from emp e left outer join dept d on e.dept_id = d.dept_id;
--오라클 문법
select emp_id, emp_name, salary, dept_name, loc
from emp e, dept d 
where e.dept_id = d.dept_id(+);


select d.dept_id, d.dept_name, d.loc, e.emp_name, e.hire_date
from emp e right join dept d on e.dept_id =  d.dept_id
where d.dept_id in (260, 270, 10, 60);
--오라클 문법
select d.dept_id, d.dept_name, d.loc, e.emp_name, e.hire_date
from emp e, dept d
where e.dept_id(+) =  d.dept_id and d.dept_id in (260, 270, 10, 60);

select d.dept_id, loc, emp_id, emp_name, salary
from dept d full outer join emp e on d.dept_id = e.dept_id
where emp_id in (100,175, 178) or d.dept_id in (260, 270, 10, 60);


-- 모든 직원의 id(emp.emp_id), 이름(emp.emp_name), 부서_id(emp.dept_id)를 조회하는데
-- 부서_id가 80 인 직원들은 부서명(dept.dept_name)과 부서위치(dept.loc) 도 같이 출력한다. (부서 ID가 80이 아니면 null이 나오도록)
select emp_id, emp_name, e.dept_id, 
       d.dept_id, dept_name, loc
from emp e left join dept d on e.dept_id = d.dept_id and e.dept_id = 80;
--오라클 조인
select emp_id, emp_name, e.dept_id, 
       d.dept_id, dept_name, loc
from emp e, dept d 
where e.dept_id = d.dept_id(+) and d.dept_id(+) = 80;




--TODO: 직원_id(emp.emp_id)가 100, 110, 120, 130, 140인 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title) 을 조회. 
--      업무명이 없을 경우 '미배정' 으로 조회
select emp_id, emp_name, decode(job_title, null, '미배정', job_title) job_title
from emp e left join job j on e.job_id = j.job_id
where emp_id in (100, 110, 120, 130, 140);

select emp_id, emp_name, decode(job_title, null, '미배정', job_title) job_title
from emp e, job j
where e.job_id = j.job_id(+) and emp_id in (100, 110, 120, 130, 140);

select emp_id, emp_name, nvl(job_title, '미배정') job_title
from emp e, job j
where e.job_id = j.job_id(+) and emp_id in (100, 110, 120, 130, 140);


--TODO: 부서의 ID(dept.dept_id), 부서이름(dept.dept_name)과 그 부서에 속한 직원들의 수를 조회. 
--      직원이 없는 부서는 0이 나오도록 조회하고 직원수가 많은 부서 순서로 조회.

--주의!! count(*)은 행의 수를 세므로 직원이 적어도 1이 나온다.
select d.dept_id, dept_name, count(emp_id)
from emp e right join dept d on e.dept_id = d.dept_id
group by d.dept_id, dept_name
order by 3 desc;

select d.dept_id, dept_name, count(emp_id)
from emp e, dept d 
where e.dept_id(+) = d.dept_id
group by d.dept_id, dept_name
order by 3 desc;

-- TODO: EMP 테이블에서 부서_ID(emp.dept_id)가 90 인 직원들의 id(emp.emp_id), 이름(emp.emp_name), 상사이름(emp.emp_name), 입사일(emp.hire_date)을 조회. 
-- 입사일은 yyyy-mm-dd 형식으로 출력
-- 상사가가 없는 직원은 '상사 없음' 출력
select e1.emp_id, e1.emp_name 직원이름, 
--       decode(e2.emp_name, null, '상사 없음', e2.emp_name) 상사이름,
       nvl(e2.emp_name, '상사없음') 상사이름,
       to_char(e1.hire_date, 'yyyy-mm-dd')
from emp e1 left join emp e2 on e1.mgr_id = e2.emp_id
where e1.dept_id = 90;



--TODO 2003년~2005년 사이에 입사한 직원의 id(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 급여(emp.salary), 입사일(emp.hire_date),
--     상사이름(emp.emp_name), 상사의입사일(emp.hire_date), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회.
-- 단 상사가 없는 직원의 경우 상사이름, 상사의입사일을 null로 출력.
-- 부서가 없는 직원의 경우 null로 조회
select e1.emp_id 직원id, e1.emp_name 직원이름, j.job_title 업무명, e1.salary 급여, e1.hire_date 입사일,
       e2.emp_name 상사이름, e2.hire_date 상사입사일, d.dept_name 소속부서, d.loc 부서위치
from emp e1 left join job j on e1.job_id = j.job_id
            left join emp e2 on e1.mgr_id = e2.emp_id
            left join dept d on e1.dept_id = d.dept_id
where to_char(e1.hire_date, 'yyyy') between 2003 and 2005
order by 1;




