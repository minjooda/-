/* **************************************************************************
서브쿼리(Sub Query)
- 쿼리안에서 select 쿼리를 사용하는 것.
- 메인 쿼리 - 서브쿼리

서브쿼리가 사용되는 구
 - select절, from절, where절, having절
 
서브쿼리의 종류
- 어느 구절에 사용되었는지에 따른 구분
    - 스칼라 서브쿼리 - select 절에 사용. 반드시 서브쿼리 결과가 1행 1열(값 하나-스칼라) 0행이 조회되면 null을 반환
    - 인라인 뷰 - from 절에 사용되어 테이블의 역할을 한다.
서브쿼리 조회결과 행수에 따른 구분
    - 단일행 서브쿼리 - 서브쿼리의 조회결과 행이 한행인 것.
    - 다중행 서브쿼리 - 서브쿼리의 조회결과 행이 여러행인 것.
동작 방식에 따른 구분
    - 비상관(비연관) 서브쿼리 - 서브쿼리에 메인쿼리의 컬럼이 사용되지 않는다. 메인쿼리에 사용할 값을 서브쿼리가 제공하는 역할을 한다.
    - 상관(연관) 서브쿼리 - 서브쿼리에서 메인쿼리의 컬럼을 사용한다. 
                            메인쿼리가 먼저 수행되어 읽혀진 데이터를 서브쿼리에서 조건이 맞는지 확인하고자 할때 주로 사용한다.
************************************************************************** */
-- 직원_ID(emp.emp_id)가 120번인 직원과 같은 업무(emp.job_id)가진 
-- 직원의 id(emp_id),이름(emp.emp_name), 업무(emp.job_id), 급여(emp.salary) 조회
select emp_id, emp_name, job_id, salary
from emp
where job_id = (select job_id from emp where emp_id = 120); --반드시 ()로 묶어줘야 한다.


-- 직원_id(emp.emp_id)가 115번인 직원과 같은 업무(emp.job_id)를 하고 같은 부서(emp.dept_id)에 속한 직원들을 조회하시오.
select *
from emp
/*where job_id = (select job_id from emp where emp_id = 115) and
      dept_id = (select dept_id from emp where emp_id = 115);*/
where (job_id, dept_id) = (select job_id, dept_id from emp where emp_id = 115); 
--pair 방식 서브쿼리.
--pair 방식은 서브쿼리일 경우만 가능.


-- 직원들 중 급여(emp.salary)가 전체 직원의 평균 급여보다 적은 
-- 직원들의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary)를 조회. 급여(emp.salary) 오름차순 정렬.
select emp_id, emp_name, salary
from emp
where salary < (select avg(salary) from emp)
order by salary;



-- 전체 직원의 평균 급여(emp.salary) 이상을 받는 부서의  이름(dept.dept_name), 소속직원들의 평균 급여(emp.salary) 출력. 
-- 평균급여는 소숫점 2자리까지 나오고 통화표시($)와 단위 구분자 출력
select dept_name, to_char(avg(salary), '$99,999.99') 평균급여
from emp, dept
where emp.dept_id = dept.dept_id(+)
group by dept_name
having avg(salary) >= (select avg(salary) from emp);



-- TODO: 직원의 ID(emp.emp_id)가 145인 직원보다 많은 연봉을 받는 직원들의 이름(emp.emp_name)과 급여(emp.salary) 조회.
-- 급여가 큰 순서대로 조회
select emp_name, salary
from emp
where salary > (select salary from emp where emp_id = 145);


-- TODO: 직원의 ID(emp.emp_id)가 150인 직원과 같은 업무(emp.job_id)를 하고 같은 상사(emp.mgr_id)를 가진 직원들의 
-- id(emp.emp_id), 이름(emp.emp_name), 업무(emp.job_id), 상사(emp.mgr_id) 를 조회
select emp_id, emp_name, job_id, mgr_id
from emp
where (job_id, mgr_id) = (select job_id, mgr_id from emp where emp_id = 150);



-- TODO : EMP 테이블에서 직원 이름이(emp.emp_name)이  'John'인 직원들 중에서 급여(emp.salary)가 가장 높은 직원의 salary(emp.salary)보다 많이 받는 
-- 직원들의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary)를 직원 ID(emp.emp_id) 오름차순으로 조회.
select emp_id, emp_name, salary
from emp
where salary > (select max(salary) from emp where emp_name = 'John')
order by 1;


-- TODO: 급여(emp.salary)가 가장 높은 직원이 속한 부서의 이름(dept.dept_name), 위치(dept.loc)를 조회.
select dept_name, loc
from dept d, emp e
where d.dept_id(+)= e.dept_id and salary = (select max(salary) from emp);



-- TODO: 30번 부서(emp.dept_id) 의 평균 급여(emp.salary)보다 급여가 많은 직원들의 모든 정보를 조회.
select *
from emp
where salary > (select avg(salary) from emp where dept_id = 30);


-- TODO: 담당 업무ID(emp.job_id) 가 'ST_CLERK'인 직원들의 평균 급여보다 적은 급여의 직원를 받는 직원들의 모든 정보를 조회. 단 업무 ID가 'ST_CLERK'이 아닌 직원들만 조회. 
select *
from emp
where salary < (select avg(salary) from emp where job_id = 'ST_CLERK') and
      job_id != 'ST_CLERK';


-- TODO: 급여(emp.salary)를 제일 많이 받는 직원들의 이름(emp.emp_name), 부서명(dept.dept_name), 급여(emp.salary) 조회. 
--       급여는 앞에 $를 붙이고 단위구분자 , 를 출력
select emp_name, dept_name, to_char(salary, '$99,999')
from emp e, dept d
where e.dept_id = d.dept_id(+) and salary = (select max(salary) from emp);
 


-- TODO: EMP 테이블에서 업무(emp.job_id)가 'IT_PROG' 인 직원들의 평균 급여 이상을 받는 
-- 직원들의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary)를 급여 내림차순으로 조회.
select emp_id, emp_name, salary
from emp
where salary >= (select avg(salary) from emp where job_id = 'IT_PROG')
order by 3 desc;


-- TODO: 'IT' 부서(dept.dept_name)의 최대 급여보다 많이 받는 직원의 ID(emp.emp_id), 이름(emp.emp_name), 입사일(emp.hire_date), 부서 ID(emp.dept_id), 급여(emp.salary) 조회
-- 입사일은 "yyyy년 mm월 dd일" 형식으로 출력
-- 급여는 앞에 $를 붙이고 단위구분자 , 를 출력
select emp_id, emp_name, 
       to_char(hire_date, 'yyyy"년" mm"월" dd"일"') hire_date,
       dept_id, to_char(salary, '$99,999') salary
from emp
where salary > (select max(salary) from emp e, dept d 
                where e.dept_id = d.dept_id and dept_name = 'IT');



/* ----------------------------------------------
 다중행 서브쿼리
 - 서브쿼리의 조회 결과가 여러행인 경우
 - where절 에서의 연산자
	- in
	- 비교연산자 any : 조회된 값들 중 하나만 참이면 참 (where 컬럼 > any(서브쿼리) ) = ? > min()
	- 비교연산자 all : 조회된 값들 모두와 참이면 참 (where 컬럼 > all(서브쿼리) ) = ? > max()
------------------------------------------------*/
--'Alexander' 란 이름(emp.emp_name)을 가진 관리자(emp.mgr_id)의 
-- 부하 직원들의 ID(emp_id), 이름(emp_name), 업무(job_id), 입사년도(hire_date-년도만출력), 급여(salary)를 조회
-- 급여는 앞에 $를 붙이고 단위구분자 , 를 출력
select emp_id, emp_name, job_id, extract(year from hire_date), salary
from emp
where mgr_id in (select emp_id from emp where emp_name = 'Alexander');

select *
from emp
where emp_name = 'Alexander';
-- 직원 ID(emp.emp_id)가 101, 102, 103 인 직원들 보다 급여(emp.salary)를 많이 받는 직원의 모든 정보를 조회.
select *
from emp
where salary > all(select salary from emp where emp_id in (101, 102, 103));

select *
from emp
where salary > (select max(salary) from emp where emp_id in (101, 102, 103));


-- 직원 ID(emp.emp_id)가 101, 102, 103 인 직원들 중 급여가 가장 적은 직원보다 급여를 많이 받는 직원의 모든 정보를 조회.
select *
from emp
where salary > any(select salary from emp where emp_id in (101, 102, 103));

select *
from emp
where salary > (select min(salary) from emp where emp_id in (101, 102, 103));


-- TODO : 부서 위치(dept.loc) 가 'New York'인 부서에 소속된 직원의 ID(emp.emp_id), 이름(emp.emp_name), 부서_id(emp.dept_id) 를 sub query를 이용해 조회.
select * from dept where loc = 'New York';

select emp_id, emp_name, dept_id
from emp 
where dept_id in (select dept_id from dept where loc = 'New York');



-- TODO : 최대 급여(job.max_salary)가 6000이하인 업무를 담당하는 직원(emp)의 모든 정보를 sub query를 이용해 조회.
select *
from emp
where job_id in (select job_id from  job where max_salary <= 6000);




-- TODO: 부서_ID(emp.dept_id)가 20인 부서의 직원들 보다 급여(emp.salary)를 많이 받는 직원들의 정보를  sub query를 이용해 조회.
select *
from emp
where salary > all(select salary from emp where dept_id = 20);

select *
from emp
where salary > (select max(salary) from emp where dept_id = 20);


-- TODO: 부서별 급여의 평균중 가장 적은 부서의 평균 급여보다 보다 많이 받는 사원들이 이름, 급여, 업무를 서브쿼리를 이용해 조회
select emp_name, salary, job_id
from emp
where salary > any(select avg(salary) from emp group by job_id);

select emp_name, salary, job_id
from emp
where salary > (select min(avg(salary)) from emp group by job_id);


-- TODO: 업무 id(job_id)가 'SA_REP' 인 직원들중 가장 많은 급여를 받는 직원보다 많은 급여를 받는 직원들의 이름(emp_name), 급여(salary), 업무(job_id) 를 subquery를 이용해 조회.
select emp_name, salary, job_id
from emp
where salary > all(select salary from emp where job_id = 'SA_REP');

select emp_name, salary, job_id
from emp
where salary > (select max(salary) from emp where job_id = 'SA_REP');


/* ****************************************************************
상관(연관) 쿼리
메인쿼리문의 조회값을 서브쿼리의 조건에서 사용하는 쿼리.
메인쿼리를 실행하고 그 결과를 바탕으로 서브쿼리의 조건절을 비교한다.
* ****************************************************************/
-- 부서별(DEPT) 급여(emp.salary)를 가장 많이 받는 직원들의 id(emp.emp_id), 이름(emp.emp_name), 연봉(emp.salary), 소속부서ID(dept.dept_id) 조회

select emp_id, emp_name, salary, dept_id
from emp e
where salary = (select max(salary) from emp where dept_id = e.dept_id);

select max(salary) from emp group by dept_id;


/* ******************************************************************************************************************
EXISTS, NOT EXISTS 연산자 (상관(연관)쿼리와 같이 사용된다)
-- 서브쿼리의 결과를 만족하는 값이 존재하는지 여부를 확인하는 조건. 조건을 만족하는 행이 여러개라도 한행만 있으면 더이상 검색하지 않는다.
**********************************************************************************************************************/


-- 직원이 한명이상 있는 부서의 부서ID(dept.dept_id)와 이름(dept.dept_name), 위치(dept.loc)를 조회
select dept_id, dept_name, loc
from dept d
where exists (select emp_id from emp where dept_id = d.dept_id)
order by 1;


-- 직원이 한명도 없는 부서의 부서ID(dept.dept_id)와 이름(dept.dept_name), 위치(dept.loc)를 조회
select dept_id, dept_name, loc
from dept d
where not exists (select 1 from emp where dept_id = d.dept_id);
                    --반환 값이 있는지 없는지만 확인하기 때문에 결과 값이 중요하지는 않다.


-- 부서(dept)에서 연봉(emp.salary)이 13000이상인 한명이라도 있는 부서의 부서ID(dept.dept_id)와 이름(dept.dept_name), 위치(dept.loc)를 조회
select dept_id, dept_name, loc
from dept d
where exists (select 1 from emp where dept_id = d.dept_id and salary >= 13000);



/* ******************************
주문 관련 테이블들 이용.
******************************* */

--TODO: 고객(customers) 중 주문(orders)을 한번 이상 한 고객들을 조회.
select *
from customers c
where EXISTS (SELECT cust_id FROM orders WHERE cust_id = c.cust_id);

--TODO: 고객(customers) 중 주문(orders)을 한번도 하지 않은 고객들을 조회.
select *
from customers c
where not EXISTS (SELECT cust_id FROM orders WHERE cust_id = c.cust_id);

--TODO: 제품(products) 중 한번이상 주문된 제품 정보 조회
select * 
from products p
where exists (select product_id from order_items where product_id = p.product_id);

--TODO: 제품(products)중 주문이 한번도 안된 제품 정보 조회
select * 
from products p
where not exists (select product_id from order_items where product_id = p.product_id);

/*
inline-view: subquery를 from절에서 사용.
 - subquery의 조회결과를 테이블로 해서 main쿼리가 실행한다.
 
*/
--inline view의 서브쿼리에서 컬럼 별칭을 지정하면 main쿼리에서는 별칭을 사용해야 한다.
select *
from (select emp_id, emp_name, job_id, dept_id
        from emp
        where dept_id = 60) e, dept d
where e.dept_id = d.dept_id;

--inline view를 이용한 n-top 쿼리(조회)
    --salary 상위 5개, 하위 3개를 조회.
    --ROWNUM컬럼: 조회결과 행번호를 변환.

select rownum, emp_id, emp_name
from emp
where rownum <= 5;

--salary가 높은 5명의 조회
select rownum, emp_id, emp_name, salary
from (select * from emp order by salary desc)
where rownum <= 5;

--salary 높은 순서 5-10인 직원정보 조회
select rank 순위, emp_id, emp_name, salary, e.dept_id, dept_name
from ( select rownum rank, emp_id, emp_name, salary, dept_id
       from (select * from emp order by salary desc)) e,
       dept d
where e.dept_id = d.dept_id(+) and --dept과 조인을 하면서 순서가 바뀐다.
      rank between 5 and 10;

select *
from ( select rownum rank, emp_id, emp_name, salary, dept_id, dept_name
       from (select emp_id, emp_name, salary, e.dept_id, dept_name
             from emp e, dept d
             where e.dept_id = d.dept_id(+)
             order by salary desc)
     )
where rank between 5 and 10;

--입사일이 빠른 직원 10명
select rownum, emp_name, hire_date
from (select rownum, emp_name, hire_date from emp
      order by hire_date)
where rownum <= 10;

--입사일이 늦은 직원 10명
select rownum, emp_name, hire_date
from (select rownum, emp_name, hire_date from emp
      order by hire_date desc)
where rownum <= 10;