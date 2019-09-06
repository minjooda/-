
/* ***********************************************************************************************
���� ���
- ���� ����
  - DECLARE ������ �Ѵ�.
  - ����: ������ [CONSTANT] ������Ÿ�� [NOT NULL] [ := �⺻��] 
     - CONSTANT : ���� ������ �� ���� ����. ����� �ݵ�� �ʱ�ȭ �ؾ� �Ѵ�.
	 - ������Ÿ��: ����Ŭ ������Ÿ��+PL/SQL ������Ÿ�� �����Ѵ�.
	 - NOT NULL: ������ NULL�� ������ �ȵ��� ������������ ����. ����� �ݵ�� �ʱ�ȭ �Ǿ���.
	 - ����� [DEFAULT ��] ���� �ʱⰪ ���� ����
  - ���Կ�����
     -  ���� := ��
  

*********************************************************************************************** */

declare
--������(identifier) ������ Ÿ��       
    v_message1      varchar2(100); --null�� �ʱ�ȭ
    v_message2 varchar2(100) not null := 'Hello World!';
    c_num constant pls_integer default 20; 
    --not null������ constant(���)�� ����� �ʱ�ȭ �ؾ��Ѵ�.
begin
    v_message1 := 'Test1';
    dbms_output.put_line(v_message1);
    
    v_message2 := '&msg';
    dbms_output.put_line(v_message2);
    
--    c_num := 5000; --������� ���� ���Ҵ� �� �� ����.
    dbms_output.put_line(c_num);

end;
/
-- TODO: DECLARE ���� ���� ������ ������ ������(�̸�, ����, �ּ� ���)�� �����ϰ� ���� ���(BEGIN)���� ���� ������ �� ����ϴ� �ڵ� �ۼ�.
declare 
    v_name nvarchar2(10);
    v_age pls_integer;
    v_address nvarchar2(50);
begin
    v_name := 'ȫ�浿';
    v_age := 55;
    v_address := '����� ������ ...';
    
    dbms_output.put_line('�̸�: '||v_name);
    dbms_output.put_line('����: '||v_age);
    dbms_output.put_line('�ּ�: '||v_address);
end;
/



-- TODO: emp ���̺��� �̸�(emp_name), �޿�(salary), Ŀ�̼Ǻ���(comm_pct), �Ի���(hire_date) �� ���� ������ �� �ִ� ������ �����ϰ�
-- &������ �̿��� ���� �Է� �޾� ����ϴ� �ڵ带 �ۼ�.
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
- %TYPE �Ӽ�
  - �÷��� ������Ÿ���� �̿��� ������ Ÿ�� �����
  - ����:   ���̺��.�÷�%TYPE
    ex) v_emp_id emp.emp_id%TYPE
*********************************************************** */
-- dept ���̺��� �÷����� ������ Ÿ���� �̿��� ���� ����
DECLARE
  v_dept_id dept.dept_id%TYPE;
  v_dept_name dept.dept_name%TYPE := '����';
  v_loc dept.loc%TYPE;
BEGIN
  v_dept_id := 2000;
  v_loc := '����';
  DBMS_OUTPUT.PUT_LINE(v_dept_id||', '||v_dept_name||', '||v_loc);
END;
/
-- TODO: job ���̺��� �÷����� Ÿ���� �̿��� v_job_id, v_job_title, v_max_salary, v_min_salary �� �����ϰ� & ������ �̿��� ���� �Է� �޾� ����ϴ� �ڵ� �ۼ�
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
���ε� ����, ȣ��Ʈ ����

-����
variable ������ Ÿ��; = var ������ Ÿ��;
var name varchar2(100);
-���
:������
:name 

*************************************** */
var e_id number;
exec :e_id := 200;

select * from emp
where emp_id = :e_id;


/* ******************************************************************
 PL/SQL���� ������(Sequence) ���
 - select �������� sequence�̸�.nextval �� �ٷ�ȣ�� ����.
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
���ν������� �Լ� ���
 - ����/����/��¥/��ȯ �Լ��� ó������� 1���� �� ���� �������� �ܵ����� ����� �� �ִ�.
 - �����Լ��� DECODE() �Լ��� SQL�������� ����� �� �ִ�. 
******************************************************************* */
BEGIN
    DBMS_OUTPUT.PUT_LINE(length('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'));
END;


-- TODO: ������ ������� ����ϴ� �ڵ带 �ۼ�
/*
"����� ������ ���ﵿ" ���ڿ��� ���̸� ���
"Hello World" �� �빮�ڷ� ���
100.23456 �� �Ҽ��� ù��° ���Ͽ��� �ݿø� �ؼ� ���
SYSDATE���� ��:��:�� �� ���
*/
BEGIN
    DBMS_OUTPUT.PUT_LINE(LENGTH('����� ������ ���ﵿ'));
    DBMS_OUTPUT.PUT_LINE(UPPER('Hello World'));
    DBMS_OUTPUT.PUT_LINE(ROUND(100.23456, 1));
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'HH24:MI:SS'));
END;
/

/* *************************************************************
��ø ����
- PL/SQL �����ϳ��� PL/SQL ������ ��ø�ؼ� �ۼ��� �� �ִ�.
- ���� �����Ͽ����� �ٱ��� ���౸������ ������ ������ ����� �� ������ �ݴ�� �ȵȴ�.
*************************************************************** */

DECLARE
    v_outer varchar2(100) := 'v_outer';
BEGIN
    declare
        v_inner varchar2(100) := 'v_inner';
    begin
        DBMS_OUTPUT.PUT_LINE('INNER: '||v_outer); --outer�� ������ inner���� ��� ����.
        DBMS_OUTPUT.PUT_LINE('INNER: '||v_inner);
    end;
    DBMS_OUTPUT.PUT_LINE('OUTER: '||v_outer);
--    DBMS_OUTPUT.PUT_LINE('OUTER: '||v_inner); --inner���� ����� ������ outer���� ��� �Ұ���.
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
            DBMS_OUTPUT.PUT_LINE('INNER: '||outer_p.v_outer); --outer ���ν����� �̸��ο�.
            DBMS_OUTPUT.PUT_LINE('INNER: '||v_inner);
        end;
        DBMS_OUTPUT.PUT_LINE('OUTER: '||v_outer);
    END;
end;
/
/* *************************************************************************************	

DML ����
- insert/delete/update
- SQL�� ����
- ó���� commit

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
  v_dept_name := '������';
  v_loc := '�λ�';
  INSERT INTO dept_copy VALUES (v_dept_id + 1, v_dept_name, v_loc);
  INSERT INTO dept_copy VALUES (v_dept_id + 2, v_dept_name, v_loc);
  commit;
END;
/
rollback;
select * from dept_copy order by 1 desc;

--delete
BEGIN
  delete from dept_copy where loc = '����'; 
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
-- TODO : emp ���̺� ���ο� �������� �߰��ϴ� ������ �ۼ�.
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

-- TODO : ������ �߰��� ���� ���� salary�� comm_pct �� ���� ���� �ø��� ������ �ۼ�
DECLARE
    v_emp_name emp.emp_name%TYPE := :emp_name;
BEGIN
  update emp_test set salary = salary * 3
  where emp_name = v_emp_name;
  commit;
END;
/

-- TODO : ������ �߰��� ���� ���� �����ϴ� ������ �ۼ�
DECLARE
    v_emp_name emp.emp_name%TYPE := :emp_name;
BEGIN
  delete from emp_test where emp_name = v_emp_name;
  commit;
END;
/

/* *************************************************************************************
��ȸ����
select into �� 

select ��ȸ�÷�
INTO   ��ȸ���� ������ ����
from ���̺�
where ��������
group by 
having
order by

************************************************************************************* */

-- �μ� ID(dept_id)�� 10�� �μ��� �̸�(dept_name), ��ġ(loc) �� ��ȸ�ϴ� ����
DECLARE
  v_dept_name dept.dept_name%TYPE;
  v_loc dept.loc%TYPE;
BEGIN
  SELECT dept_name, loc
  INTO  v_dept_name, v_loc
  FROM dept 
  WHERE dept_id = 10;
  
  DBMS_OUTPUT.PUT_LINE('�μ��̸�: '||v_dept_name||', '||'��ġ: '||v_loc);
END;
/

--���� id(emp.emp_id) �� 110 �� ������ �̸�(emp.emp_name), �޿�(emp.salary), �μ� ID(dept.dept_id) �μ��̸�(dept.dept_name) ����ϴ� �����ۼ�
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


-- TODO ������ ID�� 120�� ������ �̸�(emp.emp_name), �޿�(emp.salary), ����_ID (emp.job_id), �Ի���(emp.hire_date)�� ����ϴ� ���� �ۼ�
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
  
  DBMS_OUTPUT.PUT_LINE('�̸�: '||v_emp_name);
  DBMS_OUTPUT.PUT_LINE('�޿�: '||v_salary);
  DBMS_OUTPUT.PUT_LINE('����: '||v_job_id);
  DBMS_OUTPUT.PUT_LINE('�Ի���: '||v_hire_date);
END;
/

-- TODO �μ����̺� dept_id=9900, dept_name='�濵��ȹ', loc='����' �� insert �ϰ� dept_id�� ��ȸ�Ͽ� �Է°���� ����ϴ� ������ �ۼ�.
DECLARE
    v_dept_id dept.dept_id%TYPE;
    v_dept_name dept.dept_name%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    insert into dept values (9900, '�濵��ȹ', '����');
    SELECT dept_id, dept_name, loc
    INTO v_dept_id, v_dept_name, v_loc
    FROM dept
    WHERE  dept_id = 9900;
    commit;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_id||', '||v_dept_name||', '||v_loc);
    
END;
/

rollback;

-- TODO ����_ID�� 110�� ������ �̸�(emp.emp_name), ���� ID(emp.job_id), ������(job.job_title) ����ϴ� ���� �ۼ�
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










