
/* ***********************************************************************************************
변수 사용
- 변수 선언
  - DECLARE 절에서 한다.
  - 구문: 변수명 [CONSTANT] 데이터타입 [NOT NULL] [ := 기본값] 
     - CONSTANT : 값을 변경할 수 없는 변수. 선언시 반드시 초기화 해야 한다.
	 - 데이터타입: 오라클 데이터타입+PL/SQL 데이터타입 지정한다.
	 - NOT NULL: 변수가 NULL을 가져선 안됨을 제약조건으로 지정. 선언시 반드시 초기화 되야함.
	 - 선언시 [DEFAULT 값] 으로 초기값 선언 가능
  - 대입연산자
     -  변수 := 값
  

*********************************************************************************************** */

declare
--변수명(identifier) 데이터 타입       
    v_message1      varchar2(100); --null로 초기화
    v_message2 varchar2(100) not null := 'Hello World!';
    c_num constant pls_integer default 20; 
    --not null변수와 constant(상수)는 선언시 초기화 해야한다.
begin
    v_message1 := 'Test1';
    dbms_output.put_line(v_message1);
    
    v_message2 := '&msg';
    dbms_output.put_line(v_message2);
    
--    c_num := 5000; --상수에는 값을 재할당 할 수 없다.
    dbms_output.put_line(c_num);

end;
/
-- TODO: DECLARE 에서 본인 정보를 저장할 변수들(이름, 나이, 주소 등등)을 선언하고 실행 블록(BEGIN)에서 값을 대입한 뒤 출력하는 코드 작성.
declare 
    v_name nvarchar2(10);
    v_age pls_integer;
    v_address nvarchar2(50);
begin
    v_name := '홍길동';
    v_age := 55;
    v_address := '서울시 강남구 ...';
    
    dbms_output.put_line('이름: '||v_name);
    dbms_output.put_line('나이: '||v_age);
    dbms_output.put_line('주소: '||v_address);
end;
/



-- TODO: emp 테이블의 이름(emp_name), 급여(salary), 커미션비율(comm_pct), 입사일(hire_date) 를 값을 저장할 수 있는 변수를 선언하고
-- &변수를 이용해 값을 입력 받아 출력하는 코드를 작성.
DECLARE
    v_emp_name varchar(20);
    v_salary number(7, 2);
    v_comm_pct number(2, 2);
    v_hire_date date;
BEGIN
    v_emp_name := '&emp_name';
    v_salary := &salary;
    v_comm_pct := &comm_pct;
    v_hire_date := '&date';

    dbms_output.put_line(v_emp_name||', '||v_salary||', '||v_comm_pct||', '||v_hire_date);
END;
/


/* **********************************************************
- %TYPE 속성
  - 컬럼의 데이터타입을 이용해 변수의 타입 선언된
  - 구문:   테이블명.컬럼%TYPE
    ex) v_emp_id emp.emp_id%TYPE
*********************************************************** */
-- dept 테이블의 컬럼들의 데이터 타입을 이용해 변수 선언
DECLARE
  v_dept_id dept.dept_id%TYPE;
  v_dept_name dept.dept_name%TYPE := '없음';
  v_loc dept.loc%TYPE;
BEGIN
  v_dept_id := 2000;
  v_loc := '서울';
  DBMS_OUTPUT.PUT_LINE(v_dept_id||', '||v_dept_name||', '||v_loc);
END;
/
-- TODO: job 테이블의 컬럼들의 타입을 이용해 v_job_id, v_job_title, v_max_salary, v_min_salary 를 생성하고 & 변수를 이용해 값을 입력 받아 출력하는 코드 작성
DECLARE
  v_job_id job.job_id%TYPE;
  v_job_title job.job_title%TYPE;
  v_max_salary job.max_salary%TYPE;
  v_min_salary job.min_salary%TYPE;
BEGIN
  v_job_id := '&id';
  v_job_title := '&title';
  v_max_salary := &max_sal;
  v_min_salary := &min_sal;
  
  DBMS_OUTPUT.PUT_LINE(v_job_id||', '||v_job_title||', '||v_max_salary||', '||v_min_salary);
END;
/
desc job;

/* ***************************************
바인드 변수, 호스트 변수

-선언
variable 변수명 타입; = var 변수명 타입;
var name varchar2(100);
-사용
:변수명
:name 

*************************************** */
var e_id number;
exec :e_id := 200;

select * from emp
where emp_id = :e_id;


/* ******************************************************************
 PL/SQL에서 시퀀스(Sequence) 사용
 - select 구문없이 sequence이름.nextval 로 바로호출 가능.
********************************************************************* */
create sequence t_seq;

declare
    v_num number;
begin
    v_num := t_seq.nextval;
    DBMS_OUTPUT.PUT_LINE(v_num);
    DBMS_OUTPUT.PUT_LINE(t_seq.currval); 
end;
/






/* ****************************************************************
프로시저에서 함수 사용
 - 문자/숫자/날짜/변환 함수는 처리결과가 1개일 때 실행 구문에서 단독으로 사용할 수 있다.
 - 집계함수와 DECODE() 함수는 SQL문에서만 사용할 수 있다. 
******************************************************************* */
BEGIN
    DBMS_OUTPUT.PUT_LINE(length('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'));
END;


-- TODO: 다음을 순서대로 출력하는 코드를 작성
/*
"서울시 강남구 역삼동" 문자열의 길이를 출력
"Hello World" 를 대문자로 출력
100.23456 를 소숫점 첫번째 이하에서 반올림 해서 출력
SYSDATE에서 시:분:초 를 출력
*/
BEGIN
    DBMS_OUTPUT.PUT_LINE(LENGTH('서울시 강남구 역삼동'));
    DBMS_OUTPUT.PUT_LINE(UPPER('Hello World'));
    DBMS_OUTPUT.PUT_LINE(ROUND(100.23456, 1));
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'HH24:MI:SS'));
END;
/

/* *************************************************************
중첩 구문
- PL/SQL 실행블록내에 PL/SQL 구문을 중첩해서 작성할 수 있다.
- 안쪽 실행블록에서는 바깥쪽 실행구문에서 선언한 변수를 사용할 수 있지만 반대는 안된다.
*************************************************************** */

DECLARE
    v_outer varchar2(100) := 'v_outer';
BEGIN
    declare
        v_inner varchar2(100) := 'v_inner';
    begin
        DBMS_OUTPUT.PUT_LINE('INNER: '||v_outer); --outer의 변수를 inner에서 사용 가능.
        DBMS_OUTPUT.PUT_LINE('INNER: '||v_inner);
    end;
    DBMS_OUTPUT.PUT_LINE('OUTER: '||v_outer);
--    DBMS_OUTPUT.PUT_LINE('OUTER: '||v_inner); --inner에서 선언된 변수는 outer에서 사용 불가능.
END;
/
begin <<outer_p>>
    DECLARE
        v_outer varchar2(100) := 'v_outer';
    BEGIN
        declare
            v_inner varchar2(100) := 'v_inner';
            v_outer number := 30;
        begin
            DBMS_OUTPUT.PUT_LINE('INNER: '||v_outer);
            DBMS_OUTPUT.PUT_LINE('INNER: '||outer_p.v_outer); --outer 프로시저에 이름부여.
            DBMS_OUTPUT.PUT_LINE('INNER: '||v_inner);
        end;
        DBMS_OUTPUT.PUT_LINE('OUTER: '||v_outer);
    END;
end;
/
/* *************************************************************************************	

DML 구문
- insert/delete/update
- SQL은 동일
- 처리후 commit

************************************************************************************* */

drop table dept_copy;
create table dept_copy
as
select * from dept;

--insert
DECLARE
  v_dept_id dept.dept_id%TYPE;
  v_dept_name dept.dept_name%TYPE;
  v_loc dept.loc%TYPE;
BEGIN
  v_dept_id := :id;
  v_dept_name := :name;
  v_loc := :loc;
  
  INSERT INTO dept_copy VALUES (v_dept_id, v_dept_name, v_loc);
  v_dept_name := '연구소';
  v_loc := '부산';
  INSERT INTO dept_copy VALUES (v_dept_id + 1, v_dept_name, v_loc);
  INSERT INTO dept_copy VALUES (v_dept_id + 2, v_dept_name, v_loc);
  commit;
END;
/
rollback;
select * from dept_copy order by 1 desc;

--delete
BEGIN
  delete from dept_copy where loc = '서울'; 
END;
/

--update
DECLARE
    v_loc dept.loc%type := :loc;
    v_dept_id dept.dept_id%type := :dept_id;
BEGIN
  update dept_copy 
  set loc = v_loc
  where dept_id = v_dept_id;
  commit;
END;
/

select * from dept_copy;

create table emp_test
as
select emp_id, emp_name, salary 
from emp;

select * from emp_test;
-- TODO : emp 테이블에 새로운 세개행을 추가하는 구문을 작성.
DECLARE
  v_emp_id emp.emp_id%TYPE := :emp_id ;
  v_emp_name emp.emp_name%TYPE := :emp_name;
  v_salary emp.salary%TYPE := :salary;
BEGIN
  insert into emp_test values (v_emp_id, v_emp_name, v_salary);
  insert into emp_test values (v_emp_id + 1, v_emp_name, v_salary);
  insert into emp_test values (v_emp_id + 2, v_emp_name, v_salary);
  commit;
END;
/

-- TODO : 위에서 추가한 세개 행의 salary와 comm_pct 의 값을 세배 올리는 구문을 작성
DECLARE
    v_emp_name emp.emp_name%TYPE := :emp_name;
BEGIN
  update emp_test set salary = salary * 3
  where emp_name = v_emp_name;
  commit;
END;
/

-- TODO : 위에서 추가한 세개 행을 삭제하는 구문을 작성
DECLARE
    v_emp_name emp.emp_name%TYPE := :emp_name;
BEGIN
  delete from emp_test where emp_name = v_emp_name;
  commit;
END;
/

/* *************************************************************************************
조회구문
select into 문 

select 조회컬럼
INTO   조회값을 저장할 변수
from 테이블
where 제약조건
group by 
having
order by

************************************************************************************* */

-- 부서 ID(dept_id)가 10인 부서의 이름(dept_name), 위치(loc) 를 조회하는 구문
DECLARE
  v_dept_name dept.dept_name%TYPE;
  v_loc dept.loc%TYPE;
BEGIN
  SELECT dept_name, loc
  INTO  v_dept_name, v_loc
  FROM dept 
  WHERE dept_id = 10;
  
  DBMS_OUTPUT.PUT_LINE('부서이름: '||v_dept_name||', '||'위치: '||v_loc);
END;
/

--직원 id(emp.emp_id) 가 110 인 직원의 이름(emp.emp_name), 급여(emp.salary), 부서 ID(dept.dept_id) 부서이름(dept.dept_name) 출력하는 구문작성
DECLARE
  v_emp_name emp.emp_name%TYPE;
  v_salary emp.salary%TYPE;
  v_dept_id dept.dept_id%TYPE;
  v_dept_name dept.dept_name%TYPE;
BEGIN
  SELECT emp_name, salary, d.dept_id, dept_name
  INTO v_emp_name, v_salary, v_dept_id, v_dept_name
  FROM emp e, dept d
  WHERE e.dept_id = d.dept_id(+) and emp_id = 110;
  
  DBMS_OUTPUT.PUT_LINE(v_emp_name||', '||v_salary||', '||v_dept_id||', '||v_dept_name);
END;
/


-- TODO 직원의 ID가 120인 직원의 이름(emp.emp_name), 급여(emp.salary), 업무_ID (emp.job_id), 입사일(emp.hire_date)를 출력하는 구문 작성
DECLARE
  v_emp_name emp.emp_name%TYPE;
  v_salary emp.salary%TYPE;
  v_job_id emp.job_id%TYPE;
  v_hire_date emp.hire_date%TYPE;
BEGIN
  SELECT emp_name, salary, job_id, hire_date
  INTO v_emp_name, v_salary, v_job_id, v_hire_date 
  FROM emp
  WHERE emp_id = 120;
  
  DBMS_OUTPUT.PUT_LINE('이름: '||v_emp_name);
  DBMS_OUTPUT.PUT_LINE('급여: '||v_salary);
  DBMS_OUTPUT.PUT_LINE('업무: '||v_job_id);
  DBMS_OUTPUT.PUT_LINE('입사일: '||v_hire_date);
END;
/

-- TODO 부서테이블에 dept_id=9900, dept_name='경영기획', loc='서울' 을 insert 하고 dept_id로 조회하여 입력결과를 출력하는 구문을 작성.
DECLARE
    v_dept_id dept.dept_id%TYPE;
    v_dept_name dept.dept_name%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    insert into dept values (9900, '경영기획', '서울');
    SELECT dept_id, dept_name, loc
    INTO v_dept_id, v_dept_name, v_loc
    FROM dept
    WHERE  dept_id = 9900;
    commit;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_id||', '||v_dept_name||', '||v_loc);
    
END;
/

rollback;

-- TODO 직원_ID가 110인 직원의 이름(emp.emp_name), 업무 ID(emp.job_id), 업무명(job.job_title) 출력하는 구문 작성
DECLARE
  v_emp_name emp.emp_name%TYPE;
  v_job_id emp.job_id%TYPE;
  v_job_title job.job_title%TYPE;
BEGIN
  SELECT emp_name, e.job_id, job_title
  INTO v_emp_name, v_job_id, v_job_title
  FROM emp e, job j
  WHERE e.job_id = j.job_id(+) and emp_id = 110;
  
  DBMS_OUTPUT.PUT_LINE(v_emp_name||', '||v_job_id||', '||v_job_title);
END;
/










