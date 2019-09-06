/* *********************************************************************************************
PL/SQL 개요
- PL/SQL 이란
	- Oracle's Procedual Lanague extension to SQL
	- SQL을 확장하여 SQL작업을 절차적 프로그램으로 작성할 수 있는 프로그래밍 언어.
	- 다수의 SQL문을 한번에 처리할 수 있어 하나의 트랜잭선 작업을 하나의 블록으로 작성할 수있다.
	- 재사용이 가능하다.
	- 예외처리를 지원한다.

********************************************************************************************* */
--부서별 연봉 합계를 저장하는 테이블
create table emp_sum
as
select dept_id, sum(salary) salary_num
from emp
group by dept_id;

select * from emp_sum;

--emp_id가 XXX인 직원을 삭제.
--emp_sum에서 급여 합계를 변경.
--salary_num을 조회.(10, 5000)

select * from emp_sum;
select * from emp where emp_id = 200;
--dept_id = 10, salary = 5000;
delete from emp where emp_id = 200;
--합계 테이블 변경.
update emp_sum 
set salary_num = salary_num - 5000 
where dept_id = 10;

rollback;

set serveroutput on; --client가 server에서 출력된 결과를 받아오겠다.
DECLARE
  emp_rec emp%rowtype;
  sum_rec emp_sum%rowtype;
BEGIN
  --1. 200인 직원의 정보 조회 
  select * 
  into emp_rec --조회된 결과가 emp_rec변수 안에 저장.
  from emp where emp_id = 200;
  --2. 200인 직원을 삭제
  delete from emp where emp_id = 200;
  --3. 급여합계 테이블을 변경(update)
  update emp_sum
  set salary_num = salary_num - emp_rec.salary
  where dept_id = emp_rec.dept_id;
  --4. 급여합계 테이블에서 변경 내역 조회해서 출력
  select *
  into sum_rec
  from emp_sum
  where dept_id = emp_rec.dept_id;
  
  --출력 : 부서ID : 10, 급여합계 : 0
  dbms_output.put_line('부서ID: '||sum_rec.dept_id);
  dbms_output.put_line('급여합계: '||sum_rec.salary_num);
  rollback; --commit;
END;
/ --여기까지만 실행해줘.

rollback;
select * from emp where emp_id = 200;
/* ***********************************************************************************************
PL/SQL 기본 블록
- 선언(DECLARE)
    -  변수, 커서, 사용자정의 예외 등 선언
    -  선택사항
- 실행구문블록(BEGIN)
    - 호출되면 실행할 구문 작성
    - SQL문, PL/SQL 문을 실행 순서에 맞게 정의
    - 조건문이나 반복문 사용가능
    - 필수
- 예외처리(EXCEPTION)
    - 실행문에서 발생한 오류를 처리하는 구문 작성
    - 실행문이 실행도중 오류가 발생하면 EXCEPTION 으로 이동
    - 선택사항
- 종료(END;)
    -  PL/SQL 구문의 종료를 표시
    
- PL/SQL 종류
    - 익명 프로시저
		- 이름 없이 작성하는 PL/SQL 블록
		- DATABASE에 저장되어 관리 되지 않고 필요할 때마다 반복 작성, 실행한다.
    - 저장 프로시저(Stored Procedure)
		- 이름이 있으며 DATABASE에 저장되어 관리된다.
		- 이름으로 호출하여 재사용이 가능하다. 
		- 호출시 값을 받아 그 값을 내부에서 사용할 수 있다.
    - 함수(Function)
		- 사용자 정의 함수로 처리후 값을 반드시 반환해야 한다.
		- SQL내에서 값을 처리하기 위해 호출해서 사용한다.
		
*********************************************************************************************** */

/
-- Helloworld 출력하는 PL/SQL
begin
    dbms_output.put_line('Hello World!');
end;
/


-- TODO: 다음을 출력하는 것을 작성하시오.
/*
이름 : 홍길동
나이 : 20세
주소 : 서울시 강남구 역삼동
*/

begin
    dbms_output.put_line('이름: 홍길동');
    dbms_output.put_line('나이: 20세');
    dbms_output.put_line('주소: 서울시 강남구 역삼동');
end;
/

--conteol + space : 구문자동완성








