/*
- �÷�Ʈ:
    ���� Ÿ���� �����͸� ������ ������.(���� ����)
    
- ���ڵ�: 
    ���� �ٸ� Ÿ���� �����͸� ������ ������.(��� ����)
    ������ �ϳ��� ���̺�ó�� ���.(Ư�� �ε��� ���)
*/

/* ************************************************************************************************
���ڵ�(Record)
    - ������ ������ ������ Ÿ��. �ϳ��� ��(Row) ���� ǥ���ϴµ� ���ȴ�.
    - �ʵ�(Field) 
		- ���ڵ带 ���� ��ҷ� ���� value�� ������ �ִ�. 
		- ���ڵ��.�ʵ�� ���� �����Ѵ�.
    - ���� ���̺��� �̿��� ���ڵ�
    - ����� ���� ���ڵ�
************************************************************************************************ */


/* ************************************************************************************************
  - ���� ���̺��� �̿��� ���ڵ�
    -  %ROWTYPE �Ӽ�
    -  ���̺��̸�%ROWTYPE : ���� ���̺��̳� View�� �÷��� �ʵ�� ������ ���ڵ带 ����
        - �ش� ���̺��̳� VIEW�� ��� �÷��� �ʵ�� ������.
	- ����
		��������:  ������  ���̺��%rowtype;
	- ��ȸ�� �������� ���ڵ��� �ʵ���� ���̴�.
		���ڵ��� �ʵ� ��� : ������.�ʵ��
************************************************************************************************ */

declare 
    rec_emp emp%rowtype; --���ڵ� Ÿ���� ����: rec_������
                            --�ʵ��� ������ ���̺� ���鶧 ������ �÷�����.
begin
    select *
    into rec_emp
    from emp
    where emp_id = 100;
    --��ȸ�� ����: ���ڵ庯����.�ʵ��
    DBMS_OUTPUT.PUT_LINE(rec_emp.emp_id||' - '||rec_emp.emp_name||' - '||rec_emp.salary);
end;
/
set serveroutput on;




-- ROWTYPE�� �̿��� DML
drop table emp_copy;
create table emp_copy as select * from emp where dept_id =100 ;

DECLARE
  rec_emp emp%rowtype;
BEGIN
  select *
  into rec_emp
  from emp
  where emp_id = 140;
  
  insert into emp_copy values rec_emp; --�ʵ��-�÷����� ��ġ�ϴ� �÷��� ���� insert.
  --���ڵ� �ʵ��� �� ����.
  rec_emp.salary := 30000;
  rec_emp.comm_pct := 0.3;
  rec_emp.hire_date  := '2019/07/22';
  
  update emp_copy
  set row = rec_emp --��ü �÷��� ���� ���ڵ尡 ���� ������ ����.
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
--�Ʒ� TODO�� ��ȸ ����� ���� ������ %ROWTYPE ���ڵ�� ����.
-- TODO : JOB ���̺��� JOB_ID�� 'AD_PRES' �� ���� ��ȸ�� ���.
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


-- TODO : CUSTOMERS ���̺��� ��_ID(cust_id), �̸�(cust_name), �ּ�(address), �̸����ּ�(cust_email)�� ��ȸ�Ͽ� ����ϴ� �ڵ� �ۼ�.  
declare
begin
    for rec_cust in  (select cust_id, cust_name, address, cust_email from customers)
    loop
        dbms_output.put_line(rec_cust.cust_id);
    end loop;
end;
/


-- DEPT_COPY ���̺��� ���� (��� ������ ī��)
-- TODO : DEPT_COPY���� DEPT_ID�� 100�� �μ� ������ ����ϴ� �ڵ� �ۼ�.
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

-- TODO : DEPT_COPY �� ROWTYPE ���ڵ� ������ ���� �ϰ� �� ������ �ʵ忡 ������ ���� ������ �� INSERT �ϴ� �ڵ带 �ۼ�.

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
����� ���� ���ڵ�
 - ���ڵ� Ÿ���� ���� ����
 - ���� ����� ������ Ÿ������ ����Ѵ�.
 - ����

 TYPE ���ڵ��̸� IS RECORD (
    �ʵ��  �ʵ�Ÿ�� [NOT NULL] [ := ����Ʈ��] , 
    ...
 );
 
 -�ʵ�Ÿ��(������Ÿ��)
    - pl/eql ������Ÿ��.
    - %type
    - %rowtype, ��������� ���ڵ�Ÿ��
 -���
 ������ ���ڵ�Ÿ��;
 
 TYPE �̸� IS ����
 ************************************************************************************************ */
declare
    --�μ�ID�� �μ��̸��� ������ �� �ִ� record Ÿ�� ����
    type dept_type is record( --���ڵ�Ÿ�� �̸� : �Ƹ�_type
--        id number(4),
--        name varchar2(100)
        
        id dept.dept_id%type,
        name dept.dept_name%type
    );
    
    rec_dept dept_type; --id/name�� �ʵ�� ������ ���ڵ�.
begin
    select dept_id, dept_name
    into rec_dept
    from dept
    where dept_id = 10;
    
    dbms_output.put_line(rec_dept.id||' - '||rec_dept.name);
    rec_dept.id := 20;
    rec_dept.name := '������ȹ��';
    update dept
    set dept_name = rec_dept.name
    where dept_id = rec_dept.id;
    
end;
/

--TODO: �Ʒ� select �� �������� ������ ����� ���� ���ڵ带 ����� SQL�������� �� Ÿ���� ������ �����ѵ� ����ϴ� ���ν����� �ۼ�.
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
�÷���

- ���� Ÿ���� ������ ������ �����ϴ� ����.
    - ���ڵ�� �پ��� Ÿ���� �ʵ带 �������� ���̺�ó�� ���� ROW�� ���� �� ����.
    - �÷����� ���� row�� ������ ����
- ����
  1. �����迭: Ű�� ������ ������ �÷���
  2. VARRAY  : ũ�Ⱑ ������ �ִ� �迭����
  3. ��ø���̺� : ũ�⸦ �����Ӱ� ���� ���ִ� �迭����

************************************************************************************************************************************************************************************ */

/* *********************************************************************************************
- �����迭(Associative Array)
    - Ű-�� ������ ������ �÷���
    - Ű�� INDEX�� �θ��� ������ Index-by ���̺��̶�� �Ѵ�.
	- ������ Ÿ������ ���ȴ�.
- ����
    - Ÿ�� ����
        - TYPE �̸� IS TABLE OF ��Ÿ�� INDEX BY Ű(�ε���)Ÿ��
        - ��Ÿ�� : ��� Ÿ�� ����
        - Ű(�ε���) Ÿ�� : ������ �Ǵ� PLS_INTEGER/BINARY_INTEGER Ÿ�Ը� ����.
    - ����ο� �����Ѵ�.
	- Ÿ���� ���� �ѵ� ������ Ÿ������ ����� �� �ִ�.
	- �� ���� : �迭�̸�(INDEX):=��
    - �� ��ȸ : �迭�̸�(INDEX)
********************************************************************************************* */


declare
    --key(index)Ÿ��: ����
    --��(value) Ÿ��: varchar2(100)
    --�����迭 Ÿ���̸�: �̸�_table_types
    type my_table_type is table of varchar2(100) index by binary_integer;
    
    --���� ����
    my_table my_table_type;
    
begin
    --�����迭�� �� ����.
    my_table(10) := 'test1';
    my_table(20) := 'test2';
    --�����迭�� �� ��ȸ
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
    into dept_table(10) --select����� �����迭�� �߰�.
    from dept
    where dept_id = 10;
    
    dbms_output.put_line(dept_table(10));
     
    select dept_name
    into dept_table(20) --select����� �����迭�� �߰�.
    from dept
    where dept_id = 20;
    
    dbms_output.put_line(dept_table(20));
end;
/

declare
    -- index: ����-dept_id, value: �μ����ڵ�(����)
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
-- 1. index�� ũ�� 10�� ���ڿ��� ���� date�� ������ �����迭 ����
-- 2. index�� ����, ���� dept ���̺��� loc�� ���� Ÿ���� �����迭 ����
declare
    --1�� ����
    type test01 is table of date index by varchar2(10);
    --2�� ����
    type test02 is table of dept.loc%type index by binary_integer; --pls_integer
    
    test01_tb test01;
    test02_tb test02;
    
begin
    --1�� Ÿ���� ������ �� ���� �� ���
    test01_tb('today') := sysdate;
    --2�� Ÿ���� ������ �� ���� �� ���
    test02_tb(10) := 'korea'; 
    
    dbms_output.put_line(test01_tb('today'));
    dbms_output.put_line(test02_tb(10));
end;
/

--TODO �μ� ID�� Index�� �μ� ���ڵ�(%ROWTYPE)�� Value�� ������ �����迭�� �����ϰ�
-- dept_id�� 10�� �μ��� dept_id�� 20 �� �μ��� ����(dept_id, dept_name, loc)�� ��ȸ�Ͽ� �����迭 ������ �ִ� ���ν����� �ۼ�
create or replace procedure test03 (v_dept_id in dept.dept_id%type)
is
    type test03 is table of dept%rowtype index by binary_integer;
    
    test03_tb test03;--�μ��������� ������ �÷���.
begin
    select *
    into test03_tb(v_dept_id)
    from dept
    where dept_id = v_dept_id;
    
    dbms_output.put_line(test03_tb(v_dept_id).dept_id||'-'||test03_tb(v_dept_id).dept_name||'-'||test03_tb(v_dept_id).loc);
end;
/

exec test03(20);


-- TODO: emp_id �� 100 ~ 120���� ������ �̸��� ��ȸ�� �����迭(index: emp_id, value: emp_name)�� �����ϴ� �ڵ带 �ۼ�.
declare
    type test04 is table of emp.emp_name%type index by binary_integer;
    
    test04_tb test04;
begin
	--�ݺ����� �̿��� 100 ~ 120 �� ������ �̸��� ��ȸ �� �����迭�� ���尡��
	for i in 100..120
    loop
        select emp_name
        into test04_tb(i)
        from emp
        where emp_id = i;
    end loop;
	
	--�����迭���� ��ȸ��� ���
    for i in 100..120
    loop
        dbms_output.put_line(test04_tb(i));
    end loop;
end;
/


/* *********************************************************************************************
- VARRAY(Variable-Size Array)
    - �������� �迭. 
		- ����� �迭�� ũ��(�ִ��Ұ���)�� �����ϸ� �� ũ�� ��ŭ�� ��Ҹ� ���尡��
        - ������ ���� �̻� ���� �� �� ������ ���� �����ϴ� ���� ����.
    - Index�� 1���� 1�� �����ϴ� ������ �ڵ����� �����ȴ�.
    - �����ڸ� ���� �ʱ�ȭ
		- �ݵ�� �����ڸ� �̿��� ������ ������ �ڿ������ �� �ִ�.
    - �Ϲ� ������ �������� ���� �����ؾ� �ϴ� ��� ���� ����(index�� ���� �����̹Ƿ�)
	- C �� Java�� �迭�� ����� �����̴�.
- ����    
    - Ÿ�� ����
        - TYPE �̸� IS VARRAY(�ִ�ũ��) OF ��Ұ�Ÿ��;
    - �ʱ�ȭ 
        - ���� := �̸�(�� [, ...]) 
        - �ʱ�ȭ �� ������ŭ�� ���� ���� 
    - �� ����(����) : �̸�(INDEX):=��
    - �� ��ȸ : �̸�(INDEX)
********************************************************************************************* */


declare
    type va_type is varray(5) of varchar2(100);
    va_arr va_type;
begin
    --�ʱ�ȭ
    va_arr := va_type('��','��','��');
    va_arr(2) := 'B';
    
    for idx in 1..3
    loop
        DBMS_OUTPUT.PUT_LINE(va_arr(idx));
    end loop;
    
end;
/
--dept_id 10,50,70�� �μ��� ������ ��ȸ => �����迭 ��� ���.
declare
    --����� ���� �����迭 Ÿ��.
    type dept_table_type is table of dept%rowtype index by binary_integer;
    --��ȸ�� �μ� id���� ���� varray
    type dept_id_list is varray(3) of dept.dept_id%type;
    
    dept_table dept_table_type;
    dept_arr dept_id_list;
begin
    dept_arr := dept_id_list(10, 50, 70); --��ȸ�� �μ�id�� varray�ʱ�ȭ.
    for i in 1..3
    loop
        select *
        into dept_table(dept_arr(i))
        from dept
        where dept_id = dept_arr(i);
    end loop;
    
    --��ȸ��� ���
    for i in 1..3
    loop
        dbms_output.put_line(dept_table(dept_arr(i)).dept_name); 
    end loop;
end;
/

/* *********************************************************************************************
- ��ø���̺�(Nested Table)
    - ����� ũ�⸦ �������� �ʰ� �����ڸ� �̿��� �ʱ�ȭ �Ҷ� ���Ե� ���� ���� ���� ũ�Ⱑ ��������.
    - �����ڸ� ����� �ʱ�ȭ �� ���
    - index �� 1���� 1�� �ڵ������ϴ� ������ ����.    
    - �Ϲ� ���̺��� �÷� Ÿ������ ���� �� �ִ�.
- ����
    - Ÿ�� ����
        - TYPE �̸� IS TABLE OF ��Ÿ��;
********************************************************************************************* */

declare
 type nt_table_type is table of number;
    nt_table nt_table_type;
    nt_table2 nt_table_type;
    
begin
    --�����ڸ� �̿��� �ʱ�ȭ.
    nt_table := nt_table_type(10,20,30,40,50);
    nt_table2 := nt_table_type(2,4,6,8,10,12,14,16,181111111111111);
    nt_table(2) := 2000; --����(����)
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
- �÷��� �޼ҵ�
 # DELETE : ��� ��� ����
 # DELETE(n) : index�� n�� ��� ���� (varray�� ��������)
 # DELETE(n, m) : index�� n ~ m �� ��� ���� (varray�� ��������)
 
 # EXISTS(index) : index�� �ִ� �� ���� boolean������ ��ȯ
 # FIRST : ù��° IDNEX ��ȯ
 # LAST : ������ INDEX ��ȯ
    - FOR idx IN �÷���.FIRST..�÷���.LAST  
 # PRIOR(index) : index ���� INDEX ��ȯ
 # NEXT(index) : index ���� INDEX ��ȯ

# COUNT: �÷��ǳ��� ��� ���� ��ȯ 

***************************************************************************************************************************** */

declare 
    type varr_type is varray(4) of varchar(20);
    
    varr varr_type;
begin
    varr := varr_type('a','b','c','d');
    dbms_output.put_line(varr.first||', '||varr.last);
    DBMS_OUTPUT.PUT_LINE(varr.next(3)||', '||varr.prior(3));
    if varr.exists(4) then DBMS_OUTPUT.PUT_LINE('index����');
    end if;
end;
/





-- TODO: emp���� emp_id�� 100 ~ 120�� �������� ������ ��ȸ�� �� �� ������ emp_copy�� �߰��ϴ� �ڵ带 �ۼ�.
DECLARE
    -- �����迭 Ÿ�� ����(��ȸ�� ���������� ����): key - emp_idŸ��, value:emp row
    type emp_tb_type is table of emp%rowtype index by binary_integer;
    -- �����迭 Ÿ�� ���� ����
    emp_tb emp_tb_type;
BEGIN
    -- �ݺ����� �̿��� emp_id�� 100 ~ 120 �� ���� ��ȸ�ؼ� �����迭�� ���� 
	for i in 100..120
    loop
        select * 
        into emp_tb(i)
        from emp
        where emp_id = i;
    end loop;
	
	
	-- �ݺ����� �̿��� �����迭�� ����� ��ȸ������� emp_copy ���̺� insert (FIRST, LAST �޼ҵ� �̿�)
    for i in emp_tb.first..emp_tb.last
    loop
        insert into emp_copy values emp_tb(i);
    end loop;
	
	
END;
/

select * from emp_copy;


