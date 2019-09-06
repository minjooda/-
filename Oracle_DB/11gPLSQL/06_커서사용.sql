/* *********************************************************************************************************************************************
Ŀ��(Cursor)
 - Ŀ���� ��ǻ�Ϳ��� ���� ��ġ�� ����Ű�� ���� ���Ѵ�.
 - ����Ŭ���� Ŀ��
    - ������ SQL���� ó���� ����� ����Ű�� ������ Ŀ���� �̿��� ó���� ��� ������ ������ ���� �� �ִ�.
 - ��ȸ����� ���� �̻��� ��� �ݵ�� Ŀ���� ����ؾ� �Ѵ�.
	- select into �δ� ������ ����� ��ȸ�����ϴ�.

- Ŀ���� ���� �ܰ�
    - Ŀ�� ����
    - Ŀ�� ����(open)
    - ��ġ (fetch)
    - Ŀ�� �ݱ� (close)
    
- ������ Ŀ��, ����� Ŀ��
    - ������ Ŀ�� 
        - ����Ŭ ���ο��� �ڵ����� �����Ǿ� ���Ǵ� Ŀ���� PL/SQL ��Ͽ��� 
		  �����ϴ� ����(INSERT,UPDATE,DELETE, SELECT INTO)�� ����� ������ �ڵ����� ������.
        - ���� ���� �ܰ谡 �ڵ����� ó���ȴ�.
    - ����� Ŀ�� 
        - ����ڰ� ���� �����ؼ� ����ϴ� Ŀ���� select ����� ��ȸ�� �� ����Ѵ�.
        - ���� ������ ���� �ܰ踦 ��������� ó���ؾ� �Ѵ�.

- Ŀ�� �Ӽ�
    - Ŀ���� �����ϴ� ��������� ������.
      - Ŀ���̸�%FOUND      : ��� ���տ��� ��ȸ������ ���� �ִ��� ���� ��ȯ. 1�� �̻� ������ ��(True) ������ ����(False) ��ȯ
      - Ŀ���̸�%NOTFOUND   :  %FOUND�� �ݴ�. Cursor �� ���� ���������� ���� Ŀ���� ��� set�� ���ڵ尡 ������ ��(True)
      - Ŀ���̸�%ROWCOUNT   :  SQL���� ���� ���� ���� ���� ��ȯ
      - Ŀ���̸�%ISOPEN     : ���� Ŀ���� OPEN �����̸� ��(True), CLOSE �����̸� ����(False)
      - Ŀ���̸� 
        - ������ Ŀ�� :  SQL ����. (��: SQL%FOUND)
        - ����� Ŀ�� :  Ŀ���̸� ���� (��: my_cursor%FOUND)
*********************************************************************************************************************************************  */    
SET SERVEROUTPUT ON;

-- ������ Ŀ���� �� (update ���� ���)
begin
    update emp
    set emp_name = emp_name
    where emp_id > 150;
    
    dbms_output.put_line(sql%rowcount);
    
end;
/


-- ������ Ŀ���� ��(select ��ȸ��� ���)
declare 
    v_name emp.emp_name%type;
begin
    select emp_name
    into v_name
    from emp
    where emp_id = 200;
    
    if sql%found then --��ȸ������ ���� ����������,
        DBMS_OUTPUT.PUT_LINE(sql%rowcount);
    end if;
end;
/


--TODO
/* *********************************************************************
--Database���� DML�� ����Ǹ� �� ����� ������ ���̺�
	- log_no: ��ȣ
	- category : � ������ ����Ǿ����� ���� 
		- 'I' - insert, 'U' - update, 'D' - delete
	- exec_datetime : DML���� ���� �Ͻ�
	- table_name : ����� ���̺�
	- row_count : ������ ����� ���� ����
********************************************************************* */
drop sequence dml_log_no_seq;
create sequence dml_log_no_seq;

drop table dml_log;
create table dml_log(
    log_no number primary key,
    category char not null constraint ck_dml_log_category check(category in ('I', 'D', 'U')),
    exec_datetime date default sysdate not null,
    table_name varchar2(100) not null,
    row_count number not null
);


/* *********************************************************************
 dml_log_no_seq ���̺��� log_no �÷��� ���� ������ sequence.
*********************************************************************** */
drop table emp_copy;
create table emp_copy as select * from emp;

-- TODO: �Ķ���ͷ� dept_id�� �޾Ƽ� �� �μ��� �Ҽӵ� �������� �����ϰ� dml_log�� ����� ����� stored procedure�� ����

create or replace procedure delete_emp_by_dept_id_sp(v_dept_id in emp_copy.dept_id%type)
is
    v_del_cnt binary_integer; --���� ����� ������ ����.
    
begin
    delete from emp_copy where dept_id = v_dept_id;
    
    v_del_cnt := sql%rowcount;
    insert into dml_log values (dml_log_no_seq.nextval, 'D', sysdate, 'emp_copy', v_del_cnt);
    
end;
/

exec delete_emp_by_dept_id_sp(110);
select * from dml_log;



/* ************************************************************ 
- ����� Ŀ�� ��� ����
1. Ŀ�� ����
    - CURSOR Ŀ���̸� [(�Ķ�����̸� datatype[:=�⺻��], ...)] IS 
            select ����;
    
	- �Ķ����
        - Ŀ�� ���� ���޹��� ���� �ִ� ��� ����(������ ����) 
		- ������ ������Ÿ�� [:= �⺻��] 
		- �⺻���� �ִ� ��� ȣ��� �� ������ ������ �� �ִ�.
		
2. Ŀ������
    - OPEN Ŀ���̸� [(���ް�1, ���ް�2,..);
    - Ŀ���� �Ķ���Ͱ� ����� ��� ������ ���� ( ) �� ����. ������ () ����
	
3. Ŀ���κ��� ��ȸ ��� ������ �б�
    - FETCH Ŀ���̸� INTO ���� [,..]
	- ���� : Ŀ���� ��ȯ�ϴ� ��ȸ ������� ���� ����. select ���� �÷� ������ŭ�� ������ �����Ѵ�. 
	
4. Ŀ�� �ݱ�
    CLOSE Ŀ���̸�;
    
- Ŀ�� ���Ǵ� ����ο��� �ۼ�
- Ŀ�� ���� ~ �ݱ�� �����ο��� �ۼ�
************************************************************ */
-- DEPT_ID �� 100 �� ������ ���� ��ȸ


declare 
    rec_emp emp%rowtype;
    --1. Ŀ���� ����: � sql���� ���� ����� ����� Ŀ������ ����.
    cursor emp_cur is select * from emp where dept_id = 100;
        
begin
    --2. Ŀ������(open): 1���� ������ sql���� ����ǰ� �� ���� ����� Ŀ���� ����ȴ�.
    open emp_cur;
    
    --3. ��ȸ��� ��������.

    fetch emp_cur into rec_emp; --�� ���� ��ȸ.
    DBMS_OUTPUT.PUT_LINE(rec_emp.emp_id||' - '||rec_emp.emp_name);

    --4. Ŀ���ݱ�
    close emp_cur;
    
end;
/



-- ******************** �Ķ���Ͱ� �ִ� CURSOR  ************************
declare 
    rec_emp emp%rowtype;
    --1. Ŀ���� ����: � sql���� ���� ����� ����� Ŀ������ ����.
    cursor emp_cur(cp_dept_id dept.dept_id%type) is select * from emp where dept_id = cp_dept_id;
        
begin
    --2. Ŀ������(open): 1���� ������ sql���� ����ǰ� �� ���� ����� Ŀ���� ����ȴ�.
    open emp_cur(100);
    
    --3. ��ȸ��� ��������.
    fetch emp_cur into rec_emp; --�� ���� ��ȸ.
    DBMS_OUTPUT.PUT_LINE(rec_emp.emp_id||' - '||rec_emp.emp_name);


    --4. Ŀ���ݱ�
    close emp_cur;
    
    open emp_cur(120);
    
    fetch emp_cur into rec_emp; --�� ���� ��ȸ.
    DBMS_OUTPUT.PUT_LINE(rec_emp.emp_id||' - '||rec_emp.emp_name);
    fetch emp_cur into rec_emp; --�� ���� ��ȸ.
    DBMS_OUTPUT.PUT_LINE(rec_emp.emp_id||' - '||rec_emp.emp_name);
    
    close emp_cur;
end;
/





/* *********************************************************************************************
- LOOP �ݺ����� �̿��� ��ȸ�� ��� ��� ��ȸ
    - cursor �� fetch ������ loop ������ �ݺ��Ѵ�. 
    - ��ȸ ������ ���� ������ LOOP �� ���� ���´�. 
********************************************************************************************* */
declare
    cursor dept_cur(cp_loc dept.loc%type) is 
        select *
        from dept
        where loc = cp_loc;
        
    rec_dept dept%rowtype;
begin
    open dept_cur('New York'); --Ŀ������
    --loop���� �̿��� fetch
    loop
        fetch dept_cur into rec_dept;
        exit when dept_cur%notfound;
        
        DBMS_OUTPUT.PUT_LINE(rec_dept.dept_id||rec_dept.dept_name);
       
    end loop;
    
    close dept_cur;

end;
/





-- TODO: EMP���̺��� Ŀ�̼�(comm_pct)�� NULL�� ������ ID(emp_id), �̸�(emp_name) , �޿�(salary), Ŀ�̼�(comm_pct)�� �̸� ������������ ������ ����� ���
declare
    cursor emp_cur is select * from emp where comm_pct is null order by emp_name;
    rec_emp emp%rowtype;
begin
    open emp_cur;
    loop
        fetch emp_cur into rec_emp;
        exit when emp_cur%notfound;
        
        DBMS_OUTPUT.PUT_LINE(rec_emp.emp_id||'-'||rec_emp.emp_name||'-'||rec_emp.salary||'-'||'null');
    end loop;
    close emp_cur;
end;
/


-- TODO: DEPT ���̺��� ��ġ�� 'New York' �� �μ����� �μ�ID, �μ��� ���
declare
    cursor dept_cur(cp_loc dept.loc%type) is 
        select *
        from dept
        where loc = cp_loc;
        
    rec_dept dept%rowtype;
begin
    open dept_cur('New York'); --Ŀ������
    --loop���� �̿��� fetch
    loop
        fetch dept_cur into rec_dept;
        exit when dept_cur%notfound;
        
        DBMS_OUTPUT.PUT_LINE(rec_dept.dept_id||rec_dept.dept_name);
    end loop;
    close dept_cur;

end;
/


/* *********************************************************************************************
FOR ���� �̿��� CURSOR ��� ��ȸ
FOR ���ڵ� IN Ŀ���� [(���ް�1, ���ް�2,..)]
LOOP
    ó�� ����
END LOOP;
********************************************************************************************* */
declare 
    cursor dept_cur(cp_loc dept.loc%type) is
        select * from dept
        where loc = cp_loc;
begin
    for dept_row in dept_cur('Seattle') --for������ Ŀ���� open, fetch�� ���� dept_row�� �Ҵ�.
    loop 
        DBMS_OUTPUT.PUT_LINE(dept_row.dept_name||'-'||dept_row.loc);
    end loop; --�ݺ��� �����鼭 �ڵ� close.
    
    if dept_cur%isopen then --���� Ŀ���� open���� ��ȸ. -true: open, false: close
        DBMS_OUTPUT.PUT_LINE('��������');
    else
        DBMS_OUTPUT.PUT_LINE('��������');
    end if;
end;
/


-- TODO: EMP���̺��� Ŀ�̼�(comm_pct)�� NULL�� ������ ID(emp_id), �̸�(emp_name) , �޿�(salary), Ŀ�̼�(comm_pct)�� �̸� ������������ ������ ����� ���
declare
    cursor emp_cur is select * from emp where comm_pct is null order by emp_name;
begin
    for rec_emp in emp_cur
    loop
        DBMS_OUTPUT.PUT_LINE(rec_emp.emp_id||'-'||rec_emp.emp_name||'-'||rec_emp.salary||'-'||'null');
    end loop;
end;
/

-- TODO: DEPT ���̺��� ��ġ�� 'New York' �� �μ����� �μ�ID, �μ��� ���
declare
    cursor dept_cur(cp_loc dept.loc%type) is 
        select *
        from dept
        where loc = cp_loc;

begin
    for rec_dept in dept_cur('New York')
    loop
        DBMS_OUTPUT.PUT_LINE(rec_dept.dept_id||rec_dept.dept_name);
    end loop;
end;
/


DROP TABLE dept_copy;
CREATE TABLE dept_copy AS select * from dept;
-- TODO: EMP ���̺��� salary�� 13000 �̻��� �������� �Ҽӵ� �μ�(DEPT_COPY���̺�)�� loc�� '����'���� �����Ͻÿ�.
declare 
    v_dept_id dept.dept_id%type;
    
    cursor dept_id_cur is 
        select dept_id from emp where salary >= 13000;
begin
    /*open dept_id_cur;
    loop
        fetch dept_id_cur into v_dept_id;
        exit when dept_id_cur%notfound;
        update dept_copy
        set loc = '����'
        where dept_id = v_dept_id;
    end loop;*/
    
    for d_row in dept_id_cur
    loop
        update dept_copy
        set loc = '��õ'
        where dept_id = d_row.dept_id;
    end loop;
    
end;
/

select * from dept_copy;



/* *********************************************************************************************
FOR���� ���� Ŀ���� ���� ����

FOR ���ڵ� IN (SELECT ��)
LOOP
   ó������
END LOOP;
********************************************************************************************* */

begin
    for d_row in (select * from dept) 
    loop
--        dbms_output.put_line(d_row.dept_id||'/'||d_row.dept_name||'/'||d_row.loc);
    if d_row.loc = 'New York' then
        insert into dept_copy values d_row;
    end if;
    end loop;
    
end;
/
-- TODO: ���� ID (job.job_id)�� �޿� �λ��(0~1)�� �Ķ���ͷ� �޾Ƽ� �� ������ ����ϴ� �������� �޿�(emp.salary)�� 
--       ������ max_salary(job.max_salary) * �λ�� ��ŭ �λ�ó���ϴ� stored procdure�� ����.
create or replace procedure proc_test(v_job_id job.job_id%type, v_comm_pct emp.comm_pct%type)
is
    v_max_salary job.max_salary%type;
begin
    select max_salary
    into v_max_salary
    from job
    where job_id = v_job_id;
    
    for j_row in (select emp_id from emp where job_id = v_job_id)
    loop
        update emp set salary = salary + v_max_salary * v_comm_pct where emp_id = j_row.emp_id;
    end loop;
   
end;
/

exec proc_test('FI_ACCOUNT', 0.3);

-- TODO: EMP���̺��� Ŀ�̼�(comm_pct)�� NULL�� ������ ID(emp_id), �̸�(emp_name) , �޿�(salary), Ŀ�̼�(comm_pct)�� 
-- �̸� ������������ ������ ����� ����ϴ� stored Procedure�� ����
begin
    for e_row in (select emp_id, emp_name, salary, comm_pct 
                  from emp 
                  where comm_pct is null
                  order by 2)
    loop
        DBMS_OUTPUT.PUT_LINE(e_row.emp_id||'-'||e_row.emp_name||'-'||e_row.salary||'-'||'null');
    end loop;
end;
/

-- TODO: DEPT ���̺��� ��ġ�� 'New York' �� �μ����� �μ�ID, �μ��� ���
begin
    for d_row in (select dept_id, dept_name from dept where loc = 'New York')
    loop
        dbms_output.put_line(d_row.dept_id||d_row.dept_name);
    end loop;
end;
/




-- TODO: �⵵�� �Ķ���ͷ� �޾� ���� �Ի��� �������� ID, �̸�, �޿�, �Ի����� ����ϴ� Procedure ����
create or replace procedure EX_06_01 (v_date varchar2) --�Ķ���ʹ� ũ�⸦ ������ �ʴ´�.
is
begin
    for e_row in (select emp_id, emp_name, salary, hire_date 
                  from emp
                  where to_char(hire_date,'yyyy') = v_date)
    loop
        DBMS_OUTPUT.PUT_LINE(e_row.emp_id||'-'||e_row.emp_name||'-'||e_row.salary||'-'||e_row.hire_date);
    end loop;
end;
/

EXEC EX_06_01('2005');
EXEC EX_06_01('2006');


--TODO: �μ��� �̸�(dept.dept_name)�� �Ķ���ͷ� �޾Ƽ� 
--�� �μ��� ���� ������ ID(emp.emp_id), �����̸�(emp.emp_name), �޿�(emp.salary)�� �޿��� ���� ������ ����ϴ� stored Procedure�� ����.  
create or replace procedure EX_06_02 (v_dept_name dept.dept_name%type)
is
begin

    
    for e_row in (select emp_id, emp_name, salary
                  from emp e, dept d
                  where e.dept_id = e.dept_id and dept_name = v_dept_name
                  order by 3 desc)
    loop
        DBMS_OUTPUT.PUT_LINE(e_row.emp_id||'-'||e_row.emp_name||'-'||e_row.salary);
    end loop;
    
end;
/

EXEC EX_06_02('IT');
EXEC EX_06_02('Purchasing');



--TODO: ������  �Ķ���ͷ� �޾Ƽ� �� ���� �̻��� ������ ������ �μ��� ID(dept.dept_id), �μ��̸�(dept.dept_name)�� ����ϴ� stored Procedure�� ����.
EXEC EX_06_03(3);
EXEC EX_06_03(10);

create or replace procedure EX_06_03 (count_emp pls_integer)
is
begin

    for d_row in (select dept_id, dept_name
                    from dept
                    where dept_id in(select dept_id 
                                    from emp 
                                    group by dept_id 
                                    having count(*) >= count_emp))
    loop
        dbms_output.put_line(d_row.dept_id||d_row.dept_name);
    end loop;
end;
/

create or replace procedure EX_06_03 (count_emp pls_integer)
is
    cursor dept_id_cur is 
        select dept_id 
        from emp 
        group by dept_id 
        having count(*) >= count_emp;
                            
    cursor dept_cur(cp_dept_id dept.dept_id%type)is 
        select dept_id, dept_name
        from dept
        where dept_id = cp_dept_id;
    
begin
    for d_row in dept_id_cur
    loop
        for d_row2 in dept_cur(d_row.dept_id)
        loop
            dbms_output.put_line(d_row2.dept_id||'-'||d_row2.dept_name);
        end loop;
    end loop;
end;
/
/* **********************************
Ŀ�̼� ���� ���̺�
********************************** */
create table commission_trans(
    emp_id number(6), 
    commission number,
    comm_date date
);
-- TODO: EMP ���̺��� COMM_PCT �� �ִ�(not null) ������ Ŀ�̼�(salary * comm_pct)�� commission_trans ���̺� �����ϴ� stored Procedure�� ����.
-- comm_date�� ���� �Ͻø� �ִ´�.
create or replace procedure EX_06_04
is 
begin
    for test in (select emp_id, salary, comm_pct from emp where comm_pct is not null)
    loop
        insert into commission_trans values( test.emp_id, test.salary * test.comm_pct, sysdate);
    end loop;
end;
/

exec EX_06_04;
SELECT * FROM commission_trans;



