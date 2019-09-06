/*
- 컬렉트:
    같은 타입의 데이터를 변수로 가지다.(열과 관련)
    
- 레코드: 
    서로 다른 타입의 데이터를 변수로 가진다.(행과 관련)
    변수를 하나의 테이블처럼 사용.(특정 인덱스 사용)
*/

/* ************************************************************************************************
레코드(Record)
    - 복합형 구조의 데이터 타입. 하나의 행(Row) 값을 표현하는데 사용된다.
    - 필드(Field) 
		- 레코드를 구성 요소로 실제 value를 가지고 있다. 
		- 레코드명.필드명 으로 접근한다.
    - 기존 테이블을 이용한 레코드
    - 사용자 정의 레코드
************************************************************************************************ */


/* ************************************************************************************************
  - 기존 테이블을 이용한 레코드
    -  %ROWTYPE 속성
    -  테이블이름%ROWTYPE : 기존 테이블이나 View의 컬럼을 필드로 가지는 레코드를 생성
        - 해당 테이블이나 VIEW의 모든 컬럼을 필드로 가진다.
	- 구문
		변수선언:  변수명  테이블명%rowtype;
	- 조회나 변경대상은 레코드의 필드들의 값이다.
		레코드의 필드 사용 : 변수명.필드명
************************************************************************************************ */

declare 
    rec_emp emp%rowtype; --레코드 타입의 변수: rec_변수명
                            --필드의 순서는 테이블 만들때 지정한 컬럼순서.
begin
    select *
    into rec_emp
    from emp
    where emp_id = 100;
    --조회시 접근: 레코드변수명.필드명
    DBMS_OUTPUT.PUT_LINE(rec_emp.emp_id||' - '||rec_emp.emp_name||' - '||rec_emp.salary);
end;
/
set serveroutput on;




-- ROWTYPE을 이용한 DML
drop table emp_copy;
create table emp_copy as select * from emp where dept_id =100 ;

DECLARE
  rec_emp emp%rowtype;
BEGIN
  select *
  into rec_emp
  from emp
  where emp_id = 140;
  
  insert into emp_copy values rec_emp; --필드명-컬럼명이 일치하는 컬럼에 값을 insert.
  --레코드 필드의 값 변경.
  rec_emp.salary := 30000;
  rec_emp.comm_pct := 0.3;
  rec_emp.hire_date  := '2019/07/22';
  
  update emp_copy
  set row = rec_emp --전체 컬럼의 값을 레코드가 가진 값으로 변경.
  where emp_id = rec_emp.emp_id;
  
  commit;
END;
/

select *
from emp_copy
where emp_id = 140;

select * from emp_copy;

declare
    rec_emp emp%rowtype;
begin
    select emp_id, emp_name, salary
    into rec_emp.emp_id, rec_emp.emp_name, rec_emp.salary
    from emp
    where emp_id = 110;
    
end;
/
--아래 TODO의 조회 결과를 담을 변수는 %ROWTYPE 레코드로 선언.
-- TODO : JOB 테이블에서 JOB_ID가 'AD_PRES' 인 행을 조회해 출력.
declare
    rec_job job%rowtype;
begin
    select *
    into rec_job
    from job
    where job_id = 'AD_PRES';
        DBMS_OUTPUT.PUT_LINE(rec_job.job_id||', '||rec_job.job_title); --max_salary, min_salary....
end;
/


-- TODO : CUSTOMERS 테이블에서 고객_ID(cust_id), 이름(cust_name), 주소(address), 이메일주소(cust_email)을 조회하여 출력하는 코드 작성.  
declare
begin
    for rec_cust in  (select cust_id, cust_name, address, cust_email from customers)
    loop
        dbms_output.put_line(rec_cust.cust_id);
    end loop;
end;
/


-- DEPT_COPY 테이블을 생성 (모든 데이터 카피)
-- TODO : DEPT_COPY에서 DEPT_ID가 100인 부서 정보를 출력하는 코드 작성.
declare
    rec_dept dept_copy%rowtype;
begin
    select *
    into rec_dept
    from dept_copy
    where dept_id = 100;
    
    dbms_output.put_line(rec_dept.dept_id||', '||rec_dept.dept_name||', '||rec_dept.loc);
    
end;
/

-- TODO : DEPT_COPY 의 ROWTYPE 레코드 변수를 선언 하고 그 변수의 필드에 적당한 값을 대입한 뒤 INSERT 하는 코드를 작성.

declare
    rec_dept dept_copy%rowtype;
begin
    rec_dept.dept_id := 780;
    rec_dept.dept_name := 'Web UI';
    rec_dept.loc := 'Busan';
    
    insert into dept_copy values rec_dept;
    
end;
/

select * from dept_copy;


/* ************************************************************************************************
사용자 정의 레코드
 - 레코드 타입을 직접 선언
 - 변수 선언시 데이터 타입으로 사용한다.
 - 구문

 TYPE 레코드이름 IS RECORD (
    필드명  필드타입 [NOT NULL] [ := 디폴트값] , 
    ...
 );
 
 -필드타입(데이터타입)
    - pl/eql 데이터타입.
    - %type
    - %rowtype, 사용자정의 레코드타입
 -사용
 변수명 레코드타입;
 
 TYPE 이름 IS 종류
 ************************************************************************************************ */
declare
    --부서ID와 부서이름을 저장할 수 있는 record 타입 정의
    type dept_type is record( --레코드타입 이름 : 아름_type
--        id number(4),
--        name varchar2(100)
        
        id dept.dept_id%type,
        name dept.dept_name%type
    );
    
    rec_dept dept_type; --id/name을 필드로 가지는 레코드.
begin
    select dept_id, dept_name
    into rec_dept
    from dept
    where dept_id = 10;
    
    dbms_output.put_line(rec_dept.id||' - '||rec_dept.name);
    rec_dept.id := 20;
    rec_dept.name := '영업기획부';
    update dept
    set dept_name = rec_dept.name
    where dept_id = rec_dept.id;
    
end;
/

--TODO: 아래 select 문 실행결과를 저장할 사용자 정의 레코드를 만들고 SQL실행결과를 그 타입의 변수에 저장한뒤 출력하는 프로시저를 작성.
/*
select e.emp_id, e.emp_name, d.dept_id, d.dept_name, j.job_title
from emp e, dept d, job j
where e.dept_id = d.dept_id(+)
and   e.job_id = j.job_id(+)
and   e.emp_id = 100;
*/

declare
    type rec_join_type is record(
        emp_id emp.emp_id%type,
        emp_name emp.emp_name%type,
        dept_id dept.dept_id%type,
        dept_name dept.dept_name%type,
        job_title job.job_title%type
    );
    
    rec_join rec_join_type;
begin
    select e.emp_id, e.emp_name, d.dept_id, d.dept_name, j.job_title
    into rec_join
    from emp e, dept d, job j
    where e.dept_id = d.dept_id(+)
    and   e.job_id = j.job_id(+)
    and   e.emp_id = 100;
    
     dbms_output.put_line(rec_join.emp_id||' - '||rec_join.emp_name);
end;
/

declare 
    type join_type is record(
        rec_emp emp%rowtype,
        rec_dept dept%rowtype,
        rec_job job%rowtype
    );
    
    rec_join join_type;
begin
    select e.emp_id, e.emp_name, d.dept_id, d.dept_name, j.job_title
    into rec_join.rec_emp.emp_id,
         rec_join.rec_emp.emp_name,
         rec_join.rec_dept.dept_id,
         rec_join.rec_dept.dept_name,
         rec_join.rec_job.job_title
    from emp e, dept d, job j
    where e.dept_id = d.dept_id(+)
    and   e.job_id = j.job_id(+)
    and   e.emp_id = 100;
    
    dbms_output.put_line(rec_join.rec_emp.emp_id||' - '||rec_join.rec_emp.emp_name);
end;
/
/* ************************************************************************************************************************************************************************************
컬렉션

- 같은 타입의 값들을 여러개 저장하는 구조.
    - 레코드는 다양한 타입의 필드를 모으지만 테이블처럼 여러 ROW를 가질 수 없음.
    - 컬렉션은 여러 row를 가지는 형태
- 종류
  1. 연관배열: 키와 값으로 구성된 컬렉션
  2. VARRAY  : 크기가 고정돼 있는 배열구조
  3. 중첩테이블 : 크기를 자유롭게 정할 수있는 배열구조

************************************************************************************************************************************************************************************ */

/* *********************************************************************************************
- 연관배열(Associative Array)
    - 키-값 쌍으로 구성된 컬렉션
    - 키를 INDEX로 부르기 때문에 Index-by 테이블이라고도 한다.
	- 변수의 타입으로 사용된다.
- 구문
    - 타입 정의
        - TYPE 이름 IS TABLE OF 값타입 INDEX BY 키(인덱스)타입
        - 값타입 : 모든 타입 가능
        - 키(인덱스) 타입 : 문자형 또는 PLS_INTEGER/BINARY_INTEGER 타입만 가능.
    - 선언부에 정의한다.
	- 타입을 정의 한뒤 변수의 타입으로 사용할 수 있다.
	- 값 대입 : 배열이름(INDEX):=값
    - 값 조회 : 배열이름(INDEX)
********************************************************************************************* */


declare
    --key(index)타입: 정수
    --값(value) 타입: varchar2(100)
    --연관배열 타입이름: 이름_table_types
    type my_table_type is table of varchar2(100) index by binary_integer;
    
    --변수 선언
    my_table my_table_type;
    
begin
    --연관배열에 값 대입.
    my_table(10) := 'test1';
    my_table(20) := 'test2';
    --연관배열의 값 조회
    dbms_output.put_line(my_table(10));
    dbms_output.put_line(my_table(20));
    
end;
/

declare
    --index(key): dept_id, value: dept_name
    type dept_table_type is table of dept.dept_name%type index by binary_integer;
    
    dept_table dept_table_type;
begin
    select dept_name
    into dept_table(10) --select결과를 연관배열에 추가.
    from dept
    where dept_id = 10;
    
    dbms_output.put_line(dept_table(10));
     
    select dept_name
    into dept_table(20) --select결과를 연관배열에 추가.
    from dept
    where dept_id = 20;
    
    dbms_output.put_line(dept_table(20));
end;
/

declare
    -- index: 정수-dept_id, value: 부서레코드(한행)
    type dept_table_type is table of dept%rowtype index by binary_integer;
    
    dept_table dept_table_type;
begin
    select *
    into dept_table(10)
    from dept
    where dept_id = 10;
    
    select *
    into dept_table(20)
    from dept
    where dept_id = 20;
    
    dbms_output.put_line(dept_table(10).dept_name);
    dbms_output.put_line(dept_table(20).dept_name);
end;
/

--TODO
-- 1. index는 크기 10인 문자열로 값은 date를 가지는 연관배열 선언
-- 2. index는 정수, 값은 dept 테이블의 loc와 같은 타입인 연관배열 선언
declare
    --1번 선언
    type test01 is table of date index by varchar2(10);
    --2번 선언
    type test02 is table of dept.loc%type index by binary_integer; --pls_integer
    
    test01_tb test01;
    test02_tb test02;
    
begin
    --1번 타입의 변수에 값 대입 및 출력
    test01_tb('today') := sysdate;
    --2번 타입의 변수에 값 대입 및 출력
    test02_tb(10) := 'korea'; 
    
    dbms_output.put_line(test01_tb('today'));
    dbms_output.put_line(test02_tb(10));
end;
/

--TODO 부서 ID를 Index로 부서 레코드(%ROWTYPE)을 Value로 가지는 연관배열을 선언하고
-- dept_id가 10인 부서와 dept_id가 20 인 부서의 정보(dept_id, dept_name, loc)를 조회하여 연관배열 변수에 넣는 프로시저를 작성
create or replace procedure test03 (v_dept_id in dept.dept_id%type)
is
    type test03 is table of dept%rowtype index by binary_integer;
    
    test03_tb test03;--부서정보들을 모으는 컬렉션.
begin
    select *
    into test03_tb(v_dept_id)
    from dept
    where dept_id = v_dept_id;
    
    dbms_output.put_line(test03_tb(v_dept_id).dept_id||'-'||test03_tb(v_dept_id).dept_name||'-'||test03_tb(v_dept_id).loc);
end;
/

exec test03(20);


-- TODO: emp_id 가 100 ~ 120번인 직원의 이름을 조회해 연관배열(index: emp_id, value: emp_name)에 저장하는 코드를 작성.
declare
    type test04 is table of emp.emp_name%type index by binary_integer;
    
    test04_tb test04;
begin
	--반복문을 이용해 100 ~ 120 인 직원의 이름을 조회 및 연관배열에 저장가능
	for i in 100..120
    loop
        select emp_name
        into test04_tb(i)
        from emp
        where emp_id = i;
    end loop;
	
	--연관배열내의 조회결과 출력
    for i in 100..120
    loop
        dbms_output.put_line(test04_tb(i));
    end loop;
end;
/


/* *********************************************************************************************
- VARRAY(Variable-Size Array)
    - 고정길이 배열. 
		- 선언시 배열의 크기(최대요소개수)를 지정하면 그 크기 만큼의 요소만 저장가능
        - 선언한 개수 이상 저장 할 수 없지만 적게 저장하는 것은 가능.
    - Index는 1부터 1씩 증가하는 정수로 자동으로 설정된다.
    - 생성자를 통한 초기화
		- 반드시 생성자를 이용해 값들을 저장한 뒤에사용할 수 있다.
    - 일반 적으로 연속적인 값을 저장해야 하는 경우 많이 사용됨(index가 순번 형태이므로)
	- C 나 Java의 배열과 비슷한 형태이다.
- 구문    
    - 타입 정의
        - TYPE 이름 IS VARRAY(최대크기) OF 요소값타입;
    - 초기화 
        - 변수 := 이름(값 [, ...]) 
        - 초기화 된 개수만큼만 변경 가능 
    - 값 대입(변경) : 이름(INDEX):=값
    - 값 조회 : 이름(INDEX)
********************************************************************************************* */


declare
    type va_type is varray(5) of varchar2(100);
    va_arr va_type;
begin
    --초기화
    va_arr := va_type('가','나','다');
    va_arr(2) := 'B';
    
    for idx in 1..3
    loop
        DBMS_OUTPUT.PUT_LINE(va_arr(idx));
    end loop;
    
end;
/
--dept_id 10,50,70인 부서의 정보를 조회 => 연관배열 결과 담기.
declare
    --결과를 담을 연관배열 타입.
    type dept_table_type is table of dept%rowtype index by binary_integer;
    --조회할 부서 id들을 담을 varray
    type dept_id_list is varray(3) of dept.dept_id%type;
    
    dept_table dept_table_type;
    dept_arr dept_id_list;
begin
    dept_arr := dept_id_list(10, 50, 70); --조회할 부서id로 varray초기화.
    for i in 1..3
    loop
        select *
        into dept_table(dept_arr(i))
        from dept
        where dept_id = dept_arr(i);
    end loop;
    
    --조회결과 출력
    for i in 1..3
    loop
        dbms_output.put_line(dept_table(dept_arr(i)).dept_name); 
    end loop;
end;
/

/* *********************************************************************************************
- 중첩테이블(Nested Table)
    - 선언시 크기를 지정하지 않고 생성자를 이용해 초기화 할때 대입된 원소 수에 맞춰 크기가 정해진다.
    - 생성자를 사용한 초기화 후 사용
    - index 는 1부터 1씩 자동증가하는 정수로 설정.    
    - 일반 테이블의 컬럼 타입으로 사용될 수 있다.
- 구문
    - 타입 정의
        - TYPE 이름 IS TABLE OF 값타입;
********************************************************************************************* */

declare
 type nt_table_type is table of number;
    nt_table nt_table_type;
    nt_table2 nt_table_type;
    
begin
    --생성자를 이용한 초기화.
    nt_table := nt_table_type(10,20,30,40,50);
    nt_table2 := nt_table_type(2,4,6,8,10,12,14,16,181111111111111);
    nt_table(2) := 2000; --대입(변경)
    DBMS_OUTPUT.PUT_LINE(nt_table(2));
    
    /*for i in 1..5
    loop
        DBMS_OUTPUT.PUT_LINE(nt_table(i));
    end loop;
    */
    for i in 1..nt_table.count
    loop
        DBMS_OUTPUT.PUT_LINE(nt_table(i));
    end loop;
    
end;
/




/* *****************************************************************************************************************************
- 컬렉션 메소드
 # DELETE : 모든 요소 삭제
 # DELETE(n) : index가 n인 요소 삭제 (varray는 지원안함)
 # DELETE(n, m) : index가 n ~ m 인 요소 삭제 (varray는 지원안함)
 
 # EXISTS(index) : index가 있는 지 여부 boolean값으로 반환
 # FIRST : 첫번째 IDNEX 반환
 # LAST : 마지막 INDEX 반환
    - FOR idx IN 컬렉션.FIRST..컬렉션.LAST  
 # PRIOR(index) : index 이전 INDEX 반환
 # NEXT(index) : index 다음 INDEX 반환

# COUNT: 컬렉션내의 요소 개수 반환 

***************************************************************************************************************************** */

declare 
    type varr_type is varray(4) of varchar(20);
    
    varr varr_type;
begin
    varr := varr_type('a','b','c','d');
    dbms_output.put_line(varr.first||', '||varr.last);
    DBMS_OUTPUT.PUT_LINE(varr.next(3)||', '||varr.prior(3));
    if varr.exists(4) then DBMS_OUTPUT.PUT_LINE('index있음');
    end if;
end;
/





-- TODO: emp에서 emp_id가 100 ~ 120인 직원들의 정보를 조회한 뒤 그 정보를 emp_copy에 추가하는 코드를 작성.
DECLARE
    -- 연관배열 타입 정의(조회한 직원정보들 저장): key - emp_id타입, value:emp row
    type emp_tb_type is table of emp%rowtype index by binary_integer;
    -- 연관배열 타입 변수 선언
    emp_tb emp_tb_type;
BEGIN
    -- 반복문을 이용해 emp_id가 100 ~ 120 인 직원 조회해서 연관배열에 저장 
	for i in 100..120
    loop
        select * 
        into emp_tb(i)
        from emp
        where emp_id = i;
    end loop;
	
	
	-- 반복문을 이용해 연관배열내 저장된 조회결과들을 emp_copy 테이블에 insert (FIRST, LAST 메소드 이용)
    for i in emp_tb.first..emp_tb.last
    loop
        insert into emp_copy values emp_tb(i);
    end loop;
	
	
END;
/

select * from emp_copy;


