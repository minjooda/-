/* *********************************************************************
프로시저
 - 특정 로직을 처리하는 재사용가능한 서브 프로그램
 - 작성후 실행되면 컴파일 되어 객체로 오라클에 저장되며 EXECUTE나 EXEC 명령어로 필요시마다 재사용가능
구문
CREATE [OR REPLACE] PROCEDURE 이름 [(파라미터 선언,..)]
IS
    [변수 선언]
BEGIN
    실행구문
[EXCEPTION
    예외처리구문]
END;

- 파라미터 선언
  - 개수 제한 없음
  - 구문 : 변수명 mode 타입 [:=초기값]
    - mode
      - IN : 기본. 호출하는 곳으로 부터 값을 전달 받아 프로시저 내에서 사용. 읽기 전용변수. 
      - OUT : 호출하는 곳으로 전달할 값을 저장할 변수. (결과값 return)
      - IN OUT : IN과 OUT의 기능을 모두 하는 변수
	- 타입에 size는 지정하지 않는다. 
	- 초기값이 없는 매개변수는 호출시 반드시 값이 전달되야 한다.


실행
exec 이름[(전달값)]
execute 이름[(전달값)]

프로시저 제거
- DROP PROCEDURE 프로시저이름

*********************************************************************** */
set serveroutput on;

drop procedure message_sp1;
create or replace procedure message_sp1
is
    --변수선언.
    v_msg varchar2(100);
begin
    --실행구문 작성.
    v_msg := 'Hello World!';
    dbms_output.put_line(v_msg);
end;
/ --ctrl + enter키: 오라클 서버에 저장.

--실행
execute message_sp1;
exec message_sp1;
/
create or replace procedure message_sp2 (p_msg in varchar2 := 'Hello World!')
is
    v_msg varchar2(100);
begin
    DBMS_OUTPUT.PUT_LINE(p_msg);
--    p_msg := '새메세지';--in모드 파라미터는 값 변경이 안된다.
    v_msg := p_msg;
    dbms_output.put_line(v_msg);
    v_msg := '새메세지';
    dbms_output.put_line(v_msg);
end;
/
execute message_sp2('안녕하세요.');
execute message_sp2('HI~~~');
execute message_sp2;

create or replace procedure message_sp3 (p_msg in varchar2, p_num pls_integer)
is
begin
    DBMS_OUTPUT.PUT_LINE(p_msg||p_num);  
end;
/
execute message_sp3('안녕하세요.', 10);

create or replace procedure message_sp4(p_msg in out varchar2) --반환값을 저장할 변수를 받는다.
is
begin
    DBMS_OUTPUT.PUT_LINE(p_msg);
    p_msg := 'message_sp4에서의 메세지';
end;
/

create or replace procedure caller_sp
is
    v_msg varchar2(100);
begin
    --message_sp4를 호출 - 메세지를 반환하는 sp.
    v_msg := '기본값';
    
    message_sp4(v_msg);
    DBMS_OUTPUT.PUT_LINE(v_msg);
end;
/

exec caller_sp;

--매개변수로 부서ID, 부서이름, 위치를 받아 DEPT에 부서를 추가하는 Stored Procedure 작성
create or replace procedure add_dept(p_dept_id in dept.dept_id%TYPE, 
                                     p_dept_name in dept.dept_name%TYPE,
                                     p_loc in dept.loc%TYPE)
is
begin
    insert into dept values(p_dept_id, p_dept_name, p_loc);
    commit;
end;
/

exec add_dept(5000, 'iot service', 'gangnam');

select * from dept where dept_id = 20;


--매개변수로 부서ID를 파라미터로 받아 조회하는 Stored Procedure
create or replace procedure search_dept(p_dept_id in dept.dept_id%TYPE)
is
    v_dept dept%rowtype;
begin
    select *
    into v_dept
    from dept
    where dept_id = p_dept_id;
    
    DBMS_OUTPUT.PUT_LINE(v_dept.dept_id||', '||v_dept.dept_name||', '||v_dept.loc);
    
    if v_dept.loc = 'New York' then
        update dept
        set loc = 'Seoul'
        where dept_id = p_dept_id;
    end if;
    
    DBMS_OUTPUT.PUT_LINE(v_dept.dept_id||', '||v_dept.dept_name||', '||v_dept.loc);
    commit;
end;
/


exec search_dept(20);


-- TODO 직원의 ID를 파라미터로 받아서 직원의 이름(emp.emp_name), 급여(emp.salary), 업무_ID (emp.job_id), 입사일(emp.hire_date)를 출력하는 Stored Procedure 를 구현
EXEC TODO_01_sp(100);
EXEC TODO_01_sp(110);

create or replace procedure TODO_01_sp(p_emp_id in emp.emp_id%TYPE)
is
    v_emp emp%rowtype;
begin
    select *
    into v_emp
    from emp
    where emp_id = p_emp_id;
    
    DBMS_OUTPUT.PUT_LINE(v_emp.emp_name||', '||v_emp.salary||', '||v_emp.job_id||', '||v_emp.hire_date);
end;
/

-- TODO 업무_ID(job.job_id)를 파라미터로 받아서 업무명(job.job_title)과 업무최대/최소 급여(job.max_salary, min_salary)를 출력하는 Stored Procedure 를 구현
EXEC TODO_02_sp('FI_ACCOUNT');
EXEC TODO_02_sp('IT_PROG');
create or replace procedure TODO_02_sp(p_job_id in job.job_id%TYPE)
is
    v_job job%rowtype;
begin
    select *
    into v_job
    from job
    where job_id = p_job_id;
    
    DBMS_OUTPUT.PUT_LINE('업무명: '||v_job.job_title);
    DBMS_OUTPUT.PUT_LINE('최대급여: '||v_job.max_salary);
    DBMS_OUTPUT.PUT_LINE('최소급여: '||v_job.min_salary);
end;
/

    
-- TODO: 직원_ID를 파라미터로 받아서 직원의 이름(emp.emp_name), 업무 ID(emp.job_id), 업무명(job.job_title) 출력하는 Stored Procedure 를 구현

EXEC TODO_03_sp(110);
EXEC TODO_03_sp(200);

create or replace procedure TODO_03_sp(p_emp_id in emp.emp_id%TYPE)
is
    v_emp_name emp.emp_name%TYPE;
    v_job_id emp.job_id%TYPE;
    v_job_title job.job_title%TYPE;
begin
    select emp_name, e.job_id, job_title
    into v_emp_name, v_job_id, v_job_title
    from emp e, job j
    where e.job_id = j.job_id(+) and emp_id = p_emp_id;
    
    DBMS_OUTPUT.PUT_LINE(v_emp_name||' '||v_job_id||' '||v_job_title);
end;
/



-- TODO 직원의 ID를 파라미터로 받아서 직원의 이름(emp.emp_name), 급여(emp.salary), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 출력하는 Stored Procedure 를 구현
EXEC TODO_04_sp(100);
EXEC TODO_04_sp(120);
create or replace procedure TODO_04_sp(p_emp_id in emp.emp_id%TYPE)
is
    v_emp_name emp.emp_name%TYPE;
    v_salary emp.salary%TYPE;
    
    v_dept_name dept.dept_name%TYPE;
    v_loc dept.loc%TYPE;
begin
    select emp_name, salary, dept_name, loc
    into v_emp_name, v_salary, v_dept_name, v_loc
    from emp e, dept d
    where e.dept_id = d.dept_id(+) and emp_id = p_emp_id;
    
    DBMS_OUTPUT.PUT_LINE(v_emp_name||'/ '||v_salary||'/ '||v_dept_name||'/ '||v_loc);
end;
/



-- TODO 직원의 ID를 파라미터로 받아서 직원의 이름(emp.emp_name), 급여(emp.salary), 
-- 업무의 최대급여(job.max_salary), 업무의 최소급여(job.min_salary), 업무의 급여등급(salary_grade.grade)를 출력하는 store procedure를 구현
EXEC TODO_05_sp(100);
EXEC TODO_05_sp(120);
create or replace procedure TODO_05_sp(p_emp_id in emp.emp_id%TYPE)
is
   v_emp_name emp.emp_name%TYPE;
   v_salary emp.salary%TYPE;
   
   v_max_salary job.max_salary%TYPE;
   v_min_salary job.min_salary%TYPE;
   
   v_grade salary_grade.grade%TYPE;
    
begin
    select emp_name, salary, max_salary, min_salary, grade
    into v_emp_name, v_salary, v_max_salary, v_min_salary, v_grade
    from emp e, job j, salary_grade s
    where emp_id = p_emp_id and e.job_id = j.job_id(+)
            and salary between low_sal and high_sal;
            
    DBMS_OUTPUT.PUT_LINE(v_emp_name||', '||v_salary||', '||v_max_salary||', '||v_min_salary||', '||v_grade);
end;
/


-- TODO: 직원의 ID(emp.emp_id)를 파라미터로 받아서 급여(salary)를 조회한 뒤 급여와 급여등급을 출력하는 Stored Procedure 를 구현.
-- 업무급여 등급 기준:  급여가 $5000 미만 이면 LOW, %5000 ~ $10000 이면 MIDDLE, $10000 초과면 HIGH를 출력
exec TODO_06_sp(100);
exec TODO_06_sp(130);
create or replace procedure TODO_06_sp(p_emp_id in emp.emp_id%TYPE)
is
    v_salary emp.salary%TYPE;
    v_msg varchar2(10);
begin
    select salary
    into v_salary
    from emp
    where emp_id = p_emp_id;
    
    --if문
    if v_salary < 5000 then v_msg := 'LOW';
    elsif v_salary between 5000 and 10000 then v_msg := 'MIDDLE';
    else v_msg := 'HIGH';
    end if;
    
    --case문 
    case when v_salary < 5000 then v_msg := 'LOW';
         when v_salary between 5000 and 10000 then v_msg := 'MIDDLE';
         else v_msg := 'HIGH';
    end case;
    
    DBMS_OUTPUT.PUT_LINE(v_msg);
end;
/





