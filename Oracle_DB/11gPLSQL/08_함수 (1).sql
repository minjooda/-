/* ***************************************************************************************
�Լ� (FUNCTION)
- �̸� �����ϵǾ� ���� ������ ��ü�� SQL�� �Ǵ� PL/SQL�� ������ ȣ��Ǿ� ���Ǵ� 
  �������α׷�.
- ȣ���ڷ� ���� �Ķ���� ���� �Է� �޾� ó���ѵ� �� ����� ȣ���ڿ��� ��ȯ�Ѵ�. 
	- �Ķ���ʹ� �� ���� �� �� �ִ�.
- ��Ʈ�� �Լ�
	- ����Ŭ���� �����ϴ� �����Լ�
- ����� ���� �Լ��̸�	
	- ����� �����Լ�
	
- ����� ���� �Լ� ����
	CREATE [OR REPLACE] FUNCTION �Լ��̸� [(�Ķ����1, �Ķ����2, ..)]
		RETURN datatype
	IS
		-- �����: ����, ����� ����
	BEGIN
		-- ���� �� : ó������
		RETURN value;
	[EXCETPION]
		-- ����ó�� ��
	END;
	
	
	- RETURN ��ȯ������Ÿ��
		- ȣ���ڿ��� ������ ��ȯ���� Ÿ�� ����
		- char/varchar2 �� number�� ��� size�� �������� �ʴ´�.
		- ���� �ο��� `return ��` ������ �̿��� ó������� ��ȯ�Ѵ�.
	- �Ķ���� 
		- ���� : 0 ~ N��
		- IN ��常 ����. 
		- ����
			������ ������Ÿ�� [:=�⺻��]
		- �⺻���� ���� �Ű��������� ȣ���ڿ��� �ݵ�� ���� �����ؾ� �Ѵ�.
		
	
�Լ� ����
DROP FUNCTION �Լ���;
*************************************************************************************** */
-- �Ű����� ���� �Լ� ���� �� ȣ��
create or replace function ex_08_01_fn
    return varchar2
is
begin
    return '�ȳ��ϼ���';
end;
/
select ex_08_01_fn(), sysdate from dual;
select ex_08_01_fn from dual;
select emp_name, ex_08_01_fn() �޼���  from emp;

--�Ű������� 1�� �ִ� �Լ�
--create or replace function ex_08_02_fn(p_num binary_integer)
create or replace function ex_08_02_fn(p_num binary_integer := 0)
    return varchar2
is
begin
    return p_num||'��';
end;
/
select ex_08_02_fn(10000) from dual;
select ex_08_02_fn from dual;
select ex_08_02_fn(salary) from emp;

--�⺻���� �ִ� �Ű������� ���� �Լ�




--�Ű������� �������� �Լ�
select ex_8_3_fn(10,20, 0, '�޷�') from dual;

create or replace function ex_8_3_fn(p_num1 binary_double:=0, 
                                     p_num2 binary_double:=0,
                                     p_num3 binary_double:=0,
                                     p_cur varchar2:='��')
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
select ex_8_3_fn(10,20, '�޷�') from dual;
select ex_8_3_fn(10.5, 20.5, 30.5, '�޷�') from dual;

--  emp_id�� �޾Ƽ� �� ������ Ŀ�̼�(salary * comm_pct)�� ���� ��ȯ�ϴ� �Լ� 
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
        ex_8_5(emp_id) ��갪, 
        comm_pct, 
        salary 
from emp;


select * from emp where emp_id = 500;



-- TODO: �Ű������� ���� �ΰ��� �޾� ���� ����� �Ҽ��� ���� �κи� ��ȯ�ϴ� 
--�Լ� ���� (ex: 10/4 -> 0.5 ��ȯ)
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


-- TODO: �Ű������� ���� �ΰ��� �޾Ƽ� ������ ������ ó���ϴ� �Լ� ����.  (10/4 -> 2�� ��ȯ)
-- ���������: --������ - (��� ������ * ����)
-- ex) 10/4�� ������ : 10 - (10/4������� * 4)

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


-- TODO: 1. �Ű������� ��� ID�� �޾Ƽ� �ڽ��� �޿��� �ڽ��� ���� �μ��� 
--��ձ޿� �̻��̸� TRUE�� �̸��̸� FALSE�� ��ȯ�ϴ� �Լ� �ۼ�. 
--��ȸ�� ����� ���� ��� NULL�� ��ȯ
--       2. ���� �Լ��� ȣ���ϴ� �͸� ���ν������� �ۼ�.
--			�Լ��� ȣ���Ͽ� ��ȯ�Ǵ� boolean ����
--				TRUE�̸� '������ �޿��� �μ���� �̻�' �� FALSE�̸� 
--  '������ �޿��� �μ���� �̸�' �� NULL�̸� '���� ����' �� ����Ѵ�.


CREATE OR REPLACE FUNCTION todo_03_fn(p_emp_id emp.emp_id%TYPE)
    RETURN boolean
IS
    v_cnt binary_integer; --���� ���� ���� 
    
    v_sal emp.salary%type; --���� �޿�
    v_dept_id emp.dept_id%type; -- ������ �μ�_id
    
	v_avg_sal emp.salary%type; -- �μ��� ��ձ޿�
	
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
    -- salary �� �μ� id�� ��ȸ
	select salary, dept_id
    into   v_sal, v_dept_id
    from   emp 
    where  emp_id = p_emp_id;
	-- �μ��� ��� �޿��� ��ȸ
	select avg(salary)
    into   v_avg_sal
    from   emp
    where dept_id = v_dept_id;
	-- ������ salary�� �μ� ��ձ޿��� ���ؼ� boolean ���� ��ȯ
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


-- 170(�̻�) 180(����) 
-- ------���� �Լ� ����ϴ� ���ν���. ---------
DECLARE
    v_result boolean;
BEGIN
   v_result := todo_03_fn(180); --NULL, T, F
   if v_result is null then
     dbms_output.put_line('���� ���� ID');
   elsif v_result then
     dbms_output.put_line('����̻�');
   else
     dbms_output.put_line('��� �̸�');
   end if;
   
END;
/
--Ȯ�� sql��
select salary from emp where emp_id = 170;
select avg(salary) from emp where dept_id = (select dept_id from emp where emp_id = 170);






--TODO �Ű������� 5���� 'y' �Ǵ� 'n'�� �޾Ƽ� ���° �Ű������� y������ �ϳ��� ���ڿ��� ��� ��ȯ�ϴ� �Լ� ����.
-- select todo_03_fn('y','n', 'n', 'y', 'y') from dual;  => '1, 4, 5'

create or replace function todo_04_fn (p_yn1 varchar2, 
                                       p_yn2 varchar2,
                                       p_yn3 varchar2,
                                       p_yn4 varchar2,
                                       p_yn5 varchar2) 
    return varchar2
is  
    v_return varchar2(100); -- ������� ���ڿ��� ������ ����.

begin  
    --p_yn1 ó��: y �̸� v_return ���ڿ��� ����.
    if  p_yn1 = 'y' then
--        v_return :='1';
        if nvl(length(v_return), 0) = 0 then
            v_return:='1';
        else
            v_return := v_return||'1';    
        end if;
    end if;	
    
    --p_yn2 ó��
    if  p_yn2 = 'y' then
        if nvl(length(v_return), 0) = 0 then
            v_return:='2';
        else
            v_return := v_return||', 2';    
        end if;
    end if;
	
     --p_yn3 ó��
    if  p_yn3 = 'y' then
        if nvl(length(v_return), 0) = 0 then
            v_return:='3';
        else
            v_return := v_return||', 3';    
        end if;
    end if;    
	
	
     --p_yn4 ó��
	 if  p_yn4 = 'y' then
        if nvl(length(v_return), 0) = 0 then
            v_return:='4';
        else
            v_return := v_return||', 4';    
        end if;
    end if;
	 
     --p_yn5 ó��
	 if  p_yn5 = 'y' then
        if nvl(length(v_return), 0) = 0 then
            v_return:='5';
        else
            v_return := v_return||', 5';    
        end if;
    end if;
    
    -- ����� ��ȯ
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

select todo_04_fn(ch1, ch2, ch3, ch4, ch5) ���û��� from choice_tb;



