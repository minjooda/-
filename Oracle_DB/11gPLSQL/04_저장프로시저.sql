/* *********************************************************************
���ν���
 - Ư�� ������ ó���ϴ� ���밡���� ���� ���α׷�
 - �ۼ��� ����Ǹ� ������ �Ǿ� ��ü�� ����Ŭ�� ����Ǹ� EXECUTE�� EXEC ��ɾ�� �ʿ�ø��� ���밡��
����
CREATE [OR REPLACE] PROCEDURE �̸� [(�Ķ���� ����,..)]
IS
    [���� ����]
BEGIN
    ���౸��
[EXCEPTION
    ����ó������]
END;

- �Ķ���� ����
  - ���� ���� ����
  - ���� : ������ mode Ÿ�� [:=�ʱⰪ]
    - mode
      - IN : �⺻. ȣ���ϴ� ������ ���� ���� ���� �޾� ���ν��� ������ ���. �б� ���뺯��. 
      - OUT : ȣ���ϴ� ������ ������ ���� ������ ����. (����� return)
      - IN OUT : IN�� OUT�� ����� ��� �ϴ� ����
	- Ÿ�Կ� size�� �������� �ʴ´�. 
	- �ʱⰪ�� ���� �Ű������� ȣ��� �ݵ�� ���� ���޵Ǿ� �Ѵ�.


����
exec �̸�[(���ް�)]
execute �̸�[(���ް�)]

���ν��� ����
- DROP PROCEDURE ���ν����̸�

*********************************************************************** */
set serveroutput on;

drop procedure message_sp1;
create or replace procedure message_sp1
is
    --��������.
    v_msg varchar2(100);
begin
    --���౸�� �ۼ�.
    v_msg := 'Hello World!';
    dbms_output.put_line(v_msg);
end;
/ --ctrl + enterŰ: ����Ŭ ������ ����.

--����
execute message_sp1;
exec message_sp1;
/
create or replace procedure message_sp2 (p_msg in varchar2 := 'Hello World!')
is
    v_msg varchar2(100);
begin
    DBMS_OUTPUT.PUT_LINE(p_msg);
--    p_msg := '���޼���';--in��� �Ķ���ʹ� �� ������ �ȵȴ�.
    v_msg := p_msg;
    dbms_output.put_line(v_msg);
    v_msg := '���޼���';
    dbms_output.put_line(v_msg);
end;
/
execute message_sp2('�ȳ��ϼ���.');
execute message_sp2('HI~~~');
execute message_sp2;

create or replace procedure message_sp3 (p_msg in varchar2, p_num pls_integer)
is
begin
    DBMS_OUTPUT.PUT_LINE(p_msg||p_num);  
end;
/
execute message_sp3('�ȳ��ϼ���.', 10);

create or replace procedure message_sp4(p_msg in out varchar2) --��ȯ���� ������ ������ �޴´�.
is
begin
    DBMS_OUTPUT.PUT_LINE(p_msg);
    p_msg := 'message_sp4������ �޼���';
end;
/

create or replace procedure caller_sp
is
    v_msg varchar2(100);
begin
    --message_sp4�� ȣ�� - �޼����� ��ȯ�ϴ� sp.
    v_msg := '�⺻��';
    
    message_sp4(v_msg);
    DBMS_OUTPUT.PUT_LINE(v_msg);
end;
/

exec caller_sp;

--�Ű������� �μ�ID, �μ��̸�, ��ġ�� �޾� DEPT�� �μ��� �߰��ϴ� Stored Procedure �ۼ�
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


--�Ű������� �μ�ID�� �Ķ���ͷ� �޾� ��ȸ�ϴ� Stored Procedure
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


-- TODO ������ ID�� �Ķ���ͷ� �޾Ƽ� ������ �̸�(emp.emp_name), �޿�(emp.salary), ����_ID (emp.job_id), �Ի���(emp.hire_date)�� ����ϴ� Stored Procedure �� ����
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

-- TODO ����_ID(job.job_id)�� �Ķ���ͷ� �޾Ƽ� ������(job.job_title)�� �����ִ�/�ּ� �޿�(job.max_salary, min_salary)�� ����ϴ� Stored Procedure �� ����
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
    
    DBMS_OUTPUT.PUT_LINE('������: '||v_job.job_title);
    DBMS_OUTPUT.PUT_LINE('�ִ�޿�: '||v_job.max_salary);
    DBMS_OUTPUT.PUT_LINE('�ּұ޿�: '||v_job.min_salary);
end;
/

    
-- TODO: ����_ID�� �Ķ���ͷ� �޾Ƽ� ������ �̸�(emp.emp_name), ���� ID(emp.job_id), ������(job.job_title) ����ϴ� Stored Procedure �� ����

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



-- TODO ������ ID�� �Ķ���ͷ� �޾Ƽ� ������ �̸�(emp.emp_name), �޿�(emp.salary), �ҼӺμ��̸�(dept.dept_name), �μ���ġ(dept.loc)�� ����ϴ� Stored Procedure �� ����
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



-- TODO ������ ID�� �Ķ���ͷ� �޾Ƽ� ������ �̸�(emp.emp_name), �޿�(emp.salary), 
-- ������ �ִ�޿�(job.max_salary), ������ �ּұ޿�(job.min_salary), ������ �޿����(salary_grade.grade)�� ����ϴ� store procedure�� ����
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


-- TODO: ������ ID(emp.emp_id)�� �Ķ���ͷ� �޾Ƽ� �޿�(salary)�� ��ȸ�� �� �޿��� �޿������ ����ϴ� Stored Procedure �� ����.
-- �����޿� ��� ����:  �޿��� $5000 �̸� �̸� LOW, %5000 ~ $10000 �̸� MIDDLE, $10000 �ʰ��� HIGH�� ���
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
    
    --if��
    if v_salary < 5000 then v_msg := 'LOW';
    elsif v_salary between 5000 and 10000 then v_msg := 'MIDDLE';
    else v_msg := 'HIGH';
    end if;
    
    --case�� 
    case when v_salary < 5000 then v_msg := 'LOW';
         when v_salary between 5000 and 10000 then v_msg := 'MIDDLE';
         else v_msg := 'HIGH';
    end case;
    
    DBMS_OUTPUT.PUT_LINE(v_msg);
end;
/





