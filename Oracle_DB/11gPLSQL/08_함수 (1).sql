/* ***************************************************************************************
함수 (FUNCTION)
- 미리 컴파일되어 재사용 가능한 객체로 SQL문 또는 PL/SQL문 내에서 호출되어 사용되는 
  서브프로그램.
- 호출자로 부터 파라미터 값을 입력 받아 처리한뒤 그 결과를 호출자에게 반환한다. 
	- 파라미터는 안 받을 수 도 있다.
- 빌트인 함수
	- 오라클에서 제공하는 내장함수
- 사용자 정의 함수이름	
	- 사용자 정의함수
	
- 사용자 정의 함수 구문
	CREATE [OR REPLACE] FUNCTION 함수이름 [(파라미터1, 파라미터2, ..)]
		RETURN datatype
	IS
		-- 선언부: 변수, 상수등 선언
	BEGIN
		-- 실행 부 : 처리구문
		RETURN value;
	[EXCETPION]
		-- 예외처리 부
	END;
	
	
	- RETURN 반환데이터타입
		- 호출자에게 전달할 반환값의 타입 지정
		- char/varchar2 나 number일 경우 size는 지정하지 않는다.
		- 실행 부에서 `return 값` 구문을 이용해 처리결과를 반환한다.
	- 파라미터 
		- 개수 : 0 ~ N개
		- IN 모드만 가능. 
		- 구문
			변수명 데이터타입 [:=기본값]
		- 기본값이 없는 매개변수에는 호출자에서 반드시 값을 전달해야 한다.
		
	
함수 제거
DROP FUNCTION 함수명;
*************************************************************************************** */
-- 매개변수 없는 함수 생성 및 호출
create or replace function ex_08_01_fn
    return varchar2
is
begin
    return '안녕하세요';
end;
/
select ex_08_01_fn(), sysdate from dual;
select ex_08_01_fn from dual;
select emp_name, ex_08_01_fn() 메세지  from emp;

--매개변수가 1개 있는 함수
--create or replace function ex_08_02_fn(p_num binary_integer)
create or replace function ex_08_02_fn(p_num binary_integer := 0)
    return varchar2
is
begin
    return p_num||'원';
end;
/
select ex_08_02_fn(10000) from dual;
select ex_08_02_fn from dual;
select ex_08_02_fn(salary) from emp;

--기본값이 있는 매개변수를 가진 함수




--매개변수가 여러개인 함수
select ex_8_3_fn(10,20, 0, '달러') from dual;

create or replace function ex_8_3_fn(p_num1 binary_double:=0, 
                                     p_num2 binary_double:=0,
                                     p_num3 binary_double:=0,
                                     p_cur varchar2:='원')
    --return binary_double
    return varchar2
is 
    --v_result binary_double;
    v_result varchar2(100);
begin
    v_result := (p_num1+p_num2+p_num3) ||p_cur ;
    return v_result;
end;
/
select ex_8_3_fn from dual;
select ex_8_3_fn(10,20, '달러') from dual;
select ex_8_3_fn(10.5, 20.5, 30.5, '달러') from dual;

--  emp_id를 받아서 그 직원의 커미션(salary * comm_pct)의 값을 반환하는 함수 
create or replace function ex_8_5(p_emp_id  emp.emp_id%type)
    return binary_double
is
    v_result binary_double;
begin
    select  salary * comm_pct
    into    v_result
    from    emp
    where   emp_id = p_emp_id;
    
    return v_result;
end;
/
select ex_8_5(500) from dual;


select  emp_id, 
        ex_8_5(emp_id) 계산값, 
        comm_pct, 
        salary 
from emp;


select * from emp where emp_id = 500;



-- TODO: 매개변수로 정수 두개를 받아 나눈 결과의 소숫점 이하 부분만 반환하는 
--함수 구현 (ex: 10/4 -> 0.5 반환)
create or replace function todo_8_1(p_num1 binary_integer, 
                                    p_num2 binary_integer)
    return binary_double
is
    v_temp binary_double;
    v_result binary_double;
begin
    v_temp := p_num1/p_num2;
    v_result := v_temp - floor(v_temp);
    return v_result;
end;
/
select todo_8_1(10,3) from dual;
select todo_8_1(10,4) from dual;


-- TODO: 매개변수로 정수 두개를 받아서 나머지 연산을 처리하는 함수 구현.  (10/4 -> 2를 반환)
-- 나머지계산: --피젯수 - (결과 정수값 * 제수)
-- ex) 10/4의 나머지 : 10 - (10/4결과정수 * 4)

select mod(10,3) from dual;
create or replace function todo_8_2(p_num1 binary_integer, 
                                    p_num2 binary_integer)
    return binary_integer
is
    v_temp binary_integer;
    v_result binary_integer;
begin
    v_temp := floor(p_num1/p_num2);
    v_result := p_num1 - v_temp * p_num2;
    return v_result;
end;
/
select todo_8_2(10,3) from dual;
select todo_8_2(10,6) from dual;


-- TODO: 1. 매개변수로 사원 ID를 받아서 자신의 급여가 자신이 속한 부서의 
--평균급여 이상이면 TRUE를 미만이면 FALSE를 반환하는 함수 작성. 
--조회한 사원이 없는 경우 NULL을 반환
--       2. 위의 함수를 호출하는 익명 프로시저에서 작성.
--			함수를 호출하여 반환되는 boolean 값이
--				TRUE이면 '직원의 급여가 부서평균 이상' 을 FALSE이면 
--  '직원의 급여가 부서평균 미만' 을 NULL이면 '없는 직원' 을 출력한다.


CREATE OR REPLACE FUNCTION todo_03_fn(p_emp_id emp.emp_id%TYPE)
    RETURN boolean
IS
    v_cnt binary_integer; --직원 존재 여부 
    
    v_sal emp.salary%type; --직원 급여
    v_dept_id emp.dept_id%type; -- 직원의 부서_id
    
	v_avg_sal emp.salary%type; -- 부서의 평균급여
	
    ex_not_found exception;
BEGIN
	select count(*) 
    into v_cnt
    from emp
    where emp_id = p_emp_id;
    
    if v_cnt = 0 then
        --raise ex_not_found;
        return null;
    end if;
    -- salary 와 부서 id를 조회
	select salary, dept_id
    into   v_sal, v_dept_id
    from   emp 
    where  emp_id = p_emp_id;
	-- 부서의 평균 급여를 조회
	select avg(salary)
    into   v_avg_sal
    from   emp
    where dept_id = v_dept_id;
	-- 직원의 salary와 부서 평균급여를 비교해서 boolean 값을 반환
    /*if v_sal >= v_avg_sal then
        return TRUE;
    else
        return FALSE;
	*/
    return v_sal >= v_avg_sal;
EXCEPTION
    when ex_not_found then
        return null;
end;
/
select todo_03_fn(emp_id) from emp;


-- 170(이상) 180(이하) 
-- ------위의 함수 사용하는 프로시저. ---------
DECLARE
    v_result boolean;
BEGIN
   v_result := todo_03_fn(180); --NULL, T, F
   if v_result is null then
     dbms_output.put_line('없는 직원 ID');
   elsif v_result then
     dbms_output.put_line('평균이상');
   else
     dbms_output.put_line('평균 미만');
   end if;
   
END;
/
--확인 sql문
select salary from emp where emp_id = 170;
select avg(salary) from emp where dept_id = (select dept_id from emp where emp_id = 170);






--TODO 매개변수로 5개의 'y' 또는 'n'을 받아서 몇번째 매개변수가 y인지를 하나의 문자열로 묶어서 반환하는 함수 구현.
-- select todo_03_fn('y','n', 'n', 'y', 'y') from dual;  => '1, 4, 5'

create or replace function todo_04_fn (p_yn1 varchar2, 
                                       p_yn2 varchar2,
                                       p_yn3 varchar2,
                                       p_yn4 varchar2,
                                       p_yn5 varchar2) 
    return varchar2
is  
    v_return varchar2(100); -- 최종결과 문자열을 저장할 변수.

begin  
    --p_yn1 처리: y 이면 v_return 문자열에 연결.
    if  p_yn1 = 'y' then
--        v_return :='1';
        if nvl(length(v_return), 0) = 0 then
            v_return:='1';
        else
            v_return := v_return||'1';    
        end if;
    end if;	
    
    --p_yn2 처리
    if  p_yn2 = 'y' then
        if nvl(length(v_return), 0) = 0 then
            v_return:='2';
        else
            v_return := v_return||', 2';    
        end if;
    end if;
	
     --p_yn3 처리
    if  p_yn3 = 'y' then
        if nvl(length(v_return), 0) = 0 then
            v_return:='3';
        else
            v_return := v_return||', 3';    
        end if;
    end if;    
	
	
     --p_yn4 처리
	 if  p_yn4 = 'y' then
        if nvl(length(v_return), 0) = 0 then
            v_return:='4';
        else
            v_return := v_return||', 4';    
        end if;
    end if;
	 
     --p_yn5 처리
	 if  p_yn5 = 'y' then
        if nvl(length(v_return), 0) = 0 then
            v_return:='5';
        else
            v_return := v_return||', 5';    
        end if;
    end if;
    
    -- 결과값 반환
    return v_return;

end;
/
select todo_04_fn('y','y', 'n', 'y', 'n') from dual;
select todo_04_fn('n','y', 'n', 'y', 'y') from dual;

create table choice_tb(
    ch1 char check(ch1 in ('y', 'n')),
    ch2 char check(ch2 in ('y', 'n')),
    ch3 char check(ch3 in ('y', 'n')),
    ch4 char check(ch4 in ('y', 'n')),
    ch5 char check(ch5 in ('y', 'n'))
);

insert into choice_tb values ('n','y', 'y', 'y', 'y');
insert into choice_tb values ('y','y', 'n', 'y', 'y');
insert into choice_tb values ('n','y', 'n', 'y', 'y');
insert into choice_tb values ('n','y', 'n', 'n', 'y');
insert into choice_tb values ('n','y', 'y', 'y', 'n');
commit;

select todo_04_fn(ch1, ch2, ch3, ch4, ch5) 선택사항 from choice_tb;



