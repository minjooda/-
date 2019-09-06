/* ***************************************************************************************************************
트리거(Trigger)

- 데이터베스의 오브젝트에 이벤트가 발생하면 자동으로 실행되는 프로시저
	- 이벤트: 트리거를 작동는 상황.
		- DML 문 : insert, update, delete
		- DDL 문 : create, alter, drop
		- 데이터베이스 자체 이벤트 : 서버에러, 로그인, 데이터베이스 시작, 종료
	- 트리거 타이밍: 트리거 실행 시점.
		- BEFORE : 이벤트 발생 전
		- AFTER : 이벤트 발생 후
	- 트리거 종류
		- 행 트리거 
			- DML의 영향을 받는 모든 행단위로 트리거 실행.
			- 변경 레코드를 제어할 수 있다.
			- FOR EACH ROW 옵션
		- 명령문 트리거
			- DML 문 단위로 트리거 실행
			- 한 구문에서 몇개의 행이 갱신되어도 트리거는 한번만 호출 된다.

- 구문
	CREATE [ OR REPLACE] TRIGGER 트리거이름
 	  타이밍
	  이벤트 [ OR 이벤트2 OR 이벤트3 ..]
	  ON 테이블이름
	  [FOR EACH ROW] 
	
	[DECLARE
		선언부]
	BEGIN
		실행부]
	[EXCEPTION
		예최처리]
	END;

	- 타이밍 : BEFORE, AFTER
		-  BEFORE에서 예외가 발생하면 event 쿼리도 실행 되지 않는다. after일 경우는 예외가 발생해도 event 쿼리는 실행된다.
	- 이벤트 
		- 트리거를 발생시킬 SQL 구문
		- update 의 경우 : update of 컬럼명[,컬럼명] 으로 컬럼을 지정할 수 있다.
	- 테이블 : 트리거와 연결될 테이블 이름
	- FOR EACH ROW : 넣으면 행 트리거, 생략하면 명령문 트리거
	- DECLARE 절 : 실행문에서 사용할 변수를 선언 한다. 생략 가능
	- BEGIN 절 : 실행부
		- 실행부에서 commit/rollback을 할 수 없다.
	- EXCEPTION : 실행부에서 발생한 예외처리. 생략 가능

- 실행부에서 이벤트 적용된 값 제어
	- :old : 참조 전의 컬럼의 값 (update : 수정전 데이터, delete: 삭제 전의 데이터)
	- :new : 참조 후의 컬럼의 값 (insert : 입력된 데이터, update: 수정한 데이터)
	- :new.컬럼명, :old.컬럼명 으로 조회한다.
	
트리거 제거
- drop trigger 트리거 이름
- 연결된 테이블이 삭제되면 트리거도 자동 삭제된다.
	
*************************************************************************************************************** */

set serveroutput on;
create or replace trigger ex_trigger 
after delete on emp
BEGIN
    DBMS_OUTPUT.PUT_LINE('emp에서 삭제가 발생');
end;
/

delete from emp;
rollback;
delete from emp where 1=0;

-- 행 트리거
DROP TABLE DEPT_COPY;
CREATE TABLE DEPT_COPY AS SELECT * FROM DEPT;
create or replace trigger ex2_trigger
before insert or delete or update of loc on dept_copy
for each row --행트리거
begin
    dbms_output.put_line('변경전 loc : '||:old.loc);
    dbms_output.put_line('변경후 loc : '||:new.loc);
    dbms_output.put_line('변경전 dept_name : '||:old.dept_name);
    dbms_output.put_line('변경후 dept_name : '||:new.dept_name);
end;
/

insert into dept_copy values (300, '세무서', '인천');
delete from dept_copy where loc = '인천';
update dept_copy 
set dept_name = dept_name, loc = '부산' 
where loc = 'Seattle';

 
--  DEPT 테이블에 행이 insert 되면 같은 값을 DEPT_COPY에 insert하는 트리거 작성.
create or replace trigger dept_copy_trigger 
after insert on dept
for each row
declare 
    ex_error exception;
begin
--    raise ex_error; --trigger 실행 중 오류가 생기면 명령문이 진행x. 
    insert into dept_copy values (:new.dept_id, :new.dept_name, :new.loc);
    --commit; trigger에서는 commit, rollback은 할 수 없다.
end;
/

insert into dept values (1051, '영업기획부', '강남');

select * from dept_copy;



-- 명령문 트리거






-- dept_copy에 오전 12 ~ 07시 까지는 DML 구문을 실해하지 못하도록 하는 trigger 구현
create or replace trigger ban_dml_dept_copy_trigger
before insert or update or delete on dept_copy
declare
    ex_error exception;
    v_hour varchar2(2);
begin
    v_hour := to_char(sysdate, 'hh24');
    if  v_hour between '00' and '07' then
        --raise ex_error;
        raise_application_arror(-20001, '지금은 데이터를 변경할 수 없는 시간입니다.');
    end if;
end;
/

update dept_copy set dept_name = dept_name;



-- emp_copy 테이블에서 DML(insert, delete, update)이 발생하면 그것을 log로 남기는 트리거를 생성
drop table emp_copy ;
create table emp_copy as select * from emp where 1 =0;


drop table logs;
create table logs (
 table_name varchar2(100), -- 테이블이름
 event_time date default sysdate, --DML 실행시간
 event varchar2(10) --DML 종류
);

create or replace trigger emp_copy_log_trigger
after insert or delete or update on emp_copy
declare
    v_event varchar2(10); --어떤 dml이 실행되었는지 저장.
begin
    if inserting then --inserting : event가 insert면 true, 아니면 false
        v_event := 'insert';
    elsif deleting then
        v_event := 'delete';
    elsif updating then
        v_event := 'update';
    end if;
    
    insert into logs values ('emp_copy', sysdate, v_event);
end;
/

insert into emp_copy values (500, '강낭콩', 100, 130, sysdate, 15000, null, 1000);
update emp_copy set emp_name = emp_name where emp_id = 500;
delete from emp_copy  where emp_id = 500; 

select * from logs;

-- 위의 코드를 dept_copy_log_trigger, job_copy_log_trigger 를 만들어 dept_copy, job_copy 테이블에 에 적용. 
create or replace procedure logging_procedure(p_table_name varchar2)
is
    v_event varchar2(10); --어떤 dml이 실행되었는지 저장.
begin
    if inserting then --inserting : event가 insert면 true, 아니면 false
        v_event := 'insert';
    elsif deleting then
        v_event := 'delete';
    elsif updating then
        v_event := 'update';
    end if;
    
    insert into logs values (p_table_name, sysdate, v_event);
end;
/

create or replace trigger dept_logging_trigger
after insert or update or delete on dept_copy
begin
    logging_procedure('dept_copy');
end;
/

update dept set dept_id = dept_id where loc = 'Seattle';























